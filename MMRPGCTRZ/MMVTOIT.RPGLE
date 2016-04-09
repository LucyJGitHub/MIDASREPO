     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM Validate total interest')                     *
      *****************************************************************
      *                                                               *
      *  Midas - Standard routines                                    *
      *                                                               *
      *  MMVTOIT  - Validate total interest                          *
      *                                                               *
      *  Function:  This module validates a total interest field      *
      *             It is a slightly altered version of ZAVTOTINT     *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. MD025884           Date 19Aug14               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CAP076             Date 03Jun02               *
      * Midas Release 4.01.02 ----------------------------------------*
      *                 208051             Date 22Aug02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CSE006  *CREATE    Date 26Oct99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD025884 - Bad response from SOAP due to character string    *
      *             substitution error.                               *
      *  CAP076 - Lending API enhancements - Rollover details         *
      *           Recompile due to change in MM1030                   *
      *           (new parameter to ZINTDY)                           *
      *  208051 - Allow entry of a -ve interest amount. Use new       *
      *           program ZA0841.                                     *
      *  CSE006 - Repos Maintenance                                   *
      *                                                               *
      *****************************************************************
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** Include the MM standard declares
     D/COPY ZACPYSRC,STDDECLARE
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
      ** Program, procedure and module names for parameters
      ** ==================================================
 
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
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** ==========
      ** Parameters
 
      ** Message ID
     D MsgID1          S                   LIKE(#MsgID)
 
      ** Message data
     D MsgData1        S                   LIKE(#MsgData)
 
      ** Interest amount returned from this module
     D IKMTTI          S             15P 0
 
      ** Total interest amount
     D DDTOTI          S             14A
 
      ** Default interest for CL and CD deals with zero notice days
      ** feature flag
     D S01468          S              1A
 
      ** Deal notice days
     D DDNTCE          S              3A
 
      ** Deal type
     D DDTYPE          S              2A
 
      ** Interest rate
     D IKINTR          S             11P 7
 
      ** Deal amount
     D IKAMNP          S             15P 0
 
      ** Interest calculation method
     D DDICMT          S              1A
 
      ** Deal value date in Midas day number format
     D @VDYNO          S              5P 0
 
      ** Currency OK flag
     D CurrOK          S              1A
 
      ** Number of decimal places in deal currency
     D A6NBDP          S              1S 0
 
     ** Value date field OK
     D ValDateOK       S              1A
 
     ** Notice days field OK
     D NotDaysOK       S              1A
 
     ** Amount field OK
     D AmountOK        S              1A
 
     ** Base Rate field OK
     D BaseRateOK      S              1A
 
     ** Spread/Rate field OK
     D SpreadOK        S              1A
 
     ** Calculation method field OK
     D CalcMethOK      S              1A
 
     ** Maturity date
     D DDMDAT          S              6A
 
     ** Maturity date in Midas day number format (5,0P, from caller)
     D @MDYNO          S                   LIKE(@VDYNO)
 
     ** Maturity date field OK
     D MatDateOK       S              1A
 
     ** Notice days
     D @NTCNM          S              3S 0
 
      ** First and last day interest flag
     D DDFLID          S              1A
 
      ** Round-down interest flag
     D DDRDFC          S              1A
 
      ** Decimal separator
     D BNDCSP          S              1A
 
      ** End of parameters
      ** =================
 
      ** Beginning of interest period
     D ZZBEG           S                   LIKE(@VDYNO)
 
      ** End of interest period
     D ZZEND           S                   LIKE(@VDYNO)
 
      ** Interest work field
     D @@INTR          S                   LIKE(IKAMNP)
 
      ** Interest work field
     D @TOTIN          S                   LIKE(IKAMNP)
 
      ** Alpha field for numeric validation
     D @@ALPH          S             16A
 
      ** Number of integers in amount
     D @@IINT          S              3P 0
 
      ** Millions/Thousands id (Y=function on)
     D @@MTID          S              1A
 
      ** Error code for ZA0840
     D @@ERCD          S              1P 0
 
      ** Amount after numeric checking
     D @@AMT           S             15P 0
 
      ** Difference between input and calculated rate
     D @DIFI           S             15P 0
 
      ** 13,0P amount field for passing into ZA0920
     D Amount13        S             13P 0
 
      ** Packed version of number of decimal places for passing into ZA0920
     D NbrDecPl1       S              1P 0
 
      ** Packed version of number of decimal places for passing into ZA0840
     D NbrDecPl3       S              3P 0
 
      ** Formatted amount returned from ZA0920
     D AmountOut       S             14A
 
      ** Character String Substitution                                                      MD025884
     D BChar           DS                                                                   MD025884
     D   BLen                  1      2B 0                                                  MD025884
     D   LenStr                1      2                                                     MD025884
                                                                                            MD025884
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
     C
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
     C                   RESET                   ErrorFound
     C*
     C* If the total interest has NOT been entered...
     C*
     C     DDTOTI        IFEQ      *BLANKS
     C*
     C* Calculate total interest if S01468 installed and call deal
     C*
     C     S01468        IFEQ      'Y'
     C     DDNTCE        ANDEQ     '  0'
     C*
     C     DDTYPE        IFEQ      'CD'
     C     DDTYPE        OREQ      'CL'
     C     DDTYPE        OREQ      'DL'
     C*
     C                   Z-ADD     @VDYNO        ZZBEG
     C     ZZBEG         ADD       1             ZZEND
     C*
     C                   CALLB     'MM1030'
     C                   PARM                    ZZBEG
     C                   PARM                    ZZEND
     C                   PARM                    DDICMT
     C                   PARM                    IKAMNP
     C                   PARM                    IKINTR
     C                   PARM                    DDRDFC
     C                   PARM                    @@INTR
 
     C                   Z-ADD     @@INTR        @TOTIN
     C                   GOTO      SKIPV
     C                   END
     C                   END
     C*
     C* Error as total interest not defined
     C*
     C                   EVAL      ErrorFound = 'Y'
     C                   MOVEL     'MMM0451'     MsgID1
     C     SKIPV         TAG
     C*
     C**  If the interest has been entered...
     C*
     C                   ELSE
      *
      **  Check that the input amount is a valid number.
      **      If no error in currency field:
      *
     C     CurrOK        IFEQ      'Y'
      *
      ** If DDTOTI is '*', total interest is to be calculated
      *
     C     DDTOTI        IFEQ      '*'
     C                   Z-ADD     *ZERO         @@ERCD
     C                   ELSE
 
     C     13            SUB       A6NBDP        @@IINT
     C                   MOVE      'N'           @@MTID
      *
      ** Put field to be validated into parameter field
      ** Put number of decimal places into a packed field for call
      *
     C                   EVAL      @@ALPH = DDTOTI
     C                   EVAL      NbrDecPl3 = A6NBDP
     C                   CLEAR                   ReturnCode
 
      * Only for Call Deposit/Loans allow entry of -ve interest amounts.                      208051
     C**********         CALLB     'ZA0840'                                                   208051
     C                   CALLB     'ZA0841'                                                   208051
     C                   PARM                    ReturnCode
     C                   PARM                    @@ALPH
     C                   PARM                    NbrDecPl3
     C                   PARM                    @@IINT
     C                   PARM                    @@MTID
     C                   PARM                    @@ERCD
     C                   PARM                    @@AMT
     C                   PARM                    BNDCSP
     C                   END
     C*
     C**  The input amount is NOT a valid number.
     C*
     C     @@ERCD        IFNE      0
     C                   EVAL      ErrorFound = 'Y'
     C                   MOVEL     'MMM0452'     MsgID1
     C*
     C**  If the amount is a valid number, cross validate the actual
     C**  amount. (Only if all the fields used are valid.)
     C*
     C                   ELSE
      *
     C     ValDateOK     IFNE      'N'
     C     MatDateOK     ANDNE     'N'
     C     NotDaysOK     ANDNE     'N'
     C     CurrOK        ANDNE     'N'
     C     AmountOK      ANDNE     'N'
     C     BaseRateOK    ANDNE     'N'
     C     SpreadOK      ANDNE     'N'
     C     CalcMethOK    ANDNE     'N'
     C*
     C**  Call/notice indicator.
     C*
     C     @NTCNM        IFEQ      -999
     C                   MOVE      *BLANKS       IWRK              1
     C                   ELSE
     C     @NTCNM        IFEQ      *ZEROS
     C                   MOVE      'C'           IWRK
     C                   ELSE
     C                   MOVE      'N'           IWRK
     C                   END
     C                   END
     C*
     C**  Set up the fields for the execution of the routine to find
     C**  the total interest.
     C                   Z-ADD     @VDYNO        ZZBEG
     C                   Z-ADD     @@AMT         @TOTIN
     C*
     C     DDTYPE        IFEQ      'CD'
     C     DDMDAT        ANDEQ     *BLANKS
     C     DDTYPE        OREQ      'CL'
     C     DDMDAT        ANDEQ     *BLANKS
     C     @NTCNM        IFEQ      0
     C     ZZBEG         ADD       1             ZZEND
     C                   ELSE
     C     @NTCNM        IFNE      -999
     C     ZZBEG         ADD       @NTCNM        ZZEND
     C                   ELSE
     C                   Z-ADD     @MDYNO        ZZEND
     C                   END
     C                   END
     C                   ELSE
     C*
     C* IF FIRST & LAST DAY INTEREST, CALCULATE TO MATURITY DATE + 1
     C*
     C     DDFLID        IFEQ      'Y'
     C     @MDYNO        ADD       1             ZZEND
     C                   ELSE
     C                   Z-ADD     @MDYNO        ZZEND
     C                   END
     C                   END
     C*
     C                   CALLB     'MM1030'
     C                   PARM                    ZZBEG
     C                   PARM                    ZZEND
     C                   PARM                    DDICMT
     C                   PARM                    IKAMNP
     C                   PARM                    IKINTR
     C                   PARM                    DDRDFC
     C                   PARM                    @@INTR
      *
      ** If DDTOTI is '*', total interest is that calculated
      *
     C     DDTOTI        IFEQ      '*'
     C                   Z-ADD     @@INTR        @TOTIN
     C                   END
     C*
     C**  Find the difference between the input and calculated interest
     C**  - if the difference is greater than 1 currency unit, this is
     C**    an error.
     C*
     C     @TOTIN        SUB       @@INTR        @DIFI
     C*
     C     @DIFI         IFLT      0
     C                   Z-SUB     @DIFI         @DIFI
     C                   END
     C*
     C     @DIFI         IFGT      0
     C                   EVAL      ErrorFound = 'Y'
     C                   END
     C*
     C**  If there is a difference in the input and calculated interest
     C**  amounts, format the calculated figure and output it in a message
     C*
     C     ErrorFound    IFEQ      'Y'
      *
      ** Copy the amount into a 13,0P field for passing to ZA0920
      ** Put number of decimal places into a packed field for call
      *
     C                   EVAL      Amount13 = @@INTR
     C                   EVAL      NbrDecPl1 = A6NBDP
     C                   CLEAR                   ReturnCode
 
     C                   CALLB     'ZA0920'
     C                   PARM                    ReturnCode
     C                   PARM                    Amount13
     C                   PARM                    NbrDecPl1
     C                   PARM                    BNDCSP
     C                   PARM                    AmountOut
 
     C                   MOVE      *BLANKS       MsgData1
     C**********         MOVEL     AmountOut     MsgData1                                   MD025884
     C                   EVAL      BLen = %Len(%Trim(AmountOut))                            MD025884
     C                   EVAL      MsgData1 = LenStr +%TRIM(AmountOut)                      MD025884
     C                   MOVEL     'MMM0453'     MsgID1
     C                   END
     C                   END
     C                   END
     C                   END
     C                   END
     C*
     C**  If the amount is valid, set up the numeric amount on the
     C**  Standard Deal format.
     C*
     C     ValDateOK     IFNE      'N'
     C     MatDateOK     ANDNE     'N'
     C     NotDaysOK     ANDNE     'N'
     C     CurrOK        ANDNE     'N'
     C     AmountOK      ANDNE     'N'
     C     BaseRateOK    ANDNE     'N'
     C     SpreadOK      ANDNE     'N'
     C     CalcMethOK    ANDNE     'N'
     C     ErrorFound    ANDEQ     'N'
     C*
     C                   Z-ADD     @TOTIN        IKMTTI
 
     C**  Reformat the interest value for display
 
      ** Copy the amount into a 13,0P field for passing to ZA0920
      ** Put number of decimal places into a packed field for call
 
     C                   EVAL      Amount13 = @TOTIN
     C                   EVAL      NbrDecPl1 = A6NBDP
     C                   CLEAR                   ReturnCode
 
     C                   CALLB     'ZA0920'
     C                   PARM                    ReturnCode
     C                   PARM                    Amount13
     C                   PARM                    NbrDecPl1
     C                   PARM                    BNDCSP
     C                   PARM                    AmountOut
 
     C                   MOVE      AmountOut     DDTOTI
     C*
     C                   END
      *
      ** Return code set in /COPY
     C/COPY ZACPYSRC,SETRETCDE
 
     C                   RETURN
 
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
 
     C     *entry        PLIST
      ** Incoming return code (10A)
     C                   PARM                    ReturnCode
      ** Message ID (10A)
     C                   PARM                    MsgID1
      ** Message data (45A)
     C                   PARM                    MsgData1
      ** Total interest amount returned from this module (15,0P)
     C                   PARM                    IKMTTI
      ** Total interest amount (14A, from transaction)
     C                   PARM                    DDTOTI
      ** Default interest for CL and CD deals with zero notice days
      ** feature flag (1A, from SCSARDPD via caller)
     C                   PARM                    S01468
      ** Deal notice days (3A, from transaction)
     C                   PARM                    DDNTCE
      ** Deal type (2A, from transaction)
     C                   PARM                    DDTYPE
      ** Interest rate (11,7P, from caller)
     C                   PARM                    IKINTR
      ** Deal amount (15,0P, from caller)
     C                   PARM                    IKAMNP
      ** Interest calculation method (1A, from transaction)
     C                   PARM                    DDICMT
      ** Deal value date in Midas day number format (5,0P, from caller)
     C                   PARM                    @VDYNO
      ** Currency field OK flag (1A, from caller)
     C                   PARM                    CurrOK
      ** Number of decimal places in deal currency (1,0S, from SDCURRPD)
     C                   PARM                    A6NBDP
      ** Value date field OK (1A, from caller)
     C                   PARM                    ValDateOK
      ** Notice days field OK (1A, from caller)
     C                   PARM                    NotDaysOK
      ** Amount field OK (1A, from caller)
     C                   PARM                    AmountOK
      ** Base Rate field OK (1A, from caller)
     C                   PARM                    BaseRateOK
      ** Spread/Rate field OK (1A, from caller)
     C                   PARM                    SpreadOK
      ** Calculation method field OK (1A, from caller)
     C                   PARM                    CalcMethOK
      ** Maturity date (6A, from transaction)
     C                   PARM                    DDMDAT
      ** Maturity date in Midas day number format (5,0P, from caller)
     C                   PARM                    @MDYNO
      ** Maturity date field OK (1A, from caller)
     C                   PARM                    MatDateOK
      ** Notice days (3,0P, from caller)
     C                   PARM                    @NTCNM
      ** First and last day interest flag (1A, from transaction)
     C                   PARM                    DDFLID
      ** Round-down interest flag (1A, from transaction)
     C                   PARM                    DDRDFC
      ** Decimal separator (1A, from SDDEALPD)
     C                   PARM                    BNDCSP
 
 
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR                                                  *** InzEnd ***
      *****************************************************************
      /EJECT
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
