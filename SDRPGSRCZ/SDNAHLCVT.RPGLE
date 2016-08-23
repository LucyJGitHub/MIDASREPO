     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Non-Account Holder - File to Screen Fmt')     *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDNAHLCVT - Non-A/C Holders Conversion: File to Screen Format*
      *                                                               *
      *  Function:  This module converts the fields of a Non-A/C      *
      *             Holder from their file format to a screen format  *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2004            *
      *                                                               *
      *  Last Amend No. MD027467           Date 11Jun14               *
      *  Prev Amend No. CGL132             Date 01May13               *
      *                 CER059             Date 19Jul10               *
      *                 BUG26384           Date 13Oct09               *
      *                 CER054             Date 07Apr09               *
      *                 BUG22580           Date 02Feb09               *
      *                 CER048             Date 19May08               *
      *                 CER047             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 CSW207             Date 08Jun07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 232543             Date 31Mar05               *
      *                 CGL032  *CREATE    Date 05Jul04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD027467 - Incorrect time format of Override Time in US      *
      *             Indicia screen. Applied fix MD026835              *
      *  CGL132 - FATCA Phase 1 - Customers' Identification and       *
      *           Classification - Master                             *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG26384 - Input in 'Federal State Code' is missing          *
      *  CER054 - German Features - Church Tax                        *
      *  BUG22580 - Fields incorrectly labeled and lengths            *
      *  CER048 - German Features - Taxes                             *
      *  CER047 - German Features LF037-00 Reporting §24c KWG         *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  CSW207 - Swift 2007 Standard Changes                         *
      *  232543 - Fix to CGL031                                       *
      *  CGL032 - Automatic Exchange of Information.                  *
      *                                                               *
      *****************************************************************
 
 
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
 
      ** Non-A/C Holder - File Formats
     D NahoFilFmt    E DS                  Extname(SDNAHOPD)
                                                                                              CGL132
      ** FATCA Non Account Holder Details in file format                                      CGL132
     D CrFaFilFmt    E DS                  EXTNAME(SDFTNHPD)                                  CGL132
 
      ** Non-A/C Holder - Screen Formats
     D NaPrim        E DS                  Extname(SDNAHLPD)
 
     D NaFATC        E DS                  EXTNAME(SDFTNRPD)                                  CGL132
                                                                                              CGL132
      ** External DS for Bank details
     D SDBANK        E DS                  Extname(SDBANKPD)
 
      ** External DS for Midas modules details
     D SDMMOD        E DS                  Extname(SDMMODPD)
 
      ** External DS for SAR details
     D SCSARD        E DS                  Extname(SCSARDPD)
     D  SCA_LCD      E                     Extfld(LCD)
 
      ** First DS for access programs, short data structure
     D DSFDY         E DS                  Extname(DSFDY)
                                                                                              CGL132
     D CrFoFilFmt      DS                                                                     CGL132
     D  WCDESC                 1     50                                                       CGL132
     D  WPDESC                51    100                                                       CGL132
     D  WWBRTH               101    105                                                       CGL132
     D  WWCBTH               106    107                                                       CGL132
     D  WWBTHT               108    142                                                       CGL132
     D  WWCNCZ               143    144                                                       CGL132
     D  WWCDOM               145    146                                                       CGL132
     D  WWACCZ               147    148                                                       CGL132
     D  WWUTIN               149    173                                                       CGL132
                                                                                              CGL132
     D NaFOTH          DS                                                                     CGL132
     D  WCDESC1                1     50                                                       CGL132
     D  WPDESC1               51    100                                                       CGL132
     D  WNBRTH               101    106                                                       CGL132
     D  WWCBTH1              107    108                                                       CGL132
     D  WWBTHT1              109    143                                                       CGL132
     D  WWCNCZ1              144    145                                                       CGL132
     D  WWCDOM1              146    147                                                       CGL132
     D  WWACCZ1              148    149                                                       CGL132
     D  WWUTIN2              150    174                                                       CGL132
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D Retcd           S              7
     D Option          S              7
 
     D WBDate          DS
     D  WBYear                 1      4
     D  WBMonth                5      6
     D  WBDay                  7      8
                                                                                              CGL132
     D WFTMST          DS                                                                     CGL132
     D  WWHH                   1      2                                                       CGL132
     D  WWMM                   3      4                                                       CGL132
     D  WWSS                   5      6                                                       CGL132
 
      ** Parameter fields for ZDATE2
     D  ZDAYNO         S              5  0
     D  ZDATE          S              6  0
     D  ZADATE         S              7
 
      ** Parameter fields for ZEDIT
     D  ZFIELD         S             16
     D  ZADEC          S              1  0
 
     D  ##ACTN         S              1
                                                                                              CSW207
      ** SWIFT 2007 feature                                                                   CSW207
                                                                                              CSW207
     D CSW207          S              1A   INZ('N')                                           CSW207
     D wPrivBank       S              1A   INZ('N')                                           CSW207
     D CGL132          S              1A                                                      CGL132
 
      *                                                                                       CER047
      ** German Feature                                                                       CER047
      *                                                                                       CER047
     D CER047          S              1A                                                      CER047
     D CER048          S              1A                                                      CER048
     D CER054          S              1A                                                      CER054
      *                                                                                       CER047
      ** Parameter fields for AOSARDR0                                                        CER047
      *                                                                                       CER047
     D PRtcd           S              7                                                       CER047
     D POptn           S              7                                                       CER047
     D PSard           S              6                                                       CER047
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      **************************************************************
      /EJECT
      **************************************************************
 
      ** Initialisation
 
     C                   EXSR      SRInit
 
      ** Set primary screen fields
 
     C                   EXSR      SRScn_Prim
                                                                                              CGL132
      ** Set FATCA detail screen fields                                                       CGL132
                                                                                              CGL132
     C                   IF        CGL132 = 'Y'                                               CGL132
     C                   EXSR      SCN_FATC                                                   CGL132
     C                   ENDIF                                                                CGL132
 
      ** Return
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** SRScn_Prim - Set Primary screen fields
      *****************************************************************
 
     C     SRScn_Prim    BEGSR
 
      ** Non-A/C Holder Reference
 
     C                   MOVE      NHNAHO        DDNAHO
 
      ** Non-A/C Holder Report Name
 
     C                   MOVE      NHNARN        DDNARN
 
      ** Non-A/C Holder Report Town
 
     C                   MOVE      NHNATW        DDNATW
 
      ** Tax Identification Number
 
     C                   MOVE      NHTINO        DDTINO
 
      ** Private Individual
 
     C                   MOVE      NHPIND        DDPIND
 
      ** Identification Type
 
     C                   MOVE      NHIDTP        DDIDTP
 
      ** Issuing Country
 
     C                   MOVE      NHISCT        DDISCT
 
      ** Issuing Date
 
     C**********         IF        NHISDT = *ZEROS                                            232543
     C**********         MOVEL     *BLANKS       DDISDT                                       232543
     C**********         ELSE                                                                 232543
     C**********         MOVE      NHISDT        ZDAYNO                                       232543
     C**********         EXSR      SRZDate2                                                   232543
     C**********         MOVE      ZDATE         DDISDT                                       232543
     C**********         ENDIF                                                                232543
     C                   EVAL      DDISDT = NHISDT                                            232543
                                                                                              232543
      ** Place of Birth - Country
 
     C                   MOVE      NHBTHC        DDBTHC
 
      ** Place of Birth - Town
 
     C                   MOVEL     NHBTHT        DDBTHT
 
      ** Date of Birth
 
     C                   EVAL      WBDate = NHDBTH
     C                   IF        BJDFIN = 'D'
     C                   EVAL      DDDBTH = WBDay + WBMonth + WBYear
     C                   ELSE
     C                   EVAL      DDDBTH = WBMonth + WBDay + WBYear
     C                   ENDIF
 
      ** Mailing Address 1
 
     C                   MOVEL     NHCNA1        DDCNA1
 
      ** Mailing Address 2
 
     C                   MOVEL     NHCNA2        DDCNA2
 
      ** Mailing Address 3
 
     C                   MOVEL     NHCNA3        DDCNA3
 
      ** Mailing Address 4
 
     C                   MOVEL     NHCNA4        DDCNA4
 
      ** Identity - Family Name
 
     C                   MOVE      NHIDE1        DDIDE1
 
      ** Identity - First Name
 
     C                   MOVE      NHIDE2        DDIDE2
 
      ** Identity - Street 1
 
     C                   MOVE      NHIDE3        DDIDE3
 
      ** Identity - Street 2
 
     C                   MOVE      NHIDE4        DDIDE4
 
      ** Identity - City
 
     C                   MOVE      NHCITY        DDCITY
 
      ** Identity - Zip Code
 
     C                   MOVE      NHZIPC        DDZIPC
 
      ** Country of Residence
 
     C                   MOVE      NHCOLC        DDCOLC
 
      ** Issuing Authority                                                                    CSW207
                                                                                              CSW207
     C                   IF        CSW207 = 'Y' or wPrivBank = 'Y'                            CSW207
     C                   EVAL      DDISAU = NHISAU                                            CSW207
     C                   ENDIF                                                                CSW207
                                                                                              CSW207
      ** Country of Citizenship                                                               CGL132
      ** Alternative Country of Citizenship                                                   CGL132
      ** TIN 2-5                                                                              CGL132
      ** Country of TIN 2-5                                                                   CGL132
      ** Creation Date                                                                        CGL132
     C                   EVAL      DDCOCZ = NHCOCZ                                            CGL132
     C                   EVAL      DDACCZ = NHACCZ                                            CGL132
     C                   EVAL      DDTIN2 = NHTIN2                                            CGL132
     C                   EVAL      DDTIN3 = NHTIN3                                            CGL132
     C                   EVAL      DDTIN4 = NHTIN4                                            CGL132
     C                   EVAL      DDTIN5 = NHTIN5                                            CGL132
     C                   EVAL      DDCTIN2 = NHCTN2                                           CGL132
     C                   EVAL      DDCTIN3 = NHCTN3                                           CGL132
     C                   EVAL      DDCTIN4 = NHCTN4                                           CGL132
     C                   EVAL      DDCTIN5 = NHCTN5                                           CGL132
                                                                                              CGL132
     C                   IF        %trim(NHCRDT) <> *BLANKS                                   CGL132
     C                   EVAL      WBDate = NHCRDT                                            CGL132
     C                   IF        BJDFIN = 'D'                                               CGL132
     C                   EVAL      DDCRDT = WBDay + WBMonth + WBYear                          CGL132
     C                   ELSE                                                                 CGL132
     C                   EVAL      DDCRDT = WBMonth + WBDay + WBYear                          CGL132
     C                   ENDIF                                                                CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
     C                   IF        CER047 = 'Y'                                               CER047
      *                                                                                       CER047
     C                   EVAL      DDTITL = NHTITL                                            CER047
     C                   EVAL      DDMDNM = NHMDNM                                            CER047
     C                   EVAL      DDISUP = NHISUP                                            CER047
     C                   EVAL      DDRMK1 = NHRMK1                                            CER047
     C                   EVAL      DDRMK2 = NHRMK2                                            CER047
     C                   EVAL      DDRMK3 = NHRMK3                                            CER047
     C                   EVAL      DDSHNM = NHSHNM                                            CER047
     C                   EVAL      DDDOCN = NHDOCN                                            CER047
     C                   EVAL      DDINDC = NHINDC                                            CER047
     C                   EVAL      DDCTYC = NHCTYC                                            CER047
     C                   EVAL      DDCTYD = NHCTYD                                            CER047
     C                   EVAL      DDEXDT = NHEXDT                                            CER047
     C                   EVAL      DDPHON = NHPHON                                            CER047
     C                   EVAL      DDSREF = NHSREF                                            CER047
      *                                                                                       CER048
     C                   ELSEIF    CER048 = 'Y'                                               CER048
     C                   EVAL      DDTITL = NHTITL                                            CER048
     C                   EVAL      DDMDNM = NHMDNM                                            CER048
     C                   EVAL      DDISUP = NHISUP                                            CER048
     C                   EVAL      DDDOCN = NHDOCN                                            CER048
     C                   EVAL      DDINDC = NHINDC                                            CER048
     C                   EVAL      DDSREF = NHSREF                                          BUG22580
      *                                                                                       CER047
     C                   ENDIF                                                                CER047
      *                                                                                       CER047
     C                   IF        CER048 = 'Y'                                             BUG26384
     C                   EVAL      DDSTCD = NHSTCD                                          BUG26384
     C                   ENDIF                                                              BUG26384
      *                                                                                     BUG26384
     C                   IF        CER054 = 'Y'                                               CER054
      *                                                                                       CER054
     C**********         EVAL      DDSTCD = NHSTCD                                   CER054 BUG26384
     C                   EVAL      DDRLAF = NHRLAF                                            CER054
      *                                                                                       CER054
     C                   ENDIF                                                                CER054
      *                                                                                       CER054
     C                   ENDSR
                                                                                              CGL132
      *****************************************************************                       CGL132
      /EJECT                                                                                  CGL132
      *****************************************************************                       CGL132
      ** SCN_FATC - Set FATCA details screen fields                                           CGL132
      *****************************************************************                       CGL132
                                                                                              CGL132
     C     SCN_FATC      BEGSR                                                                CGL132
                                                                                              CGL132
      ** Action Code                                                                          CGL132
     C                   EVAL      DDACTI = DDACTN                                            CGL132
                                                                                              CGL132
      ** Non-account Holder Ref                                                               CGL132
     C                   EVAL      DDNAHL = DDNAHO                                            CGL132
                                                                                              CGL132
      ** FATCA Classification Code                                                            CGL132
     C                   EVAL      DDCLAC = FNCLAC                                            CGL132
                                                                                              CGL132
      ** FATCA Classification Date                                                            CGL132
     C                   IF        FNCLAD <> 0                                                CGL132
     C                   EVAL      ZDAYNO = FNCLAD                                            CGL132
     C                   EXSR      SRZDate2                                                   CGL132
     C                   EVAL      DDCLAF = *BLANKS                                           CGL132
     C                   MOVEL     ZDATE         DDCLAF                                       CGL132
     C                   ELSE                                                                 CGL132
     C                   MOVE      *BLANKS       DDCLAF                                       CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
      ** Previous FATCA Classification Code                                                   CGL132
     C                   EVAL      DDPCLA = FNPCLA                                            CGL132
                                                                                              CGL132
      ** US Indicium Hold Mail - system value                                                 CGL132
     C                   EVAL      DDHMSV = FNHMSV                                            CGL132
                                                                                              CGL132
      ** US Indicium Hold Mail - system value date                                            CGL132
     C                   IF        FNHMSD <> 0                                                CGL132
     C                   EVAL      ZDAYNO = FNHMSD                                            CGL132
     C                   EXSR      SRZDate2                                                   CGL132
     C                   EVAL      DDHMSF = *BLANKS                                           CGL132
     C                   MOVEL     ZDATE         DDHMSF                                       CGL132
     C                   ELSE                                                                 CGL132
     C                   MOVE      *BLANKS       DDHMSF                                       CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
      ** US Indicium Hold Mail - system value time                                            CGL132
     C                   EVAL      WFTMST = FNHMST                                            CGL132
     C                   EVAL      DDHMST = *BLANKS                                           CGL132
     C                   IF        WFTMST <> *BLANKS                                          CGL132
     C                   EVAL      DDHMST = WWHH + ':' + WWMM +                               CGL132
     C                                      ':' + WWSS                                        CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
      ** US Indicium Hold Mail - override value                                               CGL132
     C                   EVAL      DDHMOV = FNHMOV                                            CGL132
                                                                                              CGL132
      ** US Indicium Hold Mail - override user name                                           CGL132
     C                   EVAL      DDHMON = FNHMON                                            CGL132
                                                                                              CGL132
      ** US Indicium Hold Mail - override date                                                CGL132
     C                   EVAL      DDHMOF = *BLANKS                                           CGL132
     C                   IF        FNHMOD <> 0                                                CGL132
     C                   EVAL      ZDAYNO = FNHMOD                                            CGL132
     C                   EXSR      SRZDate2                                                   CGL132
     C                   MOVEL     ZDATE         DDHMOF                                       CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
      ** US Indicium Hold Mail - override time                                                CGL132
     C**********         EVAL      DDHMOM = FNHMOT                                   CGL132 MD026835
     C                   EVAL      WFTMST = FNHMOT                                          MD026835
     C                   EVAL      DDHMOM = *BLANKS                                         MD026835
     C                   IF        WFTMST <> *BLANKS                                        MD026835
     C                   EVAL      DDHMOM = WWHH + ':' + WWMM +                             MD026835
     C                                      ':' + WWSS                                      MD026835
     C                   ENDIF                                                              MD026835
                                                                                              CGL132
      ** US Indicium Hold Mail - override active document                                     CGL132
     C                   EVAL      DDHMD1 = FNHMD1                                            CGL132
     C                   EVAL      DDHMD2 = FNHMD2                                            CGL132
     C                   EVAL      DDHMD3 = FNHMD3                                            CGL132
     C                   EVAL      DDHMD4 = FNHMD4                                            CGL132
     C                   EVAL      DDHMD5 = FNHMD5                                            CGL132
     C                   MOVE      FNHMS1        DDHMS1                                       CGL132
     C                   MOVE      FNHMS2        DDHMS2                                       CGL132
     C                   MOVE      FNHMS3        DDHMS3                                       CGL132
     C                   MOVE      FNHMS4        DDHMS4                                       CGL132
     C                   MOVE      FNHMS5        DDHMS5                                       CGL132
                                                                                              CGL132
      ** US Indicium Hold Mail - comments                                                     CGL132
     C                   EVAL      DDHMC1 = %SUBST(FNHMCO:1:64)                               CGL132
     C                   EVAL      DDHMC2 = %SUBST(FNHMCO:65:64)                              CGL132
                                                                                              CGL132
      ** US Indicium Mailing Country - system value                                           CGL132
     C                   EVAL      DDMCSV = FNMCSV                                            CGL132
                                                                                              CGL132
      ** US Indicium Mailing Country - system value date                                      CGL132
     C                   IF        FNMCSD <> 0                                                CGL132
     C                   EVAL      ZDAYNO = FNMCSD                                            CGL132
     C                   EXSR      SRZDate2                                                   CGL132
     C                   EVAL      DDMCSD = *BLANKS                                           CGL132
     C                   MOVEL     ZDATE         DDMCSD                                       CGL132
     C                   ELSE                                                                 CGL132
     C                   MOVE      *BLANKS       DDMCSD                                       CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
      ** US Indicium Mailing Country - system value time                                      CGL132
     C                   EVAL      WFTMST = FNMCST                                            CGL132
     C                   EVAL      DDMCST = *BLANKS                                           CGL132
     C                   IF        WFTMST <> *BLANKS                                          CGL132
     C                   EVAL      DDMCST = WWHH + ':' + WWMM +                               CGL132
     C                                      ':' + WWSS                                        CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
      ** US Indicium Mailing Country - override value                                         CGL132
     C                   EVAL      DDMCOV = FNMCOV                                            CGL132
                                                                                              CGL132
      ** US Indicium Mailing Country - override user name                                     CGL132
     C                   EVAL      DDMCON = FNMCON                                            CGL132
                                                                                              CGL132
      ** US Indicium Mailing Country - override date                                          CGL132
     C                   EVAL      DDMCOD = *BLANKS                                           CGL132
     C                   IF        FNMCOD <> 0                                                CGL132
     C                   EVAL      ZDAYNO = FNMCOD                                            CGL132
     C                   EXSR      SRZDate2                                                   CGL132
     C                   MOVEL     ZDATE         DDMCOD                                       CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
      ** US Indicium Mailing Country - override time                                          CGL132
     C**********         EVAL      DDMCOT = FNMCOT                                   CGL132 MD026835
     C                   EVAL      WFTMST = FNMCOT                                          MD026835
     C                   EVAL      DDMCOT = *BLANKS                                         MD026835
     C                   IF        WFTMST <> *BLANKS                                        MD026835
     C                   EVAL      DDMCOT = WWHH + ':' + WWMM +                             MD026835
     C                                      ':' + WWSS                                      MD026835
     C                   ENDIF                                                              MD026835
                                                                                              CGL132
      ** US Indicium Mailing Country - override active document                               CGL132
     C                   EVAL      DDMCD1 = FNMCD1                                            CGL132
     C                   EVAL      DDMCD2 = FNMCD2                                            CGL132
     C                   EVAL      DDMCD3 = FNMCD3                                            CGL132
     C                   EVAL      DDMCD4 = FNMCD4                                            CGL132
     C                   EVAL      DDMCD5 = FNMCD5                                            CGL132
     C                   MOVE      FNMCS1        DDMCS1                                       CGL132
     C                   MOVE      FNMCS2        DDMCS2                                       CGL132
     C                   MOVE      FNMCS3        DDMCS3                                       CGL132
     C                   MOVE      FNMCS4        DDMCS4                                       CGL132
     C                   MOVE      FNMCS5        DDMCS5                                       CGL132
                                                                                              CGL132
      ** US Indicium Mailing Country - comments                                               CGL132
     C                   EVAL      DDMCC1 = %SUBST(FNMCCO:1:64)                               CGL132
     C                   EVAL      DDMCC2 = %SUBST(FNMCCO:65:64)                              CGL132
                                                                                              CGL132
      ** US Indicium Reg Payment Inst to US - system value                                    CGL132
     C                   EVAL      DDRPSV = FNRPSV                                            CGL132
                                                                                              CGL132
      ** US Indicium Reg Payment Inst to US - system value date                               CGL132
     C                   IF        FNRPSD <> 0                                                CGL132
     C                   EVAL      ZDAYNO = FNRPSD                                            CGL132
     C                   EXSR      SRZDate2                                                   CGL132
     C                   EVAL      DDRPSF = *BLANKS                                           CGL132
     C                   MOVEL     ZDATE         DDRPSF                                       CGL132
     C                   ELSE                                                                 CGL132
     C                   MOVE      *BLANKS       DDRPSF                                       CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
      ** US Indicium Reg Payment Inst to US - system value time                               CGL132
     C                   EVAL      WFTMST = FNRPST                                            CGL132
     C                   EVAL      DDRPST = *BLANKS                                           CGL132
     C                   IF        WFTMST <> *BLANKS                                          CGL132
     C                   EVAL      DDRPST = WWHH + ':' + WWMM +                               CGL132
     C                                      ':' + WWSS                                        CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
      ** US Indicium Reg Payment Inst to US - override value                                  CGL132
     C                   EVAL      DDRPOV = FNRPOV                                            CGL132
                                                                                              CGL132
      ** US Indicium Reg Payment Inst to US - override user name                              CGL132
     C                   EVAL      DDRPON = FNRPON                                            CGL132
                                                                                              CGL132
      ** US Indicium Reg Payment Inst to US - override date                                   CGL132
     C                   EVAL      DDRPOF = *BLANKS                                           CGL132
     C                   IF        FNRPOD <> 0                                                CGL132
     C                   EVAL      ZDAYNO = FNRPOD                                            CGL132
     C                   EXSR      SRZDate2                                                   CGL132
     C                   MOVEL     ZDATE         DDRPOF                                       CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
      ** US Indicium Reg Payment Inst to US - override time                                   CGL132
     C**********         EVAL      DDRPOM = FNRPOT                                   CGL132 MD026835
     C                   EVAL      WFTMST = FNRPOT                                          MD026835
     C                   EVAL      DDRPOM = *BLANKS                                         MD026835
     C                   IF        WFTMST <> *BLANKS                                        MD026835
     C                   EVAL      DDRPOM = WWHH + ':' + WWMM +                             MD026835
     C                                      ':' + WWSS                                      MD026835
     C                   ENDIF                                                              MD026835
                                                                                              CGL132
      ** US Indicium Reg Payment Inst to US - override                                        CGL132
      ** active document                                                                      CGL132
     C                   EVAL      DDRPD1 = FNRPD1                                            CGL132
     C                   EVAL      DDRPD2 = FNRPD2                                            CGL132
     C                   EVAL      DDRPD3 = FNRPD3                                            CGL132
     C                   EVAL      DDRPD4 = FNRPD4                                            CGL132
     C                   EVAL      DDRPD5 = FNRPD5                                            CGL132
     C                   MOVE      FNRPS1        DDRPS1                                       CGL132
     C                   MOVE      FNRPS2        DDRPS2                                       CGL132
     C                   MOVE      FNRPS3        DDRPS3                                       CGL132
     C                   MOVE      FNRPS4        DDRPS4                                       CGL132
     C                   MOVE      FNRPS5        DDRPS5                                       CGL132
                                                                                              CGL132
      ** US Indicium Reg Payment Inst to US - comments                                        CGL132
     C                   EVAL      DDRPC1 = %SUBST(FNRPCO:1:64)                               CGL132
     C                   EVAL      DDRPC2 = %SUBST(FNRPCO:65:64)                              CGL132
                                                                                              CGL132
      ** US Indicium Account Authority Hldr - system value                                    CGL132
     C                   EVAL      DDAUSV = FNAUSV                                            CGL132
                                                                                              CGL132
      ** US Indicium Account Authority Hldr - system value date                               CGL132
     C                   IF        FNAUSD <> 0                                                CGL132
     C                   EVAL      ZDAYNO = FNAUSD                                            CGL132
     C                   EXSR      SRZDate2                                                   CGL132
     C                   EVAL      DDAUSF = *BLANKS                                           CGL132
     C                   MOVEL     ZDATE         DDAUSF                                       CGL132
     C                   ELSE                                                                 CGL132
     C                   MOVE      *BLANKS       DDAUSF                                       CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
      ** US Indicium Account Authority Hldr - system value time                               CGL132
     C                   EVAL      WFTMST = FNAUST                                            CGL132
     C                   EVAL      DDAUST = *BLANKS                                           CGL132
     C                   IF        WFTMST <> *BLANKS                                          CGL132
     C                   EVAL      DDAUST = WWHH + ':' + WWMM +                               CGL132
     C                                      ':' + WWSS                                        CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
      ** US Indicium Account Authority Hldr - override value                                  CGL132
     C                   EVAL      DDAUOV = FNAUOV                                            CGL132
                                                                                              CGL132
      ** US Indicium Account Authority Hldr - override user name                              CGL132
     C                   EVAL      DDAUON = FNAUON                                            CGL132
                                                                                              CGL132
      ** US Indicium Account Authority Hldr - override date                                   CGL132
     C                   EVAL      DDAUOF = *BLANKS                                           CGL132
     C                   IF        FNAUOD <> 0                                                CGL132
     C                   EVAL      ZDAYNO = FNAUOD                                            CGL132
     C                   EXSR      SRZDate2                                                   CGL132
     C                   MOVEL     ZDATE         DDAUOF                                       CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
      ** US Indicium Account Authority Hldr - override time                                   CGL132
     C**********         EVAL      DDAUOM = FNAUOT                                   CGL132 MD026835
     C                   EVAL      WFTMST = FNAUOT                                          MD026835
     C                   EVAL      DDAUOM = *BLANKS                                         MD026835
     C                   IF        WFTMST <> *BLANKS                                        MD026835
     C                   EVAL      DDAUOM = WWHH + ':' + WWMM +                             MD026835
     C                                      ':' + WWSS                                      MD026835
     C                   ENDIF                                                              MD026835
                                                                                              CGL132
      ** US Indicium Account Authority Hldr - override                                        CGL132
      ** active document                                                                      CGL132
     C                   EVAL      DDAUD1 = FNAUD1                                            CGL132
     C                   EVAL      DDAUD2 = FNAUD2                                            CGL132
     C                   EVAL      DDAUD3 = FNAUD3                                            CGL132
     C                   EVAL      DDAUD4 = FNAUD4                                            CGL132
     C                   EVAL      DDAUD5 = FNAUD5                                            CGL132
     C                   MOVE      FNAUS1        DDAUS1                                       CGL132
     C                   MOVE      FNAUS2        DDAUS2                                       CGL132
     C                   MOVE      FNAUS3        DDAUS3                                       CGL132
     C                   MOVE      FNAUS4        DDAUS4                                       CGL132
     C                   MOVE      FNAUS5        DDAUS5                                       CGL132
                                                                                              CGL132
      ** US Indicium Account Authority Hldr - comments                                        CGL132
     C                   EVAL      DDAUC1 = %SUBST(FNAUCO:1:64)                               CGL132
     C                   EVAL      DDAUC2 = %SUBST(FNAUCO:65:64)                              CGL132
                                                                                              CGL132
      ** US Indicium Citizenship - system value                                               CGL132
     C                   EVAL      DDCISV = FNCISV                                            CGL132
                                                                                              CGL132
      ** US Indicium Citizenship - system value date                                          CGL132
     C                   IF        FNCISD <> 0                                                CGL132
     C                   EVAL      ZDAYNO = FNCISD                                            CGL132
     C                   EXSR      SRZDate2                                                   CGL132
     C                   EVAL      DDCISF = *BLANKS                                           CGL132
     C                   MOVEL     ZDATE         DDCISF                                       CGL132
     C                   ELSE                                                                 CGL132
     C                   MOVE      *BLANKS       DDCISF                                       CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
      ** US Indicium Citizenship - system value time                                          CGL132
     C                   EVAL      WFTMST = FNCIST                                            CGL132
     C                   EVAL      DDCIST = *BLANKS                                           CGL132
     C                   IF        WFTMST <> *BLANKS                                          CGL132
     C                   EVAL      DDCIST = WWHH + ':' + WWMM +                               CGL132
     C                                      ':' + WWSS                                        CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
      ** US Indicium Citizenship - override value                                             CGL132
     C                   EVAL      DDCIOV = FNCIOV                                            CGL132
                                                                                              CGL132
      ** US Indicium Citizenship - override user name                                         CGL132
     C                   EVAL      DDCION = FNCION                                            CGL132
                                                                                              CGL132
      ** US Indicium Citizenship - override date                                              CGL132
     C                   EVAL      DDCIOF = *BLANKS                                           CGL132
     C                   IF        FNCIOD <> 0                                                CGL132
     C                   EVAL      ZDAYNO = FNCIOD                                            CGL132
     C                   EXSR      SRZDate2                                                   CGL132
     C                   MOVEL     ZDATE         DDCIOF                                       CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
      ** US Indicium Citizenship - override time                                              CGL132
     C**********         EVAL      DDCIOM = FNCIOT                                   CGL132 MD026835
     C                   EVAL      WFTMST = FNCIOT                                          MD026835
     C                   EVAL      DDCIOM = *BLANKS                                         MD026835
     C                   IF        WFTMST <> *BLANKS                                        MD026835
     C                   EVAL      DDCIOM = WWHH + ':' + WWMM +                             MD026835
     C                                      ':' + WWSS                                      MD026835
     C                   ENDIF                                                              MD026835
                                                                                              CGL132
      ** US Indicium Citizenship - override active document                                   CGL132
     C                   EVAL      DDCID1 = FNCID1                                            CGL132
     C                   EVAL      DDCID2 = FNCID2                                            CGL132
     C                   EVAL      DDCID3 = FNCID3                                            CGL132
     C                   EVAL      DDCID4 = FNCID4                                            CGL132
     C                   EVAL      DDCID5 = FNCID5                                            CGL132
     C                   MOVE      FNCIS1        DDCIS1                                       CGL132
     C                   MOVE      FNCIS2        DDCIS2                                       CGL132
     C                   MOVE      FNCIS3        DDCIS3                                       CGL132
     C                   MOVE      FNCIS4        DDCIS4                                       CGL132
     C                   MOVE      FNCIS5        DDCIS5                                       CGL132
                                                                                              CGL132
      ** US Indicium Citizenship - comments                                                   CGL132
     C                   EVAL      DDCIC1 = %SUBST(FNCICO:1:64)                               CGL132
     C                   EVAL      DDCIC2 = %SUBST(FNCICO:65:64)                              CGL132
                                                                                              CGL132
      ** US Indicium Country of Birth - system value                                          CGL132
     C                   EVAL      DDCBSV = FNCBSV                                            CGL132
                                                                                              CGL132
      ** US Indicium Country of Birth - system value date                                     CGL132
     C                   IF        FNCBSD <> 0                                                CGL132
     C                   EVAL      ZDAYNO = FNCBSD                                            CGL132
     C                   EXSR      SRZDate2                                                   CGL132
     C                   EVAL      DDCBSF = *BLANKS                                           CGL132
     C                   MOVEL     ZDATE         DDCBSF                                       CGL132
     C                   ELSE                                                                 CGL132
     C                   MOVE      *BLANKS       DDCBSF                                       CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
      ** US Indicium Country of Birth - system value time                                     CGL132
     C                   EVAL      WFTMST = FNCBST                                            CGL132
     C                   EVAL      DDCBST = *BLANKS                                           CGL132
     C                   IF        WFTMST <> *BLANKS                                          CGL132
     C                   EVAL      DDCBST = WWHH + ':' + WWMM +                               CGL132
     C                                      ':' + WWSS                                        CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
      ** US Indicium Country of Birth - override value                                        CGL132
     C                   EVAL      DDCBOV = FNCBOV                                            CGL132
                                                                                              CGL132
      ** US Indicium Country of Birth - override user name                                    CGL132
     C                   EVAL      DDCBON = FNCBON                                            CGL132
                                                                                              CGL132
      ** US Indicium Country of Birth - override date                                         CGL132
     C                   EVAL      DDCBOF = *BLANKS                                           CGL132
     C                   IF        FNCBOD <> 0                                                CGL132
     C                   EVAL      ZDAYNO = FNCBOD                                            CGL132
     C                   EXSR      SRZDate2                                                   CGL132
     C                   MOVEL     ZDATE         DDCBOF                                       CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
      ** US Indicium Country of Birth - override time                                         CGL132
     C**********         EVAL      DDCBOM = FNCBOT                                   CGL132 MD026835
     C                   EVAL      WFTMST = FNCBOT                                          MD026835
     C                   EVAL      DDCBOM = *BLANKS                                         MD026835
     C                   IF        WFTMST <> *BLANKS                                        MD026835
     C                   EVAL      DDCBOM = WWHH + ':' + WWMM +                             MD026835
     C                                      ':' + WWSS                                      MD026835
     C                   ENDIF                                                              MD026835
                                                                                              CGL132
                                                                                              CGL132
      ** US Indicium Country of Birth - override active document                              CGL132
     C                   EVAL      DDCBD1 = FNCBD1                                            CGL132
     C                   EVAL      DDCBD2 = FNCBD2                                            CGL132
     C                   EVAL      DDCBD3 = FNCBD3                                            CGL132
     C                   EVAL      DDCBD4 = FNCBD4                                            CGL132
     C                   EVAL      DDCBD5 = FNCBD5                                            CGL132
     C                   MOVE      FNCBS1        DDCBS1                                       CGL132
     C                   MOVE      FNCBS2        DDCBS2                                       CGL132
     C                   MOVE      FNCBS3        DDCBS3                                       CGL132
     C                   MOVE      FNCBS4        DDCBS4                                       CGL132
     C                   MOVE      FNCBS5        DDCBS5                                       CGL132
                                                                                              CGL132
      ** US Indicium Country of Birth - comments                                              CGL132
     C                   EVAL      DDCBC1 = %SUBST(FNCBCO:1:64)                               CGL132
     C                   EVAL      DDCBC2 = %SUBST(FNCBCO:65:64)                              CGL132
                                                                                              CGL132
      ** US Indicium Country of Domicile - system value                                       CGL132
     C                   EVAL      DDCDSV = FNCDSV                                            CGL132
                                                                                              CGL132
      ** US Indicium Country of Domicile - system value date                                  CGL132
     C                   IF        FNCDSD <> 0                                                CGL132
     C                   EVAL      ZDAYNO = FNCDSD                                            CGL132
     C                   EXSR      SRZDate2                                                   CGL132
     C                   EVAL      DDCDSF = *BLANKS                                           CGL132
     C                   MOVEL     ZDATE         DDCDSF                                       CGL132
     C                   ELSE                                                                 CGL132
     C                   MOVE      *BLANKS       DDCDSF                                       CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
      ** US Indicium Country of Domicile - system value time                                  CGL132
     C                   EVAL      WFTMST = FNCDST                                            CGL132
     C                   EVAL      DDCDST = *BLANKS                                           CGL132
     C                   IF        WFTMST <> *BLANKS                                          CGL132
     C                   EVAL      DDCDST = WWHH + ':' + WWMM +                               CGL132
     C                                      ':' + WWSS                                        CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
      ** US Indicium Country of Domicile - override value                                     CGL132
     C                   EVAL      DDCDOV = FNCDOV                                            CGL132
                                                                                              CGL132
      ** US Indicium Country of Domicile - override user name                                 CGL132
     C                   EVAL      DDCDON = FNCDON                                            CGL132
                                                                                              CGL132
      ** US Indicium Country of Domicile - override date                                      CGL132
     C                   EVAL      DDCDOF = *BLANKS                                           CGL132
     C                   IF        FNCDOD <> 0                                                CGL132
     C                   EVAL      ZDAYNO = FNCDOD                                            CGL132
     C                   EXSR      SRZDate2                                                   CGL132
     C                   MOVEL     ZDATE         DDCDOF                                       CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
      ** US Indicium Country of Domicile - override time                                      CGL132
     C**********         EVAL      DDCDMM = FNCDOT                                   CGL132 MD026835
     C                   EVAL      WFTMST = FNCDOT                                          MD026835
     C                   EVAL      DDCDMM = *BLANKS                                         MD026835
     C                   IF        WFTMST <> *BLANKS                                        MD026835
     C                   EVAL      DDCDMM = WWHH + ':' + WWMM +                             MD026835
     C                                      ':' + WWSS                                      MD026835
     C                   ENDIF                                                              MD026835
                                                                                              CGL132
      ** US Indicium Country of Domicile - override active document                           CGL132
     C                   EVAL      DDCDD1 = FNCDD1                                            CGL132
     C                   EVAL      DDCDD2 = FNCDD2                                            CGL132
     C                   EVAL      DDCDD3 = FNCDD3                                            CGL132
     C                   EVAL      DDCDD4 = FNCDD4                                            CGL132
     C                   EVAL      DDCDD5 = FNCDD5                                            CGL132
     C                   MOVE      FNCDS1        DDCDS1                                       CGL132
     C                   MOVE      FNCDS2        DDCDS2                                       CGL132
     C                   MOVE      FNCDS3        DDCDS3                                       CGL132
     C                   MOVE      FNCDS4        DDCDS4                                       CGL132
     C                   MOVE      FNCDS5        DDCDS5                                       CGL132
                                                                                              CGL132
      ** US Indicium Country of Domicile - comments                                           CGL132
     C                   EVAL      DDCDC1 = %SUBST(FNCDCO:1:64)                               CGL132
     C                   EVAL      DDCDC2 = %SUBST(FNCDCO:65:64)                              CGL132
                                                                                              CGL132
      ** US Indicium Green Card - system value                                                CGL132
     C                   EVAL      DDGCSV = FNGCSV                                            CGL132
                                                                                              CGL132
      ** US Indicium Green Card - system value date                                           CGL132
     C                   IF        FNGCSD <> 0                                                CGL132
     C                   EVAL      ZDAYNO = FNGCSD                                            CGL132
     C                   EXSR      SRZDate2                                                   CGL132
     C                   EVAL      DDGCSF = *BLANKS                                           CGL132
     C                   MOVEL     ZDATE         DDGCSF                                       CGL132
     C                   ELSE                                                                 CGL132
     C                   MOVE      *BLANKS       DDGCSF                                       CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
      ** US Indicium Green Card - system value time                                           CGL132
     C                   EVAL      WFTMST = FNGCST                                            CGL132
     C                   EVAL      DDGCST = *BLANKS                                           CGL132
     C                   IF        WFTMST <> *BLANKS                                          CGL132
     C                   EVAL      DDGCST = WWHH + ':' + WWMM +                               CGL132
     C                                      ':' + WWSS                                        CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
      ** US Indicium Green Card - override value                                              CGL132
     C                   EVAL      DDGCOV = FNGCOV                                            CGL132
                                                                                              CGL132
      ** US Indicium Green Card - override user name                                          CGL132
     C                   EVAL      DDGCON = FNGCON                                            CGL132
                                                                                              CGL132
      ** US Indicium Green Card - override date                                               CGL132
     C                   EVAL      DDGCOF = *BLANKS                                           CGL132
     C                   IF        FNGCOD <> 0                                                CGL132
     C                   EVAL      ZDAYNO = FNGCOD                                            CGL132
     C                   EXSR      SRZDate2                                                   CGL132
     C                   MOVEL     ZDATE         DDGCOF                                       CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
      ** US Indicium Green Card - override time                                               CGL132
     C**********         EVAL      DDGCOM = FNGCOT                                   CGL132 MD026835
     C                   EVAL      WFTMST = FNGCOT                                          MD026835
     C                   EVAL      DDGCOM = *BLANKS                                         MD026835
     C                   IF        WFTMST <> *BLANKS                                        MD026835
     C                   EVAL      DDGCOM = WWHH + ':' + WWMM +                             MD026835
     C                                      ':' + WWSS                                      MD026835
     C                   ENDIF                                                              MD026835
                                                                                              CGL132
      ** US Indicium Green Card - override active document                                    CGL132
     C                   EVAL      DDGCD1 = FNGCD1                                            CGL132
     C                   EVAL      DDGCD2 = FNGCD2                                            CGL132
     C                   EVAL      DDGCD3 = FNGCD3                                            CGL132
     C                   EVAL      DDGCD4 = FNGCD4                                            CGL132
     C                   EVAL      DDGCD5 = FNGCD5                                            CGL132
     C                   MOVE      FNGCS1        DDGCS1                                       CGL132
     C                   MOVE      FNGCS2        DDGCS2                                       CGL132
     C                   MOVE      FNGCS3        DDGCS3                                       CGL132
     C                   MOVE      FNGCS4        DDGCS4                                       CGL132
     C                   MOVE      FNGCS5        DDGCS5                                       CGL132
                                                                                              CGL132
      ** US Indicium Green Card - comments                                                    CGL132
     C                   EVAL      DDGCC1 = %SUBST(FNGCCO:1:64)                               CGL132
     C                   EVAL      DDGCC2 = %SUBST(FNGCCO:65:64)                              CGL132
                                                                                              CGL132
      ** US Indicium Identity Document - system value                                         CGL132
     C                   EVAL      DDIDSV = FNIDSV                                            CGL132
                                                                                              CGL132
      ** US Indicium Identity Document - system value date                                    CGL132
     C                   IF        FNIDSD <> 0                                                CGL132
     C                   EVAL      ZDAYNO = FNIDSD                                            CGL132
     C                   EXSR      SRZDate2                                                   CGL132
     C                   EVAL      DDIDSF = *BLANKS                                           CGL132
     C                   MOVEL     ZDATE         DDIDSF                                       CGL132
     C                   ELSE                                                                 CGL132
     C                   MOVE      *BLANKS       DDIDSF                                       CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
      ** US Indicium Identity Document - system value time                                    CGL132
     C                   EVAL      WFTMST = FNIDST                                            CGL132
     C                   EVAL      DDIDST = *BLANKS                                           CGL132
     C                   IF        WFTMST <> *BLANKS                                          CGL132
     C                   EVAL      DDIDST = WWHH + ':' + WWMM +                               CGL132
     C                                      ':' + WWSS                                        CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
      ** US Indicium Identity Document - override value                                       CGL132
     C                   EVAL      DDIDOV = FNIDOV                                            CGL132
                                                                                              CGL132
      ** US Indicium Identity Document - override user name                                   CGL132
     C                   EVAL      DDIDON = FNIDON                                            CGL132
                                                                                              CGL132
      ** US Indicium Identity Document - override date                                        CGL132
     C                   EVAL      DDIDOF = *BLANKS                                           CGL132
     C                   IF        FNIDOD <> 0                                                CGL132
     C                   EVAL      ZDAYNO = FNIDOD                                            CGL132
     C                   EXSR      SRZDate2                                                   CGL132
     C                   MOVEL     ZDATE         DDIDOF                                       CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
      ** US Indicium Identity Document - override time                                        CGL132
     C**********         EVAL      DDIDOM = FNIDOT                                   CGL132 MD026835
     C                   EVAL      WFTMST = FNIDOT                                          MD026835
     C                   EVAL      DDIDOM = *BLANKS                                         MD026835
     C                   IF        WFTMST <> *BLANKS                                        MD026835
     C                   EVAL      DDIDOM = WWHH + ':' + WWMM +                             MD026835
     C                                      ':' + WWSS                                      MD026835
     C                   ENDIF                                                              MD026835
                                                                                              CGL132
      ** US Indicium Identity Document - override                                             CGL132
      ** active document                                                                      CGL132
     C                   EVAL      DDIDD1 = FNIDD1                                            CGL132
     C                   EVAL      DDIDD2 = FNIDD2                                            CGL132
     C                   EVAL      DDIDD3 = FNIDD3                                            CGL132
     C                   EVAL      DDIDD4 = FNIDD4                                            CGL132
     C                   EVAL      DDIDD5 = FNIDD5                                            CGL132
     C                   MOVE      FNIDS1        DDIDS1                                       CGL132
     C                   MOVE      FNIDS2        DDIDS2                                       CGL132
     C                   MOVE      FNIDS3        DDIDS3                                       CGL132
     C                   MOVE      FNIDS4        DDIDS4                                       CGL132
     C                   MOVE      FNIDS5        DDIDS5                                       CGL132
                                                                                              CGL132
      ** US Indicium Identity Document - comments                                             CGL132
     C                   EVAL      DDIDC1 = %SUBST(FNIDCO:1:64)                               CGL132
     C                   EVAL      DDIDC2 = %SUBST(FNIDCO:65:64)                              CGL132
                                                                                              CGL132
      ** US Indicium Joint Account Member - system value                                      CGL132
     C                   EVAL      DDJASV = FNJASV                                            CGL132
                                                                                              CGL132
      ** US Indicium Joint Account Member - system value date                                 CGL132
     C                   IF        FNJASD <> 0                                                CGL132
     C                   EVAL      ZDAYNO = FNJASD                                            CGL132
     C                   EXSR      SRZDate2                                                   CGL132
     C                   EVAL      DDJASF = *BLANKS                                           CGL132
     C                   MOVEL     ZDATE         DDJASF                                       CGL132
     C                   ELSE                                                                 CGL132
     C                   MOVE      *BLANKS       DDJASF                                       CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
      ** US Indicium Joint Account Member - system value time                                 CGL132
     C                   EVAL      WFTMST = FNJAST                                            CGL132
     C                   EVAL      DDJAST = *BLANKS                                           CGL132
     C                   IF        WFTMST <> *BLANKS                                          CGL132
     C                   EVAL      DDJAST = WWHH + ':' + WWMM +                               CGL132
     C                                      ':' + WWSS                                        CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
      ** US Indicium Joint Account Member - override value                                    CGL132
     C                   EVAL      DDJAOV = FNJAOV                                            CGL132
                                                                                              CGL132
      ** US Indicium Joint Account Member - override user name                                CGL132
     C                   EVAL      DDJAON = FNJAON                                            CGL132
                                                                                              CGL132
      ** US Indicium Joint Account Member - override date                                     CGL132
     C                   EVAL      DDJAOF = *BLANKS                                           CGL132
     C                   IF        FNJAOD <> 0                                                CGL132
     C                   EVAL      ZDAYNO = FNJAOD                                            CGL132
     C                   EXSR      SRZDate2                                                   CGL132
     C                   MOVEL     ZDATE         DDJAOF                                       CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
      ** US Indicium Joint Account Member - override time                                     CGL132
     C**********         EVAL      DDJAOM = FNJAOT                                   CGL132 MD026835
     C                   EVAL      WFTMST = FNJAOT                                          MD026835
     C                   EVAL      DDJAOM = *BLANKS                                         MD026835
     C                   IF        WFTMST <> *BLANKS                                        MD026835
     C                   EVAL      DDJAOM = WWHH + ':' + WWMM +                             MD026835
     C                                      ':' + WWSS                                      MD026835
     C                   ENDIF                                                              MD026835
                                                                                              CGL132
      ** US Indicium Joint Account Member - override active document                          CGL132
     C                   EVAL      DDJAD1 = FNJAD1                                            CGL132
     C                   EVAL      DDJAD2 = FNJAD2                                            CGL132
     C                   EVAL      DDJAD3 = FNJAD3                                            CGL132
     C                   EVAL      DDJAD4 = FNJAD4                                            CGL132
     C                   EVAL      DDJAD5 = FNJAD5                                            CGL132
     C                   MOVE      FNJAS1        DDJAS1                                       CGL132
     C                   MOVE      FNJAS2        DDJAS2                                       CGL132
     C                   MOVE      FNJAS3        DDJAS3                                       CGL132
     C                   MOVE      FNJAS4        DDJAS4                                       CGL132
     C                   MOVE      FNJAS5        DDJAS5                                       CGL132
                                                                                              CGL132
      ** US Indicium Joint Account Member - comments                                          CGL132
     C                   EVAL      DDJAC1 = %SUBST(FNJACO:1:64)                               CGL132
     C                   EVAL      DDJAC2 = %SUBST(FNJACO:65:64)                              CGL132
                                                                                              CGL132
      ** US Indicium Telephone - system value                                                 CGL132
     C                   EVAL      DDTESV = FNTESV                                            CGL132
                                                                                              CGL132
      ** US Indicium Telephone - system value date                                            CGL132
     C                   IF        FNTESD <> 0                                                CGL132
     C                   EVAL      ZDAYNO = FNTESD                                            CGL132
     C                   EXSR      SRZDate2                                                   CGL132
     C                   EVAL      DDTESF = *BLANKS                                           CGL132
     C                   MOVEL     ZDATE         DDTESF                                       CGL132
     C                   ELSE                                                                 CGL132
     C                   MOVE      *BLANKS       DDTESF                                       CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
      ** US Indicium Telephone - system value time                                            CGL132
     C                   EVAL      WFTMST = FNTEST                                            CGL132
     C                   EVAL      DDTEST = *BLANKS                                           CGL132
     C                   IF        WFTMST <> *BLANKS                                          CGL132
     C                   EVAL      DDTEST = WWHH + ':' + WWMM +                               CGL132
     C                                      ':' + WWSS                                        CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
      ** US Indicium Telephone - override value                                               CGL132
     C                   EVAL      DDTEOV = FNTEOV                                            CGL132
                                                                                              CGL132
      ** US Indicium Telephone - override user name                                           CGL132
     C                   EVAL      DDTEON = FNTEON                                            CGL132
                                                                                              CGL132
      ** US Indicium Telephone - override date                                                CGL132
     C                   EVAL      DDTEOF = *BLANKS                                           CGL132
     C                   IF        FNTEOD <> 0                                                CGL132
     C                   EVAL      ZDAYNO = FNTEOD                                            CGL132
     C                   EXSR      SRZDate2                                                   CGL132
     C                   MOVEL     ZDATE         DDTEOF                                       CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
      ** US Indicium Telephone - override time                                                CGL132
     C**********         EVAL      DDTEOM = FNTEOT                                   CGL132 MD026835
     C                   EVAL      WFTMST = FNTEOT                                          MD026835
     C                   EVAL      DDTEOM = *BLANKS                                         MD026835
     C                   IF        WFTMST <> *BLANKS                                        MD026835
     C                   EVAL      DDTEOM = WWHH + ':' + WWMM +                             MD026835
     C                                      ':' + WWSS                                      MD026835
     C                   ENDIF                                                              MD026835
                                                                                              CGL132
      ** US Indicium Telephone - override active document                                     CGL132
     C                   EVAL      DDTED1 = FNTED1                                            CGL132
     C                   EVAL      DDTED2 = FNTED2                                            CGL132
     C                   EVAL      DDTED3 = FNTED3                                            CGL132
     C                   EVAL      DDTED4 = FNTED4                                            CGL132
     C                   EVAL      DDTED5 = FNTED5                                            CGL132
     C                   MOVE      FNTES1        DDTES1                                       CGL132
     C                   MOVE      FNTES2        DDTES2                                       CGL132
     C                   MOVE      FNTES3        DDTES3                                       CGL132
     C                   MOVE      FNTES4        DDTES4                                       CGL132
     C                   MOVE      FNTES5        DDTES5                                       CGL132
                                                                                              CGL132
      ** US Indicium Telephone - comments                                                     CGL132
     C                   EVAL      DDTEC1 = %SUBST(FNTECO:1:64)                               CGL132
     C                   EVAL      DDTEC2 = %SUBST(FNTECO:65:64)                              CGL132
                                                                                              CGL132
      ** US Indicium TIN - system value                                                       CGL132
     C                   EVAL      DDTXSV = FNTXSV                                            CGL132
                                                                                              CGL132
      ** US Indicium TIN - system value time                                                  CGL132
     C                   EVAL      WFTMST = FNTXST                                            CGL132
     C                   EVAL      DDTXST = *BLANKS                                           CGL132
     C                   IF        WFTMST <> *BLANKS                                          CGL132
     C                   EVAL      DDTXST = WWHH + ':' + WWMM +                               CGL132
     C                                      ':' + WWSS                                        CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
      ** US Indicium TIN - system value date                                                  CGL132
     C                   IF        FNTXSD <> 0                                                CGL132
     C                   EVAL      ZDAYNO = FNTXSD                                            CGL132
     C                   EXSR      SRZDate2                                                   CGL132
     C                   EVAL      DDTXSF = *BLANKS                                           CGL132
     C                   MOVEL     ZDATE         DDTXSF                                       CGL132
     C                   ELSE                                                                 CGL132
     C                   MOVE      *BLANKS       DDTXSF                                       CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
      ** US Indicium TIN - override value                                                     CGL132
     C                   EVAL      DDTXOV = FNTXOV                                            CGL132
                                                                                              CGL132
      ** US Indicium TIN - override user name                                                 CGL132
     C                   EVAL      DDTXON = FNTXON                                            CGL132
                                                                                              CGL132
      ** US Indicium TIN - override date                                                      CGL132
     C                   EVAL      DDTXOF = *BLANKS                                           CGL132
     C                   IF        FNTXOD <> 0                                                CGL132
     C                   EVAL      ZDAYNO = FNTXOD                                            CGL132
     C                   EXSR      SRZDate2                                                   CGL132
     C                   MOVEL     ZDATE         DDTXOF                                       CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
      ** US Indicium TIN - override time                                                      CGL132
     C**********         EVAL      DDTXOM = FNTXOT                                   CGL132 MD026835
     C                   EVAL      WFTMST = FNTXOT                                          MD026835
     C                   EVAL      DDTXOM = *BLANKS                                         MD026835
     C                   IF        WFTMST <> *BLANKS                                        MD026835
     C                   EVAL      DDTXOM = WWHH + ':' + WWMM +                             MD026835
     C                                      ':' + WWSS                                      MD026835
     C                   ENDIF                                                              MD026835
                                                                                              CGL132
      ** US Indicium TIN - override active document                                           CGL132
     C                   EVAL      DDTXD1 = FNTXD1                                            CGL132
     C                   EVAL      DDTXD2 = FNTXD2                                            CGL132
     C                   EVAL      DDTXD3 = FNTXD3                                            CGL132
     C                   EVAL      DDTXD4 = FNTXD4                                            CGL132
     C                   EVAL      DDTXD5 = FNTXD5                                            CGL132
     C                   MOVE      FNTXS1        DDTXS1                                       CGL132
     C                   MOVE      FNTXS2        DDTXS2                                       CGL132
     C                   MOVE      FNTXS3        DDTXS3                                       CGL132
     C                   MOVE      FNTXS4        DDTXS4                                       CGL132
     C                   MOVE      FNTXS5        DDTXS5                                       CGL132
                                                                                              CGL132
      ** US Indicium TIN - comments                                                           CGL132
     C                   EVAL      DDTXC1 = %SUBST(FNTXCO:1:64)                               CGL132
     C                   EVAL      DDTXC2 = %SUBST(FNTXCO:65:64)                              CGL132
                                                                                              CGL132
      ** Exempt from FATCA                                                                    CGL132
     C                   EVAL      DDEXEM = FNEXEM                                            CGL132
                                                                                              CGL132
      ** Exemption date                                                                       CGL132
     C                   IF        FNEXED <> 0                                                CGL132
     C                   EVAL      ZDAYNO = FNEXED                                            CGL132
     C                   EXSR      SRZDate2                                                   CGL132
     C                   EVAL      DDEXEF = *BLANKS                                           CGL132
     C                   MOVEL     ZDATE         DDEXEF                                       CGL132
     C                   ELSE                                                                 CGL132
     C                   MOVE      *BLANKS       DDEXEF                                       CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
      ** Exemption time                                                                       CGL132
     C                   EVAL      WFTMST = FNEXET                                            CGL132
     C                   EVAL      DDEXET = *BLANKS                                           CGL132
     C                   IF        WFTMST <> *BLANKS                                          CGL132
     C                   EVAL      DDEXET = WWHH + ':' + WWMM +                               CGL132
     C                                      ':' + WWSS                                        CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
     C                   EVAL      DDEXEU = FNEXEU                                            CGL132
                                                                                              CGL132
      ** Exemption Remark                                                                     CGL132
     C                   EVAL      DDEXE1 = %SUBST(FNEXER:1:64)                               CGL132
     C                   EVAL      DDEXE2 = %SUBST(FNEXER:65:64)                              CGL132
     C                   EVAL      DDEXE3 = %SUBST(FNEXER:129:64)                             CGL132
     C                   EVAL      DDEXE4 = %SUBST(FNEXER:193:64)                             CGL132
                                                                                              CGL132
      ** Subject to Reporting                                                                 CGL132
     C                   EVAL      DDREPT = FNREPT                                            CGL132
                                                                                              CGL132
      ** GIIN                                                                                 CGL132
     C                   EVAL      DDGIIN = FNGIIN                                            CGL132
                                                                                              CGL132
      ** GIIN # Last Veri Date                                                                CGL132
     C                   IF        FNGIID <> 0                                                CGL132
     C                   EVAL      ZDAYNO = FNGIID                                            CGL132
     C                   EXSR      SRZDate2                                                   CGL132
     C                   EVAL      DDGIIF = *BLANKS                                           CGL132
     C                   MOVEL     ZDATE         DDGIIF                                       CGL132
     C                   ELSE                                                                 CGL132
     C                   MOVE      *BLANKS       DDGIIF                                       CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
      ** GIIN Owner                                                                           CGL132
     C                   EVAL      DDGIIO = FNGIIO                                            CGL132
                                                                                              CGL132
      ** US Tax Identification Number                                                         CGL132
     C                   EVAL      DDUTIN = FNUTIN                                            CGL132
                                                                                              CGL132
      ** US Green Card                                                                        CGL132
     C                   EVAL      DDGREC = FNGREC                                            CGL132
                                                                                              CGL132
      ** Mailing Address                                                                      CGL132
     C                   EVAL      DDMAIL = FNMAIL                                            CGL132
                                                                                              CGL132
      ** US Phone Number                                                                      CGL132
     C                   EVAL      DDPHNE = FNPHON                                            CGL132
                                                                                              CGL132
      ** FATCA Customer Type                                                                  CGL132
     C                   EVAL      DDNHTP = FNNHTY                                            CGL132
                                                                                              CGL132
      ** FATCA Customer Sub Type                                                              CGL132
     C                   EVAL      DDNHST = FNNHST                                            CGL132
                                                                                              CGL132
      ** Reporting Type                                                                       CGL132
     C                   EVAL      DDRPTT = FNRPTT                                            CGL132
                                                                                              CGL132
      ** Reporting Type Remark                                                                CGL132
     C                   EVAL      DDRPT1 = %SUBST(FNRPTR:1:64)                               CGL132
     C                   EVAL      DDRPT2 = %SUBST(FNRPTR:65:64)                              CGL132
                                                                                              CGL132
      ** Reporting type date                                                                  CGL132
     C                   IF        FNRPTD <> 0                                                CGL132
     C                   EVAL      ZDAYNO = FNRPTD                                            CGL132
     C                   EXSR      SRZDate2                                                   CGL132
     C                   EVAL      DDRPTD = *BLANKS                                           CGL132
     C                   MOVEL     ZDATE         DDRPTD                                       CGL132
     C                   ELSE                                                                 CGL132
     C                   MOVE      *BLANKS       DDRPTD                                       CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
      ** Reporting type time                                                                  CGL132
     C                   EVAL      WFTMST = FNRPTM                                            CGL132
     C                   EVAL      DDRPTM = *BLANKS                                           CGL132
     C                   IF        WFTMST <> *BLANKS                                          CGL132
     C                   EVAL      DDRPTM = WWHH + ':' + WWMM +                               CGL132
     C                                      ':' + WWSS                                        CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
     C                   EVAL      DDRPTU = FNRPTU                                            CGL132
                                                                                              CGL132
      ** High Value Account                                                                   CGL132
     C                   EVAL      DDHVAC = FNHVAC                                            CGL132
                                                                                              CGL132
      ** FATCA Information complete                                                           CGL132
     C                   EVAL      DDINFC = FNINFC                                            CGL132
                                                                                              CGL132
      ** Exception Management Flag                                                            CGL132
     C                   EVAL      DDEXMA = FNEXMA                                            CGL132
                                                                                              CGL132
      ** Exception Management Identifier                                                      CGL132
     C                   EVAL      DDEXID = FNEXID                                            CGL132
                                                                                              CGL132
     C                   IF        FNRPTT = 'C'                                               CGL132
     C                   EVAL      DDRPDE = 'ConsentReceived'                                 CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
     C                   IF        FNRPTT = 'N'                                               CGL132
     C                   EVAL      DDRPDE = 'Not Relevant'                                    CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
     C                   IF        FNRPTT = 'P'                                               CGL132
     C                   EVAL      DDRPDE = 'Pending'                                         CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
     C                   IF        FNRPTT = 'R'                                               CGL132
     C                   EVAL      DDRPDE = 'Recalcitrant'                                    CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
     C                   IF        FNRPTT = 'U'                                               CGL132
     C                   EVAL      DDRPDE = 'Unknown'                                         CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
     C                   IF        FNNHTY = 'F'                                               CGL132
     C                   EVAL      DDNHTD = 'Foreign Financial +                              CGL132
     C                                      Institution'                                      CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
     C                   IF        FNNHTY = 'N'                                               CGL132
     C                   EVAL      DDNHTD = 'Non-financial +                                  CGL132
     C                                      Entity'                                           CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
     C                   IF        FNNHTY = 'P'                                               CGL132
     C                   EVAL      DDNHTD = 'Physical Person'                                 CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
     C                   IF        FNNHTY = 'J'                                               CGL132
     C                   EVAL      DDNHTD = 'Joint Account'                                   CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
     C                   IF        FNNHTY = 'O'                                               CGL132
     C                   EVAL      DDNHTD = 'Other'                                           CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
     C                   IF        FNNHST = 'PO'                                              CGL132
     C                   EVAL      DDNHSD = 'Participating +                                  CGL132
     C                                      - Own GIIN'                                       CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
     C                   IF        FNNHST = 'PW'                                              CGL132
     C                   EVAL      DDNHSD = 'Participating +                                  CGL132
     C                                      - W/o GIIN'                                       CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
     C                   IF        FNNHST = 'PS'                                              CGL132
     C                   EVAL      DDNHSD = 'Part. w/ +                                       CGL132
     C                                      someone elses GIIN'                               CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
     C                   IF        FNNHST = 'NP'                                              CGL132
     C                   EVAL      DDNHSD = 'Non-participating'                               CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
     C                   IF        FNNHST = 'OW'                                              CGL132
     C                   EVAL      DDNHSD = 'Owner Document +                                 CGL132
     C                                      FFI'                                              CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
     C                   IF        FNNHST = 'UN'                                              CGL132
     C                   EVAL      DDNHSD = 'Unknown'                                         CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
     C                   IF        FNNHST = 'AC'                                              CGL132
     C                   EVAL      DDNHSD = 'Active'                                          CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
     C                   IF        FNNHST = 'PA'                                              CGL132
     C                   EVAL      DDNHSD = 'Passive'                                         CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
      ** Date of Birth                                                                        CGL132
     C                   IF        WWBRTH <> *ZERO                                            CGL132
     C                   MOVE      WWBRTH        ZDAYNO                                       CGL132
     C                   EXSR      SRZDate2                                                   CGL132
     C                   EVAL      WNBRTH = *BLANKS                                           CGL132
     C                   MOVEL     ZDATE         WNBRTH                                       CGL132
     C                   ELSE                                                                 CGL132
     C                   MOVE      *BLANKS       WNBRTH                                       CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
     C                   EVAL      WCDESC1 = WCDESC                                           CGL132
     C                   EVAL      WPDESC1 = WPDESC                                           CGL132
     C                   EVAL      WWCBTH1 = WWCBTH                                           CGL132
     C                   EVAL      WWBTHT1 = WWBTHT                                           CGL132
     C                   EVAL      WWCNCZ1 = WWCNCZ                                           CGL132
     C                   EVAL      WWCDOM1 = WWCDOM                                           CGL132
     C                   EVAL      WWACCZ1 = WWACCZ                                           CGL132
     C                   EVAL      WWUTIN2 = WWUTIN                                           CGL132
                                                                                              CGL132
     C                   ENDSR                                                                CGL132
                                                                                              CGL132
      *****************************************************************
      /EJECT
      *****************************************************************
      ** SRZDate2 - Format a date for output                          *
      *****************************************************************
 
     C     SRZDate2      BEGSR
 
     C                   CALLB     'ZDATE2'
     C                   PARM                    ZDAYNO
     C                   PARM                    BJDFIN
     C                   PARM                    ZDATE
     C                   PARM                    ZADATE
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** SREdit - Edit an unsigned field                              *
      *****************************************************************
 
     C     SRZedit       BEGSR
 
     C                   CALLB     'ZEDIT'
     C                   PARM                    ZFIELD
     C                   PARM                    ZADEC
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** SRInit - Initialisation
      *****************************************************************
     C     SRInit        BEGSR
 
      ** Blank outputs (except for action code within Non-A/C Holder formats)
 
     C                   MOVEL     DDACTN        ##ACTN
     C                   MOVEL     *BLANK        NaPrim
     C                   MOVEL     *BLANK        NaFATC                                       CGL132
     C                   MOVEL     *BLANK        NaFOTH                                       CGL132
     C                   MOVEL     ##ACTN        DDACTN
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** *INZSR - Initial Processing                                  *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
      **  Program Parameters
 
     C     *Entry        PLIST
 
      ** INPUTS :
      ** Return Code
      ** Non-A/C Holder file format
 
     C                   PARM                    RetCodeIn
     C                   PARM                    NahoFilFmt
     C                   PARM                    CrFAFilFmt                                   CGL132
     C                   PARM                    CrFoFilFmt                                   CGL132
 
      ** OUTPUTS :
      ** Non-A/C Holder screen formats
 
     C                   PARM                    NaPrim
     C                   PARM                    NaFATC                                       CGL132
     C                   PARM                    NaFOTH                                       CGL132
 
      ** Initialize program name
 
     C                   MOVEL     'SDNAHLCVT'   Dbpgm
 
      ** Access Bank details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       Retcd
     C                   PARM      '*FIRST  '    Option
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database error
 
     C     Retcd         IFNE      *BLANK
     C                   MOVEL     Option        Dbkey
     C                   MOVEL     'SDBANKPD'    Dbfile
     C                   MOVEL     '900'         Dbase
     C                   EXSR      *PSSR
     C                   ENDIF
                                                                                              CSW207
      ** Check if SWIFT 2007 is installed                                                     CSW207
                                                                                              CSW207
     C                   CALL      'SWIF2007'                                                 CSW207
     C                   PARM      *Blanks       RetCd                                        CSW207
                                                                                              CSW207
     C                   IF        RetCD = 'CSW2007'                                          CSW207
     C                   EVAL      CSW207 = 'Y'                                               CSW207
     C                   ENDIF                                                                CSW207
                                                                                              CSW207
      ** Check if Private Banking Module is available                                         CSW207
                                                                                              CSW207
     C                   CALL      'AOMMODR0'                                                 CSW207
     C                   PARM                    Retcd                                        CSW207
     C                   PARM      '*FIRST'      Option                                       CSW207
     C     SDMMOD        PARM      SDMMOD        DSFDY                                        CSW207
                                                                                              CSW207
     C                   IF        Retcd <> *Blanks                                           CSW207
     C                   MOVEL     'SDMMODPD'    Dbfile                                       CSW207
     C                   MOVEL     '901'         Dbase                                        CSW207
     C                   MOVEL     Option        Dbkey                                        CSW207
     C                   EXSR      *PSSR                                                      CSW207
     C                   ELSE                                                                 CSW207
     C                   IF        BGN4ST = 'Y'                                               CSW207
     C                   EVAL      wPrivBank = 'Y'                                            CSW207
     C                   ENDIF                                                                CSW207
     C                   ENDIF                                                                CSW207
                                                                                              CGL132
      ** Check if CGL132 is switched on                                                       CGL132
                                                                                              CGL132
     C                   CALLB     'AOSARDR0'                                                 CGL132
     C                   PARM      *BLANKS       @RTCD             7                          CGL132
     C                   PARM      '*VERIFY'     @OPTN             7                          CGL132
     C                   PARM      'CGL132'      @SARD                                        CGL132
     C     SCSARD        PARM      SCSARD        DSFDY                                        CGL132
                                                                                              CGL132
     C     @RTCD         IFEQ      *BLANK                                                     CGL132
     C                   MOVEL     'Y'           CGL132            1                          CGL132
     C                   ELSE                                                                 CGL132
     C                   MOVEL     'N'           CGL132                                       CGL132
     C                   ENDIF                                                                CGL132
      *                                                                                       CER047
      ** Call AOSARDR0 to check for CER047                                                    CER047
      *                                                                                       CER047
     C                   CALL      'AOSARDR0'                                                 CER047
     C                   PARM      *BLANKS       PRtcd                                        CER047
     C                   PARM      '*VERIFY'     POptn                                        CER047
     C                   PARM      'CER047'      PSard                                        CER047
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER047
      *                                                                                       CER047
     C                   IF        PRtcd = *BLANKS                                            CER047
      *                                                                                       CER047
     C                   EVAL      CER047 = 'Y'                                               CER047
      *                                                                                       CER047
     C                   ELSE                                                                 CER047
      *                                                                                       CER047
     C                   EVAL      CER047 = 'N'                                               CER047
      *                                                                                       CER047
     C                   ENDIF                                                                CER047
      *                                                                                       CER047
     C                   IF        ((PRtcd <> *BLANKS) AND                                    CER047
     C                             (PRtcd <> '*NRF   '))                                      CER047
      *                                                                                       CER047
     C     *LOCK         IN        LDA                                                        CER047
     C                   EVAL      DBase =  902                                               CER047
     C                   EVAL      DBkey =  'CER047'                                          CER047
     C                   EVAL      DBfile = 'SCSARDPD'                                        CER047
     C                   OUT       LDA                                                        CER047
     C                   EXSR      *PSSR                                                      CER047
      *                                                                                       CER047
     C                   ENDIF                                                                CER047
      *                                                                                       CER048
      ** Call AOSARDR0 to check for CER048                                                    CER048
      *                                                                                       CER048
     C                   CALL      'AOSARDR0'                                                 CER048
     C                   PARM      *BLANKS       PRtcd                                        CER048
     C                   PARM      '*VERIFY'     POptn                                        CER048
     C                   PARM      'CER048'      PSard                                        CER048
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER048
      *                                                                                       CER048
     C                   IF        PRtcd = *BLANKS                                            CER048
      *                                                                                       CER048
     C                   EVAL      CER048 = 'Y'                                               CER048
      *                                                                                       CER048
     C                   ELSE                                                                 CER048
      *                                                                                       CER048
     C                   EVAL      CER048 = 'N'                                               CER048
      *                                                                                       CER048
     C                   ENDIF                                                                CER048
      *                                                                                       CER048
     C                   IF        ((PRtcd <> *BLANKS) AND                                    CER048
     C                             (PRtcd <> '*NRF   '))                                      CER048
      *                                                                                       CER048
     C     *LOCK         IN        LDA                                                        CER048
     C                   EVAL      DBase = 903                                                CER048
     C                   EVAL      DBkey =  'CER048'                                          CER048
     C                   EVAL      DBfile = 'SCSARDPD'                                        CER048
     C                   OUT       LDA                                                        CER048
     C                   EXSR      *PSSR                                                      CER048
      *                                                                                       CER048
     C                   ENDIF                                                                CER048
      *                                                                                       CER054
      ** Call AOSARDR0 to check for CER054                                                    CER054
      *                                                                                       CER054
     C                   CALL      'AOSARDR0'                                                 CER054
     C                   PARM      *BLANKS       PRtcd                                        CER054
     C                   PARM      '*VERIFY'     POptn                                        CER054
     C                   PARM      'CER054'      PSard                                        CER054
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER054
      *                                                                                       CER054
     C                   IF        PRtcd = *BLANKS                                            CER054
      *                                                                                       CER054
     C                   EVAL      CER054 = 'Y'                                               CER054
      *                                                                                       CER054
     C                   ELSE                                                                 CER054
      *                                                                                       CER054
     C                   EVAL      CER054 = 'N'                                               CER054
      *                                                                                       CER054
     C                   ENDIF                                                                CER054
      *                                                                                       CER054
     C                   IF        ((PRtcd <> *BLANKS) AND                                    CER054
     C                             (PRtcd <> '*NRF   '))                                      CER054
      *                                                                                       CER054
     C     *LOCK         IN        LDA                                                        CER054
     C                   EVAL      DBase = 904                                                CER054
     C                   EVAL      DBkey =  'CER054'                                          CER054
     C                   EVAL      DBfile = 'SCSARDPD'                                        CER054
     C                   OUT       LDA                                                        CER054
     C                   EXSR      *PSSR                                                      CER054
      *                                                                                       CER054
     C                   ENDIF                                                                CER054
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      ********************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2004
