     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL Validate JE Item Cheque Number')              *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GLVCQNB    - Validate Journal Batch Entry Item Cheque No.    *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel.                     *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
 
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. AR784719           Date 13Jun11               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      *                 239466             Date 19Apr06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG3036            Date 02Jul04               *
      *                 BUG3037            Date 18Jun04               *
      *                 TCA102             Date 02Apr04               *
      *                 CRE019             Date 12Jan04               *
      *                 CGL029             Date 01Sep03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CAP032  *CREATE    Date 26Apr99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  AR784719 - 6-digit cheque no. is not accepted. Patterned fix *
      *             with cheque maintenance validation process.       *
      *             (Child: AR784720)                                 *
      *  239466 - Amend to allow checking of cheques already          *
      *           presented and out of range both for debit and       *
      *           credit transactions. Reverse BUG3036.               *
      *  BUG3036 - Validate cheque range only for debit entries.      *
      *  BUG3037 - Zeroise index count for warning array so messages  *
      *            are processed.  Also, validate out of range cheque *
      *            or duplicate presented cheque regardless of debit/ *
      *            credit indicator.                                  *
      *  TCA102 - Various errors on Journal Entry input (Recompile).  *
      *  CRE019 - Cheque Processing and Maintenance                   *
      *  CGL029 - Increase account code to 10 digits                  *
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
     FCHQBKL1   IF   E           K DISK    INFSR(*PSSR)                                       CRE019
     F                                     USROPN                                             CRE019
      ** Midas RE Cheque Book file - 1                                                        CRE019
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
      ** Valid JE Item (DS) - for file update
     D PVBITP        E DS                  EXTNAME(GLVBITPPD)
      *
      ** Cheque no. array
     D WCQAR           S              1    DIM(8)
      *                                                                                       CRE019
      ** Cheques presented array                                                              CRE019
     D WAR             S              1    DIM(20)                                            CRE019
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Index for arrays of error message ids, etc.
     D Idx             S              3P 0
      *
      ** Work index
     D Widx            S              1S 0
                                                                                              CGL029
     D PACCD           S             10                                                       CGL029
      *                                                                                     AR784719
      ** For cheque maintenance validation                                                  AR784719
     D WUZASF          S              8A                                                    AR784719
     D W0RTN           S              7A                                                    AR784719
     D WQ0001          S              7A                                                    AR784719
     D WQ0002          S             16A                                                    AR784719
     D WQ0003          S              1P 0                                                  AR784719
     D WQ0004          S              2P 0                                                  AR784719
     D WQ0005          S             16A                                                    AR784719
     D WCHQNM          S              8A                                                    AR784719
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
     C                   Z-ADD     *ZERO         WIdx
     C                   MOVE      'N'           WERCD             1
      *
     C                   MOVE      *BLANKS       PSTOP
      *
      ** Validate Cheque Number.
      *
     C                   EXSR      SRProc
      *
     C     DDCqnbOK      IFEQ      'N'
     C                   EVAL      RetCodeIn = 'ERROR'
     C                   ENDIF
      *
     C                   EVAL      B2CQNB = DDCQNB
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRProc - Process Cheque Number input                         *
      *                                                               *
      *****************************************************************
      *
     C     SRProc        BEGSR
      *
     C     DDCQNB        IFNE      *BLANKS
      *
      ** If account type is not Retail, then error.
      *
     C     B2ACTY        IFNE      'R'
     C                   MOVE      'N'           DDCqnbOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDCQNB'      FldNamXAr(Idx)
     C                   MOVEL     'GLX0062'     MsgIdXAr(Idx)
     C                   ELSE
      *
      ** Otherwise, validate Cheque Number.
      *
     C                   EXSR      SRValChq
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
      *  SRValChq - Validate Cheque Number                            *
      *                                                               *
      *****************************************************************
      *
     C     SRValChq      BEGSR
                                                                                            AR784719
      ** Align Cheque Number and Pad with Zeroes if necessary                               AR784719
                                                                                            AR784719
     C                   MOVE      *BLANK        WUZASF                                     AR784719
     C                   MOVE      DDCQNB        WUZASF                                     AR784719
     C                   MOVE      *BLANK        W0RTN                                      AR784719
                                                                                            AR784719
      ** ZALIGN Screen Field - Standard functions                                           AR784719
                                                                                            AR784719
     C                   CALL      'ZALIGN'                             90                  AR784719
     C                   PARM      W0RTN         WQ0001                                     AR784719
     C                   PARM      WUZASF        WQ0002                                     AR784719
     C                   PARM      *ZERO         WQ0003                                     AR784719
     C                   PARM      8             WQ0004                                     AR784719
     C                   PARM      *BLANK        WQ0005                                     AR784719
                                                                                            AR784719
     C                   MOVE      WQ0005        WCHQNM                                     AR784719
     C     WCHQNM        IFNE      *BLANK                                                   AR784719
     C                   MOVE      WCHQNM        DDCQNB                                     AR784719
     C                   ENDIF                                                              AR784719
      *
      ** Determine if Cheque Number is numeric with no blank
      ** character.
      *
     C                   MOVEA     DDCQNB        WCQAR
      *
     C     WERCD         DOWEQ     'N'
     C     Widx          ANDLT     8
     C                   ADD       1             Widx
     C     WCQAR(Widx)   IFEQ      *BLANK
     C                   MOVE      'Y'           WERCD
     C                   ENDIF
     C                   ENDDO
      *
     C     WERCD         IFEQ      'Y'
     C                   MOVE      'N'           DDCqnbOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDCQNB'      FldNamXAr(Idx)
     C                   MOVEL     'GLX0227'     MsgIdXAr(Idx)
     C                   ELSE
      *
      ** Determine if Cheque No. is numeric.
      *
     C                   TESTN                   DDCQNB               01
     C     *IN01         IFEQ      *OFF
     C                   MOVE      'N'           DDCqnbOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDCQNB'      FldNamXAr(Idx)
     C                   MOVEL     'GLX0209'     MsgIdXAr(Idx)
     C                   ELSE
      *
      ** Determine if it is a Stopped Cheque.
      *
     C                   EXSR      SRStop
      *                                                                                       CRE019
      ** Determine if out of range cheque or duplicate presented cheque is used               CRE019
      ** for debit transactions                                                               CRE019
      *                                                                                       CRE019
     C**********         IF        CRE019 = 'Y' AND B2DCIN = 'D'                      CRE019 BUG3037
     C**********         IF        CRE019 = 'Y'                                      BUG3037 BUG3036
     C**********         IF        CRE019 = 'Y' AND B2DCIN = 'D'                      BUG3036 239466
     C                   IF        CRE019 = 'Y'                                               239466
     C                   EXSR      SRWarn                                                     CRE019
     C                   ENDIF                                                                CRE019
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
      *  SRStop - Determine if Stopped Cheque                         *
      *                                                               *
      *****************************************************************
      *
     C     SRStop        BEGSR
      *
      ** Determine if Stopped Cheque.
      *
     C     B2DCIN        IFEQ      'D'
      *
     C                   CALL      'AOSTOPV0'
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM      B2PTAM        PCQAM            13 0
     C                   PARM      DDCQNB        PCQNB             8
     C                   PARM      B2RACN        PRACN            10 0
     C                   PARM      B2CUST        PCUST             6
     C                   PARM      B2CYCD        PCYCD             3
     C**********         PARM      B2ACCD        PACCD             4                          CGL029
     C                   PARM      B2ACCD        PACCD                                        CGL029
     C                   PARM      B2ACSN        PACSN             2
     C                   PARM      B2IBCA        PBRCD             3
      *
      ** Pass return code for override validation.
      *
     C     PRTCD         IFEQ      '*STOP  '
     C                   MOVE      PRTCD         PSTOP
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT                                                                                  CRE019
      *****************************************************************                       CRE019
      *                                                               *                       CRE019
      *  SRWarn - Determine if warnings should be given for duplicate *                       CRE019
      *           presented cheques and out of range cheques          *                       CRE019
      *                                                               *                       CRE019
      *****************************************************************                       CRE019
      *                                                                                       CRE019
     C     SRWarn        BEGSR                                                                CRE019
      *                                                                                       CRE019
     C     KCHQBK        KLIST                                                                CRE019
     C                   KFLD                    KACNO            10 0                        CRE019
     C                   KFLD                    KGCIN             1 0                        CRE019
     C                   KFLD                    KSCQN             8 0                        CRE019
      *                                                                                       CRE019
     C     KCHQB2        KLIST                                                                CRE019
     C                   KFLD                    KACNO                                        CRE019
     C                   KFLD                    KGCIN                                        CRE019
      *                                                                                       CRE019
     C                   EVAL      KACNO = B2RACN                                             CRE019
     C                   EVAL      KGCIN = 0                                                  CRE019
     C                   MOVE      DDCQNB        KSCQN                                        CRE019
     C                   CLEAR                   B2DUPC                                       CRE019
     C                   CLEAR                   B2OUTR                                       CRE019
     C                   Z-ADD     *ZERO         WIdx                                        BUG3037
      *                                                                                       CRE019
     C                   OPEN      CHQBKL1                                                    CRE019
     C     KCHQBK        SETGT     CHQBKPDF                                                   CRE019
     C     KCHQB2        READPE    CHQBKPDF                               43                  CRE019
      *                                                                                       CRE019
     C                   IF        *IN43 = *OFF                                               CRE019
     C                             AND RECID = 'D'                                            CRE019
      *                                                                                       CRE019
      ** Cheque is not in the range expected for the retail account                           CRE019
      *                                                                                       CRE019
     C                   IF        KSCQN < SCQN OR KSCQN > ECQN                               CRE019
     C                   MOVE      'W'           DDCqnbOK                                     CRE019
     C                   EVAL      WIdx = WIdx + 1                                            CRE019
     C                   EVAL      WFldNmXAr(WIdx) = 'DDCQNB'                                 CRE019
     C                   EVAL      WMsgIdXAr(WIdx) = 'GLX0004'                                CRE019
     C                   EVAL      B2OUTR =  'Y'                                              CRE019
     C                   ELSE                                                                 CRE019
      *                                                                                       CRE019
      ** Cheque has already been presented                                                    CRE019
      *                                                                                       CRE019
     C                   Z-ADD     KSCQN         WSCQN             8 0                        CRE019
     C     WSCQN         SUB       SCQN          WOFSET            8 0                        CRE019
     C     WOFSET        DIV       8             WI                2 0                        CRE019
     C                   MVR                     WBITN             1 0                        CRE019
     C                   EVAL      WI = WI + 1                                                CRE019
      *                                                                                       CRE019
      ** Test corresponding bit-position of element for cheque presented                      CRE019
      *                                                                                       CRE019
     C                   MOVEA     CQPS          WAR                                          CRE019
     C                   SELECT                                                               CRE019
     C                   WHEN      WBITN = 0                                                  CRE019
     C                   TESTB     '0'           WAR(WI)                  43                  CRE019
     C                   WHEN      WBITN = 1                                                  CRE019
     C                   TESTB     '1'           WAR(WI)                  43                  CRE019
     C                   WHEN      WBITN = 2                                                  CRE019
     C                   TESTB     '2'           WAR(WI)                  43                  CRE019
     C                   WHEN      WBITN = 3                                                  CRE019
     C                   TESTB     '3'           WAR(WI)                  43                  CRE019
     C                   WHEN      WBITN = 4                                                  CRE019
     C                   TESTB     '4'           WAR(WI)                  43                  CRE019
     C                   WHEN      WBITN = 4                                                  CRE019
     C                   TESTB     '4'           WAR(WI)                  43                  CRE019
     C                   WHEN      WBITN = 5                                                  CRE019
     C                   TESTB     '5'           WAR(WI)                  43                  CRE019
     C                   WHEN      WBITN = 6                                                  CRE019
     C                   TESTB     '6'           WAR(WI)                  43                  CRE019
     C                   WHEN      WBITN = 7                                                  CRE019
     C                   TESTB     '7'           WAR(WI)                  43                  CRE019
     C                   ENDSL                                                                CRE019
     C**********         CLOSE     CHQBKL1                                            CRE019 BUG3037
      *                                                                                       CRE019
      ** If bit is set, this is a duplicate                                                   CRE019
      *                                                                                       CRE019
     C                   IF        *IN43 = *ON                                                CRE019
     C                   MOVE      'W'           DDCqnbOK                                     CRE019
     C                   EVAL      WIdx = WIdx + 1                                            CRE019
     C                   EVAL      WFldNmXAr(WIdx) = 'DDCQNB'                                 CRE019
     C                   EVAL      WMsgIdXAr(WIdx) = 'GLX0003'                                CRE019
     C                   EVAL      B2DUPC =  'Y'                                              CRE019
     C                   ENDIF                                                                CRE019
     C                   ENDIF                                                                CRE019
      *                                                                                       CRE019
     C                   ELSE                                                                 CRE019
      *                                                                                       CRE019
      ** No cheque is expected for the retail account                                         CRE019
      *                                                                                       CRE019
     C                   MOVE      'W'           DDCqnbOK                                     CRE019
     C                   EVAL      WIdx = WIdx + 1                                            CRE019
     C                   EVAL      WFldNmXAr(WIdx) = 'DDCQNB'                                 CRE019
     C                   EVAL      WMsgIdXAr(WIdx) = 'GLX0005'                                CRE019
     C                   EVAL      B2OUTR =  'Y'                                              CRE019
      *                                                                                       CRE019
     C                   ENDIF                                                                CRE019
     C                   CLOSE     CHQBKL1                                                   BUG3037
     C                   ENDSR                                                                CRE019
      *                                                                                       CRE019
      *****************************************************************                       CRE019
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
      ** Cheque Number
     C                   PARM                    DDCQNB            8
      *                                                                                       CRE019
      ** Cheque Processing SAR flag                                                           CRE019
     C                   PARM                    CRE019            1                          CRE019
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *                                                                                       CRE019
      ** Warning fields/message IDs/message data (arrays) from/to caller                      CRE019
     C                   PARM                    WFldNmXAr                                    CRE019
     C                   PARM                    WMsgIDXAr                                    CRE019
     C                   PARM                    WMSGDtXAr                                    CRE019
      *
      ** Cheque Number - OK indicator
     C                   PARM                    DDCqnbOK          1
      *
      ** Return code for Stopped Cheque validation
     C                   PARM                    PSTOP             7
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
(c) Finastra International Limited 2001
