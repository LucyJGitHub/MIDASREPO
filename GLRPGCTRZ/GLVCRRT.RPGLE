     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL Validate Credit Rate/Spread & Sign')
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GLVCRRT    - Validate Credit Rate/Spread and Sign            *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. BUG5525            Date 26Jan05               *
      *  Prev Amend No. BUG4859            Date 15Nov04               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CAP035  *CREATE    Date 19Mar99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  BUG5525 - Validation of CR interest calculation type/subtype *
      *            is incorrect.  If spread rate has been inserted,   *
      *            CR interest calculation type/subtype should not be *
      *            inserted and vice versa.                           *
      *  BUG4859 - Credit interest rate sign now defaults to '+',     *
      *            blank is no longer allowed.                        *
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
 
     C                   MoveL     *Blanks       RetCodeIn
     C                   MoveL     *Blanks       FldNamXAr
     C                   MoveL     *Blanks       MsgIDXAr
     C                   MoveL     *Blanks       MsgDtaXAr
     C                   Z-Add     0             Idx
      *
     C                   ExSr      SrVRate
      *
     C                   ExSr      SrVSign
      *
      ** If an error was found, set the return code appropriately
      *
     C     DDCRISOk      IfEq      'N'
     C     DDCSIGOk      OrEq      'N'
     C                   Eval      RetCodeIn = 'Error'
     C                   EndIf
      *
      ** RETURN
      *
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrVRate - Validate Rate/Spread                               *
      *****************************************************************
     C     SRVRATE       BEGSR
      *
     C     DDCRIS        IFNE      *BLANKS
     C*****DDCSIG        ORNE      *BLANKS                                                   BUG5525
      *
     C     DDCICT        IFNE      *BLANKS
     C     DDCCST        ORNE      *BLANKS
     C                   Move      'N'           DDCRISOk
     C                   Add       1             Idx
     C                   MoveL     'DDCRIS'      FldNamXAr(Idx)
     C                   MoveL     'RE71301'     MsgIDXAr(Idx)
      *
     C                   ELSE
      *
     C                   CallB     'ZALIGN'
     C                   Parm                    ZAlignOk          1
     C                   Parm      DDCRIS        ZField           16
     C                   Parm      7             ZADec             1 0
     C                   Parm      4             ZADig             2 0
      *
     C     ZAlignOk      IFEQ      'N'
     C                   Move      'N'           DDCRISOk
     C                   Add       1             Idx
     C                   MoveL     'DDCRIS'      FldNamXAr(Idx)
     C                   MoveL     'RE71302'     MsgIDXAr(Idx)
     C                   Else
     C                   Move      ZField        AMCRIS
     C                   ENDIF
     C                   ENDIF
      *
     C                   Else
     C                   Z-ADD     *Zero         AMCRIS
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrVSign - Validate Rate/Spread Sign                          *
      *****************************************************************
     C     SRVSIGN       BEGSR
      *
     C     DDCSIG        IFNE      *BLANK
      *
      * A rate spread is always now defaulted in and cant be removed.                        BUG4859
     C*****DDCRIS        IFEQ      *BLANKS                                                   BUG4859
     C**********         Move      'N'           DDCSIGOk                                    BUG4859
     C**********         Add       1             Idx                                         BUG4859
     C**********         MoveL     'DDCSIG'      FldNamXAr(Idx)                              BUG4859
     C**********         MoveL     'RE71303'     MsgIDXAr(Idx)                               BUG4859
     C**********         ENDIF                                                               BUG4859
      *
     C     DDCRIS        IFNE      *BLANKS                                                   BUG5525
      *                                                                                      BUG5525
     C     DDCICT        IFNE      *BLANKS
     C     DDCCST        ORNE      *BLANKS
     C                   Move      'N'           DDCSIGOk
     C                   Add       1             Idx
     C                   MoveL     'DDCSIG'      FldNamXAr(Idx)
     C                   MoveL     'RE71301'     MsgIDXAr(Idx)
     C                   ENDIF
     C                   ENDIF                                                               BUG5525
      *
     C     DDCSIG        IFNE      '+'
     C     DDCSIG        ANDNE     '-'
     C                   Move      'N'           DDCSIGOk
     C                   Add       1             Idx
     C                   MoveL     'DDCSIG'      FldNamXAr(Idx)
     C                   MoveL     'RE71304'     MsgIDXAr(Idx)
     C                   ENDIF
      *
     C                   ELSE
      *
     C     DDCRIS        IFNE      *BLANK
     C                   MOVE      '+'           DDCSIG
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     DDCSIG        IFEQ      '-'
     C     AMCRIS        ANDNE     *ZEROS
     C                   Z-SUB     AMCRIS        AMCRIS
     C                   ENDIF
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
     C                   Parm                    DDCRIS           12
     C                   Parm                    DDCSIG            1
     C                   Parm                    DDCICT            2
     C                   Parm                    DDCCST            5
      *
      ** OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    FldNamXAr
     C                   Parm                    MsgIDXAr
     C                   Parm                    MsgDtaXAr
      *
     C                   Parm                    AMCRIS           11 7
      *
      ** Rate/Spread - OK
      ** Rate/Spread Sign - OK
     C                   Parm                    DDCRISOk          1
     C                   Parm                    DDCSIGOk          1
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
