     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2014')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas DL Reporting Information Screen 4 Validate')     *
      *****************************************************************
      *                                                               *
      *  Midas - Dealing Module                                       *
      *                                                               *
      *  DLRIS4VAL - Midas DL Reporting Information Screen 4 Validate *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2014            *
      *                                                               *
      *  Last Amend No. CSW214  *CREATE    Date 25Nov14               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSW214 - SWIFT Changes 2014                                  *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *****************************************************************
 
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
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
      ** The following /COPY line includes definitions for the above fields
      ** as #ProcPgm, #ProcMod and #ProcName.  They are based on the
      ** corresponding fields in the PSDS /COPY member, so that member
      ** must be included where this one is used.
 
     D/COPY ZACPYSRC,PROCPARMS
 
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
 
      ** Named Constant used to determine if a field contains invalid
      ** characters for Telex and S.W.I.F.T.
 
     D ISO             C                   'ABCDEFGHIJKLMNOPQRSTUVWXYZ-
     D                                      abcdefghijklmnopqrstuvwxyz-
     D                                      1234567890 /+-?:().,'''
 
      ** Named Constant used to determine if an additional
      ** reporting information starts with '/codeword/'
 
     D CODEW           C                   'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D DLRILK        E DS                  EXTNAME(DLRILKPD)
      ** RPIF Link file
 
     D DLRIS1Detail  E DS                  EXTNAME(DLRIS1PD)
      ** Fields from Screen 1
 
     D DLRIS2Detail  E DS                  EXTNAME(DLRIS2PD)
      ** Fields from Screen 2
 
     D DLRIS3Detail  E DS                  EXTNAME(DLRIS3PD)
      ** Fields from Screen 3
 
     D DLRIS4Detail  E DS                  EXTNAME(DLRIS4PD)
      ** Fields to validate in screen 4
 
     D DLError4      E DS                  EXTNAME(DLERI4PD)
      ** OK flags for screen 4
 
     D DLVRPFileFmt  E DS                  EXTNAME(DLVRPIPD)
      ** Valid Deals layout
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for bank details
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for access programs, short data structure
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Field in error
     D FldNamXAr       S             10A
 
      ** Error message ID
     D MsgIDXAr        S                   LIKE(#MsgId)
 
      ** Error message data
     D MsgDtaXAr       S                   LIKE(#MsgData)
 
      ** Field with warning
     D WFldNmXAr       S             10A
 
      ** Warning message ID
     D WMsgIDXAr       S                   LIKE(#MsgId)
 
      ** Warning message data
     D WMsgDtXAr       S                   LIKE(#MsgData)
 
      ** Index for arrays of of error message ids etc
     D Idx             S              3P 0
 
      ** Index for arrays of of warning message ids etc
     D WIdx            S              3P 0
 
     D WRetCode        S             10A
     D WarnDesc        S              1A
     D ReqDesc         S              1A
     D BlankBFR        S              1A
     D BlankBFR2       S              1A
     D FldName         S              6A
     D WCodeWord       S             10A
     D FldChk          S             35A
     D ErrID           S              7A
     D FldChkOK        S              1A
     D Char1           S              1A
     D W               S              2  0
     D WW              S              2  0
     D I               S              3  0
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      ** Do Validations in Sequence
      ** Validate Additional Reporting Information
 
     C     'OTHR'        SCAN      R2RPJ1                                 94
     C  N94'OTHR'        SCAN      R2RPJ2                                 94
     C  N94'OTHR'        SCAN      R2RPJ3                                 94
     C  N94'OTHR'        SCAN      R2RPJ4                                 94
 
     C                   IF        *IN94 = *ON
     C                   EVAL      ReqDesc = 'Y'
     C                   EVAL      WarnDesc = 'N'
     C                   ENDIF
 
      ** Validate additional reporting info Line 1
 
     C                   EVAL      BlankBFR = 'N'
     C                   EVAL      BlankBFR2 = 'N'
     C                   EVAL      FldName = 'R4AR01'
     C                   EVAL      WCodeWord = R4AR01
     C                   EVAL      FldChk = R4AR01
     C                   EVAL      ErrID = '5046055'
     C                   EXSR      ResetErrs
     C                   EXSR      CodeCheck
     C                   EVAL      R4AR01OK = FldChkOK
 
      ** Validate additional reporting info Line 2
 
     C                   EVAL      FldName = 'R4AR02'
     C                   EVAL      WCodeWord = R4AR02
     C                   EVAL      FldChk = R4AR02
     C                   EVAL      ErrID = '5046056'
     C                   EXSR      ResetErrs
     C                   EXSR      CodeCheck
     C                   EVAL      R4AR02OK = FldChkOK
 
      ** Validate additional reporting info Line 3
 
     C                   EVAL      FldName = 'R4AR03'
     C                   EVAL      WCodeWord = R4AR03
     C                   EVAL      FldChk = R4AR03
     C                   EXSR      ResetErrs
     C                   EXSR      CodeCheck
     C                   EVAL      R4AR03OK = FldChkOK
 
      ** Validate additional reporting info Line 4
 
     C                   EVAL      FldName = 'R4AR04'
     C                   EVAL      WCodeWord = R4AR04
     C                   EVAL      FldChk = R4AR04
     C                   EXSR      ResetErrs
     C                   EXSR      CodeCheck
     C                   EVAL      R4AR04OK = FldChkOK
 
      ** Validate additional reporting info Line 5
 
     C                   EVAL      FldName = 'R4AR05'
     C                   EVAL      WCodeWord = R4AR05
     C                   EVAL      FldChk = R4AR05
     C                   EXSR      ResetErrs
     C                   EXSR      CodeCheck
     C                   EVAL      R4AR05OK = FldChkOK
 
      ** Validate additional reporting info Line 6
 
     C                   EVAL      FldName = 'R4AR06'
     C                   EVAL      WCodeWord = R4AR06
     C                   EVAL      FldChk = R4AR06
     C                   EXSR      ResetErrs
     C                   EXSR      CodeCheck
     C                   EVAL      R4AR06OK = FldChkOK
 
      ** Validate additional reporting info Line 7
 
     C                   EVAL      FldName = 'R4AR07'
     C                   EVAL      WCodeWord = R4AR07
     C                   EVAL      FldChk = R4AR07
     C                   EXSR      ResetErrs
     C                   EXSR      CodeCheck
     C                   EVAL      R4AR07OK = FldChkOK
 
      ** Validate additional reporting info Line 8
 
     C                   EVAL      FldName = 'R4AR08'
     C                   EVAL      WCodeWord = R4AR08
     C                   EVAL      FldChk = R4AR08
     C                   EXSR      ResetErrs
     C                   EXSR      CodeCheck
     C                   EVAL      R4AR08OK = FldChkOK
 
      ** Validate additional reporting info Line 9
 
     C                   EVAL      FldName = 'R4AR09'
     C                   EVAL      WCodeWord = R4AR09
     C                   EVAL      FldChk = R4AR09
     C                   EXSR      ResetErrs
     C                   EXSR      CodeCheck
     C                   EVAL      R4AR09OK = FldChkOK
 
      ** Validate additional reporting info Line 10
 
     C                   EVAL      FldName = 'R4AR10'
     C                   EVAL      WCodeWord = R4AR10
     C                   EVAL      FldChk = R4AR10
     C                   EXSR      ResetErrs
     C                   EXSR      CodeCheck
     C                   EVAL      R4AR10OK = FldChkOK
 
      ** Validate additional reporting info Line 11
 
     C                   EVAL      FldName = 'R4AR11'
     C                   EVAL      WCodeWord = R4AR11
     C                   EVAL      FldChk = R4AR11
     C                   EXSR      ResetErrs
     C                   EXSR      CodeCheck
     C                   EVAL      R4AR11OK = FldChkOK
 
      ** Validate additional reporting info Line 12
 
     C                   EVAL      FldName = 'R4AR12'
     C                   EVAL      WCodeWord = R4AR12
     C                   EVAL      FldChk = R4AR12
     C                   EXSR      ResetErrs
     C                   EXSR      CodeCheck
     C                   EVAL      R4AR12OK = FldChkOK
 
      ** Validate additional reporting info Line 13
 
     C                   EVAL      FldName = 'R4AR13'
     C                   EVAL      WCodeWord = R4AR13
     C                   EVAL      FldChk = R4AR13
     C                   EXSR      ResetErrs
     C                   EXSR      CodeCheck
     C                   EVAL      R4AR13OK = FldChkOK
 
      ** Validate additional reporting info Line 14
 
     C                   EVAL      FldName = 'R4AR14'
     C                   EVAL      WCodeWord = R4AR14
     C                   EVAL      FldChk = R4AR14
     C                   EXSR      ResetErrs
     C                   EXSR      CodeCheck
     C                   EVAL      R4AR14OK = FldChkOK
 
      ** Validate additional reporting info Line 15
 
     C                   EVAL      FldName = 'R4AR15'
     C                   EVAL      WCodeWord = R4AR15
     C                   EVAL      FldChk = R4AR15
     C                   EXSR      ResetErrs
     C                   EXSR      CodeCheck
     C                   EVAL      R4AR15OK = FldChkOK
 
      ** Validate additional reporting info Line 16
 
     C                   EVAL      FldName = 'R4AR16'
     C                   EVAL      WCodeWord = R4AR16
     C                   EVAL      FldChk = R4AR16
     C                   EXSR      ResetErrs
     C                   EXSR      CodeCheck
     C                   EVAL      R4AR16OK = FldChkOK
 
      ** Validate additional reporting info Line 17
 
     C                   EVAL      FldName = 'R4AR17'
     C                   EVAL      WCodeWord = R4AR17
     C                   EVAL      FldChk = R4AR17
     C                   EXSR      ResetErrs
     C                   EXSR      CodeCheck
     C                   EVAL      R4AR17OK = FldChkOK
 
      ** Validate additional reporting info Line 18
 
     C                   EVAL      FldName = 'R4AR18'
     C                   EVAL      WCodeWord = R4AR18
     C                   EVAL      FldChk = R4AR18
     C                   EXSR      ResetErrs
     C                   EXSR      CodeCheck
     C                   EVAL      R4AR18OK = FldChkOK
 
      ** Validate additional reporting info Line 19
 
     C                   EVAL      FldName = 'R4AR19'
     C                   EVAL      WCodeWord = R4AR19
     C                   EVAL      FldChk = R4AR19
     C                   EXSR      ResetErrs
     C                   EXSR      CodeCheck
     C                   EVAL      R4AR19OK = FldChkOK
 
      ** Validate additional reporting info Line 20
 
     C                   EVAL      FldName = 'R4AR20'
     C                   EVAL      WCodeWord = R4AR20
     C                   EVAL      FldChk = R4AR20
     C                   EXSR      ResetErrs
     C                   EXSR      CodeCheck
     C                   EVAL      R4AR20OK = FldChkOK
 
      ** If no errors set up outstanding fields for valid file
 
     C                   IF        Idx = 0
     C                   EXSR      SetupValid
     C                   ENDIF
 
      ** Return to calling program
 
     C                   RETURN
      *****************************************************************
     C/EJECT
      *****************************************************************
     C     CodeCheck     BEGSR
 
     C                   EVAL      FldChkOK = *BLANKS
 
      ** Send warning message if a line is blank
      ** and at least one of the reporting jurisdictions is 'OTHR'.
 
     C                   IF        FldChk = *BLANKS
 
     C                   IF        ReqDesc = 'Y' AND
     C                             WarnDesc = 'N'
     C                   EVAL      WFldNmXAr = FldName
     C                   EVAL      WMsgIDXAr = '5046057'
     C                   EXSR      UpDatErrs
     C                   EVAL      WarnDesc = 'Y'
     C                   ENDIF
 
     C                   EVAL      BlankBFR = 'Y'
     C                   GOTO      ECodeCheck
 
     C                   ENDIF
 
      ** Check that no embedded blank exists.
 
     C                   IF        BlankBFR = 'Y'
     C                   IF        BlankBFR2 = 'N'
     C                   EVAL      FldNamXAr = FldName
     C                   EVAL      MsgIDXAr = '5046085'
     C                   EVAL      FldChkOK = 'N'
     C                   EXSR      UpDatErrs
     C                   EVAL      BlankBFR2 = 'Y'
     C                   ENDIF
     C                   GOTO      ECodeCheck
     C                   ENDIF
 
      ** Check that first character is '/'
 
     C                   EVAL      W = 0
     C                   EVAL      Char1 = WCodeWord
     C                   IF        Char1 <> '/'
     C                   EVAL      FldNamXAr = FldName
     C                   EVAL      MsgIDXAr = ErrID
     C                   EVAL      FldChkOK = 'N'
     C                   EXSR      UpDatErrs
 
     C                   ELSE
 
      ** Check existence of second '/' in the first 10 characters
      ** of the description field
 
     C     '/'           SCAN      WCodeWord:2   W                        96
     C                   IF        *IN96 = *OFF
     C                   EVAL      FldNamXAr =  FldName
     C                   EVAL      MsgIDXAr = ERRID
     C                   EVAL      FldChkOK = 'N'
     C                   EXSR      UpDatErrs
     C                   ENDIF
 
     C                   ENDIF
 
      ** Line 1 must not start with '//'
 
     C                   IF        W = 2 AND FldName = 'R4AR01'
     C                   EVAL      FldNamXAr = FldName
     C                   EVAL      MsgIDXAr = ERRID
     C                   EVAL      FldChkOK = 'N'
     C                   EXSR      UpDatErrs
     C                   ENDIF
 
      ** Check that characters in between the two / are capital letters.
 
     C     CODEW         CHECK     WCodeWord:2   WW                       95
     C                   IF        *IN95 = *ON AND WW < W
     C                   EVAL      FldNamXAr = FldName
     C                   EVAL      MsgIDXAr = ERRID
     C                   EVAL      FldChkOK = 'N'
     C                   EXSR      UpDatErrs
     C                   ENDIF
 
      ** Check that field value only contain SWIFT characters
 
     C     ISO           CHECK     FldChk                                 98
     C                   IF        *IN98 = *ON
     C                   EVAL      FldNamXAr = FldName
     C                   EVAL      MsgIDXAr = '5046054'
     C                   EVAL      FldChkOK = 'N'
     C                   EXSR      UpDatErrs
     C                   ENDIF
 
     C     ECodeCheck    ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
     C     SetupValid    BEGSR
 
      ** Move validated fields to DLVRPIPD fields
 
     C                   EVAL      RVAR01 = R4AR01
     C                   EVAL      RVAR02 = R4AR02
     C                   EVAL      RVAR03 = R4AR03
     C                   EVAL      RVAR04 = R4AR04
     C                   EVAL      RVAR05 = R4AR05
     C                   EVAL      RVAR06 = R4AR06
     C                   EVAL      RVAR07 = R4AR07
     C                   EVAL      RVAR08 = R4AR08
     C                   EVAL      RVAR09 = R4AR09
     C                   EVAL      RVAR10 = R4AR10
     C                   EVAL      RVAR11 = R4AR11
     C                   EVAL      RVAR12 = R4AR12
     C                   EVAL      RVAR13 = R4AR13
     C                   EVAL      RVAR14 = R4AR14
     C                   EVAL      RVAR15 = R4AR15
     C                   EVAL      RVAR16 = R4AR16
     C                   EVAL      RVAR17 = R4AR17
     C                   EVAL      RVAR18 = R4AR18
     C                   EVAL      RVAR19 = R4AR19
     C                   EVAL      RVAR20 = R4AR20
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    WRetCode
     C                   PARM                    DLRILK
     C                   PARM                    DLRIS1Detail
     C                   PARM                    DLRIS2Detail
     C                   PARM                    DLRIS3Detail
     C                   PARM                    DLRIS4Detail
     C                   PARM                    DLError4
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    Idx
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    WIdx
     C                   PARM                    DLVRPFileFmt
 
      **  Move program name into *LDA field.
 
     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM = 'DLRIS4VAL'
     C                   OUT       LDA
 
      ** Access bank details
 
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*MSG    '    @RTCD
     C                   PARM      '*FIRST  '    @OPTN
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Set up the name of the MSGF from which the message handler will
      **  get the messages
 
     C                   EVAL      #MsgFile = 'DRSMM'
 
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * ResetErrs - Reset error information that is received back     *
      *    from each validation module.                               *
      *****************************************************************
 
     C     ResetErrs     BEGSR
 
      ** Reset error & warning fields/message IDs/message data (arrays)
 
     C                   EVAL      FldNamXAr = *BLANKS
     C                   EVAL      MsgIDXAr  = *BLANKS
     C                   EVAL      MsgDtaXAr = *BLANKS
     C                   EVAL      WFldNmXAr = *BLANKS
     C                   EVAL      WMsgIDXAr = *BLANKS
     C                   EVAL      WMsgDtXAr = *BLANKS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * UpDatErrs - Update error information with that received back  *
      *    from each validation module.                               *
      *****************************************************************
 
     C     UpDatErrs     BEGSR
 
      ** Update error fields/message IDs/message data (arrays)
 
     C                   IF        FldNamXAr <> *BLANKS
 
     C                   Z-ADD     1             I
     C     *BLANK        LOOKUP    FldNameArr(I)                          99
     C                   IF        *IN99 = *ON
     C                   EVAL      FldNameArr(I) = FldNamXAr
     C                   EVAL      MsgIdArr(I) = MsgIDXAr
     C                   EVAL      MsgDtaArr(I) = MsgDtaXAr
     C                   END
 
     C                   Z-ADD     I             Idx
 
     C                   ENDIF
 
      ** Update warning fields/message IDs/message data (arrays)
 
     C                   IF        WFldNmXAr <> *BLANKS
 
     C                   Z-ADD     1             I
     C     *BLANK        LOOKUP    WFldNamArr(I)                          99
     C                   IF        *IN99 = *ON
     C                   EVAL      WFldNamArr(I) = WFldNmXAr
     C                   EVAL      WMsgIDArr(I) = WMsgIDXAr
     C                   EVAL      WMsgDtaArr(I) = WMsgDtXAr
     C                   END
 
     C                   Z-ADD     I             WIdx
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
