     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2012')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('DL Adjustment Accrued Interest Retrieve')              *
      *****************************************************************
      *                                                               *
      *  Midas - Dealing Module                                       *
      *                                                               *
      *  DLDLAARTV - Adjustments to Accrued Interest Retrieve         *
      *              (With Action Code Versus Transact.No. Validation)*
      *                                                               *
      *  Function:  This module retrieves a transaction from          *
      *             the database. As it does so, it validates the     *
      *             action code and Transaction number.               *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2012            *
      *                                                               *
      *  Last Amend No. MD047196           Date 08Aug17               *
      *  Prev Amend No. AR1096788          Date 18Mar13               *
      *                 258839             Date 28Sep12               *
      *                 CAP210  *CREATE    Date 28Sep12               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD047196 - Authority Validation not working.                 *
      *  AR1096788 - DLAA details should be written in core STRANF    *
      *              file instead of the new DLSTRANFPD file          *
      *  258839 - Amended program so that user have the option to     *
      *           verify or not to verify if user is authorised to    *
      *           default branch.                                     *
      *  CAP210 - Adjustment to Accrued Interests API                 *
      *                                                               *
      *****************************************************************
      *
      **Transaction File by Transaction Number
     F***DLSTRANLL0IF   E           K DISK    INFSR(*PSSR)                                 AR1096788
     F**********                           RENAME(DLDTRANFF:TRNFMAT0)                      AR1096788
     FSTRANFL0  IF   E           K DISK    INFSR(*PSSR)                                    AR1096788
     F                                     RENAME(STRANFF:TRNFMAT0)                        AR1096788
      *
      **Transaction File by Front Office Id
     F***DLSTRANLL1IF   E           K DISK    INFSR(*PSSR)                                 AR1096788
     F**********                           RENAME(DLDTRANFF:TRNFMAT1)                      AR1096788
     FSTRANFL1  IF   E           K DISK    INFSR(*PSSR)                                    AR1096788
     F                                     RENAME(STRANFF:TRNFMAT1)                        AR1096788
 
      *****************************************************************
      **
      **---------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **---------------------------------------------------------------
      *
      **---------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **---------------------------------------------------------------
      *
      **---------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **---------------------------------------------------------------
      *
      **---------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **---------------------------------------------------------------
      *
      ** Constant paramater for AOSVALR0                                                      258839
      *
     D DFTBRH          C                   CONST('CheckDfaultBrnchAuth')                      258839
     D CurSysVal       DS           200                                                       258839
     D CurVal                  1      1                                                       258839
     D WTNLU           S              6P 0
     D PDateIn         S              8S 0
     D PDaynoOut       S              5P 0
     D PDAYN           S              5P 0
     D PVDT            S              8S 0
     D PRTN            S              1
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** External DS for bank details ICD retrieval
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for API ICD
     D SDAPI         E DS                  EXTNAME(SDAPIPD)
      ** Externally described DS for SAR details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      ** First DS for access programs, short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** Second DS for access programs, long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Transaction Details in File Format
     D*TranFilFmt    E DS                  EXTNAME(DLSTRANFPD)                             AR1096788
     D TranFilFmt    E DS                  EXTNAME(STRANF)                                 AR1096788
      *
     D RUNDAT          DS
     D  @MBIN                 13     13
      *
     D ZMUSER          DS
     D  DBRN                  11     13
     D  BANK                  17     17
      *
      ** Index for arrays of of error message ids etc
     D Ix              S              3P 0
     D DDDLNO          S              6A
     D DDTIME          S               Z
      *
      ******************************************************************
      /EJECT
      ******************************************************************
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
     C                   IF        OKACTN = 'N'
     C                   RETURN
     C                   ENDIF
     C                   ENDIF
      *
      ** Validate Action Code & Transaction Number
      *
     C                   EXSR      VAL
      *
      **  Carry out no further validation if errors have occurred.
      *
     C                   IF        OKACTN = 'N' OR
     C                             OKTRNN = 'N'
     C                   RETURN
     C                   ENDIF
      *
      ** *-----------------------------------------------*
      ** * Access Security Checking                      *
      ** *-----------------------------------------------*
      *
     C                   IF        RespMode = 'S'
     C                   EVAL      ZACTN=DDACTN
      *
      ** If single branching
      ** Access Security Checking - Single Branching
      *
     C                   IF        BJSBRC <> *BLANK AND
     C                             RESPMODE = 'S'
     C                   EXSR      ACSSES
     C                   ENDIF
      *
      ** If multibranching
      ** Access Security Checking - Multi-Branching
      *
     C                   CALLB     'AOSVALR0'                                                 258839
     C                   PARM                    @RTCD             7                          258839
     C                   PARM      DFTBRH        @OP01            20                          258839
     C     CurSysVal     PARM                    @VL01           200                          258839
     C                   PARM                    @OP02            20                          258839
     C                   PARM                    @VL02           200                          258839
     C                   PARM                    @OP03            20                          258839
     C                   PARM                    @VL03           200                          258839
     C                   PARM                    @OP04            20                          258839
     C                   PARM                    @VL04           200                          258839
     C                   PARM                    @OP05            20                          258839
     C                   PARM                    @VL05           200                          258839
     C                   PARM                    @OP06            20                          258839
     C                   PARM                    @VL06           200                          258839
     C                   PARM                    @OP07            20                          258839
     C                   PARM                    @VL07           200                          258839
     C                   PARM                    @OP08            20                          258839
     C                   PARM                    @VL08           200                          258839
     C                   PARM                    @OP09            20                          258839
     C                   PARM                    @VL09           200                          258839
     C                   PARM                    @OP10            20                          258839
     C                   PARM                    @VL10           200                          258839
      *                                                                                       258839
     C                   IF        BJSBRC = *BLANK AND
     C                             ModeofOp <> '*FRONT' AND
     C                             RESPMODE = 'S'
     C                             AND CurVal = 'Y'                                           258839
     C                   EXSR      ACSSEM
     C                   ENDIF
     C                   ENDIF
      *
      **  Carry out no further validation if errors have occurred.
      *
     C                   IF        OKACTN = 'N'
     C                   RETURN
     C                   ENDIF
      *
      ** *--------------------------------*
      ** * Validation for Action Code 'I' *
      ** *--------------------------------*
      *
     C                   IF        DDACTN = 'I'
     C                   EXSR      VALACI
     C                   ENDIF
      *
      ** *--------------------------------*
      ** * Validation for Action Code 'E' *
      ** *--------------------------------*
      *
     C                   IF        DDACTN = 'E'
     C                   EXSR      RTVDLAA
     C                   ENDIF
      *
      ** *--------------------------------*
      ** * Validation for Action Code 'A' *
      ** *--------------------------------*
      *
     C                   IF        DDACTN = 'A'
     C                   EXSR      RTVDLAA
     C                   ENDIF
      *
      ** *--------------------------------*
      ** * Validation for Action Code 'D' *
      ** *--------------------------------*
      *
     C                   IF        DDACTN = 'D'
     C                   EXSR      RTVDLAA
     C                   EXSR      VALACD
     C                   ENDIF
      *
      ** *--------------------------------*
      ** * Validation for Action Code 'X' *
      ** *--------------------------------*
      *
      **  Carry out no further validation if errors occurred.
      *
     C                   IF        OKACTN = 'N' OR
     C                             OKTRNN = 'N'
     C                   RETURN
     C                   ENDIF
      *
      ** Return
      *
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      * ACSSES - ACCESS SECURITY CHECKING - SINGLE BRANCHING
      *****************************************************************
     C     ACSSES        BEGSR
      *
      **  Check user's authority for the action.
      *
     C                   CALL      'ZVACTU'
     C                   PARM                    ZACTN             1
     C                   PARM                    ERR               1 0
      *
      **  If action invalid for user
      *
     C                   IF        ERR = 1
     C                   MOVEL     'N'           OKACTN
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   SELECT
     C                   WHEN      DDACTN='E'
     C                   MOVEL     'DLAA030'     MsgIdArr(Ix)
     C                   WHEN      DDACTN='I'
     C                   MOVEL     'DLAA031'     MsgIdArr(Ix)
     C                   WHEN      DDACTN='A'
     C                   MOVEL     'DLAA032'     MsgIdArr(Ix)
     C                   WHEN      DDACTN='D'
     C                   MOVEL     'DLAA033'     MsgIdArr(Ix)
     C                   ENDSL
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
      **  Check user's authority for the action & Booking Branch.
      *
     C                   CALL      'ZVACTBU'
     C                   PARM                    ZACTN             1
     C                   PARM      DBRN          ZBR               3
     C                   PARM                    ERR               1 0
      *
      **   If action invalid for user
      *
     C                   IF        ERR = 1
     C                   MOVEL     'N'           OKACTN
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C**********         MOVEL     'DLAA034'     MsgIdArr(Ix)                               MD047196
     C                   MOVEL     'MMA0493'     MsgIdArr(Ix)                               MD047196
     C                   ELSE
     C                   IF        ERR = 2
     C                   MOVEL     'N'           OKACTN
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'MMA0494'     MsgIdArr(Ix)                               MD047196
     C**********         SELECT                                                             MD047196
     C**********         WHEN      DDACTN='E'                                               MD047196
     C**********         MOVEL     'DLAA030'     MsgIdArr(Ix)                               MD047196
     C**********         WHEN      DDACTN='I'                                               MD047196
     C**********         MOVEL     'DLAA031'     MsgIdArr(Ix)                               MD047196
     C**********         WHEN      DDACTN='A'                                               MD047196
     C**********         MOVEL     'DLAA032'     MsgIdArr(Ix)                               MD047196
     C**********         WHEN      DDACTN='D'                                               MD047196
     C**********         MOVEL     'DLAA033'     MsgIdArr(Ix)                               MD047196
     C**********         ENDSL
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * RTVDLAA - RETRIEVE Transaction DETAILS IF ACTION CODE 'A', 'E' OR 'D'
      *****************************************************************
     C     RTVDLAA       BEGSR
      *
      ** The front office can send us both Front Office ID and transaction ID;
      ** When the RTV is called in the back office the transaction ID must be valid
      *
     C                   IF        (DDTRNN <> *BLANK AND SubForTRNN = 0)
     C                             OR ModeofOp <> '*FRONT'
     C     DDTRNN        CHAIN     TRNFMAT0                           99
      *
      ** Transaction details not found
      *
     C                   IF        *IN99 = *ON
     C                   MOVEL     'N'           OKTRNN
     C                   ADD       1             Ix
     C                   MOVEL     'DDTRNN'      FldNameArr(Ix)
     C                   MOVEL     'USR4311'     MsgIdArr(Ix)
     C                   ENDIF
     C                   ENDIF
      *
     C     EndRTV        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VFRNT - VALIDATION FOR FRONT OFFICE TRANSACTION INTERFACE
      *****************************************************************
     C     VFRNT         BEGSR
      *
      ** Error if Action Code is not 'I','A','E' OR 'D'
      *
     C                   IF        DDACTN <> 'I' AND
     C                             DDACTN <> 'A' AND
     C                             DDACTN <> 'E' AND
     C                             DDACTN <> 'D'
     C                   EVAL      OKACTN = 'N'
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'APM0200'     MsgIdArr(Ix)
     C                   ENDIF
      *
      ** Error if Front Office Transaction ID is Blank
      *
     C                   IF        FOTRID = *BLANK
     C                   EVAL      OKACTN = 'N'
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'APM0201'     MsgIdArr(Ix)
     C                   GOTO      EVFRNT
     C                   ENDIF
      *
      ** Access Transaction with Front Office Transaction ID
      *
     C     FOTRID        CHAIN     TRNFMAT1                           99
      *
      ** If Insert
      *
     C                   IF        DDACTN = 'I'
      *
      ** Front Office Transaction ID can't be Present already
      *
     C                   IF        *IN99 = *OFF
     C                   EVAL      OKACTN = 'N'
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'APM0202'     MsgIdArr(Ix)
     C                   MOVEL     FOTRID        MsgDtaArr(Ix)
     C                   GOTO      EVFRNT
     C                   ENDIF
      *
     C                   ELSE
      *
      ** If not insert, Front Office Transaction ID Must be Present
      *
     C                   IF        *IN99 = *ON
     C                   EVAL      OKACTN = 'N'
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'APM0203'     MsgIdArr(Ix)
     C                   MOVEL     FOTRID        MsgDtaArr(Ix)
     C                   GOTO      EVFRNT
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     EVFRNT        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VAL - VALIDATION OF ACTION CODE AND TRANSACTION NUMBER
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
     C                   EVAL      OKACTN = 'N'
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'SDA0001'     MsgIdArr(Ix)
     C                   ENDIF
      *
      ** Transaction number  required unless insert
      *
     C                   IF        DDACTN <> 'I'
     C                   IF        DDTRNN = *BLANKS OR
     C                             DDTRNN = *ZEROS
     C                   MOVEL     'N'           OKTRNN
     C                   ADD       1             Ix
     C                   MOVEL     'DDTRNN'      FldNameArr(Ix)
     C                   MOVEL     'USR4312'     MsgIdArr(Ix)
     C                   GOTO      EVAL
     C                   ENDIF
     C                   ENDIF
      *
      ** If the Transaction Number is not blank, check that it is numeric.
      *
     C                   TESTN                   DDTRNN               98
     C                   MOVE      DDTRNN        @1TRNN            1
     C                   TESTZ                   @1TRNN                   99
     C                   IF        DDTRNN <> *BLANKS AND
     C                             *IN98 = *OFF OR
     C                             DDTRNN <> *BLANKS AND
     C                             *IN99 = *OFF
     C                   EVAL      OKTRNN = 'N'
     C                   ADD       1             Ix
     C                   MOVEL     'DDTRNN'      FldNameArr(Ix)
     C                   MOVEL     'USR0822'     MsgIdArr(Ix)
     C                   GOTO      EVAL
     C                   ENDIF
      *
     C     EVAL          ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VALACI - VALIDATION OF ACTION CODE 'I'
      *****************************************************************
     C     VALACI        BEGSR
      *
      ** Access Transaction from the Transactions file
      *
     C     DDTRNN        CHAIN     TRNFMAT0                           44
      *
      ** Error if present already
      *
     C                   IF        *IN44 = *OFF
     C                   EVAL      OKTRNN = 'N'
     C                   ADD       1             Ix
     C                   MOVEL     'DDTRNN'      FldNameArr(Ix)
     C                   MOVEL     'USR0542'     MsgIdArr(Ix)
     C                   ENDIF
      *
     C     EVALAI        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VALACD - VALIDATION OF ACTION CODE 'D'
      *****************************************************************
     C     VALACD        BEGSR
      *
      ** If Position present for this transaction in another file, delete not allowed
      *
     C     EVALAD        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * INIT - INITIALIZATION
      *****************************************************************
     C     INIT          BEGSR
      ** Clear Outputs
     C                   CLEAR                   TranFilFmt
     C                   EVAL      OKACTN = 'Y'
     C                   EVAL      OKTRNN = 'Y'
      ** Check for the existence of the replacement character at the
      ** Transaction Id level.
     C                   IF        GHSUBS <> *blank
     C     GHSUBS        SCAN      DDTRNN        SubForTRNN        2 0
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - INITIAL PROCESSING
      *****************************************************************
     C     *INZSR        BEGSR
      ** Parameters
     C     *ENTRY        PLIST
      ** Inputs
      *
      ** Return code
     C                   PARM                    RetCodeIn
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      *
     C                   PARM                    ModeofOp          6
      *
      ** Response mode
      *
     C                   PARM                    RespMode          1
      ** Action Code
     C                   PARM                    DDACTN            1
      ** Front Office Transaction ID
     C                   PARM                    FOTRID           20
      ** (Midas) Transaction number
     C                   PARM                    DDTRNN            6
      *
      ** Outputs
      *
      ** Transaction Details in File Format
      *
     C                   PARM                    TranFilFmt
      ** OK - Action code
     C                   PARM                    OKACTN            1
      ** OK - Transaction Number
     C                   PARM                    OKTRNN            1
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      ** Array index (3P0) from/to caller
     C                   PARM                    Ix
      ** Initialize program name
     C                   EVAL      DBPGM = 'DLDLAARTV'
      **  GET RUNDAT to access MULTI-BRANCHING flag.
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
      *
     C     *DTAARA       DEFINE                  ZMUSER
     C                   IN        ZMUSER
      *
      ** Access Bank Details
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Database Error
      *
     C                   IF        @RTCD <> *BLANKS
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE  = 900
     C                   EVAL      DBKEY = @OPTN
     C                   EXSR      *PSSR
     C                   ENDIF
      ** Access API ICD via access program
     C                   CALLB     'AOAPIR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDAPI         PARM      SDAPI         DSFDY
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      ********************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
