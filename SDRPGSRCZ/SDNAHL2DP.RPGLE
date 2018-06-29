     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Non-Account Holder - Primary Screen')         *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Details Module                              *
      *                                                               *
      *  SDNAHL2DP  - Non-A/C Holder Details Display - Primary Screen *
      *                                                               *
      *  Function:  This module displays the primary details screen   *
      *             of the customer details screen input function     *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *  Last Amend No. MD051432           Date 30Jun18               *
      *  Prev Amend No. MD050383           Date 18Apr18               *
      *                 CGL157             Date 17Aug15               *
      *                 MD046248           Date 27Oct17               *
      *                 MD028364           Date 11Jul14               *
      *                 MD026506           Date 29May14               *
      *                 MD026752           Date 19May14               *
      *                 MD026537           Date 28Apr14               *
      *                 CGL132             Date 01May13               *
      *                 CSD093             Date 01Apr13               *
      *                 AR740749           Date 25Apr11               *
      *                 AR689705           Date 03Jan11               *
      *                 AR655783           Date 12Oct10               *
      *                 CER059             Date 19Jul10               *
      *                 BUG25533           Date 19Aug09               *
      *                 BUG23642           Date 26May09               *
      *                 CER054             Date 07Apr09               *
      *                 BUG22580           Date 02Feb09               *
      *                 BUG22327           Date 29Jan09               *
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
      *  MD051432 - Remove TIN2 to TIN5 (Recompile)                   *
      *  MD050383 - Phone Number Country highlights an error even the *
      *             fields are not mandatory for input in NAHO        *
      *  CGL157 - CRS Reporting                                       *
      *  MD046248 - Finastra Rebranding                               *
      *  MD028364 - Family Name and First Name overlapped by the new  *
      *             upper-shifted fields. (Recompile)                 *
      *  MD026506 - Creation Date for newly inserted non-account      *
      *             holders becomes protected even though insert is   *
      *             not yet done. Applied MD025137                    *
      *  MD026752 - Unable to create a Non-Account Holder due to in-  *
      *             valid/missing fields.                             *
      *           - Recompiled due to correction done in the display  *
      *             file.                                             *
      *  MD026537 - Highlighted fields are different from the         *
      *             original fields that trigger the error messages   *
      *  CGL132 - FATCA Phase 1 - Customers' Identification and       *
      *           Classification - Master                             *
      *  CSD093 - Document Management                                 *
      *  AR740749 - Non Account Holder Maintenance Usability Issues   *
      *             (Child: AR740750)                                 *
      *  AR689705 - Nominal and value settled were missing after      *
      *             enter. Applied fix AR656294 (Child: AR689706)     *
      *  AR656294 - HATS issue                                        *
      *  AR655783 - Database Issues                                   *
      *           - reinstate OKISAU field with 35char long; removed  *
      *             by bug22580 to comply with CM standards.          *
      *           - Introduced OKISAU1 as ok flag for DISAU.          *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG25533 - Non Generation of Withholding Tax per Federal     *
      *             State Report during Input Cycle and after COB     *
      *             (Applied BUG24714 fix)                            *
      *  BUG24714 - Non Generation of Withholding Tax per Federal     *
      *             State Report during Input Cycle and after COB     *
      *  BUG23642 - Non - Account holders - 2 Issues                  *
      *  CER054 - German Features - Church Tax                        *
      *  BUG22580 - Fields incorrectly labeled and lengths            *
      *  BUG22327 - Recompiled due to display file changes            *
      *  CER048 - German Features - Taxes                             *
      *  CER047 - German Features LF037-00 Reporting §24c KWG         *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  CSW207 - Swift 2007 Standard Changes                         *
      *  232543 - Fix to CGL031                                       *
      *  CGL032 - Automatic Exchange of Information.                  *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

     FSDNAHL2DDFCF   E             Workstn

      ** Non-A/C Holders Details Retrieval
     FSDNAHOL1  IF   E           K Disk    Infsr(*PSSR)

      ** Table of field numbers and names
     FZAFLDNPD  IT   F   15        Disk    Infsr(*PSSR)

      *****************************************************************
      *                                                               *
      * ID F  C  H  L    FUNCTION OF INDICATORS                       *
      *                                                               *
      *     10-59 Field Error - highlight screen fields               *
      *       69  Position cursor on first screen field if no errors  *
      *       70  Protect screen fields                               *
      *       71  Enable function keys F7/F8 (read previous/next)     *
      *       72  Enable function key F10 (delete)                    *
      *       75  Condition display of CGL032 fields                  *
      *       95  Condition display of CSD093 fields                  *                       CSD093
      *       97  Subfile end                                         *
      *       99  Read error                                          *
      ********************************************************************
      /EJECT
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
      ** The following /COPY line includes all the definitions of the error
      ** arrays, including the named constant giving the size of
      ** the arrays.  Note that it uses #MsgID and *MsgData, and so requires
      ** STD_D_SPEC.
     D/COPY ZACPYSRC,FVAL_ARRAY
      **--------------------------------------------------------------------------------------------

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,APICTLARR
      **--------------------------------------------------------------------------------------------

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for fields
      ** required by the message handler.
     D/COPY ZACPYSRC,MSGHNDDCL
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

     D @Z0             S              1    Dim(60) Ctdata Perrcd(60)
     D @EI             S              1    Dim(60)


     D NaPrim        E DS                  Extname(SDNAHLPD)
     D OKNaPrim      E DS                  Extname(SDENAHLPD)

      ** External DS for Bank Details
     D SDBANK        E DS                  Extname(SDBANKPD)

      ** External DS for SAR Details
     D SCSARD        E DS                  Extname(SCSARDPD)

      **  Short DS for access programs
     D DSFDY         E DS                  Extname(DSFDY)

      **  Long DS for access programs
     D DSSDY         E DS                  Extname(DSSDY)

      ** External DS for Midas modules                                                        CSW207
     D SDMMOD        E DS                  Extname(SDMMODPD)                                  CSW207

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      ** Parameter fields for ZDATE2
     D ZDAYNO          S              5  0
     D ZDATE           S              6  0
     D ZADATE          S              7

      ** Entrty Parameter fields
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
     D @INKX           S              1                                                       CSD093

     D Retcd           S              7
     D Option          S              7
     D QueryFld        S              1
     D WDate           S              4A
     D C               S              2  0
     D E               S              2  0
      *                                                                                       232543
     D                 DS                                                                     232543
     D WIssDate                       8A                                                      232543
     D  IsDteYY                1      4A                                                      232543
     D  IsDteMM                5      6A                                                      232543
     D  IsDteDD                7      8A                                                      232543
                                                                                              232543
      ** Date format MMDDYYYY                                                                 232543
     D                 DS                                                                     232543
     D DteFmtM                        8A                                                      232543
     D  DteM_MM                1      2A                                                      232543
     D  DteM_DD                3      4A                                                      232543
     D  DteM_YY                5      8A                                                      232543
                                                                                              232543
      ** Date format DDMMYYYY                                                                 232543
     D                 DS                                                                     232543
     D DteFmtD                        8A                                                      232543
     D  DteD_DD                1      2A                                                      232543
     D  DteD_MM                3      4A                                                      232543
     D  DteD_YY                5      8A                                                      232543
                                                                                              CSW207
      ** SWIFT 2007 feature                                                                   CSW207
                                                                                              CSW207
     D CSW207          S              1A   INZ('N')                                           CSW207
     D wPrivBank       S              1A   INZ('N')                                           CSW207

     D CER047          S              1A                                                      CER047
     D CER048          S              1A                                                      CER048
     D CER054          S              1A                                                      CER054
      *                                                                                       CER047
      ** Parameter fields for AOSARDR0                                                        CER047
      *                                                                                       CER047
     D PRtcd           S              7A                                                      CER047
     D POptn           S              7A                                                      CER047
     D PSard           S              6A                                                      CER047
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the             ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+

      ** Main processing

     C                   EXSR      SRMain

      ** Return

     C     @INKC         IFEQ      *On
     C                   EVAL      *InLR = *On
     C                   ENDIF

     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      ** SRMain - Main processing
      *****************************************************************
     C     SRMain        BEGSR

     C                   IF        CSW207 = 'Y' or wPrivBank = 'Y'                            CSW207
     C                   EVAL      *IN84 = *ON                                                CSW207
     C                   ELSE                                                                 CSW207
     C                   EVAL      *IN84 = *OFF                                               CSW207
     C                   ENDIF                                                                CSW207
                                                                                              CSD093
      ** F23 - Document Management                                                            CSD093
     C                   IF        @EINKX = 'Y'                                               CSD093
     C                   EVAL      *IN95 = *ON                                                CSD093
     C                   ELSE                                                                 CSD093
     C                   EVAL      *IN95 = *OFF                                               CSD093
     C                   ENDIF                                                                CSD093
                                                                                              CSD093
                                                                                              CSW207
      ** Move 'OK' flags into array (for checking)

     C                   MOVEA     OKNaPrim      @EI

      ** Set screen error indicators acoording to status of 'OK' flags

     C                   Z-ADD     1             C
     C                   Z-ADD     10            E

     C     C             DOUGT     60

     C     @EI(C)        IFEQ      'N'
     C     @EI(C)        OREQ      'W'
     C                   MOVEL     *On           *In(E)
     C                   ENDIF

     C                   ADD       1             C
     C                   ADD       1             E

     C                   ENDDO
      *
     C     OKISAU1       COMP      'N'                                    33                AR655783
                                                                                            AR655783
     C                   IF        CER047 = 'Y'                                               CER047
     C     OKINDC        COMP      'N'                                    78                  CER047
     C     OKEXDT        COMP      'N'                                    76                  CER047
     C     OKCTYD        COMP      'N'                                    74                  CER047
     C     OKCTYC        COMP      'N'                                    75                  CER047
     C     OKSREF        COMP      'N'                                    85                  CER047
      *                                                                                       CER048
     C                   IF        CER048 = 'Y'                                               CER048
     C     OKTITL        COMP      'N'                                    80                  CER048
     C     OKISUP        COMP      'N'                                    81                  CER048
     C     OKDOCN        COMP      'N'                                    82                  CER048
     C                   ENDIF                                                                CER048
      *                                                                                       CER048
     C                   ELSEIF    CER048 = 'Y'                                               CER048
     C     OKTITL        COMP      'N'                                    80                  CER048
     C     OKINDC        COMP      'N'                                    78                  CER048
     C     OKISUP        COMP      'N'                                    81                  CER048
     C     OKDOCN        COMP      'N'                                    82                  CER048
     C     OKSREF        COMP      'N'                                    85                BUG22580
      *                                                                                       CER054
     C                   ENDIF                                                                CER054
      *                                                                                       CER054
     C                   IF        CER048 = 'Y'                                             BUG24714
     C     OKSTCD        COMP      'N'                                    87                BUG24714
     C                   ENDIF                                                              BUG24714
     C                   IF        CER054 = 'Y'                                               CER054
     C                             AND CER048 = 'Y'                                           CER054
     C*****OKSTCD        COMP      'N'                                    87         CER054 BUG24714
     C     OKRLAF        COMP      'N'                                    88                  CER054
      *                                                                                       CER048
     C                   ENDIF                                                                CER047
      *                                                                                       CER047
                                                                                              CGL132
     C*****OKCOCZ        COMP      'N'                                    74         CGL132 MD026537
     C*****OKACCZ        COMP      'N'                                    75         CGL132 MD026537
     C*****OKTIN2        COMP      'N'                                    76         CGL132 MD026537
     C     OKCOCZ        COMP      'N'                                    44                MD026537
     C     OKACCZ        COMP      'N'                                    45                MD026537
     C     OKTIN2        COMP      'N'                                    46                MD026537
     C     OKCTIN2       COMP      'N'                                    77                  CGL132
     C*****OKTIN3        COMP      'N'                                    78         CGL132 MD026537
     C     OKTIN3        COMP      'N'                                    48                MD026537
     C     OKCTIN3       COMP      'N'                                    79                  CGL132
     C*****OKTIN4        COMP      'N'                                    80         CGL132 MD026537
     C*****OKCTIN4       COMP      'N'                                    81         CGL132 MD026537
     C*****OKTIN5        COMP      'N'                                    82         CGL132 MD026537
     C     OKTIN4        COMP      'N'                                    50                MD026537
     C     OKCTIN4       COMP      'N'                                    51                MD026537
     C     OKTIN5        COMP      'N'                                    52                MD026537
     C     OKCTIN5       COMP      'N'                                    83                  CGL132
     C*****OKCRDT        COMP      'N'                                    85         CGL132 MD026537
     C     OKCRDT        COMP      'N'                                    55                MD026537
     C     OKMCT1        COMP      'N'                                    40                  CGL157
     C     OKMCT2        COMP      'N'                                    61                  CGL157
     C     OKMCT3        COMP      'N'                                    62                  CGL157
     C     OKMCT4        COMP      'N'                                    63                  CGL157
     C     OKMCT5        COMP      'N'                                    64                  CGL157
     C     OKPCT1        COMP      'N'                                    65                  CGL157
     C     OKPCT2        COMP      'N'                                    66                  CGL157
     C     OKPCT3        COMP      'N'                                    67                  CGL157
     C     OKPCT4        COMP      'N'                                    68                  CGL157
     C*****OKPCT5        COMP      'N'                                    69                  CGL157
     C     OKPCT5        COMP      'N'                                    89                MD050383

     C**********         IF        DDCRDT <> *BLANKS                                 CGL132 MD026506
     C                   EVAL      *IN60 = *OFF                                             MD026506
     C                   IF        DDACTN = 'A'                                             MD026506
     C     DDNAHO        CHAIN     SDNAHOD0                                                 MD026506
     C                   IF        NHCRDT <> *BLANKS                                        MD026506
     C                   EVAL      *IN60 = *ON                                                CGL132
     C                   ENDIF                                                              MD026506
     C                   ENDIF                                                                CGL132
      ** Set up the Non-A/C Holder Reference to be used by the message handler

     C                   EVAL      TranRef = DDNAHO
     C                   EVAL      ActionCode = DDACTN
                                                                                              232543
      ** Set up Issuing Date on the screen                                                    232543
                                                                                              232543
     C                   MOVEL     DDISDT        WIssDate                                     232543
     C                   IF        BJDFIN = 'D'                                               232543
     C                   MOVEL     IsDteDD       DteD_DD                                      232543
     C                   MOVEL     IsDteMM       DteD_MM                                      232543
     C                   MOVEL     IsDteYY       DteD_YY                                      232543
     C                   MOVEL     DteFmtD       DDISDT1                                      232543
     C                   ELSE                                                                 232543
     C                   MOVEL     IsDteMM       DteM_MM                                      232543
     C                   MOVEL     IsDteDD       DteM_DD                                      232543
     C                   MOVEL     IsdteYY       DteM_YY                                      232543
     C                   MOVEL     DteFmtM       DDISDT1                                      232543
     C                   ENDIF                                                                232543

      ** The following /COPY line includes processing for the error and
      ** warning messages.
      /COPY ZACPYSRC,MSGHNDDSP1

      ** Position cursor on first field if no errors

     C     'N'           LOOKUP    @EI                                    69

      ** Protect all fields

     C                   MOVE      *OFF          *IN70

      ** Enable detail fields (all fields except action code & non-a/c holder reference)

     C     @EDTFD        COMP      'Y'                                7070

      ** Enable Function keys

     C     @EINKG        COMP      'Y'                                    71
     C     @EINKJ        COMP      'Y'                                    72

      ** Write message subfile, Primary details and Footer screen

     C                   TIME                    DDTIME

     C                   WRITE     SDNAHLPS0
     C                   WRITE     SDNAHLPF1                                                AR656294
     C                   WRITE     SDNAHLPD1
     C**********         WRITE     SDNAHLPF1                                                AR656294

      ** Read details screen, if not write only

     C     WriteOnly     IFNE      'Y'
     C                   READ      SDNAHLPD1                              99
     C                   ENDIF

      ** If Exit/Previous screen not selected
      ** Process User request for data tables with query '?'

     C     @INKC         IFNE      *ON
     C     @INKL         ANDNE     *ON

      ** Identification Type                                                                AR740749
                                                                                            AR740749
     C                   EVAL      QueryFld = DDIDTP                                        AR740749
     C     QueryFld      IFEQ      '?'                                                      AR740749
     C                   CALL      'SD000762S'                                              AR740749
     C                   PARM                    Retcd                                      AR740749
     C                   PARM                    DDIDTP                                     AR740749
     C                   ENDIF                                                              AR740749
                                                                                            AR740749
      ** Issuing Country

     C                   MOVEL     DDISCT        QueryFld
     C     QueryFld      IFEQ      '?'
     C                   CALL      'SD0180S'
     C                   PARM                    Retcd
     C                   PARM                    DDISCT
     C                   ENDIF

      ** Place of Birth - Country

     C                   MOVEL     DDBTHC        QueryFld
     C     QueryFld      IFEQ      '?'
     C                   CALL      'SD0180S'
     C                   PARM                    Retcd
     C                   PARM                    DDBTHC
     C                   ENDIF

      ** Country of Residence

     C                   MOVEL     DDCOLC        QueryFld
     C     QueryFld      IFEQ      '?'
     C                   CALL      'SD0180S'
     C                   PARM                    Retcd
     C                   PARM                    DDCOLC
     C                   ENDIF

      *                                                                                       CER047
      ** Country of Domicile                                                                  CER047
      *                                                                                       CER047
     C                   IF        CER047 = 'Y'                                               CER047
      *                                                                                       CER047
     C                   EVAL      QueryFld = DDCTYD                                          CER047
     C     QueryFld      IFEQ      '?'                                                        CER047
     C                   CALL      'SD0180S'                                                  CER047
     C                   PARM                    Retcd                                        CER047
     C                   PARM                    DDCTYD                                       CER047
     C                   ENDIF                                                                CER047
      *                                                                                       CER047
      ** Country of Citizenship                                                               CER047
      *                                                                                       CER047
     C                   EVAL      QueryFld = DDCTYC                                          CER047
     C     QueryFld      IFEQ      '?'                                                        CER047
     C                   CALL      'SD0180S'                                                  CER047
     C                   PARM                    Retcd                                        CER047
     C                   PARM                    DDCTYC                                       CER047
     C                   ENDIF                                                                CER047
      *                                                                                       CER047
      ** Local Industry Code                                                                  CER047
      *                                                                                       CER047
     C                   EVAL      QueryFld = DDINDC                                          CER047
     C     QueryFld      IFEQ      '?'                                                        CER047
     C                   CALL      'SD0100S'                                                  CER047
     C                   PARM                    Retcd                                        CER047
     C                   PARM                    DDINDC                                       CER047
     C                   ENDIF                                                                CER047
      *                                                                                       CER047
      ** Spouse Reference                                                                     CER047
      *                                                                                       CER047
     C                   EVAL      QueryFld = DDSREF                                          CER047
      *                                                                                       CER047
     C     QueryFld      IFEQ      '?'                                                        CER047
      *                                                                                       CER047
     C                   CALL      'SD0010S'                                                  CER047
     C                   PARM                    Retcd                                        CER047
     C                   PARM                    DDSREF                                       CER047
      *                                                                                       CER047
     C                   IF        Retcd <> *BLANKS                                           CER047
     C                   CALL      'SD000020S'                                                CER047
     C                   PARM                    Retcd                                        CER047
     C                   PARM                    DDSREF                                       CER047
     C                   ENDIF                                                                CER047
      *                                                                                       CER047
     C                   ENDIF                                                                CER047
      *                                                                                       CER047
     C                   ENDIF                                                                CER047
      *                                                                                       CER054
      ** State Code & Religious Affiliation                                                   CER054
      *                                                                                       CER054
     C                   IF        CER048 = 'Y' AND                                           CER054
     C                             CER054 = 'Y'                                               CER054
      *                                                                                       CER054
     C                   EVAL      QueryFld = DDSTCD                                          CER054
     C     QueryFld      IFEQ      '?'                                                        CER054
     C                   CALL      'SD000030S'                                                CER054
     C                   PARM                    Retcd                                        CER054
     C                   PARM                    DDSTCD                                       CER054
     C                   ENDIF                                                                CER054
      *                                                                                       CER054
     C                   EVAL      QueryFld = DDRLAF                                          CER054
     C     QueryFld      IFEQ      '?'                                                        CER054
     C                   CALL      'SD000031S'                                                CER054
     C                   PARM                    Retcd                                        CER054
     C                   PARM                    DDRLAF                                       CER054
     C                   ENDIF                                                                CER054
      *                                                                                       CER054
     C                   ENDIF                                                                CER054
      *                                                                                       CER047
     C                   ENDIF

      ** Clear message subfile
      ** Set screen error indicators off

     C                   MOVEA     @Z0           *IN(10)

      ** Set Return Keys

     C                   MOVE      *INKC         @INKC
     C                   MOVE      *INKG         @INKG
     C                   MOVE      *INKH         @INKH
     C                   MOVE      *INKJ         @INKJ
     C                   MOVE      *INKL         @INKL
     C                   MOVE      *INKX         @INKX                                        CSD093
                                                                                              232543
      ** Set up Issuing Date from the screen                                                  232543
                                                                                              232543
     C                   IF        BJDFIN = 'D'                                               232543
     C                   MOVEL     DDISDT1       DteFmtD                                      232543
     C                   MOVEL     DteD_DD       IsDteDD                                      232543
     C                   MOVEL     DteD_MM       IsDteMM                                      232543
     C                   MOVEL     DteD_YY       IsDteYY                                      232543
     C                   MOVEL     WIssDate      DDISDT                                       232543
     C                   ELSE                                                                 232543
     C                   MOVEL     DDISDT1       DteFmtM                                      232543
     C                   MOVEL     DteM_DD       IsDteDD                                      232543
     C                   MOVEL     DteM_MM       IsDteMM                                      232543
     C                   MOVEL     DteM_YY       IsDteYY                                      232543
     C                   MOVEL     WIssDate      DDISDT                                       232543
     C                   ENDIF                                                                232543

     C                   ENDSR
      *****************************************************************

      ** The following /COPY line includes the ProcMsgs subroutine
      ** to process error and warning messages.
      /COPY ZACPYSRC,MSGHNDDSP2

      *****************************************************************
      /EJECT
      *****************************************************************
      ** SRZDate2 - Format a date for output
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
      ** *INZSR - Initial processing
      *****************************************************************
     C     *Inzsr        BEGSR

      ** Parameters

     C     *Entry        PLIST

      ** INPUT PARAMETERS :
      ** Return code
      ** Custo (IN SCREEN FORMAT - Primary)
      ** Fields in error
      ** Errors
      ** Warnings
      ** Enabled key & details fields
      ** Enabled Function keys
      ** KG = Command Key 07 = Read Previous (AND KH = KEY 08 = Read Next)
      ** KJ = Command Key 10 = Delete

     C                   PARM                    RetCodeIn
     C                   PARM                    NaPrim
     C                   PARM                    OKNaPrim
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

      ** OUTPUT PARAMETERS :
      ** Function Keys
      ** Write screen with no read indicator

     C                   PARM                    @INKC
     C                   PARM                    @INKG
     C                   PARM                    @INKH
     C                   PARM                    @INKJ
     C                   PARM                    @INKL
     C                   PARM                    @INKX                                        CSD093
     C                   PARM                    WriteOnly

      ** Initialize program name

     C                   MOVEL     'SDNAHL2DP'   Dbpgm

      ** Move user and workstation ID to screen fields.

     C                   MOVEL     PsUser        Dduser
     C                   MOVEL     PsJobName     Ddwid

     C                   MOVE      *On           *In97
     C                   MOVEL     '*'           Ddpgmq

      ** Access Bank details

     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR '     Retcd
     C                   PARM      '*FIRST '     Option
     C     SDBANK        PARM      SDBANK        DSFDY

      ** Database error

     C     Retcd         IFNE      *BLANKS
     C                   MOVEL     'SDBANKPD'    Dbfile
     C                   MOVEL     '901'         Dbase
     C                   MOVEL     @OPTN         Dbkey
     C                   EXSR      SRERR
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
     C                   MOVEL     '902'         Dbase                                        CSW207
     C                   MOVEL     Option        Dbkey                                        CSW207
     C                   EXSR      SRERR                                                      CSW207
     C                   ELSE                                                                 CSW207
     C                   IF        BGN4ST = 'Y'                                               CSW207
     C                   EVAL      wPrivBank = 'Y'                                            CSW207
     C                   ENDIF                                                                CSW207
     C                   ENDIF                                                                CSW207

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
     C                   EVAL      *IN73 = *OFF                                               CER047
      *                                                                                       CER047
     C                   ELSE                                                                 CER047
      *                                                                                       CER047
     C                   EVAL      CER047 = 'N'                                               CER047
     C                   EVAL      *IN73 = *ON                                                CER047
      *                                                                                       CER047
     C                   ENDIF                                                                CER047
      *                                                                                       CER047
     C                   IF        ((PRtcd  <> *BLANKS) AND                                   CER047
     C                             (PRtcd <> '*NRF   '))                                      CER047
      *                                                                                       CER047
     C     *LOCK         IN        LDA                                                        CER047
     C                   EVAL      DBase =  903                                               CER047
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
     C                   EVAL      *IN79 = *OFF                                               CER048
      *                                                                                       CER048
     C                   ELSE                                                                 CER048
      *                                                                                       CER048
     C                   EVAL      CER048 = 'N'                                               CER048
     C                   EVAL      *IN79 = *ON                                                CER048
      *                                                                                       CER048
     C                   ENDIF                                                                CER048
      *                                                                                       CER048
     C                   IF        ((PRtcd <> *BLANKS) AND                                    CER048
     C                             (PRtcd <> '*NRF   '))                                      CER048
      *                                                                                       CER048
     C     *LOCK         IN        LDA                                                        CER048
     C                   EVAL      DBase = 904                                                CER048
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
     C                   EVAL      *IN86 = *OFF                                               CER054
      *                                                                                       CER054
     C                   ELSE                                                                 CER054
      *                                                                                       CER054
     C                   EVAL      CER054 = 'N'                                               CER054
     C                   EVAL      *IN86 = *ON                                                CER054
      *                                                                                       CER054
     C                   ENDIF                                                                CER054
      *                                                                                       CER054
     C                   IF        ((PRtcd <> *BLANKS) AND                                    CER054
     C                             (PRtcd <> '*NRF   '))                                      CER054
      *                                                                                       CER054
     C     *LOCK         IN        LDA                                                        CER054
     C                   EVAL      DBase = 905                                                CER054
     C                   EVAL      DBkey =  'CER054'                                          CER054
     C                   EVAL      DBfile = 'SCSARDPD'                                        CER054
     C                   OUT       LDA                                                        CER054
     C                   EXSR      *PSSR                                                      CER054
      *                                                                                       CER054
     C                   ENDIF                                                                CER054

     C                   IF        CER047 = 'Y' OR CER048 = 'Y'                             BUG23642
     C                   EVAL      *IN88 = *ON                                              BUG23642
     C                   ELSE                                                               BUG23642
     C                   EVAL      *IN88 = *OFF                                             BUG23642
     C                   ENDIF                                                              BUG23642

      ** The following /COPY line sets up the fixed data for SD *DSP
      ** functions for the message handler, ZAMSGHNDLE.
     D/COPY SDCPYSRC,MSGHNDDATA

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** SRERR - Exception errors                                     *
      *****************************************************************
     C     SRERR         BEGSR

     C                   MOVEL     'SDNAHL2DP'   Dbpgm
     C                   MOVE      *On           *InU7
     C                   MOVE      *On           *InU8
     C                   MOVE      *On           *InLR

     C                   DUMP

      **  Terminte the program

     C                   RETURN

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
(c) Finastra International Limited 2011
** @Z0
000000000000000000000000000000000000000000000000000000000000
