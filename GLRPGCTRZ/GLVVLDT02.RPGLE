     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL Validate JE Item Value Date (Retail)')        *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GLVVLDT02  - Validate Journal Batch Entry Item               *
      *               Value Date (for Retail Accounts)                *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel.                     *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. MD026695           Date 12May14               *
      *  Prev Amend No. MD000091           Date 08May13               *
      *                 CRE073             Date 06Dec10               *
      *                 CRE075             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 248676             Date 29Jun07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CLE025             Date 20Oct03               *
      *                 TCA102             Date 02Apr04               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CAP032  *CREATE    Date 26Apr99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD026695 - Warning message not accurate / complete.          *
      *           - Correct the format of replacement data to display *
      *             the correct details of the warning message.       *
      *  MD000091 - Event Codes Substitution                          *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  248676 - Holiday warning displaying incorrectly.             *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  TCA102 - Various errors on Journal Entry input (Recompile).  *
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
      **    True       logical = *on (for indicator processing)
      **    False      logical = *off (for indicator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
      *
      /COPY ZACPYSRC,STD_D_SPEC
      *
      ** Program Status Data Structure
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
      ** Valid JE Item (DS) - for file update
     D PVBITP        E DS                  EXTNAME(GLVBITPPD)
      *
      ** Account details (DS)
     D F1ACCT        E DS                  EXTNAME(ACCNTAB)
     D                                     PREFIX(F1)
      *
     D WDTA            DS
     D  WVDAT                  1      6
     D  WCYCD                  7      9
     D  WLCCD                 10     12
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Index for arrays of error message ids, etc.
     D Idx             S              3P 0
      *
      ** Index for arrays of warning  message ids, etc.
     D WIx             S              3P 0
      *
      **                                                                                    MD000091
     D BChar           DS                                                                   MD000091
     D   BLen                  1      2B 0                                                  MD000091
     D   LenStr                1      2                                                     MD000091
      *                                                                                     MD000091
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
     C                   Z-ADD     *ZERO         WIx
      *
     C                   CLEAR                   WVLDT             5 0
     C                   CLEAR                   WRTCD             7
     C                   MOVEL     *BLANK        WNRFD             1
      *
      ** Validate Value Date of Retail Accounts.
      *
     C                   EXSR      SRProc
      *
     C     DDVldtOK      IFEQ      'N'
     C                   EVAL      RetCodeIn = 'ERROR'
     C                   ENDIF
      *
     C                   Z-ADD     WVLDT         B2VLDT
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRProc - Process Value Date for Retail Accounts              *
      *                                                               *
      *****************************************************************
      *
     C     SRProc        BEGSR
      *
      ** If blanks, default Value Date to rundate, then convert it
      ** to date format.
      *
     C     DDVLDT        IFEQ      *BLANKS
     C                   Z-ADD     BJRDNB        PDaynoIn
     C                   EXSR      SRDat2
     C                   ENDIF
      *
     C                   MOVEL     DDVLDT        WDATE
     C                   CALL      'GL0131U'
     C                   PARM                    WDATE             6
      *
      ** Check if entry is numeric.
      *
     C                   MOVEL     WDATE         WDATE2            7
     C                   MOVE      '0'           WDATE2
      *
     C                   TESTN                   WDATE2                 01
     C     *IN01         IFEQ      *ON
     C                   MOVEL     '0'           WDATE2
     C                   ENDIF
      *
     C                   TESTN                   WDATE2               01
     C     *IN01         IFEQ      *OFF
     C                   MOVE      'N'           DDVldtOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDVLDT'      FldNamXAr(Idx)
     C                   MOVEL     'GLX0109'     MsgIdXAr(Idx)
     C**********         MOVEL     DDVLDT        MsgDtaXAr(Idx)                             MD000091
     C                   EVAL      BLen = %Len(%Trim(DDVLDT))                               MD000091
     C                   EVAL      MsgDtaXAr(Idx) = LenStr +%TRIM(DDVLDT)                   MD000091
      *
     C                   ELSE
      *
      ** Validate Date format.
      *
     C                   EXSR      SRVFmt
      *
      ** Validate Value Date against Account Date only if Date
      ** is in valid format.
      *
     C     DDVldtOK      IFNE      'N'
     C                   EXSR      SRVAAct
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     ESRProc       ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVFmt - Validate Date format                                *
      *                                                               *
      *****************************************************************
      *
     C     SRVFmt        BEGSR
      *
     C                   MOVE      *BLANKS       WDNUM             6 0
     C                   MOVE      WDATE         WDNUM
     C                   Z-ADD     WDNUM         WDNUM2            6 0
      *
     C     WDNUM2        IFGT      30
     C                   CALLB     'ZDATE1'
     C                   PARM      WDATE         PDateIn           6
     C                   PARM                    PDaynoOut         5 0
     C                   PARM      BJDFIN        PDateFmt          1
     C                   PARM                    PError            1
      *
     C     PError        IFEQ      'Y'
     C                   MOVE      'N'           DDVldtOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDVLDT'      FldNamXAr(Idx)
     C                   MOVEL     'GLX0110'     MsgIdXAr(Idx)
     C**********         MOVEL     DDVLDT        MsgDtaXAr(Idx)                             MD000091
     C                   EVAL      BLen = %Len(%Trim(DDVLDT))                               MD000091
     C                   EVAL      MsgDtaXAr(Idx) = LenStr +%TRIM(DDVLDT)                   MD000091
      *
     C                   ELSE
      *
     C                   Z-ADD     PDaynoOut     WVLDT
      *
      ** Determine if Date is a holiday.
      *
     C                   CALLB     'ZCHKH'
     C                   PARM      WVLDT         PDateIn2          5 0
     C                   PARM      B2CYCD        PCurrency         3
     C                   PARM      PLCCD         PLocation         3
     C                   PARM      *BLANK        PHolInd           1
      *
      ** Issue warning message if Value Date is a holiday.
      *
     C     PHolInd       IFEQ      'H'
     C                   MOVE      DDVLDT        WVDAT
     C                   MOVE      B2CYCD        WCYCD
     C**********         MOVE      PLCCD         WLCCD                                        248676
     C                   MOVE      PLocation     WLCCD                                        248676
      *
     C                   MOVE      'W'           DDVldtOK
     C                   ADD       1             WIx
     C                   MOVEL     'DDVLDT'      WFldNmXAr(WIx)
     C     WLCCD         IFEQ      '   '                                                      248676
     C                   MOVEL     'GLX0430'     WMsgIdXAr(WIx)                               248676
     C                   EVAL      BLen = %Len(%Trim(WVDAT))                                MD000091
     C                   EVAL      WMsgDtXAr(WIx) = LenStr +%TRIM(WVDAT)                    MD000091
     C                   EVAL      BLen = %Len(%Trim(WCYCD))                                MD000091
     C                   EVAL      WMsgDtXAr(WIx) = %TRIM(WMsgDtXAr(WIx))                   MD000091
     C                                            + LenStr                                  MD026695
     C                                            + %TRIM(WCYCD)                            MD000091
     C                   ELSE                                                                 248676
     C                   MOVEL     'GLX0397'     WMsgIdXAr(WIx)
     C                   EVAL      BLen = %Len(%Trim(WVDAT))                                MD000091
     C                   EVAL      WMsgDtXAr(WIx) = LenStr +%TRIM(WVDAT)                    MD000091
     C                   EVAL      BLen = %Len(%Trim(WCYCD))                                MD000091
     C                   EVAL      WMsgDtXAr(WIx) = %TRIM(WMsgDtXAr(WIx))                   MD000091
     C                                            + LenStr                                  MD026695
     C                                            + %TRIM(WCYCD)                            MD000091
     C                   EVAL      BLen = %Len(%Trim(WLCCD))                                MD000091
     C                   EVAL      WMsgDtXAr(WIx) = %TRIM(WMsgDtXAr(WIx))                   MD000091
     C                                            + LenStr                                  MD026695
     C                                            + %TRIM(WLCCD)                            MD000091
     C                   ENDIF                                                                248676
     C**********         MOVEL     WDTA          WMsgDtXAr(WIx)                             MD000091
     C                   ENDIF
      *
      ** Check no. of forward days.
      *
     C     WVLDT         IFGE      BJRDNB
     C     BJRDNB        ADD       BMNDFV        WNDFV             5 0
     C     WVLDT         IFGT      WNDFV
     C                   MOVE      'N'           DDVldtOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDVLDT'      FldNamXAr(Idx)
     C                   MOVEL     'GLX0111'     MsgIdXAr(Idx)
     C**********         MOVEL     DDVLDT        MsgDtaXAr(Idx)                             MD000091
     C                   EVAL      BLen = %Len(%Trim(DDVLDT))                               MD000091
     C                   EVAL      MsgDtaXAr(Idx) = LenStr +%TRIM(DDVLDT)                   MD000091
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C                   ELSE
      *
      ** Value Date entered is less than or equal to 30,
      ** locate Local Ccy fwd days.
      *
     C                   CALLB     'ZFWDT'
     C                   PARM      BJRDNB        PInputDay         5 0
     C                   PARM      WDNUM2        PDaysFwd          2 0
     C                   PARM                    POutputDay        5 0
     C                   PARM      BJLCCY        PCurrency         3
     C                   PARM      PLCCD         PLocation         3
      *
     C                   Z-ADD     POutputDay    WVLDT
      *
      ** Convert Day number to Midas run date.
      *
     C                   Z-ADD     POutputDay    PDaynoIn
     C                   EXSR      SRDat2
      *
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDat2 - Convert Midas Day Number to Date Format             *
      *                                                               *
      *****************************************************************
      *
     C     SRDat2        BEGSR
      *
     C                   CALLB     'ZDATE2'
     C                   PARM                    PDaynoIn          5 0
     C                   PARM      BJDFIN        PDateFmt          1
     C                   PARM      *ZERO         PDateOut          6 0
     C                   PARM      *BLANKS       PZadate           7
      *
     C                   MOVE      PDateOut      DDVLDT
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVAAct- Validate Value Date against Account Date            *
      *                                                               *
      *****************************************************************
      *
     C     SRVAAct       BEGSR
      *
      ** Extract back-valuing period.
      *
     C     BJRDNB        SUB       BJBVPD        WBRUN             5 0
      *
     C     PAccount      IFEQ      '*ACID'
     C     PAccount      ANDEQ     '*NRFD'
     C     PAccount      ANDEQ     '*INVD'
     C     PAccount      ANDEQ     '*INCP'
     C                   MOVEL     'Y'           WNRFD
     C                   ENDIF
      *
     C                   SELECT
      *
      ** If CEU013 is installed, Currency is an In Ccy,
      ** Account Code type is 'Retail' and Account not
      ** found, the tests on Account Dates are skipped.
      *
     C     CEU013        WHENEQ    'Y'
     C     PINCY         ANDEQ     'Y'
     C     B2ACTY        ANDEQ     'R'
     C     WNRFD         ANDEQ     'Y'
      *
     C     F1DRIF        WHENEQ    *BLANK
     C     F1CRIF        ANDEQ     *BLANK
     C                   EXSR      SRDrCr
      *
     C     F1DRIF        WHENEQ    *BLANK
     C                   EXSR      SRCrIn
      *
     C     F1CRIF        WHENEQ    *BLANK
     C                   EXSR      SRDrIn
      *
      ** Check if Value Date is back valued (before rundate).
      *
     C     WVLDT         WHENLT    WBRUN
     C                   MOVE      '*BVLDER'     WRTCD
      *
     C                   ENDSL
      *
      ** Value Date is before the account was opened.
      *
     C     F1DACO        IFGT      WVLDT
     C                   MOVE      '*DTOPER'     WRTCD
     C                   ENDIF
      *
     C     WRTCD         IFEQ      '*DTOPER'
     C                   MOVE      'N'           DDVldtOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDVLDT'      FldNamXAr(Idx)
     C                   MOVEL     'GLX0112'     MsgIdXAr(Idx)
     C**********         MOVEL     DDVLDT        MsgDtaXAr(Idx)                             MD000091
     C                   EVAL      BLen = %Len(%Trim(DDVLDT))                               MD000091
     C                   EVAL      MsgDtaXAr(Idx) = LenStr +%TRIM(DDVLDT)                   MD000091
     C                   ENDIF
      *
     C     WRTCD         IFEQ      '*BVLDER'
     C                   MOVE      'N'           DDVldtOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDVLDT'      FldNamXAr(Idx)
     C                   MOVEL     'GLX0113'     MsgIdXAr(Idx)
     C**********         MOVEL     DDVLDT        MsgDtaXAr(Idx)                             MD000091
     C                   EVAL      BLen = %Len(%Trim(DDVLDT))                               MD000091
     C                   EVAL      MsgDtaXAr(Idx) = LenStr +%TRIM(DDVLDT)                   MD000091
     C                   ENDIF
      *
     C     WRTCD         IFEQ      '*DTCRER'
     C                   MOVE      'N'           DDVldtOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDVLDT'      FldNamXAr(Idx)
     C                   MOVEL     'GLX0114'     MsgIdXAr(Idx)
     C**********         MOVEL     DDVLDT        MsgDtaXAr(Idx)                             MD000091
     C                   EVAL      BLen = %Len(%Trim(DDVLDT))                               MD000091
     C                   EVAL      MsgDtaXAr(Idx) = LenStr +%TRIM(DDVLDT)                   MD000091
     C                   ENDIF
      *
     C     WRTCD         IFEQ      '*DTDRER'
     C                   MOVE      'N'           DDVldtOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDVLDT'      FldNamXAr(Idx)
     C                   MOVEL     'GLX0115'     MsgIdXAr(Idx)
     C**********         MOVEL     DDVLDT        MsgDtaXAr(Idx)                             MD000091
     C                   EVAL      BLen = %Len(%Trim(DDVLDT))                               MD000091
     C                   EVAL      MsgDtaXAr(Idx) = LenStr +%TRIM(DDVLDT)                   MD000091
     C                   ENDIF
      *
     C     WRTCD         IFEQ      '*DRCRER'
     C                   MOVE      'N'           DDVldtOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDVLDT'      FldNamXAr(Idx)
     C                   MOVEL     'GLX0116'     MsgIdXAr(Idx)
     C**********         MOVEL     DDVLDT        MsgDtaXAr(Idx)                             MD000091
     C                   EVAL      BLen = %Len(%Trim(DDVLDT))                               MD000091
     C                   EVAL      MsgDtaXAr(Idx) = LenStr +%TRIM(DDVLDT)                   MD000091
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDrCr - Debit and Credit Interest Bearing                   *
      *                                                               *
      *****************************************************************
      *
     C     SRDrCr        BEGSR
      *
     C     F1LDID        IFGT      F1LCID
      *
     C     WBRUN         IFLT      F1LDID
     C     WVLDT         IFLT      WBRUN
     C                   MOVE      '*DRCRER'     WRTCD
     C                   ENDIF
     C                   ELSE
     C     WVLDT         IFLE      F1LDID
     C                   MOVE      '*DRCRER'     WRTCD
     C                   ENDIF
     C                   ENDIF
      *
     C                   ELSE
      *
     C     WBRUN         IFLT      F1LCID
     C     WVLDT         IFLT      WBRUN
     C                   MOVE      '*DRCRER'     WRTCD
     C                   ENDIF
     C                   ELSE
     C     WVLDT         IFLE      F1LCID
     C                   MOVE      '*DRCRER'     WRTCD
     C                   ENDIF
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
      *  SRCrIn - Credit Interest Bearing                             *
      *                                                               *
      *****************************************************************
      *
     C     SRCrIn        BEGSR
      *
     C     F1LCID        IFGT      WBRUN
     C     WVLDT         IFLT      WBRUN
     C                   MOVE      '*DTCRER'     WRTCD
     C                   ENDIF
     C                   ELSE
     C     WVLDT         IFLE      F1LCID
     C                   MOVE      '*DTCRER'     WRTCD
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDrIn - Debit Interest Bearing                              *
      *                                                               *
      *****************************************************************
      *
     C     SRDrIn        BEGSR
      *
     C     F1LDID        IFGT      WBRUN
     C     WVLDT         IFLT      WBRUN
     C                   MOVE      '*DTDRER'     WRTCD
     C                   ENDIF
     C                   ELSE
     C     WVLDT         IFLE      F1LDID
     C                   MOVE      '*DTDRER'     WRTCD
     C                   ENDIF
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
      *
      ** Value Date
     C                   PARM                    DDVLDT            6
      *
      ** In Currency flag
     C                   PARM                    PINCY             1
      *
      ** Branch Location Code
     C                   PARM                    PLCCD             3
      *
      ** Account flag
     C                   PARM                    PAccount          5
      *
      ** Account details (DS)
     C                   PARM                    F1ACCT
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - System Rundate
     C                   PARM                    BJRDNB            5 0
      *
      ** SDBANK - Date Format
     C                   PARM                    BJDFIN            1
      *
      ** SDBANK - Local Currency Code
     C                   PARM                    BJLCCY            3
      *
      ** SDBANK - Back Value Period in Days
     C                   PARM                    BJBVPD            3 0
      *
      ** SDRETL - No. of Days Forward Value
     C                   PARM                    BMNDFV            3 0
      *
      ** SWITCHABLE FEATURES
      ** ===================
      *
      ** EMU Account Posting Narrative feature
     C                   PARM                    CEU013            1
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Warning flds/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr
      *
      ** Value Date - OK indicator
     C                   PARM                    DDVldtOK          1
      *
      ** Valid JE Item (DS) - for file update
     C                   PARM                    PVBITP
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
