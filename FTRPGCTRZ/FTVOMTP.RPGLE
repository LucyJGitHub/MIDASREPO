     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2009')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Validate Incoming Message Type')              *
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FTVOMTP  - Validate OP Incoming Message Type                 *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2009            *
      *                                                               *
      *  Last Amend No. CFT162             Date 08Sep17               *
      *  Prev Amend No. CRE075             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 BUG24962           Date 22Jul09               *
      *                 CSW209  *CREATE    Date 01Apr09               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CFT162 - MT900 and MT910 Message Generation (Recompile)      *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  BUG24962 - Incoming message type field should be blanks      *
      *  CSW209 - SWIFT 2009 Changes                                  *
      *                                                               *
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

      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.

     D/COPY ZACPYSRC,PSDS

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

      ** The maximum size of the appended error arrays
     D XArrayMax       C                   CONST(20)

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

      ** Array of Fields in error.
     D FldNamXAr       S             10A   DIM(XArrayMax)

      ** Array of error message IDs
     D MsgIDXAr        S                   DIM(XArrayMax) LIKE(#MsgId)

      ** Array of error message data.
     D MsgDtaXAr       S                   DIM(XArrayMax) LIKE(#MsgData)

      ** Array of Warning in error.
     D WFldNmXAr       S             10A   DIM(XArrayMax)

      ** Array of Warning message IDs
     D WMsgIDXAr       S                   DIM(XArrayMax) LIKE(#MsgId)

      ** Array of Warning message data.
     D WMsgDtaXAr      S                   DIM(XArrayMax) LIKE(#MsgData)

      * Incoming Transaction
     D NwOPFilFmt    E DS                  EXTNAME(FTVOPAYPD)
     D NwOPFilFmx    E DS                  EXTNAME(FTVOPY2PD)

      ** Cover message
     D NwOPAScnFmt   E DS                  EXTNAME(FTOPYAPD)

      * Flags to indicate whether transaction fields are valid
     D FTEOPYA       E DS                  EXTNAME(FTEOPYAPD)

      ** External data structure for access programs
     D DSFDY         E DS                  EXTNAME(DSFDY)

      ** External data structure for access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)

      ** External data structure for access programs
     D ACCNT         E DS                  EXTNAME(ACCNTAB)

      ** External data structure for access programs
     D NOSTRO        E DS                  EXTNAME(SDNOSTPD)

      ** External data structure for access programs
     D CUST          E DS                  EXTNAME(SDCUSTPD)

      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      ** Index for arrays of error message ids etc
     D Idx             S              3P 0

      ** Index for arrays of warning message ids etc
     D WIX             S              3P 0

     D PRTCD           S              7A
     D POPTN           S              7A
     D PMTPY           S              3A
     D PTYPE           S              7A
     D PACCT           S             35A
     D PCUST           S              7A
     D PCUST10A        S             10A
     D PKEY            S              7A

      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
     C
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+

      *
      ** Initialization
      *
     C                   Eval      RetCodeIn  = *BLANKS
     C                   Eval      FldNamXAr  = *BLANKS
     C                   Eval      MsgIDXAr   = *BLANKS
     C                   Eval      MsgDtaXAr  = *BLANKS
     C                   Eval      WFldNmXAr  = *BLANKS
     C                   Eval      WMsgIDXAr  = *BLANKS
     C                   Eval      WMsgDtaXAr = *BLANKS
     C                   Eval      WIX = 0
     C                   Eval      Idx = 0
     C                   EVAL      PMTPY = *BLANKS                                          BUG24962

      ** Validate
     C                   Exsr      VOMTP

      ** If an error was found, set the return code appropriately
      *
     C                   If        OKMTPY = 'N'
     C                   Eval      RetCodeIn = 'Error'
      *
     C                   Else
     C                   Eval      O2MTPY = PMTPY
     C                   EndIf

      ** RETURN
      *
     C                   Return
      *****************************************************************
      /EJECT
      *****************************************************************
      * VOMTP - Validate Outgoing Message Type
      *****************************************************************
      *
     C     VOMTP         BegSr
      *
     C                   If        SMTPY <> *Blanks
     C                   Call      'AOMTPYR0'
     C                   Parm      *BLANKS       PRTCD
     C                   Parm      '*KEY    '    POPTN
     C     SMTPY         Parm      SMTPY         PMTPY
     C                   Parm      *BLANKS       DSFDY
      *
      ** Invalid Message Type
      *
     C                   If        PRTCD <> *Blanks
     C                   Eval      OKMTPY = 'N'
     C                   Eval      Idx = Idx + 1
     C                   Eval      FldNamXAr(Idx) = 'SMTPY'
     C                   Eval      MsgDtaXAr(IDX) = SMTPY
     C                   Eval      MsgIDXAr(Idx)  = 'ME00139'
      *
      ** Ordering Bank is mandatory for SWIFT 205
      *
     C                   ElseIf    SNWRK = 'SWIFT' And
     C                             SMTPY = '205'   And
     C                             OTORBK = *Blanks And
     C                             OTORBB = *Blanks

     C                   Exsr      VOrdBen

     C                   If        BBBNBI <> 'Y'

     C                   Eval      OKMTPY = 'N'
     C                   Eval      Idx = Idx + 1
     C                   Eval      FldNamXAr(Idx) = 'SMTPY'
     C                   Eval      MsgDtaXAr(IDX) = SMTPY
     C                   Eval      MsgIDXAr(Idx)  = 'ME00169'

     C                   EndIf

     C                   EndIf

     C                   EndIf

     C                   EndSr

      *****************************************************************
      /EJECT
      *****************************************************************
      * VOrdBen - Validate Ordering Customer and Beneficiary
      *****************************************************************
      *
     C     VOrdBen       BegSr
      *
     C                   If        OTORC1 <> 'MT202'

     C                   If        OTORC1 <> *Blanks
     C                   Eval      PACCT = OTORC1
     C                   Exsr      VBANK
     C                   EndIf

     C                   If        BBBNBI = 'Y'

     C                   If        OTBNC1 <> *Blanks
     C                   Eval      PACCT = OTBNC1
     C                   Exsr      VBANK
     C                   EndIf

     C                   EndIf

     C                   EndIf

     C                   EndSr

      *****************************************************************
      /EJECT
      *****************************************************************
      * VBANK - Validate if Bank
      *****************************************************************
      *
     C     VBANK         BegSr
      *
     C                   Eval      BBBNBI = *Blanks
     C                   Eval      PCUST = *Blanks
     C                   CallB     'AOACCTV1'
     C                   Parm      *Blanks       PRTCD
     C                   Parm      *Blanks       PTYPE
     C                   Parm                    PACCT
     C                   Parm                    DSSDY

     C                   If        PRTCD = *Blanks
     C                   Select
     C     PTYPE         WhenEQ    '*RETAIL'
     C     PTYPE         OrEQ      '*LEDGER'
     C                   Eval      ACCNT = DSSDY
     C                   MoveL     CNUM          PCUST10A
     C                   Exsr      VCUST
     C     PTYPE         WhenEQ    '*NOSTRO'
     C                   Eval      NOSTRO = DSSDY
     C                   Eval      PCUST10A = A7CUST
     C                   Exsr      VCUST
     C     PTYPE         WhenEQ    '*CUSTNO'
     C     PTYPE         OrEQ      '*SHNAME'
     C                   Eval      CUST = DSSDY
     C                   EndSl

     C                   Else
     C                   EndIf

     C                   EndSr

      *****************************************************************
      /EJECT
      *****************************************************************
      * VCUST - Validate Customer Number
      *****************************************************************
      *
     C     VCUST         BegSr
      *
     C                   CallB     'AOCUSTR0'
     C                   Parm      *Blanks       PRTCD
     C                   Parm      '*KEY'        POPTN
     C                   Parm                    PCUST10A
     C                   Parm      *Blanks       PKEY
     C     CUST          Parm      CUST          DSSDY

     C                   EndSr

     C*****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BegSr

     C     *Entry        Plist

      * INPUTS
      ** Return Code
     C                   Parm                    RetCodeIn
     C                   Parm                    NwOPFilFmt
     C                   Parm                    NwOPFilFmx
     C                   Parm                    NwOPAScnFmt
     C                   Parm                    FTEOPYA
     C                   Parm                    FldNamXAr
     C                   Parm                    MsgIDXAr
     C                   Parm                    MsgDtaXAr
     C                   Parm                    WFldNmXAr
     C                   Parm                    WMsgIDXAr
     C                   Parm                    WMsgDtaXAr
      *
      ** =================================================================
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area

     C/COPY ZACPYSRC,DBFIELDS

     C                   EndSr
      *****************************************************************
      /EJECT
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2009
