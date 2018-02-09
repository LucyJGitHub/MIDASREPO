     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Non-Account Holder - Screen Enquiry')         *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDNAHLENQ - Non-account Holders Screen Enquiry               *
      *                                                               *
      *  Function:  This is the enquiry function                      *
      *             for Non-account Holder Details.                   *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. MD029805           Date 05Sep14               *
      *                 MD029849           Date 12Sep14               *
      *                 MD027658           Date 20Aug14               *
      *                 CGL132             Date 01May13               *
      *                 CSD093             Date 01Apr13               *
      *                 AR799465           Date 07Jul11               *
      *                 CER059             Date 19Jul10               *
      *                 CER054             Date 07Apr09               *
      *                 BUG22580           Date 02Feb09               *
      *                 CER048             Date 19May08               *
      *                 CER047             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 232543             Date 31Mar05               *
      *                 CGL032  *CREATE    Date 05Jul04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD029805 - GIIN number validation (Recompile)                *
      *  MD029849 - Issues on NAHL/NAHE with FATCA                    *
      *  MD027658 - Navigation issues in non-account holder           *
      *             enquiry                                           *
      *  CGL132 - FATCA Phase 1 - Customers' Identification and       *
      *           Classification - Master                             *
      *  CSD093 - Document Management                                 *
      *  AR799465 - "Non-Account Holders Maintenance" was shown when  *
      *             navigating to the related enquiry (Recompile)     *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER054 - German Features - Church Tax (Recompile)            *
      *  BUG22580 - Fields incorrectly labeled and lengths            *
      *             (Recompile)                                       *
      *  CER048 - German Features - Taxes (Recompile)                 *
      *  CER047 - German Features LF037-00 Reporting §24c KWG         *
      *           (Recompile)                                         *
      *  232543 - Fix to CGL031 (Recompile)                           *
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
 
     D X               S              3  0
     D #FldNameArr     S            200
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
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
 
      ** New Non-A/C Holder in File Format
 
     D NwNaFilFmt    E DS                  Extname(SDVNAHLPD)
                                                                                              CGL132
      ** New Non-A/C Holder in File Format - FATCA Details                                    CGL132
     D NwFaFilFmt    E DS                  EXTNAME(SDVFTNHPD)                                 CGL132
 
      ** New Non-A/C Holder in Screen Format - Primary Details
 
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
 
      ** External DS FOR BANK DETAILS
 
     D SDBANK        E DS                  Extname(SDBANKPD)
 
      ** External DS for SAR details
 
     D SCSARD        E DS                  Extname(SCSARDPD)
     D SCA_LCD       E                     Extfld(LCD)
 
      ** First DS for access programs, short data structure
 
     D DSFDY         E DS                  Extname(DSFDY)
 
      ** Second DS for access progrmas, long data structure
 
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
 
      ** Changed Party Names Array
 
     D ChgNamArr       S              1    Dim(5)
 
     D @opsel          S              1A   Dim(ArrayMax)
     D @nasel          S             10A   Dim(ArrayMax)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Non-A/C Holder Work Field
 
     D WKNAHO          S                   Like(DDNAHO)
     D*CGL032***       S              1
     D PRtcd           S              7
     D POptn           S              7
     D PSard           S              6
     D PNAHO           S                   Like(DDNAHO)
     D Retcd           S              7A                                                      CSD093
     D Option          S              7A                                                      CSD903
     D CSD093          S              1A                                                      CSD093
     D PINMOD          S              1A                                                      CSD093
     D PINAH           S             10A                                                      CSD093
     D PINTYP          S              1A                                                      CSD093
     D PMODE           S              1A                                                    MD029849
 
      ** Response Mode, passed as a constant parameter to the VAL module
      ** This is always 'S' for Synchronous
 
     D RespMode        S              1A   Inz('S')
 
      ** Timestamp for the transaction
 
     D TimeStamp       S               Z
 
      ** Index for arrays of error message ids, etc.
 
     D IDx             S              3P 0
 
      ** Parameter fields for L2DP
 
     D @EKYFD          S              1
     D @EDTFD          S              1
     D @EINKG          S              1
     D @EINKJ          S              1
     D @EINKX          S              1                                                       CSD093
     D @INKC           S              1
     D @INKG           S              1
     D @INKH           S              1
     D @INKJ           S              1
     D @INKL           S              1
     D @INKQ           S              1A                                                      CGL132
     D @INKR           S              1A                                                      CGL132
     D @INKS           S              1A                                                      CGL132
     D @INKT           S              1A                                                      CGL132
     D @INKX           S              1                                                       CSD093
 
      ** Parameter fields for RED
 
     D @RDFWD          S              1
     D @RDBCK          S              1
     D @ERRMS          S              7
     D @NARED          S             10
 
      ** Parameter fields for BRW
 
     D @BDSFL          S              1
     D @RDSFL          S              1
     D @IN36           S              1
     D @IN81           S              1                                                       CGL132
     D @INKI           S              1
 
      ** Parameter fields for RTV
 
     D @@MODE          S              6
     D @@RSMD          S              1
 
     D CGL132          S              1                                                       CGL132
     D WIdx_Pval       S              3  0
     D WIdx_Tval       S              3  0                                                    CGL132
     D INSERTENQ       S              1
     D @RDNB           S              1
     D @EINKH          S              1
     D E               S              3  0
     D @SCRN           S              1
     D WFTNH           S              1A                                                    MD027658
 
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
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      ** Build browse subfile record
 
     C     @SCRN         IFEQ      'B'
     C                   EXSR      SRBldBrw
     C                   ENDIF
 
      ** Read next browse subfile record
 
     C     @SCRN         IFEQ      'R'
     C                   EXSR      SRRdnBrw
     C                   ENDIF
                                                                                              CGL132
      ** Build browse subfile record                                                          CGL132
                                                                                              CGL132
     C     @SCRN         IFEQ      'J'                                                        CGL132
     C                   EXSR      BLDFTBRW                                                   CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
      ** Read next browse subfile record                                                      CGL132
                                                                                              CGL132
     C     @SCRN         IFEQ      'Q'                                                        CGL132
     C                   EXSR      RDNFTBRW                                                   CGL132
     C                   ENDIF                                                                CGL132
 
      ** Do While screen: Primary Details Screen
 
     C                   Z-ADD     *ZERO         WIdx_PVAL
     C     @SCRN         DOWEQ     'P'
     C                   EXSR      SRScrn@P
     C**********         IF        @SCRN <> 'P'                                      CSD093 MD027658
     C                   IF        @SCRN <> 'P' AND                                         MD027658
     C                             CGL132 <> 'Y'                                            MD027658
     C                   EXSR      SRCallNATX
     C                   ENDIF                                                                CSD093
     C                   ENDDO
                                                                                              CGL132
      ** Do while screen: FATCA details screen 1                                              CGL132
     C                   Z-ADD     *ZERO         WIdx_GVAL         3 0                        CGL132
     C     @SCRN         DOWEQ     'G'                                                        CGL132
     C                   EXSR      SCRN@G                                                     CGL132
     C                   IF        @SCRN = 'J' OR                                           MD027658
     C                             @SCRN = 'B'                                              MD027658
     C                   EXSR      SRCallNATX                                               MD027658
     C                   ENDIF                                                              MD027658
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
 
      ** Terminate program
 
     C     @SCRN         IFEQ      'T'
     C                   MOVE      *ON           *INLR
     C                   ENDIF
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** SRSfds@P - Set field status on primary screen
      *****************************************************************
 
     C     SRSfds@P      BEGSR
 
      ** Enable/disable fields on primary screen
 
     C     DDACTN        IFEQ      'I'
     C     DDACTN        OREQ      'A'
     C                   MOVEL     'Y'           @EKYFD
     C                   MOVEL     'Y'           @EDTFD
     C                   ELSE
     C                   MOVEL     'N'           @EKYFD
     C                   MOVEL     'N'           @EDTFD
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** SRScrn@P - Process primary screen
      *****************************************************************
 
     C     SRScrn@P      BEGSR
 
      ** Set function key status on Primary screen
 
     C                   EXSR      SRSfKeys
 
      ** Write/Read Display Screen - Primary Details
 
     C                   CALLB     'SDNAHL2DP'
      **                 ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
      ** INPUTS :
      ** Return code
      ** Non-A/C Holder (In Screen format - Primary )
      ** Fields in error
      ** Errors
      ** Warnings
      ** Enabled Key & Detail fields
      ** Enabled Function keys
      ** KG = Command Key 07 = Read Previous
      ** KH = Command Key 08 = Read Next
      ** KJ = Command Key 10 = Confirm Delete
 
     C                   PARM      *BLANK        RetCodeOut
     C                   PARM                    NewNaPrim
     C                   PARM                    OkNaPrim
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    @EKYFD
     C                   PARM                    @EDTFD
     C                   PARM                    @EINKG
     C                   PARM                    @EINKJ
     C                   PARM                    @EINKX                                       CSD093
 
      ** OUTPUTS :
      ** Function Keys
      ** Write screen with no read indicator
 
     C                   PARM      *Off          @INKC
     C                   PARM      *Off          @INKG
     C                   PARM      *Off          @INKH
     C                   PARM      *Off          @INKJ
     C                   PARM      *Off          @INKL
     C                   PARM      *Off          @INKX                                        CSD093
     C                   PARM      'N'           WriteOnly
 
      ** Reset errors ....
 
     C     OKNAHO        IFNE      'N'
     C                   MOVE      *ALL'Y'       OkNaPrim
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIdArr
     C                   MOVEL     *BLANK        MsgDtaArr
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
     C                   ENDIF
 
     C                   SELECT
 
      ** F3 - End Program
 
     C                   WHEN      @inkc = *On
     C                   EXSR      SREndP
 
      ** F7 - Roll Backwards
 
     C                   WHEN      @INKG = *On
     C                   EXSR      SRRoll
 
      ** F8 - Roll Forwards
 
     C                   WHEN      @INKH = *On
     C                   EXSR      SRRoll
 
      ** F12 - Cancel on Primary Screen
 
     C                   WHEN      @INKL = *On
     C                   EXSR      SRCanc@P
 
      ** Other go back to subfle screen
 
     C                   OTHER
     C                   IF        CGL132 = 'Y'                                               CGL132
     C                   MOVE      'G'           @SCRN                                        CGL132
     C                   ELSE                                                                 CGL132
     C                   MOVE      'B'           @SCRN
     C                   ENDIF                                                                CGL132
     C                   ENDSL
                                                                                              CSD093
      ** On F23, go to Document Management, if no errors on this screen                       CSD093
     C     @INKX         IFEQ      '1'                                                        CSD093
     C                   EXSR      SRDocMan                                                   CSD093
     C                   EVAL      @SCRN = 'P'                                                CSD093
     C                   ENDIF                                                                CSD093
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** SRRoll - Roll backwards & forwards through Non-A/C Holders file
      *****************************************************************
 
     C     SRRoll        BEGSR
 
      ** Read next or previous record on Non-A/C Holder file
      ** according to command key taken (F7/@INKG OR F8/@INKH)
 
     C     @INKG         IFEQ      *On
     C                   MOVEL     *BLANK        @RDFWD
     C                   MOVEL     'Y'           @RDBCK
     C                   ELSE
     C                   MOVEL     'Y'           @RDFWD
     C                   MOVEL     *BLANK        @RDBCK
     C                   ENDIF
 
     C                   CALLB     'SDNAHLRED'
      **                 ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
      ** INPUTS :
      ** Return Code
      ** Action Code
      ** Non-A/C Holders Ref. Pointer
      ** Read forwards
      ** Read backwards
 
     C                   PARM      *BLANK        RetCodeOut
     C                   PARM      'E'           DDACTN
     C                   PARM                    DDNAHO
     C                   PARM                    @RDFWD
     C                   PARM                    @RDBCK
 
      ** OUTPUTS :
      ** Error message
      ** Non-A/C Holders Ref. Read
 
     C                   PARM      *BLANK        @ERRMS
     C                   PARM      *BLANK        @NARED
 
      **If error message returned from read, send it to detail screen
 
     C     @ERRMS        IFNE      *BLANK
     C                   EXSR      SRSndM@P
     C                   GOTO      EROLL
     C                   ENDIF
 
      ** If Non-A/C Holder read
 
     C     @NARED        IFNE      *BLANK
 
      ** Retrieve Non-A/C Holder details
 
     C                   MOVEL     @NARED        DDNAHO
     C                   EXSR      SRRtvNah
 
      ** Return to browse screen if there is an error on Non-A/C Holder Reference
 
     C     OKNAHO        IFEQ      'N'
     C     OKACTN        OREQ      'N'
     C                   MOVEL     'B'           @SCRN
     C                   GOTO      EROLL
     C                   ENDIF
 
      ** Convert Non-A/C Holder
 
     C                   EXSR      SRCvtNah
     C                   MOVEL     CrNaFilFmt    NwNaFilFmt
 
      ** Put the Non-A/C Holder on the primary details screen
 
     C                   MOVEL     'P'           @SCRN
     C                   ENDIF
 
     C     EROLL         ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** SRBldBrw - Build browse subfile
      *****************************************************************
 
     C     SRBldBrw      BEGSR
 
      ** Set/reset return to key screen from primary details
 
     C                   MOVE      'N'           INSERTENQ
 
      ** Reset Read next browse subfile record
 
     C                   MOVEL     *BLANK        @RDNB
 
      ** Build Browse subfile
 
     C                   CALLB     'SDNAHLBRW'
      **                 ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
      ** INPUTS :
      ** Return Code
      ** Action Code
      ** Non-A/C Holder Ref. Pointer
      ** Build subfile
      ** Read subfile record
 
     C                   PARM      *BLANK        RetCodeOut
     C                   PARM                    DDACTN
     C                   PARM                    DDNAHO
     C                   PARM      'Y'           @BDSFL
     C                   PARM      *BLANK        @RDSFL
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
     C                   PARM      *On           @IN36
     C                   PARM                    @IN81                                        CGL132
 
      ** OUTPUTS :
      ** Error message
      ** Option Selected
      ** Non-A/C Holder Reference Selected
      ** Command Keys
 
     C                   PARM      *BLANK        @ERRMS
     C                   PARM                    @OPSEL
     C                   PARM                    @NASEL
     C                   PARM      *Off          @INKC
     C                   PARM      *Off          @INKI
     C                   PARM      '0'           @INKN             1                          CGL132
 
      ** If F3 taken in browse, End Program
 
     C     @INKC         IFEQ      *On
     C                   EXSR      SREndP
     C                   GOTO      EndBLDBRW
     C                   ENDIF
                                                                                              CGL132
      * If F14 taken in browse, End Program                                                   CGL132
     C     @INKN         IFEQ      '1'                                                        CGL132
     C                   MOVEL     'J'           @SCRN                                        CGL132
     C                   GOTO      EndBLDBRW                                                  CGL132
     C                   ENDIF                                                                CGL132
 
      ** If error message returned from browse, send it to detail screen
 
     C     @ERRMS        IFNE      *BLANK
     C                   EXSR      SRSndm@P
     C                   GOTO      EndBLDBRW
     C                   ENDIF
 
      ** Read next browse subfile record
 
     C                   MOVE      'Y'           @RDNB
     C                   MOVEL     'R'           @SCRN
 
     C     EndBLDBRW     ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** SRRdnBrw - Read next browse subfile record
      *****************************************************************
 
     C     SRRdnBrw      BEGSR
     C                   EVAL      WFTNH = 'N'                                              MD027658
 
      ** Read Next Subfile Record
 
     C                   CALLB     'SDNAHLBRW'
      **                 ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
      ** INPUTS :
      ** Return code
      ** Action code
      ** Non-A/C Holder Ref. pointer
      ** Build Sub-file
      ** Read Sub-file record
      ** Browse Screen
 
     C                   PARM      *BLANK        RetCodeOut
     C                   PARM                    DDACTN
     C                   PARM                    DDNAHO
     C                   PARM      *BLANK        @BDSFL
     C                   PARM      'Y'           @RDSFL
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
     C                   PARM      *On           @IN36
     C                   PARM                    @IN81                                        CGL132
 
      ** OUTPUTS :
      ** Error Message
      ** Option Selected
      ** Non-A/C Holder Ref. selected
      ** Function keys
 
     C                   PARM      *BLANK        @ERRMS
     C                   PARM                    @OPSEL
     C                   PARM                    @NASEL
     C                   PARM      *Off          @INKC
     C                   PARM      *Off          @INKI
     C                   PARM      '0'           @INKN             1                          CGL132
 
     C                   EVAL      x = 1
 
      ** Go to initial screen
 
     C                   IF        @Opsel(X) = *blanks or
     C                             @Nasel(X) = *blanks
     C                   EXSR      SRInitial
     C                   ELSE
 
      ** If Non-A/C Holder read from subfile
 
     C                   DOW       @opsel(x) <> *Blank   or
     C                             @nasel(x) <> *Blanks
 
      ** Retrieve Non-A/C Holder details
 
     C                   MOVEL     @OPSEL(x)     DDACTN
     C                   MOVEL     @NASEL(x)     DDNAHO
     C                   EVAL      Idx = x - 1
     C                   EXSR      SRRtvNah
     C                   EVAL      X = X + 1
     C                   MOVEA     FldnameArr    #fldnamearr
 
      ** Stay on browse screen if there is an error on Non-A/C Holder Reference
 
     C                   IF        OKNAHO = 'N' or
     C                             OKACTN = 'N'
     C                   MOVEL     'B'           @SCRN
     C                   ITER
     C                   ENDIF
 
      ** Convert Non-A/C Holder details
 
     C                   IF        #FldNameArr = *blanks
     C                   EXSR      SRCvtNah
     C                   MOVEL     CrNaFilFmt    NwNaFilFmt
 
      ** Put Non-A/C Holder on key screen for Insert, primary details otherwise
 
     C     @OPSEL(1)     IFEQ      'I'
     C                   MOVEL     'K'           @SCRN
     C                   ELSE
     C                   MOVEL     'P'           @SCRN
     C                   ENDIF
     C                   EXSR      SRSfds@P
 
     C                   Z-ADD     *ZERO         WIdx_PVAL
     C     @SCRN         DOWEQ     'P'
     C                   EXSR      SRScrn@P
     C**********         IF        @SCRN <> 'P'                                        CSD093 CGL132
     C**********         EXSR      SRCallNATX                                                 CGL132
     C**********         ENDIF                                                         CSD093 CGL132
     C                   ENDDO
                                                                                              CGL132
      ** Do while screen: FATCA details screen 1                                              CGL132
     C                   Z-ADD     *ZERO         WIdx_GVAL                                    CGL132
     C     @SCRN         DOWEQ     'G'                                                        CGL132
     C                   EXSR      SCRN@G                                                     CGL132
     C                   ENDDO                                                                CGL132
                                                                                              CGL132
      ** Do while screen: US Indicia screen 1                                                 CGL132
     C                   Z-ADD     *ZERO         WIdx_CVAL                                    CGL132
     C     @SCRN         DOWEQ     'C'                                                        CGL132
     C                   EXSR      SCRN@C                                                     CGL132
     C                   ENDDO                                                                CGL132
                                                                                              CGL132
      ** Do while screen: US Indicia screen 2                                                 CGL132
     C                   Z-ADD     *ZERO         WIdx_HVAL                                    CGL132
     C     @SCRN         DOWEQ     'H'                                                        CGL132
     C                   EXSR      SCRN@H                                                     CGL132
     C                   ENDDO                                                                CGL132
                                                                                              CGL132
      ** Do while screen: US Indicia screen 3                                                 CGL132
     C                   Z-ADD     *ZERO         WIdx_LVAL                                    CGL132
     C     @SCRN         DOWEQ     'L'                                                        CGL132
     C                   EXSR      SCRN@L                                                     CGL132
     C                   ENDDO                                                                CGL132
                                                                                              CGL132
      ** Do while screen: US Indicia screen 4                                                 CGL132
     C                   Z-ADD     *ZERO         WIdx_YVAL                                    CGL132
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
     C**********         IF        @SCRN = 'A'                                       CGL132 MD027658
     C                   IF        @SCRN = 'J' OR                                           MD027658
     C                             @SCRN = 'B'                                              MD027658
     C                   EXSR      SRCallNATX                                                 CGL132
     C                   EVAL      @SCRN = 'B'                                                CGL132
     C                   ENDIF                                                                CGL132
 
      ** if F12 or F3 were pressed go to initial screen.
 
     C                   IF        @INKC = *On
     C                   GOTO      EndRDNBRW
     C                   ENDIF
     C                   ENDIF
 
      ** Process the remaining options selected.
 
     C                   IF        @opsel(X) <> *blanks or
     C                             @nasel(X) <> *blanks
     C                   EVAL      @scrn = 'R'
     C                   ITER
 
      ** Else, go to initial screen
 
     C**********         ELSE                                                               MD027658
     C**********         EXSR      SRInitial                                                MD027658
     C                   ENDIF
     C                   ENDDO
 
     C                   ENDIF
 
     C     EndRDNBRW     ENDSR
      *****************************************************************                       CGL132
      /EJECT                                                                                  CGL132
      *****************************************************************                       CGL132
      ** BLDFTBRW - Build FATCA browse subfile                                                CGL132
      *****************************************************************                       CGL132
     C     BLDFTBRW      BEGSR                                                                CGL132
                                                                                              CGL132
      ** Set/reset return to key screen from primary details                                  CGL132
                                                                                              CGL132
     C                   MOVE      'N'           INSERTENQ                                    CGL132
                                                                                              CGL132
      ** Reset Read next browse subfile record                                                CGL132
                                                                                              CGL132
     C                   MOVEL     *BLANK        @RDNB                                        CGL132
                                                                                              CGL132
      ** Build Browse subfile                                                                 CGL132
                                                                                              CGL132
     C                   CALLB     'SDFTNHBRW'                                                CGL132
      **                 ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯                                                 CGL132
      ** INPUTS :                                                                             CGL132
      ** Return Code                                                                          CGL132
      ** Action Code                                                                          CGL132
      ** Non-A/C Holder Ref. Pointer                                                          CGL132
      ** Build subfile                                                                        CGL132
      ** Read subfile record                                                                  CGL132
                                                                                              CGL132
     C                   PARM      *BLANK        RetCodeOut                                   CGL132
     C                   PARM                    DDACTN                                       CGL132
     C                   PARM                    DDNAHO                                       CGL132
     C                   PARM      'Y'           @BDSFL                                       CGL132
     C                   PARM      *BLANK        @RDSFL                                       CGL132
     C                   PARM      *On           @IN36                                        CGL132
     C                   PARM      'E'           PMODE                                      MD029849
     C                   PARM                    FldNameArr                                   CGL132
     C                   PARM                    MsgIdArr                                     CGL132
     C                   PARM                    MsgDtaArr                                    CGL132
                                                                                              CGL132
      ** OUTPUTS :                                                                            CGL132
      ** Error message                                                                        CGL132
      ** Option Selected                                                                      CGL132
      ** Non-A/C Holder Reference Selected                                                    CGL132
      ** Command Keys                                                                         CGL132
                                                                                              CGL132
     C                   PARM      *BLANK        @ERRMS                                       CGL132
     C                   PARM                    @OPSEL                                       CGL132
     C                   PARM                    @NASEL                                       CGL132
     C                   PARM      *Off          @INKC                                        CGL132
     C                   PARM      *Off          @INKI                                        CGL132
     C                   PARM      '0'           @INKN             1                          CGL132
                                                                                              CGL132
      ** If F3 taken in browse, End Program                                                   CGL132
                                                                                              CGL132
     C     @INKC         IFEQ      *On                                                        CGL132
     C                   EXSR      SREndP                                                     CGL132
     C                   GOTO      EndBLDFTBRW                                                CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
      * If F14 taken in browse, End Program                                                   CGL132
     C     @INKN         IFEQ      '1'                                                        CGL132
     C                   MOVEL     'B'           @SCRN                                        CGL132
     C                   GOTO      EndBLDFTBRW                                                CGL132
     C                   END                                                                  CGL132
                                                                                              CGL132
      ** If error message returned from browse, send it to detail screen                      CGL132
                                                                                              CGL132
     C     @ERRMS        IFNE      *BLANK                                                     CGL132
     C                   EXSR      SRSndM@P                                                   CGL132
     C                   GOTO      EndBLDFTBRW                                                CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
      ** Read next browse subfile record                                                      CGL132
                                                                                              CGL132
     C                   MOVE      'Y'           @RDNB                                        CGL132
     C                   MOVEL     'Q'           @SCRN                                        CGL132
                                                                                              CGL132
     C     EndBLDFTBRW   ENDSR                                                                CGL132
      *****************************************************************                       CGL132
      /EJECT                                                                                  CGL132
      *****************************************************************                       CGL132
      ** RDNFTBRW - Read next browse subfile record                                           CGL132
      *****************************************************************                       CGL132
     C     RDNFTBRW      BEGSR                                                                CGL132
     C                   EVAL      WFTNH = 'Y'                                              MD027658
                                                                                              CGL132
      ** Read Next Subfile Record                                                             CGL132
                                                                                              CGL132
     C                   CALLB     'SDFTNHBRW'                                                CGL132
      **                 ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯                                                 CGL132
      ** INPUTS :                                                                             CGL132
      ** Return code                                                                          CGL132
      ** Action code                                                                          CGL132
      ** Non-A/C Holder Ref. pointer                                                          CGL132
      ** Build Sub-file                                                                       CGL132
      ** Read Sub-file record                                                                 CGL132
      ** Browse Screen                                                                        CGL132
                                                                                              CGL132
     C                   PARM      *BLANK        RetCodeOut                                   CGL132
     C                   PARM                    DDACTN                                       CGL132
     C                   PARM                    DDNAHO                                       CGL132
     C                   PARM      *BLANK        @BDSFL                                       CGL132
     C                   PARM      'Y'           @RDSFL                                       CGL132
     C                   PARM      *On           @IN36                                        CGL132
     C                   PARM      'E'           PMODE                                      MD029849
     C                   PARM                    FldNameArr                                   CGL132
     C                   PARM                    MsgIdArr                                     CGL132
     C                   PARM                    MsgDtaArr                                    CGL132
                                                                                              CGL132
      ** OUTPUTS :                                                                            CGL132
      ** Error Message                                                                        CGL132
      ** Option Selected                                                                      CGL132
      ** Non-A/C Holder Ref. selected                                                         CGL132
      ** Function keys                                                                        CGL132
                                                                                              CGL132
     C                   PARM      *BLANK        @ERRMS                                       CGL132
     C                   PARM                    @OPSEL                                       CGL132
     C                   PARM                    @NASEL                                       CGL132
     C                   PARM      *Off          @INKC                                        CGL132
     C                   PARM      *Off          @INKI                                        CGL132
     C                   PARM      '0'           @INKN             1                          CGL132
                                                                                              CGL132
     C                   EVAL      x = 1                                                      CGL132
                                                                                              CGL132
      ** Go to initial screen                                                                 CGL132
                                                                                              CGL132
     C                   IF        @Opsel(X) = *BLANKS or                                     CGL132
     C                             @Nasel(X) = *BLANKS                                        CGL132
     C                   EXSR      SRInitial                                                  CGL132
     C                   MOVEL     'J'           @SCRN                                        CGL132
     C                   ELSE                                                                 CGL132
                                                                                              CGL132
      ** If Non-A/C Holder read from subfile                                                  CGL132
                                                                                              CGL132
     C                   DOW       @opsel(x) <> *BLANKS  or                                   CGL132
     C                             @nasel(x) <> *BLANKs                                       CGL132
                                                                                              CGL132
      ** Retrieve Non-A/C Holder details                                                      CGL132
                                                                                              CGL132
     C                   MOVEL     @OPSEL(x)     DDACTN                                       CGL132
     C                   MOVEL     @NASEL(x)     DDNAHO                                       CGL132
     C                   EVAL      Idx = x - 1                                                CGL132
     C                   EXSR      SRRtvNah                                                   CGL132
     C                   EVAL      X = X + 1                                                  CGL132
     C                   MOVEA     FldnameArr    #fldnamearr                                  CGL132
                                                                                              CGL132
      ** Stay on browse screen if there is an error on Non-A/C Holder Reference               CGL132
                                                                                              CGL132
     C     OKNAHO        IFEQ      'N'                                                        CGL132
     C     OKACTN        OREQ      'N'                                                        CGL132
     C                   MOVEL     'J'           @SCRN                                        CGL132
     C                   ITER                                                                 CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
     C                   IF        #FldNameArr = *blanks                                      CGL132
                                                                                              CGL132
      ** Convert Non-A/C Holder details                                                       CGL132
                                                                                              CGL132
     C                   EXSR      SRCvtNah                                                   CGL132
     C                   MOVEL     CrNaFilFmt    NwNaFilFmt                                   CGL132
                                                                                              CGL132
     C                   MOVEL     'P'           @SCRN                                        CGL132
     C                   EXSR      SRSfds@P                                                 MD029849
                                                                                              CGL132
     C                   Z-ADD     *ZERO         WIdx_PVAL                                    CGL132
     C     @SCRN         DOWEQ     'P'                                                        CGL132
     C                   EXSR      SRScrn@P                                                   CGL132
     C                   ENDDO                                                                CGL132
                                                                                              CGL132
      ** Do while screen: FATCA details screen 1                                              CGL132
     C                   Z-ADD     *ZERO         WIdx_GVAL                                    CGL132
     C     @SCRN         DOWEQ     'G'                                                        CGL132
     C                   EXSR      SCRN@G                                                     CGL132
     C                   ENDDO                                                                CGL132
                                                                                              CGL132
      ** Do while screen: US Indicia screen 1                                                 CGL132
     C                   Z-ADD     *ZERO         WIdx_CVAL                                    CGL132
     C     @SCRN         DOWEQ     'C'                                                        CGL132
     C                   EXSR      SCRN@C                                                     CGL132
     C                   ENDDO                                                                CGL132
                                                                                              CGL132
      ** Do while screen: US Indicia screen 2                                                 CGL132
     C                   Z-ADD     *ZERO         WIdx_HVAL                                    CGL132
     C     @SCRN         DOWEQ     'H'                                                        CGL132
     C                   EXSR      SCRN@H                                                     CGL132
     C                   ENDDO                                                                CGL132
                                                                                              CGL132
      ** Do while screen: US Indicia screen 3                                                 CGL132
     C                   Z-ADD     *ZERO         WIdx_LVAL                                    CGL132
     C     @SCRN         DOWEQ     'L'                                                        CGL132
     C                   EXSR      SCRN@L                                                     CGL132
     C                   ENDDO                                                                CGL132
                                                                                              CGL132
      ** Do while screen: US Indicia screen 4                                                 CGL132
     C                   Z-ADD     *ZERO         WIdx_YVAL                                    CGL132
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
                                                                                              CGL132
     C                   IF        @SCRN = 'A'                                                CGL132
     C                   EXSR      SRCallNATX                                                 CGL132
     C**********         EVAL      @SCRN = 'B'                                       CGL132 MD029849
     C                   EVAL      @SCRN = 'J'                                              MD029849
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
      ** Process the remaining options selected.                                              CGL132
                                                                                              CGL132
     C                   IF        @opsel(X) <> *BLANKS or                                    CGL132
     C                             @nasel(X) <> *BLANKS                                       CGL132
     C                   EVAL      @scrn = 'Q'                                                CGL132
     C                   ITER                                                                 CGL132
     C                   ENDIF                                                                CGL132
     C                   ENDIF                                                                CGL132
     C                   ENDDO                                                                CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
     C     EndRDNFTBRW   ENDSR                                                                CGL132
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** SRRtvNah - Retrieve Non-account Holder
      *****************************************************************
 
     C     SRRtvNah      BEGSR
 
      ** Retrieve Non-account Holder
 
     C                   CALLB     'SDNAHLRTV'
      **                 ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
      ** INPUTS :
      ** Return code
      ** Mode = '*FRONT' (Front Office transaction interface)
      ** Mode = '      ' (Not Front Office transaction interface)
      ** Response mode
      ** Action Code
      ** Front Office Transaction ID
      ** (Midas) Non-A/C Holder Reference
 
     C                   PARM      *BLANK        RetCodeOut
     C                   PARM      '      '      @@MODE
     C                   PARM      'S'           @@RSMD
     C                   PARM                    DDACTN
     C                   PARM                    C_NHFRNT
     C                   PARM                    DDNAHO
     C                   PARM      *On           @IN36
 
      ** OUTPUTS :
      ** (Current) Customer in file format
      ** OK - Action code
      ** OK - Customer Reference
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    CrNaFilFmt
     C                   PARM                    CrFaFilFmt                                   CGL132
     C                   PARM                    CrFoFilFmt                                   CGL132
     C                   PARM      *BLANK        OKACTN
     C                   PARM      *BLANK        OKNAHO
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    Idx
 
     C     EndRTVNAH     ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** SRCvtNah - Put a Non-A/C Holder on the primary details screen
      *****************************************************************
 
     C     SRCvtNah      BEGSR
 
      ** Call program to fill screen fields with data from SDNAHOPD
 
     C                   CALLB     'SDNAHLCVT'
      **                 ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
      ** INPUTS :
      ** Return Code
      ** Non-A/C Holder file format
 
     C                   PARM      *BLANK        RetCodeOut
     C                   PARM                    CrNaFilFmt
     C                   PARM                    CrFaFilFmt                                   CGL132
     C                   PARM                    CrFoFilFmt                                   CGL132
 
      ** OUTPUTS :
      ** Non-A/C Holder - screen formats
      ** Update 'Current' Customer with Customer in Screen Format
 
     C                   PARM                    NewNaPrim
     C                   PARM                    NewCuFATC                                    CGL132
     C                   PARM                    NewCuFOTH                                    CGL132
 
     C                   MOVEL     NewNaPrim     CurNaPrim
     C                   IF        CGL132 = 'Y'                                               CGL132
     C                   MOVEL     NewCuFATC     CurCuFATC                                    CGL132
     C                   MOVEL     NewCuFOTH     CurCuFOTH                                    CGL132
     C                   ENDIF                                                                CGL132
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** SRSfKeys - Set Function key status on screen
      *****************************************************************
 
     C     SRSfKeyS      BEGSR
 
      ** Enable/disable function keys
 
      ** KG = Command Key 07 = Read Previous Non-A/C Holder
      ** KH = Command Key 08 = Read Next Non-A/C Holder
 
     C     @SCRN         IFEQ      'P'
     C                   MOVEL     'Y'           @EINKG
     C                   MOVEL     'Y'           @EINKH
     C                   ELSE
     C                   MOVEL     'N'           @EINKG
     C                   MOVEL     'N'           @EINKH
     C                   ENDIF
 
      ** KJ = Command Key 10 = Confirm Delete
 
     C     DDACTN        IFEQ      'D'
     C                   MOVEL     'Y'           @EINKJ
     C                   ELSE
     C                   MOVEL     'N'           @EINKJ
     C                   ENDIF
                                                                                              CSD093
      ** KX = Command Key 23 = Document Management                                            CSD093
                                                                                              CSD093
     C                   IF        DDACTN <> 'I' AND CSD093 = 'Y'                             CSD093
     C                   MOVEL     'Y'           @EINKX                                       CSD093
     C                   ELSE                                                                 CSD093
     C                   MOVEL     'N'           @EINKX                                       CSD093
     C                   ENDIF                                                                CSD093
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** SRIfds@K - Initialise field status on key screen
      *****************************************************************
 
     C     SRIfds@K      BEGSR
 
      ** Enable Key fields on key screen
 
     C                   MOVEL     'Y'           @EDTFD
     C                   MOVEL     'Y'           @EKYFD
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** SRSndM@P - Send a message to screen
      *****************************************************************
 
     C     SRSndM@P      BEGSR
 
      ** Add error message to array passed to detail screen
 
     C                   Z-ADD     1             E
     C     *BLANK        LOOKUP    FldNameArr(E)                          99
     C                   MOVEL     '*ANY'        FldNameArr(E)
     C                   MOVEL     @ERRMS        MsgIdArr(E)
 
     C     EndSNDM@P     ENDSR
 
      *****************************************************************
      /EJECT
                                                                                              CGL132
      *****************************************************************                       CGL132
      /EJECT                                                                                  CGL132
      *****************************************************************                       CGL132
      * SCRN@G - Process FATCA details screen 1                                               CGL132
      *****************************************************************                       CGL132
                                                                                              CGL132
     C     SCRN@G        BEGSR                                                                CGL132
                                                                                              CGL132
     C                   EVAL      DDACTI = 'E'                                               CGL132
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
     C                   PARM      *Off          @INKL                                        CGL132
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
     C                   IF        WFTNH = 'Y'                                              MD027658
     C                   MOVEL     'J'           @SCRN                                      MD027658
     C                   ELSE                                                               MD027658
     C                   MOVEL     'B'           @SCRN                                        CGL132
     C                   ENDIF                                                              MD027658
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
     C                   MOVEL     'C'           @SCRN                                        CGL132
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
     C                   MOVEL     'H'           @SCRN                                        CGL132
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
     C                   MOVEL     'L'           @SCRN                                        CGL132
     C                   ENDIF                                                                CGL132
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
     C                   MOVEL     'Y'           @SCRN                                        CGL132
     C                   ENDIF                                                                CGL132
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
     C                   MOVEL     'G'           @SCRN                                        CGL132
     C                   ENDIF                                                                CGL132
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
     C                   MOVEL     'P'           @SCRN                                        CGL132
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
      ** SRCanc@K - Cancel on Key screen
      *****************************************************************
 
     C     SRCanC@K      BEGSR
 
      ** Reset Read Next Browse Subfile Record (if active)
 
     C                   MOVEL     *BLANK        @RDNB
     C                   MOVEL     'B'           @SCRN
 
      ** Blank the screens
      ** If input fields are enabled
 
     C     @EKYFD        IFEQ      'Y'
     C     @EDTFD        OREQ      'Y'
     C                   MOVEL     *BLANK        NewNaPrim
     C                   ENDIF
 
      ** Initialize field status on Key Screen
 
     C                   EXSR      SRIfds@K
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** SRCanC@P - Cancel on Primary screen
      *****************************************************************
 
     C     SRCanC@P      BEGSR
 
     C                   IF        WFTNH = 'Y'                                              MD027658
     C                   MOVEL     'J'           @SCRN                                      MD027658
     C                   ELSE                                                               MD027658
     C                   MOVEL     'B'           @SCRN
     C                   ENDIF                                                              MD027658
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** SREndP - End Program
      *****************************************************************
 
     C     SREndP        BEGSR
 
     C                   MOVEL     'T'           @SCRN
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** SRInitial - Go To Initial Screen
      *****************************************************************
 
     C     SRInitial     BEGSR
 
      ** Reset Read Next Browse Subfile Record (if active)
 
     C                   MOVEL     *BLANK        @RDNB
 
      ** Blank the screens
 
     C                   MOVEL     *BLANK        NewNaPrim
 
      ** Browse Screen
 
     C                   MOVEL     'B'           @SCRN
 
      ** Initialize field status on Key Screen
 
     C                   EXSR      SRIfds@K
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRCallNATX - Call Non-Account Holder Details by Country       *
      *               of Tax                                          *
      *                                                               *
      *****************************************************************
     C     SRCallNATX    BEGSR
 
     C                   CALL      'SDNATXENQ'
     C                   PARM                    PRtcd
     C                   PARM      DDNAHO        PNAHO
 
     C                   ENDSR
      *****************************************************************
      /EJECT                                                                                  CSD093
      *****************************************************************                       CSD093
      *                                                               *                       CSD093
      * SRDocMan - Calls Document Management                          *                       CSD093
      *                                                               *                       CSD093
      *****************************************************************                       CSD093
     C     SRDocMan      BEGSR                                                                CSD093
     C                   CALL      'SDDCMTSIN'                                                CSD093
     C                   PARM      *BLANKS       RetCodeOut                                   CSD093
     C                   PARM      DDACTN        PINMOD                                       CSD093
     C                   PARM      DDNAHO        PINAH                                        CSD093
     C                   PARM      'N'           PINTYP                                       CSD093
     C                   ENDSR                                                                CSD093
      *****************************************************************                       CSD093
      /EJECT
      *****************************************************************
      ** *INZSR - Initial processing
      *****************************************************************
 
     C     *INZSR        BEGSR
 
      ** Initialize program name
 
     C                   MOVEL     'SDNAHLENQ'   DBPGM
 
      ** Access Bank details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database error
 
     C     PRtcd         IFNE      *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     '901'         DBASE
     C                   MOVEL     POptn         DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
                                                                                              CSD093
      ** Check whether CSD093 is available                                                    CSD093
                                                                                              CSD093
     C                   CALL      'AOSARDR0'                                                 CSD093
     C                   PARM      *Blanks       Retcd                                        CSD093
     C                   PARM      '*VERIFY'     Option                                       CSD093
     C                   PARM      'CSD093'      PSard                                        CSD093
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD093
                                                                                              CSD093
     C                   IF        Retcd <> *Blanks                                           CSD093
     C                   IF        Retcd <> '*NRF'                                            CSD093
     C                   MOVEL     'SCSARDPD'    Dbfile                                       CSD093
     C                   MOVEL     '906'         Dbase                                        CSD093
     C                   MOVEL     PSard         Dbkey                                        CSD093
     C                   EXSR      *PSSR                                                      CSD093
     C                   ENDIF                                                                CSD093
     C                   EVAL      CSD093 = 'N'                                               CSD093
     C                   ELSE                                                                 CSD093
     C                   EVAL      CSD093 = 'Y'                                               CSD093
     C                   ENDIF                                                                CSD093
                                                                                              CGL132
      ** Check if CGL132 is on                                                                CGL132
                                                                                              CGL132
     C                   EVAL      @IN81 = '0'                                                CGL132
     C                   CALL      'AOSARDR0'                                                 CGL132
     C                   PARM      *Blanks       Retcd                                        CGL132
     C                   PARM      '*VERIFY'     Option                                       CGL132
     C                   PARM      'CGL132'      PSard                                        CGL132
     C     SCSARD        PARM      SCSARD        DSFDY                                        CGL132
                                                                                              CGL132
     C                   IF        Retcd <> *Blanks                                           CGL132
     C                   IF        Retcd <> '*NRF'                                            CGL132
     C                   MOVEL     'SCSARDPD'    Dbfile                                       CGL132
     C                   MOVEL     '907'         Dbase                                        CGL132
     C                   MOVEL     PSard         Dbkey                                        CGL132
     C                   EXSR      *PSSR                                                      CGL132
     C                   ENDIF                                                                CGL132
     C                   ELSE                                                                 CGL132
     C                   EVAL      CGL132 = 'Y'                                               CGL132
     C                   EVAL      @IN81 = '1'                                                CGL132
     C                   ENDIF                                                                CGL132
 
      ** Go to initial screen
 
     C                   EXSR      SRInitial
 
 
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
