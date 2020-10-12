     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Customer primary details validation')         *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Details Module.                             *
      *                                                               *
      *  SDCUSD2VL - Customer Primary Details Validation             *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD056981           Date 12Oct20               *
      *  Prev Amend No. HUT113             Date 01Apr20               *
      *                 CSD094             Date 29Aug18               *
      *                 MD051247           Date 17Jul18               *
      *                 MD040876           Date 13Sep16               *
      *                 MD046248           Date 27Oct17               *
      *                 MD042407           Date 07Nov16               *
      *                 CSW216             Date 14Mar16               *
      *                 MD034317           Date 17Jul15               *
      *                 LLN022A            Date 03Jun15               *
      *                 LLN022             Date 03Jun15               *
      *                 CSD099             Date 11Feb15               *
      *                 CSW214             Date 25Nov14               *
      *                 MD030956           Date 09Oct14               *
      *                 MD028337           Date 10Jul14               *
      *                 TI010338           Date 24May13               *
      *                 CGL132             Date 01May13               *
      *                 CFT050             Date 03Jun13               *
      *                 CER059             Date 19Jul10               *
      *                 BUG25531           Date 14Aug09               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 BUG14927           Date 28Sep07               *
      *                 CSW207A            Date 02Aug07               *
      *                 CSW207             Date 08Jun07               *
      *                 249179             Date 17Jul07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CDL013             Date 09Jun06               *
      *                 BUG10738           Date 02Mar06               *
      *                 CSW037A            Date 02May05               *
      *                 BUG5450            Date 08Mar05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 BUG3605            Date 21Jul04               *
      *                 CFX001             Date 20Oct03               *
      *                 CLE025             Date 20Oct03               *
      *                 BUG2313            Date 28Apr04               *
      *                 CGP001             Date 23May03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CSC011             Date 18Sep01               *
      *                 CSW024             Date 31Aug01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CRE007             Date 01Mar01               *
      *                 CPB002             Date 13Dec99               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CSD007             Date 28Aug00               *
      *                 CDL008             Date 02May00               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CAP034             Date 31Mar99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD056981  - Customer Maintenance: Private Banking Error      *
      *              Encountered During Input                         *
      *              Amend  SDCUDPV048 and  SDCUDPV051                *
      *  HUT113 - Full PB Functionality in FM                         *
      *           (Upgrade HUT026 to FM2.1 SP22)                      *
      *           Addition of hook HUT113_109                         *
      *  CSD094 - Make Industry and Institution Code Mandatory        *
      *  MD051247 - SP15 CUSD API Issue                               *
      *  MD040876 - CRS MQ (Recompile)                                *
      *  MD046248 - Finastra Rebranding                               *
      *  MD042407 - Creation Date field is missing when CGL132 is     *
      *             switched off ; reversed MD034317 fix              *
      *  CSW216 - SWIFT Changes 2016 (Recompile)                      *
      *  MD034317 - Added condition on CGL132 fields validation to    *
      *             check if the feature is on.                       *
      *  LLN022A - BOE Upgrade to MidasPlus - incorporate code from   *
      *            /COPY members and add switchability.               *
      *  LLN022 - BOE Upgrade to MidasPlus.                           *
      *  CSD099 - Overrideable error if Institution Code blank.       *
      *  CSW214 - SWIFT Changes 2014 (Recompile)                      *
      *  MD030956 - Additional changes to BFM-TI enhancement          *
      *  MD028337 - Data Migration issue - Customer Details API       *
      *             sheet: Missing new fields (not filled/initialized)*
      *           - Initialize Dormant inidicator to 'N' when blank   *
      *  TI010338 - Validation is expected when Parent Indicator is   *
      *             set to 'P' and TI tab is filled. Applied for      *
      *             MD026906.                                         *
      *  CGL132 - FATCA Phase 1 - Customers' Identification and       *
      *           Classification - Master                             *
      *  CFT050 - SWIFTRef Directories upload (Recompile)             *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG25531 - Incorrect EU tax calculation                      *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  BUG14927 - Allow Blank Value for Customer Classification     *
      *             field if Private Banking Module is 'OFF'          *
      *  CSW207A - SWIFT 2007 Changes                                 *
      *  CSW207 - SWIFT 2007 Changes                                  *
      *  249179 - User is able to input new customer details in the   *
      *           Customer Details Maintenance (CUAP) although the    *
      *           user profile is not authorised to the branch.       *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CDL013 - Tiered withholding tax                              *
      *  BUG10738 - Customer insert doesn't continue on second screen *
      *             upon Enter                                        *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  BUG5450 - Designated In Currency field should not be         *
      *            displayed in Customer Details                      *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  BUG3605 - Make industry code mandatory for TI Customers.     *
      *  CFX001 - FX Margin Trading                                   *
      *  CLE025 - Credit Lines                                        *
      *  BUG2313 - Numerous errors concerning global customer id      *
      *  CGP001 - Global Processing                                   *
      *  CSC011 - 24x7 Midas Availability                             *
      *  CSW024 - S.W.I.F.T. MT3xx Field 82/83/87 (Recompiled).       *
      *  CRE007 - Base Rate Tax 2001.                                 *
      *  CPB002 - Meridian DBA Middleware Replication Customization.  *
      *  CSD007 - Customer Closing: Recompile.                        *
      *  CDL008 - Continuous Linked Settlement (Recompiled)           *
      *  CAP034 - Conversion of SD inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
                                                                                             BUG2313
     FGPCUSTXL2 IF   E           K DISK    INFSR(*PSSR)                                      BUG2313
     FSDBRCHL0  IF   E           K DISK    INFSR(*PSSR)                                      BUG2313

      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

      * Midas SD Local Industry Codes
      * Hook to enable non-core files to be included
      /COPY WNCPYSRC,SDCUDPV001

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
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **--------------------------------------------------------------------------------------------

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the size
      ** of the arrays.
     D/COPY ZACPYSRC,ERR_XARRYS
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

      ** Customer Primary Details in screen format
     D CuPrim        E DS                  EXTNAME(SDCUPRPD)
      ** Customer Extension 1 Details in screen format                                        CGL132
     D CuXC          E DS                  EXTNAME(SDCUXCPD)                                  CGL132
      ** Customer SWIFT etails in screen format                                               CSW207
     D CuSwft        E DS                  EXTNAME(SDCUSWPD)                                  CSW207

      ** Customer Primary Details OK indicators
     D OKCuPrim      E DS                  EXTNAME(SDECUPRPD)
      ** Customer Extension 1 Details OK indicators                                           CGL132
     D OKCuXC        E DS                  EXTNAME(SDECUXCPD)                                 CGL132
      ** Customer SWIFT Details OK indicators                                                 CSW207
     D OKCuSwft      E DS                  EXTNAME(SDECUSWPD)                                 CSW207

      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)

      ** External DS for Midas modules details
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)

      ** External DS for Global Customer X-Reference details                                  CGP001
     D GPCUSTX       E DS                  EXTNAME(GPCUSTXPD)                                 CGP001
     D                                     PREFIX(G)                                          CGP001
                                                                                              CGP001
      **  Short DS for access programs
     D DSFDY         E DS                  EXTNAME(DSFDY)

      **  Long DS for access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)

     D ZMUSER          DS            17
     D  USRBCH                11     13


     D ValidCusd     E DS                  EXTNAME(SDVCUSDPD)
      * Valid Customer Details layout
     D ValidCuXc     E DS                  EXTNAME(SDVCUXCPD)                                 CGL132
      * Valid Customer Ext Details layout                                                     CGL132
     D ValidSwft     E DS                  EXTNAME(SDVSWSDPD)                                 CSW207
      * Valid Customer Details layout                                                         CSW207

     D ExtData       E DS                  EXTNAME(SDCUEXPD)
      * Customer Details Extra Data - File (D/B) format

      ** External DS for SAR details                                                          CSC011
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CSC011
                                                                                              CSC011
      ** 24X7 status data area                                                                CSC011
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)                     CSC011
                                                                                              CSC011
      ** SD data area                                                                         CSC011
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)                     CSC011

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      ** Index for arrays of of error message ids etc
     D Idx             S              3P 0
      ** Index for arrays of of warning message ids etc
     D WIdx            S              3P 0

     D CSC011          S              1A                                                      CSC011
     D PRtCd           S              7A                                                      CSC011
     D POptn           S              7A                                                      CSC011
     D PSard           S              6A                                                      CSC011
     D WRunDay         S                   LIKE(BJRDNB)                                       CSC011
                                                                                              CSC011
     D CGP001          S              1A                                                      CGP001
     D PGlbCusID       S             10A                                                      CGP001
     D V_DDGCUS        S             10A                                                      CGP001
                                                                                              CGP001
     D CFX001          S              1                                                       CFX001
     D CLE025          S              1                                                       CLE025
     D CSD025          S              1                                                       CSD025
     D CSD094          S              1                                                       CSD094
     D***CGL132*          S              1                                         MD034317 MD042407
                                                                                              CLE025
     D CSW207          S              1A                                                      CSW207
     D CTI006          S              1A                                                    MD030956
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+

      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      /COPY WNCPYSRC,SDCUDPV002

      *****************************************************************
      /EJECT
      *****************************************************************

      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *inzsr is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+


      /COPY WNCPYSRC,SDCUDPV003

      ** Pass data not requiring validation to VALIDCUSD fields
      *
      ** Customer Name and Address.2
      ** Customer Name and Address.3
      ** Customer Name and Address.4
      ** Customer Alpha Sort Code
      ** Customer Telephone Number
      ** Reuters ID
      ** Customer Type
     C                   MOVE      DDCNA2        CUCNA2
     C                   MOVE      DDCNA3        CUCNA3
     C                   MOVE      DDCNA4        CUCNA4
     C                   MOVE      DDCASC        CUCASC
     C                   MOVE      DDCTNB        CUCTNB
     C                   MOVE      DDREID        CUREID
     C/COPY WNCPYSRC,SDCUS2VC01
     C     CDL013        IFEQ      'N'                                                        CDL013
     C                   MOVE      DDCSTY        CUCSTY
     C                   ENDIF                                                                CDL013
      *
      ** Validate Customer name and address
      *
      /COPY WNCPYSRC,SDCUDPV004
     C                   EXSR      VCCNA1
      /COPY WNCPYSRC,SDCUDPV005
      *
      ** Validate customer shortname
      *
      /COPY WNCPYSRC,SDCUDPV006
     C                   EXSR      VCCSSN
      /COPY WNCPYSRC,SDCUDPV007
      *
      ** Validate location
      *
      /COPY WNCPYSRC,SDCUDPV008
     C                   EXSR      VCLCCD
      /COPY WNCPYSRC,SDCUDPV009
      *
      ** Validate customer report name
      *
      /COPY WNCPYSRC,SDCUDPV010
     C                   EXSR      VCCRNM
      /COPY WNCPYSRC,SDCUDPV011
                                                                                              CGP001
      ** Validate Global Customer ID                                                          CGP001
                                                                                              CGP001
     C                   IF        CGP001 = 'Y'                                               CGP001
     C                   EXSR      VCGCUS                                                     CGP001
     C                   ENDIF                                                                CGP001
      *
      ** Validate customer report town
      *
      /COPY WNCPYSRC,SDCUDPV012
     C                   EXSR      VCCRTN
      /COPY WNCPYSRC,SDCUDPV013
      *
      ** Validate De-Activate Flag                                                            CSD025
      *                                                                                       CSD025
     C                   IF        CSD025 = 'Y'                                               CSD025
     C                   EXSR      VCDEAC                                                     CSD025
     C                   ENDIF                                                                CSD025
      *                                                                                       CSD025
      ** Validate designated in currency
      *
      /COPY WNCPYSRC,SDCUDPV014
      ** No need to validate designated in currency because field has                        BUG5450
      ** been removed from screen.                                                           BUG5450
                                                                                             BUG5450
     C**********         EXSR      VCDINC                                                    BUG5450
      /COPY WNCPYSRC,SDCUDPV015
      *                                                                                       CGL132
      ** Validate Creation Date                                                               CGL132
      *                                                                                       CGL132
     C**********         IF        CGL132 = 'Y'                                    MD034317 MD042407
     C                   EXSR      VCCRDT                                                     CGL132
     C**********         ENDIF                                                     MD034317 MD042407
      *                                                                                       CGL132
      ** Validate Dormant Indicator                                                           CGL132
      *                                                                                       CGL132
     C**********         IF        CGL132 = 'Y'                                    MD034317 MD042407
     C                   EXSR      VCDRMT                                                     CGL132
     C**********         ENDIF                                                     MD034317 MD042407
      *
      ** Validate parent indicator and parent customer number
      *
      /COPY WNCPYSRC,SDCUDPV016
     C                   EXSR      VCPIPN
      /COPY WNCPYSRC,SDCUDPV017
      *
      ** Validate account officer
      *
      /COPY WNCPYSRC,SDCUDPV018
     C                   EXSR      VCACOC
      /COPY WNCPYSRC,SDCUDPV019
      *
      ** Validate country of citizenship
      *
      /COPY WNCPYSRC,SDCUDPV020
     C                   EXSR      VCCNCZ
     C**********         IF        CGL132 = 'Y'                                    MD034317 MD042407
     C                   EXSR      VCACCZ                                                     CGL132
     C**********         ENDIF                                                     MD034317 MD042407
      /COPY WNCPYSRC,SDCUDPV021
      *
      ** Validate country of domicile
      *
      /COPY WNCPYSRC,SDCUDPV022
     C                   EXSR      VCCOLC
      /COPY WNCPYSRC,SDCUDPV023
      *
      ** Validate bank/non-bank indicator
      *
      /COPY WNCPYSRC,SDCUDPV024
     C                   EXSR      VCBNBI
      /COPY WNCPYSRC,SDCUDPV025
      *
      ** Validate suspended date
      *
      /COPY WNCPYSRC,SDCUDPV026
     C                   EXSR      VCSSDT
      /COPY WNCPYSRC,SDCUDPV027
      *
      ** Validate local insitution code
      *
      /COPY WNCPYSRC,SDCUDPV028
     C                   EXSR      VCLINC
      /COPY WNCPYSRC,SDCUDPV029
      *
      ** Validate first contact date
      *
      /COPY WNCPYSRC,SDCUDPV030
     C                   EXSR      VCDOIC
      /COPY WNCPYSRC,SDCUDPV031
      *
      ** Validate local industry code
      *
      /COPY WNCPYSRC,SDCUDPV032
     C                   EXSR      VCLICD
      /COPY WNCPYSRC,SDCUDPV033
      *
      ***Check if Bank of England extract is switched on                            LLN022A MD051247
      **********                                                                    LLN022A MD051247
     C*****LLN007        Ifeq      *BLANK                                           LLN022A MD051247
      **********                                                                    LLN022A MD051247
     C**********         Callb     'AOSARDR0'                                       LLN022A MD051247
     C**********         Parm      *BLANKS       @RTCD                              LLN022A MD051247
     C**********         Parm      '*VERIFY'     @OPTN                              LLN022A MD051247
     C**********         Parm      'LLN007'      @SARD                              LLN022A MD051247
      **********                                                                    LLN022A MD051247
      ***Set switchable feature indicator                                           LLN022A MD051247
      **********                                                                    LLN022A MD051247
     C*****@RTCD         Ifeq      *BLANK                                           LLN022A MD051247
     C**********         Movel     'Y'           LLN007            1                LLN022A MD051247
     C**********         Else                                                       LLN022A MD051247
     C**********         Movel     'N'           LLN007                             LLN022A MD051247
     C**********         Endif                                                      LLN022A MD051247
      **********                                                                    LLN022A MD051247
     C**********         Endif                                                      LLN022A MD051247
      *                                                                                      LLN022A
      ** Call additional BOE validation program                                              LLN022A
      *                                                                                      LLN022A
     C     LLN007        Ifeq      'Y'                                                       LLN022A
      *                                                                                      LLN022A
      ** Reset variables updated by each module                                              LLN022A
      *                                                                                      LLN022A
     C                   Exsr      RESETERRS                                                 LLN022A
      *                                                                                      LLN022A
      ** BOE Validation                                                                      LLN022A
      *                                                                                      LLN022A
     C                   Call      'BYCUSD2VL'                                               LLN022A
      *                                                                                      LLN022A
      ** INPUTS:                                                                             LLN022A
      *                                                                                      LLN022A
     C                   PARM                    RetCodeOut                                  LLN022A
     C     CULINC        PARM                    DDLINC                                      LLN022A
     C     CULICD        PARM                    DDLICD                                      LLN022A
     C                   PARM                    DDCOLC                                      LLN022A
      *                                                                                      LLN022A
      ** OUTPUTS:                                                                            LLN022A
      *                                                                                      LLN022A
     C                   PARM                    FldNamXAr                                   LLN022A
     C                   PARM                    MsgIDXAr                                    LLN022A
     C                   PARM                    MsgDtaXAr                                   LLN022A
     C                   PARM                    DDLICDOK                                    LLN022A
     C                   PARM                    DDLINCOK                                    LLN022A
      *                                                                                      LLN022A
      ** Update error info with that returned from the                                       LLN022A
      ** validation module                                                                   LLN022A
      *                                                                                      LLN022A
     C                   EXSR      UPDATERRS                                                 LLN022A
      *                                                                                      LLN022A
     C                   Endif                                                               LLN022A
      *                                                                                      LLN022A
      ** Validate tax/non-tax indicator and branch indicator
      *
      /COPY WNCPYSRC,SDCUDPV034
     C                   EXSR      VCTNBI
      /COPY WNCPYSRC,SDCUDPV035
      *
      ** Validate branch code
      *
      /COPY WNCPYSRC,SDCUDPV036
     C                   EXSR      VCBRCD
      /COPY WNCPYSRC,SDCUDPV037
      *
      ** Validate allow COB deletion
      *
      /COPY WNCPYSRC,SDCUDPV038
     C                   EXSR      VCCDEL
      /COPY WNCPYSRC,SDCUDPV039
      *
      ** Validate risk weighting code
      *
      /COPY WNCPYSRC,SDCUDPV040
     C                   EXSR      VCRWCD
      /COPY WNCPYSRC,SDCUDPV041
      *
      ** Validate MA analysis by assoc customer
      *
      /COPY WNCPYSRC,SDCUDPV042
     C                   EXSR      VCMCAC
      /COPY WNCPYSRC,SDCUDPV043
      *
      ** Validate retail customer group
      *
      /COPY WNCPYSRC,SDCUDPV044
     C                   EXSR      VCCGRP
      /COPY WNCPYSRC,SDCUDPV045
      *
      ** Validate margin type
      *
      /COPY WNCPYSRC,SDCUDPV046
     C                   EXSR      VCMTSC
      /COPY WNCPYSRC,SDCUDPV047
      *
      ** Validate private banking customer
      *
      /COPY WNCPYSRC,SDCUDPV048
     C                   IF        BGN4ST = 'Y'                                             BUG10738
     C                   EXSR      VCPRBA
     C                   ENDIF                                                              BUG10738
      /COPY WNCPYSRC,SDCUDPV049
                                                                                              CLE025
      ** If CLE025 is on, validate Facility Mandatory & Include Offsets flags                 CLE025
                                                                                              CLE025
     C                   IF        CLE025 = 'Y'                                               CLE025
     C                             OR  CFX001 = 'Y'                                           CFX001
     C                   EXSR      VCFMIO                                                     CLE025
     C                   ENDIF                                                                CLE025
      *
      ** Check if SWIFT 2007 is installed :                                                   CSW207
      *                                                                                       CSW207
     C                   IF        CSW207 = 'Y' OR BGN4ST = 'Y'                               CSW207
     C                   EXSR      SRVCLLS                                                    CSW207
     C                   EXSR      SRVCPCI                                                    CSW207
     C                   ENDIF                                                                CSW207
      *                                                                                       CSW207
     C                   RETURN

      * Hook to enable non-core subroutines to be included
      /COPY WNCPYSRC,SDCUDPV050

      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VCCNA1 - Validate Customer Name and Address
      *****************************************************************
     C     VCCNA1        BEGSR

      * Reset variables updated by validation

     C                   EXSR      RESETERRS
      *
      ** Validate customer name and address
      *
     C                   CALLB     'SDVCSNM'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeOut
      *
      ** Customer Name and Address.1 (35A)
     C     CUCNA1        PARM                    DDCNA1
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Customer Name and Address.1 - OK
     C                   PARM                    DDCNA1OK
      *
      * Update error info with that returned from the validation module

     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VCCRNM - Validate Customer Report Name
      *****************************************************************
     C     VCCRNM        BEGSR

      * Reset variables updated by each module

     C                   EXSR      RESETERRS
      *
      ** Validate customer report name
      *
     C                   CALLB     'SDVRENM'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeOut
      *
      ** Customer Report Name (20A)
     C     CUCRNM        PARM                    DDCRNM
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Customer Report Name - OK
     C                   PARM                    DDCRNMOK
      *
      * Update error info with that returned from the validation module

     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT                                                                                  CGP001
      *****************************************************************                       CGP001
      ** VCGCUS - Validate Global Customer ID                                                 CGP001
      *****************************************************************                       CGP001
     C     VCGCUS        BEGSR                                                                CGP001
                                                                                              CGP001
      * Reset variables updated by each module                                                CGP001
                                                                                              CGP001
     C                   EXSR      RESETERRS                                                  CGP001
                                                                                              CGP001
     C                   EVAL      DDGCUSOK = 'Y'                                             CGP001
     C                   EVAL      V_DDGCUS = *BLANKS                                         CGP001
     C                   IF        DDGCUS <> *BLANKS                                          CGP001
                                                                                              CGP001
      ** Validate global customer ID                                                          CGP001
                                                                                              CGP001
     C                   CALL      'AOGCSTR0'                                                 CGP001
     C                   PARM      *BLANKS       PRtCd                                        CGP001
     C                   PARM      '*VERIFY'     POptn                                        CGP001
     C                   PARM      DDGCUS        PGlbCusID                                    CGP001
     C     GPCUSTX       PARM      GPCUSTX       DSFDY                                        CGP001
                                                                                              CGP001
     C                   IF        PRtCd <> *BLANKS                                           CGP001
     C                   EVAL      DDGCUSOK = 'N'                                             CGP001
     C                   EVAL      FldNamXAr(1) = 'DDGCUS'                                    CGP001
     C                   EVAL      MsgIDXAr(1)  = 'GPM0011'                                   CGP001
     C                   ELSE                                                                 CGP001
     C                   EVAL      DDGCUS   = PGlbCusID                                       CGP001
     C                   EVAL      V_DDGCUS = PGlbCusID                                       CGP001
     C                   ENDIF                                                                CGP001
                                                                                             BUG2313
      * If global customer is defined and is ok so far                                       BUG2313
      * check that it is not present against another customer in this zone                   BUG2313
                                                                                             BUG2313
     C                   IF        DDGCUSOK = 'Y'                                            BUG2313
     C     DDGCUS        SETLL     GPCUSTXD0                                                 BUG2313
     C     DDGCUS        READE     GPCUSTXD0                              99                 BUG2313
     C     *IN99         DOWEQ     *OFF                                                      BUG2313
     C     CUBRCD        CHAIN     @A8REB1                            99                     BUG2313
     C     *IN99         IFEQ      *OFF                                                      BUG2313
     C     CUCUST        ANDNE     DDCUSN                                                    BUG2313
     C                   EVAL      DDGCUSOK = 'N'                                            BUG2313
     C                   EVAL      FldNamXAr(1) = 'DDGCUS'                                   BUG2313
     C                   EVAL      MsgIDXAr(1)  = 'GPM0012'                                  BUG2313
     C                   ENDIF                                                               BUG2313
     C     DDGCUS        READE     GPCUSTXD0                              99                 BUG2313
     C                   ENDDO                                                               BUG2313
     C                   ENDIF                                                               BUG2313
                                                                                              CGP001
     C                   ENDIF                                                                CGP001
                                                                                              CGP001
      ** Update error info                                                                    CGP001
                                                                                              CGP001
     C                   EXSR      UPDATERRS                                                  CGP001
                                                                                              CGP001
     C                   ENDSR                                                                CGP001
      *****************************************************************                       CGP001
     C/EJECT
      *****************************************************************
      ** VCCRTN - Validate Customer Report Town
      *****************************************************************
     C     VCCRTN        BEGSR

      * Reset variables updated by each module

     C                   EXSR      RESETERRS
      *
      ** Validate customer report town
      *
     C                   CALLB     'SDVREDE'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeOut
      *
      ** Customer Report Town (10A)
     C     CUCRTN        PARM                    DDCRTN
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Customer Report Town - OK
     C                   PARM                    DDCRTNOK
      *
      * Update error info with that returned from the validation module
      *

     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT                                                                                  CSD025
      *****************************************************************                       CSD025
      ** VCDEAC - Validate De-Activated Flag                                                  CSD025
      *****************************************************************                       CSD025
     C     VCDEAC        BEGSR                                                                CSD025
                                                                                              CSD025
      * Reset variables updated by each module                                                CSD025
                                                                                              CSD025
     C                   EXSR      RESETERRS                                                  CSD025
      *                                                                                       CSD025
      ** Validate customer report town                                                        CSD025
      *                                                                                       CSD025
     C                   CALLB     'SDVDEAC'                                                  CSD025
      *                                                                                       CSD025
      * INPUTS                                                                                CSD025
      *                                                                                       CSD025
      ** Return Code                                                                          CSD025
     C                   PARM                    RetCodeOut                                   CSD025
      ** Action code                                                                          CSD025
     C                   PARM                    DDACTN                                       CSD025
      ** De-Activated Flag                                                                    CSD025
     C                   PARM                    DDDEAC                                       CSD025
      ** De-Activated Date                                                                    CSD025
     C                   PARM                    DDDEDT                                       CSD025
      ** Bank Info SD                                                                         CSD025
     C                   PARM                    SDBANK                                       CSD025
      *                                                                                       CSD025
      * OUTPUTS                                                                               CSD025
      *                                                                                       CSD025
      * Error fields/message IDs/message data (arrays) from/to caller                         CSD025
     C                   PARM                    FldNamXAr                                    CSD025
     C                   PARM                    MsgIDXAr                                     CSD025
     C                   PARM                    MsgDtaXAr                                    CSD025
      ** De-Activation Flag - OK                                                              CSD025
     C                   PARM                    DDDEACOK                                     CSD025
      ** De-Activated Date (5N)                                                               CSD025
     C                   PARM                    WUDEDT            5 0                        CSD025
      ** De-Activated Date (6A)                                                               CSD025
     C                   PARM                    WDDEDT            6                          CSD025
      *                                                                                       CSD025
     C     RetCodeOut    IFEQ      *BLANKS                                                    CSD025
     C                   MOVE      DDDEAC        CUDEAC                                       CSD025
     C                   Z-ADD     WUDEDT        CUDEDT                                       CSD025
     C                   MOVE      WDDEDT        DDDEDT                                       CSD025
     C                   ENDIF                                                                CSD025
      *                                                                                       CSD025
      * Update error info with that returned from the validation module                       CSD025
      *                                                                                       CSD025
                                                                                              CSD025
     C                   EXSR      UPDATERRS                                                  CSD025
      *                                                                                       CSD025
     C                   ENDSR                                                                CSD025
      *****************************************************************                       CSD025
     C/EJECT
      *****************************************************************
      ** VCBRCD - Validate Branch Code
      *****************************************************************
     C     VCBRCD        BEGSR

      * Reset variables updated by each module

     C                   EXSR      RESETERRS
      *
      ** Validate branch code
      *
     C                   CALLB     'SDVBHCD'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeOut
     C                   PARM                    RespMode                                     249179
     C                   PARM                    DDACTN                                       249179
      *
      ** Multi-Branching Indicator (1A)
      *  Branch Code (3A)
      *
     C                   PARM                    BGMBIN
     C     CUBRCD        PARM                    DDBRCD
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Branch code - OK
     C                   PARM                    DDBRCDOK
      *
      * Update error info with that returned from the validation module

     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VCLCCD - Validate Location
      *****************************************************************
     C     VCLCCD        BEGSR

      * Reset variables updated by each module

     C                   EXSR      RESETERRS
      *
      ** Validate location code
      *
     C                   CALLB     'SDVLCCD01'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeOut
      *
      ** Location Code (3A)
     C     CULCCD        PARM                    DDLCCD
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Location Code - OK
     C                   PARM                    DDLCCDOK
      *
      * Update error info with that returned from the validation module

     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VCCNCZ - Validate Country of Citizenship
      *****************************************************************
     C     VCCNCZ        BEGSR

      * Reset variables updated by each module

     C                   EXSR      RESETERRS
      *
      ** Validate country of citizenship
      *
     C                   CALLB     'SDVCNCZ'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeOut
      *
      ** Country of Citizenship (2A)
     C     CUCNCZ        PARM                    DDCNCZ
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Country of Citizenship - OK
     C                   PARM                    DDCNCZOK
      *
      * Update error info with that returned from the validation module

     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT                                                                                  CGL132
      *****************************************************************                       CGL132
      ** VCDRMT - Validate Dormant Indicator                                                  CGL132
      *****************************************************************                       CGL132
     C     VCDRMT        BEGSR                                                                CGL132
                                                                                              CGL132
      * Reset variables updated by each module                                                CGL132
                                                                                              CGL132
     C                   EXSR      RESETERRS                                                  CGL132
      *                                                                                       CGL132
      ** Validate Dormant Indicator                                                           CGL132
      *                                                                                       CGL132
     C                   IF        DDDRMT = *BLANKS                                         MD028337
     C                   EVAL      DDDRMT = 'N'                                             MD028337
     C                   ENDIF                                                              MD028337
      *                                                                                     MD028337
     C                   IF        DDDRMT <> 'Y' and DDDRMT <> 'N'                            CGL132
     C                   EVAL      DDDRMTOK = 'N'                                             CGL132
     C                   EVAL      FldNamXAr(1) = 'DDDRMT'                                    CGL132
     C                   EVAL      MsgIDXAr(1)  = 'USS0317'                                   CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
     C                   EVAL      XCDRMT = DDDRMT                                            CGL132
      *                                                                                       CGL132
      * Update error info with that returned from the validation module                       CGL132
                                                                                              CGL132
     C                   EXSR      UPDATERRS                                                  CGL132
      *                                                                                       CGL132
     C                   ENDSR                                                                CGL132
      *****************************************************************                       CGL132
     C/EJECT
      *****************************************************************                       CGL132
      ** VCACCZ - Validate Alternative Country of Citizenship                                 CGL132
      *****************************************************************                       CGL132
     C     VCACCZ        BEGSR                                                                CGL132
                                                                                              CGL132
      * Reset variables updated by each module                                                CGL132
                                                                                              CGL132
     C                   EXSR      RESETERRS                                                  CGL132
      *                                                                                       CGL132
      ** Validate country of citizenship                                                      CGL132
      *                                                                                       CGL132
     C                   CALLB     'SDVACCZ'                                                  CGL132
      *                                                                                       CGL132
      * INPUTS                                                                                CGL132
      *                                                                                       CGL132
      ** Return Code                                                                          CGL132
     C                   PARM                    RetCodeOut                                   CGL132
      *                                                                                       CGL132
      ** Country of Citizenship (2A)                                                          CGL132
     C     XCACCZ        PARM                    DDACCZ                                       CGL132
      *                                                                                       CGL132
      ** Country of Citizenship (2A)                                                          CGL132
     C     CUCNCZ        PARM                    DDCNCZ                                       CGL132
      *                                                                                       CGL132
      * OUTPUTS                                                                               CGL132
      *                                                                                       CGL132
      * Error fields/message IDs/message data (arrays) from/to caller                         CGL132
     C                   PARM                    FldNamXAr                                    CGL132
     C                   PARM                    MsgIDXAr                                     CGL132
     C                   PARM                    MsgDtaXAr                                    CGL132
      *                                                                                       CGL132
      ** Country of Citizenship - OK                                                          CGL132
     C                   PARM                    DDACCZOK                                     CGL132
      *                                                                                       CGL132
      * Update error info with that returned from the validation module                       CGL132
                                                                                              CGL132
     C                   EXSR      UPDATERRS                                                  CGL132
      *                                                                                       CGL132
     C                   ENDSR                                                                CGL132
      *****************************************************************                       CGL132
     C/EJECT                                                                                  CGL132
      *****************************************************************                       CGL132
      ** VCCRDT - Validate Creation Date                                                      CGL132
      *****************************************************************                       CGL132
     C     VCCRDT        BEGSR                                                                CGL132
                                                                                              CGL132
      * Reset variables updated by each module                                                CGL132
                                                                                              CGL132
     C                   EXSR      RESETERRS                                                  CGL132
      *                                                                                       CGL132
      ** Validate Creation Date                                                               CGL132
      *                                                                                       CGL132
     C                   CALLB     'SDVCRDT'                                                  CGL132
      *                                                                                       CGL132
      * INPUTS                                                                                CGL132
      *                                                                                       CGL132
      ** Return Code                                                                          CGL132
     C                   PARM                    RetCodeOut                                   CGL132
      *                                                                                       CGL132
      ** Creation Date (2A)                                                                   CGL132
     C                   PARM                    DDCRDT                                       CGL132
      ** Customer Number (6A)                                                                 CGL132
     C                   PARM                    DDCUSN                                       CGL132
      ** Action Code (1A)                                                                     CGL132
     C                   PARM                    DDACTN                                       CGL132
      ** Run Day Number and Date Format Indicator                                             CGL132
     C                   PARM                    WRunDay                                      CGL132
     C                   PARM                    BJDFIN                                       CGL132
      *                                                                                       CGL132
      * OUTPUTS                                                                               CGL132
      *                                                                                       CGL132
      * Error fields/message IDs/message data (arrays) from/to caller                         CGL132
     C                   PARM                    FldNamXAr                                    CGL132
     C                   PARM                    MsgIDXAr                                     CGL132
     C                   PARM                    MsgDtaXAr                                    CGL132
      *                                                                                       CGL132
      ** Creation Date - OK                                                                   CGL132
     C                   PARM                    DDCRDTOK                                     CGL132
      *                                                                                       CGL132
      ** Creation Date Numeric (5,0)                                                          CGL132
      *                                                                                       CGL132
     C                   PARM                    XCCRDT            5 0                        CGL132
      *                                                                                       CGL132
      * Update error info with that returned from the validation module                       CGL132
                                                                                              CGL132
     C                   EXSR      UPDATERRS                                                  CGL132
      *                                                                                       CGL132
     C                   ENDSR                                                                CGL132
      *****************************************************************                       CGL132
     C/EJECT                                                                                  CGL132
      *****************************************************************
      ** VCCOLC - Validate Country of Domicile
      *****************************************************************
     C     VCCOLC        BEGSR

      * Reset variables updated by each module

     C                   EXSR      RESETERRS
      *
      ** Validate country of domicile
      *
     C                   CALLB     'SDVCNDI'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeOut
      *
      ** Country of Domicile (2A)
     C     CUCOLC        PARM                    DDCOLC
      *                                                                                     BUG25531
      ** Customer Number                                                                    BUG25531
     C                   PARM                    DDCUSN                                     BUG25531
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Country of Domicile - OK
     C                   PARM                    DDCOLCOK
      *
      * Update error info with that returned from the validation module

     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VCLINC - Validate Local Institution Code
      *****************************************************************
     C     VCLINC        BEGSR

      * Reset variables updated by each module

     C                   EXSR      RESETERRS
      *
      ** Validate local institution code
      *
     C                   CALLB     'SDVLCDE'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeOut
      *
      ** Local Institution Code (2A)
     C     CULINC        PARM                    DDLINC
      *                                                                                       CSD099
      ** Action Code (1A)                                                                     CSD099
     C                   PARM                    DDACTN                                       CSD099
     C                   PARM                    CSD094                                       CSD094
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *                                                                                       CSD099
      * Warning Error fields/message IDs/message data (arrays) from/to caller                 CSD099
     C                   PARM                    WFldNmXAr                                    CSD099
     C                   PARM                    WMsgIDXAr                                    CSD099
     C                   PARM                    WMsgDtXAr                                    CSD099
      *
      ** Local Institution Code - OK
     C                   PARM                    DDLINCOK
      *
      * Update error info with that returned from the validation module
      * For a TI account Institution Code is now mandatory.                                  BUG3605
      *                                                                                      BUG3605
     C     BGN3ST        IFEQ      'Y'                                                       BUG3605
     C     CTI006        OREQ      'Y'                                                      MD030956
     C     CUTICS        IFEQ      'Y'                                                       BUG3605
     C     DDLINC        ANDEQ     *BLANK                                                    BUG3605
     C                   MOVE      'N'           DDLINCOK                                    BUG3605
     C                   ADD       1             Idx                                         BUG3605
     C                   MOVEL     'DDLINC'      FldNamXAr(Idx)                              BUG3605
     C                   MOVEL     'USR0034'     MsgIdXAr(Idx)                               BUG3605
     C                   ENDIF                                                               BUG3605
     C                   ENDIF                                                               BUG3605

     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VCLICD - Local Industry Code
      *****************************************************************
     C     VCLICD        BEGSR

      * Reset variables updated by each module

     C                   EXSR      RESETERRS
      *
      ** Validate local industry code
      *
     C                   CALLB     'SDVLCCD02'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeOut
      *
      ** Local Industry Code (3A)
     C     CULICD        PARM                    DDLICD
     C                   PARM                    CSD094                                       CSD094
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Local Industry Code - OK
     C                   PARM                    DDLICDOK
      *
      * Update error info with that returned from the validation module

     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VCRWCD - Risk Weighting Code
      *****************************************************************
     C     VCRWCD        BEGSR

      * Reset variables updated by each module

     C                   EXSR      RESETERRS
      *
      ** Validate risk weighting code
      *
     C                   CALLB     'SDVRKCD'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeOut
      *
      ** Risk Weighting Code (4A)
     C     CURWCD        PARM                    DDRWCD
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Risk Weighting Code - OK
     C                   PARM                    DDRWCDOK
      *
      * Update error info with that returned from the validation module

     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VCCSSN - Validate Customer Shortname
      *****************************************************************
     C     VCCSSN        BEGSR

      * Reset variables updated by each module

     C                   EXSR      RESETERRS
      *
      ** Validate customer shortname
      *
     C                   CALLB     'SDVCSSH'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeOut
      *
      ** Action Code (1A)
      ** Use DRS Shortnames (1A)
      ** Trade Innovation (1A)
      ** DRS Customer Shortname (7A)
      ** Location Code (3A)
      ** Customer Shortname (10A)
      ** Customer Number (6A)
     C                   PARM                    DDACTN
     C                   PARM                    BGUDRS
     C                   PARM                    BGN3ST
     C     CUDRCS        PARM                    DDDRCS
     C     CULCCD        PARM                    DDLCCD
     C     CUCSSN        PARM                    DDCSSN
     C                   PARM                    DDCUSN
     C                   PARM                    CTI006                                     MD030956
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Customer shortname - OK
     C                   PARM                    DDCSSNOK
      *
      ** DRS Customer shortname - OK
     C                   PARM                    DDDRCSOK
      *
      ** Location Code - OK
     C                   PARM                    DDLCCDOK
      *
      * Update error info with that returned from the validation module

     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VCACOC - Validate Account Officer
      *****************************************************************
     C     VCACOC        BEGSR

      * Reset variables updated by each module

     C                   EXSR      RESETERRS
      *
      ** Validate account officer
      *
     C                   CALLB     'SDVACOF'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeOut
      *
      ** Account Officer (2A)
      ** Customer Number (6A)
      ** Portfolio Management (1A)
      *
     C     CUACOC        PARM                    DDACOC
     C                   PARM                    DDCUSN
     C                   PARM                    BGPFMG
      *
      /COPY WNCPYSRC,HUT113_109                                                    HUT113
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Account Officer - OK
     C                   PARM                    DDACOCOK
      *
      * Update error info with that returned from the validation module

     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VCPIPN - Validate Parent Indicator and Parent Number
      *****************************************************************
     C     VCPIPN        BEGSR

      * Reset variables updated by each module

     C                   EXSR      RESETERRS
      *
      ** Validate Parent Indicator and Parent Number
      *
     C                   CALLB     'SDVPAIN'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeOut
      *
      ** Action Code (1A)
      ** Parent Indicator (1A)
      ** Parent Customer Number (6A)
      ** Customer Number (6A)
      ** Runday Number (5,0)
      ** Portfolio Lending (1A)
      *
     C                   PARM                    DDACTN
     C     CUPAIN        PARM                    DDPAIN
     C     CUPCNB        PARM                    DDPCNB
     C                   PARM                    DDCUSN
     C**********         PARM                    BJRDNB                                       CSC011
     C                   PARM                    WRunDay                                      CSC011
     C                   PARM                    BGLMCR
     C                   PARM                    CUTICS                                     TI010338
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Parent Indicator - OK
     C                   PARM                    DDPAINOK
      *
      ** Parent Number - OK
     C                   PARM                    DDPCNBOK
      *
      * Update error info with that returned from the validation module

     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VCSSDT - Validate Suspended Date
      *****************************************************************
     C     VCSSDT        BEGSR

      * Reset variables updated by each module

     C                   EXSR      RESETERRS
      *
      ** Validate suspended date
      *
     C                   CALLB     'SDVSUDT'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeOut
      *
      ** Suspended Date Alpha (6A)
      ** Midas Run Date (5,0)
      ** Midas Date Format Indicator (1A)
      ** Action Code (1)
     C                   PARM                    DDSDAL
     C**********         PARM                    BJRDNB                                       CSC011
     C                   PARM                    WRunDay                                      CSC011
     C                   PARM                    BJDFIN
     C                   PARM                    DDACTN
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Suspended Date - OK
     C                   PARM                    DDSSDTOK
      *
      ** Suspended Date Numeric (6,0)
     C                   PARM                    CUSSDT
      *
      * Update error info with that returned from the validation module
      *
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VCDOIC - Validate First Contact Date
      *****************************************************************
     C     VCDOIC        BEGSR

      * Reset variables updated by each module

     C                   EXSR      RESETERRS
      *
      ** Validate first contact date
      *
     C                   CALLB     'SDVDTDE'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeOut
      *
      ** First Contact Date Alpha (6A)
      ** Suspended Date Alpha (6A)
      ** Suspended Date Numeric (5,0)
      ** Midas Run Date (5,0)
      ** Midas Date Format Indicator (1A)
     C                   PARM                    DDFCAL
     C                   PARM                    DDSDAL
     C                   PARM                    CUSSDT
     C**********         PARM                    BJRDNB                                       CSC011
     C                   PARM                    WRunDay                                      CSC011
     C                   PARM                    BJDFIN
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** First Contact Date - OK
     C                   PARM                    DDDOICOK
      *
      ** Suspended Date - OK
     C                   PARM                    DDSSDTOK
      *
      ** First Contact Date Numeric (6,0)
     C                   PARM                    CUDOIC
      *
      * Update error info with that returned from the validation module
      *
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VCBNBI - Validate Bank/Non-bank Indicator
      *****************************************************************
     C     VCBNBI        BEGSR

      * Reset variables updated by each module

     C                   EXSR      RESETERRS
      *
      ** Validate bank/non-bank indicator
      *
     C                   CALLB     'SDVBAIN'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeOut
      *
      ** Bank/Non-Bank Indicator (1A)
     C     CUBNBI        PARM                    DDBNBI
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Bank/Non-Bank Indicator - OK
     C                   PARM                    DDBNBIOK
      *
      * Update error info with that returned from the validation module

     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VCCGRP - Validate Retail Customer Group
      *****************************************************************
     C     VCCGRP        BEGSR

      * Reset variables updated by each module

     C                   EXSR      RESETERRS
      *
      ** Validate retail customer group
      *
     C                   CALLB     'SDVRLCS'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeOut
      *
      ** Retail Customer Group (1A)
      ** Retail 3 (1A)
     C     CUCGRP        PARM                    DDCGRP
     C                   PARM                    BGNXST
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Retail Customer Group - OK
     C                   PARM                    DDCGRPOK
      *
      * Update error info with that returned from the validation module
      *
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VCTNBI - Validate tax/non-tax indicator and branch indicator
      *****************************************************************
     C     VCTNBI        BEGSR

      * Reset variables updated by each module

     C                   EXSR      RESETERRS
      *
      ** Validate tax/non-tax indicator and branch indicator
      *
     C                   CALLB     'SDVBHIN'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeOut
      *
      ** Base Rate Tax Indicator, Switchable Feature S01383 (1A)
      ** Tax/Non-tax Indicator (1A)
      ** Branch Indicator (1A)
      ** Bank/Non-Bank Indicator (1A)
      ** Country of Location (2A)                                                             CRE007
      ** Customer Type (1A)                                                                   CDL013
      *
     C                   PARM                    S01383
     C     CUTAIN        PARM                    DDTAIN
     C     CUBSIN        PARM                    DDBSIN
     C                   PARM                    DDBNBI
     C                   PARM                    DDCOLC                                       CRE007
     C     CUCSTY        PARM                    DDCSTY                                       CDL013
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *                                                                                       CRE007
      ** Warning fields/message IDs/message data (arrays) from/to caller                      CRE007
      *                                                                                       CRE007
     C                   PARM                    WFldNmXAr                                    CRE007
     C                   PARM                    WMsgIDXAr                                    CRE007
     C                   PARM                    WMsgDtXAr                                    CRE007
      *
      ** Tax/non-tax indicator - OK
     C                   PARM                    DDTAINOK
      *
      ** Branch Indicator - OK
     C                   PARM                    DDBSINOK
      *                                                                                       CDL013
      ** Customer Type  - OK                                                                  CDL013
     C                   PARM                    DDCSTYOK          1                          CDL013
      *
      * Update error info with that returned from the validation module

     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VCCDEL - Validate Allow COB Deletion
      *****************************************************************
     C     VCCDEL        BEGSR

      * Reset variables updated by each module

     C                   EXSR      RESETERRS
      *
      ** Validate allow COB deletion
      *
     C                   CALLB     'SDVCBCB'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeOut
      *
      ** Allow COB Deletion
      ** S01424 Allow COB Deletion Switchable Feature
     C     CUCDEL        PARM                    DDCDEL
     C                   PARM                    DDACTN                         CPB002
     C                   PARM                    S01424
     C                   PARM                    BGN4ST                         CPB002
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Allow COB Deletion - OK
     C                   PARM                    DDCDELOK
      *
      * Update error info with that returned from the validation module

     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VCMCAC - Validate MA Analysis by Associated Customer
      *****************************************************************
     C     VCMCAC        BEGSR

      * Reset variables updated by each module

     C                   EXSR      RESETERRS
      *
      ** Validate MA analysis by associated customer
      *
     C                   CALLB     'SDVPFDE'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeOut
      *
      ** MA Analysis by Assoc.
      ** Management Accounts
     C     CUMCAC        PARM                    DDMCAC
     C                   PARM                    BGNVST
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** MA Analysis by Assoc.
     C                   PARM                    DDMCACOK
      *
      * Update error info with that returned from the validation module

     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VCMTSC - Validate Margin Type
      *****************************************************************
     C     VCMTSC        BEGSR

      * Reset variables updated by each module

     C                   EXSR      RESETERRS
      *
      ** Validate margin type
      *
     C                   CALLB     'SDVMGTY'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeOut
      *
      ** Customer Margins Switchable Feature (1A)
      ** Bank/Non-bank Indicator (1A)
      ** Margin Type Alpha (2A)
      *
     C                   PARM                    CDL001
     C                   PARM                    DDBNBI
     C                   PARM                    DDMTSC
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Margin type - OK
     C                   PARM                    DDMTSCOK
      *
      ** Margin Type Numeric (2,0)
     C                   PARM                    CUMGTP
      *
      * Update error info with that returned from the validation module

     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ***VCDINC*-*Validate*Designated*In-Currency**********************                      BUG5450
      *****************************************************************
     C*****VCDINC        BEGSR                                                               BUG5450

      **Reset*variables*updated*by*each*module*************************                      BUG5450

     C**********         EXSR      RESETERRS                                                 BUG5450
      *
      ***Validate*designated*in-currency*******************************                      BUG5450
      *
     C**********         CALLB     'SDVINCY'                                                 BUG5450
      *
      **INPUTS*********************************************************                      BUG5450
      *
      ***Return*Code***************************************************                      BUG5450
     C**********         PARM                    RetCodeOut                                  BUG5450
      *
      ***Designated*in-currency*(3A)***********************************                      BUG5450
     C*****CUDINC        PARM                    DDDINC                                      BUG5450
      *
      **OUTPUTS********************************************************                      BUG5450
      *
      **Error*fields/message*IDs/message*data*(arrays)*from/to*caller**                      BUG5450
     C**********         PARM                    FldNamXAr                                   BUG5450
     C**********         PARM                    MsgIDXAr                                    BUG5450
     C**********         PARM                    MsgDtaXAr                                   BUG5450
      *
      ***Designated*in-currency**-*OK**********************************                      BUG5450
     C**********         PARM                    DDDINCOK                                    BUG5450
      *
      **Update*error*info*with*that*returned*from*the*validation*module                      BUG5450

     C**********         EXSR      UPDATERRS                                                 BUG5450
      *
     C**********         ENDSR                                                               BUG5450
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** Validate Private Banking Customer
      *****************************************************************
     C     VCPRBA        BEGSR

      * Reset variables updated by validation

     C                   EXSR      RESETERRS
      *
      ** Call Validation Module
      *
     C                   CALLB     'SDVPBIN'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeIn
      *
      ** Other parms
      *
      ** Private Banking Customer
     C     CUPRBA        PARM                    DDPRBA
      *
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Valid Private Banking Customer Indicator - OK
     C                   PARM                    DDPRBAOK
      *
      * Update error info with that returned from validation

     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
      /EJECT                                                                                  CLE025
      *****************************************************************                       CLE025
      ** Validate Facility Mandatory & Include Offsets flags                                  CLE025
      *****************************************************************                       CLE025
     C     VCFMIO        BEGSR                                                                CLE025
                                                                                              CLE025
      ** Reset variables updated by validation                                                CLE025
                                                                                              CLE025
     C                   EXSR      RESETERRS                                                  CLE025
                                                                                              CLE025
      ** Call Validation module                                                               CLE025
                                                                                              CLE025
     C                   CALLB     'SDVCOLL'                                                  CLE025
                                                                                              CLE025
      ** INPUTS                                                                               CLE025
      ** Return code                                                                          CLE025
      ** Facility Mandatory                                                                   CLE025
      ** Include Offsets                                                                      CLE025
      ** FX Margin Type                                                                       CLE025
      ** Include Offsets in Pre-deal check                                                    CLE025
                                                                                              CLE025
     C                   PARM                    RetCodeIn                                    CLE025
     C     CUFCMF        PARM                    DDFCMF                                       CLE025
     C     CUINOF        PARM                    DDINOF                                       CLE025
     C     CUMSTF        PARM                    DDMSTF                                       CLE025
     C     CUIOPC        PARM                    DDIOPC                                       CLE025
                                                                                              CLE025
      ** Switchable features                                                                  CLE025
                                                                                              CLE025
     C                   PARM                    CLE025                                       CLE025
     C                   PARM                    CFX001                                       CFX001
                                                                                              CLE025
      ** OUTPUTS                                                                              CLE025
      ** Error fields/message IDs/message data (arrays) from/to caller                        CLE025
      ** Facility Mandatory OK flag                                                           CLE025
      ** Include Offsets OK flag                                                              CLE025
      ** FX Margin Tyoe OK flag                                                               CLE025
                                                                                              CLE025
     C                   PARM                    FldNamXAr                                    CLE025
     C                   PARM                    MsgIDXAr                                     CLE025
     C                   PARM                    MsgDtaXAr                                    CLE025
     C                   PARM                    DDFCMFOK                                     CLE025
     C                   PARM                    DDINOFOK                                     CLE025
     C                   PARM                    DDMSTFOK                                     CLE025
     C                   PARM                    DDIOPCOK                                     CLE025
                                                                                              CLE025
      ** Update error info with that returned from validation                                 CLE025
                                                                                              CLE025
     C                   EXSR      UPDATERRS                                                  CLE025
                                                                                              CLE025
     C                   ENDSR                                                                CLE025
      *****************************************************************                       CSW207
      /EJECT                                                                                  CSW207
      *****************************************************************                       CSW207
      *                                                                                       CSW207
      * SRVCLLS - Validate Investor Capacity Indicator Subroutine     *                       CSW207
      *                                                               *                       CSW207
      *****************************************************************                       CSW207
     C     SRVCLLS       BEGSR                                                                CSW207
                                                                                              CSW207
      * Reset variables updated by each module                                                CSW207
                                                                                              CSW207
     C                   EXSR      RESETERRS                                                  CSW207
      *                                                                                       CSW207
      **  Validate Investor Capacity Indicator                                                CSW207
      *                                                                                       CSW207
     C                   CALLB     'SDVCLLS'                                                  CSW207
     C                   PARM                    RetCodeOut                                   CSW207
     C     CUCICI        PARM                    DDCICI                                       CSW207
     C                   PARM                    BGN4ST                                     BUG14927
     C                   PARM                    FldNamXAr                                    CSW207
     C                   PARM                    MsgIDXAr                                     CSW207
     C                   PARM                    MsgDtaXAr                                    CSW207
     C                   PARM                    DDCICIOK                                     CSW207
      *                                                                                       CSW207
      * Update error info with that returned from the validation module                       CSW207
                                                                                              CSW207
     C                   EXSR      UPDATERRS                                                  CSW207
      *                                                                                       CSW207
     C                   ENDSR                                                                CSW207
      *****************************************************************                       CSW207
      /EJECT                                                                                  CSW207
      *****************************************************************                       CSW207
      *                                                               *                       CSW207
      * SRVCPCI - Validate Party Capacity Indicator Subroutine        *                       CSW207
      *                                                               *                       CSW207
      *****************************************************************                       CSW207
     C     SRVCPCI       BEGSR                                                                CSW207
                                                                                              CSW207
      * Reset variables updated by each module                                                CSW207
                                                                                              CSW207
     C                   EXSR      RESETERRS                                                  CSW207
      *                                                                                       CSW207
      **  Validate Party Capacity Indicator                                                   CSW207
      *                                                                                       CSW207
     C                   CALLB     'SDVCPCI'                                                  CSW207
     C                   PARM                    RetCodeOut                                   CSW207
     C     CUCPCI        PARM                    DDCPCI                                       CSW207
     C                   PARM                    FldNamXAr                                    CSW207
     C                   PARM                    MsgIDXAr                                     CSW207
     C                   PARM                    MsgDtaXAr                                    CSW207
     C                   PARM                    DDCPCIOK                                     CSW207
      *                                                                                       CSW207
      * Update error info with that returned from the validation module                       CSW207
                                                                                              CSW207
     C                   EXSR      UPDATERRS                                                  CSW207
      *                                                                                       CSW207
     C                   ENDSR                                                                CSW207
      *                                                                                       CSW207
      *****************************************************************                       CLE025
     C/EJECT
      *****************************************************************
      * RESETERRS - Reset error information that is received back     *
      *    from each validation module.                               *
      *****************************************************************
     C     RESETERRS     BEGSR

     C                   EVAL      RetCodeOut = *Blanks
      *
      * Reset error & warning fields/message IDs/message data (arrays)
     C                   MOVEL     *BLANK        FldNamXAr
     C                   MOVEL     *BLANK        MsgIDXAr
     C                   MOVEL     *BLANK        MsgDtaXAr
     C                   MOVEL     *BLANK        WFldNmXAr
     C                   MOVEL     *BLANK        WMsgIDXAr
     C                   MOVEL     *BLANK        WMsgDtXAr

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * UPDATERRS - Update error information with that received back  *
      *    from each validation module.                               *
      *****************************************************************
     C     UPDATERRS     BEGSR
      *
      * Update error fields/message IDs/message data (arrays)
      *
     C                   Z-ADD     1             I                 3 0
     C     *BLANK        LOOKUP    FldNameArr(I)                          99
     C     *IN99         IFEQ      '1'
     C                   MOVEA     FldNamXAr     FlDNameArr(I)
     C                   MOVEA     MsgIDXAr      MsgIdArr(I)
     C                   MOVEA     MsgDtaXAr     MsgDtaArr(I)
     C                   END
      *
      * Set Error Index
     C                   Z-ADD     1             I
     C     *BLANK        LOOKUP    FldNameArr(I)                          99
     C     I             SUB       1             Idx
      *
      * Update warning fields/message IDs/message data (arrays)
      *
     C                   Z-ADD     1             I
     C     *BLANK        LOOKUP    WFldNamArr(I)                          99
     C     *IN99         IFEQ      '1'
     C                   MOVEA     WFldNmXAr     WFldNamArr(I)
     C                   MOVEA     WMsgIDXAr     WMsgIDArr(I)
     C                   MOVEA     WMsgDtXAr     WMsgDtaArr(I)
     C                   END
      *
      * Set Warning Index
     C                   Z-ADD     1             I
     C     *BLANK        LOOKUP    WFldNamArr(I)                          99
     C     I             SUB       1             WIdx
      *
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

      * INPUTS

      * Response mode
     C                   PARM                    RespMode          1

      ** Customer Primary Details
     C                   PARM                    CuPrim
     C                   PARM                    CuXC                                         CGL132
     C                   PARM                    ExtData
      ** Switchable features                                                                  CLE025
     C                   PARM                    CLE025                                       CLE025
     C                   PARM                    CFX001                                       CFX001
     C**********         PARM                    CGL132                            MD034317 MD042407
      ** Customer SWIFT Extension                                                             CSW207
     C                   PARM                    CuSwft                                       CSW207

      * OUTPUTS

      ** Customer Primary Details OK inds
     C                   PARM                    OKCuPrim
     C                   PARM                    OKCuXC                                       CGL132

      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    Idx

      * Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr

      * Array index (3P0) from/to caller
     C                   PARM                    WIdx

      * Valid Customer details layout (DS) from/to caller
      ** Valid Global Customer ID                                                             CGP001
                                                                                              CGP001
     C                   PARM                    ValidCusd
      * Valid Customer ext details layout (DS) from/to caller                                 CGL132
     C                   PARM                    ValidCuXc                                    CGL132
     C                   PARM                    V_DDGCUS                                     CGP001
      ** Customer SWIFT Details OK inds                                                       CSW207
     C                   PARM                    OKCuSwft                                     CSW207
      * Valid Customer SWIFT Details  (DS) from/to caller                                     CSW207
     C                   PARM                    ValidSwft                                    CSW207
      *
      ** GET MODULE DETAILS
      *
     C                   CALL      'AOMMODR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST'      @OPTN
     C     SDMMOD        PARM      SDMMOD        DSFDY
      *
      ** DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     '*FIRST '     DBKEY
     C                   MOVEL     'SDMMODPD'    DBFILE
     C                   MOVEL     '901'         DBASE
     C                   EXSR      SRERR
     C                   END
      *
      ** ACCESS BANK DETAILS
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     '901'         DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   END
      *
      ** Check if switchable feature S01383 is switched on.
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'S01383'      @SARD             6
      *
      ** DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF   '
     C                   MOVEL     'S01383'      DBKEY
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   MOVEL     '900'         DBASE
     C                   EXSR      SRERR
     C                   END
     C     @RTCD         IFEQ      *BLANK
     C                   MOVE      'Y'           S01383            1
     C                   ELSE
     C                   MOVE      'N'           S01383
     C                   END
      *
      ** Check if switchable feature S01424 is switched on.
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'S01424'      @SARD
      *
      ** DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF   '
     C                   MOVEL     'S01424'      DBKEY
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   MOVEL     '901'         DBASE
     C                   EXSR      SRERR
     C                   END
     C     @RTCD         IFEQ      *BLANK
     C                   MOVE      'Y'           S01424            1
     C                   ELSE
     C                   MOVE      'N'           S01424
     C                   END
      *
      ** Check if switchable feature CDL001 is switched on.
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CDL001'      @SARD
      *
      ** DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF   '
     C                   MOVEL     'CDL001'      DBKEY
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   MOVEL     '902'         DBASE
     C                   EXSR      SRERR
     C                   END
     C     @RTCD         IFEQ      *BLANK
     C                   MOVE      'Y'           CDL001            1
     C                   ELSE
     C                   MOVE      'N'           CDL001
     C                   END
                                                                                              CSC011
     C                   EVAL      WRunDay = BJRDNB                                           CSC011
                                                                                              CSC011
      ** Check if switchable feature CSC011 is switched on.                                   CSC011
                                                                                              CSC011
     C                   EVAL      CSC011 = 'N'                                               CSC011
                                                                                              CSC011
     C                   CALL      'AOSARDR0'                                                 CSC011
     C                   PARM      *BLANKS       PRtCd                                        CSC011
     C                   PARM      '*VERIFY'     POptn                                        CSC011
     C                   PARM      'CSC011'      PSard                                        CSC011
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSC011
                                                                                              CSC011
      ** Database error                                                                       CSC011
                                                                                              CSC011
     C                   IF        (PRtCd <> *BLANKS) and                                     CSC011
     C                             (PRtCd <> '*NRF   ')                                       CSC011
     C                   EVAL      DBKEY = 'CSC011'                                           CSC011
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSC011
     C                   EVAL      DBASE = 903                                                CSC011
     C                   EXSR      SRERR                                                      CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   IF        PRtCd = *BLANKS                                            CSC011
     C                   EVAL      CSC011 = 'Y'                                               CSC011
     C                   IN        SDSTAT                                                     CSC011
     C                   IN        SC24X7                                                     CSC011
     C                   IF        LIBR = S1SUPP                                              CSC011
     C                   EVAL      WRunDay = S1DATE                                           CSC011
     C                   ENDIF                                                                CSC011
     C                   ENDIF                                                                CSC011
      *                                                                                       CDL013
      ** Access SAR details file to determine if CDL013                                       CDL013
      ** Tiered withholding tax is on.                                                        CDL013
      *                                                                                       CDL013
     C                   CALLB     'AOSARDR0'                                                 CDL013
     C                   PARM      *BLANKS       @RTCD             7                          CDL013
     C                   PARM      '*VERIFY'     @OPTN             7                          CDL013
     C                   PARM      'CDL013'      @SARD             6                          CDL013
     C     SCSARD        PARM      SCSARD        DSFDY                                        CDL013
      *                                                                                       CDL013
     C     @RTCD         IFEQ      *BLANKS                                                    CDL013
     C                   MOVE      'Y'           CDL013            1                          CDL013
     C                   ELSE                                                                 CDL013
     C                   MOVE      'N'           CDL013                                       CDL013
     C                   ENDIF                                                                CDL013
                                                                                              CGP001
      ** Check if Global Data Layout Enhancement (CGP001) is on.                              CGP001
                                                                                              CGP001
     C                   EVAL      CGP001 = 'N'                                               CGP001
                                                                                              CGP001
     C                   CALLB     'AOSARDR0'                                                 CGP001
     C                   PARM      *BLANKS       PRtCd                                        CGP001
     C                   PARM      '*VERIFY'     POptn                                        CGP001
     C                   PARM      'CGP001'      PSard                                        CGP001
     C     SCSARD        PARM      SCSARD        DSFDY                                        CGP001
                                                                                              CGP001
     C                   IF        PRtCd = *BLANKS                                            CGP001
     C                   EVAL      CGP001 = 'Y'                                               CGP001
     C                   ENDIF                                                                CGP001
                                                                                              CGP001
     C                   IF        PRtCd <> *BLANKS and                                       CGP001
     C                             PRtCd <> '*NRF   '                                         CGP001
     C                   EVAL      DBFILE= 'SCSARDPD'                                         CGP001
     C                   EVAL      DBKEY = 'CGP001'                                           CGP001
     C                   EVAL      DBASE = 904                                                CGP001
     C                   EXSR      SRERR                                                      CGP001
     C                   ENDIF                                                                CGP001
      *
                                                                                              CSD025
      ** Check if Customer De-Activation (CSD025) is on.                                      CSD025
                                                                                              CSD025
     C                   EVAL      CSD025 = 'N'                                               CSD025
                                                                                              CSD025
     C                   CALLB     'AOSARDR0'                                                 CSD025
     C                   PARM      *BLANKS       PRtCd                                        CSD025
     C                   PARM      '*VERIFY'     POptn                                        CSD025
     C                   PARM      'CSD025'      PSard                                        CSD025
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD025
                                                                                              CSD025
     C                   IF        PRtCd = *BLANKS                                            CSD025
     C                   EVAL      CSD025 = 'Y'                                               CSD025
     C                   ENDIF                                                                CSD025
                                                                                              CSD025
     C                   IF        PRtCd <> *BLANKS and                                       CSD025
     C                             PRtCd <> '*NRF   '                                         CSD025
     C                   EVAL      DBFILE= 'SCSARDPD'                                         CSD025
     C                   EVAL      DBKEY = 'CSD025'                                           CSD025
     C                   EVAL      DBASE = 910                                                CSD025
     C                   EXSR      SRERR                                                      CSD025
     C                   ENDIF                                                                CSD025
      *                                                                                     MD030956
      ** Check if feature CTI006 is switched on.                                            MD030956
      *                                                                                     MD030956
     C                   CALLB     'AOSARDR0'                                               MD030956
     C                   PARM      *BLANKS       PRtCd                                      MD030956
     C                   PARM      '*VERIFY'     POptn                                      MD030956
     C                   PARM      'CTI006'      PSard                                      MD030956
     C     SCSARD        PARM      SCSARD        DSFDY                                      MD030956
                                                                                            MD030956
     C                   IF        PRtCd  <> *BLANKS AND                                    MD030956
     C                             PRtCd  <> '*NRF   '                                      MD030956
     C                   EVAL      DBFILE = 'SCSARDPD'                                      MD030956
     C                   EVAL      DBKEY  = 'CTI006'                                        MD030956
     C                   EVAL      DBASE  = 911                                             MD030956
     C                   EXSR      SRERR                                                    MD030956
     C                   ENDIF                                                              MD030956
      *                                                                                     MD030956
     C                   IF        PRtCd  = *BLANKS                                         MD030956
     C                   EVAL      CTI006 = 'Y'                                             MD030956
     C                   ELSE                                                               MD030956
     C                   EVAL      CTI006 = 'N'                                             MD030956
     C                   ENDIF                                                              MD030956
                                                                                              CSD094
      ** Check if feature CSD094 is switched on.                                              CSD094
                                                                                              CSD094
     C                   CALLB     'AOSARDR0'                                                 CSD094
     C                   PARM      *BLANKS       PRtCd                                        CSD094
     C                   PARM      '*VERIFY'     POptn                                        CSD094
     C                   PARM      'CSD094'      PSard                                        CSD094
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD094
                                                                                              CSD094
     C                   IF        PRtCd  <> *BLANKS AND                                      CSD094
     C                             PRtCd  <> '*NRF   '                                        CSD094
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSD094
     C                   EVAL      DBKEY  = 'CSD094'                                          CSD094
     C                   EVAL      DBASE  = 912                                               CSD094
     C                   EXSR      SRERR                                                      CSD094
     C                   ENDIF                                                                CSD094
      *                                                                                       CSD094
     C                   IF        PRtCd  = *BLANKS                                           CSD094
     C                   EVAL      CSD094 = 'Y'                                               CSD094
     C                   ELSE                                                                 CSD094
     C                   EVAL      CSD094 = 'N'                                               CSD094
     C                   ENDIF                                                                CSD094

      ** Check if SWIFT 2007 is installed                                                     CSW207
                                                                                              CSW207
     C                   CALL      'SWIF2007'                                                 CSW207
     C                   PARM      *BLANKS       PRtCd                                        CSW207
                                                                                              CSW207
     C                   IF        PRtCd   = 'CSW2007'                                        CSW207
     C                   EVAL      CSW207 = 'Y'                                               CSW207
     C                   ELSE                                                                 CSW207
     C                   EVAL      CSW207 = 'N'                                               CSW207
     C                   ENDIF                                                                CSW207
                                                                                              CSW207
      *                                                                                     MD051247
      ** Check if Bank of England extract is switched on                                    MD051247
      *                                                                                     MD051247
     C                   Callb     'AOSARDR0'                                               MD051247
     C                   Parm      *BLANKS       @RTCD                                      MD051247
     C                   Parm      '*VERIFY'     @OPTN                                      MD051247
     C                   Parm      'LLN007'      @SARD                                      MD051247
      *                                                                                     MD051247
      ** Set switchable feature indicator                                                   MD051247
      *                                                                                     MD051247
     C     @RTCD         Ifeq      *BLANK                                                   MD051247
     C                   Movel     'Y'           LLN007            1                        MD051247
     C                   Else                                                               MD051247
     C                   Movel     'N'           LLN007                                     MD051247
     C                   Endif                                                              MD051247
      *                                                                                     MD051247
      **--------------------------------------------------------------------------------------------
      ** The following /COPY sets the values of program, module and
      ** procedure names for database error processing.
     C/COPY ZACPYSRC,DBFIELDS
      **--------------------------------------------------------------------------------------------

      *  Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,SDCUDPV051

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRERR - EXCEPTION ERRORS                                      *
      *                                                               *
      *****************************************************************
     C     SRERR         BEGSR
      *
     C                   MOVEL     'SDCUSD3VL'   DBPGM
     C                   MOVE      '1'           *INU7
     C                   MOVE      '1'           *INU8
     C                   MOVE      '1'           *INLR
     C                   DUMP
      *
      **  Terminte the program
      *
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      **--------------------------------------------------------------------------------------------
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILE
      **--------------------------------------------------------------------------------------------
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
