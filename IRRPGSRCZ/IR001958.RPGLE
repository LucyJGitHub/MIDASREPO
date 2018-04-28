     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas IR Cross CCY Revaluation Base Rate Report')      *
      *****************************************************************
      *                                                               *
      *  Midas - FRA/IRS Module                                       *
      *                                                               *
      *  IR001958 - Cross Currency IRS Reval Base Rate Report       *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2004            *
      *                                                               *
      *  Last Amend No. CDL096             Date 22Sep14               *
      *  Prev Amend No. CDL094             Date 11Jun14               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CDL038             Date 10May05               *
      *                 CAS010             Date 09Feb05               *
      *                 CAS008  *CREATE    Date 16Jun04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CDL094 - Enhance  Receive Settlement Instructions            *
      *           (Recompiled)                                        *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  CAS010 - IAS + PB Enhancements Upgrade to Midasplus          *
      *  CAS008 - IAS 39 Enhancements                                 *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Midas IR Cross Ccy IRS Cash Flows File
     FRXCFLAL0  IF   E           K DISK    INFSR(*PSSR)
 
      ** Midas DL Deals file
     FDEALS     IF   E           K DISK    INFSR(*PSSR)
     F                                     IGNORE(DEALSDAF)
     F                                     IGNORE(DEALSDBF)
     F                                     IGNORE(DEALSDCF)
     F                                     IGNORE(DEALSDDF)
     F                                     IGNORE(DEALSDEF)
     F                                     IGNORE(DEALSDFF)
 
      ** Midas Adjusted Amount File
     FRXNPVBL0  IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(NP_)
 
      ** Cross Currency IRS Revaluation Base Rate Summary Report
     FIR001958P1O    E             PRINTER USROPN
     F                                     INFSR(*PSSR)
     F                                     INFDS(SPOOL1)
 
      ** Cross Currency IRS Revaluation Base Rate Detail Report
     FIR001958P2O    E             PRINTER USROPN
     F                                     INFSR(*PSSR)
     F                                     INFDS(SPOOL2)
 
      ** Cross Currency IRS Revaluation Base Rate Audit Report
     FIR001958AUO    E             PRINTER INFSR(*PSSR)
     F                                     INFDS(SPOOLU)
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
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
 
      ** Externally described DS for bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** External data structure for General Ledger ICD Details
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
 
      ** Externally described DS for branch details
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
 
      ** Externally described DS for Customer details
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      ** External DS for Customer Details                                                     CAS010
     D  QQDFA1       E                     EXTFLD(QQDFAC)                                     CAS010
 
      ** Externally described DS for currency details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      ** Externally described DS for Book Code details
     D SDBKCD        E DS                  EXTNAME(SDBOOKPD)
 
      ** DS for access programs - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** DS for access programs - long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** File Information Data Structure for IR001958P1
     D SPOOL1          DS
     D  PSFile1               83     92
     D  PSFNum1              123    124B 0
     D  OflLn1               188    189B 0
     D  PrtLn1               367    368B 0
 
      ** File Information Data Structure for IR001958P2
     D SPOOL2          DS
     D  PSFile2               83     92
     D  PSFNum2              123    124B 0
     D  OflLn2               188    189B 0
     D  PrtLn2               367    368B 0
 
      ** File Information Data Structure for IR001958AU
 
     D SPOOLU          DS
     D  PSFileU               83     92
     D  PSFNumU              123    124B 0
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** ZSEDIT fields
     D PZFLD15         S             15  0
     D PZDECS          S              1  0
     D PZECODE         S              1
     D PZOUT21         S             21
 
      ** ZCONVZ1 fields
     D PINPAMT         S             15  0
     D PCVTRAT         S             13  8
     D PBASMD          S              1
     D PFRMCCY         S              3
     D PTOCCY          S              3
     D PFRMDEC         S              1  0
     D PTODEC          S              1  0
     D POUTAMT         S             15  0
 
      ** Parameters for ZSFILE
     D PSeq            S              5
     D PLevel          S              1
     D PEnty           S              3
     D ZSnum           S              6  0
     D ZSnum1          S              6  0
     D ZSnumU          S              6  0
     D ZSerr           S              1
 
      ** Parameters for access object programs
     D PRTCD           S              7
     D POPTN           S              7
     D PCYCD           S              3
     D PKYST           S              7
     D PCNUM           S             10
 
     D ZDAYNO          S              5  0
     D ZDATE           S              6  0
     D ZADATE          S              7
     D ZDATEB          S              7
 
      ** Work fields for amounts
 
     D WADJBOOK        S             15  0
     D WADJBRCA        S             15  0
     D WNPVBOOK        S             15  0
     D WNPVBRCA        S             15  0
     D WNPVT           S             15  0
     D WRDADJ          S             15  0
     D WRNPVT          S             15  0
     D W1STAMT         S             15  0
     D W1STCCY         S             15  0
     D W1STRAT         S             13  8
     D W2NDAMT         S             15  0
     D W2NDCCY         S             15  0
     D W2NDRAT         S             13  8
     D WRXBADJ         S             15  0
 
      ** Other work fields
 
     D W2NDFRM         S              3
     D W2NDMD          S              1
     D W1STFRM         S              3
     D W1STMD          S              1
     D W1STFLG         S              1
     D WIRMISS         S              1
     D WIRBKCD         S              2
     D WIRBRCA         S              3
     D WIRCYCD         S              3
     D WBOOKZERO       S              1    INZ('N')
     D WBRCAZERO       S              1    INZ('N')
     D WIRDLNO         S              6  0
     D WIRCUST         S              6
     D WRFACT          S             12
     D WNBDP           S              1  0
     D WBJCYND         S              1  0
     D WEvCtlDt        S              5P 0
     D RQDLN1          S              3  0
     D RQDLN2          S              3  0
     D DIFLN1          S              3  0
     D DIFLN2          S              3  0
     D WZERO           S             21    INZ('                0.00 ')
 
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
 
      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************
 
     C                   EXSR      SRINIT
 
     C                   EXSR      SRPROC
 
     C                   EXSR      SRAUDT
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRINIT - Initialisation                                       *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SRINIT        BEGSR
 
     C                   EVAL      W1STFLG = 'N'
 
      ** Get number of decimal place for bank currency
 
     C                   EVAL      PCYCD = BJCYCD
     C                   EXSR      SRCURR
     C                   EVAL      WBJCYND = WNBDP
 
      ** Initialize report work fields
 
     C                   EVAL      RQDLN1 = 0
     C                   EVAL      DIFLN1 = 0
     C                   EVAL      RQDLN2 = 0
     C                   EVAL      DIFLN2 = 0
 
     C                   EVAL      PZECODE = 'J'
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRPROC - Detail Processing                                    *
      *                                                               *
      *****************************************************************
 
     C     SRPROC        BEGSR
 
     C     *LOVAL        SETLL     RXCFLAL0
 
      ** Read Cross CCY IRS Cash Flows File
 
     C                   READ      RXCFLAL0                               01
 
     C                   DOW       IRSPIN = 'S' AND
     C                             *IN01 = *OFF
     C                   READ      RXCFLAL0                               01
     C                   ENDDO
 
     C                   IF        *IN01 = *OFF
 
 
      ** RCF Processing for Printer Files.
 
     C                   EXSR      SRRCFP1
     C                   EXSR      SRRCFP2
 
      ** Obtain Branch name, Book name, Currency name and Deal Sub-type Name
 
     C                   EXSR      SRGETNAME
 
      ** Print Headers for both printer file
 
     C                   WRITE     HEADP1
     C                   WRITE     HEADP2
 
     C                   ELSE
 
      ** When EOF, write trailer
 
     C                   EXSR      SRAUDT
 
     C                   ENDIF
 
     C                   DOW       *IN01 = *OFF
 
     C                   EVAL      RNORE = RNORE + 1
 
      ** Save previous deal number, CCY, branch, book code and sub-type
 
     C                   EVAL      WIRDLNO = IRDLNO
     C                   MOVE      IRCNUM        WIRCUST
     C                   EVAL      WIRCYCD = IRCYCD
     C                   EVAL      WIRBRCA = IRBRCA
     C                   EVAL      WIRBKCD = IRBKCD
     C                   EVAL      WIRMISS = IRMISS
 
      ** Print detail and read next record
 
     C                   EXSR      SRPRNTDET
     C                   READ      RXCFLAL0                               01
 
     C                   DOW       IRSPIN = 'S' AND
     C                             *IN01 = *OFF
     C                   READ      RXCFLAL0                               01
     C                   ENDDO
 
     C                   IF        WIRMISS <> *BLANKS
     C                   EVAL      WBOOKZERO = 'Y'
     C                   EVAL      WBRCAZERO = 'Y'
     C                   IF        WIRMISS = 'C'
     C                   EVAL      *IN31 = *ON
     C                   ELSE
     C                   EVAL      *IN32 = *ON
     C                   ENDIF
     C                   ENDIF
 
      ** If change in currency, write subtotal of previous currency NPV
 
     C                   IF        WIRCYCD <> IRCYCD AND
     C                             WIRDLNO = IRDLNO
     C                   EXSR      SRCCYNPV
 
      ** Save values of first currency, initialize work var for NPV total
 
     C                   EVAL      W1STCCY = WNPVT
     C                   EVAL      W1STRAT = A6SPRT
     C                   EVAL      W1STMD  = A6MDIN
     C                   EVAL      W1STFRM = IRCYCD
     C                   EVAL      WNPVT = 0
 
     C                   ENDIF
 
      ** If change in deal number, compute for deal number's total
 
     C                   IF        WIRDLNO <> IRDLNO
     C                             OR *IN01 = *ON
     C                   EXSR      SRCCYNPV
 
      ** Save values of second currency, initialize work var for NPV total
 
     C                   EVAL      W2NDCCY = WNPVT
     C                   EVAL      W2NDRAT = A6SPRT
     C                   EVAL      W2NDMD  = A6MDIN
     C                   EVAL      W2NDFRM = IRCYCD
     C                   EVAL      WNPVT = 0
 
      ** Compute for deal's total NPV
 
     C                   EXSR      SRPRNTSUM
 
      ** Initialize both currency's subtotal
 
     C                   EVAL      W1STCCY = 0
     C                   EVAL      W2NDCCY = 0
 
      ** Write Detail for printer file 1 and accumulate total NPV
      ** for Branch and Book Code
 
     C                   EXSR      SRPRNTP1
 
      ** Print total for book if there is a change in book or end
      ** of file was reached
 
     C                   IF        WIRBKCD <> IRBKCD
     C                             OR *IN01 = *ON
     C                             OR WIRBRCA <> IRBRCA
     C                   EXSR      SRBOOKTOT
     C                   EVAL      WBOOKZERO = 'N'
     C                   EVAL      WNPVBOOK = 0
     C                   EVAL      WADJBOOK = 0
     C                   ENDIF
 
      ** Print total for branch if there is a change in branch or
      ** end of file was reached. Also print for book total.
 
     C                   IF        WIRBRCA <> IRBRCA
     C                             OR *IN01 = *ON
 
     C                   EXSR      SRBRCATOT
     C                   EVAL      WBRCAZERO = 'N'
     C                   EVAL      WNPVBRCA = 0
     C                   EVAL      WADJBRCA = 0
     C                   ENDIF
 
      ** Write End of Report in end of file, else write headers
 
     C                   IF        *IN01 = *ON
     C                   EVAL      RQDLN1 = 3
     C                   EVAL      DIFLN1 = OFLLN1 - PRTLN1
     C                   IF        DIFLN1 <= RQDLN1
     C                   WRITE     HEADP1
     C                   ENDIF
     C                   WRITE     ENDRPT1
 
     C                   EVAL      RQDLN2 = 3
     C                   EVAL      DIFLN2 = OFLLN2 - PRTLN2
     C                   IF        DIFLN2 <= RQDLN2
     C                   WRITE     HEADP2
     C                   ENDIF
     C                   WRITE     ENDRPT2
 
     C                   ELSE
 
      ** Write header for Printer file 2 if there is a change in
      ** Branch or Book Code
 
     C                   IF        WIRBRCA <> IRBRCA OR
     C                             WIRBKCD <> IRBKCD
     C                   EXSR      SRGETNAME
     C                   IF        WIRBRCA <> IRBRCA
     C                   WRITE     HEADP1
     C                   ENDIF
     C                   WRITE     HEADP2
     C                   ENDIF
 
     C                   ENDIF
 
      ** Initialize indicator for rates/curves missing
 
     C                   EVAL      *IN31 = *OFF
     C                   EVAL      *IN32 = *OFF
 
     C                   ENDIF
 
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRPRNTP1  - Print details of P1. Accumulate total NPV and     *
      *             adjusted amount for Book Code and Branch          *
      *                                                               *
      *****************************************************************
     C     SRPRNTP1      BEGSR
 
      ** Access DEALS file
 
     C     WIRDLNO       CHAIN     DEALS                              33
 
      ** Move file fields to printer file
 
     C                   MOVE      WIRDLNO       RDLNO
     C                   MOVE      WIRCUST       RCNUM
     C                   EXSR      SRCUST
     C                   EVAL      RBOKC = WIRBKCD
     C                   IF        *IN33 = *OFF
     C                   EVAL      RUCUCY = UCUCY
     C                   EVAL      RTCUCY = TCUCY
 
      ** Convert value date to format DDMMMYY
 
     C                   EVAL      ZDAYNO = VDAT
     C                   EXSR      SRZDATE
     C                   EVAL      RVDAT = ZDATEB
 
      ** Convert maturity date to format DDMMMYY
 
     C                   EVAL      ZDAYNO = MDAT
     C                   EXSR      SRZDATE
     C                   EVAL      RMDAT = ZDATEB
     C                   ENDIF
 
      ** Format Our Principal Amount
 
     C                   EVAL      PCYCD = UCUCY
     C                   EXSR      SRCURR
     C                   EVAL      PZECODE = 'J'
     C                   EVAL      PZFLD15 = UPAMT
     C                   EXSR      SRZSEDIT
     C                   EVAL      RUPAMT = PZOUT21
 
      ** Format Their Principal Amount
 
     C                   EVAL      PCYCD = TCUCY
     C                   EXSR      SRCURR
     C                   EVAL      PZFLD15 = TPAMT
     C                   EXSR      SRZSEDIT
     C                   EVAL      RTPAMT = PZOUT21
 
      ** Get formated NPV and Adjusted amount
 
     C                   IF        *IN31 = *OFF AND *IN32 = *OFF
     C                   EVAL      RDTOT = RNPVT
     C                   ELSE
     C                   EVAL      RDTOT = WZERO
     C                   EVAL      RDADJ = WZERO
     C                   ENDIF
 
      ** If overflow, write header
 
     C                   EVAL      RQDLN1 = 2
     C                   EVAL      DIFLN1 = OFLLN1 - PRTLN1
     C                   IF        DIFLN1 <= RQDLN1
     C                   WRITE     HEADP1
     C                   ENDIF
 
     C                   WRITE     DETP1
 
      ** Add deal NPV to book and branch total
 
     C                   EVAL      WNPVBOOK = WNPVBOOK + WRNPVT
     C                   EVAL      WNPVBRCA = WNPVBRCA + WRNPVT
 
      ** Add deal Adujusted Amount to book and branch total
 
     C                   EVAL      WADJBOOK = WADJBOOK + WRDADJ
     C                   EVAL      WADJBRCA = WADJBRCA + WRDADJ
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRBOOKTOT - Print total for book                              *
      *                                                               *
      *****************************************************************
     C     SRBOOKTOT     BEGSR
 
     C                   EVAL      RBOKC1 = WIRBKCD
 
      ** Format total NPV for book
 
     C                   EVAL      WNBDP = WBJCYND
     C                   EVAL      PZFLD15 = WNPVBOOK
     C                   EXSR      SRZSEDIT
     C                   IF        WBOOKZERO = 'N'
     C                   EVAL      ZBKTOT = PZOUT21
     C                   ELSE
     C                   EVAL      ZBKTOT = WZERO
     C                   ENDIF
 
      ** Format total adjustment for book
 
     C                   EVAL      PZFLD15 = WADJBOOK
     C                   EXSR      SRZSEDIT
     C                   IF        WBOOKZERO = 'N'
     C                   EVAL      RBKTOT = PZOUT21
     C                   ELSE
     C                   EVAL      RBKTOT = WZERO
     C                   ENDIF
 
     C                   EVAL      RQDLN1 = 3
     C                   EVAL      DIFLN1 = OFLLN1 - PRTLN1
     C                   IF        DIFLN1 <= RQDLN1
     C                   WRITE     HEADP1
     C                   ENDIF
 
     C                   WRITE     BKTOTP1
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRBRCATOT - Print total for Branch                            *
      *                                                               *
      *****************************************************************
     C     SRBRCATOT     BEGSR
 
     C                   EVAL      RBRCA1 = WIRBRCA
 
      ** Format total NPV for book
 
     C                   EVAL      WNBDP = WBJCYND
     C                   EVAL      PZFLD15 = WNPVBRCA
     C                   EXSR      SRZSEDIT
     C                   IF        WBRCAZERO = 'N'
     C                   EVAL      ZBRTOT = PZOUT21
     C                   ELSE
     C                   EVAL      ZBRTOT =  WZERO
     C                   ENDIF
 
      ** Format total adjustment for book
 
     C                   EVAL      PZFLD15 = WADJBRCA
     C                   EXSR      SRZSEDIT
     C                   IF        WBRCAZERO = 'N'
     C                   EVAL      RBRTOT = PZOUT21
     C                   ELSE
     C                   EVAL      RBRTOT = WZERO
     C                   ENDIF
 
     C                   EVAL      RQDLN1 = 3
     C                   EVAL      DIFLN1 = OFLLN1 - PRTLN1
     C                   IF        DIFLN1 <= RQDLN1
     C                   WRITE     HEADP1
     C                   ENDIF
 
     C                   WRITE     BRTOTP1
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRPRNTSUM - Compute for total NPV of Deal. Save it to         *
      *             WRNPVT. Get the Accrued Interest Adjustment from  *
      *             the DEALS file then subtract it to the WRNPVT     *
      *             to get the adjusted NPV of the Deal.              *
      *                                                               *
      *****************************************************************
     C     SRPRNTSUM     BEGSR
 
      ** Obtain base currency equivalent of 1st ccy NPV total
 
     C                   EVAL      PINPAMT = W1STCCY
     C                   EVAL      PCVTRAT = W1STRAT
     C                   EVAL      PBASMD  = W1STMD
     C                   EVAL      PFRMCCY = W1STFRM
     C                   EXSR      SRZCONV
     C                   EVAL      W1STAMT = POUTAMT
 
      ** Obtain base currency equivalent of 2nd ccy NPV total
 
     C                   EVAL      PINPAMT = W2NDCCY
     C                   EVAL      PCVTRAT = W2NDRAT
     C                   EVAL      PBASMD  = W2NDMD
     C                   EVAL      PFRMCCY = W2NDFRM
     C                   EXSR      SRZCONV
     C                   EVAL      W2NDAMT = POUTAMT
 
      ** Add both base currency equivalent and format to printer file
 
     C                   EVAL      WNBDP = WBJCYND
     C                   EVAL      PZFLD15 = W1STAMT + W2NDAMT
     C                   EVAL      WRNPVT = W1STAMT + W2NDAMT
     C                   EXSR      SRZSEDIT
     C                   IF        *IN31 = *OFF AND *IN32 = *OFF
     C                   EVAL      RNPVT = PZOUT21
     C                   ELSE
     C                   EVAL      RNPVT = WZERO
     C                   ENDIF
 
      ** Get Accrued Interest Adjustment from RXNPVBPD file
 
     C     WIRDLNO       CHAIN     RXNPVBL0                           25
 
     C                   EVAL      WRXBADJ = 0
     C                   DOW       *IN25 = *OFF
     C                   EVAL      WRXBADJ = WRXBADJ + NP_IRAINT
     C     WIRDLNO       READE     RXNPVBL0                               25
     C                   ENDDO
     C                   EVAL      PZFLD15 = WRXBADJ
     C                   EXSR      SRZSEDIT
     C                   EVAL      RDACR = PZOUT21
 
      ** Format adjusted amount
 
     C                   EVAL      WRDADJ = WRNPVT - WRXBADJ
     C                   EVAL      WNBDP = WBJCYND
     C                   EVAL      PZFLD15 = WRDADJ
     C                   EXSR      SRZSEDIT
     C                   IF        *IN31 = *OFF AND *IN32 = *OFF
     C                   EVAL      RDADJ = PZOUT21
     C                   ELSE
     C                   EVAL      RDADJ = WZERO
     C                   ENDIF
 
     C                   MOVE      WIRDLNO       RDLNO
     C                   MOVE      WIRDLNO       RDLNO1
 
      ** Write total
 
     C                   EVAL      RQDLN2 = 7
     C                   EVAL      DIFLN2 = OFLLN2 - PRTLN2
     C                   IF        DIFLN2 <= RQDLN2
     C                   WRITE     HEADP2
     C                   ENDIF
 
     C                   WRITE     DTOT2
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRCCYNPV - Write Sub-total for currency's NPV and save it     *
      *            to WNPVT                                           *
      *                                                               *
      *****************************************************************
     C     SRCCYNPV      BEGSR
 
      ** Blank out detail line fields
 
     C                   EVAL      RDLNO = *BLANKS
     C                   EVAL      RCUST = *BLANKS
     C                   EVAL      RYIELD = *BLANKS
     C                   EVAL      RVDAT = *BLANKS
     C                   EVAL      RCCY = *BLANKS
     C                   EVAL      RAMT = *BLANKS
     C                   EVAL      REQUI = *BLANKS
     C                   EVAL      RFACT = *BLANKS
 
      ** Format subtotal for currency's NPV
 
     C                   EVAL      PCYCD = WIRCYCD
     C                   EXSR      SRCURR
     C                   EVAL      PZFLD15 = WNPVT
     C                   EXSR      SRZSEDIT
     C                   IF        *IN31 = *OFF AND *IN32 = *OFF
     C                   EVAL      RNPV = PZOUT21
     C                   ELSE
     C                   EVAL      RNPV = WZERO
     C                   ENDIF
 
      ** If overflow, write header
 
     C                   EVAL      RQDLN2 = 1
     C                   EVAL      DIFLN2 = OFLLN2 - PRTLN2
     C                   IF        DIFLN2 <= RQDLN2
     C                   WRITE     HEADP2
     C                   ENDIF
 
     C                   WRITE     DETP2
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRPRNTDET - Detail Printing                                   *
      *                                                               *
      *****************************************************************
     C     SRPRNTDET     BEGSR
 
      ** Put details to printer fields.
 
     C                   MOVE      IRDLNO        RDLNO
     C                   MOVE      IRCNUM        RCUST
     C                   EVAL      RYIELD = IRYLDC
     C                   EVAL      RVDAT = IRDATE
     C                   EVAL      RCCY = IRCYCD
 
      ** Obtain and format cash flow amount to printer field
 
     C                   EVAL      PCYCD = IRCYCD
     C                   EXSR      SRCURR
     C                   EVAL      PZFLD15 = IRCAMT
     C                   EXSR      SRZSEDIT
     C                   EVAL      RAMT = PZOUT21
 
      ** Obtain and format Net Present Value to printer field
 
     C                   EVAL      PZFLD15 = IRNPVA
     C                   EXSR      SRZSEDIT
     C                   EVAL      RNPV = PZOUT21
 
      ** Obtain and format Discount Factor to printer field
 
     C                   EVAL      PZECODE = 'L'
     C                   MOVE      IRDSCF        RFACT
     C                   EVAL      WNBDP = 9
     C                   MOVE      RFACT         PZFLD15
     C                   EXSR      SRZSEDIT
     C                   MOVE      PZOUT21       WRFACT
     C                   MOVEL     WRFACT        RFACT
     C                   EVAL      PZECODE = 'J'
 
      ** Obtain and format Dealt Equivalent amount to printer field
 
     C                   EVAL      PINPAMT = IRCAMT
     C                   EVAL      PCVTRAT = A6SPRT
     C                   EVAL      PBASMD  = A6MDIN
     C                   EVAL      PFRMCCY = IRCYCD
     C                   EXSR      SRZCONV
 
     C                   EVAL      WNBDP = WBJCYND
     C                   EVAL      PZFLD15 = POUTAMT
     C                   EXSR      SRZSEDIT
     C                   EVAL      REQUI = PZOUT21
 
      ** If overflow, write header
 
     C                   EVAL      RQDLN2 = 1
     C                   EVAL      DIFLN2 = OFLLN2 - PRTLN2
     C                   IF        DIFLN2 <= RQDLN2
     C                   WRITE     HEADP2
     C                   ENDIF
 
      ** Write Detail
 
     C                   WRITE     DETP2
 
      ** Accumulate total NPV
 
     C                   EVAL      WNPVT = WNPVT + IRNPVA
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRAUDT - Audit Processing                                     *
      *                                                               *
      *****************************************************************
 
     C     SRAUDT        BEGSR
 
     C                   WRITE     HEADAU
 
      ** If there is a DB error, output the DB error information
 
     C                   IF        *INU7 = *ON
     C                   WRITE     DBERROR
     C                   ELSE
 
      ** If file is not empty, write number of records, else no
      ** detail write to display
 
     C                   IF        RNORE <> 0
     C                   WRITE     CONTROL
     C                   ELSE
     C                   WRITE     NODTLS
     C                   ENDIF
     C                   ENDIF
 
      ** End of Program
 
     C                   EVAL      *INLR = '1'
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRRCFP1 - Detail Spool File recorded by RCF                   *
      *                                                               *
      *****************************************************************
     C     SRRCFP1       BEGSR
 
     C                   OPEN      IR001958P1
 
      ** Ensure Detail Spool File recorded by RCF.
 
     C                   EVAL      ZSnum = PSFNum1
 
     C                   CALL      'ZSFILE'
     C                   PARM                    PSeq
     C                   PARM                    PEnty
     C                   PARM                    PSFile1
     C                   PARM                    ZSnum
     C                   PARM      *Blank        ZSerr
 
      ** If Error occurs during ZSFILE processing, then return to the
      ** Calling Program.
 
     C     ZSERR         IFEQ      'Y'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRRCFP2 - Detail Spool File recorded by RCF                   *
      *                                                               *
      *****************************************************************
     C     SRRCFP2       BEGSR
 
     C                   OPEN      IR001958P2
 
      ** Ensure Detail Spool File recorded by RCF.
 
     C                   EVAL      ZSnum1 = PSFNum2
 
     C                   CALL      'ZSFILE'
     C                   PARM                    PSeq
     C                   PARM                    PEnty
     C                   PARM                    PSFile2
     C                   PARM                    ZSnum1
     C                   PARM      *Blank        ZSerr
 
      ** If Error occurs during ZSFILE processing, then return to the
      ** Calling Program.
 
     C     ZSERR         IFEQ      'Y'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRRCFAU - Detail Spool File recorded by RCF                   *
      *                                                               *
      *****************************************************************
     C     SRRCFAU       BEGSR
 
      ** Ensure Detail Spool File recorded by RCF.
 
     C                   EVAL      ZSnumU = PSFNumU
 
     C                   CALL      'ZSFILE'
     C                   PARM                    PSeq
     C                   PARM                    PEnty
     C                   PARM                    PSFileU
     C                   PARM                    ZSnumU
     C                   PARM      *Blank        ZSerr
 
      ** If Error occurs during ZSFILE processing, then return to the
      ** Calling Program.
 
     C     ZSERR         IFEQ      'Y'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRGETNAME - Obtain Branch name, Book name, Currency name      *
      *             and Deal Sub-type Name                            *
      *                                                               *
      *****************************************************************
     C     SRGETNAME     BEGSR
 
     C                   EXSR      SRBRCH
     C                   EXSR      SRBOOK
     C                   EVAL      PCYCD = IRCYCD
     C                   EXSR      SRCURR
     C                   EVAL      RRCCY = IRCYCD
     C                   EVAL      RCYNM = A6CYNM
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRCUST - Get Customer Name                                    *
      *                                                               *
      *****************************************************************
     C     SRCUST        BEGSR
 
     C                   CALLB     'AOCUSTR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      RCNUM         PCNUM
     C                   PARM      *BLANKS       PKYST
     C     SDCUST        PARM      SDCUST        DSSDY
 
      ** Database Error
 
     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      DBFILE = 'SDCUSTPD'
     C                   EVAL      DBASE = 2
     C                   EVAL      DBKEY = RCNUM
     C                   EVAL      DBPGM = 'IR001958'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRBRCH - Get Branch Name                                      *
      *                                                               *
      *****************************************************************
     C     SRBRCH        BEGSR
 
     C**********         CALLB     'AOBRCHR0'                                                 CAS010
     C                   CALL      'AOBRCHR1'                                                 CAS010
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM                    IRBRCA
     C     SDBRCH        PARM      SDBRCH        DSSDY
 
      ** Database Error
 
     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      DBFILE = 'SDBRCHPD'
     C                   EVAL      DBASE = 3
     C                   EVAL      DBKEY = IRBRCA
     C                   EVAL      DBPGM = 'IR001958'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      RBRNM = A8BRNM
     C                   EVAL      RBRCA = IRBRCA
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRBOOK - Get Book Code Name                                   *
      *                                                               *
      *****************************************************************
 
     C     SRBOOK        BEGSR
 
     C                   CALLB     'AOBOOKR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM                    IRBKCD
     C     SDBKCD        PARM      SDBKCD        DSSDY
 
      ** Database Error
 
     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      DBFILE = 'SDBOOKPD'
     C                   EVAL      DBASE = 4
     C                   EVAL      DBKEY = IRBKCD
     C                   EVAL      DBPGM = 'IR001958'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      RBKCD = IRBKCD
     C                   EVAL      RBKNM = BDBKD
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRCURR - Access Currency code file                            *
      *                                                               *
      *****************************************************************
 
     C     SRCURR        BEGSR
 
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM                    PCYCD
     C     SDCURR        PARM      SDCURR        DSSDY
 
      ** Database Error
 
     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      DBFILE = 'SDCURRPD'
     C                   EVAL      DBASE = 6
     C                   EVAL      DBKEY = PCYCD
     C                   EVAL      DBPGM = 'IR001958'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      WNBDP = A6NBDP
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRZSEDIT - Convert amount from file format to screen format   *
      *                                                               *
      *****************************************************************
 
     C     SRZSEDIT      BEGSR
 
     C                   CALLB     'ZSEDIT'
     C                   PARM                    PZFLD15
     C                   PARM      WNBDP         PZDECS
     C                   PARM                    PZECODE
     C                   PARM                    PZOUT21
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRZDATE - Convert date to format DDMMMYY                      *
      *                                                               *
      *****************************************************************
     C     SRZDATE       BEGSR
 
     C                   CALL      'ZDATE2'
     C                   PARM                    ZDAYNO
     C                   PARM                    BJDFIN
     C                   PARM                    ZDATE
     C                   PARM                    ZDATEB
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRZCONV  - Convert amount from one currency to another        *
      *                                                               *
      *****************************************************************
     C     SRZCONV       BEGSR
 
     C                   CALLB     'ZCONVZ1'
     C                   PARM                    PINPAMT
     C                   PARM                    PCVTRAT
     C                   PARM                    PBASMD
     C                   PARM                    PFRMCCY
     C                   PARM      BJCYCD        PTOCCY
     C                   PARM                    PFRMDEC
     C                   PARM                    PTODEC
     C                   PARM                    POUTAMT
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
      ** Access Bank Details
 
     C                   CALLB     'AOBANKR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database Error
 
     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE = 1
     C                   EVAL      DBKEY = '*FIRST'
     C                   EVAL      DBPGM = 'IR001958'
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Call access program for General Ledger details
 
     C**********         CALL      'AOGELRR0'                                                 CAS010
     C                   CALL      'AOGELRR1'                                                 CAS010
     C                   PARM      '*DBERR '     PRTCD
     C                   PARM      '*FIRST '     POPTN
     C*****SDGELR        PARM      SDGELR        DSFDY                                        CAS010
     C     SDGELR        PARM      SDGELR        DSSDY                                        CAS010
 
      ** Database Error
 
     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      DBFILE = 'SDGELRPD'
     C                   EVAL      DBASE = 7
     C                   EVAL      DBKEY = '*FIRST'
     C                   EVAL      DBPGM = 'IR001958'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      WEvCtlDt = BJDNWD - 1
     C                   IF        BKAPDT < WEvCtlDt
     C                   EVAL      WEvCtlDt = BKAPDT
     C                   ENDIF
 
     C                   EVAL      ZDAYNO = WEvCtlDt
     C                   EXSR      SRZDATE
     C                   EVAL      REVCDE = ZDATEB
 
      ** RCF Processing for Audit Printer File
 
     C                   EXSR      SRRCFAU
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: (**calling routines**)                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *PSSR         BEGSR
 
     C                   DUMP
 
     C                   IF        RunBefore = *BLANK
     C                   EVAL      RunBefore = 'Y'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EXSR      SRAUDT
 
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
 
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2004
