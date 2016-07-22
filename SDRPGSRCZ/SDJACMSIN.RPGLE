     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Joint A/c Member Details Screen Input')       *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDJACMSIN - Midas SD Joint Account Member Details Screen     *
      *              Input                                            *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2004            *
      *                                                               *
      *  Last Amend No. CER071             Date 01Aug16               *
      *  Prev Amend No. MD027327           Date 03Jun14               *
      *                 MD027198           Date 26May14               *
      *                 MD026549           Date 12May14               *
      *                 CGL132             Date 01May13               *
      *                 CER059             Date 19Jul10               *
      *                 BUG24730           Date 07Jul09               *
      *                 BUG23732           Date 23Apr09               *
      *                 CER048             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 BUG15196           Date 31Oct07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 233965             Date 06Jun05               *
      *                 232543             Date 30Mar05               *
      *                 CGL031  *CREATE    Date 05Jul04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER071 - BAIS - Legal Form field (Recompile)                 *
      *  MD027327 - US Green Card System Value did not Update         *
      *           - Applied fix MD027125                              *
      *  MD027198 - SD00732A updates are not committed                *
      *  MD026549 - Incorrect error messages/warning message in Joint *
      *             Account Member Maintenance                        *
      *  CGL132 - FATCA Phase 1 - Customers' Identification and       *
      *           Classification - Master                             *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG24730 - Changes made are rolled back when user logs out   *
      *  BUG23732 - Joint Account Threshold (Recompile)               *
      *  CER048 - German Features - Taxes (Recompile)                 *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  BUG15196 - Disable validation of Investment Proportion Field *
      *             if CGL031, CGL032 or PrivBank is off              *
      *  233965 - Unable to exit Joint A/c Member Details             *
      *           Maintenance.                                        *
      *  232543 - Fix to CGL031                                       *
      *  CGL031 - Taxation of Savings Income                          *
      *                                                               *
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

     FSDJACCL1  IF   E           K DISK    INFSR(*PSSR)
      ** Midas SD Joint A/c Member Details by Joint A/c No./Customer No.

     FSDACUSL1  IF   E           K DISK    INFSR(*PSSR)                                     MD026549
      ** Midas SD Additional Customer Details by Customer Number                            MD026549
                                                                                            MD026549
      *****************************************************************
      /EJECT
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

      **---------------------------------------------------------------
      ** Program Status Data Structure
     D/COPY ZACPYSRC,PSDS
      **---------------------------------------------------------------

      **---------------------------------------------------------------
      ** Standard D-specs
     D/COPY ZACPYSRC,STD_D_SPEC
      **---------------------------------------------------------------

      **---------------------------------------------------------------
      ** API Validation Error Array Declarations
     D/COPY ZACPYSRC,ERR_ARRAYS
      **---------------------------------------------------------------

      *****************************************************************
      /EJECT
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ Named Constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

      ** Customer Number Array
     D PACUST          S              6A   DIM(100)

      ** Non-a/c Holder Array
     D PANAHO          S             10A   DIM(100)

      ** Investment Proportion Array
     D PAINVP          S             10A   DIM(100)

      ** Prime A/c Holder Array                                                               232543
     D PAPAHO          S              1A   DIM(100)                                           232543
                                                                                              232543
      ** Prime A/c Holder for Tax Array
     D PAPAHT          S              1A   DIM(100)

      ** Joint A/c Member Details - Screen Format
     D JAcMScrFmt    E DS                  EXTNAME(SDJACMPD)

      ** Previous Joint A/c Member Details - Screen Format
     D PrvJAcMScr    E DS                  EXTNAME(SDJACMPD) PREFIX(PS:2)

      ** Joint A/c Member Details - File Format
     D JAcMFilFmt    E DS                  EXTNAME(SDJACCPD)

      ** OK - Joint A/c Member Details
     D OKJAcMDets    E DS                  EXTNAME(SDEJACMPD)

      ** Valid Joint A/c Member Details Layout From/To Caller
     D ValidJAcM     E DS                  EXTNAME(SDVJACMPD)

      ** Bank Details Data Structure
     D SDBANK        E DS                  EXTNAME(SDBANKPD)

      ** Short Access Object Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *                                                                                     BUG15196
      ** External DS for Midas modules details                                              BUG15196
     D SDMMOD        E DS                  Extname(SDMMODPD)                                BUG15196

      ** Override Database Table                                                              CGL132
     D ##OV1           S             50    DIM(1) CTDATA PERRCD(1)                            CGL132
     D ##OV2           S             50    DIM(1) CTDATA PERRCD(1)                            CGL132
     D ##OV3           S             50    DIM(1) CTDATA PERRCD(1)                          MD027125
     D ##OV4           S             50    DIM(1) CTDATA PERRCD(1)                          MD027125
     D ##OV5           S             50    DIM(1) CTDATA PERRCD(1)                          MD027125
     D ##OV6           S             50    DIM(1) CTDATA PERRCD(1)                          MD027125
      ** +--------------------------------------+
      ** ¦ Declared Variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      ** Access Object Parameters
     D PRtCd           S              7A
     D POptn           S              7A

      ** API Parameters
     D PRetCode        S             10A
     D PDACTN          S              1A
     D PDJANO          S              6A
     D PSFACT          S              8A
     D OKACTN          S              1A
     D POPSEL          S              1A
     D PJASEL          S              6A
     D PDACTD          S              1A
     D PCUSEL          S              6A
     D PNASEL          S             10A
     D PDFOID          S             20A
     D PDREPA          S              1A
     D PDTMST          S               Z
     D PINKC           S              1A
     D PINKE           S              1A
     D PINKI           S              1A
     D PINKL           S              1A
     D POprMode        S              6A
     D PResMode        S              1A
     D PDFRNT          S             20A
     D PDCUST          S              6A
     D PDNAHO          S             10A
     D PDMSGID         S              7A
     D PCvtMode        S              6A
     D PValMode        S              6A
     D PSARD           S              6A                                                    BUG15196

      ** Key Fields
     D KJANo           S                   LIKE(JCJANO)

      ** Working Variables
     D WSCRN           S              1A
     D WActn           S              1A
     D WB1SfA          S              1A
     D WB1SfC          S              5P 0
     D WB1SfE          S              1A
     D WB2SfA          S              1A
     D WB2SfC          S              5P 0
     D WB2SfE          S              1A
     D WVDetE          S              1A
     D Ix              S              3P 0
     D WIx             S              3P 0
     D WArrIdx         S              3P 0
     D WOKInvP         S              1A
     D WOutofB         S              1A
     D WRecUpd         S              1A
     D CGL031          S              1A   INZ(' ')                                         BUG15196
     D CGL032          S              1A   INZ(' ')                                         BUG15196
     D PrivBank        S              1A   INZ(' ')                                         BUG15196

     D PReturn         S              7A                                                      CGL132
     D PTranID         S             10A                                                      CGL132
     D PSource         S              1A                                                      CGL132
     D PClass          S              5A                                                      CGL132
     D PRepType        S              1A                                                      CGL132
     D PTMode          S              1A                                                      CGL132
     D WMsgLen         S             15P 5 INZ(50)                                            CGL132
                                                                                              CGL132
     D CGL132          S              1A   INZ(' ')                                           CGL132
     D KAcus           S                   LIKE(JCCUST)                                     MD026549
      *****************************************************************
      /EJECT
      *****************************************************************

      ** +---------------- Start of Main Processing ------------------+
      ** ¦                                                            ¦
      ** ¦  *INZSR is automatically executed at program activation.   ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+

      ** Browse 1 Screen

     C                   IF        WSCRN = '1'
     C                   EXSR      SR1BwScr
     C                   ENDIF

      ** Browse 2 Screen

     C                   IF        WSCRN = '2'
     C                   EXSR      SR2BwScr
     C                   ENDIF

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SR1BwScr - Manages the Browse 1 Screen.                      *
      *                                                               *
      *****************************************************************
     C     SR1BwScr      BEGSR

     C                   DOW       WSCRN = '1'

     C                   SELECT

      ** Build Subfile

     C                   WHEN      WB1SfA = 'B'
     C                   EXSR      SRBldBr1

      ** Refresh Subfile

     C                   WHEN      WB1SfA = 'F'
     C                   EXSR      SRRefBr1

      ** Read Next Browse Subfile Record

     C                   WHEN      WB1SfA = 'R'
     C                   EXSR      SRRdNBr1

     C                   ENDSL

     C                   ENDDO

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SR2BwScr - Manages the Browse 2 Screen.                      *
      *                                                               *
      *****************************************************************
     C     SR2BwScr      BEGSR

     C                   EVAL      PSFACT = '*READ   '
     C                   EXSR      SRJAcM1Bw

     C                   DOW       PJASEL <> *BLANKS

     C                   EVAL      WSCRN = '2'

     C                   IF        POPSEL <> *BLANK

     C                   EVAL      PDACTN = POPSEL
     C                   EVAL      PDJANO = PJASEL
     C                   EVAL      PDCUST = *BLANKS
     C                   EVAL      PDNAHO = *BLANKS
     C                   EXSR      SRJAcMRtv

     C                   DOW       WSCRN = '2'

     C                   SELECT

      ** Build Subfile

     C                   WHEN      WB2SfA = 'B'
     C                   EXSR      SRBldBr2

      ** Refresh Subfile

     C                   WHEN      WB2SfA = 'F'
     C                   EXSR      SRRefBr2

      ** Read Next Browse Subfile Record

     C                   WHEN      WB2SfA = 'R'
     C                   EXSR      SRRdNBr2

     C                   ENDSL

     C                   ENDDO

     C                   ENDIF

     C                   EVAL      PSFACT = '*READ   '
     C                   EXSR      SRJAcM1Bw
     C                   ENDDO

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRInsScr - Manages the Insert Screen.                        *
      *                                                               *
      *****************************************************************
     C     SRInsScr      BEGSR

     C                   EVAL      PDACTN = 'I'

     C                   DOW       WSCRN = '3'

     C                   SELECT

      ** Build Subfile

     C                   WHEN      WB2SfA = 'B'
     C                   EXSR      SRBldIns

      ** Refresh Subfile

     C                   WHEN      WB2SfA = 'F'
     C                   EXSR      SRRefIns

      ** Read Next Browse Subfile Record

     C                   WHEN      WB2SfA = 'R'
     C                   EXSR      SRRdNIns

     C                   ENDSL

     C                   ENDDO

     C                   EVAL      PDACTN = 'A'

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRBldBr1 - Builds the Browse 1 subfile.                      *
      *                                                               *
      *****************************************************************
     C     SRBldBr1      BEGSR

     C                   EVAL      PSFACT = '*BUILD  '
     C                   EXSR      SRJAcM1Bw

      ** Exit on F03.

     C                   IF        PINKC = *ON
     C                   EXSR      SREndPgm
     C                   ENDIF

      ** Refresh on F05.

     C                   IF        PINKE = *ON
     C                   EVAL      WB1SfA = 'F'
     C                   LEAVESR
     C                   ENDIF

     C                   EVAL      WB1SfA = 'R'

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRBldBr2 - Builds the Browse 2 subfile.                      *
      *                                                               *
      *****************************************************************
     C     SRBldBr2      BEGSR

     C                   EVAL      PSFACT = '*BUILD  '
     C                   EXSR      SRJAcM2Bw

      ** Exit on F03.

     C                   IF        PINKC = *ON

      ** Check first if there are pending errors on screen.

     C                   IF        PDACTN <> 'E'
     C                   EXSR      SRValDt2

     C                   IF        WVDetE = 'N'

     C                   EXSR      SRUpdDt1
                                                                                              CGL132
     C                   IF        CGL132 = 'Y' AND                                           CGL132
     C                             CGL133 = 'N'                                               CGL132
                                                                                              CGL132
     C                   CALL      'QCMDEXC'                                                  CGL132
     C                   PARM                    ##OV1                                        CGL132
     C                   PARM                    WMsgLen                                      CGL132
                                                                                            MD027125
     C                   CALL      'QCMDEXC'                                                MD027125
     C                   PARM                    ##OV3                                      MD027125
     C                   PARM                    WMsgLen                                    MD027125
                                                                                            MD027125
     C                   CALL      'QCMDEXC'                                                MD027125
     C                   PARM                    ##OV5                                      MD027125
     C                   PARM                    WMsgLen                                    MD027125
                                                                                              CGL132
     C**********         CALL      'SD000732'                                        CGL132 MD027125
     C                   CALL      'SD000732A'                                              MD027125
     C                   PARM      *BLANKS       PReturn                                      CGL132
     C                   PARM      PDJANO        PTranID                                      CGL132
     C                   PARM      'J'           PSource                                      CGL132
     C                   PARM      *BLANKS       PClass                                       CGL132
     C                   PARM      *BLANKS       PCLass                                       CGL132
     C                   PARM      ' '           PRepType                                     CGL132
     C                   PARM      'A'           PTMode                                       CGL132
                                                                                              CGL132
     C                   COMMIT                                                             MD027198
                                                                                            MD027198
     C                   CALL      'QCMDEXC'                                                  CGL132
     C                   PARM                    ##OV2                                        CGL132
     C                   PARM                    WMsgLen                                      CGL132
                                                                                            MD027125
     C                   CALL      'QCMDEXC'                                                MD027125
     C                   PARM                    ##OV4                                      MD027125
     C                   PARM                    WMsgLen                                    MD027125
                                                                                            MD027125
     C                   CALL      'QCMDEXC'                                                MD027125
     C                   PARM                    ##OV6                                      MD027125
     C                   PARM                    WMsgLen                                    MD027125
                                                                                              CGL132
     C                   ENDIF                                                                CGL132

     C                   EXSR      SREndPgm
     C                   ELSE
     C                   EVAL      PDMSGID = 'SDM0133'
     C                   EVAL      WB2SfA = 'B'
     C                   ENDIF

     C                   ELSE
     C                   EXSR      SREndPgm
     C                   ENDIF

     C                   LEAVESR
     C                   ENDIF

      ** Refresh on F05.

     C                   IF        PINKE = *ON
     C                   EVAL      WB2SfA = 'F'
     C                   LEAVESR
     C                   ENDIF

      ** Add on F09.

     C                   IF        PINKI = *ON

      ** Check first if there are pending errors on screen.

     C                   EXSR      SRValDt2

     C                   IF        WVDetE = 'N'

     C                   IF        PDACTN <> 'E'
     C                   EXSR      SRUpdDt1
     C                   ENDIF

     C                   EVAL      WSCRN = '3'
     C                   EVAL      WB2SfA = 'B'
     C                   EXSR      SRInsScr
     C                   ELSE
     C                   EVAL      PDMSGID = 'SDM0133'
     C                   EVAL      WB2SfA = 'B'
     C                   ENDIF

     C                   LEAVESR
     C                   ENDIF

      ** Return to the previous screen on F12.

     C                   IF        PINKL = *ON

      ** Check first if there are pending errors on screen.

     C                   IF        PDACTN <> 'E'
     C                   EXSR      SRValDt2

     C                   IF        WVDetE = 'N'

     C                   EXSR      SRUpdDt1

     C                   EVAL      WSCRN = '1'
     C                   EVAL      WB1SfA = 'B'
     C                   ELSE
     C                   EVAL      PDMSGID = 'SDM0133'
     C                   EVAL      WB2SfA = 'B'
     C                   ENDIF
                                                                                              CGL132
     C                   IF        CGL132 = 'Y' AND                                           CGL132
     C                             CGL133 = 'N'                                               CGL132
                                                                                              CGL132
     C                   CALL      'QCMDEXC'                                                  CGL132
     C                   PARM                    ##OV1                                        CGL132
     C                   PARM                    WMsgLen                                      CGL132
                                                                                            MD027125
     C                   CALL      'QCMDEXC'                                                MD027125
     C                   PARM                    ##OV3                                      MD027125
     C                   PARM                    WMsgLen                                    MD027125
                                                                                            MD027125
     C                   CALL      'QCMDEXC'                                                MD027125
     C                   PARM                    ##OV5                                      MD027125
     C                   PARM                    WMsgLen                                    MD027125
                                                                                              CGL132
     C**********         CALL      'SD000732'                                        CGL132 MD027125
     C                   CALL      'SD000732A'                                              MD027125
     C                   PARM      *BLANKS       PReturn                                      CGL132
     C                   PARM      PDJANO        PTranID                                      CGL132
     C                   PARM      'J'           PSource                                      CGL132
     C                   PARM      *BLANKS       PClass                                       CGL132
     C                   PARM      *BLANKS       PCLass                                       CGL132
     C                   PARM      ' '           PRepType                                     CGL132
     C                   PARM      'A'           PTMode                                       CGL132
                                                                                              CGL132
     C                   CALL      'QCMDEXC'                                                  CGL132
     C                   PARM                    ##OV2                                        CGL132
     C                   PARM                    WMsgLen                                      CGL132
                                                                                            MD027125
     C                   CALL      'QCMDEXC'                                                MD027125
     C                   PARM                    ##OV4                                      MD027125
     C                   PARM                    WMsgLen                                    MD027125
                                                                                            MD027125
     C                   CALL      'QCMDEXC'                                                MD027125
     C                   PARM                    ##OV6                                      MD027125
     C                   PARM                    WMsgLen                                    MD027125
                                                                                              CGL132
     C                   ENDIF                                                                CGL132

     C                   ELSE
     C                   EVAL      WSCRN = '1'
     C                   EVAL      WB1SfA = 'B'
     C                   ENDIF

     C                   LEAVESR
     C                   ENDIF

     C                   EVAL      WB2SfA = 'R'

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRBldIns - Builds the Insert subfile.                        *
      *                                                               *
      *****************************************************************
     C     SRBldIns      BEGSR

     C                   EVAL      PSFACT = '*BUILD  '
     C                   EXSR      SRJAcM2Bw

      ** Exit on F03.

     C                   IF        PINKC = *ON
     C                   EXSR      SREndPgm
     C                   ENDIF

      ** Refresh on F05.

     C                   IF        PINKE = *ON
     C                   EVAL      WB2SfA = 'F'
     C                   LEAVESR
     C                   ENDIF

      ** Return to the previous screen on F12.

     C                   IF        PINKL = *ON
     C                   EVAL      WSCRN = '2'
     C                   EVAL      WB2SfA = 'B'
     C                   LEAVESR
     C                   ENDIF

     C                   EVAL      WB2SfA = 'R'

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRefBr1 - Refreshes the Browse 1 subfile.                   *
      *                                                               *
      *****************************************************************
     C     SRRefBr1      BEGSR

     C                   EVAL      PSFACT = '*REFRESH'
     C                   EXSR      SRJAcM1Bw

     C                   EVAL      WB1SfA = 'B'

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRefBr2 - Refreshes the Browse 2 subfile.                   *
      *                                                               *
      *****************************************************************
     C     SRRefBr2      BEGSR

     C                   EVAL      PSFACT = '*REFRESH'
     C                   EXSR      SRJAcM2Bw

     C                   EVAL      WB2SfA = 'B'

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRefIns - Refreshes the Insert subfile.                     *
      *                                                               *
      *****************************************************************
     C     SRRefIns      BEGSR

     C                   EVAL      PSFACT = '*REFRESH'
     C                   EXSR      SRJAcM2Bw

     C                   EVAL      WB2SfA = 'B'

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDspBr1 - Displays the Browse 1 subfile.                    *
      *                                                               *
      *****************************************************************
     C     SRDspBr1      BEGSR

     C                   EVAL      PSFACT = '*DISPLAY'
     C                   EXSR      SRJAcM1Bw

     C                   SELECT

      ** Exit on F03.

     C                   WHEN      PINKC = *ON
     C                   EXSR      SREndPgm

      ** Refresh on F05.

     C                   WHEN      PINKE = *ON
     C                   EVAL      WB1SfA = 'F'

     C                   ENDSL

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDspBr2 - Displays the Browse 2 subfile.                    *
      *                                                               *
      *****************************************************************
     C     SRDspBr2      BEGSR

     C                   EVAL      PSFACT = '*DISPLAY'
     C                   EXSR      SRJAcM2Bw

     C                   SELECT

      ** Exit on F03.

     C                   WHEN      PINKC = *ON

      ** Check first if there are pending errors on screen.

     C                   EXSR      SRValDt2

     C                   IF        WVDetE = 'N'

     C                   IF        PDACTN <> 'E'
     C                   EXSR      SRUpdDt1
     C                   ENDIF

     C                   EXSR      SREndPgm
     C                   ELSE
     C                   EVAL      PDMSGID = 'SDM0133'
     C                   EVAL      WB2SfA = 'B'
     C                   ENDIF

      ** Refresh on F05.

     C                   WHEN      PINKE = *ON
     C                   EVAL      WB2SfA = 'F'

      ** Add on F09.

     C                   WHEN      PINKI = *ON

      ** Check first if there are pending errors on screen.

     C                   EXSR      SRValDt2

     C                   IF        WVDetE = 'N'

     C                   IF        PDACTN <> 'E'
     C                   EXSR      SRUpdDt1
     C                   ENDIF

     C                   EVAL      WSCRN = '3'
     C                   EVAL      WB2SfA = 'B'
     C                   EXSR      SRInsScr
     C                   ELSE
     C                   EVAL      PDMSGID = 'SDM0133'
     C                   EVAL      WB2SfA = 'B'
     C                   ENDIF

      ** Return to the previous screen on F12.

     C                   WHEN      PINKL = *ON

      ** Check first if there are pending errors on screen.

     C                   EXSR      SRValDt2

     C                   IF        WVDetE = 'N'

     C                   IF        PDACTN <> 'E'
     C                   EXSR      SRUpdDt1
     C                   ENDIF

     C                   EVAL      WSCRN = '1'
     C                   EVAL      WB1SfA = 'B'
     C                   ELSE
     C                   EVAL      PDMSGID = 'SDM0133'
     C                   EVAL      WB2SfA = 'B'
     C                   ENDIF

     C                   ENDSL

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDspIns - Displays the Insert subfile.                      *
      *                                                               *
      *****************************************************************
     C     SRDspIns      BEGSR

     C                   EVAL      PSFACT = '*DISPLAY'
     C                   EXSR      SRJAcM2Bw

     C                   SELECT

      ** Exit on F03.

     C                   WHEN      PINKC = *ON
     C                   EXSR      SREndPgm

      ** Refresh on F05.

     C                   WHEN      PINKE = *ON
     C                   EVAL      WB2SfA = 'F'

      ** Return to the previous screen on F12.

     C                   WHEN      PINKL = *ON
     C                   EVAL      WSCRN = '2'
     C                   EVAL      WB2SfA = 'B'

     C                   ENDSL

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRdNBr1 - Reads the next Browse 1 subfile record.           *
      *                                                               *
      *****************************************************************
     C     SRRdNBr1      BEGSR

     C                   EVAL      WB1SfE = 'N'
     C                   EVAL      WB1SfC = *ZERO
     C                   EXSR      SRResErA

     C                   EXSR      SRResErF
     C                   EVAL      PSFACT = '*READ   '
     C                   EXSR      SRJAcM1Bw

     C                   DOW       PJASEL <> *BLANKS

     C                   IF        POPSEL <> *BLANK

      ** Validate the Action Code.

     C                   EVAL      PDACTN = POPSEL
     C                   EVAL      PDJANO = PJASEL
     C                   EVAL      PDCUST = *BLANKS
     C                   EVAL      PDNAHO = *BLANKS
     C                   EXSR      SRJAcMRtv

     C                   IF        Ix <> *ZERO
     C                   EVAL      WB1SfE = 'Y'
     C                   ENDIF

     C                   EVAL      WB1SfC = WB1SfC + 1

     C                   ENDIF

     C                   EVAL      PSFACT = '*UPDATE '
     C                   EXSR      SRJAcM1Bw

     C                   EXSR      SRResErF
     C                   EVAL      PSFACT = '*READ   '
     C                   EXSR      SRJAcM1Bw
     C                   ENDDO

      ** Display the subfile if errors have occurred.

     C                   IF        WB1SfE = 'Y'
     C                   EXSR      SRDspBr1
     C                   ELSE

      ** Build the subfile if no valid selection has been made. Proceed
      ** to the Browse 2 screen otherwise.

     C                   IF        WB1SfC = *ZERO
     C                   EVAL      WB1SfA = 'B'
     C                   ELSE
     C                   EVAL      WSCRN = '2'
     C                   EVAL      WB2SfA = 'B'
     C                   ENDIF

     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRdNBr2 - Reads the next Browse 2 subfile record.           *
      *                                                               *
      *****************************************************************
     C     SRRdNBr2      BEGSR

     C                   EVAL      WB2SfE = 'N'
     C                   EVAL      WB2SfC = *ZERO
     C                   EXSR      SRResErA

     C                   EXSR      SRResErF
     C                   EVAL      PSFACT = '*READ   '
     C                   EXSR      SRJAcM2Bw

     C                   DOW       PJASEL <> *BLANKS

      ** Check first if we have details to validate.

     C                   IF        %SUBST(JAcMScrFmt:8) <> *BLANKS

     C                   IF        POPSEL <> *BLANK

      ** Validate the Action Code.

     C                   EVAL      PDACTN = POPSEL
     C                   EVAL      PDJANO = PJASEL
     C                   EVAL      PDCUST = PCUSEL
     C                   EVAL      PDNAHO = PNASEL
     C                   EXSR      SRJAcMRtv

     C                   IF        Ix <> *ZERO
     C                   EVAL      WB2SfE = 'Y'
     C                   ENDIF

     C                   ENDIF

     C                   EVAL      WB2SfC = WB2SfC + 1

     C                   ENDIF

     C                   EVAL      PSFACT = '*UPDATE '
     C                   EXSR      SRJAcM2Bw

     C                   EXSR      SRResErF
     C                   EVAL      PSFACT = '*READ   '
     C                   EXSR      SRJAcM2Bw
     C                   ENDDO

      ** Display the subfile if errors have occurred.

     C                   IF        WB2SfE = 'Y'
     C                   EXSR      SRDspBr2
     C                   ELSE

      ** Build the subfile if no changes were made. Validate the
      ** Joint A/c Member details otherwise.

     C                   IF        WB2SfC = *ZERO
     C                   EVAL      WB2SfA = 'B'
     C                   ELSE
     C                   EXSR      SRValDt1
     C                   ENDIF

     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRdNIns - Reads the next Insert subfile record.             *
      *                                                               *
      *****************************************************************
     C     SRRdNIns      BEGSR

     C                   EVAL      WB2SfE = 'N'
     C                   EVAL      WB2SfC = *ZERO
     C                   EXSR      SRResErA

     C                   EXSR      SRResErF
     C                   EVAL      PSFACT = '*READ   '
     C                   EXSR      SRJAcM2Bw

     C                   DOW       PJASEL <> *BLANKS

      ** Check first if we have details to validate.

     C                   IF        %SUBST(JAcMScrFmt:8) <> *BLANKS

     C                   IF        POPSEL <> *BLANK

      ** Validate the Action Code.

     C                   EVAL      PDACTN = POPSEL
     C                   EVAL      PDJANO = PJASEL
     C                   EVAL      PDCUST = PCUSEL
     C                   EVAL      PDNAHO = PNASEL
     C                   EXSR      SRJAcMRtv

     C                   IF        Ix <> *ZERO
     C                   EVAL      WB2SfE = 'Y'
     C                   ENDIF

     C                   ENDIF

     C                   EVAL      WB2SfC = WB2SfC + 1

     C                   ENDIF

     C                   EVAL      PSFACT = '*UPDATE '
     C                   EXSR      SRJAcM2Bw

     C                   EXSR      SRResErF
     C                   EVAL      PSFACT = '*READ   '
     C                   EXSR      SRJAcM2Bw
     C                   ENDDO

      ** Display the subfile if errors have occurred.

     C                   IF        WB2SfE = 'Y'
     C                   EXSR      SRDspIns
     C                   ELSE

      ** Build the subfile if no changes were made. Validate the
      ** Joint A/c Member details otherwise.

     C                   IF        WB2SfC = *ZERO
     C                   EVAL      WB2SfA = 'B'
     C                   ELSE
     C                   EXSR      SRValDt1
     C                   ENDIF

     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValDt1 - Validates the Joint A/c Member details.           *
      *                                                               *
      *****************************************************************
     C     SRValDt1      BEGSR

     C                   EVAL      WArrIdx = *ZERO
     C                   CLEAR                   PACUST
     C                   CLEAR                   PANAHO
     C                   CLEAR                   PAINVP
     C                   CLEAR                   PAPAHT
     C                   CLEAR                   PAPAHO                                       232543

     C                   EVAL      PValMode = '*FIELD'

     C                   EVAL      WVDetE = 'N'
     C                   EXSR      SRResErA

     C                   EXSR      SRResErF
     C                   EVAL      PSFACT = '*READ   '
     C                   EXSR      SRJAcM2Bw

     C                   DOW       PJASEL <> *BLANKS

      ** Check first if we have details to validate.

     C                   IF        %SUBST(JAcMScrFmt:8) <> *BLANKS

      ** Validate Joint A/c Member details.

     C                   EXSR      SRJAcMVal

     C                   IF        Ix <> *ZERO
     C                   EVAL      WVDetE = 'Y'
     C                   ENDIF

      ** Save Joint A/c Holder details for group processing.

     C                   EVAL      WArrIdx = WArrIdx + 1

     C                   IF        WArrIdx <= %ELEM(PACUST)
     C                   EVAL      PACUST(WArrIdx) = DDCUST
     C                   EVAL      PANAHO(WArrIdx) = DDNAHO
     C                   EVAL      PAINVP(WArrIdx) = DDINVP
     C                   EVAL      PAPAHT(WArrIdx) = DDPAHT
     C                   EVAL      PAPAHO(WArrIdx) = DDPAHO                                   232543
     C                   ENDIF

     C                   EVAL      PSFACT = '*UPDATE '
     C                   EXSR      SRJAcM2Bw

     C                   ENDIF

     C                   EXSR      SRResErF
     C                   EVAL      PSFACT = '*READ   '
     C                   EXSR      SRJAcM2Bw
     C                   ENDDO

      ** Validate Joint A/c Holder group.

     C                   IF        WVDetE = 'N'
     C                   EXSR      SRValGr1
     C                   ENDIF

      ** Display the subfile if errors have occurred. Update the database
      ** otherwise.

     C                   IF        WVDetE = 'Y'

     C                   SELECT

     C                   WHEN      WSCRN = '2'
     C                   EXSR      SRDspBr2

     C                   WHEN      WSCRN = '3'
     C                   EXSR      SRDspIns

     C                   ENDSL

     C                   ELSE
     C                   EXSR      SRUpdDt1
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValDt2 - Validates the Joint A/c Member details.           *
      *                                                               *
      *****************************************************************
     C     SRValDt2      BEGSR

     C                   EVAL      WArrIdx = *ZERO
     C                   CLEAR                   PACUST
     C                   CLEAR                   PANAHO
     C                   CLEAR                   PAINVP
     C                   CLEAR                   PAPAHT
     C                   CLEAR                   PAPAHO                                       232543

     C                   EVAL      PValMode = '*FIELD'

     C                   EVAL      WVDetE = 'N'
     C                   EXSR      SRResErA

     C                   EXSR      SRResErF
     C                   EVAL      PSFACT = '*READ   '
     C                   EXSR      SRJAcM2Bw

     C                   DOW       PJASEL <> *BLANKS

      ** Check first if we have details to validate.

     C                   IF        %SUBST(JAcMScrFmt:8) <> *BLANKS

      ** Validate Joint A/c Member details.

     C                   EXSR      SRJAcMVal

     C                   IF        Ix <> *ZERO
     C                   EVAL      WVDetE = 'Y'
     C                   ENDIF

      ** Save Joint A/c Holder details for group processing.

     C                   EVAL      WArrIdx = WArrIdx + 1

     C                   IF        WArrIdx <= %ELEM(PACUST)
     C                   EVAL      PACUST(WArrIdx) = DDCUST
     C                   EVAL      PANAHO(WArrIdx) = DDNAHO
     C                   EVAL      PAINVP(WArrIdx) = DDINVP
     C                   EVAL      PAPAHT(WArrIdx) = DDPAHT
     C                   EVAL      PAPAHO(WArrIdx) = DDPAHO                                   232543
     C                   ENDIF

     C                   EVAL      PSFACT = '*UPDATE '
     C                   EXSR      SRJAcM2Bw

     C                   ENDIF

     C                   EXSR      SRResErF
     C                   EVAL      PSFACT = '*READ   '
     C                   EXSR      SRJAcM2Bw
     C                   ENDDO

      ** Validate Joint A/c Holder group.

     C                   IF        WVDetE = 'N'
     C                             AND WArrIdx <> *ZERO                                       233965
     C                   EXSR      SRValGr2
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValGr1 - Validates the Joint A/c Holder group.             *
      *                                                               *
      *****************************************************************
     C     SRValGr1      BEGSR

     C                   EVAL      WOKInvP = 'Y'
     C                   EVAL      WArrIdx = *ZERO

     C                   SELECT

      ** Skip Investment Proportion group validation for Insert screen.

     C                   WHEN      WSCRN = '3'
     C                   EVAL      PValMode = '*SVIPG'

     C                   OTHER
     C                   EVAL      PValMode = '*GROUP'

     C                   ENDSL

     C                   EXSR      SRJAcMVal

      ** Highlight relevant fields if necessary.

     C                   IF        Ix <> *ZERO

     C                   EVAL      WVDetE = 'Y'

     C                   IF        %LOOKUP('*ERROR':PAINVP:1) <> *ZERO
     C                   EVAL      WOKInvP = 'N'
     C                   ENDIF

     C                   EXSR      SRResErF
     C                   EVAL      PSFACT = '*READ   '
     C                   EXSR      SRJAcM2Bw

     C                   DOW       PJASEL <> *BLANKS

     C                   EVAL      WArrIdx = WArrIdx + 1

     C                   IF        WArrIdx <= %ELEM(PACUST)

     C                   IF        PACUST(WArrIdx) = '*ERROR'
     C                   EVAL      OKCUST = 'N'
     C                   ENDIF

     C                   IF        PANAHO(WArrIdx) = '*ERROR'
     C                   EVAL      OKNAHO = 'N'
     C                   ENDIF

     C                   EVAL      OKINVP = WOKInvP

     C                   IF        PAPAHT(WArrIdx) = '*'
     C                   EVAL      OKPAHT = 'N'
     C                   ENDIF

     C                   IF        PAPAHO(WArrIdx) = '*'                                      232543
     C                   EVAL      OKPAHO = 'N'                                               232543
     C                   ENDIF                                                                232543
                                                                                              232543
     C                   ENDIF

     C                   EVAL      PSFACT = '*UPDATE '
     C                   EXSR      SRJAcM2Bw

     C                   EXSR      SRResErF
     C                   EVAL      PSFACT = '*READ   '
     C                   EXSR      SRJAcM2Bw
     C                   ENDDO

     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValGr2 - Validates the Joint A/c Holder group.             *
      *                                                               *
      *****************************************************************
     C     SRValGr2      BEGSR

     C                   EVAL      WOKInvP = 'Y'
     C                   EVAL      WArrIdx = *ZERO

     C                   SELECT

      ** Skip Investment Proportion group validation for Insert screen.

     C                   WHEN      WSCRN = '3'
     C                   EVAL      PValMode = '*SVIPG'

     C                   OTHER
     C                   EVAL      PValMode = '*GROUP'

     C                   ENDSL

     C                   EXSR      SRJAcMVal

     C                   IF        Ix <> *ZERO
     C                   EVAL      WVDetE = 'Y'
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRUpdDt1 - Updates the Joint A/c Member details.             *
      *                                                               *
      *****************************************************************
     C     SRUpdDt1      BEGSR

     C                   EVAL      PCvtMode = '*FILE '
     C                   EVAL      PDMSGID = *BLANKS
     C                   EVAL      WOutofB = 'N'
     C                   EVAL      WRecUpd = 'N'

     C                   EVAL      PSFACT = '*READ   '
     C                   EXSR      SRJAcM2Bw

     C                   DOW       PJASEL <> *BLANKS

      ** Convert & update Joint A/c Member details.

     C                   EVAL      DDACTN = POPSEL
     C                   EXSR      SRJAcMCvt
     C                   EVAL      JCTMST = PDTMST
     C                   EXSR      SRJAcMUpd

      ** Set message flags.

     C                   SELECT

     C                   WHEN      PRetCode = *BLANKS

     C                   IF        DDACTN = 'I' AND WSCRN = '3' OR
     C                             DDACTN = 'D'
     C                   EVAL      WOutofB = 'Y'
     C                   ENDIF
     C                   COMMIT                                                             BUG24730

     C                   WHEN      PRetCode = '*RECUPD   '
     C                   EVAL      WRecUpd = 'Y'

     C                   WHEN      PRetCode <> *BLANKS
     C                   EXSR      *PSSR

     C                   ENDSL

     C                   EVAL      PSFACT = '*READ   '
     C                   EXSR      SRJAcM2Bw
     C                   ENDDO

     C                   IF        *IN66 = *OFF                                             BUG15196
     C                   IF        WOutofB = 'Y'

      ** Check first if there are still members for this Joint A/c.

     C                   EVAL      KJANo = PDJANO
     C     KJANo         CHAIN     SDJACCL1

      ** Investment Proportion out of balance.

     C                   IF        %FOUND
                                                                                            MD026549
     C                   EVAL      KAcus = PDJANO                                           MD026549
     C     KAcus         CHAIN     SDACUSL1                                                 MD026549
     C                   IF        %FOUND(SDACUSL1)                                         MD026549
     C                             AND E5JATP = 'Y'                                         MD026549
                                                                                            MD026549
     C                   EVAL      PDMSGID = 'SDM0131'
     C                   ENDIF                                                              MD026549
     C                   ENDIF

     C                   ENDIF
     C                   ENDIF                                                              BUG15196

      ** Record updated by another workstation.

     C                   IF        WRecUpd = 'Y'
     C                   EVAL      PDMSGID = 'SDM0130'
     C                   ENDIF

      ** Display Joint A/c Member details.

     C                   EVAL      WSCRN = '2'
     C                   EVAL      WB2SfA = 'B'
     C                   EVAL      PDACTN = 'A'

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRJAcM1Bw - Joint A/c Member Details Browse 1.               *
      *                                                               *
      *****************************************************************
     C     SRJAcM1Bw     BEGSR

     C                   CALLB     'SDJACM1BW'
      **                 *********************

      **********************
      ** Input Parameters **
      **********************

      ** Return Code
     C                   PARM      *BLANKS       PRetCode

      ** Action Code
     C                   PARM                    PDACTN

      ** Joint A/c Number Pointer
     C                   PARM                    PDJANO

      ** Subfile Action
     C                   PARM                    PSFACT

      ** OK - Action Code
     C                   PARM                    OKACTN

      ** Error Fields/Message IDs/Message Data (arrays) From/To Caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr

      ** Array Index (3P0) From/To Caller
     C                   PARM                    Ix

      ***********************
      ** Output Parameters **
      ***********************

      ** Option Selected
     C                   PARM      *BLANK        POPSEL

      ** Joint A/c Number Selected
     C                   PARM      *BLANKS       PJASEL

      ** Action Code Default
     C                   PARM                    PDACTD

      ** Command Keys
     C                   PARM      *OFF          PINKC
     C                   PARM      *OFF          PINKE

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRJAcM2Bw - Joint A/c Member Details Browse 2.               *
      *                                                               *
      *****************************************************************
     C     SRJAcM2Bw     BEGSR

     C                   CALLB     'SDJACM2BW'
      **                 *********************

      **********************
      ** Input Parameters **
      **********************

      ** Return Code
     C                   PARM      *BLANKS       PRetCode

      ** Action Code
     C                   PARM                    PDACTN

      ** Joint A/c Number Pointer
     C                   PARM                    PDJANO

      ** Subfile Action
     C                   PARM                    PSFACT

      ** OK - Action Code
     C                   PARM                    OKACTN

      ** OK - Joint A/c Member Details
     C                   PARM                    OKJAcMDets

      ** Error Fields/Message IDs/Message Data (arrays) From/To Caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr

      ** Array Index (3P0) From/To Caller
     C                   PARM                    Ix

      ** Warning Fields/Message IDs/Message Data (arrays) From/To Caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr

      ** Array Index (3P0) From/To Caller
     C                   PARM                    WIx

      ** Message ID
     C                   PARM                    PDMSGID

      ***********************
      ** Output Parameters **
      ***********************

      ** Option Selected
     C                   PARM      *BLANK        POPSEL

      ** Joint A/c Number Selected
     C                   PARM      *BLANKS       PJASEL

      ** Customer Number Selected
     C                   PARM      *BLANKS       PCUSEL

      ** Non-a/c Holder Selected
     C                   PARM      *BLANKS       PNASEL

      ** Joint A/c Member Details - Screen Format
     C                   PARM                    JAcMScrFmt

      ** Joint A/c Member Front Office Transaction ID
     C                   PARM                    PDFOID

      ** Joint A/c Member Repair Location
     C                   PARM                    PDREPA

      ** Joint A/c Member Timestamp
     C                   PARM                    PDTMST

      ** Action Code Default
     C                   PARM                    PDACTD

      ** Command Keys
     C                   PARM      *OFF          PINKC
     C                   PARM      *OFF          PINKE
     C                   PARM      *OFF          PINKI
     C                   PARM      *OFF          PINKL

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRJAcMRtv - Joint A/c Member Details Retrieve.               *
      *                                                               *
      *****************************************************************
     C     SRJAcMRtv     BEGSR

     C                   CALLB     'SDJACMRTV'
      **                 *********************

      **********************
      ** Input Parameters **
      **********************

      ** Return Code
     C                   PARM      *BLANKS       PRetCode

      ** Operation Mode
     C                   PARM      *BLANKS       POprMode

      ** Response Mode
     C                   PARM      'S'           PResMode

      ** Action Code
     C                   PARM                    PDACTN

      ** Front Office Transaction ID
     C                   PARM      *BLANKS       PDFRNT

      ** Joint A/c Number
     C                   PARM                    PDJANO

      ** Customer Number
     C                   PARM                    PDCUST

      ** Non-a/c Holder
     C                   PARM                    PDNAHO

      ** Action Code Default
     C                   PARM                    PDACTD

      ***********************
      ** Output Parameters **
      ***********************

      ** Joint A/c Member Details - File Format
     C                   PARM                    JAcMFilFmt

      ** OK - Action Code
     C                   PARM                    OKACTN

      ** OK - Customer Number
     C                   PARM                    OKCUST

      ** OK - Non-a/c Holder
     C                   PARM                    OKNAHO

      ** Error Fields/Message IDs/Message Data (arrays) From/To Caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr

      ** Array Index (3P0) From/To Caller
     C                   PARM                    Ix

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRJAcMVal - Joint A/c Member Details Validate.               *
      *                                                               *
      *****************************************************************
     C     SRJAcMVal     BEGSR

     C                   CALLB     'SDJACMVAL'
      **                 *********************

      **********************
      ** Input Parameters **
      **********************

      ** Response Mode
     C                   PARM      'S'           PResMode

      ** Validate Mode
     C                   PARM                    PValMode

      ** Joint A/c Member Details - Screen Format
     C                   PARM                    JAcMScrFmt

      ** Customer Number Array
     C                   PARM                    PACUST

      ** Non-a/c Holder Array
     C                   PARM                    PANAHO

      ** Investment Proportion Array
     C                   PARM                    PAINVP

      ** Prime A/c Holder Array                                                               232543
     C                   PARM                    PAPAHO                                       232543
                                                                                              232543
      ** Prime A/c Holder for Tax Array
     C                   PARM                    PAPAHT

      ***********************
      ** Output Parameters **
      ***********************

      ** OK - Action Code
     C                   PARM                    OKACTN

      ** OK - Joint A/c Member Details
     C                   PARM                    OKJAcMDets

      ** Error Fields/Message IDs/Message Data (arrays) From/To Caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr

      ** Array Index (3P0) From/To Caller
     C                   PARM                    Ix

      ** Warning Fields/Message IDs/Message Data (arrays) From/To Caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr

      ** Array Index (3P0) From/To Caller
     C                   PARM                    WIx

      ** Valid Joint A/c Member Details Layout From/To Caller
     C                   PARM                    ValidJAcM

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRJAcMCvt - Joint A/c Member Details Convert.                *
      *                                                               *
      *****************************************************************
     C     SRJAcMCvt     BEGSR

     C                   CALLB     'SDJACMCVT'
      **                 *********************

      **********************
      ** Input Parameters **
      **********************

      ** Return Code
     C                   PARM      *BLANKS       PRetCode

      ** Convert Mode
     C                   PARM                    PCvtMode

      ***********************
      ** Output Parameters **
      ***********************

      ** Joint A/c Member Details - File Format
     C                   PARM                    JAcMFilFmt

      ** Joint A/c Member Details - Screen Format
     C                   PARM                    JAcMScrFmt

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRJAcMUpd - Joint A/c Member Details Update.                 *
      *                                                               *
      *****************************************************************
     C     SRJAcMUpd     BEGSR

     C                   CALLB     'SDJACMUPD'
      **                 *********************

      **********************
      ** Input Parameters **
      **********************

      ** Return Code
     C                   PARM      *BLANKS       PRetCode

      ** Valid Joint A/c Member Details
     C                   PARM      JAcMFilFmt    ValidJAcM

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRResErA - Resets error arrays.                              *
      *                                                               *
      *****************************************************************
     C     SRResErA      BEGSR

     C                   EVAL      FldNameArr = *BLANKS
     C                   EVAL      MsgIdArr  = *BLANKS
     C                   EVAL      MsgDtaArr = *BLANKS
     C                   EVAL      WFldNamArr = *BLANK
     C                   EVAL      WMsgIDArr  = *BLANK
     C                   EVAL      WMsgDtaArr = *BLANK
     C                   EVAL      Ix = *ZERO
     C                   EVAL      WIx = *ZERO

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRResErF - Resets error flags.                               *
      *                                                               *
      *****************************************************************
     C     SRResErF      BEGSR

     C                   EVAL      OKACTN = 'Y'
     C                   MOVE      *ALL'Y'       OKJAcMDets

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SREndPgm - Ends the program.                                 *
      *                                                               *
      *****************************************************************
     C     SREndPgm      BEGSR

     C                   EVAL      *INLR = *ON
     C                   RETURN

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program initialisation subroutine.                  *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR

      ** Get bank details.

     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY

     C                   IF        PRtCd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'SDBANKPD'
     C                   EVAL      DBKey = POptn
     C                   EVAL      DBase = 101
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
                                                                                            BUG15196
      ** Check CGL031 feature                                                               BUG15196
     C                   Call      'AOSARDR0'                                               BUG15196
     C                   Parm      *Blanks       PRtCd                                      BUG15196
     C                   Parm      '*VERIFY'     POptn                                      BUG15196
     C                   Parm      'CGL031'      PSARD                                      BUG15196
     C                   Parm                    DSFDY                                      BUG15196
      *                                                                                     BUG15196
     C                   IF        PRtCd <> *BLANKS AND                                     BUG15196
     C                             PRtCd <> '*NRF   '                                       BUG15196
     C     *LOCK         IN        LDA                                                      BUG15196
     C                   EVAL      DBFile = 'CGL031'                                        BUG15196
     C                   EVAL      DBKey = POptn                                            BUG15196
     C                   EVAL      DBase = 102                                              BUG15196
     C                   OUT       LDA                                                      BUG15196
     C                   EXSR      *PSSR                                                    BUG15196
     C                   ELSE                                                               BUG15196
     C                   IF        PRtCd = '*NRF   '                                        BUG15196
     C                   EVAL      CGL031 = 'N'                                             BUG15196
     C                   ELSE                                                               BUG15196
     C                   EVAL      CGL031 = 'Y'                                             BUG15196
     C                   ENDIF                                                              BUG15196
     C                   ENDIF                                                              BUG15196
      ** Check CGL032 feature                                                               BUG15196
     C                   Call      'AOSARDR0'                                               BUG15196
     C                   Parm      *Blanks       PRtCd                                      BUG15196
     C                   Parm      '*VERIFY'     POptn                                      BUG15196
     C                   Parm      'CGL032'      PSARD                                      BUG15196
     C                   Parm                    DSFDY                                      BUG15196
      *                                                                                     BUG15196
     C                   IF        PRtCd <> *BLANKS AND                                     BUG15196
     C                             PRtCd <> '*NRF   '                                       BUG15196
     C     *LOCK         IN        LDA                                                      BUG15196
     C                   EVAL      DBFile = 'CGL032'                                        BUG15196
     C                   EVAL      DBKey = POptn                                            BUG15196
     C                   EVAL      DBase = 103                                              BUG15196
     C                   OUT       LDA                                                      BUG15196
     C                   EXSR      *PSSR                                                    BUG15196
     C                   ELSE                                                               BUG15196
     C                   IF        PRtCd = '*NRF   '                                        BUG15196
     C                   EVAL      CGL032 = 'N'                                             BUG15196
     C                   ELSE                                                               BUG15196
     C                   EVAL      CGL032 = 'Y'                                             BUG15196
     C                   ENDIF                                                              BUG15196
     C                   ENDIF                                                              BUG15196
      *                                                                                     BUG15196
      ** Check if Private Banking Module is available                                       BUG15196
     C                   Call      'AOMMODR0'                                               BUG15196
     C                   Parm      *Blanks       PRtCd                                      BUG15196
     C                   Parm      '*FIRST'      POptn                                      BUG15196
     C     SDMMOD        PARM      SDMMOD        DSFDY                                      BUG15196
     C                   IF        PRtCd <> *BLANKS                                         BUG15196
     C     *LOCK         IN        LDA                                                      BUG15196
     C                   EVAL      DBFile = 'SDMMODPD'                                      BUG15196
     C                   EVAL      DBKey = POptn                                            BUG15196
     C                   EVAL      DBase = 104                                              BUG15196
     C                   OUT       LDA                                                      BUG15196
     C                   EXSR      *PSSR                                                    BUG15196
     C                   ENDIF                                                              BUG15196
     C                   IF        BGN4ST = 'Y'                                             BUG15196
     C                   EVAL      PrivBank = 'Y'                                           BUG15196
     C                   ENDIF                                                              BUG15196
      *                                                                                     BUG15196
     C                   IF        (CGL031 = 'Y' AND CGL032 = 'Y') OR                       BUG15196
     C                             PrivBank = 'Y'                                           BUG15196
     C                   EVAL      *IN66 = *OFF                                             BUG15196
     C                   ELSE                                                               BUG15196
     C                   EVAL      *IN66 = *ON                                              BUG15196
     C                   ENDIF                                                              BUG15196
                                                                                              CGL132
      ** Check if FATCA is switched on                                                        CGL132
                                                                                              CGL132
     C                   CALLB     'AOSARDR0'                                                 CGL132
     C                   PARM      *BLANKS       PRtCd                                        CGL132
     C                   PARM      '*VERIFY'     POptn                                        CGL132
     C                   PARM      'CGL132'      PSARD                                        CGL132
     C                   PARM                    DSFDY                                        CGL132
                                                                                              CGL132
      ** Database error                                                                       CGL132
                                                                                              CGL132
     C     PRTCD         IFNE      *BLANKS                                                    CGL132
     C     PRTCD         ANDNE     '*NRF   '                                                  CGL132
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CGL132
     C                   MOVEL     '908'         DBASE                                        CGL132
     C                   MOVEL     'CGL132'      DBKEY                                        CGL132
     C                   EXSR      *PSSR                                                      CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
     C     PRTCD         IFEQ      *BLANK                                                     CGL132
     C                   MOVEL     'Y'           CGL132                                       CGL132
     C                   ELSE                                                                 CGL132
     C                   MOVEL     'N'           CGL132                                       CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
      ** Check if FATCA is switched on                                                        CGL132
                                                                                              CGL132
     C                   CALLB     'AOSARDR0'                                                 CGL132
     C                   PARM      *BLANKS       PRtCd                                        CGL132
     C                   PARM      '*VERIFY'     POptn                                        CGL132
     C                   PARM      'CGL133'      PSARD                                        CGL132
     C                   PARM                    DSFDY                                        CGL132
                                                                                              CGL132
      ** Database error                                                                       CGL132
                                                                                              CGL132
     C     PRTCD         IFNE      *BLANKS                                                    CGL132
     C     PRTCD         ANDNE     '*NRF   '                                                  CGL132
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CGL132
     C                   MOVEL     '918'         DBASE                                        CGL132
     C                   MOVEL     'CGL133'      DBKEY                                        CGL132
     C                   EXSR      *PSSR                                                      CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
     C     PRTCD         IFEQ      *BLANK                                                     CGL132
     C                   MOVEL     'Y'           CGL133            1                          CGL132
     C                   ELSE                                                                 CGL132
     C                   MOVEL     'N'           CGL133                                       CGL132
     C                   ENDIF                                                                CGL132

      ** Start on the Browse 1 Screen.

     C                   EVAL      WSCRN = '1'
     C                   EVAL      WB1SfA = 'B'

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      **---------------------------------------------------------------
      ** ILE RPG Program Status Subroutine
     C/COPY ZACPYSRC,PSSR_ILE
      **---------------------------------------------------------------
      *****************************************************************
      /EJECT
      *****************************************************************
** CPY@
(c) Misys International Banking Systems Ltd. 2004
** ##OV1
OVRDBF FILE(SDJACCL9) TOFILE(SDJACCL9) SHARE(*NO)
** ##OV2
DLTOVR FILE(SDJACCL9)
** ##OV3
OVRDBF FILE(SDFTNHL0) TOFILE(SDFTNHL0) SHARE(*NO)
** ##OV4
DLTOVR FILE(SDFTNHL0)
** ##OV5
OVRDBF FILE(SDCUAHLA) TOFILE(SDCUAHLA) SHARE(*NO)
** ##OV6
DLTOVR FILE(SDCUAHLA)
