     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas DE Work with extract data - int payment date')
      *****************************************************************
      *                                                               *
      *  Midas - Data Export module                                   *
      *                                                               *
      *  DEWRKEZIP - Work with Extract Data (Interest Payment)        *
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
      *                 CDE002             Date 05Dec00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CDE001  *CREATE    Date 23Nov99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CDE003 - Data Export - MCR Limits Phase II (Recompiled)      *
      *  CDE002 - Data Export - CCRM Revenue Analysis.                *
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
     C     Int_Due       ANDNE     *ZERO
     C     E#INTC        ANDNE     'Y'
     C     P#INTC        ANDNE     'Y'
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
      * If interest is accrued & payable up-front on a yield/discount basis
      *    Set total interest = event interest amount (int.due at next date)
      *
     C     P#ACIN        IFEQ      'Y'
     C     P#INPM        IFEQ      'Y'
     C     P#INPM        OREQ      'D'
     C                   Z-ADD     E#INTA        P#TOTI
     C                   ENDIF
     C                   ENDIF
      *
      * If COF is accrued & payable up-front on a yield/discount basis
      *    Set total COF  = event COF amount (COF due at next date)
      *
     C     P#ACCF        IFEQ      'Y'
     C     P#INPM        IFEQ      'Y'
     C     P#INPM        OREQ      'D'
     C                   Z-ADD     E#COFA        P#TOTC
     C                   ENDIF
     C                   ENDIF
      *
      * If cash is accrued
      *    Set cash = event cash amount (cash due at next date)
      *
     C     P#ACCS        IFEQ      'Y'
     C                   Z-ADD     E#CASH        P#CASH
     C                   ENDIF
      *
      **   Update current principal if interest to be capitalized
      *
     C     E#INTC        IFEQ      'Y'
     C     P#INTC        OREQ      'Y'
     C                   ADD       Int_Due       P#NOML
     C                   ENDIF
      *
      *****If*not*first*up-front*interest*payment***************************    CDE002
      **   Update interest paid or interest capitalized to date
      **   Update COF paid or COF capitalized to date
      *
     C*****E#PRDT********IFNE******T#VDAT***********************************    CDE002
     C     E#INTC        IFEQ      'Y'
     C     P#INTC        OREQ      'Y'
     C                   ADD       Int_Due       P#ICTD
     C                   ELSE
     C                   ADD       Int_Due       P#IPRD
     C                   ENDIF
     C*******************ENDIF**********************************************    CDE002
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      *********************************************************************
      * SET CASHFLOW FIELDS
      *********************************************************************
     C     SET_CASH      BEGSR
 
      * interest
     C                   MOVEL     'I'           C#CATG
     C                   Z-ADD     Int_Due       C#AMNT
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
      ** Value Date
     C                   PARM                    T#VDAT            5 0
      ** Asset/Liability
      ** (Up front) Int Pay Method
      ** Int Capitalization Y/N
      ** Accrue Interest
      ** Accrue Cost of Funds
      ** Accrue Cash
     C                   PARM                    P#ASLI            1
     C                   PARM                    P#INPM            1
     C                   PARM                    P#INTC            1
     C                   PARM                    P#ACIN            1
     C                   PARM                    P#ACCF            1
     C                   PARM                    P#ACCS            1
      ** Processing Date
      ** Int Capitalization Ind
      ** Interest Amount
      ** Cost of Funds Amount
      ** Next Cash Date
      ** Next Cash Amount
     C                   PARM                    E#PRDT            5 0
     C                   PARM                    E#INTC            1
     C                   PARM                    E#INTA           15 0
     C                   PARM                    E#COFA           15 0
     C                   PARM                    E#NXCD            5 0
     C                   PARM                    E#CASH           15 0
      ** Suppress Settlement Y
      ** Settle Method
      ** Settle A/C
      ** Settle Branch
      ** Settle Currency
     C                   PARM                    E#SSET            1
     C**********         PARM                    E#SETD           20                          CGL029
     C                   PARM                    E#SETD                                       CGL029
      ** Interest Due
     C                   PARM                    Int_Due          15 0
      *
      * OUTPUTS
      ** Int Paid To Date
      ** Int Capitalized To Date
      ** Total Int
      ** Total COF
      ** Cash
      ** Nominal/Principal
     C                   PARM                    P#IPRD           15 0
     C                   PARM                    P#ICTD           15 0
     C                   PARM                    P#TOTI           15 0
     C                   PARM                    P#TOTC           15 0
     C                   PARM                    P#CASH           15 0
     C                   PARM                    P#NOML           15 0
      ** Cashflow
     C                   PARM                    C#CASH
 
     C                   ENDSR
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY DECPYSRC,DEPSSR_WK
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
