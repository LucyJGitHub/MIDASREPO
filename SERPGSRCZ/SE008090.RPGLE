     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Original Purchased Date set up on DPTMVD')    *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SE008090 - SE Original Purchased Date set up on DPTMVD       *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2005            *
      *                                                               *
      *  Last Amend No. CLE134             Date 01Aug12               *
      *  Prev Amend No. AR802256           Date 14Jul11               *
      *                 CER059             Date 19Jul10               *
      *                 CER054             Date 07Apr09               *
      *                 CER048             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG11193           Date 02May06               *
      *                 CSD027A            Date 05May06               *
      *                 BUG11164           Date 06Apr06               *
      *                 237063             Date 20Nov05               *
      *                 236453             Date 12Sep05               *
      *                 233698 *CREATE     Date 25May05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  AR802256 - CGL031 switch off                                 *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER054 - German Features - Church Tax (Recompile)            *
      *  CER048 - German Features - Taxes (Recompile)                 *
      *  BUG11193 - Purchased Interest not calculated on BackValued   *
      *             Trade. (Recompile)                                *
      *  CSD027A - Conversion Of Customer Number to Alpha (Recompile) *
      *  BUG11164 - A Serious Midas Error on SETRAD insert/amend      *
      *  237063 - EU Tax fixes upgrade to MP build 103.               *
      *  236453 - To set the fiscal price and the original purchased  *
      *           interest for bonds                                  *
      *  233698 - Change Control for CGL031                           *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Function of Indicators                                       *
      *                                                               *
      *  99 - Error in update for DPTMVD                              *
      *                                                               *
      *  LR - Last record indicator (program termination)             *
      *  U7 and U8 - DB error processing indicator                    *
      *                                                               *
      *****************************************************************
      /SPACE
      *****************************************************************
      *                                                               *
      *  Subroutine Index                                             *
      *                                                               *
      *  *PSSR      - Program exception error routine                 *
      *  *INZSR     - Initial First Cycle processing                  *
      *  SRERR      - File error                                      *
      *                                                               *
      *****************************************************************
 
      ** Midas SE Securities
     FDPTMV     UF   E           K DISK    INFSR(*PSSR)
     FSECTY     IF   E           K DISK    INFSR(*PSSR)                                       236453
     FINVTP     IF   E           K DISK    INFSR(*PSSR)                                       236453
 
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
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
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
 
     ** +--------------------------------------+
     ** ¦ Arrays and Data Structures           ¦
     ** ¦ ==========================           ¦
     ** +--------------------------------------+
 
      ** External DS for bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
                                                                                              236453
      ** External DS for Branch Details                                                       236453
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)                                  236453
                                                                                              236453
      ** External DS for Location Details                                                     236453
     D SDLOCN        E DS                  EXTNAME(SDLOCNPD)                                  236453
                                                                                              236453
      ** External DS for Securities Clients                                                   236453
     D SDCTTX        E DS                  EXTNAME(SDCTTXPD)                                  236453
                                                                                              236453
      ** External DS for Security Details                                                     236453
     D SECTYDS       E DS                  EXTNAME(SECTYD)                                    236453
     D CDArr                 183    230                                                       236453
     D CRArr                 231    242                                                       236453
                                                                                              236453
      ** External DS for Currency Codes                                                       236453
     D SDCURR        E DS                  EXTNAME(SDCURRPD)                                  236453
                                                                                              236453
      ** Short Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Long Data Structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D WCNCD           S                   LIKE(EWCTRT)                                       236453
     D WCOLC           S                   LIKE(EWCTRR)                                       236453
     D WrkDPSS         S                   LIKE(DPSS)                                         236453
     D WrkDPBA         S                   LIKE(DPBA)                                         236453
     D WrkEWEDT1       S                   LIKE(EWEDT1) INZ(0)                              AR802256
     D NomCcyDec       S              1P 0                                                    236453
     D WPrMat          S             15  8                                                    236453
     D IRATE           S             15P 9                                                    236453
     D ZACCRD          S             15P 0                                                    236453
     D ZACCXD          S             15P 1                                                    236453
     D ZAMT            S             15P 0                                                    236453
     D ZDDAYS          S              5P 0                                                    236453
     D ZECD            S              5P 0                                                    236453
     D ZEDATE          S              5P 0                                                    236453
     D ZINTDD          S              5P 0                                                    236453
     D ZRP             S              1A                                                      236453
     D ZSDATE          S              5P 0                                                    236453
     D ZZLCD           S              5P 0                                                    236453
                                                                                              236453
      ** Parameters
     D PRtcd           S              7A
     D POptn           S              7A
     D PCust           S             10A
      *****************************************************************                       236453
                                                                                              236453
     IDPTMVDF                                                                                 236453
     I              RECI                        DRECI                                         236453
 
      /EJECT
      *****************************************************************
      *                                                               *
      * MAIN - MAIN BODY                                              *
      *                                                               *
      *****************************************************************
 
      ** Set file pointer to start of file
 
     C     *LOVAL        SETLL     DPTMV
     C                   READ      DPTMV
     C
     C                   DOW       Not%EOF(DPTMV)
 
     C**********         IF        RECI <> '*' AND RECI <> 'R'                       236453 AR802256
     C                   IF        DRECI <> '*' AND DRECI <> 'R'                            AR802256
                                                                                              236453
     C     DPBA          IFNE      WrkDPBA                                                    236453
     C                   EXSR      SRGetEffD                                                  236453
     C                   MOVE      DPBA          WrkDPBA                                      236453
     C                   ENDIF                                                                236453
                                                                                              236453
     C     DPSS          IFNE      WrkDPSS                                                    236453
     C                   EXSR      SrSecty                                                    236453
     C                   MOVE      DPSS          WrkDPSS                                      236453
     C                   ENDIF                                                                236453
                                                                                              236453
      ** Set up the original purchase date                                                    236453
                                                                                              236453
     C                   IF        DPMV = 'WI'                                                236453
     C**********                   AND DPMD >= EWEDT1                                236453 AR802256
     C                             AND DPMD >= WrkEWEDT1                                    AR802256
     C                             OR DPMV = 'WO'                                             236453
     C**********                   AND DPDO >= EWEDT1                                236453 AR802256
     C                             AND DPDO >= WrkEWEDT1                                    AR802256
                                                                                              236453
     C*****              IF        OPDT = 0                                                   236453
     C*****              Z-ADD     DPMD          OPDT                                         236453
                                                                                              236453
     C                   IF        OPDT = 0 AND PROT = '2'                                    236453
     C                             OR OPDT = 0 AND PROT = '4'
     C                             OR OPDT = 0 AND PROT = '7'
     C**********         Z-ADD     EWEDT1        OPDT                                236453 AR802256
     C                   Z-ADD     WrkEWEDT1     OPDT                                       AR802256
     C                   UPDATE    DPTMVDF                              99                    236453
     C                   ENDIF                                                                236453
                                                                                              236453
     C                   IF        PROT <> '2' AND PROT <> '4'                                236453
     C                             AND PROT <> '7'                                            236453
                                                                                              236453
     C                   IF        OPDT <> 0 AND FSPP = 0                                     236453
     C                             OR OPDT = 0                                                236453
     C**********         Z-ADD     EWEDT1        OPDT                                236453 AR802256
     C                   Z-ADD     WrkEWEDT1     OPDT                                       AR802256
 
      ** Set up the fiscal price for bonds                                                    236453
                                                                                              236453
     C                   IF        FSPP = 0                                                   236453
     C                   IF        ISSP < 100 AND ISSP <> 0                                   236453
     C                             AND ISSD <> 0                                              236453
     C                   Z-ADD     100           WPrMat                                       236453
                                                                                              236453
     C                   CALLB     'ZAINTPL2'                                                 236453
     C                   PARM                    ISSD                                         236453
     C                   PARM                    OPDT                                         236453
     C                   PARM                    MATY                                         236453
     C                   PARM                    ISSP                                         236453
     C                   PARM                    WPrMat                                       236453
     C                   PARM                    FSPP                                         236453
                                                                                              236453
     C                   Z-ADD     FSPP          FSPR                                         236453
                                                                                              236453
     C                   ENDIF                                                                236453
     C                   ENDIF                                                                236453
                                                                                              236453
      ** Set up the original purchase interest for bonds                                      236453
                                                                                              236453
     C                   IF        OPIN = 0 AND CPNR <> 0                                     236453
     C                             AND SERECI = 'D'                                           236453
     C                   EXSR      CalInt                                                     236453
     C                   EVAL      OPIN = ZACCRD                                              236453
                                                                                              236453
     C                   IF        PROT = '8'                                                 236453
     C                   EVAL      OPIN = OPIN * CFCT                                         236453
     C                   ENDIF                                                                236453
     C                   ENDIF                                                                236453
                                                                                              236453
     C                   UPDATE    DPTMVDF                              99
 
     C                   IF        *IN99 = '1'
     C                   EXSR      SRERR
     C                   ENDIF
      *****                                                                                   236453
     C*****              ENDIF                                                                236453
                                                                                              236453
     C                   ENDIF                                                                236453
                                                                                              236453
     C                   ENDIF                                                                236453
                                                                                              236453
     C                   ENDIF                                                                236453
                                                                                              236453
     C                   ENDIF                                                                236453
 
     C                   READ      DPTMV
 
     C                   ENDDO
 
     C                   EVAL      *INLR = *ON
      *****************************************************************                       236453
      /EJECT                                                                                  236453
      *****************************************************************                       236453
      *                                                               *                       236453
      * CalInt   - Calculate original purchased interest              *                       236453
      *                                                               *                       236453
      *****************************************************************                       236453
     C     CalInt        BEGSR                                                                236453
      *                                                                                       236453
      ***  Determine Coupon Dates prior to and after the Value Date                           236453
      *                                                                                       236453
     C                   Z-ADD     OPDT          ZECD                                         236453
     C                   EXSR      ZLCD                                                       236453
                                                                                              236453
     C                   CALLB     'ZNCD'                                                     236453
     C                   PARM                    ITLD                                         236453
     C                   PARM                    FCPN                                         236453
     C                   PARM                    MATY                                         236453
     C                   PARM                    CDArr                                        236453
     C                   PARM                    CRArr                                        236453
     C                   PARM                    OPDT                                         236453
     C                   PARM      'D'           BJDFIN                                       236453
     C                   PARM                    NMCY                                         236453
     C                   PARM                    SITP                                         236453
     C                   PARM                    BCNV                                         236453
     C                   PARM                    ZZLCD                                        236453
     C                   PARM                    HCY1                                         237063
     C                   PARM                    HCY2                                         237063
     C                   PARM                    HCY3                                         237063
     C                   PARM                    HCY4                                         237063
     C                   PARM                    HCY5                                         237063
     C                   PARM                    HCY6                                         237063
     C                   PARM                    HCY7                                         237063
     C                   PARM                    HCY8                                         237063
     C                   PARM                    HCY9                                         237063
     C                   PARM                    NCD                                          236453
      *                                                                                       236453
      ** Store the value of Last Change Date for comparison later.                            236453
      *                                                                                       236453
      ***  Set up the Start and End Dates...                                                  236453
      ***  IF Cum-Coupon, just calculate from the Last Coupon Date to                         236453
      ***  the Event Control Date. For Ex-coupon, calculate on up to                          236453
      ***  the Next Coupon Date and subtract the Cum-Coupon portion.                          236453
      *                                                                                       236453
     C                   Z-ADD     ZZLCD         ZSDATE                                       236453
     C                   Z-ADD     OPDT          ZEDATE                                       236453
                                                                                              236453
     C                   CALLB     'ZACCR'                                                    236453
     C                   PARM      DPNA          ZAMT                                         236453
     C                   PARM      CPNR          IRATE                                        236453
     C                   PARM                    ZSDATE                                       236453
     C                   PARM                    ZEDATE                                       236453
     C                   PARM                    SECTYDS                                      236453
     C                   PARM                    IADJ                                         236453
     C                   PARM                    NCD                                          236453
     C                   PARM                    NomCcyDec                                    236453
     C                   PARM                    PROT                                         236453
     C                   PARM      'D'           BJDFIN                                       236453
     C                   PARM                    ZACCRD                                       236453
     C                   PARM                    ZACCXD                                       236453
     C                   PARM                    ZRP                                          236453
     C                   PARM                    ZDDAYS                                       236453
     C                   PARM                    ZINTDD                                       236453
                                                                                              236453
                                                                                              236453
     C                   ENDSR                                                                236453
      *****************************************************************                       236453
      /EJECT                                                                                  236453
      **********************************************************************                  236453
      *                                                                    *                  236453
      *  This subroutine is to cater for the fact that standard subroutine *                  236453
      *   ZPCINT in this module executes another standard subroutine,      *                  236453
      *   ZLCD, which has also been converted to a module.                 *                  236453
      *  This subroutine is also called ZLCD and simply does a CALLB to    *                  236453
      *   the module that contains subroutine ZLCD                         *                  236453
      *                                                                    *                  236453
     C     ZLCD          BEGSR                                                                236453
                                                                                              236453
     C                   CALLB     'ZLCD'                                                     236453
     C                   PARM                    ISSD                                         236453
     C                   PARM                    ITLD                                         236453
     C                   PARM                    FCPN                                         236453
     C                   PARM                    MATY                                         236453
     C                   PARM                    CDArr                                        236453
     C                   PARM                    CRArr                                        236453
     C                   PARM                    LCPN                                       BUG11164
     C                   PARM                    ZECD                                         236453
     C                   PARM      'D'           BJDFIN                                       236453
      *                                                                                       236453
      ** Nominal Currency                                                                     236453
      ** Security Investment Type                                                             236453
      ** Effect on Holidays on Coupon Dates                                                   236453
     C                   PARM                    NMCY                                         236453
     C                   PARM                    SITP                                         236453
     C                   PARM                    BCNV                                         236453
     C                   PARM                    HCY1                                         237063
     C                   PARM                    HCY2                                         237063
     C                   PARM                    HCY3                                         237063
     C                   PARM                    HCY4                                         237063
     C                   PARM                    HCY5                                         237063
     C                   PARM                    HCY6                                         237063
     C                   PARM                    HCY7                                         237063
     C                   PARM                    HCY8                                         237063
     C                   PARM                    HCY9                                         237063
     C                   PARM                    ZZLCD                                        236453
                                                                                              236453
     C     OPDT          SUB       ZZLCD         RESULT            5 0                        236453
     C                   IF        RESULT > 365                                               236453
     C                   Z-ADD     LCPN          ZZLCD                                        236453
     C                   ENDIF                                                                236453
                                                                                              236453
     C                   ENDSR                                                                236453
      *****************************************************************                       236453
      /EJECT                                                                                  236453
      *****************************************************************                       236453
      *                                                               *                       236453
      * SRSecty  - Access security details                            *                       236453
      *                                                               *                       236453
      *****************************************************************                       236453
     C     SRSecty       BEGSR                                                                236453
                                                                                              236453
     C     DPSS          CHAIN     SECTY                                                      236453
                                                                                              236453
     C                   IF        NOT%FOUND(SECTY)                                           236453
     C                   EVAL      DBKEY = DPSS                                               236453
     C                   EVAL      DBFILE = 'SECTYD'                                          236453
     C                   EVAL      DBASE = 1                                                  236453
     C                   EXSR      *PSSR                                                      236453
     C                   ENDIF                                                                236453
     C                   MOVE      RECI          SERECI            1                          236453
                                                                                              236453
     C                   IF        SERECI = 'D'                                               236453
                                                                                              236453
     C     KLINVT        KLIST                                                                236453
     C                   KFLD                    NMCY                                         236453
     C                   KFLD                    SITP                                         236453
     C     KLINVT        CHAIN     INVTP                                                      236453
                                                                                              236453
     C                   IF        NOT%FOUND(INVTP)                                           236453
     C                   EVAL      DBKEY = NMCY + ' ' + SITP                                  236453
     C                   EVAL      DBFILE = 'INVTPD'                                          236453
     C                   EVAL      DBASE = 2                                                  236453
     C                   EXSR      *PSSR                                                      236453
     C                   ENDIF                                                                236453
                                                                                              236453
     C                   CALLB     'AOCURRR0'                                                 236453
     C                   PARM      *BLANKS       @RTCD                                        236453
     C                   PARM      '*KEY   '     @OPTN                                        236453
     C                   PARM                    NMCY                                         236453
     C     SDCURR        PARM      SDCURR        DSFDY                                        236453
                                                                                              236453
     C     @RTCD         IFNE      *BLANKS                                                    236453
     C                   EVAL      DBKEY = NMCY                                               236453
     C                   EVAL      DBFILE = 'SDCURRPD'                                        236453
     C                   EVAL      DBASE = 3                                                  236453
     C                   EXSR      *PSSR                                                      236453
     C                   ENDIF                                                                236453
     C                   Z-ADD     A6NBDP        NomCcyDec                                    236453
                                                                                              236453
     C                   ENDIF                                                                236453
                                                                                              236453
     C                   ENDSR                                                                236453
      *****************************************************************                       236453
     C/EJECT                                                                                  236453
      *****************************************************************                       236453
      *                                                               *                       236453
      * SRGetEffD - Get effect Date                                   *                       236453
      *                                                               *                       236453
      *****************************************************************                       236453
                                                                                              236453
     C     SRGetEffD     BEGSR                                                                236453
                                                                                              236453
     C                   MOVEL     DPBA          @BRCH             3                          236453
     C                   CALLB     'AOBRCHR0'                                                 236453
     C                   PARM      *BLANKS       @RTCD                                        236453
     C                   PARM      '*KEY   '     @OPTN                                        236453
     C                   PARM                    @BRCH                                        236453
     C     SDBRCH        PARM      SDBRCH        DSFDY                                        236453
                                                                                              236453
     C     @RTCD         IFNE      *BLANKS                                                    236453
     C                   EVAL      DBKEY = @BRCH                                              236453
     C                   EVAL      DBFILE = 'SDBRCHPD'                                        236453
     C                   EVAL      DBASE = 4                                                  236453
     C                   EXSR      *PSSR                                                      236453
     C                   ENDIF                                                                236453
                                                                                              236453
     C                   MOVEL     A8LCCD        @LCCD             3                          236453
     C                   CALL      'AOLOCNR0'                                                 236453
     C                   PARM      *BLANKS       @RTCD                                        236453
     C                   PARM      '*KEY   '     @OPTN                                        236453
     C                   PARM                    @LCCD                                        236453
     C     SDLOCN        PARM      SDLOCN        DSFDY                                        236453
                                                                                              236453
     C     @RTCD         IFNE      *BLANKS                                                    236453
     C                   EVAL      DBKEY = A8LCCD                                             236453
     C                   EVAL      DBFILE = 'SDLOCNPD'                                        236453
     C                   EVAL      DBASE = 5                                                  236453
     C                   EXSR      *PSSR                                                      236453
     C                   ENDIF                                                                236453
                                                                                              236453
      ** Get Effect Date                                                                      236453
                                                                                              236453
     C                   EVAL      WCNCD = DVCNCD                                             236453
     C                   EVAL      WCOLC = DVCNCD                                             236453
                                                                                              236453
     C                   CALL      'AOCTTXR0'                                                 236453
     C                   PARM      *BLANKS       @RTCD                                        236453
     C                   PARM      '*KEY   '     @OPTN                                        236453
     C                   PARM      WCNCD         @PCTRT            2                          236453
     C                   PARM      WCOLC         @PCTRR            2                          236453
     C     SDCTTX        PARM      SDCTTX        DSFDY                                        236453
                                                                                              236453
     C                   IF        @RTCD = '*NRF   '                                          236453
                                                                                              236453
     C                   EVAL      WCOLC = *BLANK                                             236453
     C                   CALL      'AOCTTXR0'                                                 236453
     C                   PARM      *BLANKS       @RTCD                                        236453
     C                   PARM      '*KEY   '     @OPTN                                        236453
     C                   PARM      WCNCD         @PCTRT                                       236453
     C                   PARM      WCOLC         @PCTRR                                       236453
     C     SDCTTX        PARM      SDCTTX        DSFDY                                        236453
                                                                                              236453
      ** Database Error                                                                       236453
                                                                                              236453
     C     @RTCD         IFNE      *BLANK                                                     236453
     C                   EVAL      DBKEY = @PCTRT + ' ' + @PCTRR                              236453
     C                   EVAL      DBFILE = 'SDCTTXPD'                                        236453
     C                   EVAL      DBASE = 6                                                  236453
     C                   EXSR      *PSSR                                                      236453
     C                   ENDIF                                                                236453
     C                   ENDIF                                                                236453
     C                   EVAL      WrkEWEDT1 = EWEDT1                                       AR802256
                                                                                              236453
     C                   ENDSR                                                                236453
      ****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
      ** Access Bank Details
 
     C                   CALL      'AOBANKR0'
     C*****              PARM      '*DBERR '     PRtcd                                        236453
     C                   PARM      *BLANKS       PRtcd                                        236453
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY
 
     C                   ENDSR
      ****************************************************************
      /EJECT
      ****************************************************************
      *                                                              *
      * SRERR - EXCEPTION ERRORS                                     *
      *                                                              *
      ****************************************************************
     C     SRERR         BEGSR
 
     C                   MOVEL     '*ERROR '     PRtcd
     C                   MOVEL     'SE008090'    DBPGM
     C                   MOVE      '1'           *INU7
     C                   MOVE      '1'           *INU8
     C                   MOVE      '1'           *INLR
 
      ** TERMINATE THE PROGRAM
 
     C                   EXSR      *PSSR
 
     C                   ENDSR
      ****************************************************************
      /EJECT
      ****************************************************************
      ****************************************************************
      ** Program, module and procedure names for database error processing
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2005
