     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FF Settlement fields')
      *****************************************************************
      *                                                               *
      *  Midas - Financial Futures and Options module                 *
      *                                                               *
      *  FFSETLVAL - Settlements Validation Module                    *
      *                                                               *
      *  Function:  This module validates settlement fields for       *
      *             customer and broker, and returns messages if      *
      *             errors or warnings occur.                         *
      *                                                               *
      *  *NOTE* As this module is to be used generically for customer *
      *  and broker processing, an indicator is passed to this module *
      *  to indicate which is required. If this indicator (Customer/  *
      *  Broker Flag) = 'C' then customer settlement fields are to be *
      *  to be validated; otherwise broker fields require validation. *
      *  Both customer and broker settlement OK flags data structures *
      *  are included in the parameter list although in practice      *
      *  only one will be used in any call to this module.            *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. 240193             Date 12Jul06               *
      *  Prev Amend No. 239740             Date 29May06               *
      *                 BG11679            Date 05Jul06               *
      *                 CSD027B            Date 29Jun06               *
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 BG9185             Date 08Nov05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CGL014             Date 20Oct03               *
      *                 TDA034             Date 21Mar04               *
      *                 CGL029             Date 01Sep03               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CFF007             Date 13Feb01               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CPB001             Date 06Sep99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 147775             Date 16Nov98               *
      *                 CAP004  *CREATE    Date 01Jun98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  240193 - Apply fix 239740.                                   *
      *  239740 - Incorporation conflict introduced at SP01 (BUG9185) *
      *           TDA034 does not reflect the current DSPFFD          *
      *           structure of Pf/FFBSETPD and Pf/FFCSETPD            *
      *           Pgm using DS fld SBSLA1 - SBSLA7 & SCSLA1 - SCSLA7  *
      *           but these values are incorrect causing MMA0450.     *
      *           Revert to codes before TDA034.                      *
      *  BG11679 - Additional Conversion of Customer Number to alpha. *
      *  CSD027B- Additional Customer Number changes.                 *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BG9185 - Correction to CGL029 (Recompile)                    *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CGL014 - Collaterals Processing                              *
      *  TDA034 - Amended DS FFCSET to reflect changes made to files  *
      *           FFCSETPD and FFBSETPD.                              *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CFF007 - Futures and Options Enhancement for Private Banking *
      *  CPB001 - 'Private Banking' Module                            *
      *  147775 - General FF API fixes - (Pre-release unnanotated)    *
      *  CAP004 - Conversion of Midas inputs to APIs.                 *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Customer by shortname
     FSNAME     IF   E           K DISK
     F                                     RENAME(CLINTCBF:SNAMECBF)
      ** Accounts master
     FACCNT     IF   E           K DISK
     F                                     IGNORE(ACCNTAAF)
     F                                     IGNORE(ACCNTACF)
      ** Account numbers file
     FACNUM     IF   E           K DISK
     F                                     RENAME(ACCNTABF:ACNUMABF)
      ** Customer Master file
     FCLINT     IF   E           K DISK
     F                                     IGNORE(CLINTCAF)
     F                                     IGNORE(CLINTCCF)
     F                                     IGNORE(CLINTC1F)
     F                                     IGNORE(CLINTSEF)
      ** Futures and options table
     FTABFF     IF   E           K DISK
     F                                     IGNORE(TABTB10F)
     F                                     IGNORE(TABTB11F)
     F                                     IGNORE(TABTB20F)
     F                                     IGNORE(TABTB40F)
     F                                     IGNORE(TABTG10F)
     F                                     IGNORE(TABLETHF)
     F                                     IGNORE(TABLETRF)
 
      * Hook to enable non-core files to be included
      /COPY WNCPYSRC,FFSETLV001
 
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
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the definitions of the error
      ** arrays, including the named constant giving the size of
      ** the arrays.  Note that it uses #MsgID and *MsgData, and so requires
      ** STD_D_SPEC.
     D/COPY ZACPYSRC,FVAL_ARRAY
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
 
     D FFEBSET       E DS                  EXTNAME(FFEBSETPD)
      * Broker settlement OK flags
 
     D FFECSET       E DS                  EXTNAME(FFECSETPD)
      * Customer settlement OK flags
 
     D FFCSET        E DS                  EXTNAME(FFCSETPD)
      * Customer settlement format definition
     D**SCSLA1**              54     55                                                       TDA034
     D**SCSLA1**              84     85                                                TDA034 239740
     D  SCSLA1                54     55                                                       239740
     D**SCSLA2**              56     65                                                       CGL029
     D**SCSLA2**              56     71                                                CGL029 TDA034
     D**SCSLA2**              86    101                                                TDA034 239740
     D  SCSLA2                56     71                                                       239740
     D**SCSLA3**              54     59                                                       TDA034
     D**SCSLA3**              84     89                                                TDA034 239740
     D  SCSLA3                54     59                                                       239740
     D**SCSLA4**              60     65                                                       CGL029
     D**SCSLA4**              60     71                                                CGL029 TDA034
     D**SCSLA4**              90    101                                                TDA034 239740
     D  SCSLA4                60     71                                                       239740
     D**SCSLA5**              60     63                                                       CGL029
     D**SCSLA6**              64     65                                                       CGL029
     D**SCSLA5**              60     69                                                CGL029 TDA034
     D**SCSLA5**              90     99                                                TDA034 239740
     D  SCSLA5                60     69                                                       239740
     D**SCSLA6**              70     71                                                CGL029 TDA034
     D**SCSLA6**             100    101                                                TDA034 239740
     D  SCSLA6                70     71                                                       239740
     D**SCSLA7**              54     63                                                       TDA034
     D**SCSLA7**              84     93                                                TDA034 239740
     D  SCSLA7                54     63                                                       239740
 
     D FFBSET        E DS                  EXTNAME(FFBSETPD)
      * Broker settlement format definition
     D**SBSLA1**              54     55                                                       TDA034
     D**SBSLA1**              84     85                                                TDA034 239740
     D  SBSLA1                54     55                                                       239740
     D**SBSLA2**              56     65                                                       CGL029
     D**SBSLA2**              56     71                                                CGL029 TDA034
     D**SBSLA2**              86    101                                                TDA034 239740
     D  SBSLA2                56     71                                                       239740
     D**SBSLA3**              54     59                                                       TDA034
     D**SBSLA3**              84     89                                                TDA034 239740
     D  SBSLA3                54     59                                                       239740
     D**SBSLA4**              60     65                                                       CGL029
     D**SBSLA4**              60     71                                                CGL029 TDA034
     D**SBSLA4**              90    101                                                TDA034 239740
     D  SBSLA4                60     71                                                       239740
     D**SBSLA5**              60     63                                                       CGL029
     D**SBSLA6**              64     65                                                       CGL029
     D**SBSLA5**              60     69                                                CGL029 TDA034
     D**SBSLA5**              90     99                                                TDA034 239740
     D  SBSLA5                60     69                                                       239740
     D**SBSLA6**              70     71                                                CGL029 TDA034
     D**SBSLA6**             100    101                                                TDA034 239740
     D  SBSLA6                70     71                                                       239740
     D**SBSLA7**              54     63                                                       TDA034
     D**SBSLA7**              84     93                                                TDA034 239740
     D  SBSLA7                54     63                                                       239740
 
     D FFVSETL       E DS                  EXTNAME(FFVSETLPD)
      ** The valid settlements format
 
     D@DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for Access Programs, Short Data Structure
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Second DS for Access Programs, Long data Structure
 
     D DSLDY         E DS                  EXTNAME(DSLDY)                                     CFF007
      ** Third DS for Access Programs, Very Long data Structure                               CFF007
                                                                                              CFF007
     D KCPSH           DS            12
      ** Key for Counterparty Nostro Table file
     D  KCPSH2                 5     12
 
     D KCSNM           DS            10
      **  Key to LF/SNAME
      **  Also, re-defines Client Number/Shortname
     D  KCSNM1                 1      1
     D  KCSNM2                 1      6
     D  KCSNM3                 7     10
 
     D FFNKY           DS            12
      ** Key for Nostro Codes Table file
     D  FFNKY1                 1      2
     D  FFNCCY                 8     10
     D  FFNOSN                11     12  0
 
     D*FFAKY****       DS            12                                                       CGL029
     D FFAKY           DS            18                                                       CGL029
      ** Key for Account Codes Table file
     D  FFAKY1                 1      2
     D  FFACOD                 8     17  0                                                    CGL029
     D  FFAKY2                18     18                                                       CGL029
     D**FFACOD**               8     11  0                                                    CGL029
     D**FFAKY2**              12     12                                                       CGL029
 
     D FFCKY           DS            12
      ** Key for currencies table file
     D  FFCKY1                 1      2
     D  FFCCY                  9     11
     D  FFCKY2                12     12
 
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
      ** Branch Details
     D  BRCH         E                     EXTFLD(A8BRCD)
     D  LCCD         E                     EXTFLD(A8LCCD)
 
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      ** Customer details
     D  CUST         E                     EXTFLD(BBCUST)
     D  CSSN         E                     EXTFLD(BBCSSN)
     D  QQDFA1       E                     EXTFLD(QQDFAC)                                     CGL029
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** Bank Details
 
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
      ** EXTERNAL DS FOR GENERAL LEDGER DETAILS
 
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      ** External DS for Midas Modules Details
 
     D SDTRAD        E DS                  EXTNAME(SDTRADPD)                      CPM003
     D  QQACC1       E                     EXTFLD(QQACCD)                                     CGL029
     ** Trading details
 
     D SDPORT        E DS                  EXTNAME(SDPORTPD)                    CPM003
      ** Portfolio Management ICD
 
     D SDRETL        E DS                  EXTNAME(SDRETLPD)
     D  QQACC2       E                     EXTFLD(QQACCD)                                     CGL029
      ** EXTERNAL DS FOR BANK DETAILS
 
     D PMPORT        E DS                  EXTNAME(PMPORTPD) IMPORT
      ** PMPORTPD imported from FFVPORTRF
 
     D SDACOD        E DS                  EXTNAME(SDACODPD)                                  CGL029
     D  QQACC3       E                     EXTFLD(QQACCD)                                     CGL029
      ** Account Code Details                                                                 CGL029
                                                                                              CGL029
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** AOACODR0 Parameters                                                                  CGL029
     D PRTCD           S              7A                                                      CGL029
     D POPTN           S              7A                                                      CGL029
     D PACCD           S             10A                                                      CGL029
                                                                                              CGL029
      ** Customer/Broker Flag
     D  CustBrokFl     S              1A
 
      ** Trade date OK flag
     D  OKTRSD         S              1A
 
      ** Instrument Currency
     D  ISCY           S              3A
 
      ** Broker Code (6S,0)
     D**BOCO****       S              6S 0                                                    CSD027
     D  BOCO           S              6                                                       CSD027
 
      ** Customer Code (6S,0)
     D**CUSC****       S              6S 0                                                    CSD027
     D  CUSC           S              6                                                       CSD027
 
      ** Portfolio reference
     D SPTFR           S              4A
 
      ** Branch code
     D SBRCD           S              3A
 
      ** Settlement Branch ID
     D WXSLB           S                   LIKE(SBRCD)
 
     D*WXSLA****       DS            12                                                       CGL029
     D WXSLA           DS            18                                                       CGL029
      ** Settlement A/C
     D  WXSLA1                 1      6
     D  WXSLA2                 7     16                                                       CGL029
     D  WXSLA3                17     18                                                       CGL029
     D**WXSLA2**               7     10                                                       CGL029
     D**WXSLA3**              11     12                                                       CGL029
 
      ** Customer Number - part of
      ** key List for LF/ACCNT (Accounts): FFACTK
     D*FFCNUM***       S              6S 0                                                    CSD027
     D FFCNUM          S              6                                                       CSD027
 
      ** Account Sequence - part of
      ** key List for LF/ACCNT (Accounts): FFACTK
     D FFACSQ          S              2S 0
 
      ** Branch Code - part of
      ** key List for LF/ACCNT (Accounts): FFACTK
     D FFBRCB          S              3A
 
      ** MEMOS update indicator (= Y or N or E)
     D XMIND           S              1A
 
      ** Portfolio reference (imported from the FFVPORTRF module)
     D WWPORT          S              1A   IMPORT
 
      ** PB customer indicator                                                                CFF007
     D PPBBFLG         S              1A                                                      CFF007
     D PPBCFLG         S              1A                                                      CFF007
                                                                                              CFF007
      ** CFF007 Enhancement                                                                   CFF007
     D CFF007          S              1A                                                      CFF007
                                                                                              CFF007
      ** Transaction date
     D TRSD            S              5P 0
 
      ** Current trading date
     D CTDATE          S              5  0
 
      ** Instrument currency
     D KCCY            S                   LIKE(SBRCD)
 
      ** Part of Composite Key to LF/SNAME
     D  KCPSH1         S              2A
 
      ** Branch internal customer - from SDBRCHPD
     D BICN            S                   LIKE(A8BICN)
 
      ** Customer Number - key for CLINT logical file
     D*KCBCD****       S              6S 0                                                    CSD027
     D KCBCD           S              6                                                       CSD027
 
      ** Record type - key for CLINT logical file
     D KRCDT           S              1A
 
     D CGL014          S              1                                                       CGL014
     D PTR_Amount      S             15  0                                                    CGL014
     D PTR_Curr        S              3                                                       CGL014
     D PAC_Branch      S              3                                                       CGL014
     D PAC_Cust        S              6                                                       CGL014
     D PAC_Curr        S              3                                                       CGL014
     D PAC_Code        S             10                                                       CGL014
     D PAC_Seq         S              2                                                       CGL014
     D PAC_Retail      S             10  0                                                    CGL014
     D PRetCode        S              7                                                       CGL014
     D WPrvSBMAR       S             14                                                       CGL014
     D WPrvSBSBR       S              3                                                       CGL014
     D WPrvSBSLA       S             12                                                       CGL014
     D WPrvSCMAR       S             14                                                       CGL014
     D WPrvSBRSC       S              3                                                       CGL014
     D WPrvSCSLA       S             12                                                       CGL014
     D*WPrvBOCO*       S              6  0                                             CGL014 B11679
     D*WPrvCUSC*       S              6  0                                             CGL014 B11679
     D WPrvBOCO        S              6                                                       B11679
     D WPrvCUSC        S              6                                                       B11679
     D WPrvSPTFR       S              4                                                       CGL014
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      /COPY WNCPYSRC,FFSETLV002
 
      ** +--------------------------------------+
      ** ¦ I-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     IACCNTABF
      ** Input fields for record ACCNTABF file ACCNT format ACCNTABF.
     I              PTFR                        ACPTFR
 
     IACNUMABF
      ** Input fields for record ACNUMABF file ACNUM format ACCNTABF.
     I              PTFR                        NUPTFR
      *****************************************************************
      /EJECT
      *****************************************************************
 
     C     Start         TAG
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *inzsr is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      /COPY WNCPYSRC,FFSETLV003
 
      ** Reset error fields
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line resets the fields related to error
      ** handling: ReturnCode, ErrorFound, FldNamXArr, MsgIDXArr,
      ** MsgDtaXArr, XIdx; and to warning message handling: WarnFound,
      ** FldNamWArr, MsgIDWArr, MsgDtaWArr, WIdx.
      ** It therefore requires FVAL_ARRAY and STD_D_SPEC.
     D/COPY ZACPYSRC,FVAL_RESET
      **--------------------------------------------------------------------------------------------
 
      ** Resets
      ** ~~~~~~
     C                   EVAL      WXSLB  = *BLANKS
     C**********         EVAL      FFCNUM = 0                                                 CSD027
     C                   EVAL      FFCNUM = *BLANKS                                           CSD027
     C                   EVAL      FFACOD = 0
     C                   EVAL      FFACSQ = 0
     C                   EVAL      FFNOSN = 0
     C**********         EVAL      CNUMB  = 0                                                 CSD027
     C**********         EVAL      CNUMC  = 0                                                 CSD027
     C                   EVAL      CNUMB  = *BLANKS                                           CSD027
     C                   EVAL      CNUMC  = *BLANKS                                           CSD027
 
      ** Set MEMO indicator to N
     C                   EVAL      XMIND  = 'N'
 
      ** Setup various table keys.
     C                   MOVE      '20'          FFCKY1
     C                   MOVE      '1'           FFCKY2
     C                   MOVE      '70'          FFNKY1
     C                   MOVE      '30'          FFAKY1
     C                   MOVE      '1'           FFAKY2
     C                   MOVE      '71'          KCPSH1
     C                   MOVE      'A'           KRCDT
     C                   MOVE      ISCY          KCCY
     C                   MOVE      ISCY          FFCCY
 
     C                   SELECT
      **                 ------
 
     C                   WHEN      CustBrokFl = 'B'
 
      /COPY WNCPYSRC,FFSETLV004
     C                   EXSR      BrokerSR
 
     C                   WHEN      CustBrokFl = 'C'
 
      /COPY WNCPYSRC,FFSETLV005
 
     C                   EXSR      CustSR
 
      /COPY WNCPYSRC,FFSETLV006
 
     C                   ENDSL
 
      **--------------------------------------------------------------------------------------------
      ** The return code is set in the following /COPY:
     C/COPY ZACPYSRC,SETRETCDE
      **--------------------------------------------------------------------------------------------
 
     C                   RETURN
 
      * Hook to enable non-core subroutines to be included
      /COPY WNCPYSRC,FFSETLV007
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * BrokerSR - Processing when broker settlement instructions     *
      *          requested                                            *
      *                                                               *
      *****************************************************************
 
     C     BrokerSR      BEGSR
 
      **      Settlement Type (Broker)
      **      ~~~~~~~~~~~~~~~
     C     SBSLT         IFEQ      '  '
     C                   MOVE      '00'          SBSLT
     C                   ENDIF
      **   Valid values for settlement type
     C     SBSLT         IFNE      '00'
     C     SBSLT         ANDNE     '01'
     C     SBSLT         ANDNE     '02'
     C     SBSLT         ANDNE     '03'
     C     SBSLT         ANDNE     '04'
     C     SBSLT         ANDNE     '05'
     C     SBSLT         ANDNE     '06'
     C     SBSLT         ANDNE     '07'
     C     SBSLT         ANDNE     '08'
     C     SBSLT         ANDNE     '12'
     C     SBSLT         ANDNE     '14'
     C     SBSLT         ANDNE     '15'
     C     CFF007        ANDNE     'Y'                                                        CFF007
                                                                                              CFF007
     C     SBSLT         ORNE      '00'                                                       CFF007
     C     SBSLT         ANDNE     '01'                                                       CFF007
     C     SBSLT         ANDNE     '02'                                                       CFF007
     C     SBSLT         ANDNE     '03'                                                       CFF007
     C     SBSLT         ANDNE     '04'                                                       CFF007
     C     SBSLT         ANDNE     '05'                                                       CFF007
     C     SBSLT         ANDNE     '06'                                                       CFF007
     C     SBSLT         ANDNE     '07'                                                       CFF007
     C     SBSLT         ANDNE     '08'                                                       CFF007
     C     SBSLT         ANDNE     '12'                                                       CFF007
     C     SBSLT         ANDNE     '14'                                                       CFF007
     C     SBSLT         ANDNE     '15'                                                       CFF007
     C     CFF007        ANDEQ     'Y'                                                        CFF007
     C     PPBBFLG       ANDNE     'Y'                                                        CFF007
                                                                                              CFF007
     C     SBSLT         ORNE      '04'                                                       CFF007
     C     SBSLT         ANDNE     '05'                                                       CFF007
     C     SBSLT         ANDNE     '14'                                                       CFF007
     C     SBSLT         ANDNE     '15'                                                       CFF007
     C     PPBBFLG       ANDEQ     'Y'                                                        CFF007
     C     CFF007        ANDEQ     'Y'                                                        CFF007
 
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      XIdx = XIdx + 1
     C                   EVAL      FldNamXArr(XIdx) = 'SBSLT'
     C     CFF007        IFEQ      'Y'                                                        CFF007
     C     PPBBFLG       ANDEQ     'Y'                                                        CFF007
     C                   EVAL      MSGIDXArr(XIdx) = 'MMA1164'                                CFF007
     C                   ELSE                                                                 CFF007
     C                   EVAL      MsgIDXArr(XIdx) = 'MMA0445'
     C                   ENDIF                                                                CFF007
     C                   EVAL      OKBSLT = 'N'
     C                   GOTO      BSEND
 
     C                   ENDIF
 
      **   Types 04 + 14 only allowed if Retail present (BGRTBN)
     C     BGRTBN        IFEQ      'N'
 
     C     SBSLT         IFEQ      '04'
     C     SBSLT         OREQ      '14'
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      XIdx = XIdx + 1
     C                   EVAL      FldNamXArr(XIdx) = 'SBSLT'
     C                   EVAL      MsgIDXArr(XIdx) = 'MMA0446'
     C                   EVAL      OKBSLT = 'N'
     C                   GOTO      BSEND
     C                   ENDIF
 
     C                   ENDIF
 
      **   Type 07 - Instr. ccy must be U.S. ccy code
     C     SBSLT         IFEQ      '07'
     C     KCCY          ANDNE     BLUSCY
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      XIdx = XIdx + 1
     C                   EVAL      FldNamXArr(XIdx) = 'SBSLT'
     C                   EVAL      MsgIDXArr(XIdx) = 'MMA0447'
     C                   EVAL      OKBSLT = 'N'
     C                   GOTO      BSEND
     C                   ENDIF
 
      **   Type 14 - Retail A/c nos. must be supported
     C     SBSLT         IFEQ      '14'
 
      **   BMRANR =  Retail account numbers required indicator.
     C     BMRANR        ANDNE     'Y'
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      XIdx = XIdx + 1
     C                   EVAL      FldNamXArr(XIdx) = 'SBSLT'
     C                   EVAL      MsgIDXArr(XIdx) = 'MMA0448'
     C                   EVAL      OKBSLT = 'N'
     C                   GOTO      BSEND
     C                   ENDIF
 
      **   Continue only if Settlement Type not in error
 
      **      Settlement Account (Broker)
      **      ~~~~~~~~~~~~~~~~~~
      **   - Settlement Types 00,04,06,15 : entry not allowed
     C     SBSLT         IFEQ      '00'
     C     SBSLT         OREQ      '04'
     C     SBSLT         OREQ      '06'
     C     SBSLT         OREQ      '15'
 
      * If settlement account has an entry, not allowed.
     C     SBSLA         IFNE      *BLANK
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      XIdx = XIdx + 1
     C                   EVAL      FldNamXArr(XIdx) = 'SBSLA'
     C                   EVAL      MsgIDXArr(XIdx) = 'MMA0449'
     C                   EVAL      OKBSLA = 'N'
 
     C                   ELSE
     C                   EVAL      WXSLB = SBRCD
 
     C     SBSLT         IFNE      '00'
 
     C                   MOVE      '01'          FFACSQ
 
     C     SBSLT         IFEQ      '04'
     C                   EVAL      FFCNUM = BOCO
      * Move current account default a/c code to FFACOD account code.
     C                   MOVE      BMACCD        FFACOD
     C                   ENDIF
 
     C     SBSLT         IFEQ      '06'
      * user number =  branch internal customer
     C                   MOVE      BICN          FFCNUM
      * account code = computer suspense account code.
     C                   MOVE      BKACCD        FFACOD
     C                   ENDIF
 
     C     SBSLT         IFEQ      '15'
      * user number =  broker number.
     C                   EVAL      FFCNUM = BOCO
      * account code = default broker account code.
     C                   EVAL      FFACOD = DFBA
 
      * If it's a client portfolio and if a portfolio exists in PMPORTPD
      * use margin account sequence by default for the settlement account
 
      * Portfolio management module indicator
     C     BGPFMG        IFEQ      'Y'
      * Portfolios supported
     C     FCPORS        ANDNE     'B'
      * is customer a client portfolio?
     C     WWPORT        ANDEQ     'Y'
      * Private Banking module indicator                                        CPB001
     C     BGN4ST        OREQ      'Y'                                          CPB001
      * is customer a client portfolio?                                         CPB001
     C     WWPORT        ANDEQ     'Y'                                          CPB001
      * account sequence = FF Margin A/C Sequence.
     C                   EVAL      FFACSQ = PNACSQ
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
      **   - Settlement Types 01,02,07,08,12 : if entered, must be a
      **   2 digit no. (left adjusted) which when combined with
      **   Instr. Currency exists as a valid nostro code on PF/TABLETL
     C     SBSLT         IFEQ      '01'
     C     SBSLT         OREQ      '02'
     C     SBSLT         OREQ      '07'
     C     SBSLT         OREQ      '08'
     C     SBSLT         OREQ      '12'
      *
     C                   EVAL      FFNCCY = KCCY
 
     C     SBSLA         IFNE      *BLANK
 
     C                   TESTN                   SBSLA1               75
 
     C     *IN75         IFEQ      '0'
     C     SBSLA2        ORNE      *BLANK
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      XIdx = XIdx + 1
     C                   EVAL      FldNamXArr(XIdx) = 'SBSLA'
     C                   EVAL      MsgIDXArr(XIdx) = 'MMA0450'
     C                   EVAL      OKBSLA = 'N'
 
     C                   ELSE
     C                   MOVE      SBSLA1        FFNOSN
 
     C     FFNKY         CHAIN     TABLETLF                           70
     C  N70RECI          COMP      'D'                                7070
      **  - no live record
     C     *IN70         IFEQ      '1'
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      XIdx = XIdx + 1
     C                   EVAL      FldNamXArr(XIdx) = 'SBSLA'
     C                   EVAL      MsgIDXArr(XIdx) = 'MMA0450'
     C                   EVAL      OKBSLA = 'N'
     C                   ELSE
      **  - record found
     C                   MOVE      CNUM          FFCNUM
     C                   MOVE      ACOD          FFACOD
     C                   MOVE      ACSQ          FFACSQ
 
     C                   MOVE      BRCA          WXSLB
     C                   ENDIF
 
     C                   ENDIF
 
      **  - Nostro code must be entered
     C                   ELSE
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      XIdx = XIdx + 1
     C                   EVAL      FldNamXArr(XIdx) = 'SBSLA'
     C                   EVAL      MsgIDXArr(XIdx) = 'MMA0450'
     C                   EVAL      OKBSLA = 'N'
 
     C                   ENDIF
 
     C                   ENDIF
 
      **   - Settlement Type 03 : must be a left adjusted 6 digit no.
     C     SBSLT         IFEQ      '03'
 
     C******             TESTN                   SBSLA3               75                     CSD027B
 
     C******IN75         IFEQ      '0'                                                       CSD027B
     C*****SBSLA3        OREQ      '000000'                                                  CSD027B
     C     SBSLA3        IFEQ      '000000'                                                  CSD027B
     C     SBSLA4        ORNE      *BLANK
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      XIdx = XIdx + 1
     C                   EVAL      FldNamXArr(XIdx) = 'SBSLA'
     C                   EVAL      MsgIDXArr(XIdx) = 'MMA0451'
     C                   EVAL      OKBSLA = 'N'
     C                   ELSE
     C                   MOVE      BICN          FFCNUM
     C                   MOVE      BLACCD        FFACOD
     C                   MOVE      '01'          FFACSQ
 
     C                   MOVE      SBRCD         WXSLB
     C                   ENDIF
 
     C                   ENDIF
     C     SBSLT         IFEQ      '05'
 
     C******             TESTN                   SBSLA                75                     CSD027B
 
     C******IN75         IFEQ      '1'                                                       CSD027B
 
     C                   MOVE      SBSLA3        KCBCD
     C     KCLINT        CHAIN     CLINT                              71
 
 
     C     *IN71         IFEQ      '0'
     C                   MOVE      SBSLA5        FFACOD
     C*****FFAKY         CHAIN     TABTE10F                           70                      CGL029
     C**N70RECI*         COMP      'D'                                7070                    CGL029
     C                   EXSR      SRACOD                                                     CGL029
 
     C                   ENDIF
 
     C******             ENDIF                                                               CSD027B
 
     C     *IN71         IFEQ      '1'
     C     *IN70         OREQ      '1'
     C******IN75         OREQ      '0'                                                       CSD027B
     C     SBSLA6        OREQ      '00'
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      XIdx = XIdx + 1
     C                   EVAL      FldNamXArr(XIdx) = 'SBSLA'
     C                   EVAL      MsgIDXArr(XIdx) = 'MMA0452'
     C                   EVAL      OKBSLA = 'N'
     C                   ELSE
      *                                                                                       CFF007
     C     CFF007        IFEQ      'Y'                                                        CFF007
     C     PPBBFLG       ANDEQ     'Y'                                                        CFF007
     C     *IN70         ANDEQ     '0'                                                        CFF007
     C*****ATYP*         ANDNE     'R'                                                 CFF007 CGL029
     C     A5ACTY        ANDNE     'R'                                                        CGL029
     C                   EVAL      ErrorFound = 'Y'                                           CFF007
     C                   EVAL      XIdx = XIdx + 1                                            CFF007
     C                   EVAL      FldNamXArr(XIdx) = 'SBSLA'                                 CFF007
     C                   EVAL      MsgIDXArr(XIdx) = 'MMA1163'                                CFF007
     C                   EVAL      OKBSLA = 'N'                                               CFF007
     C                   ELSE                                                                 CFF007
     C                   MOVE      SBSLA3        FFCNUM
     C                   MOVE      SBSLA5        FFACOD
     C                   MOVE      SBSLA6        FFACSQ
     C     BGMBIN        IFEQ      'Y'
     C                   MOVE      SBSBR         WXSLB
     C     KEYB          KLIST
     C**********         KFLD                    KYCNUM            6 0                        CSD027
     C                   KFLD                    KYCNUM            6                          CSD027
     C                   KFLD                    KYCCY             3
     C**********         KFLD                    KYACOD            4 0                        CGL029
     C                   KFLD                    KYACOD           10 0                        CGL029
     C                   KFLD                    KYACSQ            2 0
     C                   KFLD                    KYBRCA            3
     C                   MOVE      SBSLA3        KYCNUM
     C                   MOVE      ISCY          KYCCY
     C                   MOVE      SBSLA5        KYACOD
     C                   MOVE      SBSLA6        KYACSQ
     C                   MOVE      SBSBR         KYBRCA
 
     C     KEYB          SETLL     ACCNT                                  99
 
     C                   IF        *in99 = False
 
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      XIdx = XIdx + 1
     C                   EVAL      FldNamXArr(XIdx) = 'SBSLA'
     C                   EVAL      MsgIDXArr(XIdx) = 'MMA0452'
     C                   EVAL      OKBSLA = 'N'
 
     C                   ENDIF
 
     C                   ELSE
     C                   MOVE      SBRCD         WXSLB
     C                   ENDIF
     C                   ENDIF                                                                CFF007
     C                   ENDIF
 
     C                   ENDIF
 
      **   - Settlement Type 14 : must be a left adjusted Retail A/c no.
      **                           with the same ccy as the Instr. ccy
     C     SBSLT         IFEQ      '14'
 
     C                   TESTN                   SBSLA7               75
 
     C     *IN75         IFEQ      '0'
     C     SBSLA6        ORNE      '  '
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      XIdx = XIdx + 1
     C                   EVAL      FldNamXArr(XIdx) = 'SBSLA'
     C                   EVAL      MsgIDXArr(XIdx) = 'MMA0453'
     C                   EVAL      OKBSLA = 'N'
     C                   ELSE
 
     C                   MOVE      SBSLA7        KACNO            10 0
     C     KACNO         CHAIN     ACNUM                              71
     C  N71RECI          COMP      'D'                                7171
 
     C     *IN71         IFEQ      '1'
     C     CCY           ORNE      KCCY
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      XIdx = XIdx + 1
 
     C                   EVAL      FldNamXArr(XIdx) = 'SBSLA'
     C                   EVAL      MsgIDXArr(XIdx) = 'MMA0453'
     C                   EVAL      OKBSLA = 'N'
     C                   ELSE
     C                   ENDIF
      **  - set Memos update ind. to 'Y'
     C     OKBSLA        IFNE      'N'
     C                   MOVE      'Y'           XMIND
     C                   MOVE      CNUM          FFCNUM
     C                   MOVE      ACOD          FFACOD
     C                   MOVE      ACSQ          FFACSQ
     C                   MOVE      BRCA          WXSLB
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
      **      Settlement Branch (Broker)
      **      ~~~~~~~~~~~~~~~~~
     C     BGMBIN        IFEQ      'Y'
 
     C     SBSLT         IFNE      '05'
     C     SBSBR         IFNE      *BLANKS
 
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      XIdx = XIdx + 1
     C                   EVAL      FldNamXArr(XIdx) = 'SBSBR'
     C                   EVAL      MsgIDXArr(XIdx) = 'MMA0460'
     C                   EVAL      OKBSBR = 'N'
 
     C                   ENDIF
 
      ** If Settlekment method is 05:
     C                   ELSE
 
     C**********         CALLB     'AOBRCHR0'                                                 CGL029
     C                   CALL      'AOBRCHR1'                                                 CGL029
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      SBSBR         @BRCD             3
     C*****SDBRCH        PARM      SDBRCH        @DSFDY                                       CGL029
     C     SDBRCH        PARM      SDBRCH        DSSDY                                        CGL029
 
      **   - live record not found
 
     C     @RTCD         IFNE      *BLANKS
 
     C     @RTCD         IFEQ      '*NOSEL '
 
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      XIdx = XIdx + 1
     C                   EVAL      FldNamXArr(XIdx) = 'SBSBR'
     C                   EVAL      MsgIDXArr(XIdx) = 'MMA0461'
     C                   EVAL      OKBSBR = 'N'
 
     C                   ELSE
 
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      XIdx = XIdx + 1
     C                   EVAL      FldNamXArr(XIdx) = 'SBSBR'
     C                   EVAL      MsgIDXArr(XIdx) = 'MMA0460'
     C                   EVAL      OKBSBR = 'N'
 
     C                   ENDIF
 
     C                   ELSE
 
      **   Selector is used
 
     C                   MOVEL     BRCH          WXSLB
     C                   MOVEL     BRCH          SBSBR
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
      **   If Retail present, Settlement Account not yet in error,
      **    and Settlement type not '00'
     C     BGRTBN        IFEQ      'Y'
     C     OKBSLA        ANDEQ     'Y'
     C     SBSLT         ANDNE     '00'
 
      **   - if the Account Type for the Settlement A/c code is 'R' for
      **      Retail, the account must exist on LF/ACCNT and be open
 
      **   - access  Account codes table file
     C*****FFAKY         CHAIN     TABTE10F                           70                      CGL029
     C**N70RECI*         COMP      'D'                                7070                    CGL029
     C                   EXSR      SRACOD                                                     CGL029
 
      **  - if a Retail account access LF/ACCNT
     C     *IN70         IFEQ      '0'
     C*****ATYP*         ANDEQ     'R'                                                        CGL029
     C     A5ACTY        ANDEQ     'R'                                                        CGL029
 
     C                   MOVE      WXSLB         FFBRCB
     C     FFACTK        CHAIN     ACCNT                              71
     C                   MOVE      *BLANK        FFBRCB
     C  N71RECI          COMP      'D'                                7171
 
      **  - Error if no live open Retail A/c exists
 
     C     *IN71         IFEQ      '1'
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      XIdx = XIdx + 1
     C                   EVAL      FldNamXArr(XIdx) = 'SBSLA'
     C                   EVAL      MsgIDXArr(XIdx) = 'MMA0454'
     C                   EVAL      OKBSLA = 'N'
     C                   ELSE
 
      **  - record found, set Memos update ind. to 'Y'
     C                   MOVE      'Y'           XMIND
 
     C                   ENDIF
 
     C                   ENDIF
 
     C     BGPFMG        IFEQ      'Y'
     C     FCPORS        ANDNE     'B'
     C     BGN4ST        OREQ      'Y'
 
      ** Test if customer of settlement account is the same as broker
      ** entered on the transaction.
     C     FFCNUM        IFNE      BOCO
     C                   EVAL      WarnFound = 'Y'
     C                   EVAL      WIdx = WIdx + 1
     C                   EVAL      FldNamWArr(WIdx) = 'SBSLA'
     C                   EVAL      MsgIDWArr(WIdx) = 'MMA0479'
     C                   MOVE      'W'           OKBSLA
     C                   ENDIF
 
      ** Access ACCNT to obtain portfolio reference
     C                   EVAL      FFBRCB = WXSLB
     C     FFACTK        CHAIN     ACCNT                              71
     C  N71RECI          COMP      'D'                                7171
     C     *IN71         IFEQ      '1'
     C                   EVAL      WarnFound = 'Y'
     C                   EVAL      WIdx = WIdx + 1
     C                   EVAL      FldNamWArr(WIdx) = 'SBSLA'
     C                   EVAL      MsgIDWArr(WIdx) = 'MMA0480'
     C                   MOVE      'W'           OKBSLA
     C                   ELSE
      ** Test if portfolio reference on the account is the same as
      ** portfolio reference on the transaction
     C     SPTFR         IFNE      ACPTFR
     C     SPTFR         IFEQ      FCR997
     C     ACPTFR        ANDNE     '9997'
     C     SPTFR         ORNE      FCR997
     C     BGN4ST        OREQ      'Y'
     C                   EVAL      WarnFound = 'Y'
     C                   EVAL      WIdx = WIdx + 1
     C                   EVAL      FldNamWArr(WIdx) = 'SBSLA'
     C                   EVAL      MsgIDWArr(WIdx) = 'MMA0479'
     C                   MOVE      'W'           OKBSLA
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
 
      **   If Memos Update ind on, + Transaction Date not in error
 
     C     XMIND         IFEQ      'Y'
     C     OKTRSD        ANDEQ     'Y'
 
      **   - determine Back Value Date
     C     CTDATE        SUB       BJBVPD        BVDATE            5 0
 
     C     DACO          IFGT      BVDATE
     C                   MOVE      DACO          BVDATE
     C                   ENDIF
 
      **   - Transaction Date must not be before Back Value Date
     C     TRSD          IFLT      BVDATE
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      XIdx = XIdx + 1
     C                   EVAL      FldNamXArr(XIdx) = 'SBSLA'
     C                   EVAL      MsgIDXArr(XIdx) = 'MMA0455'
     C                   EVAL      OKBSLA = 'N'
     C                   ENDIF
 
     C                   ENDIF
 
      ** Validate broker account's remaining balance                                          CGL014
                                                                                              CGL014
     C                   IF        CGL014 = 'Y'  AND  OKBMAR <> 'N'  AND                      CGL014
     C                             OKBSLA <> 'N'  AND  ATYP = 'R'  AND                        CGL014
     C                             COLF = 'Y'  AND  SBSLA <> *BLANKS  AND                     CGL014
     C                             SBMAR <> *BLANKS                                           CGL014
                                                                                              CGL014
     C                   MOVE      CNUM          PAC_Cust                                     CGL014
     C                   MOVE      ACOD          PAC_Code                                     CGL014
     C                   MOVE      ACSQ          PAC_Seq                                      CGL014
                                                                                              CGL014
      ** Check if balance remaining due to debit posted across                                CGL014
      ** retail accounts is sufficient to cover the blocked amount                            CGL014
                                                                                              CGL014
     C                   CALLB     'GL006000'                                                 CGL014
     C                   PARM      BMAR          PTR_Amount                                   CGL014
     C                   PARM      CCY           PTR_Curr                                     CGL014
     C                   PARM      BRCA          PAC_Branch                                   CGL014
     C                   PARM                    PAC_Cust                                     CGL014
     C                   PARM      CCY           PAC_Curr                                     CGL014
     C                   PARM                    PAC_Code                                     CGL014
     C                   PARM                    PAC_Seq                                      CGL014
     C                   PARM      ACNO          PAC_Retail                                   CGL014
     C                   PARM      *BLANKS       PRetCode                                     CGL014
                                                                                              CGL014
      ** Send error msg 'Available balance is not sufficient                                  CGL014
      ** to cover blocked amount'                                                             CGL014
                                                                                              CGL014
     C                   IF        PRetCode = '*BLKERR'                                       CGL014
     C                   EVAL      ErrorFound = 'Y'                                           CGL014
     C                   EVAL      OKBMAR = 'N'                                               CGL014
     C                   EVAL      XIdx = XIdx + 1                                            CGL014
     C                   EVAL      FldNamXArr(XIdx) = 'SBMAR'                                 CGL014
     C                   EVAL      MsgIDXArr(XIdx) = 'MMA0862'                                CGL014
     C                   ENDIF                                                                CGL014
                                                                                              CGL014
      ** Balance is greater than blocked amount but less than minimum                         CGL014
      ** balance, send warning msg 'Minimum balance will be exceeded'                         CGL014
                                                                                              CGL014
     C                   IF        PRetCode = '*WARN  '                                       CGL014
     C                   IF        WPrvSBMAR <> SBMAR  OR                                     CGL014
     C                             WPrvSBSBR <> SBSBR  OR                                     CGL014
     C                             WPrvSBSLA <> SBSLA                                         CGL014
     C                   EVAL      WPrvSBMAR = SBMAR                                          CGL014
     C                   EVAL      WPrvSBSBR = SBSBR                                          CGL014
     C                   EVAL      WPrvSBSLA = SBSLA                                          CGL014
     C                   EVAL      WarnFound = 'Y'                                            CGL014
     C                   MOVE      'W'           OKBMAR                                       CGL014
     C                   EVAL      WIdx = WIdx + 1                                            CGL014
     C                   EVAL      FldNamWArr(WIdx) = 'SBMAR'                                 CGL014
     C                   EVAL      MsgIDWArr(WIdx) = 'MMA0863'                                CGL014
     C                   ENDIF                                                                CGL014
     C                   ENDIF                                                                CGL014
                                                                                              CGL014
     C                   ENDIF                                                                CGL014
 
 
      **      For Account Of (Broker)
      **      ~~~~~~~~~~~~~~
      **   Entry only allowed for Settlement Types 01,02,07,08,12
     C     SBFAO         IFNE      *BLANK
 
     C     SBSLT         IFNE      '01'
     C     SBSLT         ANDNE     '02'
     C     SBSLT         ANDNE     '07'
     C     SBSLT         ANDNE     '08'
     C     SBSLT         ANDNE     '12'
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      XIdx = XIdx + 1
     C                   EVAL      FldNamXArr(XIdx) = 'SBFAO'
     C                   EVAL      MsgIDXArr(XIdx) = 'MMA0456'
     C                   EVAL      OKBFAO = 'N'
 
     C                   ELSE
 
     C**********         CALLB     'AOCUSTR0'                                                 CFF007
     C                   CALLB     'AOCUSTR1'                                                 CFF007
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      SBFAO         @KEY1            10
     C                   PARM                    @KYST             7
     C*****SDCUST        PARM      SDCUST        DSSDY                                        CFF007
     C     SDCUST        PARM      SDCUST        DSLDY                                        CFF007
 
      **   - must exist as a live record on SDCUSTPD
 
     C     @RTCD         IFNE      *BLANKS
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      XIdx = XIdx + 1
     C                   EVAL      FldNamXArr(XIdx) = 'SBFAO'
     C                   EVAL      MsgIDXArr(XIdx) = 'MMA0457'
     C                   EVAL      OKBFAO = 'N'
 
     C                   ELSE
 
      **   Set up SBFAO for display
 
     C                   MOVE      *BLANKS       SBFAO
     C     @KYST         IFEQ      '*CNUM'
     C                   MOVEL     CUST          SBFAO
     C                   ELSE
     C                   MOVE      CSSN          SBFAO
     C                   ENDIF
 
      **   Set up key KCBCD
 
     C                   MOVE      CUST          KCBCD
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
     C/SPACE 2
      **      Counterparty Nostro  (Broker)
      **      ~~~~~~~~~~~~~~~~~~~
      **   Entry only allowed for Settlement Types 01,02,07,08,12
     C     SBCPN         IFNE      *BLANK
 
     C     SBSLT         IFNE      '01'
     C     SBSLT         ANDNE     '02'
     C     SBSLT         ANDNE     '07'
     C     SBSLT         ANDNE     '08'
     C     SBSLT         ANDNE     '12'
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      XIdx = XIdx + 1
     C                   EVAL      FldNamXArr(XIdx) = 'SBCPN'
     C                   EVAL      MsgIDXArr(XIdx) = 'MMA0458'
     C                   EVAL      OKBCPN = 'N'
 
     C                   ELSE
 
      **   - must exist as a valid Counterparty Nostro on PF/TABLET2
      **     or as a valid customer on PF/CLINTCB
     C                   MOVEL     SBCPN         SBCPN6            6
     C******             TESTN                   SBCPN6               75                     CSD027B
 
      **   If counterparty nostro field entered is numeric, access
      **   LF/CLINT to check that record exists
     C******IN75         IFEQ      '1'                                                       CSD027B
     C                   MOVE      SBCPN6        KCBCD
     C     KCLINT        CHAIN     CLINTCBF                           71
     C  N71RECI          COMP      'D'                                7171
 
      **   - no live record exists
     C******IN71         IFEQ      '1'                                                       CSD027B
     C******             EVAL      ErrorFound = 'Y'                                          CSD027B
     C******             EVAL      XIdx = XIdx + 1                                           CSD027B
     C******             EVAL      FldNamXArr(XIdx) = 'SBCPN'                                CSD027B
     C******             EVAL      MsgIDXArr(XIdx) = 'MMA0459'                               CSD027B
     C******             EVAL      OKBCPN = 'N'                                              CSD027B
     C******             ENDIF                                                               CSD027B
 
      **   Else counterparty nostro field entered is not numeric,
      **   access LF/SNAME to check for customer shortname
     C******             ELSE                                                                CSD027B
     C                   MOVE      SBCPN         KCSNM
 
     C     KCSNM         CHAIN     SNAME                              74
     C  N74RECI          COMP      'D'                                7474
 
      **   If record found, store customer number for this customer
      **   shortname in a work field
     C     *IN74         IFEQ      '0'
 
     C**********         Z-ADD     CNUM          CNUMB             6 0                        CSD027
     C                   MOVE      CNUM          CNUMB             6                          CSD027
 
      **   Else access PF/TABLET2 to check for valid counterparty
      **   nostro
     C                   ELSE
     C                   MOVEL     SBCPN         KCPSH2
 
     C     KCPSH         CHAIN     TABLET2F                           70
     C  N70RECI          COMP      'D'                                7070
 
      **   - no live record exists
     C     *IN70         IFEQ      '1'
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      XIdx = XIdx + 1
     C                   EVAL      FldNamXArr(XIdx) = 'SBCPN'
     C                   EVAL      MsgIDXArr(XIdx) = 'MMA0459'
     C                   EVAL      OKBCPN = 'N'
     C                   ENDIF
     C                   ENDIF
 
     C**********         ENDIF                                                               CSD027B
 
     C                   ENDIF
 
     C                   ENDIF
 
      ** If there have been no errors, set up the valid settlements
      ** file details for customer or broker, as appropriate.
     C                   IF        XIdx = 0
 
     C                   EXSR      SetupVBrok
 
     C                   ENDIF
 
     C     BSEND         TAG                                                    *** BSEND  ***
 
     C                   ENDSR
 
      *****************************************************************
      *                                                               *
      * CustSR - Processing when customer settlement instructions     *
      *          requested                                            *
      *                                                               *
      *****************************************************************
 
     C     CustSR        BEGSR
 
      **   1. Settlement Type (Customer)
      **      ~~~~~~~~~~~~~~~
     C     SCSLT         IFEQ      '  '
     C                   MOVE      '00'          SCSLT
     C                   ENDIF
      **   Valid values for settlement type
     C     SCSLT         IFNE      '00'
     C     SCSLT         ANDNE     '01'
     C     SCSLT         ANDNE     '02'
     C     SCSLT         ANDNE     '03'
     C     SCSLT         ANDNE     '04'
     C     SCSLT         ANDNE     '05'
     C     SCSLT         ANDNE     '06'
     C     SCSLT         ANDNE     '07'
     C     SCSLT         ANDNE     '08'
     C     SCSLT         ANDNE     '12'
     C     SCSLT         ANDNE     '14'
     C     SCSLT         ANDNE     '15'
     C     CFF007        ANDNE     'Y'                                                        CFF007
                                                                                              CFF007
     C     SCSLT         ORNE      '00'                                                       CFF007
     C     SCSLT         ANDNE     '01'                                                       CFF007
     C     SCSLT         ANDNE     '02'                                                       CFF007
     C     SCSLT         ANDNE     '03'                                                       CFF007
     C     SCSLT         ANDNE     '04'                                                       CFF007
     C     SCSLT         ANDNE     '05'                                                       CFF007
     C     SCSLT         ANDNE     '06'                                                       CFF007
     C     SCSLT         ANDNE     '07'                                                       CFF007
     C     SCSLT         ANDNE     '08'                                                       CFF007
     C     SCSLT         ANDNE     '12'                                                       CFF007
     C     SCSLT         ANDNE     '14'                                                       CFF007
     C     SCSLT         ANDNE     '15'                                                       CFF007
     C     CFF007        ANDEQ     'Y'                                                        CFF007
     C     PPBCFLG       ANDNE     'Y'                                                        CFF007
                                                                                              CFF007
     C     SCSLT         ORNE      '04'                                                       CFF007
     C     SCSLT         ANDNE     '05'                                                       CFF007
     C     SCSLT         ANDNE     '14'                                                       CFF007
     C     SCSLT         ANDNE     '15'                                                       CFF007
     C     PPBCFLG       ANDEQ     'Y'                                                        CFF007
     C     CFF007        ANDEQ     'Y'                                                        CFF007
 
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      XIdx = XIdx + 1
     C                   EVAL      FldNamXArr(XIdx) = 'SCSLT'
     C     CFF007        IFEQ      'Y'                                                        CFF007
     C     PPBCFLG       ANDEQ     'Y'                                                        CFF007
     C                   EVAL      MSGIDXArr(XIdx) = 'MMA1165'                                CFF007
     C                   ELSE                                                                 CFF007
     C                   EVAL      MsgIDXArr(XIdx) = 'MMA0462'
     C                   ENDIF                                                                CFF007
     C                   EVAL      OKCSLT = 'N'
     C                   GOTO      CSEND
     C                   ENDIF
 
      **   Types 04 + 14 only allowed if Retail present (BGRTBN)
     C     BGRTBN        IFEQ      'N'
 
     C     SCSLT         IFEQ      '04'
     C     SCSLT         OREQ      '14'
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      XIdx = XIdx + 1
     C                   EVAL      FldNamXArr(XIdx) = 'SCSLT'
     C                   EVAL      MsgIDXArr(XIdx) = 'MMA0463'
     C                   EVAL      OKCSLT = 'N'
     C                   GOTO      CSEND
     C                   ENDIF
 
     C                   ENDIF
 
      **   Type 07 - Instr. ccy must be U.S. ccy code
     C     SCSLT         IFEQ      '07'
     C     KCCY          ANDNE     BLUSCY
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      XIdx = XIdx + 1
     C                   EVAL      FldNamXArr(XIdx) = 'SCSLT'
     C                   EVAL      MsgIDXArr(XIdx) = 'MMA0464'
     C                   EVAL      OKCSLT = 'N'
     C                   GOTO      CSEND
     C                   ENDIF
 
      **   Type 14 - Retail A/c nos. must be supported
     C     SCSLT         IFEQ      '14'
 
      **   BMRANR =  Retail account numbers required indicator.
     C     BMRANR        ANDNE     'Y'
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      XIdx = XIdx + 1
     C                   EVAL      FldNamXArr(XIdx) = 'SCSLT'
     C                   EVAL      MsgIDXArr(XIdx) = 'MMA0465'
     C                   EVAL      OKCSLT = 'N'
     C                   GOTO      CSEND
     C                   ENDIF
 
      **   Continue only if Settlement Type not in error
 
      **   2. Settlement Account (Customer)
      **      ~~~~~~~~~~~~~~~~~~
      **   - Settlement Types 00,04,06,15 : entry not allowed
     C     SCSLT         IFEQ      '00'
     C     SCSLT         OREQ      '04'
     C     SCSLT         OREQ      '06'
     C     SCSLT         OREQ      '15'
 
      * If settlement account has an entry, not allowed.
     C     SCSLA         IFNE      *BLANK
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      XIdx = XIdx + 1
     C                   EVAL      FldNamXArr(XIdx) = 'SCSLA'
     C                   EVAL      MsgIDXArr(XIdx) = 'MMA0466'
     C                   EVAL      OKCSLA = 'N'
 
     C                   ELSE
     C                   EVAL      WXSLB = SBRCD
 
     C     SCSLT         IFNE      '00'
 
     C                   MOVE      '01'          FFACSQ
 
     C     SCSLT         IFEQ      '04'
     C                   EVAL      FFCNUM = CUSC
 
      * Move current account default a/c code to FFACOD account code.
     C                   MOVE      BMACCD        FFACOD
     C                   ENDIF
 
     C     SCSLT         IFEQ      '06'
      * user number =  branch internal customer
     C                   MOVE      BICN          FFCNUM
      * account code = computer suspense account code.
     C                   MOVE      BKACCD        FFACOD
     C                   ENDIF
 
     C     SCSLT         IFEQ      '15'
      * user number =  customer number.
     C                   EVAL      FFCNUM = CUSC
      * account code = default customer account code.
     C                   EVAL      FFACOD = DFCA
 
      * If it's a client portfolio and if a portfolio exists in PMPORTPD
      * use margin account sequence by default for the settlement account
 
      * Portfolio management module indicator
     C     BGPFMG        IFEQ      'Y'
      * Portfolios supported
     C     FCPORS        ANDNE     'B'
      * is customer a client portfolio?
     C     WWPORT        ANDEQ     'Y'
      * Private Banking module indicator                                        CPB001
     C     BGN4ST        OREQ      'Y'                                          CPB001
      * is customer a client portfolio?                                         CPB001
     C     WWPORT        ANDEQ     'Y'                                          CPB001
      * account sequence = FF Margin A/C Sequence.
     C                   EVAL      FFACSQ = PNACSQ
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
      **   - Settlement Types 01,02,07,08,12 : if entered, must be a
      **   2 digit no. (left adjusted) which when combined with
      **   Instr. Currency exists as a valid nostro code on PF/TABLETL
     C     SCSLT         IFEQ      '01'
     C     SCSLT         OREQ      '02'
     C     SCSLT         OREQ      '07'
     C     SCSLT         OREQ      '08'
     C     SCSLT         OREQ      '12'
      *
     C                   EVAL      FFNCCY = KCCY
 
     C     SCSLA         IFNE      *BLANK
 
     C                   TESTN                   SCSLA1               75
 
     C     *IN75         IFEQ      '0'
     C     SCSLA2        ORNE      *BLANK
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      XIdx = XIdx + 1
     C                   EVAL      FldNamXArr(XIdx) = 'SCSLA'
     C                   EVAL      MsgIDXArr(XIdx) = 'MMA0467'
     C                   EVAL      OKCSLA = 'N'
 
     C                   ELSE
     C                   MOVE      SCSLA1        FFNOSN
 
     C     FFNKY         CHAIN     TABLETLF                           70
     C  N70RECI          COMP      'D'                                7070
      **  - no live record
     C     *IN70         IFEQ      '1'
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      XIdx = XIdx + 1
     C                   EVAL      FldNamXArr(XIdx) = 'SCSLA'
     C                   EVAL      MsgIDXArr(XIdx) = 'MMA0467'
     C                   EVAL      OKCSLA = 'N'
     C                   ELSE
      **  - record found
     C                   MOVE      CNUM          FFCNUM
     C                   MOVE      ACOD          FFACOD
     C                   MOVE      ACSQ          FFACSQ
 
     C                   MOVE      BRCA          WXSLB
     C                   ENDIF
 
     C                   ENDIF
 
      **  - Nostro code must be entered
     C                   ELSE
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      XIdx = XIdx + 1
     C                   EVAL      FldNamXArr(XIdx) = 'SCSLA'
     C                   EVAL      MsgIDXArr(XIdx) = 'MMA0467'
     C                   EVAL      OKCSLA = 'N'
 
     C                   ENDIF
 
     C                   ENDIF
 
      **   - Settlement Type 03 : must be a left adjusted 6 digit no.
     C     SCSLT         IFEQ      '03'
 
     C******             TESTN                   SCSLA3               75                     CSD027B
 
     C******IN75         IFEQ      '0'                                                       CSD027B
     C*****SCSLA3        OREQ      '000000'                                                  CSD027B
     C     SCSLA3        IFEQ      '000000'                                                  CSD027B
     C     SCSLA4        ORNE      *BLANK
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      XIdx = XIdx + 1
     C                   EVAL      FldNamXArr(XIdx) = 'SCSLA'
     C                   EVAL      MsgIDXArr(XIdx) = 'MMA0468'
     C                   EVAL      OKCSLA = 'N'
     C                   ELSE
     C                   MOVE      BICN          FFCNUM
     C                   MOVE      BLACCD        FFACOD
     C                   MOVE      '01'          FFACSQ
 
     C                   MOVE      SBRCD         WXSLB
     C                   ENDIF
 
     C                   ENDIF
     C     SCSLT         IFEQ      '05'
 
     C******             TESTN                   SCSLA                75                     CSD027B
 
     C******IN75         IFEQ      '1'                                                       CSD027B
 
     C                   MOVE      SCSLA3        KCBCD
     C     KCLINT        CHAIN     CLINT                              71
 
 
     C     *IN71         IFEQ      '0'
     C                   MOVE      SCSLA5        FFACOD
     C*****FFAKY         CHAIN     TABTE10F                           70                      CGL029
     C**N70RECI*         COMP      'D'                                7070                    CGL029
     C                   EXSR      SRACOD                                                     CGL029
 
     C                   ENDIF
 
     C******             ENDIF                                                               CSD027B
 
     C     *IN71         IFEQ      '1'
     C     *IN70         OREQ      '1'
     C******IN75         OREQ      '0'                                                       CSD027B
     C     SCSLA6        OREQ      '00'
 
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      XIdx = XIdx + 1
     C                   EVAL      FldNamXArr(XIdx) = 'SCSLA'
     C                   EVAL      MsgIDXArr(XIdx) = 'MMA0469'
     C                   EVAL      OKCSLA = 'N'
 
     C                   ELSE
      *                                                                                       CFF007
     C     CFF007        IFEQ      'Y'                                                        CFF007
     C     PPBCFLG       ANDEQ     'Y'                                                        CFF007
     C     *IN70         ANDEQ     '0'                                                        CFF007
     C*****ATYP*         ANDNE     'R'                                                 CFF007 CGL029
     C     A5ACTY        ANDNE     'R'                                                        CGL029
     C                   EVAL      ErrorFound = 'Y'                                           CFF007
     C                   EVAL      XIdx = XIdx + 1                                            CFF007
     C                   EVAL      FldNamXArr(XIdx) = 'SCSLA'                                 CFF007
     C                   EVAL      MsgIDXArr(XIdx) = 'MMA1163'                                CFF007
     C                   EVAL      OKCSLA = 'N'                                               CFF007
     C                   ELSE                                                                 CFF007
 
     C                   MOVE      SCSLA3        FFCNUM
     C                   MOVE      SCSLA5        FFACOD
     C                   MOVE      SCSLA6        FFACSQ
 
     C     BGMBIN        IFEQ      'Y'
     C                   MOVE      SBRSC         WXSLB
 
     C                   MOVE      SCSLA3        KYCNUM
     C                   MOVE      ISCY          KYCCY
     C                   MOVE      SCSLA5        KYACOD
     C                   MOVE      SCSLA6        KYACSQ
     C                   MOVE      SBRSC         KYBRCA
 
     C     KEYC          SETLL     ACCNT                                  99                   08599
 
     C                   IF        *in99 = False
 
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      XIdx = XIdx + 1
     C                   EVAL      FldNamXArr(XIdx) = 'SCSLA'
     C                   EVAL      MsgIDXArr(XIdx) = 'MMA0469'
     C                   EVAL      OKCSLA = 'N'
 
     C                   ENDIF
 
     C                   ELSE
     C                   MOVE      SBRCD         WXSLB
     C                   ENDIF
     C                   ENDIF                                                                CFF007
     C                   ENDIF
 
     C                   ENDIF
 
      **   - Settlement Type 14 : must be a left adjusted Retail A/c no.
      **                           with the same ccy as the Instr. ccy
     C     SCSLT         IFEQ      '14'
 
     C                   TESTN                   SCSLA7               75
 
     C     *IN75         IFEQ      '0'
     C     SCSLA6        ORNE      '  '
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      XIdx = XIdx + 1
     C                   EVAL      FldNamXArr(XIdx) = 'SCSLA'
     C                   EVAL      MsgIDXArr(XIdx) = 'MMA0470'
     C                   EVAL      OKCSLA = 'N'
     C                   ELSE
 
     C                   MOVE      SCSLA7        KACNO            10 0
     C     KACNO         CHAIN     ACNUM                              71
     C  N71RECI          COMP      'D'                                7171
 
     C     *IN71         IFEQ      '1'
     C     CCY           ORNE      KCCY
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      XIdx = XIdx + 1
     C                   EVAL      FldNamXArr(XIdx) = 'SCSLA'
     C                   EVAL      MsgIDXArr(XIdx) = 'MMA0470'
     C                   EVAL      OKCSLA = 'N'
     C                   ELSE
     C                   ENDIF
      **  - set Memos update ind. to 'Y'
     C     OKCSLA        IFNE      'N'
     C                   MOVE      'Y'           XMIND
     C                   MOVE      CNUM          FFCNUM
     C                   MOVE      ACOD          FFACOD
     C                   MOVE      ACSQ          FFACSQ
     C                   MOVE      BRCA          WXSLB
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
      **      Settlement Branch (Customer)
      **      ~~~~~~~~~~~~~~~~~
     C     BGMBIN        IFEQ      'Y'
 
     C     SCSLT         IFNE      '05'
     C     SBRSC         IFNE      *BLANKS
 
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      XIdx = XIdx + 1
     C                   EVAL      FldNamXArr(XIdx) = 'SBRSC'
     C                   EVAL      MsgIDXArr(XIdx) = 'MMA0477'
     C                   EVAL      OKBRSC = 'N'
 
     C                   ENDIF
 
      ** If Settlement method is 05:
     C                   ELSE
 
     C**********         CALLB     'AOBRCHR0'                                                 CGL029
     C                   CALL      'AOBRCHR1'                                                 CGL029
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      SBRSC         @BRCD             3
     C*****SDBRCH        PARM      SDBRCH        @DSFDY                                       CGL029
     C     SDBRCH        PARM      SDBRCH        DSSDY                                        CGL029
 
      **   - live record not found
 
     C     @RTCD         IFNE      *BLANKS
 
     C     @RTCD         IFEQ      '*NOSEL '
 
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      XIdx = XIdx + 1
     C                   EVAL      FldNamXArr(XIdx) = 'SBRSC'
     C                   EVAL      MsgIDXArr(XIdx) = 'MMA0478'
     C                   EVAL      OKBRSC = 'N'
 
     C                   ELSE
 
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      XIdx = XIdx + 1
     C                   EVAL      FldNamXArr(XIdx) = 'SBRSC'
     C                   EVAL      MsgIDXArr(XIdx) = 'MMA0477'
     C                   EVAL      OKBRSC = 'N'
 
     C                   ENDIF
 
     C                   ELSE
 
      **   Selector is used
 
     C                   MOVEL     BRCH          WXSLB
     C                   MOVEL     BRCH          SBRSC
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
      **   If Retail present, Settlement Account not yet in error,
      **    and Settlement type not '00'
     C     BGRTBN        IFEQ      'Y'
     C     OKCSLA        ANDEQ     'Y'
     C     SCSLT         ANDNE     '00'
 
      **   - if the Account Type for the Settlement A/c code is 'R' for
      **      Retail, the account must exist on LF/ACCNT and be open
 
      **   - access  Account codes table file
     C*****FFAKY         CHAIN     TABTE10F                           70                      CGL029
     C**N70RECI*         COMP      'D'                                7070                    CGL029
     C                   EXSR      SRACOD                                                     CGL029
 
      **  - if a Retail account access LF/ACCNT
     C     *IN70         IFEQ      '0'
     C*****ATYP*         ANDEQ     'R'                                                        CGL029
     C     A5ACTY        ANDEQ     'R'                                                        CGL029
 
     C                   MOVE      WXSLB         FFBRCB
     C     FFACTK        CHAIN     ACCNT                              71
     C                   MOVE      *BLANK        FFBRCB
     C  N71RECI          COMP      'D'                                7171
 
      **  - Error if no live open Retail A/c exists
 
     C     *IN71         IFEQ      '1'
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      XIdx = XIdx + 1
     C                   EVAL      FldNamXArr(XIdx) = 'SCSLA'
     C                   EVAL      MsgIDXArr(XIdx) = 'MMA0471'
     C                   EVAL      OKCSLA = 'N'
     C                   ELSE
 
      **  - record found, set Memos update ind. to 'Y'
     C                   MOVE      'Y'           XMIND
 
     C                   ENDIF
 
     C                   ENDIF
 
     C     BGPFMG        IFEQ      'Y'
     C     FCPORS        ANDNE     'B'
     C     BGN4ST        OREQ      'Y'                                          CPB001
 
      ** Test if customer of settlement account is the same as customer
      ** entered on the transaction.
     C     FFCNUM        IFNE      CUSC
     C                   EVAL      WarnFound = 'Y'
     C                   EVAL      WIdx = WIdx + 1
     C                   EVAL      FldNamWArr(WIdx) = 'SCSLA'
     C                   EVAL      MsgIDWArr(WIdx) = 'MMA0479'
     C                   MOVE      'W'           OKCSLA
     C                   ENDIF
 
      ** Access ACCNT to obtain portfolio reference
     C                   EVAL      FFBRCB = WXSLB
     C     FFACTK        CHAIN     ACCNT                              71
     C  N71RECI          COMP      'D'                                7171
     C     *IN71         IFEQ      '1'
     C                   EVAL      WarnFound = 'Y'
     C                   EVAL      WIdx = WIdx + 1
     C                   EVAL      FldNamWArr(WIdx) = 'SCSLA'
     C                   EVAL      MsgIDWArr(WIdx) = 'MMA0480'
     C                   MOVE      'W'           OKCSLA
     C                   ELSE
      ** Test if portfolio reference on the account is the same as
      ** portfolio reference on the transaction
     C     SPTFR         IFNE      ACPTFR
     C     SPTFR         IFEQ      FCR997
     C     ACPTFR        ANDNE     '9997'
     C     SPTFR         ORNE      FCR997
     C     BGN4ST        OREQ      'Y'                                          CPB001
     C                   EVAL      WarnFound = 'Y'
     C                   EVAL      WIdx = WIdx + 1
     C                   EVAL      FldNamWArr(WIdx) = 'SCSLA'
     C                   EVAL      MsgIDWArr(WIdx) = 'MMA0479'
     C                   MOVE      'W'           OKCSLA
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
 
      **   If Memos Update ind on, + Transaction Date not in error
 
     C     XMIND         IFEQ      'Y'
     C     OKTRSD        ANDEQ     'Y'
 
      **   - determine Back Value Date
     C     CTDATE        SUB       BJBVPD        BVDATE            5 0
 
     C     DACO          IFGT      BVDATE
     C                   MOVE      DACO          BVDATE
     C                   ENDIF
 
      **   - Transaction Date must not be before Back Value Date
     C     TRSD          IFLT      BVDATE
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      XIdx = XIdx + 1
     C                   EVAL      FldNamXArr(XIdx) = 'SCSLA'
     C                   EVAL      MsgIDXArr(XIdx) = 'MMA0472'
     C                   EVAL      OKCSLA = 'N'
     C                   ENDIF
 
     C                   ENDIF
                                                                                              CGL014
      ** Validate customer account's remaining balance                                        CGL014
                                                                                              CGL014
     C                   IF        CGL014 = 'Y'  AND  OKCMAR <> 'N'  AND                      CGL014
     C                             OKCSLA <> 'N'  AND  ATYP = 'R'  AND                        CGL014
     C                             COLF = 'Y'  AND  SCSLA <> *BLANKS  AND                     CGL014
     C                             SCMAR <> *BLANKS                                           CGL014
                                                                                              CGL014
     C                   MOVE      CNUM          PAC_Cust                                     CGL014
     C                   MOVE      ACOD          PAC_Code                                     CGL014
     C                   MOVE      ACSQ          PAC_Seq                                      CGL014
                                                                                              CGL014
      ** Check if balance remaining due to debit posted across                                CGL014
      ** retail accounts is sufficient to cover the blocked amount                            CGL014
                                                                                              CGL014
     C                   CALLB     'GL006000'                                                 CGL014
     C                   PARM      CMAR          PTR_Amount                                   CGL014
     C                   PARM      CCY           PTR_Curr                                     CGL014
     C                   PARM      BRCA          PAC_Branch                                   CGL014
     C                   PARM                    PAC_Cust                                     CGL014
     C                   PARM      CCY           PAC_Curr                                     CGL014
     C                   PARM                    PAC_Code                                     CGL014
     C                   PARM                    PAC_Seq                                      CGL014
     C                   PARM      ACNO          PAC_Retail                                   CGL014
     C                   PARM      *BLANKS       PRetCode                                     CGL014
                                                                                              CGL014
      ** Send error msg 'Available balance is not sufficient                                  CGL014
      ** to cover blocked amount'                                                             CGL014
                                                                                              CGL014
     C                   IF        PRetCode = '*BLKERR'                                       CGL014
     C                   EVAL      ErrorFound = 'Y'                                           CGL014
     C                   EVAL      OKCMAR = 'N'                                               CGL014
     C                   EVAL      XIdx = XIdx + 1                                            CGL014
     C                   EVAL      FldNamXArr(XIdx) = 'SCMAR'                                 CGL014
     C                   EVAL      MsgIDXArr(XIdx) = 'MMA0862'                                CGL014
     C                   ENDIF                                                                CGL014
                                                                                              CGL014
      ** Balance is greater than blocked amount but less than minimum                         CGL014
      ** balance, send warning msg 'Minimum balance will be exceeded'                         CGL014
                                                                                              CGL014
     C                   IF        PRetCode = '*WARN  '                                       CGL014
     C                   IF        WPrvSCMAR <> SCMAR  OR                                     CGL014
     C                             WPrvSBRSC <> SBRSC  OR                                     CGL014
     C                             WPrvSCSLA <> SCSLA                                         CGL014
     C                   EVAL      WPrvSCMAR = SCMAR                                          CGL014
     C                   EVAL      WPrvSBRSC = SBRSC                                          CGL014
     C                   EVAL      WPrvSCSLA = SCSLA                                          CGL014
     C                   EVAL      WarnFound = 'Y'                                            CGL014
     C                   MOVE      'W'           OKCMAR                                       CGL014
     C                   EVAL      WIdx = WIdx + 1                                            CGL014
     C                   EVAL      FldNamWArr(WIdx) = 'SCMAR'                                 CGL014
     C                   EVAL      MsgIDWArr(WIdx) = 'MMA0863'                                CGL014
     C                   ENDIF                                                                CGL014
     C                   ENDIF                                                                CGL014
                                                                                              CGL014
     C                   ENDIF                                                                CGL014
 
      **      For Account Of (Customer)
      **      ~~~~~~~~~~~~~~
      **   Entry only allowed for Settlement Types 01,02,07,08,12
     C     SCFAO         IFNE      *BLANK
 
     C     SCSLT         IFNE      '01'
     C     SCSLT         ANDNE     '02'
     C     SCSLT         ANDNE     '07'
     C     SCSLT         ANDNE     '08'
     C     SCSLT         ANDNE     '12'
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      XIdx = XIdx + 1
     C                   EVAL      FldNamXArr(XIdx) = 'SCFAO'
     C                   EVAL      MsgIDXArr(XIdx) = 'MMA0473'
     C                   EVAL      OKCFAO = 'N'
 
     C                   ELSE
 
     C**********         CALLB     'AOCUSTR0'                                                 CFF007
     C                   CALLB     'AOCUSTR1'                                                 CFF007
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      SCFAO         @KEY1            10
     C                   PARM                    @KYST             7
     C*****SDCUST        PARM      SDCUST        DSSDY                                        CFF007
     C     SDCUST        PARM      SDCUST        DSLDY                                        CFF007
 
      **   - must exist as a live record on SDCUSTPD
 
     C     @RTCD         IFNE      *BLANKS
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      XIdx = XIdx + 1
     C                   EVAL      FldNamXArr(XIdx) = 'SCFAO'
     C                   EVAL      MsgIDXArr(XIdx) = 'MMA0474'
     C                   EVAL      OKCFAO = 'N'
 
     C                   ELSE
 
      **   Set up SCFAO for display
 
     C                   MOVE      *BLANKS       SCFAO
     C     @KYST         IFEQ      '*CNUM'
     C                   MOVEL     CUST          SCFAO
     C                   ELSE
     C                   MOVE      CSSN          SCFAO
     C                   ENDIF
 
      **   Set up key KCBCD
 
     C                   MOVE      CUST          KCBCD
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
     C/SPACE 2
      **      Counterparty Nostro (Customer)
      **      ~~~~~~~~~~~~~~~~~~~
      **   Entry only allowed for Settlement Types 01,02,07,08,12
     C     SCCPN         IFNE      *BLANK
 
     C     SCSLT         IFNE      '01'
     C     SCSLT         ANDNE     '02'
     C     SCSLT         ANDNE     '07'
     C     SCSLT         ANDNE     '08'
     C     SCSLT         ANDNE     '12'
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      XIdx = XIdx + 1
     C                   EVAL      FldNamXArr(XIdx) = 'SCCPN'
     C                   EVAL      MsgIDXArr(XIdx) = 'MMA0475'
     C                   EVAL      OKCCPN = 'N'
 
     C                   ELSE
 
      **   - must exist as a valid Counterparty Nostro on PF/TABLET2
      **     or as a valid customer on PF/CLINTCB
     C                   MOVEL     SCCPN         SCCPN6            6
     C******             TESTN                   SCCPN6               75                     CSD027B
 
      **   If counterparty nostro field entered is numeric, access
      **   LF/CLINT to check that record exists
     C******IN75         IFEQ      '1'                                                       CSD027B
     C                   MOVE      SCCPN6        KCBCD
     C     KCLINT        CHAIN     CLINTCBF                           71
     C  N71RECI          COMP      'D'                                7171
 
      **   - no live record exists
     C     *IN71         IFEQ      '1'
     C******             EVAL      ErrorFound = 'Y'                                          CSD027B
     C******             EVAL      XIdx = XIdx + 1                                           CSD027B
     C******             EVAL      FldNamXArr(XIdx) = 'SCCPN'                                CSD027B
     C******             EVAL      MsgIDXArr(XIdx) = 'MMA0476'                               CSD027B
     C******             EVAL      OKCCPN = 'N'                                              CSD027B
     C******             ENDIF                                                               CSD027B
 
      **   Else counterparty nostro field entered is not numeric,
      **   access LF/SNAME to check for customer shortname
     C******             ELSE                                                                CSD027B
     C                   MOVE      SCCPN         KCSNM
 
     C     KCSNM         CHAIN     SNAME                              74
     C  N74RECI          COMP      'D'                                7474
 
      **   If record found, store customer number for this customer
      **   shortname in a work field
     C     *IN74         IFEQ      '0'
 
     C**********         Z-ADD     CNUM          CNUMC             6 0                        CSD027
     C                   MOVE      CNUM          CNUMC             6                          CSD027
 
      **   Else access PF/TABLET2 to check for valid counterparty
      **   nostro
     C                   ELSE
     C                   MOVEL     SCCPN         KCPSH2
 
     C     KCPSH         CHAIN     TABLET2F                           70
     C  N70RECI          COMP      'D'                                7070
 
      **   - no live record exists
     C     *IN70         IFEQ      '1'
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      XIdx = XIdx + 1
     C                   EVAL      FldNamXArr(XIdx) = 'SCCPN'
     C                   EVAL      MsgIDXArr(XIdx) = 'MMA0476'
     C                   EVAL      OKCCPN = 'N'
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
      ** If there have been no errors, set up the valid settlements
      ** file details for customer or broker, as appropriate.
     C                   IF        XIdx = 0
 
     C                   EXSR      SetupVCust
 
     C                   ENDIF
 
     C     CSEND         TAG                                                    *** CSEND  ***
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SetupVBrok - Set up valid file fields for broker              *
      *                                                               *
      *****************************************************************
 
     C     SetupVBrok    BEGSR
 
      /COPY WNCPYSRC,FFSETLV008
 
      ** Settlement type
     C                   MOVEL     SBSLT         BSLT
 
      ** Settlement account
      ** Settlement branch
 
     C     SBSLT         IFEQ      '04'
     C     SBSLT         OREQ      '06'
     C     SBSLT         OREQ      '15'
     C                   MOVE      FFCNUM        WXSLA1
     C                   MOVE      FFACOD        WXSLA2
     C                   MOVE      FFACSQ        WXSLA3
     C                   MOVE      WXSLA         BSLA
     C                   MOVE      WXSLB         BSBR
     C                   ELSE
 
     C                   MOVE      SBSLA         BSLA
 
     C     BGMBIN        IFEQ      'Y'
     C                   MOVE      SBSBR         BSBR
     C                   ELSE
     C     SBSLT         IFEQ      '05'
     C                   MOVE      WXSLB         BSBR
     C                   ELSE
     C                   MOVE      *BLANK        BSBR
     C                   END
     C                   END
 
     C                   END
 
      ** Settlement branch ID
     C                   MOVE      WXSLB         BBID                                          S0111
 
      ** For account of
     C                   MOVE      SBFAO         BFAO
 
      ** Counterparty nostro
      ** If broker customer number present, use it
 
     C*****CNUMB         IFNE      0                                                          CSD027
     C     CNUMB         IFNE      *BLANKS                                                    CSD027
     C                   MOVEL     CNUMB         BCPN
     C                   ELSE
     C                   MOVEL     SBCPN         BCPN
     C                   END
 
      /COPY WNCPYSRC,FFSETLV009
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SetupVCust - Set up valid file fields for customer            *
      *                                                               *
      *****************************************************************
 
     C     SetupVCust    BEGSR
 
      /COPY WNCPYSRC,FFSETLV010
 
      ** Settlement type
     C                   MOVEL     SCSLT         CSLT
 
      ** Settlement account
      ** Settlement branch
 
     C     SCSLT         IFEQ      '04'
     C     SCSLT         OREQ      '06'
     C     SCSLT         OREQ      '15'
     C                   MOVE      FFCNUM        WXSLA1
     C                   MOVE      FFACOD        WXSLA2
     C                   MOVE      FFACSQ        WXSLA3
     C                   MOVE      WXSLA         CSLA
     C                   MOVE      WXSLB         BRSC
     C                   ELSE
 
     C                   MOVE      SCSLA         CSLA
 
     C     BGMBIN        IFEQ      'Y'
     C                   MOVE      SBRSC         BRSC
     C                   ELSE
     C     SCSLT         IFEQ      '05'
     C                   MOVE      WXSLB         BRSC
     C                   ELSE
     C                   MOVE      *BLANK        BRSC
     C                   END
     C                   END
 
     C                   END
 
      ** Settlement branch ID
     C                   MOVE      WXSLB         CBID                                          S0111
 
      ** For account of
     C                   MOVE      SCFAO         CFAO
 
      ** Counterparty nostro
      ** If customer customer number present, use it
 
     C*****CNUMC         IFNE      *ZERO                                                      CSD027
     C     CNUMC         IFNE      *BLANKS                                                    CSD027
     C                   MOVEL     CNUMC         CCPN
     C                   ELSE
     C                   MOVEL     SCCPN         CCPN
     C                   END
 
      /COPY WNCPYSRC,FFSETLV011
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *inzsr - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
 
     C     *inzsr        BEGSR
 
     C     *entry        PLIST
      ** Parameters returned to caller
      ** -----------------------------
      ** Return code (10A, returned to caller)
     C                   PARM                    ReturnCode
      ** Field name array (<ErrArrMax> x 10A, returned to caller)
     C                   PARM                    FldNamXArr
      ** Error message ID array (<ErrArrMax> x 7A, returned to caller)
     C                   PARM                    MsgIDXArr
      ** Error message data array (<ErrArrMax> x 45A, returned to caller)
     C                   PARM                    MsgDtaXArr
      ** Field name array (<WArrMax> x 10A, returned to caller)
     C                   PARM                    FldNamWArr
      ** Warning message ID array (<WArrMax> x 7A, returned to caller)
     C                   PARM                    MsgIDWArr
      ** Warning message data array (<WArrMax> x 45A, returned to caller)
     C                   PARM                    MsgDtaWArr
      ** The valid settlements file format (data structure, from FFVSETLPD)
     C                   PARM                    FFVSETL
 
      ** Parameters received from caller
      ** -------------------------------
      ** Data structure containing broker details
     C                   PARM                    FFBSET
      ** Data structure containing customer details
     C                   PARM                    FFCSET
      ** Data structure containing broker settlement OK flags
     C                   PARM                    FFEBSET
      ** Data structure containing customer settlement OK flags
     C                   PARM                    FFECSET
      ** Customer/ Broker flag (1A, Y = Broker, N = Customer)
     C                   PARM                    CustBrokFl
      ** Branch code (3A, from transaction)
     C                   PARM                    SBRCD
      ** Portfolio reference (4A)
     C                   PARM                    SPTFR
      ** Instrument currency (3A)
     C                   PARM                    ISCY
      ** Trade date in Midas day number format (5,0P)
     C                   PARM                    TRSD
      ** Broker Code (6S,0 from TRANSD)
     C                   PARM                    BOCO
      ** Customer Code (6S,0 from TRANSD)
     C                   PARM                    CUSC
      ** Branch internal customer number (6A, from SDBRCHPD)
     C                   PARM                    BICN
      ** Current trading date
     C                   PARM                    CTDATE
      ** Bank Details ICD
     C                   PARM                    SDBANK
      ** General Ledger ICD
     C                   PARM                    SDGELR
      ** Midas Modules ICD
     C                   PARM                    SDMMOD
      ** Trading ICD
     C                   PARM                    SDTRAD
      ** Portfolio Management ICD
     C                   PARM                    SDPORT
      ** Retail ICD
     C                   PARM                    SDRETL
      ** CFF007 Enhancement                                                                   CFF007
     C                   PARM                    CFF007                                       CFF007
      ** PB customer indicator - Broker                                                       CFF007
     C                   PARM                    PPBBFLG                                      CFF007
      ** PB customer indicator - Customer                                                     CFF007
     C                   PARM                    PPBCFLG                                      CFF007
      ** Collaterals Processing enhancement                                                   CGL014
     C                   PARM                    CGL014                                       CGL014
 
 
      ** Access the (old-fashioned) FF ICD
     C                   READ      TABTB80F                               99
 
      ** Key lists
      ** ---------
      **   Set-up key to customer master file
      **   LF/CLINT
     C     KCLINT        KLIST
     C                   KFLD                    KCBCD
     C                   KFLD                    KRCDT
 
      ** Key List for LF/ACCNT (Accounts): FFACTK
     C     FFACTK        KLIST
      ** Customer Number
     C                   KFLD                    FFCNUM
      ** Currency
     C                   KFLD                    FFCCY
      ** Account Code
     C                   KFLD                    FFACOD
      ** Account Sequence
     C                   KFLD                    FFACSQ
      ** Branch Code
     C                   KFLD                    FFBRCB
 
     C     KEYC          KLIST
     C**********         KFLD                    KYCNUM            6 0                        CSD027
     C                   KFLD                    KYCNUM            6                          CSD027
     C                   KFLD                    KYCCY             3
     C**********         KFLD                    KYACOD            4 0                        CGL029
     C                   KFLD                    KYACOD                                       CGL029
     C                   KFLD                    KYACSQ            2 0
     C                   KFLD                    KYBRCA            3
 
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY sets the values of program, module and
      ** procedure names for database error processing.
     C/COPY ZACPYSRC,DBFIELDS
      **--------------------------------------------------------------------------------------------
 
      *  Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,FFSETLV012
 
     C                   ENDSR
 
      *****************************************************************                       CGL029
      /EJECT                                                                                  CGL029
      *****************************************************************                       CGL029
      *                                                               *                       CGL029
      *  SRACOD - Gets Account Codes via AOACODR0.                    *                       CGL029
      *                                                               *                       CGL029
      *****************************************************************                       CGL029
     C     SRACOD        BEGSR                                                                CGL029
      *                                                                                       CGL029
     C                   MOVE      FFACOD        PACCD                                        CGL029
      *                                                                                       CGL029
     C                   CALL      'AOACODR0'                                                 CGL029
     C                   PARM      *BLANKS       PRTCD                                        CGL029
     C                   PARM      '*VERIFY'     POPTN                                        CGL029
     C                   PARM                    PACCD                                        CGL029
     C     SDACOD        PARM      SDACOD        DSSDY                                        CGL029
      *                                                                                       CGL029
     C                   EVAL      *IN70 = *ON                                                CGL029
     C                   IF        PRTCD = *BLANKS                                            CGL029
     C                   EVAL      *IN70 = *OFF                                               CGL029
     C                   ENDIF                                                                CGL029
      *                                                                                       CGL029
     C                   ENDSR                                                                CGL029
      *****************************************************************
      /EJECT
      *****************************************************************
      **--------------------------------------------------------------------------------------------
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILE
      **--------------------------------------------------------------------------------------------
      ********************************************************************
      /EJECT
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
