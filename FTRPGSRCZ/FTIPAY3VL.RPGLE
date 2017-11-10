     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Incoming payments validation controller 3')   *
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FTIPAY3VL - Incoming Payments Validation Controller 3        *
      *                                                               *
      *  Function: This module validates Incoming Payments Level 2    *
      *            screen 2 fields for input into the Midas           *
      *            database.                                          *
      *                                                               *
      *  Component of: FTIPAYSIN                                      *
      *                FTIPAYCTL                                      *
      *                FTIPAYRPR                                      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CFT162             Date 08Sep17               *
      *  Prev Amend No. CFT120             Date 28Sep12               *
      *                 CSF011A            Date 28Nov11               *
      *                 CER059             Date 19Jul10               *
      *                 CER030             Date 09Jul08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CFT032             Date 11Sep06               *
      *                 CDL049             Date 06Jul06               *
      *                 BUG8170            Date 14Sep05               *
      *                 CGP001             Date 09Dec03               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CSW201             Date 02May01               *
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CFT009             Date 13Nov00               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CFT014             Date 25May00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CAP136  *CREATE    Date 15Nov99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CFT162 - MT900 and MT910 Message Generation (Recompile)      *
      *  CFT120 - FT IN/OP - Charges to DR of Account Currency        *
      *           (Recompile)                                         *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER030 - Multicash German Feature (Recompile)                *
      *  CFT032 - Account Line in Field 50X in MT103 (Recompile)      *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  BUG8170 - Validation of Fields in FT Incoming Payments       *
      *            Fields Intermediary Bank, SWIFT Reference and      *
      *            SWIFT sequence number should be validated          *
      *            accordingly. Also SWIFT Priority code should       *
      *            appear after Sequence Number field.                *
      *  CGP001 - Recompiled due to change in FTV2OPYPD               *
      *  CSW201 - SWIFT 2001 Standards Update                         *
      *  CFT009 - Funds Transfer Fees and Charges                     *
      *  CFT014 - Straight-through Processing Phase 2 MT103           *
      *           Messages Generation for FT.                         *
      *  CAP136 - Conversion of FT Incoming Payment inputs into       *
      *           modular structure to use as APIs.                   *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** Hook to enable non-core files to be included
      /COPY WNCPYSRC,FTIPY3V001
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      *
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indicator processing)
      **    False      logical = *off (for indicator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
      *
      /COPY ZACPYSRC,STD_D_SPEC
      *
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
      *
      /COPY ZACPYSRC,PSDS
      *
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
      *
      /COPY ZACPYSRC,ERR_ARRAYS
      *
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the size
      ** of the arrays.
      *
      /COPY ZACPYSRC,ERR_XARRYS
      *
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
      ***Incoming*Payments*Lvl*1*Scrn*details*from*incoming*transaction         CFT014
      ***-*screen*format***********************************************         CFT014
     D*NwIP1ScnFmt***E*DS***               EXTNAME(FTIPY1PD)                    CFT014
      *
      ** Incoming Payments Lvl 2 Scrn 2 details from incoming transaction
      ** - screen format
     D NwIP4ScnFmt   E DS                  EXTNAME(FTIPY4PD)
      *                                                                         CFT014
      ** Incoming Payments Lvl 2 Scrn 2 file 2 from incoming transaction        CFT014
      ** - screen format                                                        CFT014
     D NwIP4AScnFmt  E DS                  EXTNAME(FTIPY4APD)                   CFT014
      *
      ** Incoming Payments extra data
     D PExtData      E DS                  EXTNAME(FTIPEXPD)
      *
      ** Incoming Payments Lvl 2 Scrn 2 error indicators
     D FTEIPY3       E DS                  EXTNAME(FTEIPY3PD)
      *
      ** Incoming Payments for file update - file format
     D NwIPFilFmt    E DS                  EXTNAME(FTVIPAYPD)
      *                                                                         CFT014
      ** Incoming Payments (additional details) for file update                 CFT014
     D NwIP2FilFmt   E DS                  EXTNAME(FTVIPY2PD)                   CFT014
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Index for arrays of error message ids, etc.
     D IDx             S              3P 0
      *
      ** Index for arrays of warning error message ids, etc.
     D WIDx            S              3P 0
      *
      ** Index for update of error arrays
     D Ix              S              3  0
      *
      ** Response Mode
     D PResponse       S              1A
      *                                                                                       CSW201
      ** CSW201 flag                                                                          CSW201
     D CSW201          S              1A                                                      CSW201
      *
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      *
      /COPY WNCPYSRC,FTIPY3V002
      *
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ *INZSR is executed at program activation.                  ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *
      /COPY WNCPYSRC,FTIPY3V003
      *
      ** Intermediary Bank Validation.
      *
      /COPY WNCPYSRC,FTIPY3V004
      *
     C                   EXSR      SRInBk
      *
      /COPY WNCPYSRC,FTIPY3V005
      *
      ** Details Of Payment Validation.
      *
      /COPY WNCPYSRC,FTIPY3V006
      *
     C                   EXSR      SRDPay
      *
      /COPY WNCPYSRC,FTIPY3V007
      *
      ** Central Bank Reference Validation.
      *
      /COPY WNCPYSRC,FTIPY3V008
      *
     C                   EXSR      SRCBRF
      *
      /COPY WNCPYSRC,FTIPY3V009
      *
      ** Update Fontis dealer's reference.
      *
      /COPY WNCPYSRC,FTIPY3V010
      *
     C                   EVAL      IPRLPR = DDRLPR
      *
      /COPY WNCPYSRC,FTIPY3V011
      *                                                                         CFT014
      ** Transfer Commission Tariff Validation                                  CFT014
      *                                                                         CFT014
     C                   IF        CFT009 = 'N'                                 CFT009
     C                   EXSR      SRTRCT                                       CFT014
     C                   ELSE                                                   CFT009
     C                   EVAL      IPTRCT = *BLANKS                             CFT009
     C                   ENDIF                                                  CFT009
      *
      ** Outward Payment to be Generated Validation.
      *
      /COPY WNCPYSRC,FTIPY3V012
      *
     C                   EXSR      SROPIN
      *
      /COPY WNCPYSRC,FTIPY3V013
      *
      ***Details*of*Charges*Validation.********************************         CFT014
      *
      /COPY WNCPYSRC,FTIPY3V014
      *
     C*****              EXSR      SRDetC                                       CFT014
      *
      /COPY WNCPYSRC,FTIPY3V015
      *
      ***Transfer*Commission*Validation.*******************************         CFT014
      *
      /COPY WNCPYSRC,FTIPY3V016
      *
     C*****              EXSR      SRTRCM                                       CFT014
      *
      /COPY WNCPYSRC,FTIPY3V017
      *
      ***Telex*Charge*Validation.**************************************         CFT014
      *
      /COPY WNCPYSRC,FTIPY3V018
      *
     C*****              EXSR      SRTxCh                                       CFT014
      *
      /COPY WNCPYSRC,FTIPY3V019
      *
      ***Cheque*Charge*Validation.*************************************         CFT014
      *
      /COPY WNCPYSRC,FTIPY3V020
      *
     C*****              EXSR      SRCqCh                                       CFT014
      *
      /COPY WNCPYSRC,FTIPY3V021
      *
      ***Advice*Charge*Validation.*************************************         CFT014
      *
      /COPY WNCPYSRC,FTIPY3V022
      *
     C*****              EXSR      SRAdCh                                       CFT014
      *
      /COPY WNCPYSRC,FTIPY3V023
      *
      ***Telephone*Charge*Validation.**********************************         CFT014
      *
      /COPY WNCPYSRC,FTIPY3V024
      *
     C*****              EXSR      SRTlCh                                       CFT014
      *
      /COPY WNCPYSRC,FTIPY3V025
      *
      ***Miscellaneous*Charge*Validation.******************************         CFT014
      *
      /COPY WNCPYSRC,FTIPY3V026
      *
     C*****              EXSR      SRMsCh                                       CFT014
      *
      /COPY WNCPYSRC,FTIPY3V027
      *
      ***FX/Change*Commission*Validation.******************************         CFT014
      *
      /COPY WNCPYSRC,FTIPY3V028
      *
     C*****              IF        S01494 = 'Y'                                 CFT014
     C*****              EXSR      SRFXCM                                       CFT014
     C*****              ELSE                                                   CFT014
     C*****              EVAL      DDCHCD = *BLANKS                             CFT014
     C*****              EVAL      DDVAT7 = *BLANK                              CFT014
     C*****              ENDIF                                                  CFT014
      *
      /COPY WNCPYSRC,FTIPY3V029
      *
      ***Total*Charges*Validation.*************************************         CFT014
      *
      /COPY WNCPYSRC,FTIPY3V030
      *
     C*****              EXSR      SRTOTC                                       CFT014
      *
      /COPY WNCPYSRC,FTIPY3V031
      *
      ***Update*VAT*Rate.**********************************************         CFT014
      *
      /COPY WNCPYSRC,FTIPY3V032
      *
     C*****              IF        S01499 = 'Y'                                 CFT014
     C*****              IF        IPINDUM8 <> 0 or IPINVATT <> 0               CFT014
     C*****              Z-ADD     PVATR         IPINVATR                       CFT014
     C*****              ENDIF                                                  CFT014
     C*****              ENDIF                                                  CFT014
      *
      /COPY WNCPYSRC,FTIPY3V033
      *
      ***Margin*Information*Validation.********************************         CFT014
      *
      /COPY WNCPYSRC,FTIPY3V034
      *
     C*****              IF        BGN0ST = 'Y'                                 CFT014
     C*****              EXSR      SRMINF                                       CFT014
     C*****              ELSE                                                   CFT014
     C*****              EVAL      DDFXMP = *BLANKS                             CFT014
     C*****              EVAL      DDMBSI = *BLANK                              CFT014
     C*****              EVAL      DDMSIG = *BLANK                              CFT014
     C*****              ENDIF                                                  CFT014
      *
      /COPY WNCPYSRC,FTIPY3V035
      *
     C                   IF        CFT014 = 'Y'                                 CFT014
      *                                                                         CFT014
      ** Bank Operation Code                                                    CFT014
     C                   EXSR      SRBOCD                                       CFT014
      *                                                                         CFT014
      ** Transaction Type Code                                                  CFT014
     C                   EXSR      SRTTCD                                       CFT014
      *                                                                         CFT014
      ** Instruction Code                                                       CFT014
     C                   EXSR      SRICDE                                       CFT014
      *                                                                         CFT014
      ** Regulatory Reporting                                                   CFT014
     C                   EXSR      SRRRPT                                       CFT014
      *                                                                         CFT014
     C                   ENDIF                                                  CFT014
      *                                                                         CFT014
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** Hook to enable non-core subroutines to be included
      *
      /COPY WNCPYSRC,FTIPY3V036
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRINBK - Intermediary Bank Validation                        *
      *                                                               *
      *****************************************************************
      *
     C     SRInBk        BEGSR
      *
      ** Reset fields.
      *
     C                   EXSR      SRResetErrs
      *
      ** Call validation module.
      *
     C                   CALLB     'FTVIINBK'
      *                             ========
      ** INPUT
      ** =====
      *
      ** Return Code
     C                   PARM                    RetCodeOut
      *
      ** Incoming Payments Lvl 2 Scrn 2 details from incoming transaction
      ** - screen format
     C                   PARM                    NwIP4ScnFmt
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair Function)
      ** Mode = '*SIN  ' (Screen Input Function)
     C                   PARM                    PMode
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *                                                                                      BUG8170
      ** Warning fields/message IDs/message data (arrays) from/to caller                     BUG8170
     C                   Parm                    WFldNmXAr                                   BUG8170
     C                   PARM                    WMsgIDXAr                                   BUG8170
     C                   PARM                    WMsgDtXAr                                   BUG8170
      *
      ** Incoming Payments Lvl 2 Scrn 2 error indicators
     C                   PARM                    FTEIPY3
      *
      ** Incoming Payments for file update - file format
     C                   PARM                    NwIPFilFmt
      *
      ** Update error information.
      *
     C                   IF        RetCodeOut <> *BLANKS
     C                   EXSR      SRUpdatErrs
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDPAY - Details Of Payment Validation                       *
      *                                                               *
      *****************************************************************
      *
     C     SRDPay        BEGSR
      *
      ** Reset fields.
      *
     C                   EXSR      SRResetErrs
      *
      ** Call validation module.
      *
     C                   CALLB     'FTVIDTPY'
      *                             ========
      ** INPUT
      ** =====
      *
      ** Return Code
     C                   PARM                    RetCodeOut
      *
      ** Incoming Payments Lvl 2 Scrn 2 details from incoming transaction
      ** - screen format
     C                   PARM                    NwIP4ScnFmt
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair Function)
      ** Mode = '*SIN  ' (Screen Input Function)
     C                   PARM                    PMode
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Incoming Payments Lvl 2 Scrn 2 error indicators
     C                   PARM                    FTEIPY3
      *
      ** Incoming Payments for file update - file format
     C                   PARM                    NwIPFilFmt
      *
      ** Update error information.
      *
     C                   IF        RetCodeOut <> *BLANKS
     C                   EXSR      SRUpdatErrs
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCBRF - Central Bank Reference Validation                   *
      *                                                               *
      *****************************************************************
      *
     C     SRCBRF        BEGSR
      *
      ** Reset fields.
      *
     C                   EXSR      SRResetErrs
      *
      ** Call validation module.
      *
     C                   CALLB     'FTVIDNBC'
      *                             ========
      ** INPUT
      ** =====
      *
      ** Return Code
     C                   PARM                    RetCodeOut
      *
      ** Incoming Payments Lvl 2 Scrn 2 details from incoming transaction
      ** - screen format
     C                   PARM                    NwIP4ScnFmt
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair Function)
      ** Mode = '*SIN  ' (Screen Input Function)
     C                   PARM                    PMode
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Incoming Payments Lvl 2 Scrn 2 error indicators
     C                   PARM                    FTEIPY3
      *
      ** Incoming Payments for file update - file format
     C                   PARM                    NwIPFilFmt
      *
      ** Update error information.
      *
     C                   IF        RetCodeOut <> *BLANKS
     C                   EXSR      SRUpdatErrs
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT                                                                    CFT014
      *****************************************************************         CFT014
      *                                                               *         CFT014
      *  SRTRCT - Transfer Commission Tariff Validation               *         CFT014
      *                                                               *         CFT014
      *****************************************************************         CFT014
      *                                                                         CFT014
     C     SRTRCT        BEGSR                                                  CFT014
      *                                                                         CFT014
      ** Reset fields.                                                          CFT014
      *                                                                         CFT014
     C                   EXSR      SRResetErrs                                  CFT014
      *                                                                         CFT014
      ** Call validation module                                                 CFT014
      *                                                                         CFT014
     C                   CALLB     'FTVITRCT'                                   CFT014
      ** O: Return Code                                                         CFT014
     C                   PARM                    RetCodeOut                     CFT014
      *                                                                         CFT014
      ** Incoming Payments Lvl 2 Scrn 1/2 details from incoming transaction     CFT014
      ** - screen format                                                        CFT014
     C                   PARM                    NwIP4ScnFmt                    CFT014
      *                                                                         CFT014
      ** Charges Branch                                                         CFT014
     C                   PARM                    PPYBR                          CFT014
      *                                                                         CFT014
      ** OUTPUT                                                                 CFT014
      ** ======                                                                 CFT014
      *                                                                         CFT014
      ** Error fields/message IDs/message data (arrays) from/to caller          CFT014
     C                   Parm                    FldNamXAr                      CFT014
     C                   PARM                    MsgIDXAr                       CFT014
     C                   PARM                    MsgDtaXAr                      CFT014
      *                                                                         CFT014
      ** Incoming Payments Lvl 2 Scrn 1 error indicators                        CFT014
     C                   PARM                    FTEIPY3                        CFT014
      *                                                                         CFT014
      ** Incoming Payments for file update - file format                        CFT014
     C                   PARM                    NwIPFilFmt                     CFT014
      *                                                                         CFT014
      ** Update error information.                                              CFT014
      *                                                                         CFT014
     C                   IF        RetCodeOut <> *BLANKS                        CFT014
     C                   EXSR      SRUpdatErrs                                  CFT014
     C                   ENDIF                                                  CFT014
      *                                                                         CFT014
     C                   ENDSR                                                  CFT014
      *                                                                         CFT014
      *****************************************************************         CFT014
      /EJECT
      *****************************************************************
      *                                                               *
      *  SROPIN - Outward Payment to be Generated Validation          *
      *                                                               *
      *****************************************************************
      *
     C     SROPIN        BEGSR
      *
      ** Reset fields.
      *
     C                   EXSR      SRResetErrs
      *
      ** Call validation module.
      *
     C                   CALLB     'FTVIOPIN'
      *                             ========
      ** INPUT
      ** =====
      *
      ** Return Code
     C                   PARM                    RetCodeOut
      *
      ** Incoming Payments Lvl 2 Scrn 2 details from incoming transaction
      ** - screen format
     C                   PARM                    NwIP4ScnFmt
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair Function)
      ** Mode = '*SIN  ' (Screen Input Function)
     C                   PARM                    PMode
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Incoming Payments Lvl 2 Scrn 2 error indicators
     C                   PARM                    FTEIPY3
      *
      ** Incoming Payments for file update - file format
     C                   PARM                    NwIPFilFmt
      *
      ** Update error information.
      *
     C                   IF        RetCodeOut <> *BLANKS
     C                   EXSR      SRUpdatErrs
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *****************************************************************         CFT014
      ***SRDETC*-*Details*of*Charges*Validation************************         CFT014
      *****************************************************************         CFT014
      *****************************************************************
      *****************************************************************         CFT014
     C*****SRDetC        BEGSR                                                  CFT014
      *****************************************************************         CFT014
      ***Reset*fields.*************************************************         CFT014
      *****************************************************************         CFT014
     C*****              EXSR      SRResetErrs                                  CFT014
      *****************************************************************         CFT014
      ***Call*validation*module.***************************************         CFT014
      *****************************************************************         CFT014
     C*****              CALLB     'FTVIDTCH'                                   CFT014
      ******************************========***************************         CFT014
      ***INPUT*********************************************************         CFT014
      ***=====*********************************************************         CFT014
      *****************************************************************         CFT014
      ***Return*Code***************************************************         CFT014
     C*****              PARM                    RetCodeOut                     CFT014
      *****************************************************************         CFT014
      ***Incoming*Payments*Lvl*2*Scrn*2*details*from*incoming*transaction       CFT014
      ***-*screen*format***********************************************         CFT014
     C*****              PARM                    NwIP4ScnFmt                    CFT014
      *****************************************************************         CFT014
      ***Mode*=*'*FRONT'*(Front*Office*Transaction*Interface)**********         CFT014
      ***Mode*=*'******'*(Not*Front*Office*Transaction*Interface)******         CFT014
      ***Mode*=*'*RPR**'*(Repair*Function)*****************************         CFT014
      ***Mode*=*'*SIN**'*(Screen*Input*Function)***********************         CFT014
     C*****              PARM                    PMode                          CFT014
      *****************************************************************         CFT014
      ***OUTPUT********************************************************         CFT014
      ***======********************************************************         CFT014
      *****************************************************************         CFT014
      ***Error*fields/message*IDs/message*data*(arrays)*from/to*caller*         CFT014
     C*****              Parm                    FldNamXAr                      CFT014
     C*****              PARM                    MsgIDXAr                       CFT014
     C*****              PARM                    MsgDtaXAr                      CFT014
      *****************************************************************         CFT014
      ***Incoming*Payments*Lvl*2*Scrn*2*error*indicators***************         CFT014
     C*****              PARM                    FTEIPY3                        CFT014
      *****************************************************************         CFT014
      ***Incoming*Payments*for*file*update*-*file*format***************         CFT014
     C*****              PARM                    NwIPFilFmt                     CFT014
      *****************************************************************         CFT014
      ***Update*error*information.*************************************         CFT014
      *****************************************************************         CFT014
     C*****              IF        RetCodeOut <> *BLANKS                        CFT014
     C*****              EXSR      SRUpdatErrs                                  CFT014
     C*****              ENDIF                                                  CFT014
      *****************************************************************         CFT014
     C*****              ENDSR                                                  CFT014
      *****************************************************************         CFT014
      *****************************************************************
      /EJECT
      *****************************************************************
      *****************************************************************         CFT014
      ***SRTRCM*-*Transfer*Commission*Validation***********************         CFT014
      *****************************************************************         CFT014
      *****************************************************************
      *****************************************************************         CFT014
     C*****SRTRCM        BEGSR                                                  CFT014
      *****************************************************************         CFT014
      ***Reset*fields.*************************************************         CFT014
      *****************************************************************         CFT014
     C*****              EXSR      SRResetErrs                                  CFT014
      *****************************************************************         CFT014
      ***Call*validation*module.***************************************         CFT014
      *****************************************************************         CFT014
     C*****              CALLB     'FTVITRCV'                                   CFT014
      *****************************************************************         CFT014
      ***INPUT*********************************************************         CFT014
      ***=====*********************************************************         CFT014
      *****************************************************************         CFT014
      ***Return*Code***************************************************         CFT014
     C*****              PARM                    RetCodeOut                     CFT014
      *****************************************************************         CFT014
      ***Incoming*Payments*Lvl*2*Scrn*2*details*from*incoming*transaction       CFT014
      ***-*screen*format***********************************************         CFT014
     C*****              PARM                    NwIP4ScnFmt                    CFT014
      *****************************************************************         CFT014
      ***Mode*=*'*FRONT'*(Front*Office*Transaction*Interface)**********         CFT014
      ***Mode*=*'******'*(Not*Front*Office*Transaction*Interface)******         CFT014
      ***Mode*=*'*RPR**'*(Repair*Function)*****************************         CFT014
      ***Mode*=*'*SIN**'*(Screen*Input*Function)***********************         CFT014
     C*****              PARM                    PMode                          CFT014
      *****************************************************************         CFT014
      ***Input*Charge*Currency*****************************************         CFT014
     C*****              PARM                    PICCY                          CFT014
      *****************************************************************         CFT014
      ***Input*Charge*Currency*No.*of*Decimal*Places*******************         CFT014
     C*****              PARM                    PINBDP                         CFT014
      *****************************************************************         CFT014
      ***STANDING*DATA*************************************************         CFT014
      ***=============*************************************************         CFT014
      *****************************************************************         CFT014
      ***VAT*Default*Flag**********************************************         CFT014
     C*****              PARM                    PVATT                          CFT014
      *****************************************************************         CFT014
      ***VAT*Rate******************************************************         CFT014
     C*****              PARM                    PVATR                          CFT014
      *****************************************************************         CFT014
      ***SWITCHABLE*FEATURES*******************************************         CFT014
      ***===================*******************************************         CFT014
      *****************************************************************         CFT014
      ***BLI*VAT*Processing*Feature************************************         CFT014
     C*****              PARM                    S01499                         CFT014
      *****************************************************************         CFT014
      ***OUTPUT********************************************************         CFT014
      ***======********************************************************         CFT014
      *****************************************************************         CFT014
      ***Error*fields/message*IDs/message*data*(arrays)*from/to*caller*         CFT014
     C*****              Parm                    FldNamXAr                      CFT014
     C*****              PARM                    MsgIDXAr                       CFT014
     C*****              PARM                    MsgDtaXAr                      CFT014
      *****************************************************************         CFT014
      ***Incoming*Payments*Lvl*2*Scrn*2*error*indicators***************         CFT014
     C*****              PARM                    FTEIPY3                        CFT014
      *****************************************************************         CFT014
      ***Incoming*Payments*for*file*update*-*file*format***************         CFT014
     C*****              PARM                    NwIPFilFmt                     CFT014
      *****************************************************************         CFT014
      ***Update*error*information.*************************************         CFT014
      *****************************************************************         CFT014
     C*****              IF        RetCodeOut <> *BLANKS                        CFT014
     C*****              EXSR      SRUpdatErrs                                  CFT014
     C*****              ENDIF                                                  CFT014
      *****************************************************************         CFT014
     C*****              ENDSR                                                  CFT014
      *****************************************************************         CFT014
      *****************************************************************
      /EJECT
      *****************************************************************
      *****************************************************************         CFT014
      ***SRTXCH*-*Telex*Charge*Validation******************************         CFT014
      *****************************************************************         CFT014
      *****************************************************************
      *****************************************************************         CFT014
     C*****SRTxCh        BEGSR                                                  CFT014
      *****************************************************************         CFT014
      ***Reset*fields.*************************************************         CFT014
      *****************************************************************         CFT014
     C*****              EXSR      SRResetErrs                                  CFT014
      *****************************************************************         CFT014
      ***Call*validation*module.***************************************         CFT014
      *****************************************************************         CFT014
     C*****              CALLB     'FTVITXCV'                                   CFT014
      ******************************========***************************         CFT014
      ***INPUT*********************************************************         CFT014
      ***=====*********************************************************         CFT014
      *****************************************************************         CFT014
      ***Return*Code***************************************************         CFT014
     C*****              PARM                    RetCodeOut                     CFT014
      *****************************************************************         CFT014
      ***Incoming*Payments*Lvl*2*Scrn*2*details*from*incoming*transaction       CFT014
      ***-*screen*format***********************************************         CFT014
     C*****              PARM                    NwIP4ScnFmt                    CFT014
      *****************************************************************         CFT014
      ***Mode*=*'*FRONT'*(Front*Office*Transaction*Interface)**********         CFT014
      ***Mode*=*'******'*(Not*Front*Office*Transaction*Interface)******         CFT014
      ***Mode*=*'*RPR**'*(Repair*Function)*****************************         CFT014
      ***Mode*=*'*SIN**'*(Screen*Input*Function)***********************         CFT014
     C*****              PARM                    PMode                          CFT014
      *****************************************************************         CFT014
      ***Input*Charge*Currency*****************************************         CFT014
     C*****              PARM                    PICCY                          CFT014
      *****************************************************************         CFT014
      ***Input*Charge*Currency*No.*of*Decimal*Places*******************         CFT014
     C*****              PARM                    PINBDP                         CFT014
      *****************************************************************         CFT014
      ***STANDING*DATA*************************************************         CFT014
      ***=============*************************************************         CFT014
      *****************************************************************         CFT014
      ***VAT*Default*Flag**********************************************         CFT014
     C*****              PARM                    PVATT                          CFT014
      *****************************************************************         CFT014
      ***VAT*Rate******************************************************         CFT014
     C*****              PARM                    PVATR                          CFT014
      *****************************************************************         CFT014
      ***SWITCHABLE*FEATURES*******************************************         CFT014
      ***===================*******************************************         CFT014
      *****************************************************************         CFT014
      ***BLI*VAT*Processing*Feature************************************         CFT014
     C*****              PARM                    S01499                         CFT014
      *****************************************************************         CFT014
      ***OUTPUT********************************************************         CFT014
      ***======********************************************************         CFT014
      *****************************************************************         CFT014
      ***Error*fields/message*IDs/message*data*(arrays)*from/to*caller*         CFT014
     C*****              Parm                    FldNamXAr                      CFT014
     C*****              PARM                    MsgIDXAr                       CFT014
     C*****              PARM                    MsgDtaXAr                      CFT014
      *****************************************************************         CFT014
      ***Incoming*Payments*Lvl*2*Scrn*2*error*indicators***************         CFT014
     C*****              PARM                    FTEIPY3                        CFT014
      *****************************************************************         CFT014
      ***Incoming*Payments*for*file*update*-*file*format***************         CFT014
     C*****              PARM                    NwIPFilFmt                     CFT014
      *****************************************************************         CFT014
      ***Update*error*information.*************************************         CFT014
      *****************************************************************         CFT014
     C*****              IF        RetCodeOut <> *BLANKS                        CFT014
     C*****              EXSR      SRUpdatErrs                                  CFT014
     C*****              ENDIF                                                  CFT014
      *****************************************************************         CFT014
     C*****              ENDSR                                                  CFT014
      *****************************************************************         CFT014
      *****************************************************************
      /EJECT
      *****************************************************************
      *****************************************************************         CFT014
      ***SRCQCH*-*Cheque*Charge*Validation*****************************         CFT014
      *****************************************************************         CFT014
      *****************************************************************
      *****************************************************************         CFT014
     C*****SRCqCh        BEGSR                                                  CFT014
      *****************************************************************         CFT014
      ***Reset*fields.*************************************************         CFT014
      *****************************************************************         CFT014
     C*****              EXSR      SRResetErrs                                  CFT014
      *****************************************************************         CFT014
      ***Call*validation*module.***************************************         CFT014
      *****************************************************************         CFT014
     C*****              CALLB     'FTVICQCV'                                   CFT014
      *****************************************************************         CFT014
      ***INPUT*********************************************************         CFT014
      ***=====*********************************************************         CFT014
      *****************************************************************         CFT014
      ***Return*Code***************************************************         CFT014
     C*****              PARM                    RetCodeOut                     CFT014
      *****************************************************************         CFT014
      ***Incoming*Payments*Lvl*2*Scrn*2*details*from*incoming*transaction       CFT014
      ***-*screen*format***********************************************         CFT014
     C*****              PARM                    NwIP4ScnFmt                    CFT014
      *****************************************************************         CFT014
      ***Mode*=*'*FRONT'*(Front*Office*Transaction*Interface)**********         CFT014
      ***Mode*=*'******'*(Not*Front*Office*Transaction*Interface)******         CFT014
      ***Mode*=*'*RPR**'*(Repair*Function)*****************************         CFT014
      ***Mode*=*'*SIN**'*(Screen*Input*Function)***********************         CFT014
     C*****              PARM                    PMode                          CFT014
      *****************************************************************         CFT014
      ***Input*Charge*Currency*****************************************         CFT014
     C*****              PARM                    PICCY                          CFT014
      *****************************************************************         CFT014
      ***Input*Charge*Currency*No.*of*Decimal*Places*******************         CFT014
     C*****              PARM                    PINBDP                         CFT014
      *****************************************************************         CFT014
      ***STANDING*DATA*************************************************         CFT014
      ***=============*************************************************         CFT014
      *****************************************************************         CFT014
      ***VAT*Default*Flag**********************************************         CFT014
     C*****              PARM                    PVATT                          CFT014
      *****************************************************************         CFT014
      ***VAT*Rate******************************************************         CFT014
     C*****              PARM                    PVATR                          CFT014
      *****************************************************************         CFT014
      ***SWITCHABLE*FEATURES*******************************************         CFT014
      ***===================*******************************************         CFT014
      *****************************************************************         CFT014
      ***BLI*VAT*Processing*Feature************************************         CFT014
     C*****              PARM                    S01499                         CFT014
      *****************************************************************         CFT014
      ***OUTPUT********************************************************         CFT014
      ***======********************************************************         CFT014
      *****************************************************************         CFT014
      ***Error*fields/message*IDs/message*data*(arrays)*from/to*caller*         CFT014
     C*****              Parm                    FldNamXAr                      CFT014
     C*****              PARM                    MsgIDXAr                       CFT014
     C*****              PARM                    MsgDtaXAr                      CFT014
      *****************************************************************         CFT014
      ***Incoming*Payments*Lvl*2*Scrn*2*error*indicators***************         CFT014
     C*****              PARM                    FTEIPY3                        CFT014
      *****************************************************************         CFT014
      ***Incoming*Payments*for*file*update*-*file*format***************         CFT014
     C*****              PARM                    NwIPFilFmt                     CFT014
      *****************************************************************         CFT014
      ***Update*error*information.*************************************         CFT014
      *****************************************************************         CFT014
     C*****              IF        RetCodeOut <> *BLANKS                        CFT014
     C*****              EXSR      SRUpdatErrs                                  CFT014
     C*****              ENDIF                                                  CFT014
      *****************************************************************         CFT014
     C*****              ENDSR                                                  CFT014
      *****************************************************************         CFT014
      *****************************************************************
      /EJECT
      *****************************************************************
      *****************************************************************         CFT014
      ***SRADCH*-*Advice*Charge*Validation*****************************         CFT014
      *****************************************************************         CFT014
      *****************************************************************
      *****************************************************************         CFT014
     C*****SRAdCh        BEGSR                                                  CFT014
      *****************************************************************         CFT014
      ***Reset*fields.*************************************************         CFT014
      *****************************************************************         CFT014
     C*****              EXSR      SRResetErrs                                  CFT014
      *****************************************************************         CFT014
      ***Call*validation*module.***************************************         CFT014
      *****************************************************************         CFT014
     C*****              CALLB     'FTVIADCV'                                   CFT014
      ******************************========***************************         CFT014
      ***INPUT*********************************************************         CFT014
      ***=====*********************************************************         CFT014
      *****************************************************************         CFT014
      ***Return*Code***************************************************         CFT014
     C*****              PARM                    RetCodeOut                     CFT014
      *****************************************************************         CFT014
      ***Incoming*Payments*Lvl*2*Scrn*2*details*from*incoming*transaction       CFT014
      ***-*screen*format***********************************************         CFT014
     C*****              PARM                    NwIP4ScnFmt                    CFT014
      *****************************************************************         CFT014
      ***Mode*=*'*FRONT'*(Front*Office*Transaction*Interface)**********         CFT014
      ***Mode*=*'******'*(Not*Front*Office*Transaction*Interface)******         CFT014
      ***Mode*=*'*RPR**'*(Repair*Function)*****************************         CFT014
      ***Mode*=*'*SIN**'*(Screen*Input*Function)***********************         CFT014
     C*****              PARM                    PMode                          CFT014
      *****************************************************************         CFT014
      ***Input*Charge*Currency*****************************************         CFT014
     C*****              PARM                    PICCY                          CFT014
      *****************************************************************         CFT014
      ***Input*Charge*Currency*No.*of*Decimal*Places*******************         CFT014
     C*****              PARM                    PINBDP                         CFT014
      *****************************************************************         CFT014
      ***STANDING*DATA*************************************************         CFT014
      ***=============*************************************************         CFT014
      *****************************************************************         CFT014
      ***VAT*Default*Flag**********************************************         CFT014
     C*****              PARM                    PVATT                          CFT014
      *****************************************************************         CFT014
      ***VAT*Rate******************************************************         CFT014
     C*****              PARM                    PVATR                          CFT014
      *****************************************************************         CFT014
      ***SWITCHABLE*FEATURES*******************************************         CFT014
      ***===================*******************************************         CFT014
      *****************************************************************         CFT014
      ***BLI*VAT*Processing*Feature************************************         CFT014
     C*****              PARM                    S01499                         CFT014
      *****************************************************************         CFT014
      ***OUTPUT********************************************************         CFT014
      ***======********************************************************         CFT014
      *****************************************************************         CFT014
      ***Error*fields/message*IDs/message*data*(arrays)*from/to*caller*         CFT014
     C*****              Parm                    FldNamXAr                      CFT014
     C*****              PARM                    MsgIDXAr                       CFT014
     C*****              PARM                    MsgDtaXAr                      CFT014
      *****************************************************************         CFT014
      ***Incoming*Payments*Lvl*2*Scrn*2*error*indicators***************         CFT014
     C*****              PARM                    FTEIPY3                        CFT014
      *****************************************************************         CFT014
      ***Incoming*Payments*for*file*update*-*file*format***************         CFT014
     C*****              PARM                    NwIPFilFmt                     CFT014
      *****************************************************************         CFT014
      ***Update*error*information.*************************************         CFT014
      *****************************************************************         CFT014
     C*****              IF        RetCodeOut <> *BLANKS                        CFT014
     C*****              EXSR      SRUpdatErrs                                  CFT014
     C*****              ENDIF                                                  CFT014
      *****************************************************************         CFT014
     C*****              ENDSR                                                  CFT014
      *****************************************************************         CFT014
      *****************************************************************
      /EJECT
      *****************************************************************
      *****************************************************************         CFT014
      ***SRTLCH*-*Telephone*Charge*Validation**************************         CFT014
      *****************************************************************         CFT014
      *****************************************************************
      *****************************************************************         CFT014
     C*****SRTlCh        BEGSR                                                  CFT014
      *****************************************************************         CFT014
      ***Reset*fields.*************************************************         CFT014
      *****************************************************************         CFT014
     C*****              EXSR      SRResetErrs                                  CFT014
      *****************************************************************         CFT014
      ***Call*validation*module.***************************************         CFT014
      *****************************************************************         CFT014
     C*****              CALLB     'FTVITLCV'                                   CFT014
      *****************************************************************         CFT014
      ***INPUT*********************************************************         CFT014
      ***=====*********************************************************         CFT014
      *****************************************************************         CFT014
      ***Return*Code***************************************************         CFT014
     C*****              PARM                    RetCodeOut                     CFT014
      *****************************************************************         CFT014
      ***Incoming*Payments*Lvl*2*Scrn*2*details*from*incoming*transaction       CFT014
      ***-*screen*format***********************************************         CFT014
     C*****              PARM                    NwIP4ScnFmt                    CFT014
      *****************************************************************         CFT014
      ***Mode*=*'*FRONT'*(Front*Office*Transaction*Interface)**********         CFT014
      ***Mode*=*'******'*(Not*Front*Office*Transaction*Interface)******         CFT014
      ***Mode*=*'*RPR**'*(Repair*Function)*****************************         CFT014
      ***Mode*=*'*SIN**'*(Screen*Input*Function)***********************         CFT014
     C*****              PARM                    PMode                          CFT014
      *****************************************************************         CFT014
      ***Input*Charge*Currency*****************************************         CFT014
     C*****              PARM                    PICCY                          CFT014
      *****************************************************************         CFT014
      ***Input*Charge*Currency*No.*of*Decimal*Places*******************         CFT014
     C*****              PARM                    PINBDP                         CFT014
      *****************************************************************         CFT014
      ***STANDING*DATA*************************************************         CFT014
      ***=============*************************************************         CFT014
      *****************************************************************         CFT014
      ***VAT*Default*Flag**********************************************         CFT014
     C*****              PARM                    PVATT                          CFT014
      *****************************************************************         CFT014
      ***VAT*Rate******************************************************         CFT014
     C*****              PARM                    PVATR                          CFT014
      *****************************************************************         CFT014
      ***SWITCHABLE*FEATURES*******************************************         CFT014
      ***===================*******************************************         CFT014
      *****************************************************************         CFT014
      ***BLI*VAT*Processing*Feature************************************         CFT014
     C*****              PARM                    S01499                         CFT014
      *****************************************************************         CFT014
      ***OUTPUT********************************************************         CFT014
      ***======********************************************************         CFT014
      *****************************************************************         CFT014
      ***Error*fields/message*IDs/message*data*(arrays)*from/to*caller*         CFT014
     C*****              Parm                    FldNamXAr                      CFT014
     C*****              PARM                    MsgIDXAr                       CFT014
     C*****              PARM                    MsgDtaXAr                      CFT014
      *****************************************************************         CFT014
      ***Incoming*Payments*Lvl*2*Scrn*2*error*indicators***************         CFT014
     C*****              PARM                    FTEIPY3                        CFT014
      *****************************************************************         CFT014
      ***Incoming*Payments*for*file*update*-*file*format***************         CFT014
     C*****              PARM                    NwIPFilFmt                     CFT014
      *****************************************************************         CFT014
      ***Update*error*information.*************************************         CFT014
      *****************************************************************         CFT014
     C*****              IF        RetCodeOut <> *BLANKS                        CFT014
     C*****              EXSR      SRUpdatErrs                                  CFT014
     C*****              ENDIF                                                  CFT014
      *****************************************************************         CFT014
     C*****              ENDSR                                                  CFT014
      *****************************************************************         CFT014
      *****************************************************************
      /EJECT
      *****************************************************************
      *****************************************************************         CFT014
      ***SRMSCH*-*Miscellaneous*Charge*Validation**********************         CFT014
      *****************************************************************         CFT014
      *****************************************************************
      *****************************************************************         CFT014
     C*****SRMsCh        BEGSR                                                  CFT014
      *****************************************************************         CFT014
      ***Reset*fields.*************************************************         CFT014
      *****************************************************************         CFT014
     C*****              EXSR      SRResetErrs                                  CFT014
      *****************************************************************         CFT014
      ***Call*validation*module.***************************************         CFT014
      *****************************************************************         CFT014
     C*****              CALLB     'FTVIMSCV'                                   CFT014
      ******************************========***************************         CFT014
      ***INPUT*********************************************************         CFT014
      ***=====*********************************************************         CFT014
      *****************************************************************         CFT014
      ***Return Code***************************************************         CFT014
     C*****              PARM                    RetCodeOut                     CFT014
      *****************************************************************         CFT014
      ***Incoming*Payments*Lvl*2*Scrn*2*details*from*incoming*transaction       CFT014
      ***-*screen*format***********************************************         CFT014
     C*****              PARM                    NwIP4ScnFmt                    CFT014
      *****************************************************************         CFT014
      ***Mode*=*'*FRONT'*(Front*Office*Transaction*Interface)**********         CFT014
      ***Mode*=*'******'*(Not*Front*Office*Transaction*Interface)******         CFT014
      ***Mode*=*'*RPR**'*(Repair*Function)*****************************         CFT014
      ***Mode*=*'*SIN**'*(Screen*Input*Function)***********************         CFT014
     C*****              PARM                    PMode                          CFT014
      *****************************************************************         CFT014
      ***Input*Charge*Currency*****************************************         CFT014
     C*****              PARM                    PICCY                          CFT014
      *****************************************************************         CFT014
      ***Input*Charge*Currency*No.*of*Decimal*Places*******************         CFT014
     C*****              PARM                    PINBDP                         CFT014
      *****************************************************************         CFT014
      ***STANDING*DATA*************************************************         CFT014
      ***=============*************************************************         CFT014
      *****************************************************************         CFT014
      ***VAT*Default*Flag**********************************************         CFT014
     C*****              PARM                    PVATT                          CFT014
      *****************************************************************         CFT014
      ***VAT*Rate******************************************************         CFT014
     C*****              PARM                    PVATR                          CFT014
      *****************************************************************         CFT014
      ***SWITCHABLE*FEATURES*******************************************         CFT014
      ***===================*******************************************         CFT014
      *****************************************************************         CFT014
      ***BLI*VAT*Processing*Feature************************************         CFT014
     C*****              PARM                    S01499                         CFT014
      *****************************************************************         CFT014
      ***OUTPUT********************************************************         CFT014
      ***======********************************************************         CFT014
      *****************************************************************         CFT014
      ***Error*fields/message*IDs/message*data*(arrays)*from/to*caller*         CFT014
     C*****              Parm                    FldNamXAr                      CFT014
     C*****              PARM                    MsgIDXAr                       CFT014
     C*****              PARM                    MsgDtaXAr                      CFT014
      *****************************************************************         CFT014
      ***Incoming*Payments*Lvl*2*Scrn*2*error*indicators***************         CFT014
     C*****              PARM                    FTEIPY3                        CFT014
      *****************************************************************         CFT014
      ***Incoming*Payments*for*file*update*-*file*format***************         CFT014
     C*****              PARM                    NwIPFilFmt                     CFT014
      *****************************************************************         CFT014
      ***Update*error*information.*************************************         CFT014
      *****************************************************************         CFT014
     C*****              IF        RetCodeOut <> *BLANKS                        CFT014
     C*****              EXSR      SRUpdatErrs                                  CFT014
     C*****              ENDIF                                                  CFT014
      *****************************************************************         CFT014
     C*****              ENDSR                                                  CFT014
      *****************************************************************         CFT014
      *****************************************************************
      /EJECT
      *****************************************************************
      *****************************************************************         CFT014
      ***SRFXCM*-*FX/Change*Commission*Validation**********************         CFT014
      *****************************************************************         CFT014
      *****************************************************************
      *****************************************************************         CFT014
     C*****SRFXCM        BEGSR                                                  CFT014
      *****************************************************************         CFT014
      ***Reset*fields.*************************************************         CFT014
      *****************************************************************         CFT014
     C*****              EXSR      SRResetErrs                                  CFT014
      *****************************************************************         CFT014
      ***Call*validation*module.***************************************         CFT014
      *****************************************************************         CFT014
     C*****              CALLB     'FTVICHCV'                                   CFT014
      *****************************************************************         CFT014
      ***INPUT*********************************************************         CFT014
      ***=====*********************************************************         CFT014
      *****************************************************************         CFT014
      ***Return*Code***************************************************         CFT014
     C*****              PARM                    RetCodeOut                     CFT014
      *****************************************************************         CFT014
      ***Incoming*Payments*Lvl*2*Scrn*2*details*from*incoming*transaction       CFT014
      ***-*screen*format***********************************************         CFT014
     C*****              PARM                    NwIP4ScnFmt                    CFT014
      *****************************************************************         CFT014
      ***Mode*=*'*FRONT'*(Front*Office*Transaction*Interface)**********         CFT014
      ***Mode*=*'******'*(Not*Front*Office*Transaction*Interface)******         CFT014
      ***Mode*=*'*RPR**'*(Repair*Function)*****************************         CFT014
      ***Mode*=*'*SIN**'*(Screen*Input*Function)***********************         CFT014
     C*****              PARM                    PMode                          CFT014
      *****************************************************************         CFT014
      ***Settlement*In*Currency*Indicator******************************         CFT014
     C*****              PARM                    PSetInCy                       CFT014
      *****************************************************************         CFT014
      ***Settlement*EMU*Transaction*Period*Start*Date******************         CFT014
     C*****              PARM                    PSetTPSD                       CFT014
      *****************************************************************         CFT014
      ***Payment*In*Currency*Indicator*********************************         CFT014
     C*****              PARM                    PPayInCy                       CFT014
      *****************************************************************         CFT014
      ***Payment*EMU*Transaction*Period*Start*Date*********************         CFT014
     C*****              PARM                    PPayTPSD                       CFT014
      *****************************************************************         CFT014
      ***Input*Charge*Currency*****************************************         CFT014
     C*****              PARM                    PICCY                          CFT014
      *****************************************************************         CFT014
      ***Input*Charge*Currency*No.*of*Decimal*Places*******************         CFT014
     C*****              PARM                    PINBDP                         CFT014
      *****************************************************************         CFT014
      ***STANDING*DATA*************************************************         CFT014
      ***=============*************************************************         CFT014
      *****************************************************************         CFT014
      ***SDGELR*-*Currency*Code*for*Euro*******************************         CFT014
     C*****              PARM                    BKEURO                         CFT014
      *****************************************************************         CFT014
      ***VAT*Default*Flag**********************************************         CFT014
     C*****              PARM                    PVATT                          CFT014
      *****************************************************************         CFT014
      ***VAT*Rate******************************************************         CFT014
     C*****              PARM                    PVATR                          CFT014
      *****************************************************************         CFT014
      ***SWITCHABLE*FEATURES*******************************************         CFT014
      ***===================*******************************************         CFT014
      *****************************************************************         CFT014
      ***BLI*FT*Enhancements*Feature***********************************         CFT014
     C*****              PARM                    S01494                         CFT014
      *****************************************************************         CFT014
      ***BLI*VAT*Processing*Feature************************************         CFT014
     C*****              PARM                    S01499                         CFT014
      *****************************************************************         CFT014
      ***EMU*FT*Settlement*Currency*Conversion*************************         CFT014
     C*****              PARM                    CEU006                         CFT014
      *****************************************************************         CFT014
      ***OUTPUT********************************************************         CFT014
      ***======********************************************************         CFT014
      *****************************************************************         CFT014
      ***Error*fields/message*IDs/message*data*(arrays)*from/to*caller*         CFT014
     C*****              Parm                    FldNamXAr                      CFT014
     C*****              PARM                    MsgIDXAr                       CFT014
     C*****              PARM                    MsgDtaXAr                      CFT014
      *****************************************************************         CFT014
      ***Incoming*Payments*Lvl*2*Scrn*2*error*indicators***************         CFT014
     C*****              PARM                    FTEIPY3                        CFT014
      *****************************************************************         CFT014
      ***Incoming*Payments*for*file*update*-*file*format***************         CFT014
     C*****              PARM                    NwIPFilFmt                     CFT014
      *****************************************************************         CFT014
      ***Value*Dates***************************************************         CFT014
     C*****              PARM                    PVDates           5 0          CFT014
      *****************************************************************         CFT014
      ***Update*error*information.*************************************         CFT014
      *****************************************************************         CFT014
     C*****              IF        RetCodeOut <> *BLANKS                        CFT014
     C*****              EXSR      SRUpdatErrs                                  CFT014
     C*****              ENDIF                                                  CFT014
      *****************************************************************         CFT014
     C*****              ENDSR                                                  CFT014
      *****************************************************************         CFT014
      *****************************************************************
      /EJECT
      *****************************************************************
      *****************************************************************         CFT014
      ***SRTOTC*-*Total*Charges*Validation*****************************         CFT014
      *****************************************************************         CFT014
      *****************************************************************
      *****************************************************************         CFT014
     C*****SRTOTC        BEGSR                                                  CFT014
      *****************************************************************         CFT014
      ***Reset*fields.*************************************************         CFT014
      *****************************************************************         CFT014
     C*****              EXSR      SRResetErrs                                  CFT014
      *****************************************************************         CFT014
      ***Call validation module.                                                CFT014
      *****************************************************************         CFT014
     C*****              CALLB     'FTVITCHG'                                   CFT014
      ******************************========***************************         CFT014
      ***INPUT*********************************************************         CFT014
      ***=====*********************************************************         CFT014
      *****************************************************************         CFT014
      ***Return*Code***************************************************         CFT014
     C*****              PARM                    RetCodeOut                     CFT014
      *****************************************************************         CFT014
      ***Incoming*Payments*Lvl*2*Scrn*2*details*from*incoming*transaction       CFT014
      ***-*screen*format***********************************************         CFT014
     C*****              PARM                    NwIP4ScnFmt                    CFT014
      *****************************************************************         CFT014
      ***Mode*=*'*FRONT'*(Front*Office*Transaction*Interface)**********         CFT014
      ***Mode*=*'******'*(Not*Front*Office*Transaction*Interface)******         CFT014
      ***Mode*=*'*RPR**'*(Repair*Function)*****************************         CFT014
      ***Mode*=*'*SIN**'*(Screen*Input*Function)***********************         CFT014
     C*****              PARM                    PMode                          CFT014
      *****************************************************************         CFT014
      ***Input*Charge*Currency*****************************************         CFT014
     C*****              PARM                    PICCY                          CFT014
      *****************************************************************         CFT014
      ***Output*Charge*Currency****************************************         CFT014
     C*****              PARM                    POCCY                          CFT014
      *****************************************************************         CFT014
      ***Value*Dates***************************************************         CFT014
     C*****              PARM                    PVDates                        CFT014
      *****************************************************************         CFT014
      ***Output*Charge*Currency*No.*of*Decimal*Places******************         CFT014
     C*****              PARM                    PONBDP                         CFT014
      *****************************************************************         CFT014
      ***Input*Charge*Currency*No.*of*Decimal*Places*******************         CFT014
     C*****              PARM                    PINBDP                         CFT014
      *****************************************************************         CFT014
      ***SWITCHABLE*FEATURES*******************************************         CFT014
      ***===================*******************************************         CFT014
      *****************************************************************         CFT014
      ***EMU*FT*Settlement*Currency*Conversion*************************         CFT014
     C*****              PARM                    CEU006                         CFT014
      *****************************************************************         CFT014
      ***BLI*FT*Enhancements*Feature***********************************         CFT014
     C*****              PARM                    S01494                         CFT014
      *****************************************************************         CFT014
      ***BLI*VAT*Processing*Feature************************************         CFT014
     C*****              PARM                    S01499                         CFT014
      *****************************************************************         CFT014
      ***OUTPUT********************************************************         CFT014
      ***======********************************************************         CFT014
      *****************************************************************         CFT014
      ***Error*fields/message*IDs/message*data*(arrays)*from/to*caller*         CFT014
     C*****              Parm                    FldNamXAr                      CFT014
     C*****              PARM                    MsgIDXAr                       CFT014
     C*****              PARM                    MsgDtaXAr                      CFT014
      *****************************************************************         CFT014
      ***Incoming*Payments*Lvl*2*Scrn*2*error*indicators***************         CFT014
     C*****              PARM                    FTEIPY3                        CFT014
      *****************************************************************         CFT014
      ***Incoming*Payments*for*file*update*-*file*format***************         CFT014
     C*****              PARM                    NwIPFilFmt                     CFT014
      *****************************************************************         CFT014
      ***Charges*Amount************************************************         CFT014
     C*****              PARM                    PCharges                       CFT014
      *****************************************************************         CFT014
      ***Update*error*information.*************************************         CFT014
      *****************************************************************         CFT014
     C*****              IF        RetCodeOut <> *BLANKS                        CFT014
     C*****              EXSR      SRUpdatErrs                                  CFT014
     C*****              ENDIF                                                  CFT014
      *****************************************************************         CFT014
     C*****              ENDSR                                                  CFT014
      *****************************************************************         CFT014
      *****************************************************************
      /EJECT
      *****************************************************************
      *****************************************************************         CFT014
      ***SRMINF*-*Margin*Information*Validation************************         CFT014
      *****************************************************************         CFT014
      *****************************************************************
      *****************************************************************         CFT014
     C*****SRMINF        BEGSR                                                  CFT014
      *****************************************************************         CFT014
      ***Reset*fields.*************************************************         CFT014
      *****************************************************************         CFT014
     C*****              EXSR      SRResetErrs                                  CFT014
      *****************************************************************         CFT014
      ***Call*validation*module.***************************************         CFT014
      *****************************************************************         CFT014
     C*****              CALLB     'FTVIMGNI'                                   CFT014
      *****************************************************************         CFT014
      ***INPUT*********************************************************         CFT014
      ***=====*********************************************************         CFT014
      *****************************************************************         CFT014
      ***Return*Code***************************************************         CFT014
     C*****              PARM                    RetCodeOut                     CFT014
      *****************************************************************         CFT014
      ***Incoming*Payments*Lvl*1*Scrn*details*from*incoming*transaction         CFT014
      ***-*screen*format***********************************************         CFT014
     C*****              PARM                    NwIP1ScnFmt                    CFT014
      *****************************************************************         CFT014
      ***Incoming*Payments*Lvl*2*Scrn*2*details*from*incoming*transaction       CFT014
      ***-*screen*format***********************************************         CFT014
     C*****              PARM                    NwIP4ScnFmt                    CFT014
      *****************************************************************         CFT014
      ***Mode*=*'*FRONT'*(Front*Office*Transaction*Interface)**********         CFT014
      ***Mode*=*'******'*(Not*Front*Office*Transaction*Interface)******         CFT014
      ***Mode*=*'*RPR**'*(Repair*Function)*****************************         CFT014
      ***Mode*=*'*SIN**'*(Screen*Input*Function)***********************         CFT014
     C*****              PARM                    PMode                          CFT014
      *****************************************************************         CFT014
      ***OUTPUT********************************************************         CFT014
      ***======********************************************************         CFT014
      *****************************************************************         CFT014
      ***Error*fields/message*IDs/message*data*(arrays)*from/to*caller*         CFT014
     C*****              Parm                    FldNamXAr                      CFT014
     C*****              PARM                    MsgIDXAr                       CFT014
     C*****              PARM                    MsgDtaXAr                      CFT014
      *****************************************************************         CFT014
      ***Incoming*Payments*Lvl*2*Scrn*2*error*indicators***************         CFT014
     C*****              PARM                    FTEIPY3                        CFT014
      *****************************************************************         CFT014
      ***Incoming*Payments*for*file*update*-*file*format***************         CFT014
     C*****              PARM                    NwIPFilFmt                     CFT014
      *****************************************************************         CFT014
      ***Update*error*information.*************************************         CFT014
      *****************************************************************         CFT014
     C*****              IF        RetCodeOut <> *BLANKS                        CFT014
     C*****              EXSR      SRUpdatErrs                                  CFT014
     C*****              ENDIF                                                  CFT014
      *****************************************************************         CFT014
     C*****              ENDSR                                                  CFT014
      *****************************************************************         CFT014
      *****************************************************************
      /EJECT                                                                    CFT014
      *****************************************************************         CFT014
      *                                                               *         CFT014
      *  SRBOCD - Bank Operation Code validation                      *         CFT014
      *                                                               *         CFT014
      *****************************************************************         CFT014
      *                                                                         CFT014
     C     SRBOCD        BEGSR                                                  CFT014
      *                                                                         CFT014
      ** Reset fields.                                                          CFT014
      *                                                                         CFT014
     C                   EXSR      SRResetErrs                                  CFT014
      *                                                                         CFT014
      ** Call validation module                                                 CFT014
      *                                                                         CFT014
     C                   CALLB     'FTVIBOCD'                                   CFT014
      ** O: Return Code                                                         CFT014
     C                   PARM                    RetCodeOut                     CFT014
      ** I: Incoming Payments Lvl 2 Scrn 2 details from IP transaction          CFT014
     C                   PARM                    NwIP4ScnFmt                    CFT014
      ************                                                              CFT014
      ** OUTPUT **                                                              CFT014
      ************                                                              CFT014
      ** Incoming Payments Valid extension file                                 CFT014
     C                   PARM                    NwIP2FilFmt                    CFT014
      ** Incoming Payments Lvl 2 Scrn 2 error indicators                        CFT014
     C                   PARM                    FTEIPY3                        CFT014
      ** Error fields/message IDs/message data (arrays) from/to caller          CFT014
     C                   PARM                    FldNamXAr                      CFT014
     C                   PARM                    MsgIDXAr                       CFT014
     C                   PARM                    MsgDtaXAr                      CFT014
      *                                                                         CFT014
      ** Update error information.                                              CFT014
      *                                                                         CFT014
     C                   IF        RetCodeOut <> *BLANKS                        CFT014
     C                   EXSR      SRUpdatErrs                                  CFT014
     C                   ENDIF                                                  CFT014
      *                                                                         CFT014
     C                   ENDSR                                                  CFT014
      *                                                                         CFT014
      *****************************************************************         CFT014
      /EJECT                                                                    CFT014
      *****************************************************************         CFT014
      *                                                               *         CFT014
      *  SRTTCD - Transaction Type Code validation                    *         CFT014
      *                                                               *         CFT014
      *****************************************************************         CFT014
      *                                                                         CFT014
     C     SRTTCD        BEGSR                                                  CFT014
      *                                                                         CFT014
      ** Reset fields.                                                          CFT014
      *                                                                         CFT014
     C                   EXSR      SRResetErrs                                  CFT014
      *                                                                         CFT014
      ** Call validation module                                                 CFT014
      *                                                                         CFT014
     C                   CALLB     'FTVITTCD'                                   CFT014
      *                                                                         CFT014
      ** O: Return Code                                                         CFT014
     C                   PARM                    RetCodeOut                     CFT014
      ** I: Incoming Payments Lvl 2 Scrn 2 details from IP transaction          CFT014
     C                   PARM                    NwIP4ScnFmt                    CFT014
      ************                                                              CFT014
      ** OUTPUT **                                                              CFT014
      ************                                                              CFT014
      ** Incoming Payments Valid extension file                                 CFT014
     C                   PARM                    NwIP2FilFmt                    CFT014
      ** Incoming Payments Lvl 2 Scrn 2 error indicators                        CFT014
     C                   PARM                    FTEIPY3                        CFT014
      ** Error fields/message IDs/message data (arrays) from/to caller          CFT014
     C                   PARM                    FldNamXAr                      CFT014
     C                   PARM                    MsgIDXAr                       CFT014
     C                   PARM                    MsgDtaXAr                      CFT014
      *                                                                         CFT014
      ** Update error information.                                              CFT014
      *                                                                         CFT014
     C                   IF        RetCodeOut <> *BLANKS                        CFT014
     C                   EXSR      SRUpdatErrs                                  CFT014
     C                   ENDIF                                                  CFT014
      *                                                                         CFT014
     C                   ENDSR                                                  CFT014
      *                                                                         CFT014
      *****************************************************************         CFT014
      /EJECT                                                                    CFT014
      *****************************************************************         CFT014
      *                                                               *         CFT014
      *  SRICDE - Instruction Code validation                         *         CFT014
      *                                                               *         CFT014
      *****************************************************************         CFT014
      *                                                                         CFT014
     C     SRICDE        BEGSR                                                  CFT014
      *                                                                         CFT014
      ** Reset fields.                                                          CFT014
      *                                                                         CFT014
     C                   EXSR      SRResetErrs                                  CFT014
      *                                                                         CFT014
      ** Call validation module                                                 CFT014
      *                                                                         CFT014
     C                   CALLB     'FTVIICDE'                                   CFT014
      *                                                                         CFT014
      ** O: Return Code                                                         CFT014
     C                   PARM                    RetCodeOut                     CFT014
      ** I: Incoming Payments Lvl 2 Scrn 2 details                              CFT014
     C                   PARM                    NwIP4ScnFmt                    CFT014
      ** I: Incoming Payments Lvl 2 Scrn 2 file 2 details                       CFT014
     C                   PARM                    NwIP4AScnFmt                   CFT014
      ** SWIFT 2001 enhancement flag CSW201                                                   CSW201
     C                   PARM                    CSW201                                       CSW201
      ** Intermediary Bank file field                                                         CSW201
     C                   PARM                    IPACBK                                       CSW201
      ************                                                              CFT014
      ** OUTPUT **                                                              CFT014
      ************                                                              CFT014
      ** Incoming Payments Valid extension file                                 CFT014
     C                   PARM                    NwIP2FilFmt                    CFT014
      ** Incoming Payments Lvl 2 Scrn 2 Error indicators                        CFT014
     C                   PARM                    FTEIPY3                        CFT014
      ** Error fields/message IDs/message data (arrays) from/to caller          CFT014
     C                   PARM                    FldNamXAr                      CFT014
     C                   PARM                    MsgIDXAr                       CFT014
     C                   PARM                    MsgDtaXAr                      CFT014
      *                                                                         CFT014
      ** Update error information.                                              CFT014
      *                                                                         CFT014
     C                   IF        RetCodeOut <> *BLANKS                        CFT014
     C                   EXSR      SRUpdatErrs                                  CFT014
     C                   ENDIF                                                  CFT014
      *                                                                         CFT014
     C                   ENDSR                                                  CFT014
      *                                                                         CFT014
      *****************************************************************         CFT014
      /EJECT                                                                    CFT014
      *****************************************************************         CFT014
      *                                                               *         CFT014
      *  SRRRPT - Regulatory Reporting validation                     *         CFT014
      *                                                               *         CFT014
      *****************************************************************         CFT014
      *                                                                         CFT014
     C     SRRRPT        BEGSR                                                  CFT014
      *                                                                         CFT014
      ** Reset fields.                                                          CFT014
      *                                                                         CFT014
     C                   EXSR      SRResetErrs                                  CFT014
      *                                                                         CFT014
      ** Call validation module                                                 CFT014
      *                                                                         CFT014
     C                   CALLB     'FTVIRRPT'                                   CFT014
      *                                                                         CFT014
      ** O: Return Code                                                         CFT014
     C                   PARM                    RetCodeOut                     CFT014
      ** I: Incoming Payments Lvl 2 Scrn 2 File details                         CFT014
     C                   PARM                    NwIP4AScnFmt                   CFT014
      ************                                                              CFT014
      ** OUTPUT **                                                              CFT014
      ************                                                              CFT014
      ** Incoming Payments Valid extension file                                 CFT014
     C                   PARM                    NwIP2FilFmt                    CFT014
      ** Incoming Payments Lvl 2 Scrn 2 error indicators                        CFT014
     C                   PARM                    FTEIPY3                        CFT014
      ** Error fields/message IDs/message data (arrays) from/to caller          CFT014
     C                   PARM                    FldNamXAr                      CFT014
     C                   PARM                    MsgIDXAr                       CFT014
     C                   PARM                    MsgDtaXAr                      CFT014
      *                                                                         CFT014
      ** Update error information.                                              CFT014
      *                                                                         CFT014
     C                   IF        RetCodeOut <> *BLANKS                        CFT014
     C                   EXSR      SRUpdatErrs                                  CFT014
     C                   ENDIF                                                  CFT014
      *                                                                         CFT014
     C                   ENDSR                                                  CFT014
      *                                                                         CFT014
      *****************************************************************         CFT014
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRESETERRS - Routine to reset Error Information that is     *
      *                received from each validation module           *
      *                                                               *
      *****************************************************************
      *
     C     SRResetErrs   BEGSR
      *
     C                   EVAL      RetCodeOut = *BLANKS
      *
      ** Reset error and warning fields/message IDs/message
      ** data (arrays).
      *
     C                   EVAL      FldNamXAr = *BLANKS
     C                   EVAL      MsgIDXAr  = *BLANKS
     C                   EVAL      MsgDtaXAr = *BLANKS
      *
     C                   EVAL      WFldNmXAr = *BLANKS
     C                   EVAL      WMsgIDXAr = *BLANKS
     C                   EVAL      WMsgDtXAr = *BLANKS
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRUPDATERRS - Routine to update Error Information with that  *
      *                received back from each validation module      *
      *                                                               *
      *****************************************************************
      *
     C     SRUpdatErrs   BEGSR
      *
      ** Update error fields/message IDs/message data (arrays).
      *
     C                   EVAL      Ix = 1
     C     *BLANK        LOOKUP    FldNameArr(Ix)                         99
     C                   IF        *IN99 = *On
     C                   MOVEA     FldNamXar     FldNameArr(Ix)
     C                   MOVEA     MsgIDXAr      MsgIdArr(Ix)
     C                   MOVEA     MsgDtaXAr     MsgDtaArr(Ix)
     C                   ENDIF
      *
      ** Set Error Index.
      *
     C                   EVAL      Ix = 1
     C     *BLANK        LOOKUP    FLDNAMEARR(Ix)                         99
     C     *IN99         IFEQ      '1'
     C     Ix            SUB       1             IDX
     C                   ELSE
     C                   EVAL      Ix = ArrayMax
     C                   MOVE      *BLANKS       FLDNAMEARR(Ix)
     C                   MOVE      *BLANKS       MSGIDARR(Ix)
     C                   MOVE      *BLANKS       MSGDTAARR(Ix)
     C                   Eval      IDX = ArrayMax - 1
     C                   ENDIF
      *
      ** Update warning fields/message IDs/message data (arrays).
      *
     C                   EVAL      Ix = 1
     C     *BLANK        LOOKUP    WFldNamArr(Ix)                         99
     C                   IF        *IN99 = *On
     C                   MOVEA     WFldNmXAr     WFldNamArr(Ix)
     C                   MOVEA     WMsgIDXAr     WMsgIDArr(Ix)
     C                   MOVEA     WMsgDtXAr     WMsgDtaArr(Ix)
     C                   ENDIF
      *
      ** Set Warning Index.
      *
     C                   EVAL      Ix = 1
     C     *BLANK        LOOKUP    WFLDNAMARR(Ix)                         99
     C     *IN99         IFEQ      '1'
     C     Ix            SUB       1             WIDX
     C                   ELSE
     C                   EVAL      Ix = ArrayMax
     C                   MOVE      *BLANKS       WFLDNAMARR(Ix)
     C                   MOVE      *BLANKS       WMSGIDARR(Ix)
     C                   MOVE      *BLANKS       WMSGDTAARR(Ix)
     C                   Eval      WIDX = ArrayMax - 1
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation                              *
      *         - This subroutine runs automatically for program      *
      *           initialisation.                                     *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
      *
      ** INPUT
      ** =====
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair Function)
      ** Mode = '*SIN  ' (Screen Input Function)
     C                   PARM                    PMode             6
      *
      ** Response Mode
     C                   PARM                    PResponse
      *
      ***Incoming*Payments*Lvl*1*Scrn*details*from*incoming*transaction         CFT014
      ***-*screen*format***********************************************         CFT014
     C*****              PARM                    NwIP1ScnFmt                    CFT014
      *
      ** Incoming Payments Lvl 2 Scrn 2 details from incoming transaction
      ** - screen format
     C                   PARM                    NwIP4ScnFmt
      *                                                                         CFT014
      ** Incoming Payments Lvl 2 Scrn 2 file 2 from incoming transaction        CFT014
      ** - screen format                                                        CFT014
     C                   PARM                    NwIP4AScnFmt                   CFT014
      *
      ** Settlement In Currency Indicator
     C                   PARM                    PSetInCy          1
      *
      ** Settlement EMU Transaction Period Start Date
     C                   PARM                    PSetTPSD          5 0
      *
      ** Payment In Currency Indicator
     C                   PARM                    PPayInCy          1
      *
      ** Payment EMU Transaction Period Start Date
     C                   PARM                    PPayTPSD          5 0
      *
      ** Input Charge Currency
     C                   PARM                    PICCY             3
      *
      ** Input Charge Currency No. of Decimal Places
     C                   PARM                    PINBDP            1 0
      *
      ** Output Charge Currency
     C                   PARM                    POCCY             3
      *
      ** Output Charge Currency No. of Decimal Places
     C                   PARM                    PONBDP            1 0
      *
      ** Incoming Payments extra data
     C                   PARM                    PExtData
      *                                                                         CFT014
      ** Charges Branch                                                         CFT014
     C                   PARM                    PPYBR             3            CFT014
      *
      ** STANDING DATA
      ** =============
      *
      ** SDGELR - Currency Code for Euro
     C                   PARM                    BKEURO            3
      *
      ** SDMMOD - Analytical Accounting
     C                   PARM                    BGN0ST            1
      *
      ** VAT Default Flag
     C                   PARM                    PVATT             1
      *
      ** VAT Rate
     C                   PARM                    PVATR             5 4
      *
      ** SWITCHABLE FEATURES
      ** ===================
      *
      ** EMU FT Settlement Currency Conversion
     C                   PARM                    CEU006            1
      *
      ** BLI FT Enhancements Feature
     C                   PARM                    S01494            1
      *
      ** BLI VAT Processing Feature
     C                   PARM                    S01499            1
      *                                                                         CFT014
      ** MT103 Messages Generation for FT                                       CFT014
     C                   PARM                    CFT014            1            CFT014
      *                                                                         CFT009
      ** Fees & Charges                                                         CFT009
     C                   PARM                    CFT009            1            CFT009
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ** Array index (3P0) from/to caller
     C                   PARM                    IDx
      *
      ** Warning flds/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
      ** Array index (3P0) from/to caller
     C                   PARM                    WIDx
      *
      ** Incoming Payments Lvl 2 Scrn 2 error indicators
     C                   PARM                    FTEIPY3
      *
      ** Incoming Payments for file update - file format
     C                   PARM                    NwIPFilFmt
      *                                                                         CFT014
      ** Incoming Payments (additional details) for file update                 CFT014
     C                   PARM                    NwIP2FilFmt                    CFT014
      ***********                                                               CFT014
      ***DS*for*Default*Charge*Amounts*********************************         CFT014
     C***********        PARM                    PCharges        108            CFT014
      *                                                                                       CSW201
      ** Check if enhancement CSW201 is on                                                    CSW201
      *                                                                                       CSW201
     C                   CALL      'SWIF2001'                           99                    CSW201
     C                   PARM      *BLANKS       @RTCD                                        CSW201
      *                                                                                       CSW201
     C                   IF        *IN99 = *ON                                                CSW201
     C                   EVAL      DBPGM = 'FTIPAY3VL'                                        CSW201
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSW201
     C                   EVAL      DBKEY = 'CSW201'                                           CSW201
     C                   EVAL      DBASE = 001                                                CSW201
     C                   EXSR      *PSSR                                                      CSW201
     C                   ENDIF                                                                CSW201
      *                                                                                       CSW201
     C                   IF        @RTCD = 'CSW2001'                                          CSW201
     C                   EVAL      CSW201 = 'Y'                                               CSW201
     C                   ELSE                                                                 CSW201
     C                   EVAL      CSW201 = 'N'                                               CSW201
     C                   ENDIF                                                                CSW201
      *
      ** Program, module and procedure names for dbase error processing
      ** ==============================================================
      ** The following /COPY sets these values.
      *
      /COPY ZACPYSRC,DBFIELDS
      *
      ** Hook to enable non-core initial processing to be included
      *
      /COPY WNCPYSRC,FTIPY3V037
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
      *
      /COPY ZACPYSRC,PSSR_ILE
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
