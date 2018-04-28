     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Validate PB instrument type')                 *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SEVSPBITP - Validate PB Instrument Type                      *
      *                                                               *
      *  Component of: SESECSSIN                                      *
      *                SESECSCTL                                      *
      *                SESECSRPR                                      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel.                     *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. AR1092858          Date 06Mar13               *
      *  Prev Amend No. AR1090842          Date 25Feb13               *
      *                 AR996842           Date 11Feb13               *
      *                 CRE073             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CSE071             Date 19Jul05               *
      *                 CLE025             Date 20Oct03               *
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
      *  AR1092858 - Private Banking Instrument Type field does not   *
      *              defaulted in Securities Details                  *
      *  AR1090842 - Error occurred has no description. Tab is not    *
      *              highlighted in red when in error                 *
      *  AR996842 - Creation of new security details: Private Banking *
      *             Instrument type defaulting improvement            *
      *             (Child:AR996843)                                  *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
      *  CLE025 - Credit Lines (Recompile)                            *
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
      ** Externally described DS for Instrument type details
     D SDPLIN        E DS                  EXTNAME(SDPLINPD)
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
      ** Parameters for AOPLINR0
     D PRtCd           S              7A
     D POptn           S              7A
     D PInTp           S              3A
      *
      ** Redisplay screen
     D PReDsp          S              1A
      *
     D WPBIT           S              3A
      *                                                                                     AR996842
      ** Instrument type                                                                    AR996842
      *                                                                                     AR996842
     D PINNR           S              3A                                                    AR996842
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
      ** Initialise work variables.
      *
     C                   EVAL      IDx = 0
     C                   EVAL      WPBIT = *BLANKS
      *
      ** Validate PB Instrument Type.
      *
     C                   EXSR      SRValInsTp
      *
      ** If an error has been found, set return code appropriately.
      ** Otherwise, update valid file fields.
      *
     C                   IF        OKPBIT = 'N'
     C                   EVAL      RetCodeIn = 'ERROR'
     C                   ENDIF
 
     C                   IF        OKPBIT <> 'N'
     C                   EVAL      S1PBIT = DDPBIT
     C                   ENDIF
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValInsTp - Validation for PB Instrument Type               *
      *                                                               *
      *****************************************************************
 
     C     SRValInsTp    BEGSR
      *
      ** Set up work variable. If blanks, default to investment type.
      *
     C                   IF        DDPBIT = *BLANKS
     C**********         EVAL      WPBIT = S1SITP                                           AR996842
     C**********         EVAL      WPBIT = PINNR                                  AR996842 AR1092858
     C                   EVAL      DDPBIT = PINNR                                          AR1092858
     C                   EVAL      WPBIT = DDPBIT                                          AR1092858
     C                   ELSE
     C                   EVAL      WPBIT = DDPBIT
     C                   ENDIF
      *
      ** Question mark is valid only on repair and i/c screens input.
      *
     C     '?'           SCAN      WPBIT                                  01
 
     C                   IF        *IN01 = *ON
 
     C                   IF        PMode = '*FRONT'
     C                   MOVE      'N'           OKPBIT
     C                   ADD       1             Idx
     C                   MOVEL     'DDPBIT'      FldNamXAr(Idx)
     C                   MOVEL     'SEA0307'     MsgIdXAr(Idx)
     C                   GOTO      EValInsTp
     C                   ENDIF
 
     C                   EVAL      PReDsp = 'Y'
     C                   ENDIF
      *
      ** Instrument type must be a valid record in SDPLINPD.
      *
     C                   CALL      'AOPLINR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      WPBIT         PInTp
     C     SDPLIN        PARM      SDPLIN        DSFDY
 
     C                   IF        PRtCd <> *BLANKS
      *
     C                   IF        PRtCd = '*NOSEL '
     C                   EVAL      DDPBIT = *BLANKS
     C                   ENDIF
      *
      ** If blanks, generate error message
      *
     C                   IF        DDPBIT = *BLANKS
     C                   MOVE      'N'           OKPBIT
     C                   ADD       1             IDx
     C                   MOVEL     'DDPBIT'      FldNamXAr(IDx)
     C                   MOVEL     'SEA0309'     MsgIdXAr(IDx)
     C                   ELSE
     C                   MOVE      'N'           OKPBIT
     C                   ADD       1             IDx
     C                   MOVEL     'DDPBIT'      FldNamXAr(IDx)
     C                   MOVEL     'SEA0307'     MsgIdXAr(IDx)
     C                   ENDIF
      *
     C                   ELSE
     C                   EVAL      DDPBIT = PDINNR
     C                   ENDIF
 
     C     EValInsTp     ENDSR
 
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
      *                                                                                    AR1090842
      ** Instrument type                                                                   AR1090842
      *                                                                                    AR1090842
     C                   PARM                    PINNR                                     AR1090842
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
(c) Misys International Banking Systems Ltd. 2001
