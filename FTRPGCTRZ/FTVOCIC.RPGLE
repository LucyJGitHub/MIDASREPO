     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2009')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Validate Instructed Currency/Amount (Cov)')   *
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FTVOCIC  - Validate OP Instructed Currency and Amount (Cover)*
      *                                                               *
      *  (c) Finastra International Limited 2009                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. MD000091           Date 06May13               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 BUG24510           Date 24Jun09               *
      *                 CSW209  *CREATE    Date 01Apr09               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD000091 - Event Codes Substitution                          *
      *  BUG24510 - Instructed Amount Cover must be entered if        *
      *             Instructed Currency is not blank                  *
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
 
      ** Incoming Message
     D NwOPFilFmt    E DS                  EXTNAME(FTVOPY2PD)
 
      ** Cover Message
     D NwOPAScnFmt   E DS                  EXTNAME(FTOPYAPD)
     D NwOPCScnFmt   E DS                  EXTNAME(FTOPYCPD)
 
      ** Flags to indicate whether transaction fields are valid
     D FTEOPYC       E DS                  EXTNAME(FTEOPYCPD)
 
      ** External data structure for Currency standing data
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      ** External data structure for access programs (short)
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
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
 
      ** Work fields
     D PRTCD           S              7A
     D POPTN           S              7A
     D PCCY            S              3A
     D ZALIGNok        S              1A
     D ZFIELD          S             16A
     D ZADEC           S              1P 0
     D ZADIG           S              2P 0
 
      **                                                                                    MD000091
     D BChar           DS                                                                   MD000091
     D   BLen                  1      2B 0                                                  MD000091
     D   LenStr                1      2                                                     MD000091
                                                                                            MD000091
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
     C                   Eval      RetCodeIn  = *Blanks
     C                   Eval      FldNamXAr  = *Blanks
     C                   Eval      MsgIDXAr   = *Blanks
     C                   Eval      MsgDtaXAr  = *Blanks
     C                   Eval      WFldNmXAr  = *Blanks
     C                   Eval      WMsgIDXAr  = *Blanks
     C                   Eval      WMsgDtaXAr = *Blanks
     C                   Eval      WIX = 0
     C                   Eval      Idx = 0
 
      ** Validate
     C                   ExSr      VOCIC
      *
      ** If an error was found, set the return code appropriately
      *
     C                   If        OKCICY = 'N' Or
     C                             OKCIAM = 'N'
     C                   Eval      RetCodeIn = 'Error'
     C                   Else
 
     C                   If        SCICY = *Blanks
     C                   Eval      O2CICY = *Blanks
     C                   EndIf
     C                   If        SCIAM = *Blanks
     C                   Eval      O2CIAM = 0
     C                   EndIf
 
     C                   EndIf
      *
      ** RETURN
      *
     C                   Return
      *****************************************************************
      /EJECT
      *****************************************************************
      * VOCIC - Validate Instructed Currency and Amount (Cover)
      *****************************************************************
      *
     C     VOCIC         BegSr
      *
     C                   If        SOMVLF = 'COV'
      *
      ** Instructed Currency and Amount (Cover) can only be entered for
      ** Validation Flag(Main) COV
      *
     C                   Else
      *
     C                   If        SCICY <> *Blanks
     C                   Eval      OKCICY = 'N'
     C                   Eval      Idx = Idx + 1
     C                   Eval      FldNamXAr(Idx) = 'SCICY'
     C**********         Eval      MsgDtaXAr(IDX) = SCICY                                   MD000091
     C                   EVAL      BLen = %Len(%Trim(SCICY))                                MD000091
     C                   EVAL      MsgDtaXAr(IDX) = LenStr +%TRIM(SCICY)                    MD000091
     C                   Eval      MsgIDXAr(Idx) = 'ME00260'
     C                   LeaveSr
     C                   EndIf
      *
     C                   If        SCIAM <> *Blanks
     C                   Eval      OKCIAM = 'N'
     C                   Eval      Idx = Idx + 1
     C                   Eval      FldNamXAr(Idx) = 'SCIAM'
     C**********         Eval      MsgDtaXAr(IDX) = SCIAM                                   MD000091
     C                   EVAL      BLen = %Len(%Trim(SCIAM))                                MD000091
     C                   EVAL      MsgDtaXAr(IDX) = LenStr +%TRIM(SCIAM)                    MD000091
     C                   Eval      MsgIDXAr(Idx) = 'ME00261'
     C                   LeaveSr
     C                   EndIf
      *
     C                   EndIf
      *
      ** Validate Instructed Currency (Cover)
      *
     C                   If        SCICY <> *Blanks
      *
     C                   Call      'AOCURRR0'
     C                   Parm      *BLANKS       PRTCD
     C                   Parm      '*KEY'        POPTN
     C     SCICY         Parm      SCICY         PCCY
     C     SDCURR        Parm      SDCURR        DSFDY
      *
     C                   If        PRTCD <> *Blanks
     C                   Eval      OKCICY = 'N'
     C                   Eval      Idx = Idx + 1
     C                   Eval      FldNamXAr(Idx) = 'SCICY'
     C**********         Eval      MsgDtaXAr(IDX) = SCICY                                   MD000091
     C                   EVAL      BLen = %Len(%Trim(SCICY))                                MD000091
     C                   EVAL      MsgDtaXAr(IDX) = LenStr +%TRIM(SCICY)                    MD000091
     C                   Eval      MsgIDXAr(Idx) = 'ME00218'
     C                   LeaveSr
     C                   EndIf
      *
     C                   Eval      O2CICY = SCICY
     C                   EndIf
      *
      ** Validate Instructed Amount (Cover)
      *
     C                   If        SCIAM <> *Blanks
      ** Currency is mandatory if Instructed amount is entered
     C                   If        SCICY =  *Blanks
     C                   Eval      OKCIAM = 'N'
     C                   Eval      Idx = Idx + 1
     C                   Eval      FldNamXAr(Idx) = 'SCIAM'
     C**********         Eval      MsgDtaXAr(IDX) = SCIAM                                   MD000091
     C                   EVAL      BLen = %Len(%Trim(SCIAM))                                MD000091
     C                   EVAL      MsgDtaXAr(IDX) = LenStr +%TRIM(SCIAM)                    MD000091
     C                   Eval      MsgIDXAr(Idx) = 'ME00220'
     C                   LeaveSr
     C                   EndiF
      *
     C                   Eval      ZFIELD = *Blanks
     C                   Eval      ZALIGNok = 'Y'
     C                   Move (P)  SCIAM         ZFIELD
      *
      ** Ensure Instructed amount is in a valid format
      *
     C                   CallB     'ZALIGN'
     C                   Parm                    ZALIGNok
     C                   Parm                    ZFIELD
     C                   Parm      A6NBDP        ZADEC
     C                   Parm      13            ZADIG
      *
     C                   If        ZALIGNok <> 'Y'
     C                   Eval      OKCIAM = 'N'
     C                   Eval      Idx = Idx + 1
     C                   Eval      FldNamXAr(Idx) = 'SCIAM'
     C**********         Eval      MsgDtaXAr(IDX) = SCIAM                                   MD000091
     C                   EVAL      BLen = %Len(%Trim(SCIAM))                                MD000091
     C                   EVAL      MsgDtaXAr(IDX) = LenStr +%TRIM(SCIAM)                    MD000091
     C                   Eval      MsgIDXAr(Idx) = 'ME00221'
     C                   LeaveSr
     C                   EndIf
      *
     C                   Move      ZFIELD        O2CIAM
      *                                                                                     BUG24510
     C                   ELSE                                                               BUG24510
      *                                                                                     BUG24510
      ** Instructed amount is optional but is mandatory if the currency is entered.         BUG24510
      *                                                                                     BUG24510
     C                   IF        SCICY  <> *BLANKS                                        BUG24510
     C                   EVAL      OKCIAM = 'N'                                             BUG24510
     C                   EVAL      Idx = Idx + 1                                            BUG24510
     C                   EVAL      FldNamXAr(Idx) = 'SCIAM'                                 BUG24510
     C**********         EVAL      MsgDtaXAr(IDX) = SCIAM                          BUG24510 MD000091
     C                   EVAL      BLen = %Len(%Trim(SCIAM))                                MD000091
     C                   EVAL      MsgDtaXAr(IDX) = LenStr +%TRIM(SCIAM)                    MD000091
     C                   EVAL      MsgIDXAr(Idx) = 'ME00268'                                BUG24510
     C                   LEAVESR                                                            BUG24510
     C                   ENDIF                                                              BUG24510
     C                                                                                      BUG24510
     C                   EndIf
      *
     C                   EndSr
     C*****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BegSr
 
     C     *Entry        PList
 
     C                   Parm                    RetCodeIn
     C                   Parm                    NwOPFilFmt
     C                   Parm                    NwOPAScnFmt
     C                   Parm                    NwOPCScnFmt
     C                   Parm                    FTEOPYC
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
(c) Finastra International Limited 2009
