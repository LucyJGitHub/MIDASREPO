     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas DE Work with extract data - principal dec.')
      *****************************************************************
      *                                                               *
      *  Midas - Data Export module                                   *
      *                                                               *
      *  DEWRKEZPD - Work with Extract Data (Principal Decrease)      *
      *                                                               *
      *  Component of: DEWRKEDTA                                      *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD027             Date 09Dec05               *
      *                 CGL029             Date 01Sep03               *
      *                 CDE003             Date 11Dec02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CDE001  *CREATE    Date 23Nov99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CDE003 - Data Export - MCR Limits Phase II (Recompiled)      *
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
 
 
      ** E V E N T   S E T T L E M E N T    D E T A I L S
     D**E#SETD**       DS            20                                                       CGL029
     D  E#SETD         DS                                                                     CGL029
     D  E#SETM                 1      2
     D**E#SETA**               3     14                                                       CGL029
     D**E#SETB**              15     17                                                       CGL029
     D**E#SETC**              18     20                                                       CGL029
     D  E#SETA                 3     20                                                       CGL029
     D  E#SETB                21     23                                                       CGL029
     D  E#SETC                24     26                                                       CGL029
 
      ** C A S H F L O W    D E T A I L S
     D C#CASH        E DS                  EXTNAME(DEPCASHPD)
     D**C#SETD**              79     98                                                       CGL029
     D  C#SETD                85    110                                                       CGL029
 
 
      * Clear output cashflow
 
     C                   CLEAR                   C#CASH
 
      * Set Position Fields
 
     C                   EXSR      SET_POSN
 
      * Set Cashflow Fields
 
     C     E#SSET        IFNE      'Y'
     C                   EXSR      SET_CASH
     C                   ENDIF
 
      * Return to calling function
 
     C                   RETURN
 
      *****************************************************************
     C/SPACE 5
      ********************************************************************
      * SET POSITION FIELDS
      ********************************************************************
     C     SET_POSN      BEGSR
      *
      **  IF SALE OF A SECURITY
      *
     C     P#SECU        IFEQ      'Y'
     C     P#NOML        ANDNE     *ZERO
 
      **  LIQUIDATE PURCHASED INTEREST AND DISCOUNT/PREMIUM
 
     C     P#PINT        MULT      E#PRAM        pint_liq         30 0
     C                   DIV(H)    P#NOML        pint_liq
     C                   SUB       pint_liq      P#PINT
 
     C     P#DIPR        MULT      E#PRAM        dipr_liq         30 0
     C                   DIV(H)    P#NOML        dipr_liq
     C                   SUB       dipr_liq      P#DIPR
 
      ** CALCULATE REALIZED PROFIT/LOSS
 
     C     E#TAMT        SUB       pint_liq      trad_cost        15 0
     C     E#PRAM        SUB       trad_cost     trad_dipr        15 0
     C     dipr_liq      SUB       trad_dipr     P#RLPL
 
     C                   ENDIF
      *
      **  UPDATE CURRENT PRINCIPAL
      *
     C                   SUB       E#PRAM        P#NOML
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      *********************************************************************
      * SET CASHFLOW FIELDS
      *********************************************************************
     C     SET_CASH      BEGSR
 
      * countervalue
     C     E#TAMT        IFNE      *ZERO
     C                   MOVEL     'C'           C#CATG
     C                   Z-ADD     E#TAMT        C#AMNT
     C                   ELSE
      * principal
     C                   MOVEL     'P'           C#CATG
     C                   Z-ADD     E#PRAM        C#AMNT
     C                   ENDIF
      * in/out
     C     P#ASLI        IFEQ      'A'
     C                   MOVEL     'I'           C#IO
     C                   ELSE
     C                   MOVEL     'O'           C#IO
     C                   ENDIF
      * settlement instructions
     C                   MOVEL     E#SETD        C#SETD
 
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * *INZSR --- INITIAL PROCESSING
      ********************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    Ret_Code          7
     C                   PARM                    Err_Mess         30
      *
      * INPUTS
      ** Asset/Liability
      ** Security?
     C                   PARM                    P#ASLI            1
     C                   PARM                    P#SECU            1
      ** Principal Amount
      ** Total Amount
     C                   PARM                    E#PRAM           15 0
     C                   PARM                    E#TAMT           15 0
      ** Suppress Settlement Y
      ** Settle Method
      ** Settle A/C
      ** Settle Branch
      ** Settle Currency
     C                   PARM                    E#SSET            1
     C**********         PARM                    E#SETD           20                          CGL029
     C                   PARM                    E#SETD                                       CGL029
      *
      * OUTPUTS
      ** Discount/Premium
      ** Realized P/L
      ** Nominal/Principal
      ** Purchased Interest
     C                   PARM                    P#DIPR           15 0
     C                   PARM                    P#RLPL           15 0
     C                   PARM                    P#NOML           15 0
     C                   PARM                    P#PINT           15 0
      ** Cashflow
     C                   PARM                    C#CASH
 
     C                   ENDSR
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY DECPYSRC,DEPSSR_WK
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
