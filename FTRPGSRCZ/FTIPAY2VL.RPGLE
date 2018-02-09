     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Incoming payments validation controller 2')   *
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FTIPAY2VL - Incoming Payments Validation Controller 2        *
      *                                                               *
      *  Function: This module validates Incoming Payments Level 2    *
      *            screen 1 fields for input into the Midas           *
      *            database.                                          *
      *                                                               *
      *  Component of: FTIPAYSIN                                      *
      *                FTIPAYCTL                                      *
      *                FTIPAYRPR                                      *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CFT120             Date 28Sep12               *
      *                 CSF011A            Date 28Nov11               *
      *                 CER059             Date 19Jul10               *
      *                 CER030             Date 09Jul08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 250600             Date 30Sep07               *
      *                 CSW207A            Date 06Aug07               *
      *                 248080             Date 06Jun07               *
      *                 CFT032             Date 11Sep06               *
      *                 CDL049             Date 06Jul06               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CFT009             Date 13Jan01               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CFT014             Date 25May00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CAP136  *CREATE    Date 15Nov99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CFT120 - FT IN/OP - Charges to DR of Account Currency        *
      *           (Recompile)                                         *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER030 - Multicash German Feature (Recompile)                *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  250600 - Fix to CFT032                                       *
      *  CSW207A - Swift 2007 Standard Changes                        *
      *  248080 - Applied fix 240225.                                 *
      *  240225 - Allow warning messages for FTVISCOR & FTVIORCS      *
      *  CFT032 - Account Line in Field 50X in MT103                  *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CFT009 - Funds Transfer Fees and Charges (recompile)         *
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
      /COPY WNCPYSRC,FTIPY2V001
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
      ** Incoming Payments Lvl 2 Scrn 1/1 details from incoming transaction
      ** - screen format
     D NwIP2ScnFmt   E DS                  EXTNAME(FTIPY2PD)
      *
      ** Incoming Payments Lvl 2 Scrn 1/2 details from incoming transaction
      ** - screen format
     D NwIP3ScnFmt   E DS                  EXTNAME(FTIPY3PD)
      *                                                                         CFT014
      ** Incoming Payments Lvl 1 Scrn format definition file 2                  CFT014
     D NwIP1AScnFmt  E DS                  EXTNAME(FTIPY1APD)                   CFT014
      *
      ** Incoming Payments extra data
     D PExtData      E DS                  EXTNAME(FTIPEXPD)
      *
      ** Incoming Payments Lvl 2 Scrn error indicators
     D FTEIPY2       E DS                  EXTNAME(FTEIPY2PD)
      *
      ** Incoming Payments for file update - file format
     D NwIPFilFmt    E DS                  EXTNAME(FTVIPAYPD)
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Index for arrays of error message ids, etc.
     D Idx             S              3P 0
      *
      ** Index for arrays of warning error message ids, etc.
     D WIDx            S              3P 0
      *
      ** Index for update of error arrays
     D Ix              S              3  0
      *
      ** Response Mode
     D PResponse       S              1A
      *
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      *
      /COPY WNCPYSRC,FTIPY2V002
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
      /COPY WNCPYSRC,FTIPY2V003
      *
      ** Transfer Commision Tariff Validation.
      *
      /COPY WNCPYSRC,FTIPY2V004
      *
      ** Remove Transfer Commission Tariff from this module                     CFT014
     C*****              EXSR      SRTRCT                                       CFT014
      *
      /COPY WNCPYSRC,FTIPY2V005
      *
      ** Charges to the Debit of A/c Validation.
      *
      /COPY WNCPYSRC,FTIPY2V006
      *
      ** Remove Charges to the Debit of A/C from this module                    CFT014
     C*****              EXSR      SRCDRO                                       CFT014
      *
      /COPY WNCPYSRC,FTIPY2V007
      *
      ** Ordering Customer Validation.
      *
      /COPY WNCPYSRC,FTIPY2V008
      *
     C                   EXSR      SRORCU
      *
      /COPY WNCPYSRC,FTIPY2V009
      *
      ** Ordering Bank Validation.
      *
      /COPY WNCPYSRC,FTIPY2V010
      *
     C                   EXSR      SRORBK
      *
      /COPY WNCPYSRC,FTIPY2V011
      *
      ** Sender's Correspondent Validation.
      *
      /COPY WNCPYSRC,FTIPY2V012
      *
     C                   EXSR      SRSNDC
      *
      /COPY WNCPYSRC,FTIPY2V013
      *
      ** Bank to Bank Information Validation.
      *
      /COPY WNCPYSRC,FTIPY2V014
      *
     C                   EXSR      SRBTOB
      *
      /COPY WNCPYSRC,FTIPY2V015
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** Hook to enable non-core subroutines to be included
      *
      /COPY WNCPYSRC,FTIPY2V016
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *****************************************************************         CFT014
      ***SRTRCT*-*Transfer*Commision*Tariff*Validation*****************         CFT014
      *****************************************************************         CFT014
      *****************************************************************
      *****************************************************************         CFT014
     C*****SRTRCT        BEGSR                                                  CFT014
      *****************************************************************         CFT014
      ***Reset*fields.*************************************************         CFT014
      *****************************************************************         CFT014
     C*****              EXSR      SRResetErrs                                  CFT014
      *****************************************************************         CFT014
      ***Call*validation*module.***************************************         CFT014
      *****************************************************************         CFT014
     C*****              CALLB     'FTVITRCT'                                   CFT014
      ******************************========***************************         CFT014
      ***INPUT*********************************************************         CFT014
      ***=====*********************************************************         CFT014
      *****************************************************************         CFT014
      ***Return*Code***************************************************         CFT014
     C*****              PARM                    RetCodeOut                     CFT014
      *****************************************************************         CFT014
      ***Incoming*Payments*Lvl*2*Scrn*1/2 details*from*incoming*transaction     CFT014
      ***-*screen format***********************************************         CFT014
     C*****              PARM                    NwIP3ScnFmt                    CFT014
      *****************************************************************         CFT014
      ***Charges*Branch************************************************         CFT014
     C*****              PARM                    PPYBR                          CFT014
      *****************************************************************         CFT014
      ***OUTPUT********************************************************         CFT014
      ***======********************************************************         CFT014
      *****************************************************************         CFT014
      ***Error*fields/message*IDs/message*data*(arrays)*from/to*caller*         CFT014
     C*****              Parm                    FldNamXAr                      CFT014
     C*****              PARM                    MsgIDXAr                       CFT014
     C*****              PARM                    MsgDtaXAr                      CFT014
      ****************************************************************          CFT014
      ***Incoming*Payments*Lvl*2*Scrn*1*error*indicators**************          CFT014
     C*****              PARM                    FTEIPY2                        CFT014
      ****************************************************************          CFT014
      ***Incoming*Payments*for*file*update*-*file*format**************          CFT014
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
      ***SRCDRO*-*Charges*to*the*Debit*of*A/c*Validation***************         CFT014
      *****************************************************************         CFT014
      *****************************************************************
      *****************************************************************         CFT014
     C*****SRCDRO        BEGSR                                                  CFT014
      *****************************************************************         CFT014
      ***Reset*fields.*************************************************         CFT014
      *****************************************************************         CFT014
     C*****              EXSR      SRResetErrs                                  CFT014
      *****************************************************************         CFT014
      ***Call*validation*module.***************************************         CFT014
      *****************************************************************         CFT014
     C*****              CALLB     'FTVICDRO'                                   CFT014
      ******************************========***************************         CFT014
      ***INPUT*********************************************************         CFT014
      ***=====*********************************************************         CFT014
      *****************************************************************         CFT014
      ***Return*Code***************************************************         CFT014
     C*****              PARM                    RetCodeOut                     CFT014
      *****************************************************************         CFT014
      ***Incoming*Payments*Lvl*2*Scrn*1/2*details*from*incoming*transaction     CFT014
      ***-*screen*format***********************************************         CFT014
     C*****              PARM                    NwIP3ScnFmt                    CFT014
      *****************************************************************         CFT014
      ***STANDING*DATA*************************************************         CFT014
      ***=============*************************************************         CFT014
      *****************************************************************         CFT014
      ***SDBANK*-*Base*Currency*Code***********************************         CFT014
     C*****              PARM                    BJCYCD                         CFT014
      *****************************************************************         CFT014
      ***SDBANK*-*Midas*Run*Date***************************************         CFT014
     C*****              PARM                    BJRDNB                         CFT014
      *****************************************************************         CFT014
      ***SDBANK*-*Back*Value*Period*in*Days****************************         CFT014
     C*****              PARM                    BJBVPD                         CFT014
      *****************************************************************         CFT014
      ***SDBANK*-*Single*Branch*Code***********************************         CFT014
     C*****              PARM                    BJSBRC                         CFT014
      *****************************************************************         CFT014
      ***SDMMOD*-*Multibranch*Indicator********************************         CFT014
     C*****              PARM                    BGMBIN                         CFT014
      *****************************************************************         CFT014
      ***SDMMOD*-*Retail*Banking***************************************         CFT014
     C*****              PARM                    BGRTBN                         CFT014
      *****************************************************************         CFT014
      ***SDRETL*-*Retail*A/c*Number*Required?**************************         CFT014
     C*****              PARM                    BMRANR                         CFT014
      *****************************************************************         CFT014
      ***OUTPUT********************************************************         CFT014
      ***======********************************************************         CFT014
      *****************************************************************         CFT014
      ***Error*fields/message*IDs/message*data*(arrays)*from/to caller*         CFT014
     C*****              Parm                    FldNamXAr                      CFT014
     C*****              PARM                    MsgIDXAr                       CFT014
     C*****              PARM                    MsgDtaXAr                      CFT014
      *****************************************************************         CFT014
      ***Incoming*Payments*Lvl*2*Scrn*1*error*indicators***************         CFT014
     C*****              PARM                    FTEIPY2                        CFT014
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
      *                                                               *
      *  SRORCU - Ordering Customer Validation                        *
      *                                                               *
      *****************************************************************
      *
     C     SRORCU        BEGSR
      *
      ** Reset fields.
      *
     C                   EXSR      SRResetErrs
      *
      ** Call validation module.
      *
     C                   CALLB     'FTVIORCS'
      *                             ========
      ** INPUT
      ** =====
      *
      ** Return Code
     C                   PARM                    RetCodeOut
      *
      ** Incoming Payments Lvl 2 Scrn 1/1 details from incoming transaction
      ** - screen format
     C                   PARM                    NwIP2ScnFmt
     C                   PARM                    NwIP3ScnFmt                                  CFT032
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair Function)
      ** Mode = '*SIN  ' (Screen Input Function)
     C                   PARM                    PMode
      *
      ** Message Type
     C                   PARM                    IPINMTPY
      *                                                                                       250600
      ** Debit Account                                                                        250600
     C                   PARM                    PDBACT           24                          250600
      *                                                                                       250600
      ** Credit Account                                                                       250600
     C                   PARM                    PCDACT           24                          250600
      *                                                                                       250600
      ** Network                                                                              250600
     C                   PARM                    PNWRK             6                          250600
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Warning fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr
      *
      ** Incoming Payments Lvl 2 Scrn 1 error indicators
     C                   PARM                    FTEIPY2
      *
      ** Incoming Payments for file update - file format
     C                   PARM                    NwIPFilFmt
      *
      ** Update error information.
      *
     C************       IF        RetCodeOut <> *BLANKS                                      240225
     C                   EXSR      SRUpdatErrs
     C************       ENDIF                                                                240225
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRORBK - Ordering Bank Validation                            *
      *                                                               *
      *****************************************************************
      *
     C     SRORBK        BEGSR
      *
      ** Reset fields.
      *
     C                   EXSR      SRResetErrs
      *
      ** Call validation module.
      *
     C                   CALLB     'FTVIORBK'
      *                             ========
      ** INPUT
      ** =====
      *
      ** Return Code
     C                   PARM                    RetCodeOut
      *
      ** Incoming Payments Lvl 2 Scrn 1/1 details from incoming transaction
      ** - screen format
     C                   PARM                    NwIP2ScnFmt
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Warning fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr
      *
      ** Incoming Payments Lvl 2 Scrn 1 error indicators
     C                   PARM                    FTEIPY2
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
      *  SRSNDC - Sender's Correspondent Validation                   *
      *                                                               *
      *****************************************************************
      *
     C     SRSNDC        BEGSR
      *
      ** Reset fields.
      *
     C                   EXSR      SRResetErrs
      *
      ** Call validation module.
      *
     C                   CALLB     'FTVISCOR'
      *                             ========
      ** INPUT
      ** =====
      *
      ** Return Code
     C                   PARM                    RetCodeOut
      *
      ** Incoming Payments Lvl 2 Scrn 1/1 details from incoming transaction
      ** - screen format
     C                   PARM                    NwIP2ScnFmt
      *                                                                         CFT014
      ** Third Reimbursement Institution from screen 1                          CFT014
     C                   PARM                    DDTRIB                         CFT014
      *                                                                         CFT014
      ** MT103 Messages Generation for FT                                       CFT014
     C                   PARM                    CFT014                         CFT014
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Warning fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr
      *
      ** Incoming Payments Lvl 2 Scrn 1 error indicators
     C                   PARM                    FTEIPY2
      *
      ** Incoming Payments for file update - file format
     C                   PARM                    NwIPFilFmt
      *
      ** Update error information.
      *
     C***********        IF        RetCodeOut <> *BLANKS                                      240225
     C                   EXSR      SRUpdatErrs
     C***********        ENDIF                                                                240225
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRBTOB - Bank to Bank Information Validation                 *
      *                                                               *
      *****************************************************************
      *
     C     SRBTOB        BEGSR
      *
      ** Reset fields.
      *
     C                   EXSR      SRResetErrs
      *
      ** Call validation module.
      *
     C                   CALLB     'FTVIBTBI'
      *                             ========
      ** INPUT
      ** =====
      *
      ** Return Code
     C                   PARM                    RetCodeOut
      *
      ** Incoming Payments Lvl 2 Scrn 1/2 details from incoming transaction
      ** - screen format
     C                   PARM                    NwIP3ScnFmt
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Incoming Payments Lvl 2 Scrn 1 error indicators
     C                   PARM                    FTEIPY2
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
      *                                                                         CFT014
      ** Incoming Payments Lvl 1 Scrn format definition file 2                  CFT014
     C                   PARM                    NwIP1AScnFmt                   CFT014
      *
      ** Incoming Payments Lvl 2 Scrn 1/1 details from incoming transaction
      ** - screen format
     C                   PARM                    NwIP2ScnFmt
      *
      ** Incoming Payments Lvl 2 Scrn 1/2 details from incoming transaction
      ** - screen format
     C                   PARM                    NwIP3ScnFmt
      *
      ** Incoming Payments extra data
     C                   PARM                    PExtData
      *
      ** Charges Branch
     C                   PARM                    PPYBR             3
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - Base Currency Code
     C                   PARM                    BJCYCD            3
      *
      ** SDBANK - Midas Run Date
     C                   PARM                    BJRDNB            5 0
      *
      ** SDBANK - Back Value Period in Days
     C                   PARM                    BJBVPD            3 0
      *
      ** SDBANK - Single Branch Code
     C                   PARM                    BJSBRC            3
      *
      ** SDMMOD - Multibranch Indicator
     C                   PARM                    BGMBIN            1
      *
      ** SDMMOD - Retail Banking
     C                   PARM                    BGRTBN            1
      *
      ** SDRETL - Retail A/c Number Required?
     C                   PARM                    BMRANR            1
      *                                                                         CFT014
      ** MT103 Messages Generation for FT                                       CFT014
     C                   PARM                    CFT014            1            CFT014
      *                                                                                       250600
      ** Debit Account                                                                        250600
     C                   PARM                    PDBACT           24                          250600
      *                                                                                       250600
      ** Credit Account                                                                       250600
     C                   PARM                    PCDACT           24                          250600
      *                                                                                       250600
      ** Network                                                                              250600
     C                   PARM                    PNWRK             6                          250600
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
      ** Incoming Payments Lvl 2 Scrn 1 error indicators
     C                   PARM                    FTEIPY2
      *
      ** Incoming Payments for file update - file format
     C                   PARM                    NwIPFilFmt
      *
      ** Program, module and procedure names for dbase error processing
      ** ==============================================================
      ** The following /COPY sets these values.
      *
      /COPY ZACPYSRC,DBFIELDS
      *
      ** Hook to enable non-core initial processing to be included
      *
      /COPY WNCPYSRC,FTIPY2V017
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
(c) Finastra International Limited 2001
