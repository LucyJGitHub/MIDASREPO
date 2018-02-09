     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2006')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Alternative Names & Addresses - Retrieve.')            *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  SDALNARTV - Alternative Names & Addresses Details RETRIEVE   *
      *              (WITH ACTION CODE VERSUS Customer Number &       *
      *              Address code VALIDATION)                         *
      *                                                               *
      *  Function:  This module retrieves a Customer Alternative Names*
      *             & Addresses from the database. As it does,it      *
      *             validates the action code and customer number     *
      *             & Address code.                                   *
      *                                                               *
      *  (c) Finastra International Limited 2006                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. MD000091           Date 03May13               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 260292             Date 18May09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 CRE026  *CREATE    Date 24May06               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD000091 - Event Codes Substitution                          *
      *  260292 - Create new system values to check the branch/user   *
      *           authority.                                          *
      *  CRE026 - Consumer Banking                                    *
      *                                                               *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FSDAltnL3  IF   E           K DISK    INFSR(*PSSR)
      * Alt Names & Address File by Customer Noumber and Address code
     FSDAltnL4  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SDALTND0:SDAltFOI)
      * Alt Names & Address File by Front Office Id
     FSDCUSTL1  IF   E           K DISK    INFSR(*PSSR)
      * Midas SD Customer Details Retrieval
     FSDCUSTL8  IF   E           K DISK    INFSR(*PSSR)
      * Midas SD Deleted Customers awaiting drop
     FACCNTL0   IF   E           K DISK    INFSR(*PSSR)
      * Midas SD Account Master file
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **---------------------------------------------------------------
      ** The following /COPY includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **---------------------------------------------------------------
 
      **---------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **---------------------------------------------------------------
 
      **---------------------------------------------------------------
      ** The following /COPY includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **---------------------------------------------------------------
 
      **---------------------------------------------------------------
      ** The following /COPY includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **---------------------------------------------------------------
 
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
 
     D ARD1            S              1    DIM(10)
      ** Address reference
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for bank details ICD retrieval
 
     D SDAPI         E DS                  EXTNAME(SDAPIPD)
      ** External DS for API ICD
 
     D SDSTRD        E DS                  EXTNAME(SDSTRDPD)
      ** External DS for Securities ICD Details
 
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      ** EXTERNAL DS FOR CUSTOMER DETAILS
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for access programs, short data structure
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Second DS for access programs, long data structure
 
     D TranFilFmt    E DS                  EXTNAME(SDALTNPD)
      ** Transaction Details in File Format
 
     D RUNDAT          DS
     D  @MBIN                 13     13
 
     D ZMUSER          DS
     D  DBRN                  11     13
     D  BANK                  17     17
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D Ix              S              3P 0
      ** Index for arrays of of error message ids etc
 
     D ZACTN           S              1A
     D ZBR             S              3A
     D ERR             S              1P 0
 
     D WCUSN           S              6A
     D WAREF           S             10A
     D WC              S              2P 0
     D WADTYP          S              1A
     D W@ADRC          S              1A
 
     D ModeofOp        S              6A
     D RespMode        S              1A
     D DDACTN          S              1A
     D FOTRID          S             20A
     D DDCUST          S              6A
     D DDADCD          S              1A
     D OKACTN          S              1A
     D OKCUST          S              1A
     D OKADCD          S              1A
      *                                                                                       260292
      ** Constant paramater for AOSVALR0                                                      260292
      *                                                                                       260292
     D BRCUSR          C                   CONST('CheckBrchUserAuthori')                      260292
     D CurSysVal       DS           200                                                       260292
     D CurVal                  1      1                                                       260292
      *                                                                                     MD000091
     D BChar           DS                                                                   MD000091
     D   BLen                  1      2B 0                                                  MD000091
     D   LenStr                1      2                                                     MD000091
 
      ** Parameters for AOBANKR0
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
      *
     C                   EVAL      *IN98 = *OFF
 
      ** Initialisation
 
     C                   EXSR      INIT
 
      ** If the mode is 'Front Office Transaction Interface'
      ** Do (Extra) Validation for Front Office Transaction Interface
 
     C                   IF        ModeofOp = '*FRONT'
     C                   EXSR      VFRNT
 
      ** Carry out no further validation if errors have occurred.
 
     C                   IF        OKACTN = 'N'
     C                   RETURN
     C                   ENDIF
     C                   ENDIF
 
      ** Validate Action Code & Transaction Number
 
     C                   EXSR      VAL
 
      ** Carry out no further validation if errors have occurred
 
     C                   IF        OKACTN = 'N' OR
     C                             OKCUST = 'N' OR
     C                             OKADCD = 'N'
     C                   RETURN
     C                   ENDIF
 
      *  *-----------------------------------------------*
      *  * Access Security Checking                      *
      *  *-----------------------------------------------*
 
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
 
      *  *--------------------------------*
      *  * Validation for Action Code 'I' *
      *  *--------------------------------*
 
     C                   IF        DDACTN = 'I'
     C                   EXSR      VALACI
     C                   ENDIF
 
      *  *--------------------------------*
      *  * Validation for Action Code 'E' *
      *  *--------------------------------*
 
     C                   IF        DDACTN = 'E'
     C                   EXSR      RTVALTN
     C                   ENDIF
 
      *  *--------------------------------*
      *  * Validation for Action Code 'A' *
      *  *--------------------------------*
 
     C                   IF        DDACTN = 'A'
     C                   EXSR      RTVALTN
     C                   ENDIF
 
      *  *--------------------------------*
      *  * Validation for Action Code 'D' *
      *  *--------------------------------*
 
     C                   IF        DDACTN = 'D'
     C                   EXSR      RTVALTN
     C                   EXSR      VALACD
     C                   ENDIF
 
      ** Carry out no further validation if errors occurred.
 
     C                   IF        OKACTN = 'N' OR
     C                             OKCUST = 'N' OR
     C                             OKADCD = 'N'
     C                   RETURN
     C                   ENDIF
 
      ** Return
 
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      * ACSSES - ACCESS SECURITY CHECKING - SINGLE BRANCHING
      *****************************************************************
     C     ACSSES        BEGSR
 
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
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      * ACSSEM - ACCESS SECURITY CHECKING - MULTI-BRANCHING
      *****************************************************************
     C     ACSSEM        BEGSR
 
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
      * RTVALTN - Retrieve Customer Alternative Names & Addresses
      *           Details if Action Code is 'A', 'E', or 'D'
      *****************************************************************
     C     RTVALTN       BEGSR
 
      ** Access Alt Name & Address from the Alt Name & Address file
 
     C     KALTN         CHAIN     SDALTNL3                           99
 
      ** Customer Number details not found
 
     C                   IF        *IN99 = *ON
     C                   MOVEL     'N'           OKCUST
     C                   MOVEL     'N'           OKADCD
     C                   ADD       1             Ix
     C                   MOVEL     'DDCUST'      FldNameArr(Ix)
     C                   MOVEL     'Y2U0005'     MsgIdArr(Ix)
     C                   ENDIF
 
     C     EndRTV        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VFRNT - VALIDATION FOR FRONT OFFICE TRANSACTION INTERFACE
      *****************************************************************
     C     VFRNT         BEGSR
 
      ** ERROR IF ACTION CODE IS NOT 'I','A','E' OR 'D'
 
     C                   IF        DDACTN <> 'I' AND
     C                             DDACTN <> 'A' AND
     C                             DDACTN <> 'E' AND
     C                             DDACTN <> 'D'
     C                   EVAL      OKACTN = 'N'
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'APM0200'     MsgIdArr(Ix)
     C                   ENDIF
 
      ** Error if Front Office Transaction ID is Blank
 
     C                   IF        FOTRID = *BLANK
     C                   EVAL      OKACTN = 'N'
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'APM0201'     MsgIdArr(Ix)
     C                   GOTO      EVFRNT
     C                   ENDIF
 
      ** Access Transaction with Front Office Transaction ID
 
     C     FOTRID        CHAIN     SDALTFOI                           99
 
      ** If Insert
 
     C                   IF        DDACTN = 'I'
 
      ** Front Office Transaction ID can't be Present already
 
     C                   IF        *IN99 = *OFF
     C                   EVAL      OKACTN = 'N'
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'APM0202'     MsgIdArr(Ix)
     C**********         MOVEL     FOTRID        MsgDtaArr(Ix)                              MD000091
     C                   EVAL      BLen = %Len(%Trim(FOTRID))                               MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr + %Trim(FOTRID)                   MD000091
     C                   GOTO      EVFRNT
     C                   ENDIF
      *
     C                   ELSE
 
      ** If not insert, Front Office Transaction ID Must be Present
 
     C                   IF        *IN99 = *ON
     C                   EVAL      OKACTN = 'N'
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'APM0203'     MsgIdArr(Ix)
     C**********         MOVEL     FOTRID        MsgDtaArr(Ix)                              MD000091
     C                   EVAL      BLen = %Len(%Trim(FOTRID))                               MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr + %Trim(FOTRID)                   MD000091
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
 
     C                   IF        DDCUST = *BLANKS
     C                   MOVEL     'N'           OKCUST
     C                   ADD       1             Ix
     C                   MOVEL     'DDCUST'      FldNameArr(Ix)
     C                   MOVEL     'Y2U0001'     MsgIdArr(Ix)
     C                   GOTO      EVAL
     C                   ENDIF
 
      ** Must be an existing customer reference, i.e. should exist in
      ** SDCUSTL1 file
 
     C     DDCUST        CHAIN     @BBREBF                            90
     C     *IN90         IFEQ      '1'
 
      ** Record not found - Send message 'Client Details not found'
 
     C                   MOVEL     'N'           OKCUST
     C                   ADD       1             Ix
     C                   MOVEL     'DDCUST'      FldNameArr(Ix)
     C                   MOVEL     'USR0081'     MsgIdArr(Ix)
     C                   GOTO      EVAL
     C                   ENDIF
 
      ** Must not be a customer flagged for deletion, i.e. should not
      ** exist in SDCUSTL8 file
 
     C     DDCUST        SETLL     @CUSTIQ
     C     DDCUST        READE     @CUSTIQ                                90
     C     *IN90         IFEQ      '0'
 
      ** If found send error message
 
     C                   MOVEL     'N'           OKCUST
     C                   ADD       1             Ix
     C                   MOVEL     'DDCUST'      FldNameArr(Ix)
     C                   MOVEL     'USR1237'     MsgIdArr(Ix)
     C                   GOTO      EVAL
     C                   ENDIF
 
      ** Address code must be a alphabetic character from C-Z
 
     C     DDADCD        IFGE      'C'
     C     DDADCD        ANDLE     'Z'
     C                   ELSE
     C                   MOVEL     'N'           OKADCD
     C                   ADD       1             Ix
     C                   MOVEL     'DDADCD'      FldNameArr(Ix)
     C                   MOVEL     'USR1233'     MsgIdArr(Ix)
     C                   GOTO      EVAL
     C                   ENDIF
 
     C     EVAL          ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VALACI - VALIDATION OF ACTION CODE 'I'
      *****************************************************************
     C     VALACI        BEGSR
 
      ** Access Alt Name & Address from the Alt Name & Address
      ** (SDALTNL3) file
 
     C     KALTN         CHAIN     @ALTNIX                            44
 
      ** Error if present already
 
     C                   IF        *IN44 = *OFF
     C                   EVAL      OKCUST = 'N'
     C                   EVAL      OKADCD = 'N'
     C                   ADD       1             Ix
     C                   MOVEL     'DDCUST'      FldNameArr(Ix)
     C                   MOVEL     'USR0084'     MsgIdArr(Ix)
     C                   ENDIF
      *
     C     EVALAI        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VALACD - VALIDATION OF ACTION CODE 'D'
      *****************************************************************
     C     VALACD        BEGSR
 
      ** Customer Number & Address code must exists
 
     C     KALTN         CHAIN     SDALTNL3                           99
     C     *IN99         IFEQ      '1'
     C                   MOVE      'N'           OKCUST
     C                   MOVE      'N'           OKADCD
     C                   ADD       1             Ix
     C                   MOVEL     'DDCUST'      FldNameArr(Ix)
     C                   MOVEL     'Y2U0009'     MsgIdArr(Ix)
     C                   ENDIF
 
      ** Check if address reference to be deleted used in Account
      ** master file
 
     C                   EXSR      CHKACT
     C     *IN98         IFEQ      '0'
 
      ** Records with Address code 'B' cannot be deleted
 
     C     DDADCD        IFEQ      'B'
     C                   MOVE      'N'           OKADCD
     C                   ADD       1             Ix
     C                   MOVEL     'DDADCD'      FldNameArr(Ix)
     C                   MOVEL     'USR0349'     MsgIdArr(Ix)
     C                   ENDIF
     C                   ENDIF
 
 
     C     EVALAD        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * INIT - Initial processing
      *****************************************************************
     C     INIT          BEGSR
 
      ** Clear Outputs
 
     C                   CLEAR                   TranFilFmt
     C                   EVAL      OKACTN = 'Y'
     C                   EVAL      OKCUST = 'Y'
     C                   EVAL      OKADCD = 'Y'
 
     C                   ENDSR
      ********************************************************************
      /EJECT
      ********************************************************************
      *   CHKACT - Additional validation for Delete Request
      ********************************************************************
     C     CHKACT        BEGSR
 
      ** Check if address reference to be deleted used in ACCNTL0
 
     C                   MOVE      DDCUST        WCUSN
     C                   MOVE      '0'           *IN97
     C                   MOVE      '0'           *IN07
     C     WCUSN         CHAIN     ACCNTL0                            97
     C     *IN97         DOWEQ     '0'
     C     RECI          IFNE      'C'
     C                   MOVEL     ADREF1        WAREF
     C                   MOVE      ADREF2        WAREF
     C     WAREF         IFNE      *BLANKS
     C                   Z-ADD     1             WC
     C                   MOVEA     WAREF         ARD1
     C                   MOVE      ARD1(1)       WADTYP
     C     *IN07         DOUEQ     '1'
     C                   MOVE      WADTYP        W@ADRC
     C     1             ADD       WC            WC
     C     WC            IFLE      10
     C                   MOVE      ARD1(WC)      WADTYP
     C                   END
     C                   MOVE      '0'           *IN07
     C     WADTYP        IFEQ      ' '
     C     WC            OREQ      11
     C                   MOVE      '1'           *IN07
     C                   END
      *
     C     W@ADRC        IFNE      'B'
     C     W@ADRC        IFEQ      DDADCD
 
      ** Send message 'Address Code is used by a customer, deletion
      ** not allowed.'
 
     C                   MOVE      'N'           OKADCD
     C                   ADD       1             Ix
     C                   MOVEL     'DDADCD'      FldNameArr(Ix)
     C                   MOVEL     'USR4289'     MsgIdArr(Ix)
     C                   SETON                                        9807
     C                   ENDIF
     C                   ENDIF
     C                   END
     C                   ENDIF
     C                   ENDIF
     C     WCUSN         READE     ACCNTL0                                97
     C                   END
 
     C                   ENDSR
      ********************************************************************
      /EJECT
      ********************************************************************
      * *INZSR - Initialisation
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
 
      ** Front Office Transaction ID
 
     C                   PARM                    FOTRID
 
      ** (Midas) Customer Number & Address code
 
     C                   PARM                    DDCUST
     C                   PARM                    DDADCD
 
      ** Outputs
 
      ** Transaction Details in File Format
 
     C                   PARM                    TranFilFmt
 
      ** OK - Action code
 
     C                   PARM                    OKACTN
 
      ** OK - Customer Number & Address code
 
     C                   PARM                    OKCUST
     C                   PARM                    OKADCD
 
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
 
      ** Array index (3P0) from/to caller
 
     C                   PARM                    Ix
 
      ** Key Lists
 
     C     KALTN         KLIST
     C                   KFLD                    DDCUST
     C                   KFLD                    DDADCD
 
      ** Initialise program name
 
     C                   EVAL      DBPGM = 'SDALNARTV'
 
      ** GET RUNDAT to access MULTI-BRANCHING flag.
 
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
 
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
     C                   EVAL      DBASE  = 900
     C                   EVAL      DBKEY = @OPTN
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Access API ICD via access program
 
     C                   CALLB     'AOAPIR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDAPI         PARM      SDAPI         DSFDY
 
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
(c) Finastra International Limited 2006
