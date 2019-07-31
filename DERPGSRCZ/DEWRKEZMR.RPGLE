     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas DE Work with extract data - manual repayment')
      *****************************************************************
      *                                                               *
      *  Midas - Data Export module                                   *
      *                                                               *
      *  DEWRKEZMR - Work with Extract Data (Manual Repayment)        *
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
     D P_C#CASH      E DS                  EXTNAME(DEPCASHPD)
     D                                     PREFIX(P_)
     D**P_C#SETD              79     98                                                       CGL029
     D  P_C#SETD              85    110                                                       CGL029
     D I_C#CASH      E DS                  EXTNAME(DEPCASHPD)
     D                                     PREFIX(I_)
     D**I_C#SETD              79     98                                                       CGL029
     D  I_C#SETD              85    110                                                       CGL029
 
 
      * Clear output cashflows
 
     C                   CLEAR                   P_C#CASH
     C                   CLEAR                   I_C#CASH
 
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
      **   UPDATE CURRENT PRINCIPAL WITH PRINCIPAL REPAID
      *
     C                   SUB       E#PRAM        P#NOML
      *
      **   UPDATE INTEREST PAID TO DATE WITH INTEREST REPAID
      *
     C                   ADD       E#INTA        P#IPRD
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      *********************************************************************
      * SET CASHFLOW FIELDS
      *********************************************************************
     C     SET_CASH      BEGSR
 
      * PRINCIPAL REPAID
 
     C     E#PRAM        IFNE      *ZERO
      * principal
     C                   MOVEL     'P'           P_C#CATG
     C                   Z-ADD     E#PRAM        P_C#AMNT
      * in/out
     C     P#ASLI        IFEQ      'A'
     C                   MOVEL     'I'           P_C#IO
     C                   ELSE
     C                   MOVEL     'O'           P_C#IO
     C                   ENDIF
      * settlement instructions
     C                   MOVEL     E#SETD        P_C#SETD
      *
     C                   ENDIF
 
      * INTEREST REPAID
 
     C     E#INTA        IFNE      *ZERO
      * interest
     C                   MOVEL     'I'           I_C#CATG
     C                   Z-ADD     E#INTA        I_C#AMNT
      * in/out
     C     P#ASLI        IFEQ      'A'
     C                   MOVEL     'I'           I_C#IO
     C                   ELSE
     C                   MOVEL     'O'           I_C#IO
     C                   ENDIF
      * settlement instructions
     C                   MOVEL     E#SETD        I_C#SETD
      *
     C                   ENDIF
 
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
     C                   PARM                    P#ASLI            1
      ** Principal Amount
      ** Interest Amount
      ** Total Amount
     C                   PARM                    E#PRAM           15 0
     C                   PARM                    E#INTA           15 0
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
      ** Int Paid To Date
      ** Nominal/Principal
     C                   PARM                    P#IPRD           15 0
     C                   PARM                    P#NOML           15 0
      ** Cashflows
     C                   PARM                    P_C#CASH
     C                   PARM                    I_C#CASH
 
     C                   ENDSR
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY DECPYSRC,DEPSSR_WK
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
