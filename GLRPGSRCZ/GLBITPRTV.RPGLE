     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL JE retrieve')                                 *
      *****************************************************************
      *                                                               *
      *  Midas -  General Ledger ILE Module                           *
      *                                                               *
      *  GLBITPRTV - Batch Item RETRIEVE                              *
      *              (WITH ACTION CODE VERSUS Transact.NO. VALIDATION)*
      *                                                               *
      *  Function:  This module retrieves a transaction from          *
      *             the database. As it does so, it validates the     *
      *             action code and Transaction number.               *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      *  Last Amend No. MD027587           Date 19Jun14               *
      *  Prev Amend No. CGL135A            Date 10Jul13               *
      *                 MD000091           Date 07May13               *
      *                 CGL130             Date 28Sep12               *
      *                 CAP207             Date 10Feb11               *
      *                 CER059             Date 19Jul10               *
      *                 BUG23742           Date 09May09               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 246418             Date 20Mar07              *
      * Midas Plus 1.4 Base ------------------------------------------*
      *                 237122             Date 01Dec06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 BUG8550            Date 07Oct05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CMM121             Date 29Jun04               *
      *                 CLE025             Date 20Oct03               *
      *                 CAP084  *CREATE    Date 12Aug03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD027587 - Unable to use the C for Copy and T for Template   *
      *             (Recompile)                                       *
      *  CGL135A - Accounting Rules Process                           *
      *            Added hooks: CGL135_054, CGL135_055, CGL135_056,   *
      *                         CGL135_057, CGL135_058, CGL135_059    *
      *  MD000091 - Event Codes Substitution                          *
      *  CGL130 - GL Batch Number Using Alphabetical Characters       *
      *  CAP207 - Account Balance Check extended to other APIs        *
      *           (Recompile)                                         *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG23742 - Improper handling of Ext Narr from Batch          *
      *             Interface Input                                   *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  246418 - CGL013 changes for Midas Plus                       *
      *  237122 - Only allow numeric batch number.                    *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG8550 - Reposition capture of ZMUSER data area             *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CMM121 - Core changes for GBO021                             *
      *         - Upgrade to Midasplus                                *
      *           Core hooks added:GLBITPTF01,GLBITPTD01,GLBITPTC01,  *
      *                            GLBITPTC02                         *
      *         - OUTPUT tag :86: - Information to Account Owners     *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CAP084 - MidasPlus Changes                                   *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FGLJENPL1  IF   E           K DISK    INFSR(*PSSR)
 
     FGLJENPL7  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(@BTREAM:@BTREAMOI)
      * Batch Headers by Front Office Id
                                                                                              246418
     FGLJENXL2  IF   E           K DISK    INFSR(*PSSR)                                       246418
      ** RTV: Midas GL Journal Entry File - Additional Information                            246418
 
     FGLMNARL3  IF   E           K DISK    INFSR(*PSSR)                                     BUG23742
      *                                                                                     BUG23742
      ** Midas GL MultiCash Narratives File - Rtv Indx                                      BUG23742
      *                                                                                     BUG23742
     F/COPY WNCPYSRC,GLBITPTF01
     F/COPY OFCPYSRCZ,CGL135_054                                                             CGL135A
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **-----------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **-----------------------------------------------------------------------
 
      **-----------------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **-----------------------------------------------------------------------
 
      **-----------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **-----------------------------------------------------------------------
 
      **-----------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **-----------------------------------------------------------------------
 
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
      *                                                                                       CGL130
      ** Valid Characters                                                                     CGL130
      *                                                                                       CGL130
     D #VLDVL          C                   CONST('ABCDEFGHIJKLMNOPQRSTUVWXYZ012-              CGL130
     D                                     3456789')                                          CGL130
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D DepotSn         S             10    DIM(10)
      ** Depot shortnames array
 
     D DepotNo         S              6    DIM(10)
      ** Depot customer numbers array
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for bank details ICD retrieval
 
     D SDAPI         E DS                  EXTNAME(SDAPIPD)
      ** External DS for API ICD
 
     D SDSTRD        E DS                  EXTNAME(SDSTRDPD)
      ** External DS for Securities ICD Details
 
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      ** EXTERNAL DS FOR CUSTOMER DETAILS
 
     D/COPY WNCPYSRC,GLH00451
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for access programs, short data structure
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Second DS for access programs, long data structure
 
     D BITPFilFmt    E DS                  EXTNAME(GLJENPPD)
      ** Transaction Details in File Format
      *                                                                                       246418
     D BITPXFilFmt   E DS                  EXTNAME(GLJENXPD)                                  246418
      ** JE Additional Info Data for CGL013 - File format of GLJENXPD                         246418
 
     D PMNarrFmt     E DS                  EXTNAME(GLMNARPD)                                BUG23742
      *                                                                                     BUG23742
      ** MultiCash Narratives - File format of GLMNARPD                                     BUG23742
      *                                                                                     BUG23742
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CGL130
      *                                                                                       CGL130
      ** External DS for SAR Details                                                          CGL130
      *                                                                                       CGL130
                                                                                              CGL130
     D RUNDAT          DS
     D  @MBIN                 13     13
 
     D ZMUSER          DS
     D  DBRN                  11     13
     D  BANK                  17     17
     D/COPY OFCPYSRCZ,CGL135_055                                                             CGL135A
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of of error message ids etc
     D Ix              S              3P 0
     D/COPY WNCPYSRC,GLH00452
      *                                                                                     BUG23742
      ** CER030 Feature (Entry Parameter)                                                   BUG23742
      *                                                                                     BUG23742
     D CER030          S              1A                                                    BUG23742
 
      **                                                                                    MD000091
     D BChar           DS                                                                   MD000091
     D   BLen                  1      2B 0                                                  MD000091
     D   LenStr                1      2                                                     MD000091
                                                                                            MD000091
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
     D/COPY WNCPYSRC,GLBITPTD01
      *****************************************************************
      /EJECT
      **************************************************************
                                                                                             BUG8550
      ** Retrieve ZMUSER details                                                             BUG8550
                                                                                             BUG8550
     C     *DTAARA       DEFINE                  ZMUSER                                      BUG8550
     C                   IN        ZMUSER                                                    BUG8550
     C/COPY WNCPYSRC,GLH00453
      *
      * Clear Outputs
     C                   CLEAR                   BITPFilFmt
     C                   EVAL      OKACTN = 'Y'
     C                   EVAL      OKBTNB = 'Y'
      *
      * If the mode is 'Front Office Transaction Interface'
      * Do (Extra) Validation for Front Office Transaction Interface
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
      * Validate Action Code & Transaction Number
      *
     C                   EXSR      VAL
      *
      **  Carry out no further validation if errors have occurred.
      *
     C                   IF        OKACTN = 'N' OR
     C                             OKBTNB = 'N'
     C                   RETURN
     C                   ENDIF
      *
      *  *-----------------------------------------------*
      *  * Access Security Checking                      *
      *  *-----------------------------------------------*
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
     C                   IF        BJSBRC = *BLANK AND
     C                             DDACTN <> 'I' AND
     C                             RESPMODE = 'S'
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
     C                   EXSR      RTVJENP
     C                   ENDIF
      *
      *  *--------------------------------*
      *  * Validation for Action Code 'A' *
      *  *--------------------------------*
      *
     C                   IF        DDACTN = 'A'
     C                   EXSR      RTVJENP
     C                   ENDIF
      *
      *  *--------------------------------*
      *  * Validation for Action Code 'D' *
      *  *--------------------------------*
      *
     C                   IF        DDACTN = 'D'
     C                   EXSR      RTVJENP
     C                   ENDIF
      *
      **  Carry out no further validation if errors occurred.
     C                   IF        OKACTN = 'N' OR
     C                             OKBTNB = 'N'
     C                   RETURN
     C                   ENDIF
 
      * Return
 
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
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      **********************************************************************
      * RTVJENP - RETRIEVE Transaction DETAILS IF ACTION CODE 'A', 'E' OR 'D'
      **********************************************************************
     C     RTVJENP       BEGSR
 
      * The front office can send us both Front Office ID and transaction ID;
      * When the RTV is called in the back office the transaction ID must be valid
     C                   IF        DDBTNB <> *BLANK
     C                             OR ModeofOp <> '*FRONT'
     C                   MOVE      DDBTNB        BTBTNB
     C                   MOVE      DDBINB        BTBINB
     C     KJENP1        CHAIN     GLJENPL1                           99
 
      * Transaction details not found
     C                   IF        *IN99 = *ON
     C                   MOVEL     'N'           OKBTNB
     C                   ADD       1             Ix
     C                   MOVEL     'DDBTNB'      FldNameArr(Ix)
     C                   MOVEL     'USR4311'     MsgIdArr(Ix)
     C                   ENDIF
                                                                                              246418
     C                   IF        CGL013 = 'Y'                                               246418
     C                             and *IN99 = *OFF                                           246418
     C     KJENP1        CHAIN     GLJENXL2                                                   246418
     C                   ENDIF                                                                246418
                                                                                              246418
      *                                                                                     BUG23742
     C                   IF        CER030 = 'Y'                                             BUG23742
     C     KGLMNAR       CHAIN     GLMNARL3                                                 BUG23742
     C                   ENDIF                                                              BUG23742
      *                                                                                     BUG23742
     C/COPY WNCPYSRC,GLBITPTC02
     C/COPY OFCPYSRCZ,CGL135_056                                                             CGL135A
     C                   ENDIF
 
     C     EndRTV        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VFRNT - VALIDATION FOR FRONT OFFICE TRANSACTION INTERFACE
      *****************************************************************
     C     VFRNT         BEGSR
      *
      * ERROR IF ACTION CODE IS NOT 'I','A','E' OR 'D'
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
      * Error if Front Office Transaction ID is Blank
      *
     C                   IF        FOTRID = *BLANK
     C                   EVAL      OKACTN = 'N'
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'APM0201'     MsgIdArr(Ix)
     C                   GOTO      EVFRNT
     C                   ENDIF
      *
      * Access Transaction with Front Office Transaction ID
      *
     C     KJENP         CHAIN     GLJENPL7                           99
      *
      * If Insert
      *
     C                   IF        DDACTN = 'I'
      *
      * Front Office Transaction ID can't be Present already
      *
     C                   IF        *IN99 = *OFF
     C                   EVAL      OKACTN = 'N'
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'APM0202'     MsgIdArr(Ix)
     C**********         MOVEL     FOTRID        MsgDtaArr(Ix)                              MD000091
     C                   EVAL      BLen = %Len(%Trim(FOTRID))                               MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(FOTRID)                    MD000091
     C                   GOTO      EVFRNT
     C                   ENDIF
      *
     C                   ELSE
      *
      * If not insert, Front Office Transaction ID Must be Present
      *
     C                   IF        *IN99 = *ON
     C                   EVAL      OKACTN = 'N'
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'APM0203'     MsgIdArr(Ix)
     C**********         MOVEL     FOTRID        MsgDtaArr(Ix)                              MD000091
     C                   EVAL      BLen = %Len(%Trim(FOTRID))                               MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(FOTRID)                    MD000091
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
 
      * Action Code
      *  .. must be 'I','A','D' or 'E'
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
      *  Transaction number  required
      *
     C                   IF        DDBTNB = *BLANKS OR
     C                             DDBTNB = *ZEROS
     C                   MOVEL     'N'           OKBTNB
     C                   ADD       1             Ix
     C                   MOVEL     'DDBTNB'      FldNameArr(Ix)
     C                   MOVEL     'USR4312'     MsgIdArr(Ix)
     C                   GOTO      EVAL
     C                   ENDIF
      *
      *  If the Transaction Number is not blank, check that it is numeric.
      *
     C                   IF        DDACTN =  'I' OR                                           237122
     C                             DDACTN =  'A'                                              237122
     C/COPY WNCPYSRC,GLH00454
      *                                                                                       CGL130
      ** If CGL130 is on                                                                      CGL130
      *                                                                                       CGL130
     C                   IF        CGL130 = 'Y'                                               CGL130
     C                   IF        DDBTNB = '000'                                             CGL130
     C                   MOVEL     'DDBTNB'      FldNameArr(Ix)                               CGL130
     C                   MOVEL     'GLX0431'     MsgIdArr(Ix)                                 CGL130
     C                   RETURN                                                               CGL130
     C                   ELSE                                                                 CGL130
      *                                                                                       CGL130
      ** Check if batch number is alpha numeric                                               CGL130
      *                                                                                       CGL130
     C                   MOVE      'Y'           #OK               1                          CGL130
     C                   Z-ADD     1             #X                1 0                        CGL130
     C                   DOW       (#OK = 'Y') AND (#X < 4)                                   CGL130
      *                                                                                       CGL130
      ** Check for valid values                                                               CGL130
      *                                                                                       CGL130
     C     1             SUBST     DDBTNB:#X     #CH               1                          CGL130
     C     #CH           SCAN      #VLDVL:1      #P                2 0    50                  CGL130
     C                   IF        *IN50 = *OFF                                               CGL130
     C                   MOVE      'N'           #OK                                          CGL130
     C                   ENDIF                                                                CGL130
     C                   ADD       1             #X                                           CGL130
     C                   ENDDO                                                                CGL130
      *                                                                                       CGL130
      ** Send error message if one of the characters is not valid                             CGL130
      *                                                                                       CGL130
     C                   IF        #OK = 'N'                                                  CGL130
     C                   MOVEL     'DDBTNB'      FldNameArr(Ix)                               CGL130
     C                   MOVEL     'GLX0431'     MsgIdArr(Ix)                                 CGL130
     C                   RETURN                                                               CGL130
     C                   ENDIF                                                                CGL130
     C                   ENDIF                                                                CGL130
     C                   ELSE                                                                 CGL130
     C                   TESTN                   DDBTNB               98
     C                   MOVE      DDBTNB        @1BTNB            1
     C                   TESTZ                   @1BTNB                   99
     C                   IF        DDBTNB <> *BLANKS AND
     C                             *IN98 = *OFF OR
     C                             DDBTNB <> *BLANKS AND
     C                             *IN99 = *OFF
     C                   EVAL      OKBTNB = 'N'
     C                   ADD       1             Ix
     C                   MOVEL     'DDBTNB'      FldNameArr(Ix)
     C**********         MOVEL     'USR0822'     MsgIdArr(Ix)                                 237122
     C                   MOVEL     'GLX0168'     MsgIdArr(Ix)                                 237122
     C                   GOTO      EVAL
     C                   ENDIF
     C                   ENDIF                                                                CGL130
     C/COPY WNCPYSRC,GLH00455
     C                   ENDIF                                                                237122
 
     C     EVAL          ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VALACI - VALIDATION OF ACTION CODE 'I'
      *****************************************************************
     C     VALACI        BEGSR
 
      *
      * Access Transaction from the Transactions file
      *
     C     DDBTNB        CHAIN     GLJENPL1                           44
      *
      * Error if present already
      *
     C                   IF        *IN44 = *OFF
     C                   EVAL      OKBTNB = 'N'
     C                   ADD       1             Ix
     C                   MOVEL     'DDBTNB'      FldNameArr(Ix)
     C                   MOVEL     'USR0542'     MsgIdArr(Ix)
     C                   ENDIF
      *
      *
     C     EVALAI        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - INITIAL PROCESSING
      *****************************************************************
     C     *INZSR        BEGSR
 
      * Parameters
     C     *ENTRY        PLIST
 
      * Inputs
      *
      * Return code
     C                   PARM                    RetCodeIn
      *
      * Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      * Mode = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
      *
     C                   PARM                    ModeofOp          6
      *
      * Response mode
     C                   PARM      'S'           RespMode          1
      *
      * Action Code
     C                   PARM                    DDACTN            1
      *
      * Front Office Transaction ID
     C                   PARM                    FOTRID           20
      *
      * Batch Number
     C                   PARM                    DDBTNB            3
      *
      * Batch Item Number
     C                   PARM                    DDBINB            3
      *                                                                                     BUG23742
      ** CER030 feature                                                                     BUG23742
      *                                                                                     BUG23742
     C                   PARM                    CER030                                     BUG23742
      *
      * Outputs
      *
      * Transaction Details in File Format
     C                   PARM                    BITPFilFmt
                                                                                              246418
      * (Current) Additional Information in File Format                                       246418
     C                   PARM                    BITPXFilFmt                                  246418
      *                                                                                     BUG23742
      ** MultiCash Narratives - File Format                                                 BUG23742
      *                                                                                     BUG23742
     C                   PARM                    PMNarrFmt                                  BUG23742
      *
      * OK - Action code
     C                   PARM                    OKACTN            1
      *
      * OK - Transaction Number
     C                   PARM                    OKBTNB            1
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * Array index (3P0) from/to caller
     C                   PARM                    Ix
      ** MT94x Messages Generation                                                            246418
     C                   PARM                    CGL013            1                          246418
     C/COPY WNCPYSRC,GLBITPTC01
     C/COPY OFCPYSRCZ,CGL135_057                                                             CGL135A
      *
      ** Initialise program name
      *
     C                   EVAL      DBPGM = 'GLBITPRTV'
      *
      **  GET RUNDAT to access MULTI-BRANCHING flag.
      *
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
      *
     C******DTAARA       DEFINE                  ZMUSER                                      BUG8550
     C**********         IN        ZMUSER                                                    BUG8550
      *
     C     KJENP         KLIST
     C                   KFLD                    BTFRNT
     C                   KFLD                    BTBTNB
     C                   KFLD                    BTBINB
     C     KJENP1        KLIST
     C                   KFLD                    BTBTNB
     C                   KFLD                    BTBINB
      *                                                                                     BUG23742
     C     KGLMNAR       KLIST                                                              BUG23742
     C                   KFLD                    BTPTDT                                     BUG23742
     C                   KFLD                    BTBTNB                                     BUG23742
     C                   KFLD                    BTBINB                                     BUG23742
     C/COPY OFCPYSRCZ,CGL135_058                                                             CGL135A
      *
      ** Access Bank Details
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      * Database Error
      *
     C                   IF        @RTCD <> *BLANKS
     C                   EVAL      DBFILE = 'SDBANKPD'                           ************
     C                   EVAL      DBASE  = 900                                  * DBERR 900*
     C                   EVAL      DBKEY = @OPTN                                 ************
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Access API ICD via access program
     C                   CALLB     'AOAPIR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDAPI         PARM      SDAPI         DSFDY
      *                                                                                       CGL130
      ** Check if enhancement CGL130 is on                                                    CGL130
      *                                                                                       CGL130
     C                   MOVE      'N'           CGL130            1                          CGL130
      *                                                                                       CGL130
     C                   CALLB     'AOSARDR0'                                                 CGL130
     C                   PARM      *BLANKS       @RTCD                                        CGL130
     C                   PARM      '*VERIFY'     @OPTN                                        CGL130
     C                   PARM      'CGL130'      @SARD             6                          CGL130
     C     SCSARD        PARM      SCSARD        DSFDY                                        CGL130
      *                                                                                       CGL130
     C                   IF        (@RTCD <> *BLANKS) AND (@RTCD <> '*NRF')                   CGL130
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CGL130
     C                   EVAL      DBKEY = 'CGL130'                                           CGL130
     C                   EVAL      DBASE = 901                                                CGL130
     C                   EXSR      *PSSR                                                      CGL130
     C                   ENDIF                                                                CGL130
      *                                                                                       CGL130
     C                   IF        @RTCD = *BLANKS                                            CGL130
     C                   EVAL      CGL130 = 'Y'                                               CGL130
     C                   ENDIF                                                                CGL130
      *
     C/COPY WNCPYSRC,GLH00456
     C/COPY OFCPYSRCZ,CGL135_059                                                             CGL135A
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      ********************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
