     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Watch list configuration input')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDWLCCSIN - Watch List Configuration Input                   *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. BUG27991           Date 10Aug10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD019             Date 02Jun03               *
      *                 CSD015  *CREATE    Date 14Oct02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  BUG27991 - WLC Config Maintenance - Unable to select         *
      *             multiple records on initial screen                *
      *  CSD019 - Midas Compliance Watch - Entry Level Watch List     *
      *           Checking                                            *
      *  CSD015 - Midas Compliance Watch - Watch List Checking        *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
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
 
     D MTYPARR         S              3A   DIM(20)
     D INEXARR         S              1A   DIM(20)
 
     D WLCMDets      E DS                  EXTNAME(SDWLCMPD)
      ** Watch List Configuration Definition File
 
     D ValidWLCM     E DS                  EXTNAME(SDWLCMPD)
     D                                     PREFIX(V)
      ** Validated Watch List Configuration Definition File
 
     D OKWLCMDets    E DS                  EXTNAME(SDEWLCMPD)
      ** Watch List Configuration Error File
 
     D WLCCFilFmt    E DS                  EXTNAME(SDWLCCPD)
      ** Watch List Configuration in File Format
 
     D CWCDFilFmt    E DS                  EXTNAME(SDCWCDPD)
      ** Watch List Configuration Data in File Format
                                                                                              CSD019
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CSD019
      ** Midas SC Switchable features descriptions                                            CSD019
                                                                                              CSD019
                                                                                              CSD019
     D DSFDY         E DS                  EXTNAME(DSFDY)                                     CSD019
      ** Short data structure                                                                 CSD019
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index of errors
     D Idx             S              3P 0
 
     D E               S              3P 0
     D WSCRN           S              1A
     D RespMode        S              1A
     D PINKC           S              1A
     D PINKL           S              1A
     D PINKH           S              1A
     D PACTN           S              1A
     D PFUNC           S              8A
     D PRDSFL          S              1A
     D PBDSFL          S              1A
     D PERRMS          S              7A
     D POPSEL          S              1A
     D PFNCSEL         S              8A
     D OKACTN          S              1A
     D OKFUNC          S              1A
     D PRTCD           S              7A
     D P_Retcd         S              7                                                       CSD019
     D P_Optn          S              7                                                       CSD019
     D P_Sard          S              6                                                       CSD019
     D CSD019          S              1A                                                      CSD019
     D PRDNXT          S              1A                                                    BUG27991
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
     C                   DOW       WSCRN <> 'T'
 
      ** Build browse subfile record
 
     C                   DOW       WSCRN = 'B'
     C                   IF        PRDNXT = 'Y'                                             BUG27991
     C                   EXSR      SRRdNxtSF                                                BUG27991
     C                   ENDIF                                                              BUG27991
     C                   EXSR      SRBldBrw
     C                   ENDDO
 
      ** Do while screen: Transaction Detail Screen
 
     C                   DOW       WSCRN = 'P'
     C                   EXSR      SRDisplay
     C                   ENDDO
 
     C                   ENDDO
 
      ** Terminate program
 
     C                   EVAL      *INLR = *ON
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRDisplay - Process Detail Screen                             *
      *                                                               *
      *****************************************************************
 
     C     SRDisplay     BEGSR
 
     C                   CALLB     'SDWLCCDSP'
 
      ** Input Parameters :
      ** Return Code
     C                   PARM      *BLANKS       RetCodeIn
      ** Watch List Configuration Definition File
     C                   PARM                    WLCMDets
      ** Watch List Configuration Error File
     C                   PARM                    OKWLCMDets
      ** Errors
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
 
      ** Output Parameters :
      ** Function Keys
     C                   PARM      *OFF          PINKC
     C                   PARM      *OFF          PINKL
 
      ** Reset errors
 
     C                   MOVE      *ALL'Y'       OKWLCMDets
     C                   EVAL      FldNameArr = *BLANKS
     C                   EVAL      MsgIdArr   = *BLANKS
     C                   EVAL      MsgDtaArr  = *BLANKS
 
      ** F3 - End program
 
     C     PINKC         CASEQ     *ON           SREnd
 
      ** F12 - Cancel on Details Screen
 
     C     PINKL         CASEQ     *ON           SRCancel
 
      ** Validate input to Details Screen
 
     C                   CAS                     SRValidate
 
     C                   ENDCS
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRValidate - Validate Input to Details Screen                 *
      *                                                               *
      *****************************************************************
 
     C     SRValidate    BEGSR
 
      ** Validate Transaction Detail
 
     C                   EVAL      Idx  = *ZEROS
     C                   MOVE      *ALL'Y'       OKWLCMDets
 
     C                   CALLB     'SDWLCCVAL'
 
      ** Inputs
      ** Watch List Configuration Definition File
     C                   PARM                    WLCMDets
 
      ** Outputs
      ** Watch List Configuration Error File
     C                   PARM                    OKWLCMDets
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      ** Array index (3P0) from/to caller
     C                   PARM                    Idx
      ** Valid Watch List Configuration Definition File
     C                   PARM                    ValidWLCM
 
      ** If errors returned
 
     C                   IF        Idx <> 0
     C                   GOTO      EndVAL@P
     C                   ENDIF
 
      ** Clear any error messages
 
     C                   MOVE      *ALL'Y'       OKWLCMDets
 
     C                   EXSR      SRUpdate
 
     C     EndVAL@P      ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRBldBrw - Build Browse Subfile                               *
      *                                                               *
      *****************************************************************
 
     C     SRBldBrw      BEGSR
 
     C                   IF        PRDNXT <> 'Y'                                            BUG27991
      ** Build Browse subfile
 
     C                   CALLB     'SDWLCCBRW'
 
      ** Input Parameters :
      ** Return Code
     C                   PARM      *BLANKS       RetCodeIn
      ** Action Code
     C                   PARM      *BLANKS       PACTN
      ** Function Code
     C                   PARM                    PFUNC
      ** Build Subfile
     C                   PARM      'Y'           PBDSFL
      ** Read Subfile Record
     C                   PARM      *BLANKS       PRDSFL
      ** Error
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
 
      ** Output Parameters :
      ** Command Keys
     C                   PARM      *OFF          PINKC
     C                   PARM      *OFF          PINKH
      ** Error Message
     C                   PARM      *BLANKS       PERRMS
      ** Option Selected
     C                   PARM      *BLANKS       POPSEL
      ** Function Code Selected
     C                   PARM      *BLANKS       PFNCSEL
                                                                                            BUG27991
     C                   ENDIF                                                              BUG27991
 
      ** If F3 taken in browse, end program
 
     C                   IF        PINKC = *ON
     C                   EXSR      SREnd
     C                   GOTO      EndBLDBRW
     C                   ENDIF
 
      ** If error message returned from browse, send it to detail screen
 
     C                   IF        PERRMS <> *BLANKS
     C                   EXSR      SRSndMsg
     C                   EVAL      WSCRN = 'B'
     C                   GOTO      EndBLDBRW
     C                   ENDIF
 
     C                   IF        PFNCSEL <> *BLANKS or
     C                             PINKH = *ON
 
      ** Retrieve record
 
     C                   EVAL      PACTN = POPSEL
     C                   EVAL      PFUNC = PFNCSEL
 
     C                   EXSR      SRRetrieve
 
      ** Stay on browse screen if there is an error
 
     C                   IF        OKFUNC = 'N' or OKACTN = 'N'
     C                   EVAL      WSCRN = 'B'
     C                   GOTO      EndBLDBRW
     C                   ENDIF
 
     C                   IF        PINKH = *ON
     C                   EXSR      SRUpdate
     C                   ELSE
      ** Convert record
 
     C                   EXSR      SRConvert
 
      ** Put details in screen
 
     C                   EVAL      WSCRN = 'P'
     C                   ENDIF
     C                   EVAL      PRDNXT = 'Y'                                             BUG27991
 
      ** Else, rebuild subfile browse
 
     C                   ELSE
     C                   EXSR      SRInit
     C                   ENDIF
 
     C     EndBLDBRW     ENDSR
 
      *****************************************************************                     BUG27991
      /EJECT                                                                                BUG27991
      *****************************************************************                     BUG27991
      *                                                               *                     BUG27991
      * SRRdNxtSF - Read next Subfile record                          *                     BUG27991
      *                                                               *                     BUG27991
      *****************************************************************                     BUG27991
                                                                                            BUG27991
     C     SRRdNxtSF     BEGSR                                                              BUG27991
                                                                                            BUG27991
      ** Build Browse subfile                                                               BUG27991
                                                                                            BUG27991
     C                   CALLB     'SDWLCCBRW'                                              BUG27991
                                                                                            BUG27991
      ** Input Parameters :                                                                 BUG27991
      ** Return Code                                                                        BUG27991
     C                   PARM      *BLANKS       RetCodeIn                                  BUG27991
      ** Action Code                                                                        BUG27991
     C                   PARM      *BLANKS       PACTN                                      BUG27991
      ** Function Code                                                                      BUG27991
     C                   PARM                    PFUNC                                      BUG27991
      ** Build Subfile                                                                      BUG27991
     C                   PARM      *BLANKS       PBDSFL                                     BUG27991
      ** Read Subfile Record                                                                BUG27991
     C                   PARM      'Y'           PRDSFL                                     BUG27991
      ** Error                                                                              BUG27991
     C                   PARM                    FldNameArr                                 BUG27991
     C                   PARM                    MsgIdArr                                   BUG27991
     C                   PARM                    MsgDtaArr                                  BUG27991
                                                                                            BUG27991
      ** Output Parameters :                                                                BUG27991
      ** Command Keys                                                                       BUG27991
     C                   PARM      *OFF          PINKC                                      BUG27991
     C                   PARM      *OFF          PINKH                                      BUG27991
      ** Error Message                                                                      BUG27991
     C                   PARM      *BLANKS       PERRMS                                     BUG27991
      ** Option Selected                                                                    BUG27991
     C                   PARM      *BLANKS       POPSEL                                     BUG27991
      ** Function Code Selected                                                             BUG27991
     C                   PARM      *BLANKS       PFNCSEL                                    BUG27991
                                                                                            BUG27991
      ** If No Subfile record was returned (i.e. no more records with                       BUG27991
      ** action code = 'A'), rebuild subfile                                                BUG27991
                                                                                            BUG27991
     C                   IF        POPSEL = *BLANKS                                         BUG27991
     C                   EVAL      PRDNXT = *BLANKS                                         BUG27991
     C                   ENDIF                                                              BUG27991
                                                                                            BUG27991
     C                   ENDSR                                                              BUG27991
                                                                                            BUG27991
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRRetrieve - Retrieve Transaction Details                     *
      *                                                               *
      *****************************************************************
 
     C     SRRetrieve    BEGSR
 
      ** Retrieve transaction details
 
     C                   CALLB     'SDWLCCRTV'
 
      ** INPUTS
      ** Return Code
     C                   PARM      *BLANKS       RetCodeIn
      ** Response Mode
     C                   PARM      'S'           RespMode
      ** Action Code
     C                   PARM                    PACTN
      ** Function Code
     C                   PARM                    PFUNC
      ** F8 Key
     C                   PARM                    PINKH
 
      ** OUTPUTS
      ** Watch List Configuration in File Format
     C                   PARM      *BLANKS       WLCCFilFmt
      ** Watch List Configuration Data in File Format
     C                   PARM      *BLANKS       CWCDFilFmt
      ** Message Type
     C                   PARM      *BLANKS       MTYPARR
      ** Include/Exclude Indicator
     C                   PARM      *BLANKS       INEXARR
      ** OK - Action Code
     C                   PARM      *BLANKS       OKACTN
      ** OK - Function Code
     C                   PARM      *BLANKS       OKFUNC
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
      * SRConvert - Put a Transaction Detail on Screen                *
      *                                                               *
      *****************************************************************
 
     C     SRConvert     BEGSR
 
     C                   CALLB     'SDWLCCCVT'
 
      ** Input Parameters
      ** Return Code
     C                   PARM      *BLANKS       RetCodeIn
      ** Watch List Configuration in File Format
     C                   PARM                    WLCCFilFmt
      ** Message Type
     C                   PARM                    MTYPARR
      ** Include/Exclude Indicator
     C                   PARM                    INEXARR
 
      ** Output Parameters
      ** Watch List Configuration Definition File
     C                   PARM                    WLCMDets
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRSndMsg - Send a Message to Detail Screen                    *
      *                                                               *
      *****************************************************************
 
     C     SRSndMsg      BEGSR
 
      ** Add error message to array passed to detail screen
 
     C                   Z-ADD     1             E
     C     *BLANKS       LOOKUP    FldNameArr(E)                          75
     C                   MOVEL     '*ANY'        FldNameArr(E)
     C                   MOVEL     PERRMS        MsgIdArr(E)
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRUpdate - Update File                                        *
      *                                                               *
      *****************************************************************
 
     C     SRUpdate      BEGSR
 
     C                   CALLB     'SDWLCCUPD'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM                    PINKH
     C                   PARM                    ValidWLCM
 
      ** If there were any errors in the update functions, rollback any
      ** updates and end this program. Otherwise, commit the updates and
      ** go back to Browse screen.
 
     C                   IF        PRTCD <> *BLANKS
     C                   ROLBK
     C                   IF        PRTCD <> '*RECUPD'
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ELSE
     C                   EVAL      WSCRN = 'B'
     C                   COMMIT
     C                   ENDIF
 
      ** If update not done due to record being updated by another
      ** workstation send message to screen
     C
     C                   IF        PRTCD = '*RECUPD'
     C                   MOVEL     '*ANY'        FldNameArr(1)
     C                   MOVEL     'MMM1067'     MsgIdArr(1)
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SREnd - End Program                                           *
      *                                                               *
      *****************************************************************
 
     C     SREnd         BEGSR
 
     C                   EVAL      WSCRN = 'T'
 
     C                   ENDSR
 
      *****************************************************************
      *                                                               *
      * SRCancel - Cancel on Detail Screen                            *
      *                                                               *
      *****************************************************************
 
     C     SRCancel      BEGSR
 
      ** Return to previous screen
 
     C                   EVAL      PFUNC = *BLANKS
 
     C                   EVAL      WSCRN  = 'B'
     C                   EVAL      PRDNXT = *BLANKS                                         BUG27991
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRInit - Go To Initial Screen                                 *
      *                                                               *
      *****************************************************************
 
     C     SRInit        BEGSR
 
     C                   EVAL      PFUNC = *BLANKS
 
      ** Blank the screens
 
     C                   EVAL      WLCMDets = *BLANKS
 
     C                   MOVEL     'B'           WSCRN
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Initial Processing                                   *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
      ** Initialize program name
 
     C                   MOVEL     'SDWLCCSIN'   DBPGM
     C                   MOVEL     'B'           WSCRN
 
      ** Clear DS parameter arrays
 
     C                   CLEAR                   WLCCFilFmt
     C                   CLEAR                   ValidWLCM
     C                   CLEAR                   WLCMDets
     C                   MOVE      *ALL'Y'       OKWLCMDets
                                                                                              CSD019
      ** Check if CSD019 is installed                                                         CSD019
                                                                                              CSD019
     C                   EVAL      CSD019 = 'N'                                               CSD019
     C                   CALLB     'AOSARDR0'                                                 CSD019
     C                   PARM      *BLANKS       P_RetCd                                      CSD019
     C                   PARM      '*VERIFY'     P_Optn                                       CSD019
     C                   PARM      'CSD019'      P_Sard                                       CSD019
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD019
                                                                                              CSD019
      ** Database error                                                                       CSD019
                                                                                              CSD019
     C                   IF        (P_RetCd <> *BLANKS) and                                   CSD019
     C                             (P_RetCd <> '*NRF   ')                                     CSD019
     C                   EVAL      DBKEY = 'CSD019'                                           CSD019
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSD019
     C                   EVAL      DBASE = 002                                                CSD019
     C                   EXSR      *PSSR                                                      CSD019
     C                   ENDIF                                                                CSD019
                                                                                              CSD019
     C                   IF        P_RetCd = *BLANKS                                          CSD019
     C                   RETURN                                                               CSD019
     C                   ENDIF                                                                CSD019
 
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
