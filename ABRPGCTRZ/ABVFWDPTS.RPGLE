     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas AB Validate forward points')                     *
      *****************************************************************
      *                                                               *
      *  Midas - Internal Contracts (Dealing) Module                  *
      *                                                               *
      *  ABVFWDPTS - Validate Forward Points                          *
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
      *  Prev Amend No. MD000091           Date 09May13               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 156689             Date 08Mar99               *
      *                 CAP004 *CREATE     Date 08Sep98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
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
 
     D                 DS
      * Amount data structure for cross-validation #1 - W@115nn
     D  W@1150                 1     15  0
     D  W@1151                 1     15  1
     D  W@1152                 1     15  2
     D  W@1153                 1     15  3
     D                 DS
      * Amount data structure for cross-validation #2 - W@215nn
     D  W@2150                 1     15  0
     D  W@2151                 1     15  1
     D  W@2152                 1     15  2
     D  W@2153                 1     15  3
     D                 DS
      * Amount data structure for cross-validation #3 - W@315nn
     D  W@3150                 1     15  0
     D  W@3151                 1     15  1
     D  W@3152                 1     15  2
     D  W@3153                 1     15  3
 
     D M@MGDA          DS
      * Message data data structure
     D  M@0145                 1     45
     D  M@0115                 1     15
     D  M@0102                 1      2  0
     D  M@0101                 1      1  0
     D  M@1630                16     30
 
 
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
 
     C                   Z-ADD     *ZERO         JUFWPP                          Fwd. points
     C                   Z-ADD     *ZERO         JUFDXR                          New rate
      *
      ** FORWARD POINTS VALIDATION
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
     C                   EXSR      FPTSV
     C                   END                                                    FI
      *
      ** If an error was found, set the return code appropriately
      *
     C     DDFPTSOK      IFEQ      'N'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
      *
      * RETURN
      *
     C                   RETURN
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** FPTSV - FORWARD POINTS VALIDATION
      *****************************************************************
     C     FPTSV         BEGSR
      *
      * Forward Points can't be blank
      *
     C     DDFPTS        IFEQ      *BLANK
     C                   MOVE      'N'           DDFPTSOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDFPTS'      FldNamXAr(Idx)
     C                   MOVEL     'ABM0127'     MsgIdXAr(Idx)
     C                   GOTO      EFPTSV
     C                   END
      *
      * Forward Points must be a valid (signed) number
      *
     C                   MOVE      *BLANKS       ZFLD17
     C                   MOVEL     DDFPTS        ZFLD17
     C     7             SUB       2             ZSDIG
     C                   Z-ADD     2             ZSDEC
 
     C                   EXSR      ZASIGN
      *
      * It is an invalid number
      *
     C     ZASIGNok      IFEQ      'N'
     C                   MOVE      'N'           DDFPTSOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDFPTS'      FldNamXAr(Idx)
     C                   MOVEL     'ABM0213'     MsgIdXAr(Idx)
     C                   GOTO      EFPTSV
     C                   END
      *
      * Forward Points for output to file
      *
     C                   MOVE      ZOUT15        JUFWPP
     C     ZFSIGN        IFEQ      '-'
     C                   Z-SUB     JUFWPP        JUFWPP
     C                   ENDIF
      *
      * Edit Forward points (signed) for display
      *
     C                   Z-ADD     *ZERO         @@AMTW
     C                   MOVE      JUFWPP        @@AMTW
     C                   Z-ADD     2             W@DECP
     C                   EXSR      FMTAMT
     C                   MOVE      @@AMTD        DDFPTS
      *
      * Calculate forward points
      * ------------------------
      *
      * Set up second leg sell amount
      *
     C                   MOVE      JUFDA1        W@2150
     C                   SELECT
     C     JUCDPF        WHENEQ    *ZERO
     C                   Z-ADD     W@2150        W@AMTS           15 3
     C     JUCDPF        WHENEQ    1
     C                   Z-ADD     W@2151        W@AMTS
     C     JUCDPF        WHENEQ    2
     C                   Z-ADD     W@2152        W@AMTS
     C     JUCDPF        WHENEQ    3
     C                   Z-ADD     W@2153        W@AMTS
     C                   ENDSL
      *
      * Set up second leg buy amount
      *
     C                   MOVE      JUFDA2        W@1150
     C                   SELECT
     C     JUCDPS        WHENEQ    *ZERO
     C                   Z-ADD     W@1150        W@AMTB           15 3
     C     JUCDPS        WHENEQ    1
     C                   Z-ADD     W@1151        W@AMTB
     C     JUCDPS        WHENEQ    2
     C                   Z-ADD     W@1152        W@AMTB
     C     JUCDPS        WHENEQ    3
     C                   Z-ADD     W@1153        W@AMTB
     C                   ENDSL
      *
      * Calculate 2nd leg rate
      *
     C     JUDMD1        IFEQ      'D'
     C     W@AMTS        DIV(H)    W@AMTB        W@RATE           12 8
     C                   ELSE
     C     W@AMTB        DIV(H)    W@AMTS        W@RATE
     C                   END
      *
      * Far Date Exchange Rate for output to file
      *
     C                   Z-ADD     W@RATE        JUFDXR                          New rate
      *
      * Edit Far Date Exchange Rate for display
      *
     C                   Z-ADD     *ZERO         @@AMTW
     C                   MOVE      JUFDXR        @@AMTW
     C                   Z-ADD     8             W@DECP
     C                   EXSR      FMTAMT
     C                   MOVE      @@AMTP        DDL2RT
      *
      * Calculate 2nd leg forward points
      *
     C     JUNDXR        SUB       JUFDXR        W@TMP1           15 8
     C                   MULT      -1            W@TMP1
      *
      * Correct decimal positions
      *
     C     W@NQDP        IFNE      0
     C                   MULT      @AD(W@NQDP)   W@TMP1
     C                   END
      *
      *  Calculate differance between input and calculated forward points
      *  If differance is not in range + or - 1 send warning message with
      *  calculated forward points.
      *
     C                   Z-ADD(H)  W@TMP1        W@3152                         Correct size
     C     JUFWPP        SUB       W@3152        W@DIF1            8 2
     C     W@DIF1        IFGT      .01                                          IF   ¦ DIFF.
     C     W@DIF1        ORLT      -.01                                          AND ¦
     C                   MOVE      *BLANK        M@MGDA                           Message data
     C                   Z-ADD     W@3150        @@AMTW                           I:Amount
     C                   Z-ADD     2             W@DECP                           I:Dec.places
     C                   EXSR      FMTAMT                                         <Convert>
     C                   Z-ADD     1             P1                               Set ptr.1
     C     *BLANK        LOOKUP    @Y(P1)                             90          Find start
     C                   MOVEA     @Y(P1)        M@0115                           O:To msg.data
     C                   MOVE      M@MGDA        M@MGD2           45              Stack Msg.Dta
     C                   MOVE      'W'           DDFPTSOK
     C                   ADD       1             WIx
     C                   MOVEL     'DDFPTS'      WFldNmXAr(WIx)
     C                   MOVEL     'ABM0109'     WMsgIdXAr(WIx)
     C**********         MOVEL     M@MGD2        WMsgDtXAr(WIx)                  I:Msg.data MD000091
     C                   EVAL      BLen = %Len(%Trim(M@MGD2))                               MD000091
     C                   EVAL      WMsgDtXAr(WIx) = LenStr +%TRIM(M@MGD2)                   MD000091
     C                   END                                                    FI
      *
     C     EFPTSV        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * ZASIGN - VALIDATE SIGNED NUMERIC AMOUNT
      *****************************************************************
     C     ZASIGN        BEGSR
 
     C                   CALLB     'ZASIGN'
     C                   PARM                    ZASIGNok          1
     C                   PARM                    ZFLD17           17
     C                   PARM                    ZSDIG             2 0
     C                   PARM                    ZSDEC             1 0
     C                   PARM      BNDCSP        ZSDCSP            1            156689
     C                   PARM      *BLANK        ZOUT15           15
     C                   PARM      *BLANK        ZFSIGN            1
 
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
     C                   PARM                    DDFPTS            9
      *
      ** Deal File fields
      ** Near Date Exchange Rate
      ** First Currency Decimal Places
      ** First Ccy Far Date Amount
      ** Second Currency Decimal Places
      ** Second Ccy Far Date Amount
      ** Deal Mult/Div First Amount Ind
      *
     C                   PARM                    JUNDXR           13 8
     C                   PARM                    JUCDPF                           Dec.places
     C                   PARM                    JUFDA1           15 0            Amount
     C                   PARM                    JUCDPS                           Dec.places
     C                   PARM                    JUFDA2           15 0            Amount
     C                   PARM                    JUDMD1            1              Dec.places
      *
      * Deal Normally-Quoted Decimal Places:
     C                   PARM                    W@NQDP            1 0            Quoted=5
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
      ** ICD
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
      * 2nd Leg Exchange Rate
     C                   PARM                    DDL2RT           13
      *
      ** Forward Points - OK
     C                   PARM                    DDFPTSOK          1
      *
      ** Deal Far Date exchange Rate
      ** Deal Forward Points
      *
     C                   PARM                    JUFDXR           13 8           New rate
     C                   PARM                    JUFWPP            7 2           Fwd. points
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
(c) Finastra International Limited 2001
** @AD
000000010
000000100
000001000
000010000
000100000
001000000
010000000
100000000
