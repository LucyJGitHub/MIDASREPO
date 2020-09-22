     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM Validate base currency rate')                 *
      *****************************************************************
      *                                                               *
      *  Midas - Money Market Dealing Module                          *
      *                                                               *
      *  MMVBCURRAT - Validate Base Currency Rate                     *
      *                                                               *
      *  Function:  This module receives a parameter containing the   *
      *             Base Currency Rate field and confirms             *
      *             whether it has a valid value.                     *
      *             If it is valid the 10A return code will be blank, *
      *             if it is not it will contain  'Error'             *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. MD056472           Date 22Sep20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 MD000091           Date 14May13               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4.01.02 ----------------------------------------*
      *                 191138             Date 20Jun02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 154453             Date 06Nov98               *
      *                 CAP002  *CREATE    Date 22Sep97               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD056472 - Unknown characters are displayed for error        *
      *             message id 45033939 in LDNI                       *
      *  MD046248 - Finastra Rebranding                               *
      *  MD000091 - Event Codes Substitution                          *
      *  191138 - System validates base currency rate in amend mode   *
      *           but field is unamendable.  Validate this field only *
      *           when in insert mode.                                *
      *  154453 - Applied fix 128710.                                 *
      *           Base ccy rate tolerance work field is to small.     *
      *           Increased the size of @ULIM.  Applied fix 114480.   *
      *  CAP002 - Conversion of MM inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
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

      ** Error message field received as a parameter
     D     Msgid1      S                   LIKE(#MsgID)
      ** Base Currency Rate - received as a parameter
     D     DDBRAT      S             13A
      ** Deal Ccy received as a parameter
     D     DDCCY       S              3A
      ** Deal Ccy OK received as a parameter
     D     DDCCYOK     S              1A
      ** Spot Rate (SDCURRPD) received as a parameter
     D     A6SPRT      S             13  8
      ** Scaling Exponent (SDCURRPD) received as a parameter
     D     A6SCEX      S              1S 0
      ** Mult/Divide Ind (SDCURRPD) received as a parameter
     D     A6MDIN      S              1A

      ** Decimal separator (SDDEALPD) via caller
     D     BNDCSP      S              1A
     D     BJCYCD      S              3A
      ** Base Curr. rate (MMSTDLPP) via caller
     D     IKBRAT      S             13  8
      ** Mult/Div. Indic. (MMSTDLPP) via caller
     D     IKMMDI      S              1A
      ** Work fields used in program validation routines
     D     DDACTN      S              1A                                                      191138
      ** Action code received as a paramater                                                  191138
     D     @@SXP1      S              1S 0
     D     @@SXP2      S                   LIKE(@@SXP1)
     D AmountIn        S             13P 0
     D AmountOut       S             14A
     D BasCurErr       S              1A
     D     @@ALPH      S             16A
     D     @@AMTD      S             14A
     D     @@AMT       S             15  0
     D     @@IDP       S              3  0
     D     @@IINT      S              3  0
     D     @@MTID      S              1A
     D     @@SEXP      S              1  0
     D*****@@USRT      S             12  8                                      154453
     D*****@LLIM       S             13  9                                      154453
     D*****@ULIM       S             13  9                                      154453
     D     @@USRT      S             13  8                                      154453
     D     @LLIM       S             30  9                                      154453
     D     @ULIM       S             30  9                                      154453
     D     @@AMTW      S             13  0
     D     @BRATN      S             13  8

      **                                                                                    MD000091
     D BChar           DS                                                                   MD000091
     D   BLen                  1      2B 0                                                  MD000091
     D   LenStr                1      2                                                     MD000091

      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************

      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+

      ** Reset error flags & msgs to prevent problems on subsequent calls
     C                   RESET                   ErrorFound
     C                   RESET                   Msgid1
     C                   MOVE      ' '           BasCurErr                      154453
      *
      *
      *  *--------------------------------------*
      *  * Validate Base Currency Exchange Rate *
      *  *--------------------------------------*
      *
      **  If the deal ccy is valid, validate the rate.
     C     DDCCYOK       IFNE      'N'
      *
      **  If the rate is blank, default it to the rate held on the
      **  currency file for the deal currency.
      **
     C     DDBRAT        IFEQ      *BLANKS
      *
      ** convert to display amount
      ** Scale the rate for display.
     C                   Z-ADD     A6SPRT        @@INRT
     C                   Z-ADD     A6SCEX        @@SXP1
     C                   Z-ADD     0             @@SXP2
     C                   MOVE      'M'           @@FCMD
      ** Convert Rate to Scaled Rate
     C                   CALLB     'ZA1150'
      *                  ~~~~~~~~~~~~~~~~~
     C                   PARM                    @@SXP1                         1st ccy scaling expo
     C                   PARM                    @@SXP2                         2nd ccy scaling expo
     C*****              PARM                    @@INRT           12 8      Rate154453
     C                   PARM                    @@INRT           13 8          154453
     C                   PARM                    @@FCMD            1            1st Ccy Mult/Div ind
     C*****              PARM                    @@SCRT           12 8          154453
     C*****              PARM                    @@ISRT           12 8          154453
     C                   PARM                    @@SCRT           13 8          154453
     C                   PARM                    @@ISRT           13 8          154453
     C                   PARM                    @@ERCD            1 0          Error code.
      *
      **  If the error code is 1 or 3 process error.
     C     @@ERCD        IFEQ      1
     C     @@ERCD        OREQ      3
     C                   MOVEL     'MMA0001 '    MSGID1
     C                   MOVE      'Y'           ErrorFound
     C                   END
      *
     C                   Z-ADD     8             @@QECN            1 0
     C     @@SCRT        MULT      100000000     @@AMTW
      ** Edit the Amount for display as a character field
     C                   CALLB     'ZA0920'
      *                  ~~~~~~~~~~~~~~~~~
     C                   PARM                    RetCodeIn
     C                   PARM                    @@AMTW
     C                   PARM                    @@QECN
     C                   PARM                    BNDCSP
     C                   PARM                    @@AMTD
      *                                                                         154453
     C                   MOVEL     @@AMTD        W1Dig             1            154453
     C     W1Dig         IFEQ      *BLANK                                       154453
     C                   MOVE      @@AMTD        DDBRAT
     C                   ELSE                                                   154453
     C                   MOVEL     @@AMTD        DDBRAT                         154453
     C                   ENDIF                                                  154453
      *                                                                         154453

      ** Place the derived amount into the field that will be used to set
      **  up the value to go out on to file
     C                   Z-ADD     @@AMTW        @@AMT

      **  Check it is a valid figure with 8 decimal places max.
     C                   ELSE
      *
     C                   Z-ADD     8             @@IDP
     C*****              Z-ADD     4             @@IINT                         154453
     C                   Z-ADD     5             @@IINT                         154453
     C                   MOVE      *BLANKS       @@ALPH
     C                   MOVE      DDBRAT        @@ALPH
     C                   MOVE      'N'           @@MTID
      *
     C                   CALLB     'ZA0840'
      *                  ~~~~~~~~~~~~~~~~~
     C                   PARM                    RetCodeIn
     C                   PARM                    @@ALPH
     C                   PARM                    @@IDP
     C                   PARM                    @@IINT
     C                   PARM                    @@MTID
     C                   PARM                    @@ERCD
     C                   PARM                    @@AMT
     C                   PARM                    BNDCSP
     C     @@ERCD        IFNE      0
     C                   MOVEL     'MMM0413'     MSGID1
     C                   MOVE      'Y'           ErrorFound
      *
      **  Calculate the upper and lower limits for the exchange rate.
     C                   ELSE
     C                   Z-ADD     0             @BRATN
     C                   MOVE      @@AMT         @@INRT
     C                   Z-ADD     A6SCEX        @@SEXP
                                                                                154453
      * If the full five integers are being used, drop the last                 154453
      * decimal place                                                           154453
      *                                                                         154453
     C     1             SUBST     @@ALPH:3      WPos14            1            154453
     C     WPos14        IFEQ      *BLANK                                       154453
     C                   MOVE      @@ALPH        DDBRAT
     C                   ELSE                                                   154453
     C     13            SUBST     @@ALPH:3      DDBRAT                         154453
     C                   END                                                    154453
      *                                                                         154453
      * Convert Scaled to Non-scaled
     C                   CALLB     'ZA1160'
      *                  ~~~~~~~~~~~~~~~~~
     C                   PARM                    @@SEXP                         1st ccy scaling expo
     C                   PARM                    @@INRT                         Rate to be scaled.
     C                   PARM                    @@USRT                         Inv. of scaled rate
      *
     C                   Z-ADD     @@USRT        @BRATN
     C     A6SPRT        MULT      .8            @LLIM
     C     A6SPRT        MULT      1.2           @ULIM
      *
      ** If Deal currency equals the base currency and the base currency
      ** rate is not equal to spot rate.
     C     DDCCY         IFEQ      BJCYCD
     C     @BRATN        ANDNE     A6SPRT
     C     DDACTN        ANDEQ     'I'                                                        191138
     C                   MOVEL     'MMM0412'     MSGID1
     C                   MOVE      'Y'           ErrorFound
     C                   MOVE      'Y'           BasCurErr
      *
     C                   END
      *
      **  If the rate is less than the lower limit, or greater than the
      **  the upper limit , this is an error.
      **  If there is a difference in the input and calculated interest
      **  amounts, format the calculated figure and output it in a message
     C     DDACTN        IFEQ      'I'                                                        191138
     C     @BRATN        IFLT      @LLIM
     C     @BRATN        ORGT      @ULIM
     C                   Z-ADD     8             @@QECN
      *
      **  Scale the Spot Rate for output in the message.
     C                   Z-ADD     A6SCEX        @@SXP1
     C                   Z-ADD     0             @@SXP2
     C                   Z-ADD     A6SPRT        @@INRT
     C                   MOVE      'M'           @@FCMD
     C                   CALLB     'ZA1150'
      *                  ~~~~~~~~~~~~~~~~~
     C                   PARM                    @@SXP1                         1st ccy scaling expo
     C                   PARM                    @@SXP2                         2nd ccy scaling expo
     C                   PARM                    @@INRT                         Rate to be scaled.
     C                   PARM                    @@FCMD                         1st Ccy Mult/Div ind
     C                   PARM                    @@SCRT                         Scaled rate.
     C                   PARM                    @@ISRT                         Inv. of scaled rate
     C                   PARM                    @@ERCD                         Error code.
      *
      **  If the error code is 1 or 3 process error.
     C     @@ERCD        IFEQ      1
     C     @@ERCD        OREQ      3
     C                   MOVEL     'MMA0001 '    MSGID1
     C                   MOVE      'Y'           ErrorFound
     C                   END
      *
     C                   MOVE      @@SCRT        @@AMTW
      *
     C                   CALLB     'ZA0920'
      *                  ~~~~~~~~~~~~~~~~~
     C                   PARM                    RetCodeIn
     C                   PARM                    @@AMTW
     C                   PARM                    @@QECN
     C                   PARM                    BNDCSP
     C                   PARM                    @@AMTD
      *
     C                   MOVE      *BLANKS       #MSGDATA
     C**********         MOVEL     @@AMTD        #MSGDATA                                   MD000091
     C**********         EVAL      BLen = %Len(%Trim(@@AMTD))                      MD000091 MD056472
     C**********         EVAL      #MSGDATA = LenStr +%TRIM(@@AMTD)                MD000091 MD056472
     C                   EVAL      #MSGDATA = %TRIM(@@AMTD)                                 MD056472
     C                   MOVEL     'MMM0414'     MSGID1
     C                   MOVE      'Y'           ErrorFound
     C                   END
     C                   ENDIF                                                                191138
     C                   END
     C                   END
     C                   END
      *
      **  If the base currency exchange rate is valid, set up the base
      **  currency exchange rate and the multiply divide indicator
      **  for output
     C     DDCCYOK       IFNE      'N'
     C     BasCurErr     ANDEQ     ' '
     C     DDBRAT        IFEQ      *BLANKS
     C                   Z-ADD     *ZEROS        IKBRAT
     C                   ELSE
     C                   MOVE      @@AMT         @@INRT
     C                   Z-ADD     A6SCEX        @@SEXP
      *
      * Convert Scaled to Non-scaled
     C                   CALLB     'ZA1160'
      *                  ~~~~~~~~~~~~~~~~~
     C                   PARM                    @@SEXP                         1st ccy scaling expo
     C                   PARM                    @@INRT                         Rate to be scaled.
     C                   PARM                    @@USRT                         Inv. of scaled rate
      *
     C                   Z-ADD     @@USRT        IKBRAT
     C                   MOVE      A6MDIN        IKMMDI
     C                   END
     C                   END
      *
      ** If an error was found, set the return code appropriately
      *
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
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     *INZSR        BEGSR

     C     *ENTRY        PLIST
     C                   PARM                    RetCodeIn
     C                   PARM                    MSGID1
     C                   PARM                    #MSGDATA
      ** Base Currency Rate - received as a parameter
     C                   PARM                    DDBRAT           13
      ** Deal Currency received as a parameter
     C                   PARM                    DDCCY             3
      ** Deal Ccy OK received as a parameter
     C                   PARM                    DDCCYOK           1
      ** Spot Rate (SDCURRPD) received as a parameter
     C                   PARM                    A6SPRT           13 8
      ** Scaling Exponent (SDCURRPD) received as a parameter
     C                   PARM                    A6SCEX            1 0
      ** Mult/Divide Ind (SDCURRPD) received as a parameter
     C                   PARM                    A6MDIN            1
      ** Decimal separator (SDDEALPD) via caller
     C                   PARM                    BNDCSP            1
     C                   PARM                    BJCYCD            3
      ** Base Curr. rate (MMSTDLPP) via caller
     C                   PARM                    IKBRAT           13 8
      ** Mult/Div. Indic. (MMSTDLPP) via caller
     C                   PARM                    IKMMDI            1
      ** Action Code                                                                          191138
     C                   PARM                    DDACTN            1                          191138

      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
     C                   ENDSR

      *****************************************************************
      /EJECT
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
