     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL Validate Highest OD Commission')
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GLVCMCM02  - Validate Highest OD Commission                  *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. BUG3890            Date 30Mar05               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.02 -----------------------------------------------*
      *  Prev Amend No. CAP035  *CREATE    Date 19Mar99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  BUG3890- Should issue error when field not to be used.       *
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
 
     D CEX             S              1    DIM(15)
 
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
     D Idx1            S              2P 0
 
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
     C                   Z-Add     1             Idx1
      *
      ** CHECK IF COMMISSION ON HIGHEST OVERDRAFT PRESENT
      *
     C     CHOV          IFEQ      'Y'
     C     WMDBI         IFEQ      'N'
      *
      ** FIELDS CAN BE FILL ONLY IF COMMISSION IS APPLICABLE
      *
     C     DDCEXA        IFNE      *BLANKS
     C                   Move      'N'           DDCEXAOk
     C                   Add       1             Idx
     C                   MoveL     'DDCEXA'      FldNamXAr(Idx)
     C                   MoveL     'RE71400'     MsgIDXAr(Idx)
     C                   ENDIF
     C                   ELSE
      *
      ** IF COMMISSION IS ACTIVE CHECK IF THERE IS ONE FOR THE ACCOUNT
      *
     C     DDCEXA        IFNE      *BLANKS
      *
      ** CHECK IF EXEMPT OR NOT
      *
     C                   MOVEA     DDCEXA        CEX
     C     CEX(Idx1)     DOWNE     'E'
     C     Idx1          ANDLE     11
     C                   ADD       1             Idx1
     C                   ENDDO
     C     CEX(Idx1)     IFEQ      'E'
     C                   MOVE      ' '           CEX(Idx1)
     C                   MOVE      'E'           CEX(1)
     C                   MOVEA     CEX           DDCEXA
     C                   MOVE      *BLANKS       COCEXA
     C                   MOVEL     'E'           COCEXA
     C                   ELSE
      *
      ** IF THERE IS A RATE CHECK IF IT IS RIGHT
      *
     C                   Move      *Blanks       ZField
     C                   CallB     'ZALIGN'
     C                   Parm                    ZAlignOk          1
     C                   Parm      DDCEXA        ZField           16
     C                   Parm      8             ZADec             1 0
     C                   Parm      2             ZADig             2 0
     C     ZAlignOk      IFEQ      'N'
     C                   Move      'N'           DDCEXAOk
     C                   Add       1             Idx
     C                   MoveL     'DDCEXA'      FldNamXAr(Idx)
     C                   MoveL     'RE71203'     MsgIDXAr(Idx)
     C                   ELSE
     C                   MOVE      ZFIELD        COCEXA
     C                   ENDIF
     C                   ENDIF
     C                   ELSE
     C                   MOVE      *BLANKS       COCEXA
     C                   ENDIF
     C                   ENDIF
     C                   ELSE                                                                BUG3890
      *                                                                                      BUG3890
      ** FIELDS CAN BE FILL ONLY IF COMMISSION IS APPLICABLE                                 BUG3890
      *                                                                                      BUG3890
     C     DDCEXA        IFNE      *BLANKS                                                   BUG3890
     C                   Move      'N'           DDCEXAOk                                    BUG3890
     C                   Add       1             Idx                                         BUG3890
     C                   MoveL     'DDCEXA'      FldNamXAr(Idx)                              BUG3890
     C                   MoveL     'RE71400'     MsgIDXAr(Idx)                               BUG3890
     C                   ENDIF                                                               BUG3890
     C                   ENDIF
      *
      ** If an error was found, set the return code appropriately
      *
     C     DDCEXAOk      IfEq      'N'
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
     C                   Parm                    DDCEXA           11
     C                   Parm                    WMDBI             1
      *
      ** ICD
     C                   Parm                    CHOV              1
      *
      ** OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    FldNamXAr
     C                   Parm                    MsgIDXAr
     C                   Parm                    MsgDtaXAr
      *
     C                   Parm                    COCEXA           10
      *
      ** Highest OD Commission - Ok
     C                   Parm                    DDCEXAOk          1
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
