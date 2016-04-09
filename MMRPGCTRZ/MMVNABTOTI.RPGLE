     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM Validate total interest                 ')
      *****************************************************************
      *                                                               *
      *  Midas - Standard routines                                    *
      *                                                               *
      *  MMVNABTOTI - Validate total interest for NAs purchased       *
      *                                                               *
      *  Function:  This module validates the total interest field    *
      *             for Negotiable Assets Purchased                   *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. AR814519           Date 11Mar15               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CAP076             Date 03Jun02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP002  *CREATE    Date 18Nov97               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR814519 - Allow negative base rate.                         *
      *           - Applied for MD033488                              *
      *  CAP076 - Lending API enhancements - Rollover details         *
      *           Recompile due to change in MM1030                   *
      *           (new parameter to ZINTDY)                           *
      *  CAP002 - Conversion of MM inputs into modular structure to   *
      *           use as APIs.                                        *
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
 
      ** Name of the MM1030 routine (Calculate interest)
     D MM1030          C                   CONST('MM1030')
 
      ***Name*of*the*ZA0840*routine*(Validate*field*is*numeric)********                     AR814519
     D*ZA0840***       C                   CONST('ZA0840')                                  AR814519
      ** Name of the ZA0841 routine (Validate field is numeric)                             AR814519
     D ZA0841          C                   CONST('ZA0841')                                  AR814519
 
      ***Name*of*the*ZA0920*routine*(Format*amount*for*output)*********                     AR814519
     D*ZA0920***       C                   CONST('ZA0920')                                  AR814519
      ** Name of the ZA0921 routine (Format amount for output)                              AR814519
     D ZA0921          C                   CONST('ZA0921')                                  AR814519
 
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
 
      ** Total interest amount
     D DDMTTI          S             14A
 
      ** Deal type
     D DDMTYP          S              2A
 
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
 
     ** Maturity date in Midas day number format (5,0P, from caller)
     D @MDYNO          S                   LIKE(@VDYNO)
 
     ** Maturity date field OK
     D MatDateOK       S              1A
 
      ** Round-down interest flag
     D DDRDFC          S              1A
 
      ** Decimal separator
     D BNDCSP          S              1A
 
     ** Face Value OK
     D FaceValOK       S              1A
 
     **
     D DDINTROK        S              1A
 
     **
     D IHFVAL          S             15  0
 
     **
     D IHFRAT          S             11  7
 
     **
     D IHMTTI          S             15  0
 
      ** End of parameters
      ** =================
 
      ** Beginning of interest period
     D ZZBEG           S                   LIKE(@VDYNO)
 
      ** End of interest period
     D ZZEND           S                   LIKE(@VDYNO)
 
      ** Interest work field
     D @@INTR          S             15P 0
 
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
 
      ***13,0P*amount*field*for*passing*into*ZA0920********************                     AR814519
      ** 13,0P amount field for passing into ZA0921                                         AR814519
     D Amount13        S             13P 0
 
      ***Packed*version*of*number*of*decimal*places*for*passing*into*ZA0920                 AR814519
      ** Packed version of number of decimal places for passing into ZA0921                 AR814519
     D NbrDecPl1       S              1P 0
 
      ** Packed version of number of decimal places for passing into ZA0840
     D NbrDecPl3       S              3P 0
 
      ***Formatted*amount*returned*from*ZA0920                                              AR814519
      ** Formatted amount returned from ZA0921                                              AR814519
     D AmountOut       S             14A
 
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
     C                   RESET                   MSGID1
     C                   RESET                   MSGDATA1
 
      *  *--------------------------------*
      *  * Validate Total Interest Amount *
      *  *--------------------------------*
      *
     C     DDMTTI        IFEQ      *BLANKS
     C     DDMTYP        IFEQ      'C1'
     C                   MOVEL     'MMM0451'     MSGID1
     C                   EVAL      ErrorFound = 'Y'
     C                   END
      *
      **  If the interest has been entered...
     C                   ELSE
 
 
      **  The interest field must not be entered if Deal type is not C1.
     C     DDMTYP        IFNE      'C1'
     C                   MOVEL     'MMM0454'     MSGID1
     C                   EVAL      ErrorFound = 'Y'
     C                   END
      *
      **  Check that the input amount is a valid number.
     C     CurrOK        IFNE      'N'
     C     DDMTYP        ANDEQ     'C1'
 
 
     C     13            SUB       A6NBDP        @@IINT
     C                   MOVE      *BLANKS       @@ALPH
     C                   MOVE      DDMTTI        @@ALPH
     C                   MOVE      'N'           @@MTID
      ** Put number of decimal places into a packed field for call
     C                   EVAL      NbrDecPl3 = A6NBDP
      *
     C**********         CALLB     ZA0840                                                   AR814519
     C                   CALLB     'ZA0841'                                                 AR814519
      *                  ~~~~~~~~~~~~~~~~
     C                   PARM                    RetCodeOut
     C                   PARM                    @@ALPH
     C                   PARM                    NbrDecPl3
     C                   PARM                    @@IINT
     C                   PARM                    @@MTID
     C                   PARM                    @@ERCD
     C                   PARM                    @@AMT
     C                   PARM                    BNDCSP
 
 
     C     @@ERCD        IFNE      0
     C                   MOVEL     'MMM0452'     MSGID1
     C                   EVAL      ErrorFound = 'Y'
      *
      **  If the amount is a valid number, cross validate the actual
      **  amount. (Only if all the fields used are valid.)
 
     C                   ELSE
 
 
     C**********         MOVE      @@ALPH        DDMTTI                                     AR814519
     C     @@ALPH        IFNE      *BLANKS                                                  AR814519
     C                   EVAL      Amount13 = @@AMT                                         AR814519
     C                   EVAL      NbrDecPl1 = A6NBDP                                       AR814519
     C                   CLEAR                   ReturnCode                                 AR814519
     C                   CALLB     'ZA0921'                                                 AR814519
     C                   PARM                    ReturnCode                                 AR814519
     C                   PARM                    Amount13                                   AR814519
     C                   PARM                    NbrDecPl1                                  AR814519
     C                   PARM                    BNDCSP                                     AR814519
     C                   PARM                    AmountOut                                  AR814519
     C                   MOVE      AmountOut     DDMTTI                                     AR814519
     C                   ENDIF                                                              AR814519
     C                   Z-ADD     @@AMT         IHMTTI
 
      *
     C     ValDateOK     IFNE      'N'
 
     C     MatDateOK     IFNE      'N'
 
     C     CurrOK        IFNE      'N'
     C     FaceValOK     ANDNE     'N'
     C     DdintrOK      ANDNE     'N'
      *
      **  Set up the fields for the execution of the routine to find
      **  the total interest.
     C                   Z-ADD     @VDYNO        ZZBEG
     C                   Z-ADD     @MDYNO        ZZEND
     C                   MOVE      DDRDFC        @@RDFC            1
      *
     C                   CALLB     MM1030
      *                  ~~~~~~~~~~~~~~~~
     C                   PARM                    ZZBEG
     C                   PARM                    ZZEND
     C                   PARM                    DDICMT
     C                   PARM                    IHFVAL
     C                   PARM                    IHFRAT
     C                   PARM                    DDRDFC
     C                   PARM                    @@INTR
      *
      *
      **  Find the difference between the input and calculated interest
      **  - if the difference is greater than 1 currency unit, this is
      **    an error.
     C     IHMTTI        SUB       @@INTR        @DIFI            15 0
      *
     C     @DIFI         IFLT      0
     C                   Z-SUB     @DIFI         @DIFI
     C                   END
      *
     C     A6NBDP        IFEQ      0
     C     @DIFI         ANDGT     1
     C                   EVAL      ErrorFound = 'Y'
     C                   END
      *
     C     A6NBDP        IFEQ      1
     C     @DIFI         DIV(H)    10            @WK151           15 0
     C     @WK151        IFGT      1
     C                   EVAL      ErrorFound = 'Y'
     C                   END
     C                   END
      *
     C     A6NBDP        IFEQ      2
     C     @DIFI         DIV(H)    100           @WK152           15 0
     C     @WK152        IFGT      1
     C                   EVAL      ErrorFound = 'Y'
     C                   END
     C                   END
      *
     C     A6NBDP        IFEQ      3
     C     @DIFI         DIV(H)    1000          @WK153           15 0
     C     @WK153        IFGT      1
     C                   EVAL      ErrorFound = 'Y'
     C                   END
     C                   END
      *
     C     ErrorFound    IFEQ      'Y'
     C                   MOVEL     'MMM0453'     MSGID1
     C                   MOVE      *BLANKS       MsgData1
      ** Put number of decimal places into a packed field for call
     C                   EVAL      NbrDecPl1 = A6NBDP
      ***Copy*the*amount*into*a*13,0P*field*for*passing*to*ZA0920******                     AR814519
      ** Copy the amount into a 13,0P field for passing to ZA0921                           AR814519
     C                   EVAL      Amount13 = @@INTR
 
     C**********         CALLB     'ZA0920'                                                 AR814519
     C                   CALLB     'ZA0921'                                                 AR814519
     C                   PARM                    RetCodeOut
     C                   PARM                    Amount13
     C                   PARM                    NbrDecPl1
     C                   PARM                    BNDCSP
     C                   PARM                    AmountOut
 
     C                   MOVEL     AmountOut     MsgData1
 
     C                   END
     C                   END
     C                   END
     C                   END
     C                   END
     C                   END
     C                   END
      *
      ** If an error was found, set the return code appropriately
     C                   IF        ErrorFound = 'Y'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
 
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
     C                   PARM                    RetCodeIn
      ** Message ID (10A)
     C                   PARM                    MsgID1
      ** Message data (45A)
     C                   PARM                    MsgData1
      ** Total interest amount (14A, from transaction)
     C                   PARM                    DDMTTI           14
      ** Deal type (2A, from transaction)
     C                   PARM                    DDMTYP            2
      ** Interest calculation method (1A, from transaction)
     C                   PARM                    DDICMT            1
      ** Deal value date in Midas day number format (5,0P, from caller)
     C                   PARM                    @VDYNO            5 0
      ** Currency field OK flag (1A, from caller)
     C                   PARM                    CurrOK            1
      ** Number of decimal places in deal currency (1,0S, from SDCURRPD)
     C                   PARM                    A6NBDP            1 0
      ** Value date field OK (1A, from caller)
     C                   PARM                    ValDateOK         1
      ** Maturity date in Midas day number format (5,0P, from caller)
     C                   PARM                    @MDYNO
      ** Maturity date field OK (1A, from caller)
     C                   PARM                    MatDateOK
      ** Round-down interest flag (1A, from transaction)
     C                   PARM                    DDRDFC
      ** Decimal separator (1A, from SDDEALPD)
     C                   PARM                    BNDCSP
      ** Global Warning indicator
     C                   PARM                    WarnGlobal        1
      ** Face value OK flag (1A, from caller)
     C                   PARM                    FaceValOK
      ** Interest OK flag (1A, from caller)
     C                   PARM                    DDIntrOK
      * Face Value
     C                   PARM                    IHFVAL
      * Face Rate
     C                   PARM                    IHFRAT
      * Midas Total Interest
     C                   PARM                    IHMTTI
 
 
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
