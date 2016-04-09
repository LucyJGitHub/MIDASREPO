     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Movements Status - Details Retrieve')
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  RPGLE/SEMVTSRTV - Movements Status - Retrieve                *
      *             (With Action Code Versus Transact.No. Validation) *
      *                                                               *
      *  Function:  This module retrieves a transaction from          *
      *             the database. As it does so, it validates the     *
      *             action code and Transaction Key Fields.           *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSE039   *CREATE   Date 13Feb03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSE039 - Automatic Settlement of Trades                      *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FSEMVTSL3  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SEMVTSD0:SEMVTSD3)
      ** Movements Status by Front Office Id.
 
     FSEMVTSL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SEMVTSD0:SEMVTSD1)
      ** Movements Status by Main Key (Transaction Reference, Date, Etc...)
 
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
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for bank details ICD retrieval
 
     D SDAPI         E DS                  EXTNAME(SDAPIPD)
      ** External DS for API ICD
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for access programs, short data structure
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Second DS for access programs, long data structure
 
     D TranFilFmt    E DS                  EXTNAME(SEMVTSPD)
      ** Transaction Details in File Format
 
      ** Split up of the Movement Reference
     D DDMvtRef        DS
     D  DDTRRF                        6A
     D  DDTRTY                        1A
     D  DDNTDT                        6A
     D  DDSQNR                        3S 0
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of of error message ids etc
     D Ix              S              3P 0
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      **************************************************************
      ** +--- Start of Main processing -------------------------------+
      ** ¦ Initial processing is performed automatically: the *INZSR  ¦
      ** ¦ subroutine is executed at program activation.              ¦
      ** +------------------------------------------------------------+
      *
      ** Initialization
      *
     C                   EXSR      INIT
      *
      ** If the mode is 'Front Office Transaction Interface'
      ** Do (Extra) Validation for Front Office Transaction Interface
      *
     C                   IF        ModeofOp = '*FRONT'
     C                   EXSR      VFRNT
      *
      **  Carry out no further validation if errors have occurred.
      *
     C                   IF        DDACTNOK = 'N'
     C                   RETURN
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Validate Action Code
      *
     C                   EXSR      VAL
      *
      **  Carry out no further validation if errors have occurred.
      *
     C                   IF        DDACTNOK = 'N' OR
     C                             DDTRRFOK = 'N'
     C                   RETURN
     C                   ENDIF
      *
      *  *--------------------------------*
      *  * Validation for Action Code 'I' *
      *  *--------------------------------*
      *
     C                   IF        DDACTN = 'I'
     C                   EXSR      VALACI
     C                   ENDIF
      *
      *  *--------------------------------*
      *  * Validation for Action Code 'E' *
      *  *--------------------------------*
      *
     C                   IF        DDACTN = 'E'
     C                   EXSR      RTVMVTS
     C                   ENDIF
      *
      *  *--------------------------------*
      *  * Validation for Action Code 'A' *
      *  *--------------------------------*
      *
     C                   IF        DDACTN = 'A'
     C                   EXSR      RTVMVTS
     C                   ENDIF
      *
      *  *--------------------------------*
      *  * Validation for Action Code 'D' *
      *  *--------------------------------*
      *
     C                   IF        DDACTN = 'D'
     C                   EXSR      RTVMVTS
     C                   EXSR      VALACD
     C                   ENDIF
      *
      **  Carry out no further validation if errors have occurred.
      *
     C                   IF        DDACTNOK = 'N' OR
     C                             DDTRRFOK = 'N'
     C                   RETURN
     C                   ENDIF
      *
      ** In Insert, the booking branch of the transaction is retrieved by
      ** the RTT module and passed to this one by the caller
      ** In other modes, the booking branch is taken from the record itself
      ** (read in VFRNT and/or RTVMVTS)
      *
     C                   IF        DDACTN <> 'I'
     C                   EVAL      P@BRCA = TMTRBB
     C                   ENDIF
      *
      *  *-----------------------------------------------*
      *  * Access Security Checking                      *
      *  *-----------------------------------------------*
      *
     C                   IF        RespMode = 'S'
     C                   EVAL      ZACTN = DDACTN
      *
      ** If single branching
      ** Access Security Checking - Single Branching
      *
     C                   IF        BJSBRC <> *BLANK
     C                   EXSR      ACSSES
      *
      ** If multibranching
      ** Access Security Checking - Multi-Branching
      *
     C                   ELSE
     C                   EXSR      ACSSEM
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Return
      *
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      * VFRNT - VALIDATION FOR FRONT OFFICE TRANSACTION INTERFACE
      *****************************************************************
     C     VFRNT         BEGSR
      *
      ** Error if Action Code isn't "I","A","E" or "D"
      *
     C                   IF        DDACTN <> 'I' AND
     C                             DDACTN <> 'A' AND
     C                             DDACTN <> 'E' AND
     C                             DDACTN <> 'D'
     C                   EVAL      DDACTNOK = 'N'
     C     Ix            COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Ix
     C   99              MOVEL     'DDACTN'      FldNameArr(Ix)
     C   99              MOVEL     'APM0200'     MsgIdArr(Ix)
     C                   ENDIF
      *
      ** Error if Front Office Transaction ID is Blank
      *
     C                   IF        FOTRID = *BLANK
     C                   EVAL      DDACTNOK = 'N'
     C     Ix            COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Ix
     C   99              MOVEL     'DDACTN'      FldNameArr(Ix)
     C   99              MOVEL     'APM0201'     MsgIdArr(Ix)
     C                   GOTO      EVFRNT
     C                   ENDIF
      *
      ** Access Transaction with Front Office Transaction ID
      *
     C     FOTRID        CHAIN     SEMVTSD3                           99
      *
      ** If Insert
      *
     C                   IF        DDACTN = 'I'
      *
      ** Front Office Transaction ID can't be Present already
      *
     C                   IF        NOT *IN99
     C                   EVAL      DDACTNOK = 'N'
     C     Ix            COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Ix
     C   99              MOVEL     'DDACTN'      FldNameArr(Ix)
     C   99              MOVEL     'APM0202'     MsgIdArr(Ix)
     C   99              MOVEL     FOTRID        MsgDtaArr(Ix)
     C                   GOTO      EVFRNT
     C                   ENDIF
      *
     C                   ELSE
      *
      ** If not insert, Front Office Transaction ID Must be Present
      *
     C                   IF        *IN99
     C                   EVAL      DDACTNOK = 'N'
     C     Ix            COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Ix
     C   99              MOVEL     'DDACTN'      FldNameArr(Ix)
     C   99              MOVEL     'APM0203'     MsgIdArr(Ix)
     C   99              MOVEL     FOTRID        MsgDtaArr(Ix)
     C                   GOTO      EVFRNT
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     EVFRNT        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VAL - VALIDATION OF ACTION CODE
      *****************************************************************
     C     VAL           BEGSR
      *
      ** Action Code
      **  .. must be 'I','A','D' or 'E'
      *
     C                   IF        DDACTN <> 'I' AND
     C                             DDACTN <> 'A' AND
     C                             DDACTN <> 'E' AND
     C                             DDACTN <> 'D'
     C                   EVAL      DDACTNOK = 'N'
     C     Ix            COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Ix
     C   99              MOVEL     'DDACTN'      FldNameArr(Ix)
     C   99              MOVEL     'APM0200'     MsgIdArr(Ix)
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VALACI - VALIDATION FOR ACTION CODE 'I'
      *****************************************************************
     C     VALACI        BEGSR
      *
      ** As the sequence number, which is the last part of the key, is
      ** incremented at each input of a new movement, this new movement
      ** can never be already present in file.
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * RTVMVTS - RETRIEVE Transaction DETAILS IF ACTION CODE 'A', 'E' OR 'D'
      *****************************************************************
     C     RTVMVTS       BEGSR
      *
      ** The front office can send us both Front Office ID and transaction ID;
      ** When the RTV is called in the back office the transaction ID must be valid
      *
     C                   IF        SubForTRNN = 0 OR ModeofOp <> '*FRONT'
      *
      ** Convert the notification date
      *
     C                   MOVE      DDNTDT        ZDATE
     C                   EXSR      ZDATE1
     C                   MOVE      ZDAYNO        TMNTDT
      *
     C     KSEMVTSL1     CHAIN     SEMVTSD1                           99
      *
      ** Transaction details not found
      *
     C                   IF        *IN99
     C                   MOVEL     'N'           DDTRRFOK
     C     Ix            COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Ix
     C   99              MOVEL     'DDTRRF'      FldNameArr(Ix)
     C   99              MOVEL     'SE03912'     MsgIdArr(Ix)
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VALACD - VALIDATION OF ACTION CODE 'D'
      *****************************************************************
     C     VALACD        BEGSR
      *
      ** Verify that the movement is not already deleted
      *
     C                   IF        DDACTNOK = 'Y' AND DDTRRFOK = 'Y' AND
     C                             TMLCTP = 'D'
     C                   MOVEL     'N'           DDACTNOK
     C     Ix            COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Ix
     C   99              MOVEL     'DDACTN'      FldNameArr(Ix)
     C   99              MOVEL     'SE03913'     MsgIdArr(Ix)
     C                   ENDIF
      *
      ** Verify that the movement can be deleted (input origin = MANUAL)
      *
     C                   IF        DDACTNOK = 'Y' AND DDTRRFOK = 'Y' AND
     C                             TMINOR <> 'MANUAL'
     C                   MOVEL     'N'           DDACTNOK
     C     Ix            COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Ix
     C   99              MOVEL     'DDACTN'      FldNameArr(Ix)
     C   99              MOVEL     'SE03915'     MsgIdArr(Ix)
     C                   ENDIF
      *
     C     EVALAD        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * ACSSES - ACCESS SECURITY CHECKING - SINGLE BRANCHING
      *****************************************************************
     C     ACSSES        BEGSR
      *
      ** Check user's authority for the action.
      *
     C                   CALL      'ZVACTU'
     C                   PARM                    ZACTN             1
     C                   PARM                    ERR               1 0
      *
      ** If action invalid for user
      *
     C                   IF        ERR <> 0
     C                   MOVEL     'N'           DDACTNOK
     C     Ix            COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Ix
     C   99              MOVEL     'DDACTN'      FldNameArr(Ix)
     C   99              MOVEL     'SE03911'     MsgIdArr(Ix)
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      * ACSSEM - ACCESS SECURITY CHECKING - MULTI-BRANCHING
      *****************************************************************
     C     ACSSEM        BEGSR
      *
      ** Check user's authority for the action & Booking Branch.
      *
     C                   CALL      'ZVACTBU'
     C                   PARM                    ZACTN             1
     C                   PARM      P@BRCA        ZBR               3
     C                   PARM                    ERR               1 0
      *
      ** If action invalid for user
      *
     C                   IF        ERR <> 0
     C                   MOVEL     'N'           DDACTNOK
     C     Ix            COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Ix
     C   99              MOVEL     'DDACTN'      FldNameArr(Ix)
     C   99              MOVEL     'SE03911'     MsgIdArr(Ix)
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * ZDATE1 - Format a date for input
      *****************************************************************
     C     ZDATE1        BEGSR
      *
     C                   CALLB     'ZDATE1'
     C                   PARM                    ZDATE             6
     C                   PARM                    ZDAYNO            5 0
     C                   PARM                    BJDFIN
     C                   PARM                    ErrorFlag         1
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * INIT - INITIALIZATION
      *****************************************************************
     C     INIT          BEGSR
      *
      ** Clear Outputs
      *
     C                   CLEAR                   TranFilFmt
      *
     C                   EVAL      DDACTNOK = 'Y'
     C                   EVAL      DDTRRFOK = 'Y'
      *
      ** Check for the existence of the replacement character in the
      ** movement reference
      *
     C                   IF        GHSUBS <> *Blank
     C     GHSUBS        SCAN      DDMvtRef      SubForTRNN        2 0
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - INITIAL PROCESSING
      *****************************************************************
     C     *INZSR        BEGSR
      *
      ** Parameters
      *
     C     *ENTRY        PLIST
      *
      ** INPUT PARAMETERS
      ** Return code
     C                   PARM                    RetCodeIn
      ** Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      ** Mode = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
     C                   PARM                    ModeofOp          6
      ** Response mode
     C                   PARM                    RespMode          1
      ** Action Code
     C                   PARM                    DDACTN            1
      ** Front Office Transaction ID
     C                   PARM                    FOTRID           20
      ** (Midas) Movement Reference
     C                   PARM                    DDMvtRef
      *
      ** INPUT/OUPUT PARAMETERS
      ** Booking Branch of the linked Transaction (trade or DPMV)
     C                   PARM                    P@BRCA            3
      *
      ** OUPUT PARAMETERS
      ** Transaction Details in File Format
     C                   PARM                    TranFilFmt
      ** OK - Action code and first key field of the movement reference
     C                   PARM                    DDACTNOK          1
     C                   PARM                    DDTRRFOK          1
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      ** Array index (3P0) from/to caller
     C                   PARM                    Ix
      *
      ** KLIST's
      *
     C     KSEMVTSL1     KLIST
     C                   KFLD                    DDTRRF
     C                   KFLD                    DDTRTY
     C                   KFLD                    TMNTDT
     C                   KFLD                    DDSQNR
      *
      ** Program, module and procedure names for database error processing.
      *
     C                   EVAL      DBPgm  = PSProcPgm
     C                   EVAL      DBMod  = PSProcMod
     C                   EVAL      DBProc = PSProcName
      *
      ** Access Bank Details
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       @RtCd
     C                   PARM      '*FIRST '     @Optn
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Database Error
      *
     C                   IF        @RtCd <> *BLANKS
     C                   EVAL      DBFILE = 'SDBANKPD'                           ************
     C                   EVAL      DBASE  = 900                                  * DBERR 900*
     C                   EVAL      DBKEY = @Optn                                 ************
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Access API ICD via access program
      *
     C                   CALLB     'AOAPIR0'
     C                   PARM      *BLANKS       @RtCd
     C                   PARM      '*FIRST '     @Optn
     C     SDAPI         PARM      SDAPI         DSFDY
      *
      ** Database Error
      *
     C                   IF        @RtCd <> *BLANKS
     C                   EVAL      DBFILE = 'SDAPIPD'                            ************
     C                   EVAL      DBASE  = 901                                  * DBERR 901*
     C                   EVAL      DBKEY = @Optn                                 ************
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
      *****************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
**CTDATA CPY@
(c) Misys International Banking Systems Ltd. 2003
