     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2007')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Customer Withholding Tax Details Retrieve')            *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  SDCUWTRTV - Customer Withholding Tax Details RETRIEVE        *
      *              (WITH ACTION CODE VERSUS Customer Withholding    *
      *               Tax code VALIDATION).                           *
      *                                                               *
      *  Function:  This module retrieves customer withholding tax    *
      *             Details  from the database. As it does, it        *
      *             validates the action code and customer.           *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2007            *
      *                                                               *
      *  Last Amend No. MD024991           Date 24Mar14               *
      *  Prev Amend No. MD020373           Date 15May13               *
      *                 258250             Date 06Jan09               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 260292             Date 18May09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 CSD079  *CREATE    Date 05Feb07               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD024991 - Error appears upon deleting customer.             *
      *           - Do not perform defaulting if action code is 'D'.  *
      *           - Do not perform validation if action code is 'D'.  *
      *  MD020373 - Customer not classified as safe custody or        *
      *             discretionary error message was shown.            *
      *  258250 - Check whether the customer is classified as         *
      *           safe custody or discretionary only if               *
      *           Securities Trading Module is present                *
      *  260292 - Create new system values to check the branch/user   *
      *           authority.                                          *
      *  CSD079 - Enhanced Customer Maintenance API                   *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FSDWTCSL1  IF   E           K DISK    INFSR(*PSSR)
      ** Withholding Tax Customer Details File by Customer Number
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **------------------------------------------------------------------
 
      **------------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **------------------------------------------------------------------
 
      **------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **------------------------------------------------------------------
 
      **------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **------------------------------------------------------------------
 
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
 
     D DepotSn         S             10    DIM(10)
      ** Depot shortnames array
 
     D DepotNo         S              6    DIM(10)
      ** Depot customer numbers array
 
     D CRTT_Arr        S              2A   DIM(30)
      ** Country of Tax treaty - array
 
     D INTS_Arr        S              3A   DIM(30)
      ** Intermediary Status - array
 
     D DCRC_Arr        S              1A   DIM(30)
      ** Documentation received - array
 
     D DCEX_Arr        S              5P 0 DIM(30)
      ** Documentation Expiry Date - array
 
     D EXCD_Arr        S              2A   DIM(30)
      ** Exemption code - array
 
     D BCWA_Arr        S              1A   DIM(30)
      ** Backup WHT applicable Y/N - array
 
     D RPCD_Arr        S              2A   DIM(30)
      ** Recipient code - array
 
     D TXBS_Arr        S              2A   DIM(30)
      ** Tax Basket - array
 
     D RFSI_Arr        S              1A   DIM(30)
      ** Report foreign src income Y/N - array
 
     D DBTT_Arr        S              1A   DIM(30)
      ** Double tax treaty Y/N - array
 
     D TIN_Arr         S             20A   DIM(30)
      ** Tax Identification Number - array
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for bank details ICD retrieval
 
     D SDAPI         E DS                  EXTNAME(SDAPIPD)
      ** External DS for API ICD
 
     D SDSTRD        E DS                  EXTNAME(SDSTRDPD)
      ** External DS for Securities ICD Details
 
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      ** EXTERNAL DS FOR CUSTOMER DETAILS
                                                                                              258250
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)                                  258250
      ** External data structure for Midas Modules                                            258250
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for access programs, short data structure
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Second DS for access programs, long data structure
 
     D TranFilFmt    E DS                  EXTNAME(SDVCUWTPD)
      ** Transaction Details in Valid File Format
 
     D RUNDAT          DS
     D  @MBIN                 13     13
 
     D ZMUSER          DS
     D  DBRN                  11     13
     D  BANK                  17     17
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of of error message ids etc
     D Ix              S              3P 0
 
      ** Counter variable for the arrays
     D Wrk_Ctr         S              3P 0
 
      ** Entry Parameters
     D ModeofOp        S              6A
     D DDACTN          S              1A
     D DDCSNO          S              6A
     D DDCLAS          S              1A
     D OKACTN          S              1A
     D OKCSNO          S              1A
     D RespMode        S              1A
 
     D ZACTN           S              1A
     D ZBR             S              3A
     D ERR             S              1P 0
 
     D PRTCD           S              7A
     D POPTN           S              7A
      *                                                                                       260292
      ** Constant paramater for AOSVALR0                                                      260292
      *                                                                                       260292
     D BRCUSR          C                   CONST('CheckBrchUserAuthori')                      260292
     D CurSysVal       DS           200                                                       260292
     D CurVal                  1      1                                                       260292
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** Initialisation
 
     C                   EXSR      SRINIT
 
      ** Validate Action Code & Transaction Number
 
     C                   EXSR      SRVAL
 
      ** Carry out no further validation if errors have occurred
 
     C                   IF        OKACTN = 'N' OR
     C                             OKCSNO = 'N'
     C                   RETURN
     C                   ENDIF
 
      ** Access Security Checking
 
     C                   IF        RespMode = 'S'
     C                   EVAL      ZACTN=DDACTN
 
      ** If single branching
      ** Access Security Checking - Single Branching
 
     C                   IF        BJSBRC <> *BLANK AND
     C                             RESPMODE = 'S'
     C                   EXSR      SRACSSES
     C                   ENDIF
 
      ** If multibranching
      ** Access Security Checking - Multi-Branching
 
     C                   IF        BJSBRC = *BLANK AND
     C                             DDACTN <> 'I' AND
     C                             RESPMODE = 'S'
     C                   EXSR      SRACSSEM
     C                   ENDIF
     C                   ENDIF
 
      ** Carry out no further validation if errors have occurred
 
     C                   IF        OKACTN = 'N'
     C                   RETURN
     C                   ENDIF
 
      ** Validation for Action Code 'I'
 
     C                   IF        DDACTN = 'I'
     C                   EXSR      SRVALACI
     C                   ENDIF
 
      ** Validation for Action Code 'E'
 
     C                   IF        DDACTN = 'E'
     C                   EXSR      SRRTVCUWT
     C                   ENDIF
 
      ** Validation for Action Code 'A'
 
     C                   IF        DDACTN = 'A'
     C                   EXSR      SRRTVCUWT
     C                   ENDIF
 
      ** Validation for Action Code 'D'
 
     C                   IF        DDACTN = 'D'
     C                   EXSR      SRRTVCUWT
     C                   EXSR      SRVALACD
     C                   ENDIF
 
      ** Carry out no further validation if errors occurred
 
     C                   IF        OKACTN = 'N' OR
     C                             OKCSNO = 'N'
     C                   RETURN
     C                   ENDIF
 
      ** Return
 
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRACSSES - Access Security Checking - Single Branching       *
      *                                                               *
      *****************************************************************
     C     SRACSSES      BEGSR
 
      ** Check user's authority for the action
 
     C                   CALL      'ZVACTU'
     C                   PARM                    ZACTN
     C                   PARM                    ERR
 
      ** If action invalid for user
 
     C                   IF        ERR = 1
     C                   MOVEL     'N'           OKACTN
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   SELECT
     C                   WHEN      DDACTN='E'
     C                   MOVEL     'RE7105B'     MsgIdArr(Ix)
     C                   WHEN      DDACTN='I'
     C                   MOVEL     'RE7102B'     MsgIdArr(Ix)
     C                   WHEN      DDACTN='A'
     C                   MOVEL     'RE7103B'     MsgIdArr(Ix)
     C                   WHEN      DDACTN='D'
     C                   MOVEL     'RE7104B'     MsgIdArr(Ix)
     C                   ENDSL
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRACSSEM - Access Security Checking - Multi-Branching        *
      *                                                               *
      *****************************************************************
     C     SRACSSEM      BEGSR
 
     C                   CALLB     'AOSVALR0'                                                 260292
     C                   PARM                    @RTCD             7                          260292
     C                   PARM      BRCUSR        @OP01            20                          260292
     C     CurSysVal     PARM                    @VL01           200                          260292
     C                   PARM                    @OP02            20                          260292
     C                   PARM                    @VL02           200                          260292
     C                   PARM                    @OP03            20                          260292
     C                   PARM                    @VL03           200                          260292
     C                   PARM                    @OP04            20                          260292
     C                   PARM                    @VL04           200                          260292
     C                   PARM                    @OP05            20                          260292
     C                   PARM                    @VL05           200                          260292
     C                   PARM                    @OP06            20                          260292
     C                   PARM                    @VL06           200                          260292
     C                   PARM                    @OP07            20                          260292
     C                   PARM                    @VL07           200                          260292
     C                   PARM                    @OP08            20                          260292
     C                   PARM                    @VL08           200                          260292
     C                   PARM                    @OP09            20                          260292
     C                   PARM                    @VL09           200                          260292
     C                   PARM                    @OP10            20                          260292
     C                   PARM                    @VL10           200                          260292
      *                                                                                       260292
     C                   IF        CurVal = 'Y'                                               260292
      *                                                                                       260292
      ** Check user's authority for the action & Booking Branch
 
     C                   CALL      'ZVACTBU'
     C                   PARM                    ZACTN
     C                   PARM      DBRN          ZBR
     C                   PARM                    ERR
 
      ** If action invalid for user
 
     C                   IF        ERR = 1
     C                   MOVEL     'N'           OKACTN
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'RE71070'     MsgIdArr(Ix)
     C                   ELSE
     C                   IF        ERR = 2
     C                   MOVEL     'N'           OKACTN
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   SELECT
     C                   WHEN      DDACTN='E'
     C                   MOVEL     'RE7105B'     MsgIdArr(Ix)
     C                   WHEN      DDACTN='I'
     C                   MOVEL     'RE7102B'     MsgIdArr(Ix)
     C                   WHEN      DDACTN='A'
     C                   MOVEL     'RE7103B'     MsgIdArr(Ix)
     C                   WHEN      DDACTN='D'
     C                   MOVEL     'RE7104B'     MsgIdArr(Ix)
     C                   ENDSL
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF                                                                260292
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRTVCUWT - Retreive Transaction Details if Action Code      *
      *           'A' ,'E' OR 'D'                                     *
      *                                                               *
      *****************************************************************
     C     SRRTVCUWT     BEGSR
 
      ** Access Customer Number from the Withholding Tax
      ** Customer Details Logical File
 
     C                   EVAL      CRTT_Arr = *BLANKS
     C                   EVAL      INTS_Arr = *BLANKS
     C                   EVAL      DCRC_Arr = *BLANKS
     C                   EVAL      DCEX_Arr = *ZEROS
     C                   EVAL      EXCD_Arr = *BLANKS
     C                   EVAL      BCWA_Arr = *BLANKS
     C                   EVAL      RPCD_Arr = *BLANKS
     C                   EVAL      TXBS_Arr = *BLANKS
     C                   EVAL      RFSI_Arr = *BLANKS
     C                   EVAL      DBTT_Arr = *BLANKS
     C                   EVAL      TIN_Arr  = *BLANKS
     C                   EVAL      Wrk_Ctr = 1
     C                   MOVE      *OFF          *IN99
 
     C     DDCSNO        SETLL     SDWTCSL1
     C                   DOW       *IN99 = *OFF
     C     DDCSNO        READE     SDWTCSL1                               99
     C                   IF        *IN99 = *OFF
 
      ** Populate the Arrays
 
     C                   EVAL      WTRECI = WHRECI
     C                   EVAL      WTCSNO = WHCSNO
     C                   EVAL      WTTYLC = WHTYLC
     C                   EVAL      WTLCD  = WHLCD
     C                   EVAL      WTTMST = WHTMST
     C                   EVAL      CRTT_Arr(Wrk_Ctr) = WHCRTT
     C                   EVAL      INTS_Arr(Wrk_Ctr) = WHINTS
     C                   EVAL      DCRC_Arr(Wrk_Ctr) = WHDCRC
     C                   EVAL      DCEX_Arr(Wrk_Ctr) = WHDCEX
     C                   EVAL      EXCD_Arr(Wrk_Ctr) = WHEXCD
     C                   EVAL      BCWA_Arr(Wrk_Ctr) = WHBCWA
     C                   EVAL      RPCD_Arr(Wrk_Ctr) = WHRPCD
     C                   EVAL      TXBS_Arr(Wrk_Ctr) = WHTXBS
     C                   EVAL      RFSI_Arr(Wrk_Ctr) = WHRFSI
     C                   EVAL      DBTT_Arr(Wrk_Ctr) = WHDBTT
     C                   EVAL      TIN_Arr(Wrk_Ctr)  = WHTIN
     C                   EVAL      Wrk_Ctr = Wrk_Ctr + 1
     C                   ENDIF
     C                   ENDDO
 
      ** Customer Number details not found
 
     C                   IF        *IN99 = *ON And Wrk_Ctr = 1
     C                             And DDACTN <> 'D'                                        MD024991
     C                   MOVEL     'N'           OKCSNO
     C                   ADD       1             Ix
     C                   MOVEL     'DDCSNO'      FldNameArr(Ix)
     C                   MOVEL     'USR7517'     MsgIdArr(Ix)
     C                   ELSE
 
      ** Populate Valid file format of Customer Withholding Tax
      ** details
 
     C                   EXSR      POPVALF
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVAL - Validation of Action Code and Customer Number        *
      *                                                               *
      *****************************************************************
     C     SRVAL         BEGSR
 
      ** Action Code
      ** .. must be 'I','A','D' or 'E'
 
     C                   IF        DDACTN <> 'I' AND
     C                             DDACTN <> 'A' AND
     C                             DDACTN <> 'E' AND
     C                             DDACTN <> 'D'
     C                   EVAL      OKACTN = 'N'
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'SDA0001'     MsgIdArr(Ix)
     C                   ENDIF
 
      ** Customer Number is required
 
     C                   IF        DDCSNO = *BLANKS  OR
     C                             DDCSNO = *ZEROS
     C                   MOVEL     'N'           OKCSNO
     C                   ADD       1             Ix
     C                   MOVEL     'DDCSNO'      FldNameArr(Ix)
     C                   MOVEL     'Y2U0001'     MsgIdArr(Ix)
     C                   GOTO      EVAL
     C                   ENDIF
                                                                                              258250
      ** Securities Trading Module is present                                                 258250
                                                                                              258250
     C                   IF        BGSECS = 'Y'                                               258250
 
      ** Check whether the customer is classified as safe custody or
      ** discretionary
 
     C                   IF        (DDCLAS <> 'S' AND DDCLAS <>
     C**********                   'D' AND DDCLAS <> 'I')                                   MD020373
     C                             'D' AND DDCLAS <> 'I'                                    MD020373
     C                             AND DDCLAS <> ' ')                                       MD020373
 
     C                   MOVEL     'N'           OKCSNO
     C                   ADD       1             Ix
     C                   MOVEL     'DDCSNO'      FldNameArr(Ix)
     C                   MOVEL     'USR7500'     MsgIdArr(Ix)
     C                   GOTO      EVAL
     C                   ENDIF
 
     C                   ENDIF                                                                258250
                                                                                              258250
     C     EVAL          ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVALACI - Validation of Action Code 'I'                     *
      *                                                               *
      *****************************************************************
     C     SRVALACI      BEGSR
 
      ** Access Customer Number from the Withholding Tax customer
      ** details (SDWTCSL1) file
 
     C     DDCSNO        CHAIN     SDWTCSL1                           44
 
      ** Error, if record already present,
 
     C                   IF        *IN44 = *OFF
     C                   EVAL      OKCSNO = 'N'
     C                   ADD       1             Ix
     C                   MOVEL     'DDCSNO'      FldNameArr(Ix)
     C                   MOVEL     'USR8917'     MsgIdArr(Ix)
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVALACD - Validation of action code 'D'                     *
      *                                                               *
      *****************************************************************
     C     SRVALACD      BEGSR
 
      ** Customer Number must exists
 
     C     DDCSNO        CHAIN     SDWTCSL1                           99
     C     *IN99         IFEQ      '1'
     C     DDACTN        ANDNE     'D'                                                      MK024991
     C                   MOVE      'N'           OKCSNO
     C                   ADD       1             Ix
     C                   MOVEL     'DDCSNO'      FldNameArr(Ix)
     C                   MOVEL     'USR7517'     MsgIdArr(Ix)
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRINIT - Initial processing                                  *
      *                                                               *
      *****************************************************************
     C     SRINIT        BEGSR
 
      ** Clear Outputs
 
     C                   CLEAR                   TranFilFmt
     C                   EVAL      OKACTN = 'Y'
     C                   EVAL      OKCSNO = 'Y'
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Initialisation                                      *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
      ** Parameters
 
     C     *ENTRY        PLIST
 
      ** Inputs
      ** Return code
 
     C                   PARM                    RetCodeIn
 
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
 
     C                   PARM                    ModeofOp
 
      ** Response mode
 
     C                   PARM                    RespMode
 
      ** Action Code
 
     C                   PARM                    DDACTN
 
      ** (Midas) Customer Number
 
     C                   PARM                    DDCSNO
 
      ** Securities Classification
 
     C                   PARM                    DDCLAS
 
      ** Outputs
      ** Transaction Details in File Format
 
     C                   PARM                    TranFilFmt
 
      ** OK - Action code
 
     C                   PARM                    OKACTN
 
      ** OK - Customer Number
 
     C                   PARM                    OKCSNO
 
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
 
      ** Array index (3P0) from/to caller
 
     C                   PARM                    Ix
 
      ** Initialise program name
 
     C                   EVAL      DBPGM = 'SDCUWTRTV'
 
      ** GET RUNDAT to access MULTI-BRANCHING flag
 
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
      *
     C     *DTAARA       DEFINE                  ZMUSER
     C                   IN        ZMUSER
 
      ** Access Bank Details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database Error
 
     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE  = 900
     C                   EVAL      DBKEY = POPTN
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Access API ICD via access program
 
     C                   CALLB     'AOAPIR0'
     C                   PARM      '*DBERR '     PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDAPI         PARM      SDAPI         DSFDY
                                                                                              258250
      ** Call Access Program for Midas Modules                                                258250
                                                                                              258250
     C                   CALLB     'AOMMODR0'                                                 258250
     C                   PARM      *BLANKS       PRTCD                                        258250
     C                   PARM      '*FIRST '     POPTN                                        258250
     C     SDMMOD        PARM      SDMMOD        DSFDY                                        258250
                                                                                              258250
      ** Database Error                                                                       258250
                                                                                              258250
     C                   IF        PRTCD <> *BLANKS                                           258250
     C                   EVAL      DBFILE = 'SDMMODPD'                                        258250
     C                   EVAL      DBASE  = 901                                               258250
     C                   EVAL      DBKEY = POPTN                                              258250
     C                   EXSR      *PSSR                                                      258250
     C                   ENDIF                                                                258250
 
      ** Program, module and procedure names for dbase error processing
      ** ==============================================================
      ** The following /COPY sets these values.
      /COPY ZACPYSRC,DBFIELDS
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  POPVALF - Populate Valid file format of Customer Withholding *
      *           Tax details                                         *
      *                                                               *
      *****************************************************************
     C     POPVALF       BEGSR
 
     C                   EVAL      WTCRTT1 = CRTT_Arr(1)
     C                   EVAL      WTINTS1 = INTS_Arr(1)
     C                   EVAL      WTDCRC1 = DCRC_Arr(1)
     C                   EVAL      WTDCEX1 = DCEX_Arr(1)
     C                   EVAL      WTEXCD1 = EXCD_Arr(1)
     C                   EVAL      WTBCWA1 = BCWA_Arr(1)
     C                   EVAL      WTRPCD1 = RPCD_Arr(1)
     C                   EVAL      WTTXBS1 = TXBS_Arr(1)
     C                   EVAL      WTRFSI1 = RFSI_Arr(1)
     C                   EVAL      WTDBTT1 = DBTT_Arr(1)
     C                   EVAL      WTTIN1  = TIN_Arr(1)
 
     C                   EVAL      WTCRTT2 = CRTT_Arr(2)
     C                   EVAL      WTINTS2 = INTS_Arr(2)
     C                   EVAL      WTDCRC2 = DCRC_Arr(2)
     C                   EVAL      WTDCEX2 = DCEX_Arr(2)
     C                   EVAL      WTEXCD2 = EXCD_Arr(2)
     C                   EVAL      WTBCWA2 = BCWA_Arr(2)
     C                   EVAL      WTRPCD2 = RPCD_Arr(2)
     C                   EVAL      WTTXBS2 = TXBS_Arr(2)
     C                   EVAL      WTRFSI2 = RFSI_Arr(2)
     C                   EVAL      WTDBTT2 = DBTT_Arr(2)
     C                   EVAL      WTTIN2  = TIN_Arr(2)
 
     C                   EVAL      WTCRTT3 = CRTT_Arr(3)
     C                   EVAL      WTINTS3 = INTS_Arr(3)
     C                   EVAL      WTDCRC3 = DCRC_Arr(3)
     C                   EVAL      WTDCEX3 = DCEX_Arr(3)
     C                   EVAL      WTEXCD3 = EXCD_Arr(3)
     C                   EVAL      WTBCWA3 = BCWA_Arr(3)
     C                   EVAL      WTRPCD3 = RPCD_Arr(3)
     C                   EVAL      WTTXBS3 = TXBS_Arr(3)
     C                   EVAL      WTRFSI3 = RFSI_Arr(3)
     C                   EVAL      WTDBTT3 = DBTT_Arr(3)
     C                   EVAL      WTTIN3  = TIN_Arr(3)
 
     C                   EVAL      WTCRTT4 = CRTT_Arr(4)
     C                   EVAL      WTINTS4 = INTS_Arr(4)
     C                   EVAL      WTDCRC4 = DCRC_Arr(4)
     C                   EVAL      WTDCEX4 = DCEX_Arr(4)
     C                   EVAL      WTEXCD4 = EXCD_Arr(4)
     C                   EVAL      WTBCWA4 = BCWA_Arr(4)
     C                   EVAL      WTRPCD4 = RPCD_Arr(4)
     C                   EVAL      WTTXBS4 = TXBS_Arr(4)
     C                   EVAL      WTRFSI4 = RFSI_Arr(4)
     C                   EVAL      WTDBTT4 = DBTT_Arr(4)
     C                   EVAL      WTTIN4  = TIN_Arr(4)
 
     C                   EVAL      WTCRTT5 = CRTT_Arr(5)
     C                   EVAL      WTINTS5 = INTS_Arr(5)
     C                   EVAL      WTDCRC5 = DCRC_Arr(5)
     C                   EVAL      WTDCEX5 = DCEX_Arr(5)
     C                   EVAL      WTEXCD5 = EXCD_Arr(5)
     C                   EVAL      WTBCWA5 = BCWA_Arr(5)
     C                   EVAL      WTRPCD5 = RPCD_Arr(5)
     C                   EVAL      WTTXBS5 = TXBS_Arr(5)
     C                   EVAL      WTRFSI5 = RFSI_Arr(5)
     C                   EVAL      WTDBTT5 = DBTT_Arr(5)
     C                   EVAL      WTTIN5  = TIN_Arr(5)
 
 
     C                   EVAL      WTCRTT6 = CRTT_Arr(6)
     C                   EVAL      WTINTS6 = INTS_Arr(6)
     C                   EVAL      WTDCRC6 = DCRC_Arr(6)
     C                   EVAL      WTDCEX6 = DCEX_Arr(6)
     C                   EVAL      WTEXCD6 = EXCD_Arr(6)
     C                   EVAL      WTBCWA6 = BCWA_Arr(6)
     C                   EVAL      WTRPCD6 = RPCD_Arr(6)
     C                   EVAL      WTTXBS6 = TXBS_Arr(6)
     C                   EVAL      WTRFSI6 = RFSI_Arr(6)
     C                   EVAL      WTDBTT6 = DBTT_Arr(6)
     C                   EVAL      WTTIN6  = TIN_Arr(6)
 
     C                   EVAL      WTCRTT7 = CRTT_Arr(7)
     C                   EVAL      WTINTS7 = INTS_Arr(7)
     C                   EVAL      WTDCRC7 = DCRC_Arr(7)
     C                   EVAL      WTDCEX7 = DCEX_Arr(7)
     C                   EVAL      WTEXCD7 = EXCD_Arr(7)
     C                   EVAL      WTBCWA7 = BCWA_Arr(7)
     C                   EVAL      WTRPCD7 = RPCD_Arr(7)
     C                   EVAL      WTTXBS7 = TXBS_Arr(7)
     C                   EVAL      WTRFSI7 = RFSI_Arr(7)
     C                   EVAL      WTDBTT7 = DBTT_Arr(7)
     C                   EVAL      WTTIN7  = TIN_Arr(7)
 
     C                   EVAL      WTCRTT8 = CRTT_Arr(8)
     C                   EVAL      WTINTS8 = INTS_Arr(8)
     C                   EVAL      WTDCRC8 = DCRC_Arr(8)
     C                   EVAL      WTDCEX8 = DCEX_Arr(8)
     C                   EVAL      WTEXCD8 = EXCD_Arr(8)
     C                   EVAL      WTBCWA8 = BCWA_Arr(8)
     C                   EVAL      WTRPCD8 = RPCD_Arr(8)
     C                   EVAL      WTTXBS8 = TXBS_Arr(8)
     C                   EVAL      WTRFSI8 = RFSI_Arr(8)
     C                   EVAL      WTDBTT8 = DBTT_Arr(8)
     C                   EVAL      WTTIN8  = TIN_Arr(8)
 
     C                   EVAL      WTCRTT9 = CRTT_Arr(9)
     C                   EVAL      WTINTS9 = INTS_Arr(9)
     C                   EVAL      WTDCRC9 = DCRC_Arr(9)
     C                   EVAL      WTDCEX9 = DCEX_Arr(9)
     C                   EVAL      WTEXCD9 = EXCD_Arr(9)
     C                   EVAL      WTBCWA9 = BCWA_Arr(9)
     C                   EVAL      WTRPCD9 = RPCD_Arr(9)
     C                   EVAL      WTTXBS9 = TXBS_Arr(9)
     C                   EVAL      WTRFSI9 = RFSI_Arr(9)
     C                   EVAL      WTDBTT9 = DBTT_Arr(9)
     C                   EVAL      WTTIN9  = TIN_Arr(9)
 
     C                   EVAL      WTCRTT10 = CRTT_Arr(10)
     C                   EVAL      WTINTS10 = INTS_Arr(10)
     C                   EVAL      WTDCRC10 = DCRC_Arr(10)
     C                   EVAL      WTDCEX10 = DCEX_Arr(10)
     C                   EVAL      WTEXCD10 = EXCD_Arr(10)
     C                   EVAL      WTBCWA10 = BCWA_Arr(10)
     C                   EVAL      WTRPCD10 = RPCD_Arr(10)
     C                   EVAL      WTTXBS10 = TXBS_Arr(10)
     C                   EVAL      WTRFSI10 = RFSI_Arr(10)
     C                   EVAL      WTDBTT10 = DBTT_Arr(10)
     C                   EVAL      WTTIN10  = TIN_Arr(10)
 
     C                   EVAL      WTCRTT11 = CRTT_Arr(11)
     C                   EVAL      WTINTS11 = INTS_Arr(11)
     C                   EVAL      WTDCRC11 = DCRC_Arr(11)
     C                   EVAL      WTDCEX11 = DCEX_Arr(11)
     C                   EVAL      WTEXCD11 = EXCD_Arr(11)
     C                   EVAL      WTBCWA11 = BCWA_Arr(11)
     C                   EVAL      WTRPCD11 = RPCD_Arr(11)
     C                   EVAL      WTTXBS11 = TXBS_Arr(11)
     C                   EVAL      WTRFSI11 = RFSI_Arr(11)
     C                   EVAL      WTDBTT11 = DBTT_Arr(11)
     C                   EVAL      WTTIN11  = TIN_Arr(11)
 
     C                   EVAL      WTCRTT12 = CRTT_Arr(12)
     C                   EVAL      WTINTS12 = INTS_Arr(12)
     C                   EVAL      WTDCRC12 = DCRC_Arr(12)
     C                   EVAL      WTDCEX12 = DCEX_Arr(12)
     C                   EVAL      WTEXCD12 = EXCD_Arr(12)
     C                   EVAL      WTBCWA12 = BCWA_Arr(12)
     C                   EVAL      WTRPCD12 = RPCD_Arr(12)
     C                   EVAL      WTTXBS12 = TXBS_Arr(12)
     C                   EVAL      WTRFSI12 = RFSI_Arr(12)
     C                   EVAL      WTDBTT12 = DBTT_Arr(12)
     C                   EVAL      WTTIN12  = TIN_Arr(12)
 
     C                   EVAL      WTCRTT13 = CRTT_Arr(13)
     C                   EVAL      WTINTS13 = INTS_Arr(13)
     C                   EVAL      WTDCRC13 = DCRC_Arr(13)
     C                   EVAL      WTDCEX13 = DCEX_Arr(13)
     C                   EVAL      WTEXCD13 = EXCD_Arr(13)
     C                   EVAL      WTBCWA13 = BCWA_Arr(13)
     C                   EVAL      WTRPCD13 = RPCD_Arr(13)
     C                   EVAL      WTTXBS13 = TXBS_Arr(13)
     C                   EVAL      WTRFSI13 = RFSI_Arr(13)
     C                   EVAL      WTDBTT13 = DBTT_Arr(13)
     C                   EVAL      WTTIN13  = TIN_Arr(13)
 
     C                   EVAL      WTCRTT14 = CRTT_Arr(14)
     C                   EVAL      WTINTS14 = INTS_Arr(14)
     C                   EVAL      WTDCRC14 = DCRC_Arr(14)
     C                   EVAL      WTDCEX14 = DCEX_Arr(14)
     C                   EVAL      WTEXCD14 = EXCD_Arr(14)
     C                   EVAL      WTBCWA14 = BCWA_Arr(14)
     C                   EVAL      WTRPCD14 = RPCD_Arr(14)
     C                   EVAL      WTTXBS14 = TXBS_Arr(14)
     C                   EVAL      WTRFSI14 = RFSI_Arr(14)
     C                   EVAL      WTDBTT14 = DBTT_Arr(14)
     C                   EVAL      WTTIN14  = TIN_Arr(14)
 
     C                   EVAL      WTCRTT15 = CRTT_Arr(15)
     C                   EVAL      WTINTS15 = INTS_Arr(15)
     C                   EVAL      WTDCRC15 = DCRC_Arr(15)
     C                   EVAL      WTDCEX15 = DCEX_Arr(15)
     C                   EVAL      WTEXCD15 = EXCD_Arr(15)
     C                   EVAL      WTBCWA15 = BCWA_Arr(15)
     C                   EVAL      WTRPCD15 = RPCD_Arr(15)
     C                   EVAL      WTTXBS15 = TXBS_Arr(15)
     C                   EVAL      WTRFSI15 = RFSI_Arr(15)
     C                   EVAL      WTDBTT15 = DBTT_Arr(15)
     C                   EVAL      WTTIN15  = TIN_Arr(15)
 
     C                   EVAL      WTCRTT16 = CRTT_Arr(16)
     C                   EVAL      WTINTS16 = INTS_Arr(16)
     C                   EVAL      WTDCRC16 = DCRC_Arr(16)
     C                   EVAL      WTDCEX16 = DCEX_Arr(16)
     C                   EVAL      WTEXCD16 = EXCD_Arr(16)
     C                   EVAL      WTBCWA16 = BCWA_Arr(16)
     C                   EVAL      WTRPCD16 = RPCD_Arr(16)
     C                   EVAL      WTTXBS16 = TXBS_Arr(16)
     C                   EVAL      WTRFSI16 = RFSI_Arr(16)
     C                   EVAL      WTDBTT16 = DBTT_Arr(16)
     C                   EVAL      WTTIN16  = TIN_Arr(16)
 
     C                   EVAL      WTCRTT17 = CRTT_Arr(17)
     C                   EVAL      WTINTS17 = INTS_Arr(17)
     C                   EVAL      WTDCRC17 = DCRC_Arr(17)
     C                   EVAL      WTDCEX17 = DCEX_Arr(17)
     C                   EVAL      WTEXCD17 = EXCD_Arr(17)
     C                   EVAL      WTBCWA17 = BCWA_Arr(17)
     C                   EVAL      WTRPCD17 = RPCD_Arr(17)
     C                   EVAL      WTTXBS17 = TXBS_Arr(17)
     C                   EVAL      WTRFSI17 = RFSI_Arr(17)
     C                   EVAL      WTDBTT17 = DBTT_Arr(17)
     C                   EVAL      WTTIN17  = TIN_Arr(17)
 
     C                   EVAL      WTCRTT18 = CRTT_Arr(18)
     C                   EVAL      WTINTS18 = INTS_Arr(18)
     C                   EVAL      WTDCRC18 = DCRC_Arr(18)
     C                   EVAL      WTDCEX18 = DCEX_Arr(18)
     C                   EVAL      WTEXCD18 = EXCD_Arr(18)
     C                   EVAL      WTBCWA18 = BCWA_Arr(18)
     C                   EVAL      WTRPCD18 = RPCD_Arr(18)
     C                   EVAL      WTTXBS18 = TXBS_Arr(18)
     C                   EVAL      WTRFSI18 = RFSI_Arr(18)
     C                   EVAL      WTDBTT18 = DBTT_Arr(18)
     C                   EVAL      WTTIN18  = TIN_Arr(18)
 
     C                   EVAL      WTCRTT19 = CRTT_Arr(19)
     C                   EVAL      WTINTS19 = INTS_Arr(19)
     C                   EVAL      WTDCRC19 = DCRC_Arr(19)
     C                   EVAL      WTDCEX19 = DCEX_Arr(19)
     C                   EVAL      WTEXCD19 = EXCD_Arr(19)
     C                   EVAL      WTBCWA19 = BCWA_Arr(19)
     C                   EVAL      WTRPCD19 = RPCD_Arr(19)
     C                   EVAL      WTTXBS19 = TXBS_Arr(19)
     C                   EVAL      WTRFSI19 = RFSI_Arr(19)
     C                   EVAL      WTDBTT19 = DBTT_Arr(19)
     C                   EVAL      WTTIN19  = TIN_Arr(19)
 
     C                   EVAL      WTCRTT20 = CRTT_Arr(20)
     C                   EVAL      WTINTS20 = INTS_Arr(20)
     C                   EVAL      WTDCRC20 = DCRC_Arr(20)
     C                   EVAL      WTDCEX20 = DCEX_Arr(20)
     C                   EVAL      WTEXCD20 = EXCD_Arr(20)
     C                   EVAL      WTBCWA20 = BCWA_Arr(20)
     C                   EVAL      WTRPCD20 = RPCD_Arr(20)
     C                   EVAL      WTTXBS20 = TXBS_Arr(20)
     C                   EVAL      WTRFSI20 = RFSI_Arr(20)
     C                   EVAL      WTDBTT20 = DBTT_Arr(20)
     C                   EVAL      WTTIN20  = TIN_Arr(20)
 
     C                   EVAL      WTCRTT21 = CRTT_Arr(21)
     C                   EVAL      WTINTS21 = INTS_Arr(21)
     C                   EVAL      WTDCRC21 = DCRC_Arr(21)
     C                   EVAL      WTDCEX21 = DCEX_Arr(21)
     C                   EVAL      WTEXCD21 = EXCD_Arr(21)
     C                   EVAL      WTBCWA21 = BCWA_Arr(21)
     C                   EVAL      WTRPCD21 = RPCD_Arr(21)
     C                   EVAL      WTTXBS21 = TXBS_Arr(21)
     C                   EVAL      WTRFSI21 = RFSI_Arr(21)
     C                   EVAL      WTDBTT21 = DBTT_Arr(21)
     C                   EVAL      WTTIN21  = TIN_Arr(21)
 
     C                   EVAL      WTCRTT22 = CRTT_Arr(22)
     C                   EVAL      WTINTS22 = INTS_Arr(22)
     C                   EVAL      WTDCRC22 = DCRC_Arr(22)
     C                   EVAL      WTDCEX22 = DCEX_Arr(22)
     C                   EVAL      WTEXCD22 = EXCD_Arr(22)
     C                   EVAL      WTBCWA22 = BCWA_Arr(22)
     C                   EVAL      WTRPCD22 = RPCD_Arr(22)
     C                   EVAL      WTTXBS22 = TXBS_Arr(22)
     C                   EVAL      WTRFSI22 = RFSI_Arr(22)
     C                   EVAL      WTDBTT22 = DBTT_Arr(22)
     C                   EVAL      WTTIN22  = TIN_Arr(22)
 
     C                   EVAL      WTCRTT23 = CRTT_Arr(23)
     C                   EVAL      WTINTS23 = INTS_Arr(23)
     C                   EVAL      WTDCRC23 = DCRC_Arr(23)
     C                   EVAL      WTDCEX23 = DCEX_Arr(23)
     C                   EVAL      WTEXCD23 = EXCD_Arr(23)
     C                   EVAL      WTBCWA23 = BCWA_Arr(23)
     C                   EVAL      WTRPCD23 = RPCD_Arr(23)
     C                   EVAL      WTTXBS23 = TXBS_Arr(23)
     C                   EVAL      WTRFSI23 = RFSI_Arr(23)
     C                   EVAL      WTDBTT23 = DBTT_Arr(23)
     C                   EVAL      WTTIN23  = TIN_Arr(23)
 
     C                   EVAL      WTCRTT24 = CRTT_Arr(24)
     C                   EVAL      WTINTS24 = INTS_Arr(24)
     C                   EVAL      WTDCRC24 = DCRC_Arr(24)
     C                   EVAL      WTDCEX24 = DCEX_Arr(24)
     C                   EVAL      WTEXCD24 = EXCD_Arr(24)
     C                   EVAL      WTBCWA24 = BCWA_Arr(24)
     C                   EVAL      WTRPCD24 = RPCD_Arr(24)
     C                   EVAL      WTTXBS24 = TXBS_Arr(24)
     C                   EVAL      WTRFSI24 = RFSI_Arr(24)
     C                   EVAL      WTDBTT24 = DBTT_Arr(24)
     C                   EVAL      WTTIN24  = TIN_Arr(24)
 
     C                   EVAL      WTCRTT25 = CRTT_Arr(25)
     C                   EVAL      WTINTS25 = INTS_Arr(25)
     C                   EVAL      WTDCRC25 = DCRC_Arr(25)
     C                   EVAL      WTDCEX25 = DCEX_Arr(25)
     C                   EVAL      WTEXCD25 = EXCD_Arr(25)
     C                   EVAL      WTBCWA25 = BCWA_Arr(25)
     C                   EVAL      WTRPCD25 = RPCD_Arr(25)
     C                   EVAL      WTTXBS25 = TXBS_Arr(25)
     C                   EVAL      WTRFSI25 = RFSI_Arr(25)
     C                   EVAL      WTDBTT25 = DBTT_Arr(25)
     C                   EVAL      WTTIN25  = TIN_Arr(25)
 
     C                   EVAL      WTCRTT26 = CRTT_Arr(26)
     C                   EVAL      WTINTS26 = INTS_Arr(26)
     C                   EVAL      WTDCRC26 = DCRC_Arr(26)
     C                   EVAL      WTDCEX26 = DCEX_Arr(26)
     C                   EVAL      WTEXCD26 = EXCD_Arr(26)
     C                   EVAL      WTBCWA26 = BCWA_Arr(26)
     C                   EVAL      WTRPCD26 = RPCD_Arr(26)
     C                   EVAL      WTTXBS26 = TXBS_Arr(26)
     C                   EVAL      WTRFSI26 = RFSI_Arr(26)
     C                   EVAL      WTDBTT26 = DBTT_Arr(26)
     C                   EVAL      WTTIN26  = TIN_Arr(26)
 
     C                   EVAL      WTCRTT27 = CRTT_Arr(27)
     C                   EVAL      WTINTS27 = INTS_Arr(27)
     C                   EVAL      WTDCRC27 = DCRC_Arr(27)
     C                   EVAL      WTDCEX27 = DCEX_Arr(27)
     C                   EVAL      WTEXCD27 = EXCD_Arr(27)
     C                   EVAL      WTBCWA27 = BCWA_Arr(27)
     C                   EVAL      WTRPCD27 = RPCD_Arr(27)
     C                   EVAL      WTTXBS27 = TXBS_Arr(27)
     C                   EVAL      WTRFSI27 = RFSI_Arr(27)
     C                   EVAL      WTDBTT27 = DBTT_Arr(27)
     C                   EVAL      WTTIN27  = TIN_Arr(27)
 
     C                   EVAL      WTCRTT28 = CRTT_Arr(28)
     C                   EVAL      WTINTS28 = INTS_Arr(28)
     C                   EVAL      WTDCRC28 = DCRC_Arr(28)
     C                   EVAL      WTDCEX28 = DCEX_Arr(28)
     C                   EVAL      WTEXCD28 = EXCD_Arr(28)
     C                   EVAL      WTBCWA28 = BCWA_Arr(28)
     C                   EVAL      WTRPCD28 = RPCD_Arr(28)
     C                   EVAL      WTTXBS28 = TXBS_Arr(28)
     C                   EVAL      WTRFSI28 = RFSI_Arr(28)
     C                   EVAL      WTDBTT28 = DBTT_Arr(28)
     C                   EVAL      WTTIN28  = TIN_Arr(28)
 
     C                   EVAL      WTCRTT29 = CRTT_Arr(29)
     C                   EVAL      WTINTS29 = INTS_Arr(29)
     C                   EVAL      WTDCRC29 = DCRC_Arr(29)
     C                   EVAL      WTDCEX29 = DCEX_Arr(29)
     C                   EVAL      WTEXCD29 = EXCD_Arr(29)
     C                   EVAL      WTBCWA29 = BCWA_Arr(29)
     C                   EVAL      WTRPCD29 = RPCD_Arr(29)
     C                   EVAL      WTTXBS29 = TXBS_Arr(29)
     C                   EVAL      WTRFSI29 = RFSI_Arr(29)
     C                   EVAL      WTDBTT29 = DBTT_Arr(29)
     C                   EVAL      WTTIN29  = TIN_Arr(29)
 
     C                   EVAL      WTCRTT30 = CRTT_Arr(30)
     C                   EVAL      WTINTS30 = INTS_Arr(30)
     C                   EVAL      WTDCRC30 = DCRC_Arr(30)
     C                   EVAL      WTDCEX30 = DCEX_Arr(30)
     C                   EVAL      WTEXCD30 = EXCD_Arr(30)
     C                   EVAL      WTBCWA30 = BCWA_Arr(30)
     C                   EVAL      WTRPCD30 = RPCD_Arr(30)
     C                   EVAL      WTTXBS30 = TXBS_Arr(30)
     C                   EVAL      WTRFSI30 = RFSI_Arr(30)
     C                   EVAL      WTDBTT30 = DBTT_Arr(30)
     C                   EVAL      WTTIN30  = TIN_Arr(30)
      *
     C                   ENDSR
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program, and performs      *
      *          a ROLLBACK.                                          *
      *                                                               *
      *****************************************************************
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILE
 
      *  Note: if non-standard processing required, use the PSSR_ILENE
      *  subroutine
      ****************************************************************
      /EJECT
      ****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2007
