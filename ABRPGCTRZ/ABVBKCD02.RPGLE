     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas AB Validate FUND Book Code 2')                   *
      *****************************************************************
      *                                                               *
      *  Midas - Internal Funding Module                              *
      *                                                               *
      *  ABVBKCD02 - Validate FUND Book Code 2                        *
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
      *                 CDL049             Date 11May06               *
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
      *  Use of indicators.                                           *
      *                                                               *
      *    05         SCAN: String '?' found indicator                *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * SRValBOK2 - Validate Book Code 2                              *
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
 
      ** Externally described DS for Book Code details
     D SDBOOK        E DS                  EXTNAME(SDBOOKPD)
 
      ** DS for Access Objects - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Indicator Array
     D Indicators      DS                  BASED(IndicatorP)
     D  StrFoundIn            05     05
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of error message ids, etc.
     D IDx             S              3P 0
 
      ** Mode of processing
     D PMode           S              6A
 
      ** Redisplay screen flag
     D PReDsp          S              1A
 
      ** Work Variables
     D WBookCode2      S              2A
 
      ** Parameters for module AOBOOKR0
     D PRtCd           S              7A
     D POptn           S              7A
     D PKey            S              3A
 
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
     C                   EVAL      WBookCode2 = *Blank
 
     C                   EXSR      SRValBOK2
 
      ** If an error has been found, set return code appropriately.
      ** Otherwise, update valid file fields.
 
     C                   IF        OKBOK2 <> 'Y'
 
     C                   EVAL      RetCodeIn = 'ERROR'
 
     C                   ELSE
 
     C                   EVAL      N2BOKC = WBookCode2
 
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
      *  SRValBOK2 - Validate Book Code 2                             *
      *                                                               *
      *****************************************************************
 
     C     SRValBOK2     BEGSR
 
      ** Field is mandatory
 
     C                   IF        DDBOK2 = *Blanks
 
     C                   EVAL      OKBOK2 = 'N'
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNamXAr(IDx)= '#1BOK2'
     C                   EVAL      MsgIdXAr(IDx) = 'FXM1037'
     C                   GOTO      EndValBOK2
 
     C                   ENDIF
 
     C     '?'           SCAN      DDBOK2                                 05
 
     C                   IF        StrFoundIn = True
 
     C                   EVAL      PReDsp = 'Y'
 
     C                   IF        PMode = '*FRONT'
 
     C                   EVAL      OKBOK2 = 'N'
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNamXAr(IDx)= '#1BOK2'
     C                   EVAL      MsgIdXAr(IDx) = 'FXM1038'
     C                   GOTO      EndValBOK2
 
     C                   ENDIF
 
     C                   ENDIF
 
      ** Validate if Book Code is existing
 
     C                   CALLB     'AOBOOKR0'
     C                   PARM      *Blanks       PRtcd
     C                   PARM      '*KEY'        POptn
     C                   PARM      DDBOK2        PKey
     C     SDBOOK        PARM      SDBOOK        DSFDY
 
     C                   IF        PRtcd <> *Blanks
 
      ** If no select
 
     C                   IF        PRtcd = '*NOSEL '
 
     C                   EVAL      DDBOK2 = *Blank
     C                   EVAL      OKBOK2 = 'N'
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNamXAr(IDx)= '#1BOK2'
     C                   EVAL      MsgIdXAr(IDx) = 'FXM1037'
     C                   GOTO      EndValBOK2
 
     C                   ELSE
 
     C                   EVAL      OKBOK2 = 'N'
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNamXAr(IDx)= '#1BOK2'
     C                   EVAL      MsgIdXAr(IDx) = 'FXM1038'
     C                   GOTO      EndValBOK2
 
     C                   ENDIF
 
     C                   ELSE
 
     C                   EVAL      WBookCode2 = BDBKCD
     C                   EVAL      DDBOK2 = BDBKCD
 
     C                   ENDIF
 
     C     EndValBOK2    ENDSR
 
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
 
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair function)
      ** Mode = '*SIN  ' (Screen input function)
     C                   PARM                    PMode
 
      ** New Deal in Screen Format
     C                   PARM                    NwDlScnFmt
 
      ** OUTPUT
      ** ======
 
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIdXAr
     C                   PARM                    MsgDtaXAr
 
      ** Internal funding deals error indicator file
     C                   PARM                    OkFlags
 
      ** New Deal in File Format of associated deal
     C                   PARM                    NwDlFilFmt2
 
      ** Redisplay screen flag
     C                   PARM                    PReDsp
 
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
