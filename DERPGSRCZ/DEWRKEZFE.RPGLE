     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas DE Work with extract data - fee payment date')
      *****************************************************************
      *                                                               *
      *  Midas - Data Export module                                   *
      *                                                               *
      *  DEWRKEZFE - Work with Extract Data (Fee Payment)             *
      *                                                               *
      *  Component of: DEWRKEDTA                                      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSD027             Date 09Dec05               *
      *  Prev Amend No. CGL029             Date 01Sep03               *
      *                 CDE003             Date 11Dec02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CDE001  *CREATE    Date 23Nov99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
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
 
     D E#NCDP          S              1S 0
 
      ** E V E N T   S E T T L E M E N T    D E T A I L S
     D**E#SETD**       DS            20                                                       CGL029
     D  E#SETD         DS                                                                     CGL029
     D  E#SETM                 1      2
     D  E#SETA                 3     20                                                       CGL029
     D  E#SETB                21     23                                                       CGL029
     D  E#SETC                24     26                                                       CGL029
     D**E#SETA**               3     14                                                       CGL029
     D**E#SETB**              15     17                                                       CGL029
     D**E#SETC**              18     20                                                       CGL029
 
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
     C     E#TAMT        ANDNE     *ZERO
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
      * Set position fee
      * (The position fee is signed positive
      *  if it is incoming, negative if it is outgoing).
      *
     C     E#IO          IFEQ      'I'
     C                   Z-ADD     E#FEE         P#FEE
     C                   ELSE
     C                   Z-SUB     E#FEE         P#FEE
     C                   ENDIF
      *
      * Add charges and commissions to position
      * (The position charges and commissions are signed positive
      *  if they are incoming, negative if they are outgoing).
      *
     C     E#IO          IFEQ      'I'
     C                   ADD       E#CHRG        P#CHRG
     C                   ADD       E#COMM        P#COMM
     C                   ELSE
     C                   SUB       E#CHRG        P#CHRG
     C                   SUB       E#COMM        P#COMM
     C                   ENDIF
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      *********************************************************************
      * SET CASHFLOW FIELDS
      *********************************************************************
     C     SET_CASH      BEGSR
      * fee
     C                   MOVEL     'F'           C#CATG
     C                   MOVEL     E#SETC        C#CCY
     C                   MOVEL     E#NCDP        C#CDP
     C                   Z-ADD     E#TAMT        C#AMNT
      * in/out
     C                   MOVEL     E#IO          C#IO
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
      ** Fees
      ** Charges
      ** Commissions
      ** Total Amount
      ** Ccy Dec Places
      ** In/Out - I/O/blank
     C                   PARM                    E#FEE            15 0
     C                   PARM                    E#CHRG           15 0
     C                   PARM                    E#COMM           15 0
     C                   PARM                    E#TAMT           15 0
     C                   PARM                    E#NCDP            1 0
     C                   PARM                    E#IO              1
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
      ** Fee
      ** Charges
      ** Commissions
     C                   PARM                    P#FEE            15 0
     C                   PARM                    P#CHRG           15 0
     C                   PARM                    P#COMM           15 0
      ** Cashflow
     C                   PARM                    C#CASH
 
     C                   ENDSR
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY DECPYSRC,DEPSSR_WK
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
