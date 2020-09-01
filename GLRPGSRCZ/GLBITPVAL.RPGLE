     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL JE item validation controller')               *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GLBITPVAL - Journal Batch Entry Item Validation              *
      *              Control                                          *
      *                                                               *
      *  Function: This program validates Journal Batch Entry item    *
      *            fields for input into Midas database.              *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD056479           Date 01Sep20               *
      *  Prev Amend No. MD055528           Date 13Aug20               *      
      *                 MD053869           Date 07Jan20               *
      *                 MD052075           Date 07Jun19               *
      *                 CGL148             Date 13Jul18               *
      *                 MD046248           Date 27Oct17               *
      *                 LLN022A            Date 03Jun15               *
      *                 CGL135A            Date 10Jul13               *
      *                 CSF011A            Date 28Nov11               *
      *                 CRE075             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 BUG26280           Date 05Oct09               *
      *                 BUG25438           Date 18Aug09               *
      *                 BUG23742           Date 09May09               *
      *                 CER030             Date 09Jul08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 BUG18301           Date 22Apr08               *
      *                 238620             Date 29Jun07               *
      *                 246418             Date 15Mar07               *
      *                 243965             Date 23Nov06               *
      *                 CRE026             Date 24May06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 240684             Date 26Jun06               *
      *                 CGL064             Date 10Jul06               *
      *                 240204             Date 06Jun06               *
      *                 237508             Date 23May06               *
      *                 238884             Date 21Apr06               *
      *                 238620             Date 16Mar06               *
      *                 237621             Date 10Jan06               *
      *                 CSD027             Date 09Dec05               *
      *                 BUG9009            Date 07Nov05               *
      *                 BG9185             Date 08Nov05               *
      *                 CRE023             Date 29Jul05               *
      *                 BUG6979            Date 04May05               *
      *                 LLN022             Date 24Jan05               *
      *                 CMM121             Date 29Jun04               *
      *                 BUG3036            Date 02Jul04               *
      *                 BUG3037            Date 18Jun04               *
      *                 BUG2948            Date 03Jun04               *
      *                 CGL014             Date 20Oct03               *
      *                 CLE025             Date 20Oct03               *
      *                 BUG449             Date 27Apr04               *
      *                 TCA102             Date 02Apr04               *
      *                 TDA035             Date 02Apr04               *
      *                 CRE019             Date 12Jan04               *
      *                 CGL029             Date 01Sep03               *
      *                 CAP084             Date 21Aug03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CPB001             Date 23Aug99               *
      *                 CAP032 *Create     Date 27May99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD056479 -  Cannot accept batch due to calculated hash       *
      *              not recalculated after deleting batch item       *
      *  MD055528 - Corrective Batches value dates are overwritten by *
      *             Booking Date.                                     *
      *           - When corrective batches value dates are equal to  *
      *             *BLANKS defaults value date to Booking Date       *      
      *  MD053869 - Do not validate batch item on delete.             *
      *  MD052075 - [CGL150] Warning message should be displayed when *
      *           the system defaults the value date.                 *
      *  CGL148 - Automatic Opening of GL accounts                    *
      *  MD046248 - Finastra Rebranding                               *
      *  LLN022A - BOE Upgrade to MidasPlus - incorporate code from   *
      *            /COPY members and add switchability.               *
      *  CGL135A - Accounting Rules Process                           *
      *            Added hooks: CGL135_067, CGL135_068, CGL135_069,   *
      *                         CGL135_070, CGL135_071  CGL135_072    *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG26280 - USR9375 error when AI tab is filled and MN tab is *
      *             blank                                             *
      *  BUG25438 - Batch was accepted when 2 EN tabs are filled out  *
      *  BUG23742 - Improper handling of Ext Narr from Batch          *
      *             Interface Input                                   *
      *  CER030 - Multicash German Feature                            *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  BUG18301 - System not allowing to pass journal entry(balance *
      *             increase) on retail account used as collateral.   *
      *  238620 - Include warning message arrays into output parms.   *
      *  246418 - CGL013 changes for midas plus                       *
      *  243965 - Do not compare associated customer number with      *
      *           customer number if System Val GLJRNECmpAssCust = 'N'*
      *  CRE026 - Consumer Banking (Recompile)                        *
      *  240684 - Applied fix 237621 and BUG9009.                     *
      *  CGL064 - Associated Customer / Cost Centre Validation Changes*
      *  240204 - Provide a warning message if account is flagged     *
      *           for closure in todays cob.  Rework of 155440.       *
      *  237508 - Issue warning message if account is flagged for     *
      *  238884 - Authorisation of Overrides                          *
      *  238620 - Include warning message arrays into output parms.   *
      *  237621 - Upgrade CGL037 Journal Entry only.                  *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG9009 - Add validation for CGL037                          *
      *  BG9185 - Correction to CGL029 (Recompile)                    *
      *  CRE023 - 2 O'clock Flag Upgrade to MidasPlus.                *
      *  BUG6979 - Ensure ZMUSER is re-checked on every call,         *
      *            move out of *INZSR.                                *
      *  LLN022 - BOE Upgrade to MidasPlus.                           *
      *  CMM121 - Core changes for GBO021                             *
      *         - Upgrade to Midasplus                                *
      *           Core hooks amended:GLBITPVC03,GLBITPV002,GLBITPV037 *
      *         - OUTPUT tag :86: - Information to Account Owners     *
      *  BUG3036 - Recompile over changes made to GLVQCNB.            *
      *  BUG3037 - Recompile over changes made to GLVQCNB.            *
      *  BUG2948 - Different branch code item accepted even if        *
      *           multiple branch indicator is set to 'N'.            *
      *  CGL014 - Collaterals Processing                              *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  BUG449 - Set DDRINO to 'N' instead of leaving it blank       *
      *  TCA102 - Various errors on Journal Entry input (Recompile).  *
      *  TDA035 - RTS Signon changes for MidasPlus. (Recompile)       *
      *  CRE019 - Cheque Processing and Maintenance                   *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CPB001 - Meridian DBA Middleware Replication Customization.  *
      *           Recompiled due to database changes                  *
      *  CAP032 - Conversion of Journal Batch Entry inputs into       *
      *           modular structure to use as APIs.                   *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
                                                                                              CAP084
     FSFACAUL0  IF   E           K DISK    INFSR(*PSSR)                                       CAP084
      ** RTV : Account Code/Authorities File By Account Code                                  CAP084
      *
      ** Hook to enable non-core files to be included
      /COPY WNCPYSRC,GLBITPV001
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      *
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
      *
      /COPY ZACPYSRC,STD_D_SPEC
      *
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
      *
      /COPY ZACPYSRC,PSDS
      *
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
      *
      /COPY ZACPYSRC,ERR_ARRAYS
      *
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the size
      ** of the arrays.
      *
      /COPY ZACPYSRC,ERR_XARRYS
      *
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
      *
     D PSysVal1        C                   CONST('GLJRNECmpAssCust')                          243965
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
      ** Incoming Transaction (DS)
     D PTranIn       E DS                  EXTNAME(GLBITPPD)
      *                                                                                       246418
      ** JE Additional Info Data for CGL013                                                   246418
     D PAddInfo      E DS                  EXTNAME(GLBITPXPD)                                 246418
      *
      ** Valid JE Item (DS) - for file update
     D PVBITP        E DS                  EXTNAME(GLVBITPPD)
     D PvBTAccd      E                     EXTFLD(QQACCD)                                     CGL029
      *                                                                                       246418
      ** Valid JE Item Additional Information (DS) - for file update                          246418
     D PVBITPX       E DS                  EXTNAME(GLVBIPXPD)                                 246418
      *
      ** JE Items Error Indicators (DS)
     D PFlagsOK      E DS                  EXTNAME(GLEBITPPD)
      *
      ** JE Items Extra Data (DS)
     D PExtData      E DS                  EXTNAME(GLBPEXPD)
      *
      ** Accounts details (DS)
     D F1ACCT        E DS                  EXTNAME(ACCNTAB)
     D                                     PREFIX(F1)
                                                                                              CAP084
     D ZMUSER        E DS                  EXTNAME(ZMUSER) DTAARA(ZMUSER)                     CAP084
      ** Java user information                                                                CAP084
     D SDUSER        E DS                  EXTNAME(MUSERDD) PREFIX(M)                         CAP084
      ** Data Structure for User Details                                                      CAP084
                                                                                              CAP084
      ** DS for access programs -  Long  data structure                                       CAP084
     D DSSDY         E DS                  EXTNAME(DSSDY)                                     CAP084
                                                                                              CAP084
      *                                                                                       CAP084
      *****************************************************************                BG9009 237621
      ***Externally*described*DS*for*Account*details*******************                BG9009 237621
     D*SDACCT********E*DS******************EXTNAME(ACCNTAB)************                BG9009 237621
     D***********                          PREFIX(IF)                                  BG9009 237621
      ***********                                                                      BG9009 237621
      ***Externally*described*DS*for*SAR*details***********************                BG9009 237621
     D*SCSARD********E*DS******************EXTNAME(SCSARDPD)***********                BG9009 237621
      ***********                                                                      BG9009 237621
      ***DS*for*access*programs*-*short*data*structure*****************                BG9009 237621
     D*DSFDY*********E*DS******************EXTNAME(DSFDY)**************                BG9009 237621
      ***********                                                                      BG9009 237621
      ***Data*structure*for*data*area*ZMITEM***************************                BG9009 237621
     D*ZMITEM********E*DS******************EXTNAME(ZMITEM)*DTAARA(ZMITEM)              BG9009 237621
      *                                                                                       246418
     D PPostDetails    DS           118                                                       246418
     D WDBTNB                  1      3                                                       246418
     D WDBINB                  4      6                                                       246418
     D WBranch                 7      9                                                       CER030
     D WCNum                  10     15                                                       CER030
     D WCurr                  16     18                                                       CER030
     D WASeq                  23     24                                                       CER030
     D WACode                109    118                                                       CER030
      *                                                                                     BUG23742
     D*PAddNarr*       DS          1000                                            BUG23742 BUG26280
     D PAddNarr        DS           770                                                     BUG26280
      ** SAR descriptions                                                                     CGL064
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CGL064
      **                                                                                      CGL064
      ** Account Codes DS for assigning data from Access                                      CGL064
      ** Programs to work fields                                                              CGL064
     D D@ACOD        E DS                  EXTNAME(SDACODPD)                                  CGL064
      **                                                                                      CGL064
     D UUFDY         E DS                  EXTNAME(DSFDY)                                     CGL064
     D/COPY OFCPYSRCZ,CGL135_067                                                             CGL135A
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Index for arrays of error message ids, etc.
     D Idx             S              3P 0
      *
      ** Index for arrays of warning message ids, etc.
     D WIdx            S              3P 0
                                                                                              CGL014
     D CGL014          S              1                                                       CGL014
      *                                                                                       CRE023
      ** Variables used by CRE023                                                             CRE023
      *                                                                                       CRE023
     D CRE023          S              1                                                       CRE023
     D P_RtnCde        S             10                                                       CRE023
                                                                                              243965
     D P@OP01          S             20A                                                      243965
     D P@VL01          S            200A                                                      243965
     D P@OP02          S             20A                                                      243965
     D P@VL02          S            200A                                                      243965
     D P@OP03          S             20A                                                      243965
     D P@VL03          S            200A                                                      243965
     D P@OP04          S             20A                                                      243965
     D P@VL04          S            200A                                                      243965
     D P@OP05          S             20A                                                      243965
     D P@VL05          S            200A                                                      243965
     D P@OP06          S             20A                                                      243965
     D P@VL06          S            200A                                                      243965
     D P@OP07          S             20A                                                      243965
     D P@VL07          S            200A                                                      243965
     D P@OP08          S             20A                                                      243965
     D P@VL08          S            200A                                                      243965
     D P@OP09          S             20A                                                      243965
     D P@VL09          S            200A                                                      243965
     D P@OP10          S             20A                                                      243965
     D P@VL10          S            200A                                                      243965
      *                                                                                       243965
     D PRetCode        S              7A                                                      243965
     D CmpAssCust      S              1A   EXPORT                                             243965
      *                                                                                       246418
      ** Input/Output Parameters                                                              246418
     D PRetCodeIn      S              7                                                       246418
     D PAdditional     S              1                                                       246418
     D PMode           S              1                                                       246418
     D PApiMode        S              1                                                       246418
      **********                                                                       BG9009 237621
      ***Define*variable*for*switchable*CGL037.************************                BG9009 237621
     D*CGL037***       S              1A   INZ(*BLANKS)                                BG9009 237621
      **********                                                                       BG9009 237621
      ***Define*parameters*for*AOSARDR0********************************                BG9009 237621
     D*PRTNC****       S              7A                                               BG9009 237621
     D*POPTN****       S              7A                                               BG9009 237621
     D*PSARD****       S              6A                                               BG9009 237621
      *                                                                                     BUG23742
     D PBrca           S              3A                                                    BUG23742
     D*PCNum****       S              6  0                                                  BUG23742
     D PCNum           S              6A                                                    BUG23742
     D PCcy            S              3A                                                    BUG23742
     D PAccd           S             10S 0                                                  BUG23742
     D PAcsq           S              2S 0                                                  BUG23742
     D PNetwrk         S              6A                                                    BUG23742
     D PNwrk           S              6A                                                    BUG23742
     D PRtcd           S              7A                                                    BUG23742
     D PCancel         S              1A                                                    BUG23742
     D PExit           S              1A                                                    BUG23742
     D CER030          S              1A                                                    BUG23742
      *
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      *
      /COPY WNCPYSRC,GLBITPV002
      *
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ *INZSR is executed at program activation.                  ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *
      * If the user is connected via a browser, the job user name is QUSER -                 BUG6979
      * their user name is stored in ZMUSER                                                  BUG6979
     C                   IN        ZMUSER                                                    BUG6979
                                                                                             BUG6979
     C     USRID         IFNE      *BLANKS                                                   BUG6979
     C     USRID         ANDNE     PSUser                                                    BUG6979
     C                   MOVE      'Y'           JAVAUSER          1                         BUG6979
     C                   ELSE                                                                BUG6979
     C                   MOVE      'N'           JAVAUSER                                    BUG6979
     C                   ENDIF                                                               BUG6979
      *                                                                                      BUG6979
      ** Check the User details extension to retrieve the journal                            BUG6979
      ** entry authorisation for CGL008                                                      BUG6979
      *                                                                                      BUG6979
     C     CGL008        IFEQ      'Y'                                                       BUG6979
     C                   CALL      'AOUSERR0'                                                BUG6979
     C                   PARM      *BLANKS       PRTNC             7                         BUG6979
     C                   PARM      '*KEY   '     POPTN             7                         BUG6979
     C                   PARM      USRID         PUSRP            10                         BUG6979
     C     SDUSER        PARM      SDUSER        DSSDY                                       BUG6979
     C                   ENDIF                                                               BUG6979
      *                                                                                      BUG6979
      /COPY WNCPYSRC,GLBITPV003

      ** Validate Account.
      ***Validate*non-retail*account*if*CGL037*is*on*******************                BG9009 237621

      /COPY WNCPYSRC,GLBITPV004

     C                   EXSR      SRACID                                                   MD056479
     C                   IF        DDACTN <> 'D'                                            MD053869
     C                   MOVE      ' '           DDAcidOK                                   MD056479
     C                   MOVE      ' '           DDCycdOK                                   MD056479
     C                   MOVE      ' '           DDAccdOK                                   MD056479
     C                   MOVE      ' '           DDAcsnOK                                   MD056479
     C                   MOVE      ' '           DDIbcaOK                                   MD056479
     C**********         EXSR      SRACID                                                   MD056479
     C                   ENDIF                                                              MD053869
     C**********         If        CGL037 = 'Y'                                        BG9009 237621
     C**********         ExSr      ChkRetAc                                            BG9009 237621
     C**********         EndIf                                                         BG9009 237621

      /COPY WNCPYSRC,GLBITPV005

      ** Validate Posting Amount.

      /COPY WNCPYSRC,GLBITPV006

     C                   EXSR      SRPTAM                                                   MD056479
     C                   IF        DDACTN <> 'D'                                            MD053869
     C                   MOVE      ' '           DDPtamOK                                   MD056479
     C**********         EXSR      SRPTAM                                                   MD056479
     C                   ENDIF                                                              MD053869

      /COPY WNCPYSRC,GLBITPV007

      ** Validate Debit/Credit Indicator.

      /COPY WNCPYSRC,GLBITPV008
      *
     C                   IF        DDACTN <> 'D'                                            MD053869
     C                   EXSR      SRDRCR
     C                   ENDIF                                                              MD053869

      /COPY WNCPYSRC,GLBITPV009
                                                                                              CGL014
      ** Validate for Sufficient Funds                                                        CGL014
                                                                                              CGL014
     C                   IF        CGL014 = 'Y'  AND  DDACIDOK <> 'N'  AND                    CGL014
     C                             DDCYCDOK <> 'N'  AND  DDACCDOK <> 'N'  AND                 CGL014
     C                             DDACSNOK <> 'N'  AND  DDIBCAOK <> 'N'  AND                 CGL014
     C                             DDPTAMOK <> 'N'  AND  DDDCINOK <> 'N'  AND                 CGL014
     C**********                   F1ATYP = 'R'  AND  F1COLF = 'Y'                   CGL014 BUG18301
     C                             F1ATYP = 'R'  AND  F1COLF = 'Y' AND                      BUG18301
     C                             DDDCIN = 'D'                                             BUG18301
                                                                                              CGL014
      /COPY WNCPYSRC,GLBITPV040                                                               CGL014
                                                                                              CGL014
     C                   IF        DDACTN <> 'D'                                            MD053869
     C                   EXSR      SRBLCK                                                     CGL014
     C                   ENDIF                                                              MD053869
                                                                                              CGL014
      /COPY WNCPYSRC,GLBITPV041                                                               CGL014
                                                                                              CGL014
     C                   ENDIF                                                                CGL014

      ** Validate Narrative.

      /COPY WNCPYSRC,GLBITPV010

     C                   IF        DDACTN <> 'D'                                            MD053869
     C                   EXSR      SRNARR
     C                   ENDIF                                                              MD053869

      /COPY WNCPYSRC,GLBITPV011

      ** Validate Transaction Type/Subtype.

      /COPY WNCPYSRC,GLBITPV012

     C                   IF        DDACTN <> 'D'                                            MD053869
     C                   EXSR      SRTTYP
     C                   ENDIF                                                              MD053869

      /COPY WNCPYSRC,GLBITPV013

      ** Validate Value Date.

      /COPY WNCPYSRC,GLBITPV014

     C                   IF        DDACTN <> 'D'                                            MD053869
     C                   EXSR      SRVDAT
     C                   ENDIF                                                              MD053869
     C/COPY OFCPYSRCZ,CGL135_068                                                             CGL135A

      /COPY WNCPYSRC,GLBITPV015

      ** Validate Cheque Number.

      /COPY WNCPYSRC,GLBITPV016

     C                   IF        DDACTN <> 'D'                                            MD053869
     C                   EXSR      SRCQNB
     C                   ENDIF                                                              MD053869

      /COPY WNCPYSRC,GLBITPV017

      ** For Swift Reference input, no need to validate.  If not
      ** blanks, move value to Valid file field.

      /COPY WNCPYSRC,GLBITPV018

     C     DDSWCR        IFNE      *BLANKS
     C                   MOVE      DDSWCR        B2SWCR
     C                   ENDIF

      /COPY WNCPYSRC,GLBITPV019

      ** Validate Profit Centre.

      /COPY WNCPYSRC,GLBITPV020

     C                   IF        DDACTN <> 'D'                                            MD053869
     C     BKPRCU        IFEQ      'Y'
     C                   EXSR      SRPRCN
     C                   ELSE
     C                   MOVEL     *BLANKS       DDPRCN
     C                   ENDIF
     C                   ENDIF                                                              MD053869

      /COPY WNCPYSRC,GLBITPV021

      ** Validate Error Overrides.

      /COPY WNCPYSRC,GLBITPV022

     C                   IF        DDACTN <> 'D'                                            MD053869
     C                   EXSR      SREROV
     C                   ENDIF                                                              MD053869

      /COPY WNCPYSRC,GLBITPV023

      ** Validate Associated Customer.

      /COPY WNCPYSRC,GLBITPV024

      ** Check if Profit / Loss feature is installed                                         LLN022A
      *                                                                                      LLN022A
     C     LLN021        IFEQ      'Y'                                                       LLN022A
      *                                                                                      LLN022A
      ** Can work only if account is OK                                                      LLN022A
      *                                                                                      LLN022A
     C     DDAcidOK      IFEQ      'Y'                                                       LLN022A
     C     DDAccdOK      ANDEQ     'Y'                                                       LLN022A
      *                                                                                      LLN022A
      ** The assoc. cust. must be empty                                                      LLN022A
      *                                                                                      LLN022A
     C     DDACNB        IFEQ      *BLANKS                                                   LLN022A
      *                                                                                      LLN022A
      ** check the account code for IN/EX                                                    LLN022A
      *                                                                                      LLN022A
     C                   CALL      'AOACODR0'                                                LLN022A
     C                   PARM      *BLANKS       PRTCD             7                         LLN022A
     C                   PARM      '*KEY   '     POPTN             7                         LLN022A
     C                   PARM      DDACCD        PKACOD           10                         LLN022A
     C     D@ACOD        PARM      D@ACOD        DSSDY                                       LLN022A
      *                                                                                      LLN022A
     C     PRTCD         IFEQ      *BLANKS                                                   LLN022A
      *                                                                                      LLN022A
      ** Only if it is a interface batch entry                                               LLN022A
      *                                                                                      LLN022A
     C                   MOVEL     A5ACSC        WUACSC            2                         LLN022A
     C     WUACSC        IFEQ      'IN'                                                      LLN022A
     C     WUACSC        OREQ      'EX'                                                      LLN022A
     C                   MOVEL     F1CNUM        DDACNB                                      LLN022A
     C                   ENDIF                                                               LLN022A
      *                                                                                      LLN022A
     C                   ENDIF                                                               LLN022A
      *                                                                                      LLN022A
     C                   ENDIF                                                               LLN022A
      *                                                                                      LLN022A
     C                   ENDIF                                                               LLN022A
      *                                                                                      LLN022A
     C                   ENDIF                                                               LLN022A
      *                                                                                      LLN022A
     C                   IF        DDACTN <> 'D'                                            MD053869
     C                   EXSR      SRACUS
     C                   ENDIF                                                              MD053869

      /COPY WNCPYSRC,GLBITPV025

      ** Validate Book Code.

      /COPY WNCPYSRC,GLBITPV026

     C                   IF        DDACTN <> 'D'                                            MD053869
     C                   EXSR      SRBKCD
     C                   ENDIF                                                              MD053869

      /COPY WNCPYSRC,GLBITPV027

      ** Validate Reverse/Void Indicator.

      /COPY WNCPYSRC,GLBITPV028

     C                   IF        DDACTN <> 'D'                                            MD053869
     C                   EXSR      SRRVIN
     C                   ENDIF                                                              MD053869

      /COPY WNCPYSRC,GLBITPV029

      ** Validate No. of Items.

      /COPY WNCPYSRC,GLBITPV030

     C                   IF        DDACTN <> 'D'                                            MD053869
     C     PCMTR         IFEQ      'Y'
     C                   EXSR      SRNITM
     C                   ELSE
     C                   MOVEL     *BLANKS       DDNITM
     C                   Z-ADD     1             B2NITM
     C                   ENDIF
     C                   ENDIF                                                              MD053869

      /COPY WNCPYSRC,GLBITPV031

      ** Validate Original Currency/Amount.

      /COPY WNCPYSRC,GLBITPV032

     C                   IF        DDACTN <> 'D'                                            MD053869
     C     CEU013        IFEQ      'Y'
     C                   EXSR      SRORCA
     C                   ELSE
     C                   MOVEL     *BLANKS       DDOCCY
     C                   MOVEL     *BLANKS       DDOAMT
     C                   ENDIF
     C                   ENDIF                                                              MD053869

      ** If MidasPlus user then it's possible to edit or delete a batch item                  CAP084
      ** therefore need to set up the batch item number                                       CAP084
                                                                                              CAP084
     C     JAVAUSER      IFEQ      'Y'                                                        CAP084
     C     DDBINB        IFNE      *BLANKS                                                    CAP084
     C                   MOVE(P)   DDBINB        ZFIELD                                       CAP084
      *                                                                                       CAP084
     C                   CALLB     'ZALIGN'                                                   CAP084
     C                   PARM                    ZalignOK          1                          CAP084
     C                   PARM                    ZFIELD           16                          CAP084
     C                   PARM      *ZERO         ZADEC             1 0                        CAP084
     C                   PARM      3             ZADIG             2 0                        CAP084
                                                                                              CAP084
     C                   MOVE      ZFIELD        B2BINB                                       CAP084
                                                                                              CAP084
      ** Also set the batch valid indicator to '*' to indicate to the UPD                     CAP084
      ** module that it needs deleting.                                                       CAP084
                                                                                              CAP804
     C     DDDLIT        IFEQ      'Y'                                                        CAP084
     C                   MOVE      '*'           B2VALI                                       CAP084
     C                   ENDIF                                                                CAP084
     C                   ENDIF                                                                CAP084
                                                                                              CAP084
      ** Set up the batch number                                                              CAP084
     C     DDBTNB        IFNE      *BLANKS                                                    CAP084
     C                   MOVE      DDBTNB        B2BTNB                                       CAP084
     C                   ENDIF                                                                CAP084
                                                                                              CAP084
     C                   ENDIF                                                                CAP084
                                                                                              CAP084
      ** Security on Journal Entry, check that user is authorised to the account code         CAP084
                                                                                              CAP084
     C     CGL008        IFEQ      'Y'                                                        CAP084
     C     JAVAUSER      ANDEQ     'Y'                                                        CAP084
      *                                                                                       CAP084
      ** Check the Access to all account codes                                                CAP084
      *                                                                                       CAP084
     C     MALACOD       IFNE      'Y'                                                        CAP084
      *                                                                                       CAP084
      ** Check the Authorities of this account code                                           CAP084
      *                                                                                       CAP084
     C**********         MOVE      B2ACCD        WACCD             4 0                 CAP084 CGL029
     C                   MOVE      B2ACCD        WACCD            10 0                        CGL029
     C     KACCD         CHAIN     SFACAUL0                           22                      CAP084
      *                                                                                       CAP084
      ** If no record found, the input is not allowed                                         CAP084
      *                                                                                       CAP084
     C                   EXSR      SRRESET                                                    CAP084
     C     *IN22         IFEQ      *ON                                                        CAP084
     C                   MOVEL     'DDACCD'      FldNamXAr(1)                                 CAP084
     C                   MOVEL     'CGL0001'     MsgIdXAr(1)                                  CAP084
     C                   MOVE      'N'           DDACCDOK                                     CAP084
     C                   EXSR      SRUPDERR                                                   CAP084
     C                   ENDIF                                                                CAP084
      *                                                                                       CAP084
     C                   ENDIF                                                                CAP084
     C                   ENDIF                                                                CAP084
                                                                                              CAP084
      /COPY WNCPYSRC,GLBITPV033

      ** For non-existing Nostro, if CEU013 is *ON and Currency
      ** is an 'In' Currency, then default Account Type to 'N'.

      /COPY WNCPYSRC,GLBITPV034

     C     PInvAct       IFEQ      '*NOSTRO'
     C                   MOVEL     'N'           B2ACTY
     C                   ENDIF

      /COPY WNCPYSRC,GLBITPV035

      ** For non-existing Retail A/c No., if CEU013 is *ON and
      ** Currency is an 'In' Currency, then default Account
      ** Type to 'R'.

      /COPY WNCPYSRC,GLBITPV036

     C     PInvAct       IFEQ      '*RETAIL'
     C                   MOVEL     'R'           B2ACTY
     C                   ENDIF

      /COPY WNCPYSRC,GLBITPV037
      *                                                                                       CRE023
      ** Call Two O'clock validation if CRE023 is on.                                         CRE023
      *                                                                                       CRE023
     C                   IF        DDACTN <> 'D'                                            MD053869
     C                   IF        CRE023 =  'Y'                                              CRE023
      *                                                                                       CRE023
     C                   CALLB     'GLVTWOCLK'                                                CRE023
     C                   PARM      *BLANK        P_RtnCde                                     CRE023
     C                   PARM                    PTranIn                                      CRE023
     C                   PARM                    PVBITP                                       CRE023
     C                   PARM                    BJRDNB                                       CRE023
     C                   PARM                    PFlagsOk                                     CRE023
     C                   PARM                    FldNameArr                                   CRE023
     C                   PARM                    MsgIDArr                                     CRE023
     C                   PARM                    MsgDtaArr                                    CRE023
     C                   PARM                    Idx                                          CRE023
     C                   PARM                    WFldNamArr                                   CRE023
     C                   PARM                    WMsgIdArr                                    CRE023
     C                   PARM                    WMsgDtaArr                                   CRE023
     C                   PARM                    WIdx                                         CRE023
      *                                                                                       CRE023
     C                   ENDIF                                                                CRE023
     C                   ENDIF                                                              MD053869
      *                                                                                       CRE023
      ** MT94x Messages Generation                                                            246418
      *                                                                                       246418
     C                   IF        DDACTN <> 'D'                                            MD053869
     C                   IF        CGL013 =  'Y'                                              246418
      *                                                                                       246418
      ** Checking if Additional Information and Extended Narratives                         BUG25438
      ** both have contents.                                                                BUG25438
      *                                                                                     BUG25438
     C                   IF        PAddInfo <> *BLANKS                                      BUG25438
     C                             AND PAddNarr <> *BLANKS                                  BUG25438
     C                   EXSR      SRRESET                                                  BUG25438
     C                   MOVEL     'DDADI1'      FldNamXAr(1)                               BUG25438
     C                   MOVEL     'USR9375'     MsgIdXAr(1)                                BUG25438
     C                   EXSR      SRUPDERR                                                 BUG25438
     C                   ENDIF                                                              BUG25438
      *                                                                                     BUG25438
      * Set up parameters for call to GL000185                                                246418
      *                                                                                       246418
     C                   Z-ADD     0             B3PTDT                                       246418
     C                   EVAL      B3BTNB = B2BTNB                                            246418
     C                   Z-ADD     B2BINB        B3BINB                                       246418
     C                   EVAL      B3ADI1 = DDADI1                                            246418
     C                   EVAL      B3ADI2 = DDADI2                                            246418
     C                   EVAL      B3ADI3 = DDADI3                                            246418
     C                   EVAL      B3ADI4 = DDADI4                                            246418
     C                   EVAL      B3ADI5 = DDADI5                                            246418
     C                   EVAL      B3ADI6 = DDADI6                                            246418
     C                   EVAL      B3AERI = DDAERI                                            246418
     C                   EVAL      WDBTNB = DDBTNB                                            246418
     C                   EVAL      WDBINB = DDBINB                                            246418
      *                                                                                       CER030
     C                   EVAL      WBranch = B2IBCA                                           CER030
     C                   EVAL      WCNum = B2CUST                                             CER030
     C                   EVAL      WCurr = B2CYCD                                             CER030
     C                   EVAL      WACode = B2ACCD                                            CER030
     C                   EVAL      WASeq = B2ACSN                                             CER030
      *                                                                                       246418
     C                   CALL      'GL000185'                                                 246418
     C                   PARM      *BLANKS       PRetCodeIn                                   246418
     C                   PARM                    PPostDetails                                 246418
     C                   PARM      *BLANKS       PAdditional                                  246418
     C                   PARM      'V'           PMode                                        246418
     C                   PARM      '0'           PExit                                      BUG23742
     C                   PARM      '0'           PCancel                                    BUG23742
     C                   PARM                    PVBITPX                                      246418
     C                   PARM      'Y'           PApiMode                                     246418
     C                   PARM                    FldNamXAr                                    246418
     C                   PARM                    MsgIDXAr                                     246418
     C                   PARM                    MsgDtaXAr                                    246418
                                                                                              246418
     C                   EXSR      SRUPDERR                                                   246418
     C                   ENDIF                                                                246418
     C                   ENDIF                                                              MD053869
      *                                                                                     BUG23742
      ** Set up parameters for call to GLVEXTNARR                                           BUG23742
      *                                                                                     BUG23742
     C                   IF        DDACTN <> 'D'                                            MD053869
     C                   IF        CER030 =  'Y'                                            BUG23742
      *                                                                                     BUG23742
     C                   EVAL      PBrca = B2IBCA                                           BUG23742
     C                   MOVEL     B2CUST        PCNum                                      BUG23742
     C                   EVAL      PCcy = B2CYCD                                            BUG23742
     C                   MOVEL     B2ACCD        PAccd                                      BUG23742
     C                   MOVEL     B2ACSN        PAcsq                                      BUG23742
      *                                                                                     BUG23742
      ** Call Extended Narrative Validation Program                                         BUG23742
      *                                                                                     BUG23742
     C                   CALLB     'GLVEXTNARR'                                             BUG23742
     C                   PARM      *BLANKS       RetCodeIn                                  BUG23742
     C                   PARM                    PBrca                                      BUG23742
     C                   PARM                    PCNum                                      BUG23742
     C                   PARM                    PCcy                                       BUG23742
     C                   PARM                    PAccd                                      BUG23742
     C                   PARM                    PAcsq                                      BUG23742
     C                   PARM                    PAddNarr                                   BUG23742
     C                   PARM                    FldNamXAr                                  BUG23742
     C                   PARM                    MsgIDXAr                                   BUG23742
     C                   PARM                    MsgDtaXAr                                  BUG23742
      *                                                                                     BUG23742
     C                   EXSR      SRUPDERR                                                 BUG23742
      *                                                                                     BUG23742
     C                   ENDIF                                                              BUG23742
     C                   ENDIF                                                              MD053869
     C/COPY OFCPYSRCZ,CGL135_069                                                             CGL135A

     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** Hook to enable non-core subroutines to be included
      /COPY WNCPYSRC,GLBITPV038
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRACID - Validate Account                                    *
      *                                                               *
      *****************************************************************
      *
     C     SRACID        BEGSR
      *
      ** Reset error fields.
      *
     C                   EXSR      SRRESET
      *
     C/COPY WNCPYSRC,GLH00537
     C                   CALLB     'GLVIMAC'
      *                             ========
      ** INPUT
      ** =====
      *
      ** Return code
     C                   PARM                    RetCodeOut
      *
      ** Associated Front Office Id
     C                   PARM                    APFOAsocId
      *
      ** Account Identifier
     C                   PARM                    DDACID
      *
      ** Currency Code
     C                   PARM                    DDCYCD
      *
      ** Account Code
     C                   PARM                    DDACCD
      *
      ** Account Sequence
     C                   PARM                    DDACSN
      *
      ** Input Branch Code
     C                   PARM                    DDIBCA
                                                                                             BUG2948
      ** Batch Header number                                                                 BUG2948
     C                   PARM                    DDBTNB                                      BUG2948
                                                                                             BUG2948
      ** Action Code                                                                         BUG2948
     C                   PARM                    DDACTN                                      BUG2948
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - System Rundate
     C                   PARM                    BJRDNB
      *
      ** SDBANK - Single Branch Code
     C                   PARM                    BJSBRC
      *
      ** SWITCHABLE FEATURES
      ** ===================
      *
      ** EMU Account Posting Narrative feature
     C                   PARM                    CEU013
                                                                                              237621
      ** Account Access Security                                                              237621
     C                   PARM                    CGL037                                       237621
                                                                                              CGL148
      ** Automatic Opening of GL accounts                                                     CGL148
     C                   PARM                    CGL148                                       CGL148
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      ** Warning Error fields/message Id's/message data from /to caller                       240204
     C                   PARM                    WFldNamArr                                   240204
     C                   PARM                    WMsgIdArr                                    240204
     C                   PARM                    WMsgDtaArr                                   240204
     C                   PARM                    WIdx                                         240204
      *
      ** Account Identifier - OK indicator
     C                   PARM                    DDAcidOK
      *
      ** Currency Code - OK indicator
     C                   PARM                    DDCycdOK
      *
      ** Account Code - OK indicator
     C                   PARM                    DDAccdOK
      *
      ** Account Sequence - OK indicator
     C                   PARM                    DDAcsnOK
      *
      ** Branch Code - OK indicator
     C                   PARM                    DDIbcaOK
      *
      ** In Currency flag
     C                   PARM                    PINCY             1
      *
      ** No. of Decimal Places
     C                   PARM                    PNBDP             1 0
      *
      ** Branch Location Code
     C                   PARM                    PLCCD             3
      *
      ** Account flag
     C                   PARM                    PAccount          5
      *
      ** Invalid account flag
     C                   PARM                    PInvAct           7
      *
      ** Customer for Profit Centre validation
     C                   PARM                    PCust1            6
      *
      ** Customer A/c Officer Code for Profit Centre validation
     C                   PARM                    PAcOf1            2
      *
      ** Account details (DS)
     C                   PARM                    F1ACCT
      *
      ** Valid JE Item (DS) - for file update
     C                   PARM                    PVBITP
     C/COPY WNCPYSRC,GLH00538
      *
      ** Update error information.
      *
     C                   EXSR      SRUPDERR
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************                BG9009 237621
      *****************************************************************                BG9009 237621
      ***ChkRetAc*-*Check*for*retail*account*security******************                BG9009 237621
      *****************************************************************                BG9009 237621
      *****************************************************************                BG9009 237621
      **********                                                                       BG9009 237621
     C*****ChkRetAc      BegSr                                                         BG9009 237621
      **********                                                                       BG9009 237621
      ***Reset*error*fields.*******************************************                BG9009 237621
     C**********         EXSR      SRRESET                                             BG9009 237621
      **********                                                                       BG9009 237621
      ***Find*out*what*the*menu*option*taken*was***********************                BG9009 237621
     C**********         In        ZMITEM                                              BG9009 237621
      **********                                                                       BG9009 237621
      ***If*Journal*entry*-*non-retail,*check*that*account*is*non-retail               BG9009 237621
     C**********         If        INDX = '0000002745'                                 BG9009 237621
     C**********         CALLB     'AOACCTR0'                                          BG9009 237621
     C**********         PARM      *BLANKS       PPRTCD            7                   BG9009 237621
     C**********         PARM      '*KEY   '     PPOPTN            7                   BG9009 237621
     C**********         PARM                    PPRETL           10                   BG9009 237621
     C**********         PARM                    PPCNUM            6                   BG9009 237621
     C**********         PARM                    PPCUCD            3                   BG9009 237621
     C**********         PARM                    DDACCD                                BG9009 237621
     C**********         PARM                    PPACSQ            2                   BG9009 237621
     C**********         PARM                    PPBRCA            3                   BG9009 237621
     C*****SDACCT        PARM      SDACCT        DSSDY                                 BG9009 237621
      **********                                                                       BG9009 237621
      ***If*it*is*a*retail*account*then*error.*************************                BG9009 237621
      **********                                                                       BG9009 237621
     C**********         If        IFATYP = 'R'                                        BG9009 237621
     C**********         Eval      FldNamXAr(1) =  'DDACID'                            BG9009 237621
     C**********         Eval      MsgIDXAr(1)  =  'GLX0427'                           BG9009 237621
      **********                                                                       BG9009 237621
      ***Update*error*information.*************************************                BG9009 237621
     C**********         ExSr      SRUPDERR                                            BG9009 237621
     C**********         EndIf                                                         BG9009 237621
     C**********         EndIf                                                         BG9009 237621
      **********                                                                       BG9009 237621
     C**********         EndSr                                                         BG9009 237621
      **********                                                                       BG9009 237621
      *****************************************************************                BG9009 237621
      *EJECT***********************************************************                BG9009 237621
      *****************************************************************
      *                                                               *
      *  SRPTAM - Validate Posting Amount                             *
      *                                                               *
      *****************************************************************
      *
     C     SRPTAM        BEGSR
      *
      ** Reset error fields.
      *
     C                   EXSR      SRRESET
      *
     C                   CALLB     'GLVIMPS'
      *                             =======
      ** INPUT
      ** =====
      *
      ** Return code
     C                   PARM                    RetCodeOut
      *
      ** Posting Amount
     C                   PARM                    DDPTAM
      *
      ** No. of Currency Decimal Places
     C                   PARM                    PNBDP
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Posting Amount - OK indicator
     C                   PARM                    DDPtamOK
      *
      ** Valid JE Item (DS) - for file update
     C                   PARM                    PVBITP
      *
      ** Update error information.
      *
     C                   EXSR      SRUPDERR
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDRCR - Validate Debit/Credit Indicator                     *
      *                                                               *
      *****************************************************************
      *
     C     SRDRCR        BEGSR
      *
      ** Reset error fields.
      *
     C                   EXSR      SRRESET
      *
     C                   CALLB     'GLVDBIN'
      *                             =======
      ** INPUT
      ** =====
      *
      ** Return code
     C                   PARM                    RetCodeOut
      *
      ** Debit/Credit Indicator
     C                   PARM                    DDDCIN
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Debit/Credit Indicator - OK indicator
     C                   PARM                    DDDcinOK
      *
      ** Valid JE Item (DS) - for file update
     C                   PARM                    PVBITP
      *
      ** Update error information.
      *
     C                   EXSR      SRUPDERR
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************                       CGL014
      *                                                               *                       CGL014
      *  SRBLCK - Validate for Sufficient Funds                       *                       CGL014
      *                                                               *                       CGL014
      *****************************************************************                       CGL014
                                                                                              CGL014
     C     SRBLCK        BEGSR                                                                CGL014
                                                                                              CGL014
      ** Reset error fields                                                                   CGL014
                                                                                              CGL014
     C                   EXSR      SRRESET                                                    CGL014
                                                                                              CGL014
     C                   CALLB     'GLVFUNDS'                                                 CGL014
                                                                                              CGL014
      ** INPUT                                                                                CGL014
      ** Return code                                                                          CGL014
                                                                                              CGL014
     C                   PARM                    RetCodeOut                                   CGL014
                                                                                              CGL014
      ** Valid JE Item (DS) - for file update                                                 CGL014
                                                                                              CGL014
     C                   PARM                    PVBITP                                       CGL014
                                                                                              CGL014
      ** OUTPUTS                                                                              CGL014
      ** Error fields/message IDs/message data (arrays) from/to caller                        CGL014
                                                                                              CGL014
     C                   PARM                    FldNamXAr                                    CGL014
     C                   PARM                    MsgIDXAr                                     CGL014
     C                   PARM                    MsgDtaXAr                                    CGL014
                                                                                              CGL014
      ** Posting Amount - OK flag                                                             CGL014
                                                                                              CGL014
     C                   PARM                    DDPTAMOK                                     CGL014
                                                                                              CGL014
      ** Update error information                                                             CGL014
                                                                                              CGL014
     C                   EXSR      SRUPDERR                                                   CGL014
                                                                                              CGL014
     C                   ENDSR                                                                CGL014
                                                                                              CGL014
      *****************************************************************                       CGL014
      /EJECT                                                                                  CGL014
      *****************************************************************
      *                                                               *
      *  SRNARR - Validate Narrative                                  *
      *                                                               *
      *****************************************************************
      *
     C     SRNARR        BEGSR
      *
      ** Reset error fields.
      *
     C                   EXSR      SRRESET
      *
     C                   CALLB     'GLVIMDX'
      *                             =======
      ** INPUT
      ** =====
      *
      ** Return code
     C                   PARM                    RetCodeOut
      *
      ** Narrative
     C                   PARM                    DDNARR
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Narrative - OK indicator
     C                   PARM                    DDNarrOK
      *
      ** Valid JE Item (DS) - for file update
     C                   PARM                    PVBITP
      *
      ** Update error information.
      *
     C                   EXSR      SRUPDERR
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRTTYP - Validate Transaction Type/Subtype                   *
      *                                                               *
      *****************************************************************
      *
     C     SRTTYP        BEGSR
      *
      ** Reset error fields.
      *
     C                   EXSR      SRRESET
      *
     C                   CALLB     'GLVIMTY'
      *                             =======
      ** INPUT
      ** =====
      *
      ** Return code
     C                   PARM                    RetCodeOut
      *
      ** Transaction Type
     C                   PARM                    DDTRTY
      *
      ** Transaction Subtype
     C                   PARM                    DDTSTY
      *
      ** Book Code
     C                   PARM                    DDBKCD
      *
      ** Profit Centre
     C                   PARM                    DDPRCN
      *
      ** Reverse/Void Indicator
     C                   PARM                    DDRVDI
      *
      ** STANDING DATA
      ** =============
      *
      ** SDMMOD - Management Accounts
     C                   PARM                    BGNVST
      *
      ** SWITCHABLE FEATURES
      ** ===================
      *
      ** EMU Account Posting Narrative feature
     C                   PARM                    CEU013
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Transaction Type - OK indicator
     C                   PARM                    DDTrtyOK
      *
      ** Valid JE Item (DS) - for file update
     C                   PARM                    PVBITP
      *
      ** Update error information.
      *
     C                   EXSR      SRUPDERR
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVDAT - Validate Value Date                                 *
      *                                                               *
      *****************************************************************
      *
     C     SRVDAT        BEGSR
      *
      ** Reset error fields.
      *
     C                   EXSR      SRRESET
      *
     C     B2ACTY        IFEQ      'R'
      *
     C                   CALLB     'GLVVLDT02'
      *                             =========
      ** INPUT
      ** =====
      *
      ** Return code
     C                   PARM                    RetCodeOut
      *
      ** Value Date
     C                   PARM                    DDVLDT
      *
      ** In Currency flag
     C                   PARM                    PINCY
      *
      ** Branch Location Code
     C                   PARM                    PLCCD
      *
      ** Account flag
     C                   PARM                    PAccount
      *
      ** Account details (DS)
     C                   PARM                    F1ACCT
     C                   PARM                    DDBTNB                                     MD055528      
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - System Rundate
     C                   PARM                    BJRDNB
      *
      ** SDBANK - Date Format
     C                   PARM                    BJDFIN
      *
      ** SDBANK - Local Currency Code
     C                   PARM                    BJLCCY
      *
      ** SDBANK - Back Value Period in Days
     C                   PARM                    BJBVPD
      *
      ** SDRETL - No. of Days Forward Value
     C                   PARM                    BMNDFV
      *
      ** SWITCHABLE FEATURES
      ** ===================
      *
      ** EMU Account Posting Narrative feature
     C                   PARM                    CEU013
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Warning flds/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr
      ** CGL150 Default Value Date 'Y'                                                      MD052075
     C                   PARM                    VDFLTF                                     MD052075
      *
      ** Value Date - OK indicator
     C                   PARM                    DDVldtOK
      *
      ** Valid JE Item (DS) - for file update
     C                   PARM                    PVBITP
      *
     C                   ELSE
      *
     C                   CALLB     'GLVVLDT01'
      *                             =========
      ** INPUT
      ** =====
      *
      ** Return code
     C                   PARM                    RetCodeOut
      *
      ** Value Date
     C                   PARM                    DDVLDT
      *
      ** In Currency flag
     C                   PARM                    PINCY
      *
      ** Account flag
     C                   PARM                    PAccount
      *
      ** Account details (DS)
     C                   PARM                    F1ACCT
     C                   PARM                    DDBTNB                                     MD055528     
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - System Rundate
     C                   PARM                    BJRDNB
      *
      ** SDBANK - Data Format
     C                   PARM                    BJDFIN
      *
      ** SDBANK - Back Value Period in Days
     C                   PARM                    BJBVPD
      *
      ** SWITCHABLE FEATURES
      ** ===================
      *
      ** EMU Account Posting Narrative feature
     C                   PARM                    CEU013
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      ** Warning flds/message IDs/message data (arrays) from/to caller                      MD052075
     C                   PARM                    WFldNmXAr                                  MD052075
     C                   PARM                    WMsgIDXAr                                  MD052075
     C                   PARM                    WMsgDtXAr                                  MD052075
      ** CGL150 Default Value Date 'Y'                                                      MD052075
     C                   PARM                    VDFLTF                                     MD052075
      *
      ** Value Date - OK indicator
     C                   PARM                    DDVldtOK
      *
      ** Valid JE Item (DS) - for file update
     C                   PARM                    PVBITP
      *
     C                   ENDIF
      *
      ** Update error information.
      *
     C                   EXSR      SRUPDERR
      *
     C                   ENDSR
     C/COPY OFCPYSRCZ,CGL135_070                                                             CGL135A
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCQNB - Validate Cheque Number                              *
      *                                                               *
      *****************************************************************
      *
     C     SRCQNB        BEGSR
      *
      ** Reset error fields.
      *
     C                   EXSR      SRRESET
      *
     C                   CALLB     'GLVCQNB'
      *                             =======
      ** INPUT
      ** =====
      *
      ** Return code
     C                   PARM                    RetCodeOut
      *
      ** Cheque Number
     C                   PARM                    DDCQNB
      *                                                                                       CRE019
      ** Cheque book processing feature                                                       CRE019
     C                   PARM                    CRE019            1                          CRE019
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *                                                                                       CRE019
      ** Warning fields/message IDs/message data (arrays) from/to caller                      CRE019
     C                   PARM                    WFldNmXAr                                    CRE019
     C                   PARM                    WMsgIDXAr                                    CRE019
     C                   PARM                    WMsgDtXAr                                    CRE019
      *
      ** Cheque Number - OK indicator
     C                   PARM                    DDCqnbOK
      *
      ** Return code for Stopped Cheque validation
     C                   PARM                    PSTOP             7
      *
      ** Valid JE Item (DS) - for file update
     C                   PARM                    PVBITP
      *
      ** Update error information.
      *
     C                   EXSR      SRUPDERR
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPRCN - Validate Profit Centre                              *
      *                                                               *
      *****************************************************************
      *
     C     SRPRCN        BEGSR
      *
      ** Reset error fields.
      *
     C                   EXSR      SRRESET
      *
      *                                                                                      CGL064
     C     CGL064        IFEQ      'Y'                                                       CGL064
      *                                                                                      CGL064
     C                   MOVE      *BLANKS       PSection          2                         CGL064
     C     DDACCD        IFNE      *BLANK                                                    CGL064
     C                   CALL      'AOACODR0'                                                CGL064
     C                   PARM      *BLANKS       WRTCD             7                         CGL064
     C                   PARM      '*KEY'        WOPTN             7                         CGL064
     C                   PARM      DDACCD        WACOD            10                         CGL064
     C     D@ACOD        PARM      *BLANK        DSSDY                                       CGL064
     C     WRTCD         IFEQ      *BLANKS                                                   CGL064
     C                   MOVE      A5ACSC        PSection                                    CGL064
     C                   ENDIF                                                               CGL064
     C                   ENDIF                                                               CGL064
      *                                                                                      CGL064
     C                   ENDIF                                                               CGL064
      *                                                                                      CGL064
     C                   CALLB     'GLVIMPF'
      *                             =======
      ** INPUT
      ** =====
      *
      ** Return code
     C                   PARM                    RetCodeOut
      *
      ** Profit Centre
     C                   PARM                    DDPRCN
      *
      ** Account Flag
     C                   PARM                    PAccount
      *
      ** Customer for Profit Centre validation
     C                   PARM                    PCust1            6
      *
      ** Customer A/c Officer Code for Profit Centre validation
     C                   PARM                    PAcOf1            2
      *
      ** Associated Customer for Profit Centre validation
     C                   PARM                    PCust2            6
      *
      ** Associated Customer A/c Officer Code for Profit Centre
      ** validation
     C                   PARM                    PAcOf2            2
      *
      ** Account details (DS)
     C                   PARM                    F1ACCT
      *
      ** STANDING DATA
      ** =============
      *
      ** SDGELR - Profit Centre Defaults Used
     C                   PARM                    BKPCDU
      *
      ** SDMMOD - Analytical Accounting
     C                   PARM                    BGN0ST
      *                                                                                      CGL064
      ** CGL064 flag                                                                         CGL064
     C                   PARM                    PCGL064           1                         CGL064
      *                                                                                      CGL064
      ** Account section                                                                     CGL064
     C                   PARM                    PSection          2                         CGL064
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Warning flds/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr
      *
      ** Profit Centre - OK indicator
     C                   PARM                    DDPrcnOK
      *
      ** Valid JE Item (DS) - for file update
     C                   PARM                    PVBITP
      *
      ** Update error information.
      *
     C                   EXSR      SRUPDERR
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SREROV - Validate Error Overrides                            *
      *                                                               *
      *****************************************************************
      *
     C     SREROV        BEGSR
      *
      ** Reset error fields.
      *
     C                   EXSR      SRRESET
      *
     C                   Z-ADD     *ZERO         WUSPEC            1 0                        238884
     C                   CALL      'ZVACTBU'                            90                    238884
     C                   PARM      'O'           ZACTN             1                          238884
     C                   PARM      DDIBCA        ZBR               3                          238884
     C     WUSPEC        PARM      *ZERO         ERR               1 0                        238884
      *                                                                                       238884
      **   If action invalid for user                                                         238884
      *                                                                                       238884
     C                   IF        *IN90 = '1'                                                238884
     C                   MOVEL     'Y2U0021'     W0RTN             7                          238884
     C                   ENDIF                                                                238884
     C                   IF        WUSPEC = 0                                                 238884
     C                   MOVE      'Y'           WUAUTH            1                          238884
     C                   ELSE                                                                 238884
     C                   MOVE      'N'           WUAUTH                                       238884
     C                   ENDIF                                                                238884
      *
     C                   CALLB     'GLVIMER'
      *                             =======
      ** INPUT
      ** =====
      *
      ** Return code
     C                   PARM                    RetCodeOut
      *
      ** Retail Override Indicator
     C                   PARM                    DDRINO
      *
      ** Return code for Stopped Cheque validation
     C                   PARM                    PSTOP
      *
      ** Account flag
     C                   PARM                    PAccount
      *
      ** Account details (DS)
     C                   PARM                    F1ACCT
      *
      ** SWITCHABLE FEATURES
      ** ===================
      *
      ** Block GL Accounts feature
     C                   PARM                    CGL002
      *                                                                                       238884
      ** Authorised to override                                                               238884
     C                   PARM                    WUAUTH                                       238884
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Retail/GL Overrides - OK indicator
     C                   PARM                    DDRinoOK
      *
      ** Retail Error Indicator - OK indicator
     C                   PARM                    DDRineOK
      *
      ** Non-overrideable flag
     C                   PARM                    POverride         1
      *
      ** Valid JE Item (DS) - for file update
     C                   PARM                    PVBITP
      *
      ** Update error information.
      *
     C     DDRineOK      IFEQ      'N'                                                        BUG449
     C     JAVAUSER      ANDEQ     'Y'                                                        BUG449
     C                   Eval      DDRINO = 'N'                                               BUG449
     C                   ENDIF                                                                BUG449
      *                                                                                       BUG449
     C                   EXSR      SRUPDERR
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRACUS - Validate Associated Customer                        *
      *                                                               *
      *****************************************************************
      *
     C     SRACUS        BEGSR
      *
      ** Reset error fields.
      *
     C                   EXSR      SRRESET
      *                                                                                      CGL064
     C     CGL064        IFEQ      'Y'                                                       CGL064
      *                                                                                      CGL064
     C                   MOVE      *BLANKS       PSection          2                         CGL064
     C     DDACCD        IFNE      *BLANK                                                    CGL064
     C                   CALL      'AOACODR0'                                                CGL064
     C                   PARM      *BLANKS       WRTCD             7                         CGL064
     C                   PARM      '*KEY'        WOPTN             7                         CGL064
     C                   PARM      DDACCD        WACOD            10                         CGL064
     C     D@ACOD        PARM      *BLANK        DSSDY                                       CGL064
     C     WRTCD         IFEQ      *BLANKS                                                   CGL064
     C                   MOVE      A5ACSC        PSection                                    CGL064
     C                   ENDIF                                                               CGL064
     C                   ENDIF                                                               CGL064
      *                                                                                      CGL064
     C                   ENDIF                                                               CGL064
      *                                                                                      CGL064
      *
     C                   CALLB     'GLVIMCS'
      *                             ========
      ** INPUT
      ** =====
      *
      ** Return code
     C                   PARM                    RetCodeOut
      *
      ** Associated Customer
     C                   PARM                    DDACNB
      *
      ** Account flag
     C                   PARM                    PAccount
      *
      ** Non-overrideable flag
     C                   PARM                    POverride
      *                                                                                      CGL064
      ** CGL064 flag                                                                         CGL064
     C                   PARM                    PCGL064           1                         CGL064
      *                                                                                      CGL064
      ** Account section                                                                     CGL064
     C                   PARM                    PSection          2                         CGL064
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Associated Customer - OK indicator
     C                   PARM                    DDAcnbOK
      *
      ** Associated Customer for Profit Centre validation
     C                   PARM                    PCust2            6
      *
      ** Associated Customer A/c Officer Code for Profit Centre
      ** validation
     C                   PARM                    PAcOf2            2
      *
      ** Valid JE Item (DS) - for file update
     C                   PARM                    PVBITP
      *
      ** Update error information.
      *
     C                   EXSR      SRUPDERR
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRBKCD - Validate Book Code                                  *
      *                                                               *
      *****************************************************************
      *
     C     SRBKCD        BEGSR
      *
      ** Reset error fields.
      *
     C                   EXSR      SRRESET
      *
     C                   CALLB     'GLVBKCD'
      *                             =======
      ** INPUT
      ** =====
      *
      ** Return code
     C                   PARM                    RetCodeOut
      *
      ** Book Code
     C                   PARM                    DDBKCD
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Book Code - OK indicator
     C                   PARM                    DDBkcdOK
      *
      ** Valid JE Item (DS) - for file update
     C                   PARM                    PVBITP
      *
      ** Update error information.
      *
     C                   EXSR      SRUPDERR
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRVIN - Validate Reverse/Void Indicator                     *
      *                                                               *
      *****************************************************************
      *
     C     SRRVIN        BEGSR
      *
      ** Reset error fields.
      *
     C                   EXSR      SRRESET
      *
     C                   CALLB     'GLVIMIN'
      *                             =======
      ** INPUT
      ** =====
      *
      ** Return code
     C                   PARM                    RetCodeOut
      *
      ** Reverse/Void Indicator
     C                   PARM                    DDRVDI
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Reverse/Void Indicator - OK indicator
     C                   PARM                    DDRvdiOK
      *
      ** Valid JE Item (DS) - for file update
     C                   PARM                    PVBITP
      *
      ** Update error information.
      *
     C                   EXSR      SRUPDERR
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRNITM - Validate No. of Items                               *
      *                                                               *
      *****************************************************************
      *
     C     SRNITM        BEGSR
      *
      ** Reset error fields.
      *
     C                   EXSR      SRRESET
      *
     C                   CALLB     'GLVNBIM01'
      *                             =========
      ** INPUT
      ** =====
      *
      ** Return code
     C                   PARM                    RetCodeOut
      *
      ** No. of Items
     C                   PARM                    DDNITM
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** No. of Items - OK indicator
     C                   PARM                    DDNitmOK
      *
      ** Valid JE Item (DS) - for file update
     C                   PARM                    PVBITP
      *
      ** Update error information.
      *
     C                   EXSR      SRUPDERR
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRORCA - Validate Original Currency and Amount               *
      *                                                               *
      *****************************************************************
      *
     C     SRORCA        BEGSR
      *
      ** Reset error fields.
      *
     C                   EXSR      SRRESET
      *
     C                   CALLB     'GLVIMCY'
      *                             =======
      ** INPUT
      ** =====
      *
      ** Return code
     C                   PARM                    RetCodeOut
      *
      ** Original Currency
     C                   PARM                    DDOCCY
      *
      ** Original Amount
     C                   PARM                    DDOAMT
      *
      ** In Currency flag
     C                   PARM                    PINCY
      *
      ** STANDING DATA
      ** =============
      *
      ** SDGELR - Currency Code for Euro
     C                   PARM                    BKEURO
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *                                                                                       238620
      ** Warning flds/message IDs/message data (arrays) from/to caller                        238620
     C                   PARM                    WFldNmXAr                                    238620
     C                   PARM                    WMsgIDXAr                                    238620
     C                   PARM                    WMsgDtXAr                                    238620
      *
      ** Original Currency - OK indicator
     C                   PARM                    DDOccyOK
      *
      ** Original Amount - OK indicator
     C                   PARM                    DDOamtOK
      *
      ** Valid JE Item (DS) - for file update
     C                   PARM                    PVBITP
      *
      ** Update error information.
      *
     C                   EXSR      SRUPDERR
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRESET - Reset error information that is received back from *
      *            each validation module                             *
      *                                                               *
      *****************************************************************
      *
     C     SRRESET       BEGSR
      *
     C                   EVAL      RetCodeOut = *BLANKS
      *
      ** Reset error and warning fields/message IDs/message
      ** data (arrays).
      *
     C                   MOVEL     *BLANKS       FldNamXAr
     C                   MOVEL     *BLANKS       MsgIDXAr
     C                   MOVEL     *BLANKS       MsgDtaXAr
      *
     C                   MOVEL     *BLANKS       WFldNmXAr
     C                   MOVEL     *BLANKS       WMsgIDXAr
     C                   MOVEL     *BLANKS       WMsgDtXAr
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRUPDERR - Routine to update Error Information with that     *
      *             received back from each validation module         *
      *                                                               *
      *****************************************************************
      *
     C     SRUPDERR      BEGSR
      *
      ** Update error fields/message IDs/message data (arrays).
      *
     C                   Z-ADD     1             I                 3 0
     C     *BLANK        LOOKUP    FldNameArr(I)                          01
     C     *IN01         IFEQ      '1'
     C                   MOVEA     FldNamXAr     FlDNameArr(I)
     C                   MOVEA     MsgIDXAr      MsgIdArr(I)
     C                   MOVEA     MsgDtaXAr     MsgDtaArr(I)
     C                   ENDIF
      *
      ** Set Error Index.
      *
     C                   Z-ADD     1             I
     C     *BLANK        LOOKUP    FldNameArr(I)                          01
     C     *IN01         IFEQ      '1'
     C     I             SUB       1             Idx
     C                   ELSE
     C                   EVAL      I = ArrayMax
     C                   MOVE      *BLANKS       FLDNAMEARR(I)
     C                   MOVE      *BLANKS       MSGIDARR(I)
     C                   MOVE      *BLANKS       MSGDTAARR(I)
     C                   EVAL      Idx = ArrayMax - 1
     C                   ENDIF
      *
      ** Update warning fields/message IDs/message data (arrays).
      *
     C                   Z-ADD     1             I
     C     *BLANK        LOOKUP    WFldNamArr(I)                          01
     C     *IN01         IFEQ      '1'
     C                   MOVEA     WFldNmXAr     WFldNamArr(I)
     C                   MOVEA     WMsgIDXAr     WMsgIDArr(I)
     C                   MOVEA     WMsgDtXAr     WMsgDtaArr(I)
     C                   ENDIF
      *
      ** Set Warning Index.
      *
     C                   Z-ADD     1             I
     C     *BLANK        LOOKUP    WFldNamArr(I)                          01
     C     *IN01         IFEQ      '1'
     C     I             SUB       1             WIdx
     C                   ELSE
     C                   EVAL      I = ArrayMax
     C                   MOVE      *BLANKS       WFLDNAMARR(I)
     C                   MOVE      *BLANKS       WMSGIDARR(I)
     C                   MOVE      *BLANKS       WMSGDTAARR(I)
     C                   EVAL      WIdx = ArrayMax - 1
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation                              *
      *         - This subroutine runs automatically for program      *
      *           initialisation.                                     *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
      *
      ** INPUT
      ** =====
      *
      ** Response Mode
     C                   PARM                    APRespMode        1
      *
      ** Associated Front Office Id
     C                   PARM                    APFOAsocId       20
      *
      ** Incoming Transaction (DS)
     C                   PARM                    PTranIn
                                                                                              246418
      ** JE Items Additional Info                                                             246418
     C                   PARM                    PAddInfo                                     246418
      *                                                                                     BUG23742
      ** JE Items Additional Narratives                                                     BUG23742
      *                                                                                     BUG23742
     C                   PARM                    PAddNarr                                   BUG23742
      *
      ** JE Items Extra Data (DS)
     C                   PARM                    PExtData
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - System Rundate
     C                   PARM                    BJRDNB            5 0
      *
      ** SDBANK - Date Format
     C                   PARM                    BJDFIN            1
      *
      ** SDBANK - Local Currency Code
     C                   PARM                    BJLCCY            3
      *
      ** SDBANK - Back Value Period in Days
     C                   PARM                    BJBVPD            3 0
      *
      ** SDBANK - Single Branch Code
     C                   PARM                    BJSBRC            3
      *
      ** SDGELR - Profit Centres Used
     C                   PARM                    BKPRCU            1
      *
      ** SDGELR - Profit Centre Defaults Used?
     C                   PARM                    BKPCDU            1
      *
      ** SDGELR - Currency Code for Euro
     C                   PARM                    BKEURO            3
      *
      ** SDMMOD - Analytical Accounting
     C                   PARM                    BGN0ST            1
      *
      ** SDMMOD - Management Accounts
     C                   PARM                    BGNVST            1
      *
      ** SDRETL - No. of Days Forward Value
     C                   PARM                    BMNDFV            3 0
      *
      ** TABTBRE - Charge for Multiple Transactions
     C                   PARM                    PCMTR             1
      *
      ** SWITCHABLE FEATURES
      ** ===================
      *
      ** EMU Account Posting Narrative feature
     C                   PARM                    CEU013            1
      *
      ** Block GL Accounts feature
     C                   PARM                    CGL002            1
      *                                                                                       CAP084
      ** Journal Entry Security Feature                                                       CAP084
     C                   PARM                    CGL008            1                          CAP084
      *                                                                                       CRE019
      ** Cheque book processing feature                                                       CRE019
     C                   PARM                    CRE019            1                          CRE019
      *                                                                                       CGL014
      ** Collaterals Processing                                                               CGL014
     C                   PARM                    CGL014                                       CGL014
                                                                                              237621
      ** Account Access Security                                                              237621
     C                   PARM                    CGL037            1                          237621
                                                                                              246418
      ** MT94x Messages Generation                                                            246418
     C                   PARM                    CGL013            1                          246418
      *                                                                                     BUG23742
      ** CER030 feature                                                                     BUG23742
      *                                                                                     BUG23742
     C                   PARM                    CER030                                     BUG23742
      *
      ** OUTPUT
      ** ======
      *
      ** JE Items Error Indicators (DS)
     C                   PARM                    PFlagsOK
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      *
      ** Array index (3P0) from/to caller
     C                   PARM                    Idx
      *
      ** Warning fields/message IDs/msg data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
      *
      ** Array index (3P0) from/to caller
     C                   PARM                    WIdx
      *
      ** Valid JE Item (DS) - for file update
     C                   PARM                    PVBITP
     C/COPY WNCPYSRC,GLBITPVC03
     C                   PARM                    CRE023                                       CRE023
      ** Valid JE Item (DS) - for file update                                                 246418
     C                   PARM                    PVBITPX                                      246418
     C/COPY OFCPYSRCZ,CGL135_071                                                             CGL135A
      ** CGL150 Default Value Date 'Y'                                                      MD052075
     C                   PARM                    VDFLTF            1                        MD052075
      *
      ** Program, module and procedure names for dbase error processing
      ** ==============================================================
      ** The following /COPY sets these values.
      *
      /COPY ZACPYSRC,DBFIELDS
      *
      ** Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,GLBITPV039
      *
      ** Check if Profit / Loss feature LLN021 is installed                                  LLN022A
      *                                                                                      LLN022A
     C                   CALL      'AOSARDR0'                                                LLN022A
     C                   PARM      *BLANKS       UUAPRC            7                         LLN022A
     C                   PARM      '*VERIFY'     UUAPOP            7                         LLN022A
     C                   PARM      'LLN021'      UUSARN            6                         LLN022A
      *                                                                                      LLN022A
     C     UUAPRC        IFEQ      *BLANKS                                                   LLN022A
     C                   MOVE      'Y'           LLN021            1                         LLN022A
     C                   ELSE                                                                LLN022A
     C                   MOVE      'N'           LLN021                                      LLN022A
     C                   ENDIF                                                               LLN022A
      *                                                                                      LLN022A
      **If*the*user*is*connected*via*a*browser,*the*job*user*name*is*QUSER*-          CAP084 BUG6979
      **their*user*name*is*stored*in*ZMUSER                                           CAP084 BUG6979
     C**********         IN        ZMUSER                                             CAP084 BUG6979
      **********                                                                      CAP084 BUG6979
     C*****USRID         IFNE      *BLANKS                                            CAP084 BUG6979
     C*****USRID         ANDNE     PSUser                                             CAP084 BUG6979
     C**********         MOVE      'Y'           JAVAUSER          1                  CAP084 BUG6979
     C**********         ELSE                                                         CAP084 BUG6979
     C**********         MOVE      'N'           JAVAUSER                             CAP084 BUG6979
     C**********         ENDIF                                                        CAP084 BUG6979
      **********                                                                      CAP084 BUG6979
      ***Check*the*User*details*extension*to*retrieve*the*journal                     CAP084 BUG6979
      ***entry*authorisation*for*CGL008                                               CAP084 BUG6979
      **********                                                                      CAP084 BUG6979
     C*****CGL008        IFEQ      'Y'                                                CAP084 BUG6979
     C**********         CALL      'AOUSERR0'                                         CAP084 BUG6979
     C**********         PARM      *BLANKS       PRTNC             7                  CAP084 BUG6979
     C**********         PARM      '*KEY   '     POPTN             7                  CAP084 BUG6979
     C**********         PARM      USRID         PUSRP            10                  CAP084 BUG6979
     C*****SDUSER        PARM      SDUSER        DSSDY                                CAP084 BUG6979
      **********                                                                       BG9009 237621
      ***Check*if*Retail*account*security*is*installed.****************                BG9009 237621
     C**********         CallB     'AOSARDR0'                                          BG9009 237621
     C**********         Parm      *BLANKS       PRTNC                                 BG9009 237621
     C**********         Parm      '*VERIFY'     POPTN                                 BG9009 237621
     C**********         Parm      'CGL037'      PSARD                                 BG9009 237621
     C*****SCSARD        Parm      SCSARD        DSFDY                                 BG9009 237621
      **********                                                                       BG9009 237621
      ***An*NRF*(No*Record*Found)*return*code*is*valid.****************                BG9009 237621
      ***Issue*database*error*only*for*error*return*codes.*************                BG9009 237621
     C**********         If        PRTNC <> *BLANKS and PRTNC <> '*NRF   '             BG9009 237621
     C**********         Eval      DBFile = 'SCSARDPD'                                 BG9009 237621
     C**********         Eval      DBKey = 'CGL037'                                    BG9009 237621
     C**********         Eval      DBase = 001                                         BG9009 237621
     C**********         ExSr      *PSSR                                               BG9009 237621
     C**********         EndIf                                                         BG9009 237621
      **********                                                                       BG9009 237621
     C**********         If        PRTNC = *BLANKS                                     BG9009 237621
     C**********         Eval      CGL037 = 'Y'                                        BG9009 237621
     C**********         Else                                                          BG9009 237621
     C**********         Eval      CGL037 = 'N'                                        BG9009 237621
     C**********         EndIf                                                         BG9009 237621
      *                                                                                       243965
     C                   EVAL      CmpAssCust = 'Y'                                           243965
      *                                                                                       243965
      ** Access System values                                                                 243965
                                                                                              243965
     C                   CALL      'AOSVALR0'                                                 243965
     C                   PARM      *BLANKS       PRetCode                                     243965
     C                   PARM      PSysVal1      P@OP01                                       243965
     C                   PARM      *BLANKS       P@VL01                                       243965
     C                   PARM      *BLANKS       P@OP02                                       243965
     C                   PARM      *BLANKS       P@VL02                                       243965
     C                   PARM      *BLANKS       P@OP03                                       243965
     C                   PARM      *BLANKS       P@VL03                                       243965
     C                   PARM      *BLANKS       P@OP04                                       243965
     C                   PARM      *BLANKS       P@VL04                                       243965
     C                   PARM      *BLANKS       P@OP05                                       243965
     C                   PARM      *BLANKS       P@VL05                                       243965
     C                   PARM      *BLANKS       P@OP06                                       243965
     C                   PARM      *BLANKS       P@VL06                                       243965
     C                   PARM      *BLANKS       P@OP07                                       243965
     C                   PARM      *BLANKS       P@VL07                                       243965
     C                   PARM      *BLANKS       P@OP08                                       243965
     C                   PARM      *BLANKS       P@VL08                                       243965
     C                   PARM      *BLANKS       P@OP09                                       243965
     C                   PARM      *BLANKS       P@VL09                                       243965
     C                   PARM      *BLANKS       P@OP10                                       243965
     C                   PARM      *BLANKS       P@VL10                                       243965
                                                                                              243965
     C                   IF        PRetCode  <> *BLANKS                                       243965
     C                   EVAL      DBFile = 'SDSVALPD'                                        243965
     C                   EVAL      DBKey = '*KEY   '                                          243965
     C                   EVAL      DBase = 1                                                  243965
     C                   EXSR      *PSSR                                                      243965
     C                   ELSE                                                                 243965
     C                   IF        P@VL01 = 'N'                                               243965
     C                   EVAL      CmpAssCust = 'N'                                           243965
     C                   ENDIF                                                                243965
     C                   ENDIF                                                                243965
      *                                                                                       CAP084
      ** Define key list for SFACAUL0.                                                        CAP084
      *                                                                                       CAP084
     C     KACCD         KLIST                                                                CAP084
     C                   KFLD                    WACCD                                        CAP084
     C                   KFLD                    USRID                                        CAP084
      *                                                                                       CAP084
     C**********         ENDIF                                                        CAP084 BUG6979
      ** Access SAR details file to determine if CGL064 is on.                                CGL064
      *                                                                                       CGL064
     C                   CALLB     'AOSARDR0'                                                 CGL064
     C                   PARM      *BLANKS       @RTCD                                        CGL064
     C                   PARM      '*VERIFY'     @OPTN                                        CGL064
     C                   PARM      'CGL064'      @SARD                                        CGL064
     C     SCSARD        PARM      SCSARD        UUFDY                                        CGL064
      *                                                                                       CGL064
     C     @RTCD         IFEQ      *BLANK                                                     CGL064
     C                   MOVE      'Y'           CGL064            1                          CGL064
     C                   MOVE      'Y'           PCGL064           1                          CGL064
     C                   ELSE                                                                 CGL064
     C                   MOVE      'N'           CGL064                                       CGL064
     C                   MOVE      'N'           PCGL064                                      CGL064
     C                   END                                                                  CGL064
      *                                                                                       CGL148
      ** Access SAR details file to determine if CGL148 is on.                                CGL148
      *                                                                                       CGL148
     C                   CALLB     'AOSARDR0'                                                 CGL148
     C                   PARM      *BLANKS       @RTCD                                        CGL148
     C                   PARM      '*VERIFY'     @OPTN                                        CGL148
     C                   PARM      'CGL148'      @SARD                                        CGL148
     C     SCSARD        PARM      SCSARD        UUFDY                                        CGL148
      *                                                                                       CGL148
     C     @RTCD         IFEQ      *BLANK                                                     CGL148
     C                   MOVE      'Y'           CGL148            1                          CGL148
     C                   ELSE                                                                 CGL148
     C                   MOVE      'N'           CGL148                                       CGL148
     C                   ENDIF                                                                CGL148
      *                                                                                       CGL148
      *                                                                                       CGL064
     C/COPY OFCPYSRCZ,CGL135_072                                                             CGL135A
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
      *
      /COPY ZACPYSRC,PSSR_ILE
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
**  CPY@
(c) Finastra International Limited 2001
