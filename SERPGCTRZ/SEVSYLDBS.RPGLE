     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Validate yield basis')                        *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SEVSYLDBS - Validate Yield Basis                             *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel.                     *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CRE073             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CSE071             Date 19Jul05               *
      *                 CAS006             Date 21Jan03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CSE032             Date 13Dec01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CSD006             Date 14May01               *
      *                 CAP060             Date 14May01               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CAP137  *CREATE    Date 07Feb00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *           (Recompile)                                         *
      *  MD046248 - Finastra Rebranding                               *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
      *  CAS006 - Hedge Accounting Phase B (Recompile)                *
      *  CSE032 - Allow entry of yield basis with percentage price    *
      *           based securities.                                   *
      *  CSD006 - Market Data Feeds (recompile)                       *
      *  CAP060 - Midas APIs, Security Prices Full API (recompile)    *
      *  CAP137 - Conversion of SE Security Inputs into modular       *
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
      ** Array for valid yield basis
     D TABYBS          S              2    DIM(12) CTDATA PERRCD(12)
      *
      ** Securities screen 2 details from incoming transaction
      ** - screen format
     D NwSE2ScnFmt   E DS                  EXTNAME(SESEC2PD)
      *
      ** Securities for file update - file format
     D NwSEFilFmt    E DS                  EXTNAME(SEVSECSPD)
      *
      ** Securities screen 2 error indicators
     D SEESEC2       E DS                  EXTNAME(SEESEC2PD)
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Index for arrays of error message ids, etc.
     D IDx             S              3P 0
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
     C                   EVAL      IDx = 0
      *
      ** Validate yield basis
      *
     C                   EXSR      SRValYldBs
      *
      ** If an error has been found, set return code appropriately.
      ** Otherwise, update valid file fields.
      *
     C                   IF        OKSYBS = 'N'
     C                   EVAL      RetCodeIn = 'ERROR'
     C                   ENDIF

     C                   IF        OKSYBS <> 'N'
     C                   MOVE      DDSYBS        S1SYBS
     C                   ENDIF

     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVALYLDBS - Validation for Yield Basis                      *
      *                                                               *
      *****************************************************************
     C     SRValYldBs    BEGSR
      *
      ** If yield basis is blank, trade basis must not be 'Y'
      *
     C                   IF        CSE032 <> 'Y'                                              CSE032
     C                   IF        DDSYBS = *BLANKS
     C                   IF        S1STBS = 'Y'
     C                   MOVE      'N'           OKSYBS
     C                   ADD       1             IDx
     C                   MOVEL     'DDSYBS'      FldNamXAr(IDx)
     C                   MOVEL     'SEA0217'     MsgIdXAr(IDx)
     C                   ENDIF
     C                   ELSE
      *
      ** Else trade basis must be 'Y'
      *
     C                   IF        S1STBS <> 'Y'
     C                   MOVE      'N'           OKSYBS
     C                   ADD       1             IDx
     C                   MOVEL     'DDSYBS'      FldNamXAr(IDx)
     C                   MOVEL     'SEA0217'     MsgIdXAr(IDx)
     C                   ELSE
     C     DDSYBS        LOOKUP    TABYBS                                 01
     C                   IF        *IN01 = *OFF
     C                   MOVE      'N'           OKSYBS
     C                   ADD       1             IDx
     C                   MOVEL     'DDSYBS'      FldNamXAr(IDx)
     C                   MOVEL     'SEA0218'     MsgIdXAr(IDx)
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CSE032
     C                   ELSE                                                                 CSE032
      ** CSE032 is 'Y'.                                                                       CSE032
      ** If yield basis is blank, trade basis must not be 'Y'                                 CSE032
      ** or 'P' with price basis of 'P'.                                                      CSE032
      *                                                                                       CSE032
     C                   IF        DDSYBS = *BLANKS                                           CSE032
     C                   IF        S1STBS = 'Y' or                                            CSE032
     C                             (S1STBS = 'P' and                                          CSE032
     C                             S1SPBS = 'P')                                              CSE032
     C                   MOVE      'N'           OKSYBS                                       CSE032
     C                   ADD       1             IDx                                          CSE032
     C                   MOVEL     'DDSYBS'      FldNamXAr(IDx)                               CSE032
     C                   MOVEL     'SEA0221'     MsgIdXAr(IDx)                                CSE032
     C                   ENDIF                                                                CSE032
     C                   ELSE                                                                 CSE032
      *                                                                                       CSE032
      ** Else trade basis must be 'Y' or 'P' with price basis of 'P'.                         CSE032
      *                                                                                       CSE032
     C                   IF        S1STBS = 'Y' or                                            CSE032
     C                             (S1STBS = 'P' and                                          CSE032
     C                             S1SPBS = 'P')                                              CSE032
     C     DDSYBS        LOOKUP    TABYBS                                 01                  CSE032
     C                   IF        *IN01 = *OFF                                               CSE032
     C                   MOVE      'N'           OKSYBS                                       CSE032
     C                   ADD       1             IDx                                          CSE032
     C                   MOVEL     'DDSYBS'      FldNamXAr(IDx)                               CSE032
     C                   MOVEL     'SEA0218'     MsgIdXAr(IDx)                                CSE032
     C                   ENDIF                                                                CSE032
     C                   ELSE                                                                 CSE032
     C                   MOVE      'N'           OKSYBS                                       CSE032
     C                   ADD       1             IDx                                          CSE032
     C                   MOVEL     'DDSYBS'      FldNamXAr(IDx)                               CSE032
     C                   MOVEL     'SEA0248'     MsgIdXAr(IDx)                                CSE032
     C                   ENDIF                                                                CSE032
     C                   ENDIF                                                                CSE032
     C                   ENDIF

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
      ** Securities screen 2 details from incoming transaction
      ** - screen format
     C                   PARM                    NwSE2ScnFmt
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Securities screen 2 error indicators
     C                   PARM                    SEESEC2
      *
      ** Securities for file update - file format
     C                   PARM                    NwSEFilFmt
      *
      **  Determine if feature CSE032 is installed.                                           CSE032
      *                                                                                       CSE032
     C                   MOVE      'N'           CSE032            1                          CSE032
                                                                                              CSE032
     C                   CALLB     'AOSARDR0'                                                 CSE032
     C                   PARM      *BLANKS       @RTCD                                        CSE032
     C                   PARM      '*VERIFY'     @OPTN                                        CSE032
     C                   PARM      'CSE032'      @SARD                                        CSE032
      *                                                                                       CSE032
      ** Database error                                                                       CSE032
      *                                                                                       CSE032
     C     @RTCD         IFNE      *BLANKS                                                    CSE032
     C     @RTCD         ANDNE     '*NRF   '                                                  CSE032
     C                   MOVEL     'CSE032'      DBKEY                                        CSE032
     C                   MOVEL     'SCSARDPD'    DBFILE                         ************  CSE032
     C                   MOVEL     '901'         DBASE                          * DBERR 901*  CSE032
     C                   EXSR      *PSSR                                        ************  CSE032
     C                   ELSE                                                                 CSE032
     C     @RTCD         IFEQ      *BLANKS                                                    CSE032
     C                   MOVE      'Y'           CSE032                                       CSE032
     C                   END                                                                  CSE032
     C                   END                                                                  CSE032
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
**  CTDATA TABYBS            Valid Yield Basis entries
A C J R S U W Y DADMDYAU
