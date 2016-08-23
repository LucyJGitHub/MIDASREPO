     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL Validate TI Account')                         *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GLVTIAC    - Validate TI Account                             *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. 230445             Date 03Nov14               *
      *  Prev Amend No. MD030198           Date 30Aug14               *
      *                 TI010206           Date 06May13               *
      *                 CSD091             Date 04Jul11               *
      *                 BUG23497           Date 21Mar09               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CDL038             Date 10May05               *
      *                 BUG6597            Date 21Apr05               *
      *                 BUG5340            Date 07Apr05               *
      *                 BUG4062            Date 23Aug04               *
      *                 BUG3365            Date 25Jun04               *
      *                 CGL029             Date 01Sep03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CAP035  *CREATE    Date 19Mar99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  230445 - Do not accept 'Y' as TI account flag if the customer*
      *           is a non-TI customer.                               *
      *  MD030198 - Repeating TI Account Suffix warning message       *
      *             and database error in AMAD                        *
      *  TI010206- Error on Manual Open of Account for TI Customer    *
      *            with alphanumeric customer number. Applied for     *
      *            MD026906.                                          *
      *  CSD091 - Overrideable Errors Configurability Enabler Phase 2 *
      *  BUG23497 - Applied Fix 249278                                *
      *  249278 - Set *IN84 = '1' when action code is 'D'. Also add   *
      *           condition when DDACTN is not equal to 'D' to allow  *
      *           closure of TI account.                              *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  BUG6597 - Do not allow input of different accounts with      *
      *            duplicate TI key fields.  Applied fix 230076.      *
      *  BUG5340 - Validate TI account details.                       *
      *  BUG4062 - Rework TI account validation for WIP.              *
      *  BUG3365 - Add TI account validation.                         *
      *  CGL029 - Increase account code to 10 digits                  *
      *  CAP035 - Midas/ToF Interface                                 *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *****************************************************************
 
      ** GL Accounts by branch, TI A/c no and TI A/c suffix
     FACCNTTI   IF   E           K DISK    INFSR(*PSSR)
 
      ** SD Account Codes Retrieval
     FSDACODL1  IF   E           K DISK    INFSR(*PSSR)
 
      ** SD Customer Detail Retrieval                                                         230445
     FSDCUSTL1  IF   E           K DISK    INFSR(*PSSR)                                       230445
                                                                                              230445
      ** SD Trade innovation account types retrieval                                         BUG3365
     FSDTIACL1  IF   E           K DISK    INFSR(*PSSR)                                      BUG3365
                                                                                             BUG3365
      ** SD Midas Currency ISO codes table                                                   BUG3365
     FSDISOCL0  IF   E           K DISK    INFSR(*PSSR)                                      BUG3365
                                                                                             BUG3365
      *                                                                                      BUG5340
      ** GL Midas Accounts Details Shadow File                                               BUG5340
      *                                                                                      BUG5340
     FGLACSHL3  IF   E           K DISK    INFSR(*PSSR)                                      BUG5340
     F                                     RENAME(ACCNTABF:ACCNTTIF)                         BUG5340
     F                                     PREFIX(SH_)                                       BUG5340
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
 
      ** The maximum size of the appended error arrays
     D XArrayMax       C                   CONST(20)
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Array of Fields in error.
     D FldNamXAr       S             10A   DIM(XArrayMax)
 
      ** Array of error message IDs
     D MsgIDXAr        S                   DIM(XArrayMax) LIKE(#MsgId)
 
      ** Array of error message data.
     D MsgDtaXAr       S                   DIM(XArrayMax) LIKE(#MsgData)
 
      ** Array of Fields with warnings.
     D WFldNmXAr       S             10A   DIM(XArrayMax)
 
      ** Array of warning message IDs
     D WMsgIDXAr       S                   DIM(XArrayMax) LIKE(#MsgId)
 
      ** Array of warning message data.
     D WMsgDtXAr       S                   DIM(XArrayMax) LIKE(#MsgData)
 
      ** External data structure for branch codes file
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
 
      ** External data structure for access programs (long)
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** TI ICD details                                                                      BUG3365
     D SDTIIN        E DS                  EXTNAME(SDTIINPD)                                 BUG3365
                                                                                             BUG3365
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
                                                                                             BUG3365
      ** Index for arrays of warning message ids etc                                         BUG3365
     D WIdx            S              3P 0                                                   BUG3365
                                                                                              CGL029
     D ACODX           S             10                                                       CGL029
     D DDACOD          S             10                                                       CGL029
      *                                                                                       CGL029
     D DSSDY         E DS                  EXTNAME(DSSDY)                                     CGL029
      *                                                                                      BUG5340
      ** Data structure for Midas SAR Details                                                BUG5340
      *                                                                                      BUG5340
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                 BUG5340
      *                                                                                      BUG5340
     D Indicators      DS                  BASED(IndicatorP)                                 BUG3365
     D  RcdNotFnd             85     85                                                      BUG3365
                                                                                             BUG3365
      ** Indicator Array                                                                     BUG3365
     DIndicatorP       S               *   INZ(%ADDR(*IN))                                   BUG3365
 
     D CSD012          S              1A                                                     BUG5340
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
 
     C                   MoveL     *Blanks       RetCodeIn
     C**********         MoveL     *Blanks       FldNamXAr                                   BUG5340
     C**********         MoveL     *Blanks       MsgIDXAr                                    BUG5340
     C**********         MoveL     *Blanks       MsgDtaXAr                                   BUG5340
     C**********         Z-Add     0             Idx                                         BUG5340
      *
      ** If Midas/TI Interface is on then:
      *
     C     BGN3ST        IFEQ      'Y'                                          B01
      *
     C                   MOVE      *OFF          WIN89
      *
      ** validate TI Account
      *
     C     DDTIAC        IFNE      'Y'                                          B02
     C     DDTIAC        ANDNE     'N'
     C                   Move      'N'           DDTIACOk
     C                   Add       1             Idx
     C                   MoveL     'DDTIAC'      FldNamXAr(Idx)
     C                   MoveL     'RE71113'     MsgIDXAr(Idx)
     C                   ENDIF                                                  E02
      *                                                                                      BUG3365
     C                   CALL      'AOBRCHR1'                                                BUG3365
     C                   PARM      '*MSG   '     @RTCD                                       BUG3365
     C                   PARM      '*KEY   '     @OPTN                                       BUG3365
     C                   PARM                    DDBRCA                                      BUG3365
     C     SDBRCH        PARM      SDBRCH        DSSDY                                       BUG3365
      *                                                                                      BUG4062
      ** TI account should be unique as there is only one BICN per CCY per branch            BUG4062
      ** but if there was a duplication it would be picked up here.                          BUG4062
     C     DDTIAN        IFNE      *BLANKS                                      B02          BUG4062
     C     DDTIAS        ANDNE     *BLANKS                                                   BUG4062
     C     WACCNT        CHAIN     ACCNTTI                            84                     BUG4062
     C                   MOVE      CNUM          CNUMA                                       BUG4062
     C                   MOVE      ACOD          ACODA                                       BUG4062
     C                   MOVE      ACSQ          ACSQA                                       BUG4062
      *                                                                                      BUG4062
      ***However*ignore*'this'*account*if*find*it*on*ACCNTTI*view*during*an*amend.   BUG40622 249278
      ** However ignore 'this' account if find it on ACCNTTI view                             249278
      ** during an amend or closure.                                                          249278
     C     DDACTN        IFEQ      'A'                                          B03          BUG4062
     C     DDACTN        OREQ      'D'                                                        249278
     C*****DDBRCA        ANDEQ     BRCA                                               BUG4062 249278
     C     DDBRCA        IFEQ      BRCA                                                       249278
     C     DDCUSN        ANDEQ     CNUMA                                                     BUG4062
     C     DDCCY         ANDEQ     CCY                                                       BUG4062
     C     DDACOD        ANDEQ     ACODA                                                     BUG4062
     C     DDACSQ        ANDEQ     ACSQA                                                     BUG4062
     C                   MOVE      '1'           *IN84                                       BUG4062
     C                   ENDIF                                                                249278
     C                   ENDIF                                                  E03          BUG4062
     C     *IN84         IFEQ      '0'                                          B03          BUG4062
     C                   Move      'N'           DDTIACOk                                    BUG4062
     C                   Move      'N'           DDTIANOk                                    BUG4062
     C                   Move      'N'           DDTIASOk                                    BUG4062
     C                   Add       1             Idx                                         BUG4062
     C                   MoveL     'DDTIAS'      FldNamXAr(Idx)                              BUG4062
     C                   MoveL     'RE71060'     MsgIDXAr(Idx)                               BUG4062
     C                   ENDIF                                                  E03          BUG4062
     C                   ENDIF                                                  E02          BUG4062
      *
     C** validate TI Account: if TI Account is 'Y'
     C** then TI Account Type on SDACODPD must not be blank
      *
     C     DDTIAC        IFEQ      'Y'                                          B02
     C     DDACOD        CHAIN     SDACODL1                           81
      *
     C     *IN81         IFEq      *Off                                         B03
      *
     C     A5TIAT        IFEQ      *BLANKS                                      B04
     C                   Move      'N'           DDTIACOk
     C                   Add       1             Idx
     C                   MoveL     'DDTIAC'      FldNamXAr(Idx)
     C                   MoveL     'RE71064'     MsgIDXAr(Idx)
     C                   ENDIF                                                  E04
      *
     C                   ELSE                                                   X03
     C                   Move      'N'           DDTIACOk
     C                   Add       1             Idx
     C                   MoveL     'DDTIAC'      FldNamXAr(Idx)
     C                   MoveL     'RE71062'     MsgIDXAr(Idx)
     C                   ENDIF                                                  E03
      *
      ** Validate TI Account Number: if TI Account is 'Y' then
      ** if Branch Internal Customer is not the Customer Number
      ** from the Account file then TI Account Number must be the
      ** Account Customer
      *
      ** Following section is to default the TI account data based on three conditions.      BUG3365
      ** Only default if sequence is not already keyed on screen                             BUG3365
      *                                                                                      BUG3365
     C     DDTIAS        IFEQ      *BLANKS                                      B03          BUG3365
      *                                                                                      BUG3365
      **************************************************************************             BUG3365
      ** First of three cases. Deafauts for SP101 internal account.                          BUG3365
      ** It the  customer then default the basic number into the TI customer                 BUG3365
     C     DDACOD        CHAIN     SDACODL1                           86                     BUG3365
     C     *IN86         IFEQ      *OFF                                         B04          BUG3365
     C                   MOVE      A5TIAT        CKTIAT            2                         BUG3365
     C                   ENDIF                                                  E04          BUG3365
      *  Retrieve TI Details                                                                 BUG3365
     C                   CALL      'AOTIINR0'                                                BUG3365
     C                   PARM      '*MSG'        W0RTCD            7                         BUG3365
     C                   PARM      '*FIRST'      W0OPTN            7                         BUG3365
     C     SDTIIN        PARM      SDTIIN        DSFDY                                       BUG3365
      *                                                                                      BUG3365
     C     CKTIAT        IFEQ      TIATYP                                       B04          BUG3365
      *                                                                                      BUG3365
      ** This is an SP101 Acount - apply defaults.                                           BUG3365
      ** Place SP101 basic number into left side of TI account number.                       BUG3365
     C                   MOVEL     TIBCNO        DDTIAN                                      BUG3365
      *  Retrieve TI Details                                                                 BUG3365
     C     DDCCY         CHAIN     SDISOCL0                           83                     BUG3365
     C     *IN83         IFEQ      *OFF                                         B05          BUG3365
     C     DDTIAN        ANDEQ     *BLANKS                                                   BUG3365
      ** Place CCY ISO number into right side of TI account number.                          BUG3365
     C                   MOVE      GIISO3        DDTIAN                                      BUG3365
     C                   ENDIF                                                  E05          BUG3365
      ** DDTIAS cannot be defaulted, as it is the ISO number of a related                    BUG3365
      ** currency account, must be set manually.                                             BUG3365
      *                                                                                      BUG3365
     C                   ELSE                                                   X04          BUG3365
      *                                                                                      BUG3365
      **************************************************************************             BUG3365
      ** Second of three cases. Deafauts for BICN customer account.                          BUG3365
      ** If BICN customer then default the basic number into the TI customer                 BUG3365
     C     A8BICN        IFEQ      DDCUSN                                       B05          BUG3365
     C     DDTIAN        IFEQ      *BLANKS                                      B06          BUG3365
     C     A5TIAT        CHAIN     SDTIACL1                           82                     BUG3365
     C     *IN82         IFEQ      *OFF                                         B07          BUG3365
     C                   MOVE      GDBCNO        DDTIAN                                      BUG3365
      * Output default warning message                                                       BUG3365
     C**********         Move      'N'           DDTIANOk                             BUG3365 CSD091
     C**********         Add       1             WIdx                                BUG3365 BUG4062
     C**********         EVAL      WFldNmXAr(WIdx) = 'DDTIAN'                        BUG3365 BUG4062
     C**********         EVAL      WMsgIdXar(WIdx) = 'RE71065'                       BUG3365 BUG4062
     C**********         Add       1             Idx                                  BUG4062 CSD091
     C**********         MoveL     'DDTIAN'      FldNamXAr(Idx)                       BUG4062 CSD091
     C**********         MoveL     'RE71065'     MsgIDXAr(Idx)                        BUG4062 CSD091
     C                   EVAL      DDTIANOk = 'W'                                             CSD091
     C                   ADD       1             WIdx                                         CSD091
     C                   EVAL      WFldNmXAr(WIdx) = 'DDTIAN'                                 CSD091
     C                   EVAL      WMsgIdXar(WIdx) = 'RE71065'                                CSD091
      *                                                                                      BUG4062
     C                   ENDIF                                                  E07          BUG3365
     C                   ENDIF                                                  E06          BUG3365
     C     DDTIAS        IFEQ      *BLANKS                                      B06          BUG3365
     C     DDCCY         CHAIN     SDISOCL0                           83                     BUG3365
     C     *IN83         IFEQ      *OFF                                         B07          BUG3365
     C                   MOVE      GIISO3        DDTIAS                                      BUG3365
      * Output default warning message                                                       BUG3365
     C**********         Move      'N'           DDTIASOk                             BUG3365 CSD091
     C**********         Add       1             WIdx                                BUG3365 BUG4062
     C**********         EVAL      WFldNmXAr(WIdx) = 'DDTIAS'                        BUG3365 BUG4062
     C**********         EVAL      WMsgIdXar(WIdx) = 'RE71066'                       BUG3365 BUG4062
     C**********         Add       1             Idx                                  BUG4062 CSD091
     C**********         MoveL     'DDTIAS'      FldNamXAr(Idx)                       BUG4062 CSD091
     C**********         MoveL     'RE71066'     MsgIDXAr(Idx)                        BUG4062 CSD091
     C                   EVAL      DDTIASOk = 'W'                                             CSD091
     C                   ADD       1             WIdx                                         CSD091
     C                   EVAL      WFldNmXAr(WIdx) = 'DDTIAS'                                 CSD091
     C                   EVAL      WMsgIdXar(WIdx) = 'RE71066'                                CSD091
      *                                                                                      BUG3365
     C                   ENDIF                                                  E07          BUG3365
     C                   ENDIF                                                  E06          BUG3365
      *                                                                                      BUG3365
      ***TI*account*should*be*unique*as*there*is*only*one*BICN*per*CCY*per*branch    BUG3365 BUG4062
      ***but*if*there*was*a*duplication*it*would*be*picked*up*here.                  BUG3365 BUG4062
     C*****WACCNT        CHAIN     ACCNTTI                            84             BUG3365 BUG4062
     C******IN84         IFEQ      *OFF                                         B06  BUG3365 BUG4062
     C**********         Move      'N'           DDTIACOk                            BUG3365 BUG4062
     C**********         Move      'N'           DDTIANOk                            BUG3365 BUG4062
     C**********         Move      'N'           DDTIASOk                            BUG3365 BUG4062
     C**********         Add       1             Idx                                 BUG3365 BUG4062
     C**********         MoveL     'DDTIAC'      FldNamXAr(Idx)                      BUG3365 BUG4062
     C**********         MoveL     'RE71060'     MsgIDXAr(Idx)                       BUG3365 BUG4062
     C**********         ENDIF                                                  E06  BUG3365 BUG4062
      *                                                                                      BUG3365
      **************************************************************************             BUG3365
      ** Third of three cases. Deafauts for non BICN customer account.                       BUG3365
      ** If non BICN customer then default that into a blank TI customer                     BUG3365
      *                                                                                      BUG3365
     C                   ELSE                                                   X05          BUG3365
     C                   MOVE      DDCUSN        DDTIAN                                      BUG3365
      * Output default warning message                                                       BUG3365
     C**********         Move      'N'           DDTIANOk                             BUG3365 CSD091
     C**********         Add       1             WIdx                                BUG3365 BUG4062
     C**********         EVAL      WFldNmXAr(WIdx) = 'DDTIAN'                        BUG3365 BUG4062
     C**********         EVAL      WMsgIdXar(WIdx) = 'RE71065'                       BUG3365 BUG4062
     C**********         Add       1             Idx                                  BUG4062 CSD091
     C**********         MoveL     'DDTIAN'      FldNamXAr(Idx)                       BUG4062 CSD091
     C**********         MoveL     'RE71065'     MsgIDXAr(Idx)                        BUG4062 CSD091
     C                   EVAL      DDTIANOk = 'W'                                             CSD091
     C                   ADD       1             WIdx                                         CSD091
     C                   EVAL      WFldNmXAr(WIdx) = 'DDTIAN'                                 CSD091
     C                   EVAL      WMsgIdXar(WIdx) = 'RE71065'                                CSD091
      *                                                                                      BUG3365
     C                   MOVE      '001'         DDTIAS                                      BUG3365
     C                   MOVE      *BLANKS       WrkWARN           1                        MD030198
      *                                                                                      BUG3365
      ** Check if TI account is already already in use, must be unique key.                  BUG3365
     C     RcdNotFnd     DOUEQ     True                                         B06          BUG3365
      *                                                                                      BUG3365
     C     WACCNT        CHAIN     ACCNTTI                            85                     BUG3365
     C                   MOVE      CNUM          CNUMA             6                         BUG3365
     C                   MOVE      ACOD          ACODA            10                         BUG3365
     C**********         MOVE      ACSQ          ACSQA             4                 BUG3365 BUG4062
     C                   MOVE      ACSQ          ACSQA             2                         BUG4062
      *                                                                                      BUG3365
      ** However ignore 'this' account if find it on ACCNTTI view during an amend.           BUG3365
     C     DDACTN        IFEQ      'A'                                          B07          BUG3365
     C     DDBRCA        ANDEQ     BRCA                                                      BUG3365
     C     DDCUSN        ANDEQ     CNUMA                                                     BUG3365
     C     DDCCY         ANDEQ     CCY                                                       BUG3365
     C     DDACOD        ANDEQ     ACODA                                                     BUG3365
     C     DDACSQ        ANDEQ     ACSQA                                                     BUG3365
     C                   MOVE      '1'           *IN85                                       BUG3365
     C                   ENDIF                                                  E07          BUG3365
      *                                                                                      BUG3365
     C     RcdNotFnd     IFEQ      False                                        B07          BUG3365
     C                   MOVE      DDTIAS        DDTIASN           3 0                       BUG3365
     C                   ADD       1             DDTIASN                                     BUG3365
     C                   MOVE      DDTIASN       DDTIAS                                      BUG3365
      *                                                                                     MD030198
      ** Output default warning message                                                     MD030198
     C                   IF        WrkWARN  <> 'Y'                                          MD030198
     C                   EVAL      DDTIASOk = 'W'                                           MD030198
     C                   ADD       1             WIdx                                       MD030198
     C                   EVAL      WFldNmXAr(WIdx) = 'DDTIAS'                               MD030198
     C                   EVAL      WMsgIdXar(WIdx) = 'RE71066'                              MD030198
     C                   MOVE      'Y'           WrkWARN                                    MD030198
     C                   ENDIF                                                              MD030198
      *                                                                                      BUG3365
      ** Error if sequence counts above 999.                                                 BUG3365
     C     DDTIASN       IFEQ      0                                            B08          BUG3365
     C                   Move      'N'           DDTIASOk                                    BUG3365
     C                   RETURN                                                              BUG3365
     C                   ENDIF                                                  E08          BUG3365
     C                   ENDIF                                                  E07          BUG3365
      **Output*default*warning*message***************************                   BUG3365 MD030198
     C**********         Move      'N'           DDTIASOk                             BUG3365 CSD091
     C**********         Add       1             WIdx                                BUG3365 BUG4062
     C**********         EVAL      WFldNmXAr(WIdx) = 'DDTIAS'                        BUG3365 BUG4062
     C**********         EVAL      WMsgIdXar(WIdx) = 'RE71066'                       BUG3365 BUG4062
     C**********         Add       1             Idx                                  BUG4062 CSD091
     C**********         MoveL     'DDTIAS'      FldNamXAr(Idx)                       BUG4062 CSD091
     C**********         MoveL     'RE71066'     MsgIDXAr(Idx)                        BUG4062 CSD091
     C**********         EVAL      DDTIASOk = 'W'                                    CSD091 MD030198
     C**********         ADD       1             WIdx                                CSD091 MD030198
     C**********         EVAL      WFldNmXAr(WIdx) = 'DDTIAS'                        CSD091 MD030198
     C**********         EVAL      WMsgIdXar(WIdx) = 'RE71066'                       CSD091 MD030198
      *                                                                                      BUG3365
     C                   ENDDO                                                  E06          BUG3365
     C                   ENDIF                                                  E05          BUG3365
     C                   ENDIF                                                  E04          BUG3365
     C                   ENDIF                                                  E03          BUG3365
      *                                                                                      BUG3365
     C**********         CALL      'AOBRCHR0'                                                 CGL029
     C**********         CALL      'AOBRCHR1'                                         CGL029 BUG3365
     C**********         PARM      '*MSG   '     @RTCD                                       BUG3365
     C**********         PARM      '*KEY   '     @OPTN                                       BUG3365
     C**********         PARM                    DDBRCA                                      BUG3365
     C*****SDBRCH        PARM      SDBRCH        DSFDY                                        CGL029
     C*****SDBRCH        PARM      SDBRCH        DSSDY                                CGL029 BUG3365
     C*
     C*****@RTCD         IFNE      *BLANKS                                                   BUG3365
     C*****A8BICN        ORNE      DDCUSN                                                    BUG3365
     C     A8BICN        IFNE      DDCUSN                                       B03          BUG3365
     C     DDTIAN        ANDNE     DDCUSN
     C                   Move      'N'           DDTIANOk
     C                   Add       1             Idx
     C                   MoveL     'DDTIAN'      FldNamXAr(Idx)
     C                   MoveL     'RE71067'     MsgIDXAr(Idx)
     C                   ENDIF                                                  E03
      *                                                                                       230445
      ** Validate TI account flag based on the account customer                               230445
      *                                                                                       230445
     C     DDCUSN        CHAIN     SDCUSTL1                           81                      230445
      *                                                                                       230445
     C     *IN81         IFEq      *Off                                                       230445
      *                                                                                       230445
     C     BBTICS        IFNE      'Y'                                                        230445
     C     A8BICN        ANDNE     DDCUSN                                                     230445
     C                   Move      'N'           DDTIACOk                                     230445
     C                   Add       1             Idx                                          230445
     C                   MoveL     'DDTIAC'      FldNamXAr(Idx)                               230445
     C                   MoveL     'RE71878'     MsgIDXAr(Idx)                                230445
     C                   ENDIF                                                                230445
     C                   ENDIF                                                                230445
      *
      ** TI Account Number can be any value except 000000,
      *
     C**********         TESTN                   DDTIAN               87            BUG3365 TI010206
     C*****DDTIAN        IFEQ      *ZERO                                        B03         TI010206
     C*****DDTIAN        OREQ      *BLANKS                                                  TI010206
     C     DDTIAN        IFEQ      *BLANKS                                                  TI010206
     C******IN87         OREQ      '0'                                              BUG3365 TI010206
     C                   Move      'N'           DDTIANOk
     C                   Add       1             Idx
     C                   MoveL     'DDTIAN'      FldNamXAr(Idx)
     C                   MoveL     'RE71061'     MsgIDXAr(Idx)
     C                   ENDIF                                                  E03
      *
     C                   TESTN                   DDTIAS               87                     BUG3365
     C     DDTIAS        IFEQ      *ZERO                                        B03          BUG3365
     C     DDTIAS        OREQ      *BLANKS                                                   BUG3365
     C     *IN87         OREQ      '0'                                                       BUG3365
     C                   Move      'N'           DDTIASOk                                    BUG3365
     C                   Add       1             Idx                                         BUG3365
     C                   MoveL     'DDTIAS'      FldNamXAr(Idx)                              BUG3365
     C                   MoveL     'RE71071'     MsgIDXAr(Idx)                               BUG3365
     C                   ENDIF                                                  E03          BUG3365
      *                                                                                      BUG3365
      ** validate unique details: if TI Account is 'Y' then
      **   if user has changed TI Account field from 'N' to 'Y' then
      **   for Branch Internal Customer accounts:
      **     Midas account branch combined with TI Account Number
      **     and TI Account Suffix must be unique across all accounts.
      **   for non-Branch Internal Customer accounts:
      **     Midas Account Branch combined with TI Account Number, Ccy
      **     and TI Account Type must be unique across all accounts.
      *
     C     DDACTN        IFNE      'D'                                                        249278
      *                                                                                       249278
     C     DDTIAC        IFNE      AMTIAC                                       B03
      *
     C     A8BICN        IFEQ      DDCUSN                                       B04
      *
      ** it is a Branch Internal Customer account
      *
     C     DDTIAN        IFNE      *BLANKS                                      B05          BUG4062
     C     DDTIAS        ANDNE     *BLANKS                                                   BUG4062
     C*****WACCNT        CHAIN     ACCNTTI                            81        B05          BUG4062
     C     WACCNT        CHAIN     ACCNTTI                            81                     BUG4062
     C                   MOVE      CNUM          CNUMA                                       BUG4062
     C                   MOVE      ACOD          ACODA                                       BUG4062
     C                   MOVE      ACSQ          ACSQA                                       BUG4062
      *                                                                                      BUG4062
      ** However ignore 'this' account if find it on ACCNTTI view during an amend.           BUG4062
     C     DDACTN        IFEQ      'A'                                          B07          BUG4062
     C     DDBRCA        ANDEQ     BRCA                                                      BUG4062
     C     DDCUSN        ANDEQ     CNUMA                                                     BUG4062
     C     DDCCY         ANDEQ     CCY                                                       BUG4062
     C     DDACOD        ANDEQ     ACODA                                                     BUG4062
     C     DDACSQ        ANDEQ     ACSQA                                                     BUG4062
     C                   MOVE      '1'           *IN81                                       BUG4062
     C                   ENDIF                                                  E07          BUG4062
     C******IN81         IFEQ      *OFF                                                      BUG4062
     C     *IN81         IFEQ      '0'                                          B06          BUG4062
     C                   Move      'N'           DDTIACOk
     C                   Move      'N'           DDTIANOk
     C                   Move      'N'           DDTIASOk
     C                   Add       1             Idx
     C                   MoveL     'DDTIAC'      FldNamXAr(Idx)
     C                   MoveL     'RE71060'     MsgIDXAr(Idx)
     C                   ENDIF                                                  E06          BUG4062
     C                   ENDIF                                                  E05
      *
     C                   ELSE                                                   X04
      *
      ** it is a non-Branch Internal Customer account, so:
      ** save the TI Account Type of current account as W#TIAT
      ** Let W#FLAG be 'Y' when current account is not unique.
      *
     C                   MOVE      'N'           W#FLAG            1
     C     DDACOD        CHAIN     SDACODL1                           76
     C     *IN76         IFEQ      *OFF                                         B05
     C                   MOVE      A5TIAT        W#TIAT            2
      *
     C     WACCNT        CHAIN     ACCNTTI                            76
     C     *IN76         DOWEQ     *OFF                                         B06
     C**********         MOVE      ACOD          ACODX             4                          CGL029
     C                   MOVE      ACOD          ACODX                                        CGL029
     C     ACODX         CHAIN     SDACODL1                           76
     C     *IN76         IFEQ      *OFF                                         B07
     C*****DDCCY         ANDEQ     CCY                                                       BUG6597
     C*****W#TIAT        ANDEQ     A5TIAT                                                    BUG6597
     C                   MOVE      'Y'           W#FLAG
     C                   ENDIF                                                  E07
     C                   READE     ACCNTTI                                76
     C                   ENDDO                                                  E06
      *
     C                   ELSE                                                   X05
     C                   MOVE      'Y'           W#FLAG
     C                   ENDIF                                                  E05
      *
      * now look at W#TIAT to determine *IN76
      *
     C                   Move      *In76         WIN76
      *
     C     W#FLAG        IFEQ      'Y'                                          B05
     C                   Move      'N'           DDTIACOk
     C                   Move      'N'           DDTIANOk
     C                   Move      'N'           DDTIASOk
     C                   Add       1             Idx
     C                   MoveL     'DDTIAC'      FldNamXAr(Idx)
     C                   MoveL     'RE71069'     MsgIDXAr(Idx)
     C                   Move      *On           WIN76
     C                   Else                                                   X05
     C                   Move      *Off          WIN76
     C                   ENDIF                                                  E05
      *
     C                   ENDIF                                                  E04
      *
     C                   ENDIF                                                  E03
      *                                                                                       249278
     C                   ENDIF                                                                249278
      **
      ** set on WIN89 if user allowed to amend TI Account N0. & Suffix:
      **   cannot amend these fields unless:
      **      1) Inserting and DDTIAC='Y'
      **   or 2) Amending and DDTIAC='Y' and A5TIAN & A5TIAS blank
      **
     C     DDACTN        IFEQ      'I'                                          B03
     C     DDACTN        OREQ      'A'
     C     A5TIAN        ANDEQ     *BLANKS
     C     A5TIAS        ANDEQ     *BLANKS
     C                   MOVE      *ON           WIN89
     C                   ENDIF                                                  E03
      *                                                                                      BUG5340
      ** Validate GL Account Shadows file                                                    BUG5340
      *                                                                                      BUG5340
     C                   IF        DDACTN = 'I' AND CSD012 = 'Y'                             BUG5340
     C                             AND DDTIAC = 'Y'                                          BUG5340
     C                             AND DDBRCA <> *BLANKS                                     BUG5340
     C                             AND DDTIAN <> *BLANKS                                     BUG5340
     C                             AND DDTIAS <> *BLANKS                                     BUG5340
     C     WACCNT        CHAIN     GLACSHL3                                                  BUG5340
     C                   IF        %FOUND                                                    BUG5340
     C                   EVAL      DDTIANOk = 'W'                                             CSD091
     C                   Add       1             WIdx                                        BUG5340
     C                   EVAL      WFldNmXAr(WIdx) = 'DDTIAN'                                BUG5340
     C                   EVAL      WMsgIdXar(WIdx) = 'RE76020'                               BUG5340
     C                   ENDIF                                                               BUG5340
     C                   ENDIF                                                               BUG5340
      *
     C                   ELSE                                                   X02
      *
      **   validate TI Account Number:
      **   if TI Account is 'N' and DDTIAN or DDTIAS is not blank
      **   then make DDTIAN and DDTIAS blank and send warning message
      *
     C     DDTIAC        IFEQ      'N'                                          B03
     C     DDTIAN        IFNE      *BLANKS                                      B04
     C     DDTIAS        ORNE      *BLANKS
     C**********         MOVE      *BLANKS       DDTIAN                                      BUG4062
     C**********         MOVE      *BLANKS       DDTIAS                                      BUG4062
     C**********         MoveL     '*ANY   '     WFldNmXAr(1)                                BUG4062
     C**********         MoveL     'RE71068'     WMsgIDXAr(1)                                BUG4062
     C                   Add       1             Idx                                         BUG4062
     C                   MoveL     'DDTIAC'      FldNamXAr(Idx)                              BUG4062
     C                   MoveL     'RE71068'     MsgIDXAr(Idx)                               BUG4062
     C                   ENDIF                                                  E04
      *
     C                   ENDIF                                                  E03
      *
     C                   ENDIF                                                  E02
      *
     C                   ENDIF                                                  E01
      *
      ** If an error was found, set the return code appropriately
      *
     C     DDTIACOk      IfEq      'N'                                          B01
     C     DDTIANOk      OrEq      'N'
     C     DDTIASOk      OrEq      'N'
     C                   Eval      RetCodeIn = 'Error'
     C                   Else                                                                 CSD091
     C     DDTIANOk      IfEq      'W'                                                        CSD091
     C     DDTIASOk      OrEq      'W'                                                        CSD091
     C                   Eval      RetCodeIn = 'Warning'                                      CSD091
     C                   EndIf                                                                CSD091
     C                   EndIf                                                  E01
      *
      ** RETURN
      *
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *Entry        Plist
      *
      ** INPUTS
      *
      ** Return Code
     C                   Parm                    RetCodeIn
      *
      ** Account Screen fields
     C                   Parm                    DDACTN            1
     C                   Parm                    DDTIAC            1
     C                   Parm                    DDTIAN            6
     C                   Parm                    DDTIAS            3
     C**********         Parm                    DDACOD            4                          CGL029
     C                   Parm                    DDACOD                                       CGL029
     C                   Parm                    DDBRCA            3
     C                   Parm                    DDCUSN            6
     C                   Parm                    DDCCY             3
     C                   Parm                    DDACSQ            2                         BUG3365
      *
     C                   Parm                    AMTIAC            1
      *
      ** ICD
     C                   Parm                    BGN3ST            1
      *
      ** OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    FldNamXAr
     C                   Parm                    MsgIDXAr
     C                   Parm                    MsgDtaXAr
      *
      * Warning message IDs/message data (arrays) from/to caller
     C                   Parm                    WFldNmXAr
     C                   Parm                    WMsgIDXAr
     C                   Parm                    WMsgDtXAr
      *
      ** Indicator 76 & 89 for used in display file
     C                   Parm                    WIN76             1
     C                   Parm                    WIN89             1
      *
      ** TI Account - OK
      ** TI Account Number - OK
      ** TI Account Suffix - OK
     C                   Parm                    DDTIACOk          1
     C                   Parm                    DDTIANOk          1
     C                   Parm                    DDTIASOk          1
     C                   Parm                    Idx                                         BUG5340
     C                   Parm                    WIdx                                        BUG5340
      *                                                                                      BUG5340
      ** Access SAR details file to determine if CSD012 is on.                               BUG5340
      *                                                                                      BUG5340
     C                   CALLB     'AOSARDR0'                                                BUG5340
     C                   PARM      *BLANKS       @RTCD                                       BUG5340
     C                   PARM      '*VERIFY'     @OPTN                                       BUG5340
     C                   PARM      'CSD012'      @SARD                                       BUG5340
     C     SCSARD        PARM      SCSARD        DSFDY                                       BUG5340
      *                                                                                      BUG5340
     C     @RTCD         IFEQ      *BLANKS                                                   BUG5340
     C                   MOVE      'Y'           CSD012                                      BUG5340
     C                   ELSE                                                                BUG5340
     C                   MOVE      'N'           CSD012                                      BUG5340
     C                   ENDIF                                                               BUG5340
      *
      ** Key list to access accounts on ACCNTTI
      *
     C     WACCNT        KLIST
     C                   KFLD                    DDBRCA
     C                   KFLD                    DDTIAN
     C                   KFLD                    DDTIAS
      *
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR                                                  *** InzEnd ***
      *****************************************************************
      /EJECT
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
