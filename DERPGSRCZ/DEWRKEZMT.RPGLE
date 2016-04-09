     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas DE Work with extract data - maturity')
      *****************************************************************
      *                                                               *
      *  Midas - Data Export module                                   *
      *                                                               *
      *  DEWRKEZMT - Work with Extract Data (Maturity)                *
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
     C     E#TAMT        IFNE      *ZERO
     C     P#NOML        ORNE      *ZERO
     C                   EXSR      SET_CASH
     C                   ENDIF
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
      * DEFINED NOMINAL AT MATURITY
      *
     C     E#NOML        IFNE      *ZERO
     C                   Z-ADD     E#NOML        P#NOML
     C                   ENDIF
      *
      ** Add charges and commissions to position
      *
     C                   ADD       E#CHRG        P#CHRG
     C                   ADD       E#COMM        P#COMM
 
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
     C                   Z-ADD     P#NOML        C#AMNT
     C                   ENDIF
      * in/out
     C     E#IO          IFEQ      *BLANK
     C     P#ASLI        IFEQ      'A'
     C                   MOVEL     'I'           C#IO
     C                   ELSE
     C                   MOVEL     'O'           C#IO
     C                   ENDIF
     C                   ELSE
     C                   MOVEL     E#IO          C#IO
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
      ** Nominal/Principal
     C                   PARM                    P#ASLI            1
     C                   PARM                    P#NOML           15 0
      ** Nominal
      ** Charges
      ** Commissions
      ** Total Amount
      ** In/Out - I/O/blank
     C                   PARM                    E#NOML           15 0
     C                   PARM                    E#CHRG           15 0
     C                   PARM                    E#COMM           15 0
     C                   PARM                    E#TAMT           15 0
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
      ** Charges
      ** Commissions
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
