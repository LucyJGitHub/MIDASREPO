     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FX Validate CLS Amount')
      *****************************************************************
      *                                                               *
      *  Midas - Common Validation Routine                            *
      *                                                               *
      *  FXVCLSAMT - Validate Amount                                  *
      *              (for CLS Pay-in Schedule)                        *
      *                                                               *
      *  Function:  This module receives a parameter containing the   *
      *             CLS Pay-in Amount and confirms if valid.          *
      *             If it is valid then 10A return code will be       *
      *             blank; if it is not it will contain 'Error'       *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.04 -----------------------------------------------*
      *  Prev Amend No. 186669             Date 20Nov00               *
      *                 CDL008  *CREATE    Date 02May00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  186669 - Last digit/s are erroneously truncated;             *
      *           incorrect value for Number of decimal places        *
      *  CDL008 - Continuous Linked Settlement                        *
      *                                                               *
      *****************************************************************
 
      *****************************************************************
      ** +----------------------------+
      ** ¦ Manually Included F-Specs  ¦
      ** ¦ =========================  ¦
      ** +----------------------------+
      **
      ** +-----------------------------------+
      ** ¦ End of Manually Included F-Specs  ¦
      ** ¦ ================================  ¦
      ** +-----------------------------------+
      **
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
 
      ** Include the MM standard declares
     D/COPY ZACPYSRC,STDDECLARE
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
      ** Program, procedure and module names for parameters
      ** ==================================================
 
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
 
     D INFDS           DS
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** CLS Pay-in amount received as a parameter
     D @CLSAMT         S             18A
 
      ** Action Code received as a paramater
     D @CLSACT         S              1A
 
      ** Currency number of decimal places (from SDCURRPD)
      ** received as a parameter
     D A6NBDP          S              1S 0
 
      ** Decimal separator
     D BNDCSP          S              1A
 
      ** Index of errors accumulated from previous modules
      ** received as a parameter
     D Idx             S              3  0
 
      ** CLS Amount passed as a parameter
     D @PYAMT          S             17  0
 
      ** Fields used in call to Module ZA0840
 
      ** Alpha field for numeric validation
     D @@ALPH          S             16A
      ** Millions/Thousands id (Y=function on)
     D @@MTID          S              1A
      ** Amount calculation field
     D @@AMT           S             15  0
      ** Error code
     D @@ERCD          S              1  0
      ** Number of decimal places
     D @@IDP           S              3  0
      ** Number of integers
     D @@IINT          S              3  0
 
      ** First two characters for the @CLSAMT field                                           186669
     D W1stTwo         S              2A                                                      186669
                                                                                              186669
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
 
     C                   MOVE      *BLANK        RetCodeIn
 
     C                   MOVE      *BLANK        FldNamXAr
     C                   MOVE      *BLANK        MsgIDXAr
     C                   MOVE      *BLANK        MsgDtaXAr
     C                   Z-ADD     0             Idx
      *
      *  *-----------------*
      *  * Validate Amount *
      *  *-----------------*
      *
     C     @CLSAMT       IFNE      *BLANK
      *
      ** Verify that the amount entered is valid numeric.
      *
     C                   Z-ADD     A6NBDP        @@IDP
     C     15            SUB       A6NBDP        @@IINT
     C                   MOVE      *BLANKS       @@ALPH
     C                   MOVEL     @CLSAMT       W1stTwo                                      186669
     C                   IF        W1stTwo = *BLANKS                                          186669
     C                   MOVE      @CLSAMT       @@ALPH                                       186669
     C                   ELSE                                                                 186669
     C                   EVAL      @@ALPH = @CLSAMT
     C                   ENDIF                                                                186669
     C                   MOVE      'Y'           @@MTID            1
     C                   CALLB     'ZA0840'
     C                   PARM                    RetCodeIn
     C                   PARM                    @@ALPH
     C                   PARM                    @@IDP
     C                   PARM                    @@IINT
     C                   PARM                    @@MTID
     C                   PARM                    @@Ercd
     C                   PARM                    @@Amt
     C                   PARM                    BNDCSP
      *
     C     @@Ercd        IFNE      0
     C                   MOVE      'N'           CLSAMTOK
     C                   ADD       1             Idx
     C                   MOVEL     @CLSAMT       FldNamXAr(Idx)
     C                   MOVEL     'FXM3031'     MsgIdXAr(Idx)
     C                   ENDIF
      *
      ** If the amount is valid, set up the numeric amount for output
      *
     C     Idx           IFEQ      0
     C     @CLSAMT       IFNE      *BLANK
     C                   Z-ADD     @@Amt         @PYAMT
     C                   MOVE      *BLANKS       @CLSAMT
     C                   EVAL      %SUBST(@CLSAMT:2:16) = @@ALPH
     C                   ELSE
     C                   Z-ADD     *ZERO         @PYAMT
     C                   ENDIF
     C                   ENDIF
     C                   ELSE
     C                   MOVE      'N'           CLSAMTOK
     C                   ADD       1             Idx
     C                   MOVEL     @CLSAMT       FldNamXAr(Idx)
     C                   MOVEL     'FXM3024'     MsgIdXAr(Idx)
     C                   ENDIF
      *
     C                   IF        CLSAMTOK  = 'N'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
      *
     C                   RETURN
 
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *entry        PLIST
     C                   PARM                    RetCodeIn
     C                   PARM                    @CLSAMT
     C                   PARM                    A6NBDP
     C                   PARM                    BNDCSP
      *
      * Error fields/message IDs/message data (arrays) from/to caller
      *
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
     C                   PARM                    @PYAMT
     C                   PARM                    CLSAMTOK          1
 
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
