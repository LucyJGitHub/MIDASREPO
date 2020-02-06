     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas DE Maintain position data')
      *****************************************************************
      *                                                               *
      *  Midas - Data Export module                                   *
      *                                                               *
      *  DEMNTPOSD - Maintain Position Data.                          *
      *                                                               *
      *  Function:  This module calculates the nominal and interest   *
      *             for a current position and updates the position   *
      *             data with these details.                          *
      *                                                               *
      *  Component of: DEWRKEDTS                                      *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.03 -----------------------------------------------*
      *  Prev Amend No. CDE001  *CREATE    Date 16Dec99               *
      *                                    Date DDMmmYY               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CDE001 - Data Export - CCRM Limits.                          *
      *                                                               *
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
 
     D/COPY DECPYSRC,DEEVDARRS
 
     D POWER8          S              8  4 DIM(8) CTDATA PERRCD(1)
 
      *
      * INPUT PARAMETERS
      *
     C     *ENTRY        PLIST
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           30
      * INPUTS
      * mode
     C                   PARM                    I#MODE           10
      * dec.places
     C                   PARM                    I#NCDP            1 0          * NOM. CCY DEC.P.
     C                   PARM                    I#NMDP            1 0          * NOM.DEC.PLCS
      * int.calc.method
     C                   PARM                    I#ICMT            7            * INT CAL MTHD
      * int paymts/year
     C                   PARM                    I#IPY             2 0          * INT PAY PER YR
      * sec.price basis
     C                   PARM                    I#SPBS            1            * NOM. CCY DEC.P.
      * Yen bond?, mort-backed, part-paid, fully paid price, accuracy
     C                   PARM                    I#YBON            1            * YEN BOND ?
     C                   PARM                    I#MORT            1            * YEN BOND ?
     C                   PARM                    I#PART            1            * YEN BOND ?
     C                   PARM                    I#FUPP           15 0          * NOMINAL
     C                   PARM                    I#ACUR            1 0          * ACCURACY
      * Event dates & data
     C                   PARM                    #arevdt_ip
     C                   PARM                    #arevdt_ir
     C                   PARM                    #arevdt_mp
     C                   PARM                    #arevdt_pp
      * nominal
     C                   PARM                    P_PS_NOML        15 0
     C                   PARM                    P_PS_XNML        15 0
      * consideration
     C                   PARM                    P_PS_CONS        15 0
      * purchased int
     C                   PARM                    P_PS_PINT        15 0
      * discount/premium
     C                   PARM                    P_PS_DIPR        15 0
      * trade details
     C                   PARM                    TD_TDTP           2
     C                   PARM                    TD_ACIN           1
     C                   PARM                    TD_TDVD           5 0
     C                   PARM                    TD_NOML          11 0
     C                   PARM                    TD_PRIC          15 8
     C                   PARM                    TD_CONS          15 0
     C                   PARM                    TD_PINT          15 0
      * curr.factor, PP price
     C                   PARM                    PS_CFCT          10 9
     C                   PARM                    PS_PPCP          10 9
 
      * OUTPUTS
      * asset/liab ind.
     C                   PARM                    N_PS_ASLI         1
      * nominal
     C                   PARM                    N_PS_NOML        15 0
     C                   PARM                    N_PS_XNML        15 0
      * consideration
     C                   PARM                    N_PS_CONS        15 0
      * purchased int
     C                   PARM                    N_PS_PINT        15 0
      * discount/premium
     C                   PARM                    N_PS_DIPR        15 0
      * average price
     C                   PARM                    PS_AVPR          15 8
      * realized P/L
     C                   PARM                    PS_RLPL          15 0
 
 
     C                   SELECT
 
      * INITIALIZE
 
     C     I#MODE        WHENEQ    '*INIT   '
 
     C                   EXSR      INIT
 
     C                   OTHER
 
      * UPDATE POSITION
 
     C                   EXSR      UPD_POSN
 
      * SET ASSET/LIABILITY INDICATOR
 
     C     N_PS_NOML     IFLT      *ZERO
     C                   MOVE      'L'           N_PS_ASLI
     C                   ELSE
     C                   MOVE      'A'           N_PS_ASLI
     C                   ENDIF
 
      * CALCULATE AVERAGE PRICE (COST/NOMINAL)
 
     C     N_PS_NOML     IFNE      *ZERO
     C                   EXSR      CAL_AVPR
     C                   ELSE
     C                   Z-ADD     *ZERO         PS_AVPR
     C                   END
 
      * CALCULATE TOTAL INTEREST ON CURRENT POSITION AT VALUE DATE
 
     C                   EXSR      CAL_INTM
 
      ** CALCULATE REALIZED PROFIT/LOSS (DUE TO TRADE)
 
     C                   EXSR      CAL_RLPL
 
     C                   ENDSL
 
     C                   RETURN
 
      ********************************************************************
      * UPDATE POSITION
      ********************************************************************
     C     UPD_POSN      BEGSR
      *
      ** Initialize NEW nominal, consideration, purch.interest, discnt/prem
      *
     C                   Z-ADD     P_PS_NOML     N_PS_NOML
     C                   Z-ADD     P_PS_XNML     N_PS_XNML
     C                   Z-ADD     P_PS_CONS     N_PS_CONS
     C                   Z-ADD     P_PS_PINT     N_PS_PINT
     C                   Z-ADD     P_PS_DIPR     N_PS_DIPR
      *
      **  Calculate trade discount/premium
      *
     C     I#SPBS        IFEQ      'P'
     C                   Z-ADD     TD_NOML       ZNOML
     C                   Z-ADD     100           ZPRC
      * adjust the nominal by the partly paid price
     C     I#PART        IFEQ      'Y'
     C                   MULT(H)   PS_PPCP       ZNOML
     C                   ENDIF
     C                   EXSR      ZCNSD
     C                   Z-ADD     ZCONS         TD_DIPR          15 0
     C                   Z-ADD     TD_NOML       ZNOML
     C                   Z-ADD     TD_PRIC       ZPRC
     C                   EXSR      ZCNSD
     C                   SUB       ZCONS         TD_DIPR
     C                   ELSE
     C                   Z-ADD     *ZERO         TD_DIPR
     C                   ENDIF
      *
      **  Calculate absolute value of nominal
      *
     C     N_PS_NOML     IFLT      *ZEROS
     C                   Z-SUB     N_PS_NOML     AB_NOML          11 0
     C                   ELSE
     C                   Z-ADD     N_PS_NOML     AB_NOML
     C                   END
 
      *-------------------------------------------------------------------------
      **   1. Update fields for trade purchase
      *-------------------------------------------------------------------------
 
     C     TD_TDTP       IFEQ      'TP'
      *
      **   Update nominal
     C                   ADD       TD_NOML       N_PS_NOML
      *
      **   Update the ex-coupon nominal and purchased interest
      *
     C     TD_ACIN       IFEQ      'X'
     C                   ADD       TD_NOML       N_PS_XNML
     C                   END
      *
      **   Update the cost, purch.int and disc/prem
      *
     C     P_PS_NOML     IFEQ      *ZEROS
     C                   Z-ADD     TD_CONS       N_PS_CONS
     C                   Z-ADD     TD_PINT       N_PS_PINT
     C                   Z-ADD     TD_DIPR       N_PS_DIPR
     C                   END
      *
     C     P_PS_NOML     IFGT      *ZEROS
     C                   ADD       TD_CONS       N_PS_CONS
     C                   ADD       TD_PINT       N_PS_PINT
     C                   ADD       TD_DIPR       N_PS_DIPR
     C                   END
      *
     C     P_PS_NOML     IFLT      *ZEROS
      *
     C     AB_NOML       IFGT      TD_NOML
     C     N_PS_NOML     DIV(H)    P_PS_NOML     W158             15 8
     C     W158          MULT(H)   N_PS_CONS     N_PS_CONS
     C     W158          MULT(H)   N_PS_PINT     N_PS_PINT
     C     W158          MULT(H)   N_PS_DIPR     N_PS_DIPR
     C                   END
      *
     C     AB_NOML       IFLT      TD_NOML
      *
      **   Calculate consideration
      *
     C                   Z-ADD     N_PS_NOML     ZNOML
     C                   Z-ADD     TD_PRIC       ZPRC
     C                   EXSR      ZCNSD
      *
     C                   Z-ADD     ZCONS         N_PS_CONS
      *
      **   Calculate PURCHASED INTEREST
      *
     C                   EXSR      CAL_INTM
     C                   Z-ADD(H)  W#TINT        N_PS_PINT
      *
      **   Calculate DISCOUNT/PREMIUM
      *
     C     I#SPBS        IFEQ      'P'
     C                   Z-ADD     N_PS_NOML     ZNOML
     C                   Z-ADD     100           ZPRC
      * adjust the nominal by the partly paid price
     C     I#PART        IFEQ      'Y'
     C                   MULT(H)   PS_PPCP       ZNOML
     C                   ENDIF
     C                   EXSR      ZCNSD
      *
     C     ZCONS         SUB       N_PS_CONS     N_PS_DIPR
     C                   ELSE
     C                   Z-ADD     *ZERO         N_PS_DIPR
     C                   ENDIF
      *
     C                   END
      *
     C     AB_NOML       IFEQ      TD_NOML
     C                   Z-ADD     *ZEROS        N_PS_CONS
     C                   Z-ADD     *ZEROS        N_PS_PINT
     C                   Z-ADD     *ZEROS        N_PS_DIPR
     C                   END
      *
     C                   END
      *
     C                   END
 
      *-------------------------------------------------------------------------
      **   2. Update fields for trade sale
      *-------------------------------------------------------------------------
 
     C     TD_TDTP       IFEQ      'TS'
      *
      **   Update nominal
      *
     C                   SUB       TD_NOML       N_PS_NOML
      *
      **   Update the ex-coupon nominal
      *
     C     TD_ACIN       IFEQ      'X'
     C                   SUB       TD_NOML       N_PS_XNML
     C                   END
      *
      **   Update the cost, purch.int and disc/prem
      *
     C     P_PS_NOML     IFEQ      *ZEROS
     C                   Z-SUB     TD_CONS       N_PS_CONS
     C                   Z-SUB     TD_PINT       N_PS_PINT
     C                   Z-SUB     TD_DIPR       N_PS_DIPR
     C                   END
      *
     C     P_PS_NOML     IFLT      *ZEROS
     C                   SUB       TD_CONS       N_PS_CONS
     C                   SUB       TD_PINT       N_PS_PINT
     C                   SUB       TD_DIPR       N_PS_DIPR
     C                   END
      *
     C     P_PS_NOML     IFGT      *ZEROS
      *
     C     P_PS_NOML     IFGT      TD_NOML
     C     N_PS_NOML     DIV(H)    P_PS_NOML     W158             15 8
     C     W158          MULT(H)   N_PS_CONS     N_PS_CONS
     C     W158          MULT(H)   N_PS_PINT     N_PS_PINT
     C     W158          MULT(H)   N_PS_DIPR     N_PS_DIPR
     C                   END
      *
     C     P_PS_NOML     IFLT      TD_NOML
      *
      **   Calculate consideraion
      *
     C                   Z-ADD     N_PS_NOML     ZNOML
     C                   Z-ADD     TD_PRIC       ZPRC
     C                   EXSR      ZCNSD
      *
     C                   Z-ADD     ZCONS         N_PS_CONS
      *
      **   Calculate PURCHASED INTEREST
      *
     C                   EXSR      CAL_INTM
     C                   Z-ADD(H)  W#TINT        N_PS_PINT
      *
      **   Calculate DISCOUNT/PREMIUM
      *
     C     I#SPBS        IFEQ      'P'
     C                   Z-ADD     N_PS_NOML     ZNOML
     C                   Z-ADD     100           ZPRC
      * adjust the nominal by the partly paid price
     C     I#PART        IFEQ      'Y'
     C                   MULT(H)   PS_PPCP       ZNOML
     C                   ENDIF
     C                   EXSR      ZCNSD
      *
     C     ZCONS         SUB       N_PS_CONS     N_PS_DIPR
     C                   ELSE
     C                   Z-ADD     *ZERO         N_PS_DIPR
     C                   ENDIF
      *
     C                   END
      *
     C     P_PS_NOML     IFEQ      TD_NOML
     C                   Z-ADD     *ZEROS        N_PS_CONS
     C                   Z-ADD     *ZEROS        N_PS_PINT
     C                   Z-ADD     *ZEROS        N_PS_DIPR
     C                   END
      *
     C                   END
      *
     C                   END
      *
     C                   ENDSR
      ********************************************************************
      /SPACE
      ********************************************************************
      ** CALCULATE INTEREST ON POSITION
      ********************************************************************
     C     CAL_INTM      BEGSR
      *
      * IF NON-INTEREST BEARING, THEN IGNORE
      *
     C     I#IPY         IFEQ      0
     C                   Z-ADD     *ZERO         W#TINT
     C                   ELSE
      *
      * CALCULATE INTEREST ON TOTAL NOMINAL
      *
     C                   CALLB     'DECALINTM'
      * Inputs
     C                   PARM      *BLANK        W#RTCD            7
     C                   PARM      *BLANK        W#ERMS           30
     C                   PARM      *BLANK        W#MODE           10
     C                   PARM      I#NCDP        W#NCDP            1 0          * NOM. CCY DEC.P.
     C                   PARM      I#NMDP        W#NMDP            1 0          * NOM.DEC.PLCS
     C                   PARM      I#ICMT        W#ICMT            7            * INT CAL MTHD
     C                   PARM      I#IPY         W#IPY             2 0          * INT PAY PER YR
     C                   PARM      I#YBON        W#YBON            1            * YEN BOND ?
     C                   PARM      I#MORT        W#MORT            1            * YEN BOND ?
     C                   PARM      I#PART        W#PART            1            * YEN BOND ?
     C                   PARM      I#FUPP        W#FUPP           15 0          * NOMINAL
     C                   PARM      I#ACUR        W#ACUR            1 0          * ACCURACY
 
     C                   PARM      N_PS_NOML     W#NOML           15 0          * NOMINAL
     C                   PARM      *ZERO         W#SDAT            5 0
     C                   PARM      TD_TDVD       W#EDAT            5 0
      * Event dates & data
     C                   PARM                    #arevdt_ip
     C                   PARM                    #arevdt_ir
     C                   PARM                    #arevdt_mp
     C                   PARM                    #arevdt_pp
 
      * LAST/NEXT INTEREST PERIOD?
     C                   PARM      'N'           #LNIPERIOD        1
      * Outputs
     C                   PARM      *ZERO         W#TINT           15 2          * INTEREST
     C                   PARM      *ZERO         W#TINTP          15 9          * INTEREST %
     C                   PARM      *ZERO         W#TINTF          15 9          * INTEREST FACTOR
 
     C     W#RTCD        IFEQ      '*ERROR'
     C                   EVAL      I#ERMS = 'ERROR IN CALL TO DECALINTM'
     C                   EXSR      *PSSR
     C                   END
 
     C                   ENDIF
 
     C                   ENDSR
      ********************************************************************
      /SPACE
      ********************************************************************
      ** CALCULATE REALIZED PROFIT/LOSS (DUE TO TRADE)
      ********************************************************************
     C     CAL_RLPL      BEGSR
      *
      * PROFIT/LOSS = CHANGE IN POSITION COST
      * ADJUSTED BY TRADE COST
      *
     C     N_PS_CONS     SUB       P_PS_CONS     PS_RLPL
     C     TD_TDTP       IFEQ      'TS'
     C                   ADD       TD_CONS       PS_RLPL
     C                   ELSE
     C                   SUB       TD_CONS       PS_RLPL
     C                   END
 
      * Adjust if mortgage backed
     C     I#MORT        IFEQ      'Y'
     C                   MULT      PS_CFCT       PS_RLPL
     C                   ENDIF
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * CALCULATE AVERAGE PRICE
      ********************************************************************
     C     CAL_AVPR      BEGSR
      *
      * CALCULATE AVERAGE PRICE (COST/NOMINAL)
      *
     C     5             ADD       I#NCDP        W010              1 0
     C                   SUB       I#NMDP        W010
 
     C     W010          IFLT      5
     C     N_PS_CONS     DIV(H)    POWER8(W010)  W150             15 0
     C                   ELSE
     C                   Z-ADD     N_PS_CONS     W150
     C                   END
 
     C     I#SPBS        IFEQ      'P'
     C                   MULT      100           W150
     C                   END
 
     C     W150          DIV(H)    N_PS_NOML     PS_AVPR
     C     W010          IFGE      5
     C                   DIV(H)    POWER8(W010)  PS_AVPR          15 8
     C                   END
      *
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      *****************************************************************
     C     INIT          BEGSR
      *
      * CALCULATE INTEREST ON TOTAL NOMINAL - INITIALIZE
      *
     C                   CALLB     'DECALINTM'
      * Inputs
     C                   PARM      *BLANK        W#RTCD            7
     C                   PARM      *BLANK        W#ERMS           30
     C                   PARM      '*INIT     '  W#MODE           10
     C                   PARM      I#ICMT        W#ICMT            7            * INT CAL MTHD
     C                   PARM      I#IPY         W#IPY             2 0          * INT PAY PER YR
     C                   PARM      I#NCDP        W#NCDP            1 0          * NOM. CCY DEC.P.
     C                   PARM      I#NMDP        W#NMDP            1 0          * NOM.DEC.PLCS
     C                   PARM      I#ACUR        W#ACUR            1 0          * ACCURACY
     C                   PARM      I#YBON        W#YBON            1            * YEN BOND ?
     C                   PARM      I#MORT        W#MORT            1            * YEN BOND ?
     C                   PARM      I#PART        W#PART            1            * YEN BOND ?
     C                   PARM      I#FUPP        W#FUPP           15 0          * NOMINAL
 
     C                   PARM      *ZERO         W#NOML           15 0          * NOMINAL
     C                   PARM      *ZERO         W#SDAT            5 0
     C                   PARM      *ZERO         W#EDAT            5 0
      * Event dates & data
     C                   PARM                    #arevdt_ip
     C                   PARM                    #arevdt_ir
     C                   PARM                    #arevdt_mp
     C                   PARM                    #arevdt_pp
 
      * LAST/NEXT INTEREST PERIOD?
     C                   PARM                    #LNIPERIOD        1
      * Outputs
     C                   PARM      *ZERO         W#TINT           15 2          * INTEREST
     C                   PARM      *ZERO         W#TINTP          15 9          * INTEREST %
     C                   PARM      *ZERO         W#TINTF          15 9          * INTEREST FACTOR
 
     C     W#RTCD        IFEQ      '*ERROR'
     C                   EVAL      I#ERMS = 'ERROR IN INITCALL TO DECALINTM'
     C                   EXSR      *PSSR
     C                   END
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
     C     ZCNSD         BEGSR
     C                   CALLB     'ZCNSD'
     C                   PARM                    ZNOML            15 0
     C                   PARM                    ZPRC             16 9
     C                   PARM      I#SPBS        W#SPBS            1
     C                   PARM      I#NMDP        W#NMDP            1 0
     C                   PARM      I#NCDP        W#NCDP            1 0
     C                   PARM      *ZERO         ZCONS            15 0
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY DECPYSRC,DEPSSR
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2001
**  POWER8 - ARRAY OF POWERS FOR CURRENCY CONVERSION
00000001
00000010
00000100
00001000
00010000
00100000
01000000
10000000
