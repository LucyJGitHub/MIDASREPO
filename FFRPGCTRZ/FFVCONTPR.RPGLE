     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FF Validate contract price')                     *
      *****************************************************************
      *                                                               *
      *  Midas - Financial Futures and Options module                 *
      *                                                               *
      *  FFVCONTPR - Validate contract price                          *
      *                                                               *
      *  Function:  This module checks the validity of the contract   *
      *             price on an FF trade .                            *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CAP208             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CPL002             Date 08Mar99               *
      *                 CAP004  *CREATE    Date 01Jun98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CAP208 - F&O Market Instrument API (Recompile)               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CPL002 - Midas-Plato Interface (Recompiled)                  *
      *  CAP004 - Conversion of Midas inputs to APIs                  *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Midas FF Market Price
     FPRICS     IF   E           K DISK
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the definitions of the error
      ** arrays, including the named constant giving the size of
      ** the arrays.  Note that it uses #MsgID and #MsgData, and so requires
      ** STD_D_SPEC.
     D/COPY ZACPYSRC,FVAL_ARRAY
      **--------------------------------------------------------------------------------------------
 
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
 
     D FFEEXTR       E DS                  EXTNAME(FFEEXTRPD)
      ** Error indicators
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D INTYP         E DS                  EXTNAME(INTYPD)
      ** Instrument types data structure
 
     D WMIODS          DS            61                                         CFF004
      ** Work fields - Market Instrument / O.T.C.  details
     D  WBOCO                  1      6  0
     D  WCUSC                  7     12  0
     D  WMIOAM                32     61
     D  WTRSD                 32     36  0
     D  WNUCO                 37     41  0
     D  WCOPR                 42     56  8
     D  WCPINT                42     48  0
     D  WCPDP1                49     49  0
     D  WCPDP2                49     50  0
     D  WCPDP3                49     51  0
     D  WVALD                 57     61  0
 
     D                 DS
      ** New Price redefined
     D  NEWP                   1     15  8                                      CFF004
     D  NPINT                  1      7  0                                      CFF004
     D  NPDP1                  8      8  0                                      CFF004
     D  NPDP2                  8      9  0                                      CFF004
     D  NPDP3                  8     10  0                                      CFF004
 
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Contract price
     D SCOPR           S             16A
 
      ** Screen price
     D FFSPRC          S                   LIKE(SCOPR)
 
      ** Ticks Denominator
     D FFTKDM          S              3P 0
 
      ** Minmum price fluctuation
     D FFMNPF          S             15P 8
 
      ** File conversion of price
     D FFPRIC          S                   LIKE(FFMNPF)
 
      ** Put call
     D SPCAL           S                   LIKE(KPCALP)
 
      ** Year number
     D WYRNO           S              2S 0
 
      ** Month number
     D WMTHN           S                   LIKE(WYRNO)
 
      ** Strike price
     D WSTRP           S             15P 8
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
 
     C     Start         TAG
      ** Note: the above tag is only there to force the first comments in
      ** the C-specs to appear after the D- or I-specs in compiled listings.
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *inzsr is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      ** Reset error fields
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line resets the fields related to error
      ** handling: ReturnCode, ErrorFound, WarnFound, FldNamXArr, MsgIDXArr,
      ** MsgDtaXArr, XIdx.  It therefore requires FVAL_ARRAY and STD_D_SPEC.
     D/COPY ZACPYSRC,FVAL_RESET
      **--------------------------------------------------------------------------------------------
 
 
      **   - contract price cannot be blank
     C     SCOPR         IFEQ      *BLANK
 
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      XIdx = XIdx + 1
     C                   EVAL      FldNamXArr(XIdx) = 'SCOPR'
     C                   EVAL      MsgIDXArr(XIdx) = 'MMA0338'
 
     C                   GOTO      VCPEND
     C                   END
 
      **  - convert screen contract price to file format
     C                   Z-ADD     TKDM          FFTKDM
     C                   Z-ADD     MNPF          FFMNPF
     C                   MOVE      SCOPR         FFSPRC
 
     C                   CALLB     'FFPRVL'
      ** Parameters rerturned to caller
      ** ------------------------------
      ** Return code (10A, returned to caller)
     C                   PARM                    ReturnCode
      ** File version of price (15,8P)
     C                   PARM                    FFPRIC
 
      ** Parameters received from caller
      ** -------------------------------
      ** Screen version of price (16A)
     C                   PARM                    FFSPRC
      ** Ticks denominator (3,0P)
     C                   PARM                    FFTKDM
      ** Minmum price fluctuation (15,8P)
     C                   PARM                    FFMNPF
 
      **   - invalid format
     C     ReturnCode    IFNE      *BLANKS
 
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      XIdx = XIdx + 1
     C                   EVAL      FldNamXArr(XIdx) = 'SCOPR'
     C                   EVAL      MsgIDXArr(XIdx) = 'MMA0339'
 
     C                   GOTO      VCPEND
     C                   END
      **   - valid format
     C                   Z-ADD     FFPRIC        WCOPR
 
      **   - cannot be zero
     C     WCOPR         IFEQ      0
 
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      XIdx = XIdx + 1
     C                   EVAL      FldNamXArr(XIdx) = 'SCOPR'
     C                   EVAL      MsgIDXArr(XIdx) = 'MMA0338'
 
     C                   GOTO      VCPEND
     C                   END
 
      **   - convert FF contract price from file to screen format
     C                   CALLB     'FFPRCS'
      ** Parameters returned to caller
      ** -----------------------------
      ** Return code (10A, returned to caller)
     C                   PARM                    ReturnCode
      ** Screen version of price (16A)
     C                   PARM                    FFSPRC
 
      ** Parameters received from caller
      ** -------------------------------
      ** File version of price (15,8P)
     C                   PARM                    FFPRIC
      ** Tick denominator (3,0P)
     C                   PARM                    FFTKDM
      ** Minimum price fluctuation (15,8P)
     C                   PARM                    FFMNPF
 
      **   - valid format
     C     ReturnCode    IFEQ      *BLANKS
     C                   MOVE      FFSPRC        SCOPR
     C                   END
 
     C/SPACE 2
      **   Warning Errors (process only if Year, Month, Put/Call,
      **   ~~~~~~~~~~~~~~  Strike Price + Contract Price not in error)
 
 
     C     OKMTHN        IFNE      'Y'
     C     OKYRNO        ORNE      'Y'
     C     OKPCAL        ORNE      'Y'
     C     OKSTRP        ORNE      'Y'
     C                   GOTO      VCPEND
     C                   END
 
     C                   MOVE      ISTT          KISTTP
     C                   MOVE      WYRNO         KYRNOP
     C                   MOVE      WMTHN         KMTHNP
     C                   MOVE      SPCAL         KPCALP
     C                   MOVE      WSTRP         KSTRPP
 
     C     KPRICS        CHAIN     PRICSDF                            71
     C  N71RECI          COMP      'D'                                7171
 
      **   1. No Prices record
     C     *IN71         IFEQ      '1'
 
     C                   EVAL      WarnFound = 'Y'
     C                   EVAL      WIdx = WIdx + 1
     C                   EVAL      FldNamWArr(WIdx) = 'SCOPR'
     C                   EVAL      MsgIDWArr(WIdx) = 'MMA0340'
 
     C                   GOTO      VCPEND
     C                   END
 
      **   Calculate upper and lower limits for the 'New Price'
     C                   Z-ADD     0             NEWPTK           17 8
     C                   Z-ADD     0             WCPTKS           17 8
 
      **   - if Ticks Denom = 100 , decimal quotation
     C     TKDM          IFEQ      100
     C     WCOPR         MULT      100           WCPTKS
     C     NEWP          MULT      100           NEWPTK
 
     C                   ELSE
 
      **   - Convert  Price integer to a No of Ticks
     C     WCPINT        MULT      TKDM          WCPTKS
     C     NPINT         MULT      TKDM          NEWPTK
 
      **   - Add remaining Ticks to this
 
      **     - if Ticks Denom <= 10  use 1st dec place
     C     TKDM          IFLE      10
     C                   ADD       WCPDP1        WCPTKS
     C                   ADD       NPDP1         NEWPTK
     C                   ELSE
 
      **     - if Ticks Denom <= 99  use 1-2nd dec places
     C     TKDM          IFLE      99
     C                   ADD       WCPDP2        WCPTKS
     C                   ADD       NPDP2         NEWPTK
     C                   ELSE
 
      **     - if Ticks Denom <= 999  use 1-3rd dec places
     C                   ADD       WCPDP3        WCPTKS
     C                   ADD       NPDP3         NEWPTK
     C                   END
 
     C                   END
 
     C                   END
 
     C     NEWPTK        MULT(H)   1.1           MAXTKS           17 8
     C     NEWPTK        MULT(H)   0.9           MINTKS           17 8
 
      **   2. Varies from new price by more than 10%
     C     WCPTKS        IFLT      MINTKS
     C     WCPTKS        ORGT      MAXTKS
 
     C                   EVAL      WarnFound = 'Y'
     C                   EVAL      WIdx = WIdx + 1
     C                   EVAL      FldNamWArr(WIdx) = 'SCOPR'
     C                   EVAL      MsgIDWArr(WIdx) = 'MMA0341'
 
     C                   END
 
     C     VCPEND        TAG
 
      **--------------------------------------------------------------------------------------------
      ** The return code is set in the following /COPY:
     C/COPY ZACPYSRC,SETRETCDE
      **--------------------------------------------------------------------------------------------
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *inzsr - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *inzsr        BEGSR
 
     C     *entry        PLIST
      ** Parameters returned to caller
      ** -----------------------------
      ** Return code (10A, returned to caller)
     C                   PARM                    ReturnCode
      ** Field name array (<ErrArrMax> x 10A, returned to caller)
     C                   PARM                    FldNamXArr
      ** Error message ID array (<ErrArrMax> x 7A, returned to caller)
     C                   PARM                    MsgIDXArr
      ** Error message data array (<ErrArrMax> x 45A, returned to caller)
     C                   PARM                    MsgDtaXArr
 
      ** Field name array (<WArrMax> x 10A, returned to caller)
     C                   PARM                    FldNamWArr
      ** Warning message ID array (<WArrMax> x 7A, returned to caller)
     C                   PARM                    MsgIDWArr
      ** Warning message data array (<WArrMax> x 45A, returned to caller)
     C                   PARM                    MsgDtaWArr
      ** Numeric (file) version of price (15,8P)
     C                   PARM                    FFPRIC
 
      ** Parameters received from caller
      ** -------------------------------
      ** Contract price (16A)
     C                   PARM                    SCOPR
      ** Year number (2,0S, from transaction)
     C                   PARM                    WYRNO
      ** Month number (2,0S, from transaction)
     C                   PARM                    WMTHN
      ** Put call indicator (1A, from transaction)
     C                   PARM                    SPCAL
      ** Strike price (15,8P, from transaction)
     C                   PARM                    WSTRP
      ** Instrument types (DS, from INTYPD)
     C                   PARM                    INTYP
      ** OK flags
     C                   PARM                    FFEEXTR
 
      **--------------------------------------------------------------------------------------------
 
      ** Key list for  PRICS
     C     KPRICS        KLIST
     C                   KFLD                    KISTTP            5
     C                   KFLD                    KYRNOP            2 0
     C                   KFLD                    KMTHNP            2 0
     C                   KFLD                    KPCALP            1
     C                   KFLD                    KSTRPP           15 8
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY sets the values of program, module and
      ** procedure names for database error processing.
     C/COPY ZACPYSRC,DBFIELDS
      **--------------------------------------------------------------------------------------------
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      **--------------------------------------------------------------------------------------------
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILE
      **--------------------------------------------------------------------------------------------
      ********************************************************************
      /EJECT
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
