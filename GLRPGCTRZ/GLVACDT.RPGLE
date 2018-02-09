     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL Validate Date Account Opened')
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GLVACDT    - Validate Date Account Opened                    *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.02 -----------------------------------------------*
      *  Prev Amend No. CAP035  *CREATE    Date 19Mar99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CAP035 - Midas/ToF Interface                                 *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
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
 
      ** Initialization
 
     C                   Movel     *Blanks       RetCodeIn
     C                   Movel     *Blanks       FldNamXAr
     C                   Movel     *Blanks       MsgIDXAr
     C                   Movel     *Blanks       MsgDtaXAr
     C                   Z-add     0             Idx
      *
     C     DDActn        IfEq      'I'
     C                   Exsr      SrDAcO
     C                   EndIf
      *
      ** If an error was found, set the return code appropriately
      *
     C     DDDAcOOK      IfEq      'N'
     C                   Eval      RetCodeIn = 'Error'
     C                   EndIf
      *
      ** RETURN
      *
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrDAcO - Validate Date Account Oppened                       *
      *****************************************************************
     C     SrDAcO        BEGSR
      *
     C     DDDAcO        Ifeq      *Blanks
     C                   CallB     'ZDATE2'
     C                   Parm      BJRDNB        ZDAYNO            5 0
     C                   Parm                    BJDFIN
     C                   Parm      0             ZDATE             6 0
     C                   Parm      *Blanks       ZADATE            7
      *
     C                   Move      ZDATE         DDDAcO
     C                   Z-add     BJRDNB        WWDACO            5 0
      *
     C                   ELSE
      *
     C                   CallB     'ZDATE1'
     C                   Parm      DDDAcO        DateIn            6
     C                   Parm      *Zero         DaynoOut          5 0
     C                   Parm                    BJDFIN
     C                   Parm                    ErrorFlag         1
      *
     C     ErrorFlag     IfEq      'Y'
     C                   Move      'N'           DDDAcOOk
     C                   Add       1             Idx
     C                   Movel     'DDDAcO'      FldNamXAr(Idx)
     C                   Movel     'RE71101'     MsgIDXAr(Idx)
     C                   Else
     C                   Z-ADD     DaynoOut      WWDACO
     C                   EndIf
      *
      ** DDDACO must be < or = to rundate
     C     WWDACO        IFGT      BJRDNB
     C                   Move      'N'           DDDAcOOk
     C                   Add       1             Idx
     C                   Movel     'DDDAcO'      FldNamXAr(Idx)
     C                   Movel     'RE71102'     MsgIDXAr(Idx)
     C                   EndIf
      *
      ** DDDACO Must be > or = to rundate - back value period
     C     BJRDNB        Sub       BJBVPD        BACKVA            5 0
     C*
     C     WWDACO        IfLT      BACKVA
     C                   Move      'N'           DDDAcOOk
     C                   Add       1             Idx
     C                   Movel     'DDDAcO'      FldNamXAr(Idx)
     C                   Movel     'RE71119'     MsgIDXAr(Idx)
     C                   EndIf
     C                   EndIf
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *Entry        Plist
      *
      ** INPUTS
      *
      ** Return Code
     C                   Parm                    RetCodeIn
      *
      ** Account Screen fields
     C                   Parm                    DDACTN            1
     C                   Parm                    DDDACO            6
      *
      ** ICD
     C                   Parm                    BJRDNB            5 0
     C                   Parm                    BJDFIN            1
     C                   Parm                    BJBVPD            3 0
      *
      ** OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    FldNamXAr
     C                   Parm                    MsgIDXAr
     C                   Parm                    MsgDtaXAr
      *
      ** Date Account Open work field
     C                   Parm                    WWDAcO            5 0
      *
      ** Date Account Open - Ok
     C                   Parm                    DDDAcOOk          1
      *
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR                                                  *** InzEnd ***
      *****************************************************************
      /EJECT
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
