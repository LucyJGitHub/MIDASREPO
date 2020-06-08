     H DEBUG
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SE Unauth/Authorised Today Pos Sett Report')     *
      *****************************************************************
      *                                                               *
      *  Midas - Security Trading Module                              *
      *                                                               *
      ***SEH024 - Midas SE Unauth/Authorised Today Pos Sett Report    *                    HUT105
      *  XX105024 - Midas SE Unauth/Authorised Today Pos Sett Report  *                    HUT105
      *                                                               *
      *  Function:  This program list all unauthorised position       *
      *             settlements or position settlements authorised    *
      ***********   today from file POSETDX4.                         *                    HUT105
      *             today from file XXPOSEX4.                         *                    HUT105
      *                                                               *
      ***(c)*Misys*International*Banking*Systems*Ltd.*2008*************                    HUT105
      *  (c) Finastra International Systems Ltd. 2020                 *                    HUT105
      *                                                               *
      *  Last Amend No. HUT105             Date 07Apr20               *
      *  Prev Amend No. AR836848           Date 06Oct11               *
      *                 HUT015I01          Date 27Aug10               *
      *                 HUT015             Date 01Jul10               *
      *                 261221             Date 23Jul09               *
      *                 259148A            Date 14Apr09               *
      *                 259148             Date 05Mar09               *
      *                 258825             Date 11Feb09               *
      *                 258113             Date 14Jan09               *
      *                 HUT011I09          Date 11Sep08               *
      *                 HUT011I02          Date 11Jun08               *
      *                 HUT011  *CREATE    Date 12May08               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  HUT105 - Bulk Position Settlement Authorisation              *                    HUT105
      *           (Upgrade HUT011/015 to FM2.1 SP22)                  *                    HUT105
      *  AR836848 - Reports SEH024P1/SEH024P2 generated in the bulk   *
      *             authorisation screen must reflect only those      *
      *             transactions, that the generating user is only    *
      *             authorised to. (Child: AR836849)                  *
      *  HUT015I01 - changed indicator on chain procedure to avoid    *
      *              print overflow conflict.                         *
      *  HUT015 - 4eyes on Bulk Position Settlement Function          *
      *  261221  - Recompiled under the correct printer files.        *
      *  259148A - Recompiled due to changes in POSETV2 and POSETV3.  *
      *  259148 - Validate settlement account and value date.         *
      *  258825 - Wrong decimal place for Amount Due.                 *
      *  258113 - Recompiled due to changes in POSETV2, POSETV3 and   *
      *           POSETDY4.                                           *
      *  HUT011I09 - Amount decimal place formatting error            *
      *  HUT011I02 - Prompt the standard RCF screen.                  *
      *  HUT011 - Bulk Position Settlement Authorisation              *
      *                                                               *
      *****************************************************************
     F**********POSETV2 IF  E           K        DISK                                        HUT105
     FXXPOSEL2  IF   E           K DISK                                                      HUT105
      ** Position Settlements file (PAUI = ' ')
      ** and (RECI = 'D')                                                                    259148A
      *
     F**********POSETV3 IF  E           K        DISK                                        HUT105
     FXXPOSEL3  IF   E           K DISK                                                      HUT105
     F                                     RENAME(POSETDF:POSETDF3)
      ** Position Settlements file (PAUI = 'Y')
      ** and (RECI = 'D')                                                                    259148A
      *
     F**********POSETDY4UF  E           K        DISK                      A                 HUT105
     FXXPOSEV4  UF A E           K DISK                                                      HUT105
      ** Position Settlements - Client/Market
      *
     FPSAUT     IF   E           K DISK                                                       HUT015
      ** Midas SE Position Settlement Authorisation detail                                    HUT015
      *                                                                                       HUT015
     F**********SEH024P1O   E             60     PRINTER      KINFDS SPOOL1     UC
     F**********SEH024P1  O    E             PRINTER INFDS(SPOOL1)                            HUT105
     FXX105024P1O    E             PRINTER INFDS(SPOOL1)                                      HUT105
     F                                     OFLIND(*IN60)
     F                                     USROPN
      ** Midas SE Unauthorised Position Settlemens Report
      *
     F**********SEH024P2  O    E             PRINTER INFDS(SPOOL2)                            HUT105
     FXX105024P2O    E             PRINTER INFDS(SPOOL2)                                      HUT105
     F                                     OFLIND(*IN61)
     F                                     USROPN
      ** Midas SE Position Settlements Authorised Today Rpt
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
      ***23*****-*READ*Indicator*for*POSETDY4**************************                  HUT105
      ***88*****-*READ*Indicator*for*POSETV2*or*POSETV3****************                  HUT105
      ***60*****-*OVERFLOW*Indicator*for*SEH024P1**********************                  HUT105
      ***61*****-*OVERFLOW*Indicator*for*SEH024P2**********************                  HUT105
      *  23     - READ Indicator for XXPOSEV4                         *                  HUT105
      *  88     - READ Indicator for XXPOSEL2 or XXPOSEL3             *                  HUT105
      *  60     - OVERFLOW Indicator for XX105024P1                   *                  HUT105
      *  61     - OVERFLOW Indicator for XX105024P2                   *                  HUT105
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
      ***SRUNAU*-*Get*records*in*POSETV2*using*entry*parm*as*key*******                  HUT105
      ***SRAUTI*-*Get*records*in*POSETV3*usign*entry*parm*as*key*******                  HUT105
      ***SRAUTC*-*Get*records*in*POSETV3*during*COB********************                  HUT105
      ***SRLSDE*-*Load*SEH241D2*or*SEH242D2****************************                  HUT105
      *  SRUNAU - Get records in XXPOSEL2 using entry parm as key     *                  HUT105
      *  SRAUTI - Get records in XXPOSEL3 usign entry parm as key     *                  HUT105
      *  SRAUTC - Get records in XXPOSEL3 during COB                  *                  HUT105
      *  SRLSDE - Load XX105024D*                                     *                  HUT105
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
      *                                                                                       HUT015
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
     D  @RSEQN                 1      5
     D  @RSESN                 6     15
     D  @RDUDT                16     21
     D  @REVTP                22     23
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
     D*POSET4***     E DS                  EXTNAME(POSETDX4)                             IUM105
     D POSET4        E DS                  EXTNAME(XXPOSEX4)                             IUM105
      ** Position Settlement file - Client/Market
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
     I*COPY*ZSRSRC*ZFRPEDZ2                                                              HUT105
     I/COPY ZSRSRC,ZFRPEDZ1LE                                                            HUT105
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
      ***Extract records from POSETV2 or POSETV3
      ** Extract records from XXPOSEL2 or XXPOSEL3
      *
     C                   SELECT
     C     @RSEQN        WHENEQ    '10001'
     C                   EXSR      SRUNAU
     C     @RSEQN        WHENEQ    '10002'
     C                   EXSR      SRAUTI
     C                   OTHER
     C                   EXSR      SRAUTC
     C                   ENDSL
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
     C                   SELECT
     C     @RSEQN        WHENEQ    '10001'
     C**********         WRITE     SEH241D1                                              HUT105
     C**********         WRITE     SEH241D2                                              HUT105
     C**********         WRITE     SEH241D8                                              HUT105
     C**********         WRITE     SEH241D7                                              HUT105
     C                   WRITE     XX105241D1                                            HUT105
     C                   WRITE     XX105241D2                                            HUT105
     C                   WRITE     XX105241D8                                            HUT105
     C                   WRITE     XX105241D7                                            HUT105
      *
     C     @RSEQN        WHENEQ    '10002'
     C**********         WRITE     SEH242D1                                              HUT105
     C**********         WRITE     SEH242D2                                              HUT105
     C**********         WRITE     SEH242D8                                              HUT105
     C**********         WRITE     SEH242D7                                              HUT105
     C                   WRITE     XX105242D1                                            HUT105
     C                   WRITE     XX105242D2                                            HUT105
     C                   WRITE     XX105242D8                                            HUT105
     C                   WRITE     XX105242D7                                            HUT105
      *
     C                   OTHER
     C**********         WRITE     SEH242D1                                              HUT105
     C**********         WRITE     SEH242D8                                              HUT105
     C**********         WRITE     SEH242D7                                              HUT105
     C                   WRITE     XX105242D1                                            HUT105
     C                   WRITE     XX105242D8                                            HUT105
     C                   WRITE     XX105242D7                                            HUT105
     C                   ENDSL
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
     C     @RSEQN        IFEQ      '10001'
     C**********         WRITE     SEH241D1                                              HUT105
     C**********         WRITE     SEH241D2                                              HUT105
     C                   WRITE     XX105241D1                                            HUT105
     C                   WRITE     XX105241D2                                            HUT105
     C                   ELSE
     C**********         WRITE     SEH242D1                                              HUT105
     C**********         WRITE     SEH242D2                                              HUT105
     C                   WRITE     XX105242D1                                            HUT105
     C                   WRITE     XX105242D2                                            HUT105
     C                   ENDIF
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
      *                                                                                       HUT015
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
      *                                                                                       HUT015
      **Obtain*switchable*feature*HUT015 status.                                       HUT015 HUT105
      *                                                                                       HUT015
     C**********         CALL      'AOSARDR0'                                          HUT015 HUT105
     C**********         PARM      *BLANKS       @RTCD             7                   HUT015 HUT105
     C**********         PARM      '*VERIFY'     @OPTN             7                   HUT015 HUT105
     C**********         PARM      'HUT015'      @SARD             6                   HUT015 HUT105
     C*****SCSARD        PARM      SCSARD        DSFDY                                 HUT015 HUT105
      *                                                                                       HUT015
     C**********         SELECT                                                        HUT015 HUT105
     C*****@RTCD         WHENEQ    *BLANK                                              HUT015 HUT105
     C**********         MOVE      'Y'           HUT015            1                   HUT015 HUT105
     C*****@RTCD         WHENEQ    '*NRF'                                              HUT015 HUT105
     C**********         MOVE      'N'           HUT015                                HUT015 HUT105
     C**********         OTHER                                                         HUT015 HUT105
     C******LOCK         IN        LDA                                                 HUT015 HUT105
     C**********         MOVEL     'SCSARDPD'    DBFILE                  ************* HUT015 HUT105
     C**********         Z-ADD     004           DBASE                   *DBERROR 004* HUT015 HUT105
     C**********         MOVEL     @OPTN         DBKEY                   ************* HUT015 HUT105
     C**********         SETON                                        U7U8LR           HUT015 HUT105
     C**********         OUT       LDA                                                 HUT015 HUT105
     C**********         EXSR      *PSSR                                               HUT015 HUT105
     C**********         ENDSL                                                         HUT015 HUT105
      *                                                                                       HUT015
     C     KPSAUT        KLIST
     C                   KFLD                    PBCA
     C                   KFLD                    PSSH
     C                   KFLD                    PCPY
     C                   KFLD                    PDUD
     C                   KFLD                    PEVT
     C                   KFLD                    PTFR
     C                   KFLD                    TNLU
     C                   KFLD                    TXBS
     C                   KFLD                    BNFO
     C                   KFLD                    EXCD
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
      *                                                                                     AR836848
     C                   MOVE      *BLANKS       SAVBA             3
      *
     C     *IN88         DOWEQ     '0'
     C                   MOVEL     *BLANKS       @KEY1
     C                   MOVEL     PCPY          @KEY1
      *                                                                                     AR836848
     C     PBCA          IFNE      SAVBA
     C                   MOVEL     PBCA          SAVBA
     C                   Z-ADD     0             @ERR
     C                   CALL      'ZVBBU'
     C                   PARM      PBCA          @ZBRCD            3
     C                   PARM                    @ERR              1 0
     C                   ENDIF
      *                                                                                     AR836848
     C     @ERR          IFEQ      0
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
      *                                                                                     AR836848
     C                   ENDIF
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
      *  SRAUTI  - Get records of all authorised position settlements *
      *            using the entry paramater (security, due date,     *
      *            event type) as key                                 *
      *            I/C                                                *
      *                                                               *
      *  Called By: Main Processing                                   *
      *                                                               *
      *****************************************************************
      *
     C     SRAUTI        BEGSR
      *
     C                   EXSR      RCFP1
      *
     C     KPOSET        SETLL     POSETDF3
     C     KPOSET        READE     POSETDF3                               88
      *                                                                                     AR836848
     C                   MOVE      *BLANKS       SAVBA
      *
     C     *IN88         DOWEQ     '0'
     C     CHTP          IFEQ      'Y'
     C     LCD           ANDEQ     BJRDNB
      *
     C                   MOVEL     *BLANKS       @KEY1
     C                   MOVEL     PCPY          @KEY1
      *                                                                                     AR836848
     C     PBCA          IFNE      SAVBA
     C                   MOVEL     PBCA          SAVBA
     C                   Z-ADD     0             @ERR
     C                   CALL      'ZVBBU'
     C                   PARM      PBCA          @ZBRCD
     C                   PARM                    @ERR
     C                   ENDIF
      *                                                                                     AR836848
     C     @ERR          IFEQ      0
      *
      ** Check customer details if customer is Private Banking Client or not
      *
     C                   CALL      'AOCUSTR1'
     C                   PARM      *BLANK        @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM                    @KEY1
     C                   PARM                    @KYST
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
      *                                                                                     AR836848
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     KPOSET        READE     POSETDF3                               88
      *
     C                   ENDDO
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAUTC  - Get records of all authorised position settlements *
      *            (During COB)                                       *
      *                                                               *
      *  Called By: Main Processing                                   *
      *                                                               *
      *****************************************************************
      *
     C     SRAUTC        BEGSR
      *
     C**********         OPEN      SEH024P2                                              HUT105
     C                   OPEN      XX105024P2                                            HUT105
      *
     C     *LOVAL        SETLL     POSETDF3
     C                   READ      POSETDF3                               88
      *
     C     *IN88         DOWEQ     '0'
     C     CHTP          IFEQ      'Y'
     C     LCD           ANDEQ     BJRDNB
      *
     C                   MOVEL     *BLANKS       @KEY1
     C                   MOVEL     PCPY          @KEY1
      *
      ** Check customer details if customer is Private Banking Client or not
      *
     C                   CALL      'AOCUSTR1'
     C                   PARM      *BLANK        @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM                    @KEY1
     C                   PARM                    @KYST
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
     C                   ENDIF
      *
     C                   READ      POSETDF3                               88
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
     C     *IN61         OREQ      *ON
     C     @RSEQN        IFEQ      '10001'
     C**********         WRITE     SEH241D1                                              HUT105
     C                   WRITE     XX105241D1                                            HUT105
     C                   MOVE      *OFF          *IN60
     C                   ELSE
     C**********         WRITE     SEH242D1                                              HUT105
     C                   WRITE     XX105242D1                                            HUT105
     C                   MOVE      *OFF          *IN61
     C                   ENDIF
     C                   ENDIF
      *
     C                   EXSR      SRLOAD
      *
     C     @RSEQN        IFEQ      '10001'
     C**********         WRITE     SEH241D3                                              HUT105
     C                   WRITE     XX105241D3                                            HUT105
     C*****HUT015        IFEQ      'Y'                                                   HUT105
     C**********         WRITE     SEH241DB                                              HUT105
     C                   WRITE     XX105241DB                                            HUT105
     C**********         ENDIF                                                           HUT105
     C                   ELSE
     C**********         WRITE     SEH242D3                                              HUT105
     C                   WRITE     XX105242D3                                            HUT105
     C                   ENDIF
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
      * Retrieve number of decimal places                                                  HUT011I09
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C**********           PARM PSCU      PCCY    3                                 HUT011I09 258825
     C                   PARM      PNCY          PCCY              3
     C     SDCURR        PARM      SDCURR        DSLDY
      *
     C     @RTCD         IFNE      *BLANKS
     C**********           MOVELPSCU      DBKEY                                     HUT011I09 258825
     C                   MOVEL     PNCY          DBKEY
     C                   MOVEL     'SDCURRPD'    DBFILE
     C                   Z-ADD     2             DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *                                                                                    HUT011I09
      * Format Amount                                                                      HUT011I09
     C                   MOVEL     A6NBDP        ZCDP
     C                   Z-ADD     PAMD          ZAMNT
     C                   MOVE      'Y'           ZCOMMA
     C                   MOVE      'N'           ZMINUS
     C                   EXSR      ZEDIT
     C                   MOVE      ZAMNTA        RAMTD
      *                                                                                    HUT011I09
     C**********           MOVE PAMD      RAMTD                                            HUT011I09
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
      * Format Amount                                                                      HUT011I09
     C                   Z-ADD     WTXAD         ZAMNT
     C                   MOVE      'Y'           ZCOMMA
     C                   MOVE      'N'           ZMINUS
     C                   EXSR      ZEDIT
     C                   MOVE      ZAMNTA        RTXAD
     C**********           MOVE WTXAD     RTXAD                                            HUT011I09
      *
      ** Settlement Amount
      * Retrieve number of decimal places                                                     258825
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      PSCU          PCCY
     C     SDCURR        PARM      SDCURR        DSLDY
      *                                                                                       258825
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     PSCU          DBKEY
     C                   MOVEL     'SDCURRPD'    DBFILE
     C                   Z-ADD     3             DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      * Format Amount                                                                      HUT011I09
     C                   MOVEL     A6NBDP        ZCDP
     C                   Z-ADD     PSAT          ZAMNT
     C                   MOVE      'Y'           ZCOMMA
     C                   MOVE      'N'           ZMINUS
     C                   EXSR      ZEDIT
     C                   MOVE      ZAMNTA        RPSAT
      *
     C**********           MOVE PSAT      RPSAT                                            HUT011I09
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
     C*****HUT015        IFEQ      'Y'                                                        HUT105
      *                                                                                       HUT015
     C********** KPSAUT    CHAINPSAUT                60                             HUT015 HUT015I01
     C     KPSAUT        CHAIN     PSAUT                              16                      HUT015
      *                                                                                       HUT015
     C********** *IN60     IFEQ *OFF                                                HUT015 HUT015I01
     C     *IN16         IFEQ      *OFF                                                       HUT015
     C                   MOVE      PALUSR        RLUSR                                        HUT015
     C                   ELSE                                                                 HUT015
     C                   MOVE      *BLANKS       RLUSR                                        HUT015
     C                   ENDIF                                                                HUT015
      *                                                                                       HUT015
     C**********         ENDIF                                                                HUT105
      *                                                                                       HUT015
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
     C     *IN61         OREQ      *ON
     C     @RSEQN        IFEQ      '10001'
     C**********         WRITE     SEH241D1                                              HUT105
     C                   WRITE     XX105241D1                                            HUT105
     C                   MOVE      *OFF          *IN60
     C                   ELSE
     C**********         WRITE     SEH242D1                                              HUT105
     C                   WRITE     XX105242D1                                            HUT105
     C                   MOVE      *OFF          *IN61
     C                   ENDIF
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
     C     @RSEQN        IFEQ      '10001'
     C**********         WRITE     SEH241D2                                              HUT105
     C                   WRITE     XX105241D2                                            HUT105
     C                   ELSE
     C**********         WRITE     SEH242D2                                              HUT105
     C                   WRITE     XX105242D2                                            HUT105
     C                   ENDIF
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
     C     *IN61         OREQ      *ON
     C     @RSEQN        IFEQ      '10001'
     C**********         WRITE     SEH241D1                                              HUT105
     C                   WRITE     XX105241D1                                            HUT105
     C                   MOVE      *OFF          *IN60
     C                   ELSE
     C**********         WRITE     SEH242D1                                              HUT105
     C                   WRITE     XX105242D1                                            HUT105
     C                   MOVE      *OFF          *IN61
     C                   ENDIF
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
      * Format Amount                                                                      HUT011I09
     C                   MOVEL     A6NBDP        ZCDP
     C                   Z-ADD     WPSAT         ZAMNT
     C                   MOVE      'Y'           ZCOMMA
     C                   MOVE      'N'           ZMINUS
     C                   EXSR      ZEDIT
     C                   MOVE      ZAMNTA        RPSATA
     C**********           MOVE WPSAT     RPSATA                                           HUT011I09
     C                   MOVE      *ZEROS        WPSAT
      *
     C     @RSEQN        IFEQ      '10001'
     C**********         WRITE     SEH241D4                                                HUT105
     C                   WRITE     XX105241D4                                              HUT105
     C                   ELSE
     C**********         WRITE     SEH242D4                                                HUT105
     C                   WRITE     XX105242D4                                              HUT105
     C                   ENDIF
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
     C     *IN61         OREQ      *ON
     C     @RSEQN        IFEQ      '10001'
     C**********         WRITE     SEH241D1                                              HUT105
     C                   WRITE     XX105241D1                                            HUT105
     C                   MOVE      *OFF          *IN60
     C                   ELSE
     C**********         WRITE     SEH242D1                                              HUT105
     C                   WRITE     XX105242D1                                            HUT105
     C                   MOVE      *OFF          *IN61
     C                   ENDIF
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
     C     @RSEQN        IFEQ      '10001'
     C**********         WRITE     SEH241D5                                              HUT105
     C                   WRITE     XX105241D5                                            HUT105
     C                   ELSE
     C**********         WRITE     SEH242D5                                              HUT105
     C                   WRITE     XX105242D5                                            HUT105
     C                   ENDIF
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
     C     *IN61         OREQ      *ON
     C     @RSEQN        IFEQ      '10001'
     C**********         WRITE     SEH241D1                                              HUT105
     C                   WRITE     XX105241D1                                            HUT105
     C                   MOVE      *OFF          *IN60
     C                   ELSE
     C**********         WRITE     SEH242D1                                              HUT105
     C                   WRITE     XX105242D1                                            HUT105
     C                   MOVE      *OFF          *IN61
     C                   ENDIF
     C                   ENDIF
      *
     C     @RSEQN        IFEQ      '10001'
     C**********         WRITE     SEH241D6                                              HUT105
     C**********         WRITE     SEH241D7                                              HUT105
     C                   WRITE     XX105241D6                                            HUT105
     C                   WRITE     XX105241D7                                            HUT105
     C                   ELSE
     C                   MOVE      WCOUNT        ROVRAL
     C**********         WRITE     SEH242D6                                              HUT105
     C**********         WRITE     SEH242D7                                              HUT105
     C                   WRITE     XX105242D6                                            HUT105
     C                   WRITE     XX105242D7                                            HUT105
     C                   ENDIF
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
     C**********         MOVEL     'SEH024'      DBPGM                                   HUT105
     C                   MOVEL     'XX105024'    DBPGM                                   HUT105
      *
      ** Read RUNDAT for multi-branching indicator
      *
     C                   IN        RUNDAT
     C     *DTAARA       DEFINE                  RUNDAT           13
      *                                                                                     AR836848
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
     C     @RSEQN        IFEQ      '10001'
     C**********         OPEN      SEH024P1                                              HUT105
     C                   OPEN      XX105024P1                                            HUT105
     C                   MOVEL     SFILE1        ZFILE
     C                   Z-ADD     SFNUM1        ZSNUM
     C                   ELSE
     C**********         OPEN      SEH024P2                                              HUT105
     C                   OPEN      XX105024P2                                            HUT105
     C                   MOVEL     SFILE2        ZFILE
     C                   Z-ADD     SFNUM2        ZSNUM
     C                   ENDIF
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
     C********************************************************************                 HUT011I09
      /EJECT                                                                               HUT011I09
     C********************************************************************                 HUT011I09
     C**                                                                                   HUT011I09
     C*                                                                                    HUT011I09
     C*  ZEDIT SR. SUBROUTINE TO EDIT AN AMOUNT FIELD FOR OUTPUT                           HUT011I09
     C*                                                                                    HUT011I09
     C*  CALLED BY: BASFMT, ENQFMT                                                         HUT011I09
     C*                                                                                    HUT011I09
     C*  INPUT FIELDS:                                                                     HUT011I09
     C*                    ZAMNT  15 0    AMOUNT FIELD TO BE EDITED                        HUT011I09
     C*                    ZCDP    1,0    NO. OF DECIMAL PLACES                            HUT011I09
     C*                    ZCOMMA  1 A    COMMAS WANTED ('Y' OR 'N')                       HUT011I09
     C*                    ZMINUS  1 A    MINUS SIGN WANTED ('Y' OR 'N')                   HUT011I09
     C*                                                                                    HUT011I09
     C*  OUTPUT FIELDS:                                                                    HUT011I09
     C*                    ZAMNTA 21 A    EDITED AMOUNT FIELD                              HUT011I09
     C*                                                                                    HUT011I09
     C*  INDICATOR USED:                                                                   HUT011I09
     C*                    *IN94          SETON IF NON-ZERO CHARACTER                      HUT011I09
     C*                                   FOUND IN THE AMOUNT                              HUT011I09
     C*                                                                                    HUT011I09
     C     ZEDIT         BEGSR                                                  ***  ZEDIT  ***
     C*                                                                                    HUT011I09
     C                   Z-ADD     ZAMNT         ZAMNT            15 0          I/P FIELD
     C                   MOVE      ZCOMMA        ZCOMMA            1            VALUE Y OR N
     C                   MOVE      ZMINUS        ZMINUS            1            VALUE Y OR N
     C                   Z-ADD     ZCDP          ZCDP              1 0          NO. OF DPs.
     C                   MOVE      *BLANK        ZAMNTA           21            O/P FIELD
     C                   MOVE      '0'           *IN94
     C*                                                                                    HUT011I09
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
     C*                                                                                    HUT011I09
     C*  INCLUDE MINUS SIGN IF NEEDED                                                      HUT011I09
     C*  PROCESS AMOUNT AS A POSTIVE NUMBER EVEN IF NEGATIVE                               HUT011I09
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
     C*                                                                                    HUT011I09
     C*  SEPARATE INTEGER AND DECIMAL PARTS OF AMOUNT                                      HUT011I09
     C*  - ZERO DECIMAL PLACES                                                             HUT011I09
     C     ZCDP          IFEQ      0                                            **** B1
     C                   MOVE      ZAMNT         ZFLD1
     C                   ELSE
     C*                                                                                    HUT011I09
     C*  - ONE DECIMAL PLACE                                                               HUT011I09
     C     ZCDP          IFEQ      1                                            **** B2
     C                   MOVE      ZAMNT         ZDEC1             1
     C                   MOVEL     ZAMNT         ZAMT1            14
     C                   MOVE      ZAMT1         ZFLD1
     C                   ELSE
     C*                                                                                    HUT011I09
     C*  - TWO DECIMAL PLACES                                                              HUT011I09
     C     ZCDP          IFEQ      2                                            **** B3
     C                   MOVE      ZAMNT         ZDEC2             2
     C                   MOVEL     ZAMNT         ZAMT2            13
     C                   MOVE      ZAMT2         ZFLD1
     C                   ELSE
     C*                                                                                    HUT011I09
     C*  - THREE DECIMAL PLACES                                                            HUT011I09
     C     ZCDP          IFEQ      3                                            **** B4
     C                   MOVE      ZAMNT         ZDEC3             3
     C                   MOVEL     ZAMNT         ZAMT3            12
     C                   MOVE      ZAMT3         ZFLD1
     C                   ELSE
     C*                                                                                    HUT011I09
     C*  - EIGHT DECIMAL PLACES                                                            HUT011I09
     C     ZCDP          IFEQ      8                                            **** B5
     C                   MOVE      ZAMNT         ZDEC8             8
     C                   MOVEL     ZAMNT         ZAMT8             7
     C                   MOVE      ZAMT8         ZFLD1
     C                   END                                                    **** E5
     C                   END                                                    **** E4
     C                   END                                                    **** E3
     C                   END                                                    **** E2
     C                   END                                                    **** E1
     C*                                                                                    HUT011I09
     C*  MOVE THE INTEGER FIELD INTO A 5X3 ARRAY FOR EDITING                               HUT011I09
     C                   MOVEA     ZFLD1         ZAMT
     C*                                                                                    HUT011I09
     C/SPACE 3                                                                             HUT011I09
     C*                                                                                    HUT011I09
     C****                                                                                 HUT011I09
     C*                                                                                    HUT011I09
     C*  CHECK IF COMMAS ARE NEEDED OR NOT                                                 HUT011I09
     C*                                                                                    HUT011I09
     C****                                                                                 HUT011I09
     C     ZCOMMA        IFEQ      'Y'                                          **** E1
     C****                                                                                 HUT011I09
     C*                                                                                    HUT011I09
     C*  IF ZCOMMA  IS 'Y' MOVE COMMAS ETC. INTO A 5X4 EDITED ARRAY                        HUT011I09
     C*  (FOR ZERO DECIMAL PLACES DO NOT WANT A DECIMAL POINT)                             HUT011I09
     C*                                                                                    HUT011I09
     C     ZCDP          IFEQ      0                                            **** B2
     C                   MOVEA     ZCOM(1)       ZEDT
     C                   ELSE
     C                   MOVEA     ZCOM(2)       ZEDT
     C                   END                                                    **** E2
     C*                                                                                    HUT011I09
     C*                                                                                    HUT011I09
     C*  READ THROUGH AMOUNT ARRAY SO AS TO PLACE EDITED DIGITS                            HUT011I09
     C*  INTO ZEDT. THE ARRAY IS READ 3 CHARACTERS AT A TIME.                              HUT011I09
     C*  ALL LEADING ZEROES ARE SUPPRESSED.                                                HUT011I09
     C                   DO        5             Z                 1 0          **** B2
     C*                                                                                    HUT011I09
     C     *IN94         IFEQ      '1'                                          **** B3
     C                   MOVEL     ZAMT(Z)       ZEDT(Z)
     C                   ELSE
     C*                                                                                    HUT011I09
     C*  BLANK OUT EDITED FIELD IF ZEROES ARE FOUND                                        HUT011I09
     C     ZAMT(Z)       IFEQ      '000'                                        **** B4
     C     Z             IFNE      5                                            **** B5
     C                   MOVE      '    '        ZEDT(Z)
     C                   END                                                    **** E5
     C                   ELSE
     C*                                                                                    HUT011I09
     C*  WHEN FIRST NON ZERO CHARACTERS ARE REACHED REMOVE LEADING                         HUT011I09
     C*  ZEROES. READ ARRAY ELEMENT 1 CHARACTER AT A TIME.                                 HUT011I09
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
     C*                                                                                    HUT011I09
     C*  PLACE EDITED ARRAY INTO ALPHA FIELD TO INCLUDE DECIMALS.                          HUT011I09
     C                   MOVEA     ZEDT          ZFLD2
     C*                                                                                    HUT011I09
     C*  - ZERO DECIMAL PLACES                                                             HUT011I09
     C     ZCDP          IFEQ      0                                            **** B2
     C                   MOVEL     ZFLD2         ZAMT0            19
     C                   MOVE      ZAMT0         ZAMNTC
     C                   ELSE
     C*                                                                                    HUT011I09
     C*  - ONE DECIMAL PLACE                                                               HUT011I09
     C     ZCDP          IFEQ      1                                            **** B3
     C                   MOVE      ZFLD2         ZAMT1A           19
     C                   MOVEL     ZAMT1A        ZAMNTC
     C                   MOVE      ZDEC1         ZAMNTC
     C                   ELSE
     C*                                                                                    HUT011I09
     C*  - TWO DECIMAL PLACES                                                              HUT011I09
     C     ZCDP          IFEQ      2                                            **** B4
     C                   MOVE      ZFLD2         ZAMT2A           18
     C                   MOVEL     ZAMT2A        ZAMNTC
     C                   MOVE      ZDEC2         ZAMNTC
     C                   ELSE
     C*                                                                                    HUT011I09
     C*  - THREE DECIMAL PLACES                                                            HUT011I09
     C     ZCDP          IFEQ      3                                            **** B5
     C                   MOVE      ZFLD2         ZAMT3A           17
     C                   MOVEL     ZAMT3A        ZAMNTC
     C                   MOVE      ZDEC3         ZAMNTC
     C                   ELSE
     C*                                                                                    HUT011I09
     C*  - EIGHT DECIMAL PLACES                                                            HUT011I09
     C     ZCDP          IFEQ      8                                            **** B6
     C                   MOVE      ZFLD2         ZAMT8A           12
     C                   MOVEL     ZAMT8A        ZAMNTC
     C                   MOVE      ZDEC8         ZAMNTC
     C                   END                                                    **** E6
     C                   END                                                    **** E5
     C                   END                                                    **** E4
     C                   END                                                    **** E3
     C                   END                                                    **** E2
     C*                                                                                    HUT011I09
     C*  INCLUDE MINUS SIGN IF NEEDED                                                      HUT011I09
     C     ZMINUS        IFEQ      'Y'                                          **** B2
     C                   MOVEL     ZAMNTC        ZAMNTA
     C                   MOVE      ZMINS         ZAMNTA
     C                   ELSE                                                   **** X2
     C                   MOVE      ZAMNTC        ZAMNTA
     C                   END                                                    **** E2
     C*                                                                                    HUT011I09
     C****                                                 ****                            HUT011I09
     C*                                                                                    HUT011I09
     C                   ELSE                                                   **** X1
     C*                                                                                    HUT011I09
     C****                                                 ****                            HUT011I09
     C*                                                                                    HUT011I09
     C*  ELSE IF ZCOMMA EQUAL 'N':                                                         HUT011I09
     C*  MOVE FORMAT LEFT INTO A 6X3 ARRAY - 6TH ELEMENT CONTAINS D.P.                     HUT011I09
     C*  (FOR ZERO DECIMAL PLACES DO NOT WANT A DECIMAL POINT)                             HUT011I09
     C     ZCDP          IFEQ      0                                            **** B2
     C                   MOVEA     ZCOM(3)       ZED2
     C                   ELSE
     C                   MOVEA     ZCOM(4)       ZED2
     C                   END                                                    **** E2
     C*                                                                                    HUT011I09
     C*                                                                                    HUT011I09
     C*  READ THROUGH AMOUNT ARRAY SO AS TO PLACE EDITED DIGITS                            HUT011I09
     C*  INTO ZED2. THE ARRAY IS READ 3 CHARACTERS AT A TIME.                              HUT011I09
     C*  ALL LEADING ZEROES ARE SUPPRESSED.                                                HUT011I09
     C                   DO        5             Z                 1 0          **** B2
     C*                                                                                    HUT011I09
     C     *IN94         IFEQ      '1'                                          **** B3
     C                   MOVEL     ZAMT(Z)       ZED2(Z)
     C                   ELSE
     C*                                                                                    HUT011I09
     C*  SEARCH FOR FIRST NONE-ZERO CHARACTERS                                             HUT011I09
     C     ZAMT(Z)       IFNE      '000'                                        **** B4
     C*                                                                                    HUT011I09
     C*  WHEN FIRST NON ZERO CHARACTERS ARE REACHED REMOVE LEADING                         HUT011I09
     C*  ZEROES. READ ARRAY ELEMENT 1 CHARACTER AT A TIME.                                 HUT011I09
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
     C*                                                                                    HUT011I09
     C*  PLACE EDITED ARRAY INTO ALPHA FIELD TO INCLUDE DECIMALS.                          HUT011I09
     C                   MOVEA     ZED2          ZFLD3
     C*                                                                                    HUT011I09
     C*  - ZERO DECIMAL PLACES                                                             HUT011I09
     C     ZCDP          IFEQ      0                                            **** B2
     C                   MOVEL     ZFLD3         ZAMT0B           15
     C                   MOVE      ZAMT0B        ZAMNTB
     C                   ELSE
     C*                                                                                    HUT011I09
     C*  - ONE DECIMAL PLACE                                                               HUT011I09
     C     ZCDP          IFEQ      1                                            **** B3
     C                   MOVE      ZFLD3         ZAMT1B           15
     C                   MOVEL     ZAMT1B        ZAMNTB
     C                   MOVE      ZDEC1         ZAMNTB
     C                   ELSE
     C*                                                                                    HUT011I09
     C*  - TWO DECIMAL PLACES                                                              HUT011I09
     C     ZCDP          IFEQ      2                                            **** B4
     C                   MOVE      ZFLD3         ZAMT2B           14
     C                   MOVEL     ZAMT2B        ZAMNTB
     C                   MOVE      ZDEC2         ZAMNTB
     C                   ELSE
     C*                                                                                    HUT011I09
     C*  - THREE DECIMAL PLACES                                                            HUT011I09
     C     ZCDP          IFEQ      3                                            **** B5
     C                   MOVE      ZFLD3         ZAMT3B           13
     C                   MOVEL     ZAMT3B        ZAMNTB
     C                   MOVE      ZDEC3         ZAMNTB
     C                   ELSE
     C*                                                                                    HUT011I09
     C*  - EIGHT DECIMAL PLACES                                                            HUT011I09
     C     ZCDP          IFEQ      8                                            **** B6
     C                   MOVE      ZFLD3         ZAMT8B            8
     C                   MOVEL     ZAMT8B        ZAMNTB
     C                   MOVE      ZDEC8         ZAMNTB
     C                   END                                                    **** E6
     C                   END                                                    **** E5
     C                   END                                                    **** E4
     C                   END                                                    **** E3
     C                   END                                                    **** E2
     C*                                                                                    HUT011I09
     C*  INCLUDE MINUS SIGN IF NEEDED                                                      HUT011I09
     C     ZMINUS        IFEQ      'Y'                                          **** B2
     C                   MOVEL     ZAMNTB        ZAMNTD
     C                   MOVE      ZMINS         ZAMNTD
     C                   ELSE                                                   **** X2
     C                   MOVE      ZAMNTB        ZAMNTD
     C                   END                                                    **** E2
     C*                                                                                    HUT011I09
     C*  FINALLY MOVE NON-COMMA EDITED FIELD INTO O/P FIELD                                HUT011I09
     C                   MOVE      ZAMNTD        ZAMNTA
     C*                                                                                    HUT011I09
     C****                                                                                 HUT011I09
     C                   END                                                    **** E1
     C****                                                                                 HUT011I09
     C                   ENDSR
     C*                                                                                    HUT011I09
     C**                                                                                   HUT011I09
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
**   ZCOM - EDIT FORMAT FOR AMOUNT FIELD                                                   HUT011I09
   ,   ,   ,   ,  0                                                                        HUT011I09
   ,   ,   ,   ,  0.                                                                       HUT011I09
              0                                                                            HUT011I09
              0.                                                                           HUT011I09
