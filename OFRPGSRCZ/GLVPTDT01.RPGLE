     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2013')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas OF Validate JE Item Posting Date')               *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GLVPTDT01  - Validate Journal Batch Entry Item               *
      *               Posting Date                                    *
      *                                                               *
      *  (c) Finastra International Limited 2013                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 MD032379           Date 15Jul15               *
      *                 CGL135A  *CREATE   Date 10Jul13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *  MD046248 - Finastra Rebranding                               *
      *  MD032379 - Correct posting date validation for non-working   *
      *             day.                                              *
      *  CGL135A - Accounting Rules Process                           *
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
      *
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
      ** Account details (DS)
     D F1ACCT        E DS                  EXTNAME(ACCNTAB)
     D                                     PREFIX(F1)
      *
      ** Valid JE Item (DS) - for file update
     D PVBITP        E DS                  EXTNAME(GLVBITPPD)
      *
      ** JE Posting Date Valid File
     D VExtPostD     E DS                  EXTNAME(GLJENP1D)
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Index for arrays of error message ids, etc.
     D Idx             S              3P 0
      *
     D WVLDT           S              5S 0
      *
     D DDVLDT          S              6A
     D D#PSDN          S              6A
     D D#PSDNOk        S              1A
      *
      ** External DS for Bank Details                                                       MD032379
     D SDBANK        E DS                  EXTNAME(SDBANKPD)                                MD032379
     D                                     PREFIX(AO_)                                      MD032379
                                                                                            MD032379
      **  Short DS for access programs                                                      MD032379
     D DSFDY         E DS                  EXTNAME(DSFDY)                                   MD032379
      *                                                                                     MD032379
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
     C                   Z-ADD     *ZERO         WVLDT
     C                   EVAL      D#PSDNOk = 'Y'
      *
      ** Validate Posting Date
      *
     C                   EXSR      SRProc
      *
     C     D#PSDNOk      IFEQ      'N'
     C                   EVAL      RetCodeIn = 'ERROR'
     C                   ENDIF
      *
     C                   Z-ADD     WVLDT         BEPSDN
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRProc - Validate Posting Date Format                        *
      *                                                               *
      *****************************************************************
      *
     C     SRProc        BEGSR
      *
     C     D#PSDN        IFEQ      *BLANKS
     C                   Z-ADD     BJRDNB        WVLDT
     C                   EVAL      ZDAYNO = WVLDT
     C                   EXSR      ZDATE2
     C                   EVAL      D#PSDN = *BLANKS
     C                   MOVEL     ZDATE         D#PSDN
     C                   ELSE
      *
      ** Verify if entry is numeric.
      *
     C                   EXSR      SRValNum
     C                   ENDIF
      *
      ** If entry is numeric and is in valid format, perform
      ** Postin Date Validation
      *
     C     D#PSDNOk      IFEQ      'Y'
     C                   EXSR      SRValPdt
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValNum - Validate if Entry is numeric                      *
      *                                                               *
      *****************************************************************
      *
     C     SRValNum      BEGSR
      *
     C                   MOVEL     D#PSDN        WDATE
     C                   CALL      'GL0131U'
     C                   PARM                    WDATE             6
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
     C                   MOVE      'N'           D#PSDNOk
     C                   ADD       1             Idx
     C                   MOVEL     'DDPSDN'      FldNamXAr(Idx)
     C                   MOVEL     '5046128'     MsgIdXAr(Idx)
     C                   MOVEL     D#PSDN        MsgDtaXAr(Idx)
      *
     C                   ELSE
      *
      ** If entry is numeric, check if in valid date format.
      *
     C                   MOVE      *BLANKS       WDNUM             6 0
     C                   MOVE      WDATE         WDNUM
     C                   Z-ADD     WDNUM         WDNUM2            6 0
      *
     C                   CALLB     'ZDATE1'
     C                   PARM      WDATE         PDateIn           6
     C                   PARM                    PDaynoOut         5 0
     C                   PARM      BJDFIN        PDateFmt          1
     C                   PARM                    PError            1
      *
      ** Posting Date is not in valid format.
      *
     C     PError        IFEQ      'Y'
     C                   MOVE      'N'           D#PSDNOk
     C                   ADD       1             Idx
     C                   MOVEL     'DDPSDN'      FldNamXAr(Idx)
     C                   MOVEL     '5046129'     MsgIdXAr(Idx)
     C                   MOVEL     D#PSDN        MsgDtaXAr(Idx)
      *
     C                   ELSE
      *
     C                   Z-ADD     PDaynoOut     WVLDT
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
      *  SRValPdt - Postin Date Validation                            *
      *                                                               *
      *****************************************************************
      *
     C     SRValPdt      BEGSR
      *
      ** Posting Date is greater than rundate
      *
     C*****WVLDT         IFGT      BJRDNB                                                   MD032379
     C     WVLDT         IFGE      AO_BJDNWD                                                MD032379
     C                   MOVE      'N'           D#PSDNOk
     C                   ADD       1             Idx
     C                   MOVEL     'DDPSDN'      FldNamXAr(Idx)
     C                   MOVEL     '5046130'     MsgIdXAr(Idx)
     C                   MOVEL     D#PSDN        MsgDtaXAr(Idx)
      *
     C                   ELSE
      *
      ** Posting Date is before computed backvalue date.
      *
     C     BJRDNB        SUB       BJBVPD        WBRUN             5 0
     C                   IF        WVLDT < WBRUN
     C                   MOVE      'N'           D#PSDNOk
     C                   ADD       1             Idx
     C                   MOVEL     'DDPSDN'      FldNamXAr(Idx)
     C                   MOVEL     '5046131'     MsgIdXAr(Idx)
     C                   MOVEL     D#PSDN        MsgDtaXAr(Idx)
     C                   ENDIF
     C                   ENDIF
      *
      ** Posting Date is before Date Account Opened.
      *
     C                   IF        F1DACO > WVLDT
     C                   MOVE      'N'           D#PSDNOk
     C                   ADD       1             Idx
     C                   MOVEL     'DDPSDN'      FldNamXAr(Idx)
     C                   MOVEL     '5046132'     MsgIdXAr(Idx)
     C                   MOVEL     D#PSDN        MsgDtaXAr(Idx)
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
     C                   PARM                    DDVLDT
      *
      ** Posting Date
     C                   PARM                    D#PSDN
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
      ** SDBANK - Data Format
     C                   PARM                    BJDFIN            1
      *
      ** SDBANK - Back Value Period in Days
     C                   PARM                    BJBVPD            3 0
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Valid JE Item (DS) - for file update
     C                   PARM                    PVBITP
      *
      ** Posting Date - OK indicator
     C                   PARM                    D#PSDNOk
      *
      ** Valid JE Posting Date - for file update
     C                   PARM                    VExtPostD
      *
      ** Access Bank details                                                                MD032379
     C                   CALL      'AOBANKR0'                                               MD032379
     C                   PARM      *Blanks       @RTCD                                      MD032379
     C                   PARM      '*FIRST '     @OPTN                                      MD032379
     C     SDBANK        PARM      SDBANK        DSFDY                                      MD032379
                                                                                            MD032379
     C                   IF        @RTCD <> *Blanks                                         MD032379
     C     *LOCK         IN        LDA                                                      MD032379
     C                   EVAL      DBKey = @OPTN                                            MD032379
     C                   EVAL      DBFile = 'SDBANKPD'                                      MD032379
     C                   EVAL      DBase = 001                                              MD032379
     C                   OUT       LDA                                                      MD032379
     C                   EXSR      *PSSR                                                    MD032379
     C                   ENDIF                                                              MD032379
      *                                                                                     MD032379
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
      *                                                               *
      * ZDATE2 - Format a date for output                             *
      *                                                               *
      *****************************************************************
     C     ZDATE2        BEGSR

     C                   CALLB     'ZDATE2'
     C                   PARM                    ZDAYNO            5 0
     C                   PARM                    BJDFIN
     C                   PARM                    ZDATE             6 0
     C                   PARM                    ZADATE            7

     C                   ENDSR
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
(c) Finastra International Limited 2013
