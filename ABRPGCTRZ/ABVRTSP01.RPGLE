     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas AB Validate FUND Rate/Spread')                   *
      *****************************************************************
      *                                                               *
      *  Midas - Internal Funding Module                              *
      *                                                               *
      *  ABVRTSP01 - Validate FUND Rate/Spread                        *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel.                     *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. CGL165             Date 17Feb15               *
      *  Prev Amend No. CDL096             Date 22Sep14               *
      *                 CRE073             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CDL049             Date 04Jul06               *
      *                 CDL038             Date 10May05               *
      *                 CSD027             Date 09Dec05               *
      *                 CGL029             Date 01Sep03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CAP042  *CREATE    Date 08Jan01               *
      *                                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CAP042 - Conversion of Internal Funding Deal inputs into     *
      *           modular structure to use as APIs.                   *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * SRValRTSP - Validate Rate/Spread                              *
      * SRZA0840  - Validate field is numeric                         *
      * *INZSR    - Initialise                                        *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
      ** Standard D-specs
      ** ================
 
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *On (for indicator processing)
      **    False      logical = *Off (for indicator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
 
      /COPY ZACPYSRC,STD_D_SPEC
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
      /COPY ZACPYSRC,PSDS
 
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the size
      ** of the arrays.
 
      /COPY ZACPYSRC,ERR_XARRYS
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** New Deal in Screen Format
     D NwDlScnFmt    E DS                  EXTNAME(ABFUNDPD)
     D                                     Prefix(DD:2)
 
      ** Internal funding deals error indicator file
     D OkFlags       E DS                  EXTNAME(ABEFUNDPD)
 
      ** New Deal in File Format of main deal
     D NwDlFilFmt1   E DS                  EXTNAME(MMVLDNIPD)
     D                                     Prefix(N1:2)
     D  N1DORIQQ     E                     EXTFLD(QQDORI)                                     CGL029
     D  N1MORIQQ     E                     EXTFLD(QQMORI)                                     CGL029
     D  N1DOPIQQ     E                     EXTFLD(QQDOPI)                                     CGL029
     D  N1MOPIQQ     E                     EXTFLD(QQMOPI)                                     CGL029
     D  N1RONSQQ     E                     EXTFLD(QQRONS)                                     CGL029
     D  N1PONSQQ     E                     EXTFLD(QQPONS)                                     CGL029
     D  N1INSAQQ     E                     EXTFLD(QQINSA)                                     CGL029
 
      ** New Deal in File Format of associated deal
     D NwDlFilFmt2   E DS                  EXTNAME(MMVLDNIPD)
     D                                     Prefix(N2:2)
     D  N2DORIQQ     E                     EXTFLD(QQDORI)                                     CGL029
     D  N2MORIQQ     E                     EXTFLD(QQMORI)                                     CGL029
     D  N2DOPIQQ     E                     EXTFLD(QQDOPI)                                     CGL029
     D  N2MOPIQQ     E                     EXTFLD(QQMOPI)                                     CGL029
     D  N2RONSQQ     E                     EXTFLD(QQRONS)                                     CGL029
     D  N2PONSQQ     E                     EXTFLD(QQPONS)                                     CGL029
     D  N2INSAQQ     E                     EXTFLD(QQINSA)                                     CGL029
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of error message ids, etc.
     D IDx             S              3P 0
 
      ** Work Variables
     D WRateSpred      S             11P 7
     D WInIntRate      S             11P 7
     D WIntRate        S             11P 7
     D WVRTSP          S             11P 7
 
      ** Work Parameters
     D PRate           S             11P 7
 
      ** Parameters for ZA0840
     D PRetCode        S                   LIKE(ReturnCode)
     D PAlpha          S             16A
     D PIDP            S              3  0
     D PIINT           S              3  0
     D PIMTID          S              1A
     D POErrCde        S              1  0
     D POAmount        S             15  0
     D BNDCSP          S              1A
 
      ** Pointer for the indicator Array
     D IndicatorP      S               *   INZ(%Addr(*IN))
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ *INZSR is executed at program activation.                  ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
 
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
 
      ** Initialise work variables
 
     C                   EVAL      IDx = 0
     C                   EVAL      WRateSpred = 0
     C                   EVAL      WInIntRate = 0
     C                   EVAL      WIntRate = 0
     C                   EVAL      WVRTSP = 0
     C                   EVAL      POAmount = 0
     C                   EVAL      POErrCde = 0
     C                   EVAL      PAlpha = *Blanks
 
     C                   EXSR      SRValRTSP
 
      ** If an error has been found, set return code appropriately.
      ** Otherwise, update valid file fields.
 
     C                   IF        OKRTSP <> 'Y'
 
     C                   EVAL      RetCodeIn = 'ERROR'
 
     C                   ELSE
 
     C                   EVAL      N1INTR = WIntRate
     C                   EVAL      N1SPRD = WRateSpred
     C                   EVAL      N1IIRT = WInIntRate
 
     C                   EVAL      N2INTR = WIntRate
     C                   EVAL      N2SPRD = WRateSpred
     C                   EVAL      N2IIRT = WInIntRate
 
     C                   ENDIF
 
      *                  ======
     C                   RETURN
      *                  ======
 
      *****************************************************************
      *  P R O G R A M   E N D                                        *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValRTSP - Validate Rate/Spread                             *
      *                                                               *
      *****************************************************************
 
     C     SRValRTSP     BEGSR
 
      **  If the spread/rate is blank, this is an error unless base
      **  rate code is entered
 
     C                   IF        DDRTSP = *BLANKS AND
     C                             DDBRTT = *BLANKS
 
     C                   EVAL      IDx = IDx + 1
 
     C                   IF        DDACTN = 'I'
 
     C                   EVAL      OKRTSP = 'N'
     C                   EVAL      FldNamXAr(IDx)= '#1RTSP'
 
     C                   ELSE
 
     C                   EVAL      OKBRTT = 'N'
     C                   EVAL      FldNamXAr(IDx)= '#1BRTT'
 
     C                   ENDIF
 
     C                   EVAL      MsgIdXAr(IDx) = 'MMM0419'
     C                   GOTO      EndValRTSP
 
     C                   ENDIF
 
     C                   IF        DDRTSP <> *BLANKS
 
      ** Check it is a valid figure with 7 decimal places max
 
     C                   Z-ADD     7             PIDP
     C                   Z-ADD     4             PIINT
     C                   MOVE      *Blanks       PAlpha
     C                   MOVE      DDRTSP        PAlpha
     C                   Z-ADD     *Zero         POAmount
     C                   MOVE      'N'           PIMTID
     C                   EXSR      SRZA0840
 
     C                   IF        POErrCde <> 0
 
     C                   EVAL      OKRTSP = 'N'
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNamXAr(IDx)= '#1RTSP'
     C                   EVAL      MsgIdXAr(IDx) = 'MMM0422'
     C                   GOTO      EndValRTSP
 
     C                   ENDIF
 
     C                   ENDIF
 
      **  If the spread/rate is valid, determine the effective rate and
      **  place it in the Deal format
 
     C                   MOVE      POAmount      WVRTSP
     C                   MOVE      PAlpha        DDRTSP
 
     C                   IF        DDBRTT <> *BLANKS
 
     C                   EVAL      WIntRate = WVRTSP + PRate
     C                   Z-ADD     WVRTSP        WRateSpred
     C                   Z-ADD     *Zero         WInIntRate
 
     C                   ELSE
 
     C                   Z-ADD     WVRTSP        WIntRate
     C                   Z-ADD     *Zero         WRateSpred
     C                   Z-ADD     WVRTSP        WInIntRate
 
     C                   ENDIF
 
     C     EndValRTSP    ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRZA0840 - Validate field is numeric                         *
      *                                                               *
      *****************************************************************
 
     C     SRZA0840      BEGSR
 
     C                   CALLB     'ZA0840'
     C                   PARM                    PRetCode
     C                   PARM                    PAlpha
     C                   PARM                    PIDP
     C                   PARM                    PIINT
     C                   PARM                    PIMTID
     C                   PARM                    POErrCde
     C                   PARM                    POAmount
     C                   PARM                    BNDCSP
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
 
      ** INPUT
      ** =====
 
      ** Return Code
     C                   PARM                    RetCodeIn
 
      ** New Deal in Screen Format
     C                   PARM                    NwDlScnFmt
 
      ** Rate from ZAVBRATCDE
     C                   PARM                    PRate
 
      ** Standing Data
      ** =============
 
      ** SDDEAL: Decimal Separator
     C                   PARM                    BNDCSP
 
      ** OUTPUT
      ** ======
 
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIdXAr
     C                   PARM                    MsgDtaXAr
 
      ** Internal funding deals error indicator file
     C                   PARM                    OkFlags
 
      ** New Deal in File Format of main deal
     C                   PARM                    NwDlFilFmt1
 
      ** New Deal in File Format of associated deal
     C                   PARM                    NwDlFilFmt2
 
      ** Program, module and procedure names for dbase error processing
      ** ==============================================================
      ** The following /COPY sets these values.
 
      /COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
 
      /COPY ZACPYSRC,PSSR_ILE
 
      *****************************************************************
      /EJECT
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
