     H DEBUG
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SE Generated Position Settlements Report')       *
      *****************************************************************
      *                                                               *
      *  Midas - Security Trading Module                              *
      *                                                               *
      *  XX118002 - Midas SE Generated Position Settlements Report    *
      *                                                               *
      *  Function:  This program list all generated position          *
      *             settlements for a given Security/Due Date/Event   *
      *             Type from file XXPOSEX4.                          *
      *                                                               *
      *  Called By: XXC118002 - Position Settlement Generated Report  *
      *                                                               *
      *  (c) Finastra International Limited 2020                      *
      *                                                               *
      *  Last Amend No. HUT118  *CREATE    Date 10Dec20               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  HUT118 - Online Generation of Position Settlements           *
      *                                                               *
      *****************************************************************
     FXXPOSEL2  IF   E           K DISK
      ** Position Settlements file (PAUI = ' ')
      ** and (RECI = 'D')
      *
     FXXPOSEV4  UF A E           K DISK
      ** Position Settlements - Client/Market
      *
     FXX118002P1O    E             PRINTER INFDS(SPOOL1)
     F                                     OFLIND(*IN60)
     F                                     USROPN
      ** Midas SE Unauthorised Position Settlemens Report
      *
      *****************************************************************
      /EJECT
      *****************************************************************
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
     D*    ARRAYS FOR EDITING AN AMOUNT ACCORDING TO NO. OF DPS.                           HUT011I09
     D ZEDT            S              4    DIM(5)                               EDITED AMOUNT
     D ZED2            S              3    DIM(6)                               AMT WITH NO COMMA
     D ZAMT            S              3    DIM(5)                               AMOUNT FIELD
     D Z3              S              1    DIM(3)                               DUMMY 3 CHAR FLD
     D ZCOM            S             20    DIM(4) CTDATA PERRCD(1)              EDT CHARS FOR AMT
     D RAT             S              1  0 DIM(11)                              EDITED AMOUNT
     D OUT             S              1    DIM(12)                              EDITED AMOUNT
     D*                                                                                    HUT011I09
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  F U N C T I O N   O F   I N D I C A T O R S                  *
      *                                                               *
      *  23     - READ Indicator for XXPOSEV4                         *
      *  88     - READ Indicator for XXPOSEL2                         *
      *  60     - OVERFLOW Indicator for XX118002P1                   *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E   I N D E X                              *
      *                                                               *
      *  SRINIT - Initialisation Program                              *
      *  SRPRNT - Print Transaction Details                           *
      *  SRBLNK - Blank Out Detail Fields                             *
      *  SRLOAD - Load Detail Line                                    *
      *  SRUNAU - Get records in XXPOSEL2 using entry parm as key     *
      *  SRLSDE - Load XX118002D*                                     *
      *  SRCSBA - Total Settlement Amount per Branch                  *
      *  SRTOTL - Total Records read per security event               *
      *  SRENDR - End of Report                                       *
      *  RCPF1  - Register printer file via RCF                       *
      *                                                               *
      *  *INZSR - Program Initialisation Routine                      *
      *  *PSSR  - Program Exception Error Routine                     *
      *                                                               *
      *****************************************************************
     D WLVLDS          DS             3
      ** File sorted by Security,Due Date,Event Type (WL3),
      ** Private Banking Cust (WL2) and Booking Branch (WL1)
      *
     D  WL3                    1      1
     D  WL2                    2      2
     D  WL1                    3      3
      *
     D SPOOL1          DS
      ** File Information Data Structure
      *
     D  SFILE1                83     92
     D  SFNUM1               123    124B 0
     D  PRTLN1               367    368B 0
      *
     D SPOOL2          DS
      ** File Information Data Structure
      *
     D  SFILE2                83     92
     D  SFNUM2               123    124B 0
     D  PRTLN2               367    368B 0
      *
     D LDA             DS           256
      ** Local Data Area for Database Error details
      *
     D  DBLOT                134    183
     D  DBFILE               134    141
     D  DBKEY                142    170
     D  DBPGM                171    180
     D  DBASE                181    183  0
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** Bank Details File
      *
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
     D  QQDFAX       E                     EXTFLD(QQDFAC)
      ** Branch codes file
      *
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
      ** Branch codes file
      *
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ** Currencies file
      *
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
     D  DFLCD        E                     EXTFLD(LCD)
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for access programs, short data structure
      *
     D DSLDY         E DS                  EXTNAME(DSLDY)
      ** Second DS for access programs, long data structure
      *
     D @RPARM          DS
     D*** Parameters for @RPARM - 100 long string passed to RCF
     D*
     D  @@RPRM                 1    100
     D**@RSEQN***              1      5
     D**@RSESN***              6     15
     D**@RDUDT***             16     21
     D**@REVTP***             22     23
     D  @RSESN                 1     10
     D  @RDUDT                11     16
     D  @RPUDT                17     22
     D  @REVTP                23     24
      *
     D POSET         E DS                  EXTNAME(POSETD)
      ** Position Settlement File
      *
     D  RECIX        E                     EXTFLD(RECI)
     D  PBCAX        E                     EXTFLD(PBCA)
     D  PSSHX        E                     EXTFLD(PSSH)
     D  PCPYX        E                     EXTFLD(PCPY)
     D  PMARX        E                     EXTFLD(PMAR)
     D  PDUDX        E                     EXTFLD(PDUD)
     D  PEVTX        E                     EXTFLD(PEVT)
     D  PAUIX        E                     EXTFLD(PAUI)
     D  PNMPX        E                     EXTFLD(PNMP)
     D  PNCYX        E                     EXTFLD(PNCY)
     D  PBCDX        E                     EXTFLD(PBCD)
     D  PAMDX        E                     EXTFLD(PAMD)
     D  PPREX        E                     EXTFLD(PPRE)
     D  PSCUX        E                     EXTFLD(PSCU)
     D  PSXRX        E                     EXTFLD(PSXR)
     D  PMDIX        E                     EXTFLD(PMDI)
     D  PBRXX        E                     EXTFLD(PBRX)
     D  PSMTX        E                     EXTFLD(PSMT)
     D  PSEAQX       E                     EXTFLD(PSEAQQ)
     D  PSEBX        E                     EXTFLD(PSEB)
     D  PCPNX        E                     EXTFLD(PCPN)
     D  PFACX        E                     EXTFLD(PFAC)
     D  PSPIX        E                     EXTFLD(PSPI)
     D  PCHCX        E                     EXTFLD(PCHC)
     D  PCHAX        E                     EXTFLD(PCHA)
     D  PCCDX        E                     EXTFLD(PCCD)
     D  PCAMX        E                     EXTFLD(PCAM)
     D  PSATX        E                     EXTFLD(PSAT)
     D  PSMIX        E                     EXTFLD(PSMI)
     D  PDTGX        E                     EXTFLD(PDTG)
     D  LCDX4        E                     EXTFLD(LCD)
     D  CHTPX        E                     EXTFLD(CHTP)
     D  TNLUX        E                     EXTFLD(TNLU)
     D  PPFCX        E                     EXTFLD(PPFC)
     D  TASOX        E                     EXTFLD(TASO)
     D  TASRX        E                     EXTFLD(TASR)
     D  TAUSX        E                     EXTFLD(TAUS)
     D  PSVLX        E                     EXTFLD(PSVL)
     D  PTFRX        E                     EXTFLD(PTFR)
     D  SRPGX        E                     EXTFLD(SRPG)
     D  SABCX        E                     EXTFLD(SABC)
     D  BAUSX        E                     EXTFLD(BAUS)
     D  PSCFX        E                     EXTFLD(PSCF)
     D  FXMPX        E                     EXTFLD(FXMP)
     D  FXMRX        E                     EXTFLD(FXMR)
     D  MAMTX        E                     EXTFLD(MAMT)
     D  TXBSX        E                     EXTFLD(TXBS)
     D  TXBNX        E                     EXTFLD(TXBN)
     D  EXCDX        E                     EXTFLD(EXCD)
     D  CRTXX        E                     EXTFLD(CRTX)
     D  RPCDX        E                     EXTFLD(RPCD)
     D  ICTPX        E                     EXTFLD(ICTP)
     D  BNFOX        E                     EXTFLD(BNFO)
     D  MT5RX        E                     EXTFLD(MT5R)
     D  MT5GX        E                     EXTFLD(MT5G)
     D  CTYPX        E                     EXTFLD(CTYP)
     D  PREFX        E                     EXTFLD(PREF)
     D  PSEQX        E                     EXTFLD(PSEQ)
     D  CTINX        E                     EXTFLD(CTIN)
     D  DAMTX        E                     EXTFLD(DAMT)
     D  DEPTX        E                     EXTFLD(DEPT)
     D  PSEAX        E                     EXTFLD(PSEA)
     D  TXNMX        E                     EXTFLD(TXNM)
     D  TXSTX        E                     EXTFLD(TXST)
     D  TAXAX        E                     EXTFLD(TAXA)
     D  TXCYX        E                     EXTFLD(TXCY)
      *
     D POSET4        E DS                  EXTNAME(XXPOSEX4)
      *
     D @NOST           DS
      ** Nostro account
      *
     D  WNOST                  1      5
     D  NCCY                   1      3
     D  NACSQ                  4      5
      *
     D @GLACT          DS
      ** Full GL account
      *
     D  WGLACT                 1     24
     D  GBRCA                  1      3
     D  GCUSN                  4      9
     D  GCCY                  10     12
     D  GACOD                 13     22
     D  GACSQ                 23     24
      *
     I/COPY ZSRSRC,ZFRPEDZ1LE
      *****************************************************************
      *                                                               *
      *  Main Processing                                              *
      *                                                               *
      *****************************************************************
      *
      ** Initialise fields
      *
     C                   EXSR      SRINIT
      *
      ** Extract records from XXPOSEL2
      *
     C                   EXSR      SRUNAU
      *
      ** Process details
      *
     C     *LOVAL        SETLL     POSETDD4
     C                   READ      POSETDD4                               23
      *
      ** No record read
      *
     C     *IN23         IFEQ      *ON
     C                   MOVEL     @RSESN        RSESN
     C                   MOVEL     @REVTP        REVTP
      *
      ** Due Date in DDMMMYY
      ** Convert Due Date entry parameter into Midas Day number
      *
     C                   MOVEL     @RDUDT        ZDATE1
     C                   CALL      'ZDATE1'
     C                   PARM      *BLANKS       ZERR              7
     C                   PARM                    ZDATE1            6 0
     C                   PARM      *BLANKS       ZDATFM            1
     C                   PARM                    ZDAYNO            5 0
      *
     C                   CALL      'ZDATE2'
     C                   PARM                    ZDAYNO            5 0
     C                   PARM      *BLANKS       ZDATFM            1
     C                   PARM                    @ZDAT2            6 0
     C                   PARM                    ZADATE            7
      *
     C                   MOVEL     ZADATE        RDUDT
     C                   MOVEL     ZADATE        WDUDT
      *
     C                   WRITE     XX118002D1
     C                   WRITE     XX118002D2
     C                   WRITE     XX118002D8
     C                   WRITE     XX118002D7
      *
     C                   ENDIF
      *
      ** First Record Read (Set up header)
      *
     C     *IN23         IFEQ      *OFF
      *
     C                   MOVEL     PSSH          WSESN
     C                   MOVE      PDUD          WDUD
     C                   MOVE      PEVT          WEVTP
     C                   MOVE      PBCA          WBRCH
     C                   MOVE      PRBA          WCTYP
      *
     C                   MOVEL     PSSH          RSESN
     C                   MOVEL     PEVT          REVTP
      *
      ** Due Date in DDMMMYY
      *
     C                   MOVEL     PDUD          ZDAYNO
     C                   CALL      'ZDATE2'
     C                   PARM                    ZDAYNO            5 0
     C                   PARM      *BLANKS       ZDATFM            1
     C                   PARM                    @ZDAT2            6 0
     C                   PARM                    ZADATE            7
      *
     C                   MOVEL     ZADATE        RDUDT
     C                   MOVEL     ZADATE        WDUDT
      *
     C                   WRITE     XX118002D1
     C                   WRITE     XX118002D2
     C                   ENDIF
      *
     C     *IN23         DOWEQ     *OFF
      *
     C                   EXSR      SRPRNT
      *
     C                   READ      POSETDD4                               23
      *
     C                   ENDDO
      *
     C     WCOUNT        IFNE      *ZERO
      *
      ** Write Total number of settlement accounts
      *
     C                   EXSR      SRCSBA
      *
      ** Write Total number of records read per security event
      *
     C                   EXSR      SRTOTL
      *
      ** Write End of Report
      *
     C                   EXSR      SRENDR
     C                   ENDIF
      *
      ** Return to calling program
      *
     C                   MOVE      *ON           *INLR
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRINIT - Initialisation Routine                              *
      *                                                               *
      *  Called By: Main Processing                                   *
      *                                                               *
      *****************************************************************
      *
     C     SRINIT        BEGSR
      *
     C     *DTAARA       DEFINE                  LDA
      *
      ** Convert Due Date entry parameter into Midas Day number
      *
     C                   MOVEL     @RDUDT        ZDATE1
     C                   CALL      'ZDATE1'
     C                   PARM      *BLANKS       ZERR              7
     C                   PARM                    ZDATE1            6 0
     C                   PARM      *BLANKS       ZDATFM            1
     C                   PARM                    ZDAYNO            5 0
      *
     C     ZERR          IFEQ      *BLANKS
     C                   Z-ADD     ZDAYNO        KDUDT             5 0
     C                   ENDIF
      *
     C                   Z-ADD     0             WCOUNT            4 0
      *
     C                   MOVE      *BLANKS       WSESN            10
     C                   MOVE      *ZEROS        WDUD              6 0
     C                   MOVE      *BLANKS       WEVTP             2
     C                   MOVE      *BLANKS       WBRCH             3
     C                   MOVE      *BLANKS       WCTYP             1
     C                   MOVE      *ZEROS        WTXAD            13 0
     C                   MOVE      *ZEROS        WPSAT            13 0
     C                   MOVE      *ZEROS        WTOTAL            4 0
     C                   MOVE      *BLANKS       WLVLDS
     C                   Z-ADD     *ZEROS        PAGE
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRUNAU  - Get records of all unauthorised position settlement*
      *            using the entry paramater (security, due date,     *
      *            event type) as key                                 *
      *            I/C                                                *
      *                                                               *
      *  Called By: Main Processing                                   *
      *                                                               *
      *****************************************************************
      *
     C     SRUNAU        BEGSR
      *
     C                   EXSR      RCFP1
      *
     C     KPOSET        SETLL     POSETDF
     C     KPOSET        READE     POSETDF                                88
      *
     C*****              MOVE      *BLANKS       SAVBA             3                          HUT118
      *
     C     *IN88         DOWEQ     '0'
     C                   MOVEL     *BLANKS       @KEY1
     C                   MOVEL     PCPY          @KEY1
      *
     C*****PBCA          IFNE      SAVBA                                                      HUT118
     C*****              MOVEL     PBCA          SAVBA                                        HUT118
     C*****              Z-ADD     0             @ERR                                         HUT118
     C*****              CALL      'ZVBBU'                                                    HUT118
     C*****              PARM      PBCA          @ZBRCD            3                          HUT118
     C*****              PARM                    @ERR              1 0                        HUT118
     C*****              ENDIF                                                                HUT118
      *
     C*****@ERR          IFEQ      0                                                          HUT118
      *
      ** Check customer details if customer is Private Banking Client or not
      *
     C                   CALL      'AOCUSTR1'
     C                   PARM      *BLANK        @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM                    @KEY1            10
     C                   PARM                    @KYST             7
     C     SDCUST        PARM      SDCUST        DSLDY
      *
     C     @RTCD         IFEQ      *BLANKS
     C     BBPRBA        IFEQ      *BLANKS
     C                   MOVEL     'N'           PRBA
     C                   ELSE
     C                   MOVEL     BBPRBA        PRBA
     C                   ENDIF
     C                   WRITE     POSETDD4
     C                   ENDIF
      *
     C*****              ENDIF
      *
     C     KPOSET        READE     POSETDF                                88
      *
     C                   ENDDO
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPRNT - Print Transaction Details                           *
      *                                                               *
      *  Called By: Main Processing                                   *
      *                                                               *
      *  Calls: SRBLNK, SRLOAD, SRTOTL, SRLSDE, SRCSBA, *PSSR         *
      *                                                               *
      *****************************************************************
      *
     C     SRPRNT        BEGSR
      *
      ** Determine which field has changed upon read to POSETDY4
      *
     C                   MOVE      *ALL'N'       WLVLDS
      *
     C                   SELECT
      *
     C     PSSH          WHENNE    WSESN
     C     PDUD          ORNE      WDUD
     C     PEVT          ORNE      WEVTP
     C                   MOVEL     'YNN'         WLVLDS
     C     PRBA          WHENNE    WCTYP
     C                   MOVEL     'NYN'         WLVLDS
     C     PBCA          WHENNE    WBRCH
     C                   MOVEL     'NNY'         WLVLDS
      *
     C                   ENDSL
      *
      ** At change of Security,Due Date,Event Type (for COB)
      *
     C     WL3           IFEQ      'Y'
     C                   EXSR      SRCSBA
     C                   EXSR      SRTOTL
     C                   EXSR      SRLSDE
     C                   ENDIF
      *
      ** At change of customer type (private banking customer)
      ** or change of branch
      *
     C     WL2           IFEQ      'Y'
     C     WL1           OREQ      'Y'
     C                   EXSR      SRCSBA
     C                   ENDIF
      *
      ** Load details onto detail line
      *
     C                   EXSR      SRBLNK
      *
     C     *IN60         IFEQ      *ON
     C                   WRITE     XX118002D1
     C                   MOVE      *OFF          *IN60
     C                   ENDIF
      *
     C                   EXSR      SRLOAD
      *
     C                   WRITE     XX118002D3
      *
     C                   MOVEL     PSSH          WSESN
     C                   MOVE      PDUD          WDUD
     C                   MOVE      PEVT          WEVTP
     C                   MOVE      PRBA          WCTYP
     C                   MOVE      PBCA          WBRCH
      *
      ** Accumulated settlement amount per branch
      *
     C                   ADD       PSAT          WPSAT
      *
      ** Count the records per security,due date, and event type
      *
     C                   ADD       1             WTOTAL
      *
      ** Count the records read
      *
     C                   ADD       1             WCOUNT
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRBLNK - Blank Out Detail Fields                             *
      *                                                               *
      *  Called By: SRPRNT                                            *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     SRBLNK        BEGSR
      *
     C                   MOVE      *BLANKS       RBRCH
     C                   MOVE      *BLANKS       RCUSN
     C                   MOVE      *BLANKS       RCTYP
     C                   MOVE      *BLANKS       RPTFR
     C                   MOVE      *BLANKS       RVLDT
     C                   MOVE      *ZEROS        RAMTD
     C                   MOVE      *BLANKS       RPSCU
     C                   MOVE      *ZEROS        RTXAD
     C                   MOVE      *ZEROS        RPSAT
     C                   MOVE      *BLANKS       RPSEA
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRLOAD - Load Detail Line                                    *
      *                                                               *
      *  Called By: SRPRNT                                            *
      *                                                               *
      *  Calls: ZFRPED                                                *
      *                                                               *
      *****************************************************************
      *
     C     SRLOAD        BEGSR
      *
      ** Booking Branch
      *
     C                   MOVEL     PBCA          RBRCH
      *
      ** Customer
      *
     C                   MOVE      PCPY          RCUSN
      *
      ** Customer Type
      *
     C     PRBA          IFEQ      'Y'
     C                   MOVEL     'Client'      RCTYP
     C                   ELSE
     C                   MOVEL     'Market'      RCTYP
     C                   ENDIF
      *
      ** Portfolio Reference
      *
     C                   MOVE      PTFR          RPTFR
      *
      ** Value Date in DDMMMYY
      *
     C                   Z-ADD     PSVL          ZDAYNO
     C                   CALL      'ZDATE2'
     C                   PARM                    ZDAYNO
     C                   PARM      *BLANKS       ZDATFM
     C                   PARM                    @ZDAT2
     C                   PARM                    ZADATE
      *
     C                   MOVEL     ZADATE        RVLDT
      *
      ** Amount Due
      * Retrieve number of decimal places
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      PNCY          PCCY              3
     C     SDCURR        PARM      SDCURR        DSLDY
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     PNCY          DBKEY
     C                   MOVEL     'SDCURRPD'    DBFILE
     C                   Z-ADD     2             DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      * Format Amount
     C                   MOVEL     A6NBDP        ZCDP
     C                   Z-ADD     PAMD          ZAMNT
     C                   MOVE      'Y'           ZCOMMA
     C                   MOVE      'N'           ZMINUS
     C                   EXSR      ZEDIT
     C                   MOVE      ZAMNTA        RAMTD
      *
      ** Settlement Currency
      *
     C                   MOVEL     PSCU          RPSCU
      *
      ** Tax Amount Deducted
      ** (Tax ded. @ source + Tax ded. @ srce ref. + Tax ded. by user)
      *
     C                   Z-ADD     TASO          WTXAD
     C     WTXAD         ADD       TASR          WTXAD
     C     WTXAD         ADD       TAUS          WTXAD
      * Format Amount
     C                   Z-ADD     WTXAD         ZAMNT
     C                   MOVE      'Y'           ZCOMMA
     C                   MOVE      'N'           ZMINUS
     C                   EXSR      ZEDIT
     C                   MOVE      ZAMNTA        RTXAD
      *
      ** Settlement Amount
      * Retrieve number of decimal places
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      PSCU          PCCY
     C     SDCURR        PARM      SDCURR        DSLDY
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     PSCU          DBKEY
     C                   MOVEL     'SDCURRPD'    DBFILE
     C                   Z-ADD     3             DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      * Format Amount
     C                   MOVEL     A6NBDP        ZCDP
     C                   Z-ADD     PSAT          ZAMNT
     C                   MOVE      'Y'           ZCOMMA
     C                   MOVE      'N'           ZMINUS
     C                   EXSR      ZEDIT
     C                   MOVE      ZAMNTA        RPSAT
      *
      ** Settlement Account
      *
     C                   SELECT
      *
      ** Nostro Account
      *
     C     PSMT          WHENEQ    1
     C     PSMT          OREQ      8
     C                   MOVEL     PSCU          NCCY
     C                   MOVEL     PSEA          NACSQ
     C                   MOVEL     WNOST         RPSEA
      *
      ** Retail Account
      *
     C     PSMT          WHENEQ    4
     C     PSMT          OREQ      14
     C                   MOVEL     PSEA          RPSEA
      *
      ** GL Account
      *
     C     PSMT          WHENEQ    5
     C                   MOVEL     PSEB          GBRCA
     C                   MOVEL     PSCU          GCCY
     C                   MOVEL     PSEA          GCUSN
     C                   MOVE      PSEA          GACSQ
     C                   MOVE      PSEA          WACCT            12
     C                   MOVEL     WACCT         GACOD
     C                   MOVEL     WGLACT        RPSEA
      *
     C                   ENDSL
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRLSDE - Load Security, Due date and Event Type              *
      *           (During COB only)                                   *
      *                                                               *
      *  Called By: SRPRNT                                            *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     SRLSDE        BEGSR
      *
     C     *IN60         IFEQ      *ON
     C                   WRITE     XX118002D1
     C                   MOVE      *OFF          *IN60
     C                   ENDIF
      *
      ** Security Shortname and Event Type
      *
     C                   MOVEL     PSSH          RSESN
     C                   MOVEL     PEVT          REVTP
      *
      ** Due Date in DDMMMYY
      *
     C                   Z-ADD     PDUD          ZDAYNO
     C                   CALL      'ZDATE2'
     C                   PARM                    ZDAYNO            5 0
     C                   PARM      *BLANKS       ZDATFM            1
     C                   PARM                    @ZDAT2            6 0
     C                   PARM                    ZADATE            7
      *
     C                   MOVEL     ZADATE        RDUDT
     C                   MOVEL     ZADATE        WDUDT             7
      *
     C                   WRITE     XX118002D2
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCSBA - Total Customer Settlement Amount per Branch         *
      *                                                               *
      *  Called By: SRPRNT                                            *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     SRCSBA        BEGSR
      *
     C     *IN60         IFEQ      *ON
     C                   WRITE     XX118002D1
     C                   MOVE      *OFF          *IN60
     C                   ENDIF
      *
     C                   MOVE      WBRCH         RBRCHA
      *
     C     WCTYP         IFEQ      'Y'
     C                   MOVEL     'Client'      RCTYPA
     C                   ELSE
     C                   MOVEL     'Market'      RCTYPA
     C                   ENDIF
      *
      ** Total Position Settlement per Branch
      *
      * Format Amount
     C                   MOVEL     A6NBDP        ZCDP
     C                   Z-ADD     WPSAT         ZAMNT
     C                   MOVE      'Y'           ZCOMMA
     C                   MOVE      'N'           ZMINUS
     C                   EXSR      ZEDIT
     C                   MOVE      ZAMNTA        RPSATA
     C                   MOVE      *ZEROS        WPSAT
      *
     C                   WRITE     XX118002D4
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRTOTL - Total Records read per Security Event               *
      *                                                               *
      *  Called By: Main Processing and SRPRNT                        *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     SRTOTL        BEGSR
      *
     C     *IN60         IFEQ      *ON
     C                   WRITE     XX118002D1
     C                   MOVE      *OFF          *IN60
     C                   ENDIF
      *
      ** Total Position Settlement records read per security event
      *
     C                   MOVE      WSESN         RSESNA
     C                   MOVE      WEVTP         REVTPA
     C                   MOVE      WDUDT         RDUDTA
     C                   Z-ADD     WTOTAL        RTOTAL
      *
      ** Initialise
      *
     C                   MOVE      *ZEROS        WTOTAL
      *
     C                   WRITE     XX118002D5
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRENDR - End of Report                                       *
      *                                                               *
      *  Called By: Main Processing                                   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     SRENDR        BEGSR
      *
      ** Write 'END OF REPORT'
      *
     C     *IN60         IFEQ      *ON
     C                   WRITE     XX118002D1
     C                   MOVE      *OFF          *IN60
     C                   ENDIF
      *
     C                   WRITE     XX118002D6
     C                   WRITE     XX118002D7
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation Routine                      *
      *                                                               *
      *  Called By: Implicitly on program activation                  *
      *                                                               *
      *  Calls: *PSSR                                                 *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
     C                   PARM                    @SEQN             5
     C                   PARM                    @RPARM          100
      *
     C                   MOVEA     CPY@          CPY2@            80
      *
     C                   MOVEL     'XX118002'    DBPGM
      *
      ** Read RUNDAT for multi-branching indicator
      *
     C                   IN        RUNDAT
     C     *DTAARA       DEFINE                  RUNDAT           13
      *
     C                   CALL      'SFC0400'
      *
      ** Access Bank Details
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM      '*FIRST  '    POPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Database Error
      *
     C     PRTCD         IFNE      *BLANKS
     C                   MOVEL     POPTN         DBKEY
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   Z-ADD     1             DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C     BJDFIN        IFEQ      'M'
     C                   MOVE      *ON           *IN98
     C                   ENDIF
      *
     C     KPOSET        KLIST
     C                   KFLD                    @RSESN
     C                   KFLD                    KDUDT
     C                   KFLD                    @REVTP
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  RCFP1 - Subroutine to register P1 or P2 printer file via RCF *
      *                                                               *
      *****************************************************************
      *
     C     RCFP1         BEGSR
      *
      **      ENSURE REPORT SPOOL FILE RECORDED BY RCF
      *
     C                   OPEN      XX118002P1
     C                   MOVEL     SFILE1        ZFILE
     C                   Z-ADD     SFNUM1        ZSNUM
      *
     C                   CALL      'ZSFILE'
     C                   PARM                    @SEQN
     C                   PARM      *BLANK        ZENTY             3
     C                   PARM                    ZFILE            10
     C                   PARM                    ZSNUM             6 0
     C                   PARM                    ZSERR             1
      *
     C     ZSERR         IFEQ      'Y'
      *
      **  Error during ZSFILE processing, return to calling program
      *
     C                   SETON                                        U7U8LR
     C                   RETURN
     C                   END
      *
     C                   ENDSR
      *
     C********************************************************************
      /EJECT
     C********************************************************************
     C**
     C*
     C*  ZEDIT SR. SUBROUTINE TO EDIT AN AMOUNT FIELD FOR OUTPUT
     C*
     C*  CALLED BY: BASFMT, ENQFMT
     C*
     C*  INPUT FIELDS:
     C*                    ZAMNT  15 0    AMOUNT FIELD TO BE EDITED
     C*                    ZCDP    1,0    NO. OF DECIMAL PLACES
     C*                    ZCOMMA  1 A    COMMAS WANTED ('Y' OR 'N')
     C*                    ZMINUS  1 A    MINUS SIGN WANTED ('Y' OR 'N')
     C*
     C*  OUTPUT FIELDS:
     C*                    ZAMNTA 21 A    EDITED AMOUNT FIELD
     C*
     C*  INDICATOR USED:
     C*                    *IN94          SETON IF NON-ZERO CHARACTER
     C*                                   FOUND IN THE AMOUNT
     C*
     C     ZEDIT         BEGSR                                                  ***  ZEDIT  ***
     C*
     C                   Z-ADD     ZAMNT         ZAMNT            15 0          I/P FIELD
     C                   MOVE      ZCOMMA        ZCOMMA            1            VALUE Y OR N
     C                   MOVE      ZMINUS        ZMINUS            1            VALUE Y OR N
     C                   Z-ADD     ZCDP          ZCDP              1 0          NO. OF DPs.
     C                   MOVE      *BLANK        ZAMNTA           21            O/P FIELD
     C                   MOVE      '0'           *IN94
     C*
     C                   MOVE      *BLANK        ZAMNTB           16            NON-COMMA EDIT
     C                   MOVE      *BLANK        ZAMNTC           20            NON-COMMA EDIT
     C                   MOVE      *BLANK        ZAMNTD           17            NON-COMMA EDIT
     C                   MOVE      *BLANK        ZFLD3            16            NON-COMMA EDIT
     C                   MOVE      '00000000'    ZFLD1            15
     C                   MOVEL     '0000000'     ZFLD1
     C                   MOVE      *BLANK        ZFLD2            20
     C                   MOVE      ' '           ZMINS             1            MINUS CHARCTER
     C                   MOVEA     *BLANK        ZEDT
     C                   MOVEA     *BLANK        ZED2
     C                   MOVEA     *BLANK        ZAMT
     C                   MOVEA     *BLANK        Z3
     C*
     C*  INCLUDE MINUS SIGN IF NEEDED
     C*  PROCESS AMOUNT AS A POSTIVE NUMBER EVEN IF NEGATIVE
     C     ZMINUS        IFEQ      'Y'                                          **** B1
     C     ZAMNT         IFLT      0                                            **** B2
     C                   MOVE      '-'           ZMINS
     C                   Z-SUB     ZAMNT         ZAMNT
     C                   ELSE                                                   **** X2
     C                   MOVE      ' '           ZMINS
     C                   END                                                    **** E2
     C                   ELSE                                                   **** X2
     C     ZAMNT         IFLT      0                                            **** B2
     C                   Z-SUB     ZAMNT         ZAMNT
     C                   END                                                    **** E2
     C                   END                                                    **** E1
     C*
     C*  SEPARATE INTEGER AND DECIMAL PARTS OF AMOUNT
     C*  - ZERO DECIMAL PLACES
     C     ZCDP          IFEQ      0                                            **** B1
     C                   MOVE      ZAMNT         ZFLD1
     C                   ELSE
     C*
     C*  - ONE DECIMAL PLACE
     C     ZCDP          IFEQ      1                                            **** B2
     C                   MOVE      ZAMNT         ZDEC1             1
     C                   MOVEL     ZAMNT         ZAMT1            14
     C                   MOVE      ZAMT1         ZFLD1
     C                   ELSE
     C*
     C*  - TWO DECIMAL PLACES
     C     ZCDP          IFEQ      2                                            **** B3
     C                   MOVE      ZAMNT         ZDEC2             2
     C                   MOVEL     ZAMNT         ZAMT2            13
     C                   MOVE      ZAMT2         ZFLD1
     C                   ELSE
     C*
     C*  - THREE DECIMAL PLACES
     C     ZCDP          IFEQ      3                                            **** B4
     C                   MOVE      ZAMNT         ZDEC3             3
     C                   MOVEL     ZAMNT         ZAMT3            12
     C                   MOVE      ZAMT3         ZFLD1
     C                   ELSE
     C*
     C*  - EIGHT DECIMAL PLACES
     C     ZCDP          IFEQ      8                                            **** B5
     C                   MOVE      ZAMNT         ZDEC8             8
     C                   MOVEL     ZAMNT         ZAMT8             7
     C                   MOVE      ZAMT8         ZFLD1
     C                   END                                                    **** E5
     C                   END                                                    **** E4
     C                   END                                                    **** E3
     C                   END                                                    **** E2
     C                   END                                                    **** E1
     C*
     C*  MOVE THE INTEGER FIELD INTO A 5X3 ARRAY FOR EDITING
     C                   MOVEA     ZFLD1         ZAMT
     C*
     C/SPACE 3
     C*
     C****
     C*
     C*  CHECK IF COMMAS ARE NEEDED OR NOT
     C*
     C****
     C     ZCOMMA        IFEQ      'Y'                                          **** E1
     C****
     C*
     C*  IF ZCOMMA  IS 'Y' MOVE COMMAS ETC. INTO A 5X4 EDITED ARRAY
     C*  (FOR ZERO DECIMAL PLACES DO NOT WANT A DECIMAL POINT)
     C*
     C     ZCDP          IFEQ      0                                            **** B2
     C                   MOVEA     ZCOM(1)       ZEDT
     C                   ELSE
     C                   MOVEA     ZCOM(2)       ZEDT
     C                   END                                                    **** E2
     C*
     C*
     C*  READ THROUGH AMOUNT ARRAY SO AS TO PLACE EDITED DIGITS
     C*  INTO ZEDT. THE ARRAY IS READ 3 CHARACTERS AT A TIME.
     C*  ALL LEADING ZEROES ARE SUPPRESSED.
     C                   DO        5             Z                 1 0          **** B2
     C*
     C     *IN94         IFEQ      '1'                                          **** B3
     C                   MOVEL     ZAMT(Z)       ZEDT(Z)
     C                   ELSE
     C*
     C*  BLANK OUT EDITED FIELD IF ZEROES ARE FOUND
     C     ZAMT(Z)       IFEQ      '000'                                        **** B4
     C     Z             IFNE      5                                            **** B5
     C                   MOVE      '    '        ZEDT(Z)
     C                   END                                                    **** E5
     C                   ELSE
     C*
     C*  WHEN FIRST NON ZERO CHARACTERS ARE REACHED REMOVE LEADING
     C*  ZEROES. READ ARRAY ELEMENT 1 CHARACTER AT A TIME.
     C                   MOVE      '1'           *IN94
     C                   Z-ADD     1             ZN                1 0
     C                   MOVEA     ZAMT(Z)       Z3
     C     Z3(ZN)        DOWEQ     '0'                                          **** B5
     C                   MOVE      ' '           Z3(ZN)
     C                   ADD       1             ZN
     C                   END                                                    **** E5
     C                   MOVEA     Z3            ZEDT(Z)
     C                   END                                                    **** E4
     C                   END                                                    **** E3
     C                   END                                                    **** E2
     C*
     C*  PLACE EDITED ARRAY INTO ALPHA FIELD TO INCLUDE DECIMALS.
     C                   MOVEA     ZEDT          ZFLD2
     C*
     C*  - ZERO DECIMAL PLACES
     C     ZCDP          IFEQ      0                                            **** B2
     C                   MOVEL     ZFLD2         ZAMT0            19
     C                   MOVE      ZAMT0         ZAMNTC
     C                   ELSE
     C*
     C*  - ONE DECIMAL PLACE
     C     ZCDP          IFEQ      1                                            **** B3
     C                   MOVE      ZFLD2         ZAMT1A           19
     C                   MOVEL     ZAMT1A        ZAMNTC
     C                   MOVE      ZDEC1         ZAMNTC
     C                   ELSE
     C*
     C*  - TWO DECIMAL PLACES
     C     ZCDP          IFEQ      2                                            **** B4
     C                   MOVE      ZFLD2         ZAMT2A           18
     C                   MOVEL     ZAMT2A        ZAMNTC
     C                   MOVE      ZDEC2         ZAMNTC
     C                   ELSE
     C*
     C*  - THREE DECIMAL PLACES
     C     ZCDP          IFEQ      3                                            **** B5
     C                   MOVE      ZFLD2         ZAMT3A           17
     C                   MOVEL     ZAMT3A        ZAMNTC
     C                   MOVE      ZDEC3         ZAMNTC
     C                   ELSE
     C*
     C*  - EIGHT DECIMAL PLACES
     C     ZCDP          IFEQ      8                                            **** B6
     C                   MOVE      ZFLD2         ZAMT8A           12
     C                   MOVEL     ZAMT8A        ZAMNTC
     C                   MOVE      ZDEC8         ZAMNTC
     C                   END                                                    **** E6
     C                   END                                                    **** E5
     C                   END                                                    **** E4
     C                   END                                                    **** E3
     C                   END                                                    **** E2
     C*
     C*  INCLUDE MINUS SIGN IF NEEDED
     C     ZMINUS        IFEQ      'Y'                                          **** B2
     C                   MOVEL     ZAMNTC        ZAMNTA
     C                   MOVE      ZMINS         ZAMNTA
     C                   ELSE                                                   **** X2
     C                   MOVE      ZAMNTC        ZAMNTA
     C                   END                                                    **** E2
     C*
     C****                                                 ****
     C*
     C                   ELSE                                                   **** X1
     C*
     C****                                                 ****
     C*
     C*  ELSE IF ZCOMMA EQUAL 'N':
     C*  MOVE FORMAT LEFT INTO A 6X3 ARRAY - 6TH ELEMENT CONTAINS D.P.
     C*  (FOR ZERO DECIMAL PLACES DO NOT WANT A DECIMAL POINT)
     C     ZCDP          IFEQ      0                                            **** B2
     C                   MOVEA     ZCOM(3)       ZED2
     C                   ELSE
     C                   MOVEA     ZCOM(4)       ZED2
     C                   END                                                    **** E2
     C*
     C*
     C*  READ THROUGH AMOUNT ARRAY SO AS TO PLACE EDITED DIGITS
     C*  INTO ZED2. THE ARRAY IS READ 3 CHARACTERS AT A TIME.
     C*  ALL LEADING ZEROES ARE SUPPRESSED.
     C                   DO        5             Z                 1 0          **** B2
     C*
     C     *IN94         IFEQ      '1'                                          **** B3
     C                   MOVEL     ZAMT(Z)       ZED2(Z)
     C                   ELSE
     C*
     C*  SEARCH FOR FIRST NONE-ZERO CHARACTERS
     C     ZAMT(Z)       IFNE      '000'                                        **** B4
     C*
     C*  WHEN FIRST NON ZERO CHARACTERS ARE REACHED REMOVE LEADING
     C*  ZEROES. READ ARRAY ELEMENT 1 CHARACTER AT A TIME.
     C                   MOVE      '1'           *IN94
     C                   Z-ADD     1             ZN                1 0
     C                   MOVEA     ZAMT(Z)       Z3
     C     Z3(ZN)        DOWEQ     '0'                                          **** B5
     C                   MOVE      ' '           Z3(ZN)
     C                   ADD       1             ZN
     C                   END                                                    **** E5
     C                   MOVEA     Z3            ZED2(Z)
     C                   END                                                    **** E4
     C                   END                                                    **** E3
     C                   END                                                    **** E2
     C*
     C*  PLACE EDITED ARRAY INTO ALPHA FIELD TO INCLUDE DECIMALS.
     C                   MOVEA     ZED2          ZFLD3
     C*
     C*  - ZERO DECIMAL PLACES
     C     ZCDP          IFEQ      0                                            **** B2
     C                   MOVEL     ZFLD3         ZAMT0B           15
     C                   MOVE      ZAMT0B        ZAMNTB
     C                   ELSE
     C*
     C*  - ONE DECIMAL PLACE
     C     ZCDP          IFEQ      1                                            **** B3
     C                   MOVE      ZFLD3         ZAMT1B           15
     C                   MOVEL     ZAMT1B        ZAMNTB
     C                   MOVE      ZDEC1         ZAMNTB
     C                   ELSE
     C*
     C*  - TWO DECIMAL PLACES
     C     ZCDP          IFEQ      2                                            **** B4
     C                   MOVE      ZFLD3         ZAMT2B           14
     C                   MOVEL     ZAMT2B        ZAMNTB
     C                   MOVE      ZDEC2         ZAMNTB
     C                   ELSE
     C*
     C*  - THREE DECIMAL PLACES
     C     ZCDP          IFEQ      3                                            **** B5
     C                   MOVE      ZFLD3         ZAMT3B           13
     C                   MOVEL     ZAMT3B        ZAMNTB
     C                   MOVE      ZDEC3         ZAMNTB
     C                   ELSE
     C*
     C*  - EIGHT DECIMAL PLACES
     C     ZCDP          IFEQ      8                                            **** B6
     C                   MOVE      ZFLD3         ZAMT8B            8
     C                   MOVEL     ZAMT8B        ZAMNTB
     C                   MOVE      ZDEC8         ZAMNTB
     C                   END                                                    **** E6
     C                   END                                                    **** E5
     C                   END                                                    **** E4
     C                   END                                                    **** E3
     C                   END                                                    **** E2
     C*
     C*  INCLUDE MINUS SIGN IF NEEDED
     C     ZMINUS        IFEQ      'Y'                                          **** B2
     C                   MOVEL     ZAMNTB        ZAMNTD
     C                   MOVE      ZMINS         ZAMNTD
     C                   ELSE                                                   **** X2
     C                   MOVE      ZAMNTB        ZAMNTD
     C                   END                                                    **** E2
     C*
     C*  FINALLY MOVE NON-COMMA EDITED FIELD INTO O/P FIELD
     C                   MOVE      ZAMNTD        ZAMNTA
     C*
     C****
     C                   END                                                    **** E1
     C****
     C                   ENDSR
     C*
     C**
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR - Program Exception Error Routine                      *
      *                                                               *
      *  Called By: *INZSR, SRPRNT                                    *
      *                                                               *
      *  Calls: SRAUDT                                                *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C     WRUN          IFEQ      *BLANK
     C                   MOVE      'Y'           WRUN              1
     C                   DUMP
     C                   ENDIF
      *
     C                   MOVE      *ON           *INU7
     C                   MOVE      *ON           *INU8
     C                   MOVE      *ON           *INLR
      *
     C                   RETURN
      *
     C                   ENDSR
      *
      *****************************************************************
** CPY@
(c) Finastra International Systems Ltd. 2020
**   ZCOM - EDIT FORMAT FOR AMOUNT FIELD
   ,   ,   ,   ,  0
   ,   ,   ,   ,  0.
              0
              0.
