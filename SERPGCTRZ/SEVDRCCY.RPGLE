     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Validate Diary Events Redemption Currency')
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SEVDRCCY - Validate Diary Events Redemption Currency         *
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
      *  Last Amend No. CSD031             Date 10Apr06               *
      *  Prev Amend No. CAS006             Date 21Jan03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CAP140   *CREATE   Date 17Oct00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CAS006 - Hedge Accounting Phase B (Recompile)                *
      *  CAP140 - Conversion of SE Security Diary Event inputs into   *
      *           modular structure to use as APIs.                   *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    01         Use for scan of symbol '?'                      *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SrRedCcy - Validate Redemption Currency                      *
      *  *PSSR - Error processing                                     *
      *  *INZSR - Initialise                                          *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
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
      ** SE Diary Events for file update - file format
     D NwDEFilFmt    E DS                  EXTNAME(SEVSEDEPD)
      *
      ** SE Diary Events screen error indicators
     D SEESEDE       E DS                  EXTNAME(SEESEDEPD)
      *
      ** SE Diary Events screen details from incoming
      ** transaction - screen format
     D NwDE1ScnFmt   E DS                  EXTNAME(SESEDEPD)
      *
      ** Externally described DS for Currency details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      *
      ** DS for Access Objects - long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Index for arrays of error message ids, etc.
     D IDx             S              3P 0
      *
      ** Redisplay screen flag
     D PReDsp          S              1A
      *
      ** Mode of processing
     D PMode           S              6A
      *
      ** Parameters for module AOCURRR0
     D PRtCd           S              7A
     D POptn           S              7A
     D PKey            S              3A
 
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
     C                   EVAL      IDx = 0
      *
     C                   EXSR      SrRedCcy
      *
      ** If an error has been found, set return code appropriately.
      ** Otherwise, update valid file fields.
      *
     C                   IF        OKRCCY = 'N'
     C                   EVAL      RetCodeIn = 'ERROR'
     C                   ELSE
     C                   MOVE      DDRCCY        S2SDCX
     C                   ENDIF
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrRedCcy - Validate Redemption Currency                      *
      *                                                               *
      *****************************************************************
 
     C     SRRedCcy      BEGSR
      *
      ** Redemption Currency si mandatory if Exchange Rate is entered.
      *
     C                   IF        DDRCCY = *BLANKS
      *
     C                   IF        DDXRAT <> *BLANKS
     C                   MOVE      'N'           OKRCCY
     C                   ADD       1             Idx
     C                   MOVEL     'DDRCCY'      FldNamXAr(Idx)
     C                   MOVEL     'SEA0352'     MsgIdXAr(Idx)
     C                   ENDIF
      *
     C                   ELSE
      *
      ** Question mark is valid only on repair and i/c screens input.
      *
     C     '?'           SCAN      DDRCCY                                 01
      *
     C                   IF        *IN01
      *
     C                   IF        PMode = '*FRONT'
     C                   MOVE      'N'           OKRCCY
     C                   ADD       1             Idx
     C                   MOVEL     'DDRCCY'      FldNamXAr(Idx)
     C                   MOVEL     'SEA0394'     MsgIdXAr(Idx)
     C                   GOTO      ERedCcy
     C                   ENDIF
      *
     C                   EVAL      PReDsp = 'Y'
     C                   ENDIF
      *
      ** Validate if currency is existing.
      *
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      DDRCCY        PKey
     C     SDCURR        PARM      SDCURR        DSSDY
      *
     C                   IF        PRtCd <> *BLANKS
      *
     C                   IF        PRtCd = '*NOSEL '
     C                   EVAL      DDRCCY = *BLANKS
     C                   ELSE
     C                   MOVE      'N'           OKRCCY
     C                   ADD       1             Idx
     C                   MOVEL     'DDRCCY'      FldNamXAr(Idx)
     C                   MOVEL     'SEA0394'     MsgIdXAr(Idx)
     C                   ENDIF
      *
     C                   ELSE
     C                   MOVEL     A6CYCD        DDRCCY
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     ERedCcy       ENDSR
 
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
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair function)
      ** Mode = '*SIN  ' (Screen input function)
     C                   PARM                    PMode
      *
      ** SE Diary Events screen details from incoming
      ** transaction - screen format
     C                   PARM                    NwDE1ScnFmt
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** SE Diary Events screen error indicators
     C                   PARM                    SEESEDE
      *
      ** SE Diary Events for file update - file format
     C                   PARM                    NwDEFilFmt
      *
      ** Redisplay screen flag
     C                   PARM                    PReDsp
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
