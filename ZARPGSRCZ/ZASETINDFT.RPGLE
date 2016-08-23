     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas ZA Settle instructions defaulting')              *
      *****************************************************************
      *                                                               *
      *  Midas - MM Dealer Module                                     *
      *                                                               *
      *  ZASETINDFT - SETTLEMENT INSTRUCTIONS DEFAULTING              *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. MD028079           Date 25Nov14               *
      *  Prev Amend No. CDL094             Date 01Sep14               *
      *                 MD028280A          Date 19Aug14               *
      *                 MD028280           Date 19Aug14               *
      *                 CSD095             Date 08Apr14               *
      *                 AR1001007          Date 10Jul12               *
      *                 CSW212             Date 03May12               *
      *                 AR787620           Date 10Jun11               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CLE031             Date 26Apr05               *
      *                 BUG7512            Date 15Jun05               *
      *                 BUG7013R           Date 01Jun05               *
      *                 BUG7032            Date 06May05               *
      *                 CSW037A            Date 02May05               *
      *                 BUG6715            Date 20Apr05               *
      *                 CSD025             Date 11Jan05               *
      *                 CDL031             Date 24Nov04               *
      *                 CDL025             Date 02Nov04               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      *                 CDL018             Date 03Feb04               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAP068             Date 01Mar02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CDL008             Date 02May00               *
      *                 182558             DATE 11Aug00               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CSW097             Date 02Dec99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 156955             Date 11Mar99               *
      *                 CAP003             Date 03Jun98               *
      *                 CAP002  *CREATE    Date 01Nov97               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD028079 - ISDA Rules Version defaulted for Non-ISDA type    *
      *  CDL094 - Enhance  Receive Settlement Instructions            *
      *  MD028280A - CUS-CCY-AT transactions does not default         *
      *            - Clear BYBRCA and BYSTYP after an unsuccesful     *
      *              chain.                                           *
      *  MD028280 - MM Deal subtype's SSI was not defaulted to a      *
      *             take-on MM deal with the same CCY and MM subtype. *
      *           - initialize BYBRCA and BYSTYP when SSIBranch = 'N' *
      *  CSD095 - Allow Deal Sub-Type and Branch for MM and FX SSIs   *
      *  AR1001007 - Extended Settlement details for 'OP' deal type   *
      *              do not default in FXDN                           *
      *  CSW212 - SWIFT 2012 Changes                                  *
      *  AR787620 - Hooks Incorporation                               *
      *             WNCPYSRC,ZAH00001                                 *
      *             WNCPYSRC,ZAH00002                                 *
      *             WNCPYSRC,ZAH00003                                 *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE031 - Lending Enhancements - Settlement Currency          *
      *  BUG7512 - Don't hard code CL here otherwise it               *
      *            always defaults CL SSI's even when inapproriate    *
      *  BUG7013R- CLS settlement details not defaulting even though  *
      *            associated cuustomer CLS flag = Y                  *
      *            Amendment to BUG6555                               *
      *  BUG7032 - Do extended settlement defaulting for 'NT' type.   *
      *            Borrow unused BQAGVC for Buy/Sell Net inds.        *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  BUG6715- Incorrect defaulting for Caps,Collars and Floors    *
      *  CSD025 - Customer De-Activation                              *
      *  CDL031 - Effective Date on Extended SSI                      *
      *  CDL025 - FX Netting Payment Generation                       *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CDL018 - Multiple Settlement Accounts on Loans/Deposit       *
      *           (Recompile)                                         *
      *  CAP068 - Enable Lending APIs to call this instead of SD2410  *
      *  CDL008 - Continuous Linked Settlement                        *
      *  182558 - Should check for 'DEAM' as well as 'LDNI'.          *
      *  CSW097 - Swift 97 Changes for MT340s and MT360s              *
      *  156955 - Default Euro extended instructions when required.   *
      *  CAP003 - Phase II of Midas API conversions                   *
      *  CAP002 - Conversion of Midas inputs to modular API structure *
      *                                                               *
      *****************************************************************
     FSDEXSTL1  IF   E           K DISK
     F/COPY WNCPYSRC,ZAH00037
 
     D/COPY ZACPYSRC,STD_D_SPEC                                                 CDL008
     D/COPY ZACPYSRC,PSDS                                                       CDL008
                                                                                CDL008
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      * DATA STRUCTURE FOR CUSTOMER DETAILS
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      * SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE
     D DSLDY         E DS                  EXTNAME(DSLDY)                                   BUG7013R
      ** Third DS for access programs, very long data structure                             BUG7013R
 
     D ##RECF        E DS                  EXTNAME(SDESFRPD)
      * FILE RECEIVE INSTRUCTIONS
 
     D ##PAYF        E DS                  EXTNAME(SDESFPPD)
      * FILE PAYMENT INSTRUCTIONS
 
     D ##FRIF        E DS                  EXTNAME(SDESFFPD)
      **FILE*FRA/IRS*INSTRUCTIONS**************************************                       CSW212
      * FILE EXTENDED SETTLEMENT INSTRUCTIONS                                                 CSW212
 
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                    CDL008
      ** External DS for SAR Details                                            CDL008
                                                                                CDL008
     D DSFDY         E DS                  EXTNAME(DSFDY)                       CDL008
      ** First DS for Access Programs, Short Data Structure                     CDL008
                                                                                CDL008
      * Buy Net and Sell Net Indicators, passed in through unused parameter.                 BUG7032
     D BQAGVC          DS                                                                    BUG7032
     D  ##BUY                  1      1                                                      BUG7032
     D  ##SEL                  2      2                                                      BUG7032
                                                                                              CSD095
      ** Constant to hold input parameter for AOSVALR0                                        CSD095
                                                                                              CSD095
     D SSIBranch       C                   Const('SSIBranch')                                 CSD095
     D SSIDealStype    C                   Const('SSIDealSubtype_Trans')                      CSD095
     D SSIDftSecChk    C                   Const('SSIDefault_Sec_Check')                      CSD095
                                                                                              CSD095
      ** Parameters for AOSVALR0 callR0 call                                                  CSD095
                                                                                              CSD095
     D PRtnCode        S              7A                                                      CSD095
     D PSysVal01       S             20A                                                      CSD095
     D PCurSet01       S            200A                                                      CSD095
     D PSysVal02       S             20A                                                      CSD095
     D PCurSet02       S            200A                                                      CSD095
     D PSysVal03       S             20A                                                      CSD095
     D PCurSet03       S            200A                                                      CSD095
     D PSysVal04       S             20A                                                      CSD095
     D PCurSet04       S            200A                                                      CSD095
     D PSysVal05       S             20A                                                      CSD095
     D PCurSet05       S            200A                                                      CSD095
     D PSysVal06       S             20A                                                      CSD095
     D PCurSet06       S            200A                                                      CSD095
     D PSysVal07       S             20A                                                      CSD095
     D PCurSet07       S            200A                                                      CSD095
     D PSysVal08       S             20A                                                      CSD095
     D PCurSet08       S            200A                                                      CSD095
     D PSysVal09       S             20A                                                      CSD095
     D PCurSet09       S            200A                                                      CSD095
     D PSysVal10       S             20A                                                      CSD095
     D PCurSet10       S            200A                                                      CSD095
                                                                                              CSD095
      ** Work Variables                                                                       CSD095
                                                                                              CSD095
     D WUSEBR          S              1A                                                      CSD095
     D WUSEST          S             20A                                                      CSD095
     D WSECHK          S              1A                                                      CSD095
     D WFOUND          S              1A                                                      CSD095
     D ##BRCA          S              3A                                                      CSD095
     D ##STYP          S              2A                                                      CSD095
                                                                                              CSD095
      /EJECT
     C*****************************************************************
                                                                                              CLE031
      ** Zeroise Exchange Rate to prevent decimal data error                                  CLE031
                                                                                              CLE031
     C                   EVAL      FLPEXR = *Zeros                                            CLE031
     C                   EVAL      FLREXR = *Zeros                                            CLE031
      *
      ** Retrieve customer number
      *
     C                   EXSR      RTVCST
      *
      ** INITIALIZE ALL FILE INSTRUCTIONS
      *
     C                   EXSR      INITFL
      *
      ** DEFAULT STANDARD SETTLEMENT INSTRUCTIONS
      *
     C                   EXSR      DEFSSI
     C/COPY WNCPYSRC,ZAH00038
      *
      ** RETURN
      *
     C                   RETURN
     C*****************************************************************
      /EJECT
     C*****************************************************************
     C*                                                               *
     C* DEFSSI - DEFAULT STANDARD SETTLEMENT INSTRUCTIONS             *
     C*                                                               *
     C*****************************************************************
     C*
     C     DEFSSI        BEGSR
     C*
     C*  Calling program is FX Deal Input
     C*
     C     ##CALP        IFEQ      'FXDL'
     C*
     C*  Federal Funds ?
     C*
     C     ##FFIN        IFEQ      'Y'
     C                   MOVEL     'FF'          ##TRTY            2
     C                   ELSE
     C     ##DTYP        IFEQ      'OP'                                                    AR1001007
     C                   MOVEL     'OP'          ##TRTY                                    AR1001007
     C                   ELSE                                                              AR1001007
     C/COPY WNCPYSRC,ZAH00001
     C                   MOVEL     'FX'          ##TRTY
     C                   ENDIF                                                             AR1001007
     C/COPY WNCPYSRC,ZAH00002
     C                   END
      *                                                                         CDL008
      ** CLS Settlement ?                                                       CDL008
      *                                                                         CDL008
     C     CDL008        IFEQ      'Y'                                          CDL008
     C     ##DTYP        ANDEQ     'CL'                                         CDL008
     C                   MOVEL     'CL'          ##TRTY                         CDL008
     C                   ENDIF                                                  CDL008
      *                                                                         CDL008
     C                   END
     C*
     C*  Calling program is Loan/Deposit Deal Input
     C*
     C     ##CALP        IFEQ      'LDNI'
     C     ##CALP        OREQ      'DEAM'                                                     182558
     C*
     C*  Federal Funds ?
     C*
     C     ##FFIN        IFEQ      'Y'
     C                   MOVEL     'MF'          ##TRTY
     C                   ELSE
     C                   MOVEL     'MM'          ##TRTY
     C                   END
     C                   END
     C*
     C*  Calling program is NA's Bought Deal Input
     C*
     C     ##CALP        IFEQ      'NASP'
     C*
     C*  Federal Funds ?
     C*
     C     ##FFIN        IFEQ      'Y'
     C                   MOVEL     'FP'          ##TRTY
     C                   ELSE
     C                   MOVEL     'NP'          ##TRTY
     C                   END
     C                   END
     C*
     C*  Calling program is NA's Sold Deal Input
     C*
     C     ##CALP        IFEQ      'NASS'
     C*
     C*  Federal Funds ?
     C*
     C     ##FFIN        IFEQ      'Y'
     C                   MOVEL     'FS'          ##TRTY
     C                   ELSE
     C                   MOVEL     'NS'          ##TRTY
     C                   END
     C                   END
     C*
     C*  Calling program is FRA or IRS Input
     C*
     C*****##CALP        IFEQ      'FRAS'                                       CAP003
     C     ##CALP        IFEQ      'FRA '                                       CAP003
     C     ##CALP        OREQ      'SIRS'                                       CAP003
     C     ##CALP        OREQ      'CIRS'                                       CAP003
     C     ##CALP        OREQ      'CACF'                                       BUG6715
     C                   MOVEL     ##DTYP        ##TRTY
     C                   ENDIF
     C*                                                                                       CAP068
     C*  Calling program is Lending Input                                                     CAP068
     C*                                                                                       CAP068
     C     ##CALP        IFEQ      'LEND'                                                     CAP068
     C                   MOVEL     'LE'          ##TRTY                                       CAP068
     C                   END                                                                  CAP068
                                                                                              CSD095
      ** Populate Subtype and Branch based on SSIs system values                              CSD095
                                                                                              CSD095
     C                   EVAL      ##BRCA = *BLANKS                                           CSD095
     C                   EVAL      ##STYP = *BLANKS                                           CSD095
                                                                                              CSD095
     C                   IF        WUSEBR = 'Y'                                               CSD095
     C                   EVAL      ##BRCA = BQBRCA                                            CSD095
     C                   ENDIF                                                                CSD095
                                                                                              CSD095
     C                   IF        WUSEST <> *BLANKS                                          CSD095
     C                   EVAL      ##STYP = BQSTYP                                            CSD095
     C                   ENDIF                                                                CSD095
      *
      *  Load Payment and Receipt instructions for Prime currency
      *
     C                   EXSR      PRIMSI
      *
      *  IF FX or a Cross Currency Interest Rate Swap
      *  Overwrite Receipt instructions with Buy currency's
      *  receipt instructions
      *
     C     ##CALP        IFEQ      'FXDL'
     C     ##DTYP        OREQ      'RX'
     C                   EXSR      BYCRSI
     C                   END
      *
     C                   ENDSR
     C*****************************************************************
      /EJECT
     C*****************************************************************
     C*                                                               *
     C* PRIMI - Retrieve Prime Currency Pay/Receive                   *
     C*         Standard Settlement Instructions                      *
     C*         (for FX this will be the Sell ccy)                    *
     C*                                                               *
     C*****************************************************************
     C     PRIMSI        BEGSR
      *
      *  Define Keylist for Extended Settlement Instructions file
      *
     C     EXSTK         KLIST
     C                   KFLD                    BYCYCD
     C                   KFLD                    BYCUST
     C                   KFLD                    BYTRTY
     C                   KFLD                    BYBRCA                                       CSD095
     C                   KFLD                    BYSTYP                                       CSD095
      *
     C                   MOVEL     ##PCCY        BYCYCD
     C                   MOVEL     ##CUST        BYCUST
     C                   MOVEL     ##TRTY        BYTRTY
     C                   MOVEL     *BLANKS       BYBRCA                                       CSD095
     C                   MOVEL     *BLANKS       BYSTYP                                       CSD095
                                                                                              CSD095
     C                   MOVEL     'N'           WFOUND                                       CSD095
     C                   IF        WUSEBR = 'Y' and WUSEST <> *BLANKS                         CSD095
                                                                                              CSD095
     C                   MOVEL     ##BRCA        BYBRCA                                       CSD095
     C                   MOVEL     ##STYP        BYSTYP                                       CSD095
     C     EXSTK         CHAIN     SDEXSTL1                           99                      CSD095
                                                                                              CSD095
     C                   IF        *IN99 = '0'                                                CSD095
     C                   MOVEL     'Y'           WFOUND                                       CSD095
     C                   ENDIF                                                                CSD095
                                                                                              CSD095
     C                   IF        *IN99 = '1'                                                CSD095
                                                                                              CSD095
     C                   IF        WSECHK = 'B'                                               CSD095
                                                                                              CSD095
     C                   MOVEL     *BLANKS       BYSTYP                                       CSD095
     C     EXSTK         CHAIN     SDEXSTL1                           99                      CSD095
     C                   IF        *IN99 = '1'                                                CSD095
     C                   MOVEL     ##STYP        BYSTYP                                       CSD095
     C                   MOVEL     *BLANKS       BYBRCA                                       CSD095
     C     EXSTK         CHAIN     SDEXSTL1                           99                      CSD095
     C                   ENDIF                                                                CSD095
                                                                                              CSD095
     C                   ELSEIF    WSECHK = 'S'                                               CSD095
                                                                                              CSD095
     C                   MOVEL     *BLANKS       BYBRCA                                       CSD095
     C     EXSTK         CHAIN     SDEXSTL1                           99                      CSD095
     C                   IF        *IN99 = '1'                                                CSD095
     C                   MOVEL     ##BRCA        BYBRCA                                       CSD095
     C                   MOVEL     *BLANKS       BYSTYP                                       CSD095
     C     EXSTK         CHAIN     SDEXSTL1                           99                      CSD095
     C                   ENDIF                                                                CSD095
                                                                                              CSD095
     C                   ENDIF                                                                CSD095
                                                                                              CSD095
     C                   IF        *IN99 = '0'                                                CSD095
     C                   MOVEL     'Y'           WFOUND                                       CSD095
     C                   ENDIF                                                                CSD095
                                                                                              CSD095
     C                   IF        *IN99 = '1'                                                CSD095
     C                   MOVEL     *BLANKS       BYBRCA                                       CSD095
     C                   MOVEL     *BLANKS       BYSTYP                                       CSD095
     C                   ENDIF                                                                CSD095
                                                                                              CSD095
     C                   ENDIF                                                                CSD095
                                                                                              CSD095
     C                   ELSE                                                                 CSD095
                                                                                              CSD095
     C                   IF        WUSEBR = 'Y' and WUSEST = *BLANKS                          CSD095
     C                   MOVEL     *BLANKS       BYSTYP                                       CSD095
     C                   MOVEL     ##BRCA        BYBRCA                                     MD028280
     C     EXSTK         CHAIN     SDEXSTL1                           99                      CSD095
     C                   IF        *IN99 = '0'                                                CSD095
     C                   MOVEL     'Y'           WFOUND                                       CSD095
     C                   ELSE                                                              MD028280A
     C                   MOVEL     *BLANKS       BYBRCA                                    MD028280A
     C                   ENDIF                                                                CSD095
                                                                                           MD028280A
     C                   ELSEIF    WUSEBR = 'N' and WUSEST <> *BLANKS                         CSD095
     C                   MOVEL     *BLANKS       BYBRCA                                       CSD095
     C                   MOVEL     ##STYP        BYSTYP                                     MD028280
     C     EXSTK         CHAIN     SDEXSTL1                           99                      CSD095
     C                   IF        *IN99 = '0'                                                CSD095
     C                   MOVEL     'Y'           WFOUND                                       CSD095
     C                   ELSE                                                              MD028280A
     C                   MOVEL     *BLANKS       BYSTYP                                    MD028280A
     C                   ENDIF                                                                CSD095
                                                                                           MD028280A
     C                   ELSE                                                                 CSD095
     C                   MOVEL     *BLANKS       BYSTYP                                       CSD095
     C                   MOVEL     *BLANKS       BYBRCA                                       CSD095
     C                   ENDIF                                                                CSD095
                                                                                              CSD095
     C                   ENDIF                                                                CSD095
      *                                                                                      BUG7032
      * If CDL025 on first check for net settlement instructions.                            BUG7032
      *                                                                                      BUG7032
     C                   If        CDL025 = 'Y' and ##CALP = 'FXDL' and                      BUG7032
     C                             ##SEL = 'Y'                                               BUG7032
     C                   Eval      BYTRTY = 'NT'                                             BUG7032
     C     EXSTK         CHAIN     SDEXSTL1                           99                     BUG7032
      * Reset BYTRTY for standard deal check below, if this chain was unsuccessful.          BUG7032
     C                   Eval      BYTRTY = ##TRTY                                           BUG7032
     C                   Endif                                                               BUG7032
      *
      * GET EXTENDED SETTLEMENT INSTRUCTIONS FOR DEAL TYPE
      *
     C                   If        CDL025 = 'Y' and ##CALP = 'FXDL' and                      BUG7032
     C                             ##SEL = 'Y' and *IN99 = '1' or                            BUG7032
     C                             CDL025 <> 'Y' or ##CALP <> 'FXDL' or                      BUG7032
     C                             ##SEL <> 'Y'                                              BUG7032
     C
     C                   IF        WFOUND = 'N'                                               CSD095
                                                                                              CSD095
     C     EXSTK         CHAIN     SDEXSTL1                           99
      *
     C     CDL031        IFEQ      'Y'                                          CDL031
     C     *IN99         ANDEQ     '1'                                          CDL031
                                                                                CDL031
     C     ##TRTY        IFEQ      'RS'                                         CDL031
     C     ##TRTY        OREQ      'RX'                                         CDL031
     C     ##TRTY        OREQ      'FR'                                         CDL031
     C     ##TRTY        OREQ      'RR'                                         CDL031
     C     ##TRTY        OREQ      'RP'                                         CDL031
     C     ##TRTY        OREQ      'RF'                                         CDL031
     C                   MOVEL     'DV'          BYTRTY                         CDL031
     C     EXSTK         CHAIN     SDEXSTL1                           99        CDL031
     C                   ENDIF                                                  CDL031
     C                   ENDIF                                                  CDL031
     C                   ENDIF                                                                CSD095
     C                   ENDIF                                                               BUG7032
 
      **********                                                                CDL025       BUG7032
     C**********         If        CDL025 = 'Y'                                 CDL025       BUG7032
      **For*FX*Deals*if*Type*'NT'*and*not*found*try*'FX'*instructions           CDL025       BUG7032
     C**********         If        ##CALP = 'FXDL' and ##TRTY ='NT' and         CDL025       BUG7032
     C**********                   *In99 = *On                                  CDL025       BUG7032
     C**********         Eval      BYTRTY = 'FX'                                CDL025       BUG7032
     C*****EXSTK         Chain     SDEXSTL1                           99        CDL025       BUG7032
     C**********         EndIf                                                  CDL025       BUG7032
     C**********         EndIf                                                  CDL025       BUG7032
      *                                                                         CDL025       BUG7032
      * IF NONE, GET INSTRUCTIONS FOR DEAL TYPE = 'ALL TYPES' (AT).
      *
     C     *IN99         IFEQ      '1'
      *                                                                         CDL008
     C     CDL008        IFEQ      'Y'                                          CDL008
     C     ##CALP        ANDEQ     'FXDL'                                       CDL008
     C     ##TRTY        ANDEQ     'CL'                                         CDL008
     C                   ELSE                                                   CDL008
      *                                                                         CDL008
     C                   MOVEL     'AT'          BYTRTY
     C     EXSTK         CHAIN     SDEXSTL1                           99
     C                   ENDIF                                                  CDL008
      *                                                                         CDL008
     C                   END
      *                                                                         156955
      * IF PRESENT, AND SETTLEMENT CURRENCY IS DEFINED                          156955
      * ACCESS SETTLEMENT CURRENCY INSTRUCTIONS                                 156955
      *                                                                         156955
     C     *IN99         IFEQ      '0'                                          156955
     C     BYSTCY        ANDNE     *BLANK                                       156955
     C                   MOVEL     BYIERI        ##IERI            1            156955
     C                   MOVEL     BYSTCY        BYCYCD                         156955
     C     EXSTK         CHAIN     SDEXSTL1                           97        156955
     C     *IN97         IFEQ      '1'                                          156955
     C                   MOVEL     ##PCCY        BYCYCD                         156955
     C                   ENDIF                                                  156955
     C                   ENDIF                                                  156955
      *
      * IF PRESENT, DEFAULT INSTRUCTIONS
      *
     C     *IN99         IFEQ      '0'
      *
      * DEFAULT RECEIVE INSTRUCTIONS
      *
     C                   EXSR      DEFREC
      *
      * DEFAULT PAYMENT INSTRUCTIONS
      * (EXCEPT FOR NA SOLD WHERE PAYMENT INSTRUCTIONS SHOULD BE BLANK)
      *
     C     ##TRTY        IFNE      'NS'
     C                   EXSR      DEFPAY
     C                   END
      *
      **DEFAULT*FRA*&*IRS*INSTRUCTIONS*********************************                       CSW212
      * DEFAULT EXTENDED SETTLEMENT INSTRUCTIONS                                              CSW212
      *
     C     ##TRTY        IFEQ      'FR'
     C     ##TRTY        OREQ      'RS'
     C     ##TRTY        OREQ      'RX'
     C     ##CALP        OREQ      'FXDL'                                                     CSW212
     C     CSW212        ANDEQ     'Y'                                                        CSW212
     C                   EXSR      DEFFRI
     C                   END
     C                   END
     C*
     C                   ENDSR
     C*****************************************************************
      /EJECT
     C*****************************************************************
     C*                                                               *
     C* BYCRSI -  Retrieve Buy Currency Receipt                       *
     C*           Standard Settlement Instructions                    *
     C*           (only if deal involves foreign exchange)            *
     C*                                                               *
     C*****************************************************************
     C*
     C     BYCRSI        BEGSR
     C*
     C                   MOVEL     ##RCCY        BYCYCD
     C                   MOVEL     ##CUST        BYCUST
     C                   MOVEL     ##TRTY        BYTRTY
     C                   MOVEL     *BLANKS       BYBRCA                                       CSD095
     C                   MOVEL     *BLANKS       BYSTYP                                       CSD095
                                                                                              CSD095
     C                   MOVEL     'N'           WFOUND                                       CSD095
     C                   IF        WUSEBR = 'Y' and WUSEST <> *BLANKS                         CSD095
                                                                                              CSD095
     C                   MOVEL     ##BRCA        BYBRCA                                       CSD095
     C                   MOVEL     ##STYP        BYSTYP                                       CSD095
     C     EXSTK         CHAIN     SDEXSTL1                           99                      CSD095
                                                                                              CSD095
     C                   IF        *IN99 = '0'                                                CSD095
     C                   MOVEL     'Y'           WFOUND                                       CSD095
     C                   ENDIF                                                                CSD095
                                                                                              CSD095
     C                   IF        *IN99 = '1'                                                CSD095
                                                                                              CSD095
     C                   IF        WSECHK = 'B'                                               CSD095
                                                                                              CSD095
     C                   MOVEL     *BLANKS       BYSTYP                                       CSD095
     C     EXSTK         CHAIN     SDEXSTL1                           99                      CSD095
     C                   IF        *IN99 = '1'                                                CSD095
     C                   MOVEL     ##STYP        BYSTYP                                       CSD095
     C                   MOVEL     *BLANKS       BYBRCA                                       CSD095
     C     EXSTK         CHAIN     SDEXSTL1                           99                      CSD095
     C                   ENDIF                                                                CSD095
                                                                                              CSD095
     C                   ELSEIF    WSECHK = 'S'                                               CSD095
                                                                                              CSD095
     C                   MOVEL     *BLANKS       BYBRCA                                       CSD095
     C     EXSTK         CHAIN     SDEXSTL1                           99                      CSD095
     C                   IF        *IN99 = '1'                                                CSD095
     C                   MOVEL     ##BRCA        BYBRCA                                       CSD095
     C                   MOVEL     *BLANKS       BYSTYP                                       CSD095
     C     EXSTK         CHAIN     SDEXSTL1                           99                      CSD095
     C                   ENDIF                                                                CSD095
                                                                                              CSD095
     C                   ENDIF                                                                CSD095
                                                                                              CSD095
     C                   IF        *IN99 = '0'                                                CSD095
     C                   MOVEL     'Y'           WFOUND                                       CSD095
     C                   ENDIF                                                                CSD095
                                                                                              CSD095
     C                   IF        *IN99 = '1'                                                CSD095
     C                   MOVEL     *BLANKS       BYBRCA                                       CSD095
     C                   MOVEL     *BLANKS       BYSTYP                                       CSD095
     C                   ENDIF                                                                CSD095
                                                                                              CSD095
     C                   ENDIF                                                                CSD095
                                                                                              CSD095
     C                   ELSE                                                                 CSD095
                                                                                              CSD095
     C                   IF        WUSEBR = 'Y' and WUSEST = *BLANKS                          CSD095
     C                   MOVEL     *BLANKS       BYSTYP                                       CSD095
     C                   MOVEL     ##BRCA        BYBRCA                                    MD028280A
     C     EXSTK         CHAIN     SDEXSTL1                           99                      CSD095
     C                   IF        *IN99 = '0'                                                CSD095
     C                   MOVEL     'Y'           WFOUND                                       CSD095
     C                   ELSE                                                              MD028280A
     C                   MOVEL     *BLANKS       BYBRCA                                    MD028280A
     C                   ENDIF                                                                CSD095
                                                                                           MD028280A
     C                   ELSEIF    WUSEBR = 'N' and WUSEST <> *BLANKS                         CSD095
     C                   MOVEL     *BLANKS       BYBRCA                                       CSD095
     C                   MOVEL     ##STYP        BYSTYP                                    MD028280A
     C     EXSTK         CHAIN     SDEXSTL1                           99                      CSD095
     C                   IF        *IN99 = '0'                                                CSD095
     C                   MOVEL     'Y'           WFOUND                                       CSD095
     C                   ELSE                                                              MD028280A
     C                   MOVEL     *BLANKS       BYSTYP                                    MD028280A
     C                   ENDIF                                                                CSD095
                                                                                           MD028280A
     C                   ELSE                                                                 CSD095
     C                   MOVEL     *BLANKS       BYSTYP                                       CSD095
     C                   MOVEL     *BLANKS       BYBRCA                                       CSD095
     C                   ENDIF                                                                CSD095
                                                                                              CSD095
     C                   ENDIF                                                                CSD095
      *                                                                                      BUG7032
      * If CDL025 on first check for net settlement instructions.                            BUG7032
      *                                                                                      BUG7032
     C                   If        CDL025 = 'Y' and ##CALP = 'FXDL' and                      BUG7032
     C                             ##BUY = 'Y'                                               BUG7032
     C                   Eval      BYTRTY = 'NT'                                             BUG7032
     C     EXSTK         CHAIN     SDEXSTL1                           99                     BUG7032
      * Reset BYTRTY for standard deal check below, if this chain was unsuccessful.          BUG7032
     C                   Eval      BYTRTY = ##TRTY                                           BUG7032
     C                   Endif                                                               BUG7032
      *
      * GET EXTENDED SETTLEMENT INSTRUCTIONS FOR DEAL TYPE
      *
     C                   If        CDL025 = 'Y' and ##CALP = 'FXDL' and                      BUG7032
     C                             ##BUY = 'Y' and *IN99 = '1' or                            BUG7032
     C                             CDL025 <> 'Y' or ##CALP <> 'FXDL' or                      BUG7032
     C                             ##BUY <> 'Y'                                              BUG7032
      *                                                                                      BUG7032
     C                   IF        WFOUND = 'N'                                               CSD095
                                                                                              CSD095
     C     EXSTK         CHAIN     SDEXSTL1                           99
      *
     C     CDL031        IFEQ      'Y'                                          CDL031
     C     *IN99         ANDEQ     '1'                                          CDL031
                                                                                CDL031
     C     ##TRTY        IFEQ      'RS'                                         CDL031
     C     ##TRTY        OREQ      'RX'                                         CDL031
     C     ##TRTY        OREQ      'FR'                                         CDL031
     C     ##TRTY        OREQ      'RR'                                         CDL031
     C     ##TRTY        OREQ      'RP'                                         CDL031
     C     ##TRTY        OREQ      'RF'                                         CDL031
     C                   MOVEL     'DV'          BYTRTY                         CDL031
     C     EXSTK         CHAIN     SDEXSTL1                           99        CDL031
     C                   ENDIF                                                  CDL031
     C                   ENDIF                                                  CDL031
     C                   ENDIF                                                                CSD095
     C                   ENDIF                                                               BUG7032
 
      **********                                                                CDL025       BUG7032
     C**********         If        CDL025 = 'Y'                                 CDL025       BUG7032
      **For*FX*Deals*if*Type*'NT'*and*not*found*try*'FX'*instructions           CDL025       BUG7032
     C**********         If        ##CALP = 'FXDL' and ##TRTY ='NT' and         CDL025       BUG7032
     C**********                   *In99 = *On                                  CDL025       BUG7032
     C**********         Eval      BYTRTY = 'FX'                                CDL025       BUG7032
     C*****EXSTK         Chain     SDEXSTL1                           99        CDL025       BUG7032
     C**********         EndIf                                                  CDL025       BUG7032
     C**********         EndIf                                                  CDL025       BUG7032
      *
      * IF NONE, GET INSTRUCTIONS FOR DEAL TYPE = 'ALL TYPES' (AT).
      *
     C     *IN99         IFEQ      '1'
      *                                                                         CDL008
     C     CDL008        IFEQ      'Y'                                          CDL008
     C     ##CALP        ANDEQ     'FXDL'                                       CDL008
     C     ##TRTY        ANDEQ     'CL'                                         CDL008
     C                   ELSE                                                   CDL008
      *                                                                         CDL008
     C                   MOVEL     'AT'          BYTRTY
     C     EXSTK         CHAIN     SDEXSTL1                           99
     C                   ENDIF                                                  CDL008
      *                                                                         CDL008
     C                   END
      *                                                                         156955
      * IF PRESENT, AND SETTLEMENT CURRENCY IS DEFINED                          156955
      * ACCESS SETTLEMENT CURRENCY INSTRUCTIONS                                 156955
      *                                                                         156955
     C     *IN99         IFEQ      '0'                                          156955
     C     BYSTCY        ANDNE     *BLANK                                       156955
     C                   MOVEL     BYSTCY        BYCYCD                         156955
     C     EXSTK         CHAIN     SDEXSTL1                           97        156955
     C     *IN97         IFEQ      '1'                                          156955
     C                   MOVEL     ##RCCY        BYCYCD                         156955
     C                   ENDIF                                                  156955
     C                   ENDIF                                                  156955
      *
      * IF PRESENT, DEFAULT INSTRUCTIONS
      *
     C     *IN99         IFEQ      '0'
      *
      * DEFAULT RECEIVE INSTRUCTIONS
      *
     C                   EXSR      DEFREC
      *
      * else if no instructions for Buy Currency, set fields to
      * blanks so no default to Sell Currency values
      *
     C                   ELSE
     C                   CLEAR                   ##RECF
     C                   END
     C*
     C                   ENDSR
     C*****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * DEFREC - DEFAULT RECEIVE INSTRUCTIONS                         *
      *                                                               *
      *****************************************************************
     C     DEFREC        BEGSR
      *
     C                   MOVEL     BYRSTY        FLRSTM
     C                   MOVEL     BYRONO        FLRONS
      *
     C                   MOVEL     BYRIBN        FLRIBN
     C                   MOVEL     BYRIBL        FLRIBA
     C                   MOVEL     BYROBN        FLROBN
     C                   MOVEL     BYROCS        FLROCN
      *
     C                   MOVEL     BYORBR        FLROBR
      *                                                                         156955
      * IF THE CURRENCY OF THE INSTRUCTIONS IS NOT THE RECEIVE CURRENCY         156955
      * SET THE RECEIVE SETTLEMENT CURRENCY TO THAT CURRENCY                    156955
      *                                                                         156955
     C     BYCYCD        IFNE      ##RCCY                                       156955
     C     ##RCCY        ANDNE     *BLANK                                       156955
     C                   MOVEL     BYCYCD        FLRSCY                         156955
     C                   ELSE                                                   156955
     C                   MOVEL     *BLANK        FLRSCY                         156955
     C                   ENDIF                                                  156955
     C                   Z-ADD     *ZEROS        FLREXR                                       CLE031
     C                   MOVEL     *BLANKS       FLREXI                                       CLE031
      *
      * Receive Bank to Bank Information                                                      CDL094
     C                   MOVEL     *BLANKS       FLRBB1                                       CDL094
     C                   MOVEL     *BLANKS       FLRBB2                                       CDL094
     C                   MOVEL     *BLANKS       FLRBB3                                       CDL094
     C                   MOVEL     *BLANKS       FLRBB4                                       CDL094
     C                   MOVEL     *BLANKS       FLRBB5                                       CDL094
     C                   MOVEL     *BLANKS       FLRBB6                                       CDL094
     C                   MOVEL     BYRBB1        FLRBB1                                       CDL094
     C                   MOVEL     BYRBB2        FLRBB2                                       CDL094
     C                   MOVEL     BYRBB3        FLRBB3                                       CDL094
     C                   MOVEL     BYRBB4        FLRBB4                                       CDL094
     C                   MOVEL     BYRBB5        FLRBB5                                       CDL094
     C                   MOVEL     BYRBB6        FLRBB6                                       CDL094
      *                                                                                       CDL094
      *
     C                   ENDSR
     C*****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * DEFPAY - DEFAULT PAYMENT INSTRUCTIONS                         *
      *                                                               *
      *****************************************************************
     C     DEFPAY        BEGSR
      *
     C                   MOVEL     BYPSTY        FLPSTM
     C                   MOVEL     BYPONO        FLPONS
      *
     C                   MOVEL     BYPIBN        FLPIBN
     C                   MOVEL     BYPIBA        FLPIBA
     C                   MOVEL     BYPOBN        FLPOBN
     C                   MOVEL     BYPOCS        FLPOCN
     C                   MOVEL     BYRCNO        FLRCRN
     C                   MOVEL     BYRCAL        FLRCRA
     C                   MOVEL     BYRCNB        FLRVNO
     C                   MOVEL     BYACBN        FLAWBN
     C                   MOVEL     BYACBL        FLAWBA
     C                   MOVEL     BYBYNB        FLBENN
     C                   MOVEL     BYBACL        FLBENA
     C                   MOVEL     BYDPY1        FLDTP1
     C                   MOVEL     BYDPY2        FLDTP2
     C                   MOVEL     BYDPY3        FLDTP3
     C                   MOVEL     BYDPY4        FLDTP4
     C                   MOVEL     BYDECG        FLDCHG
     C                   MOVEL     BYBBI1        FLBTB1
     C                   MOVEL     BYBBI2        FLBTB2
     C                   MOVEL     BYBBI3        FLBTB3
     C                   MOVEL     BYBBI4        FLBTB4
     C                   MOVEL     BYBBI5        FLBTB5
     C                   MOVEL     BYBBI6        FLBTB6
     C                   MOVEL     BYCVMR        FLCVMR
      *
     C                   MOVEL     BYOPBR        FLPOBR
      *                                                                         156955
      * IF THE CURRENCY OF THE INSTRUCTIONS IS NOT THE PAYMENT CURRENCY         156955
      * SET THE PAYMENT SETTLEMENT CURRENCY TO THAT CURRENCY                    156955
      *                                                                         156955
     C     BYCYCD        IFNE      ##PCCY                                       156955
     C                   MOVEL     BYCYCD        FLPSCY                         156955
     C     ##IERI        IFEQ      'Y'                                          156955
     C                   MOVEL     ##PCCY        FLIC72                         156955
     C                   ENDIF                                                  156955
     C                   ENDIF                                                  156955
     C                   Z-ADD     *ZEROS        FLPEXR                                       CLE031
     C                   MOVEL     *BLANKS       FLPEXI                                       CLE031
      *
     C                   ENDSR
     C*****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      **DEFFRI*-*DEFAULT*FRA*&*IRS*INSTRUCTIONS************************                       CSW212
      * DEFFRI - DEFAULT EXTENDED SETTLEMENT INSTRUCTIONS             *                       CSW212
      *                                                               *
      *****************************************************************
     C     DEFFRI        BEGSR
      *
     C                   MOVEL     BYDSR1        FLDSR1
     C                   MOVEL     BYDSR2        FLDSR2
     C                   MOVEL     BYDSR3        FLDSR3
     C                   MOVEL     BYDSR4        FLDSR4
     C                   MOVEL     BYDSR5        FLDSR5
     C                   MOVEL     BYDSR6        FLDSR6
     C                   MOVEL     BYSSR1        FLSSR1
     C                   MOVEL     BYSSR2        FLSSR2
     C                   MOVEL     BYSSR3        FLSSR3
     C                   MOVEL     BYSSR4        FLSSR4
     C                   MOVEL     BYSSR5        FLSSR5
     C                   MOVEL     BYSSR6        FLSSR6
     C                   MOVEL     BYCND1        FLCND1
     C                   MOVEL     BYCND2        FLCND2
     C                   MOVEL     BYCND3        FLCND3
     C                   MOVEL     BYCND4        FLCND4
     C                   MOVEL     BYCND5        FLCND5
     C                   MOVEL     BYCND6        FLCND6
     C                   MOVEL     BYISDA        FLISDA
     C                   MOVEL     BYAGTY        FLAGTY
     C                   MOVEL     BYAGDT        FLAGDT
     C                   MOVEL     BYAGVV        FLAGVV
     C                   MOVEL     BYAGVC        FLAGVC                         CSW097
      *
     C                   ENDSR
     C*****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * INITFL - INITIALIZE ALL FILE INSTRUCTIONS                     *
      *                                                               *
      *****************************************************************
     C     INITFL        BEGSR
      *
      * INITIALIZE RECEIVE INSTRUCTIONS
      *
     C                   CLEAR                   ##RECF
      *
      * INITIALIZE PAYMENT INSTRUCTIONS
      *
     C                   CLEAR                   ##PAYF
      *
      **INITIALIZE*FRA*&*IRS*INSTRUCTIONS******************************                       CSW212
      * INITIALIZE EXTENDED SETTLEMENT INSTRUCTIONS                                           CSW212
      *
     C                   CLEAR                   ##FRIF
     C*
     C     ##DTYP        IFEQ      'RS'
     C     ##DTYP        OREQ      'RX'
     C*
     C                   IF        BQAGTY = *BLANKS                                         MD028079
     C*****BQISDA        IFNE      *BLANKS                                                  MD028079
     C**********         MOVEL     BQISDA        FLISDA                                     MD028079
     C**********         ELSE                                                               MD028079
     C                   MOVEL     '1991'        FLISDA
     C**********         ENDIF                                                              MD028079
     C*
     C*****BQAGTY        IFNE      *BLANKS                                                  MD028079
     C**********         MOVEL     BQAGTY        FLAGTY                                     MD028079
     C**********         ELSE                                                               MD028079
     C                   MOVEL     'ISDA'        FLAGTY
     C**********         ENDIF                                                              MD028079
     C*
     C*****BQAGDT        IFNE      *BLANKS                                                  MD028079
     C**********         MOVEL     BQAGDT        FLAGDT                                     MD028079
     C**********         ELSE                                                               MD028079
     C                   MOVEL     '871012'      FLAGDT
     C**********         ENDIF                                                              MD028079
     C*
     C*****BQAGVV        IFNE      *BLANKS                                                  MD028079
     C**********         MOVEL     BQAGVV        FLAGVV                                     MD028079
     C**********         ELSE                                                               MD028079
     C                   MOVEL     '87'          FLAGVV
     C**********         ENDIF                                                              MD028079
     C*                                                                         CSW097
     C*****BQAGVC        IFNE      *BLANKS                                           CSW097 MD028079
     C**********         MOVEL     BQAGVC        FLAGVC                              CSW097 MD028079
     C**********         ELSE                                                        CSW097 MD028079
     C                   MOVEL     '19'          FLAGVC                         CSW097
     C**********         ENDIF                                                       CSW097 MD028079
     C                   ELSE                                                               MD028079
     C                   EVAL      FLISDA = BQISDA                                          MD028079
     C                   EVAL      FLAGTY = BQAGTY                                          MD028079
     C                   EVAL      FLAGDT = BQAGDT                                          MD028079
     C                   EVAL      FLAGVV = BQAGVV                                          MD028079
     C                   EVAL      FLAGVC = BQAGVC                                          MD028079
     C                   ENDIF                                                              MD028079
     C*
     C                   ENDIF
     C*
     C                   ENDSR
     C*****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * RTVCST - Retrieve customer number                             *
      *                                                               *
      *****************************************************************
     C     RTVCST        BEGSR
      *
      *  Retrieve Customer Number from Customer details file
      *
     C*******************CALLB     'AOCUSTR0'                                               BUG7013R
     C                   CALLB     'AOCUSTR1'                                               BUG7013R
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      ##CSHN        @KEY1            10
     C                   PARM      *BLANKS       @KYST             7
     C*****SDCUST        PARM      SDCUST        DSSDY                                      BUG7013R
     C     SDCUST        PARM      SDCUST        DSLDY                                      BUG7013R
      *
      *  If valid, use customer number,
      *  else exit from this program
      *
     C     @RTCD         IFEQ      *BLANKS
     C     @KYST         ANDNE     '*ERROR '
     C                   MOVEL     BBCUST        ##CUST            6
      *                                                                                     BUG7013R
      ** Set up CLS settlement flag from customer file                                      BUG7013R
      *                                                                                     BUG7013R
      *******************IF        BBCLSS = 'Y'                                     BUG7013R BUG7512
      *******************MOVEL     'CL'          ##DTYP                             BUG7013R BUG7512
      *******************MOVEL     'CL'          ##TRTY                             BUG7013R BUG7512
      *******************ENDIF                                                      BUG7013R BUG7512
     C                   ELSE
     C                   RETURN
     C                   END
     C                   ENDSR
     C*****************************************************************
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
      *
      ** PARAMETERS
      *
     C     *ENTRY        PLIST
      *
      ** INPUT
      *
      ** Code to indicate calling function
     C                   PARM                    ##CALP            4
      *
      ** Payment currency
     C                   PARM                    ##PCCY            3
      *
      ** Receive currency
     C                   PARM                    ##RCCY            3
      *
      ** Customer (shortname or number)
     C                   PARM                    ##CSHN           10
      *
      ** Deal type
     C                   PARM                    ##DTYP            2
      *
      ** Federal Funds Ind.
     C                   PARM                    ##FFIN            1
      *
      ** Version of ISDA Rules govern
     C                   PARM                    BQISDA            4
      *
      ** Type of ISDA agreement
     C                   PARM                    BQAGTY            6
      *
      ** Date of ISDA Agreement
     C                   PARM                    BQAGDT            6
      *
      ** Version of ISDA Agreement
     C                   PARM                    BQAGVV            2
      *                                                                         CSW097
      ** Version century of ISDA Agreement                                      CSW097
     C                   PARM                    BQAGVC            2            CSW097
      ** Deal Subype                                                                          CSD095
     C                   PARM                    BQSTYP            2                          CSD095
      ** Branch                                                                               CSD095
     C                   PARM                    BQBRCA            3                          CSD095
 
      ** OUTPUT
 
      ** File Payment Settlement Instruction
     C                   PARM                    ##PAYF
 
      ** File Receipt Settlement Instruction
     C                   PARM                    ##RECF
 
      ***File*FRA/IRS*Settlement*Instruction***************************                       CSW212
      ** File Extended Settlement Instruction                                                 CSW212
     C                   PARM                    ##FRIF
      *                                                                         CDL008
      ** Check if switchable feature CDL008 is switched on                      CDL008
      *                                                                         CDL008
     C                   CALLB     'AOSARDR0'                                   CDL008
     C                   PARM      *BLANKS       @RTCD                          CDL008
     C                   PARM      '*VERIFY '    @OPTN                          CDL008
     C                   PARM      'CDL008'      @SARD                          CDL008
     C     SCSARD        PARM      SCSARD        DSFDY                          CDL008
      *                                                                         CDL008
     C     @RTCD         IFNE      *BLANK                                       CDL008
     C     @RTCD         ANDNE     '*NRF   '                                    CDL008
     C                   MOVEL     @SARD         DBKEY                          CDL008
     C                   MOVEL     'SCSARDPD'    DBFILE                         CDL008
     C                   MOVEL     '001'         DBASE                          CDL008
     C                   EXSR      *PSSR                                        CDL008
     C                   ENDIF                                                  CDL008
      *                                                                         CDL008
     C     @RTCD         IFEQ      *BLANKS                                      CDL008
     C                   MOVE      'Y'           CDL008            1            CDL008
     C                   ELSE                                                   CDL008
     C                   MOVE      'N'           CDL008                         CDL008
     C                   ENDIF                                                  CDL008
      ** Start CDL025
      ** Check if switchable feature CDL025 is switched on                      CDL025
      *                                                                         CDL025
     C                   CALLB     'AOSARDR0'                                   CDL025
     C                   PARM      *BLANKS       @RTCD                          CDL025
     C                   PARM      '*VERIFY '    @OPTN                          CDL025
     C                   PARM      'CDL025'      @SARD                          CDL025
     C     SCSARD        PARM      SCSARD        DSFDY                          CDL025
      *                                                                         CDL025
     C     @RTCD         IFNE      *BLANK                                       CDL025
     C     @RTCD         ANDNE     '*NRF   '                                    CDL025
     C                   MOVEL     @SARD         DBKEY                          CDL025
     C                   MOVEL     'SCSARDPD'    DBFILE                         CDL025
     C                   MOVEL     '001'         DBASE                          CDL025
     C                   EXSR      *PSSR                                        CDL025
     C                   ENDIF                                                  CDL025
      *                                                                         CDL025
     C     @RTCD         IFEQ      *BLANKS                                      CDL025
     C                   MOVE      'Y'           CDL025            1            CDL025
     C                   ELSE                                                   CDL025
     C                   MOVE      'N'           CDL025                         CDL025
     C                   ENDIF                                                  CDL025
 
      ** Check if switchable feature CDL031 is switched on                      CDL031
     C                   CALLB     'AOSARDR0'                                   CDL031
     C                   PARM      *BLANKS       @RTCD                          CDL031
     C                   PARM      '*VERIFY '    @OPTN                          CDL031
     C                   PARM      'CDL031'      @SARD                          CDL031
     C     SCSARD        PARM      SCSARD        DSFDY                          CDL031
      *                                                                         CDL031
     C     @RTCD         IFNE      *BLANK                                       CDL031
     C     @RTCD         ANDNE     '*NRF   '                                    CDL031
     C                   MOVEL     @SARD         DBKEY                          CDL031
     C                   MOVEL     'SCSARDPD'    DBFILE                         CDL031
     C                   MOVEL     '001'         DBASE                          CDL031
     C                   EXSR      *PSSR                                        CDL031
     C                   ENDIF                                                  CDL031
      *                                                                         CDL031
     C     @RTCD         IFEQ      *BLANKS                                      CDL031
     C                   MOVE      'Y'           CDL031            1            CDL031
     C                   ELSE                                                   CDL031
     C                   MOVE      'N'           CDL031                         CDL031
     C                   ENDIF                                                  CDL031
     C/COPY WNCPYSRC,ZAH00003
 
      *                                                                                       CSW212
      ** Check if SWIFT 2012  is on                                                           CSW212
      *                                                                                       CSW212
     C                   CALL      'SWIF2012'                                                 CSW212
     C                   PARM      *BLANKS       @RTCD                                        CSW212
      *                                                                                       CSW212
     C     @RTCD         IFEQ      'CSW2012'                                                  CSW212
     C                   MOVEL     'Y'           CSW212            1                          CSW212
     C                   ELSE                                                                 CSW212
     C                   MOVEL     'N'           CSW212                                       CSW212
     C                   ENDIF                                                                CSW212
      *                                                                                       CSW212
      ** Retrieve setting of the SSIs system values                                           CSD095
      *                                                                                       CSD095
     C                   CALLB     'AOSVALR0'                                                 CSD095
     C                   PARM      *BLANKS       PRtnCode                                     CSD095
     C                   PARM      SSIBranch     PSysVal01                                    CSD095
     C                   PARM                    PCurSet01                                    CSD095
     C                   PARM      SSIDealStype  PSysVal02                                    CSD095
     C                   PARM                    PCurSet02                                    CSD095
     C                   PARM      SSIDftSecChk  PSysVal03                                    CSD095
     C                   PARM                    PCurSet03                                    CSD095
     C                   PARM                    PSysVal04                                    CSD095
     C                   PARM                    PCurSet04                                    CSD095
     C                   PARM                    PSysVal05                                    CSD095
     C                   PARM                    PCurSet05                                    CSD095
     C                   PARM                    PSysVal06                                    CSD095
     C                   PARM                    PCurSet06                                    CSD095
     C                   PARM                    PSysVal07                                    CSD095
     C                   PARM                    PCurSet07                                    CSD095
     C                   PARM                    PSysVal08                                    CSD095
     C                   PARM                    PCurSet08                                    CSD095
     C                   PARM                    PSysVal09                                    CSD095
     C                   PARM                    PCurSet09                                    CSD095
     C                   PARM                    PSysVal10                                    CSD095
     C                   PARM                    PCurSet10                                    CSD095
                                                                                              CSD095
     C                   IF        PRtnCode <> *BLANKS                                        CSD095
     C                   EVAL      DBFILE = 'SDSVALPD'                                        CSD095
     C                   EVAL      DBASE = 002                                                CSD095
     C                   EVAL      DBKEY = PSysVal01                                          CSD095
     C                   EXSR      *PSSR                                                      CSD095
     C                   ENDIF                                                                CSD095
                                                                                              CSD095
     C                   EVAL      WUSEBR = PCurSet01                                         CSD095
     C                   EVAL      WUSEST = PCurSet02                                         CSD095
     C                   EVAL      WSECHK = PCurSet03                                         CSD095
                                                                                              CSD095
     C                   ENDSR
      *****************************************************************
     C/COPY WNCPYSRC,ZAH00039
     C/COPY ZACPYSRC,PSSR_ILE                                                   CDL008
**  CPY@                                                                        CDL008
(c) Misys International Banking Systems Ltd. 2001                               CDL008
