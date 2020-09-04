     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited. 2009')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas SD Todays Credit Interest Posting List')
      *****************************************************************
      *                                                               *
      *  Midas - German Withholding Tax Module                        *
      *                                                               *
      *  SD200204 - Today's Credit Interest Postings                  *
      *                                                               *
      *  Function: This report lists today's interest posting         *
      *            activity related to Standing Data tables referring *
      *            primarily from Customer Incomes File and Customer  *
      *            Details by Country of Tax.                         *
      *                                                               *
      *  (c) Finastra International Limited. 2009                     *
      *                                                               *
      *  Last Amend No. MD046248           Date 05Feb18               *
      *  Prev Amend No. CDL099             Date 06Oct17               *
      *                 CER069             Date 03Jul14               *
      *                 CER059             Date 19Jul10               *
      *                 BUG26816           Date 08Dec09               *
      *                 BUG26730           Date 12Nov09               *
      *                 BUG25986           Date 11Sep09               *
      *                 BUG24966           Date 14Jul09               *
      *                 CER054  *CREATE    Date 07Apr09               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CDL099 - Split Value Date (Recompile)                        *
      *  CER069 - German Tax Enhancement                              *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG26816 - SDC200204 00001 Printer Overflow                  *
      *  BUG26730 - Recompiled due to changes in SD200204P1           *
      *  BUG25986 - SDC200204 00001 Printer Overflow                  *
      *  BUG24966 - SDC200204 00001 Printer Overflow                  *
      *  CER054 - German Features - Church Tax                        *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** Midas TA Swiss Installation Control Data
     FSDSTAXPD  IF   E             DISK    INFSR(*PSSR)
      *
      ** Midas DL Deals file
     FDEALS     IF   E           K DISK    INFSR(*PSSR)
     F                                     IGNORE(DEALSDBF)
     F                                     IGNORE(DEALSDDF)
     F                                     IGNORE(DEALSDEF)
     F                                     IGNORE(DEALSDGF)
     F                                     IGNORE(DEALSDFF)
      *
      ** Midas Today's Credit Interest Postings Audit
     FSD200204AUO    E             PRINTER USROPN
     F                                     INFSR(*PSSR)
     F                                     INFDS(SPOOLU)
      *
      ** Midas Today's Credit Interest Postings Report
     FSD200204P1O    E             PRINTER USROPN
     F                                     INFSR(*PSSR)
     F                                     INFDS(SPOOL1)
      *
      ** Midas Today's Credit Interest Postings Summary Report
     FSD200204P2O    E             PRINTER USROPN
     F                                     INFSR(*PSSR)
     F                                     INFDS(SPOOL2)
      *****************************************************************
     ** +--------------------------------------+
     ** ¦ Automatically included D-specs       ¦
     ** ¦ ==============================       ¦
     ** +--------------------------------------+
     **
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
     ***--------------------------------------------------------------------------------------------
      *****************************************************************
      /EJECT
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

      ** Array containing Copyright statement
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      *
      ** External DS for Customer Details
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      *
      ** External DS for Currency Details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      *
      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      ** External DS for Bank Details
     D SDCSIN        E DS                  EXTNAME(SDCSINPD)
      *
      ** Externally described DS for Country Details
     D SDACTX        E DS                  EXTNAME(SDACTXPD)
      *
      ** DS for access programs - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** DS for access programs - short data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
      ** Local data area for database error details
     D LDA           E DS           256    EXTNAME(LDA)
      *
      ** File Information Data Structure for SD200204P1
     D SPOOL1          DS
     D   SFile1               83     92
     D   SFNum1              123    124B 0
     D   OflLn1              188    189B 0
     D   PrtLn1              367    368B 0
      *
      ** File Information Data Structure for SD200204P2
     D SPOOL2          DS
     D   SFile2               83     92
     D   SFNum2              123    124B 0
     D   OflLn2              188    189B 0
     D   PrtLn2              367    368B 0
      *
      ** File Information Data Structure for SD200204AU
     D SPOOLU          DS
     D   SFileU               83     92
     D   SFNumU              123    124B 0

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
     D RUNDAT          S              8  0
     D WFirst          S              1
     D CPY2@           S             80
     D @SARD           S              6
      *
      ** Entry Parameters
     D SEQ             S              5
     D Wrun            S              1
      *
      ** Entry Parameters for AOCURRR0
     D WRtcd           S              7
     D WOptn           S              7
     D WKey1           S              3
      *
      ** Entry Parameters for AOCUSTR0
     D @RtCd           S              7
     D @Optn           S              7
     D @Key10          S             10
     D @KySt           S              7
      *
     D CER048          S              1
     D CER054          S              1
     D RqdLn1          S              3  0
     D DifLn1          S              3  0
     D RqdLn2          S              3  0
     D DifLn2          S              3  0
      *
      ** Parameters for ZSFILE
     D PSEnty          S              3
     D PZSNum          S              6  0
     D ZSNumU          S              6  0
     D ZSErr           S              1
      *
      ** ZSEDIT fields
     D ZFld15          S             15  0
     D PZDecs          S              1  0
     D PZeCode         S              1
     D ZOut21          S             21
      *
     D WWCust          S             10
     D WWNbDp          S              1  0
     D @@DAYN          S              5  0
      *
     C/COPY ZSRSRC,ZDATE9Z1LE
     C/COPY ZSRSRC,ZDATE9Z2LE

      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
      *
      ** Perform Initial Processing
      *
     C                   EXSR      SrInit
      *
      ** Read first record in file
      *
     C/EXEC SQL
     C+ FETCH FIRST FROM QRY_CSINJ0 INTO
     C+           :TSIPDT, :TSBRCA, :AXETXS, :TSCUST,
     C+           :TSDLLN, :TSOCCY, :TSACOD, :TSACSQ, :TSRLAF, :TSSTCD,
     C+           :TSGINT, :TSGINC, :TSTXSR, :TSTXSC,
     C+           :TSNINT, :TSNINC, :TSSTDO, :TSSTDT, :TSTTDO, :TSTTDT
     C/END-EXEC
      *
      ** SQL error trapping
     C/EXEC SQL
     C+ WHENEVER SQLERROR GOTO ERROR
     C/END-EXEC
      *
      ** If no record found print 'No details to report'
      *
     C                   IF        SQLCOD = 100
     C                   EXSR      SrAudit
     C                   ENDIF
      *
      ** Read until End of file
      *
     C                   DOW       SQLCOD = 0
      *
      ** First time
      *
     C                   IF        WFirst = 'Y'
     C                   EVAL      WFirst = 'N'
     C                   EXSR      SrBrCd
     C                   EXSR      SrSet
     C                   ENDIF
      *
     C                   EXSR      SrDetail
     C/EXEC SQL
     C+ FETCH NEXT FROM QRY_CSINJ0 INTO
     C+           :TSIPDT, :TSBRCA, :AXETXS, :TSCUST,
     C+           :TSDLLN, :TSOCCY, :TSACOD, :TSACSQ, :TSRLAF, :TSSTCD,
     C+           :TSGINT, :TSGINC, :TSTXSR, :TSTXSC,
     C+           :TSNINT, :TSNINC, :TSSTDO, :TSSTDT, :TSTTDO, :TSTTDT
     C/END-EXEC
      *
     C                   ENDDO
     C/EXEC SQL
     C+ CLOSE QRY_CSINJ0
     C/END-EXEC
      *
     C                   EXSR      SrFinal
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C     ERROR         TAG
     C                   EXSR      *PSSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrDetail - Subroutine to cumul the totaux and write details  *
      *                                                               *
      *  Called By - Main Processing                                  *
      *                                                               *
      *  Calls - SrCNum, SrCTax, SrWp1Sum, SrBrCd                     *
      *                                                               *
      *****************************************************************
     C     SrDetail      BEGSR
      *
      ** If the branch code has changed
      *
     C                   IF        TSBRCA <> ZRBRCD
     C                   EXSR      SrCNum
     C                   EXSR      SrCTax
     C                   EXSR      SrWp1Sum
     C                   EXSR      SrBrCd
     C                   EXSR      SrSet
     C                   ELSE
      *
      ** If the Tax Type has changed
      *
     C                   IF        AXETXS <> ZRCTAX
     C                   EXSR      SrCNum
     C                   EXSR      SrCTax
     C                   EXSR      SrSet
     C                   ELSE
      *
      ** If the Customer number has changed
      *
     C                   IF        TSCUST <> ZRCNUM
     C                   EXSR      SrCNum
     C                   EXSR      SrSet
     C                   END
     C                   END
     C                   END
      *
      ** Add Customer amounts to Customer totals
      *
     C                   ADD       TSGINC        Z1GIND
     C                   ADD       TSTXSC        Z1TXDD
     C                   ADD       TSNINC        Z1NIND
     C                   IF        CER048 = 'Y'
     C                   ADD       TSSTDT        Z1SOZD
     C                   ENDIF
      *
      ** Add Church Tax amounts to overall Totals for Summary per branch
      *
     C                   IF        CER054 = 'Y'
     C                   ADD       TSTTDT        Z1CHCD
     C                   ENDIF
      *
      ** Add Tax type amounts to Tax type totals
      *
     C                   ADD       TSGINC        Z2GIND
     C                   ADD       TSTXSC        Z2TXDD
     C                   ADD       TSNINC        Z2NIND
     C                   IF        CER048 = 'Y'
     C                   ADD       TSSTDT        Z2SOZD
     C                   ENDIF
      *
      ** Add Church Tax amounts to overall Totals for Summary per branch
      *
     C                   IF        CER054 = 'Y'
     C                   ADD       TSTTDT        Z2CHCD
     C                   ENDIF
      *
      ** Add Tax Type amounts to overall Totals for Summary per branch
      *
     C                   ADD       TSGINC        Z3GIND
     C                   ADD       TSTXSC        Z3TXDD
     C                   ADD       TSNINC        Z3NIND
     C                   IF        CER048 = 'Y'
     C                   ADD       TSSTDT        Z3SOZD
     C                   ENDIF
      *
      ** Add Church Tax amounts to overall Totals for Summary per branch
      *
     C                   IF        CER054 = 'Y'
     C                   ADD       TSTTDT        Z3CHCD
     C                   ENDIF
      *
      ** Add Tax type amounts to overall Totals for Summary Consolidated
      *
     C                   ADD       TSGINC        Z4GIND
     C                   ADD       TSTXSC        Z4TXDD
     C                   ADD       TSNINC        Z4NIND
     C                   IF        CER048 = 'Y'
     C                   ADD       TSSTDT        Z4SOZD
     C                   ENDIF
      *
      ** Add Church Tax amounts to overall Totals for Summary per branch
      *
     C                   IF        CER054 = 'Y'
     C                   ADD       TSTTDT        Z4CHCD
     C                   ENDIF
      *
      ** - Adjustment type
      *
     C                   EVAL      PRTYPE = *BLANKS
     C     TSDLLN        CHAIN     DEALS
     C                   IF        TAXI = 'T'
     C                   EVAL      PRTYPE = 'T'
     C                   ENDIF
     C                   IF        TAXI = 'Y'
     C                   EVAL      PRTYPE = 'Y'
     C                   ENDIF
     C                   IF        TAXI = 'N'
     C                   EVAL      PRTYPE = 'N'
     C                   ENDIF
     C                   IF        TAXI = 'A'                                                 CER069
     C                   EVAL      PRTYPE = 'A'                                               CER069
     C                   ENDIF                                                                CER069
     C                   IF        TSMODI = 'G'
     C                   EVAL      PRTYPE = 'S'
     C                   ENDIF
     C                   IF        TSMODI = 'M'
     C                   EVAL      PRTYPE = 'M'
     C                   ENDIF

      *
      ** Access currencies file for number of decimal places
      *
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       WRtCd
     C                   PARM      '*KEY   '     WOptn
     C                   PARM      TSOCCY        WKey1
     C     SDCURR        PARM      SDCURR        DSSDY
      *
     C                   IF        WRtCd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'SDCURRPD'
     C                   Z-ADD     006           DBase
     C                   EVAL      DBKey = TSOCCY
     C                   EVAL      DBPgm = 'SD200204'
     C                   EVAL      *INU7 = '1'
     C                   EVAL      *INU8 = '1'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   EVAL      PRCCY = TSOCCY
     C                   Z-ADD     A6NBDP        PZDecs
      *
      ** Format Gross Interest Amount
      *
     C                   EVAL      ZFld15 = TSGINT
     C                   EXSR      SrZSEdit
     C                   EVAL      PRGINC = ZOut21
      *
      ** Format Net Interest amount
      *
     C                   EVAL      ZFld15 = TSNINT
     C                   EXSR      SrZSEdit
     C                   EVAL      PRNINC = ZOut21
      *
      ** Format Tax Deducted Amount
      *
     C                   EVAL      ZFld15 = TSTXSR
     C                   EXSR      SrZSEdit
     C                   EVAL      PRTXDC = ZOut21
      *
      ** Format Solidarity Contribution amount
      *
     C                   IF        CER048 = 'Y'
     C                   EVAL      ZFld15 = TSSTDO
     C                   EXSR      SrZSEdit
     C                   EVAL      PRSOZC = ZOut21
     C                   ENDIF
      *
      ** Format Churh Tax amount
      *
     C                   IF        CER054 = 'Y'
     C                   EVAL      ZFld15 = TSTTDO
     C                   EXSR      SrZSEdit
     C                   EVAL      PRCHCC = ZOut21
     C                   ENDIF
      *
      ** Check that sufficient lines remain for the Format. If not,
      ** write out the Main Headings on a new page.
      *
     C                   IF        CER048 = 'Y'
      *
     C                   IF        TSOCCY = BJCYCD
     C                   Z-ADD     3             RqdLn1
     C                   ELSE
     C**********         Z-ADD     5             RqdLn1                                     BUG26816
     C                   Z-ADD     6             RqdLn1                                     BUG26816
     C                   ENDIF
      *
     C                   ELSE
     C                   IF        TSOCCY = BJCYCD
     C                   Z-ADD     2             RqdLn1
     C                   ELSE
     C                   Z-ADD     3             RqdLn1
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     OflLn1        SUB       PrtLn1        DifLn1
     C**********         IF        DifLn1 < RqdLn1                                          BUG24966
     C                   IF        DifLn1 <= RqdLn1                                         BUG24966
     C                   WRITE     FMTP101
     C                   ENDIF
      *
      ** Write Detail line
      *
     C                   EVAL      *IN51 = *OFF
     C                   IF        CER048 = 'Y' AND
     C                             TSOCCY <> BJCYCD
     C                   EVAL      *IN51 = *ON
     C                   ENDIF
      *
     C                   WRITE     FMTP102
      *
      ** If currency is not ICD currency output Base Ccy line
      *
     C                   IF        TSOCCY <> BJCYCD
      *
     C                   Z-ADD     WWNbDp        PZDecs
     C                   EVAL      ZFld15 = TSGINC
     C                   EXSR      SrZSEdit
     C                   EVAL      PRGIND = ZOut21
      *
     C                   EVAL      ZFld15 = TSTXSC
     C                   EXSR      SrZSEdit
     C                   EVAL      PRTXDD = ZOut21
      *
     C                   EVAL      ZFld15 = TSNINC
     C                   EXSR      SrZSEdit
     C                   EVAL      PRNIND = ZOut21
      *
      ** Format Churh Tax amount
      *
     C                   IF        CER054 = 'Y'
     C                   EVAL      ZFld15 = TSTTDT
     C                   EXSR      SrZSEdit
     C                   EVAL      PRCHCD = ZOut21
     C                   ENDIF
      *
     C                   IF        CER048 = 'Y'
     C                   EVAL      ZFld15 = TSSTDT
     C                   EXSR      SrZSEdit
     C                   EVAL      PRSOZD = ZOut21
     C                   ENDIF
      *
      ** Write Detail line in base currency
      *
     C                   WRITE     FMTP103
     C                   ENDIF
      *
      ** Initialise fields for next line
      *
     C                   EVAL      PRCTAX = *BLANKS
     C                   EVAL      PRCNUM = *BLANKS
     C                   EVAL      PRCNAM = *BLANKS
     C                   IF        CER054 = 'Y'
     C                   EVAL      PCONF = *BLANKS
     C                   EVAL      PBUND = *BLANKS
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrFinal - Subroutine to print the last record and the        *
      *            Consolidated Summary Report                        *
      *                                                               *
      *  Called By - Main Processing                                  *
      *                                                               *
      *  Calls - SrCNum, SrCTax, Wp1Sum, Wp2Sum                       *
      *                                                               *
      *****************************************************************
     C     SrFinal       BEGSR
      *
      ** Print the customer total, the tax type total and the branch's
      ** summary for the last record on the file
      *
     C                   EXSR      SrCNum
     C                   EXSR      SrCTax
     C                   EXSR      SrWp1Sum
      *
      ** Print the consolidated summary report
      *
     C                   EXSR      SrWp2Sum
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrCNum - Subroutine to print the Customer Totals             *
      *                                                               *
      *  Called By - SrDetail, SrFinal                                *
      *                                                               *
      *  Calls - None                                                 *
      *                                                               *
      *****************************************************************
     C     SrCNum        BEGSR
      *
      ** Set up fileds to print Customer Totals
      *
     C                   EVAL      ZFld15 = Z1GIND
     C                   EXSR      SrZSEdit
     C                   EVAL      PRGIND = ZOut21
      *
     C                   EVAL      ZFld15 = Z1TXDD
     C                   EXSR      SrZSEdit
     C                   EVAL      PRTXDD = ZOut21
      *
     C                   EVAL      ZFld15 = Z1NIND
     C                   EXSR      SrZSEdit
     C                   EVAL      PRNIND = ZOut21
      *
     C                   IF        CER048 = 'Y'
     C                   EVAL      ZFld15 = Z1SOZD
     C                   EXSR      SrZSEdit
     C                   EVAL      PRSOZD = ZOut21
     C                   ENDIF
      *
      ** Add Church Tax amounts to overall Totals for Summary per branch
      *
     C                   IF        CER054 = 'Y'
     C                   EVAL      ZFld15 = Z1CHCD
     C                   EXSR      SrZSEdit
     C                   EVAL      PRCHCD = ZOut21
     C                   ENDIF
      *
      ** Check that sufficient lines remain for the Format. If not,
      ** write out the Main Headings on a new page.
     C                   Z-ADD     4             RqdLn1
     C     OflLn1        SUB       PrtLn1        DifLn1
     C**********         IF        DifLn1 < RqdLn1                                          BUG24966
     C                   IF        DifLn1 <= RqdLn1                                         BUG24966
     C                   WRITE     FMTP101
     C                   ENDIF
      *
      ** Write Totals Customer
      *
     C                   WRITE     FMTP104
      *
      ** Set up the printer fields with the new details
      *
     C                   EVAL      WWCust = TSCUST
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       @RtCd
     C                   PARM      '*KEY   '     @Optn
     C                   PARM      WWCust        @Key10
     C                   PARM      *BLANKS       @KySt
     C     SDCUST        PARM      SDCUST        DSSDY
      *
     C                   IF        @RtCd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'SDCUSTPD'
     C**********         MOVE      5             DBase                                      BUG26816
     C                   Z-ADD     5             DBase                                      BUG26816
     C                   EVAL      DBKey = TSCUST
     C                   EVAL      DBPgm = 'SD200204'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   EVAL      PBUND = TSSTCD
     C                   EVAL      PCONF = TSRLAF
      *
     C                   EVAL      PRCNUM = TSCUST
     C                   EVAL      PRCNAM = BBCRNM
      *
      ** Initialise the customer Totals for the new customer
      *
     C                   Z-ADD     *ZERO         Z1GIND
     C                   Z-ADD     *ZERO         Z1NIND
     C                   Z-ADD     *ZERO         Z1TXDD
     C                   IF        CER048 = 'Y'
     C                   Z-ADD     *ZERO         Z1SOZD
     C                   ENDIF
      *
      ** Add Church Tax amounts to overall Totals for Summary per branch
      *
     C                   IF        CER054 = 'Y'
     C                   Z-ADD     *ZERO         Z1CHCD
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrCTax - Subroutine to print the Tax Type Totals             *
      *                                                               *
      *  Called By - SrDetail, SrFinal                                *
      *                                                               *
      *  Calls - None                                                 *
      *                                                               *
      *****************************************************************
     C     SrCTax        BEGSR
      *
      ** Set up fields to print Tax Type Total
      *
     C                   EVAL      ZFld15 = Z2GIND
     C                   EXSR      SrZSEdit
     C                   EVAL      PRGIND = ZOut21
      *
     C                   EVAL      ZFld15 = Z2TXDD
     C                   EXSR      SrZSEdit
     C                   EVAL      PRTXDD = ZOut21
      *
     C                   EVAL      ZFld15 = Z2NIND
     C                   EXSR      SrZSEdit
     C                   EVAL      PRNIND = ZOut21
      *
     C                   IF        CER048 = 'Y'
     C                   EVAL      ZFld15 = Z2SOZD
     C                   EXSR      SrZSEdit
     C                   EVAL      PRSOZD = ZOut21
     C                   ENDIF
      *
      ** Add Church Tax amounts to overall Totals for Summary per branch
      *
     C                   IF        CER054 = 'Y'
     C                   EVAL      ZFld15 = Z2CHCD
     C                   EXSR      SrZSEdit
     C                   EVAL      PRCHCD = ZOut21
     C                   ENDIF
      *
      ** Check that sufficient lines remain for the Format. If not,
      ** write out the Main Headings on a new page.
      *
     C                   Z-ADD     3             RqdLn1
     C     OflLn1        SUB       PrtLn1        DifLn1
     C**********         IF        DifLn1 < RqdLn1                                          BUG25986
     C                   IF        DifLn1 <= RqdLn1                                         BUG25986
     C                   WRITE     FMTP101
     C                   ENDIF
      *
      ** Write Totals Tax Type
     C                   WRITE     FMTP105
      *
      ** Store Totals according to Tax type for summary report
      *
     C                   IF        ZRCTAX = 'E '
     C                   ADD       Z2GIND        TTGIE
     C                   ADD       Z2NIND        TTNIE
     C                   ADD       Z2TXDD        TTTXE
     C                   IF        CER048 = 'Y'
     C                   ADD       Z2SOZD        TTSOE
     C                   IF        CER054 = 'Y'
     C                   ADD       Z2CHCD        TTCHE
     C                   ENDIF
     C                   ENDIF
     C                   END
      *
     C                   IF        ZRCTAX = 'D '
     C                   ADD       Z2GIND        TTGID
     C                   ADD       Z2NIND        TTNID
     C                   ADD       Z2TXDD        TTTXD
     C                   IF        CER048 = 'Y'
     C                   ADD       Z2SOZD        TTSOD
     C                   ENDIF
     C                   IF        CER054 = 'Y'
     C                   ADD       Z2CHCD        TTCHD
     C                   ENDIF
     C                   END
      *
     C                   IF        ZRCTAX = 'S '
     C                   ADD       Z2GIND        TTGIS
     C                   ADD       Z2NIND        TTNIS
     C                   ADD       Z2TXDD        TTTXS
     C                   IF        CER048 = 'Y'
     C                   ADD       Z2SOZD        TTSOS
     C                   ENDIF
     C                   IF        CER054 = 'Y'
     C                   ADD       Z2CHCD        TTCHS
     C                   ENDIF
     C                   END
      *
     C                   IF        ZRCTAX = 'T '
     C                   ADD       Z2GIND        TTGIT
     C                   ADD       Z2NIND        TTNIT
     C                   ADD       Z2TXDD        TTTXT
     C                   IF        CER048 = 'Y'
     C                   ADD       Z2SOZD        TTSOT
     C                   ENDIF
     C                   IF        CER054 = 'Y'
     C                   ADD       Z2CHCD        TTCHT
     C                   ENDIF
     C                   ENDIF
      *
      ** Initialise the Tax type Totals for new Tax type
      *
     C                   Z-ADD     *ZERO         Z2GIND
     C                   Z-ADD     *ZERO         Z2NIND
     C                   Z-ADD     *ZERO         Z2TXDD
     C                   IF        CER048 = 'Y'
     C                   Z-ADD     *ZERO         Z2SOZD
     C                   ENDIF
     C                   IF        CER054 = 'Y'
     C                   Z-ADD     *ZERO         Z2CHCD
     C                   ENDIF
      *
      ** Force a new page to be printed
      *
     C                   IF        SQLCOD = *ZERO AND
     C                             TSBRCA = ZRBRCD
     C                   WRITE     FMTP101
     C                   ENDIF
     C                   EVAL      PRCTAX = AXETXS
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrBrCd - Subroutine to process a change in branch            *
      *                                                               *
      *  Called By - Main Processing                                  *
      *                                                               *
      *  Calls - SrRCFP1                                              *
      *                                                               *
      *****************************************************************
     C     SrBrCd        BEGSR
      *
      ** Ensure Report Spool File recorded by RCF
      ** A report by branch and ALL branch must be printed
      *
     C                   EVAL      PSEnty = TSBRCA
     C                   EXSR      SrRCFP1
      *
      ** Retrieve the customer report name
      *
     C                   EVAL      WWCust = TSCUST
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       @RtCd
     C                   PARM      '*KEY   '     @Optn
     C                   PARM      WWCust        @Key10
     C                   PARM      *BLANKS       @KySt
     C     SDCUST        PARM      SDCUST        DSSDY
      *
     C                   IF        @RtCd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'SDCUSTPD'
     C**********         MOVE      4             DBase                                      BUG26816
     C                   Z-ADD     4             DBase                                      BUG26816
     C                   EVAL      DBKey = TSCUST
     C                   EVAL      DBPgm = 'SD200204'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      * Get Customer Confession code and State code
      *
     C                   EVAL      PBUND = TSSTCD
     C                   EVAL      PCONF = TSRLAF
      *
      ** Output report header
     C                   EVAL      PRBRCA = TSBRCA
     C                   EVAL      PRCTAX = AXETXS
     C                   EVAL      PRCNUM = TSCUST
     C                   EVAL      PRCNAM = BBCRNM
      *
     C                   WRITE     FMTP101
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrSet  - Subroutine to save fields to Zr fields              *
      *                                                               *
      *  Called by - Main Processing                                  *
      *                                                               *
      *  Calls - None                                                 *
      *                                                               *
      *****************************************************************
     C     SrSet         BEGSR
      *
     C                   EVAL      ZRBRCD = TSBRCA
     C                   EVAL      ZRCTAX = AXETXS
     C                   EVAL      ZRCNUM = TSCUST
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrWp1Sum - Subroutine to Write the summary per branch        *
      *                                                               *
      *  Called by - SrDetail, SrFinal                                *
      *                                                               *
      *  Calls - SrWp1Rec                                             *
      *                                                               *
      *****************************************************************
     C     SrWp1Sum      BEGSR
      *
      ** Write header of report
      *
     C                   WRITE     FMTP107
      *
      ** Format for each tax type the amounts and print the detail
      *
     C                   EVAL      PRCTAX = 'E '
     C                   MOVE      TTGIE         ZFld15
     C                   EXSR      SrZSEdit
     C                   MOVE      ZOut21        PRGIND
      *
     C                   MOVE      TTTXE         ZFld15
     C                   EXSR      SrZSEdit
     C                   MOVE      ZOut21        PRTXDD
      *
     C                   MOVE      TTNIE         ZFld15
     C                   EXSR      SrZSEdit
     C                   MOVE      ZOut21        PRNIND
      *
     C                   IF        CER048 = 'Y'
     C                   MOVE      TTSOE         ZFld15
     C                   EXSR      SrZSEdit
     C                   MOVE      ZOut21        PRSOZD
     C                   ENDIF
     C                   IF        CER054 = 'Y'
     C                   MOVE      TTCHE         ZFld15
     C                   EXSR      SrZSEdit
     C                   MOVE      ZOut21        PRCHCD
     C                   ENDIF
     C                   EXSR      SrWp1Rec
      *
     C                   EVAL      PRCTAX = 'D '
     C                   MOVE      TTGID         ZFld15
     C                   EXSR      SrZSEdit
     C                   MOVE      ZOut21        PRGIND
      *
     C                   MOVE      TTTXD         ZFld15
     C                   EXSR      SrZSEdit
     C                   MOVE      ZOut21        PRTXDD
      *
     C                   MOVE      TTNID         ZFld15
     C                   EXSR      SrZSEdit
     C                   MOVE      ZOut21        PRNIND
      *
     C                   IF        CER048 = 'Y'
     C                   MOVE      TTSOD         ZFld15
     C                   EXSR      SrZSEdit
     C                   MOVE      ZOut21        PRSOZD
     C                   ENDIF
     C                   IF        CER054 = 'Y'
     C                   MOVE      TTCHD         ZFld15
     C                   EXSR      SrZSEdit
     C                   MOVE      ZOut21        PRCHCD
     C                   ENDIF
     C                   EXSR      SrWp1Rec
      *
     C                   EVAL      PRCTAX = 'S '
     C                   MOVE      TTGIS         ZFld15
     C                   EXSR      SrZSEdit
     C                   MOVE      ZOut21        PRGIND
      *
     C                   MOVE      TTTXS         ZFld15
     C                   EXSR      SrZSEdit
     C                   MOVE      ZOut21        PRTXDD
      *
     C                   MOVE      TTNIS         ZFld15
     C                   EXSR      SrZSEdit
     C                   MOVE      ZOut21        PRNIND
      *
     C                   IF        CER048 = 'Y'
     C                   MOVE      TTSOS         ZFld15
     C                   EXSR      SrZSEdit
     C                   MOVE      ZOut21        PRSOZD
     C                   ENDIF
     C                   IF        CER054 = 'Y'
     C                   MOVE      TTCHS         ZFld15
     C                   EXSR      SrZSEdit
     C                   MOVE      ZOut21        PRCHCD
     C                   ENDIF
     C                   EXSR      SrWp1Rec
      *
     C                   EVAL      PRCTAX = 'T '
     C                   MOVE      TTGIT         ZFld15
     C                   EXSR      SrZSEdit
     C                   MOVE      ZOut21        PRGIND
      *
     C                   MOVE      TTTXT         ZFld15
     C                   EXSR      SrZSEdit
     C                   MOVE      ZOut21        PRTXDD
      *
     C                   MOVE      TTNIT         ZFld15
     C                   EXSR      SrZSEdit
     C                   MOVE      ZOut21        PRNIND
      *
     C                   IF        CER048 = 'Y'
     C                   MOVE      TTSOT         ZFld15
     C                   EXSR      SrZSEdit
     C                   MOVE      ZOut21        PRSOZD
     C                   ENDIF
     C                   IF        CER054 = 'Y'
     C                   MOVE      TTCHT         ZFld15
     C                   EXSR      SrZSEdit
     C                   MOVE      ZOut21        PRCHCD
     C                   ENDIF
     C                   EXSR      SrWp1Rec
      *
      ** Write overall summary totals
      *
     C                   MOVE      Z3GIND        ZFld15
     C                   EXSR      SrZSEdit
     C                   MOVE      ZOut21        PRGIND
      *
     C                   MOVE      Z3TXDD        ZFld15
     C                   EXSR      SrZSEdit
     C                   MOVE      ZOut21        PRTXDD
      *
     C                   MOVE      Z3NIND        ZFld15
     C                   EXSR      SrZSEdit
     C                   MOVE      ZOut21        PRNIND
      *
     C                   IF        CER048 = 'Y'
     C                   MOVE      Z3SOZD        ZFld15
     C                   EXSR      SrZSEdit
     C                   MOVE      ZOut21        PRSOZD
     C                   ENDIF
      *
     C                   IF        CER054 = 'Y'
     C                   MOVE      Z3CHCD        ZFld15
     C                   EXSR      SrZSEdit
     C                   MOVE      ZOut21        PRCHCD
     C                   ENDIF
      *
      ** Check that sufficient lines remain for the Format. If not,
      ** write out the Main Headings on a new page.
      *
     C                   Z-ADD     3             RqdLn1
     C     OflLn1        SUB       PrtLn1        DifLn1
     C                   IF        DifLn1 < RqdLn1
     C                   WRITE     FMTP107
     C                   ENDIF
     C                   WRITE     FMTP109
      *
      ** Write end of report
      ** Check that sufficient lines remain for the Format. If not,
      ** write out the Main Headings on a new page.
      *
     C                   Z-ADD     4             RqdLn1
     C     OflLn1        SUB       PrtLn1        DifLn1
     C                   IF        DifLn1 < RqdLn1
     C                   WRITE     FMTP107
     C                   ENDIF
     C                   WRITE     FMTP106
      *
     C                   CLOSE     SD200204P1
      *
      ** Store totals according tax type for consolidated report
      *
     C                   ADD       TTGIT         TCGIT
     C                   ADD       TTGID         TCGID
     C                   ADD       TTGIS         TCGIS
     C                   ADD       TTGIE         TCGIE
      *
     C                   ADD       TTTXT         TCTXT
     C                   ADD       TTTXD         TCTXD
     C                   ADD       TTTXS         TCTXS
     C                   ADD       TTTXE         TCTXE
      *
     C                   ADD       TTNIT         TCNIT
     C                   ADD       TTNID         TCNID
     C                   ADD       TTNIS         TCNIS
     C                   ADD       TTNIE         TCNIE
      *
     C                   IF        CER048 = 'Y'
     C                   ADD       TTSOT         TCSOT
     C                   ADD       TTSOD         TCSOD
     C                   ADD       TTSOS         TCSOS
     C                   ADD       TTSOE         TCSOE
     C                   ENDIF
      *
     C                   IF        CER054 = 'Y'
     C                   ADD       TTCHT         TCCHT
     C                   ADD       TTCHD         TCCHD
     C                   ADD       TTCHS         TCCHS
     C                   ADD       TTCHE         TCCHE
     C                   ENDIF
      *
      ** Initialise Summary Totals
      *
     C                   Z-ADD     *ZERO         Z3GIND
     C                   Z-ADD     *ZERO         TTGIT
     C                   Z-ADD     *ZERO         TTGID
     C                   Z-ADD     *ZERO         TTGIS
     C                   Z-ADD     *ZERO         TTGIE
      *
     C                   Z-ADD     *ZERO         Z3TXDD
     C                   Z-ADD     *ZERO         TTTXT
     C                   Z-ADD     *ZERO         TTTXD
     C                   Z-ADD     *ZERO         TTTXS
     C                   Z-ADD     *ZERO         TTTXE
      *
     C                   Z-ADD     *ZERO         Z3NIND
     C                   Z-ADD     *ZERO         TTNIT
     C                   Z-ADD     *ZERO         TTNID
     C                   Z-ADD     *ZERO         TTNIS
     C                   Z-ADD     *ZERO         TTNIE
      *
     C                   IF        CER048 = 'Y'
     C                   Z-ADD     *ZERO         Z3SOZD
     C                   Z-ADD     *ZERO         TTSOT
     C                   Z-ADD     *ZERO         TTSOD
     C                   Z-ADD     *ZERO         TTSOS
     C                   Z-ADD     *ZERO         TTSOE
     C                   ENDIF
      *
     C                   IF        CER054 = 'Y'
     C                   Z-ADD     *ZERO         Z3CHCD
     C                   Z-ADD     *ZERO         TTCHT
     C                   Z-ADD     *ZERO         TTCHD
     C                   Z-ADD     *ZERO         TTCHS
     C                   Z-ADD     *ZERO         TTCHE
     C                   ENDIF
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrWp1Rec - Subroutine to Write a Detail record to the Report *
      *                                                               *
      *  Called By - SrWp1Sum                                         *
      *                                                               *
      *  Calls - None                                                 *
      *                                                               *
      *****************************************************************
     C     SrWp1Rec      BEGSR
      *
      ***  Check that sufficient lines remain for the Format. If not,
      ***  write out the Main Headings on a new page.
      *
     C                   Z-ADD     1             RqdLn1
     C     OflLn1        SUB       PrtLn1        DifLn1
     C                   IF        DifLn1 < RqdLn1
     C                   WRITE     FMTP107
     C                   ENDIF
      *
      ***  Write out Detail Record.
      *
     C                   WRITE     FMTP108
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrWp2Sum - Subroutine to Write the summary consolidated      *
      *                                                               *
      *  Called by - SrFinal                                          *
      *                                                               *
      *  Calls - SrRCFP2                                              *
      *****************************************************************
     C     SrWp2Sum      BEGSR
      *
      ** Register the P2 printer file via RCF
      *
     C                   EXSR      SrRCFP2
      *
      ** Write header of report
      *
     C                   WRITE     FMTP201
      *
      ** Format for each tax type the amounts and print the detail
      *
     C                   EVAL      PRCTAX = 'E '
     C                   MOVE      TCGIE         ZFld15
     C                   EXSR      SrZSEdit
     C                   MOVE      ZOut21        PRGIND
      *
     C                   MOVE      TCTXE         ZFld15
     C                   EXSR      SrZSEdit
     C                   MOVE      ZOut21        PRTXDD
      *
     C                   MOVE      TCNIE         ZFld15
     C                   EXSR      SrZSEdit
     C                   MOVE      ZOut21        PRNIND
      *
     C                   IF        CER048 = 'Y'
     C                   MOVE      TCSOE         ZFld15
     C                   EXSR      SrZSEdit
     C                   MOVE      ZOut21        PRSOZD
     C                   ENDIF
      *
     C                   IF        CER054 = 'Y'
     C                   MOVE      TCCHE         ZFld15
     C                   EXSR      SrZSEdit
     C                   MOVE      ZOut21        PRCHCD
     C                   ENDIF
     C                   EXSR      SrWp2Rec
      *
     C                   EVAL      PRCTAX = 'D '
     C                   MOVE      TCGID         ZFld15
     C                   EXSR      SrZSEdit
     C                   MOVE      ZOut21        PRGIND
      *
     C                   MOVE      TCTXD         ZFld15
     C                   EXSR      SrZSEdit
     C                   MOVE      ZOut21        PRTXDD
      *
     C                   MOVE      TCNID         ZFld15
     C                   EXSR      SrZSEdit
     C                   MOVE      ZOut21        PRNIND
      *
     C                   IF        CER048 = 'Y'
     C                   MOVE      TCSOD         ZFld15
     C                   EXSR      SrZSEdit
     C                   MOVE      ZOut21        PRSOZD
     C                   ENDIF
      *
     C                   IF        CER054 = 'Y'
     C                   MOVE      TCCHD         ZFld15
     C                   EXSR      SrZSEdit
     C                   MOVE      ZOut21        PRCHCD
     C                   ENDIF
     C                   EXSR      SrWp2Rec
      *
     C                   EVAL      PRCTAX = 'S '
     C                   MOVE      TCGIS         ZFld15
     C                   EXSR      SrZSEdit
     C                   MOVE      ZOut21        PRGIND
      *
     C                   MOVE      TCTXS         ZFld15
     C                   EXSR      SrZSEdit
     C                   MOVE      ZOut21        PRTXDD
      *
     C                   MOVE      TCNIS         ZFld15
     C                   EXSR      SrZSEdit
     C                   MOVE      ZOut21        PRNIND
      *
     C                   IF        CER048 = 'Y'
     C                   MOVE      TCSOS         ZFld15
     C                   EXSR      SrZSEdit
     C                   MOVE      ZOut21        PRSOZD
     C                   ENDIF
      *
     C                   IF        CER054 = 'Y'
     C                   MOVE      TCCHS         ZFld15
     C                   EXSR      SrZSEdit
     C                   MOVE      ZOut21        PRCHCD
     C                   ENDIF
     C                   EXSR      SrWp2Rec
      *
     C                   EVAL      PRCTAX = 'T '
     C                   MOVE      TCGIT         ZFld15
     C                   EXSR      SrZSEdit
     C                   MOVE      ZOut21        PRGIND
      *
     C                   MOVE      TCTXT         ZFld15
     C                   EXSR      SrZSEdit
     C                   MOVE      ZOut21        PRTXDD
      *
     C                   MOVE      TCNIT         ZFld15
     C                   EXSR      SrZSEdit
     C                   MOVE      ZOut21        PRNIND
      *
     C                   IF        CER048 = 'Y'
     C                   MOVE      TCSOT         ZFld15
     C                   EXSR      SrZSEdit
     C                   MOVE      ZOut21        PRSOZD
     C                   ENDIF
      *
     C                   IF        CER054 = 'Y'
     C                   MOVE      TCCHT         ZFld15
     C                   EXSR      SrZSEdit
     C                   MOVE      ZOut21        PRCHCD
     C                   ENDIF
     C                   EXSR      SrWp2Rec
      *
      ** Write overall summary totals
      *
     C                   MOVE      Z4GIND        ZFld15
     C                   EXSR      SrZSEdit
     C                   MOVE      ZOut21        PRGIND
      *
     C                   MOVE      Z4TXDD        ZFld15
     C                   EXSR      SrZSEdit
     C                   MOVE      ZOut21        PRTXDD
      *
     C                   MOVE      Z4NIND        ZFld15
     C                   EXSR      SrZSEdit
     C                   MOVE      ZOut21        PRNIND
      *
     C                   IF        CER048 = 'Y'
     C                   MOVE      Z4SOZD        ZFld15
     C                   EXSR      SrZSEdit
     C                   MOVE      ZOut21        PRSOZD
     C                   ENDIF
      *
     C                   IF        CER054 = 'Y'
     C                   MOVE      Z4CHCD        ZFld15
     C                   EXSR      SrZSEdit
     C                   MOVE      ZOut21        PRCHCD
     C                   ENDIF
      *
      ** Check that sufficient lines remain for the Format. If not,
      ** write out the Main Headings on a new page.
      *
     C                   Z-ADD     3             RqdLn2
     C     OflLn2        SUB       PRTLN2        DifLn2
     C                   IF        DifLn2 < RqdLn2
     C                   WRITE     FMTP201
     C                   ENDIF
     C                   WRITE     FMTP203
      *
      ** Write end of report
      ** Check that sufficient lines remain for the Format. If not,
      ** write out the Main Headings on a new page.
      *
     C                   Z-ADD     4             RqdLn2
     C     OflLn2        SUB       PRTLN2        DifLn2
     C                   IF        DifLn2 < RqdLn2
     C                   WRITE     FMTP201
     C                   ENDIF
     C                   WRITE     FMTP204
      *
     C                   CLOSE     SD200204P2
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrWp2Rec - Subroutine to Write a Detail record to the Report *
      *                                                               *
      *  Called by - SrWp2Sum                                         *
      *                                                               *
      *  Calls - None                                                 *
      *                                                               *
      *****************************************************************
     C     SrWp2Rec      BEGSR
      *
      ** Check that sufficient lines remain for the Format. If not,
      ** write out the Main Headings on a new page.
      *
     C                   Z-ADD     1             RqdLn2
     C     OflLn2        SUB       PRTLN2        DifLn2
     C                   IF        DifLn2 < RqdLn2
     C                   WRITE     FMTP201
     C                   ENDIF
      *
      ** Write out Detail Record.
      *
     C                   WRITE     FMTP202
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrAudit - Subroutine to Output Audit report and End Program  *
      *                                                               *
      *  Called by - Main                                             *
      *                                                               *
      *  Calls - SrRCFAU                                              *
      *                                                               *
      *****************************************************************
     C     SrAudit       BEGSR
      *
      ***  RCF Processing
      *
     C                   OPEN      SD200204AU
     C                   EXSR      SrRCFAU
      *
      ** If there is a DB Error, Output the DB Error Information.
      *
     C                   IF        *INU7 = *ON OR
     C                             *INU8 = *ON
     C                   WRITE     HEADAU
     C                   WRITE     DBERROR
     C                   ELSE
      *
      ** Or, if no records read, Output "No Details" message.
      *
     C                   WRITE     HEADAU
     C                   WRITE     NODTLS
     C                   ENDIF
      *
      ** End Program and Return.
      *
     C                   CLOSE     SD200204AU
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrRCFP1 - Subroutine to register the P1 Printer File via RCF *
      *                                                               *
      *  Called by - SrBrCd                                           *
      *                                                               *
      *  Calls - None                                                 *
      *                                                               *
      *****************************************************************
     C     SrRCFP1       BEGSR
      *
     C                   OPEN      SD200204P1
      *
      ** Ensure Report Spool File recorded by RCF.
      *
     C                   Z-ADD     SFNum1        PZSNum
      *
     C                   CALL      'ZSFILE'
     C                   PARM                    SEQ
     C                   PARM      *BLANKS       PSEnty
     C                   PARM                    SFile1
     C                   PARM                    PZSNum
     C                   PARM      *BLANKS       ZSErr
      *
      ** If Error occurs during ZSFILE processing, then return to the
      ** Calling Program.
      *
     C                   IF        ZSErr = 'Y'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrRCFP2 - Subroutine to register the P2 Printer File via RCF *
      *                                                               *
      *  Called by - SrWp2Sum                                         *
      *                                                               *
      *  Calls - None                                                 *
      *                                                               *
      *****************************************************************
     C     SrRCFP2       BEGSR
      *
     C                   OPEN      SD200204P2
      *
      ** Ensure Report Spool File recorded by RCF.
      *
     C                   Z-ADD     SFNum2        PZSNum
      *
     C                   CALL      'ZSFILE'
     C                   PARM                    SEQ
     C                   PARM      *BLANKS       PSEnty
     C                   PARM                    SFile2
     C                   PARM                    PZSNum
     C                   PARM      *BLANKS       ZSErr
      *
      ** If Error occurs during ZSFILE processing, then return to the
      ** Calling Program.
      *
     C                   IF        ZSErr = 'Y'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrRCFAU - Subroutine to register the AU Printer File via RCF *
      *                                                               *
      *  Called by - SrAudit                                          *
      *                                                               *
      *  Calls - None                                                 *
      *                                                               *
      *****************************************************************
     C     SrRCFAU       BEGSR
      *
      ** Ensure Audit Spool File recorded by RCF.
      *
     C                   Z-ADD     SFNumU        ZSNumU
      *
     C                   CALL      'ZSFILE'
     C                   PARM                    SEQ
     C                   PARM      *BLANKS       PSEnty
     C                   PARM                    SFileU
     C                   PARM                    ZSNumU
     C                   PARM      *BLANKS       ZSErr
      *
      ** If Error occurs during ZSFILE processing, then return to the
      ** Calling Program.
      *
     C                   IF        ZSErr = 'Y'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR  - Error control subroutine                            *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
      *
      ** Check to see that *PSSR has not already been called.
      *
     C                   IF        WRun = *BLANKS
     C                   MOVE      'Y'           WRun
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   DUMP
     C                   EXSR      SrAudit
     C                   ENDIF
      *
      ** If *PSSR already run, then just end the program here.
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrZSEdit - Convert amount from file format to screen format  *
      *                                                               *
      *  Called by -                                                  *
      *                                                               *
      *  Calls - None                                                 *
      *                                                               *
      *****************************************************************
     C     SrZSEdit      BEGSR
      *
     C                   CALL      'ZSEDIT'
     C                   PARM                    ZFld15
     C                   PARM                    PZDecs
     C                   PARM      'L'           PZeCode
      ** Output
     C                   PARM                    ZOut21
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrInit - Initialisation                                      *
      *                                                               *
      *  Called by - Main Processing                                  *
      *                                                               *
      *  Calls - None                                                 *
      *                                                               *
      *****************************************************************
     C     SrInit        BEGSR
      *
      ** Set up copyright parameter
     C                   MOVEA     CPY@          CPY2@
      *
      ** Initialise LDA field.
      *
     C     *DTAARA       DEFINE                  LDA

     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   OUT       LDA
      *
      ** Check if CER048 is enabled
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RtCd
     C                   PARM      '*VERIFY'     @Optn
     C                   PARM      'CER048'      @SARD
     C                   PARM                    DSFDY
      *
     C                   IF        @RtCd = *BLANKS
     C                   MOVE      'Y'           CER048
     C                   EVAL      *IN50 = *ON
     C                   ENDIF
      *
      ** Check if CER054 is enabled
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RtCd
     C                   PARM      '*VERIFY'     @Optn
     C                   PARM      'CER054'      @SARD
     C                   PARM                    DSFDY
      *
     C                   IF        @RtCd = *BLANKS
     C                   MOVE      'Y'           CER054
     C                   EVAL      *IN52 = *ON
     C                   ENDIF
      *
      **  Call Access Program for Bank Details - Title, Run Date and
      **  Run Day Number.
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      '*MSG   '     WRtCd
     C                   PARM      '*FIRST '     WOptn
     C     SDBANK        PARM      SDBANK        DSFDY
      *
     C                   IF        WRtCd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'SDBANKPD'
     C                   Z-ADD     001           DBase
     C                   EVAL      DBKey = *BLANKS
     C                   EVAL      DBPgm = 'SD200204'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      **  Check System Date Format, DDMMYY (*IN98 off)
      **                            MMDDYY (*IN98 on).
      *
     C                   IF        BJDFIN = 'M'
     C                   EVAL      *IN98 = *ON
     C                   ENDIF
      *
      * Convert date to YYYYMMDD format
      *
     C                   MOVE      BJRDNB        @@DAYN
     C                   EXSR      ZDATE9
     C                   MOVEL     @@VDT         RUNDAT
      *
      ** Report Work fields.
      *
     C                   Z-ADD     0             RqdLn1
     C                   Z-ADD     0             DifLn1
     C                   Z-ADD     0             RqdLn2
     C                   Z-ADD     0             DifLn2
     C                   MOVE      'Y'           WFirst
      *
      ** Access Swiss Installation Control Data
      *
     C     1             CHAIN     SDSTAXPD
     C                   IF        NOT %FOUND(SDSTAXPD)
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'SDSTAXPD'
     C                   Z-ADD     002           DBase
     C                   EVAL      DBKey = *BLANKS
     C                   EVAL      DBPgm = 'SD200204'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ***  Call Access Program for Currency details
      *
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       WRtCd
     C                   PARM      '*KEY   '     WOptn
     C                   PARM      BJCYCD        WKey1
     C     SDCURR        PARM      SDCURR        DSSDY
      *
     C                   IF        WRtCd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'SDCURRPD'
     C                   Z-ADD     003           DBase
     C                   EVAL      DBKey = BJCYCD
     C                   EVAL      DBPgm = 'SD200204'
     C                   EVAL      *INU7 = '1'
     C                   EVAL      *INU8 = '1'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   Z-ADD     A6NBDP        WWNbDp
      *
      *** Save fields
      *
     C     *LIKE         DEFINE    TSBRCA        ZRBRCD
     C     *LIKE         DEFINE    AXETXS        ZRCTAX
     C     *LIKE         DEFINE    TSCUST        ZRCNUM
      *
      ** Gross interest totals
      *
     C     *LIKE         DEFINE    TSGINC        Z1GIND          + 1
     C     *LIKE         DEFINE    Z1GIND        Z2GIND          + 1
     C     *LIKE         DEFINE    Z2GIND        Z3GIND          + 1
     C     *LIKE         DEFINE    Z3GIND        Z4GIND          + 1
     C     *LIKE         DEFINE    TSGINC        TTGIE           + 1
     C     *LIKE         DEFINE    TSGINC        TTGID           + 1
     C     *LIKE         DEFINE    TSGINC        TTGIS           + 1
     C     *LIKE         DEFINE    TSGINC        TTGIT           + 1
     C     *LIKE         DEFINE    TSGINC        TCGIE           + 1
     C     *LIKE         DEFINE    TSGINC        TCGID           + 1
     C     *LIKE         DEFINE    TSGINC        TCGIS           + 1
     C     *LIKE         DEFINE    TSGINC        TCGIT           + 1
      *
      ** Net interest totals
      *
     C     *LIKE         DEFINE    TSNINC        Z1NIND          + 1
     C     *LIKE         DEFINE    Z1GIND        Z2NIND          + 1
     C     *LIKE         DEFINE    Z2GIND        Z3NIND          + 1
     C     *LIKE         DEFINE    Z3GIND        Z4NIND          + 1
     C     *LIKE         DEFINE    TSNINC        TTNIE           + 1
     C     *LIKE         DEFINE    TSNINC        TTNID           + 1
     C     *LIKE         DEFINE    TSNINC        TTNIS           + 1
     C     *LIKE         DEFINE    TSNINC        TTNIT           + 1
     C     *LIKE         DEFINE    TSNINC        TCNIE           + 1
     C     *LIKE         DEFINE    TSNINC        TCNID           + 1
     C     *LIKE         DEFINE    TSNINC        TCNIS           + 1
     C     *LIKE         DEFINE    TSNINC        TCNIT           + 1
      *
      ** Tax deducted totals
      *
     C     *LIKE         DEFINE    TSTXSC        Z1TXDD          + 1
     C     *LIKE         DEFINE    Z1TXDD        Z2TXDD          + 1
     C     *LIKE         DEFINE    Z2TXDD        Z3TXDD          + 1
     C     *LIKE         DEFINE    Z3TXDD        Z4TXDD          + 1
     C     *LIKE         DEFINE    TSTXSC        TTTXE           + 1
     C     *LIKE         DEFINE    TSTXSC        TTTXD           + 1
     C     *LIKE         DEFINE    TSTXSC        TTTXS           + 1
     C     *LIKE         DEFINE    TSTXSC        TTTXT           + 1
     C     *LIKE         DEFINE    TSTXSC        TCTXE           + 1
     C     *LIKE         DEFINE    TSTXSC        TCTXD           + 1
     C     *LIKE         DEFINE    TSTXSC        TCTXS           + 1
     C     *LIKE         DEFINE    TSTXSC        TCTXT           + 1
      *
      ** Solidaritaetszuschlag totals
      *
     C                   IF        CER048 = 'Y'
     C     *LIKE         DEFINE    TSSTDT        Z1SOZD          + 1
     C     *LIKE         DEFINE    Z1SOZD        Z2SOZD          + 1
     C     *LIKE         DEFINE    Z2SOZD        Z3SOZD          + 1
     C     *LIKE         DEFINE    Z3SOZD        Z4SOZD          + 1
     C     *LIKE         DEFINE    TSSTDT        TTSOE           + 1
     C     *LIKE         DEFINE    TSSTDT        TTSOD           + 1
     C     *LIKE         DEFINE    TSSTDT        TTSOS           + 1
     C     *LIKE         DEFINE    TSSTDT        TTSOT           + 1
     C     *LIKE         DEFINE    TSSTDT        TCSOE           + 1
     C     *LIKE         DEFINE    TSSTDT        TCSOD           + 1
     C     *LIKE         DEFINE    TSSTDT        TCSOS           + 1
     C     *LIKE         DEFINE    TSSTDT        TCSOT           + 1
     C                   ENDIF
      *
      ** Church tax totals
      *
     C                   IF        CER054 = 'Y'
     C     *LIKE         DEFINE    TSTTDT        Z1CHCD          + 1
     C     *LIKE         DEFINE    Z1CHCD        Z2CHCD          + 1
     C     *LIKE         DEFINE    Z2CHCD        Z3CHCD          + 1
     C     *LIKE         DEFINE    Z3CHCD        Z4CHCD          + 1
     C     *LIKE         DEFINE    TSTTDT        TTCHE           + 1
     C     *LIKE         DEFINE    TSTTDT        TTCHD           + 1
     C     *LIKE         DEFINE    TSTTDT        TTCHS           + 1
     C     *LIKE         DEFINE    TSTTDT        TTCHT           + 1
     C     *LIKE         DEFINE    TSTTDT        TCCHE           + 1
     C     *LIKE         DEFINE    TSTTDT        TCCHD           + 1
     C     *LIKE         DEFINE    TSTTDT        TCCHS           + 1
     C     *LIKE         DEFINE    TSTTDT        TCCHT           + 1
     C                   ENDIF
     C
     C/EXEC SQL
     C+ DECLARE QRY_CSINJ0 SCROLL CURSOR
     C+   FOR SELECT TSIPDT, TSBRCA, AXETXS, TSCUST,
     C+              TSDLLN, TSOCCY, TSACOD, TSACSQ, TSRLAF, TSSTCD,
     C+              TSGINT, TSGINC, TSTXSR, TSTXSC,
     C+              TSNINT, TSNINC, TSSTDO, TSSTDT, TSTTDO, TSTTDT
     C+       FROM SDCSINPD JOIN SDACTXPD
     C+       ON TSCUST = AXCUST AND TSCTRT = AXCTTX
     C+       WHERE TSIPDT = :RUNDAT
     C+       ORDER BY TSIPDT, TSBRCA, AXETXS, TSCUST
     C/END-EXEC

     C/EXEC SQL
     C+ OPEN QRY_CSINJ0
     C/END-EXEC
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Initial Processing
      *****************************************************************
     C     *INZSR        BEGSR

     C     *ENTRY        PLIST
     C                   PARM                    SEQ
     C                   ENDSR
      *****************************************************************
     C/COPY ZSRSRC,ZDATE9Z3LE
      *****************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2009
** @YD  USED BY SR. ZDATE9 - YEARS, IN DAYS, CUMULATIVE IN 4 YEAR SPAN
00366007310109601461
** @MD  USED BY SR. ZDATE9 - MONTHS IN DAYS CUMULATIVE THROUGH YEAR
00000000310005900090001200015100181002120024300273003040033400365
