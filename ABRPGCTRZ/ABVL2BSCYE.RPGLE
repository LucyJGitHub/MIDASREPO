     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas AB Validate leg 2 base ccy equivalent')          *
      *****************************************************************
      *                                                               *
      *  Midas - Internal Contracts (Dealing) Module                  *
      *                                                               *
      *  ABVL2BSCYE - Validate Leg 2 Base Currency Equivalent         *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. MD000091           Date 09May13               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *  Prev Amend No. 156689             Date 08Mar99               *
      *                 CAP004 *CREATE     Date 08Sep98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD000091 - Event Codes Substitution                          *
      *  156689 - ZASIGN TO RECOGNIZE '.' OR ',' AS DECIMAL SEPARATOR *
      *  CAP004 - API's Phase 3.                                      *
      *                                                               *
      *****************************************************************
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
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
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the size
      ** of the arrays.
     D/COPY ZACPYSRC,ERR_XARRYS
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
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      * AMOUNT EDITING FIELDS
     D                 DS
     D  @Z                     1     16
     D                                     DIM(16) ASCEND
     D  @Y                     1     17
     D                                     DIM(17) ASCEND
     D  @@AMTP                 1     16
     D  @@AMTD                 1     17
 
 
     D                 DS
      * Decimal Adjustment array/field data structure
     D  @AD                    1     72  0
     D                                     DIM(8) CTDATA PERRCD(1)
 
 
     D M@MGDA          DS
      * Message data data structure
     D  M@0145                 1     45
     D  M@0115                 1     15
     D  M@0102                 1      2  0
     D  M@0101                 1      1  0
     D  M@1630                16     30
 
     D                 DS
      * BCE Low range value data structure (Subrs.BEBCE1 & BFBCE2)
     D  W@BC0L                 1     15  0
     D  W@BC1L                 1     15  1
     D  W@BC2L                 1     15  2
     D  W@BC3L                 1     15  3
     D                 DS
      * BCE High range value data structure (Subrs.BEBCE1 & BFBCE2)
     D  W@BC0H                 1     15  0
     D  W@BC1H                 1     15  1
     D  W@BC2H                 1     15  2
     D  W@BC3H                 1     15  3
 
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
      ** Index for arrays of warning message ids etc
     D WIx             S              3P 0
 
     D JUCDPF          S              1S 0
     D JUCDPS          S              1S 0
 
      **                                                                                    MD000091
     D BChar           DS                                                                   MD000091
     D   BLen                  1      2B 0                                                  MD000091
     D   LenStr                1      2                                                     MD000091
                                                                                            MD000091
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
 
      ** Initialization
 
     C                   MOVE      *BLANK        RetCodeIn
 
     C                   MOVE      *BLANK        FldNamXAr
     C                   MOVE      *BLANK        MsgIDXAr
     C                   MOVE      *BLANK        MsgDtaXAr
     C                   Z-ADD     0             Idx
     C                   MOVE      *BLANK        WFldNmXAr
     C                   MOVE      *BLANK        WMsgIDXAr
     C                   MOVE      *BLANK        WMsgDtXAr
     C                   Z-ADD     0             WIx
 
      ** Clear output deal fields
 
     C                   Z-ADD     *ZERO         JUFBCA
      *
      * 2nd.Base Currency Equivalent Validation
      *
     C     DDL1RTOK      IFNE      'N'
     C     DDL1DTOK      ANDNE     'N'
     C     DDL1CBOK      ANDNE     'N'
     C     DDL1BAOK      ANDNE     'N'
     C     DDL1CSOK      ANDNE     'N'
     C     DDL1SAOK      ANDNE     'N'
     C     DDL2DTOK      ANDNE     'N'
     C     DDLRDFOK      ANDNE     'N'                                           AND R-D IND OK
     C     DDLOCMOK      ANDNE     'N'
     C     DDLOIROK      ANDNE     'N'                                           1ST LEG SELL
     C     DDDRDFOK      ANDNE     'N'                                           AND R-D IND OK
     C     DDDPCMOK      ANDNE     'N'
     C     DDDPIROK      ANDNE     'N'                                           1ST LEG BUY
     C                   EXSR      L2BEV
     C                   END
      *
      ** If an error was found, set the return code appropriately
      *
     C     DDL2BEOK      IFEQ      'N'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
      *
      * RETURN
      *
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      * L2BEV - 2nd.Base Currency Equivalent Validation
      *****************************************************************
     C     L2BEV         BEGSR
      *
      * If defined,
      * 2nd. Leg Base Equivalent must be a valid amount in base ccy
      *
     C     DDL2BE        IFNE      *BLANK
     C                   Z-ADD     BseCcyDP      @@IDP
     C     13            SUB       BseCcyDP      @@IINT
     C                   MOVE      *BLANKS       @@ALPH
     C                   MOVE      DDL2BE        @@ALPH
     C                   MOVE      'Y'           @@MTID
     C                   EXSR      ZA0840
      *
      * It is an invalid amount
      *
     C     @@ERCD        IFNE      0
     C                   MOVE      'N'           DDL2BEOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDL2BE'      FldNamXAr(Idx)
     C                   MOVEL     'ABM0211'     MsgIdXAr(Idx)
     C                   GOTO      EL2BEV
     C                   END
      *
      * 2nd. Leg Base Equivalent must not be zero.
      *
     C                   MOVE      @@ALPH        DDL2BE
     C     @@AMT         IFEQ      *ZEROS
     C                   MOVE      'N'           DDL2BEOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDL2BE'      FldNamXAr(Idx)
     C                   MOVEL     'ABM0212'     MsgIdXAr(Idx)
     C                   GOTO      EL2BEV
     C                   END
      *
      * 1st. Leg Base Equivalent for output to file
      *
     C                   Z-ADD     @@AMT         JUFBCA
      *
     C                   END
      *
      * If 2nd Leg Buy Currency is Base currency, BCE is 2nd Leg Buy Amt
      * (Send warning message if overridden)
      *
     C     DDL2CB        IFEQ      BJCYCD                                       IF L2/BUY=BASE
     C     JUFBCA        IFNE      *ZERO                                        IF BCE ENTERED
     C     JUFDA2        ANDNE     JUFBCA                                        AND BUY<>BCE
     C                   MOVE      'W'           DDL2BEOK
     C                   ADD       1             WIx
     C                   MOVEL     'DDL2BE'      WFldNmXAr(WIx)
     C                   MOVEL     'ABM0136'     WMsgIdXAr(Wix)
     C                   END                                                    FI
     C                   Z-ADD     JUFDA2        JUFBCA                           Default
     C                   GOTO      SL2BEV                                         Skip--->
     C                   END                                                    FI
      *
      * If 2nd Leg Sell Currency is Base currency, BCE is 1st Leg Sell Amt
      * (Send warning message if overridden)
      *
     C     DDL2CS        IFEQ      BJCYCD                                       IF L2/SELL=BASE
     C     JUFBCA        IFNE      *ZERO                                        IF BCE ENTERED
     C     JUFDA1        ANDNE     JUFBCA                                        AND SELL<>BCE
     C                   MOVE      'W'           DDL2BEOK
     C                   ADD       1             WIx
     C                   MOVEL     'DDL2BE'      WFldNmXAr(WIx)
     C                   MOVEL     'ABM0135'     WMsgIdXAr(Wix)
     C                   END                                                    FI
     C                   Z-ADD     JUFDA1        JUFBCA                           Default
     C                   GOTO      SL2BEV                                         Skip--->
     C                   END                                                    FI
      *
      * Calculate BCE for 2nd.Leg Sell currency :
      *
     C     JUCDPF        IFGT      *ZERO                                        IF DECP>0
     C     JUFDA1        DIV(H)    @AD(JUCDPF)   W@BCE1           15 3            Adjust
     C                   ELSE                                                   EL DECP=0
     C                   Z-ADD     JUFDA1        W@BCE1                           Amount
     C                   END                                                    FI
     C     W@MDI1        IFEQ      'M'                                          IF MULTIPLY 1
     C                   MULT(H)   W@SRT1        W@BCE1                           Amount*Spot
     C                   ELSE                                                   EL DIVIDE   1
     C     W@SRT1        IFNE      *ZERO                                        IF NOT ZERO
     C                   DIV(H)    W@SRT1        W@BCE1                           Amount/Spot
     C                   END                                                    FI
     C                   END                                                    FI
      *
      * Calculate BCE for 2nd.Leg Buy currency :
      *
     C     JUCDPS        IFGT      *ZERO                                        IF DECP>0
     C     JUFDA2        DIV(H)    @AD(JUCDPS)   W@BCE2           15 3            Adjust
     C                   ELSE                                                   EL DECP=0
     C                   Z-ADD     JUFDA2        W@BCE2                           Amount
     C                   END                                                    FI
     C     W@MDI2        IFEQ      'M'                                          IF MULTIPLY 2
     C                   MULT(H)   W@SRT2        W@BCE2                           Amount*Spot
     C                   ELSE                                                   EL DIVIDE 2
     C     W@SRT2        IFNE      *ZERO                                        IF NOT ZERO
     C                   DIV(H)    W@SRT2        W@BCE2                           Amount/Spot
     C                   END                                                    FI
     C                   END                                                    FI
      *
      * Find the average of the BCE values calculated :
      *
     C                   ADD       W@BCE1        W@BCE2                         Sum
     C                   DIV(H)    2             W@BCE2                         Average
      *
      * Calculate lowest and highest (average +/- 20%) :
      *
     C     W@BCE2        DIV(H)    5             W@BCE1                         20%
     C     W@BCE2        SUB       W@BCE1        W@BCEL           15 3          Lowest allowed
     C     W@BCE2        ADD       W@BCE1        W@BCEH           15 3          Highest allowed
      *
      * Adjust High & Low values to Base decimal positions :
      *
     C     BseCcyDP      IFEQ      *ZERO                                        IF BASE DECP=0
     C                   Z-ADD(H)  W@BCEL        W@BC0L                           Adjust Low
     C                   Z-ADD(H)  W@BCEH        W@BC0H                           Adjust High
     C                   END                                                    FI
     C     BseCcyDP      IFEQ      1                                            IF BASE DECP=1
     C     W@BCEL        DIV(H)    1             W@BC1L                           Adjust Low
     C     W@BCEH        DIV(H)    1             W@BC1H                           Adjust High
     C                   END                                                    FI
     C     BseCcyDP      IFEQ      2                                            IF BASE DECP=2
     C     W@BCEL        DIV(H)    1             W@BC2L                           Adjust Low
     C     W@BCEH        DIV(H)    1             W@BC2H                           Adjust High
     C                   END                                                    FI
     C     BseCcyDP      IFEQ      3                                            IF BASE DECP=3
     C     W@BCEL        DIV(H)    1             W@BC3L                           Adjust Low
     C     W@BCEH        DIV(H)    1             W@BC3H                           Adjust High
     C                   END                                                    FI
      *
      * If no amount entered, use median as default :
      * (and send warning message)
      *
     C     JUFBCA        IFEQ      *ZERO                                        IF NOT ENTERED
     C     W@BC0H        ADD       W@BC0L        JUFBCA                           Sum
     C                   DIV(H)    2             JUFBCA                           Average
     C                   MOVE      'W'           DDL2BEOK
     C                   ADD       1             WIx
     C                   MOVEL     'DDL2BE'      WFldNmXAr(WIx)
     C                   MOVEL     'ABM0161'     WMsgIdXAr(Wix)
     C                   END                                                    FI
      *
      * Check entered amount against calculated limits :
      *
     C     JUFBCA        IFLT      W@BC0L                                       IF  TOO LOW
     C     JUFBCA        ORGT      W@BC0H                                        OR TOO HIGH
     C                   MOVE      *BLANK        M@MGDA                           Message data
     C                   Z-ADD     W@BC0L        @@AMTW                           I:Amount
     C                   Z-ADD     BseCcyDP      W@DECP                           I:Dec.places
     C                   EXSR      FMTAMT                                         <Convert>
     C                   Z-ADD     1             P1                               Set ptr.1
     C     *BLANK        LOOKUP    @Z(P1)                             90          Find start
     C                   MOVEA     @Z(P1)        M@0115                           O:To msg.data
     C                   Z-ADD     W@BC0H        @@AMTW                           I:Amount
     C                   Z-ADD     BseCcyDP      W@DECP                           I:Dec.places
     C                   EXSR      FMTAMT                                         <Convert>
     C                   Z-ADD     1             P1                               Set ptr.1
     C     *BLANK        LOOKUP    @Z(P1)                             90          Find start
     C                   MOVEA     @Z(P1)        M@1630                           O:To msg.data
     C                   MOVE      'N'           DDL2BEOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDL2BE'      FldNamXAr(Idx)
     C                   MOVEL     'ABM0138'     MsgIdXAr(Idx)
     C**********         MOVEL     M@MGDA        MsgDtaXAr(Idx)                  I:Msg.data MD000091
     C                   EVAL      BLen = %Len(%Trim(M@MGDA))                               MD000091
     C                   EVAL      MsgDtaXAr(Idx) = LenStr +%TRIM(M@MGDA)                   MD000091
     C                   GOTO      EL2BEV
     C                   END                                                    FI
      *          _____________
     C     SL2BEV        TAG                                                    +++TAG+++
      *          ~~~~~~~~~~~~~
      * Reformat BCE amount for display :
      *
     C                   Z-ADD     JUFBCA        @@AMTW                         I:Amount
     C                   Z-ADD     BseCcyDP      W@DECP                         I:Dec.places
     C                   EXSR      FMTAMT                                       <Convert>
     C                   MOVE      @@AMTP        DDL2BE                         O:To display
      *
     C     EL2BEV        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * ZA0840 - VALIDATE/REFORMAT AMOUNT                             *
      *****************************************************************
     C     ZA0840        BEGSR
     C                   CALLB     'ZA0840'
     C                   PARM      *BLANK        RetCodeOut
     C                   PARM                    @@ALPH           16            Display field
     C                   PARM                    @@IDP             3 0          no.of dec.plcs
     C                   PARM                    @@IINT            3 0          no.of integers
     C                   PARM                    @@MTID            1            Million/Thous.
     C                   PARM      *ZERO         @@ERCD            1 0          Error code
     C                   PARM      *ZERO         @@AMT            15 0          File field
     C                   PARM                    BNDCSP
     C                   ENDSR
      *****************************************************************
      /EJECT
     C*********************************************************************
     C* FMTAMT - FORMAT AMOUNT FOR DISPLAY
     C*********************************************************************
     C     FMTAMT        BEGSR
 
     C                   CALLB     'ZA0921'
     C                   PARM      *BLANK        @@RETC           10
     C                   PARM                    @@AMTW           15 0
     C                   PARM                    W@DECP            1 0
     C                   PARM      BNDCSP        @@DCSP            1            156689
     C                   PARM      *BLANK        @@AMTP           16
     C                   PARM      *BLANK        @@AMTD           17
 
     C                   ENDSR
     C*********************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeIn
      *
      ** Deal Screen fields
      ** 2nd leg base equivalent
      ** 2nd leg buy currency
      ** 2nd leg sell currency
     C                   PARM                    DDL2BE           16
     C                   PARM                    DDL2CB            3
     C                   PARM                    DDL2CS            3
      *
      ** Deal File fields
      ** First Currency Decimal Places
      ** First Ccy Far Date Amount
      ** Second Currency Decimal Places
      ** Second Ccy Far Date Amount
      *
     C                   PARM                    JUCDPF                           Dec.places
     C                   PARM                    JUFDA1           15 0            Amount
     C                   PARM                    JUCDPS                           Dec.places
     C                   PARM                    JUFDA2           15 0            Amount
      *
      ** 1st Leg Exchange Rate - OK
      ** 1st Leg Value Date - OK
      ** 1st Leg Buy Currency - OK
      ** 1st Leg Buy Amount - OK
      ** 1st Leg Sell Currency - OK
      ** 1st Leg Sell Amount - OK
      ** 2nd Leg Value Date - OK
      ** Loan Round down Ind. - OK
      ** Loan Interest Calculation Method - OK
      ** Loan Interest Rate - OK
      ** Deposit Round down Ind. - OK
      ** Deposit Interest Calculation Method - OK
      ** Deposit Interest Rate - OK
     C                   PARM                    DDL1RTOK          1
     C                   PARM                    DDL1DTOK          1
     C                   PARM                    DDL1CBOK          1
     C                   PARM                    DDL1BAOK          1
     C                   PARM                    DDL1CSOK          1
     C                   PARM                    DDL1SAOK          1
     C                   PARM                    DDL2DTOK          1
     C                   PARM                    DDLRDFOK          1             AND R-D IND OK
     C                   PARM                    DDLOCMOK          1
     C                   PARM                    DDLOIROK          1             1ST LEG SELL
     C                   PARM                    DDDRDFOK          1             AND R-D IND OK
     C                   PARM                    DDDPCMOK          1
     C                   PARM                    DDDPIROK          1             1ST LEG SELL
      *
      ** Currency 1 & 2 spot rates & M/D indicators
     C                   PARM                    W@SRT1           13 8            Spot rate
     C                   PARM                    W@MDI1            1              Mult/Div.ind.
     C                   PARM                    W@SRT2           13 8            Spot rate
     C                   PARM                    W@MDI2            1              Mult/Div.ind.
      *
      ** ICD
     C                   PARM                    BJCYCD            3
     C                   PARM                    BseCcyDP          1 0
     C                   PARM                    BNDCSP            1
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr
      *
      ** 2nd leg base equivalent - OK
     C                   PARM                    DDL2BEOK          1
      *
      ** Far Date Base Ccy for Accounting Amount
     C                   PARM                    JUFBCA           15 0            Amount
      *
      ** Work fields
      *
 
     C                   Z-ADD     1             P1                5 0          Set pointer 1
      *
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      ********************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
** @AD
000000010
000000100
000001000
000010000
000100000
001000000
010000000
100000000
