     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2013')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('SD Currency/Time of Netting Details Retrieve')         *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  SDCTNMRTV - Currency/Time of Netting Details RETRIEVE        *
      *              (WITH ACTION CODE VERSUS Customer Number         *
      *               VALIDATION)                                     *
      *                                                               *
      *  Function:  This module retrieves a Currency/Time of Netting  *
      *             Details from the database. As it does, it         *
      *             validates the action code and customer number.    *
      *                                                               *
      *  (c) Finastra International Limited 2013                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. MD039287           Date 09Jun16               *
      *                 MD022997           Date 24Apr14               *
      *                 MD024991           Date 24Mar14               *
      *                 AR1086546 *CREATE  Date 14Jun13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD039287 - Customer number is not automatically generated    *
      *             when CSD021 is on                                 *
      *  MD022997 - Customer being filtered was not displayed on the  *
      *             main list view of CUSD maintenance                *
      *  MD024991 - Error appears upon deleting customer.             *
      *           - Do not perform defaulting if action code is 'D'.  *
      *           - Do not perform validation if action code is 'D'.  *
      *  AR1086546 - CDL025 upgrade to MP1.4. (Child: AR1086547).     *
      *              Applied for MD021813                             *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Midas SD Currency/Time of Netting Details File Retrieve
     FSDCTNML1  IF   E           K DISK    INFSR(*PSSR)
 
      ** Midas SD Customer Extra Details Retrieval
     FSDCUSTL1  IF   E           K DISK    INFSR(*PSSR)
 
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
 
      ** CTNM Currency 1 Array
     D Ccy1_Arr        S              3    DIM(10)
 
      ** CTNM Currency 2 Array
     D Ccy2_Arr        S              3    DIM(10)
 
      ** CTNM Time Array
     D Time_Arr        S              4    DIM(10)
 
      ** CTNM Release Notes Array
     D RNot_Arr        S              1  0 DIM(10)
 
      ** External DS for bank details ICD retrieval
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** External DS for API ICD
     D SDAPI         E DS                  EXTNAME(SDAPIPD)
 
      ** External DS for Securities ICD Details
     D SDSTRD        E DS                  EXTNAME(SDSTRDPD)
 
      ** External DS for Customer Details
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
 
      ** First DS for access programs, short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Second DS for access programs, long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** Transaction Details in File Format
     D TranFilFmt    E DS                  EXTNAME(SDVCTNMPD)
     D                                     PREFIX(V_)
 
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                MD039287
 
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
 
     D Ctr             S              3P 0
 
     D ZACTN           S              1A
     D ERR             S              1P 0
     D ZBR             S              3A
 
      ** Entry Parameters
     D ModeofOp        S              6A
     D RespMode        S              1A
     D DDACTN          S              1A
     D DDCUST          S              6A
     D DDCCY1_1        S              1A
     D DDCCY2_1        S              1A
     D From_Cust       S              1A
     D OKACTN          S              1A
     D OKCUST          S              1A
      *                                                                                     MD022997
      ** Constant paramater for AOSVALR0                                                    MD022997
      *                                                                                     MD022997
     D BRCUSR          C                   CONST('CheckBrchUserAuthori')                    MD022997
     D CurSysVal       DS           200                                                     MD022997
     D CurVal                  1      1                                                     MD022997
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      **************************************************************
 
      ** Initialisation
 
     C                   EXSR      INIT
 
      ** If the mode is 'Front Office Transaction Interface'
      ** Do (Extra) Validation for Front Office Transaction Interface
 
     C                   IF        ModeofOp = '*FRONT'
     C                   EXSR      VFRNT
 
      ** Carry out no further validation if errors have occurred
 
     C                   IF        OKACTN = 'N'
     C                   RETURN
     C                   ENDIF
     C                   ENDIF
 
      ** Validate Action Code & Customer Number
 
     C                   EXSR      VALCODE
 
      **  Carry out no further validation if errors have occurred
 
     C                   IF        OKACTN = 'N' OR
     C                             OKCUST = 'N'
     C                   RETURN
     C                   ENDIF
 
      ** Access Security Checking
 
     C                   IF        RespMode = 'S'
     C                   EVAL      ZACTN=DDACTN
 
      ** If single branching
      ** Access Security Checking - Single Branching
 
     C                   IF        BJSBRC <> *BLANK AND
     C                             RESPMODE = 'S'
     C                   EXSR      ACSSES
     C                   ENDIF
 
      ** If multibranching
      ** Access Security Checking - Multi-Branching
 
     C                   IF        BJSBRC = *BLANK AND
     C                             DDACTN <> 'I' AND
     C                             RESPMODE = 'S'
     C                   EXSR      ACSSEM
     C                   ENDIF
     C                   ENDIF
 
      ** Carry out no further validation if errors have occurred
 
     C                   IF        OKACTN = 'N'
     C                   RETURN
     C                   ENDIF
 
      ** Validation for Action Code 'I'
 
     C                   IF        DDACTN = 'I'
     C                   EXSR      VALACI
     C                   ENDIF
 
      ** Validation for Action Code 'E'
 
     C                   IF        DDACTN = 'E'
     C                   EXSR      RTVCTNM
     C                   ENDIF
 
      ** Validation for Action Code 'A'
 
     C                   IF        DDACTN = 'A'
     C                   EXSR      RTVCTNM
     C                   ENDIF
 
      ** Validation for Action Code 'D'
 
     C                   IF        DDACTN = 'D'
     C                   EXSR      RTVCTNM
     C                   EXSR      VALACD
     C                   ENDIF
 
      ** Validation for Action Code 'R' or 'C'
 
     C                   IF        DDACTN = 'C' OR DDACTN = 'R'
     C                   EXSR      RTVCTNM
     C                   ENDIF
 
      **  Carry out no further validation if errors occurred
 
     C                   IF        OKACTN = 'N' OR
     C                             OKCUST = 'N'
     C                   RETURN
     C                   ENDIF
 
      ** Return
 
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  ACSSES - Access Security Checking - Single Branching         *
      *                                                               *
      *****************************************************************
     C     ACSSES        BEGSR
 
      ** Check user's authority for the action
 
     C                   CALL      'ZVACTU'
     C                   PARM                    ZACTN             1
     C                   PARM                    ERR               1 0
 
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
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  ACSSEM - ACCESS SECURITY CHECKING - MULTI-BRANCHING          *
      *                                                               *
      *****************************************************************
     C     ACSSEM        BEGSR
 
     C                   CALLB     'AOSVALR0'                                               MD022997
     C                   PARM                    @RTCD             7                        MD022997
     C                   PARM      BRCUSR        @OP01            20                        MD022997
     C     CurSysVal     PARM                    @VL01           200                        MD022997
     C                   PARM                    @OP02            20                        MD022997
     C                   PARM                    @VL02           200                        MD022997
     C                   PARM                    @OP03            20                        MD022997
     C                   PARM                    @VL03           200                        MD022997
     C                   PARM                    @OP04            20                        MD022997
     C                   PARM                    @VL04           200                        MD022997
     C                   PARM                    @OP05            20                        MD022997
     C                   PARM                    @VL05           200                        MD022997
     C                   PARM                    @OP06            20                        MD022997
     C                   PARM                    @VL06           200                        MD022997
     C                   PARM                    @OP07            20                        MD022997
     C                   PARM                    @VL07           200                        MD022997
     C                   PARM                    @OP08            20                        MD022997
     C                   PARM                    @VL08           200                        MD022997
     C                   PARM                    @OP09            20                        MD022997
     C                   PARM                    @VL09           200                        MD022997
     C                   PARM                    @OP10            20                        MD022997
     C                   PARM                    @VL10           200                        MD022997
      *                                                                                     MD022997
     C                   IF        CurVal = 'Y'                                             MD022997
                                                                                            MD022997
     C     DDCUST        CHAIN     SDCUSTL1                           44                    MD022997
     C                   MOVE      BBBRCD        ZBR                                        MD022997
                                                                                            MD022997
      ** Check user's authority for the action & Booking Branch
 
     C                   CALL      'ZVACTBU'
     C                   PARM                    ZACTN
     C**********         PARM      DBRN          ZBR                                        MD022997
     C                   PARM                    ZBR                                        MD022997
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
     C                   ENDIF                                                              MD022997
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * RTVCTNM - Retrieve Currency/Time of Netting Details. If       *
      *           Action Code 'A', 'E' or 'D'                         *
      *                                                               *
      *****************************************************************
     C     RTVCTNM       BEGSR
 
      ** Access Currency/Time of Netting Details
 
     C                   Eval      Ccy1_Arr = *BLANKS
     C                   Eval      Ccy2_Arr = *BLANKS
     C                   Eval      Time_Arr = *BLANKS
     C                   Eval      RNot_Arr = *ZEROS
     C                   Eval      Ctr=1
     C                   MOVE      *OFF          *IN25
 
     C     DDCUST        SETLL     SDCTNML1
     C                   DOW       *IN25 = *OFF
     C     DDCUST        READE     SDCTNML1                               25
     C                   IF        *IN25 = *OFF
 
      ** Populate Arrays here
 
     C                   Eval      V_TNCUST = LCUST
     C                   Eval      Ccy1_Arr(Ctr) = LCCY1
     C                   Eval      Ccy2_Arr(Ctr) = LCCY2
     C                   Eval      Time_Arr(Ctr) = LTIME
     C                   Eval      RNot_Arr(Ctr) = LRNTD
     C                   Eval      Ctr = Ctr + 1
     C                   ENDIF
     C                   ENDDO
 
      ** Populate file format
 
     C                   EXSR      Pop_filfmt
 
     C     EndRTV        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  VFRNT - Validation for Front Office Transaction  Interface   *
      *                                                               *
      *****************************************************************
     C     VFRNT         BEGSR
 
      ** Error if Action Code is not 'I','A','E' OR 'D'
 
     C                   IF        DDACTN <> 'I' AND
     C                             DDACTN <> 'A' AND
     C                             DDACTN <> 'E' AND
     C                             DDACTN <> 'D' AND
     C                             DDACTN <> 'C' AND
     C                             DDACTN <> 'R'
     C                   EVAL      OKACTN = 'N'
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'APM0200'     MsgIdArr(Ix)
     C                   ENDIF
      *
      *
     C     EVFRNT        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  VALCODE - VALIDATION OF ACTION CODE AND Customer Code        *
      *                                                               *
      *****************************************************************
     C     VALCODE       BEGSR
 
      ** Action Code
      **  .. must be 'I','A','D' or 'E'
 
     C                   IF        DDACTN <> 'I' AND
     C                             DDACTN <> 'A' AND
     C                             DDACTN <> 'E' AND
     C                             DDACTN <> 'D' AND
     C                             DDACTN <> 'C' AND
     C                             DDACTN <> 'R'
     C                   EVAL      OKACTN = 'N'
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'SDA0001'     MsgIdArr(Ix)
     C                   ENDIF
 
      ** Customer number required
     C     CSD021        IFEQ      'N'                                                      MD039287
     C     DDACTN        ORNE      'I'                                                      MD039287
 
     C     DDCUST        IFEQ      *BLANKS
     C     DDCUST        OREQ      *ZEROS
     C                   MOVEL     'N'           OKCUST
     C                   ADD       1             Ix
     C                   MOVEL     'DDCUST'      FldNameArr(Ix)
     C                   MOVEL     'USR0246'     MsgIdArr(Ix)
     C                   GOTO      EVAL
     C                   ENDIF
 
     C                   ENDIF                                                              MD039287
 
      ** Access Customer from the Customers file when action code is
      ** not equal to 'D'
 
     C                   If        DDACTN <> 'D' AND DDACTN <> 'I'
     C                             AND From_Cust = 'N'
 
     C     DDCUST        CHAIN     SDCUSTL1                           44
 
      ** Customer details not found
 
     C     *IN44         IFEQ      '1'
     C                   MOVEL     'N'           OKCUST
     C                   ADD       1             Ix
     C                   MOVEL     'DDCUST'      FldNameArr(Ix)
     C                   MOVEL     'USR0081'     MsgIdArr(Ix)
 
      ** Customer must reference an active Customer
 
     C                   ELSE
     C     BBDTDL        IFNE      *ZERO
     C     DDACTN        ANDNE     'E'
     C                   MOVEL     'N'           OKCUST
     C                   ADD       1             Ix
     C                   MOVEL     'DDCUST'      FldNameArr(Ix)
     C                   MOVEL     'USR0342'     MsgIdArr(Ix)
     C                   ELSE
     C     BBCLST        IFEQ      'Y'
     C     DDACTN        ANDEQ     'A'
     C                   MOVEL     'N'           OKCUST
     C                   ADD       1             Ix
     C                   MOVEL     'DDCUST'      FldNameArr(Ix)
     C                   MOVEL     'USR9236'     MsgIdArr(Ix)
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C     EVAL          ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  VALACI - Validation of Action Code 'I'                       *
      *                                                               *
      *****************************************************************
     C     VALACI        BEGSR
 
      ** Access Currency/Time of Netting Detaiils file
 
     C     DDCUST        CHAIN     SDCTNMP0                           44
 
      ** Error if customer/currency combination already exist
 
     C                   IF        *IN44 = *OFF
     C                   EVAL      OKCUST = 'N'
     C                   ADD       1             Ix
     C                   MOVEL     'DDCUST'      FldNameArr(Ix)
     C                   MOVEL     'USR0542'     MsgIdArr(Ix)
     C                   ENDIF
 
     C     EVALAI        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  VALACD - VALIDATION OF ACTION CODE 'D'                       *
      *                                                               *
      *****************************************************************
     C     VALACD        BEGSR
 
      ** Customer Number must exists
 
     C     DDCUST        CHAIN     SDCUSTL1                           99                    MD022997
     C     DDCUST        CHAIN     SDCTNML1                           99
     C     *IN99         IFEQ      '1'
     C     DDACTN        ANDNE     'D'                                                      MK024991
     C     BBNET         ANDEQ     'Y'                                                      MD022997
     C                   MOVE      'N'           OKCUST
     C                   ADD       1             Ix
     C                   MOVEL     'DDCUST'      FldNameArr(Ix)
     C                   MOVEL     'USR7517'     MsgIdArr(Ix)
     C                   ENDIF
 
     C     EVALAD        ENDSR
      *****************************************************************
      /EJECT
 
      *****************************************************************
      *                                                               *
      *  Pop_filfmt - Populate File Format                            *
      *                                                               *
      *****************************************************************
     C     Pop_filfmt    BEGSR
 
     C                   Eval      V_TNCCY1_1 = Ccy1_Arr(1)
     C                   Eval      V_TNCCY2_1 = Ccy2_Arr(1)
     C                   Eval      V_TNTIME_1 = Time_Arr(1)
     C                   Eval      V_TNRNTD_1 = RNot_Arr(1)
     C                   Eval      V_TNCCY1_2 = Ccy1_Arr(2)
     C                   Eval      V_TNCCY2_2 = Ccy2_Arr(2)
     C                   Eval      V_TNTIME_2 = Time_Arr(2)
     C                   Eval      V_TNRNTD_2 = RNot_Arr(2)
     C                   Eval      V_TNCCY1_3 = Ccy1_Arr(3)
     C                   Eval      V_TNCCY2_3 = Ccy2_Arr(3)
     C                   Eval      V_TNTIME_3 = Time_Arr(3)
     C                   Eval      V_TNRNTD_3 = RNot_Arr(3)
     C                   Eval      V_TNCCY1_4 = Ccy1_Arr(4)
     C                   Eval      V_TNCCY2_4 = Ccy2_Arr(4)
     C                   Eval      V_TNTIME_4 = Time_Arr(4)
     C                   Eval      V_TNRNTD_4 = RNot_Arr(4)
     C                   Eval      V_TNCCY1_5 = Ccy1_Arr(5)
     C                   Eval      V_TNCCY2_5 = Ccy2_Arr(5)
     C                   Eval      V_TNTIME_5 = Time_Arr(5)
     C                   Eval      V_TNRNTD_5 = RNot_Arr(5)
     C                   Eval      V_TNCCY1_6 = Ccy1_Arr(6)
     C                   Eval      V_TNCCY2_6 = Ccy2_Arr(6)
     C                   Eval      V_TNTIME_6 = Time_Arr(6)
     C                   Eval      V_TNRNTD_6 = RNot_Arr(6)
     C                   Eval      V_TNCCY1_7 = Ccy1_Arr(7)
     C                   Eval      V_TNCCY2_7 = Ccy2_Arr(7)
     C                   Eval      V_TNTIME_7 = Time_Arr(7)
     C                   Eval      V_TNRNTD_7 = RNot_Arr(7)
     C                   Eval      V_TNCCY1_8 = Ccy1_Arr(8)
     C                   Eval      V_TNCCY2_8 = Ccy2_Arr(8)
     C                   Eval      V_TNTIME_8 = Time_Arr(8)
     C                   Eval      V_TNRNTD_8 = RNot_Arr(8)
     C                   Eval      V_TNCCY1_9 = Ccy1_Arr(9)
     C                   Eval      V_TNCCY2_9 = Ccy2_Arr(9)
     C                   Eval      V_TNTIME_9 = Time_Arr(9)
     C                   Eval      V_TNRNTD_9 = RNot_Arr(9)
     C                   Eval      V_TNCCY1_10 = Ccy1_Arr(10)
     C                   Eval      V_TNCCY2_10 = Ccy2_Arr(10)
     C                   Eval      V_TNTIME_10 = Time_Arr(10)
     C                   Eval      V_TNRNTD_10 = RNot_Arr(10)
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  INIT - Initial processing                                    *
      *                                                               *
      *****************************************************************
     C     INIT          BEGSR
 
      ** Clear Outputs
 
     C                   CLEAR                   TranFilFmt
     C                   EVAL      OKACTN = 'Y'
     C                   EVAL      OKCUST = 'Y'
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Initialisation                                       *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
      ** Parameters
 
     C     *ENTRY        PLIST
 
      ** Inputs
      ** Return code
 
     C                   PARM                    RetCodeIn
 
      ** Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      ** Mode = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
 
     C                   PARM                    ModeofOp
 
      ** Response mode
 
     C                   PARM                    RespMode
 
      ** Action Code
 
     C                   PARM                    DDACTN
 
      ** (Midas) Customer Number
 
     C                   PARM                    DDCUST
 
      ** From Customer Flag
 
     C                   PARM                    From_Cust
 
      ** Outputs
      ** Transaction Details in File Format
 
     C                   PARM                    TranFilFmt
 
      ** OK - Action code
 
     C                   PARM                    OKACTN
 
      ** OK - Customer Number
 
     C                   PARM                    OKCUST
 
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
 
      ** Array index (3P0) from/to caller
 
     C                   PARM                    Ix
 
      ** Initialise program name
 
     C                   EVAL      DBPGM = 'SDCTNMRTV'
 
      **  GET RUNDAT to access MULTI-BRANCHING flag
 
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
      *
     C     *DTAARA       DEFINE                  ZMUSER
     C                   IN        ZMUSER
 
      ** Access Bank Details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database Error
 
     C                   IF        @RTCD <> *BLANKS
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE  =  900
     C                   EVAL      DBKEY = @OPTN
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Access API ICD via access program
 
     C                   CALLB     'AOAPIR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDAPI         PARM      SDAPI         DSFDY
      *
      ** Determine if CSD021 is switched on                                                 MD039287
 
     C                   MOVEL     'N'           CSD021            1                        MD039287
     C                   CALLB     'AOSARDR0'                                               MD039287
     C                   PARM      *BLANKS       @RTCD                                      MD039287
     C                   PARM      '*VERIFY'     @OPTN                                      MD039287
     C                   PARM      'CSD021'      @SARD             6                        MD039287
     C     SCSARD        PARM      SCSARD        DSFDY                                      MD039287
 
     C     @RTCD         IFEQ      *BLANK                                                   MD039287
     C                   MOVEL     'Y'           CSD021                                     MD039287
     C                   ENDIF                                                              MD039287
      ** Program, module and procedure names for dbase error processing
      ** ==============================================================
      ** The following /COPY sets these values.
      /COPY ZACPYSRC,DBFIELDS
     C                   ENDSR
      *****************************************************************
      /EJECT
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
(c) Finastra International Limited 2013
