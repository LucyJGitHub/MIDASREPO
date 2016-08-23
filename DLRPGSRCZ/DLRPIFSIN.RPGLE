     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2013')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas DL Reporting Information Maintenance')           *
      *****************************************************************
      *                                                               *
      *  Midas - Money Market Dealing Module                          *
      *                                                               *
      *  DLRPIFSIN - Midas DL Reporting Information Maintenance       *
      *                                                               *
      *  Function:  This is the main screen input function for        *
      *             DL Reporting Information Maintenance              *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2013            *
      *                                                               *
      *  Last Amend No. MD029862           Date 25Nov14               *
      *  Prev Amend No. CSW214             Date 25Nov14               *
      *                 MD024151           Date 18Dec13               *
      *                 MD023197           Date 03Nov13               *
      *                 CSW213  *CREATE    Date 03Jun13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD029862 - Various Function Key Errors in Deals Enquiry      *
      *  CSW214 - SWIFT Changes 2014                                  *
      *  MD024151 - Missing parameter for DLRPIFDFT/DLRPIFVU.         *
      *  MD023197 - Link Swap ID shown for other APIs other than FXDL *
      *             with both currencies tagged as non-precious       *
      *             metals.                                           *
      *  CSW213 - SWIFT Changes 2013                                  *
      *                                                               *
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
 
      * Transaction Reporting File Format
     D DLRPIFileFmt  E DS                  EXTNAME(DLRPIFPD)
 
      * Valid RPIF File Format
     D DLVRPFileFmt  E DS                  EXTNAME(DLVRPIPD)
 
      * RPIF Error File - Screen 1
     D DLError1      E DS                  EXTNAME(DLERI1PD)
 
      * RPIF Error File - Screen 2
     D DLError2      E DS                  EXTNAME(DLERI2PD)
 
      * RPIF Error File - Screen 3
     D DLError3      E DS                  EXTNAME(DLERI3PD)
                                                                                              CSW214
      * RPIF Error File - Screen 4                                                            CSW214
     D DLError4      E DS                  EXTNAME(DLERI4PD)                                  CSW214
 
      * RPIF Link File
     D DLRILKDetail  E DS                  EXTNAME(DLRILKPD)
 
      * Transaction Reporting Screen (1)
     D DLRIS1Detail  E DS                  EXTNAME(DLRIS1PD)
 
      * Transaction Reporting Screen (2)
     D DLRIS2Detail  E DS                  EXTNAME(DLRIS2PD)
 
      * Transaction Reporting Screen (3)
     D DLRIS3Detail  E DS                  EXTNAME(DLRIS3PD)
                                                                                              CSW214
      * Transaction Reporting Screen (4)                                                      CSW214
     D DLRIS4Detail  E DS                  EXTNAME(DLRIS4PD)                                  CSW214
 
      * Transaction Reporting Screen (1) Output
     D DLRIS1PDOut   E DS                  EXTNAME(DLRIS1PD)
     D                                     PREFIX(OUT)
      * Transaction Reporting Screen (2) Output
     D DLRIS2PDOut   E DS                  EXTNAME(DLRIS2PD)
     D                                     PREFIX(OUT)
      * Transaction Reporting Screen (3) Output
     D DLRIS3PDOut   E DS                  EXTNAME(DLRIS3PD)
     D                                     PREFIX(OUT)
      * Transaction Reporting Screen (4) Output                                               CSW214
     D DLRIS4PDOut   E DS                  EXTNAME(DLRIS4PD)                                  CSW214
     D                                     PREFIX(OUT)                                        CSW214
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D UpdateYN        S              1A
 
     D ValScrnNo       S              1  0
     D Screen          S              1A
 
     D ErrFlag         S              1A
     D***ValidScrn3      S              1A                                                    CSW214
     D ValidAllScreen  S              1A                                                      CSW214
 
     D INKC            S              1A
     D INKL            S              1A
 
     D Idx             S              3  0
     D WIdx            S              3  0
 
     D APIRetc         S              1A
     D IX              S              2  0
     D PModeOp         S              6A
 
     D PTranRefOK      S              1A
     D DFOfcrIDOK      S              1A
     D WNoRepFlag      S              1A
     D ScrPrv          S              1  0                                                  MD029862
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      /COPY WNCPYSRC,FXFXDLS008
 
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
      *
     C                   EVAL      ValScrnNo = 0
     C                   EVAL      ErrFlag = 'Y'
     C**********         EVAL      ValidScrn3 = 'N'                                           CSW214
     C                   EVAL      ValidAllScreen = 'N'                                       CSW214
      *
      ** Check if in Update mode or not
      *
     C                   IF        UpdateYN = 'Y'
 
     C                   EVAL      Screen = 'U'
 
     C                   ELSE
 
     C                   EVAL      Screen = '1'
     C                   IF        RLACTN <> 'I'
     C                             and DLRIS1Detail = *BLANKS
     C                             and DLRIS2Detail = *BLANKS
     C                             and DLRIS3Detail = *BLANKS
     C                             AND DLRIS4Detail = *BLANKS                                 CSW214
     C                   EXSR      RtvDel
     C                   ENDIF
 
     C                   ENDIF
      *
      ** First screen
      *
     C                   DOW       Screen <> 'U' AND                                        MD029862
     C                             Screen <> 'T'                                            MD029862
     C                   DOW       Screen = '1'
     C                   EXSR      Scrn1
     C                   ENDDO
      *
      ** Second screen
      *
     C                   DOW       Screen = '2'
     C                   EXSR      Scrn2
     C                   ENDDO
      *
      ** Third screen
      *
     C                   DOW       Screen = '3'
     C                   EXSR      Scrn3
     C                   ENDDO
                                                                                              CSW214
      ** Fourth screen                                                                        CSW214
                                                                                              CSW214
     C                   DOW       Screen = '4'                                               CSW214
     C                   EXSR      Scrn4                                                      CSW214
     C                   ENDDO                                                                CSW214
     C                   ENDDO                                                              MD029862
      *
      ** Call DLRPIFVU for updates
      *
     C                   IF        Screen = 'U'
     C                   EXSR      Updats
     C                   ENDIF
      *
      ** Terminate Program
      *
     C                   IF        Screen = 'T'
     C                   EVAL      *INLR = *ON
     C                   ENDIF
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      * Scrn1 - Process First Screen
      *
      *****************************************************************
     C     Scrn1         BEGSR
      *
     C                   EVAL      ValScrnNo = 1
      *
      ** Write/Read display screen
      *
     C                   CALLB     'DLRIS1DSP'
      *
      ** Input parameters
      *
      ** Return code
     C                   PARM      *BLANK        RetCodeOut
      *
      ** Action code
     C                   PARM                    RLACTN
      *
      ** Transaction Reporting screen 1
     C                   PARM                    DLRIS1Detail
      *
      ** Fields in error
     C                   PARM                    DLError1
      *
      ** Errors
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ** Warnings
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
      ** Output parameters
      *
      * Function keys
     C                   PARM      '0'           INKC
     C                   PARM      '0'           INKL
      *                                                                                     MD023197
     C                   PARM                    DLRILKDetail                               MD023197
      *
      ** Reset errors
      *
     C                   CLEAR                   DLError1
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIdArr
     C                   MOVEL     *BLANK        MsgDtaArr
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
      *
      ** CK/3 - End program
      *
     C     INKC          CASEQ     '1'           EndP
      *
      ** CK/12 - Cancel on main details screen
      *
     C     INKL          CASEQ     '1'           SrCanc
      *
      ** Validate input to first screen
      *
     C                   CAS                     ValS1
     C                   ENDCS
 
     C                   ENDSR
 
      /EJECT
      *****************************************************************
      *
      * Scrn2 - Process Second Screen
      *
      *****************************************************************
     C     Scrn2         BEGSR
      *
     C                   EVAL      ValScrnNo = 2
      ** Write/Read display screen
      *
     C                   CALLB     'DLRIS2DSP'
      *
      ** Input parameters
      *
      ** Return code
     C                   PARM      *BLANK        RetCodeOut
      *
      ** Action code
     C                   PARM                    RLACTN
      *
      ** Transaction Reporting screen 2
     C                   PARM                    DLRIS2Detail
      *
      ** Fields in error
     C                   PARM                    DLError2
      *
      ** Errors
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ** Warnings
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
      ** Output parameters
      *
      * Function keys
     C                   PARM      '0'           INKC
     C                   PARM      '0'           INKL
      *
      ** Reset errors
      *
     C                   CLEAR                   DLError2
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIdArr
     C                   MOVEL     *BLANK        MsgDtaArr
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
      *
      ** End program
      *
     C     INKC          CASEQ     '1'           Endp
      *
      ** Cancel/Previous screen
      *
     C*****INKL          CASEQ     '1'           SrCanc                                     MD029862
     C     INKL          CASEQ     '1'           SrPrev                                     MD029862
      *
      ** Validate input to second screen
      *
     C                   CAS                     ValS2
     C                   ENDCS
      *
     C                   ENDSR
 
      /EJECT
      *****************************************************************
      *
      * Scrn3 - Process Third Screen
      *
      *****************************************************************
     C     Scrn3         BEGSR
 
     C                   EVAL      ValScrnNo = 3
     C                   IF        R3TSDT = *BLANKS AND
     C                              (DLRIS1Detail <> *BLANKS OR
     C                               DLRIS2Detail <> *BLANKS OR
     C**********                     DLRIS3Detail <> *BLANKS)                                 CSW214
     C                               DLRIS3Detail <> *BLANKS OR                               CSW214
     C                               DLRIS4Detail <> *BLANKS)                                 CSW214
     C                   EVAL      R3TSDT = RLVALD
     C                   ENDIF
      *
      ** Write/Read display screen
      *
     C                   CALLB     'DLRIS3DSP'
      *
      ** Input parameters
      *
      ** Return code
     C                   PARM      *BLANK        RetCodeOut
      *
      ** Action code
     C                   PARM                    RLACTN
      *
      ** Transaction Reporting screen 2
     C                   PARM                    DLRIS3Detail
      *
      ** Fields in error
     C                   PARM                    DLError3
      *
      ** Errors
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ** Warnings
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
      ** Output parameters
      *
      * Function keys
     C                   PARM      '0'           INKC
     C                   PARM      '0'           INKL
      *
      ** Reset errors
      *
     C                   CLEAR                   DLError3
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIdArr
     C                   MOVEL     *BLANK        MsgDtaArr
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
      *
      ** End program
      *
     C     INKC          CASEQ     '1'           EndP
      *
      ** Cancel/Previous screen
      *
     C*****INKL          CASEQ     '1'           SrCanc                                     MD029862
     C     INKL          CASEQ     '1'           SrPrev                                     MD029862
      *
      *
      ** Validate input to second screen
      *
     C                   CAS                     ValS3
     C                   ENDCS
      *
     C                   ENDSR
      *****************************************************************
      /EJECT                                                                                  CSW214
      *****************************************************************                       CSW214
      *                                                                                       CSW214
      * Scrn4 - Process Fourth Screen                                                         CSW214
      *                                                                                       CSW214
      *****************************************************************                       CSW214
     C     Scrn4         BEGSR                                                                CSW214
                                                                                              CSW214
     C                   EVAL      ValScrnNo = 4                                              CSW214
                                                                                              CSW214
      ** Write/Read display screen                                                            CSW214
                                                                                              CSW214
     C                   CALLB     'DLRIS4DSP'                                                CSW214
                                                                                              CSW214
      ** Input parameters                                                                     CSW214
                                                                                              CSW214
      ** Return code                                                                          CSW214
     C                   PARM      *BLANK        RetCodeOut                                   CSW214
                                                                                              CSW214
      ** Action code                                                                          CSW214
     C                   PARM                    RLACTN                                       CSW214
                                                                                              CSW214
      ** Transaction Reporting screen 4                                                       CSW214
     C                   PARM                    DLRIS4Detail                                 CSW214
                                                                                              CSW214
      ** Fields in error                                                                      CSW214
     C                   PARM                    DLError4                                     CSW214
                                                                                              CSW214
      ** Errors                                                                               CSW214
     C                   PARM                    FldNameArr                                   CSW214
     C                   PARM                    MsgIdArr                                     CSW214
     C                   PARM                    MsgDtaArr                                    CSW214
                                                                                              CSW214
      ** Warnings                                                                             CSW214
     C                   PARM                    WFldNamArr                                   CSW214
     C                   PARM                    WMsgIdArr                                    CSW214
     C                   PARM                    WMsgDtaArr                                   CSW214
                                                                                              CSW214
      ** Output parameters                                                                    CSW214
                                                                                              CSW214
      ** Function keys                                                                        CSW214
     C                   PARM      '0'           INKC                                         CSW214
     C                   PARM      '0'           INKL                                         CSW214
                                                                                              CSW214
      ** Reset errors                                                                         CSW214
                                                                                              CSW214
     C                   CLEAR                   DLError4                                     CSW214
     C                   MOVEL     *BLANK        FldNameArr                                   CSW214
     C                   MOVEL     *BLANK        MsgIdArr                                     CSW214
     C                   MOVEL     *BLANK        MsgDtaArr                                    CSW214
     C                   MOVEL     *BLANK        WFldNamArr                                   CSW214
     C                   MOVEL     *BLANK        WMsgIdArr                                    CSW214
     C                   MOVEL     *BLANK        WMsgDtaArr                                   CSW214
                                                                                              CSW214
      ** End program                                                                          CSW214
                                                                                              CSW214
     C     INKC          CASEQ     '1'           EndP                                         CSW214
                                                                                              CSW214
      ** Cancel/Previous screen                                                               CSW214
                                                                                              CSW214
     C*****INKL          CASEQ     '1'           SrCanc                              CSW214 MD029862
     C     INKL          CASEQ     '1'           SrPrev                                     MD029862
                                                                                              CSW214
      ** Validate input to fourth screen                                                      CSW214
                                                                                              CSW214
     C                   CAS                     ValS4                                        CSW214
     C                   ENDCS                                                                CSW214
                                                                                              CSW214
     C                   ENDSR                                                                CSW214
      *****************************************************************                       CSW214
      /EJECT
      *****************************************************************
      *
      * ValS1 - Validate input to first Screen
      *
      *****************************************************************
     C     ValS1         BEGSR
      *
      ** If Enquire
      *
     C     RLACTN        IFEQ      'E'
 
     C                   MOVEL     '2'           Screen
 
     C                   GOTO      EvalS1
 
     C                   ENDIF
      *
      ** If Insert or Amend
      *
     C     RLACTN        IFEQ      'I'
     C     RLACTN        OREQ      'A'
      *
      ** Prior to validation, initialize error indicators
      *
     C                   Z-ADD     *ZERO         Idx
     C                   Z-ADD     *ZERO         WIdx
     C                   CLEAR                   DLError1
     C                   CLEAR                   DLError2
     C                   CLEAR                   DLError3
 
     C                   EXSR      RpifVU
      *
      ** If errors returned
      *
     C                   IF        DLError1 <> ' '
     C                   EVAL      ERRFLAG = 'Y'
     C                   ELSE
     C                   EVAL      ERRFLAG = 'N'
     C                   MOVEL     '2'           Screen
     C                   ENDIF
 
     C                   ENDIF
 
     C     EvalS1        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      * ValS2 - Validate input to second screen
      *
      *****************************************************************
     C     ValS2         BEGSR
      *
      ** If Enquire
      *
     C     RLACTN        IFEQ      'E'
 
     C                   MOVEL     '3'           Screen
 
     C                   GOTO      EvalS2
 
     C                   ENDIF
      *
      ** If Insert or Amend
      *
     C     RLACTN        IFEQ      'I'
     C     RLACTN        OREQ      'A'
      *
      ** Prior to validation, initialize error indicators
      *
     C                   Z-ADD     *ZERO         Idx
     C                   Z-ADD     *ZERO         WIdx
     C                   CLEAR                   DLError2
 
     C                   EXSR      RpifVU
      *
      ** If errors returned
      *
     C                   IF        DLError2 <> ' '
     C                   EVAL      ERRFLAG = 'Y'
     C                   ELSE
     C                   EVAL      ERRFLAG = 'N'
     C                   MOVEL     '3'           Screen
     C                   ENDIF
 
     C                   ENDIF
 
     C     EvalS2        ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      * ValS3 - Validate input to third screen
      *
      *****************************************************************
     C     ValS3         BEGSR
      *
      ** If Enquire
      *
     C     RLACTN        IFEQ      'E'
 
     C                   EVAL      Screen = '4'                                               CSW214
     C                   GOTO      EVALS3
 
     C                   ENDIF
      *
      ** If Insert or Amend
      *
     C     RLACTN        IFEQ      'I'
     C     RLACTN        OREQ      'A'
      *
      ** Prior to validation, initialize error indicators
      *
     C                   Z-ADD     *ZERO         Idx
     C                   Z-ADD     *ZERO         WIdx
     C                   CLEAR                   DLError3
 
     C                   EXSR      RpifVU
      *
      ** If errors returned
      *
     C                   IF        DLError3 <> ' '
 
     C                   EVAL      ERRFLAG = 'Y'
 
     C                   ELSE
 
     C                   EVAL      ErrFlag = 'N'
     C**********         EVAL      ValidScrn3 = 'Y'                                           CSW214
     C                   EVAL      ValidAllScreen = 'Y'                                       CSW214
     C**********         MOVEL     '3'           Screen                                       CSW214
     C                   EVAL      Screen = '4'                                               CSW214
     C                   Z-ADD     1             IX
     C     *BLANK        LOOKUP    WFldNamArr(IX)                         01
     C                   MOVE      'Confirm'     WFldNamArr(IX)
     C                   MOVEL     'ESM0800'     WMsgIdArr(IX)
 
     C                   ENDIF
     C                   ENDIF
 
     C     EVALS3        ENDSR
                                                                                              CSW214
      *****************************************************************                       CSW214
      /EJECT                                                                                  CSW214
      *****************************************************************                       CSW214
      *                                                                                       CSW214
      * ValS4 - Validate input to fourth screen                                               CSW214
      *                                                                                       CSW214
      *****************************************************************                       CSW214
     C     ValS4         BEGSR                                                                CSW214
                                                                                              CSW214
      ** If Enquire                                                                           CSW214
                                                                                              CSW214
     C     RLACTN        IFEQ      'E'                                                        CSW214
                                                                                              CSW214
     C                   EVAL      Screen = 'T'                                             MD029862
     C                   GOTO      EVALS4                                                     CSW214
                                                                                              CSW214
     C                   ENDIF                                                                CSW214
                                                                                              CSW214
      ** If Insert or Amend                                                                   CSW214
                                                                                              CSW214
     C     RLACTN        IFEQ      'I'                                                        CSW214
     C     RLACTN        OREQ      'A'                                                        CSW214
     C     RLACTN        OREQ      'X'                                                        CSW214
                                                                                              CSW214
      ** Prior to validation, initialize error indicators                                     CSW214
                                                                                              CSW214
     C                   Z-ADD     *ZERO         Idx                                          CSW214
     C                   Z-ADD     *ZERO         WIdx                                         CSW214
     C                   CLEAR                   DLError4                                     CSW214
                                                                                              CSW214
     C                   EXSR      RpifVU                                                     CSW214
                                                                                              CSW214
      ** If errors returned                                                                   CSW214
                                                                                              CSW214
     C                   IF        DLError4 <> ' '                                            CSW214
                                                                                              CSW214
     C                   EVAL      ErrFlag = 'Y'                                              CSW214
                                                                                              CSW214
     C                   ELSE                                                                 CSW214
                                                                                              CSW214
     C                   EVAL      ErrFlag = 'N'                                              CSW214
     C                   EVAL      ValidAllScreen = 'Y'                                       CSW214
     C                   EVAL      Screen = '4'                                               CSW214
     C                   EVAL      Screen = 'T'                                             MD029862
     C                   Z-ADD     1             Ix                                           CSW214
     C     *BLANK        LOOKUP    WFldNamArr(IX)                         01                  CSW214
     C                   MOVE      'Confirm'     WFldNamArr(Ix)                               CSW214
     C                   MOVEL     'ESM0800'     WMsgIdArr(Ix)                                CSW214
                                                                                              CSW214
     C                   ENDIF                                                                CSW214
     C                   ENDIF                                                                CSW214
                                                                                              CSW214
     C     EVALS4        ENDSR                                                                CSW214
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      * RpifVU - Validate input to RPIF Screens
      *
      *****************************************************************
     C     RpifVU        BEGSR
 
     C                   CALL      'DLRPIFVU'
     C                   PARM                    DLRILKDetail
     C                   PARM                    DLRIS1Detail
     C                   PARM                    DLRIS2Detail
     C                   PARM                    DLRIS3Detail
     C                   PARM                    DLRIS4Detail                                 CSW214
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    Idx
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    WIdx
     C                   PARM                    MsgFArray
     C                   PARM                    DLRIS1PDOut
     C                   PARM                    DLRIS2PDOut
     C                   PARM                    DLRIS3PDOut
     C                   PARM                    DLRIS4PDOut                                  CSW214
     C                   PARM                    UpdateYN
     C                   PARM                    APIRetc
     C                   PARM                    ValScrnNo
     C                   PARM                    DLVRPFileFmt
     C                   PARM                    DLError1
     C                   PARM                    DLError2
     C                   PARM                    DLError3
     C                   PARM                    DLError4                                     CSW214
     C                   PARM                    PayAmount        14                        MD024151
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * RtvDel - Retrieve Deal
      *****************************************************************
     C     RtvDel        BEGSR
 
     C                   IF        RLFOID <> *BLANKS
     C                   EVAL      PModeOp = '*FRONT'
     C                   ENDIF
 
     C                   CALL      'DLRPIFR'
      ** Inputs
      ** Return code
     C                   PARM                    RetCodeIn
      *
      ** Mode of operation
     C                   PARM                    PModeOp
      ** RPFI Set up fields
     C                   PARM                    DLRILKDetail
      *
      ** OUTPUTS
     C                   PARM      *BLANKS       PTranRefOK
      *
     C                   PARM      *BLANKS       DFOfcrIDOK
      *
     C                   PARM                    WNoRepFlag
      *
      ** DLRPIF in File Format
     C                   PARM      *BLANKS       DLRPIFileFmt
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * Array index from/to caller
     C                   PARM                    Idx
      *
      ** Warning error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
      ** Warning array index from/to caller
     C                   PARM                    WIdx
      *
      ** Report Information File - Screen Format
     C                   PARM                    DLRIS1Detail
     C                   PARM                    DLRIS2Detail
     C                   PARM                    DLRIS3Detail
     C                   PARM                    DLRIS4Detail                                 CSW214
 
     C                   EVAL      DLVRPFileFmt = DLRPIFileFmt
 
     C     WNoRepFlag    IFEQ      'Y'
     C                   EVAL      Screen = 'T'
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      * SrCanc - Cancel on a RPIF Screen
      *
      *****************************************************************
     C     SrCanc        BEGSR
 
     C                   IF        ErrFlag = 'N' AND
     C**********                   ValidScrn3 = 'Y'                                           CSW214
     C                             ValidAllScreen = 'Y'                                       CSW214
     C                   EVAL      RetCodeIn = *BLANKS
 
     C                   ELSE
     C                   EVAL      RetCodeIn =  '*F12'
     C                   EVAL      ScrPrv = 0                                               MD029862
     C                   ENDIF
 
     C                   RETURN
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************                     MD029862
      *                                                                                     MD029862
      * SRPrev - Display Previous Screen                                                    MD029862
      *                                                                                     MD029862
      *****************************************************************                     MD029862
     C     SRPrev        BEGSR                                                              MD029862
                                                                                            MD029862
     C                   EVAL      ScrPrv = ValScrnNo - 1                                   MD029862
     C                   MOVEL     ScrPrv        Screen                                     MD029862
                                                                                            MD029862
     C                   ENDSR                                                              MD029862
      *****************************************************************                     MD029862
      /EJECT                                                                                MD029862
      *****************************************************************
      *
      * Updats - Updates
      *
      *****************************************************************
     C     Updats        BEGSR
 
     C                   Z-ADD     *ZERO         Idx
     C                   Z-ADD     *ZERO         WIdx
     C                   Z-ADD     *ZERO         ValScrnNo
     C                   CLEAR                   DLError1
     C                   CLEAR                   DLError2
     C                   CLEAR                   DLError3
     C                   CLEAR                   DLError4                                     CSW214
 
     C                   EXSR      RpifVU
 
     C                   IF        APIRetc = '0'
     C                   EVAL      RetCodeIn = '*ERROR'
     C                   ELSE
     C                   EVAL      RetCodeIn = *BLANKS
     C                   ENDIF
 
     C                   EVAL      Screen = 'T'
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * EndP - End Program
      *****************************************************************
     C     EndP          BEGSR
 
     C                   EVAL      Screen = 'T'
     C                   EVAL      RetCodeIn =   '*F3'
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      * *INZSR - Initial Processing
      *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
      *
      ** Input parameters
      *
      ** Return code
     C                   PARM                    RetCodeIn
      *
      ** Transaction Reporting Info
     C                   PARM                    DLRILKDetail
      *
      ** Transaction Reporting screen 1 Info
     C                   PARM                    DLRIS1Detail
      *
      ** Transaction Reporting screen 2 Info
     C                   PARM                    DLRIS2Detail
      *
      ** Transaction Reporting screen 3 Info
     C                   PARM                    DLRIS3Detail
      *                                                                                       CSW214
      ** Transaction Reporting screen 4 Info                                                  CSW214
     C                   PARM                    DLRIS4Detail                                 CSW214
      *
      ** Update flag Yes or No
     C                   PARM                    UpdateYN
      *
      ** Initialize program name
      *
     C                   MOVEL     'DLRPIFSIN'   DBPGM
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
     C/COPY WNCPYSRC,FXFXDLSIC2
      *****************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
