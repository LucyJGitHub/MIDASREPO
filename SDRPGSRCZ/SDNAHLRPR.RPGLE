     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Non-Account Holder - Repair')                 *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDNAHLRPR - Invalid Non-A/C Holders Details Repair Function  *
      *                                                               *
      *  Function:  This function allows invalid Non-A/C  details to  *
      *             be 'repaired' and applied to the Midas database.  *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *  Last Amend No. CSD100             Date 03Aug17               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 MD029805           Date 05Sep14               *
      *                 MD026550           Date 22May14               *
      *                 CGL132             Date 01May13               *
      *                 CER059             Date 19Jul10               *
      *                 CER054             Date 07Apr09               *
      *                 BUG22580           Date 02Feb09               *
      *                 CER048             Date 19May08               *
      *                 CER047             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 CSW207A            Date 06Aug07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 232543             Date 14Mar05               *
      * Midas Release 4.04 -------------------------------------------*
      *                 CGL032  *CREATE    Date 05Jul04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD100 - Patronymic and Gender Fields for Non-Account Holder *
      *           (Recompile)                                         *      
      *  MD046248 - Finastra Rebranding                               *
      *  MD029805 - GIIN number validation (Recompile)                *
      *  MD026550 - Require US TIN when Subject to Reporting is 'Y'   *
      *             for all new FATCA Customers/Non-Account Holders   *
      *  CGL132 - FATCA Phase 1 - Customers' Identification and       *
      *           Classification - Master                             *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER054 - German Features - Church Tax (Recompile)            *
      *  BUG22580 - Fields incorrectly labeled and lengths            *
      *             (Recompile)                                       *
      *  CER048 - German Features - Taxes (Recompile)                 *
      *  CER047 - German Features LF037-00 Reporting §24c KWG         *
      *           (Recompile)                                         *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  CSW207A - SWIFT 2007 Changes (Recompile)                     *
      *  232543 - Fix to CGL032                                       *
      *  CGL032 - Automatic Exchange of Information.                  *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FZATRNERRL0IF   E           K DISK    Infsr(*PSSR)
 
     FSDINAHLL0 IF   E           K DISK    Infsr(*PSSR)
     F                                     Rename(SDINAHLD0:SDINAHLX0)
 
     FSDINAHLL1 UF   E           K DISK    Infsr(*PSSR)
     F                                     Commit
 
     FSDIFTNHL1 UF   E           K DISK    Infsr(*PSSR)                                       CGL132
     F                                     Commit                                             CGL132
                                                                                              CGL132
      ** API Invalid Log File from Support Database
     FAPILOGL0  UF   E           K DISK    INFSR(*PSSR) USROPN
     F                                     COMMIT
 
      ** Hook to enable non-core files to be included
      /COPY WNCPYSRC,SDNAHLR001
 
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
 
   41 ** Array of Fields in error, temporary store
     D @EI             S              1    Dim(60)
 
   42 ** Array of error message IDs, temporary store
   42D TmpFldNmAr      S             10A   Dim(ArrayMax)
 
   42D TmpMsgIdAr      S                   Dim(ArrayMax)
   42D                                     Like(#MsgID)
 
      ** Current Non-A/C Holder in File Format
     D CrNaFilFmt    E DS                  Extname(SDNAHOPD)
     D                                     Prefix(C_)
                                                                                              CGL132
      ** Current Non-A/C Holder in File Format - FATCA details                                CGL132
     D CrFaFilFmt    E DS                  EXTNAME(SDFTNHPD)                                  CGL132
     D                                     PREFIX(C_)                                         CGL132
 
      ** Current Non-A/C Holder in Screen Format - Primary Details
     D CurNaPrim     E DS                  Extname(SDNAHLPD)
     D                                     Prefix(@)
                                                                                              CGL132
      ** Current Non-A/C Holder in Screen Format - FATCA Details                              CGL132
     D CurCuFATC     E DS                  EXTNAME(SDFTNRPD)                                  CGL132
     D                                     PREFIX(@)                                          CGL132
 
      ** New Non-A/C Holer in File Format
     D NwNaFilFmt    E DS                  Extname(SDVNAHLPD)
                                                                                              CGL132
      ** New Non-A/C Holder in File Format - FATCA Details                                    CGL132
     D NwFaFilFmt    E DS                  EXTNAME(SDVFTNHPD)                                 CGL132
 
      ** New Non-A/C Holder  in Screen Format - Primary Details
     D NewNaPrim     E DS                  Extname(SDNAHLPD)
                                                                                              CGL132
      ** New Non-A/C Holder in Screen Format - FATCA details                                  CGL132
     D NewCuFATC     E DS                  EXTNAME(SDFTNRPD)                                  CGL132
 
      ** Previous Non-A/C Holder in Screen Format - Primary Details
     D PrvNaPrim     E DS                  Extname(SDNAHLPD)
     D                                     Prefix(@P)
                                                                                              CGL132
      ** Previous Customer in Screen Format - FATCA customer details                          CGL132
     D PrvCuFATC     E DS                  EXTNAME(SDFTNRPD)                                  CGL132
     D                                     PREFIX(@P)                                         CGL132
 
      ** Error indicators
     D OkNaPrim      E DS                  Extname(SDENAHLPD)
     D OKFATCAdet    E DS                  EXTNAME(SDEFTNHPD)                                 CGL132
 
      ** External DS for Bank Details
     D SDBANK        E DS                  Extname(SDBANKPD)
 
      ** External DS for SAR Details
     D SCSARD        E DS                  Extname(SCSARDPD)
     D  SCA_LCD      E                     Extfld(LCD)
 
      ** External DS for API ICD
     D SDAPI         E DS                  Extname(SDAPIPD)
 
      ** First DS for Access Programs, Short Data Structure
     D DSFDY         E DS                  Extname(DSFDY)
 
      ** Second DS for Access Programs, Long Data Structure
     D DSSDY         E DS                  Extname(DSSDY)
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
     D  WWTINO               149    173                                                       CGL132
                                                                                              CGL132
     D NewCuFOTH       DS                                                                     CGL132
     D  WCDESC1                1     50                                                       CGL132
     D  WPDESC1               51    100                                                       CGL132
     D  WNNARD1              101    106                                                       CGL132
     D  WNLARD1              107    112                                                       CGL132
     D  WNBRTH1              113    118                                                       CGL132
     D  WWCBTH1              119    120                                                       CGL132
     D  WWBTHT1              121    155                                                       CGL132
     D  WWCNCZ1              156    157                                                       CGL132
     D  WWCDOM1              158    159                                                       CGL132
     D  WWACCZ1              160    161                                                       CGL132
     D  WWTINO1              162    186                                                       CGL132
                                                                                              CGL132
     D CurCuFOTH       DS                                                                     CGL132
     D  WCDESC2                1     50                                                       CGL132
     D  WPDESC2               51    100                                                       CGL132
     D  WNBRTH2              101    106                                                       CGL132
     D  WWCBTH2              107    108                                                       CGL132
     D  WWBTHT2              109    143                                                       CGL132
     D  WWCNCZ2              144    145                                                       CGL132
     D  WWCDOM2              146    147                                                       CGL132
     D  WWACCZ2              148    149                                                       CGL132
     D  WWTINO2              150    174                                                       CGL132
 
      ** SD data area
     D SDSTAT        E DS                  Extname(SDSTAT) DTAARA(SDSTAT)
 
      ** 24X7 status data area
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      **   Timestamp selected
     D @TMESTPSEL      S             26Z
     D @Timestamp      S             26Z
 
     D ExtData         S            500A
     D Retcd           S              7A                                                      CGL132
     D Option          S              7A                                                      CGL132
 
      ** Response Mode, passed as a constant parameter to the VAL module
      ** This is always 'S' for Synchronous
     D RespMode        S              1A   Inz('S')
 
      ** Fields for getting the starting field number from file (parameters
      ** to ZACGTFLDNO, plus the offset to the requested field).
     D FormatC         S             10A   Inz('SDNAHLPD')
 
     D FormatP         S             10A   Inz('SDNAHLPD')
     D FormatS         S             10A   Inz('SDNAHLPD')
 
     D FieldP          S             10A   Inz('DDACTN')
     D FieldS          S             10A   Inz('DDCSID')
 
     D FldOffsetP      S              5P 0
     D FldOffsetS      S              5P 0
 
     D FieldNo         S              5P 0
 
      ** End of fields for getting starting field number
 
      ** Fields for getting the ending field number from file (parameters
      ** to ZACGTFLDNO, plus the offset to the requested field).
 
     D FieldPL         S             10A   Inz('DDMTSC')
     D FieldSL         S             10A   Inz('DDSSDL')
 
     D FldOffstPL      S              5P 0
     D FldOffstSL      S              5P 0
 
      ** End of fields for getting ending field number
     D WKNAHO          S                   Like(DDNAHO)
     D WeF             S              1A   Inz(*BLANK)
     D WeB             S              1A   Inz(*BLANK)
     D WeS             S              1A   Inz(*BLANK)
     D WeM             S              1A   Inz(*BLANK)
     D WeV             S              1A   Inz(*BLANK)
 
 
      ** Flags to indicate whether substitution is required in
      ** each of the various parts the transaction
 
     D RepPrim         S              1A   inz('N')
 
     D KMsgType        S              8A
     D PRtCd           S              7A
     D POptn           S              7A
     D PSard           S              6A
     D KFrntOffID      S                   Like(@FOTRANSEL)
     D KTimeStamp      S                   Like(@TMESTPSEL)
     D CSC011          S              1A
 
      ** Parameter fields for RPB pgm
     D @BDSFL          S              1
     D @RDSFL          S              1
     D @ERRUP          S              1
     D @ERRMS          S              7
     D @OPSEL          S              1
     D @ACSEL          S              1
     D @FOTRANSEL      S             20
     D @INKC           S              1
     D @INKL           S              1
     D @INKX           S              1                                                       CGL132
 
      ** Parameter field for 2DP pgm
     D @EKYFD          S              1
     D @EDTFD          S              1
     D @EINKG          S              1
     D @EINKJ          S              1
     D @INKG           S              1
     D @INKH           S              1
     D @INKJ           S              1
     D @INKQ           S              1A   INZ('0')                                           CGL132
     D @INKR           S              1A   INZ('0')                                           CGL132
     D @INKS           S              1A   INZ('0')                                           CGL132
     D @INKT           S              1A   INZ('0')                                           CGL132
     D @EINKX          S              1                                                       CGL132
 
      ** Parameter field for RTV pgm
     D @@MODE          S              6
     D @@RSMD          S              1
     D @IN36           S              1
     D @Einkh          S              1
 
      ** Parameter fields for APDTASUBS
     D SubsChar        S              1
     D IncDATA         S           2000
     D CurDATA         S           2000
 
     D WIdx_Pval       S              3  0
     D WIdx_Tval       S              3  0                                                    CGL132
     D @RdnB           S              1
     D E               S              3  0
     D F               S              3  0
     D Idx             S              3  0
     D PrvN_Warn       S              3  0
     D @SCRN           S              1
     D ##DDNaho        S              6
 
      ** -------------------------------------------------------------------
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
     C
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *InzSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
 
      ** Issue rollback to clear any possible updates in window functions
 
     C     @INKL         IFEQ      *On
     C                   ROLBK
     C                   ENDIF
 
      ** Do Screen: Browse Invalid Deals
 
     C     @SCRN         IFEQ      'I'
     C                   EXSR      SRScrn@I
     C                   ENDIF
 
      ** Read next browse subfile record
 
     C     @SCRN         IFEQ      'R'
     C                   EXSR      SRRdnBrw
     C                   ENDIF
 
      ** Do While screen: Primary Details Screen
 
     C                   Z-ADD     *ZERO         WIdx_PVAL
     C     @SCRN         DOWEQ     'P'
     C                   EXSR      SRScrn@P
     C                   ENDDO
                                                                                              CGL132
      ** Do while screen: FATCA details screen 1                                              CGL132
     C                   Z-ADD     *ZERO         WIdx_GVAL         3 0                        CGL132
     C     @SCRN         DOWEQ     'G'                                                        CGL132
     C                   EXSR      SCRN@G                                                     CGL132
     C                   ENDDO                                                                CGL132
                                                                                              CGL132
      ** Do while screen: US Indicia screen 1                                                 CGL132
     C                   Z-ADD     *ZERO         WIdx_CVAL         3 0                        CGL132
     C     @SCRN         DOWEQ     'C'                                                        CGL132
     C                   EXSR      SCRN@C                                                     CGL132
     C                   ENDDO                                                                CGL132
                                                                                              CGL132
      ** Do while screen: US Indicia screen 2                                                 CGL132
     C                   Z-ADD     *ZERO         WIdx_HVAL         3 0                        CGL132
     C     @SCRN         DOWEQ     'H'                                                        CGL132
     C                   EXSR      SCRN@H                                                     CGL132
     C                   ENDDO                                                                CGL132
                                                                                              CGL132
      ** Do while screen: US Indicia screen 3                                                 CGL132
     C                   Z-ADD     *ZERO         WIdx_LVAL         3 0                        CGL132
     C     @SCRN         DOWEQ     'L'                                                        CGL132
     C                   EXSR      SCRN@L                                                     CGL132
     C                   ENDDO                                                                CGL132
                                                                                              CGL132
      ** Do while screen: US Indicia screen 4                                                 CGL132
     C                   Z-ADD     *ZERO         WIdx_YVAL         3 0                        CGL132
     C     @SCRN         DOWEQ     'Y'                                                        CGL132
     C                   EXSR      SCRN@Y                                                     CGL132
     C                   ENDDO                                                                CGL132
                                                                                              CGL132
      ** Do while screen: US Indicia comment history screen                                   CGL132
     C     @SCRN         DOWEQ     'V'                                                        CGL132
     C                   EXSR      SRUSHC                                                     CGL132
     C                   ENDDO                                                                CGL132
                                                                                              CGL132
      ** Do while screen: Exception screen                                                    CGL132
     C     @SCRN         DOWEQ     'N'                                                        CGL132
     C                   EXSR      SCRN@O                                                     CGL132
     C                   ENDDO                                                                CGL132
                                                                                              CGL132
 
      ** Do File updates
 
     C     @SCRN         IFEQ      'U'
     C                   EXSR      SRUpdats
     C                   ENDIF
 
      ** Terminate program
 
     C     @SCRN         IFEQ      'T'
     C                   MOVE      *ON           *INLR
     C                   ENDIF
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** SRScrn@I - Browse Invalid Non-A/C Holders
      *****************************************************************
 
     C     SRScrn@I      BEGSR
 
      ** Reset read nexT browse subfile record
 
     C                   MOVEL     *BLANK        @RDNB             1
 
      ** Build Browse Subfile
 
     C                   CALLB     'SDNAHLRPB'
      **                ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
      ** INPUTS :
      ** Return Code
      ** Build Sub-File
      ** Read Subfile Record
      ** Error in update of previous deal
 
     C                   PARM      *BLANK        RetCodeOut
     C                   PARM      'Y'           @BDSFL            1
     C                   PARM      *BLANK        @RDSFL            1
     C                   PARM                    @ERRUP            1
     C                   PARM                    CSC011
 
      ** OUTPUTS :
      ** Error Message
      ** Option Selecetd
      ** Action Selected
      ** FO Transaction ID Selected
      ** Non-A/C Holder Reference
      ** Timestamp of Transaction Selected
      ** Command Keys
 
     C                   PARM      *BLANK        @ERRMS
     C                   PARM                    @OPSEL
     C                   PARM                    @ACSEL
     C                   PARM                    @FOTRANSEL
     C                   PARM      *blanks       DDNAHO
     C                   PARM                    @TMESTPSEL
     C                   PARM      *Off          @INKC
     C                   PARM      *Off          @INKL
 
      ** If error set on external switches
 
     C     @ERRMS        IFNE      *BLANK
     C                   MOVE      *On           *INU6
     C                   ENDIF
 
      ** If CK/3 or CK/12 taken in browse, or error message
      ** End program
 
     C     @INKC         IFEQ      *On
     C     @INKL         OREQ      *On
     C     @ERRMS        ORNE      *BLANK
     C                   EXSR      SREndP
     C                   GOTO      ESCRN@I
     C                   ENDIF
 
      ** Read next browse subfile record
 
     C                   MOVE      'Y'           @RDNB
     C                   MOVE      'R'           @SCRN
 
     C     ESCRN@I       ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** SRRdnBrw - Read next browse subfile record
      *****************************************************************
 
     C     SRRdnBrw      BEGSR
 
      ** Read Next Subfile Record
 
     C                   CALLB     'SDNAHLRPB'
      **                ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
      ** INPUTS :
      ** Return Code
      ** Build Sub-File
      ** Read Subfile Record
      ** Error in update of previous deal
 
     C                   PARM      *BLANK        RetCodeOut
     C                   PARM      *BLANK        @BDSFL
     C                   PARM      'Y'           @RDSFL
     C                   PARM                    @ERRUP
     C                   PARM                    CSC011
 
      ** OUTPUTS :
      ** Error Message
      ** Option Selected
      ** Action Selected
      ** FO Transaction ID Selected
      ** Non-A/C Holder
      ** Timestamp of Transaction Selected
      ** Command Keys
 
     C                   PARM      *BLANK        @ERRMS
     C                   PARM      *BLANK        @OPSEL
     C                   PARM      *BLANK        @ACSEL
     C                   PARM      *BLANK        @FOTRANSEL
     C                   PARM      *BLANK        DDNAHO
     C                   PARM                    @TMESTPSEL
     C                   PARM      *Off          @INKC
     C                   PARM      *Off          @INKL
 
      ** If CK/3 taken within invalid transaction deletion function,
      ** End program
 
     C     @INKC         IFEQ      *On
     C                   EXSR      SREndP
     C                   GOTO      ERDNBRW
     C                   ENDIF
 
      ** If Invalid Non-A/C Holder read from subfile
 
     C     @OPSEL        IFNE      *BLANK
 
      ** Clear file formats
 
     C                   CLEAR                   NwNaFilFmt
 
      ** Blank the screens
 
     C                   EVAL      WKNAHO = DDNAHO
     C                   EVAL      WeF = *BLANK
     C                   EVAL      WeB = *BLANK
     C                   EVAL      WeS = *BLANK
     C                   EVAL      WeM = *BLANK
     C                   EVAL      WeV = *BLANK
     C                   CLEAR                   NewNaPrim
 
      ** Reset Errors
 
     C                   MOVE      *ALL'Y'       OkNaPrim
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIdArr
     C                   MOVEL     *BLANK        MsgDtaArr
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
 
      ** Retrieve Non-A/C  details
 
     C                   EVAL      DDNAHO = WKNAHO
     C                   MOVEL     @ACSEL        DDACTN
     C                   MOVEL     @FOTRANSEL    DDFRNT
 
      ** Make sure Invalid transaction's  details are passed to 'Retreive'
      ** module for SPF checking .
 
     C     ZATRNKX0      CHAIN     SDINAHLX0                          99
 
      ** Set retrieve mode to '*FRONT' (Access using Front Office ID)
      **  if insert
      **  if not insert and Midas transaction ID is not present
      ** Otherwise
      **  Set retrieve mode to blank  (Access using Midas transaction ID).
 
     C     DDACTN        IFEQ      'I'
     C                   MOVEL     '*FRONT'      @@MODE
     C                   ELSE
 
     C     DDNAHO        IFEQ      *BLANK
     C                   MOVEL     '*FRONT'      @@MODE
     C                   ELSE
     C                   MOVEL     '      '      @@MODE
     C                   ENDIF
 
     C                   ENDIF
 
     C                   EXSR      SRRtvNah
 
      ** If Non-A/C  details were retrieved
      ** Convert the Non-A/C  to screen format.
 
     C     C_NHNAHO      IFNE      *BLANK
     C     DDACTN        ANDNE     'I'
     C                   EXSR      SRCvtNah
     C                   MOVEL     CrNaFilFmt    NwNaFilFmt
     C                   ENDIF
 
      ** Now overwite the fields on the main details screen with those
      ** on the invalid Non-A/C s file (except for the Midas Non-A/C
      ** reference retrieved above using the front office transaction ID).
      ** Access invalid Non-A/C  with timestamp and front office transaction ID.
 
      ** Non-A/C  details:
 
     C                   MOVEL     DDNAHO        ##DDNAHO
     C     ZATRNKX0      CHAIN     SDINAHLX0                          99
 
      ** If Non-A/C  details were retrieved and this is an amendment
 
     C     C_NHNAHO      IFNE      *BLANK
     C     DDACTN        ANDEQ     'A'
 
      ** Data Substitution - Transaction Details
 
     C     GHSUBS        IFNE      *blank
 
     C     GHSUBS        SCAN      NewNaPrim                              99
     C                   IF        *in99
     C                   EVAL      RepPrim = 'Y'
     C                   ENDIF
 
      ** If any of the flags set above is true, do the data
      ** substution subroutine.
 
     C                   IF        (RepPrim = 'Y')
     C                   EXSR      SRTDtDtaSubs
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
      ** If action code, or Non-A/C  reference were NOT OK
      ** blank out action code so that the input cannot proceed
 
     C     OkActn        IFEQ      'N'
     C     OkNaho        OREQ      'N'
     C                   MOVEL     *BLANK        DDACTN
     C                   ENDIF
 
      ** Send the Non-A/C s error messages to the primary details screen
      ** and go to Primary Details Screen
 
     C                   EXSR      SRSndM@P
     C                   Z-ADD     *ZERO         WIdx_PVAL
     C                   MOVE      'P'           @SCRN
 
      ** ELSE IF NO INVALID Non-A/C  Read FROM SUBFILE
 
     C                   ELSE
 
      ** Go to Browse Screen
 
     C                   MOVE      'I'           @SCRN
     C                   ENDIF
 
     C     ERDNBRW       ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** SRSndM@P - SEND A MESSAGE TO PRIMARY DETAILS SCREEN
      *****************************************************************
     C     SRSndM@P      BEGSR
 
     C                   Z-ADD     Idx           E
 
      ** If there are fundamental errors in this transaction
      ** Identify this fact.
 
     C     OkActn        IFEQ      'N'
     C     OKNaho        OREQ      'N'
     C                   Add       1             E
 
      ** Ensure that the message 'TRANSACTION CANNOT PROCEED' is seen
      ** first by the user
 
     C                   EVAL      TmpfldNmAr = *BLANKS
     C                   EVAL      TmpMsgIdAr = *BLANKS
     C                   MOVEA     FldNameArr    TmpFldNmAr
     C                   MOVE      *BLANKS       FldNameArr(1)
     C                   MOVEA     TmpFldNmAr    FldNameArr(2)
     C                   MOVEA     MsgIdArr      TmpMsgIdAr
     C                   MOVE      *BLANKS       MsgIdArr(1)
     C                   MOVEA     TmpMsgIdAr    MsgIdArr(2)
     C                   MOVEL     '*ANY'        FldNameArr(1)
     C                   MOVEL     'APM0110'     MsgIdArr(1)
     C                   ENDIF
 
      ** Initialize error indicators
 
     C                   MOVEA     OkNaPrim      @EI
 
     C                   MOVE      @TMESTPSEL    @Timestamp
 
      ** Read error messages for Non-A/C
 
     C     ZATRNKD0      Setll     ZATRNERRD0
     C     ZATRNKD0      ReadE     ZATRNERRD0                             99
 
      ** Add error message to array passed to detail screen
      ** and set OK flag for field to 'N'
 
     C     *IN99         DOWEQ     *Off
 
     C                   CALLB     'ZACGTFLDNO'
     C                   PARM      *BLANK        ReturnCode
     C                   PARM                    FormatP
     C                   PARM                    ABFIELDNAM
     C                   PARM      *ZERO         FieldNo
 
     C                   IF        ReturnCode = *blank
     C                   Add       1             E
     C                   MOVEL     ABFIELDNAM    FldNameArr(E)
     C                   MOVEL     ABMSGID       MsgIdArr(E)
     C                   Z-ADD     ABFIELDID     F
     C                   Sub       FldOffsetP    F
 
     C     F             IFLT      1
     C     F             Orgt      60
     C                   Z-ADD     1             F
     C                   ENDIF
 
     C     ABFIELDNAM    IFEQ      'DDCDEL'
     C     ABMSGID       ANDEQ     'USR4592'
     C                   ELSE
     C                   MOVE      'N'           @EI(F)
     C                   ENDIF
     C                   ENDIF
 
     C     ZATRNKD0      ReadE     ZATRNERRD0                             99
     C                   ENDDO
 
     C                   MOVEA     @EI           OkNaPrim
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** SRScrn@P - PROCESS SCREEN: PRIMARY DETAILS
      *****************************************************************
     C     SRScrn@P      BEGSR
 
      ** Enable/disable detail fields on primary details screen
      ** if changes to the data are allowed
      ** (key fields = action code & Non-A/C  reference; detail fields = rest)
      ** (Action code can only be 'I', 'A', 'D', or 'E')
 
     C     DDACTN        IFEQ      'I'
     C     @OPSEL        ANDEQ     'U'
     C     DDACTN        OREQ      'A'
     C     @OPSEL        ANDEQ     'U'
     C                   MOVEL     'Y'           @EDTFD
     C                   ELSE
     C                   MOVEL     'N'           @EDTFD
     C                   ENDIF
 
      ** KJ = COMMAND KEY 10 = CONFIRM DELETE
 
     C     DDACTN        IFEQ      'D'
     C                   MOVEL     'Y'           @EINKJ
     C                   ELSE
     C                   MOVEL     'N'           @EINKJ
     C                   ENDIF
 
      ** Update 'previous' screen
 
     C                   MOVEL     NewNaPrim     PrvNaPrim
 
      ** Set function key status on PRIMARY screen
 
     C                   EXSR      SRSfKeys
 
      ** If action code, or Non-A/C reference were NOT OK
      ** blank out action code so that the input cannot proceed
 
     C     OkActn        IFEQ      'N'
     C     OkNaho        OREQ      'N'
     C                   MOVEL     *BLANK        DDACTN
     C                   ENDIF
 
      ** WRITE/Read DISPLAY SCREEN - Primary Details
 
     C                   CALLB     'SDNAHL2DP'
      **                ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
      ** INPUTS :
      ** Return code
      ** Non-A/C  (In Screen Format - Primary)
      ** Fields in error
      ** Errors
      ** Warnings
      ** Enabled Key & Detail Fields
      ** Enabled Function Keys
      ** KG = COMMAND KEY 07 = Read Previous
      ** KH = COMMAND KEY 08 = Read Next
      ** KJ = COMMAND KEY 10 = Confirm Delete
 
     C                   PARM      *BLANK        RetCodeOut
     C                   PARM                    NewNaPrim
     C                   PARM                    OkNaPrim
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
     C                   PARM      'N'           @EKYFD
     C                   PARM                    @EDTFD
     C                   PARM      'N'           @EINKG
     C                   PARM                    @EINKJ
     C                   PARM                    @EINKX                                       CGL132
 
      ** OUTPUTS :
      ** Function Keys
      ** Write screen with no read indicator
 
     C                   PARM      *Off          @INKC
     C                   PARM      *Off          @INKG
     C                   PARM      *Off          @INKH
     C                   PARM      *Off          @INKJ
     C                   PARM      *Off          @INKL
     C                   PARM      *Off          @INKX                                        CGL132
     C                   PARM      'N'           WriteOnly
 
      ** Reset Errors ...
 
     C                   MOVE      *ALL'Y'       OkNaPrim
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIdArr
     C                   MOVEL     *BLANK        MsgDtaArr
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
 
      ** F3 - End Program
 
     C     @INKC         Caseq     *On           SREndP
 
      ** F12 - Cancel on Primary Screen
 
     C     @INKL         Caseq     *On           SRCanC@P
 
      ** Validate input to Primary screen
 
     C                   Cas                     SRVal@P
     C                   Endcs
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** SRVal@P  - VALIDATE INPUT TO PRIMARY DETAILS SCREEN
      *****************************************************************
     C     SRVal@P       BEGSR
 
      ** Retrieve Non-A/C Holder details
 
     C                   MOVEL     '      '      @@MODE
     C                   EXSR      SRRtvNah
 
      ** If action code, or Non-A/C  reference are NOT OK
      ** Re-output screen with error messages on it
 
     C     OkActn        IFEQ      'N'
     C     OkNaho        OREQ      'N'
     C                   GOTO      EndVAL@P
     C                   ENDIF
 
      ** If Delete
 
     C     DDACTN        IFEQ      'D'
 
      ** If CK/10 Taken, Go onto Updates
 
     C     @EINKJ        IFEQ      'Y'
     C                   MOVEL     'U'           @SCRN
     C                   ENDIF
     C                   GOTO      EndVAL@P
     C                   ENDIF
 
      ** Prior to validation, initialize error indicators as 'OK'
      ** and clear Non-A/C  in File Format
 
     C                   Z-ADD     *ZERO         Idx
     C                   Z-ADD     *ZERO         WIdx_PVAL
     C                   Z-ADD     *ZERO         PrvN_Warn
     C                   MOVE      *ALL'Y'       OkNaPrim
     C                   CLEAR                   NwNaFilFmt
 
      ** Validate Primary Non-A/C  details
 
     C                   CALLB     'SDNAHL2VL'
      **                ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
      ** INPUTS :
      ** Response mode
      ** Non-A/C  Primary Details
      ** Non-A/C  Extra Data file data
 
     C                   PARM                    RespMode
     C                   PARM                    NewNaPrim
     C                   PARM                    ExtData
 
      ** OUTPUTS :
      ** Non-A/C  Primary Details OK inds
      ** Error fields/message IDs/message data (arrays) from/to caller
      ** Array index (3P0) from/to caller
      ** Warning fields/message IDs/message data (arrays) from/to caller
      ** Array index (3P0) from/to caller
      ** Valid Non-A/C  layout (DS) from/to caller
 
     C                   PARM                    OkNaPrim
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    Idx
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    WIdx_PVAL
     C                   PARM                    NwNaFilFmt
 
      ** If errors returned
 
     C     Idx           IFNE      0
     C                   GOTO      EndVAL@P
     C                   ENDIF
 
      ** If the screen has changed in the course of the validation
      ** or if there are warnings which have not been displayed
      ** re-display the screen
 
     C     NewNaPrim     IFNE      PrvNaPrim
     C     WIdx_PVAL     ORNE      PrvN_Warn
     C                   GOTO      EndVAL@P
     C                   ENDIF
 
      ** Clear any warning messages
 
     C                   MOVE      *ALL'Y'       OkNaPrim
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
 
     C                   IF        CGL132 = 'Y'                                               CGL132
     C                   MOVEL     'G'           @SCRN                                        CGL132
     C                   ELSE                                                                 CGL132
     C                   MOVEL     'U'           @SCRN
     C                   ENDIF                                                                CGL132
 
     C     EndVAL@P      ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** SRRtvNah - Retrieve Non-A/C
      *****************************************************************
     C     SRRtvNah      BEGSR
 
      ** Retrieve Non-A/C
 
     C                   CALLB     'SDNAHLRTV'
      **                 ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
      ** INPUTS :
      ** Return code
      ** Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      ** MODE = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
      ** Response mode
      ** Action Code
      ** Front Office Transaction ID
      ** (Midas) Non-A/C  Reference
 
     C                   PARM      *BLANK        RetCodeOut
     C                   PARM                    @@MODE
     C                   PARM      'S'           @@RSMD
     C                   PARM      @ACSEL        DDACTN
     C                   PARM                    DDFRNT
     C                   PARM                    DDNAHO
     C                   PARM                    @In36
 
      ** OUTPUTS :
      ** (Current) Non-A/C  in file format
      ** OK - Action code
      ** OK - Non-A/C  Reference
      ** Error fields/message IDs/message data (arrays) from/to caller
      ** Array index (3P0) from/to caller
 
     C                   PARM                    CrNaFilFmt
     C                   PARM                    CrFaFilFmt                                   CGL132
     C                   PARM                    CrFoFilFmt                                   CGL132
     C                   PARM      *BLANK        OkActn
     C                   PARM      *BLANK        OkNaho
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
     C                   PARM      *ZERO         Idx
 
     C     EndRTVNAH     ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** SRCvtNah - Put a Non-A/C on the secondary screen
      *****************************************************************
     C     SRCvtNah      BEGSR
 
      ** Call program to fill screen fields with data
 
     C                   CALLB     'SDNAHLCVT'
      **                 ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
      ** INPUTS :
      ** Return Code
      ** Non-A/C  in file format
 
     C                   PARM      *BLANK        RetCodeOut
     C                   PARM                    CrNaFilFmt
     C                   PARM                    CrFaFilFmt                                   CGL132
     C                   PARM                    CrFoFilFmt                                   CGL132
 
      ** OUTPUTS
      ** Non-A/C  - screen formats
 
     C                   PARM                    NewNaPrim
     C                   PARM                    NewCuFATC                                    CGL132
     C                   PARM                    NewCuFOTH                                    CGL132
 
      ** Update 'Current' Non-A/C  with Non-A/C  in Screen Format
 
     C                   MOVEL     NewNaPrim     CurNaPrim
     C                   IF        CGL132 = 'Y'                                               CGL132
     C                   MOVEL     NewCuFATC     CurCuFATC                                    CGL132
     C                   MOVEL     NewCuFOTH     CurCuFOTH                                    CGL132
     C                   ENDIF                                                                CGL132
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** SRCanC@P - Cancel on Primary Details Screen
      *****************************************************************
     C     SrCanC@P      BEGSR
 
      ** If records are still to be Read from the subfile, Read them
 
     C     @RDNB         IFEQ      'Y'
     C                   MOVEL     'R'           @SCRN
     C                   ELSE
 
      ** ELSE, Return to the Browse Screen
 
     C                   MOVEL     'I'           @SCRN
     C                   ENDIF
 
     C                   ENDSR
                                                                                              CGL132
      *****************************************************************                       CGL132
      /EJECT                                                                                  CGL132
      *****************************************************************                       CGL132
      * SCRN@G - Process FATCA details screen 1                                               CGL132
      *****************************************************************                       CGL132
                                                                                              CGL132
     C     SCRN@G        BEGSR                                                                CGL132
                                                                                              CGL132
      ** Set function key status on screen                                                    CGL132
     C                   EXSR      SrSFKEYS                                                   CGL132
                                                                                              CGL132
      ** Write/read display - FATCA details screen 5                                          CGL132
     C                   CALLB     'SDFTNH5DP'                                                CGL132
                                                                                              CGL132
      ** INPUTS :                                                                             CGL132
      ** Return code                                                                          CGL132
      ** FATCA Customer details (In Screen format - Primary )                                 CGL132
      ** Fields in error                                                                      CGL132
      ** Errors                                                                               CGL132
      ** Warnings                                                                             CGL132
      ** Enabled Key & Detail fields                                                          CGL132
      ** Enabled Function keys                                                                CGL132
                                                                                              CGL132
     C                   PARM      *BLANK        RetCodeOut                                   CGL132
     C                   PARM                    NewCuFATC                                    CGL132
     C                   PARM                    NewCuFOTH                                    CGL132
     C                   PARM                    NewNaPrim                                    CGL132
     C                   PARM                    OkFATCAdet                                   CGL132
     C                   PARM                    FldNameArr                                   CGL132
     C                   PARM                    MsgIdArr                                     CGL132
     C                   PARM                    MsgDtaArr                                    CGL132
     C                   PARM                    WFldNamArr                                   CGL132
     C                   PARM                    WMsgIdArr                                    CGL132
     C                   PARM                    WMsgDtaArr                                   CGL132
                                                                                              CGL132
      ** OUTPUTS :                                                                            CGL132
      ** Function Keys                                                                        CGL132
      ** Write screen with no read indicator                                                  CGL132
                                                                                              CGL132
     C                   PARM      *Off          @INKC                                        CGL132
     C                   PARM      *Off          @INKR                                        CGL132
     C                   PARM      *Off          @INKS                                        CGL132
     C                   PARM      *Off          @INKT                                        CGL132
     C                   PARM      'N'           WriteOnly                                    CGL132
                                                                                              CGL132
      ** Reset errors                                                                         CGL132
     C                   MOVE      *ALL'Y'       OkFATCAdet                                   CGL132
     C                   MOVEL     *BLANK        FldNameArr                                   CGL132
     C                   MOVEL     *BLANK        MsgIdArr                                     CGL132
     C                   MOVEL     *BLANK        MsgDtaArr                                    CGL132
     C                   MOVEL     *BLANK        WFldNamArr                                   CGL132
     C                   MOVEL     *BLANK        WMsgIdArr                                    CGL132
     C                   MOVEL     *BLANK        WMsgDtaArr                                   CGL132
                                                                                              CGL132
     C                   IF        @INKC = '1'                                                CGL132
     C                   EXSR      SREndP                                                     CGL132
     C                   ENDIF                                                                CGL132
     C                   IF        @INKL = '1'                                                CGL132
     C                   EXSR      CANC@G                                                     CGL132
     C                   ENDIF                                                                CGL132
     C                   IF        @INKR = '1'                                                CGL132
     C                   EXSR      SCRN@C                                                     CGL132
     C                   ENDIF                                                                CGL132
     C                   IF        @INKS = '1'                                                CGL132
     C                   EXSR      SRUSHC                                                     CGL132
     C                   ENDIF                                                                CGL132
     C                   IF        @INKT = '1'                                                CGL132
     C                   EXSR      SCRN@O                                                     CGL132
     C                   ENDIF                                                                CGL132
     C                   IF        @INKC = '0' AND                                            CGL132
     C                             @INKL = '0' AND                                            CGL132
     C                             @INKR = '0' AND                                            CGL132
     C                             @INKS = '0' AND                                            CGL132
     C                             @INKT = '0'                                                CGL132
     C                   EXSR      VAL@G                                                      CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
     C                   ENDSR                                                                CGL132
                                                                                              CGL132
                                                                                              CGL132
      *****************************************************************                       CGL132
      /EJECT                                                                                  CGL132
      *****************************************************************                       CGL132
      * SCRN@C - Process FATCA details screen 2                                               CGL132
      *****************************************************************                       CGL132
                                                                                              CGL132
     C     SCRN@C        BEGSR                                                                CGL132
                                                                                              CGL132
      ** Set function key status on screen                                                    CGL132
     C                   EXSR      SrSFKEYS                                                   CGL132
                                                                                              CGL132
      ** Write/read display - FATCA details screen 2                                          CGL132
     C                   CALLB     'SDFTNH1DP'                                                CGL132
                                                                                              CGL132
      ** INPUTS :                                                                             CGL132
      ** Return code                                                                          CGL132
      ** FATCA Customer details (In Screen format - Primary )                                 CGL132
      ** Fields in error                                                                      CGL132
      ** Errors                                                                               CGL132
      ** Warnings                                                                             CGL132
      ** Enabled Key & Detail fields                                                          CGL132
      ** Enabled Function keys                                                                CGL132
                                                                                              CGL132
     C                   PARM      *BLANK        RetCodeOut                                   CGL132
     C                   PARM                    NewCuFATC                                    CGL132
     C                   PARM                    NewNaPrim                                    CGL132
     C                   PARM                    OkFATCAdet                                   CGL132
     C                   PARM                    FldNameArr                                   CGL132
     C                   PARM                    MsgIdArr                                     CGL132
     C                   PARM                    MsgDtaArr                                    CGL132
     C                   PARM                    WFldNamArr                                   CGL132
     C                   PARM                    WMsgIdArr                                    CGL132
     C                   PARM                    WMsgDtaArr                                   CGL132
                                                                                              CGL132
      ** OUTPUTS :                                                                            CGL132
      ** Function Keys                                                                        CGL132
      ** Write screen with no read indicator                                                  CGL132
                                                                                              CGL132
     C                   PARM      *Off          @INKC                                        CGL132
     C                   PARM      *Off          @INKL                                        CGL132
     C                   PARM      *Off          @INKQ                                        CGL132
     C                   PARM      *Off          @INKS                                        CGL132
     C                   PARM      *Off          @INKT                                        CGL132
     C                   PARM      'N'           WriteOnly                                    CGL132
                                                                                              CGL132
      ** Reset errors                                                                         CGL132
     C                   MOVE      *ALL'Y'       OkFATCAdet                                   CGL132
     C                   MOVEL     *BLANK        FldNameArr                                   CGL132
     C                   MOVEL     *BLANK        MsgIdArr                                     CGL132
     C                   MOVEL     *BLANK        MsgDtaArr                                    CGL132
     C                   MOVEL     *BLANK        WFldNamArr                                   CGL132
     C                   MOVEL     *BLANK        WMsgIdArr                                    CGL132
     C                   MOVEL     *BLANK        WMsgDtaArr                                   CGL132
                                                                                              CGL132
     C                   IF        @INKC = '1'                                                CGL132
     C                   EXSR      SREndP                                                     CGL132
     C                   ENDIF                                                                CGL132
     C                   IF        @INKL = '1'                                                CGL132
     C                   EXSR      CANC@C                                                     CGL132
     C                   ENDIF                                                                CGL132
     C                   IF        @INKQ = '1'                                                CGL132
     C                   EXSR      SCRNGG                                                     CGL132
     C                   ENDIF                                                                CGL132
     C                   IF        @INKS = '1'                                                CGL132
     C                   EXSR      SCRNGH                                                     CGL132
     C                   ENDIF                                                                CGL132
     C                   IF        @INKT = '1'                                                CGL132
     C                   EXSR      SCRNGE                                                     CGL132
     C                   ENDIF                                                                CGL132
     C                   IF        @INKC = '0' AND                                            CGL132
     C                             @INKL = '0' AND                                            CGL132
     C                             @INKQ = '0' AND                                            CGL132
     C                             @INKS = '0' AND                                            CGL132
     C                             @INKT = '0'                                                CGL132
     C                   EXSR      VAL@C                                                      CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
      ** On F23, go to Further Details, if there                                              CGL132
                                                                                              CGL132
     C                   ENDSR                                                                CGL132
      *****************************************************************                       CGL132
      /EJECT                                                                                  CGL132
      *****************************************************************                       CGL132
      * SCRN@H - Process FATCA details screen 3                                               CGL132
      *****************************************************************                       CGL132
                                                                                              CGL132
     C     SCRN@H        BEGSR                                                                CGL132
                                                                                              CGL132
      ** Set function key status on screen                                                    CGL132
     C                   EXSR      SrSFKEYS                                                   CGL132
                                                                                              CGL132
      ** Write/read display - FATCA details screen 3                                          CGL132
     C                   CALLB     'SDFTNH2DP'                                                CGL132
                                                                                              CGL132
      ** INPUTS :                                                                             CGL132
      ** Return code                                                                          CGL132
      ** FATCA Customer details (In Screen format - Primary )                                 CGL132
      ** Fields in error                                                                      CGL132
      ** Errors                                                                               CGL132
      ** Warnings                                                                             CGL132
      ** Enabled Key & Detail fields                                                          CGL132
      ** Enabled Function keys                                                                CGL132
                                                                                              CGL132
     C                   PARM      *BLANK        RetCodeOut                                   CGL132
     C                   PARM                    NewCuFATC                                    CGL132
     C                   PARM                    NewNaPrim                                    CGL132
     C                   PARM                    OkFATCAdet                                   CGL132
     C                   PARM                    FldNameArr                                   CGL132
     C                   PARM                    MsgIdArr                                     CGL132
     C                   PARM                    MsgDtaArr                                    CGL132
     C                   PARM                    WFldNamArr                                   CGL132
     C                   PARM                    WMsgIdArr                                    CGL132
     C                   PARM                    WMsgDtaArr                                   CGL132
                                                                                              CGL132
      ** OUTPUTS :                                                                            CGL132
      ** Function Keys                                                                        CGL132
      ** Write screen with no read indicator                                                  CGL132
                                                                                              CGL132
     C                   PARM      *Off          @INKC                                        CGL132
     C                   PARM      *Off          @INKL                                        CGL132
     C                   PARM      *Off          @INKQ                                        CGL132
     C                   PARM      *Off          @INKS                                        CGL132
     C                   PARM      *Off          @INKT                                        CGL132
     C                   PARM      'N'           WriteOnly                                    CGL132
                                                                                              CGL132
      ** Reset errors                                                                         CGL132
     C                   MOVE      *ALL'Y'       OkFATCAdet                                   CGL132
     C                   MOVEL     *BLANK        FldNameArr                                   CGL132
     C                   MOVEL     *BLANK        MsgIdArr                                     CGL132
     C                   MOVEL     *BLANK        MsgDtaArr                                    CGL132
     C                   MOVEL     *BLANK        WFldNamArr                                   CGL132
     C                   MOVEL     *BLANK        WMsgIdArr                                    CGL132
     C                   MOVEL     *BLANK        WMsgDtaArr                                   CGL132
                                                                                              CGL132
     C                   IF        @INKC = '1'                                                CGL132
     C                   EXSR      SREndP                                                     CGL132
     C                   ENDIF                                                                CGL132
     C                   IF        @INKL = '1'                                                CGL132
     C                   EXSR      CANC@H                                                     CGL132
     C                   ENDIF                                                                CGL132
     C                   IF        @INKQ = '1'                                                CGL132
     C                   EXSR      SCRNGG                                                     CGL132
     C                   ENDIF                                                                CGL132
     C                   IF        @INKS = '1'                                                CGL132
     C                   EXSR      SCRNGH                                                     CGL132
     C                   ENDIF                                                                CGL132
     C                   IF        @INKT = '1'                                                CGL132
     C                   EXSR      SCRNGE                                                     CGL132
     C                   ENDIF                                                                CGL132
     C                   IF        @INKC = '0' AND                                            CGL132
     C                             @INKL = '0' AND                                            CGL132
     C                             @INKQ = '0' AND                                            CGL132
     C                             @INKS = '0' AND                                            CGL132
     C                             @INKT = '0'                                                CGL132
     C                   EXSR      VAL@H                                                      CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
      ** On F23, go to Further Details, if there                                              CGL132
                                                                                              CGL132
     C                   ENDSR                                                                CGL132
                                                                                              CGL132
      *****************************************************************                       CGL132
      /EJECT                                                                                  CGL132
      *****************************************************************                       CGL132
      * SCRN@L - Process FATCA details screen 4                                               CGL132
      *****************************************************************                       CGL132
                                                                                              CGL132
     C     SCRN@L        BEGSR                                                                CGL132
                                                                                              CGL132
      ** Set function key status on screen                                                    CGL132
     C                   EXSR      SrSFKEYS                                                   CGL132
                                                                                              CGL132
      ** Write/read display - FATCA details screen 3                                          CGL132
     C                   CALLB     'SDFTNH3DP'                                                CGL132
                                                                                              CGL132
      ** INPUTS :                                                                             CGL132
      ** Return code                                                                          CGL132
      ** FATCA Customer details (In Screen format - Primary )                                 CGL132
      ** Fields in error                                                                      CGL132
      ** Errors                                                                               CGL132
      ** Warnings                                                                             CGL132
      ** Enabled Key & Detail fields                                                          CGL132
      ** Enabled Function keys                                                                CGL132
                                                                                              CGL132
     C                   PARM      *BLANK        RetCodeOut                                   CGL132
     C                   PARM                    NewCuFATC                                    CGL132
     C                   PARM                    NewNaPrim                                    CGL132
     C                   PARM                    OkFATCAdet                                   CGL132
     C                   PARM                    FldNameArr                                   CGL132
     C                   PARM                    MsgIdArr                                     CGL132
     C                   PARM                    MsgDtaArr                                    CGL132
     C                   PARM                    WFldNamArr                                   CGL132
     C                   PARM                    WMsgIdArr                                    CGL132
     C                   PARM                    WMsgDtaArr                                   CGL132
                                                                                              CGL132
      ** OUTPUTS :                                                                            CGL132
      ** Function Keys                                                                        CGL132
      ** Write screen with no read indicator                                                  CGL132
                                                                                              CGL132
     C                   PARM      *Off          @INKC                                        CGL132
     C                   PARM      *Off          @INKL                                        CGL132
     C                   PARM      *Off          @INKQ                                        CGL132
     C                   PARM      *Off          @INKS                                        CGL132
     C                   PARM      *Off          @INKT                                        CGL132
     C                   PARM      'N'           WriteOnly                                    CGL132
                                                                                              CGL132
      ** Reset errors                                                                         CGL132
     C                   MOVE      *ALL'Y'       OkFATCAdet                                   CGL132
     C                   MOVEL     *BLANK        FldNameArr                                   CGL132
     C                   MOVEL     *BLANK        MsgIdArr                                     CGL132
     C                   MOVEL     *BLANK        MsgDtaArr                                    CGL132
     C                   MOVEL     *BLANK        WFldNamArr                                   CGL132
     C                   MOVEL     *BLANK        WMsgIdArr                                    CGL132
     C                   MOVEL     *BLANK        WMsgDtaArr                                   CGL132
                                                                                              CGL132
     C                   IF        @INKC = '1'                                                CGL132
     C                   EXSR      SREndP                                                     CGL132
     C                   ENDIF                                                                CGL132
     C                   IF        @INKL = '1'                                                CGL132
     C                   EXSR      CANC@L                                                     CGL132
     C                   ENDIF                                                                CGL132
     C                   IF        @INKQ = '1'                                                CGL132
     C                   EXSR      SCRNGG                                                     CGL132
     C                   ENDIF                                                                CGL132
     C                   IF        @INKS = '1'                                                CGL132
     C                   EXSR      SCRNGH                                                     CGL132
     C                   ENDIF                                                                CGL132
     C                   IF        @INKT = '1'                                                CGL132
     C                   EXSR      SCRNGE                                                     CGL132
     C                   ENDIF                                                                CGL132
     C                   IF        @INKC = '0' AND                                            CGL132
     C                             @INKL = '0' AND                                            CGL132
     C                             @INKQ = '0' AND                                            CGL132
     C                             @INKS = '0' AND                                            CGL132
     C                             @INKT = '0'                                                CGL132
     C                   EXSR      VAL@L                                                      CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
      ** On F23, go to Further Details, if there                                              CGL132
                                                                                              CGL132
     C                   ENDSR                                                                CGL132
                                                                                              CGL132
      *****************************************************************                       CGL132
      /EJECT                                                                                  CGL132
      *****************************************************************                       CGL132
      * SCRN@Y - Process FATCA details screen 4                                               CGL132
      *****************************************************************                       CGL132
                                                                                              CGL132
     C     SCRN@Y        BEGSR                                                                CGL132
                                                                                              CGL132
      ** Set function key status on screen                                                    CGL132
     C                   EXSR      SrSFKEYS                                                   CGL132
                                                                                              CGL132
      ** Write/read display - FATCA details screen 4                                          CGL132
     C                   CALLB     'SDFTNH4DP'                                                CGL132
                                                                                              CGL132
      ** INPUTS :                                                                             CGL132
      ** Return code                                                                          CGL132
      ** FATCA Customer details (In Screen format - Primary )                                 CGL132
      ** Fields in error                                                                      CGL132
      ** Errors                                                                               CGL132
      ** Warnings                                                                             CGL132
      ** Enabled Key & Detail fields                                                          CGL132
      ** Enabled Function keys                                                                CGL132
                                                                                              CGL132
     C                   PARM      *BLANK        RetCodeOut                                   CGL132
     C                   PARM                    NewCuFATC                                    CGL132
     C                   PARM                    NewNaPrim                                    CGL132
     C                   PARM                    OkFATCAdet                                   CGL132
     C                   PARM                    FldNameArr                                   CGL132
     C                   PARM                    MsgIdArr                                     CGL132
     C                   PARM                    MsgDtaArr                                    CGL132
     C                   PARM                    WFldNamArr                                   CGL132
     C                   PARM                    WMsgIdArr                                    CGL132
     C                   PARM                    WMsgDtaArr                                   CGL132
                                                                                              CGL132
      ** OUTPUTS :                                                                            CGL132
      ** Function Keys                                                                        CGL132
      ** Write screen with no read indicator                                                  CGL132
                                                                                              CGL132
     C                   PARM      *Off          @INKC                                        CGL132
     C                   PARM      *Off          @INKL                                        CGL132
     C                   PARM      *Off          @INKQ                                        CGL132
     C                   PARM      *Off          @INKS                                        CGL132
     C                   PARM      *Off          @INKT                                        CGL132
     C                   PARM      'N'           WriteOnly                                    CGL132
                                                                                              CGL132
      ** Reset errors                                                                         CGL132
     C                   MOVE      *ALL'Y'       OkFATCAdet                                   CGL132
     C                   MOVEL     *BLANK        FldNameArr                                   CGL132
     C                   MOVEL     *BLANK        MsgIdArr                                     CGL132
     C                   MOVEL     *BLANK        MsgDtaArr                                    CGL132
     C                   MOVEL     *BLANK        WFldNamArr                                   CGL132
     C                   MOVEL     *BLANK        WMsgIdArr                                    CGL132
     C                   MOVEL     *BLANK        WMsgDtaArr                                   CGL132
                                                                                              CGL132
     C                   IF        @INKC = '1'                                                CGL132
     C                   EXSR      SREndP                                                     CGL132
     C                   ENDIF                                                                CGL132
     C                   IF        @INKL = '1'                                                CGL132
     C                   EXSR      CANC@Y                                                     CGL132
     C                   ENDIF                                                                CGL132
     C                   IF        @INKQ = '1'                                                CGL132
     C                   EXSR      SCRNGG                                                     CGL132
     C                   ENDIF                                                                CGL132
     C                   IF        @INKS = '1'                                                CGL132
     C                   EXSR      SCRNGH                                                     CGL132
     C                   ENDIF                                                                CGL132
     C                   IF        @INKT = '1'                                                CGL132
     C                   EXSR      SCRNGE                                                     CGL132
     C                   ENDIF                                                                CGL132
     C                   IF        @INKC = '0' AND                                            CGL132
     C                             @INKL = '0' AND                                            CGL132
     C                             @INKQ = '0' AND                                            CGL132
     C                             @INKS = '0' AND                                            CGL132
     C                             @INKT = '0'                                                CGL132
     C                   EXSR      VAL@Y                                                      CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
      ** On F23, go to Further Details, if there                                              CGL132
                                                                                              CGL132
     C                   ENDSR                                                                CGL132
                                                                                              CGL132
      *****************************************************************                       CGL132
      /EJECT                                                                                  CGL132
      *****************************************************************                       CGL132
      * SCRN@O - Display Exception screen                                                     CGL132
      *****************************************************************                       CGL132
                                                                                              CGL132
     C     SCRN@O        BEGSR                                                                CGL132
                                                                                              CGL132
     C                   CALLB     'SDFTNHEDP'                                                CGL132
     C                   PARM      *BLANK        RetCodeOut                                   CGL132
     C                   PARM                    NewCuFATC                                    CGL132
     C                   PARM                    NewNaPrim                                    CGL132
     C                   PARM      *Off          @INKC                                        CGL132
     C                   PARM      *Off          @INKQ                                        CGL132
     C                   PARM      *Off          @INKR                                        CGL132
     C                   PARM      *Off          @INKS                                        CGL132
                                                                                              CGL132
     C                   IF        @INKC = '1'                                                CGL132
     C                   EXSR      SREndP                                                     CGL132
     C                   ENDIF                                                                CGL132
     C                   IF        @INKQ = '1'                                                CGL132
     C                   EXSR      SCRNGG                                                     CGL132
     C                   ENDIF                                                                CGL132
     C                   IF        @INKR = '1'                                                CGL132
     C                   EXSR      SCRN@C                                                     CGL132
     C                   ENDIF                                                                CGL132
     C                   IF        @INKS = '1'                                                CGL132
     C                   EXSR      SCRNGH                                                     CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
     C                   ENDSR                                                                CGL132
                                                                                              CGL132
      *****************************************************************                       CGL132
      /EJECT                                                                                  CGL132
      *****************************************************************                       CGL132
      * SRUSHC - US Indicia Comment History                                                   CGL132
      *****************************************************************                       CGL132
                                                                                              CGL132
     C     SRUSHC        BEGSR                                                                CGL132
                                                                                              CGL132
     C                   CALLB     'SDFTNH3BW'                                                CGL132
     C                   PARM      *BLANK        RetCodeOut                                   CGL132
     C                   PARM                    NwNaFilFmt                                   CGL132
     C                   PARM      '0'           @INKC                                        CGL132
     C                   PARM      '0'           @INKQ                                        CGL132
     C                   PARM      '0'           @INKR                                        CGL132
     C                   PARM      '0'           @INKT                                        CGL132
                                                                                              CGL132
     C                   IF        @INKC = '1'                                                CGL132
     C                   EXSR      SREndP                                                     CGL132
     C                   ENDIF                                                                CGL132
     C                   IF        @INKQ = '1'                                                CGL132
     C                   EXSR      SCRNGG                                                     CGL132
     C                   ENDIF                                                                CGL132
     C                   IF        @INKR = '1'                                                CGL132
     C                   EXSR      SCRN@C                                                     CGL132
     C                   ENDIF                                                                CGL132
     C                   IF        @INKT = '1'                                                CGL132
     C                   EXSR      SCRNGE                                                     CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
     C                   ENDSR                                                                CGL132
                                                                                              CGL132
      *****************************************************************                       CGL132
      /EJECT                                                                                  CGL132
      *****************************************************************                       CGL132
      * VAL@G - Validate FATCA details 1                                                      CGL132
      *****************************************************************                       CGL132
                                                                                              CGL132
     C     VAL@G         BEGSR                                                                CGL132
                                                                                              CGL132
     C                   Z-ADD     *ZERO         Idx                                          CGL132
     C                   Z-ADD     *ZERO         WIdx_GVAL                                    CGL132
     C                   MOVE      *ALL'Y'       OkFATCAdet                                   CGL132
                                                                                              CGL132
     C                   MOVEL     NewCuFATC     PrvCuFATC                                    CGL132
     C                   Z-ADD     WIdx_GVAL     PrvG_Warn         3 0                        CGL132
                                                                                              CGL132
     C                   CALLB     'SDFTNH5VL'                                                CGL132
                                                                                              CGL132
      ** INPUTS :                                                                             CGL132
      ** Response mode                                                                        CGL132
      ** FATCA customer details                                                               CGL132
      ** FATCA customer details (old)                                                         CGL132
                                                                                              CGL132
     C                   PARM                    RespMode                                     CGL132
     C                   PARM                    NewCuFATC                                    CGL132
     C                   PARM                    CurCuFATC                                    CGL132
     C                   PARM                    CrFoFilFmt                                   CGL132
     C                   PARM                    NwNaFilFmt                                   CGL132
     C                   PARM      DDCRDT        P_CRDT            8                        MD026550
                                                                                              CGL132
      ** OUTPUTS :                                                                            CGL132
      ** FATCA Customer Details OK inds                                                       CGL132
      ** Error fields/message IDs/message data (arrays) from/to caller                        CGL132
      ** Warning fields/message IDs/message data (arrays) from/to caller                      CGL132
      ** Valid FATCA Customer layout (DS) from/to caller                                      CGL132
                                                                                              CGL132
     C                   PARM                    OkFATCAdet                                   CGL132
                                                                                              CGL132
      * Error fields/message IDs/message data (arrays) from/to caller                         CGL132
     C                   PARM                    FldNameArr                                   CGL132
     C                   PARM                    MsgIDArr                                     CGL132
     C                   PARM                    MsgDtaArr                                    CGL132
                                                                                              CGL132
      ** Array index (3P0) from/to caller                                                     CGL132
     C                   PARM                    Idx                                          CGL132
                                                                                              CGL132
      ** Warning fields/message IDs/message data (arrays) from/to caller                      CGL132
     C                   PARM                    WFldNamArr                                   CGL132
     C                   PARM                    WMsgIDArr                                    CGL132
     C                   PARM                    WMsgDtaArr                                   CGL132
                                                                                              CGL132
      ** Array index (3P0) from/to caller                                                     CGL132
     C                   PARM                    WIdx_GVAL                                    CGL132
                                                                                              CGL132
      ** Valid FATCA file layout (DS) to/from caller                                          CGL132
     C                   PARM                    NwFaFilFmt                                   CGL132
                                                                                              CGL132
      ** If there are errors, redisplay FATCA details screen                                  CGL132
                                                                                              CGL132
     C     Idx           IFNE      0                                                          CGL132
     C                   GOTO      EndVAL@G                                                   CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
      ** If the screen has changed in the course of the validation                            CGL132
      ** or if there are warnings which have not been displayed                               CGL132
      ** re-display the screen                                                                CGL132
                                                                                              CGL132
     C     NewCuFATC     IFNE      PrvCuFATC                                                  CGL132
     C     WIdx_GVAL     ORNE      PrvG_Warn                                                  CGL132
     C                   GOTO      EndVAL@G                                                   CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
      ** Clear any warning messages                                                           CGL132
                                                                                              CGL132
     C                   MOVE      *ALL'Y'       OkFATCAdet                                   CGL132
     C                   MOVEL     *BLANK        WFldNamArr                                   CGL132
     C                   MOVEL     *BLANK        WMsgIdArr                                    CGL132
     C                   MOVEL     *BLANK        WMsgDtaArr                                   CGL132
                                                                                              CGL132
      ** Validate US indicia and return error if found                                        CGL132
                                                                                              CGL132
     C                   Z-ADD     *ZERO         WIdx_CVAL                                    CGL132
     C                   Z-ADD     *ZERO         WIdx_HVAL                                    CGL132
     C                   Z-ADD     *ZERO         WIdx_LVAL                                    CGL132
                                                                                              CGL132
     C                   CALLB     'SDFTNH1VL'                                                CGL132
                                                                                              CGL132
      ** INPUTS :                                                                             CGL132
      ** Response mode                                                                        CGL132
      ** FATCA customer details                                                               CGL132
      ** FATCA customer details (old)                                                         CGL132
                                                                                              CGL132
     C                   PARM                    RespMode                                     CGL132
     C                   PARM                    NewCuFATC                                    CGL132
     C                   PARM                    CurCuFATC                                    CGL132
                                                                                              CGL132
      ** OUTPUTS :                                                                            CGL132
      ** FATCA Customer Details OK inds                                                       CGL132
      ** Error fields/message IDs/message data (arrays) from/to caller                        CGL132
      ** Warning fields/message IDs/message data (arrays) from/to caller                      CGL132
      ** Valid FATCA Customer layout (DS) from/to caller                                      CGL132
                                                                                              CGL132
     C                   PARM                    OkFATCAdet                                   CGL132
                                                                                              CGL132
      * Error fields/message IDs/message data (arrays) from/to caller                         CGL132
     C                   PARM                    FldNameArr                                   CGL132
     C                   PARM                    MsgIDArr                                     CGL132
     C                   PARM                    MsgDtaArr                                    CGL132
                                                                                              CGL132
      ** Array index (3P0) from/to caller                                                     CGL132
     C                   PARM                    Idx                                          CGL132
                                                                                              CGL132
      ** Warning fields/message IDs/message data (arrays) from/to caller                      CGL132
     C                   PARM                    WFldNamArr                                   CGL132
     C                   PARM                    WMsgIDArr                                    CGL132
     C                   PARM                    WMsgDtaArr                                   CGL132
                                                                                              CGL132
      ** Array index (3P0) from/to caller                                                     CGL132
     C                   PARM                    WIdx_CVAL                                    CGL132
                                                                                              CGL132
      ** Valid FATCA file layout (DS) to/from caller                                          CGL132
     C                   PARM                    NwFaFilFmt                                   CGL132
                                                                                              CGL132
      ** If there are errors, redisplay FATCA details screen                                  CGL132
                                                                                              CGL132
     C     Idx           IFNE      0                                                          CGL132
     C                   Z-ADD     1             E                 3 0                        CGL132
     C     *BLANK        LOOKUP    FldNameArr(E)                          99                  CGL132
     C                   MOVEL     '*ANY'        FldNameArr(E)                                CGL132
     C                   MOVEL     'USS0397'     MsgIdArr(E)                                  CGL132
     C                   GOTO      EndVAL@G                                                   CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
     C                   CALLB     'SDFTNH2VL'                                                CGL132
                                                                                              CGL132
      ** INPUTS :                                                                             CGL132
      ** Response mode                                                                        CGL132
      ** FATCA customer details                                                               CGL132
      ** FATCA customer details (old)                                                         CGL132
                                                                                              CGL132
     C                   PARM                    RespMode                                     CGL132
     C                   PARM                    NewCuFATC                                    CGL132
     C                   PARM                    CurCuFATC                                    CGL132
                                                                                              CGL132
      ** OUTPUTS :                                                                            CGL132
      ** FATCA Customer Details OK inds                                                       CGL132
      ** Error fields/message IDs/message data (arrays) from/to caller                        CGL132
      ** Warning fields/message IDs/message data (arrays) from/to caller                      CGL132
      ** Valid FATCA Customer layout (DS) from/to caller                                      CGL132
                                                                                              CGL132
     C                   PARM                    OkFATCAdet                                   CGL132
                                                                                              CGL132
      * Error fields/message IDs/message data (arrays) from/to caller                         CGL132
     C                   PARM                    FldNameArr                                   CGL132
     C                   PARM                    MsgIDArr                                     CGL132
     C                   PARM                    MsgDtaArr                                    CGL132
                                                                                              CGL132
      ** Array index (3P0) from/to caller                                                     CGL132
     C                   PARM                    Idx                                          CGL132
                                                                                              CGL132
      ** Warning fields/message IDs/message data (arrays) from/to caller                      CGL132
     C                   PARM                    WFldNamArr                                   CGL132
     C                   PARM                    WMsgIDArr                                    CGL132
     C                   PARM                    WMsgDtaArr                                   CGL132
                                                                                              CGL132
      ** Array index (3P0) from/to caller                                                     CGL132
     C                   PARM                    WIdx_HVAL                                    CGL132
                                                                                              CGL132
      ** Valid FATCA file layout (DS) to/from caller                                          CGL132
     C                   PARM                    NwFaFilFmt                                   CGL132
                                                                                              CGL132
      ** If there are errors, redisplay FATCA details screen                                  CGL132
                                                                                              CGL132
     C     Idx           IFNE      0                                                          CGL132
     C                   Z-ADD     1             E                                            CGL132
     C     *BLANK        LOOKUP    FldNameArr(E)                          99                  CGL132
     C                   MOVEL     '*ANY'        FldNameArr(E)                                CGL132
     C                   MOVEL     'USS0397'     MsgIdArr(E)                                  CGL132
     C                   GOTO      EndVAL@G                                                   CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
     C                   CALLB     'SDFTNH3VL'                                                CGL132
                                                                                              CGL132
      ** INPUTS :                                                                             CGL132
      ** Response mode                                                                        CGL132
      ** FATCA customer details                                                               CGL132
      ** FATCA customer details (old)                                                         CGL132
                                                                                              CGL132
     C                   PARM                    RespMode                                     CGL132
     C                   PARM                    NewCuFATC                                    CGL132
     C                   PARM                    CurCuFATC                                    CGL132
                                                                                              CGL132
      ** OUTPUTS :                                                                            CGL132
      ** FATCA Customer Details OK inds                                                       CGL132
      ** Error fields/message IDs/message data (arrays) from/to caller                        CGL132
      ** Warning fields/message IDs/message data (arrays) from/to caller                      CGL132
      ** Valid FATCA Customer layout (DS) from/to caller                                      CGL132
                                                                                              CGL132
     C                   PARM                    OkFATCAdet                                   CGL132
                                                                                              CGL132
      * Error fields/message IDs/message data (arrays) from/to caller                         CGL132
     C                   PARM                    FldNameArr                                   CGL132
     C                   PARM                    MsgIDArr                                     CGL132
     C                   PARM                    MsgDtaArr                                    CGL132
                                                                                              CGL132
      ** Array index (3P0) from/to caller                                                     CGL132
     C                   PARM                    Idx                                          CGL132
                                                                                              CGL132
      ** Warning fields/message IDs/message data (arrays) from/to caller                      CGL132
     C                   PARM                    WFldNamArr                                   CGL132
     C                   PARM                    WMsgIDArr                                    CGL132
     C                   PARM                    WMsgDtaArr                                   CGL132
                                                                                              CGL132
      ** Array index (3P0) from/to caller                                                     CGL132
     C                   PARM                    WIdx_LVAL                                    CGL132
                                                                                              CGL132
      ** Valid FATCA file layout (DS) to/from caller                                          CGL132
     C                   PARM                    NwFaFilFmt                                   CGL132
                                                                                              CGL132
      ** If there are errors, redisplay FATCA details screen                                  CGL132
                                                                                              CGL132
     C     Idx           IFNE      0                                                          CGL132
     C                   Z-ADD     1             E                                            CGL132
     C     *BLANK        LOOKUP    FldNameArr(E)                          99                  CGL132
     C                   MOVEL     '*ANY'        FldNameArr(E)                                CGL132
     C                   MOVEL     'USS0397'     MsgIdArr(E)                                  CGL132
     C                   GOTO      EndVAL@G                                                   CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
     C                   CALLB     'SDFTNH4VL'                                                CGL132
                                                                                              CGL132
      ** INPUTS :                                                                             CGL132
      ** Response mode                                                                        CGL132
      ** FATCA customer details                                                               CGL132
      ** FATCA customer details (old)                                                         CGL132
                                                                                              CGL132
     C                   PARM                    RespMode                                     CGL132
     C                   PARM                    NewCuFATC                                    CGL132
     C                   PARM                    CurCuFATC                                    CGL132
                                                                                              CGL132
      ** OUTPUTS :                                                                            CGL132
      ** FATCA Customer Details OK inds                                                       CGL132
      ** Error fields/message IDs/message data (arrays) from/to caller                        CGL132
      ** Warning fields/message IDs/message data (arrays) from/to caller                      CGL132
      ** Valid FATCA Customer layout (DS) from/to caller                                      CGL132
                                                                                              CGL132
     C                   PARM                    OkFATCAdet                                   CGL132
                                                                                              CGL132
      * Error fields/message IDs/message data (arrays) from/to caller                         CGL132
     C                   PARM                    FldNameArr                                   CGL132
     C                   PARM                    MsgIDArr                                     CGL132
     C                   PARM                    MsgDtaArr                                    CGL132
                                                                                              CGL132
      ** Array index (3P0) from/to caller                                                     CGL132
     C                   PARM                    Idx                                          CGL132
                                                                                              CGL132
      ** Warning fields/message IDs/message data (arrays) from/to caller                      CGL132
     C                   PARM                    WFldNamArr                                   CGL132
     C                   PARM                    WMsgIDArr                                    CGL132
     C                   PARM                    WMsgDtaArr                                   CGL132
                                                                                              CGL132
      ** Array index (3P0) from/to caller                                                     CGL132
     C                   PARM                    WIdx_TVAL                                    CGL132
                                                                                              CGL132
      ** Valid FATCA file layout (DS) to/from caller                                          CGL132
     C                   PARM                    NwFaFilFmt                                   CGL132
                                                                                              CGL132
      ** If there are errors, redisplay FATCA details screen                                  CGL132
                                                                                              CGL132
     C     Idx           IFNE      0                                                          CGL132
     C                   Z-ADD     1             E                                            CGL132
     C     *BLANK        LOOKUP    FldNameArr(E)                          99                  CGL132
     C                   MOVEL     '*ANY'        FldNameArr(E)                                CGL132
     C                   MOVEL     'USS0397'     MsgIdArr(E)                                  CGL132
     C                   GOTO      EndVAL@G                                                   CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
      ** If displaying Further Details, return to secondary details                           CGL132
      ** screen, Otherwise move on to message detail screen                                   CGL132
                                                                                              CGL132
     C     DDACTN        IFEQ      'E'                                                        CGL132
      *                                                                                       CGL132
      * If displaying Further Details, return to message details screen                       CGL132
      * Otherwise move on to customer subfile display                                         CGL132
      *                                                                                       CGL132
     C     @RDNB         IFEQ      'Y'                                                        CGL132
     C                   MOVEL     'I'           @SCRN                                        CGL132
     C                   ELSE                                                                 CGL132
     C                   EXSR      SRINITIAL                                                  CGL132
     C                   ENDIF                                                                CGL132
      *                                                                                       CGL132
     C                   GOTO      EndVAL@G                                                   CGL132
     C                   END                                                                  CGL132
      *                                                                                       CGL132
      *                                                                                       CGL132
      * If Action Code is I or A go to Update                                                 CGL132
      *                                                                                       CGL132
     C     DDACTN        IFEQ      'I'                                                        CGL132
     C     DDACTN        OREQ      'A'                                                        CGL132
     C                   MOVEL     'U'           @SCRN                                        CGL132
     C                   ELSE                                                                 CGL132
     C                   MOVEL     'B'           @SCRN                                        CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
                                                                                              CGL132
     C     EndVAL@G      ENDSR                                                                CGL132
                                                                                              CGL132
      *****************************************************************                       CGL132
      /EJECT                                                                                  CGL132
      *****************************************************************                       CGL132
      * VAL@C - Validate FATCA details 2                                                      CGL132
      *****************************************************************                       CGL132
                                                                                              CGL132
     C     VAL@C         BEGSR                                                                CGL132
                                                                                              CGL132
     C                   Z-ADD     *ZERO         Idx                                          CGL132
     C                   Z-ADD     *ZERO         WIdx_CVAL                                    CGL132
     C                   MOVE      *ALL'Y'       OkFATCAdet                                   CGL132
                                                                                              CGL132
     C                   MOVEL     NewCuFATC     PrvCuFATC                                    CGL132
     C                   Z-ADD     WIdx_CVAL     PrvC_Warn         3 0                        CGL132
                                                                                              CGL132
     C                   CALLB     'SDFTNH1VL'                                                CGL132
                                                                                              CGL132
      ** INPUTS :                                                                             CGL132
      ** Response mode                                                                        CGL132
      ** FATCA customer details                                                               CGL132
      ** FATCA customer details (old)                                                         CGL132
                                                                                              CGL132
     C                   PARM                    RespMode                                     CGL132
     C                   PARM                    NewCuFATC                                    CGL132
     C                   PARM                    CurCuFATC                                    CGL132
                                                                                              CGL132
      ** OUTPUTS :                                                                            CGL132
      ** FATCA Customer Details OK inds                                                       CGL132
      ** Error fields/message IDs/message data (arrays) from/to caller                        CGL132
      ** Warning fields/message IDs/message data (arrays) from/to caller                      CGL132
      ** Valid FATCA Customer layout (DS) from/to caller                                      CGL132
                                                                                              CGL132
     C                   PARM                    OkFATCAdet                                   CGL132
                                                                                              CGL132
      * Error fields/message IDs/message data (arrays) from/to caller                         CGL132
     C                   PARM                    FldNameArr                                   CGL132
     C                   PARM                    MsgIDArr                                     CGL132
     C                   PARM                    MsgDtaArr                                    CGL132
                                                                                              CGL132
      ** Array index (3P0) from/to caller                                                     CGL132
     C                   PARM                    Idx                                          CGL132
                                                                                              CGL132
      ** Warning fields/message IDs/message data (arrays) from/to caller                      CGL132
     C                   PARM                    WFldNamArr                                   CGL132
     C                   PARM                    WMsgIDArr                                    CGL132
     C                   PARM                    WMsgDtaArr                                   CGL132
                                                                                              CGL132
      ** Array index (3P0) from/to caller                                                     CGL132
     C                   PARM                    WIdx_CVAL                                    CGL132
                                                                                              CGL132
      ** Valid FATCA file layout (DS) to/from caller                                          CGL132
     C                   PARM                    NwFaFilFmt                                   CGL132
                                                                                              CGL132
      ** If there are errors, redisplay FATCA details screen                                  CGL132
                                                                                              CGL132
     C     Idx           IFNE      0                                                          CGL132
     C                   GOTO      EndVAL@C                                                   CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
      ** If the screen has changed in the course of the validation                            CGL132
      ** or if there are warnings which have not been displayed                               CGL132
      ** re-display the screen                                                                CGL132
                                                                                              CGL132
     C     NewCuFATC     IFNE      PrvCuFATC                                                  CGL132
     C     WIdx_CVAL     ORNE      PrvC_Warn                                                  CGL132
     C                   GOTO      EndVAL@C                                                   CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
      ** Clear any warning messages                                                           CGL132
                                                                                              CGL132
     C                   MOVE      *ALL'Y'       OkFATCAdet                                   CGL132
     C                   MOVEL     *BLANK        WFldNamArr                                   CGL132
     C                   MOVEL     *BLANK        WMsgIdArr                                    CGL132
     C                   MOVEL     *BLANK        WMsgDtaArr                                   CGL132
                                                                                              CGL132
     C                   MOVEL     'H'           @SCRN                                        CGL132
                                                                                              CGL132
     C     EndVAL@C      ENDSR                                                                CGL132
                                                                                              CGL132
      *****************************************************************                       CGL132
      /EJECT                                                                                  CGL132
      *****************************************************************                       CGL132
      * VAL@H - Validate FATCA details 3                                                      CGL132
      *****************************************************************                       CGL132
                                                                                              CGL132
     C     VAL@H         BEGSR                                                                CGL132
                                                                                              CGL132
     C                   Z-ADD     *ZERO         Idx                                          CGL132
     C                   Z-ADD     *ZERO         WIdx_HVAL                                    CGL132
     C                   MOVE      *ALL'Y'       OkFATCAdet                                   CGL132
                                                                                              CGL132
     C                   MOVEL     NewCuFATC     PrvCuFATC                                    CGL132
     C                   Z-ADD     WIdx_HVAL     PrvH_Warn         3 0                        CGL132
                                                                                              CGL132
     C                   CALLB     'SDFTNH2VL'                                                CGL132
                                                                                              CGL132
      ** INPUTS :                                                                             CGL132
      ** Response mode                                                                        CGL132
      ** FATCA customer details                                                               CGL132
      ** FATCA customer details (old)                                                         CGL132
                                                                                              CGL132
     C                   PARM                    RespMode                                     CGL132
     C                   PARM                    NewCuFATC                                    CGL132
     C                   PARM                    CurCuFATC                                    CGL132
                                                                                              CGL132
      ** OUTPUTS :                                                                            CGL132
      ** FATCA Customer Details OK inds                                                       CGL132
      ** Error fields/message IDs/message data (arrays) from/to caller                        CGL132
      ** Warning fields/message IDs/message data (arrays) from/to caller                      CGL132
      ** Valid FATCA Customer layout (DS) from/to caller                                      CGL132
                                                                                              CGL132
     C                   PARM                    OkFATCAdet                                   CGL132
                                                                                              CGL132
      * Error fields/message IDs/message data (arrays) from/to caller                         CGL132
     C                   PARM                    FldNameArr                                   CGL132
     C                   PARM                    MsgIDArr                                     CGL132
     C                   PARM                    MsgDtaArr                                    CGL132
                                                                                              CGL132
      ** Array index (3P0) from/to caller                                                     CGL132
     C                   PARM                    Idx                                          CGL132
                                                                                              CGL132
      ** Warning fields/message IDs/message data (arrays) from/to caller                      CGL132
     C                   PARM                    WFldNamArr                                   CGL132
     C                   PARM                    WMsgIDArr                                    CGL132
     C                   PARM                    WMsgDtaArr                                   CGL132
                                                                                              CGL132
      ** Array index (3P0) from/to caller                                                     CGL132
     C                   PARM                    WIdx_HVAL                                    CGL132
                                                                                              CGL132
      ** Valid FATCA file layout (DS) to/from caller                                          CGL132
     C                   PARM                    NwFaFilFmt                                   CGL132
                                                                                              CGL132
      ** If there are errors, redisplay FATCA details screen                                  CGL132
                                                                                              CGL132
     C     Idx           IFNE      0                                                          CGL132
     C                   GOTO      EndVAL@H                                                   CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
      ** If the screen has changed in the course of the validation                            CGL132
      ** or if there are warnings which have not been displayed                               CGL132
      ** re-display the screen                                                                CGL132
                                                                                              CGL132
     C     NewCuFATC     IFNE      PrvCuFATC                                                  CGL132
     C     WIdx_HVAL     ORNE      PrvH_Warn                                                  CGL132
     C                   GOTO      EndVAL@H                                                   CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
      ** Clear any warning messages                                                           CGL132
                                                                                              CGL132
     C                   MOVE      *ALL'Y'       OkFATCAdet                                   CGL132
     C                   MOVEL     *BLANK        WFldNamArr                                   CGL132
     C                   MOVEL     *BLANK        WMsgIdArr                                    CGL132
     C                   MOVEL     *BLANK        WMsgDtaArr                                   CGL132
                                                                                              CGL132
                                                                                              CGL132
      ** If displaying Further Details, return to secondary details                           CGL132
      ** screen, Otherwise move on to message detail screen                                   CGL132
                                                                                              CGL132
     C                   MOVEL     'L'           @SCRN                                        CGL132
                                                                                              CGL132
     C     EndVAL@H      ENDSR                                                                CGL132
                                                                                              CGL132
      *****************************************************************                       CGL132
      /EJECT                                                                                  CGL132
      *****************************************************************                       CGL132
      * VAL@L - Validate FATCA details 4                                                      CGL132
      *****************************************************************                       CGL132
                                                                                              CGL132
     C     VAL@L         BEGSR                                                                CGL132
                                                                                              CGL132
     C                   Z-ADD     *ZERO         Idx                                          CGL132
     C                   Z-ADD     *ZERO         WIdx_LVAL                                    CGL132
     C                   MOVE      *ALL'Y'       OkFATCAdet                                   CGL132
                                                                                              CGL132
     C                   MOVEL     NewCuFATC     PrvCuFATC                                    CGL132
     C                   Z-ADD     WIdx_LVAL     PrvL_Warn         3 0                        CGL132
                                                                                              CGL132
     C                   CALLB     'SDFTNH3VL'                                                CGL132
                                                                                              CGL132
      ** INPUTS :                                                                             CGL132
      ** Response mode                                                                        CGL132
      ** FATCA customer details                                                               CGL132
      ** FATCA customer details (old)                                                         CGL132
                                                                                              CGL132
     C                   PARM                    RespMode                                     CGL132
     C                   PARM                    NewCuFATC                                    CGL132
     C                   PARM                    CurCuFATC                                    CGL132
                                                                                              CGL132
      ** OUTPUTS :                                                                            CGL132
      ** FATCA Customer Details OK inds                                                       CGL132
      ** Error fields/message IDs/message data (arrays) from/to caller                        CGL132
      ** Warning fields/message IDs/message data (arrays) from/to caller                      CGL132
      ** Valid FATCA Customer layout (DS) from/to caller                                      CGL132
                                                                                              CGL132
     C                   PARM                    OkFATCAdet                                   CGL132
                                                                                              CGL132
      * Error fields/message IDs/message data (arrays) from/to caller                         CGL132
     C                   PARM                    FldNameArr                                   CGL132
     C                   PARM                    MsgIDArr                                     CGL132
     C                   PARM                    MsgDtaArr                                    CGL132
                                                                                              CGL132
      ** Array index (3P0) from/to caller                                                     CGL132
     C                   PARM                    Idx                                          CGL132
                                                                                              CGL132
      ** Warning fields/message IDs/message data (arrays) from/to caller                      CGL132
     C                   PARM                    WFldNamArr                                   CGL132
     C                   PARM                    WMsgIDArr                                    CGL132
     C                   PARM                    WMsgDtaArr                                   CGL132
                                                                                              CGL132
      ** Array index (3P0) from/to caller                                                     CGL132
     C                   PARM                    WIdx_LVAL                                    CGL132
                                                                                              CGL132
      ** Valid FATCA file layout (DS) to/from caller                                          CGL132
     C                   PARM                    NwFaFilFmt                                   CGL132
                                                                                              CGL132
      ** If there are errors, redisplay FATCA details screen                                  CGL132
                                                                                              CGL132
     C     Idx           IFNE      0                                                          CGL132
     C                   GOTO      EndVAL@L                                                   CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
      ** If the screen has changed in the course of the validation                            CGL132
      ** or if there are warnings which have not been displayed                               CGL132
      ** re-display the screen                                                                CGL132
                                                                                              CGL132
     C     NewCuFATC     IFNE      PrvCuFATC                                                  CGL132
     C     WIdx_LVAL     ORNE      PrvL_Warn                                                  CGL132
     C                   GOTO      EndVAL@L                                                   CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
      ** Clear any warning messages                                                           CGL132
                                                                                              CGL132
     C                   MOVE      *ALL'Y'       OkFATCAdet                                   CGL132
     C                   MOVEL     *BLANK        WFldNamArr                                   CGL132
     C                   MOVEL     *BLANK        WMsgIdArr                                    CGL132
     C                   MOVEL     *BLANK        WMsgDtaArr                                   CGL132
                                                                                              CGL132
                                                                                              CGL132
      ** If displaying Further Details, return to secondary details                           CGL132
      ** screen, Otherwise move on to message detail screen                                   CGL132
                                                                                              CGL132
     C                   MOVEL     'Y'           @SCRN                                        CGL132
                                                                                              CGL132
     C     EndVAL@L      ENDSR                                                                CGL132
                                                                                              CGL132
      *****************************************************************                       CGL132
      /EJECT                                                                                  CGL132
      *****************************************************************                       CGL132
      * VAL@Y - Validate US Indicia details 4                                                 CGL132
      *****************************************************************                       CGL132
                                                                                              CGL132
     C     VAL@Y         BEGSR                                                                CGL132
                                                                                              CGL132
     C                   Z-ADD     *ZERO         Idx                                          CGL132
     C                   Z-ADD     *ZERO         WIdx_YVAL                                    CGL132
     C                   MOVE      *ALL'Y'       OkFATCAdet                                   CGL132
                                                                                              CGL132
     C                   MOVEL     NewCuFATC     PrvCuFATC                                    CGL132
     C                   Z-ADD     WIdx_YVAL     PrvY_Warn         3 0                        CGL132
                                                                                              CGL132
     C                   CALLB     'SDFTNH4VL'                                                CGL132
                                                                                              CGL132
      ** INPUTS :                                                                             CGL132
      ** Response mode                                                                        CGL132
      ** FATCA customer details                                                               CGL132
      ** FATCA customer details (old)                                                         CGL132
                                                                                              CGL132
     C                   PARM                    RespMode                                     CGL132
     C                   PARM                    NewCuFATC                                    CGL132
     C                   PARM                    CurCuFATC                                    CGL132
                                                                                              CGL132
      ** OUTPUTS :                                                                            CGL132
      ** FATCA Customer Details OK inds                                                       CGL132
      ** Error fields/message IDs/message data (arrays) from/to caller                        CGL132
      ** Warning fields/message IDs/message data (arrays) from/to caller                      CGL132
      ** Valid FATCA Customer layout (DS) from/to caller                                      CGL132
                                                                                              CGL132
     C                   PARM                    OkFATCAdet                                   CGL132
                                                                                              CGL132
      * Error fields/message IDs/message data (arrays) from/to caller                         CGL132
     C                   PARM                    FldNameArr                                   CGL132
     C                   PARM                    MsgIDArr                                     CGL132
     C                   PARM                    MsgDtaArr                                    CGL132
                                                                                              CGL132
      ** Array index (3P0) from/to caller                                                     CGL132
     C                   PARM                    Idx                                          CGL132
                                                                                              CGL132
      ** Warning fields/message IDs/message data (arrays) from/to caller                      CGL132
     C                   PARM                    WFldNamArr                                   CGL132
     C                   PARM                    WMsgIDArr                                    CGL132
     C                   PARM                    WMsgDtaArr                                   CGL132
                                                                                              CGL132
      ** Array index (3P0) from/to caller                                                     CGL132
     C                   PARM                    WIdx_TVAL                                    CGL132
                                                                                              CGL132
      ** Valid FATCA file layout (DS) to/from caller                                          CGL132
     C                   PARM                    NwFaFilFmt                                   CGL132
                                                                                              CGL132
      ** If there are errors, redisplay FATCA details screen                                  CGL132
                                                                                              CGL132
     C     Idx           IFNE      0                                                          CGL132
     C                   GOTO      EndVAL@Y                                                   CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
      ** If the screen has changed in the course of the validation                            CGL132
      ** or if there are warnings which have not been displayed                               CGL132
      ** re-display the screen                                                                CGL132
                                                                                              CGL132
     C     NewCuFATC     IFNE      PrvCuFATC                                                  CGL132
     C     WIdx_YVAL     ORNE      PrvY_Warn                                                  CGL132
     C                   GOTO      EndVAL@Y                                                   CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
      ** Clear any warning messages                                                           CGL132
                                                                                              CGL132
     C                   MOVE      *ALL'Y'       OkFATCAdet                                   CGL132
     C                   MOVEL     *BLANK        WFldNamArr                                   CGL132
     C                   MOVEL     *BLANK        WMsgIdArr                                    CGL132
     C                   MOVEL     *BLANK        WMsgDtaArr                                   CGL132
                                                                                              CGL132
                                                                                              CGL132
      ** If displaying Further Details, return to secondary details                           CGL132
      ** screen, Otherwise move on to message detail screen                                   CGL132
                                                                                              CGL132
     C                   MOVEL     'G'           @SCRN                                        CGL132
                                                                                              CGL132
     C     EndVAL@Y      ENDSR                                                                CGL132
                                                                                              CGL132
      *****************************************************************                       CGL132
      /EJECT                                                                                  CGL132
      *****************************************************************                       CGL132
      *                                                               *                       CGL132
      * SCRNGE - Exception screen                                     *                       CGL132
      *                                                               *                       CGL132
      *****************************************************************                       CGL132
                                                                                              CGL132
     C     SCRNGE        BEGSR                                                                CGL132
                                                                                              CGL132
      ** Go to Exception screen                                                               CGL132
     C                   MOVEL     'N'           @SCRN                                        CGL132
                                                                                              CGL132
     C                   ENDSR                                                                CGL132
                                                                                              CGL132
      *****************************************************************                       CGL132
      /EJECT                                                                                  CGL132
      *****************************************************************                       CGL132
      *                                                               *                       CGL132
      * SCRNGH - US Indicia comment history screen                    *                       CGL132
      *                                                               *                       CGL132
      *****************************************************************                       CGL132
                                                                                              CGL132
     C     SCRNGH        BEGSR                                                                CGL132
                                                                                              CGL132
      ** Go to US Indicia comment history screen                                              CGL132
     C                   MOVEL     'V'           @SCRN                                        CGL132
                                                                                              CGL132
     C                   ENDSR                                                                CGL132
                                                                                              CGL132
      *****************************************************************                       CGL132
      /EJECT                                                                                  CGL132
      *****************************************************************                       CGL132
      *                                                               *                       CGL132
      * SCRNGG - FATCA detail screen 1                                *                       CGL132
      *                                                               *                       CGL132
      *****************************************************************                       CGL132
                                                                                              CGL132
     C     SCRNGG        BEGSR                                                                CGL132
                                                                                              CGL132
      ** Go to FATCA detail screen 1                                                          CGL132
     C                   MOVEL     'G'           @SCRN                                        CGL132
                                                                                              CGL132
     C                   ENDSR                                                                CGL132
                                                                                              CGL132
      *****************************************************************                       CGL132
      /EJECT                                                                                  CGL132
      *****************************************************************                       CGL132
      *                                                               *                       CGL132
      * CANC@G - Cancel on FATCA detail screen 1                      *                       CGL132
      *                                                               *                       CGL132
      *****************************************************************                       CGL132
                                                                                              CGL132
     C     CANC@G        BEGSR                                                                CGL132
                                                                                              CGL132
      ** Go to MT3xx details screen                                                           CGL132
     C                   MOVEL     'M'           @SCRN                                        CGL132
                                                                                              CGL132
     C                   ENDSR                                                                CGL132
                                                                                              CGL132
      *****************************************************************                       CGL132
      /EJECT                                                                                  CGL132
      *****************************************************************                       CGL132
      *                                                               *                       CGL132
      * CANC@C - Cancel on FATCA detail screen 2                      *                       CGL132
      *                                                               *                       CGL132
      *****************************************************************                       CGL132
                                                                                              CGL132
     C     CANC@C        BEGSR                                                                CGL132
                                                                                              CGL132
      ** Go to FATCA detail screen 1                                                          CGL132
     C                   MOVEL     'G'           @SCRN                                        CGL132
                                                                                              CGL132
     C                   ENDSR                                                                CGL132
                                                                                              CGL132
      *****************************************************************                       CGL132
      /EJECT                                                                                  CGL132
      *****************************************************************                       CGL132
      *                                                               *                       CGL132
      * CANC@H - Cancel on FATCA detail screen 3                      *                       CGL132
      *                                                               *                       CGL132
      *****************************************************************                       CGL132
                                                                                              CGL132
     C     CANC@H        BEGSR                                                                CGL132
                                                                                              CGL132
      ** Go to FATCA detail screen 2                                                          CGL132
     C                   MOVEL     'C'           @SCRN                                        CGL132
                                                                                              CGL132
     C                   ENDSR                                                                CGL132
                                                                                              CGL132
      *****************************************************************                       CGL132
      /EJECT                                                                                  CGL132
      *****************************************************************                       CGL132
      *                                                               *                       CGL132
      * CANC@L - Cancel on FATCA detail screen 3                      *                       CGL132
      *                                                               *                       CGL132
      *****************************************************************                       CGL132
                                                                                              CGL132
     C     CANC@L        BEGSR                                                                CGL132
                                                                                              CGL132
      ** Go to FATCA detail screen 3                                                          CGL132
     C                   MOVEL     'H'           @SCRN                                        CGL132
                                                                                              CGL132
     C                   ENDSR                                                                CGL132
                                                                                              CGL132
      *****************************************************************                       CGL132
      /EJECT                                                                                  CGL132
      *****************************************************************                       CGL132
      *                                                               *                       CGL132
      * CANC@Y - Cancel on FATCA detail screen 4                      *                       CGL132
      *                                                               *                       CGL132
      *****************************************************************                       CGL132
                                                                                              CGL132
     C     CANC@Y        BEGSR                                                                CGL132
                                                                                              CGL132
      ** Go to FATCA detail screen 3                                                          CGL132
     C                   MOVEL     'L'           @SCRN                                        CGL132
                                                                                              CGL132
     C                   ENDSR                                                                CGL132
                                                                                              CGL132
      *****************************************************************                       CGL132
      /EJECT                                                                                  CGL132
      *****************************************************************                       CGL132
      *                                                               *                       CGL132
      * CANC@O - Cancel on Exception screen                           *                       CGL132
      *                                                               *                       CGL132
      *****************************************************************                       CGL132
                                                                                              CGL132
     C     CANC@O        BEGSR                                                                CGL132
                                                                                              CGL132
      ** Go to FATCA detail screen                                                            CGL132
     C                   MOVEL     'G'           @SCRN                                        CGL132
                                                                                              CGL132
     C                   ENDSR                                                                CGL132
                                                                                              CGL132
      *****************************************************************
      /EJECT
      *****************************************************************
      ** SRUpdats - Updates
      *****************************************************************
     C     SRUpdats      BEGSR
 
      ** Update valid Non-A/C : Non-A/C  reference
 
     C                   MOVEL     DDNAHO        NANAHO
     C                   MOVEL     DDACTN        NACHTP
     C                   MOVEL     DDFRNT        NAFRNT
     C                   MOVEL     DDREPA        NAREPA                                       232543
 
      ** Carry forward file data to valid file
 
     C                   EVAL      NATMST = C_NHTMST
 
     C                   MOVEL     *BLANK        PRtcd
     C                   IF        CGL132 = 'Y'                                               CGL132
     C                   EVAL      FVNAHO = DDNAHO                                            CGL132
     C                   EVAL      FVGIIN = DDGIIN                                            CGL132
     C                   EVAL      FVUTIN = DDUTIN                                            CGL132
     C                   EVAL      FVHMSV = C_FNHMSV                                          CGL132
     C                   EVAL      FVHMSD = C_FNHMSD                                          CGL132
     C                   EVAL      FVHMST = C_FNHMST                                          CGL132
     C                   EVAL      FVMCSV = C_FNMCSV                                          CGL132
     C                   EVAL      FVMCSD = C_FNMCSD                                          CGL132
     C                   EVAL      FVMCST = C_FNMCST                                          CGL132
     C                   EVAL      FVRPSV = C_FNRPSV                                          CGL132
     C                   EVAL      FVRPSD = C_FNRPSD                                          CGL132
     C                   EVAL      FVRPST = C_FNRPST                                          CGL132
     C                   EVAL      FVCISV = C_FNCISV                                          CGL132
     C                   EVAL      FVCISD = C_FNCISD                                          CGL132
     C                   EVAL      FVCIST = C_FNCIST                                          CGL132
     C                   EVAL      FVCBSV = C_FNCBSV                                          CGL132
     C                   EVAL      FVCBSD = C_FNCBSD                                          CGL132
     C                   EVAL      FVCBST = C_FNCBST                                          CGL132
     C                   EVAL      FVCDSV = C_FNCDSV                                          CGL132
     C                   EVAL      FVCDSD = C_FNCDSD                                          CGL132
     C                   EVAL      FVCDST = C_FNCDST                                          CGL132
     C                   EVAL      FVGCSV = C_FNGCSV                                          CGL132
     C                   EVAL      FVGCSD = C_FNGCSD                                          CGL132
     C                   EVAL      FVGCST = C_FNGCST                                          CGL132
     C                   EVAL      FVIDSV = C_FNIDSV                                          CGL132
     C                   EVAL      FVIDSD = C_FNIDSD                                          CGL132
     C                   EVAL      FVIDST = C_FNIDST                                          CGL132
     C                   EVAL      FVJASV = C_FNJASV                                          CGL132
     C                   EVAL      FVJASD = C_FNJASD                                          CGL132
     C                   EVAL      FVJAST = C_FNJAST                                          CGL132
     C                   EVAL      FVTESV = C_FNTESV                                          CGL132
     C                   EVAL      FVTESD = C_FNTESD                                          CGL132
     C                   EVAL      FVTEST = C_FNTEST                                          CGL132
     C                   EVAL      FVTXSV = C_FNTXSV                                          CGL132
     C                   EVAL      FVTXSD = C_FNTXSD                                          CGL132
     C                   EVAL      FVTXST = C_FNTXST                                          CGL132
     C                   EVAL      FVEXMA = C_FNEXMA                                          CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
 
      ** Non-A/C Holder Updates
 
     C                   CALLB     'SDNAHLUPD'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM                    NwNaFilFmt
     C                   PARM                    NwFaFilFmt                                   CGL132
 
      ** If there were any errors in the update functions, rollback any
      ** updates and end this program.
      ** otherwise delete the invalid Non-A/C Holder actioned & commit the updates
 
     C     PRtcd         IFNE      *BLANK
     C     PRtcd         ANDNE     '*RECUPD'
     C                   ROLBK
     C                   EXSR      *PSSR
     C                   ELSE
     C     ZATRNKD1      CHAIN     SDINAHLD0                          99
     C  N99              DELETE    SDINAHLD0
     C                   IF        CGL132 = 'Y'                                               CGL132
     C     ZATRNKD1      CHAIN     SDIFTNHD0                          98                      CGL132
     C  N98              DELETE    SDIFTNHD0                                                  CGL132
     C                   ENDIF                                                                CGL132
     C                   ENDIF
 
      ** Delete invalid record from the log file.
 
     C                   IF        CSC011 = 'Y' and S1SUPP = LIBR
 
     C                   EVAL      KMsgType = 'SDNAHL'
     C                   EVAL      KFrntOffID = @FOTRANSEL
     C                   EVAL      KTimeStamp = @TMESTPSEL
 
     C     KAPILOGL0     CHAIN     APILOGL0                           99
     C                   IF        *IN99 = *OFF
     C                   DELETE    APILOGL0
     C                   ENDIF
 
     C                   ENDIF
 
     C                   COMMIT
 
      ** If error occurred in updating last transaction set on flag to
      ** display message on 'browse' screen.
 
     C     PRtcd         IFEQ      '*RECUPD'
     C                   MOVE      'Y'           @ERRUP
     C                   ELSE
     C                   MOVE      'N'           @ERRUP
     C                   ENDIF
 
      ** If records are still to be read from the subfile, read them
 
     C     @RDNB         IFEQ      'Y'
     C                   MOVEL     'R'           @SCRN
     C                   ELSE
 
      ** ELSE, Return to the browse screen
 
     C                   MOVEL     'I'           @SCRN
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** SRSfKeys - Set function key status on screen
      *****************************************************************
     C     SRSfKeys      BEGSR
 
      ** Enable/disable function keys
 
      ** KG = Command Key 07 = Read previous Non-A/C
      ** KH = Command Key 08 = Read next Non-A/C
 
     C                   MOVEL     'N'           @EINKG
     C                   MOVEL     'N'           @EINKH
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SREndP - End Program
      *****************************************************************
     C     SREndP        BEGSR
 
     C                   MOVEL     'T'           @SCRN
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** SRTDtDtaSubs - Transaction Details Data Substitution         *
      *****************************************************************
     C     SRTDtDtaSubs  BEGSR
 
      ** Substitute the data for the various parts of the transaction,
      ** dependent on the flags that were set earlier.
 
     C                   IF        RepPrim = 'Y'
     C                   RESET                   ReturnCode
     C                   CLEAR                   IncData
     C                   CLEAR                   CurData
 
     C                   CALLB     'APDTASUBS'
 
      ** Return Code
      ** Substitution character
      ** Incoming Data
      ** Current Data
 
     C                   PARM                    ReturnCode
     C                   PARM      GHSUBS        SubsChar
     C                   PARM      NewNaPrim     IncDATA
     C                   PARM      CurNaPrim     CurDATA
 
     C                   MOVEL     IncDATA       NewNaPrim
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** SRInitial - Go To Initial Screen
      *****************************************************************
     C     SRInitial     BEGSR
 
      ** Go to Primary Screen
 
     C                   MOVEL     'P'           @SCRN
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** *InzSR - Initial Processing
      *****************************************************************
     C     *InzSR        BEGSR
 
      ** Initialize program name
 
     C                   MOVEL     'SDNAHLRPR'   DBPGM
 
      ** Access Bank Details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database Error
 
     C     PRtcd         IFNE      *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     '901'         DBASE
     C                   MOVEL     POptn         DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Access API ICD Details
 
     C                   CALLB     'AOAPIR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*FIRST '     POptn
     C     SDAPI         PARM      SDAPI         DSFDY
 
      ** Database Error
 
     C     PRtcd         IFNE      *BLANKS
     C                   MOVEL     'SDAPIPD '    DBFILE
     C                   MOVEL     '903'         DBASE
     C                   MOVEL     POptn         DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Check if switchable feature CSC011 is switched on.
 
     C                   EVAL      CSC011 = 'N'
 
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'CSC011'      PSard
     C     SCSARD        PARM      SCSARD        DSFDY
 
      ** Database error
 
     C                   IF        (PRtCd <> *BLANKS) and
     C                             (PRtCd <> '*NRF   ')
     C                   EVAL      DBKEY = 'CSC011'
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE = 905
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        PRtCd = *BLANKS
     C                   EVAL      CSC011 = 'Y'
     C                   OPEN      APILOGL0
     C                   IN        SDSTAT
     C                   IN        SC24X7
     C                   ENDIF
 
      ** Check if FATCA is switched on                                                        CGL132
                                                                                              CGL132
     C                   CALLB     'AOSARDR0'                                                 CGL132
     C                   PARM      *BLANKS       Retcd                                        CGL132
     C                   PARM      '*VERIFY'     Option                                       CGL132
     C                   PARM      'CGL132'      PSard                                        CGL132
     C     SCSARD        PARM      SCSARD        DSFDY                                        CGL132
                                                                                              CGL132
      ** Database error                                                                       CGL132
                                                                                              CGL132
     C     @RTCD         IFNE      *BLANKS                                                    CGL132
     C     @RTCD         ANDNE     '*NRF   '                                                  CGL132
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CGL132
     C                   MOVEL     '908'         DBASE                                        CGL132
     C                   MOVEL     'CGL132'      DBKEY                                        CGL132
     C                   EXSR      *PSSR                                                      CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
     C     @RTCD         IFEQ      *BLANK                                                     CGL132
     C                   MOVEL     'Y'           CGL132            1                          CGL132
     C                   ELSE                                                                 CGL132
     C                   MOVEL     'N'           CGL132                                       CGL132
     C                   ENDIF                                                                CGL132
      ** Key Lists
 
     C     KAPILOGL0     KLIST
     C                   KFLD                    KMsgType
     C                   KFLD                    KFrntOffID
     C                   KFLD                    KTimeStamp
 
     C     ZATRNKD0      KLIST
     C                   KFLD                    @FOTRANSEL
     C                   KFLD                    @Timestamp
 
     C     ZATRNKD1      KLIST
     C                   KFLD                    @FOTRANSEL
     C                   KFLD                    @TMESTPSEL
 
     C     ZATRNKX0      KLIST
     C                   KFLD                    @TMESTPSEL
     C                   KFLD                    @FOTRANSEL
 
      ** Get the field number for the action code field; the primary
      ** screen fields start from that number.  Subtract one from it to
      ** give the value to subtract from each field's number.
 
     C                   CALLB     'ZACGTFLDNO'
     C                   PARM                    ReturnCode
     C                   PARM                    FormatP
     C                   PARM                    FieldP
     C                   PARM      *ZERO         FieldNo
 
     C                   IF        ReturnCode = *Blank
     C                   EVAL      FldOffsetP = FieldNo - 1
     C                   ENDIF
 
      ** Get the field number for the SWIFT ID field; the secondary
      ** screen fields start from that number.  Subtract one from it to
      ** give the value to subtract from each field's number.
 
     C                   CALLB     'ZACGTFLDNO'
     C                   PARM                    ReturnCode
     C                   PARM                    FormatS
     C                   PARM                    FieldS
     C                   PARM                    FieldNo
 
     C                   IF        ReturnCode = *Blank
     C                   EVAL      FldOffsetS = FieldNo - 1
     C                   ENDIF
 
      ** Get the field number for the margin type field; the primary
      ** screen fields end at that number.
 
     C                   CALLB     'ZACGTFLDNO'
     C                   PARM                    ReturnCode
     C                   PARM                    FormatP
     C                   PARM                    FieldPL
     C                   PARM      *ZERO         FieldNo
 
     C                   IF        ReturnCode = *blank
     C                   EVAL      FldOffstPL = FieldNo
     C                   ENDIF
 
      ** Get the field number for the stop statement download field.
      ** The secondary screen fields end at that number.
 
     C                   CALLB     'ZACGTFLDNO'
     C                   PARM                    ReturnCode
     C                   PARM                    FormatS
     C                   PARM                    FieldSL
     C                   PARM                    FieldNo
 
     C                   IF        ReturnCode = *blank
     C                   EVAL      FldOffstSL = FieldNo
     C                   ENDIF
 
      ** Start on Browse Screen
 
     C                   MOVEL     'I'           @SCRN
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2004
