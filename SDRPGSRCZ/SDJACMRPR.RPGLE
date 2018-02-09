     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Joint A/c Member Details Repair')             *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDJACMRPR - Midas SD Joint Account Member Details Repair     *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CER059             Date 19Jul10               *
      *                 BUG23732           Date 23Apr09               *
      *                 CER048             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      *                 244537             Date 17Aug05               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 232543             Date 14Mar05               *
      * Midas Release 4.04 -------------------------------------------*
      *                 CGL031  *CREATE    Date 05Jul04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG23732 - Joint Account Threshold                           *
      *  CER048 - German Features - Taxes (Recompile)                 *
      *  244537 - To avoid overriding front office identifier.        *
      *           (Recompile).                                        *
      *  244537 - To avoid overriding front office identifier         *
      *           (Recompile)                                         *
      *  232543 - Fix to CGL031                                       *
      *  CGL031 - Taxation of Savings Income                          *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FZATRNERRL0IF   E           K DISK    INFSR(*PSSR)
      ** Midas API Transaction Errors by Front Office ID/Timestamp
 
     FSDIJACML0 IF   E           K DISK    INFSR(*PSSR)
      ** Midas SD Invalid Joint A/c Members by Timestamp/Front Office ID
 
     FSDIJACML1 UF   E           K DISK    INFSR(*PSSR) COMMIT
     F                                     RENAME(SDIJACMD0:SDIJACMD1)
      ** Midas SD Invalid Joint A/c Members by Front Office ID/Timestamp
 
     FAPILOGL0  UF   E           K DISK    INFSR(*PSSR) COMMIT
      ** Midas AP API Invalid Log File from Support Database
 
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
      ** Prime A/c Holder for Tax Array                                                       232543
     D PAPAHT          S              1A   DIM(100)                                           232543
                                                                                              232543
      ** Error Indicators Array
     D EINA            S              1A   DIM(60)
 
      ** Current Joint A/c Member Details - File Format
     D CurJAcMDet    E DS                  EXTNAME(SDJACCPD) PREFIX(CF:2)
 
      ** Current Joint A/c Member Details - Screen Format
     D CurJAcMScr    E DS                  EXTNAME(SDJACMPD) PREFIX(CS:2)
 
      ** New Joint A/c Member Details - File Format
     D NewJAcMDet    E DS                  EXTNAME(SDVJACMPD)
 
      ** New Joint A/c Member Details - Screen Format
     D NewJAcMScr    E DS                  EXTNAME(SDJACMPD)
 
      ** Previous Joint A/c Member Details - Screen Format
     D PrvJAcMScr    E DS                  EXTNAME(SDJACMPD) PREFIX(PS:2)
 
      ** Joint A/c Member Details Error indicators
     D OKJAcMDets    E DS                  EXTNAME(SDEJACMPD)
 
      ** Bank Details Data Structure
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** API ICD Details Data Structure
     D SDAPI         E DS                  EXTNAME(SDAPIPD)
 
      ** Switchable Feature Details Data Structure
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
 
      ** Short Access Object Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Long Access Object Data Structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** +--------------------------------------+
      ** ¦ Declared Variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Access Object Parameters
     D PRtCd           S              7A
     D POptn           S              7A
     D PSARD           S              6A
 
      ** API Parameters
     D PRetCode        S             10A
     D PDACTN          S              1A
     D PDJANO          S              6A
     D PSFACT          S              8A
     D PMSGID          S              7A
     D PACTNSEL        S              1A
     D PFOIDSEL        S             20A
     D POPSEL          S              1A
     D PJASEL          S              6A
     D PDACTD          S              1A
     D PCUSEL          S              6A
     D PNASEL          S             10A
     D PDTMST          S               Z
     D PINKC           S              1A
     D PINKE           S              1A
     D PINKL           S              1A
     D POprMode        S              6A
     D PResMode        S              1A
     D PDFRNT          S             20A
     D PDCUST          S              6A
     D PDNAHO          S             10A
     D PCvtMode        S              6A
     D PValMode        S              6A
     D OKACTN          S              1A
 
      ** Standard Utility Parameters
     D PFormat         S             10A   INZ('SDJACMPD')
     D PField          S             10A   INZ('DDACTN')
     D PFieldNo        S              5P 0
     D POffset         S              5P 0
     D PSubChar        S              1A
     D PIncDta         S           2000A
     D PCurDta         S           2000A
 
      ** Switchable Features
     D CSC011          S              1A   INZ('N')
 
      ** Key Fields
     D KTmst           S                   LIKE(DDTMST)
     D KFrnt           S                   LIKE(DDFRNT)
     D KMTyp           S                   LIKE(APMTYP) INZ('SDJACM')
 
      ** Working Variables
     D WRPRA           S              1A
     D Ix              S              3P 0
     D WIx             S              3P 0
     D WPrvWarn        S              3P 0
     D WI              S              3P 0
     D WJ              S              3P 0
     D WFTMST          S               Z
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +---------------- Start of Main Processing ------------------+
      ** ¦                                                            ¦
      ** ¦  *INZSR is automatically executed at program activation.   ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
 
      ** Build Subfile
 
     C                   IF        WRPRA = 'B'
     C                   EXSR      SRBldRpb
     C                   ENDIF
 
      ** Read Next Browse Subfile Record
 
     C                   IF        WRPRA = 'R'
     C                   EXSR      SRRdNRpb
     C                   ENDIF
 
      ** Update Joint A/c Member Details
 
     C                   DOW       WRPRA = 'D'
     C                   EXSR      SRDspDet
     C                   ENDDO
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRBldRpb - Builds the Repair Browse Subfile.                 *
      *                                                               *
      *****************************************************************
     C     SRBldRpb      BEGSR
 
     C                   EVAL      PSFACT = '*BUILD  '
     C                   EXSR      SRJAcMRpb
 
      ** Exit on F03.
 
     C                   IF        PINKC = *ON
     C                   EXSR      SREndPgm
     C                   ENDIF
 
     C                   EVAL      WRPRA = 'R'
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRdNRpb - Reads the next Repair Browse subfile record.      *
      *                                                               *
      *****************************************************************
     C     SRRdNRpb      BEGSR
 
     C                   EVAL      PSFACT = '*READ   '
     C                   EXSR      SRJAcMRpb
 
     C                   IF        PINKC = *ON
     C                   EXSR      SREndPgm
     C                   ENDIF
 
     C                   IF        POPSEL <> *BLANK
 
     C                   CLEAR                   NewJAcMDet
     C                   CLEAR                   NewJAcMScr
 
     C                   EVAL      KTmst = PDTMST
     C                   EVAL      KFrnt = PFOIDSEL
     C     KIJL0         CHAIN     SDIJACML0
 
      ** Determine Operation Mode.
 
     C                   IF        DDACTN = 'I'
     C                   EVAL      POprMode = '*FRONT'
     C                   ELSE
     C                   IF        DDJANO = *BLANKS
     C                   EVAL      POprMode = '*FRONT'
     C                   ELSE
     C                   EVAL      POprMode = *BLANKS
     C                   ENDIF
     C                   ENDIF
 
     C                   EXSR      SRResErF
     C                   EXSR      SRResErA
 
      ** Retrieve Joint A/c Member details.
 
     C                   EVAL      PDACTN = PACTNSEL
     C                   EVAL      PDFRNT = PFOIDSEL
     C                   EVAL      PDJANO = PJASEL
     C                   EVAL      PDCUST = PCUSEL
     C                   EVAL      PDNAHO = PNASEL
     C                   EXSR      SRJAcMRtv
 
      ** Convert Joint A/c Member details to screen format.
 
     C                   IF        CFJANO <> *BLANKS
 
     C                   IF        DDACTN <> 'I'
     C                   EVAL      PCvtMode = '*SCRN '
     C                   EXSR      SRJAcMCvt
     C                   ENDIF
 
     C                   IF        DDACTN = 'A'
 
      ** Do data substitution if necessary.
 
     C                   IF        GHSUBS <> *BLANK
     C     GHSUBS        SCAN      NewJAcMScr
     C                   IF        %FOUND
     C                   EXSR      SRDtaSub
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
      ** Blank out the Action Code if an error has occurred during retrieve.
 
     C                   IF        OKACTN = 'N' OR
     C                             OKCUST = 'N' OR
     C                             OKNAHO = 'N'
     C                   EVAL      DDACTN = *BLANKS
     C                   ENDIF
 
     C                   EXSR      SRSndMsg
 
      ** Save previous screen image.
 
     C                   EVAL      PrvJAcMScr = NewJAcMScr
     C                   EVAL      WPrvWarn = *ZERO
     C                   EVAL      WRPRA = 'D'
 
     C                   ELSE
     C                   EVAL      WRPRA = 'B'
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDspDet - Displays the Invalid Joint A/c Member details.    *
      *                                                               *
      *****************************************************************
     C     SRDspDet      BEGSR
 
     C                   EXSR      SRJAcMDsp
 
     C                   EXSR      SRResErA
     C                   EXSR      SRResErF
 
     C                   SELECT
 
      ** Exit on F03.
 
     C                   WHEN      PINKC = *ON
     C                   EXSR      SREndPgm
 
      ** Refresh on F05.
 
     C                   WHEN      PINKE = *ON
     C                   EVAL      NewJAcMScr = PrvJAcMScr
     C                   EVAL      CurJAcMScr = PrvJAcMScr
 
      ** Return to the previous screen on F12.
 
     C                   WHEN      PINKL = *ON
     C                   EVAL      WRPRA = 'B'
 
     C                   OTHER
     C                   EXSR      SRValDet
     C                   ENDSL
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValDet - Validates the Joint A/c Member details.           *
      *                                                               *
      *****************************************************************
     C     SRValDet      BEGSR
 
      ** Update key fields.
 
     C                   EVAL      PDCUST = DDCUST
     C                   EVAL      PDNAHO = DDNAHO
 
     C                   CLEAR                   CurJAcMDet
     C                   EXSR      SRJAcMRtv
 
     C                   IF        OKACTN = 'N' OR
     C                             OKCUST = 'N' OR
     C                             OKNAHO = 'N'
     C                   LEAVESR
     C                   ENDIF
 
      ** Save the most recent timestamp value.
 
     C                   EVAL      WFTMST = CFTMST
 
     C                   EVAL      CurJAcMScr = NewJAcMScr
 
     C                   EVAL      PValMode = '*FIELD'
 
     C                   CLEAR                   NewJAcMDet
     C                   EXSR      SRJAcMVal
 
     C                   IF        Ix <> 0
     C                   LEAVESR
     C                   ENDIF
 
      ** Redisplay the screen if defaulting or reformatting has occurred in
      ** validation or if the number of warnings has changed. Update invalid
      ** Joint A/c Member details otherwise.
 
     C                   IF        NewJAcMScr <> CurJAcMScr OR
     C                             WIx <> WPrvWarn
     C                   EVAL      WPrvWarn = WIx
     C                   LEAVESR
     C                   ENDIF
 
     C                   EXSR      SRResErA
     C                   EXSR      SRResErF
 
      ** Update Joint A/c Member details.
 
     C                   EXSR      SRUpdDet
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRUpdDet - Updates the Invalid Joint A/c Member details.     *
      *                                                               *
      *****************************************************************
     C     SRUpdDet      BEGSR
 
     C                   EVAL      PMSGID = *BLANKS
     C                   EVAL      PCvtMode = '*FILE '
 
      ** Convert Joint A/c Member details.
 
     C                   MOVE      NewJAcMScr    CurJAcMScr
     C                   EXSR      SRJAcMCvt
     C**********         MOVE      CurJAcMDet    NewJAcMDet                                 BUG23732
     C                   MOVEL     CurJAcMDet    NewJAcMDet                                 BUG23732
     C                   EVAL      JAFRNT = DDFRNT                                            232543
     C                   EVAL      JAREPA = DDREPA                                            232543
     C                   EVAL      JATMST = WFTMST
 
     C                   EXSR      SRJAcMUpd
 
     C                   SELECT
 
     C                   WHEN      PRetCode = *BLANKS
 
     C     KIJL1         CHAIN     SDIJACML1
 
     C                   IF        %FOUND
     C                   DELETE    SDIJACML1
     C                   ENDIF
 
      ** Update the API Invalid Log File if necessary.
 
     C                   IF        CSC011 = 'Y'
 
     C     KILOG         CHAIN     APILOGL0
 
     C                   IF        %FOUND
     C                   DELETE    APILOGD0
     C                   ENDIF
 
     C                   ENDIF
 
     C                   COMMIT
 
     C                   EVAL      PMSGID = 'SDM0132'
     C                   EVAL      WRPRA = 'B'
 
     C                   WHEN      PRetCode = '*RECUPD   '
 
     C                   EVAL      PMSGID = 'SDM0130'
     C                   EVAL      WRPRA = 'B'
 
     C                   OTHER
     C                   ROLBK
     C                   EXSR      *PSSR
 
     C                   ENDSL
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSndMsg - Sends messages to the screen.                     *
      *                                                               *
      *****************************************************************
     C     SRSndMsg      BEGSR
 
     C                   EVAL      WI = *ZERO
 
      ** If an Action Code error occurs, make sure that the error message
      ** "This transaction cannot be applied..." is displayed.
 
     C                   IF        OKACTN = 'N'
     C                   EVAL      WI = WI + 1
     C                   EVAL      FldNameArr(WI) = '*ANY'
     C                   EVAL      MsgIdArr(WI) = 'APM0110'
     C                   ENDIF
 
     C                   MOVE      *ALL'Y'       EINA
 
      ** Read error messages for Joint A/c Member details.
 
     C     KIJL1         SETLL     ZATRNERRD0
     C     KIJL1         READE     ZATRNERRD0
 
     C                   DOW       NOT %EOF
 
     C                   CALLB     'ZACGTFLDNO'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM                    PFormat
     C                   PARM                    ABFIELDNAM
     C                   PARM      *ZERO         PFieldNo
 
     C                   IF        PRetCode = *BLANKS
     C                   EVAL      WI = WI + 1
     C                   EVAL      FldNameArr(WI) = ABFIELDNAM
     C                   EVAL      MsgIdArr(WI) = ABMSGID
     C                   EVAL      WJ = ABFIELDID
     C                   EVAL      WJ = WJ - POffset
 
     C                   IF        WJ < 1 OR
     C                             WJ > 60
     C                   EVAL      WJ = 1
     C                   ENDIF
 
     C                   EVAL      EINA(WJ) = 'N'
     C                   ENDIF
 
     C     KIJL1         READE     ZATRNERRD0
     C                   ENDDO
 
     C                   MOVEA     EINA          OKJAcMDets
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDtaSub - Handles data substitution.                        *
      *                                                               *
      *****************************************************************
     C     SRDtaSub      BEGSR
 
     C                   CLEAR                   PIncDta
     C                   CLEAR                   PCurDta
 
     C                   CALLB     'APDTASUBS'
      **                 *********************
 
      ** Return Code
     C                   PARM      *BLANKS       PRetCode
 
      ** Substitution Character
     C                   PARM      GHSUBS        PSubChar
 
      ** Incoming Data
     C                   PARM      NewJAcMScr    PIncDta
 
      ** Current Data
     C                   PARM      CurJAcMScr    PCurDta
 
     C                   MOVEL     PIncDta       NewJAcMScr
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRJAcMRtv - Joint A/c Member Details Retrieve.               *
      *                                                               *
      *****************************************************************
     C     SRJAcMRtv     BEGSR
 
      ** 'I' & 'A' are possible default Action Codes.
 
     C                   IF        DDACTN = 'I' OR
     C                             DDACTN = 'A'
     C                   EVAL      PDACTD = 'Y'
     C                   ELSE
     C                   EVAL      PDACTD = 'N'
     C                   ENDIF
 
     C                   CALLB     'SDJACMRTV'
      **                 *********************
 
      **********************
      ** Input Parameters **
      **********************
 
      ** Return Code
     C                   PARM      *BLANKS       PRetCode
 
      ** Operation Mode
     C                   PARM                    POprMode
 
      ** Response Mode
     C                   PARM      'S'           PResMode
 
      ** Action Code
     C                   PARM                    PDACTN
 
      ** Front Office Transaction ID
     C                   PARM                    PDFRNT
 
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
     C                   PARM                    CurJAcMDet
 
      ** OK - Action code
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
 
      ** Current Joint A/c Member Details - File Format
     C                   PARM                    CurJAcMDet
 
      ** Current Joint A/c Member Details - Screen Format
     C                   PARM                    CurJAcMScr
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRJAcMDsp - Joint A/c Member Details Display.                *
      *                                                               *
      *****************************************************************
     C     SRJAcMDsp     BEGSR
 
     C                   CALLB     'SDJACMDSP'
      **                 *********************
 
      **********************
      ** Input Parameters **
      **********************
 
      ** Return Code
     C                   PARM      *BLANKS       PRetCode
 
      ** Joint A/c Number
     C                   PARM                    PDJANO
 
      ** Joint A/c Member Details - Screen Format
     C                   PARM                    NewJAcMScr
 
      ** OK - Action Code
     C                   PARM                    OKACTN
 
      ** OK - Joint A/c Member
     C                   PARM                    OKJAcMDets
 
      ** Error Fields/Message IDs/Message Data (arrays) From/To Caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
 
      ** Array Index (3P0) From/To Caller
     C                   PARM                    Ix
 
      ***********************
      ** Output Parameters **
      ***********************
 
      ** Command Keys
     C                   PARM      *OFF          PINKC
     C                   PARM      *OFF          PINKE
     C                   PARM      *OFF          PINKL
 
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
 
      ** New Joint A/c Member Details - Screen Format
     C                   PARM                    NewJAcMScr
 
      ** Customer Number Array
     C                   PARM                    PACUST
 
      ** Non-a/c Holder Array
     C                   PARM                    PANAHO
 
      ** Investment Proportion Array
     C                   PARM                    PAINVP
 
      ** Prime A/c Holder Array                                                               232543
     C                   PARM                    PAPAHO                                       232543
                                                                                              232543
      ** Prime A/c Holder for Tax Array                                                       232543
     C                   PARM                    PAPAHT                                       232543
                                                                                              232543
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
 
      ** New Joint A/c Member Details - File Format
     C                   PARM                    NewJAcMDet
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRJAcMRpb - Joint A/c Member Details Repair Browse.          *
      *                                                               *
      *****************************************************************
     C     SRJAcMRpb     BEGSR
 
     C                   CALLB     'SDJACMRPB'
      **                 *********************
 
      **********************
      ** Input Parameters **
      **********************
 
      ** Return Code
     C                   PARM      *BLANKS       PRetCode
 
      ** Subfile Action
     C                   PARM                    PSFACT
 
      ** Message ID
     C                   PARM                    PMSGID
 
      ***********************
      ** Output Parameters **
      ***********************
 
      ** Option Selected
     C                   PARM                    POPSEL
 
      ** Action Code Selected
     C                   PARM                    PACTNSEL
 
      ** Front Office ID Selected
     C                   PARM                    PFOIDSEL
 
      ** Joint A/c Number Selected
     C                   PARM                    PJASEL
 
      ** Customer Number Selected
     C                   PARM                    PCUSEL
 
      ** Non-a/c Holder Selected
     C                   PARM                    PNASEL
 
      ** Joint A/c Member Timestamp
     C                   PARM                    PDTMST
 
      ** Command Keys
     C                   PARM      *OFF          PINKC
     C                   PARM      *OFF          PINKL
 
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
 
      ** New Joint A/c Member Details
     C                   PARM                    NewJAcMDet
 
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
 
      ** Key Lists
 
     C     KIJL0         KLIST
     C                   KFLD                    KTmst
     C                   KFLD                    KFrnt
 
     C     KIJL1         KLIST
     C                   KFLD                    KFrnt
     C                   KFLD                    KTmst
 
     C     KILOG         KLIST
     C                   KFLD                    KMTyp
     C                   KFLD                    KFrnt
     C                   KFLD                    KTmst
 
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
 
      ** Get API ICD details.
 
     C                   CALL      'AOAPIR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*FIRST '     POptn
     C     SDAPI         PARM      SDAPI         DSFDY
 
     C                   IF        PRtCd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'SDAPIPD'
     C                   EVAL      DBKey = POptn
     C                   EVAL      DBase = 102
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Check if CSC011 is enabled.
 
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'CSC011'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C                   IF        PRtCd = *BLANKS
     C                   EVAL      CSC011 = 'Y'
     C                   ELSE
 
     C                   IF        PRtCd <> '*NRF   '
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'SCSARDPD'
     C                   EVAL      DBKey = PSARD
     C                   EVAL      DBase = 103
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDIF
 
      **---------------------------------------------------------------
      ** Program, Module, & Procedure Names for DB Error Processing
     C/COPY ZACPYSRC,DBFIELDS
      **---------------------------------------------------------------
 
      ** Get the field number for the action code field. The primary
      ** screen fields start from that number. Subtract one from it to
      ** give the value to subtract from each field's number.
 
     C                   CALLB     'ZACGTFLDNO'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM                    PFormat
     C                   PARM                    PField
     C                   PARM      *ZERO         PFieldNo
 
     C                   IF        PRetCode = *BLANKS
     C                   EVAL      POffset = PFieldNo
     C                   ENDIF
 
      ** Start on the Browse Screen.
 
     C                   EVAL      WRPRA = 'B'
 
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
(c) Finastra International Limited 2004
