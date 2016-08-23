     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL Validate JE Header Department Code')
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GLVDOCD    - Validate Journal Batch Entry Header             *
      *               Department Code                                 *
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
      *  Last Amend No. 240080             Date 24May06               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.02 -----------------------------------------------*
      *  Prev Amend No. CAP032  *CREATE    Date 26Apr99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  240080 - Default department code from user definiton when    *
      *           left blanks during input.                           *
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
      ** Error message array
     D WMsgArr         S             45    DIM(1) CTDATA PERRCD(1)
      *
      ** Valid JE Header (DS) - for file update
     D PVBITH        E DS                  EXTNAME(GLVBITHPD)
      *
      ** Externally described DS for Department Code Details
     D SDDEPT        E DS                  EXTNAME(SDDEPTPD)
      *
      ** DS for Acess Programs - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
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
      ** Validate Department Code.
      *
     C                   EXSR      SRProc
      *
     C     DDDpcdOK      IFEQ      'N'
     C                   EVAL      RetCodeIn = 'ERROR'
     C                   ENDIF
      *
     C                   EVAL      B1DPCD = DDDPCD
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRProc - Process Department Code Input                       *
      *                                                               *
      *****************************************************************
      *
     C     SRProc        BEGSR
      *                                                                                       240080
     C     DDDPCD        IFEQ      *BLANKS                                                    240080
     C                   MOVE      WDppt         DDDPCD                                       240080
     C                   ENDIF                                                                240080
      *
      ** Verify if question mark has been entered.
      *
     C     '?'           SCAN      DDDPCD                                 01
      *
     C                   SELECT
      *
      ** Department Code should not be blanks.
      *
     C*****DDDPCD        WHENEQ    *BLANKS                                                    240080
     C***********        MOVE      'N'           DDDpcdOK                                     240080
     C***********        ADD       1             Idx                                          240080
     C***********        MOVEL     'DDDPCD'      FldNamXAr(Idx)                               240080
     C***********        MOVEL     'GLX0211'     MsgIdXAr(Idx)                                240080
      *
      ** Error if question mark has been entered.
      *
     C     *IN01         WHENEQ    *ON
     C                   MOVE      'N'           DDDpcdOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDDPCD'      FldNamXAr(Idx)
     C                   MOVEL     'GLX0999'     MsgIdXAr(Idx)
     C                   MOVEL     WMsgArr(1)    MsgDtaXAr(Idx)
      *
      ** If not blank and not question mark, access Department
      ** Codes file.
      *
     C                   OTHER
     C                   CALL      'AODEPTR0'
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM      '*KEY'        POPTN             7
     C                   PARM      DDDPCD        PDPCD             3
     C     SDDEPT        PARM      SDDEPT        DSFDY
      *
     C     PRTCD         IFNE      *BLANKS
     C                   MOVE      'N'           DDDpcdOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDDPCD'      FldNamXAr(Idx)
     C                   MOVEL     'GLX0044'     MsgIdXAr(Idx)
     C                   ENDIF
      *
     C                   ENDSL
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
      ** Return Code
     C                   PARM                    RetCodeIn
      *
      ** Department Code
     C                   PARM                    DDDPCD            3
     C                   PARM                    WDppt             3                          240080
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Department Code - OK indicator
     C                   PARM                    DDDpcdOK          1
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
** WMsgArr
Invalid department code.
