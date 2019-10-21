     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas AB Validate FUND Int. Freq. Day in Month')       *
      *****************************************************************
      *                                                               *
      *  Midas - Internal Funding Module                              *
      *                                                               *
      *  ABVITFQ01 - Validate FUND Int. Freq. Day in Month            *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel.                     *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. CER050             Date 16Jun19               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CGL165             Date 17Feb15               *
      *                 CDL096             Date 22Sep14               *
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
      *  CER050 - Annualised Percentage Rate (Recompile)              *
      *  MD046248 - Finastra Rebranding                               *
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
      * SRValINTF - Validate Interest Frequency Day in Month          *
      * SRZAlign  - Validate numeric fields                           *
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

      ** Value Date Data structure
     D DSValDate       DS
     D  WVDAT1                 1      2  0
     D  WVDAT2                 3      4  0
     D  WVYEAR                 5      6  0

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      ** Index for arrays of error message ids, etc.
     D IDx             S              3P 0

      ** Work Parameters
     D BJDFIN          S              1A

      ** Work Variables
     D WIntFrDIM       S              2  0

      ** Parameters for ZALIGN
     D ZAlignOk        S              1A
     D ZField          S             16A
     D ZADEC           S              1P 0
     D ZADIG           S              2P 0

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
     C                   EVAL      WintFrDIM = 0

     C                   EXSR      SRValINTF

      ** If an error has been found, set return code appropriately.
      ** Otherwise, update valid file fields.

     C                   IF        OKINTF = 'N'

     C                   EVAL      RetCodeIn = 'ERROR'

     C                   ELSE

     C                   EVAL      N1IPDM = WIntFrDIM

     C                   EVAL      N2IPDM = WIntFrDIM

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
      *  SRValINTF - Validate Interest Frequency Day in Month         *
      *                                                               *
      *****************************************************************

     C     SRValINTF     BEGSR

      ** If the interest frequency day in month is not blank, and is
      ** not an integer between 00 and 31 it is an error

     C                   IF        DDINTF <> *Blanks

     C                   EXSR      SRFmtDlNo

     C                   MOVE      *Blanks       ZField
     C                   MOVE      DDINTF        ZField
     C                   Z-ADD     0             ZADEC
     C                   Z-ADD     2             ZADIG
     C                   EXSR      SRZAlign

     C                   IF        ZAlignOk = 'N'

     C                   Z-ADD     *Zero         WIntFrDIM

     C                   EVAL      OKINTF = 'N'
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNamXAr(IDx)= '#1INTF'
     C                   EVAL      MsgIdXAr(IDx) = 'MMM0455'
     C                   GOTO      EndValINTF
     C
     C                   ENDIF

     C                   MOVE      DDINTF        WIntFrDIM

     C                   IF        WIntFrDIM < 0 OR
     C                             WIntFrDIM > 31

     C                   Z-ADD     *Zero         WIntFrDIM

     C                   EVAL      OKINTF = 'N'
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNamXAr(IDx)= '#1INTF'
     C                   EVAL      MsgIdXAr(IDx) = 'MMM0455'
     C                   GOTO      EndValINTF

     C                   ENDIF

     C                   ELSE

      ** Interest Frequency Day in Month is blank

     C                   Z-ADD     *ZERO         WIntFrDIM

     C                   ENDIF

      ** If the interest frequency day in month is not blank, and the
      ** interest frequency is *blank, this is an error

     C                   IF        DDINTF <> *Blanks AND
     C                             DDIPFR = *Blanks

     C                   EVAL      OKINTF = 'N'
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNamXAr(IDx)= '#1INTF'
     C                   EVAL      MsgIdXAr(IDx) = 'MMM0456'
     C                   GOTO      EndValINTF

     C                   ENDIF

      ** If the next interest date is valid and not blank, and
      ** the value and Maturity dates are valid, and the interest
      ** payment day in month is Zero, set the day in month
      ** to the days part of the value date

     C                   IF        DDNIDT <> *Blank AND
     C                             OKVDAT <> 'N' AND
     C                             OKMDAT <> 'N' AND
     C                             OKNIDT <> 'N' AND
     C                             OKINTF <> 'N'

     C                   IF        WIntFrDIM = *Zero AND
     C                             DDIPFR <> *Blank

     C                   MOVE      DDVDAT        DSValDate

     C                   IF        BJDFIN = 'D'

     C                   EVAL      WIntFrDIM = WVDAT1

     C                   ELSE

     C                   EVAL      WIntFrDIM = WVDAT2

     C                   ENDIF

     C                   ENDIF

     C                   ENDIF

     C     EndValINTF    ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRZAlign - Validate numeric fields                           *
      *                                                               *
      *****************************************************************

     C     SRZAlign      BEGSR

     C                   CALLB     'ZALIGN'
     C                   PARM                    ZAlignOk
     C                   PARM                    ZField
     C                   PARM                    ZADEC
     C                   PARM                    ZADIG

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRFmtDlNo - Format entry before validation                    *
      *                                                               *
      *****************************************************************

     C     SRFmtDlNo     BEGSR

     C                   Z-ADD     0             PIDP
     C                   Z-ADD     2             PIINT
     C                   MOVE      *Blanks       PAlpha
     C                   MOVE      DDINTF        PAlpha
     C                   Z-ADD     *Zero         POAmount
     C                   MOVE      'N'           PIMTID

     C                   CALLB     'ZA0840'
     C                   PARM                    PRetCode
     C                   PARM                    PAlpha
     C                   PARM                    PIDP
     C                   PARM                    PIINT
     C                   PARM                    PIMTID
     C                   PARM                    POErrCde
     C                   PARM                    POAmount
     C                   PARM                    BNDCSP

     C                   IF        POErrCde = 0

     C                   MOVE      POAmount      DDINTF

     C                   ENDIF

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

      ** Standing Data
      ** =============

      ** SDBANK: Date Format Indicator
     C                   PARM                    BJDFIN
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
(c) Finastra International Limited 2001
