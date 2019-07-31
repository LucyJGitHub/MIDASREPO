     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Validate weighting code')                     *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SEVSWEICD - Validate Weighting Code                          *
      *                                                               *
      *  Component of: SESECSSIN                                      *
      *                SESECSCTL                                      *
      *                SESECSRPR                                      *
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
      *  Prev Amend No. CRE073             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CSE071             Date 19Jul05               *
      *                 CGL014             Date 20Oct03               *
      *                 CGP001             Date 08Sep03               *
      *                 CAS006             Date 21Jan03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CSD006             Date 14May01               *
      *                 CAP060             Date 14May01               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CAP137  *CREATE    Date 07Feb00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
      *  CGL014 - Collaterals Processing                              *
      *  CGP001 - Global Processing.                                  *
      *           - SDWEIG* files renamed to GPWEIG*.                 *
      *  CAS006 - Hedge Accounting Phase B (Recompile)                *
      *  CSD006 - Market Data Feeds (recompile)                       *
      *  CAP060 - Midas APIs, Security Prices Full API (recompile)    *
      *  CAP137 - Conversion of SE Security inputs into modular       *
      *           structure to use as APIs.                           *
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
      ** Securities screen 3 details from incoming transaction
      ** - screen format
     D NwSE3ScnFmt   E DS                  EXTNAME(SESEC3PD)
      *
      ** Securities for file update - file format
     D NwSEFilFmt    E DS                  EXTNAME(SEVSECSPD)
      *
      ** Securities screen 3 error indicators
     D SEESEC3       E DS                  EXTNAME(SEESEC3PD)
      *
      ** Externally described DS for Weighting Code details
     D*SDWEIG******* E DS                  EXTNAME(SDWEIGPD)                                  CGP001
     D GPWEIG        E DS                  EXTNAME(GPWEIGPD)                                  CGP001
      *                                                                                       CGL014
      ** Externally described DS for Instrument Type details                                  CGL014
     D SDPLIN        E DS                  EXTNAME(SDPLINPD)                                  CGL014
     D                                     PREFIX(P)                                          CGL014
      *
      ** DS for Access Objects - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Index for arrays of error message ids, etc.
     D IDx             S              3P 0
      *
      ** Mode of processing
     D PMode           S              6A
      *
      ** Redisplay screen
     D PReDsp          S              1A
      *
      ** Parameters for GPAOWEIGR0
     D PRtCd           S              7A
     D POptn           S              7A
     D PWeiC           S              2A
                                                                                              CGL014
     D CGL014          S              1                                                       CGL014
     D PInst           S              3                                                       CGL014
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
      ** Initialise work variable.
      *
     C                   EVAL      IDx = 0
      *
      ** Validate weighting code.
      *
     C                   EXSR      SRValWeiCd
      *
      ** If an error has been found, set return code appropriately.
      ** Otherwise, update valid file fields.
      *
     C                   IF        OKWEIC = 'N'
     C                   EVAL      RetCodeIn = 'ERROR'
     C                   ENDIF
 
     C                   IF        OKWEIC <> 'N'
     C                   MOVE      DDWEIC        S1WEIC
     C                   ENDIF
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValWeiCd - Validation for Weighting Code                   *
      *                                                               *
      *****************************************************************
 
     C     SRValWeiCd    BEGSR
 
      *
      ** Question mark is valid only on repair and i/c screens input.
      *
     C     '?'           SCAN      DDWEIC                                 01
 
     C                   IF        *IN01 = *ON
 
     C                   IF        PMode = '*FRONT'
     C                   MOVE      'N'           OKWEIC
     C                   ADD       1             Idx
     C                   MOVEL     'DDWEIC'      FldNamXAr(Idx)
     C                   MOVEL     'SEA0242'     MsgIdXAr(Idx)
     C                   GOTO      EValWeiCd
     C                   ENDIF
 
     C                   EVAL      PReDsp = 'Y'
     C                   ENDIF
      *
      ** Weighting code must be a valid customer.
      *
     C                   IF        DDWEIC <> *BLANKS
 
     C**********         CALL      'AOWEIGR0'                                                 CGP001
     C                   CALL      'GPAOWEIGR0'                                               CGP001
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      DDWEIC        PWeiC
     C*****SDWEIG        PARM      SDWEIG        DSFDY                                        CGP001
     C     GPWEIG        PARM      GPWEIG        DSFDY                                        CGP001
 
     C                   IF        PRtCd <> *BLANKS
     C                   IF        PRtCd = '*NOSEL '
     C                   EVAL      DDWEIC = *BLANKS
     C                   ENDIF
     C                   MOVE      'N'           OKWEIC
     C                   ADD       1             IDx
     C                   MOVEL     'DDWEIC'      FldNamXAr(IDx)
     C                   MOVEL     'SEA0242'     MsgIdXAr(IDx)
     C                   ELSE
     C                   MOVEL     PDWEIG        DDWEIC
     C                   ENDIF
 
     C                   ENDIF
                                                                                              CGL014
      ** If CGL014 is on, instrument type is valid, and weighting                             CGL014
      ** code (from screen 1) is left blank, default it to the                                CGL014
      ** weighting code for the instrument                                                    CGL014
                                                                                              CGL014
     C                   IF        CGL014 = 'Y'  AND  OKPBIT <> 'N'  AND                      CGL014
     C                             DDWEIC = *BLANKS                                           CGL014
                                                                                              CGL014
     C                   CALL      'AOPLINR0'                                                 CGL014
     C                   PARM      *BLANKS       PRtCd                                        CGL014
     C                   PARM      '*KEY   '     POptn                                        CGL014
     C                   PARM      DDPBIT        PInst                                        CGL014
     C     SDPLIN        PARM      SDPLIN        DSFDY                                        CGL014
                                                                                              CGL014
     C                   IF        PRtCd <> *BLANKS  AND  PRtCd <> '*NRF   '                  CGL014
     C                   EVAL      DBFILE = 'SDPLINPD'                                        CGL014
     C                   EVAL      DBKEY  = PInst                                             CGL014
     C                   EVAL      DBASE  = 1                                                 CGL014
     C                   EXSR      *PSSR                                                      CGL014
     C                   ENDIF                                                                CGL014
                                                                                              CGL014
     C                   IF        PRtCd = *BLANKS                                            CGL014
     C                   MOVE      PPDWEIG       DDWEIC                                       CGL014
     C                   ENDIF                                                                CGL014
     C                   ENDIF                                                                CGL014
 
     C     EValWeiCd     ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation                              *
      *         - This subroutine runs automatically for program      *
      *           initialisation.                                     *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
      *
      ** INPUT
      ** =====
      *
      ** Return code
     C                   PARM                    RetCodeIn
      *
      ** Securities screen 3 details from incoming transaction
      ** - screen format
     C                   PARM                    NwSE3ScnFmt
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*SIN  ' (Screen input function)
      ** Mode = '*RPR  ' (Repair function)
     C                   PARM                    PMode
      *
      ** Redisplay screen
     C                   PARM                    PReDsp
                                                                                              CGL014
      ** Collaterals Processing                                                               CGL014
                                                                                              CGL014
     C                   PARM                    CGL014                                       CGL014
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Securities screen 3 error indicators
     C                   PARM                    SEESEC3
      *
      ** Securities for file update - file format
     C                   PARM                    NwSEFilFmt
      *
      ** Program, module and procedure names for dbase error processing
      ** ==============================================================
      ** The following /COPY sets these values.
      *
      /COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
      *
      /COPY ZACPYSRC,PSSR_ILE
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *
**  CPY@
(c) Finastra International Limited 2001
