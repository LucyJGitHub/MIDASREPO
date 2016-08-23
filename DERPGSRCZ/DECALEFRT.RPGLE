     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas DE Calculate effective rate')
      *****************************************************************
      *                                                               *
      *  Midas - Data Export module                                   *
      *                                                               *
      *  DECALEFRT - Calculate Effective Rate                         *
      *                                                               *
      *  Function:  This module determine the effective rate and      *
      *             effective balance when an interest or fee         *
      *             calculation is performed on a balance on a tiered *
      *             or treshold method.                               *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      *  Last Amend No. CDE002  *CREATE    Date 05Dec00               *
      *  Prev Amend No.                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CDE002 - Data Export - CCRM Revenue Analysis.                *
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
 
      * Work amounts
     D WAMT            S                   LIKE(I#AM01) INZ(0)
     D WPFAM           S                   LIKE(I#AM01) INZ(0)
     D WAMT15          S                   LIKE(I#AM01) INZ(0)
     D @AMOUNT         S                   LIKE(I#AM01) INZ(0)
     D @TOTAL          S                   LIKE(I#AM01) INZ(0)
      *
      * Rates
     D RAT             S                   DIM(11) LIKE(I#RT01)
      * Balances
     D AMT             S                   DIM(12) LIKE(I#AM01) ASCEND
     D AMNT            S                   DIM(11) LIKE(I#AM01) ASCEND
     D X               S              2  0
     D Y               S              2  0
     D Z               S              2  0
      *
     C     *ENTRY        PLIST
      *
     C                   PARM                    I#RTCD            7            * RETURN CODE
     C                   PARM                    I#ERMS           30            * ERROR MESSAGE
     C                   PARM                    I#MODI            2            * ERROR MESSAGE
      * INPUTS
      * rates
     C                   PARM                    I#RT01           11 7          * RATE, TIER 1
     C                   PARM                    I#RT02           11 7          * RATE, TIER 2
     C                   PARM                    I#RT03           11 7          * RATE, TIER 3
     C                   PARM                    I#RT04           11 7          * RATE, TIER 4
     C                   PARM                    I#RT05           11 7          * RATE, TIER 5
     C                   PARM                    I#RT06           11 7          * RATE, TIER 1
     C                   PARM                    I#RT07           11 7          * RATE, TIER 2
     C                   PARM                    I#RT08           11 7          * RATE, TIER 3
     C                   PARM                    I#RT09           11 7          * RATE, TIER 4
     C                   PARM                    I#RT10           11 7          * RATE, TIER 5
     C                   PARM                    I#RT11           11 7          * RATE, TIER 5
      * balances
     C                   PARM                    I#AM01           15 0          * BALANCE, TIER 1
     C                   PARM                    I#AM02           15 0          * BALANCE, TIER 2
     C                   PARM                    I#AM03           15 0          * BALANCE, TIER 3
     C                   PARM                    I#AM04           15 0          * BALANCE, TIER 4
     C                   PARM                    I#AM05           15 0          * BALANCE, TIER 5
     C                   PARM                    I#AM06           15 0          * BALANCE, TIER 1
     C                   PARM                    I#AM07           15 0          * BALANCE, TIER 2
     C                   PARM                    I#AM08           15 0          * BALANCE, TIER 3
     C                   PARM                    I#AM09           15 0          * BALANCE, TIER 4
     C                   PARM                    I#AM10           15 0          * BALANCE, TIER 5
     C                   PARM                    I#AM11           15 0          * BALANCE, TIER 5
      * balance
     C                   PARM                    I#IBAL           15 0          * FACILITY AMOUNT
      * tiered/threshold indicator
     C                   PARM                    I#TIER            1 0          * FACILITY AMOUNT
      *
      * OUTPUTS
      * effective rate
      *
     C                   PARM                    O#EFRT           11 7          * FEE RATE
      *
      * effective balance
      *
     C                   PARM                    O#EFBL           15 0
      *
      **--------------------------------------------------------------------------------------------
      *
      ** Initialise rate and amount arrays
      *
     C                   Z-ADD     I#RT01        RAT(1)
     C                   Z-ADD     I#RT02        RAT(2)
     C                   Z-ADD     I#RT03        RAT(3)
     C                   Z-ADD     I#RT04        RAT(4)
     C                   Z-ADD     I#RT05        RAT(5)
     C                   Z-ADD     I#RT06        RAT(6)
     C                   Z-ADD     I#RT07        RAT(7)
     C                   Z-ADD     I#RT08        RAT(8)
     C                   Z-ADD     I#RT09        RAT(9)
     C                   Z-ADD     I#RT10        RAT(10)
     C                   Z-ADD     I#RT11        RAT(11)
     C                   Z-ADD     I#AM01        AMT(1)
     C                   Z-ADD     I#AM02        AMT(2)
     C                   Z-ADD     I#AM03        AMT(3)
     C                   Z-ADD     I#AM04        AMT(4)
     C                   Z-ADD     I#AM05        AMT(5)
     C                   Z-ADD     I#AM06        AMT(6)
     C                   Z-ADD     I#AM07        AMT(7)
     C                   Z-ADD     I#AM08        AMT(8)
     C                   Z-ADD     I#AM09        AMT(9)
     C                   Z-ADD     I#AM10        AMT(10)
     C                   Z-ADD     I#AM11        AMT(11)
     C                   Z-ADD     0             AMT(12)
      *
      ** Initialise output rate and balance
      *
     C                   Z-ADD     0             O#EFRT
     C                   Z-ADD     0             O#EFBL
      *
      ** Determine rate applicable against balance.
      ** N.B. 0 = threshold, 1 = tiered.
      *
     C                   Z-ADD     1             X
     C                   MOVE      '0'           *IN80
      *
      ** Search amount array to find value larger or equal.
      *
     C                   IF        I#TIER = 0
     C     I#IBAL        LOOKUP    AMT(X)                             80
      *
      ** If tier is found, set output rate and output balance
      *
     C     *IN80         IFEQ      '1'
     C                   EVAL      X = X - 1
      *
     C                   IF        X = 0
     C                   Z-ADD     1             X
     C                   ENDIF
      *
     C                   EVAL      O#EFRT = RAT(X)
     C                   EVAL      O#EFBL = I#IBAL
      *
     C                   ELSE
     C                   Z-ADD     1             X
      *
      * Get the index of the last tier balance not equal to zero
      *
     C                   DOW       AMT(X) <> 0   AND X <= 11
     C                   EVAL      X= X+1
     C                   ENDDO
      *
      * If tiered balance and rate is zero, get the index of the last
      * non-zero tier by subtracting one.
      *
     C                   IF        RAT(X) = *Zeros
     C                   EVAL      X = X - 1
     C                   IF        X = 0
     C                   Z-ADD     1             X
     C                   ENDIF
      *
      * If tiered balance iz zero but tiered rate is not, use this rate
      * and apply this to whole balance.
      *
     C                   ELSE
     C                   EVAL      AMT(X) = I#IBAL
     C                   ENDIF
      *
     C                   IF        I#MODI = 'LE'
     C                   EVAL      O#EFBL = AMT(X)
     C                   ELSE
     C                   EVAL      O#EFBL = I#IBAL
     C                   ENDIF
      *
     C                   EVAL      O#EFRT = RAT(X)
      *
     C                   ENDIF
      *
      ** If tiered
      *
     C                   ELSE
      *
      * Apportion input balance across the 11 balance tiers
      *
     C                   Z-ADD     1             X
     C                   Z-ADD     2             Z
     C                   Z-ADD     *Zeros        WPFAM
     C                   EVAL      @AMOUNT = *Zeros
     C                   EVAL      WAMT15  = *Zeros
     C                   EVAL      @TOTAL  = *Zeros
     C                   EVAL      WAMT = I#IBAL
      *
     C                   DOW       WAMT > *Zeros AND
     C                             X <= 11
      *
      * IF balance is less than the tier balance, OR tier balance
      * is zero and the module is 'RE' and there's remaining balance
      * left, THEN add this remaining balance to the last tier amount
      * and multiply this by its corresponding tier rate.  If the
      * module is 'LE', remaining balance is ignored.
      *
     C                   IF        I#IBAL < AMT(Z) OR
     C                             AMT(Z) = *Zeros
      *
     C                   IF        I#MODI = 'LE' and X = 1
     C                   EVAL      WAMT = WAMT - AMT(X)
     C                   IF        WAMT > 0
     C                   EVAL      WAMT15 = WAMT * RAT(X)
     C                   ELSE
     C                   EVAL      WAMT15 = 0
     C                   ENDIF
      *
     C                   ELSE
     C                   EVAL      WAMT15 = WAMT * RAT(X)
     C                   ENDIF
      *
     C                   IF        RAT(X) = *Zeros
     C                   IF        I#MODI = 'RE'
     C                   EVAL      Y = X - 1
     C                   IF        Y > 0
     C                   EVAL      WAMT15 = WAMT * RAT(Y)
     C                   ELSE
     C                   EVAL      WAMT15 = WAMT * 0
     C                   ENDIF
     C                   EVAL      @AMOUNT = @AMOUNT + WAMT
     C                   EVAL      AMT(X) = WAMT + WPFAM
     C                   ENDIF
      *
     C                   ELSE
     C                   EVAL      @AMOUNT = @AMOUNT + WAMT
     C                   EVAL      AMT(X) = WAMT + WPFAM
     C                   ENDIF
      *
     C                   ELSE
      *
     C                   IF        AMT(Z) <> *Zeros
     C                   EVAL      WAMT15 = (AMT(Z) - AMT(X)) * RAT(X)
     C                   EVAL      @AMOUNT = @AMOUNT + AMT(Z) - AMT(X)
     C                   ENDIF
     C                   ENDIF
      *
     C                   EVAL      @TOTAL = @TOTAL + WAMT15
     C                   EVAL      WAMT = I#IBAL - AMT(Z)
     C                   EVAL      WPFAM = AMT(X)
     C                   EVAL      X = X + 1
     C                   EVAL      Z = X + 1
     C                   EVAL      WAMT15  = *Zeros
     C                   ENDDO
      *
      * Output Rate and Output Balance
      *
     C                   IF        I#IBAL <> *Zeros
     C     @TOTAL        DIV(H)    I#IBAL        O#EFRT
     C                   EVAL      O#EFBL = @AMOUNT
     C                   ELSE
     C                   EVAL      O#EFRT = *Zeros
     C                   EVAL      O#EFBL = *Zeros
     C                   ENDIF
      *
     C                   ENDIF
     C                   RETURN
      *
      **************************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY DECPYSRC,DEPSSR
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
