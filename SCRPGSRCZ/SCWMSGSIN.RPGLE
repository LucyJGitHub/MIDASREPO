     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SC 24x7 Processing Day Msg Mnt Main')
      *****************************************************************
      *                                                               *
      *  Midas - System Control Module                                *
      *                                                               *
      *  SCWMSGSIN - 24x7 Processing Day Message Maintenance Screen   *
      *              Input                                            *
      *                                                               *
      *  Function:  This is the main screen input function            *
      *             for the 24x7 Processing Day Message Maintenance.  *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4.01 -------------------------------------------*
      *  Prev Amend No. CSC011  *CREATE    Date 18Sep01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSC011 - 24x7 Midas Availability                             *
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
 
     D NumSel          C                   '12345678'
     D MsgTyp          C                   'CSOMFVWX'
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Selected record
     D SelRec          DS
     D   WSMsgType             1      1
     D   WSMsgTime             2      6  0
     D   WSLangCode            7      8
 
      ** Record details in Screen Format
     D RecDets         DS
     D   WMsgType              1      1
     D   WMsgTime              2      6
     D   WLangCode             7      8
     D   WMsgText              9    508
 
      ** Record details in File Format
     D RecFilFmt       DS
     D   WFMsgType             1      1
     D   WFMsgTime             2      6  0
     D   WFLangCode            7      8
     D   WFMsgText             9    508
 
      ** Error indicators
     D OKFlags         DS
     D   OKSELE                1      1
     D   OKMTIM                2      2
     D   OKLANG                3      3
     D   OKMTXT                4      4
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Action Code
     D PAction         S              1A
 
      ** Build subfile
     D PBDSFL          S              1A
 
      ** condition availability of F10 (delete)
     D PEINKJ          S              1A
 
      ** F3 Exit
     D PINKC           S              1A
 
      ** F9 Insert
     D PINKI           S              1A
 
      ** F10 Delete
     D PINKJ           S              1A
 
      ** F12 Cancel
     D PINKL           S              1A
 
      ** Option selected
     D POPSEL          S              1A
 
      ** Read next browse
     D PRDNB           S              1A
 
      ** Read subfile
     D PRDSFL          S              1A
 
      ** Enable detail fields
     D PEDTFD          S              1A
 
      ** Enable key fields
     D PEKYFD          S              1A
 
      ** Message Type
     D PMType          S              1A
 
      ** Message Time
     D PMTime          S              5  0
     D PMinutes        S              3A
     D PSeconds        S              2A
 
      ** Language Code
     D PLang           S              2A
 
      ** Message Text
     D PMText          S            500A
 
      ** Message Type Text
     D PMTypTxt        S             78A
 
      ** Selection option in initial screen
     D PSelect         S              1A
 
      ** Screen / function
     D WSCRN           S              1A
 
      ** Index of errors
     D Idx             S              3P 0
     D WIdx            S              3P 0
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      /COPY WNCPYSRC,SCWMSGS001
 
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
 
      /COPY WNCPYSRC,SCWMSGS002
      ** Display initial screen.
 
     C                   DOW       WSCRN = 'I'
     C                   EXSR      SRInitScrn
     C                   ENDDO
 
      /COPY WNCPYSRC,SCWMSGS003
      ** Build browse subfile record
 
     C                   IF        WSCRN = 'B'
     C                   EXSR      SRBldBrw
     C                   ENDIF
 
      ** Read next browse subfile record
 
     C                   IF        WSCRN = 'R'
     C                   EXSR      SRRdNBrw
     C                   ENDIF
 
      /COPY WNCPYSRC,SCWMSGS004
      ** Do while screen: Key Details Screen
 
     C                   DOW       WSCRN = 'K'
     C                   EXSR      SRMainScrn
     C                   ENDDO
 
      /COPY WNCPYSRC,SCWMSGS005
      ** Do while screen: Transaction Detail Screen
 
     C                   DOW       WSCRN = 'P'
     C                   EXSR      SRDetsScrn
     C                   ENDDO
 
      /COPY WNCPYSRC,SCWMSGS006
      ** Do File updates
 
     C                   IF        WSCRN = 'U'
     C                   EXSR      SRUpdate
     C                   ENDIF
 
      /COPY WNCPYSRC,SCWMSGS007
      ** Terminate program
 
     C                   IF        WSCRN = 'T'
     C                   EVAL      *INLR = *ON
     C                   ENDIF
 
      *****************************************************************
 
      * Hook to enable non-core subroutines to be included
      /COPY WNCPYSRC,SCWMSGS008
 
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRInitScrn - Process Initial Screen                          *
      *                                                               *
      *  Called by: Main                                              *
      *                                                               *
      *  Calls    : SCWMSGDSP, SREndPgm, SRValInit                    *
      *                                                               *
      *****************************************************************
 
     C     SRInitScrn    BEGSR
 
      ** Write/Read initial screen
 
     C                   CALLB     'SCWMSGDSP'
 
      ** Input Parameters
      ** Return Code
 
     C                   PARM      *BLANK        RetCodeOut
 
      ** Message Type Text
 
     C                   PARM                    PMTypTxt
 
      ** Record Details in screen format
 
     C                   PARM      *BLANK        RecDets
 
      ** Record Details OK indicators
 
     C                   PARM                    OKFlags
 
      ** Errors
 
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
 
      ** Warnings
 
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
 
      ** Enabled Key & Detail Fields
 
     C                   PARM                    PEKYFD
     C                   PARM                    PEDTFD
 
      ** Enabled Function Keys
      ** F10 - Confirm Delete
 
     C                   PARM                    PEINKJ
 
      ** Output Parameters
      ** Selection option in initial screen
 
     C                   PARM                    PSelect
 
      ** Function Keys
 
     C                   PARM      '0'           PINKC
     C                   PARM      '0'           PINKJ
     C                   PARM      '0'           PINKL
 
      ** Reset Errors
 
     C                   MOVE      *ALL'Y'       OKFlags
     C                   EVAL      FldNameArr = *BLANK
     C                   EVAL      MsgIdArr   = *BLANK
     C                   EVAL      MsgDtaArr  = *BLANK
     C                   EVAL      WFldNamArr = *BLANK
     C                   EVAL      WMsgIDArr  = *BLANK
     C                   EVAL      WMsgDtaArr = *BLANK
 
      ** F3 - End Program
 
     C                   IF        PINKC = '1'
     C                   EXSR      SREndPgm
 
      ** Validate selection input
 
     C                   ELSE
     C                   EXSR      SRValInit
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValInit - Validate input to initial screen                 *
      *                                                               *
      *  Called by: SRInitScrn                                        *
      *                                                               *
      *  Calls    : SCWMSGVAL                                         *
      *                                                               *
      *****************************************************************
 
     C     SRValInit     BEGSR
 
      ** Prior to validation, initialize error indicators as 'OK'.
 
     C                   EVAL      Idx  = *ZERO
     C                   EVAL      WIdx = *ZERO
     C                   MOVE      *ALL'Y'       OKFlags
 
     C                   CALLB     'SCWMSGVAL'
 
      ** Inputs
      ** Return Code
 
     C                   PARM      *BLANK        RetCodeOut
 
      ** Selection option in initial screen
 
     C                   PARM                    PSelect
 
      ** Action Code
 
     C                   PARM                    PAction
 
      ** Transaction Details
 
     C                   PARM                    RecDets
 
      ** Outputs
      ** Record details OK indicators
 
     C                   PARM                    OKFlags
 
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
 
      ** Array index (3P0) from/to caller
 
     C                   PARM                    Idx
 
      ** Warning fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
 
      ** Array index (3P0) from/to caller
 
     C                   PARM                    WIdx
 
      ** Valid Transaction details layout (DS) from/to caller
 
     C                   PARM                    RecFilFmt
 
      ** If errors returned
 
     C                   IF        Idx = 0
     C     NumSel:MsgTyp XLATE     PSelect       PMType
     C                   EVAL      WSCRN = 'B'
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRMainScrn - Process Main Screen                             *
      *                                                               *
      *  Called by: Main                                              *
      *                                                               *
      *  Calls    : SCWMSGDSP                                         *
      *                                                               *
      *****************************************************************
 
     C     SRMainScrn    BEGSR
 
      ** Write/Read Main Display Screen
 
     C                   CALLB     'SCWMSGDSP'
 
      ** Input Parameters
      ** Return code
 
     C                   PARM      *BLANK        RetCodeOut
 
      ** Message Type Text
 
     C                   PARM                    PMTypTxt
 
      ** Record Details in screen format
 
     C                   PARM                    RecDets
 
      ** Record Details OK indicators
 
     C                   PARM                    OKFlags
 
      ** Errors
 
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
 
      ** Warning
 
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
 
      ** Enabled Key & Detail Fields
 
     C                   PARM                    PEKYFD
     C                   PARM                    PEDTFD
 
      ** Enabled Function Keys
      ** F10 - Confirm Delete
 
     C                   PARM                    PEINKJ
 
      ** Output Parameters
      ** Selection option in initial screen
 
     C                   PARM                    PSelect
 
      ** Function Keys
 
     C                   PARM      '0'           PINKC
     C                   PARM      '0'           PINKJ
     C                   PARM      '0'           PINKL
 
      ** Reset Errors
 
     C                   MOVE      *ALL'Y'       OKFlags
     C                   EVAL      FldNameArr = *BLANK
     C                   EVAL      MsgIdArr   = *BLANK
     C                   EVAL      MsgDtaArr  = *BLANK
     C                   EVAL      WFldNamArr = *BLANK
     C                   EVAL      WMsgIDArr  = *BLANK
     C                   EVAL      WMsgDtaArr = *BLANK
 
     C                   SELECT
 
      ** F3 - End Program
 
     C                   WHEN      PINKC = '1'
     C                   EXSR      SREndPgm
 
      ** F12 - Previous Screen
 
     C                   WHEN      PINKL = '1'
     C                   EVAL      WSCRN = 'B'
 
      ** Validate Inputs
 
     C                   OTHER
     C                   EXSR      SRValMain
     C                   ENDSL
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValMain - Validate input to Main Screen                    *
      *                                                               *
      *  Called by: SRMainScrn                                        *
      *                                                               *
      *  Calls    : SCWMSGVAL                                         *
      *                                                               *
      *****************************************************************
 
     C     SRValMain     BEGSR
 
     C                   CALLB     'SCWMSGVAL'
 
      ** Inputs
      ** Return Code
 
     C                   PARM      *BLANK        RetCodeOut
 
      ** Selection option in initial screen
 
     C                   PARM                    PMType
 
      ** Action Code
 
     C                   PARM                    PAction
 
      ** Transaction Details
 
     C                   PARM                    RecDets
 
      ** Outputs
      ** Record details OK indicators
 
     C                   PARM                    OKFlags
 
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
 
      ** Array index (3P0) from/to caller
 
     C                   PARM                    Idx
 
      ** Warning fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
 
      ** Array index (3P0) from/to caller
 
     C                   PARM                    WIdx
 
      ** Record details in file format
 
     C                   PARM                    RecFilFmt
 
      ** Check if record to be inserted is valid.
 
     C                   IF        OKMTIM = 'Y' AND OKLANG = 'Y'
     C                   MOVE      WFMsgTime     WMsgTime
     C                   EVAL      PMTime = WFMsgTime
     C                   EVAL      PLang = WFLangCode
     C                   EXSR      SRRtvDets
 
     C                   IF        OKMTIM = 'Y' AND OKLANG = 'Y'
     C                   MOVE      *ALL'Y'       OKFlags
     C                   EVAL      PAction = 'A'
     C                   EXSR      SRFuncKeys
     C                   EXSR      SRFldSts
     C                   EVAL      WSCRN = 'P'
     C                   ELSE
     C                   EXSR      SRFuncKeys
     C                   EXSR      SRFldSts
     C                   EVAL      WMsgType = PMType
     C                   EVAL      WSCRN = 'K'
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRFldSts - Set field status on detail screen                 *
      *                                                               *
      *  Called by: SRMainScrn                                        *
      *                                                               *
      *  Calls    : SCWMSGVAL                                         *
      *                                                               *
      *****************************************************************
 
     C     SRFldSts      BEGSR
 
      ** Enable/disable fields on detail screen
 
     C                   SELECT
     C                   WHEN      PAction = 'A'
     C                   EVAL      PEKYFD = 'N'
     C                   EVAL      PEDTFD = 'Y'
 
     C                   WHEN      PAction = 'D' OR PAction = 'E'
     C                   EVAL      PEKYFD = 'Y'
     C                   EVAL      PEDTFD = 'Y'
 
     C                   WHEN      PAction = 'I'
     C                   EVAL      PEKYFD = 'Y'
     C                   EVAL      PEDTFD = 'N'
 
     C                   OTHER
     C                   EVAL      PEKYFD = 'N'
     C                   EVAL      PEDTFD = 'N'
     C                   ENDSL
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDetsScrn - Process details screen                          *
      *                                                               *
      *  Called by: Main                                              *
      *                                                               *
      *  Calls    : SCWMSGDSP                                         *
      *                                                               *
      *****************************************************************
 
     C     SRDetsScrn    BEGSR
 
     C                   CALLB     'SCWMSGDSP'
 
      ** Input Parameters
      ** Return code
 
     C                   PARM      *BLANK        RetCodeOut
 
      ** Message Type Text
 
     C                   PARM                    PMTypTxt
 
      ** Record Details in screen format
 
     C                   PARM                    RecDets
 
      ** Record Details OK indicators
 
     C                   PARM                    OKFlags
 
      ** Errors
 
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
 
      ** Warning
 
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
 
      ** Enabled Key & Detail Fields
 
     C                   PARM                    PEKYFD
     C                   PARM                    PEDTFD
 
      ** Enabled Function Keys
      ** F10 - Confirm Delete
 
     C                   PARM                    PEINKJ
 
      ** Output Parameters
      ** Selection option in initial screen
 
     C                   PARM                    PSelect
 
      ** Function Keys
 
     C                   PARM      '0'           PINKC
     C                   PARM      '0'           PINKJ
     C                   PARM      '0'           PINKL
 
      ** Reset Errors
 
     C                   MOVE      *ALL'Y'       OKFlags
     C                   EVAL      FldNameArr = *BLANK
     C                   EVAL      MsgIdArr   = *BLANK
     C                   EVAL      MsgDtaArr  = *BLANK
     C                   EVAL      WFldNamArr = *BLANK
     C                   EVAL      WMsgIDArr  = *BLANK
     C                   EVAL      WMsgDtaArr = *BLANK
 
     C                   SELECT
 
      ** F3 - End Program
 
     C                   WHEN      PINKC = '1'
     C                   EXSR      SREndPgm
 
      ** F12 - Previous Screen
 
     C                   WHEN      PINKL = '1'
     C                   IF        PINKI = '1'
     C                   EVAL      PAction = 'I'
     C                   EXSR      SRFuncKeys
     C                   EXSR      SRFldSts
     C                   EVAL      WMsgType = PMType
     C                   EVAL      WSCRN = 'K'
     C                   ELSE
     C                   EVAL      WSCRN = 'B'
     C                   ENDIF
 
      ** Validate Input to Details Screen
 
     C                   OTHER
     C                   EXSR      SRValDets
     C                   ENDSL
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValDets - Validate input details screen                    *
      *                                                               *
      *  Called by: SRDetsScrn                                        *
      *                                                               *
      *  Calls    : SCWMSGVAL                                         *
      *                                                               *
      *****************************************************************
 
     C     SRValDets     BEGSR
 
      ** If Delete
 
     C                   IF        PAction = 'D'
 
      ** If F10 taken, update file.
 
     C                   IF        PINKJ = '1'
     C                   EVAL      WFMsgType = WMsgType
     C                   MOVE      WMsgTime      WFMsgTime
     C                   EVAL      WFLangCode = WLangCode
     C                   EVAL      WSCRN = 'U'
     C                   ELSE
     C                   EXSR      SRFuncKeys
     C                   EXSR      SRFldSts
     C                   EVAL      WSCRN = 'P'
     C                   ENDIF
 
      ** Initialize error indicators as 'OK'
 
     C                   EVAL      Idx  = *ZERO
     C                   EVAL      WIdx = *ZERO
     C                   MOVE      *ALL'Y'       OKFlags
     C                   ENDIF
 
      ** If Enquire
 
     C                   IF        PAction = 'E'
     C                   EVAL      WSCRN = 'R'
 
      ** Initialize error indicators as 'OK'
 
     C                   EVAL      Idx  = *ZERO
     C                   EVAL      WIdx = *ZERO
     C                   MOVE      *ALL'Y'       OKFlags
     C                   ENDIF
 
      ** If Amend
 
     C                   IF        PAction = 'A'
 
      ** Validate record details
      ** Prior to validation, initialize error indicators as 'OK'
 
     C                   EVAL      Idx  = *ZERO
     C                   EVAL      WIdx = *ZERO
     C                   MOVE      *ALL'Y'       OKFlags
 
     C                   CALLB     'SCWMSGVAL'
 
      ** Inputs
      ** Return Code
 
     C                   PARM      *BLANK        RetCodeOut
 
      ** Selection Option entered from Main Screen
 
     C                   PARM                    PMType
 
      ** Action Code
 
     C                   PARM                    PAction
 
      ** Transaction Details
 
     C                   PARM                    RecDets
 
      ** Outputs
      ** Record details OK indicators
 
     C                   PARM                    OKFlags
 
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM      *BLANKS       FldNameArr
     C                   PARM      *BLANKS       MsgIDArr
     C                   PARM      *BLANKS       MsgDtaArr
 
      ** Array index (3P0) from/to caller
 
     C                   PARM      0             Idx
 
      ** Warning fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM      *BLANKS       WFldNamArr
     C                   PARM      *BLANKS       WMsgIDArr
     C                   PARM      *BLANKS       WMsgDtaArr
 
      ** Array index (3P0) from/to caller
 
     C                   PARM      0             WIdx
 
      ** Valid Transaction details layout (DS) from/to caller
 
     C                   PARM      *BLANKS       RecFilFmt
 
      ** If errors returned
 
     C                   IF        Idx <> 0
     C                   EXSR      SRFuncKeys
     C                   EXSR      SRFldSts
     C                   EVAL      WSCRN = 'P'
     C                   ELSE
     C                   MOVE      *ALL'Y'       OKFlags
     C                   EVAL      WSCRN = 'U'
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRBldBrw - Build browse subfile                              *
      *                                                               *
      *  Called by: SRDetsScrn                                        *
      *                                                               *
      *  Calls    : SCWMSGVAL                                         *
      *                                                               *
      *****************************************************************
 
     C     SRBldBrw      BEGSR
 
      ** Reset Read next browse subfile record
 
     C                   EVAL      PSelect = *BLANK
     C                   EVAL      PRDNB = *BLANK
 
      ** Build Browse subfile
 
     C                   CALLB     'SCWMSGBRW'
 
      ** Input Parameters
      ** Return Code
 
     C                   PARM      *BLANKS       RetCodeOut
 
      ** Action Code
 
     C                   PARM                    PMType
 
      ** Build Sub-File
 
     C                   PARM      'Y'           PBDSFL
 
      ** Read Subfile Record
 
     C                   PARM      'N'           PRDSFL
 
      ** Errors
 
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
 
      ** Output Parameters
      ** Message Type Text
 
     C                   PARM      *BLANKS       PMTypTxt
 
      ** Selected Record
 
     C                   PARM      *BLANKS       SelRec
 
      ** Option Selected
 
     C                   PARM      *BLANKS       POPSEL
 
      ** Command Keys
 
     C                   PARM      '0'           PINKC
     C                   PARM      '0'           PINKI
     C                   PARM      '0'           PINKL
 
     C                   SELECT
 
      ** If F3 taken in browse, end program.
 
     C                   WHEN      PINKC = '1'
     C                   EXSR      SREndPgm
 
      ** If Insert (F9) selected from browse, go to key screen.
 
     C                   WHEN      PINKI = '1'
     C                   EVAL      RecDets = *BLANK
     C                   EVAL      PAction = 'I'
     C                   EXSR      SRFuncKeys
     C                   EXSR      SRFldSts
     C                   EVAL      WMsgType = PMType
     C                   EVAL      WSCRN = 'K'
 
      ** If F12 taken in browse, go back to initial screen.
 
     C                   WHEN      PINKL = '1'
     C                   EVAL      PAction = *BLANK
     C                   EXSR      SRFuncKeys
     C                   EXSR      SRFldSts
     C                   EVAL      WSCRN = 'I'
 
      ** Read next browse subfile record
 
     C                   OTHER
     C                   EVAL      PRDNB = 'Y'
     C                   EVAL      WSCRN = 'R'
     C                   ENDSL
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRdNBrw - Read Next Browse subfile record                   *
      *                                                               *
      *  Called by: SRDetsScrn                                        *
      *                                                               *
      *  Calls    : SCWMSGBRW, SRRtvDets, SRCvtDets, SRFldSts         *
      *                                                               *
      *****************************************************************
 
     C     SRRdNBrw      BEGSR
 
      ** Read Next Subfile Record
 
     C                   CALLB     'SCWMSGBRW'
 
      ** Input Parameters
      ** Return Code
 
     C                   PARM      *BLANKS       RetCodeOut
 
      ** Action Code
 
     C                   PARM                    PMType
 
      ** Build Sub-File
 
     C                   PARM      'N'           PBDSFL
 
      ** Read Subfile Record
 
     C                   PARM      'Y'           PRDSFL
 
      ** Errors
 
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
 
      ** Output Parameters
      ** Message Type Text
 
     C                   PARM                    PMTypTxt
 
      ** Selected Record
 
     C                   PARM      *BLANKS       SelRec
 
      ** Option Selected
 
     C                   PARM      *BLANKS       POPSEL
 
      ** Command Keys
 
     C                   PARM      '0'           PINKC
     C                   PARM      '0'           PINKI
     C                   PARM      '0'           PINKL
 
      ** If a record is read from subfile
 
     C                   IF        SelRec <> *BLANK
 
      ** Retrieve record details
 
     C                   EVAL      PAction = POPSEL
     C                   EVAL      PMType = WSMsgType
     C                   EVAL      PMTime = WSMsgTime
     C                   EVAL      PLang = WSLangCode
     C                   EXSR      SRRtvDets
 
      ** Convert record details
 
     C                   EXSR      SRCvtDets
 
      ** Display detail screen
 
     C                   EXSR      SRFuncKeys
     C                   EXSR      SRFldSts
     C                   EVAL      WSCRN = 'P'
 
      ** Else, rebuild subfile browse
 
     C                   ELSE
     C                   EVAL      WSCRN = 'B'
     C                   ENDIF
 
     C     EndRDNBRW     ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRtvDets - Retrieve record details                          *
      *                                                               *
      *  Called by: SRDetsScrn                                        *
      *                                                               *
      *  Calls    : SCWMSGRTV                                         *
      *                                                               *
      *****************************************************************
 
     C     SRRtvDets     BEGSR
 
      ** Retrieve record details
 
     C                   CALLB     'SCWMSGRTV'
 
      ** Input Parameters
      ** Return Code
 
     C                   PARM      *BLANKS       RetCodeOut
 
      ** Action Code
 
     C                   PARM                    PAction
 
      ** Message Type
 
     C                   PARM                    PMType
 
      ** Message Time
 
     C                   PARM                    PMTime
 
      ** Language Code
 
     C                   PARM                    PLang
 
      * Outputs
      * Transaction  Details in File Format
 
     C                   PARM                    PMText
 
      ** OK - Message Time
 
     C                   PARM      *BLANK        OKMTIM
 
      ** OK - Language Code
 
     C                   PARM      *BLANK        OKLANG
 
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
 
      ** Array index (3P0) from/to caller
 
     C                   PARM      0             Idx
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCvtDets - Convert record details                           *
      *                                                               *
      *  Called by: SRRdNBrw                                          *
      *                                                               *
      *  Calls    : SCWMSGCVT                                         *
      *                                                               *
      *****************************************************************
 
     C     SRCvtDets     BEGSR
 
      ** Convert Message Time from file to screen format.
 
     C                   CALLB     'SCWMSGCVT'
 
      ** Input Parameters
      ** Return Code
 
     C                   PARM      *BLANKS       RetCodeOut
 
      ** Message Time in file format
 
     C                   PARM                    PMTime
 
      ** Output Parameters
      ** Message Time in screen format
 
     C                   PARM      *BLANKS       PMinutes
     C                   PARM      *BLANKS       PSeconds
 
     C                   EVAL      WMsgType = WSMsgType
     C                   EVAL      WMsgTime = PMinutes + PSeconds
     C                   EVAL      WLangCode = WSLangCode
     C                   EVAL      WMsgText = PMText
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRFuncKeys - Set function key status on screen               *
      *                                                               *
      *  Called by: Main                                              *
      *                                                               *
      *  Calls    : None                                              *
      *                                                               *
      *****************************************************************
 
     C     SRFuncKeys    BEGSR
 
      ** Enable/disable function keys
      ** KJ = Command Key F10 = Confirm Delete
 
     C                   IF        PAction = 'D'
     C                   EVAL      PEINKJ = 'Y'
     C                   ELSE
     C                   EVAL      PEINKJ = 'N'
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCancMain - Cancel on Main Screen                           *
      *                                                               *
      *  Called by: SRMainScrn                                        *
      *                                                               *
      *  Calls    : None                                              *
      *                                                               *
      *****************************************************************
 
     C     SRCancMain    BEGSR
 
     C                   EVAL      WSCRN  = 'B'
     C                   EVAL      RecDets = *BLANK
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCancDets - Cancel on Detail Screen                         *
      *                                                               *
      *  Called by: SRDetsScrn                                        *
      *                                                               *
      *  Calls    : None                                              *
      *                                                               *
      *****************************************************************
 
     C     SRCancDets    BEGSR
 
     C                   IF        PAction = 'D' OR PAction = 'E'
     C                   EVAL      WSCRN  = 'B'
 
     C                   ELSE
     C                   EXSR      SRFuncKeys
     C                   EXSR      SRFldSts
     C                   EVAL      WMsgType = PMType
     C                   EVAL      WSCRN  = 'K'
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRUpdate - Update file                                       *
      *                                                               *
      *  Called by: Main                                              *
      *                                                               *
      *  Calls    : SCWMSGUPD                                         *
      *                                                               *
      *****************************************************************
 
     C     SRUpdate      BEGSR
 
     C                   IF        PAction = 'A' AND PINKI = '1'
     C                   EVAL      PAction = 'I'
     C                   ENDIF
 
      ** Update file
 
     C                   CALLB     'SCWMSGUPD'
 
      ** Input Parameters
      ** Return Code
 
     C                   PARM      *BLANKS       RetCodeOut
 
      ** Action Code
 
     C                   PARM                    PAction
 
      ** Record details in file format
 
     C                   PARM                    RecFilFmt
 
      ** If there were any errors in the update functions, rollback any
      ** updates and end this program. Otherwise, commit the updates
 
     C                   IF        RetCodeOut <> *BLANK
     C                   ROLBK
     C                   EXSR      *PSSR
     C                   ELSE
     C                   COMMIT
     C                   ENDIF
 
      ** If records are still to be read from the subfile, read them
 
     C                   IF        PRDNB = 'Y'
     C                   MOVEL     'R'           WSCRN
     C                   ELSE
 
      ** Else, return to Browse Subfile
 
     C                   EVAL      WSCRN = 'B'
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SREndPgm - End Program                                       *
      *                                                               *
      *  Called by: SRInitScrn, SRMainScrn, SRDetsScrn                *
      *                                                               *
      *  Calls    : None                                              *
      *                                                               *
      *****************************************************************
 
     C     SREndPgm      BEGSR
 
     C                   EVAL      WSCRN = 'T'
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Initial Processing                                  *
      *                                                               *
      *  Called by: Implicitly upon program activation                *
      *                                                               *
      *  Calls    : None                                              *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
      ** Initialize program name
 
     C                   EVAL      DBPGM = 'SCWMSGSIN'
 
     C                   CLEAR                   RecDets
     C                   MOVE      *ALL'Y'       OKFlags
     C                   EVAL      PAction = *BLANK
     C                   EXSR      SRFuncKeys
     C                   EXSR      SRFldSts
     C                   EVAL      WScrn = 'I'
 
      *  Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,SCWMSGS009
 
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
** CPY@
(c) Finastra International Limited 2001
