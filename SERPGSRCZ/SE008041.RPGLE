     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Fiscal Price Set up on Trades Init')          *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SE008041 - SE Fiscal Price Set Up on Trades                  *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2004            *
      *                                                               *
      *  Last Amend No. CER059             Date 19Jul10               *
      *  Prev Amend No. CER054             Date 07Apr09               *
      *                 CER048             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 243023             Date 16Oct06               *
      *                 CSD027A            Date 05May06               *
      *                 BUG11164           Date 06Apr06               *
      *                 236137             Date 20Sep05               *
      *                 CGL035             Date 01Mar05               *
      *                 236453             Date 30Aug05               *
      *                 234876             Date 11Jul05               *
      *                 234675             Date 05Jul05               *
      *                 234577             Date 26Jun05               *
      *                 234440             Date 21Jun05               *
      *                 233757             Date 27May05               *
      *                 CGL032 *CREATE     Date 05Jul04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER054 - German Features - Church Tax (Recompile)            *
      *  CER048 - German Features - Taxes (Recompile)                 *
      *  243023 - wrong call to AOLOCNR0
      *  CSD027A - Conversion Of Customer Number to Alpha (Recompile) *
      *  BUG11164 - A Serious Midas Error on SETRAD insert/amend      *
      *  236137 - Change Control for CGL031 Parts 4 & 5.              *
      *           Several changes in the Taxation of Savings Income   *
      *           functionality.                                      *
      *           - Choice of calculation method for fiscal price     *
      *           must take in account Tax Calculation Basis          *
      *           indicator from Country of Tax Codes file SDCTTXPD.  *
      *  CGL035 - EUSD Upgrade to Midasplus                           *
      *  236453 - Review setup of Price for Funds.                    *
      *  234876 - INVTP file must be accessed with the nominal        *
      *           currency and the investment type instead of the     *
      *           value currency                                      *
      *  234675 - Change control for processing type 4 and Dividend   *
      *           EU tax calculation.                                 *
      *  234577 - Field WFspr not initialised to 100 for bonds        *
      *  234440 - Change Control 1 Part 4 - For Switzerland only,     *
      *           bonds at at a discount will have their fiscal price *
      *           calculated on a yield curve.                        *
      *  233757 - Various errors on SE008041                          *
      *  CGL032 - Automatic Exchange of Information                   *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Function of Indicators                                       *
      *                                                               *
      *  90 - End of file for TRADS                                   *
      *  91 - Record not found in SDSECSL1                            *
      *  92 - Record not found in SECTY                               *
      *  93 - Record not found in INVTP                               *
      *  94 - End of file for PRICT                                   *
      *  99 - Error in update for TRADS                               *
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
      *  SRFilter   - Determines if the fiscal price should be input  *
      *  SRFndBnd   - Determines if the security is a bond or fund    *
      *  SRFunds    - Calculate the Fund fiscal price                 *
      *  SRBonds    - Calculate the Bond fiscal price                 *
      *  SRPercent  - Convert the yield into percentage               *
      *  *PSSR      - Program exception error routine                 *
      *  *INZSR     - Initial First Cycle processing                  *
      *  SRERR      - File error                                      *
      *                                                               *
      *****************************************************************
 
      ** Midas SE Securities
     FSECTY     IF   E           K DISK    INFSR(*PSSR)
 
      ** Midas SE Investment Types
     FINVTP     IF   E           K DISK    INFSR(*PSSR)
 
      ** Midas SD Securities clients retrieval
     FSDSECSL1  IF   E           K DISK    INFSR(*PSSR)
 
      ***Midas*SE*Trades***********************************************                       236137
     F***TRADS**   UF A E           K DISK                                                    233757
     F*TRADS*****UF*A*E***********K*DISK****PREFIX(TD)*****************                233757 236137
      ** Midas SE Trades keyed by TCNR/TDBA/TDSS.                                             236137
     FTRADSY    UF A E           K DISK    PREFIX(TD)                                         236137
 
      ** Midas SE Price
     FPRICT     IF   E           K DISK    INFSR(*PSSR)
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
 
      ** Security Details
     D SECTYDS       E DS                  EXTNAME(SECTYD)
     D   CDDS                183    230                                                       234440
     D   CRDS                231    242                                                       234440
 
      ** External DS for bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** External DS for Tax Details                                                          236453
     D SDCTTX        E DS                  EXTNAME(SDCTTXPD)                                  236453
                                                                                              236453
      ** External DS for Securities Clients
     D SDSECS        E DS                  EXTNAME(SDSECSPD)
     D BFZONE        E                     EXTFLD(SEZONE)                                     CGL035
 
      ** External DS for Branch Details                                                       234440
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)                                  234440
                                                                                              234440
      ** External DS for Location Details                                                     234440
     D SDLOCN        E DS                  EXTNAME(SDLOCNPD)                                  234440
                                                                                              234440
      ** External DS for Customer Details.                                                    236137
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)                                  236137
     D QQDFAC2       E                     EXTFLD(QQDFAC)                                     236137
      ** Short Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Long Data Structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Parameters
     D PRtcd           S              7A
     D POptn           S              7A
     D PCust           S             10A
                                                                                              236137
      ** Specific parameters for AOCUSTR0                                                     236137
     D PKyst           S              7A                                                      236137
                                                                                              236137
      ** Specific parameters for AOCTTXR0                                                     236137
     D PCtrt           S              2A                                                      236137
     D PCtrr           S              2A                                                      236137
 
      ** Working Variables
     D WFPrice         S              1A
     D WBFClas         S              1A
     D WSetx           S              1A
     D WPtyp           S              2A
     D WSesn           S             10A
     D WPdat           S              5P 0
     D*WPcst****       S              6P 0                                                   CSD027A
     D WPcst           S              6A                                                     CSD027A
     D WMaty           S              5P 0
     D WPram           S             15P 8
     D WFspr           S             15P 8
     D WStbs           S              1A
     D SCUMEX          S              1A
     D WRkpi           S             15P 9
     D WIssd           S              5P 0
     D WIssp           S             15P 8
     D WTddt           S              5P 0
     D WTdvd           S              5P 0
     D WType           S              1A
     D*WVlcy           S              3A                                                      234876
     D WNmcy           S              3A                                                      234876
     D WSitp           S              3A
     D ZPRCOT          S             15P 8
     D ZYLDOK          S              1A
     D W_TDTCNR        S                   LIKE(TDTCNR)                                       236137
 
      /EJECT
      *****************************************************************
      *                                                               *
      * MAIN - MAIN BODY                                              *
      *                                                               *
      *****************************************************************
 
      ** Set file pointer to start of file
 
     C******LOVAL        SETLL     TRADS                                                      236137
     C**********         READ      TRADS                                                      236137
     C     *LOVAL        SETLL     TRADSY                                                     236137
     C                   READ      TRADSY                                                     236137
     C
     C**********         DOW       Not%EOF(TRADS)                                             236137
     C                   DOW       Not%EOF(TRADSY)                                            236137
 
     C     TDRECI        IFNE      '*'                                                        234577
     C     TDRECI        ANDNE     'C'                                                        234577
     C     TDRECI        ANDNE     'R'                                                        234577
      *                                                                                       236453
      ** Only if Trade Value Date > Effective Date                                            236453
     C     TDTDVD        ANDGT     EWEDT1                                                     236453
                                                                                              234577
     C**********         Z-ADD     TDDT          WTddt                                        233757
     C**********         Z-ADD     TDVD          WTdvd                                        233757
     C                   Z-ADD     TDTDDT        WTddt                                        233757
     C                   Z-ADD     TDTDVD        WTdvd                                        233757
 
     C                   EXSR      SRFilter
 
     C                   IF        WFPrice = 'Y'
     C                   EXSR      SRFndBnd
 
      ** Read the Securities Prices
 
     C                   MOVE      'V '          WPtyp
     C                   Z-ADD     0             WPdat
     C*****              Z-ADD     0             WPcst                                       CSD027A
     C                   EVAL      WPcst = *blanks                                           CSD027A
 
     C     KEYPT         SETLL     PRICT
     C     KEYPTP        READE     PRICT                                  94
 
      ** Processing for Funds
 
     C                   IF        WType = 'F'
     C                   EXSR      SRFunds
     C                   ENDIF
 
      ** Processing for Bonds
 
     C                   IF        WType = 'B'
     C                   EXSR      SRBonds
     C                   ENDIF
 
     C                   ENDIF
                                                                                              234577
     C                   ENDIF                                                                234577
 
     C**********         READ      TRADS                                                      236137
     C                   READ      TRADSY                                                     236137
 
     C                   ENDDO
 
     C                   EVAL      *INLR = *ON
      ****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRFilter - Check if the fiscal price input may be done.       *
      *                                                               *
      *****************************************************************
     C     SRFilter      BEGSR
 
     C**********         MOVE      TCNR          PCust                                        233757
     C                   MOVEL     TDTCNR        PCust                                        233757
                                                                                              236137
      ** On change of customer.                                                               236137
                                                                                              236137
     C     TDTCNR        IFNE      W_TDTCNR                                                   236137
     C                   EVAL      W_TDTCNR = TDTCNR                                          236137
                                                                                              236137
      ** Get Customer Country of Residence.                                                   236137
                                                                                              236137
     C                   CALL      'AOCUSTR0'                                                 236137
     C                   PARM      *BLANK        PRtcd                                        236137
     C                   PARM      '*KEY   '     POptn                                        236137
     C                   PARM                    PCust                                        236137
     C                   PARM                    PKyst                                        236137
     C     SDCUST        PARM      SDCUST        DSSDY                                        236137
                                                                                              236137
      ** Database Error.                                                                      236137
                                                                                              236137
     C                   IF        PRtCd <> *Blanks                                           236137
     C                   EVAL      DBKEY = PCust                                              236137
     C                   EVAL      DBFILE = 'SDCUSTPD'                                        236137
     C                   EVAL      DBASE = 1                                                  236137
     C                   EXSR      *PSSR                                                      236137
                                                                                              236137
     C                   ENDIF                                                                236137
 
      ** Check if the customer is a securities customer
 
     C                   CALL      'AOSECSR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY   '     POptn
     C                   PARM                    PCust
     C     SDSECS        PARM      SDSECS        DSSDY
 
     C                   IF        PRtCd <> *Blanks
     C                   EVAL      DBKEY = PCust
     C                   EVAL      DBFILE = 'SDSECSPD'
     C                   EVAL      DBASE = 2
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDIF                                                                236137
                                                                                              236137
     C                   IF        BFCLAS = 'D' OR
     C                             BFCLAS = 'S'
     C                   EVAL      WBFClas = 'Y'
     C                   ELSE
     C                   EVAL      WBFClas = 'N'
     C                   ENDIF
 
      ** Check for Security Shortname
 
     C*****TDSS*         CHAIN     SECTY                                                      233757
     C     TDTDSS        CHAIN     SECTY                                                      233757
 
     C                   IF        NOT%FOUND(SECTY)
     C**********         EVAL      DBKEY = TDSS                                               233757
     C                   EVAL      DBKEY = TDTDSS                                             233757
     C                   EVAL      DBFILE = 'SECTYD'
     C                   EVAL      DBASE = 3
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   MOVE      SESN          WSesn
     C                   Z-ADD     ISSP          WIssp
     C                   Z-ADD     ISSD          WIssd
     C                   Z-ADD     MATY          WMaty
     C                   MOVE      STBS          WStbs
     C*****              MOVE      VLCY          WVlcy                                        234876
     C                   MOVE      NMCY          WNmcy                                        234876
 
     C                   IF        SETX = 'Y'
     C                   EVAL      WSetx = 'Y'
     C                   ELSE
     C                   EVAL      WSetx = 'N'
     C                   ENDIF
 
     C                   IF        WBFClas = 'Y' and WSETX = 'Y'
     C                   EVAL      WFPrice = 'Y'
     C                   ELSE
     C                   EVAL      WFPrice = 'N'
     C                   ENDIF
                                                                                              234440
      * On change of branch, access country of branch location                                234440
                                                                                              234440
     C     TDTDBA        IFNE      P_TDTDBA                                                   234440
                                                                                              234440
     C                   CALL      'AOBRCHR0'                                                 234440
     C                   PARM      '*DBERR '     @RTCD                                        234440
     C                   PARM      '*KEY   '     @OPTN                                        234440
     C                   PARM      TDTDBA        @BRCH             3                          234440
     C     SDBRCH        PARM      SDBRCH        DSFDY                                        234440
                                                                                              234440
     C                   CALL      'AOLOCNR0'                                                 234440
     C                   PARM      *BLANKS       @RTCD                                        234440
     C*****************  PARM      '*DBERR '     @OPTN                                 234440 243023
     C                   PARM      '*KEY   '     @OPTN                                        243023
     C                   PARM      A8LCCD        @LCCD             3                          234440
     C     SDLOCN        PARM      SDLOCN        DSFDY                                        234440
                                                                                              234440
     C                   MOVE      TDTDBA        P_TDTDBA          3                          234440
     C                   ENDIF                                                                234440
                                                                                              236137
      ** Accesses to Country of Tax Codes Details.                                            236137
                                                                                              236137
     C                   CALL      'AOCTTXR0'                                                 236137
     C                   PARM      *BLANKS       PRtcd                                        236137
     C                   PARM      '*KEY   '     POptn                                        236137
     C                   PARM      DVCNCD        PCtrt                                        236137
     C                   PARM      BBCOLC        PCtrr                                        236137
     C     SDCTTX        PARM      SDCTTX        DSFDY                                        236137
                                                                                              236137
     C                   IF        PRTCD = '*NRF   '                                          236137
                                                                                              236137
     C                   CALL      'AOCTTXR0'                                                 236137
     C                   PARM      *BLANKS       PRtcd                                        236137
     C                   PARM      '*KEY   '     POptn                                        236137
     C                   PARM      DVCNCD        PCtrt                                        236137
     C                   PARM      *BLANKS       PCtrr                                        236137
     C     SDCTTX        PARM      SDCTTX        DSFDY                                        236137
                                                                                              236137
      ** Database Error.                                                                      236137
                                                                                              236137
     C                   IF        PRtCd <> *Blanks                                           236137
     C                   MOVEL     PCtrt         DBKEY                                        236137
     C                   MOVE      PCtrr         DBKEY                                        236137
     C                   EVAL      DBFILE = 'SDCTTXPD'                                        236137
     C                   EVAL      DBASE = 5                                                  236137
     C                   EXSR      *PSSR                                                      236137
                                                                                              236137
     C                   ENDIF                                                                236137
                                                                                              236137
     C                   ENDIF                                                                236137
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRFndBnd - Check if the Security is a Fund or a Bond.         *
      *                                                               *
      *****************************************************************
     C     SRFndBnd      BEGSR
 
     C                   MOVE      SITP          WSitp
     C*****              MOVE      VLCY          WVlcy                                        234876
     C                   MOVE      NMCY          WNmcy                                        234876
 
     C     KEYIVT        CHAIN     INVTP                              93
 
     C                   IF        NOT%FOUND(INVTP)
     C*****              EVAL      DBKEY = SITP + VLCY                                        234876
     C                   EVAL      DBKEY = SITP + NMCY                                        234876
     C                   EVAL      DBFILE = 'INVTPD'
     C                   EVAL      DBASE = 4
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Identify the processing type and determine if funds or bonds.
 
     C                   EVAL      WType = *Blanks
 
     C                   IF        PROT = '7'
     C                             OR PROT = '4' AND SETX = 'Y'                               234675
     C                   EVAL      WType = 'F'
     C                   ENDIF
 
     C                   IF        PROT <> '7' AND
     C                             PROT <> '4' AND
     C**********                   PROT <> '2' AND                                            233757
     C**********                   ISSP < 100                                                 233757
     C                             PROT <> '2'                                                233757
     C                   EVAL      WType = 'B'
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRFunds - Set the Fiscal Price for Funds.                     *
      *                                                               *
      *****************************************************************
     C     SRFunds       BEGSR
 
     C**********         IF        *IN94 = *OFF AND                                           236453
     C**********                   RECI = 'D'                                                 236453
     C**********         Z-ADD     PEXI          FSPR                                         233757
     C**********         Z-ADD     PEXI          TDFSPR                                233757 236453
      **********                                                                              236453
     C**********         UPDATE    TRADSDF                              99                    236453
      **********                                                                              236453
     C**********         ENDIF                                                                236453
      *                                                                                       236453
      ** If Trade Value Date <= Effective Date ==> Should be 0                                236453
     C     TDTDVD        IFLE      EWEDT1                                       - B1          236453
     C                   Z-ADD     *ZEROS        TDFSPR                                       236453
     C                   ELSE                                                   - X1          236453
      *                                                                                       236453
      ** Position after Value Date and Retrieve previous price.                               236453
     C                   Z-ADD     TDTDVD        WPdat                                        236453
     C     KEYPT         SETGT     PRICT                                                      236453
     C     KEYPTP        READPE    PRICT                                  94                  236453
      *                                                                                       236453
     C                   IF        *IN94 = *OFF and RECI = 'D'                  - B2          236453
      *                                                                                       236453
      ** If Price Value Date is before effective date ==> Should be 0                         236453
     C     PVDT          IFLT      EWEDT1                                       - B3          236453
     C                   Z-ADD     *ZEROS        TDFSPR                                       236453
     C                   ELSE                                                   - X3          236453
     C                   Z-ADD     PEXI          TDFSPR                                       236453
     C                   ENDIF                                                  - E3          236453
      *                                                                                       236453
      ** No record found on PF/PRICED                                                         236453
     C                   ELSE                                                                 236453
     C                   Z-ADD     *ZEROS        TDFSPR                                       236453
     C                   ENDIF                                                  - E2          236453
      *                                                                                       236453
     C                   ENDIF                                                  - E1          236453
      *                                                                                       236453
      ** Update SE Trade record                                                               236453
     C                   UPDATE    TRADSDF                              99                    236453
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRBonds - Set the Fiscal Price for Bonds.                     *
      *                                                               *
      *****************************************************************
     C     SRBonds       BEGSR
 
     C                   IF        WIssp = 0 OR
     C                             WIssd = 0 OR
     C                             WIssp >= 100
 
     C**********         Z-ADD     PPRC          FSPR                                         233757
     C                   Z-ADD     100           TDFSPR                                       233757
     C                   Z-ADD     100           TDFSPP                                       233757
     C                   Z-ADD     100           WFspr                                        234577
 
     C                   ELSE
 
     C                   Z-ADD     100           WPram
 
      ** Choice of calculation method for fiscal price depends on Tax                         236137
      ** Calculation Basis indicator from Country of Tax Codes file.                          236137
                                                                                              236137
      ** Straight line basis:                                                                 236137
                                                                                              236137
     C*****DVCNCD        IFNE      'CH'                                                234440 236137
     C     EWTXCB        IFEQ      'B'                                                        236137
     C                   CALLB     'ZAINTPL2'
     C                   PARM                    WIssd
     C**********         PARM                    WTddt                                        233757
     C                   PARM                    WTdvd                                        233757
     C                   PARM                    WMaty
     C                   PARM                    WIssp
     C                   PARM                    WPram
     C                   PARM                    WFspr
                                                                                              236137
      ** Actuarial interpolation:                                                             236137
                                                                                              236137
     C                   ELSE                                                                 234440
     C                   CALL      'ZAACTUAR'                                                 234440
     C                   PARM      *BLANK        WRTCD            10                          234440
     C                   PARM                    WIssd                                        234440
     C                   PARM                    WIssp                                        234440
     C                   PARM                    WMaty                                        234440
     C                   PARM                    WPram                                        234440
     C                   PARM                    DYBS                                         234440
     C                   PARM                    DVBS                                         234440
     C                   PARM                    CDDS             48                          234440
     C                   PARM                    CRDS             12                          234440
     C                   PARM                    LCPN                                       BUG11164
     C                   PARM                    WTdvd                                        234440
     C                   PARM                    WFspr                                        234440
     C                   ENDIF                                                                234440
 
     C                   ENDIF
 
     C                   IF        WStbs = 'Y'
     C                   EXSR      SRPercent
     C                   ELSE
     C**********         Z-ADD     WFspr         FSPR                                         233757
     C                   Z-ADD     WFspr         TDFSPR                                       233757
     C                   Z-ADD     TDFSPR        TDFSPP                                       233757
     C                   ENDIF
 
     C                   UPDATE    TRADSDF                              99
 
     C                   IF        *IN99 = '1'
     C                   EXSR      SRERR
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRPercent - Converts the Price from a Yield format to a       *
      *             percent format.                                   *
      *                                                               *
      *****************************************************************
     C     SRPercent     BEGSR
 
      ** Calculate PI as a fraction of Nominal
 
     C*****NOML*         IFNE      0                                                          233757
     C*****ITRA*         DIV       NOML          WRkpi                                        233757
     C     TDNOML        IFNE      0                                                          233757
     C     TDITRA        DIV       TDNOML        WRkpi                                        233757
     C                   ELSE
     C                   Z-ADD     0             WRkpi
     C                   END
 
      * Cum/Ex ind.
 
     C*****ACIN*         IFEQ      'X'                                                        233757
     C     TDACIN        IFEQ      'X'                                                        233757
     C                   MOVE      'X'           SCUMEX
     C                   ELSE
     C                   MOVE      'C'           SCUMEX
     C                   END
 
     C                   CALLB     'ZPRCI'
     C                   PARM                    WFspr
     C                   PARM                    WTdvd
     C                   PARM                    SECTYDS
     C                   PARM                    NMDP
     C                   PARM                    PROT
     C**********         PARM                    NOML                                         233757
     C                   PARM                    TDNOML                                       233757
     C                   PARM                    WRKPI
     C                   PARM                    SCUMEX
     C                   PARM                    BJDFIN
     C                   PARM                    ZYLDOk
     C                   PARM                    ZPRCOT
 
     C**********         Z-ADD     WFspr         FSPR                                         233757
     C**********         Z-ADD     ZPRCOT        FSPP                                         233757
     C                   Z-ADD     WFspr         TDFSPR                                       233757
     C                   Z-ADD     ZPRCOT        TDFSPP                                       233757
 
     C                   ENDSR
      *****************************************************************
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
     C                   PARM      '*DBERR '     PRtcd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Define key list for file
 
     C     KEYPT         KLIST
     C                   KFLD                    WPtyp
     C                   KFLD                    WSesn
     C                   KFLD                    WPdat
     C                   KFLD                    WPcst
 
     C     KEYPTP        KLIST
     C                   KFLD                    WPtyp
     C                   KFLD                    WSesn
 
     C     KEYIVT        KLIST
     C*****              KFLD                    WVlcy                                        234876
     C                   KFLD                    WNmcy                                        234876
     C                   KFLD                    WSitp
 
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
     C                   MOVEL     'SE008040'    DBPGM
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
(c) Misys International Banking Systems Ltd. 2004
