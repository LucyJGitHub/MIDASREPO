     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM Validate Midas Taxable indicator')            *
      *****************************************************************
      *                                                               *
      *  Midas - Money Market Dealing Module                          *
      *                                                               *
      *  MMVTAXIND  - Validate Midas Taxable indicator                *
      *                                                               *
      *  Function:  This module receives a parameter containing the   *
      *             Midas Taxable Indicator and confirms whether it   *
      *             has a valid value.                                *
      *             If it is valid the 10A return code will be blank, *
      *             if it is not it will contain  'Error'             *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CER069             Date 03Jul14               *
      *                 MD028368           Date 19Aug14               *
      *                 CLE134             Date 01Aug12               *
      *                 AR762349A          Date 08Jun11               *
      *                 AR762349           Date 03Jun11               *
      *                 CER059             Date 19Jul10               *
      *                 BUG25912A          Date 10Sep09               *
      *                 BUG25912           Date 08Sep09               *
      *                 BUG24265           Date 23Jun09               *
      *                 BUG23887A          Date 18Jun09               *
      *                 BUG23485A          Date 17Apr09               *
      *                 BUG23887           Date 09Jun09               *
      *                 BUG23485           Date 20Mar09               *
      *                 BUG23048           Date 20Feb09               *
      *                 CER048             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 241001             Date 03Aug06               *
      *                 CSD031             Date 10Apr06               *
      *                 CDL013             Date 10Jul06               *
      *                 CSD027             Date 09Dec05               *
      *                 CLE025             Date 20Oct03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CRE007             Date 01Mar01               *
      * Midas DBA 3.01 -----------------------------------------------*
      *                 CDL006             Date 26Apr99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP002  *CREATE    Date 17Sep97               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CER069 - German Tax Enhancement                              *
      *  MD028368 - Taxable Indicator defaulted to 'T' if             *
      *             counterparty is taxable.                          *
      *           - Defaulting to 'T' rules should only apply to      *
      *             deposit deals.                                    *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  AR762349A - Self-Report Customer validation issues Reopen    *
      *  AR762349 - Self-Report Customer validation issues            *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG25912A - Trades for customers that are set up to pay WHT  *
      *              are been processed as nontaxable trades          *
      *  BUG25912 - Trades for customers that are set up to pay WHT   *
      *             are been processed as nontaxable trades           *
      *  BUG24265 - Serious Midas Error occured on blank customer     *
      *             Applied fix 23485A                                *
      *  BUG23887A - Options Y/N should be valid if customer details  *
      *              taxable indicator is Y and Threshold Method is N *
      *  BUG23485A - Serious Midas Error occurred for empty Customer  *
      *  BUG23887 - Taxable Indicator defaults to Threshold           *
      *  BUG23485 - Serious Midas Error occurred for Invalid Customer *
      *  BUG23048 - Check tax status from SDACTXPD                    *
      *  CER048 - German Features - Taxes                             *
      *  241001 - Default 'N' as tax indicator for TD/IT deals with   *
      *           amount *GE 50,000GBP. Applied fixes 234019, 227193. *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CDL013 - Tiered Withholding Tax                              *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CRE007 - Base Rate Tax 2001.                                 *
      *  CDL006 - Dealing Fiduciary.                                  *
      *  CAP002 - Conversion of MM inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      * Midas BRT Customer Details
     FSDCBRTL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     USROPN
      *                                                                                     BUG23048
      ** Customer Details by Country of Tax                                                 BUG23048
     FSDACTXL1  IF   E           K DISK    INFSR(*PSSR)                                     BUG23048
                                                                                            BUG23887
     FSDCTTXL0  IF   E           K DISK                                                     BUG23887
      *                                                                                     BUG23887
      ** Midas SD Country of Tax Codes                                                      BUG23887
      *                                                                                     BUG23887
 
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
 
      ** Include the MM standard declares
     D/COPY ZACPYSRC,STDDECLARE
 
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
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D DSSDY         E DS                  EXTNAME(DSSDY)                       CRE007
      ** First DS for Access Programs, Long Date Structure                      CRE007
                                                                                CRE007
     D SDCURR        E DS                  EXTNAME(SDCURRPD)                    CRE007
      ** External DS for Currency Details                                       CRE007
                                                                                CRE007
     D DSFDY         E DS                  EXTNAME(DSFDY)                                     CER048
      *                                                                                       CER048
      ** First DS For Access Programs, Short Data Structure                                   CER048
      *                                                                                       CER048
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)                                BUG23048
     D  WBBTAIN      E                     EXTFLD(BBTAIN)                                   BUG23048
     D  WBBCSTY      E                     EXTFLD(BBCSTY)                                   BUG23048
      *                                                                                     BUG23048
      ** External DS for Customer Details                                                   BUG23048
      *                                                                                     BUG23048
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)                                BUG23048
     D  WQQDFAC      E                     EXTFLD(QQDFAC)                                   BUG23048
      *                                                                                     BUG23048
      ** External DS for Branch Details                                                     BUG23048
      *                                                                                     BUG23048
     D SDLOCN        E DS                  EXTNAME(SDLOCNPD)                                BUG23048
      *                                                                                     BUG23048
      ** External DS for Location Codes                                                     BUG23048
      *                                                                                     BUG23048
     D DSLDY         E DS                  EXTNAME(DSLDY)                                   BUG23048
      *                                                                                     BUG23048
      ** Third DS For Access Programs, Long Data Structure                                  BUG23048
      *                                                                                     BUG23048
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CER048
      *                                                                                       CER048
      ** External DS for SAR Details                                                          CER048
      *                                                                                       CER048
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Error message field received as a parameter
     D Msgid1          S                   LIKE(#MsgID)
      *                                                                                       CER048
      ** Error message field received as a parameter                                          CER048
      *                                                                                       CER048
     D Msgid2          S                   LIKE(#MsgID)                                       CER048
      *                                                                                     BUG23048
      ** Parameters for Access programs and key list fields                                 BUG23048
      *                                                                                     BUG23048
     D PLccd           S              3A                                                    BUG23048
     D PKyst           S              7A                                                    BUG23048
     D PKey1           S             10A                                                    BUG23048
     D PBrca           S              3A                                                    BUG23048
     D KCust           S              6A                                                    BUG23048
     D KCtax           S              2A                                                    BUG23048
 
      ** Midas Taxable indicator received as a parameter
     D DDMTAX          S              1A
      *                                                                                     BUG23048
      ** Branch of the transaction as entered on screen                                     BUG23048
     D DDBRCA          S              3A                                                    BUG23048
 
      ** Basic Rate Tax SAR Flag - received as a parameter
     D BRTind          S              1A
 
      ** Deal Type received as a parameter
     D DDType          S              2A
 
      ** Deal Type OK received as a parameter
     D DDTypeOK        S              1A
 
      ** CUSTOMER received as a parameter
     D DDCUST          S             10A
 
      ** CUSTOMER OK received as a parameter
     D DDCUSTOK        S              1A
 
      ** Customer Number
     D*IKCNum***       S              6S 0                                                    CSD027
     D IKCNum          S              6A                                                      CSD027
 
      ** Taxable Indicator (SDCUSTPD) - received as a parameter
     D BBTAIN          S              1A
 
      ** Allow direct call to SD2410 indicator - received as a parameter
     D AlwCali         S              1A
                                                                                CDL006
     D CDL006          S              1A   IMPORT                               CDL006
 
      ** Principal Amount - received as a parameter                             CRE007
     D IKAMNP          S             15P 0                                      CRE007
                                                                                CRE007
      ** Deal Currency - received as a parameter                                CRE007
     D DDCCY           S              3A                                        CRE007
                                                                                CRE007
      ** Local Currency - received as a parameter                               CRE007
     D BJLCCY          S              3A                                        CRE007
                                                                                CRE007
      *Withholding tax Flag received as a parameter                                          CDL013
     D CDL013          S              1A                                                     CDL013
      ** Customer type (SDCUSTPD) - received as a parameter                                  CDL013
     D BBCSTY          S              1A                                                     CDL013
      *
     D CER048          S              1A                                                      CER048
     D PWarnFnd        S              1A                                                      CER048
     D PRtcd           S              7A                                                      CER048
     D POptn           S              7A                                                      CER048
     D PSard           S              6A                                                      CER048
     D CER069          S              1A                                                      CER069
      *                                                                                     BUG23887
     D KCtTx           S              2A                                                    BUG23887
     D KCtRe           S              2A                                                    BUG23887
     D WThrMtd         S              1A                                                    BUG23887
      *                                                                                       CER048
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      ** Reset error flags & msgs to prevent problems on subsequent calls
     C                   RESET                   ErrorFound
     C                   RESET                   Msgid1
     C                   RESET                   Msgid2                                       CER048
      *                                                                                     BUG23048
      ** Retrieve Country of Tax Details                                                    BUG23048
      *                                                                                     BUG23048
     C                   EXSR      SrRtvCust                                                BUG23048
      *                                                                                       CER048
      ** Default Interest Taxable                                                             CER048
      *                                                                                       CER048
     C                   IF        CER048 = 'Y'                                               CER048
      *                                                                                       CER048
     C                   IF        DDMTAX = *BLANKS                                           CER048
      *                                                                                       CER048
     C**********         IF        BBTAIN = 'Y'                                      CER048 BUG23048
     C                   IF        CER069 = 'Y' AND AXETXS <> ' '                             CER069
     C                   EVAL      DDMTAX = 'A'                                               CER069
     C                   ELSE                                                                 CER069
     C                   IF        AXETXS = 'T'                                             BUG23048
     C                             and WThrMtd = 'Y'                                        BUG23887
     C                             AND (DDType = 'TD' OR DDType = 'CD')                     MD028368
     C                   EVAL      DDMTAX = 'T'                                               CER048
     C                   ELSE                                                                 CER048
     C                   EVAL      DDMTAX = 'N'                                               CER048
     C                   ENDIF                                                                CER048
      *                                                                                       CER048
     C                   ENDIF                                                                CER069
      *                                                                                       CER069
     C                   ENDIF                                                                CER048
      *                                                                                       CER069
      * Error out when Tax Indicator on Customer Level is Blanks and                          CER069
      * Tax Indicator on Transaction level is 'A' (triggers usage of                          CER069
      * Tax Indicator on Customer Level)                                                      CER069
     C                   IF        CER069 = 'Y' AND AXETXS = *BLANKS                          CER069
     C                             AND DDMTAX = 'A'                                           CER069
     C                   EVAL      ErrorFound = 'Y'                                           CER069
     C                   EVAL      Msgid1 = '5046499'                                         CER069
     C                   ENDIF                                                                CER069
      *                                                                                       CER069
      ** Valid Values are T, Y, N or A when CER069 is ON                                      CER069
      *                                                                                       CER069
     C                   IF        CER069 = 'Y'                                               CER069
     C                   IF        DDMTAX <>'T' AND DDMTAX <> 'Y' AND                         CER069
     C                             DDMTAX <> 'N' AND DDMTAX <> 'A'                            CER069
     C                   EVAL      ErrorFound = 'Y'                                           CER069
     C                   EVAL      Msgid1 = '5046497'                                         CER069
     C                   ENDIF                                                                CER069
                                                                                              CER069
     C                   ELSE                                                                 CER069
      *                                                                                       CER048
      ** Valid Values are T, Y or N                                                           CER048
      *                                                                                       CER048
     C                   IF        (DDMTAX <> 'T') AND                                        CER048
     C                             (DDMTAX <> 'Y') AND                                        CER048
     C                             (DDMTAX <> 'N')                                            CER048
     C                   EVAL      ErrorFound = 'Y'                                           CER048
     C                   EVAL      Msgid1 = 'MMM1073'                                         CER048
     C                   ENDIF                                                                CER048
      *                                                                                       CER048
     C                   ENDIF                                                                CER069
      ***Y*or*T*can*only*be*entered*if*the*account*holder*is*taxable****************CER048 BUG23887A
      *                                                                                       CER048
      ** Y/N can be entered if Account Holder is Taxable regardless of Threshold Method    BUG23887A
      ** T can only be entered if Threshold Method is 'Y' and Account Holder is Taxable    BUG23887A
     C**********         IF        (DDMTAX = 'Y' OR DDMTAX = 'T') AND               CER048 BUG23887A
     C**********                   (BBTAIN <> 'Y')                                   CER048 BUG23048
     C**********                   (AXETXS <> 'T')                                BUG23048 BUG23887A
     C                   IF        (DDMTAX = 'T') AND (AXETXS = 'T') AND                   BUG23887A
     C                             (WThrMtd <> 'Y')                                        BUG23887A
     C                   EVAL      ErrorFound = 'Y'                                           CER048
     C                   EVAL      Msgid1 = 'MMM1074'                                         CER048
     C                   ENDIF                                                                CER048
      *                                                                                       CER048
      ** N can only be entered if Account holder is Non-Taxable                             AR762349
     C                   IF        (DDMTAX = 'Y' OR DDMTAX = 'T') AND                       AR762349
     C                             (AXETXS='S' OR AXETXS='E' OR AXETXS='D')                   CER069
     C**********                   (AXETXS <> 'T') AND (WThrMtd <> 'Y')           AR762349 AR762349A
     C**********                   (AXETXS <> 'T')                                  AR762349A CER069
     C                   EVAL      ErrorFound = 'Y'                                         AR762349
     C                   EVAL      Msgid1 = 'MMM1080'                                       AR762349
     C                   ENDIF                                                              AR762349
      *                                                                                     AR762349
      ** Issue a warning, if account holder is                                                CER048
      ** taxable and N has been entered                                                       CER048
      *                                                                                       CER048
     C**********         IF        (BBTAIN = 'Y') AND                                CER048 BUG23048
     C**********         IF        (AXETXS = 'T') AND                                BUG23048 CER069
     C**********                   (DDMTAX = 'N')                                   CER048 BUG23887A
     C                   IF        (AXETXS = 'T' OR                                           CER069
     C                             (AXETXS = 'Y' AND CER069 = 'Y')) AND                       CER069
     C                             (DDMTAX = 'N') AND                                      BUG23887A
     C                             (WthrMTd = 'Y')                                         BUG23887A
     C                   EVAL      PWarnFnd = 'Y'                                             CER048
     C                   EVAL      Msgid2 = 'MMM1075'                                         CER048
     C                   ENDIF                                                                CER048
      *                                                                                       CER048
     C                   ELSE                                                                 CER048
 
      ** +----------------------------+
      ** * Validate Taxable Indicator *
      ** +----------------------------+
 
      ** IF BRT SAR IS INSTALLED
      *  -----------------------
      *
     C     BRTInd        IFEQ      'Y'
      *
      **  If the taxable indicator does not have the value 'Y','N', 'X'
      *   or blank, it is an error.
      *
     C     DDMTAX        IFNE      *BLANK
     C     DDMTAX        ANDNE     'Y'
     C     DDMTAX        ANDNE     'N'
     C     DDMTAX        ANDNE     'X'
     C     CRE007        ANDNE     'Y'                                          CRE007
     C                   MOVEL     'MMM0590'     Msgid1
     C                   MOVE      'Y'           ErrorFound
      *
      **  If customer and deal type are valid,
      *
     C                   ELSE
     C     DDCustOK      IFNE      'N'
     C     DDTypeOK      ANDNE     'N'
     C     DDTYPE        ANDNE     *BLANKS
     C     DDCUST        ANDNE     *BLANKS
      *
      ****If*deal*type*is*IT,*TD*or*CD,*************************************    CDL006
      **  If deal type is IT, TD or CD, DT, LT, or FT                           CDL006
      *
     C     DDTYPE        IFEQ      'IT'
     C     DDTYPE        OREQ      'TD'
     C     DDTYPE        OREQ      'CD'
     C     DDTYPE        OREQ      'DT'                                         CDL006
     C     CDL006        ANDEQ     'Y'                                          CDL006
     C     DDTYPE        OREQ      'LT'                                         CDL006
     C     CDL006        ANDEQ     'Y'                                          CDL006
     C     DDTYPE        OREQ      'FT'                                         CDL006
     C     CDL006        ANDEQ     'Y'                                          CDL006
      *
 
     C     IKCNUM        CHAIN     SDCBRTL1                           65
      *                  ~~~~~
     C     *IN65         IFEQ      '1'
     C     XRECI         ORNE      'D'
     C     DDTYPE        IFEQ      'DT'                                         CDL006
     C     CDL006        ANDEQ     'Y'                                          CDL006
     C     DDTYPE        OREQ      'LT'                                         CDL006
     C     CDL006        ANDEQ     'Y'                                          CDL006
     C     DDTYPE        OREQ      'FT'                                         CDL006
     C     CDL006        ANDEQ     'Y'                                          CDL006
     C                   MOVEL     'MMM9018'     MSGID1                         CDL006
     C                   ELSE                                                   CDL006
     C                   MOVEL     'MMM0591'     MSGID1
     C                   ENDIF                                                  CDL006
     C                   MOVE      'Y'           ErrorFound
     C                   END
      *                                                                         CRE007
      **  If Base Rate Tax 2001 is ON, Taxable Indicator can only be 'X'        CRE007
      **  for Fiduciary Deals, Deal types DT, LT, or FT.                        CRE007
      *                                                                         CRE007
     C     CRE007        IFEQ      'Y'                                          CRE007
      *                                                                         CRE007
     C     DDTYPE        IFEQ      'DT'                                         CRE007
     C     CDL006        ANDEQ     'Y'                                          CRE007
     C     DDTYPE        OREQ      'LT'                                         CRE007
     C     CDL006        ANDEQ     'Y'                                          CRE007
     C     DDTYPE        OREQ      'FT'                                         CRE007
     C     CDL006        ANDEQ     'Y'                                          CRE007
      *                                                                         CRE007
     C     DDMTAX        IFNE      'X'                                          CRE007
     C                   MOVEL     'MMM0695'     Msgid1                         CRE007
     C                   MOVE      'Y'           ErrorFound                     CRE007
     C                   GOTO      ETAXVL                                       CRE007
     C                   ENDIF                                                  CRE007
     C                   ENDIF                                                  CRE007
     C                   ENDIF                                                  CRE007
      *                                                                         CRE007
      **  If the Account Holder Type is 'R' and the taxable indicator           CRE007
      **  does not have the value 'N' or 'X', it is an error.                   CRE007
      *                                                                         CRE007
     C     ACHLRT        IFEQ      'R'                                          CRE007
      *                                                                         CRE007
     C     DDMTAX        IFNE      *BLANK                                       CRE007
     C     DDMTAX        ANDNE     'X'                                          CRE007
     C     DDMTAX        ANDNE     'N'                                          CRE007
     C                   MOVEL     'MMM0694'     Msgid1                         CRE007
     C                   MOVE      'Y'           ErrorFound                     CRE007
     C                   ENDIF                                                  CRE007
      *                                                                         CRE007
     C                   ELSE                                                   CRE007
      *                                                                         CRE007
      **  If the taxable indicator does not have the value 'Y','N', 'X'         CRE007
      **  or blank, it is an error.                                             CRE007
      *                                                                         CRE007
     C     DDMTAX        IFNE      *BLANK                                       CRE007
     C     DDMTAX        ANDNE     'Y'                                          CRE007
     C     DDMTAX        ANDNE     'N'                                          CRE007
     C     DDMTAX        ANDNE     'X'                                          CRE007
     C                   MOVEL     'MMM0590'     Msgid1                         CRE007
     C                   MOVE      'Y'           ErrorFound                     CRE007
     C                   ENDIF                                                  CRE007
      *
      **  Error if deal tax indicator is Y and customer
      **  is not liable for BRT
      *
     C     DDMTAX        IFEQ      'Y'
     C     TAXIND        IFEQ      'X'
     C     TAXIND        OREQ      'N'
     C                   MOVEL     'MMM0592'     MSGID1
     C                   MOVE      'Y'           ErrorFound
     C                   END
     C                   END
      *                                                                                       241001
      ** Tax indicator 'N' is valid for TD and IT deals where the                             241001
      ** Principal amount is equal or greater than 50,000.                                    241001
      *                                                                                       241001
     C                   MOVE      *ZERO         ULAMCO                                       241001
     C     CRE007        IFEQ      'Y'                                                        241001
      *                                                                                       241001
     C     DDTYPE        IFEQ      'TD'                                                       241001
     C     TAXIND        ANDEQ     'L'                                                        241001
     C     DDTYPE        OREQ      'TD'                                                       241001
     C     TAXIND        ANDEQ     'P'                                                        241001
     C     DDTYPE        OREQ      'IT'                                                       241001
     C     TAXIND        ANDEQ     'L'                                                        241001
     C     DDTYPE        OREQ      'IT'                                                       241001
     C     TAXIND        ANDEQ     'P'                                                        241001
      *                                                                                       241001
      ** Access GBP curreny details                                                           241001
      *                                                                                       241001
     C                   MOVE      IKAMNP        ULAMCO                                       241001
      *                                                                                       241001
     C                   CALL      'AOCURRR0'                                                 241001
     C                   PARM      '*DBERR '     @RTCD             7                          241001
     C                   PARM      '*KEY   '     @OPTN             7                          241001
     C                   PARM                    BJLCCY                                       241001
     C     SDCURR        PARM      SDCURR        DSSDY                                        241001
      *                                                                                       241001
     C                   MOVE      BJLCCY        ZCCYO             3                          241001
     C                   Z-ADD     A6SPRT        ULRATO           13 8                        241001
     C                   Z-ADD     A6NBDP        ZCDPO             1 0                        241001
     C                   MOVE      A6MDIN        ULZMDO            1                          241001
      *                                                                                       241001
      ** If Deal currency is not GBP then Access Deal CCY details                             241001
      *                                                                                       241001
     C     DDCCY         IFNE      BJLCCY                                                     241001
      *                                                                                       241001
     C                   CALL      'AOCURRR0'                                                 241001
     C                   PARM      '*DBERR '     @RTCD             7                          241001
     C                   PARM      '*KEY   '     @OPTN             7                          241001
     C                   PARM                    DDCCY                                        241001
     C     SDCURR        PARM      SDCURR        DSSDY                                        241001
      *                                                                                       241001
     C                   Z-ADD     IKAMNP        ZAMTCI           15 0                        241001
     C                   MOVE      DDCCY         ZCCYI             3                          241001
     C                   Z-ADD     A6SPRT        ULRATI           13 8                        241001
     C                   Z-ADD     A6NBDP        ZCDPI             1 0                        241001
     C                   MOVE      A6MDIN        ULZMDI            1                          241001
      *                                                                                       241001
      ** Initialize Cross Exchange Rate to Zero                                               241001
     C                   Z-ADD     *ZEROS        ZEXCH                                        241001
      *                                                                                       241001
      ** If Mult/Div Indic. for 'FROM' is = Mult/Div Indic for 'TO'                           241001
      ** Indic and Spot Rate for 'TO' Currency (ZRATET) is not = Zero                         241001
     C     ULZMDI        IFEQ      ULZMDO                                                     241001
     C     ULRATO        ANDNE     *ZEROS                                                     241001
     C     ULRATI        DIV       ULRATO        ZEXCH                                        241001
      *                                                                                       241001
      ** If Milt/Div Indic for 'FROM' is Not = Mult/Div Indic For 'TO'                        241001
      ** Indic or Spot Rate for 'TO' Currency (ULRATO) is = Zero                              241001
     C                   ELSE                                                                 241001
     C     ULRATI        MULT      ULRATO        ZEXCH                                        241001
     C                   END                                                                  241001
      *                                                                                       241001
      ** Move Mult/Div Indic for 'FROM' Currency to Cross Rate Mult/Div                       241001
      ** Indicator (ZMD)                                                                      241001
     C                   MOVE      ULZMDI        ZMD                                          241001
      *                                                                                       241001
      ** Convert Amount                                                                       241001
     C                   CALLB     'ZCONV'                                                    241001
     C                   PARM                    ZAMTCI           15 0                        241001
     C                   PARM                    ZEXCH            13 8                        241001
     C                   PARM                    ZMD               1                          241001
     C                   PARM                    ZCCYI             3                          241001
     C                   PARM                    ZCCYO             3                          241001
     C                   PARM                    ZCDPI             1 0                        241001
     C                   PARM                    ZCDPO             1 0                        241001
     C                   PARM                    ZAMTCO           15 0                        241001
      *                                                                                       241001
     C                   MOVE      ZAMTCO        ULAMCO           15 2                        241001
      *                                                                                       241001
     C                   ENDIF                                                                241001
     C                   ENDIF                                                                241001
     C                   ENDIF                                                                241001
      *
      **  Error if deal tax indicator is N and customer tax indicator
      **  is L or P.
      *
     C     DDMTAX        IFEQ      'N'
     C     TAXIND        IFEQ      'L'
     C     TAXIND        OREQ      'P'
     C     ULAMCO        IFLT      50000                                                      241001
     C                   MOVEL     'MMM0593'     MSGID1
     C                   MOVE      'Y'           ErrorFound
     C                   END                                                                  241001
     C                   END
     C                   END
      *
      **  Warning message if deal tax indicator is X and
      **  customer is BRT liable.
      *
     C     TAXIND        IFEQ      'L'
     C     TAXIND        OREQ      'P'
     C     AlwCali       IFEQ      'Y'
     C     DDMTAX        ANDEQ     'X'
     C                   MOVEL     'MMM1050'     MSGID1
     C                   MOVE      'Y'           ErrorFound
     C                   END
      *
     C                   ELSE
      *                                                                                       241001
      ** If account holder type is 'C', 'B', 'N' or 'O', taxable                              241001
      ** indicator should be 'N'.  Else, error.                                               241001
      *                                                                                       241001
     C     ACHLRT        IFEQ      'C'                                                        241001
     C     DDMTAX        ANDNE     'N'                                                        241001
     C     DDMTAX        ANDNE     *BLANK                                                     241001
     C     ACHLRT        OREQ      'B'                                                        241001
     C     DDMTAX        ANDNE     'N'                                                        241001
     C     DDMTAX        ANDNE     *BLANK                                                     241001
     C     ACHLRT        OREQ      'N'                                                        241001
     C     DDMTAX        ANDNE     'N'                                                        241001
     C     DDMTAX        ANDNE     *BLANK                                                     241001
     C     ACHLRT        OREQ      'O'                                                        241001
     C     DDMTAX        ANDNE     'N'                                                        241001
     C     DDMTAX        ANDNE     *BLANK                                                     241001
     C                   MOVEL     'MMM0594'     MSGID1                                       241001
     C                   MOVE      'Y'           ErrorFound                                   241001
     C                   ELSE                                                                 241001
      *
      ** Error message if deal tax indicator is not 'N' or blank
      ** and customer is not liable to BRT.
      *
     C     DDMTAX        IFNE      *BLANK
     C     DDMTAX        ANDNE     'N'
     C     DDMTAX        ANDNE     'X'                                                        241001
     C                   MOVEL     'MMM0594'     MSGID1
     C                   MOVE      'Y'           ErrorFound
     C                   ELSE
     C**********         MOVE      'N'           DDMTAX                                       241001
      *                                                                                       241001
      ** If Account Holder Type is 'C', 'B', 'N' or 'O' and                                   241001
      ** Taxable Indicator is blank, default to 'N'.                                          241001
      *                                                                                       241001
     C     ACHLRT        IFEQ      'C'                                                        241001
     C     ACHLRT        OREQ      'B'                                                        241001
     C     ACHLRT        OREQ      'N'                                                        241001
     C     ACHLRT        OREQ      'O'                                                        241001
     C                   MOVE      'N'           DDMTAX                                       241001
     C                   ENDIF                                                                241001
     C                   END
     C                   END
      *
     C                   ENDIF                                                                241001
     C                   ENDIF                                                  CRE007
     C                                                                          CRE007
     C     ETAXVL        TAG                                                    CRE007
      *                                                                         CRE007
      **  Default taxable indicator
      *
     C     DDMTAX        IFEQ      *BLANK
     C     TAXIND        IFEQ      'L'
     C     TAXIND        OREQ      'P'
     C                   MOVE      'Y'           DDMTAX
     C                   ELSE
     C                   MOVE      TAXIND        DDMTAX
     C                   END
      *                                                                         CRE007
      ** If Base Rate Tax 2001 is ON, default tax indicator to 'X'              CRE007
      ** for Fiduciary Deals, Deal types DT, LT, or FT.                         CRE007
      *                                                                         CRE007
     C     CRE007        IFEQ      'Y'                                          CRE007
      *                                                                         CRE007
     C     DDTYPE        IFEQ      'DT'                                         CRE007
     C     CDL006        ANDEQ     'Y'                                          CRE007
     C     DDTYPE        OREQ      'LT'                                         CRE007
     C     CDL006        ANDEQ     'Y'                                          CRE007
     C     DDTYPE        OREQ      'FT'                                         CRE007
     C     CDL006        ANDEQ     'Y'                                          CRE007
      *                                                                         CRE007
     C                   MOVE      'X'           DDMTAX                         CRE007
     C                   GOTO      ETAXDF                                       CRE007
     C                   ENDIF                                                  CRE007
     C                   ENDIF                                                  CRE007
      *                                                                         CRE007
      ** If Account holder type is 'R' default tax indicator to 'N'             CRE007
      *                                                                         CRE007
 B5  C     ACHLRT        IFEQ      'R'                                          CRE007
     C                   MOVE      'N'           DDMTAX                         CRE007
      *                                                                         CRE007
 X5  C                   ELSE                                                   CRE007
      *                                                                         CRE007
      ***If*Deal*is*a*Time*Deposit*(TD)*and*Principal*amount*is********                CRE007 241001
      ***>=*50,000*GBP*default*tax*indicator*to*'X'.*******************                CRE007 241001
      ** If deal is TD or IT and Principal amount is                                          241001
      ** >= 50,000 GBP, default tax indicator to 'N'.                                         241001
      *                                                                         CRE007
 B6  C     CRE007        IFEQ      'Y'                                          CRE007
      *                                                                         CRE007
 B7  C     DDTYPE        IFEQ      'TD'                                         CRE007
     C     TAXIND        ANDEQ     'L'                                          CRE007
     C     DDTYPE        OREQ      'TD'                                         CRE007
     C     TAXIND        ANDEQ     'P'                                          CRE007
     C     DDTYPE        OREQ      'IT'                                                       241001
     C     TAXIND        ANDEQ     'L'                                                        241001
     C     DDTYPE        OREQ      'IT'                                                       241001
     C     TAXIND        ANDEQ     'P'                                                        241001
      *                                                                         CRE007
      ** Access GBP curreny details                                             CRE007
      *                                                                         CRE007
     C                   MOVE      IKAMNP        ULAMCO                         CRE007
      *                                                                         CRE007
     C                   CALL      'AOCURRR0'                                   CRE007
     C                   PARM      '*DBERR '     @RTCD                          CRE007
     C                   PARM      '*KEY   '     @OPTN                          CRE007
     C                   PARM                    BJLCCY                         CRE007
     C     SDCURR        PARM      SDCURR        DSSDY                          CRE007
      *                                                                         CRE007
     C                   MOVE      BJLCCY        ZCCYO                          CRE007
     C                   Z-ADD     A6SPRT        ULRATO           13 8          CRE007
     C                   Z-ADD     A6NBDP        ZCDPO                          CRE007
     C                   MOVE      A6MDIN        ULZMDO            1            CRE007
      *                                                                         CRE007
      ** If Deal currency is not GBP then Access Deal CCY details               CRE007
      *                                                                         CRE007
 B8  C     DDCCY         IFNE      BJLCCY                                       CRE007
      *                                                                         CRE007
     C                   CALL      'AOCURRR0'                                   CRE007
     C                   PARM      '*DBERR '     @RTCD                          CRE007
     C                   PARM      '*KEY   '     @OPTN                          CRE007
     C                   PARM                    DDCCY                          CRE007
     C     SDCURR        PARM      SDCURR        DSSDY                          CRE007
      *                                                                         CRE007
     C                   Z-ADD     IKAMNP        ZAMTCI           15 0          CRE007
     C                   MOVE      DDCCY         ZCCYI                          CRE007
     C                   Z-ADD     A6SPRT        ULRATI           13 8          CRE007
     C                   Z-ADD     A6NBDP        ZCDPI                          CRE007
     C                   MOVE      A6MDIN        ULZMDI            1            CRE007
      *                                                                         CRE007
      ** Initialize Cross Exchange Rate to Zero                                 CRE007
     C                   Z-ADD     *ZEROS        ZEXCH                          CRE007
      *                                                                         CRE007
      ** If Mult/Div Indic. for 'FROM' is = Mult/Div Indic for 'TO'             CRE007
      ** Indic and Spot Rate for 'TO' Currency (ZRATET) is not = Zero           CRE007
     C     ULZMDI        IFEQ      ULZMDO                                       CRE007
     C     ULRATO        ANDNE     *ZEROS                                       CRE007
     C     ULRATI        DIV       ULRATO        ZEXCH                          CRE007
      *                                                                         CRE007
      ** If Milt/Div Indic for 'FROM' is Not = Mult/Div Indic For 'TO'          CRE007
      ** Indic or Spot Rate for 'TO' Currency (ULRATO) is = Zero                CRE007
     C                   ELSE                                                   CRE007
     C     ULRATI        MULT      ULRATO        ZEXCH                          CRE007
     C                   END                                                    CRE007
      *                                                                         CRE007
      ** Move Mult/Div Indic for 'FROM' Currency to Cross Rate Mult/Div         CRE007
      ** Indicator (ZMD)                                                        CRE007
     C                   MOVE      ULZMDI        ZMD                            CRE007
      *                                                                         CRE007
      ** Convert Amount                                                         CRE007
     C                   CALLB     'ZCONV'                                      CRE007
     C                   PARM                    ZAMTCI           15 0          CRE007
     C                   PARM                    ZEXCH            13 8          CRE007
     C                   PARM                    ZMD               1            CRE007
     C                   PARM                    ZCCYI             3            CRE007
     C                   PARM                    ZCCYO             3            CRE007
     C                   PARM                    ZCDPI             1 0          CRE007
     C                   PARM                    ZCDPO             1 0          CRE007
     C                   PARM                    ZAMTCO           15 0          CRE007
      *                                                                         CRE007
     C                   MOVE      ZAMTCO        ULAMCO           15 2          CRE007
      *                                                                         CRE007
 E8  C                   ENDIF                                                  CRE007
      *                                                                         CRE007
      ** Determine if Principal Amount is >= 50,000 in GBP                      CRE007
      *                                                                         CRE007
 B8  C     ULAMCO        IFGE      50000                                        CRE007
     C**********         MOVE      'X'           DDMTAX                                CRE007 241001
     C                   MOVE      'N'           DDMTAX                                       241001
 E8  C                   ENDIF                                                  CRE007
      *                                                                         CRE007
 E7  C                   ENDIF                                                  CRE007
 E6  C                   ENDIF                                                  CRE007
 E5  C                   ENDIF                                                  CRE007
      *                                                                         CRE007
     C     ETAXDF        TAG                                                    CRE007
      *                                                                         CRE007
     C                   END
      *
      ****If*deal*type*is*not*IT,*TD*or*CD,****************************         CDL006
      ** If deal type is not IT, TD, CD, FT, DT, or LT                          CDL006
      **  the Taxable Indicator should only be blank
      *
     C                   ELSE
      *
     C     DDMTAX        IFEQ      *BLANK
     C                   ELSE
     C     DDTYPE        IFEQ      'DP'                                         CDL006
     C     CDL006        ANDEQ     'Y'                                          CDL006
     C     DDTYPE        OREQ      'LP'                                         CDL006
     C     CDL006        ANDEQ     'Y'                                          CDL006
     C     DDTYPE        OREQ      'FL'                                         CDL006
     C     CDL006        ANDEQ     'Y'                                          CDL006
     C                   MOVEL     'MMM9019'     MSGID1                         CDL006
     C                   ELSE                                                   CDL006
     C                   MOVEL     'MMM0595'     MSGID1
     C                   ENDIF                                                  CDL006
     C                   MOVE      'Y'           ErrorFound
     C                   END
     C                   END
     C                   END
     C                   END
      *
      ** ELSE BRT SAR IS NOT INSTALLED
      *
     C                   ELSE
      *                                                                                      CDL013
      *** if CAR CDL013 is installed.                                                        CDL013
     C     CDL013        IFEQ      'Y'                                                       CDL013
     C                   MOVE      *BLANKS       @MSGF            10                         CDL013
     C                   MOVE      *BLANKS       @MSGID           10                         CDL013
     C                   MOVEL     'XXUSRMSG'    @MSGF                                       CDL013
      *                                                                                      CDL013
      *** if taxable indicator is BLANK set to Customer details value.                       CDL013
     C     DDMTAX        IFEQ      *BLANKS                                                   CDL013
     C                   MOVE      BBTAIN        DDMTAX                                      CDL013
     C                   ENDIF                                                               CDL013
      *                                                                                      CDL013
      *** if taxable ind is NOT within the range 0-9 - then ERROR.                           CDL013
     C     DDMTAX        IFNE      '0'                                                       CDL013
     C     DDMTAX        ANDNE     '1'                                                       CDL013
     C     DDMTAX        ANDNE     '2'                                                       CDL013
     C     DDMTAX        ANDNE     '3'                                                       CDL013
     C     DDMTAX        ANDNE     '4'                                                       CDL013
     C     DDMTAX        ANDNE     '5'                                                       CDL013
     C     DDMTAX        ANDNE     '6'                                                       CDL013
     C     DDMTAX        ANDNE     '7'                                                       CDL013
     C     DDMTAX        ANDNE     '8'                                                       CDL013
     C     DDMTAX        ANDNE     '9'                                                       CDL013
     C                   MOVEL     'XXW0101'     MSGID1                                      CDL013
     C                   MOVE      'Y'           ErrorFound                                  CDL013
     C                   ELSE                                                                CDL013
      *                                                                                      CDL013
      *** If customer and deal type are valid,                                               CDL013
     C     DDTYPE        IFNE      *BLANKS                                                   CDL013
     C     DDCUST        ANDNE     *BLANKS                                                   CDL013
     C     DDCustOK      ANDNE     'N'                                                       CDL013
     C     DDTypeOK      ANDNE     'N'                                                       CDL013
      *                                                                                      CDL013
      *** If customer type is 'N' and Tax Ind NE 0 - ERROR                                   CDL013
     C     BBCSTY        IFEQ      'N'                                                       CDL013
     C     DDMTAX        ANDNE     '0'                                                       CDL013
     C                   MOVEL     'XXW0100'     MSGID1                                      CDL013
     C                   MOVE      'Y'           ErrorFound                                  CDL013
     C                   ELSE                                                                CDL013
      *                                                                                      CDL013
      *** If deal type not 'IT', 'TD' or 'CD' and Tax Ind NE 0 - ERROR                       CDL013
     C     DDTYPE        IFNE      'IT'                                                      CDL013
     C     DDTYPE        ANDNE     'TD'                                                      CDL013
     C     DDTYPE        ANDNE     'CD'                                                      CDL013
     C     DDMTAX        ANDNE     '0'                                                       CDL013
     C                   MOVEL     'XXW0102'     MSGID1                                      CDL013
     C                   MOVE      'Y'           ErrorFound                                  CDL013
      *                                                                                      CDL013
     C                   ENDIF                                                               CDL013
     C                   ENDIF                                                               CDL013
     C                   ENDIF                                                               CDL013
     C                   ENDIF                                                               CDL013
      *                                                                                      CDL013
      *** otherwise perform Original validation.                                             CDL013
     C                   ELSE                                                                CDL013
      *
      **  If the taxable indicator does not have the value 'Y','N' or
      **  blank, it is an error.
     C     DDMTAX        IFNE      *BLANK
     C     DDMTAX        ANDNE     'Y'
     C     DDMTAX        ANDNE     'N'
     C                   MOVEL     'MMM0457'     MSGID1
     C                   MOVE      'Y'           ErrorFound
      *
      **  If customer is not taxable (BBBOST on SDCUSTPD), or the
      ****deal*type*is*not*IT,TD*or*CD,*and*the*taxable*indicator*is*Y*         CDL006
      ** type is not IT,TD,CD,FT,DT, or LT & the taxable indicator is Y         CDL006
      **  (Only check if both the customer and deal type are non-blank
      **  and valid.)
     C                   ELSE
      *
     C     DDCustOK      IFNE      'N'
     C     DDTypeOK      ANDNE     'N'
     C     DDTYPE        ANDNE     *BLANKS
     C     DDCUST        ANDNE     *BLANKS
     C*****BBTAIN        IFNE      'Y'                                                      BUG23048
     C*****AXETXS        IFNE      'T'                                            BUG23048 BUG25912A
     C     BBTAIN        IFNE      'Y'                                                     BUG25912A
     C     DDMTAX        ANDEQ     'Y'
      *
     C                   MOVEL     'MMM0459'     MSGID1
     C                   MOVE      'Y'           ErrorFound
     C                   ELSE
      *                                                                                     BUG25912
     C**********         EVAL      DDMTAX   = 'Y'                                 BUG25912 BUG25912A
     C**********         EVAL      PWarnFnd = 'Y'                                 BUG25912 BUG25912A
     C**********         EVAL      Msgid2 = 'MMA3006'                             BUG25912 BUG25912A
      *                                                                                     BUG25912
     C     DDTYPE        IFNE      'IT'
     C     DDTYPE        ANDNE     'TD'
     C     DDTYPE        ANDNE     'CD'
     C     DDMTAX        ANDEQ     'Y'
     C     CDL006        ANDEQ     'N'                                          CDL006
     C     DDTYPE        ORNE      'IT'                                         CDL006
     C     DDTYPE        ANDNE     'TD'                                         CDL006
     C     DDTYPE        ANDNE     'CD'                                         CDL006
     C     DDTYPE        ANDNE     'FT'                                         CDL006
     C     DDTYPE        ANDNE     'DT'                                         CDL006
     C     DDTYPE        ANDNE     'LT'                                         CDL006
     C     DDMTAX        ANDEQ     'Y'                                          CDL006
     C     CDL006        ANDEQ     'Y'                                          CDL006
     C                   MOVEL     'MMM0458'     MSGID1
     C                   MOVE      'Y'           ErrorFound
     C                   END
     C                   END
     C                   END
      *
      **  If customer is  taxable (BBBOST on SDCUSTPD), and the deal
      **  type is IT,TD or CD, and the taxable indicator is blank, set
      **  the indicator to 'Y'.
     C     DDCustOK      IFNE      'N'
     C     DDTypeOK      ANDNE     'N'
     C     DDTYPE        ANDNE     *BLANKS
     C     DDCUST        ANDNE     *BLANKS
     C*****BBTAIN        IFEQ      'Y'                                                      BUG23048
     C*****AXETXS        IFNE      'T'                                            BUG23048 BUG25912A
     C     BBTAIN        IFEQ      'Y'                                                     BUG25912A
     C     DDMTAX        ANDEQ     *BLANK
     C     DDTYPE        IFEQ      'IT'
     C     DDTYPE        OREQ      'TD'
     C     DDTYPE        OREQ      'CD'
     C     DDTYPE        OREQ      'FT'                                         CDL006
     C     CDL006        ANDEQ     'Y'                                          CDL006
     C     DDTYPE        OREQ      'DT'                                         CDL006
     C     CDL006        ANDEQ     'Y'                                          CDL006
     C     DDTYPE        OREQ      'LT'                                         CDL006
     C     CDL006        ANDEQ     'Y'                                          CDL006
     C                   MOVE      'Y'           DDMTAX
     C                   END
     C                   END
     C                   END
     C                   END
     C                   ENDIF                                                               CDL013
      *
     C                   END
      *                                                                                       CER048
     C                   ENDIF                                                                CER048
      *
      ** If an error was found, set the return code appropriately
     C                   IF        ErrorFound = 'Y'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************                     BUG23048
      *                                                               *                     BUG23048
      *  SrRtvCust: Retrieve Country of Tax Details                   *                     BUG23048
      *                                                               *                     BUG23048
      *  Called By: Main                                              *                     BUG23048
      *                                                               *                     BUG23048
      *  Calls: None                                                  *                     BUG23048
      *                                                               *                     BUG23048
      *****************************************************************                     BUG23048
     C     SrRtvCust     BEGSR                                                              BUG23048
      *                                                                                     BUG23048
      ** Key List for accessing country of tax details                                      BUG23048
      *                                                                                     BUG23048
     C     KCustByTax    KLIST                                                              BUG23048
     C                   KFLD                    KCust                                      BUG23048
     C                   KFLD                    KCtax                                      BUG23048
      *                                                                                     BUG23048
      *  Key List to access Country of Tax Codes                                            BUG23887
     C     KCTxCd        KLIST                                                              BUG23887
     C                   KFLD                    KCtTx                                      BUG23887
     C                   KFLD                    KCtRe                                      BUG23887
      *                                                                                     BUG23887
      ** To get the Branch, Use the Customer Table to get the data                          BUG23048
      *                                                                                     BUG23048
     C                   MOVEL     DDCUST        PKey1                                      BUG23048
      *                                                                                     BUG23048
     C                   CALL      'AOCUSTR0'                                               BUG23048
      *                                                                                     BUG23048
     C                   PARM      *BLANKS       PRtcd                                      BUG23048
     C                   PARM      '*KEY'        POptn                                      BUG23048
     C                   PARM                    PKey1                                      BUG23048
     C                   PARM      *BLANKS       PKyst                                      BUG23048
     C     SDCUST        PARM      SDCUST        DSLDY                                      BUG23048
      *                                                                                     BUG23048
     C**********         IF        (PRtcd <> *BLANKS)                              BUG23048 BUG23485
     C**********         IF        (PRtcd <> *BLANKS) AND                         BUG23485 BUG23485A
     C**********                   (PRtcd <> '*NRF')                              BUG23485 BUG23485A
      **********                                                                  BUG23048 BUG23485A
     C******LOCK         IN        LDA                                            BUG23048 BUG23485A
     C**********         EVAL      DBFILE = 'SDCUSTPD'                            BUG23048 BUG23485A
     C**********         EVAL      DBKEY = PKey1                                  BUG23048 BUG23485A
     C**********         EVAL      DBASE = 002                                    BUG23048 BUG23485A
     C**********         OUT       LDA                                            BUG23048 BUG23485A
     C**********         EXSR      *PSSR                                          BUG23048 BUG23485A
      *                                                                                     BUG23048
     C**********         ENDIF                                                    BUG23048 BUG23485A
      *                                                                                     BUG23048
     C                   CALL      'AOBRCHR0'                                               BUG23048
      *                                                                                     BUG23048
     C                   PARM      *BLANKS       PRtcd                                      BUG23048
     C                   PARM      '*KEY'        POptn                                      BUG23048
     C                   PARM      DDBRCA        PBrca                                      BUG23048
     C     SDBRCH        PARM      SDBRCH        DSSDY                                      BUG23048
      *                                                                                     BUG23048
     C**********         IF        (PRtcd <> *BLANKS)                              BUG23048 BUG23485
     C                   IF        (PRtcd <> *BLANKS) AND                                   BUG23485
     C                             (PRtcd <> '*NRF')                                        BUG23485
      *                                                                                     BUG23048
     C     *LOCK         IN        LDA                                                      BUG23048
     C                   EVAL      DBFILE = 'SDBRCHPD'                                      BUG23048
     C                   EVAL      DBKEY = DDBRCA                                           BUG23048
     C                   EVAL      DBASE = 003                                              BUG23048
     C                   OUT       LDA                                                      BUG23048
     C                   EXSR      *PSSR                                                    BUG23048
      *                                                                                     BUG23048
     C                   ENDIF                                                              BUG23048
      *                                                                                     BUG23048
      ** Get the Location Code to get the country details                                   BUG23048
      *                                                                                     BUG23048
     C                   CALL      'AOLOCNR0'                                               BUG23048
      *                                                                                     BUG23048
     C                   PARM      *BLANKS       PRtcd                                      BUG23048
     C                   PARM      '*KEY'        POptn                                      BUG23048
     C                   PARM      A8LCCD        PLccd                                      BUG23048
     C     SDLOCN        PARM      SDLOCN        DSLDY                                      BUG23048
      *                                                                                     BUG23048
     C**********         IF        (PRtcd <> *BLANKS)                              BUG23048 BUG23485
     C                   IF        (PRtcd <> *BLANKS) AND                                   BUG23485
     C                             (PRtcd <> '*NRF')                                        BUG23485
      *                                                                                     BUG23048
     C     *LOCK         IN        LDA                                                      BUG23048
     C                   EVAL      DBFILE = 'SDLOCNPD'                                      BUG23048
     C                   EVAL      DBKEY = A8LCCD                                           BUG23048
     C                   EVAL      DBASE = 004                                              BUG23048
     C                   OUT       LDA                                                      BUG23048
     C                   EXSR      *PSSR                                                    BUG23048
      *                                                                                     BUG23048
     C                   ENDIF                                                              BUG23048
      *                                                                                     BUG23048
      ** Chain Customer Details by Country of Tax File to get                               BUG23048
      ** the European Tax Status                                                            BUG23048
      *                                                                                     BUG23048
     C                   MOVE      BBCUST        KCust                                      BUG23048
     C                   EVAL      KCtax = DVCNCD                                           BUG23048
      *                                                                                     BUG23887
      ** Retrieve threshold method                                                          BUG23887
      *                                                                                     BUG23887
     C                   EVAL      WThrMtd = *blanks                                        BUG23887
     C                   EVAL      KCtTx = DVCNCD                                           BUG23887
     C                   EVAL      KCtRe = BBCOLC                                           BUG23887
     C     KCTxCd        CHAIN     SDCTTXL0                                                 BUG23887
     C                   IF        %FOUND(SDCTTXL0)                                         BUG23887
     C                   EVAL      WThrMtd = EWTHMD                                         BUG23887
     C                   ENDIF                                                              BUG23887
      *                                                                                     BUG23048
     C     KCustByTax    CHAIN     SDACTXL1                                                 BUG23048
      *                                                                                     BUG23048
      ** No Record Found                                                                    BUG23048
      *                                                                                     BUG23048
     C                   IF        NOT %FOUND(SDACTXL1)                                     BUG23048
     C                   EVAL      AXETXS = ' '                                             BUG23048
     C                   ENDIF                                                              BUG23048
      *                                                                                     BUG23048
     C                   ENDSR                                                              BUG23048
      *****************************************************************                     BUG23048
      /EJECT                                                                                BUG23048
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
 
     C     *ENTRY        PLIST
     C                   PARM                    RetCodeIn
     C                   PARM                    PWarnFnd                                     CER048
     C                   PARM                    Msgid1
     C                   PARM                    Msgid2                                       CER048
     C                   PARM                    DDMTAX
     C                   PARM                    DDBRCA                                     BUG23048
     C                   PARM                    BRTIND
     C                   PARM                    DDType
     C                   PARM                    DDTypeOK
     C                   PARM                    DDCUST
     C                   PARM                    DDCUSTOK
     C                   PARM                    IKCNum
     C                   PARM                    BBTAIN
     C                   PARM                    AlwCali
     C                   PARM                    IKAMNP                         CRE007
     C                   PARM                    DDCCY                          CRE007
     C                   PARM                    BJLCCY                         CRE007
     C                   PARM                    BBCSTY                                      CDL013
     C                   PARM                    CDL013                                      CDL013
 
     C                   OPEN      SDCBRTL1
 
      *                                                                         CRE007
      ** Access SAR details to check if CRE007 is installed                     CRE007
      *                                                                         CRE007
     C                   CALL      'AOSARDR0'                                   CRE007
     C                   PARM      *BLANKS       @RTCD             7            CRE007
     C                   PARM      '*VERIFY'     @OPTN             7            CRE007
     C                   PARM      'CRE007'      @SARD             6            CRE007
      *                                                                         CRE007
     C     @RTCD         IFEQ      *BLANKS                                      CRE007
     C                   MOVE      'Y'           CRE007            1            CRE007
     C                   ELSE                                                   CRE007
     C                   MOVE      'N'           CRE007                         CRE007
     C                   ENDIF                                                  CRE007
                                                                                CRE007
      *                                                                                       CER048
      ** Access SAR details to check if CER048 is installed                                   CER048
      *                                                                                       CER048
     C                   CALLB     'AOSARDR0'                                                 CER048
     C                   PARM      *BLANKS       PRtcd                                        CER048
     C                   PARM      '*VERIFY'     POptn                                        CER048
     C                   PARM      'CER048'      PSard                                        CER048
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER048
      *                                                                                       CER048
      ** Database Error                                                                       CER048
      *                                                                                       CER048
     C                   IF        PRtcd  <> *BLANKS AND                                      CER048
     C                             PRtcd <> '*NRF   '                                         CER048
     C     *LOCK         IN        LDA                                                        CER048
     C                   EVAL      DBKEY = 'CER048'                                           CER048
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER048
     C                   EVAL      DBASE = 001                                                CER048
     C                   OUT       LDA                                                        CER048
     C                   EXSR      *PSSR                                                      CER048
     C                   ENDIF                                                                CER048
      *                                                                                       CER048
     C                   IF        PRtcd = *BLANKS                                            CER048
     C                   EVAL      CER048 = 'Y'                                               CER048
     C                   ELSE                                                                 CER048
     C                   EVAL      CER048 = 'N'                                               CER048
     C                   ENDIF                                                                CER048
      *                                                                                       CER048
      *                                                                                       CER069
      ** Access SAR details to check if CER069 is installed                                   CER069
      *                                                                                       CER069
     C                   CALLB     'AOSARDR0'                                                 CER069
     C                   PARM      *BLANKS       PRtcd                                        CER069
     C                   PARM      '*VERIFY'     POptn                                        CER069
     C                   PARM      'CER069'      PSard                                        CER069
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER069
      *                                                                                       CER069
      ** Database Error                                                                       CER069
      *                                                                                       CER069
     C                   IF        PRtcd  <> *BLANKS AND                                      CER069
     C                             PRtcd <> '*NRF   '                                         CER069
     C     *LOCK         IN        LDA                                                        CER069
     C                   EVAL      DBKEY = 'CER069'                                           CER069
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER069
     C                   EVAL      DBASE = 005                                                CER069
     C                   OUT       LDA                                                        CER069
     C                   EXSR      *PSSR                                                      CER069
     C                   ENDIF                                                                CER069
      *                                                                                       CER069
     C                   IF        PRtcd = *BLANKS                                            CER069
     C                   EVAL      CER069 = 'Y'                                               CER069
     C                   ELSE                                                                 CER069
     C                   EVAL      CER069 = 'N'                                               CER069
     C                   ENDIF                                                                CER069
      *                                                                                       CER069
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
