     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM Calculate total interest')
      *****************************************************************
      *                                                               *
      *  Midas - Standard routines                                    *
      *                                                               *
      *  ZACTOTINT - Calculate total interest                         *
      *                                                               *
      *  Function:  This module calculates the total interest         *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CDL020  *CREATE    Date 03Feb04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CDL020 - Apply Base Rate at Value Date                       *
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
 
      ** Action Code (1A, from caller)
     D DDACTN          S              1A
 
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
 
     D CDL006          S              1A   IMPORT
 
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
      *
      * If the total interest has NOT been entered...
      *
     C     DDTOTI        IFEQ      *BLANKS
      *
      * Calculate total interest if S01468 installed and call deal
      *
     C     S01468        IFEQ      'Y'
     C     DDNTCE        ANDEQ     '  0'
      *
     C     DDTYPE        IFEQ      'CD'
     C     DDTYPE        OREQ      'CL'
     C     DDTYPE        OREQ      'DL'
     C     DDTYPE        OREQ      'DT'
     C     CDL006        ANDEQ     'Y'
     C     DDTYPE        OREQ      'LT'
     C     CDL006        ANDEQ     'Y'
     C     DDTYPE        OREQ      'DP'
     C     CDL006        ANDEQ     'Y'
     C     DDTYPE        OREQ      'LP'
     C     CDL006        ANDEQ     'Y'
      *
     C                   Z-ADD     @VDYNO        ZZBEG
     C     ZZBEG         ADD       1             ZZEND
      *
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
      *
      * Error as total interest not defined
      *
     C                   EVAL      ErrorFound = 'Y'
     C                   MOVEL     'MMM0451'     MsgID1
     C     SKIPV         TAG
      *
      **  If the interest has been entered...
      *
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
 
      * Only for Call Deposit/Loans allow entry of -ve interest amounts.
     C                   CALLB     'ZA0841'
     C                   PARM                    ReturnCode
     C                   PARM                    @@ALPH
     C                   PARM                    NbrDecPl3
     C                   PARM                    @@IINT
     C                   PARM                    @@MTID
     C                   PARM                    @@ERCD
     C                   PARM                    @@AMT
     C                   PARM                    BNDCSP
     C                   END
      *
      **  The input amount is NOT a valid number.
      *
     C     @@ERCD        IFNE      0
     C                   EVAL      ErrorFound = 'Y'
     C                   MOVEL     'MMM0452'     MsgID1
      *
      **  If the amount is a valid number, cross validate the actual
      **  amount. (Only if all the fields used are valid.)
      *
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
      *
      **  Call/notice indicator.
      *
     C     @NTCNM        IFEQ      -999
     C                   MOVE      *BLANKS       IWRK              1
     C                   ELSE
     C     @NTCNM        IFEQ      *ZEROS
     C                   MOVE      'C'           IWRK
     C                   ELSE
     C                   MOVE      'N'           IWRK
     C                   END
     C                   END
      *
      **  Set up the fields for the execution of the routine to find
      **  the total interest.
     C                   Z-ADD     @VDYNO        ZZBEG
     C                   Z-ADD     @@AMT         @TOTIN
     C*
     C     DDTYPE        IFEQ      'CD'                                         b*1
     C     DDTYPE        OREQ      'CL'
     C     DDTYPE        OREQ      'DL'
     C     DDTYPE        OREQ      'DT'
     C     CDL006        ANDEQ     'Y'
     C     DDTYPE        OREQ      'LT'
     C     CDL006        ANDEQ     'Y'
     C     DDTYPE        OREQ      'DP'
     C     CDL006        ANDEQ     'Y'
     C     DDTYPE        OREQ      'LP'
     C     CDL006        ANDEQ     'Y'
      *
      * If Maturity date is Not entered use Notice Days for calculating
      * the Total Interest
     C     @MDYNO        IFEQ      0                                            b*2
      *
     C     @NTCNM        IFEQ      0                                            b*3
     C     ZZBEG         ADD       1             ZZEND
     C                   ELSE                                                   x*3
     C     @NTCNM        IFNE      -999                                         b*4
     C     ZZBEG         ADD       @NTCNM        ZZEND
     C                   ELSE                                                   x*4
     C                   Z-ADD     @MDYNO        ZZEND
     C                   END                                                    e*4
     C                   END                                                    e*3
      *
      * When Maturity date entered
     C                   ELSE                                                   x*2
     C                   Z-ADD     @MDYNO        ZZEND
     C                   END                                                    e*2
      *
     C                   ELSE                                                   x*1
      *
      * IF FIRST & LAST DAY INTEREST, CALCULATE TO MATURITY DATE + 1
      *
     C     DDFLID        IFEQ      'Y'                                          b*2
     C     @MDYNO        ADD       1             ZZEND
     C                   ELSE                                                   x*2
     C                   Z-ADD     @MDYNO        ZZEND
     C                   END                                                    e*2
     C                   END                                                    e*1
      *
     C                   CALLB     'MM1030'
     C                   PARM                    ZZBEG
     C                   PARM                    ZZEND
     C                   PARM                    DDICMT
     C                   PARM                    IKAMNP
     C                   PARM                    IKINTR
     C                   PARM                    DDRDFC
     C                   PARM                    @@INTR
     C                   END
     C                   END
     C                   END
     C                   END
      *
      **  If the amount is valid, set up the numeric amount on the
      **  Standard Deal format.
      *
     C     ValDateOK     IFNE      'N'
     C     MatDateOK     ANDNE     'N'
     C     NotDaysOK     ANDNE     'N'
     C     CurrOK        ANDNE     'N'
     C     AmountOK      ANDNE     'N'
     C     BaseRateOK    ANDNE     'N'
     C     SpreadOK      ANDNE     'N'
     C     CalcMethOK    ANDNE     'N'
     C     ErrorFound    ANDEQ     'N'
      *
     C                   Z-ADD     @@INTR        IKMTTI
 
      **  Reformat the interest value for display
 
      ** Copy the amount into a 13,0P field for passing to ZA0920
      ** Put number of decimal places into a packed field for call
 
     C                   EVAL      Amount13 = @@INTR
     C                   EVAL      NbrDecPl1 = A6NBDP
     C                   CLEAR                   ReturnCode
 
     C                   CALLB     'ZA0920'
     C                   PARM                    ReturnCode
     C                   PARM                    Amount13
     C                   PARM                    NbrDecPl1
     C                   PARM                    BNDCSP
     C                   PARM                    AmountOut
 
     C                   MOVE      AmountOut     DDTOTI
      *
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
      ** Action Code (1A, from caller)
     C                   PARM                    DDACTN
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
(c) Finastra International Limited 2004
