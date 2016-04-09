     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL Validate Next Statement Date')                *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GLVSMDT    - Validate Next Statement Date                    *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CGL001             Date 06Aug12               *
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
      *  CGL001 - Introduction of New statement frequency 'N' (NEVER) *
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
     C                   Exsr      SrNStD
      *
      ** If an error was found, set the return code appropriately
      *
     C     DDNStDOK      IfEq      'N'
     C                   Eval      RetCodeIn = 'Error'
     C                   EndIf
      *
      ** RETURN
      *
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrNStD - Validate Next Statement Date                        *
      *****************************************************************
     C     SrNStD        BEGSR
     C/COPY WNCPYSRC,GLH00721
      *
     C     DDSTFq        IfNE      'Z'
     C     DDSTFQ        ANDNE     'N'                                                        CGL001
     C     DDNStD        AndEq     *Blanks
     C                   Move      'N'           DDNStDOk
     C                   Add       1             Idx
     C                   Movel     'DDNStD'      FldNamXAr(Idx)
     C                   Movel     'RE71103'     MsgIDXAr(Idx)
     C                   EndIf
     C/COPY WNCPYSRC,GLH00722
      *
     C     DDNStD        IfNe      *Blanks
     C                   CallB     'ZDATE1'
     C                   Parm      DDNStD        DateIn            6
     C                   Parm                    DaynoOut          5 0
     C                   Parm                    BJDFIN
     C                   Parm                    ErrorFlag         1
 
     C     ErrorFlag     IfEq      'Y'
     C     DDNStD        OrEq      '?'
     C                   Move      'N'           DDNStDOk
     C                   Add       1             Idx
     C                   Movel     'DDNStD'      FldNamXAr(Idx)
     C                   Movel     'RE71104'     MsgIDXAr(Idx)
     C                   Else
     C                   Z-ADD     DaynoOut      WWNStD
     C                   EndIf
      *
      ** DDNStD must be > or = to rundate
     C     WWNStD        IFLT      BJRDNB
     C                   Move      'N'           DDNStDOk
     C                   Add       1             Idx
     C                   Movel     'DDNStD'      FldNamXAr(Idx)
     C                   Movel     'RE71105'     MsgIDXAr(Idx)
     C                   EndIf
      *
      ** DDNStD must be > or = to account open date
     C     WWNStD        IFLT      WWDAcO
     C                   Move      'N'           DDNStDOk
     C                   Add       1             Idx
     C                   Movel     'DDNStD'      FldNamXAr(Idx)
     C                   Movel     'RE71106'     MsgIDXAr(Idx)
     C                   EndIf
      *
      ** DDNStD must be = to accrual date if DDSTFQ is 'A'
     C     DDSTFQ        IfEq      'A'
     C     WWNStD        AndNe     BKAPDT
     C                   Move      'N'           DDNStDOk
     C                   Add       1             Idx
     C                   Movel     'DDNStD'      FldNamXAr(Idx)
     C                   Movel     'RE71107'     MsgIDXAr(Idx)
     C                   EndIf
      *
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
     C                   Parm                    DDNSTD            6
     C                   Parm                    DDSTFQ            1
      *
      ** Passed from GLVACDT
     C                   Parm                    WWDACO            5 0
      *
      ** ICD
     C                   Parm                    BJRDNB            5 0
     C                   Parm                    BJDFIN            1
     C                   Parm                    BKAPDT            5 0
     C/COPY WNCPYSRC,GLH00723
      *
      ** OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    FldNamXAr
     C                   Parm                    MsgIDXAr
     C                   Parm                    MsgDtaXAr
      *
      ** Next Statement Date work field
     C                   Parm                    WWNStD            5 0
      *
      ** Next Statement Date - Ok
     C                   Parm                    DDNStDOk          1
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
(c) Misys International Banking Systems Ltd. 2001
