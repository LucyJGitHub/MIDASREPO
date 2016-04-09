     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL Validate JE Header Number of Items')
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GLVNBIM02  - Validate Journal Batch Entry Header             *
      *               Number of Items                                 *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel.                     *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. 237512             Date 12Apr06               *
      *  Prev Amend No. 240063             Date 06Jun06               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CAP032  *CREATE    Date 26Apr99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  237512 - Validate number of items should only be done when   *
      *           GL ICD setup is equal to "Y".                       *
      *  240063 - Validate number of items should only be done when   *
      *           GL ICD setup is equal to "Y". Applied fix 237512.   *
      *  237512 - Validate number of items should only be done when   *
      *           GL ICD setup is equal to "Y".                       *
      *  CAP032 - Conversion of Journal Batch Entry inputs into       *
      *           modular structure to use as APIs.                   *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      *
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indicator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
      *
      /COPY ZACPYSRC,STD_D_SPEC
      *
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
      *
      /COPY ZACPYSRC,PSDS
      *
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the size
      ** of the arrays.
      *
      /COPY ZACPYSRC,ERR_XARRYS
      *
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
      ** Valid JE Header (DS) - for file update
     D PVBITH        E DS                  EXTNAME(GLVBITHPD)
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Index for arrays of error message ids, etc.
     D Idx             S              3P 0
      *
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ *INZSR is executed at program activation.                  ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *
     C                   Z-ADD     *ZERO         Idx
      *
     C                   Z-ADD     *ZERO         WFLD              3 0
      *
      ** Validate No. of Items.
      *
     C                   EXSR      SRProc
      *
     C     DDNoisOK      IFEQ      'N'
     C                   EVAL      RetCodeIn = 'ERROR'
     C                   ENDIF
      *
     C                   EVAL      B1HINI = WFLD
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRProc - Process No. of Items input                          *
      *                                                               *
      *****************************************************************
      *
     C     SRProc        BEGSR
      *
      ** Validate No. of Items if it has been entered.
      ** Error if it has not been entered.
      *
     C     DDNOIS        IFNE      *BLANKS
     C                   EXSR      SRItem
     C                   ELSE
      *
     C                   If        Retbkmhtn='Y'                                              237512
     C                   MOVE      'N'           DDNoisOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDNOIS'      FldNamXAr(Idx)
     C                   MOVEL     'GLX0384'     MsgIdXAr(Idx)
     C                   Endif                                                                237512
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRItem - Validate No. of Items entered                       *
      *                                                               *
      *****************************************************************
      *
     C     SRItem        BEGSR
      *
     C                   MOVE(P)   DDNOIS        ZFIELD
      *
     C                   CALLB     'ZALIGN'
     C                   PARM                    ZalignOK          1
     C                   PARM                    ZFIELD           16
     C                   PARM      *ZERO         ZADEC             1 0
     C                   PARM      3             ZADIG             2 0
      *
      ** Error if entry is not numeric.
      *
     C     ZalignOK      IFEQ      'N'
     C                   MOVE      'N'           DDNoisOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDNOIS'      FldNamXAr(Idx)
     C                   MOVEL     'GLX0212'     MsgIdXAr(Idx)
      *
     C                   ELSE
      *
      ** If entry is numeric, it must not be equal to zero.
      *
     C                   MOVE      ZFIELD        WFLD
     C     WFLD          IFEQ      *ZERO
     C     Retbkmhtn     ANDEQ     'Y'                                                        237512
     C                   MOVE      'N'           DDNoisOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDNOIS'      FldNamXAr(Idx)
     C                   MOVEL     'GLX0384'     MsgIdXAr(Idx)
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation                              *
      *         - This subroutine runs automatically for program      *
      *           initialisation.                                     *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
      *
      ** INPUT
      ** =====
      *
      ** Return code
     C                   PARM                    RetCodeIn
      *                                                                                       237512
      ** GL ICD Setup on Mandatory Parameter                                                  237512
     C                   PARM                    Retbkmhtn         1                          237512
      *
      ** No. of Items
     C                   PARM                    DDNOIS            3
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** No. of Items - OK indicator
     C                   PARM                    DDNoisOK          1
      *
      ** Valid JE Header (DS) - for file update
     C                   PARM                    PVBITH
      *
      ** Program, module and procedure names for dbase error processing
      ** ==============================================================
      ** The following /COPY sets these values.
      *
      /COPY ZACPYSRC,DBFIELDS
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
      *
      /COPY ZACPYSRC,PSSR_ILE
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
