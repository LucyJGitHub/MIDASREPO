     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM Invalid NAs purchased repair        ')        *
      *****************************************************************
      *                                                               *
      *  Midas - Money Market Dealing Module                          *
      *                                                               *
      *  MMNASPRPR - Invalid Negotiable Assets Purchased Repair       *
      *                                                               *
      *  Function:  This function allows invalid NAs purchased to be  *
      *             'repaired' and applied to the Midas database.     *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. MD036070           Date 19Oct15               *
      *                 LLN022A            Date 03Jun15               *
      *                 LLN022             Date 03Jun15               *
      *                 CDL094             Date 11Jun14               *
      *                 CSD095             Date 08Apr14               *
      *                 CLE134             Date 01Aug12               *
      *                 CSF011A            Date 28Nov11               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CDL049             Date 11Jul06               *
      *                 CSD027             Date 09Dec05               *
      *                 BUG9711            Date 26Jan06               *
      *                 CER001             Date 25Apr05               *
      *                 CLE031             Date 26Apr05               *
      *                 CDL038             Date 10May05               *
      *                 CAP086             Date 08Jun05               *
      *                 CDL018             Date 03Feb04               *
      *                 TDA012             Date 23Mar04               *
      *                 CSC022             Date 24Feb04               *
      *                 CGL029             Date 01Sep03               *
      *                 222727             Date 05Nov03               *
      *                 CAS005             Date 16Dec02               *
      *                 CAS004             Date 26Jun02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAS001             Date 23Nov01               *
      *                 CSC011             Date 18Sep01               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 200400             Date 20Nov01               *
      *                 192530             Date 16May01               *
      *                 192829             Date 08May01               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 179510             Date 08Nov00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 166907             Date 27Dec99               *
      * Midas DBA 3.02 Patch Z ---------------------------------------*
      *                 176883             Date 24Mar00               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CAP014             Date 10Dec99               *
      *                 CAP013             Date 07Sep99               *
      *                 CAP011             Date 07Sep99               *
      *                 168345             Date 13Oct99               *
      *                 163820             Date 09Jul99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP006             Date 11Mar99               *
      *                 CAP004             Date 01Sep98               *
      *                 141360             Date 26Aug98               *
      *                 CAP002  *CREATE    Date 12Mar98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD036070 - No way to go back to main deal details screen     *
      *             after reaching settlement screen.  Introduce new  *
      *             function key F11.                                 *
      *  LLN022A - BOE Upgrade to MidasPlus - incorporate code from   *
      *            /COPY members and add switchability.               *
      *  LLN022 - BOE Upgrade to MidasPlus.                           *
      *           Core hooks added: MMNASPRD02,MMNASPRD03,MMNASPRC06  *
      *                             MMNASPRC07,MMNASPRC09,MMNASPRC08  *
      *  CDL094 - Enhance Receive Settlement Instructions             *
      *           (Recompile)                                         *
      *  CSD095 - Allow Deal Sub-Type and Branch for MM and FX SSIs   *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG9711- Changes to MMVNASPPD/MMVNASSPD (re-compile)         *
      *  CER001 - LUX Upgrade to MidasPlus                            *
      *  CLE031 - Lending Enhancements - Settlement Currency Recompile*
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  CAP086 - Introduce Auto Authorisation to the API's           *
      *           without it.                                         *
      *  CDL018 - Multiple Settlement Accounts on Loans/Deposits      *
      *           (Recompile)                                         *
      *  TDA012 - Fix 10-digit account code processing.               *
      *  CSC022 - Commitment Control Changes for MidasPlus            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  222727 - Release 5.0 errors  (Recompile)                     *
      *  CAS005 - Enhancements to CAS001, CAS002 and CAS004           *
      *           (Recompile)                                         *
      *  CAS004 - Hedge Accounting Phase A                            *
      *  CAS001 - Net Present Value (NPV) Accounting (Recompile)      *
      *  CSC011 - 24x7 Midas Availability                             *
      *  200400 - Reverse fix 179510                                  *
      *  192530 - Pass the correct deal date/value date to ZASETINSIN *
      *  192829 - The wrong module name passed to WN0010.             *
      *  179510 - For Settlement method 04 , fields  xxMORI &  xxMOPI *
      *           Midas  Our  Receive/ Pay  Instructions  respectively*
      *           are not  correctly  updated .  Introduced  new  Data
      *           Structure  @MORPI  which is used  for that purpose .*
      *  166907 - Display 'Deal No. 999999 successfully inserted.'    *
      *           in the correct screen.                              *
      *  176883 - Errors found as a result of creating DBAR3.02       *
      *           Meridian repository file.                           *
      *           Recompiled due to mismatch between parameter calls  *
      *           to ZASETINDFT.                                      *
      *  CAP014 - Repair function enhancements                        *
      *  CAP013 - Allow access by Midas transaction ID if not insert  *
      *  CAP011 - Substitution of Midas database flds for externl i/fs*
      *  168345 - Prevent two users from accessing same transaction   *
      *           in repair screen at the same cycle, and converting  *
      *           it into two different Midas Deal No.s  .            *
      *           Second user should not be allowed to repair the tran-
      *           saction and convert it into a another Midas Deal.   *
      *  163820 - Transactions Repair Function performs SPF checking  *
      *           to find if user is authorised to the Branch , but   *
      *           does that against User's Default Branch code instead*
      *           of the selected transaction's Booking/Origin branch *
      *  CAP006 - Check for deal being updated by another workstation *
      *  CAP004 - APIs Phase 3.                                       *
      *           - Add extra parm for Extra Data                     *
      *           - Change definition of MSGTYPE to be based on file  *
      *             field                                             *
      *  141360 - NAs purchased repair fails with decimal data error  *
      *  CAP002 - Conversion of Midas inputs to modular API structure *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     FZATRNERRL0IF   E           K DISK    INFSR(*PSSR)
 
     FMMINASPL0 IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(MMINASPD0 : MMINASPX0)
     FMMINASPL1 UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
 
     FAPIDSETL0 IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(APIDSETD0:APIDSETX0)
     FAPIDSETL1 UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
 
      ** API Invalid log file by Type/FO Id/Time                                              CSC011
     FAPILOGL0  UF   E           K DISK    INFSR(*PSSR) USROPN                                CSC011
     F                                     COMMIT                                             CSC011
                                                                                              CSC011
     FMMINPLX1L0UF   E           K DISK    USROPN                                             CER001
     F                                     RENAME(MMINPLXD6:RTVIDX1)                          CER001
     F                                     INFSR(*PSSR)                                       CER001
     F                                     COMMIT                                             CER001
      * Hook to enable non-core files to be included
      /COPY WNCPYSRC,MMNASPR009
 
     FMMINPEXL0 UF   E           K DISK    INFSR(*PSSR)                                      LLN022A
     F                                     COMMIT                                            LLN022A
     F                                     USROPN                                            LLN022A
                                                                                             LLN022A
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
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
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
 
     D OkBOEFlags    E DS                  EXTNAME(MMENASPX0)                                LLN022A
                                                                                             LLN022A
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D @EI             S              1    DIM(60)
 
 
 
     D CrDlFilFmt    E DS                  EXTNAME(MMDENBPP)
      * Current Deal in File Format
     D**HLREC**              463    531                                                CAP011 CGL029
     D**HLPAY**              532   1090                                                CAP011 CGL029
     D  HLREC                477    531                                                       CGL029
     D  HLPAY                546   1090                                                       CGL029
     D**HLRECEx             1317   1334                                                CGL029 TDA012
     D**HLPAYEx             1335   1352                                                CGL029 TDA012
     D  HLRECEx             1332   1349                                                       TDA012
     D  HLPAYEx             1350   1367                                                       TDA012
 
     D CrDlScnFmt    E DS                  EXTNAME(MMNASPPD)
      * (Current) Deal in Screen Format
     D                                     PREFIX(@)
 
     D NwDlFilFmt    E DS                  EXTNAME(MMVNASPPD)
      * New Deal in File Format
     D QQDOR1        E                     EXTFLD(QQDORI)                                     CGL029
     D QQMOR1        E                     EXTFLD(QQMORI)                                     CGL029
     D QQDOP1        E                     EXTFLD(QQDOPI)                                     CGL029
     D QQMOP1        E                     EXTFLD(QQMOPI)                                     CGL029
     D QQRON1        E                     EXTFLD(QQRONS)                                     CGL029
     D QQPON1        E                     EXTFLD(QQPONS)                                     CGL029
     D**IHREC**              463    531                                                       CGL029
     D**IHPAY**              532   1090                                                       CGL029
     D  IHREC                477    531                                                       CGL029
     D  IHPAY                546   1090                                                       CGL029
     D**IHRECEx             1317   1334                                                CGL029 TDA012
     D**IHPAYEx             1335   1352                                                CGL029 TDA012
     D  IHRECEx             1332   1349                                                       TDA012
     D  IHPAYEx             1350   1367                                                       TDA012
 
     D NwDlScnFmt    E DS                  EXTNAME(MMNASPPD)
      * New Deal in Screen Format
                                                                                              CER001
      ** New Deal in File Format (#6LXVL)                                                     CER001
     D NwDlFilFmtLux E DS                  EXTNAME(MMVNPLX1PD)                                CER001
                                                                                              CER001
      ** Current Deal in File Format (VL)                                                     CER001
     D CrDlFilFmtLux E DS                  EXTNAME(MMDLX1L0)                                  CER001
                                                                                              CER001
      ** Screen Format - LUX                                                                  CER001
     D NwDlScnFmtLux E DS                  EXTNAME(MMNPRXPD)                                  CER001
                                                                                              CER001
 
     D MMENASP       E DS                  EXTNAME(MMENASPPD)
      * Error indicators
 
 
     D ##RECF        E DS                  EXTNAME(SDESFRPD)
      ** FILE RECEIVE INSTRUCTIONS
     D**FLREC**                1     69                                                       CGL029
     D  FLREC                 21     75                                                       CGL029
 
     D ##PAYF        E DS                  EXTNAME(SDESFPPD)
      *** FILE PAYMENT INSTRUCTIONS
     D**FLPAY**                1    559                                                       CGL029
     D  FLPAY                 21    565                                                       CGL029
 
     D ##FRIF        E DS                  EXTNAME(SDESFFPD)
      ** FILE FRA/IRS INSTRUCTIONS
 
     D ##RECS        E DS                  EXTNAME(SDESSRPD)
      ** SCREEN RECEIVE INSTRUCTIONS
 
     D ##PAYS        E DS                  EXTNAME(SDESSPPD)
      ** SCREEN PAYMENT INSTRUCTIONS
 
     D ##FRIS        E DS                  EXTNAME(SDESSFPD)
      ** SCREEN FRA/IRS INSTRUCTIONS
 
     D CrPaySttmt    E DS                  EXTNAME(SDESSPPD) PREFIX(@)          CAP011
      * Pay Settlement Instructions - Current                                   CAP011
                                                                                CAP011
     D CrRecSttmt    E DS                  EXTNAME(SDESSRPD) PREFIX(@)          CAP011
      * Receive Settlement Instructions - Current                               CAP011
                                                                                CAP011
     D CrFRASttmt    E DS                  EXTNAME(SDESSFPD) PREFIX(@)          CAP011
      * FRA/IRS Settlement Instructions - Current                               CAP011
                                                                                CAP011
     D @SETIN          DS
      ** Receive / Pay Settlement Currency, Method & Nostro
     D  @@RSCY                 1      3
     D  @@RSTM                 4      5  0
     D**@@RONS*                6     17                                                       CGL029
     D**@@PSCY*               18     20                                                       CGL029
     D**@@PSTM*               21     22  0                                                    CGL029
     D**@@PONS*               23     34                                                       CGL029
     D  @@RONS                 6     23                                                       CGL029
     D  @@PSCY                24     26                                                       CGL029
     D  @@PSTM                27     28  0                                                    CGL029
     D  @@PONS                29     46                                                       CGL029
 
     D                 DS
      **  Data structure for date in, to change format.
     D  DateIn                 1      8  0
     D  @@YY                   1      4  0
     D  @@MM                   5      6  0
     D  @@DD                   7      8  0
 
     D*@MORPI*****     DS                                                              179510 200400
      ***Midas*Our Receive / Pay  Instructions (for Settl Meth = 04 )                  179510 200400
     D**@@MORI****             1     12                                                179510 200400
     D**@@MOPI****            13     24                                                179510 200400
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** EXTERNAL DS FOR BANK DETAILS
 
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      ** MIDAS MODULES DETAILS ACCESSED VIA ACCESS PROGRAM
 
     D SDAPI         E DS                  EXTNAME(SDAPIPD)                     CAP011
      ** EXTERNAL DS FOR API ICD                                                CAP011
                                                                                CAP011
      *                                                                                       CER001
      ** External data structure for Currency Details file                                    CER001
      *                                                                                       CER001
     D SDCURR        E DS                  EXTNAME(SDCURRPD)                                  CER001
                                                                                              CER001
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
                                                                                              CAP086
     D InfData       E DS                  EXTNAME(MMNAIFPD)                                  CAP086
     D                                     PREFIX(IF_)                                        CAP086
      ** DL (NASP) Extra Data - File (D/B) format                                             CAP086
                                                                                CAP004
     D ExtData       E DS                  EXTNAME(MMNPEXPD)                    CAP004
      * MM NASP Extra Data - File (D/B) format                                  CAP004
                                                                                              CSC011
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CSC011
      ** External DS for SAR details                                                          CSC011
                                                                                              CSC011
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)                     CSC011
      ** 24X7 status data area                                                                CSC011
                                                                                              CSC011
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)                     CSC011
      ** SD data area                                                                         CSC011
                                                                                              CSC022
     D SCCMTJOB      E DS                  EXTNAME(SCCMTJOB) DTAARA(SCCMTJOB)                 CSC022
     D  WCMTJOBS               4    103A                                                      CSC022
      ** Commitment Control dataarea                                                          CSC022
                                                                                              CSC022
     D ValidNAData   E DS                  EXTNAME(MMINPEXL0)                                LLN022A
      ** MM Transaction Extra Data - File (D/B) format                                       LLN022A
      *                                                                                      LLN022A
      ** Array to hold commitment jobs name                                                   CSC022
     D WCMT            S             10A   DIM(10)                                            CSC022
 
     D/COPY QWINDSRC,MMNASPSDTA
                                                                                              CER001
     D DATALUX         DS          1024                                                       CER001
     D  L1FLD1                 1      6  0                                                    CER001
     D  L1DN38                 1      6                                                       CER001
     D  L1DLTP                 7      8                                                       CER001
     D  L1CNUM                 9     14                                                       CER001
     D  L1CCY                 15     17                                                       CER001
     D  L1AMNT                18     32  0                                                    CER001
     D  L1VDAT                33     38                                                       CER001
     D  L1MDAT                39     44                                                       CER001
     D  L1FOTR                45     64                                                       CER001
     D  L1TMST                65     90Z                                                      CER001
     D  #1DEXT                91     91                                                       CER001
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      **   Timestamp selected
     D @TMESTPSEL      S             26Z
 
      ** Response Mode, passed as a constant parameter to the VAL module
      ** This is always 'S' for Synchronous
     D RespMode        S              1A   INZ('S')
 
      ** -------------------------------------------------------------------
      ** Fields for getting the starting field number from file (parameters
      ** to ZAGETFLDNO, plus the offset to the requested field).
     D Format          S             10A   INZ('MMNASPPD')
 
     D Field           S             10A   INZ('DDACTN')
     D FieldExt        S             10A   INZ('L6LXLUSU')                                    CER001
 
     D FieldNo         S              5P 0
 
     D FldOffset       S              5P 0
     D FldOffsetExt    S              5P 0                                                    CER001
 
      ** End of fields for getting starting field number
      ** -------------------------------------------------------------------
 
      ** Message type field for chaining to APIDSETPD; defined in terms         CAP004
      ** of the file field when the file field was changed.                     CAP004
     D @MSGTYPE        S                   LIKE(DDMSGTYPE)                      CAP004
                                                                                CAP004
     D CSC011          S              1A   INZ('N')                                           CSC011
     D CAP086          S              1A   INZ('N')                                           CAP086
     D KMsgType        S              8A                                                      CSC011
     D KFrntOffID      S             20A                                                      CSC011
     D KTimeStamp      S                   LIKE(@TMESTPSEL)                                   CSC011
     D PRTCD           S              7A                                                      CSC011
     D POPTN           S              7A                                                      CSC011
     D PSARD           S              6A                                                      CSC011
                                                                                CAP004
      ** Fields for enhancement CSC022                                                        CSC022
     D CSC022          S              1A   INZ('N')                                           CSC022
     D WCmtSk          S              1A                                                      CSC022
                                                                                              CSC022
     D DDTMESTMP       S             26Z                                                      CER001
     D DDFOTRANID      S             20                                                       CER001
     D WWERR           S              1                                                       CER001
     D WFIND           S              1                                                       CER001
     D ZFIELD          S             16                                                       CER001
     D ZADEC           S              1  0                                                    CER001
     D DSSDY         E DS                  EXTNAME(DSSDY)                                     CER001
     D InRCCY          S              3A                                                     CSF011A
     D InPCCY          S              3A                                                     CSF011A
                                                                                              CSD095
     D BlankSTYP       S              2A                                                      CSD095
     D BlankBRCA       S              3A                                                      CSD095
                                                                                              CSD095
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      /COPY WNCPYSRC,MMNASPR010
 
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
 
      /COPY WNCPYSRC,MMNASPR001
 
      * DO SCREEN: BROWSE INVALID DEALS
     C     @SCRN         IFEQ      'B'
     C                   EXSR      SCRN@B
     C                   END
 
      /COPY WNCPYSRC,MMNASPR002
 
      * READ NEXT BROWSE SUBFILE RECORD
     C     @SCRN         IFEQ      'R'
     C                   EXSR      RDNBRW
     C                   END
 
      /COPY WNCPYSRC,MMNASPR003
 
      * DO WHILE SCREEN: MAIN DETAILS
     C     @SCRN         DOWEQ     'M'
     C                   EXSR      SCRN@M
     C                   END
 
      /COPY WNCPYSRC,MMNASPR004
 
      *                                                                                       CER001
      ** Extension Screen Validation                                                          CER001
      *                                                                                       CER001
     C     @SCRN         IFEQ      'L'                                                        CER001
     C                   EXSR      Sr_ScnLUX                                                  CER001
     C                   END                                                                  CER001
                                                                                              CER001
      * SCREEN: WINDOW
     C     @SCRN         IFEQ      'W'
     C                   EXSR      WINDOW
     C                   END
 
      /COPY WNCPYSRC,MMNASPR005
 
      * DO WHILE SCREEN: SETTLEMENT DETAILS
     C     @SCRN         DOWEQ     'S'
     C                   EXSR      SCRN@S
     C                   END
 
      /COPY WNCPYSRC,MMNASPR006
 
      * SCREEN: CONFIRMATION OF INPUT
     C     @SCRN         IFEQ      'C'
     C                   EXSR      SCRN@C
     C                   END
 
      /COPY WNCPYSRC,MMNASPR007
 
      * DO FILE UPDATES
     C     @SCRN         IFEQ      'U'
     C                   EXSR      UPDATS
     C                   END
 
      /COPY WNCPYSRC,MMNASPR008
 
      * TERMINATE PROGRAM
     C     @SCRN         IFEQ      'T'
     C                   MOVE      '1'           *INLR
     C                   END
      *****************************************************************
 
      * Hook to enable non-core subroutines to be included
      /COPY WNCPYSRC,MMNASPR011
 
      /EJECT
      *****************************************************************
      * SCRN@B - BROWSE INVALID DEALS
      *****************************************************************
     C     SCRN@B        BEGSR
      *
      * RESET READ NEXT BROWSE SUBFILE RECORD
      *
     C                   MOVEL     *BLANK        @RDNB             1
      *
      * BUILD BROWSE SUBFILE
      *
     C                   CALLB     'MMNASPRPB'
      *
      * INPUT PARAMETERS
      *
      * RETURN CODE
     C                   PARM      *BLANK        RetCodeOut
      *
      * BUILD SUB-FILE
     C                   PARM      'Y'           @BDSFL            1
      *
      * READ SUBFILE RECORD
     C                   PARM      *BLANK        @RDSFL            1
      *
      * Error in update of previous deal                                        CAP006
     C                   PARM                    @ERRUP            1            CAP006
      *                                                                         CAP006
      * OUTPUT PARAMETERS
      *
      * ERROR MESSAGE
     C                   PARM      *BLANK        @ERRMS            7
      *
      * OPTION SELECTED
     C                   PARM                    @OPSEL            1
      *
      * ACTION SELECTED
     C                   PARM                    @ACSEL            1
      *
      * FO TRANSACTION ID SELECTED
     C                   PARM                    @FOTRANSEL       20
      *
      * FO ASSOCIATED TRANSACTION ID SELECTED
     C                   PARM                    @FOASOCSEL       20
      *
      * TIMESTAMP OF TRANSACTION SELECTED
     C                   PARM                    @TMESTPSEL
      *
      * COMMAND KEYS
     C                   PARM      '0'           @INKC             1
     C                   PARM      '0'           @INKL             1
      *                                                                         166907
      ** Successfully Inserted Deal Number                                      166907
      *                                                                         166907
     C                   PARM                    @SIDN             6            166907
      *                                                                                       CSC011
     C                   PARM                    CSC011                                       CSC011
      *
      * If error set on external switches
      *
     C     @ERRMS        IFNE      *BLANK
     C                   MOVE      '1'           *INU6
     C                   END
      *
      * If CK/3 or CK/12 taken in browse, or error message
      * End program
      *
     C     @INKC         IFEQ      '1'
     C     @INKL         OREQ      '1'
     C     @ERRMS        ORNE      *BLANK
     C                   EXSR      ENDP
     C                   GOTO      ESCRN@B
     C                   END
      *
      * Read next browse subfile record
      *
     C                   MOVE      'Y'           @RDNB
     C                   MOVE      'R'           @SCRN
      *
     C     ESCRN@B       ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * RDNBRW - READ NEXT BROWSE SUBFILE RECORD
      *****************************************************************
     C     RDNBRW        BEGSR
      *
      * READ NEXT SUBFILE RECORD
      *
     C                   CALLB     'MMNASPRPB'
      *
      * INPUT PARAMETERS
      *
      * RETURN CODE
     C                   PARM      *BLANK        RetCodeOut
      *
      * BUILD SUB-FILE
     C                   PARM      *BLANK        @BDSFL            1
      *
      * READ SUBFILE RECORD
     C                   PARM      'Y'           @RDSFL            1
      *
      * Error in update of previous deal                                        CAP006
     C                   PARM                    @ERRUP            1            CAP006
      *                                                                         CAP006
      * OUTPUT PARAMETERS
      *
      * ERROR MESSAGE
     C                   PARM      *BLANK        @ERRMS            7
      *
      * OPTION SELECTED
     C                   PARM      *BLANK        @OPSEL            1
      *
      * ACTION SELECTED
     C                   PARM      *BLANK        @ACSEL            1
      *
      * FO TRANSACTION ID SELECTED
     C                   PARM      *BLANK        @FOTRANSEL       20
      *
      * FO ASSOCIATED TRANSACTION ID SELECTED
     C                   PARM      *BLANK        @FOASOCSEL       20
      *
      * TIMESTAMP OF TRANSACTION SELECTED
     C                   PARM                    @TMESTPSEL
      *
      * COMMAND KEYS
     C                   PARM      '0'           @INKC             1
     C                   PARM      '0'           @INKL             1
      *                                                                         166907
      ** Successfully Inserted Deal Number                                      166907
      *                                                                         166907
     C                   PARM                    @SIDN             6            166907
      *                                                                                       CSC011
     C                   PARM                    CSC011                                       CSC011
      *                                                                         CAP004
      * If CK/3 taken within invalid transaction deletion function,             CAP004
      * End program                                                             CAP004
      *                                                                         CAP004
     C     @INKC         IFEQ      '1'                                          CAP004
     C                   EXSR      ENDP                                         CAP004
     C                   GOTO      ERDNBRW                                      CAP004
     C                   END                                                    CAP004
      *
      * IF INVALID DEAL READ FROM SUBFILE
      *
     C     @OPSEL        IFNE      *BLANK
      *
      * BLANK THE MAIN DETAILS SCREEN
      *
     C                   MOVEL     *BLANK        NwDlScnFmt
     C                   MOVEL     *BLANK        DDSTS
      *
      * RESET ERRORS
      *
     C                   MOVE      *ALL'Y'       MMENASP
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIdArr
     C                   MOVEL     *BLANK        MsgDtaArr
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
      *
      * Retrieve deal details
      *
     C                   MOVEL     @ACSEL        DDACTN
     C                   MOVEL     @FOTRANSEL    FOTRID
     C*******************MOVEL     '*FRONT'      @@MODE                         CAP013
      *                                                                         163820
      * Make sure Invalid transaction's  details are passed to 'Retreive'       163820
      * module for SPF checking .                                               163820
      *                                                                         163820
     C     ZATRNKX0      CHAIN     MMINASPX0                          99        163820
      *                                                                         163820
      * Set retrieve mode to '*FRONT' (Access using Front Office ID)            CAP013
      *  if insert                                                              CAP013
      *  if not insert and Midas transaction ID is not present                  CAP013
      * Otherwise                                                               CAP013
      *  Set retrieve mode to blank  (Access using Midas transaction ID).       CAP013
      *                                                                         CAP013
     C     DDACTN        IFEQ      'I'                                          CAP013
     C                   MOVEL     '*FRONT'      @@MODE                         CAP013
     C                   ELSE                                                   CAP013
     C     DDDLNO        IFEQ      *BLANK                                       CAP013
     C                   MOVEL     '*FRONT'      @@MODE                         CAP013
     C                   ELSE                                                   CAP013
     C                   MOVEL     '      '      @@MODE                         CAP013
     C                   ENDIF                                                  CAP013
     C                   ENDIF                                                  CAP013
      *                                                                         CAP013
     C                   EXSR      RTVDEL
      *                                                                                       CER001
      ** retrieve extension record if switchable is on                                        CER001
      *                                                                                       CER001
     C                   IF        ULX004  = 'Y'                                              CER001
     C                   EXSR      Sr_SetLUX                                                  CER001
     C                   ENDIF                                                                CER001
      *
      * If deal details were retrieved
      * Put the deal on the main details screen
      *
     C     HLRCID        IFNE      *BLANK
     C     DDACTN        ANDNE     'I'
     C                   EXSR      PUTD@M
     C                   END
      *
      * Now overwite the fields on the main details screen with those
      * on the invalid deals file (except for the Midas deal number
      * retrieved above using the front office transaction ID).
      * Access invalid deal with timestamp and front office transaction ID.
      *
     C                   MOVEL     DDDLNO        ##DDDLNO          6
     C     ZATRNKX0      CHAIN     MMINASPX0                          99
     C     HLRCID        IFNE      *BLANK
     C     DDACTN        ANDNE     'I'
     C                   MOVEL     ##DDDLNO      DDDLNO
     C                   END
      *
      * Access invalid deal settlement instructions
      *
     C                   CLEAR                   ##PAYS
     C                   CLEAR                   ##RECS
     C     APDSETKX      CHAIN     APIDSETX0                          99
      *                                                                         CAP011
      * If deal details were retrieved and this is an amendment                 CAP011
      *                                                                         CAP011
     C     HLRCID        IFNE      *BLANK                                       CAP011
     C     DDACTN        ANDEQ     'A'                                          CAP011
                                                                                CAP011
      * Data Substitution - Transaction Details                                 CAP011
                                                                                CAP011
     C     GHSUBS        ifne      *blank                                       CAP011
     C     GHSUBS        SCAN      NwDlScnFmt                             99    CAP011
     C     *IN99         IFEQ      *ON                                          CAP011
     C                   EXSR      TDtDtaSubs                                   CAP011
     C                   END                                                    CAP011
     C                   END                                                    CAP011
                                                                                CAP011
      * Setup settlement instructions on amend                                  CAP011
                                                                                CAP011
     C                   EXSR      SetupAmend                                   CAP011
                                                                                CAP011
      * Data Substitution - Settlement Details                                  CAP011
                                                                                CAP011
     C     GHSUBS        ifne      *blank                                       CAP011
     C     GHSUBS        SCAN      ##PAYS                                 99    CAP011
     C  N99GHSUBS        SCAN      ##RECS                                 99    CAP011
     C     *IN99         IFEQ      *ON                                          CAP011
     C                   EXSR      SDtDtaSubs                                   CAP011
     C                   END                                                    CAP011
     C                   END                                                    CAP011
                                                                                CAP011
     C                   END                                                    CAP011
      *
      * If action code, or deal number were NOT OK
      * blank out action code so that the input cannot proceed
      *
     C     OKACTN        IFEQ      'N'
     C     OKDLNO        OREQ      'N'
     C                   MOVEL     *BLANK        DDACTN
     C                   END
      *
      * Send the deals error messages to the main details screen
      *
     C                   EXSR      SNDM@M
      *
      * GO TO MAIN DETAILS SCREEN
      *
     C                   MOVE      'M'           @SCRN
      *
      * ELSE IF NO INVALID DEAL READ FROM SUBFILE
      *
     C                   ELSE
      *
      * GO TO BROWSE SCREEN
      *
     C                   MOVE      'B'           @SCRN
     C                   END
      *
     C*******************ENDSR                                                  CAP004
     C     ERDNBRW       ENDSR                                                  CAP004
      *****************************************************************
      /EJECT
      *****************************************************************
      * SNDM@M - SEND A MESSAGE TO MAIN DETAILS SCREEN
      *****************************************************************
     C     SNDM@M        BEGSR
 
     C                   Z-ADD     Idx           E                 3 0
      *
      ** If there are fundamental errors in this transaction
      ** Identify this fact.
      *
     C     OKACTN        IFEQ      'N'
     C     OKDLNO        OREQ      'N'
     C                   ADD       1             E
     C                   MOVEL     '*ANY'        FldNameArr(E)
     C                   MOVEL     'APM0110'     MsgIdArr(E)
     C                   ENDIF
      *
      ** Initialize error indicators
      *
     C                   MOVEA     MMENASP       @EI
      *
      ** Read error messages for deal
      *
     C     ZATRNKD0      SETLL     ZATRNERRD0
     C     ZATRNKD0      READE     ZATRNERRD0                             99    *
      *
      ** Add error message to array passed to detail screen
      ** and set OK flag for field to 'N'
      *
     C     *IN99         DOWEQ     '0'
     C                   IF        ULX004  = 'N'  Or                                          CER001
     C                             (ULX004 = 'Y' And ABFIELDID <= FldOffsetExt)               CER001
     C                   ADD       1             E
     C                   MOVEL     ABFIELDNAM    FldNameArr(E)
     C                   MOVEL     ABMSGID       MsgIdArr(E)
     C                   Z-ADD     ABFIELDID     F                 3 0
     C                   SUB       FldOffset     F
     C     F             IFLT      1
     C     F             ORGT      60
     C                   Z-ADD     1             F
     C                   END
     C                   MOVE      'N'           @EI(F)
     C                   ENDIF                                                                CER001
     C     ZATRNKD0      READE     ZATRNERRD0                             99    *
     C                   END
      *
     C                   MOVEA     @EI           MMENASP
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SCRN@M - PROCESS SCREEN: MAIN DETAILS
      *****************************************************************
     C     SCRN@M        BEGSR
      *
      * Issue rollback to clear any possible updates in window function
      *
     C     BGWDPR        IFEQ      'Y'
     C                   IF        (CSC022 = 'N')                                             CSC022
     C                             OR (CSC022 = 'Y') AND (WCMTSK = 'N')                       CSC022
     C                   ROLBK
     C                   ELSE                                                                 CSC022
     C                   SETON                                        U7U8                    CSC022
     C                   ENDIF                                                                CSC022
     C                   END
      *
      * Enable/disable detail fields on main details screen
      * if changes to the data are allowed                                      CAP014
      * (key fields = action code & deal number; detail fields = rest)
      * (Action code can only be 'I', 'A', 'D', or 'X')
      *
     C     DDACTN        IFEQ      'I'
     C     @OPSEL        ANDEQ     'U'                                          CAP014
     C     DDACTN        OREQ      'A'
     C     @OPSEL        ANDEQ     'U'                                          CAP014
     C                   MOVEL     'Y'           @EDTFD
     C                   ELSE
     C                   MOVEL     'N'           @EDTFD
     C                   END
      *
      * KJ = COMMAND KEY 10 = CONFIRM DELETE
      *
     C     DDACTN        IFEQ      'D'
     C                   MOVEL     'Y'           @EINKJ
     C                   ELSE
     C                   MOVEL     'N'           @EINKJ
     C                   END
      *
      * WRITE/READ DISPLAY SCREEN
      *
     C                   CALLB     'MMNASPDSP'
      *
      * INPUT PARAMETERS
      *
      * RETURN CODE
     C                   PARM      *BLANK        RetCodeOut
      *
      * DEAL (IN SCREEN FORMAT)
     C                   PARM                    NwDlScnFmt
      *
      * DEAL STATUS
     C                   PARM                    DDSTS            24
      *
      * FIELDS IN ERROR
     C                   PARM                    MMENASP
     C/COPY WNCPYSRC,MMH00059
      *
      * ERRORS
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * WARNINGS
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
      * ENABLED KEY & DETAIL FIELDS
      *
     C                   PARM      'N'           @EKYFD            1
     C                   PARM                    @EDTFD            1
      *
      * ENABLED FUNCTION KEYS
     C                   PARM      'N'           @EINKG            1
     C                   PARM      'N'           @EINKH            1
     C                   PARM                    @EINKJ            1
     C                   PARM      'N'           @EINKN            1
     C                   PARM      'N'           @EINKP            1
      *
      * SUCCESFUL INSERT DEAL
     C                   PARM                    @SIDN             6
      *
      * OUTPUT PARAMETERS
      *
      * FUNCTION KEYS
     C                   PARM      '0'           @INKC             1
     C                   PARM      '0'           @INKG             1
     C                   PARM      '0'           @INKH             1
     C                   PARM      '0'           @INKJ             1
     C                   PARM      '0'           @INKL             1
     C                   PARM      '0'           @INKN             1
     C                   PARM      '0'           @INKP             1
     C                   PARM      'N'           WriteOnly         1
      *
      * RESET ERRORS
      *
     C                   MOVE      *ALL'Y'       MMENASP
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIdArr
     C                   MOVEL     *BLANK        MsgDtaArr
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
      *
      * CK/3 - END PROGRAM
      *
     C     @INKC         CASEQ     '1'           ENDP
      *
      * CK/12 - CANCEL ON MAIN DETAILS SCREEN
      *
     C     @INKL         CASEQ     '1'           CANC@M
      *
      * VALIDATE INPUT TO MAIN DETAILS SCREEN
      *
     C                   CAS                     VAL@M
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VAL@M  - VALIDATE INPUT TO MAIN DETAILS SCREEN
      *****************************************************************
     C     VAL@M         BEGSR
      *
      * Retrieve deal details
      *
     C                   MOVEL     '      '      @@MODE
     C                   EXSR      RTVDEL
      *
      * If action code, or deal number are NOT OK
      * Re-output screen with error messages on it
      *
     C     OKACTN        IFEQ      'N'
     C     OKDLNO        OREQ      'N'
     C                   GOTO      EVAL@M
     C                   END
      *
      *----------------------------------------------------------------
      * IF DELETE
      *
     C     DDACTN        IFEQ      'D'
      *
      * Update Deal in File Format
      *
     C                   MOVEL     CrDlFilFmt    NwDlFilFmt
      *
      * IF CK/10 TAKEN, GO ONTO UPDATES
      *
     C     @INKJ         IFEQ      '1'
     C                   MOVEL     'U'           @SCRN
     C                   END
     C                   GOTO      EVAL@M
     C                   END
      *
      *----------------------------------------------------------------
      * IF AUTHORIZE
      *
     C     DDACTN        IFEQ      'X'
      *
      * Update Deal in File Format
      *
     C                   MOVEL     CrDlFilFmt    NwDlFilFmt
      *
      * If windows processing on, call window routine
      * otherwise, continue to settlements screen
      *
     C     BGWDPR        IFEQ      'Y'
     C                   MOVEL     'W'           @SCRN
     C                   ELSE
     C                   MOVEL     'S'           @SCRN
     C                   END
      *
     C                   GOTO      EVAL@M
     C                   END
      *
      *----------------------------------------------------------------
      * IF INSERT OR AMEND
      *
     C     DDACTN        IFEQ      'I'
     C     DDACTN        OREQ      'A'
      *
      * Prior to validation, initialize error indicators as 'OK'
      * and clear Deal in File Format
      *
     C                   Z-ADD     *ZERO         Idx               3 0
     C                   Z-ADD     *ZERO         WIdx              3 0
     C                   MOVE      *ALL'Y'       MMENASP
     C                   CLEAR                   NwDlFilFmt
     C                   Z-ADD     *ZERO         IHRSTM
     C**********         Z-ADD     *ZERO         IHROBN                                       CSD027
     C**********         Z-ADD     *ZERO         IHROCN                                       CSD027
     C                   EVAL      IHROBN = *BLANKS                                           CSD027
     C                   EVAL      IHROCN = *BLANKS                                           CSD027
     C                   Z-ADD     *ZERO         IHPSTM
     C**********         Z-ADD     *ZERO         IHPOBN                                       CSD027
     C**********         Z-ADD     *ZERO         IHPOCN                                       CSD027
     C                   EVAL      IHPOBN = *BLANKS                                           CSD027
     C                   EVAL      IHPOCN = *BLANKS                                           CSD027
      *
      * IF AMEND
      *
     C     DDACTN        IFEQ      'A'
      *
      * Update Deal in File Format
      *
     C                   MOVEL     CrDlFilFmt    NwDlFilFmt
      *
      * Validate whether non-amenable fields have been changed
      *
     C                   CALLB     'MMNASPAMD'
      *
      * INPUTS
      *
      * Return Code
     C                   PARM      *BLANK        RetCodeOut
      *
      * New Deal in Screen Format
     C                   PARM                    NwDlScnFmt
      *
      * Current Deal in Screen Format
     C                   PARM                    CrDlScnFmt
      *
      * Current Deal in file format
     C                   PARM                    CrDlFilFmt
      *
      * OUTPUTS
      *
      * Field OK flags (DS) from/to caller
     C                   PARM                    MMENASP
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
      *
      * Amendments OK
     C                   PARM                    @@AMOK            1
      *
      * Reset of Fields in Error Required (Y/N)
     C                   PARM      'Y'           @@RSTE            1
     C                   END
      *
      * Validate deal details
      *
     C                   CALLB     'MMNASPVAL'
     C                   PARM                    RespMode
     C                   PARM                    NwDlScnFmt
     C                   PARM      IHSTCY        @@RSCY
     C                   PARM      IHRSTM        @@RSTM
     C                   PARM      IHRONS        @@RONS
     C                   PARM      IHSTCY        @@PSCY
     C                   PARM      IHPSTM        @@PSTM
     C                   PARM      IHPONS        @@PONS
     C                   PARM                    ExtData                        CAP004
     C                   PARM                    MMENASP
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    Idx
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    WIdx
     C                   PARM                    NwDlFilFmt
      *
      * If errors returned
      *
     C     Idx           IFNE      0
     C                   GOTO      EVAL@M
     C                   END
                                                                                              CAP086
      ** Setup Automatic Authorisation flag on the Valid file                                 CAP086
                                                                                              CAP086
     C                   IF        CAP086 = 'Y'                                               CAP086
     C                   EVAL      IHAUTH = DDAUTH                                            CAP086
     C                   ENDIF                                                                CAP086
      *
      * If windows processing on, call window routine
      * otherwise, continue to settlements screen
      *
     C     BGWDPR        IFEQ      'Y'
     C                   MOVEL     'W'           @SCRN
     C                   ELSE
     C                   MOVEL     'S'           @SCRN
     C                   END
      *
     C                   END
      *----------------------------------------------------------------
     C     EVAL@M        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************                       CER001
      *                                                               *                       CER001
      *  Sr_ScnLUX - LUX Extension Screen                             *                       CER001
      *                                                               *                       CER001
      *****************************************************************                       CER001
     C     Sr_ScnLUX     BEGSR                                                                CER001
      *                                                                                       CER001
      ** Change mode to Enquire only when Option selected is "N"                              CER001
      *                                                                                       CER001
     C                   IF        @OPSEL = 'N'                                               CER001
     C                   EVAL      ACTION = 'E'                                               CER001
     C                   EVAL      #1DEXT = 'Y'                                               CER001
     C                   ELSE                                                                 CER001
     C                   EVAL      ACTION = DDACTN                                            CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
      ** Display LUX Extension Screen                                                         CER001
      *                                                                                       CER001
     C                   CALL      'MMNASP2RP'                                                CER001
     C                   PARM      *BLANKS       #RTRN                                        CER001
     C                   PARM                    ACTION                                       CER001
     C                   PARM                    DATALUX                                      CER001
     C                   PARM                    W0RTN             7                          CER001
     C                   PARM                    NwDlFilFmtLux                                CER001
     C                   PARM                    NwDlScnFmtLux                                CER001
     C                   PARM                    NwDlFilFmt                                   CER001
     C                   EVAL      #1DEXT = *BLANK                                            CER001
      *                                                                                       CER001
      ** Process command keys if pressed                                                      CER001
      *                                                                                       CER001
     C                   SELECT                                                               CER001
     C                   WHEN      W0RTN   = 'Y2U9999'                                        CER001
     C                   EXSR      ENDP                                                       CER001
     C                   WHEN      W0RTN   = 'USR0790'                                        CER001
     C                   EVAL      @SCRN   = 'S'                                              CER001
     C                   WHEN      @OPSEL  = 'N'                                              CER001
     C                   EVAL      @SCRN   = 'R'                                              CER001
     C                   OTHER                                                                CER001
     C                   EVAL      @SCRN   = 'C'                                              CER001
     C                   ENDSL                                                                CER001
      *                                                                                       CER001
     C                   ENDSR                                                                CER001
      *****************************************************************                       CER001
      /EJECT                                                                                  CER001
      *****************************************************************                       CER001
      *                                                               *                       CER001
      *  Sr_SetLUX - Setup LUX Parameters To Be Passed                *                       CER001
      *                                                               *                       CER001
      *****************************************************************                       CER001
     C     Sr_SetLUX     BEGSR                                                                CER001
      *                                                                                       CER001
      ** Setup DATALUX                                                                        CER001
      *                                                                                       CER001
     C                   EVAL      L1DN38 = DDDLNO                                            CER001
     C                   EVAL      L1DLTP = DDMTYP                                            CER001
     C                   EVAL      L1CCY  = DDCCY                                             CER001
     C                   MOVE      DDAMNP        L1AMNT                                       CER001
     C                   EVAL      L1VDAT = DDVDAT                                            CER001
     C                   EVAL      L1MDAT = DDMDAT                                            CER001
     C                   EVAL      L1TMST = DDTMESTMP                                         CER001
     C                   EVAL      L1FOTR = FRONTOFFID                                        CER001
     C                   CLEAR                   NwDlFilFmtLux                                CER001
     C                   CLEAR                   CrDlFilFmtLux                                CER001
      *                                                                                       CER001
     C     LUXKEY        CHAIN     RTVIDX1                                                    CER001
      *                                                                                       CER001
      ** Move data from Invalid File to Screen Format DS                                      CER001
      *                                                                                       CER001
     C                   MOVE      #6LXLUSU      L6LXLUSU                                     CER001
     C                   MOVE      #6LXIM93      L6LXIM93                                     CER001
     C                   MOVE      #6LXCLAT      L6LXCLAT                                     CER001
     C                   MOVE      #6LXSUBR      L6LXSUBR                                     CER001
     C                   MOVE      *BLANKS       L6LXMOBL                                     CER001
     C                   MOVEL     #6LXMOBL      L6LXMOBL                                     CER001
     C                   MOVE      #6LXRISC      L6LXRISC                                     CER001
      *                                                                                       CER001
     C     VL1UAC        IFEQ      5                                                          CER001
     C                   MOVE      #6LX1UAC      L6LXGUAC                                     CER001
     C                   ELSE                                                                 CER001
     C                   MOVE      '0'           L6LXGUAC                                     CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   MOVE      #6LXROFC      L6LXROFC                                     CER001
     C                   MOVE      #6LXRATC      L6LXRATC                                     CER001
     C                   IF        #6LXSECQ = '1'                                             CER001
     C                   EVAL      L6LXSECQ = 'Y'                                             CER001
     C                   ELSE                                                                 CER001
     C                   EVAL      L6LXSECQ = 'N'                                             CER001
     C                   ENDIF                                                                CER001
     C                   MOVE      #6LXSECT      L6LXSECT                                     CER001
     C                   MOVE      #6LXEVMT      L6LXEVMT                                     CER001
     C                   MOVE      #6LXOPTP      L6LXOPTP                                     CER001
      *                                                                                       CER001
      ** Access Currency file to retrieve decimal position                                    CER001
      *                                                                                       CER001
     C                   CALLB     'AOCURRR0'                                                 CER001
     C                   PARM      *BLANKS       @RtCd                                        CER001
     C                   PARM      '*KEY   '     @Optn                                        CER001
     C                   PARM      L1CCY         @CURR             3                          CER001
     C     SDCURR        PARM      SDCURR        DSSDY                                        CER001
      *                                                                                       CER001
     C     @RtCd         IFNE      *BLANK                                                     CER001
     C                   MOVEL     'SDCURRPD'    DBFILE                                       CER001
     C                   MOVEL     '003'         DBASE                                        CER001
     C                   MOVEL     @CURR         DBKEY                                        CER001
     C                   EXSR      *PSSR                                                      CER001
     C                   ENDIF                                                                CER001
     C                   MOVE      #6LXCOAM      L6LXCOAM                                     CER001
     C                   EVAL      #1DEXT  = 'Y'                                              CER001
      *                                                                                       CER001
     C                   ENDSR                                                                CER001
      *****************************************************************                       CER001
      /EJECT                                                                                  CER001
      *****************************************************************                       CER001
      *                                                               *                       CER001
      * Sr_UpdLUX - Update LUX Extension File                         *                       CER001
      *                                                               *                       CER001
      *****************************************************************                       CER001
     C     Sr_UpdLUX     BEGSR                                                                CER001
      *                                                                                       CER001
     C                   EVAL      #6LXVMDN38 = IHDN38                                        CER001
      *                                                                                       CER001
     C                   CALLB     'MMNASP2UP'                                                CER001
     C                   PARM      *BLANK        @RTCD                                        CER001
     C                   PARM                    DDACTN                                       CER001
     C                   PARM                    NwDlFilFmtLux                                CER001
      *                                                                                       CER001
     C                   ENDSR                                                                CER001
      *****************************************************************                       CER001
      /EJECT                                                                                  CER001
      *****************************************************************
      * WINDOW - CALL WINDOW MANAGER
      *****************************************************************
     C     WINDOW        BEGSR
      *
      * Reset erros
      *
     C                   MOVE      *ALL'Y'       MMENASP
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIdArr
     C                   MOVEL     *BLANK        MsgDtaArr
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
      *
      * Write out screen to remove error messages
      *
     C                   CALLB     'MMNASPDSP'
      *
      * INPUT PARAMETERS
      *
      * RETURN CODE
     C                   PARM      *BLANK        RetCodeOut
      *
      * DEAL (IN SCREEN FORMAT)
     C                   PARM                    NwDlScnFmt
      *
      * DEAL STATUS
     C                   PARM                    DDSTS            24
      *
      * FIELDS IN ERROR
     C                   PARM                    MMENASP
     C/COPY WNCPYSRC,MMH00060
      *
      * ERRORS
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * WARNINGS
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
      * ENABLED KEY & DETAIL FIELDS
      *
     C                   PARM                    @EKYFD
     C                   PARM                    @EDTFD
      *
      * ENABLED FUNCTION KEYS
     C                   PARM                    @EINKG
     C                   PARM                    @EINKH
     C                   PARM                    @EINKJ
     C                   PARM                    @EINKN
     C                   PARM                    @EINKP
      *
      * SUCCESFUL INSERT DEAL
     C                   PARM                    @SIDN             6
      *
      * OUTPUT PARAMETERS
      *
      * FUNCTION KEYS
     C                   PARM      '0'           @INKC             1
     C                   PARM      '0'           @INKG             1
     C                   PARM      '0'           @INKH             1
     C                   PARM      '0'           @INKJ             1
     C                   PARM      '0'           @INKL             1
     C                   PARM      '0'           @INKN             1
     C                   PARM      '0'           @INKP             1
     C                   PARM      'Y'           WriteOnly         1
      *
      * IF DEAL NUMBER NOT DEFINED (ON INSERT),
      * GET NEXT AVAILABLE DEAL NUMBER
      *
     C     DDDLNO        IFEQ      *BLANK
     C                   CALLB     'CAGETNXTDL'
     C                   PARM      *BLANKS       RetCodeOut
     C                   PARM      *BLANKS       @@MSG1            7
     C                   PARM                    I#DDDLNO          6
     C                   PARM      *ZERO         IHDN38
      *
      * DATABASE ERROR
      *
     C     @@MSG1        IFNE      *BLANK
     C                   MOVEL     'CAGTNXDL'    DBFILE                         ************
     C                   MOVEL     '002'         DBASE                          * DBERR 001*
     C                   MOVEL     DDDLNO        DBKEY                          ************
     C                   EXSR      *PSSR
     C                   END
     C                   END
      *
     C/COPY WNCPYSRC,MMNASPSMV1
      *
      ** If BOE installed                                                                    LLN022A
      *                                                                                      LLN022A
     C                   IF        LLN012 = 'Y'                                              LLN022A
      *                                                                                      LLN022A
      ** If Insert and the Deal Number has been entered...                                   LLN022A
      *                                                                                      LLN022A
     C     DDACTN        IFEQ      'I'                                                       LLN022A
     C     DDDLNO        IFNE      *BLANKS                                                   LLN022A
     C                   MOVE      DDDLNO        BYDLNO                                      LLN022A
     C                   ELSE                                                                LLN022A
     C                   MOVE      I#DDDLNO      BYDLNO                                      LLN022A
     C                   ENDIF                                                               LLN022A
      *                                                                                      LLN022A
      ** Otherwise use deal number from file                                                 LLN022A
      *                                                                                      LLN022A
     C                   ELSE                                                                LLN022A
     C                   MOVE      IHDN38        BYDLNO                                      LLN022A
     C                   ENDIF                                                               LLN022A
     C                   MOVE      DDMDAT        BYMDAT                                      LLN022A
                                                                                             LLN022A
     C                   ENDIF                                                               LLN022A
                                                                                             LLN022A
      ** If BOE installed validate window fields                                             LLN022A
      *                                                                                      LLN022A
     C                   IF        LLN012 = 'Y'                                              LLN022A
                                                                                             LLN022A
     C                   EVAL      BYFRNT = @FOTRANSEL                                       LLN022A
     C                   EVAL      BYTIME = @TMESTPSEL                                       LLN022A
                                                                                             LLN022A
     C                   CALLB     'MMLNASPEXV'                                              LLN022A
     C                   PARM                    ExtData                                     LLN022A
     C                   PARM                    ULMDAT            5 0                       LLN022A
     C                   PARM                    Idx                                         LLN022A
     C                   PARM                    FldNameArr                                  LLN022A
     C                   PARM                    MsgIDArr                                    LLN022A
     C                   PARM                    DDDLNO                                      LLN022A
     C                   PARM                    OkBOEFlags                                  LLN022A
     C                   PARM                    BJDFIN                                      LLN022A
                                                                                             LLN022A
     C                   ENDIF                                                               LLN022A
                                                                                             LLN022A
     C                   IF        @OPSEL     = 'N'                                           LLN022
     C                   EVAL      ACTION     = 'E'                                           LLN022
     C                   ELSE                                                                 LLN022
     C                   EVAL      ACTION     = DDACTN                                        LLN022
     C                   ENDIF                                                                LLN022
                                                                                              LLN022
     C                   CALL      'WN0010'
     C**********         PARM      'MMNASPSIN'   #PGM             10                          192829
     C                   PARM      'MMNASPRPR'   #PGM             10                          192829
     C                   PARM                    FKEY              2
     C**********         PARM      DDACTN        ACTION            1                          LLN022
     C                   PARM                    ACTION            1                          LLN022
     C                   PARM                    DATA
     C                   PARM      *BLANKS       #RTRN             7
     C                   PARM                    SPAREW          256
      *
      * Process returned command keys
      *
     C*****#RTRN         IFEQ      'Y2U9999'                                                  LLN022
     C**********         EXSR      ENDP                                                       LLN022
     C**********         ELSE                                                                 LLN022
      *
      *  If Cmd12 pressed, or in enquiry, return to main details screen;
      *  otherwise, go to settlements screen
      *
     C*****#RTRN         IFEQ      'USR0790'                                                  LLN022
     C*****DDACTN        OREQ      'E'                                                        LLN022
     C*****@RDNB         IFEQ      'Y'                                                        LLN022
     C**********         EVAL      @SCRN = 'R'                                                LLN022
     C**********         ELSE                                                                 LLN022
     C**********         EVAL      @SCRN = 'M'                                                LLN022
     C**********         END                                                                  LLN022
     C**********         ELSE                                                                 LLN022
     C**********         EVAL      @SCRN = 'S'                                                LLN022
     C**********         ENDIF                                                                LLN022
     C**********         ENDIF                                                                LLN022
      *
      ** Simplify the above codes                                                             LLN022
      *                                                                                       LLN022
     C                   SELECT                                                               LLN022
      *                                                                                       LLN022
      ** If F3 = *On                                                                          LLN022
      *                                                                                       LLN022
     C                   WHEN      #RTRN = 'Y2U9999'                                          LLN022
     C                   EXSR      ENDP                                                       LLN022
      *                                                                                       LLN022
      ** If F12 = *On                                                                         LLN022
      *                                                                                       LLN022
     C                   WHEN      #RTRN = 'USR0790'                                          LLN022
     C                   EVAL      @SCRN = 'M'                                                LLN022
      *                                                                                       LLN022
      ** If Enter                                                                             LLN022
      *                                                                                       LLN022
     C                   OTHER                                                                LLN022
     C                   EVAL      @SCRN = 'S'                                                LLN022
                                                                                              LLN022
     C                   ENDSL                                                                LLN022
                                                                                              LLN022
     C     WIND          ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * RTVDEL - RETRIEVE DEAL
      *****************************************************************
     C     RTVDEL        BEGSR
      *
      *
      * RETRIEVE DEAL
      *
     C                   CALLB     'MMNASPRTV'
      *
      * INPUTS
      *
      * Return code
     C                   PARM      *BLANK        RetCodeOut
      *
      * Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      * MODE = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
      *
     C                   PARM                    @@MODE            6
      *
      * Response mode
     C                   PARM      'S'           @@RSMD            1
      *
      * Action Code
     C                   PARM                    DDACTN
      *
      * Front Office Transaction ID
     C                   PARM                    FOTRID           20
      *
      * (Midas) Deal Number
     C                   PARM                    DDDLNO
      *
      * Booking branch
     C                   PARM                    DDBRCA
      *
      * OUTPUTS
      *
      * (Current) deal in file format
     C                   PARM                    CrDlFilFmt
      *
      * OK - Action code
     C                   PARM      *BLANK        OKACTN
      *
      * OK - Deal Number
     C                   PARM      *BLANK        OKDLNO
      *
      * OK - Booking branch
     C                   PARM      *BLANK        OKBRCA
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * Array index (3P0) from/to caller
     C                   PARM      *ZERO         Idx
                                                                                              CAS004
      ** Warning flds/message IDs/message data (arrays) from/to caller                        CAS004
                                                                                              CAS004
     C                   PARM                    WFldNamArr                                   CAS004
     C                   PARM                    WMsgIdArr                                    CAS004
     C                   PARM                    WMsgDtaArr                                   CAS004
                                                                                              CAS004
      ** Array index (3P0) from/to caller                                                     CAS004
                                                                                              CAS004
     C                   PARM                    WIdx                                         CAS004
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * PUTD@M - PUT A DEAL ON THE MAIN DETAILS SCREEN
      *****************************************************************
     C     PUTD@M        BEGSR
      *
      * Call program to fill screen fields with data from MMDENBPP
      *
     C                   CALLB     'MMNASPCVT'
      *
      * INPUTS
      *
      * Return Code
     C                   PARM      *BLANK        RetCodeOut
      *
      * Deal in file format
     C                   PARM                    CrDlFilFmt
      *
      * OUTPUTS
      *
      * Deal in screen format
     C                   PARM                    NwDlScnFmt
      *
      * Deal Status
     C                   PARM                    DDSTS            24
      *
      * Update 'Current' Deal with Deal in Screen Format
      *
     C                   MOVEL     NwDlScnFmt    CrDlScnFmt
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * CANC@M - CANCEL ON MAIN DETAILS SCREEN
      *****************************************************************
     C     CANC@M        BEGSR
      *
      * IF RECORDS ARE STILL TO BE READ FROM THE SUBFILE, READ THEM
      *
     C     @RDNB         IFEQ      'Y'
     C                   MOVEL     'R'           @SCRN
     C                   ELSE
      *
      * ELSE, RETURN TO THE BROWSE SCREEN
      *
     C                   MOVEL     'B'           @SCRN
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SCRN@S - PROCESS SCREEN: SETTLEMENT DETAILS
      *          EVOKED FOR INSERTS, AMENDS, ENQUIRIES & AUTHORIZATIONS
      *****************************************************************
     C     SCRN@S        BEGSR
      *                                                                                       192530
      ** PAYMENT DATE = VALUE DATE FOR NAS PURCHASED                                          192530
      *                                                                                       192530
     C                   Z-ADD     IHDVSD        ##DATP                                       192530
      *                                                                                       192530
      ** RECEIVE DATE = MATURITY DATE FOR NS PURCHASED                                        192530
      *                                                                                       192530
     C                   Z-ADD     IHMATD        ##DATR                                       192530
      *
      * IF FIRST TIME FOR ACTION CODE, DEAL NUMBER, CURRENCY OR CUSTOMER
      *
     C     DDACTN        IFNE      ##ACTN
     C     DDDLNO        ORNE      ##DLNO
     C     DDCCY         ORNE      ##PCCY
     C     DDCSNM        ORNE      ##CSNM
      *
      * DETERMINE PARAMETERS FOR SETTLEMENT DETAILS INPUT
      *
     C                   EXSR      DETP@S
     C                   END
      *                                                                         CAP014
      * If no changes are allowed, protect (but still validate)                 CAP014
      * all instructions by passing action code 'X' to ZASETINSIN               CAP014
      *                                                                         CAP014
     C     @OPSEL        IFEQ      'N'                                          CAP014
     C                   MOVEL     'X'           ##ACTN                         CAP014
     C                   ELSE                                                   CAP014
     C                   MOVEL     DDACTN        ##ACTN                         CAP014
     C                   ENDIF                                                  CAP014
      *
      * SETTLEMENT INSTRUCTIONS INPUT
      *
     C     DDMTYP        IFEQ      'C1'
     C                   MOVEL     DDISUR        ##CSNM
     C                   ELSE
     C                   MOVEL     DDCSNM        ##CSNM
     C                   END
 
     C                   CALLB     'ZASETINSIN'
      *
      * INPUTS
      *
      * Return Code
     C                   PARM      *BLANK        ##RTCD           10
      *
      * Action code
     C                   PARM                    ##ACTN            1            CAP014
     C*******************PARM      DDACTN        ##ACTN            1            CAP014
      *
      * Deal number
     C                   PARM      DDDLNO        ##DLNO            6
      *
      * Protect Payment
     C                   PARM                    ##PPAY            1
      *
      * Protect Receive
     C                   PARM                    ##PREC            1
      *
      * Calling program
     C                   PARM      'NASP'        ##CALP            4
      *
      * Payment currency
     C                   PARM      DDCCY         ##PCCY            3
      *
      * Receive currency
     C                   PARM      DDCCY         ##RCCY            3
      *
      * Customer shortname
     C                   PARM                    ##CSNM           10
      *
      * Transaction Type
     C                   PARM      DDMTYP        ##TTYP            2
      *
      * Federal Funds Ind.
     C                   PARM      DDFEDF        ##FFND            1
      *
      * Booking branch
     C                   PARM      DDBRCA        ##BRCA            3
      *
      * Receipt Date
     C                   PARM                    ##DATR            5 0
      *
      * Payment Date
     C                   PARM                    ##DATP            5 0
      *
      * Payment instructions
     C                   PARM                    ##PAYS
      *
      * Receive instructions
     C                   PARM                    ##RECS
      *
      * FRA/IRS instructions
     C                   PARM                    ##FRIS
      *
      * OUTPUTS
      *
      * Payment instructions
     C                   PARM                    ##PAYF
      *
      * Receive instructions
     C                   PARM                    ##RECF
      *
      * FRA/IRS instructions
     C                   PARM                    ##FRIF
      *
      * FUNCTION KEYS
     C                   PARM      '0'           @INKC             1
     C                   PARM      '0'           @INKK             1                        MD036070
     C                   PARM      '0'           @INKL             1
      *
      **MIDAS*Our*Receive/ Pay Instructions (for Settlm Meth = 04 )                    179510 200400
     C************       PARM                    @MORPI                                179510 200400
      ************                                                                     179510 200400
      * CK/3 - END PROGRAM
      *
     C     @INKC         CASEQ     '1'           ENDP
      *
      * CK/12 - CANCEL ON SETTLEMENT DETAILS
      *
     C     @INKK         CASEQ     '1'           CANC@S                                     MD036070
     C     @INKL         CASEQ     '1'           CANC@S
      *
      * EXIT FROM SETTLEMENT DETAILS
      *
     C                   CAS                     EXIT@S
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * DETP@S - DETERMINE PARAMETERS FOR SETTLEMENT DETAILS SCREEN
      *****************************************************************
     C     DETP@S        BEGSR
      *
      * PAYMENT DATE = VALUE DATE FOR NAS PURCHASED
      *
     C                   Z-ADD     IHDVSD        ##DATP
      *
      * RECEIVE DATE = MATURITY DATE FOR NS PURCHASED
      *
     C                   Z-ADD     IHMATD        ##DATR
      *
      * Convert Transaction Date to a Midas Day Number
      *
     C                   Z-ADD     IHDTYY        @@YY
     C                   Z-ADD     IHDTMM        @@MM
     C                   Z-ADD     IHDTDD        @@DD
     C     DateIn        IFEQ      0
     C                   Z-ADD     BJRDNB        TransDate
     C                   ELSE
     C                   CALLB     'ZDATE10'
     C                   PARM                    DateIn
     C                   PARM                    ZZMDNO            5 0
     C                   MOVE      ZZMDNO        TransDate         5 0
     C                   END
      *
      * PROTECT PAYMENT/RECEIVE INSTRUCTIONS IF DATES
      * ARE IN THE PAST AND THE DEAL WAS NOT DONE TODAY
      *
     C     ##DATP        IFLT      BJRDNB
     C     TransDate     ANDNE     BJRDNB
     C                   MOVEL     'Y'           ##PPAY
     C                   ELSE
     C                   MOVEL     'N'           ##PPAY
     C                   END
     C     ##DATR        IFLT      BJRDNB
     C     TransDate     ANDNE     BJRDNB
     C                   MOVEL     'Y'           ##PREC
     C                   ELSE
     C                   MOVEL     'N'           ##PREC
     C                   END
      *
      * IF PAYMENT OR RECEIPT INSTRUCTIONS ALREADY PRESENT (ON INVALID
      * DEAL SETTLEMENT INSTRUCTIONS FILE) THEN BYPASS DEFAULTING
      *
     C     ##PAYS        IFNE      *blank
     C     ##RECS        ORNE      *blank
     C                   GOTO      EDETP@S
     C                   END
      *
      * SET UP PAYMENT INSTRUCTIONS FROM DEAL
      * (ON INSERTIONS, THESE FIELDS WILL BE ZERO/BLANK)
      *
     C                   MOVEL     IHPSTM        FLPSTM                                       CGL029
     C                   MOVEL     IHPAYEx       FLPONS                                       CGL029
     C                   MOVEL     IHPAY         FLPAY
     C                   MOVEL     IHPOBR        FLPOBR
     C                   MOVEL     IHCVMR        FLCVMR
     C                   MOVEL     IHSTCY        FLPSCY
     C                   MOVEL     IHIC72        FLIC72
      *
      * SET UP RECEIVE INSTRUCTIONS FROM DEAL
      * (ON INSERTIONS, THESE FIELDS WILL BE ZERO/BLANK)
      *
     C                   MOVEL     IHRSTM        FLRSTM                                       CGL029
     C                   MOVEL     IHRECEx       FLRONS                                       CGL029
     C                   MOVEL     IHREC         FLREC
     C                   MOVEL     IHROBR        FLROBR
     C                   MOVEL     IHSTCY        FLRSCY
      *
      * IF SETTLEMENT INSTRUCTIONS ARE NOT DEFINED,
      * AND PAYMENT/RECEIPT DATES ARE NOT IN THE PAST, DEFAULT THEM
      *
     C     FLPSTM        IFEQ      *ZERO
     C     ##PPAY        ANDNE     'Y'
     C     FLRSTM        ANDEQ     *ZERO
     C     ##PREC        ANDNE     'Y'
      *
     C     DDMTYP        IFEQ      'C1'
     C                   MOVEL     DDISUR        ##CSNM
     C                   ELSE
     C                   MOVEL     DDCSNM        ##CSNM
     C                   END
      *
     C/COPY WNCPYSRC,MMH00037
     C                   CALLB     'ZASETINDFT'
      *
      * INPUTS
      *
      * Calling program
     C                   PARM      'NASP'        ##CALP            4
      *
      * Payment currency
     C                   PARM      DDCCY         ##PCCY            3
      *
      * Receive currency
     C                   PARM      DDCCY         ##RCCY            3
     C/COPY WNCPYSRC,MMNASPRC01
      *
      * Customer shortname
     C                   PARM                    ##CSNM           10
      *
      * Transaction Type
     C                   PARM      DDMTYP        ##TTYP            2
      *
      * Federal Funds Ind.
     C                   PARM      DDFEDF        ##FFND            1
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
      ** Version of ISDA Agreement century                                                    176883
     C                   PARM                    Blank2            2                          176883
                                                                                              CSD095
      ** Deal Subtype                                                                         CSD095
     C                   PARM      *BLANK        BlankSTYP                                    CSD095
                                                                                              CSD095
      ** Branch                                                                               CSD095
     C                   PARM      *BLANK        BlankBRCA                                    CSD095
      *
      ** OUTPUTS
      *
      * Payment instructions
     C                   PARM                    ##PAYF
      *
      * Receive instructions
     C                   PARM                    ##RECF
      *
      * FRA/IRS instructions
     C                   PARM                    ##FRIF
      *
     C/COPY WNCPYSRC,MMH00038
     C                   END
      *
      * CONVERT SETTLEMENT DETAILS FROM FILE TO SCREEN FORMAT
      *
     C                   CALLB     'ZASETINCVT'
      *
      ** INPUTS
      *
      ** File Payment Settlement Instruction
     C                   PARM                    ##PAYF
      *
      ** File Receipt Settlement Instruction
     C                   PARM                    ##RECF
      *
      ** File FRA/IRS Settlement Instruction
     C                   PARM      *BLANK        ##FRIF
      *
      ** OUTPUTS
      ** Screen Payment Settlement Instruction
     C                   PARM      *BLANK        ##PAYS
      *
      ** Screen Receipt Settlement Instruction
     C                   PARM      *BLANK        ##RECS
      *
      ** Screen FRA/IRS Settlement Instruction
     C                   PARM      *BLANK        ##FRIS
     C                   PARM      DDCCY         InRCCY                                      CSF011A
     C                   PARM      DDCCY         InPCCY                                      CSF011A
      *
     C     EDETP@S       ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * CANC@S - CANCEL ON SETTLEMENT DETAILS SCREEN
      *****************************************************************
     C     CANC@S        BEGSR
      *
      * Return to Main Details Screen
      *
     C                   MOVEL     'M'           @SCRN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * EXIT@S - EXIT FROM SETTLEMENT DETAILS SCREEN
      *****************************************************************
     C     EXIT@S        BEGSR
      *
      * IF SETTLEMENT DETAILS INVALID
      *
     C     ##RTCD        IFEQ      '*ERRORS'
      *
      * RETURN TO MAIN DETAILS SCREEN
      *
     C                   MOVEL     'M'           @SCRN
     C                   ELSE
     C                   IF        ACTION <> 'E'                                              LLN022
      *                                                                                       LLN022
     C                   IF        ULX004  = 'Y'                                              CER001
     C                   EVAL      @SCRN   = 'L'                                              CER001
     C                   ELSE                                                                 CER001
     C                   IF        @OPSEL  = 'N'                                              CER001
     C                   EVAL      @SCRN   = 'R'                                              CER001
     C                   ELSE                                                                 CER001
      *
      * ELSE, CONTINUE WITH CONFIRMATION SCREEN
      *
     C                   MOVEL     'C'           @SCRN
     C                   ENDIF                                                                CER001
     C                   ENDIF                                                                CER001
      *
      * UPDATE VALID DEAL: PAYMENT SETTLEMENT INSTRUCTIONS
      *
     C                   MOVEL     FLPSTM        IHPSTM                                       CGL029
     C                   MOVEL     FLPONS        IHPAYEx                                      CGL029
     C                   MOVEL     FLPAY         IHPAY
     C                   MOVEL     FLPOBR        IHPOBR
     C                   MOVEL     FLCVMR        IHCVMR
      *
      **For*Settlement*method*04*,*move*the*required*part*of**the****                  179510 200400
      **DataStructure**into*the**correspondent**file**field**.*******                  179510 200400
      ************                                                                     179510 200400
     C*****DDPSTM*       IFEQ      '04'                                                179510 200400
     C************       MOVE      @@MOPI        IHMOPI                                179510 200400
     C************       ENDIF                                                         179510 200400
      ************                                                                     179510 200400
      * UPDATE VALID DEAL: RECEIPT SETTLEMENT INSTRUCTIONS
      *
     C                   MOVEL     FLRSTM        IHRSTM                                       CGL029
     C                   MOVEL     FLRONS        IHRECEx                                      CGL029
     C                   MOVEL     FLREC         IHREC
     C                   MOVEL     FLROBR        IHROBR
      *
      **For*Settlement*method*04*,*move*the*required*part*of**the****                  179510 200400
      **DataStructure**into*the**correspondent**file**field**.*******                  179510 200400
      ************                                                                     179510 200400
     C*****DDRSTM*       IFEQ      '04'                                                179510 200400
     C************       MOVE      @@MORI        IHMORI                                179510 200400
     C************       ENDIF                                                         179510 200400
      ************                                                                     179510 200400
      * UPDATE VALID DEAL: SETTLEMENT CURRENCY & 'IN' CCY IN FIELD 72
      *
     C                   MOVEL     FLPSCY        IHSTCY
     C                   MOVEL     FLIC72        IHIC72
     C                   ELSE                                                                 LLN022
     C                   EVAL      @SCRN = 'B'                                                LLN022
     C                   ENDIF                                                                LLN022
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SCRN@C - PROCESS SCREEN: CONFIRMATION OF INPUT
      *          EVOKED FOR INSERTS, AMENDS & AUTHORIZATIONS
      *****************************************************************
     C     SCRN@C        BEGSR
      *
      * Prior to validation, initialize error indicators as 'OK'
      *
     C                   MOVE      *ALL'Y'       MMENASP
      *
      * Validate deal details
      *
     C                   CALLB     'MMNASPVAL'
     C                   PARM                    RespMode
     C                   PARM                    NwDlScnFmt
     C                   PARM      IHSTCY        @@RSCY
     C                   PARM      IHRSTM        @@RSTM
     C                   PARM      IHRONS        @@RONS
     C                   PARM      IHSTCY        @@PSCY
     C                   PARM      IHPSTM        @@PSTM
     C                   PARM      IHPONS        @@PONS
     C                   PARM                    ExtData                        CAP004
     C                   PARM                    MMENASP
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
     C                   PARM      *ZERO         Idx               3 0
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
     C                   PARM      *ZERO         WIdx              3 0
     C*******************PARM                    @@Mode                         141360
     C                   PARM                    NwDlFilFmt
      *
      * If transaction is valid output message 'Press enter to accept'
      *
     C     Idx           IFEQ      *ZERO
     C                   MOVEL     '*ANY'        FldNameArr(1)
     C                   MOVEL     'MMM1030'     MsgIdArr(1)
     C                   END
      *
      * WRITE/READ DISPLAY SCREEN
      *
     C                   CALLB     'MMNASPDSP'
      *
      * INPUT PARAMETERS
      *
      * RETURN CODE
     C                   PARM      *BLANK        RetCodeOut
      *
      * DEAL (IN SCREEN FORMAT)
     C                   PARM                    NwDlScnFmt
      *
      * DEAL STATUS
     C                   PARM                    DDSTS            24
      *
      * FIELDS IN ERROR
     C                   PARM                    MMENASP
     C/COPY WNCPYSRC,MMH00061
      *
      * ERRORS
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * WARNINGS
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
      * ENABLED KEY & DETAIL FIELDS
      *
     C                   PARM      'N'           @EKYFD
     C                   PARM      'N'           @EDTFD
      *
      * ENABLED FUNCTION KEYS
     C                   PARM      'N'           @EINKG
     C                   PARM      'N'           @EINKH
     C                   PARM      'N'           @EINKJ
     C                   PARM      'N'           @EINKN
     C                   PARM      'N'           @EINKP
      *
      * SUCCESFUL INSERT DEAL
     C                   PARM                    @SIDN             6
      *
      * OUTPUT PARAMETERS
      *
      * FUNCTION KEYS
     C                   PARM      '0'           @INKC             1
     C                   PARM      '0'           @INKG             1
     C                   PARM      '0'           @INKH             1
     C                   PARM      '0'           @INKJ             1
     C                   PARM      '0'           @INKL             1
     C                   PARM      '0'           @INKN             1
     C                   PARM      '0'           @INKP             1
     C                   PARM      'N'           WriteOnly         1
      *
      * RESET ERRORS
      *
     C                   MOVE      *ALL'Y'       MMENASP
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIdArr
     C                   MOVEL     *BLANK        MsgDtaArr
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
      *
      * CK/3 - END PROGRAM
      *
     C     @INKC         CASEQ     '1'           ENDP
      *
      * CK/12 - CANCEL ON CONFIRMATION SCREEN
      *
     C     @INKL         CASEQ     '1'           CANC@C
      *
      * EXIT CONFIRMATION SCREEN
      *
     C                   CAS                     EXIT@C
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * CANC@C - CANCEL ON CONFIRMATION SCREEN
      *****************************************************************
     C     CANC@C        BEGSR
      *
      * RETURN TO MAIN DETAILS SCREEN
      *
     C                   MOVEL     'M'           @SCRN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * EXIT@C - EXIT FROM CONFIRMATION SCREEN
      *****************************************************************
     C     EXIT@C        BEGSR
      *
      * IF NO ERRORS IN VALIDATION
      *
     C     Idx           IFEQ      *ZERO
      *
      * CONTINUE WITH UPDATES
      *
     C                   MOVEL     'U'           @SCRN
      *
      * ELSE, RETURN TO MAIN DETAILS SCREEN
      *
     C                   ELSE
     C                   MOVEL     'M'           @SCRN
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * UPDATS - UPDATES
      *****************************************************************
     C     UPDATS        BEGSR
      *
     C/COPY WNCPYSRC,MMNASPRC03
      * IF DEAL NUMBER NOT DEFINED (ON INSERT),
      * GET NEXT AVAILABLE DEAL NUMBER
      *
     C     DDDLNO        IFEQ      *BLANK
      *
     C     I#DDDLNO      IFNE      *BLANK
     C                   MOVEL     I#DDDLNO      DDDLNO
     C                   ELSE
     C                   CALLB     'CAGETNXTDL'
     C                   PARM      *BLANKS       RetCodeOut
     C                   PARM      *BLANKS       @@MSG1            7
     C                   PARM                    DDDLNO
     C                   PARM      *ZERO         IHDN38
      *
      * DATABASE ERROR
      *
     C     @@MSG1        IFNE      *BLANK
     C                   MOVEL     'CAGTNXDL'    DBFILE                         ************
     C                   MOVEL     '001'         DBASE                          * DBERR 001*
     C                   MOVEL     DDDLNO        DBKEY                          ************
     C                   EXSR      *PSSR
     C                   END
     C                   END
     C                   MOVEL     DDDLNO        @SIDN
     C                   END
      *
     C/COPY WNCPYSRC,MMNASPRC02
      * UPDATE VALID DEAL: DEAL NUMBER
      *
     C                   MOVEL     DDDLNO        IHDN38
      *
      * UPDATE VALID DEAL: LAST ACTION CODE
      *
     C                   MOVEL     DDACTN        IHLACT
      *
      * UPDATE VALID DEAL: FRONT OFFICE TRANSACTION ID
      *
     C                   MOVEL     @FOTRANSEL    IHFRNT
      *
      * UPDATE VALID DEAL: FRONT OFFICE ASSOCIATED TRANSACTION ID
      *
     C                   MOVEL     @FOASOCSEL    IHAFRT
      *
      * MONEY MARKET DATABASE UPDATES
      *
     C                   CALLB     'MMNASPUPM'
     C                   PARM      *BLANK        @RTCD             7
     C                   PARM                    NwDlFilFmt
      *
      * DEALS UPDATES
      *
     C     @RTCD         IFEQ      *BLANK
     C                   CALLB     'MMNASPUPD'
     C                   PARM                    @RTCD
     C                   PARM                    NwDlFilFmt
     C                   END
      *                                                                                       LLN022
      ** If LLN012 installed, update BOE extension file.                                     LLN022A
      *                                                                                      LLN022A
     C                   IF        LLN012 = 'Y'                                              LLN022A
                                                                                             LLN022A
     C                   IF        @RTCD = *BLANK                                            LLN022A
      *                                                                                      LLN022A
      ** Populate ExtData fields                                                             LLN022A
      *                                                                                      LLN022A
     C                   EVAL      LGTEEEX = CQGTEE                                          LLN022A
     C                   EVAL      LQUALEX = CQQUAL                                          LLN022A
     C                   EVAL      LFMATEX = CQFMAT                                          LLN022A
     C                   MOVE      IHDN38        WDDLNO                                      LLN022A
                                                                                             LLN022A
     C                   CALLB     'MMNASPUPD1'                                              LLN022A
     C                   PARM                    WDDLNO            6                         LLN022A
     C                   PARM      DDACTN        PActn             1                         LLN022A
     C                   PARM      *BLANKS       P@RTCD            7                         LLN022A
     C                   PARM                    ExtData                                     LLN022A
                                                                                             LLN022A
     C                   EVAL      @RTCD = P@RTCD                                            LLN022A
                                                                                             LLN022A
     C                   ENDIF                                                               LLN022A
                                                                                             LLN022A
     C                   ENDIF                                                               LLN022A
      *                                                                                       CER001
      ** Update LUX Extension File if allowed                                                 CER001
      *                                                                                       CER001
     C                   IF        ULX004 = 'Y' and                                           CER001
     C                             @RTCD = *Blanks                                            CER001
     C                   EXSR      Sr_UpdLUX                                                  CER001
     C                   ENDIF                                                                CER001
      *
      * IF THERE WERE ANY ERRORS IN THE UPDATE FUNCTIONS, ROLLBACK ANY
      * UPDATES AND END THIS PROGRAM.
      * OTHERWISE DELETE THE INVALID MM DEAL ACTIONED & COMMIT THE UPDATES
      *
     C     @RTCD         IFNE      *BLANK
     C*****@RTCD         ANDNE     '*RECUPD'                             CAP006 168345
     C                   IF        (CSC022 = 'N')                                             CSC022
     C                             OR (CSC022 = 'Y') AND (WCMTSK = 'N')                       CSC022
     C                   ROLBK
     C                   ELSE                                                                 CSC022
     C                   SETON                                        U7U8                    CSC022
     C                   ENDIF                                                                CSC022
     C     @RTCD         IFNE      '*RECUPD'                                    168345
     C                   EXSR      *PSSR
     C                   ENDIF                                                  168345
     C                                                                          CAP006
     C                   ELSE
     C     ZATRNKD0      CHAIN     MMINASPD0                          99
     C  N99              DELETE    MMINASPD0
      *                                                                                      LLN022A
      **  If Liquidity Report LR extract is installed,                                       LLN022A
      **  delete the associated record on the extension file                                 LLN022A
      *                                                                                      LLN022A
     C     LLN012        IFEQ      'Y'                                                       LLN022A
     C     *IN99         ANDEQ     *OFF                                                      LLN022A
                                                                                             LLN022A
     C                   OPEN      MMINPEXL0                            88                   LLN022A
     C     *IN88         IFEQ      *OFF                                                      LLN022A
     C     ZATRNKD0      CHAIN     MMINPEXD0                          89                     LLN022A
     C     *IN89         IFEQ      *OFF                                                      LLN022A
     C                   DELETE    MMINPEXD0                                                 LLN022A
     C                   ENDIF                                                               LLN022A
     C                   CLOSE     MMINPEXL0                                                 LLN022A
     C                   ENDIF                                                               LLN022A
                                                                                             LLN022A
     C                   ENDIF                                                               LLN022A
                                                                                             LLN022A
     C                   IF        ULX004 = 'Y'                                               CER001
     C     LUXKEY        CHAIN     RTVIDX1                                                    CER001
     C                   IF        %FOUND(MMINPLX1L0)                                         CER001
     C                   DELETE    RTVIDX1                                                    CER001
     C                   ENDIF                                                                CER001
     C                   ENDIF                                                                CER001
     C     APDSETK0      CHAIN     APIDSETD0                          99
     C  N99              DELETE    APIDSETD0
                                                                                              CSC011
      ** Delete invalid record from the log file                                              CSC011
                                                                                              CSC011
     C                   IF        CSC011 = 'Y' AND                                           CSC011
     C                             S1SUPP = LIBR                                              CSC011
                                                                                              CSC011
     C                   EVAL      KMsgType = @MSGTYPE                                        CSC011
     C                   EVAL      KFrntOffID = @FOTRANSEL                                    CSC011
     C                   EVAL      KTimeStamp = @TMESTPSEL                                    CSC011
                                                                                              CSC011
     C     KAPLOG        CHAIN     APILOGL0                           99                      CSC011
                                                                                              CSC011
     C                   IF        *IN99 = *OFF                                               CSC011
     C                   DELETE    APILOGL0                                                   CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   IF        (CSC022 = 'N')                                             CSC022
     C                             OR (CSC022 = 'Y') AND (WCMTSK = 'N')                       CSC022
     C                   COMMIT
     C                   ENDIF                                                                CSC022
     C                   END
      *
      * If error occurred in updating last transaction set on flag to           CAP006
      * display message on 'browse' screen.                                     CAP006
     C     @RTCD         IFEQ      '*RECUPD'                                    CAP006
     C                   MOVE      'Y'           @ERRUP                         CAP006
     C                   ELSE                                                   CAP006
     C                   MOVE      'N'           @ERRUP                         CAP006
     C                   END                                                    CAP006
     C                                                                          CAP006
      * IF RECORDS ARE STILL TO BE READ FROM THE SUBFILE, READ THEM
      *
     C     @RDNB         IFEQ      'Y'
     C                   MOVEL     'R'           @SCRN
     C                   ELSE
      *
      * ELSE, RETURN TO THE BROWSE SCREEN
      *
     C                   MOVEL     'B'           @SCRN
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * ENDP - END PROGRAM
      *****************************************************************
     C     ENDP          BEGSR
     C                   MOVEL     'T'           @SCRN
     C                   IF        BGWDPR = 'Y'                                               LLN022
     C                   ROLBK                                                                LLN022
     C                   ENDIF                                                                LLN022
     C                   ENDSR
      *****************************************************************
      /EJECT                                                                    CAP011
      *****************************************************************         CAP011
      *                                                               *         CAP011
      * TDtDtaSubs - Transaction Details Data Substitution            *         CAP011
      *                                                               *         CAP011
      *****************************************************************         CAP011
                                                                                CAP011
     C     TDtDtaSubs    BEGSR                                                  CAP011
                                                                                CAP011
     C                   RESET                   ReturnCode                     CAP011
     C                   CALLB     'APDTASUBS'                                  CAP011
                                                                                CAP011
      * Return Code                                                             CAP011
     C                   PARM                    ReturnCode       10            CAP011
      * Substitution character                                                  CAP011
     C                   PARM      GHSUBS        SubsChar          1            CAP011
      * Incoming Data                                                           CAP011
     C                   PARM      NwDlScnFmt    IncDATA        2000            CAP011
      * Current Data                                                            CAP011
     C                   PARM      CrDlScnfmt    CurDATA        2000            CAP011
                                                                                CAP011
     C                   MOVEL     IncDATA       NwDlScnFmt                     CAP011
                                                                                CAP011
     C                   ENDSR                                                  CAP011
      *****************************************************************         CAP011
      /EJECT                                                                    CAP011
      *****************************************************************         CAP011
      *                                                               *         CAP011
      * SetupAmend - Setup Settlement Instructions on Amendment       *         CAP011
      *                                                               *         CAP011
      *****************************************************************         CAP011
                                                                                CAP011
     C     SetupAmend    BEGSR                                                  CAP011
                                                                                CAP011
      ** CONVERSION OF FILE FIELDS TO SCREEN FORMAT                             CAP011
     C                   MOVEL     HLRSTM        FLRSTM                                       CGL029
     C                   MOVEL     HLRECEx       FLRONS                                       CGL029
     C                   MOVEL     HLREC         FLREC                          CAP011
     C                   MOVEL     HLROBR        FLROBR                         CAP011
     C                   MOVEL     HLSTCY        FLRSCY                         CAP011
     C                   MOVEL     HLPSTM        FLPSTM                                       CGL029
     C                   MOVEL     HLPAYEx       FLPONS                                       CGL029
     C                   MOVEL     HLPAY         FLPAY                          CAP011
     C                   MOVEL     HLPOBR        FLPOBR                         CAP011
     C                   MOVEL     HLCVMR        FLCVMR                         CAP011
     C                   MOVEL     HLSTCY        FLPSCY                         CAP011
     C                   MOVEL     HLIC72        FLIC72                         CAP011
                                                                                CAP011
     C                   CALLB     'ZASETINCVT'                                 CAP011
                                                                                CAP011
      ** Deal Settlement Instructions in file format                            CAP011
     C                   PARM                    ##PAYF                         CAP011
     C                   PARM                    ##RECF                         CAP011
     C                   PARM      *BLANK        ##FRIF                         CAP011
                                                                                CAP011
      ** Current Settlement Instruction in input format                         CAP011
     C                   PARM      *BLANK        CrPaySttmt                     CAP011
     C                   PARM      *BLANK        CrRecSttmt                     CAP011
     C                   PARM      *BLANK        CrFRASttmt                     CAP011
     C                   PARM      HLCCY         InRCCY                                      CSF011A
     C                   PARM      HLCCY         InPCCY                                      CSF011A
                                                                                CAP011
      *  If no Payment or Receive instructions have been supplied               CAP011
      *  Default them to those currently on the deal.                           CAP011
                                                                                CAP011
     C                   IF            (##PAYS = *blank)                        CAP011
     C                   EVAL      ##PAYS = CrPaySttmt                          CAP011
     C                   ENDIF                                                  CAP011
                                                                                CAP011
     C                   IF            (##RECS = *blank)                        CAP011
     C                   EVAL      ##RECS = CrRecSttmt                          CAP011
     C                   ENDIF                                                  CAP011
                                                                                CAP011
     C                   ENDSR                                                  CAP011
      *****************************************************************         CAP011
      /EJECT                                                                    CAP011
      *****************************************************************         CAP011
      *                                                               *         CAP011
      * SDtDtaSubs - Settlement Details Data Substitution             *         CAP011
      *                                                               *         CAP011
      *****************************************************************         CAP011
                                                                                CAP011
     C     SDtDtaSubs    BEGSR                                                  CAP011
                                                                                CAP011
      ** PAYMENT INSTRUCTIONS                                                   CAP011
     C                   RESET                   ReturnCode                     CAP011
     C                   CALLB     'APDTASUBS'                                  CAP011
                                                                                CAP011
      * Return Code                                                             CAP011
     C                   PARM                    ReturnCode                     CAP011
      * Substitution character                                                  CAP011
     C                   PARM      GHSUBS        SubsChar                       CAP011
      * Incoming Data                                                           CAP011
     C                   PARM      ##PAYS        IncDATA                        CAP011
      * Current Data                                                            CAP011
     C                   PARM      CrPaySttmt    CurDATA                        CAP011
                                                                                CAP011
     C                   MOVEL     IncDATA       ##PAYS                         CAP011
                                                                                CAP011
      ** RECEIPT INSTRUCTIONS                                                   CAP011
     C                   RESET                   ReturnCode                     CAP011
     C                   CALLB     'APDTASUBS'                                  CAP011
                                                                                CAP011
      * Return Code                                                             CAP011
     C                   PARM                    ReturnCode                     CAP011
      * Substitution character                                                  CAP011
     C                   PARM      GHSUBS        SubsChar                       CAP011
      * Incoming Data                                                           CAP011
     C                   PARM      ##RECS        IncDATA                        CAP011
      * Current Data                                                            CAP011
     C                   PARM      CrRecSttmt    CurDATA                        CAP011
                                                                                CAP011
     C                   MOVEL     IncDATA       ##RECS                         CAP011
                                                                                CAP011
     C                   ENDSR                                                  CAP011
      *****************************************************************         CAP011
      /EJECT
      *****************************************************************
      * *INZSR - INITIAL PROCESSING
      *****************************************************************
     C     *INZSR        BEGSR
      *
      ** Initialize program name
      *
     C                   MOVEL     'MMINASPMNT'  DBPGM
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
     C                   MOVEL     'SDBANKPD'    DBFILE                         ************
     C                   MOVEL     '901'         DBASE                          * DBERR 901*
     C                   MOVEL     @OPTN         DBKEY                          ************
     C                   EXSR      *PSSR
     C                   END
      *
      ** Access Module Details
      *
     C                   CALL      'AOMMODR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDMMOD        PARM      SDMMOD        DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDMMODPD'    DBFILE                         ************
     C                   MOVEL     '902'         DBASE                          * DBERR 902*
     C                   MOVEL     @OPTN         DBKEY                          ************
     C                   EXSR      *PSSR
     C                   END
      *                                                                         CAP011
      ** Access API ICD Details                                                 CAP011
      *                                                                         CAP011
     C                   CALLB     'AOAPIR0'                                    CAP011
     C                   PARM      *BLANKS       @RTCD                          CAP011
     C                   PARM      '*FIRST '     @OPTN                          CAP011
     C     SDAPI         PARM      SDAPI         DSFDY                          CAP011
      *                                                                         CAP011
      * DATABASE ERROR                                                          CAP011
      *                                                                         CAP011
     C     @RTCD         IFNE      *BLANKS                                      CAP011
     C                   MOVEL     'SDAPIPD '    DBFILE                         CAP011
     C                   MOVEL     '903'         DBASE                          CAP011
     C                   MOVEL     @OPTN         DBKEY                          CAP011
     C                   EXSR      *PSSR                                        CAP011
     C                   END                                                    CAP011
                                                                                              CSC011
      ** Check if CSC011 is installed                                                         CSC011
                                                                                              CSC011
     C                   CALLB     'AOSARDR0'                                                 CSC011
     C                   PARM      *BLANKS       PRTCD                                        CSC011
     C                   PARM      '*VERIFY'     POPTN                                        CSC011
     C                   PARM      'CSC011'      PSARD                                        CSC011
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSC011
                                                                                              CSC011
     C                   IF        PRTCD = *Blanks                                            CSC011
                                                                                              CSC011
     C                   EVAL      CSC011 = 'Y'                                               CSC011
                                                                                              CSC011
     C                   OPEN      APILOGL0                                                   CSC011
                                                                                              CSC011
     C                   IN        SC24X7                                                     CSC011
     C                   IN        SDSTAT                                                     CSC011
                                                                                              CSC011
     C                   ELSE                                                                 CSC011
                                                                                              CSC011
      ** Database error                                                                       CSC011
                                                                                              CSC011
     C                   IF        PRTCD <> '*NRF'                                            CSC011
     C     *LOCK         IN        LDA                                                        CSC011
     C                   EVAL      DBKEY = 'CSC011'                                           CSC011
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSC011
     C                   EVAL      DBASE = 904                                                CSC011
     C                   OUT       LDA                                                        CSC011
     C                   EXSR      *PSSR                                                      CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   ENDIF                                                                CSC011
      *                                                                                       CSC022
      ** Access SAR details file to determine if CSC022 switchable feature                    CSC022
      ** is switched on                                                                       CSC022
      *                                                                                       CSC022
     C                   CALLB     'AOSARDR0'                                                 CSC022
     C                   PARM      *BLANKS       PRTCD                                        CSC022
     C                   PARM      '*VERIFY'     POPTN                                        CSC022
     C                   PARM      'CSC022'      PSARD                                        CSC022
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSC022
                                                                                              CSC022
     C                   IF        PRTCD = *Blanks                                            CSC022
                                                                                              CSC022
     C                   EVAL      CSC022 = 'Y'                                               CSC022
     C                   EVAL      WCMTSK = 'N'                                               CSC022
                                                                                              CSC022
     C                   IN        SCCMTJOB                                                   CSC022
                                                                                              CSC022
     C                   IF        COMITNUM > 0                                               CSC022
                                                                                              CSC022
     C                   MOVEA     WCMTJOBS      WCMT                                         CSC022
                                                                                              CSC022
     C                   IF        %LOOKUP(PSJOBNAME:WCMT) > 0                                CSC022
     C                   EVAL      WCMTSK = 'Y'                                               CSC022
     C                   ENDIF                                                                CSC022
                                                                                              CSC022
     C                   ENDIF                                                                CSC022
                                                                                              CSC022
     C                   ELSE                                                                 CSC022
     C                   IF        PRTCD <> '*NRF'                                            CSC022
     C     *LOCK         IN        LDA                                                        CSC022
     C                   EVAL      DBKEY = 'CSC022'                                           CSC022
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSC022
     C                   EVAL      DBASE = 905                                                CSC022
     C                   OUT       LDA                                                        CSC022
     C                   EXSR      *PSSR                                                      CSC022
     C                   ENDIF                                                                CSC022
                                                                                              CSC022
     C                   ENDIF                                                                CSC022
      *                                                                                      LLN022A
      ** Access SAR details file to determine if LLN012                                      LLN022A
      ** FSA Liquidity Report LR extract is installed.                                       LLN022A
      *                                                                                      LLN022A
     C                   MOVE      'N'           LLN012            1                         LLN022A
     C                   CALLB     'AOSARDR0'                                                LLN022A
     C                   PARM      *BLANKS       PRTCD                                       LLN022A
     C                   PARM      '*VERIFY'     POPTN                                       LLN022A
     C                   PARM      'LLN012'      PSARD                                       LLN022A
     C     SCSARD        PARM      SCSARD        DSFDY                                       LLN022A
      *                                                                                      LLN022A
      ** Switchable Feature LLN012 is *ON                                                    LLN022A
      *                                                                                      LLN022A
     C                   IF        @RTCD = *Blanks                                           LLN022A
     C                   EVAL      LLN012 = 'Y'                                              LLN022A
     C                   ENDIF                                                               LLN022A
                                                                                              CAP086
      ** Access SAR details file to determine if                                              CAP086
      ** Automatic Authorisation is installed                                                 CAP086
                                                                                              CAP086
     C                   EVAL      CAP086 = 'N'                                               CAP086
     C                   CALL      'AOSARDR0'                                                 CAP086
     C                   PARM      *BLANKS       @RTCD                                        CAP086
     C                   PARM      '*VERIFY'     @OPTN                                        CAP086
     C                   PARM      'CAP086'      @SARD                                        CAP086
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAP086
                                                                                              CAP086
     C                   IF        @RTCD <> *BLANKS AND                                       CAP086
     C                             @RTCD <> '*NRF'                                            CAP086
     C     *LOCK         IN        LDA                                                        CAP086
     C                   EVAL      DBPGM = 'MMNASPRPR'                                        CAP086
     C                   EVAL      DBKEY = 'CAP086'                                           CAP086
     C                   EVAL      DBFILE ='SCSARDPD'                                         CAP086
     C                   EVAL      DBASE  = 906                                               CAP086
     C                   OUT       LDA                                                        CAP086
     C                   EXSR      *PSSR                                                      CAP086
     C                   ENDIF                                                                CAP086
                                                                                              CAP086
     C                   IF        @RTCD = *BLANK                                             CAP086
     C                   EVAL      CAP086 = 'Y'                                               CAP086
     C                   ENDIF                                                                CAP086
                                                                                              CER001
      *                                                                                       CER001
      ** Access SAR details file to determine if ULX004 switchable                            CER001
      ** feature is switched on                                                               CER001
      *                                                                                       CER001
     C                   CALLB     'AOSARDR0'                                                 CER001
     C                   PARM      *BLANKS       @RTCD                                        CER001
     C                   PARM      '*VERIFY'     @OPTN                                        CER001
     C                   PARM      'ULX004'      @SARD                                        CER001
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER001
                                                                                              CER001
     C                   MOVE      'N'           ULX004            1                          CER001
                                                                                              CER001
     C                   IF        @RTCD  = *Blanks                                           CER001
     C                   EVAL      ULX004 = 'Y'                                               CER001
      *                                                                                       CER001
      ** Do not process lux extension details when Lux Return indicator is                    CER001
      ** not set to 'Y'                                                                       CER001
      *                                                                                       CER001
     C                   IF         BGLRIN <> 'Y'                                             CER001
     C                   EVAL       ULX004 = 'N'                                              CER001
     C                   ENDIF                                                                CER001
                                                                                              CER001
     C                   ELSEIF    @RTCD <> '*NRF'                                            CER001
                                                                                              CER001
     C     *LOCK         IN        LDA                                                        CER001
     C                   EVAL      DBKEY = 'ULX004'                                           CER001
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER001
     C                   EVAL      DBASE = 907                                                CER001
     C                   OUT       LDA                                                        CER001
     C                   EXSR      *PSSR                                                      CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
      ** Only open LUX related files when SAR is installed                                    CER001
      *                                                                                       CER001
     C                   IF        ULX004 = 'Y'                                               CER001
     C                   OPEN      MMINPLX1L0                                                 CER001
     C                   ENDIF                                                                CER001
                                                                                              CER001
     C/COPY WNCPYSRC,MMH00039
      *
      * Key Lists
      *
     C     ZATRNKD0      KLIST
     C                   KFLD                    @FOTRANSEL
     C                   KFLD                    @TMESTPSEL
     C     ZATRNKX0      KLIST
     C                   KFLD                    @TMESTPSEL
     C                   KFLD                    @FOTRANSEL
     C     APDSETK0      KLIST
     C                   KFLD                    @MSGTYPE
     C                   KFLD                    @FOTRANSEL
     C                   KFLD                    @TMESTPSEL
     C     APDSETKX      KLIST
     C                   KFLD                    @MSGTYPE
     C                   KFLD                    @TMESTPSEL
     C                   KFLD                    @FOTRANSEL
                                                                                              CSC011
     C     KAPLOG        KLIST                                                                CSC011
     C                   KFLD                    KMsgType                                     CSC011
     C                   KFLD                    KFrntOffID                                   CSC011
     C                   KFLD                    KTimeStamp                                   CSC011
      *                                                                                       CER001
     C     LUXKEY        KLIST                                                                CER001
     C                   KFLD                    L1TMST                                       CER001
     C                   KFLD                    L1FOTR                                       CER001
 
      ** Message Type
     C*******************MOVEL     'MMNASP'      @MSGTYPE          8            CAP004
     C                   MOVEL     'MMNASP'      @MSGTYPE                       CAP004
 
      ** Get the field number for the action code field; the screen fields
      ** start from that number.  Subtract one from it to give the value
      ** to subtract from each field's number.
     C                   CALLB     'ZACGTFLDNO'
     C                   PARM                    ReturnCode
     C                   PARM                    Format
     C                   PARM                    Field
     C                   PARM                    FieldNo
 
     C                   IF        ReturnCode = *blank
     C                   EVAL      FldOffset = FieldNo - 1
 
      ** If there was an error default the offset to 13
     C                   ELSE
     C                   EVAL      FldOffset = 13
     C                   ENDIF
      *                                                                                       CER001
     C                   CALLB     'ZACGTFLDNO'                                               CER001
     C                   PARM                    ReturnCode                                   CER001
     C                   PARM                    Format                                       CER001
     C                   PARM                    FieldExt                                     CER001
     C                   PARM                    FieldNo                                      CER001
                                                                                              CER001
     C                   IF        ReturnCode   = *BLANK                                      CER001
     C                   EVAL      FldOffsetExt = FieldNo - 1                                 CER001
      *                                                                                       CER001
      ** If there was an error default the offset to 121                                      CER001
      *                                                                                       CER001
     C                   ELSE                                                                 CER001
     C                   EVAL      FldOffsetExt = 121                                         CER001
     C                   ENDIF                                                                CER001
      *
      * Start on Browse Screen
      *
     C                   MOVEL     'B'           @SCRN             1
 
      *  Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,MMNASPR012
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      *****************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
