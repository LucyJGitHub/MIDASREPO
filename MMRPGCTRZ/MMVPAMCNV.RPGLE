     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2014')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM Payment date and Amount convention valdtn')   *
      *****************************************************************
      *                                                               *
      *  Midas - Money Market Dealing Module                          *
      *                                                               *
      *  IRVPAMCNV - Payment Date & Amount Convention Validation      *
      *                                                               *
      *  Function:  This module validates the payment date and amount *
      *             codes screen fields.                              *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2014            *
      *                                                               *
      *  Last Amend No. CDL096  *CREATE    Date 22Sep14               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *                                                               *
      *****************************************************************
      /EJECT
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
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
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
 
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for Arrays of Error Message IDs Etc.
     D Idx             S              2P 0
 
     D PDDIPFQ         S              1
     D RtnSysVal       S            200
     D SetDefault      S              1    Inz('Y')
 
      * Constant to hold input parameter for AOSVALR0
     D RtvCnvDft       C                   Const('MMBusDayConvDefault')
 
     D PayDateOk       S              1
     D AmtCodeOk       S              1
     D Defaulted       S               N   Inz(False)
 
     D/COPY ZACPYSRC,PRGETMDSVL
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
 
     C                   Eval      RetCodeIn = *Blanks
     C                   Eval      Idx = 0
     C                   Eval      ErrorFound = 'N'
     C                   Eval      PayDateOk = 'Y'
     C                   Eval      AmtCodeOk = 'Y'
     C                   Clear                   MsgIdArr
     C                   Clear                   FldNameArr
 
      ** If no Interest Payment Frequency passed,
      ** Business Day Convention entries are not relevant.
      ** return no error
     C                   If        PDDIPFQ = *BLANK
     C                   Return
     C                   EndIf
 
      ** Interest Payment Frequency is passed.
      ** If SetDefault system value = Yes,
      ** set valid defaults for Business Day convention
      ** fields then return no error
     C                   If        SetDefault = 'Y'
 
     C                   Eval      Defaulted = (PPayDate = *BLANK
     C                                          and PAmtCode = *BLANK)
 
     C                   If        PPayDate = *BLANK
     C                   Eval      PPayDate = 'MF'
     C                   EndIf
 
     C                   If        PAmtCode = *BLANK
     C                   Eval      PAmtCode = 'MF'
     C                   EndIf
 
     C                   If        Defaulted
     C                   Return
     C                   EndIf
 
     C                   ElseIf    SetDefault = 'N'
 
      ** Payment Date Convention must be defined
 
     C                   If        PPayDate = *Blanks
     C                   Eval      Idx = Idx + 1
     C                   Eval      MsgIdArr(Idx) = '5047406'
     C                   Eval      ErrorFound = 'Y'
     C                   Eval      PayDateOk = 'N'
     C                   Eval      FldNameArr(Idx) = 'DDPYDC'
     C                   EndIf
 
      ** Amount Convention must be defined
 
     C                   If        PAmtCode = *Blanks
     C                   Eval      Idx = Idx + 1
     C                   Eval      MsgIdArr(Idx) = '5047407'
     C                   Eval      ErrorFound = 'Y'
     C                   Eval      AmtCodeOk = 'N'
     C                   Eval      FldNameArr(Idx) = 'DDAMTC'
     C                   EndIf
 
     C                   EndIf
 
     C                   Eval      PPayDate = %trim(PPayDate)
     C                   Eval      PAmtCode = %trim(PAmtCode)
 
      ** Payment Date Convention must be P, F, MF or MP.
 
     C                   If        PPayDate <> *Blanks and
     C                             PPayDate <> 'P' and
     C                             PPayDate <> 'F' and
     C                             PPayDate <> 'MF'and
     C                             PPayDate <> 'MP'
     C                   Eval      Idx = Idx + 1
     C                   Eval      MsgIdArr(Idx) = 'MMA0851'
     C                   Eval      ErrorFound = 'Y'
     C                   Eval      PayDateOk = 'N'
     C                   Eval      FldNameArr(Idx) = 'DDPYDC'
     C                   Endif
 
      ** Amount Convention must be P, F, MF, MP or A.
 
     C                   If        PAmtCode <> *Blanks and
     C                             PAmtCode <> 'A' and
     C                             PAmtCode <> 'P' and
     C                             PAmtCode <> 'F' and
     C                             PAmtCode <> 'MF'and
     C                             PAmtCode <> 'MP'
     C                   Eval      Idx = Idx + 1
     C                   Eval      MsgIdArr(Idx) = 'MMA0852'
     C                   Eval      ErrorFound = 'Y'
     C                   Eval      AmtCodeOk = 'N'
     C                   Eval      FldNameArr(Idx) = 'DDAMTC'
     C                   Endif
 
     C                   If        Errorfound = 'N'
     C                   If        PPayDate = *Blanks and
     C                             PAmtCode = *Blanks
     C                   Eval      PAmtCode = 'A'
     C                   Endif
 
      ** Valid Combination are as follows:
      **    Payment Date Code     Amount Code
      **           P (Previous)        P
      **           F (Following)       F
      **          MF (Modified F)     MF
      **          MP (Modified P)     MP
      **          MP                  A (Actual)
      **          MF                  A
      **          P                   A
      **          F                   A
 
     C                   If        PPayDate = 'P' and
     C                             PAmtCode = 'P' or
     C                             PPayDate = 'F' and
     C                             PAmtCode = 'F' or
     C                             PPayDate = 'MF' and
     C                             PAmtCode = 'MF' or
     C                             PPayDate = 'MP' and
     C                             PAmtCode = 'MP' or
     C                             PPayDate = 'MP' and
     C                             PAmtCode = 'A' or
     C                             PPayDate = 'MF' and
     C                             PAmtCode = 'A' or
     C                             PPayDate = 'P' and
     C                             PAmtCode = 'A' or
     C                             PPayDate = 'F' and
     C                             PAmtCode = 'A'
     C                   Else
     C                   Eval      Idx = Idx + 1
     C                   Eval      MsgIdArr(Idx) = '5047473'
     C                   Eval      ErrorFound = 'Y'
     C                   Eval      PayDateOk = 'N'
     C                   Eval      AmtCodeOk = 'N'
     C                   Eval      FldNameArr(Idx) = 'DDAMTC'
     C                   Endif
 
     C                   Endif
 
     C                   Return
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        Begsr
 
     C     *Entry        Plist
     C                   Parm                    RetCodeIn
     C                   Parm                    PPayDate          2
     C                   Parm                    PAmtCode          2
     C                   Parm                    PDDIPFQ
     C                   Parm                    PayDateOk
     C                   Parm                    AmtCodeOk
     C                   Parm                    MsgIdArr
     C                   Parm                    FldNameArr
 
     C                   CALLP     GetMidasSysVal(RtvCnvDft:
     C                                            RtnSysVal)
 
     C                   IF        RtnSysVal = '*NRF'
 
     C                   EVAL      DBPGM = PSPROCPGM
     C                   EVAL      DBKEY = RtvCnvDft
     C                   EVAL      DBFILE = 'SDSVALPD'
     C                   EVAL      DBASE = 001
     C                   EXSR      *PSSR
 
     C                   ELSE
     C                   EVAL      SetDefault = RtnSysVal
     C                   EndIf
 
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   Endsr
 
      *****************************************************************
      /EJECT
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
     C/COPY ZACPYSRC,PIGETMDSVL
**  CPY@
(c) Misys International Banking Systems Ltd. 2014
