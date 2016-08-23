     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Validate Trade Settlement Nominal Settled')   *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SEVTSNOMS - Validate Trade Settlement Nominal Settled Amount *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel.                     *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. CRE073             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD027             Date 09Dec05               *
      *                 CSE075             Date 17Nov05               *
      *                 CSE074             Date 30Aug05               *
      *                 CSE071             Date 19Jul05               *
      *                 CAP182   *CREATE   Date 03Jan03               *
      *                                    Date DDMmmYY               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSE075 - US Enhanced Treasury Upgrade to MidasPlus           *
      *           (Recompile)                                         *
      *  CSE074 - Const. Yld Amort. Upgrade to MidasPlus (Recompile)  *
      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
      *  CAP182 - Auto Settlement of Trades                           *
      *         - Conversion of SE Trade Settlement Input maintence   *
      *           function to modular structure to use as APIs.       *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    XX         Function of indicator                           *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SrNomSetAmnt - Validate Nominal Settled Amount               *
      *  *PSSR        - Error processing                              *
      *  *INZSR       - Initialise                                    *
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
      **    True       logical = *On (for indicator processing)
      **    False      logical = *Off (for indicator processing)
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
      ** SE Trade Settlement Details for file update - file format
     D NwTSFilFmt    E DS                  EXTNAME(SEVTRSMPD)
      *
      ** Error indicators
     D SEETRSM       E DS                  EXTNAME(SEETRSMPD)
      *
      ** SE Trade Settlement Screen details from incoming transaction
      ** - screen format
     D NwTS1ScnFmt   E DS                  EXTNAME(SETRSMPD)
      *
      ** SE Trade Details information retrieved from file - file format
     D CrTDFilFmt    E DS                  EXTNAME(TRADS)
      *
      ** Externally described DS for security details
     D PSectyd       E DS                  EXTNAME(SECTYD)
     D                                     PREFIX(S_)
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Index for arrays of error message ids, etc.
     D IDx             S              3P 0
      *
      ** Index for arrays of warning error message ids, etc.
     D WIdx            S              3P 0
      *
      ** Input parameters
     D CSE007          S              1A
     D CEU017          S              1A
      *
      ** Work parameters
     D ZFIELD          S             16A
     D ZADEC           S              1P 0
     D ZADIG           S              2P 0
     D ZALIGNok        S              1A
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
      ** ¦ Initial processing is performed automatically.             ¦
      ** ¦ *INZSR is executed at program activation.                  ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
      *
      ** Initialise work variables.
     C                   Eval      IDx = 0
      *
     C                   Exsr      SrNomSetAmnt
      *
      ** If an error has been found, set return code appropriately.
      ** Otherwise, update valid file fields.
      *
     C                   If        OKNOMS = 'N'
     C                   Eval      RetCodeIn = 'ERROR'
     C                   Else
     C                   Z-Add     WNomS         VTSSNMS
     C                   EndIf
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrNomSetAmnt - Validate Nominal Settled Amount               *
      *                                                               *
      *****************************************************************
 
     C     SrNomSetAmnt  BEGSR
      *
      ** Reset all working fields
     C                   Z-Add     *Zeros        WNomS
     C                   Z-Add     *Zeros        WK13N2
     C                   Z-Add     *Zeros        WK01N
     C                   Z-Add     *Zeros        WK158N
     C                   Z-Add     *Zeros        ZADIG
     C                   Z-Add     *Zeros        ZADEC
      *
     C                   If        DDNOMS <> *Blanks
      *
     C                   Eval      ZFIELD = *Blanks
     C                   Eval      ZFIELD = DDNOMS
     C     13            Sub       TNMD          ZADIG
     C                   Move      TNMD          ZADEC
      *
     C                   CALLB     'ZALIGN'
     C                   PARM      *BLANK        ZALIGNok
     C                   PARM                    ZFIELD
     C                   PARM                    ZADEC
     C                   PARM                    ZADIG
 
     C                   If        ZALIGNok = 'N'
     C                   Move      'N'           OKNOMS
     C                   Add       1             IDx
     C                   MoveL     'DDNOMS'      FldNamXAr(IDx)
     C                   MoveL     'USR2039'     MsgIdXAr(IDx)
     C                   Else
      *
      ** If ok, must be multiple of trade denomination (if present)
      *
     C                   Move      ZFIELD        WNomS            13 0
     C                   Z-Add     1             FACTOR           10 0
      *
     C                   DO        TNMD
     C     FACTOR        Mult      10            FACTOR
     C                   End
      *
     C     WNomS         Div       FACTOR        WK158N           15 8
      *
     C                   If        S_SDNM <> *ZEROS
     C     WK158N        Div       S_SDNM        WK13N2           13 0
     C                   Mvr                     WK01N             2 1
      *
     C                   If        WK01N <> *ZEROS
     C                   If        CSE007 = 'N' And CEU017 = 'N'                               CSE00
     C                   Move      'N'           OKNOMS
     C                   Add       1             IDx
     C                   MoveL     'DDNOMS'      FldNamXAr(IDx)
     C                   MoveL     'USR2040'     MsgIdXAr(IDx)
     C                   Else                                                                  CSE00
     C                   Move      'W'           OKNOMS
     C                   Add       1             WIdx
     C                   Eval      WFldNmXAr(WIdx) = 'DDNOMS'
     C                   Eval      WMsgIdXAr(WIdx) = 'USR2041'
     C                   EndIf
     C                   EndIf
      *
     C                   EndIf
      *
      ** Must be less than O/S nominal
     C                   If        DDREVE <> 'Y' And DDFSET <> 'Y'
     C                   If        WNomS > TOSN
     C                   Move      'W'           OKNOMS
     C                   Add       1             WIdx
     C                   Eval      WFldNmXAr(WIdx) = 'DDNOMS'
     C                   Eval      WMsgIdXAr(WIdx) = 'USR2042'
     C                   EndIf
     C                   EndIf
      *
      ** If Reversal specified, must be LE than Nominal settled
     C                   If        DDREVE = 'Y'
     C     TNSN          Add       TNSP          WK13N2
     C                   If        WNomS > WK13N2
     C                   Move      'N'           OKNOMS
     C                   Add       1             IDx
     C                   MoveL     'DDNOMS'      FldNamXAr(IDx)
     C                   MoveL     'USR2043'     MsgIdXAr(IDx)
     C                   EndIf
     C                   EndIf
      *
      ** If full settlement specified, O/S Nom - Nom Set must = 0
     C                   If        DDFSET = 'Y'
     C     TOSN          SUB       WNomS         WK13N2
     C                   If        WK13N2 <> 0
     C                   Move      'N'           OKNOMS
     C                   Add       1             IDx
     C                   MoveL     'DDNOMS'      FldNamXAr(IDx)
     C                   MoveL     'USR2044'     MsgIdXAr(IDx)
     C                   EndIf
     C                   EndIf
      *
     C                   EndIf
     C                   EndIf
      *
      ** Cannot be blank for full settlement
     C                   If        DDNOMS = *Blanks  And DDFSET = 'Y'
     C                   Move      'N'           OKNOMS
     C                   Add       1             IDx
     C                   MoveL     'DDNOMS'      FldNamXAr(IDx)
     C                   MoveL     'USR2045'     MsgIdXAr(IDx)
     C                   EndIf
      *
     C                   ENDSR
 
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
      ** SE Trade Details retrieved from file - file format
     C                   PARM                    CrTDFilFmt
      *
      ** Externally described DS for security details
     C                   PARM                    PSectyd
      *
      ** SE Trade Settlement screen details from incoming
      ** transaction - screen format
     C                   PARM                    NwTS1ScnFmt
      *
      ** SWITCHABLE FEATURES
      ** ===================
      *
      ** Corporate Action
     C                   PARM                    CSE007
      *
      ** Security Redenomination Euro Changes
     C                   PARM                    CEU017
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDxAr
     C                   PARM                    WMsgDtXAr
      *
      ** Error indicators
     C                   PARM                    SEETRSM
      *
      ** SE Trade Settlement details for file update - file format
     C                   PARM                    NwTSFilFmt
      *
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
(c) Misys International Banking Systems Ltd. 2003
