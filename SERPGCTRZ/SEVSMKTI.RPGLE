     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Validate market indicator')                   *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SEVSMKTI - Validate Market Indicator                         *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Component of: SESECSSIN                                      *
      *                SESECSCTL                                      *
      *                SESECSRPR                                      *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel.                     *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. MD023865           Date 01Jun20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CRE073             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CSE071             Date 19Jul05               *
      *                 CGL014             Date 20Oct03               *
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
      *  MD023865 - Not able to change Market Indicator from          *
      *             Securities Details Screen. Check only RECI = 'D'  *
      *             records for non-zero positions before issuing     *
      *             error message.                                    *
      *  MD046248 - Finastra Rebranding                               *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
      *  CGL014 - Collaterals Processing (Recompile)                  *
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
      ** Securities trade by security/receivers trade date
     FTRADSR    IF   E           K DISK    INFSR(*PSSR)
      *
      ** Securities user depot positions non-zero nominal
     FUDEPZ     IF   E           K DISK    INFSR(*PSSR)
      *
      ** Securities customer depot positions non-zero nominal
     FCDEPZ     IF   E           K DISK    INFSR(*PSSR)
      *
      ** Securities book position header
     FBKPHD     IF   E           K DISK    INFSR(*PSSR)
      *
      ** Securities book positions
     FBKPOS     IF   E           K DISK    INFSR(*PSSR)
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
      ** Securities screen 1 details from incoming transaction
      ** - screen format
     D NwSE1ScnFmt   E DS                  EXTNAME(SESEC1PD)
      *
      ** Securities screen 1 details retrieved from file
      ** - screen format
     D CrSE1ScnFmt   E DS                  EXTNAME(SESEC1PD)
     D                                     PREFIX(O)
      *
      ** Securities for file update - file format
     D NwSEFilFmt    E DS                  EXTNAME(SEVSECSPD)
      *
      ** Securities screen 1 error indicators
     D SEESEC1       E DS                  EXTNAME(SEESEC1PD)
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Index for arrays of error message ids, etc.
     D IDx             S              3P 0
      *
      ** Switchable feature
     D S01511          S              1A
      *
      ** Work parameter
     D PDMAR           S              1A
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
      ** Validate market indicator
      *
     C                   EXSR      SRValMktI
      *
      ** If an error has been found, set return code appropriately.
      ** Otherwise, update valid file fields.
      *
     C                   IF        OKMKTI = 'N'
     C                   EVAL      RetCodeIn = 'ERROR'
     C                   ENDIF

     C                   IF        OKMKTI <> 'N'
     C                   MOVEL     DDMKTI        S1MKTI
     C                   ENDIF

     C                   RETURN

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValMktI - Validation for Market Indicator                  *
      *                                                               *
      *****************************************************************
     C     SRValMktI     BEGSR
      *
      ** If field is blank, default market indicator from PF/INVTPD
      *
     C                   IF        DDMKTI = *BLANK
     C                   EVAL      DDMKTI = PDMAR
     C                   ENDIF

     C                   IF        DDMKTI <> 'G' AND
     C                             DDMKTI <> 'P' AND
     C                             DDMKTI <> 'S'
     C                   MOVE      'N'           OKMKTI
     C                   ADD       1             Idx
     C                   MOVEL     'DDMKTI'      FldNamXAr(IDx)
     C                   MOVEL     'SEA0117'     MsgIDXAr(IDx)
     C                   ENDIF
      *
      ** Check for allowable changes to market indicator
      *
     C                   IF        DDACTN = 'A'
      *
      ** IF 'G' is the original value, 'G', 'P' or 'S' is allowed
      ** If 'P' is the original value, 'P' or 'S' is allowed
      ** If 'S' is the original value, amendment is not allowed
      *
     C                   IF        (ODDMKTI = 'G' AND
     C                              DDMKTI <> 'G' AND
     C                              DDMKTI <> 'P' AND
     C                              DDMKTI <> 'S') OR

     C                             (ODDMKTI = 'P' AND
     C                              DDMKTI <> 'P' AND
     C                              DDMKTI <> 'S') OR

     C                              ODDMKTI = 'S' AND
     C                              DDMKTI <> 'S'

     C                   MOVE      'N'           OKMKTI
     C                   ADD       1             Idx
     C                   MOVEL     'DDMKTI'      FldNamXAr(IDx)
     C                   MOVEL     'SEA0118'     MsgIDXAr(IDx)
     C                   ENDIF
      *
      ** If S01511 is installed, only validate a change of market, if
      ** the change is from 'G' to another
      *
     C                   IF        DDMKTI <> ODDMKTI AND
     C                             (S01511 = 'N' OR
     C                             ODDMKTI = 'G')
     C                   EXSR      SrValDCMkt
     C                   ENDIF

     C                   ENDIF

     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVALDCMKT - Validation for Change of Market Processing      *
      *                                                               *
      *****************************************************************
     C     SRValDCMkt    BEGSR
      *
      ** Check LF/TRADSR - trades by security
      *
     C     DDSESN        SETLL     TRADSDF
     C     *IN01         DOWEQ     *OFF
     C     DDSESN        READE     TRADSDF                                01

     C                   IF        *IN01 = *OFF AND
     C                             TDMI = ODDMKTI
     C                   MOVE      'N'           OKMKTI
     C                   ADD       1             IDx
     C                   MOVEL     'DDMKTI'      FldNamXAr(IDx)
     C                   MOVEL     'SEA0119'     MsgIdXAr(IDx)
     C                   GOTO      EValDCMkt
     C                   ENDIF

     C                   ENDDO
      *
      ** Check LF/UDEPZ - user depot positions
      *
     C                   MOVE      *OFF          *IN01
     C     DDSESN        SETLL     UDEPPDF
     C     *IN01         DOWEQ     *OFF
     C     DDSESN        READE     UDEPPDF                                01

     C                   IF        *IN01 = *OFF and
     C                             (UECN <> *ZEROS OR                                       MD023865
     C                             UDNT <> *ZEROS OR                                        MD023865
     C                             UDNV <> *ZEROS OR                                        MD023865
     C                             UDNS <> *ZEROS OR                                        MD023865
     C                             UNRT <> *ZEROS OR                                        MD023865
     C                             UNRV <> *ZEROS) AND                                      MD023865
     C                             RECI = 'D' AND                                           MD023865
     C                             UDMK = ODDMKTI
     C                   MOVE      'N'           OKMKTI
     C                   ADD       1             IDx
     C                   MOVEL     'DDMKTI'      FldNamXAr(IDx)
     C                   MOVEL     'SEA0119'     MsgIdXAr(IDx)
     C                   GOTO      EValDCMkt
     C                   ENDIF

     C                   ENDDO
      *
      ** Check CDEPZ - customer depot positions
      *
     C                   MOVE      *OFF          *IN01
     C     DDSESN        SETLL     CDEPPDF
     C     *IN01         DOWEQ     *OFF
     C     DDSESN        READE     CDEPPDF                                01

     C                   IF        *IN01 = *OFF AND
     C                             (CECN <> *ZEROS OR                                       MD023865
     C                             CDNT <> *ZEROS OR                                        MD023865
     C                             CDNV <> *ZEROS OR                                        MD023865
     C                             CDNS <> *ZEROS) AND                                      MD023865
     C                             RECI = 'D' AND                                           MD023865
     C                             CDMK = ODDMKTI
     C                   MOVE      'N'           OKMKTI
     C                   ADD       1             IDx
     C                   MOVEL     'DDMKTI'      FldNamXAr(IDx)
     C                   MOVEL     'SEA0119'     MsgIdXAr(IDx)
     C                   GOTO      EValDCMkt
     C                   ENDIF

     C                   ENDDO
      *
      ** Check LF/BKPHD - book positions header
      *
     C                   MOVE      *OFF          *IN01
     C     DDSESN        SETLL     BKPHDDF
     C     *IN01         DOWEQ     *OFF
     C     DDSESN        READE     BKPHDDF                                01

     C                   IF        *IN01 = *OFF AND
     C                             RECI = 'D'
      *
      ** Check BKPOSD of record found on header
      *
     C     KBPKY         CHAIN     BKPOS                              01

     C                   IF        *IN01 = *OFF AND
     C                             (ECNP <> *ZEROS OR
     C                             NPSN <> *ZEROS) AND
     C                             BPMK = ODDMKTI
     C                   MOVE      'N'           OKMKTI
     C                   ADD       1             IDx
     C                   MOVEL     'DDMKTI'      FldNamXAr(IDx)
     C                   MOVEL     'SEA0119'     MsgIdXAr(IDx)
     C                   ENDIF

     C                   ENDIF

     C                   ENDDO

     C     EValDCMkt     ENDSR

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
      ** Securities screen 1 details from incoming transaction
      ** - screen format
     C                   PARM                    NwSE1ScnFmt
      *
      ** Securities screen 1 details retrieved from file
      ** - screen format
     C                   PARM                    CrSE1ScnFmt
      *
      ** Default market indicator from, PF/INVTPD
     C                   PARM                    PDMAR
      *
      ** SWITCHABLE FEATURES
      ** ===================
      *
      ** Market migration
     C                   PARM                    S01511
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Securities screen 1 error indicators
     C                   PARM                    SEESEC1
      *
      ** Securities for file update - file format
     C                   PARM                    NwSEFilFmt
      *
      ** Key to access book position records.
      *
     C     KBPKY         KLIST
     C                   KFLD                    BHSC
     C                   KFLD                    BHBA
     C                   KFLD                    BHBK
     C                   KFLD                    BHMK
     C                   KFLD                    BHTV
     C                   KFLD                    LPSD
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
