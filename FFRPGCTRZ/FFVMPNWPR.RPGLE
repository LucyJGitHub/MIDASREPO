     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2006')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FF Validate new price')                          *
      *****************************************************************
      *                                                               *
      *  Midas - Financial Futures and Options module                 *
      *                                                               *
      *  FFVMPNWPR - Validate New Price                               *
      *                                                               *
      *  Function:  This module checks the validity of the new        *
      *             price on an FF trade.                             *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2006            *
      *                                                               *
      *  Last Amend No. CAP208             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      *  Prev Amend No. 245143             Date 24Jan07               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG10387           Date 06Feb06               *
      *                 CAP183  *Create    Date 05Jan06               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CAP208 - F&O Market Instrument API (Recompile)               *
      *  245143 - Reinstate chaining of PRICS.                        *
      *  BUG10387 - Checks Market Code even if OTC                    *
      *  CAP183 - Conversion of Market Prices Input into modular      *
      *           structure to use APIs.                              *
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
 
      ** Error indicators
     D FFEMPRI       E DS                  EXTNAME(FFEMPRIPD)
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Instrument types data structure
     D INTYP         E DS                  EXTNAME(INTYPD)
 
      ** Work fields - Market Instrument / O.T.C.  details
     D WMIODS          DS            61
     D  WBOCO                  1      6  0
     D  WCUSC                  7     12  0
     D  WMIOAM                32     61
     D  WTRSD                 32     36  0
     D  WNUCO                 37     41  0
     D  WNEWP                 42     56  8
     D  WCPINT                42     48  0
     D  WCPDP1                49     49  0
     D  WCPDP2                49     50  0
     D  WCPDP3                49     51  0
     D  WVALD                 57     61  0
 
      ** New Price redefined
     D                 DS
     D  NEWP                   1     15  8
     D  NPINT                  1      7  0
     D  NPDP1                  8      8  0
     D  NPDP2                  8      9  0
     D  NPDP3                  8     10  0
 
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Contract price
     D DDNEWP          S             16A
 
      ** Screen price
     D FFSPRC          S                   LIKE(DDNEWP)
 
      ** Ticks Denominator
     D FFTKDM          S              3P 0
 
      ** Minimum price fluctuation
     D FFMNPF          S             15P 8
 
      ** File conversion of price
     D FFPRIC          S                   LIKE(FFMNPF)
 
      ** Put call
     D***DDPCAL*         S                   LIKE(KPCALP)                                   BUG10387
     D DDPCAL          S              1A                                                    BUG10387
 
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
 
 
      *
      ** New price cannot be blank
      *
     C     DDNEWP        IFEQ      *BLANK
 
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      XIdx = XIdx + 1
     C                   EVAL      FldNamXArr(XIdx) = 'DDNEWP'
     C                   EVAL      MsgIDXArr(XIdx) = 'MMA2116'
 
     C                   GOTO      VCPEND
     C                   ENDIF
 
      *
      ** Convert screen new price to file format
      *
     C                   Z-ADD     TKDM          FFTKDM
     C                   Z-ADD     MNPF          FFMNPF
     C                   MOVE      DDNEWP        FFSPRC
 
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
      *
      ** Invalid format returned
      *
     C     ReturnCode    IFNE      *BLANKS
 
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      XIdx = XIdx + 1
     C                   EVAL      FldNamXArr(XIdx) = 'DDNEWP'
     C                   EVAL      MsgIDXArr(XIdx) = 'MMA2116'
 
     C                   GOTO      VCPEND
     C                   ENDIF
      *
      ** Valid Format returned
      *
     C                   Z-ADD     FFPRIC        WNEWP
      *
      ** New Price cannot be zero
      *
     C     WNEWP         IFEQ      0
 
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      XIdx = XIdx + 1
     C                   EVAL      FldNamXArr(XIdx) = 'DDNEWP'
     C                   EVAL      MsgIDXArr(XIdx) = 'MMA2116'
 
     C                   GOTO      VCPEND
     C                   ENDIF
      *
      *
      ** Convert FF new price from file to screen format
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
      *
      ** Valid format
      *
     C     ReturnCode    IFEQ      *BLANKS
     C                   MOVE      FFSPRC        DDNEWP
     C                   ENDIF
      *
      *
     C/SPACE 2
      **   Warning Errors (process only if Year, Month, Put/Call,
      **   ~~~~~~~~~~~~~~  Strike Price + Contract Price not in error)
 
 
     C     OKMTHN        IFNE      'Y'
     C     OKYEAR        ORNE      'Y'
     C     OKPCAL        ORNE      'Y'
     C     OKSTRP        ORNE      'Y'
     C                   GOTO      VCPEND
     C                   END
 
     C**********         MOVE      ISTT          KISTTP                                     BUG10387
     C**********         MOVE      WYRNO         KYRNOP                                     BUG10387
     C**********         MOVE      WMTHN         KMTHNP                                     BUG10387
     C**********         MOVE      DDPCAL        KPCALP                                     BUG10387
     C**********         MOVE      WSTRP         KSTRPP                                     BUG10387
 
     C*****KPRICS        CHAIN     PRICSDF                            71                    BUG10387
     C**N71RECI*         COMP      'D'                                7171                  BUG10387
 
      *****1.*No*Prices record*****************************************                     BUG10387
     C******IN71         IFEQ      '1'                                                      BUG10387
 
     C**********         EVAL      WarnFound = 'Y'                                          BUG10387
     C**********         EVAL      WIdx = WIdx + 1                                          BUG10387
     C**********         EVAL      FldNamWArr(WIdx) = 'DDNEWP'                              BUG10387
     C**********         EVAL      MsgIDWArr(WIdx) = 'MMA2119'                              BUG10387
 
     C**********         GOTO      VCPEND                                                   BUG10387
     C**********         END                                                                BUG10387
     C                   MOVE      ISTT          KISTTP                                       245143
     C                   MOVE      WYRNO         KYRNOP                                       245143
     C                   MOVE      WMTHN         KMTHNP                                       245143
     C                   MOVE      DDPCAL        KPCALP                                       245143
     C                   MOVE      WSTRP         KSTRPP                                       245143
     C     KPRICS        CHAIN     PRICSDF                            71                      245143
 
      **   Calculate upper and lower limits for the 'New Price'
     C                   Z-ADD     0             NEWPTK           17 8
     C                   Z-ADD     0             WCPTKS           17 8
 
      ** If Ticks Denom = 100 , decimal quotation
     C     TKDM          IFEQ      100
     C     WNEWP         MULT      100           WCPTKS
     C     NEWP          MULT      100           NEWPTK
 
     C                   ELSE
 
      ** Convert  Price integer to a No of Ticks
     C     WCPINT        MULT      TKDM          WCPTKS
     C     NPINT         MULT      TKDM          NEWPTK
 
      ** Add remaining Ticks to this
 
      ** If Ticks Denom <= 10  use 1st dec place
     C     TKDM          IFLE      10
     C                   ADD       WCPDP1        WCPTKS
     C                   ADD       NPDP1         NEWPTK
     C                   ELSE
 
      ** If Ticks Denom <= 99  use 1-2nd dec places
     C     TKDM          IFLE      99
     C                   ADD       WCPDP2        WCPTKS
     C                   ADD       NPDP2         NEWPTK
     C                   ELSE
 
      ** If Ticks Denom <= 999  use 1-3rd dec places
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
     C                   EVAL      FldNamWArr(WIdx) = 'DDNEWP'
     C                   EVAL      MsgIDWArr(WIdx) = 'MMA2120'
 
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
 
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
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
     C                   PARM                    DDNEWP
      ** Year number (2,0S, from transaction)
     C                   PARM                    WYRNO
      ** Month number (2,0S, from transaction)
     C                   PARM                    WMTHN
      ** Put call indicator (1A, from transaction)
     C                   PARM                    DDPCAL
      ** Strike price (15,8P, from transaction)
     C                   PARM                    WSTRP
      ** Instrument types (DS, from INTYPD)
     C                   PARM                    INTYP
      ** OK flags
     C                   PARM                    FFEMPRI
 
      **--------------------------------------------------------------------------------------------
 
      ** Key list for  PRICS
     C*****KPRICS        KLIST                                                              BUG10387
     C**********         KFLD                    KISTTP            5                        BUG10387
     C**********         KFLD                    KYRNOP            2 0                      BUG10387
     C**********         KFLD                    KMTHNP            2 0                      BUG10387
     C**********         KFLD                    KPCALP            1                        BUG10387
     C**********         KFLD                    KSTRPP           15 8                      BUG10387
     C     KPRICS        KLIST                                                                245143
     C                   KFLD                    KISTTP            5                          245143
     C                   KFLD                    KYRNOP            2 0                        245143
     C                   KFLD                    KMTHNP            2 0                        245143
     C                   KFLD                    KPCALP            1                          245143
     C                   KFLD                    KSTRPP           15 8                        245143
 
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
(c) Misys International Banking Systems Ltd. 2006
