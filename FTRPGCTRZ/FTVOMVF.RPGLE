     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2009')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Validate Outgoing Validation Flag (Main)')    *
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FTVOMVF  - Validate OP Outgoing Validation Flag Main         *
      *                                                               *
      *  (c) Finastra International Limited 2009                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CSF011A            Date 28Nov11               *
      *                 CRE075             Date 06Dec10               *
      *                 BUG26775           Date 16Nov09               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 CSW209  *CREATE    Date 01Apr09               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  BUG26775 - Validation error in Outgoing Validation Flag      *
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
     D FTOPAY1       E DS                  EXTNAME(FTOPY1PD)
     D NwOPFilFmt    E DS                  EXTNAME(FTVOPAYPD)
     D NwOPFilFmx    E DS                  EXTNAME(FTVOPY2PD)
 
      ** Cover Message
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
     D WAllowsMT202C   S              1A
     D CTYP            S              1A                                                    BUG26775
 
      ** System Value for MT202 SWIFT MT202 COV to cover SWIFT MT202 COV
 
     D PAllowsMT202C   C                    'AllowMT202Cover'
 
      ** Parameters for Access Objects
 
     D P@RTCD          S              7A
     D P@OP01          S             20A
     D P@VL01          S            200A
     D P@OP02          S             20A
     D P@VL02          S            200A
     D P@OP03          S             20A
     D P@VL03          S            200A
     D P@OP04          S             20A
     D P@VL04          S            200A
     D P@OP05          S             20A
     D P@VL05          S            200A
     D P@OP06          S             20A
     D P@VL06          S            200A
     D P@OP07          S             20A
     D P@VL07          S            200A
     D P@OP08          S             20A
     D P@VL08          S            200A
     D P@OP09          S             20A
     D P@VL09          S            200A
     D P@OP10          S             20A
     D P@VL10          S            200A
 
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
 
      ** Validate
     C                   Exsr      VOMVF
 
      ** If an error was found, set the return code appropriately
      *
     C                   If        OKOMVF = 'N'
     C                   Eval      RetCodeIn = 'Error'
      *
     C                   Else
     C                   Eval      O2OMVF = SOMVLF
     C                   EndIf
 
      ** RETURN
      *
     C                   Return
      *****************************************************************
      /EJECT
      *****************************************************************
      * VOMVF - Validate Outgoing Validation Flag Main
      *****************************************************************
      *
     C     VOMVF         BegSr
      *
     C                   If        SNWRK = 'SWIFT'
     C                             And (SMTPY = '202' Or SMTPY = '205')
     C                             And SVALF = 'COV'
     C                             And SOMVLF = 'COV'
 
     C                   Else
     C                   If        SOMVLF <> 'COV'
     C                             And SOMVLF <> *Blanks
     C                   Eval      OKOMVF = 'N'
     C                   Eval      Idx = Idx + 1
     C                   Eval      FldNamXAr(Idx) = 'SOMVLF'
     C                   Eval      MsgDtaXAr(IDX) = SOMVLF
     C                   Eval      MsgIDXAr(Idx)  = 'ME00252'
     C                   LeaveSr
     C                   EndIf
     C                   EndIf
 
     C                   If        SOMVLF = *Blanks
 
     C                   If        OTSTMT = 08
     C                             And SVALF = 'COV'
     C                   Eval      SOMVLF = 'COV'
 
     C                   ExSr      VOrdBen
     C                   If        OKOMVF = 'N'
     C                   LeaveSr
     C                   EndIf
 
     C                   ExSr      VMT202
     C                   If        OKOMVF = 'N'
     C                   LeaveSr
     C                   EndIf
 
     C                   ExSr      VRelRef
     C                   If        OKOMVF = 'N'
     C                   LeaveSr
     C                   EndIf
 
     C                   ExSr      VRegPay
 
     C                   EndIf
 
     C                   Else
 
     C                   If        OTSTMT <> 08
     C                   Eval      OKOMVF = 'N'
     C                   Eval      Idx = Idx + 1
     C                   Eval      FldNamXAr(Idx) = 'SOMVLF'
     C                   Eval      MsgDtaXAr(IDX) = SOMVLF
     C                   Eval      MsgIDXAr(Idx)  = 'ME00229'
     C                   LeaveSr
     C                   EndIf
 
     C                   If        SOMVLF = 'COV'
 
     C                   If        SVALF <> 'COV'
     C                   Eval      OKOMVF = 'N'
     C                   Eval      Idx = Idx + 1
     C                   Eval      FldNamXAr(Idx) = 'SOMVLF'
     C                   Eval      MsgDtaXAr(IDX) = SOMVLF
     C                   Eval      MsgIDXAr(Idx)  = 'ME00231'
     C                   LeaveSr
     C                   EndIf
 
     C                   ExSr      VOrdBen
     C                   If        OKOMVF = 'N'
     C                   LeaveSr
     C                   EndIf
 
     C                   ExSr      VMT202
     C                   If        OKOMVF = 'N'
     C                   LeaveSr
     C                   EndIf
 
     C                   ExSr      VRelRef
     C                   If        OKOMVF = 'N'
     C                   LeaveSr
     C                   EndIf
 
     C                   ExSr      VRegPay
 
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
     C                             AND OTBNC1 <> *BLANKS                                    BUG26775
     C**********         Eval      PACCT = OTORC1                                           BUG26775
     C**********         Exsr      VBANK                                                    BUG26775
     C                   Call      'FT1020'                                                 BUG26775
     C                   Parm      OTORCT        CNTYP             1                        BUG26775
     C                   Parm      OTSMCY        CNCCY             3                        BUG26775
     C                   Parm      OTORC1        CNTR1            35                        BUG26775
     C                   Parm      OTORC2        CNTR2            35                        BUG26775
     C                   Parm      OTORC3        CNTR3            35                        BUG26775
     C                   Parm      OTORC4        CNTR4            35                        BUG26775
     C                   Parm      OTORC5        CNTR5            35                        BUG26775
     C                   Parm      OTBNCT        BNTYP             1                        BUG26775
     C                   Parm      OTPCCY        BNCCY             3                        BUG26775
     C                   Parm      OTBNC1        BNTR1            35                        BUG26775
     C                   Parm      OTBNC2        BNTR2            35                        BUG26775
     C                   Parm      OTBNC3        BNTR3            35                        BUG26775
     C                   Parm      OTBNC4        BNTR4            35                        BUG26775
     C                   Parm      OTBNC5        BNTR5            35                        BUG26775
     C                   Parm      'C'           CTYP                                       BUG26775
     C                   EndIf
 
     C**********         If        BBBNBI <> 'Y'                                            BUG26775
     C                   IF        CTYP <> 'B'                                              BUG26775
     C                   Eval      OKOMVF = 'N'
     C                   Eval      Idx = Idx + 1
     C                   Eval      FldNamXAr(Idx) = 'SOMVLF'
     C                   Eval      MsgDtaXAr(IDX) = SOMVLF
     C                   Eval      MsgIDXAr(Idx)  = 'ME00230'
     C                   LeaveSr
     C                   EndIf
 
     C**********         If        OTBNC1 <> *Blanks                                        BUG26775
     C**********         Eval      PACCT = OTBNC1                                           BUG26775
     C**********         Exsr      VBANK                                                    BUG26775
     C**********         EndIf                                                              BUG26775
 
     C**********         If        BBBNBI <> 'Y'                                            BUG26775
     C**********         Eval      OKOMVF = 'N'                                             BUG26775
     C**********         Eval      Idx = Idx + 1                                            BUG26775
     C**********         Eval      FldNamXAr(Idx) = 'SOMVLF'                                BUG26775
     C**********         Eval      MsgDtaXAr(IDX) = SOMVLF                                  BUG26775
     C**********         Eval      MsgIDXAr(Idx)  = 'ME00230'                               BUG26775
     C**********         LeaveSr                                                            BUG26775
     C**********         EndIf                                                              BUG26775
 
     C                   EndIf
 
     C                   EndSr
 
      *****************************************************************
      /EJECT
      *****************************************************************
      * VMT202 - Validate if MT202
      *****************************************************************
      *
     C     VMT202        BegSr
      *
     C                   If        SSNMT = 'Y'
     C                   If        WAllowsMT202C <> 'Y'
     C                             And SOMVLF = 'COV'
     C                   Eval      OKOMVF = 'N'
     C                   Eval      Idx = Idx + 1
     C                   Eval      FldNamXAr(Idx) = 'SOMVLF'
     C                   Eval      MsgDtaXAr(IDX) = SOMVLF
     C                   Eval      MsgIDXAr(Idx)  = 'ME00250'
     C                   EndIf
     C                   EndIf
 
     C                   EndSr
 
      *****************************************************************
      /EJECT
      *****************************************************************
      * VRelRef - Validate Related Reference
      *****************************************************************
      *
     C     VRelRef       BegSr
      *
     C                   If        OTRLPR = *Blanks
     C                   Eval      OKOMVF = 'N'
     C                   Eval      Idx = Idx + 1
     C                   Eval      FldNamXAr(Idx) = 'SOMVLF'
     C                   Eval      MsgDtaXAr(IDX) = SOMVLF
     C                   Eval      MsgIDXAr(Idx)  = 'ME00174'
     C                   EndIf
 
     C                   EndSr
 
      *****************************************************************
      /EJECT
      *****************************************************************
      * VRegPay - Validate Regular Payment
      *****************************************************************
      *
     C     VRegPay       BegSr
      *
     C                   If        OTPYTP = 'RP'
     C                             And SOMVLF = 'COV'
     C                   Eval      OKOMVF = 'N'
     C                   Eval      Idx = Idx + 1
     C                   Eval      FldNamXAr(Idx) = 'SOMVLF'
     C                   Eval      MsgDtaXAr(IDX) = SOMVLF
     C                   Eval      MsgIDXAr(Idx)  = 'ME00251'
     C                   EndIf
 
     C                   EndSr
 
      *****************************************************************
      /EJECT
      *****************************************************************
      * VBANK - Validate if Bank
      *****************************************************************
      *
     C*****VBANK         BegSr                                                              BUG26775
      *
     C**********         Eval      BBBNBI = *Blanks                                         BUG26775
     C**********         Eval      PCUST = *Blanks                                          BUG26775
     C**********         CallB     'AOACCTV1'                                               BUG26775
     C**********         Parm      *Blanks       PRTCD                                      BUG26775
     C**********         Parm      *Blanks       PTYPE                                      BUG26775
     C**********         Parm                    PACCT                                      BUG26775
     C**********         Parm                    DSSDY                                      BUG26775
 
     C**********         If        PRTCD = *Blanks                                          BUG26775
     C**********         Select                                                             BUG26775
     C*****PTYPE         WhenEQ    '*RETAIL'                                                BUG26775
     C*****PTYPE         OrEQ      '*LEDGER'                                                BUG26775
     C**********         Eval      ACCNT = DSSDY                                            BUG26775
     C**********         MoveL     CNUM          PCUST10A                                   BUG26775
     C**********         Exsr      VCUST                                                    BUG26775
     C*****PTYPE         WhenEQ    '*NOSTRO'                                                BUG26775
     C**********         Eval      NOSTRO = DSSDY                                           BUG26775
     C**********         Eval      PCUST10A = A7CUST                                        BUG26775
     C**********         Exsr      VCUST                                                    BUG26775
     C*****PTYPE         WhenEQ    '*CUSTNO'                                                BUG26775
     C*****PTYPE         OrEQ      '*SHNAME'                                                BUG26775
     C**********         Eval      CUST = DSSDY                                             BUG26775
     C**********         EndSl                                                              BUG26775
     C**********         EndIf                                                              BUG26775
 
     C**********         EndSr                                                              BUG26775
 
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
     C     *InzSr        BegSr
      *
     C     *Entry        PList
 
     C                   Parm                    RetCodeIn
     C                   Parm                    FTOPAY1
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
 
     C                   Call      'AOSVALR0'
     C                   Parm      *Blanks       P@RTCD
     C                   Parm      PAllowsMT202C P@OP01
     C                   Parm      *Blanks       P@VL01
     C                   Parm      *Blanks       P@OP02
     C                   Parm      *Blanks       P@VL02
     C                   Parm      *Blanks       P@OP03
     C                   Parm      *Blanks       P@VL03
     C                   Parm      *Blanks       P@OP04
     C                   Parm      *Blanks       P@VL04
     C                   Parm      *Blanks       P@OP05
     C                   Parm      *Blanks       P@VL05
     C                   Parm      *Blanks       P@OP06
     C                   Parm      *Blanks       P@VL06
     C                   Parm      *Blanks       P@OP07
     C                   Parm      *Blanks       P@VL07
     C                   Parm      *Blanks       P@OP08
     C                   Parm      *Blanks       P@VL08
     C                   Parm      *Blanks       P@OP09
     C                   Parm      *Blanks       P@VL09
     C                   Parm      *Blanks       P@OP10
     C                   Parm      *Blanks       P@VL10
 
     C                   Eval      WAllowsMT202C = 'N'
     C                   If        P@RTCD = *Blanks
     C                   Movel     P@VL01        WAllowsMT202C
     C                   EndIf
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
(c) Finastra International Limited 2009
