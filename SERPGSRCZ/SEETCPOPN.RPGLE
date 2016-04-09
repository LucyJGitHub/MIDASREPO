     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE EU Saving Tax Opening Position Take-on')      *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SEETCPOPN - EU TAX Customer Position Opening Position        *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2005            *
      *                                                               *
      *    This program calculates the opening position from          *
      *    details on CDEPPD and CPOSND on effective date             *
      *                                                               *
      *  Last Amend No. CER059             Date 19Jul10               *
      *  Prev Amend No. CER054             Date 07Apr09               *
      *                 CER048             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 BUG16152           Date 20Feb08               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG11193           Date 02May06               *
      *                 CSD027A            Date 05May06               *
      *                 BUG11164           Date 06Apr06               *
      *                 237063             Date 20Nov05               *
      *                 CGL035             Date 01Mar05               *
      *                 236453             Date 26Oct05               *
      *                 236754             Date 20Jun05               *
      *                 235088             Date 01Aug05               *
      *                 234675             Date 05Jul05               *
      *                 234577             Date 30Jun05               *
      *                 236696             Date 27Jun05               *
      *                 234440  *CREATE    Date 20Jun05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER054 - German Features - Church Tax (Recompile)            *
      *  CER048 - German Features - Taxes (Recompile)                 *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  BUG16152 - CGL031 Initialization pgm error                   *
      *  BUG11193 - Purchased Interest not calculated on BackValued   *
      *             Trade. (Recompile)                                *
      *  CSD027A - Conversion Of Customer Number to Alpha (recompile) *
      *  BUG11164 - A Serious Midas Error on SETRAD insert/amend      *
      *  237063 - EU Tax fixes upgrade to MP build 103.               *
      *  CGL035 - EUSD Upgrade to Midasplus                           *
      *  236453 - Fiscal price at effective date must be calculated   *
      *           in this program                                     *
      *  236754 - Defaults for Walk outs should not be restricted to  *
      *           after last coupon date                              *
      *  235088 - Only the live records of CDEPPD must be processed   *
      *  234675 - Change control for processing type 4 and Dividend   *
      *           EU tax calculation                                  *
      *  234577 - Get cutover date for branch not customer            *
      *  236696 - Interest over transition date wrong                 *
      *  234440 - Purchase Interest Management                        *
      *                                                               *
      *****************************************************************
 
     FCPOSC     IF   E           K DISK    PREFIX(S_)
     F                                     RENAME(CPOSNDF:CPOSCF)
     FSECTY     IF   E           K DISK    PREFIX(SEC_)
     FSECDEPL7  IF   E           K DISK    PREFIX(D_)
     FSECDEPL4  IF   E           K DISK    PREFIX(D_)                                         234440
     F                                     RENAME(CDEPPDF:CDEPHF)                             234440
     F***PRICM     IF   E           K DISK    PREFIX(P_)                                      236453
     FCPOSH     IF   E           K DISK    PREFIX(H_)                                         236453
     F                                     RENAME(CPOSNDF:CPOSHF)                             236453
     FETCPOSL0  UF A E           K DISK    PREFIX(E_) COMMIT
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** Include the SE standard declares
     D/COPY SECPYSRC,STDDECLARE
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
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
 
      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** External DS for Branch Details
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
 
      ** External DS for Location Details
     D SDLOCN        E DS                  EXTNAME(SDLOCNPD)
 
      ** External DS for Securities Clients
     D SDCTTX        E DS                  EXTNAME(SDCTTXPD)
 
      ** External DS for Currency Codes
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      ** External DS for Customer
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
     D  QQDFA1       E                     EXTFLD(QQDFAC)                                     CGL035
 
      ** External DS for Security Details
     D SECTYDS       E DS                  EXTNAME(SECTYD) PREFIX(SEC_)
     D CDArr                 183    230
     D CRArr                 231    242
 
      ** Externally described DS for investment types
     D SDINV         E DS                  EXTNAME(INVTPD)
 
      ** Short Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Long Data Structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** Array for manipulating decimal positions                                             236754
     D POWER9          S              9  4 DIM(9) CTDATA PERRCD(1)                            236754
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Interest rate     (ZRATE)
     D  IRATE          S             15P 9
      ** Next Coupon Date (ZNCD)
     D  NCD            S              5P 0 INZ(0)                                             CSE031
      ** Nominal currency decimal places
     D NomCcyDec       S              1P 0
     D WCNCD           S                   LIKE(DVCNCD)
     D WCOLC           S                   LIKE(BBCOLC)                                       233038
     D SumCDNV         S                   LIKE(D_CDNV)
     D WrkCDMK         S                   LIKE(D_CDMK)
     D WrkPTFR         S                   LIKE(D_PTFR)
     D WrkCSSC         S                   LIKE(S_CSSC)
     D WrkCSBA         S                   LIKE(S_CSBA)
     D WrkCSCN         S                   LIKE(S_CSCN)
     D @MKRT           S                   LIKE(D_CDMK)
     D @PTFR           S                   LIKE(D_PTFR)
     D WrkLAVP         S             27P 8
     D WrkCSAV         S             29P 8
     D WrkRslt         S             27P 8                                                    236453
     D Indx            S              1  0
 
      ** Interest Accrued (1)   (ZACCR)
     D ZACCRD          S             15P 0
      ** Interest Accrued (2)   (ZACCR)
     D ZACCXD          S             15P 1
      ** Pay/Rec/Zero Indicator (ZACCR)
     D ZRP             S              1A
      ** Last Coupon Date before Control Date  (ZLCD)
     D  ZZLCD          S              5P 0
      ** Start date
     D  ZSDATE         S              5P 0
      ** End date
     D  ZEDATE         S              5P 0
      ** Principal amount
     D ZAMT            S             15P 0
     D  ZDDAYS         S              5P 0
     D  ZECD           S              5P 0
     D  ZINTDD         S              5P 0
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
     C
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      ** Initialization
 
     C     *LOVAL        SETLL     CPOSC
     C                   READ      CPOSC                                  30
 
     C                   If        *In30 = *Off                                             BUG16152
     C                   EXSR      SrRtvEff
     C                   EVAL      E_APDT = EWEDT1
     C                   Endif                                                              BUG16152
 
     C                   DOW       *IN30 = '0'
 
      ** If no record found for effective date or before, zero field
 
     C**********         EVAL      E_APNC = S_CSPV                                            236453
 
     C                   EVAL      E_RECI = 'D'
     C                   EVAL      E_CSBA = S_CSBA
     C                   EVAL      E_CSSC = S_CSSC
     C                   EVAL      E_CSCN = S_CSCN
     C                   EVAL      E_CSDA = EWEDT1
     C                   EVAL      E_TTYPE = 'O'
 
     C                   EXSR      SrSecty
 
     C*****KEYPR         SETLL     PRICM                                                      236453
     C*****KEYPR         READE     PRICM                                  33                  236453
      **********                                                                              236453
     C**********         IF        *IN33 = '1'                                                236453
     C*****KEYPR         SETLL     PRICM                                                      236453
     C*****S_CSSC        READPE    PRICM                                  33                  236453
     C**********         ENDIF                                                                236453
      **********                                                                              236453
     C**********         IF        *IN33 = '1'                                                236453
     C**********         EVAL      E_AVFP = 0                                                 236453
     C**********         ELSE                                                                 236453
     C**********         EVAL      E_AVFP = P_PEXI                                            236453
     C**********         ENDIF                                                                236453
                                                                                              236453
     C                   EVAL      E_AVFP = 0                                                 236453
                                                                                              236453
     C                   IF        PROT <> '2' AND PROT <> '4'                                236453
     C                             AND PROT <> '7'                                            236453
                                                                                              236453
     C                   IF        SEC_ISSP = 0                                               236453
     C                             OR SEC_ISSP > 100                                          236453
     C                             OR SEC_ISSD = 0                                            236453
     C                   EVAL      E_AVFP = 100                                               236453
                                                                                              236453
     C                   ELSE                                                                 236453
                                                                                              236453
     C                   Z-ADD     100           WPrMat                                       236453
                                                                                              236453
     C                   CALLB     'ZAINTPL2'                                                 236453
     C                   PARM                    SEC_ISSD                                     236453
     C                   PARM                    EWEDT1                                       236453
     C                   PARM                    SEC_MATY                                     236453
     C                   PARM                    SEC_ISSP                                     236453
     C                   PARM                    WPrMat           15 8                        236453
     C                   PARM                    WFsPri           15 8                        236453
                                                                                              236453
     C                   Z-ADD     WFsPri        E_AVFP                                       236453
                                                                                              236453
     C                   ENDIF                                                                236453
                                                                                              236453
     C                   ENDIF                                                                236453
 
     C                   EVAL      SumCDNV = 0
     C     KEYDP         SETLL     SECDEPL7
     C     KEYDP         READE     SECDEPL7                               32
 
     C                   MOVEL     D_CDMK        WrkCDMK
     C                   MOVEL     D_PTFR        WrkPTFR
 
     C                   DOW       *IN32 = '0'
 
     C                   IF        D_RECI = 'D'                                               235088
     C                   EXSR      Det_TD_Posn                                                234440
     C                   EVAL      SumCDNV = SumCDNV + D_CDNV
     C                   ENDIF                                                                235088
 
     C     KEYDP         READE     SECDEPL7                               32
     C                   IF        WrkCDMK <> D_CDMK
     C                             OR WrkPTFR <> D_PTFR
     C                             OR *IN32 = '1'
                                                                                              236453
     C     KEYCPD        SETGT     CPOSH                                                      236453
     C                   READP     CPOSH                                  33                  236453
                                                                                              236453
     C                   IF        *IN33 = '1'                                                236453
     C                   EVAL      E_APNC = 0                                                 236453
     C                   ELSE                                                                 236453
     C                   EVAL      E_APNC = H_CSPV                                            236453
     C                   ENDIF                                                                236453
                                                                                              236453
     C                   EXSR      Insert
     C                   MOVEL     D_CDMK        WrkCDMK
     C                   MOVEL     D_PTFR        WrkPTFR
     C                   EVAL      SumCDNV = 0
     C                   ENDIF
 
     C                   ENDDO
 
     C                   READ      CPOSC                                  30
     C                   ENDDO
 
 
     C                   COMMIT
      ** Return
 
     C                   SETON                                        LR
      *****************************************************************
      /EJECT                                                                                  234440
      *****************************************************************                       234440
      *                                                               *                       234440
      * Det_TD_Posn - Determine Transition Date Position              *                       234440
      *                                                               *                       234440
      *****************************************************************                       234440
     C     Det_TD_Posn   BEGSR                                                                234440
                                                                                              234440
      ** Get CDEPPD position on transition date (prior to movements on this date)             234440
                                                                                              234440
     C     EWEDT1        SUB       1             PosnDate                                     234440
     C     CDKEYF        SETGT     SECDEPL4                                                   234440
     C     CDKEYP        READPE    SECDEPL4                               99                  234440
     C   99              Z-ADD     0             D_CDNV                                       234440
     C                   ENDSR                                                                234440
      *****************************************************************                       234440
      /EJECT
      *****************************************************************
      *                                                               *
      * Insert   - Insert record into ETCPOSND for this market        *
      *            and portfolio                                      *
      *                                                               *
      *****************************************************************
     C     Insert        BEGSR
 
     C                   EVAL      E_CSNV = SumCDNV
                                                                                              236453
     C                   IF        E_CSNV <> H_CSNV                                           236453
     C                   IF        H_CSNV <> 0                                                236453
     C                   EVAL(H)   WrkRslt = E_CSNV / H_CSNV                                  236453
     C                   EVAL(H)   E_APNC = E_APNC * WrkRslt                                  236453
     C                   ELSE                                                                 236453
     C                   EVAL      E_APNC = 0                                                 236453
     C                   ENDIF                                                                236453
     C                   ENDIF                                                                236453
                                                                                              236453
     C                   EVAL      Indx = 5 - Sec_NMDP + NomCcyDec                            236696
     C                   IF        E_CSNV <> 0
     C**********         EVAL      Indx = 5 - Sec_NMDP + NomCcyDec                            236696
 
     C**********         IF        S_CSNV = 0                                          236754 236453
     C**********         EVAL      E_APNC = 0                                          236754 236453
     C**********         ELSE                                                          236754 236453
     C**********         EVAL      E_APNC = E_APNC * E_CSNV / S_CSNV                          236453
     C**********         ENDIF                                                         236754 236453
 
     C                   EVAL      WrkLAVP = E_APNC / E_CSNV
     C                   EVAL      WrkLAVP = WrkLAVP / POWER9(Indx)
     C                   Z-ADD     WrkLAVP       E_LAVP
     C                   ELSE
     C                   EVAL      E_LAVP = 0
     C                   ENDIF
     C                   IF        Sec_SPBS = 'P'
     C                   EVAL      E_LAVP = E_LAVP * 100
     C                   ENDIF
     C                   EVAL      WrkCSAV = E_CSNV * E_AVFP * POWER9(Indx)
     C                   Z-ADD     WrkCSAV       E_CSAV
     C                   IF        SEC_SPBS = 'P'
     C                   EVAL      E_CSAV = E_CSAV / 100
     C                   ENDIF
     C                   EVAL      E_SAPD = EWEDT1 * E_CSNV
 
     C                   IF        PROT <> '2' AND PROT <> '4'
     C                             AND PROT <> '7'
     C                   EXSR      CalInt
     C                   EVAL      E_CSPI = ZACCRD
 
     C                   IF        PROT = '8'
     C                   EVAL      E_CSPI = E_CSPI * SEC_CFCT
     C                   ENDIF
 
     C                   ELSE
     C                   EVAL      E_CSPI = 0
     C                   ENDIF
 
     C                   EVAL      E_CSMK = WrkCDMK
     C                   EVAL      E_PTFR = WrkPTFR
      *
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    E_TMST
 
     C                   IF        E_CSNV <> 0
     C                   WRITE     ETCPOSNDF
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRSecty  - Access security details                            *
      *                                                               *
      *****************************************************************
     C     SRSecty       BEGSR
 
     C     WrkCSSC       IFNE      S_CSSC
     C     S_CSSC        CHAIN     SECTY
 
     C                   IF        NOT%FOUND(SECTY)
     C                   EVAL      DBKEY = S_CSSC
     C                   EVAL      DBFILE = 'SECTYD'
     C                   EVAL      DBASE = 7
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   CALL      'AOINVTR0'
     C                   PARM      *BLANKS       @Rtcd
     C                   PARM      '*KEY   '     @Optn
     C                   PARM                    SEC_SITP
     C                   PARM                    SEC_NMCY
     C     SDINV         PARM      SDINV         DSFDY
 
     C                   IF        @Rtcd <> *BLANKS
     C                   MOVE      *BLANKS       DBKEY
     C                   MOVEL     SEC_NMCY      DBKEY
     C                   MOVE      SEC_SITP      DBKEY
     C                   MOVEL     'INVTPD'      DBFILE
     C                   MOVE      '102'         DBASE
     C                   EXSR      *PSSR
     C                   END
 
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      SEC_NMCY      @BRCH
     C*****SDCURR        PARM      SDCURR        DSFDY                                        236453
     C     SDCURR        PARM      SDCURR        DSSDY                                        236453
 
     C     @RTCD         IFNE      *BLANKS
     C                   EVAL      DBKEY = SEC_NMCY
     C                   EVAL      DBFILE = 'SDCURRPD'
     C                   EVAL      DBASE = 10
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   Z-ADD     A6NBDP        NomCcyDec
 
     C                   MOVE      S_CSSC        WrkCSSC
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrRtvEff - Retrieve Effective Date                            *
      *                                                               *
      *****************************************************************
     C     SrRtvEff      BEGSR
 
     C     WrkCSBA       IFNE      S_CSBA
     C                   MOVEL     S_CSBA        @BRCH             3
     C                   CALLB     'AOBRCHR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM                    @BRCH
     C     SDBRCH        PARM      SDBRCH        DSFDY
 
     C                   MOVE      S_CSBA        WrkCSBA           3
 
     C     @RTCD         IFNE      *BLANKS
     C                   EVAL      DBKEY = S_CSBA
     C                   EVAL      DBFILE = 'SDBRCHPD'
     C                   EVAL      DBASE = 3
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   MOVEL     A8LCCD        @LCCD             3
     C                   CALL      'AOLOCNR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM                    @LCCD
     C     SDLOCN        PARM      SDLOCN        DSFDY
 
     C     @RTCD         IFNE      *BLANKS
     C                   EVAL      DBKEY = A8LCCD
     C                   EVAL      DBFILE = 'SDLOCNPD'
     C                   EVAL      DBASE = 4
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
 
     C                   MOVE      S_CSCN        WrkCSCN                                      234577
     C     WrkCSCN       IFNE      S_CSCN
     C                   MOVEL     *BLANK        @PKEY1           10
     C                   MOVEL     S_CSCN        @PKEY1
 
      ** Customer details
 
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANK        @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM                    @PKEY1
     C                   PARM                    @PKYST            7
     C     SDCUST        PARM      SDCUST        DSSDY
 
     C                   MOVE      S_CSCN        WrkCSCN
 
      ** Database Error
 
     C     @RTCD         IFNE      *BLANK
     C                   EVAL      DBKEY = @PKYST
     C                   EVAL      DBFILE = 'SDCUSTPD'
     C                   EVAL      DBASE = 5
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
 
      ** Tax basket
 
     C                   EVAL      WCNCD = DVCNCD
     C                   EVAL      WCOLC = DVCNCD                                             234577
     C*******************EVAL      WCOLC = BBCOLC                                      233038 234577
 
     C                   CALL      'AOCTTXR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      WCNCD         @PCTRT            2
     C                   PARM      WCOLC         @PCTRR            2                          233038
     C     SDCTTX        PARM      SDCTTX        DSFDY
 
     C                   IF        @RTCD = '*NRF   '
 
     C                   EVAL      WCOLC = *BLANK                                             233038
     C                   CALL      'AOCTTXR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      WCNCD         @PCTRT
     C                   PARM      WCOLC         @PCTRR                                       233038
     C     SDCTTX        PARM      SDCTTX        DSFDY
 
      ** Database Error
 
     C     @RTCD         IFNE      *BLANK
     C                   EVAL      DBKEY = @PCTRT + ' ' + @PCTRR
     C                   EVAL      DBFILE = 'SDCTTXPD'
     C                   EVAL      DBASE = 6
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ZACCR    - Retrieve Effective Date                            *
      *                                                               *
      *****************************************************************
     C     CalInt        BEGSR
      *
      ***  Determine Coupon Dates prior to and after the Value Date
      *
     C                   Z-ADD     EWEDT1        ZECD
     C                   EXSR      ZLCD
                                                                                              236696
     C                   CALLB     'ZNCD'                                                     236696
     C                   PARM                    SEC_ITLD                                     236696
     C                   PARM                    SEC_FCPN                                     236696
     C                   PARM                    SEC_MATY                                     236696
     C                   PARM                    CDArr                                        236696
     C                   PARM                    CRArr                                        236696
     C                   PARM                    EWEDT1                                       236696
     C                   PARM                    BJDFIN                                       236696
     C                   PARM                    SEC_NMCY                                     236696
     C                   PARM                    SEC_SITP                                     236696
     C                   PARM                    SEC_BCNV                                     236696
     C                   PARM                    ZZLCD                                        236696
     C                   PARM                    SEC_HCY1                                     237063
     C                   PARM                    SEC_HCY2                                     237063
     C                   PARM                    SEC_HCY3                                     237063
     C                   PARM                    SEC_HCY4                                     237063
     C                   PARM                    SEC_HCY5                                     237063
     C                   PARM                    SEC_HCY6                                     237063
     C                   PARM                    SEC_HCY7                                     237063
     C                   PARM                    SEC_HCY8                                     237063
     C                   PARM                    SEC_HCY9                                     237063
     C                   PARM                    NCD                                          236696
      *                                                                                       212939
      ** Store the value of Last Change Date for comparison later.                            212939
      *                                                                                       212939
     C                   Z-ADD     ZZLCD         ZZLCD1            5 0                        212939
      *
      ***  Set up the Start and End Dates...
      ***  IF Cum-Coupon, just calculate from the Last Coupon Date to
      ***  the Event Control Date. For Ex-coupon, calculate on up to
      ***  the Next Coupon Date and subtract the Cum-Coupon portion.
      *
     C                   Z-ADD     ZZLCD         ZSDATE
     C                   Z-ADD     EWEDT1        ZEDATE
 
     C                   CALLB     'ZACCR'
     C                   PARM      E_CSNV        ZAMT
     C                   PARM      SEC_CPNR      IRATE
     C                   PARM                    ZSDATE
     C                   PARM                    ZEDATE
     C                   PARM                    SECTYDS
     C                   PARM                    DADJN             1
     C                   PARM                    NCD
     C                   PARM                    NomCcyDec
     C                   PARM                    PROT
     C                   PARM                    BJDFIN
     C                   PARM                    ZACCRD
     C                   PARM                    ZACCXD
     C                   PARM                    ZRP
     C                   PARM                    ZDDAYS
     C                   PARM                    ZINTDD
 
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      **********************************************************************
      *                                                                    *
      *  This subroutine is to cater for the fact that standard subroutine *
      *   ZPCINT in this module executes another standard subroutine,      *
      *   ZLCD, which has also been converted to a module.                 *
      *  This subroutine is also called ZLCD and simply does a CALLB to    *
      *   the module that contains subroutine ZLCD                         *
      *                                                                    *
     C     ZLCD          BEGSR
 
     C                   CALLB     'ZLCD'
     C                   PARM                    SEC_ISSD
     C                   PARM                    SEC_ITLD
     C                   PARM                    SEC_FCPN
     C                   PARM                    SEC_MATY
     C                   PARM                    CDArr
     C                   PARM                    CRArr
     C                   PARM                    SEC_LCPN                                   BUG11164
     C                   PARM                    ZECD
     C                   PARM                    BJDFIN
      *                                                                                       CSE005
      ** Nominal Currency                                                                     CSE005
      ** Security Investment Type                                                             CSE005
      ** Effect on Holidays on Coupon Dates                                                   CSE005
     C                   PARM                    SEC_NMCY                                     CSE005
     C                   PARM                    SEC_SITP                                     CSE005
     C                   PARM                    SEC_BCNV                                     CSE005
     C                   PARM                    SEC_HCY1                                     237063
     C                   PARM                    SEC_HCY2                                     237063
     C                   PARM                    SEC_HCY3                                     237063
     C                   PARM                    SEC_HCY4                                     237063
     C                   PARM                    SEC_HCY5                                     237063
     C                   PARM                    SEC_HCY6                                     237063
     C                   PARM                    SEC_HCY7                                     237063
     C                   PARM                    SEC_HCY8                                     237063
     C                   PARM                    SEC_HCY9                                     237063
     C                   PARM                    ZZLCD
 
     C                   ENDSR
      **********************************************************************
     C/EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     KEYCP         KLIST
     C                   KFLD                    S_CSBA
     C                   KFLD                    S_CSSC
     C                   KFLD                    S_CSCN
 
     C     KEYCPD        KLIST
     C                   KFLD                    S_CSBA
     C                   KFLD                    S_CSSC
     C                   KFLD                    S_CSCN
     C                   KFLD                    EWEDT1
 
     C     KEYDP         KLIST
     C                   KFLD                    S_CSBA
     C                   KFLD                    S_CSCN
     C                   KFLD                    S_CSSC
 
     C     KEYPR         KLIST
     C                   KFLD                    S_CSSC
     C                   KFLD                    EWEDT1
                                                                                              234440
     C     CDKEYF        KLIST                                                                234440
     C                   KFLD                    S_CSBA                                       234440
     C                   KFLD                    S_CSSC                                       234440
     C                   KFLD                    D_CDPT                                       234440
     C                   KFLD                    D_CDMK                                       234440
     C                   KFLD                    S_CSCN                                       234440
     C                   KFLD                    D_PTFR                                       234440
     C                   KFLD                    PosnDate          5 0                        234440
                                                                                              234440
     C     CDKEYP        KLIST                                                                234440
     C                   KFLD                    S_CSBA                                       234440
     C                   KFLD                    S_CSSC                                       234440
     C                   KFLD                    D_CDPT                                       234440
     C                   KFLD                    D_CDMK                                       234440
     C                   KFLD                    S_CSCN                                       234440
     C                   KFLD                    D_PTFR                                       234440
 
      ** Get Bank Details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST  '    @OPTN
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database Error
 
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     '*FIRST '     DBKEY
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     '900'         DBASE
     C                   EXSR      *PSSR
     C                   END
 
 
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      ********************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2005
**  POWER9 - ARRAY OF POWERS FOR CURRENCY CONVERSION                                          236754
000000001                                                                                     236754
000000010                                                                                     236754
000000100                                                                                     236754
000001000                                                                                     236754
000010000                                                                                     236754
000100000                                                                                     236754
001000000                                                                                     236754
010000000                                                                                     236754
100000000                                                                                     236754
