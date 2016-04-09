     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Validate sending institution header')         *
      *****************************************************************
      *                                                               *
      *  Midas - Standard subprograms                                 *
      *                                                               *
      *  FTVSEIS02  - Validate Sending Institution Header             *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. CRE075             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *  Prev Amend No. CSW209             Date 01Apr09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 CSW207             Date 07Jun07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CLE025             Date 20Oct03               *
      *                 221760             Date 01Apr04               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CSW201             Date 02May01               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 185107             Date 17Oct00               *
      *                 184060             Date 22Sep00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 178185             Date 26Apr00               *
      *                 CFT008  *CREATE    Date 17Nov99               *
      *                                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  CSW209 - SWIFT 2009 Changes (Recompile)                      *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  CSW207 - Swift 2007 Changes (Recompiled)                     *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  221760 - Do not validate SWIFT ID if MEBICDPD is empty.      *
      *  CSW201 - SWIFT 2001 Standards Update                         *
      *  185107 - Mapping of details from swift message - Recompile   *
      *  184060 - No transaction type code in detail screen -Recompile*
      *  178185 - Default sending institution with sender for 'BI'    *
      *  CFT008 - Funds Transfer/Swift Messages MT102                 *
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
 
      ** Include the MM standard declares
     D/COPY ZACPYSRC,STDDECLARE
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
      ** Program, procedure and module names for parameters
      ** ==================================================
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_XARRYS
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
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      * Header record datastructure
     D HdrRcdIn      E DS                  EXTNAME(FT102HSPD)
     D DtlRcdIn      E DS                  EXTNAME(FT102DSPD) PREFIX(D)
 
      ** Midas Branch Details
     DSDBRCH         E DS                  EXTNAME(SDBRCHPD)
 
      *  External Data structure to hold the outgoing record format
     D ACCNT         E DS                  EXTNAME(ACCNTAB)
     D   ACBRCA      E                     EXTFLD(BRCA)
     D   ACPRFC      E                     EXTFLD(PRFC)
 
      ** External data structure for access programs (Long)
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D wvalid          S              1
     D wsvld           S              1
     D wrvld           S              1
     D CFT004          S              1
 
      * OK Flags for first screen - Header
     D OKFlagHs1     E DS                  EXTNAME(FTE102H1PD)
 
     D GenOkFlag2      S              1    Import
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
 
      ** Index for arrays of of warning message ids etc
     D WIdx            S              3P 0
 
      ** SWIFT 2001 switchable feature                                                        CSW201
     D CSW201          S              1A                                                      CSW201
                                                                                              CSW201
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
     C                   Eval      RetCodeIn  = *Blanks
     C                   Eval      Idx        = 0
     C                   Eval      WIdx       = 0
     C                   Eval      PTType = *Blanks
     C                   Eval      PType = *Blanks
     C                   Eval      GenOkFlag2 = 'Y'
     C                   Eval      wsvld = 'Y'
     C                   Eval      wrvld = 'Y'
     C                   Eval      wValid = 'Y'
     C                   Eval      PSinStt = *blanks
      *
      ** Mandatory
     C                   If        PSINST = *Blanks
      *                                                                                       CSW201
      ** If CSW201 is on, Sending Institution may be blank                                    CSW201
      *                                                                                       CSW201
     C                             AND CSW201 = 'N'                                           CSW201
      *                                                                                       CSW201
     C                   Eval      GenOkFlag2 = 'N'
     C                   Eval      Idx = Idx + 1
     C                   Eval      RetCodeIn = 'Error'
     C                   Eval      FldNamXAr(Idx) = DDSName
     C                   Eval      MsgIdXAr(Idx) = 'RFV0201'
     C                   Endif
 
     C                   If        PSINST <> *Blanks
      *
      ** Type is BO
      *
     C                   If        PCCTTYP = 'BO'
 
     C     8             Subst     PSTID:1       BIC1              8            178185
     C     3             Subst     PSTID:10      BIC2              3            178185
     C     BIC1          Cat       BIC2          BIC3             11            178185
      *                                                                         178185
     C                   If        BIC3 <> PSINST                               178185
     C                   Eval      GenOkFlag2 = 'N'                             178185
     C                   Eval      Idx = Idx + 1                                178185
     C                   Eval      RetCodeIn = 'Error'                          178185
     C                   Eval      FldNamXAr(Idx) = DDSName                     178185
     C                   Eval      MsgIdXAr(Idx) = 'RFV0380'                    178185
     C                   Else                                                   178185
      *                                                                         178185
      *
     C                   Eval      PACCT = PSINST
     C                   Exsr      SrAcct
      *
     C                   If        Wvalid <> 'N'
     C                   Eval      GenOkFlag2 = 'N'
     C                   Eval      Idx = Idx + 1
     C                   Eval      RetCodeIn = 'Error'
     C                   Eval      FldNamXAr(Idx) = DDSName
     C                   Eval      MsgIdXAr(Idx) = 'RFV0321'
     C                   Else
      *
     C**********         CallB     'AOBICDV0'                                                 221760
     C                   CallB     'AOBICDV01'                                                221760
     C                   Parm                    RetCodeIn
     C                   Parm                    PSINST
     C                   Parm                    PTType            7
     C                   Parm                    DSSDY
 
     C                   If        PTType = '*BIC   ' or
     C                             PTType =  '*NUMBER'  and
     C                             RetCodeIn = '*BICFND' or
     C                             PTType =  '*SHNAME' and
     C                             RetCodeIn = '*BICFND'
 
     C                   If        PTType =  '*NUMBER'  AND
     C                             %Subst(PSINST:7:1) <> *Blanks
     C                   Eval      Idx             =   Idx+1
     C                   Eval      RetCodeIn       =   'Error'
     C                   Eval      MsgIdXAr(Idx)   =  'RFV0363'
     C                   Eval      FldNamXAr(Idx)  =  DDSName
     C                   Eval      GenOkFlag2 = 'N'
     C                   Return
     C                   Endif
 
     C                   If        PTType =  '*SHNAME'  AND
     C                             %Subst(PSINST:11:1) <> *Blanks
     C                   Eval      Idx             =   Idx+1
     C                   Eval      RetCodeIn       =   'Error'
     C                   Eval      MsgIdXAr(Idx)   =  'RFV0362'
     C                   Eval      FldNamXAr(Idx)  =  DDSName
     C                   Eval      GenOkFlag2 = 'N'
     C                   Return
     C                   Endif
 
     C                   Else
 
      ** Must be BIC, customer number or shortname
     C                   Eval      GenOkFlag2 = 'N'
     C                   Eval      Idx = Idx + 1
     C                   Eval      RetCodeIn = 'Error'
     C                   Eval      FldNamXAr(Idx) = DDSName
     C                   Eval      MsgIdXAr(Idx) = 'RFV0186'
     C                   Endif
     C                   Endif
     C                   Endif                                                  178185
     C                   Endif
      *
      ** Type is BI
     C                   If        PCCTTYP = 'BI'
      *
      ** Check whether sender's/receiver's correspondent contain valid accou
      *
     C                   Eval      PACCT = PSndCOR
     C                   Exsr      SrAcct
      *
      ** Account invalid for senders correspondent
      *
     C                   If        wvalid = 'N'
     C                   Eval      wsvld = 'N'
     C                   Endif
      *
     C                   Eval      PACCT = PRCVCOR
     C                   Exsr      SrAcct
      *
      ** Account invalid for receivers correspondent
      *
     C                   If        wvalid = 'N'
     C                   Eval      wrvld = 'N'
     C                   Endif
 
     C                   Select
      *
      ** Both sender and receivers correspondent have a invalid account
      *
     C                   When      wsvld = 'N' and
     C                             wrvld = 'N'
      *
     C                   Eval      PACCT = PSINST
     C                   Exsr      SrAcct
      *
      ** Account invalid
      *
     C                   If        wvalid = 'N'
     C                   Eval      GenOkFlag2 = 'N'
     C                   Eval      Idx = Idx + 1
     C                   Eval      RetCodeIn = 'Error'
     C                   Eval      FldNamXAr(Idx) = DDSName
     C                   Eval      MsgIdXAr(Idx) = 'RFV0205'
     C                   Else
 
     C                   Select
     C                   When      PTYPE = 'IBAN'
     C                   Eval      PSINSTT = 'I'
     C                   When      PTYPE = '*LEDGER'
     C                   Eval      PSINSTT = 'G'
     C                   When      PTYPE = '*NOSTRO'
     C                   Eval      PSINSTT = 'F'
     C                   When      PTYPE = '*RETAIL'
     C                   Eval      PSINSTT = 'R'
     C                   Endsl
      *
     C                   Endif
      *
      ** Either sender or receivers correspondent has a valid account
      *
     C                   Other
 
     C**********         CallB     'AOBICDV0'                                                 221760
     C                   CallB     'AOBICDV01'                                                221760
     C                   Parm                    RetCodeIn
     C                   Parm                    PSINST
     C                   Parm                    PTType            7
     C                   Parm                    DSSDY
 
     C                   If        PTType = '*BIC   ' or
     C                             PTType =  '*NUMBER'  and
     C                             RetCodeIn = '*BICFND' or
     C                             PTType =  '*SHNAME' and
     C                             RetCodeIn = '*BICFND'
     C                   Else
      *
      ** Must be BIC, customer number or shortname
     C                   Eval      GenOkFlag2 = 'N'
     C                   Eval      Idx = Idx + 1
     C                   Eval      RetCodeIn = 'Error'
     C                   Eval      FldNamXAr(Idx) = DDSName
     C                   Eval      MsgIdXAr(Idx) = 'RFV0186'
     C                   Endif
      *
     C                   Endsl
     C                   Endif
     C                   Endif
      *
     C                   Return
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrAcct - Checks for valid account                             *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: AOIBANR2, AOACCTV1                                     *
      *                                                               *
      *****************************************************************
     C     SrAcct        Begsr
 
     C                   Eval      PTYPE = *Blanks
     C                   Eval      wvalid = 'Y'
 
      ** CFT is switched on
     C                   If        CFT004 = 'Y'
 
      ** Validate Account
     C                   CallB     'AOIBANR2'
     C                   Parm      *Blanks       PRTCD
     C                   Parm                    PACCT            35
     C     ACCNT         Parm      ACCNT         DSSDY
 
     C                   If        PRTCD = *Blanks
     C                   Eval      PTYPE = 'IBAN'
     C                   Endif
     C                   Endif
 
     C                   If        PTYPE <> 'IBAN'
 
      ** Validate Account
     C                   CallB     'AOACCTV1'
     C                   Parm      *Blanks       PRTCD             7            B:Return code
     C                   Parm                    PTYPE             7            I:A/c ID
     C                   Parm                    PACCT                          I:A/c Currency
     C                   Parm                    DSSDY                          I:A/c code
     C                   Endif
 
      ** Invalid Account
     C                   If        PTYPE <> 'IBAN' and
     C                             PTYPE <> '*NOSTRO'  and
     C                             PTYPE <> '*RETAIL'  and
     C                             PTYPE <> '*LEDGER' or
     C                             PRTCD <> *Blanks
     C                   Eval      wvalid = 'N'
     C                   Endif
 
     C                   Endsr
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        Begsr
 
     C     *Entry        PLIST
 
      ** INPUTS
 
     C                   Parm                    RetCodeIn
     C                   Parm                    RespMode          1
     C                   Parm                    ActionCode        1
 
      ** Screen fields
     C                   Parm                    HdrRcdIn
     C                   Parm                    DtlRcdIn
     C                   PARM                    OKFlagHS1
 
      ** OUTPUTS
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    FldNamXAr
     C                   Parm                    MsgIDXAr
     C                   Parm                    MsgDtaXAr
     C                   Parm                    WFldNmXAr
     C                   Parm                    WMsgIDXAr
     C                   Parm                    WMsgDtXAr
     C                   Parm                    DDSName          10
 
      ** Access SAR file to see if CFT004 is present
     C                   CallB     'AOSARDR0'
     C                   Parm      *Blanks       PRTCD
     C                   Parm      '*VERIFY'     POPTN             7
     C                   Parm      'CFT004'      PSARD             6
     C                   Parm                    DSSDY
      *
     C                   Eval      CFT004 = 'N'
     C                   If        PRTCD = *Blanks
     C                   Eval      CFT004 = 'Y'
     C                   Endif
      *                                                                                       CSW201
      ** Check if SWIFT 2001 is installed                                                     CSW201
      *                                                                                       CSW201
     C                   CALL      'SWIF2001'                                                 CSW201
     C                   PARM      *BLANKS       @RTCD                                        CSW201
      *                                                                                       CSW201
     C                   IF        @RTCD = 'CSW2001'                                          CSW201
     C                   EVAL      CSW201 = 'Y'                                               CSW201
     C                   ELSE                                                                 CSW201
     C                   EVAL      CSW201 = 'N'                                               CSW201
     C                   ENDIF                                                                CSW201
      *                                                                                       CSW201
 
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   Endsr                                                  *** InzEnd ***
 
      *****************************************************************
      /EJECT
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
