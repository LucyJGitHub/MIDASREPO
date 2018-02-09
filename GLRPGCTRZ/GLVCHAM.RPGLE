     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL Validate Account Charge Amount')
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GLVCHAM    - Validate Account Charge Amount                  *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. BUG12819           Date 08Dec06               *
      *                 CSD031             Date 10Apr06               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CAP035   *CREATE   Date 19Mar99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  BUG12819 - Account charge amount not updating                *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
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
 
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ** EXTERNAL DS FOR CURRENCY DETAILS
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      * SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE
 
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
 
     C                   MoveL     *Blanks       RetCodeIn
     C                   MoveL     *Blanks       FldNamXAr
     C                   MoveL     *Blanks       MsgIDXAr
     C                   MoveL     *Blanks       MsgDtaXAr
     C                   Z-Add     0             Idx
      *
      ** The field must be entered if it is subject to account charge
      *
     C     DDCHIN        IfEq      'Y'
      *
     C     DDCHAM        IfNE      *Blanks
      *
      ** Access Currency details via access program
      *  (database error handling done in access program)
     C                   CALLB     'AOCURRR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      DDCCY         @CCY              3
     C     SDCURR        PARM      SDCURR        DSSDY
      *
      **   Using ZA0840 module to validate and align amount
     C                   MOVE      *BLANK        @@ALPH
     C                   MOVE      DDCHAM        @@ALPH
     C                   Z-ADD     A6NBDP        @@IDP
     C     7             SUB       A6NBDP        @@IINT
     C                   CALLB     'ZA0840'
     C                   PARM      *BLANK        RetCodeOut
     C                   PARM                    @@ALPH           16
     C                   PARM                    @@IDP             3 0
     C                   PARM                    @@IINT            3 0
     C                   PARM      'N'           @@MTID            1
     C                   PARM      *Zero         @@ERCD            1 0
     C                   PARM      *Zero         @@AMT            15 0
     C                   PARM      '.'           BNDCSP            1
                                                                                            BUG12819
      ** Initialise Amount flag                                                             BUG12819
                                                                                            BUG12819
     C                   Move      'Y'           DDCHAMOk                                   BUG12819
                                                                                            BUG12819
      *
      **   The field is invalid in the base currency if the return code
      **   is equal to '1' or to '2'
     C     @@ERCD        IfEq      1
     C     @@ERCD        OrEq      2
     C                   Move      'N'           DDCHAMOk
     C                   Add       1             Idx
     C                   MoveL     'DDCHAM'      FldNamXAr(Idx)
     C                   MoveL     'LZW1614'     MsgIDXAr(Idx)
     C                   EndIf
      *
      ** The field can't be less then zero
     C     @@AMT         IfLT      *Zeros
     C                   Move      'N'           DDCHAMOk
     C                   Add       1             Idx
     C                   MoveL     'DDCHAM'      FldNamXAr(Idx)
     C                   MoveL     'LZW1615'     MsgIDXAr(Idx)
     C                   EndIF
      *
      **   If the amount returned by the subroutine is valid
      **   moving the amount in a work field
     C     DDCHAMOk      IfEq      'Y'
     C     DDCHAM        AndNE     *Blanks
     C                   Move      @@ALPH        DDCHAM
     C                   Z-ADD     @@AMT         WNCHAM
     C                   EndIf
      *
     C                   EndIF
     C                   EndIf
      *
      ** The field must be blank if it is not subject to account charge
     C     DDCHIN        IfNE      'Y'
     C     DDCHAM        AndNE     *Blanks
     C                   Move      'N'           DDCHAMOk
     C                   Add       1             Idx
     C                   MoveL     'DDCHAM'      FldNamXAr(Idx)
     C                   MoveL     'LZW1616'     MsgIDXAr(Idx)
     C                   EndIf
      *
      ** If an error was found, set the return code appropriately
      *
     C     DDCHAMOk      IfEq      'N'
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
     C                   Parm                    DDCHAM            8
     C                   Parm                    DDCHIN            1
     C                   Parm                    DDCCY             3
      *
      ** OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    FldNamXAr
     C                   Parm                    MsgIDXAr
     C                   Parm                    MsgDtaXAr
      *
     C                   Parm                    WNCHAM            7 0
      *
      ** Account Charge Amount - Ok
     C                   Parm                    DDCHAMOk          1
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
