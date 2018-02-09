     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Joint A/c Member Details Enquiry')            *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDJACMENQ - Midas SD Joint Account Member Details Screen     *
      *              Enquiry                                          *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CER059             Date 19Jul10               *
      *                 CER048             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 BUG15111           Date 23Oct07               *
      *                 244537             Date 17Aug05               *
      *                 CGL031  *CREATE    Date 05Jul04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER048 - German Features - Taxes (Recompile)                 *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  BUG15111 - An incorrect error message was displayed          *
      *             during enquiry                                    *
      *  244537 - To avoid overriding front office identifier.        *
      *           (Recompile).                                        *
      *  CGL031 - Taxation of Savings Income                          *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
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
 
      ** Joint A/c Member Details - Screen Format
     D JAcMScrFmt    E DS                  EXTNAME(SDJACMPD)
 
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
 
      ** Working Variables
     D WSCRN           S              1A
     D WActn           S              1A
     D WB1SfA          S              1A
     D WB1SfC          S              5P 0
     D WB1SfE          S              1A
     D WB2SfA          S              1A
     D WDScrA          S              1A
     D Ix              S              3P 0
     D WIx             S              3P 0
     D WArrIdx         S              3P 0
     D WOKInvP         S              1A
 
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
      *  SRBldBr1 - Builds the Browse 1 subfile.                      *
      *                                                               *
      *****************************************************************
     C     SRBldBr1      BEGSR
 
     C                   EVAL      PSFACT = '*ENQUIRY'
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
     C                   EXSR      SREndPgm
     C                   ENDIF
 
      ** Refresh on F05.
 
     C                   IF        PINKE = *ON
     C                   EVAL      WB2SfA = 'F'
     C                   LEAVESR
     C                   ENDIF
 
      ** Return to the previous screen on F12.
 
     C                   IF        PINKL = *ON
     C                   EVAL      WSCRN = '1'
     C                   EVAL      WB1SfA = 'B'
     C                   LEAVESR
     C                   ENDIF
 
     C                   EVAL      WB2SfA = 'B'
 
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
     C                   EXSR      SREndPgm
 
      ** Refresh on F05.
 
     C                   WHEN      PINKE = *ON
     C                   EVAL      WB2SfA = 'F'
 
      ** Return to the previous screen on F12.
 
     C                   WHEN      PINKL = *ON
     C                   EVAL      WSCRN = '1'
     C                   EVAL      WB1SfA = 'B'
 
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
     C                   IF        PDACTN = 'E'                                             BUG15111
     C                   EXSR      SRJAcMRtv
     C                   ELSE                                                               BUG15111
     C                   EVAL      OKACTN = 'N'                                             BUG15111
     C                   ENDIF                                                              BUG15111
 
      ***If*action is 'A' (amend) set error as only enquiry is allowed                      BUG15111
      ** If action is Not E (Enquire) set error as only enquiry is allowed                  BUG15111
 
     C**********         IF        PDACTN = 'A'                                             BUG15111
     C                   IF        PDACTN <> 'E'                                            BUG15111
     C                   EVAL      Ix = Ix + 1
     C                   EVAL      FldNameArr(Ix) = 'DDACTN'
     C**********         EVAL      MsgIDArr(Ix) = 'SDM0105'                                 BUG15111
     C                   EVAL      MsgIDArr(Ix) = 'SDM0137'                                 BUG15111
     C                   ENDIF
 
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
(c) Finastra International Limited 2004
