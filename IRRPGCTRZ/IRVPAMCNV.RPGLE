     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas IR Payment date and amount codes validation')
      *****************************************************************
      *                                                               *
      *  Midas - FRA/IRS Dealing Module                               *
      *                                                               *
      *  IRVPAMCNV - Payment Date & Amount Codes Validation           *
      *                                                               *
      *  Function:  This module validates the payment date and amount *
      *             codes screen fields.                              *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.03 -----------------------------------------------*
      *  Prev Amend No. CIR005  *CREATE    Date 21Jan00               *
      *                                    Date DDMmmYY               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CIR005 - FRA/IRS Business Day Conventions                    *
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
 
     D PayDateOk       S              1
     D AmtCodeOk       S              1
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for Arrays of Error Message IDs Etc.
     D Idx             S              2P 0
 
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
 
     C                   If        PPayDate = ' P' or
     C                             PPayDate = ' F'
     C                   Move      PPayDate      WPDate            1
     C                   Move      *Blanks       PPayDate
     C                   MoveL     WPDate        PPayDate
     C                   Endif
 
     C                   If        PAmtCode = ' P' or
     C                             PAmtCode = ' F' or
     C                             PAmtCode = ' A'
     C                   Move      PAmtCode      WACode            1
     C                   Move      *Blanks       PAmtCode
     C                   MoveL     WACode        PAmtCode
     C                   Endif
 
      ** Payment Date Code must be blank, P, F, MF or MP.
 
     C                   If        PPayDate <> *Blanks and
     C                             PPayDate <> 'P' and
     C                             PPayDate <> 'F' and
     C                             PPayDate <> 'MF'and
     C                             PPayDate <> 'MP'
     C                   Eval      Idx = Idx + 1
     C                   Eval      MsgIdArr(Idx) = 'MMA0851'
     C                   Eval      ErrorFound = 'Y'
     C                   Eval      PayDateOk = 'N'
     C                   Eval      FldNameArr(Idx) = 'SPDC'
     C                   Endif
 
      ** Amount Codes must be blank, P, F, MF, MP or A.
 
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
     C                   Eval      FldNameArr(Idx) = 'SAMC'
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
      **        Blank                 A
 
     C                   If        PPayDate = *Blanks and
     C                             PAmtCode = 'A' or
     C                             PPayDate = 'P' and
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
     C                   Eval      MsgIdArr(Idx) = 'MMA0853'
     C                   Eval      ErrorFound = 'Y'
     C                   Eval      PayDateOk = 'N'
     C                   Eval      AmtCodeOk = 'N'
     C                   Eval      FldNameArr(Idx) = 'SAMC'
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
     C                   Parm                    PayDateOk
     C                   Parm                    AmtCodeOk
     C                   Parm                    MsgIdArr
     C                   Parm                    FldNameArr
 
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
**  CPY@
(c) Finastra International Limited 2001
