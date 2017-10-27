     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2006')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Yield Curves Details Retrieve')                        *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  SDYLCURTV - Yield Curves Details RETRIEVE                    *
      *              (WITH ACTION CODE VERSUS Yield Curves code       *
      *              VALIDATION)                                      *
      *                                                               *
      *  Function:  This module retrieves a Yield Curves from         *
      *             the database. As it does so, it validates the     *
      *             action code and Yield Curves code.                *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2006            *
      *                                                               *
      *  Last Amend No. CDL099             Date 06Oct17               *
      *  Prev Amend No. CGL165             Date 15Feb17               *
      *                 CDL096             Date 22Sep14               *
      *                 CDL094             Date 11Jun14               *
      *                 CLE134             Date 01Aug12               *
      *                 CLE148             Date 23Jul12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 CRE026  *CREATE    Date 24May06               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CDL099 - Split Value Date (Recompile)                        *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CDL094 - Enhance  Receive Settlement Instructions            *
      *           (Recompiled)                                        *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CLE148 - Alpha Loan Reference (Recompile)                    *
      *  CRE026 - Consumer Banking                                    *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FSDYLDCL1  IF   E           K DISK    INFSR(*PSSR)
 
     FSDYLCUL2  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SDYLDCD0:SDYLDFOI)
      * Yield Curves File by Front Office Id
 
     FSDYLDRL1  IF   E           K DISK    INFSR(*PSSR)
     ** Yield Rates Master File Retrieval Index
     FGLTRANL0  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(CLOANCLF:@TRANL0)
     ** Live Deals and Customer Loans
     FGLTRANL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(CLOANCLF:@TRANL1)
     ** Live Deals and Customer Loans
     FGLTRANL2  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(DEALSDBF:@TRANL2)
     ** Live Deals and Customer Loans
     FGLTRANL3  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(DEALSDBF:@TRANL3)
     ** Live Deals and Customer Loans
     FGLTRANL4  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(DEALSDCF:@TRANL4)
     ** Live Deals and Customer Loans
     FGLTRANL5  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(DEALSDDF:@TRANL5)
     ** Live Deals and Customer Loans
     FSDTPSTL0  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SDLOAND0:@TPSTL0)
     ** Deal and Loan Type/Sub-Type
     FSDTPSTL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SDLOAND0:@TPSTL1)
     ** Deal and Loan Type/Sub-Type
     FSDTPSTL2  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(FDDTSTPD:@TPSTL2)
     ** Deal and Loan Type/Sub-Type
     FSDTPSTL3  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(FDDTSTPD:@TPSTL3)
     ** Deal and Loan Type/Sub-Type
 
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
 
     D TranFilFmt    E DS                  EXTNAME(SDYLDCPD)
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
 
      ** Index for arrays of of error message ids etc
     D Ix              S              3P 0
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      **************************************************************
      *
      ** Initialisation
      *
     C                   EXSR      INIT
      *
      ** If the mode is 'Front Office Transaction Interface'
      ** Do (Extra) Validation for Front Office Transaction Interface
      *
     C                   IF        ModeofOp = '*FRONT'
     C                   EXSR      VFRNT
      *
      ** Carry out no further validation if errors have occurred
      *
     C                   IF        OKACTN = 'N'
     C                   RETURN
     C                   ENDIF
     C                   ENDIF
      *
      * Validate Action Code & Transaction Number
     C                   EXSR      VAL
      *
      ** Carry out no further validation if errors have occurred
      *
     C                   IF        OKACTN = 'N' OR
     C                             OKYLDC = 'N'
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
      ** Carry out no further validation if errors have occurred
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
     C                   EXSR      RTVYLDC
     C                   ENDIF
      *
      *  *--------------------------------*
      *  * Validation for Action Code 'A' *
      *  *--------------------------------*
      *
     C                   IF        DDACTN = 'A'
     C                   EXSR      RTVYLDC
     C                   ENDIF
      *
      *  *--------------------------------*
      *  * Validation for Action Code 'D' *
      *  *--------------------------------*
      *
     C                   IF        DDACTN = 'D'
     C                   EXSR      RTVYLDC
     C                   EXSR      VALACD
     C                   ENDIF
      *
      ** Carry out no further validation if errors occurred
      *
     C                   IF        OKACTN = 'N' OR
     C                             OKYLDC = 'N'
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
      ** Check user's authority for the action
      *
     C                   CALL      'ZVACTU'
     C                   PARM                    ZACTN             1
     C                   PARM                    ERR               1 0
      *
      ** If action invalid for user
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
      ** Check user's authority for the action & Booking Branch
      *
     C                   CALL      'ZVACTBU'
     C                   PARM                    ZACTN             1
     C                   PARM      DBRN          ZBR               3
     C                   PARM                    ERR               1 0
      *
      ** If action invalid for user
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
      * RTVYLDC - Retrieve Yield Curve If Action Code 'A','E' OR 'D         '
      **********************************************************************
     C     RTVYLDC       BEGSR
 
      * Access Yield Curves Code from the Yield Curve file
     C     DDYLDC        CHAIN     SDYLDCL1                           99
 
      * Yield Curves details not found
     C                   IF        *IN99 = *ON
     C                   MOVEL     'N'           OKYLDC
     C                   ADD       1             Ix
     C                   MOVEL     'DDYLDC'      FldNameArr(Ix)
     C                   MOVEL     'USR7605'     MsgIdArr(Ix)
     C                   ENDIF
 
     C     EndRTV        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VFRNT - VALIDATION FOR FRONT OFFICE TRANSACTION INTERFACE
      *****************************************************************
     C     VFRNT         BEGSR
      *
      ** ERROR IF ACTION CODE IS NOT 'I','A','E' OR 'D'
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
     C     FOTRID        CHAIN     SDYLDFOI                           99
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
 
      * Action Code
      *  .. must be 'I','A','D' or 'E'
     C                   IF        DDACTN <> 'I' AND
     C                             DDACTN <> 'A' AND
     C                             DDACTN <> 'E' AND
     C                             DDACTN <> 'D'
     C                   EVAL      OKACTN = 'N'
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'SDA0001'     MsgIdArr(Ix)
     C                   ENDIF
      *  Yield Curve is required
     C                   IF        DDYLDC = *BLANKS
     C                   MOVEL     'N'           OKYLDC
     C                   ADD       1             Ix
     C                   MOVEL     'DDYLDC'      FldNameArr(Ix)
     C                   MOVEL     'USR9158'     MsgIdArr(Ix)
     C                   GOTO      EVAL
     C                   ENDIF
 
     C     EVAL          ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VALACI - VALIDATION OF ACTION CODE 'I'
      *****************************************************************
     C     VALACI        BEGSR
 
      *
      ** Access Yield Curve from the Yield Curve file
      *
     C     DDYLDC        CHAIN     SDYLDCL1                           44
      *
      ** Error if present already
      *
     C                   IF        *IN44 = *OFF
     C                   EVAL      OKYLDC = 'N'
     C                   ADD       1             Ix
     C                   MOVEL     'DDYLDC'      FldNameArr(Ix)
     C                   MOVEL     'USR9166'     MsgIdArr(Ix)
     C                   ENDIF
      *
      *
     C     EVALAI        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VALACD - VALIDATION OF ACTION CODE 'D'
      *****************************************************************
     C     VALACD        BEGSR
 
      *
 
     ** Check if the Yield Curve is a live transaction (Deal or Loan)
     ** is linked to it
     C                   EXSR      SRDelete
 
 
 
     C     EVALAD        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRDelete - Subroutine for Checking Yield Curve Live Transacation
      * link
      *****************************************************************
     C     SRDelete      BEGSR
      ** Check if the Yield Curve is a live transaction (Deal or Loan)
      ** is linked to it
     C     DDYLDC        CHAIN     @TRANL0                            60
     C                   IF        *IN60 = *OFF
     C                   MOVE      'N'           OKACTN
     C                   ADD       1             Ix
     C                   MOVEL     'DDYLDC'      FldNameArr(Ix)
     C                   MOVEL     'USR9167'     MsgIdArr(Ix)
     C                   ENDIF
     C                   IF        *IN60 = *ON
     C     DDYLDC        CHAIN     @TRANL1                            60
     C                   IF        *IN60 = *OFF
     C                   MOVE      'N'           OKACTN
     C                   ADD       1             Ix
     C                   MOVEL     'DDYLDC'      FldNameArr(Ix)
     C                   MOVEL     'USR9167'     MsgIdArr(Ix)
     C                   ENDIF
     C                   ENDIF
     C                   IF        *IN60 = *ON
     C     DDYLDC        CHAIN     @TRANL2                            60
     C                   IF        *IN60 = *OFF
     C                   MOVE      'N'           OKACTN
     C                   ADD       1             Ix
     C                   MOVEL     'DDYLDC'      FldNameArr(Ix)
     C                   MOVEL     'USR9167'     MsgIdArr(Ix)
     C                   ENDIF
     C                   ENDIF
     C                   IF        *IN60 = *ON
     C     DDYLDC        CHAIN     @TRANL3                            60
     C                   IF        *IN60 = *OFF
     C                   MOVE      'N'           OKACTN
     C                   ADD       1             Ix
     C                   MOVEL     'DDYLDC'      FldNameArr(Ix)
     C                   MOVEL     'USR9167'     MsgIdArr(Ix)
     C                   ENDIF
     C                   ENDIF
     C                   IF        *IN60 = *ON
     C     DDYLDC        CHAIN     @TRANL4                            60
     C                   IF        *IN60 = *OFF
     C                   MOVE      'N'           OKACTN
     C                   ADD       1             Ix
     C                   MOVEL     'DDYLDC'      FldNameArr(Ix)
     C                   MOVEL     'USR9167'     MsgIdArr(Ix)
     C                   ENDIF
     C                   ENDIF
     C                   IF        *IN60 = *ON
     C     DDYLDC        CHAIN     @TRANL5                            60
     C                   IF        *IN60 = *OFF
     C                   MOVE      'N'           OKACTN
     C                   ADD       1             Ix
     C                   MOVEL     'DDYLDC'      FldNameArr(Ix)
     C                   MOVEL     'USR9167'     MsgIdArr(Ix)
     C                   ENDIF
     C                   ENDIF
     ** Check if Yield Curve has a deal/loan sub-type linked to it
     C     DDYLDC        CHAIN     @TPSTL0                            60
     C                   IF        *IN60 = *OFF
     C                   MOVE      'N'           OKACTN
     C                   ADD       1             Ix
     C                   MOVEL     'DDYLDC'      FldNameArr(Ix)
     C                   MOVEL     'USR9168'     MsgIdArr(Ix)
     C                   ENDIF
     C                   IF        *IN60 = *ON
     C     DDYLDC        CHAIN     @TPSTL1                            60
     C                   IF        *IN60 = *OFF
     C                   MOVE      'N'           OKACTN
     C                   ADD       1             Ix
     C                   MOVEL     'DDYLDC'      FldNameArr(Ix)
     C                   MOVEL     'USR9168'     MsgIdArr(Ix)
     C                   ENDIF
     C                   ENDIF
     C                   IF        *IN60 = *ON
     C     DDYLDC        CHAIN     @TPSTL2                            60
     C                   IF        *IN60 = *OFF
     C                   MOVE      'N'           OKACTN
     C                   ADD       1             Ix
     C                   MOVEL     'DDYLDC'      FldNameArr(Ix)
     C                   MOVEL     'USR9168'     MsgIdArr(Ix)
     C                   ENDIF
     C                   ENDIF
     C                   IF        *IN60 = *ON
     C     DDYLDC        CHAIN     @TPSTL3                            60
     C                   IF        *IN60 = *OFF
     C                   MOVE      'N'           OKACTN
     C                   ADD       1             Ix
     C                   MOVEL     'DDYLDC'      FldNameArr(Ix)
     C                   MOVEL     'USR9168'     MsgIdArr(Ix)
     C                   ENDIF
     C                   ENDIF
     ** Check if Yield Curve still has Yield Rates linked to it
     C     DDYLDC        CHAIN     SDYLDRD0                           60
     C                   IF        *IN60 = *OFF
     C                   MOVE      'N'           OKACTN
     C                   ADD       1             Ix
     C                   MOVEL     'DDYLDC'      FldNameArr(Ix)
     C                   MOVEL     'USR9500'     MsgIdArr(Ix)
     C                   ENDIF
     C     DDYLDC        CHAIN     SDYLDCL1                           6061
     ** Yield Curves code must exists
     C                   IF        *IN60 = *ON
     C                   MOVE      'N'           OKACTN
     C                   ADD       1             Ix
     C                   MOVEL     'DDYLDC'      FldNameArr(Ix)
     C                   MOVEL     'USR7602'     MsgIdArr(Ix)
     C                   ENDIF
     C                   ENDSR
      *****************************************************************
      * INIT - Initial processing
      *****************************************************************
     C     INIT          BEGSR
 
      * Clear Outputs
     C                   CLEAR                   TranFilFmt
     C                   EVAL      OKACTN = 'Y'
     C                   EVAL      OKYLDC = 'Y'
 
 
     C                   ENDSR
      ********************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Initialisation
      *****************************************************************
     C     *INZSR        BEGSR
 
      *
      ** Parameters
      *
     C     *ENTRY        PLIST
 
      *
      ** Inputs
      *
      ** Return code
      *
     C                   PARM                    RetCodeIn
      *
      ** Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      ** Mode = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
      *
     C                   PARM                    ModeofOp          6
      *
      ** Response mode
      *
     C                   PARM                    RespMode          1
      *
      ** Action Code
      *
     C                   PARM                    DDACTN            1
      *
      ** Front Office Transaction ID
      *
     C                   PARM                    FOTRID           20
      *
      ** (Midas) Yield Curves Code
      *
     C                   PARM                    DDYLDC            5
      *
      ** Outputs
      *
      ** Transaction Details in File Format
      *
     C                   PARM                    TranFilFmt
      *
      ** OK - Action code
      *
     C                   PARM                    OKACTN            1
      *
      ** OK - Yield Curves Code
      *
     C                   PARM                    OKYLDC            1
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
      *
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ** Array index (3P0) from/to caller
      *
     C                   PARM                    Ix
      *
      ** Initialise program name
      *
     C                   EVAL      DBPGM = 'SDYLCURTV'
      *
      ** GET RUNDAT to access MULTI-BRANCHING flag
      *
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
      *
 
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
(c) Misys International Banking Systems Ltd. 2006
