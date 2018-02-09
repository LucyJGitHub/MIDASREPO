     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2015')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL Validate Interest Taxable Codes')             *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GLVITCD    - Validate Interest Taxable Codes                 *
      *                                                               *
      *  (c) Finastra International Limited 2015                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CGL165  *CREATE    Date 23Feb15               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CGL165 - Dual Withholding Tax                                *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *****************************************************************
     FSDWTRCL1  IF   E           K DISK    INFSR(*PSSR)
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
 
      ** First DS for Access Programs, Short Data Structure
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** Array of Fields in error.
     D FldNamXAr       S             10A   DIM(XArrayMax)
 
      ** Array of error message IDs
     D MsgIDXAr        S                   DIM(XArrayMax) LIKE(#MsgId)
 
      ** Array of error message data.
     D MsgDtaXAr       S                   DIM(XArrayMax) LIKE(#MsgData)
      *
      ** Array of Fields with warnings.
      *
     D WFldNmXAr       S             10A   DIM(XArrayMax)
      *
      ** Array of warning message IDs
      *
     D WMsgIdXAr       S                   DIM(XArrayMax)
     D                                     LIKE(#MsgId)
      *
      ** Array of warning message data.
      *
     D WMsgDtXAr       S                   DIM(XArrayMax)
     D                                     LIKE(#MsgData)
 
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
     D WIdx            S              3P 0
      *
     D PRtCd           S              7A
     D POptn           S              7A
     D PSard           S              6A
     D PAcHlF          S              1A
 
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
 
     C                   MoveL     *Blanks       RetCodeIn
     C                   MoveL     *Blanks       FldNamXAr
     C                   MoveL     *Blanks       MsgIDXAr
     C                   MoveL     *Blanks       MsgDtaXAr
     C                   MOVEL     *BLANKS       WFldNmXAr
     C                   MOVEL     *BLANKS       WMsgIdXAr
     C                   MOVEL     *BLANKS       WMsgDtXAr
      *
     C                   Z-Add     0             Idx
      *
     C                   EVAL      WIdx = 0
      *
      ** If account is taxable Main Tax Code is mandatory
B1   C     DDITAX        IfEQ      'Y'
     C
B2   C     DDTXC1        IfEq      *Blanks
     C                   Move      'N'           DDTXC1Ok
     C                   Add       1             Idx
     C                   MoveL     'DDTXC1'      FldNamXAr(Idx)
     C                   MoveL     '5047561'     MsgIDXAr(Idx)
      **
      ** If Main Tax Code is blank, should be no entry in Secondary Tax Code
B3   C     DDTXC2        IfNe      *Blanks
     C                   Move      'N'           DDTXC2Ok
     C                   Add       1             Idx
     C                   MoveL     'DDTXC2'      FldNamXAr(Idx)
     C                   MoveL     '5047565'     MsgIDXAr(Idx)
E3   C                   EndIf
      *
X2   C                   Else
      **
      ** Tax Code must be valid tax code
     C     DDTXC1        Chain     SDWTRCD0
B3   C                   IF        NOT %FOUND(SDWTRCL1)
     C                   Move      'N'           DDTXC1Ok
     C                   Add       1             Idx
     C                   MoveL     'DDTXC1'      FldNamXAr(Idx)
     C                   MoveL     '5047562'     MsgIDXAr(Idx)
X3   C                   Else
      **
      ** Tax Code must be valid for the account currency
B4   C                   If        CYCD <> *Blanks
     C                             AND CYCD <> DDCCY
     C                   Move      'N'           DDTXC1Ok
     C                   Add       1             Idx
     C                   MoveL     'DDTXC1'      FldNamXAr(Idx)
     C                   MoveL     '5047563'     MsgIDXAr(Idx)
E4   C                   EndIf
E3   C                   EndIf
E2   C                   EndIf
      *
B2   C     DDTXC2        IfNe      *Blanks
      *
      * Must not be the same as Main Tax code
B3   C     DDTXC2        IfEq      DDTXC1
     C                   Move      'N'           DDTXC2Ok
     C                   Add       1             Idx
     C                   MoveL     'DDTXC2'      FldNamXAr(Idx)
     C                   MoveL     '5047566'     MsgIDXAr(Idx)
     C                   Else
      *
     C     DDTXC2        Chain     SDWTRCD0
B3   C                   IF        NOT %FOUND(SDWTRCL1)
     C                   Move      'N'           DDTXC2Ok
     C                   Add       1             Idx
     C                   MoveL     'DDTXC2'      FldNamXAr(Idx)
     C                   MoveL     '5047562'     MsgIDXAr(Idx)
X3   C                   Else
      **
      ** Tax Code must be valid for the account currency
B4   C                   If        CYCD <> *Blanks
     C                             AND CYCD <> DDCCY
     C                   Move      'N'           DDTXC2Ok
     C                   Add       1             Idx
     C                   MoveL     'DDTXC2'      FldNamXAr(Idx)
     C                   MoveL     '5047563'     MsgIDXAr(Idx)
E4   C                   EndIf
E3   C                   Endif
E2   C                   Endif
E2   C                   Endif
      *
      ** If Account not taxable should be no entry made
X1   C                   Else
B2   C     DDTXC1        IfNe      *Blanks
     C                   Move      'N'           DDTXC1Ok
     C                   Add       1             Idx
     C                   MoveL     'DDTXC1'      FldNamXAr(Idx)
     C                   MoveL     '5047564'     MsgIDXAr(Idx)
E2   C                   Endif
B2   C     DDTXC2        IfNe      *Blanks
     C                   Move      'N'           DDTXC2Ok
     C                   Add       1             Idx
     C                   MoveL     'DDTXC2'      FldNamXAr(Idx)
     C                   MoveL     '5047564'     MsgIDXAr(Idx)
E2   C                   Endif
E1   C                   Endif
      *
      ** If an error was found, set the return code appropriately
      *
     C     DDTXC1Ok      IfEq      'N'
     C     DDTXC2Ok      OrEq      'N'
     C                   Eval      RetCodeIn = 'Error'
     C                   EndIf
      *
      ** RETURN
      *
     C                   RETURN
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
     C                   Parm                    DDITAX            1
     C                   Parm                    DDTXC1            2
     C                   Parm                    DDTXC2            2
     C                   Parm                    DDCCY             3
      *
      ** OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    FldNamXAr
     C                   Parm                    MsgIDXAr
     C                   Parm                    MsgDtaXAr
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIdXAr
     C                   PARM                    WMsgDtXAr
      *
      ** Taxable Codes - OK
     C                   Parm                    DDTXC1Ok          1
     C                   Parm                    DDTXC2Ok          1
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
(c) Finastra International Limited 2015
