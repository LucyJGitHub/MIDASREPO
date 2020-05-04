     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL Validate JE Header Batch Total')
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GLVBCTO    - Validate Journal Batch Entry Header             *
      *               Batch Totals                                    *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel.                     *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. MD055030           Date 27Apr20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Prev Amend No. 247277             Date 24May07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 237512 (Reopen)    Date 22May06               *
      *                 240063             Date 06Jun06               *
      *                 BUG2605            Date 14Sep04               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CAP032  *CREATE    Date 26Apr99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD055030 - Issue on job names during SSL enabling of JDBC    *
      *              calls (Child: AR1088820)                         *
      *           - Applied for MD055645.                             *
      *  MD046248 - Finastra Rebranding                               *
      *  247277 - Allow for native JDBC driver as well as toolbox.    *
      *  237512 - Initialise DDFNAM to blank.                         *
      *  240063 - Initialise DDFNAM to blank. Applied fix 237512.     *
      *  237512 - Initialise DDFNAM to blank.                         *
      *  BUG2605- Convert a lower case letter in the amount field     *
      *           from MidasPlus to upper case for validation         *
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
      ** DS to get the first 3 decimal positions from
      ** the converted amount.
     D                 DS
     D WDEC3                   1      3  0
     D WDEC                    1      9  9
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Index for arrays of error message ids, etc.
     D Idx             S              3P 0
      *
      ** Default batch total
     D*WFMAM****       S             23A   INZ('999,999,999,999,999.999')                     237512
     D WFMAM           S             23A   INZ('                       ')                     237512
      *                                                                                      BUG2605
      ** Integer to hold position of lower case letter in amount field                       BUG2605
     D LowT            S              1  0                                                   BUG2605
     D LowM            S              1  0                                                   BUG2605
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
     C                   MOVE      *BLANKS       PDATA
      *
     C                   Z-ADD     *ZERO         PINT
     C                   Z-ADD     *ZERO         WDEC3
      *
      ** Validate Batch Totals.
      *
     C                   EXSR      SRProc
      *
     C     DDFmamOK      IFEQ      'N'
     C                   EVAL      RetCodeIn = 'ERROR'
     C                   ENDIF
      *
     C                   EVAL      B1HIIN = PINT
     C                   EVAL      B1HDIN = WDEC3
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRProc - Process Batch Total input                           *
      *                                                               *
      *****************************************************************
      *
     C     SRProc        BEGSR
      *
      ** Error if no entry has been entered and entry is
      ** mandatory.
      *
     C     DDFMAM        IFEQ      *BLANKS
     C     BKMHTN        ANDEQ     'Y'
     C                   MOVE      'N'           DDFmamOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDFMAM'      FldNamXAr(Idx)
     C                   MOVEL     'GLX0385'     MsgIdXAr(Idx)
      *
     C                   goto      ESRProc
     C                   ENDIF
      *
      ** If entry is blanks and entry is not mandatory, default
      ** it to 999,999,999,999,999.999.
      *
     C     DDFMAM        IFEQ      *BLANKS
     C                   MOVE      WFMAM         DDFMAM
     C                   ENDIF
                                                                                             BUG2605
      * Replace lower case values from MidasPlus with upper case values                      BUG2605
     C*******            If        PsJobName = 'QZDASOINIT'                           BUG2605 247277
     C                   If        PsJobName = 'QZDASOINIT' OR                                247277
     C                             PsJobName = 'QZDASSINIT' OR                              MD055030
     C                             PsJobName = 'QSQSRVR'                                      247277
      *                                                                                       247277
     C                   Eval      LowT = %scan('t':DDFMAM)                                  BUG2605
     C                   Eval      LowM = %scan('m':DDFMAM)                                  BUG2605
                                                                                             BUG2605
     C                   If        LowT > 0                                                  BUG2605
     C                   Eval      DDFMAM = %replace('T':DDFMAM:LowT:1)                      BUG2605
     C                   EndIf                                                               BUG2605
     C                   If        LowM > 0                                                  BUG2605
     C                   Eval      DDFMAM = %replace('M':DDFMAM:LowM:1)                      BUG2605
     C                   EndIf                                                               BUG2605
                                                                                             BUG2605
     C                   EndIf                                                               BUG2605
                                                                                             BUG2605
      *
      ** Convert batch total to numeric format.
      *
     C                   MOVE      DDFMAM        PDATA
     C                   CALL      'GL0139U'
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM                    PDATA            32
     C                   PARM                    PINT             15 0
     C     WDEC          PARM                    PDEC              9 9
      *
     C     PRTCD         IFNE      *BLANKS
     C                   MOVE      'N'           DDFmamOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDFMAM'      FldNamXAr(Idx)
     C                   MOVEL     'GLX0064'     MsgIdXAr(Idx)
     C                   ENDIF
      *
      ** Error if entry is zero and entry is mandatory.
      *
     C     DDFmamOK      IFEQ      'Y'
     C     BKMHTN        ANDEQ     'Y'
     C     PINT          ANDEQ     *ZERO
     C     WDEC3         ANDEQ     *ZERO
     C                   MOVE      'N'           DDFmamOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDFMAM'      FldNamXAr(Idx)
     C                   MOVEL     'GLX0385'     MsgIdXAr(Idx)
     C                   ENDIF
      *
     C     ESRProc       ENDSR
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
      *
      ** Batch Total
     C                   PARM                    DDFMAM           23
      *
      ** STANDING DATA
      ** =============
      *
      ** SDGELR - Mandatory Batch No./ No. of Items
     C                   PARM                    BKMHTN            1
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Batch Total - OK indicator
     C                   PARM                    DDFmamOK          1
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
(c) Finastra International Limited 2001
