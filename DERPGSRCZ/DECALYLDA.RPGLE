     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas DE Calculate yield for a number of days')
      *****************************************************************
      *                                                               *
      *  Midas - Data Export module                                   *
      *                                                               *
      *  DECALYLDA - Calculate Yield for a Number of Days             *
      *                                                               *
      *  Function:  This module calculates the yield on a given       *
      *             nominal based on the day and year basis and the   *
      *             yield rate provided.                              *
      *                                                               *
      *  Component of: DEWRKEDTA                                      *
      *                DEWRKEDTS                                      *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD027             Date 09Dec05               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CDE001  *CREATE    Date 16Dec99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
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
 
     D POWER8          S              8  4 DIM(8) CTDATA PERRCD(1)              POWER8 ARRAY
 
      *
      * INPUT PARAMETERS
      *
     C     *ENTRY        PLIST
     C                   PARM                    I#RTCD            7            * RETURN CODE
     C                   PARM                    I#ERMS           30            * ERROR MESSAGE
      * INPUTS
      * no of days, year basis
     C                   PARM                    I#NDYS            5 0          * NO. OF DAYS
     C                   PARM                    I#YBAS            5 0          * YEAR BASIS
      * nominal
     C                   PARM                    I#NOML           15 0          * NOMINAL
      * dec.places
     C                   PARM                    I#NCDP            1 0          * NOM. CCY DEC.P.
     C                   PARM                    I#NMDP            1 0          * NOM.DEC.PLCS
      * yield rate
     C                   PARM                    I#YRAT           11 7          * YIELD RATE
      * accuracy
     C                   PARM                    I#ACUR            1 0          * ACCURACY
      * OUTPUTS
      * interest, int as %
     C                   PARM                    O#INT            15 2          * INTEREST
     C                   PARM                    O#INTP           15 9          * INTEREST %
     C                   PARM                    O#INTF           15 9          * INTEREST FACTOR
      *
      * OUTGOING INTEREST AND INTEREST %
      *
     C                   Z-ADD     0             O#INT
     C                   Z-ADD     0             O#INTP
     C                   Z-ADD     0             O#INTF
      *
      * EARLY EXIT CONDITIONS
      *
     C                   EXSR      EARLYEXIT
      *
      * Determine index for conversion to Nominal Currency
      *
     C     I#NCDP        SUB       I#NMDP        W#D
     C     W#D           ADD       5             W#D               1 0
      *
      * Calculate Interest Amount
      *
      ** INTEREST = PRINCIPAL ( 1 - 1 / ( 1 + RATE X NUMBER OF DAYS/360))
      **     I.E. = PRINCIPAL ( 1 - 360 / ( 360 + RATE X NUMBER OF DAYS))
      *
     C     I#YBAS        MULT      100           W#050             5 0
      *
     C     I#NDYS        MULT      I#YRAT        W#157            15 7
     C                   ADD       W#050         W#157
      *
     C     W#157         IFNE      *ZERO
     C     W#050         DIV(H)    W#157         W#159            15 9
     C     1             SUB       W#159         W#159
     C     I#NOML        MULT(H)   W#159         W#309            30 9
     C     W#309         MULT(H)   POWER8(W#D)   O#INT
     C                   END
      *
      * Interest Percentage
      *
     C     O#INT         DIV(H)    I#NOML        O#INTP
     C                   DIV(H)    POWER8(W#D)   O#INTP
      *
      * Round interest percentage and amount to the number
      * of decimal places implied by the accuracy
      *
     C     I#ACUR        IFLT      9
     C                   EXSR      ROUND
     C                   END
      *
      * Interest Factor
      *
     C     I#YBAS        MULT      100           W#150            15 0
     C     I#NDYS        DIV(H)    W#150         O#INTF
      *
     C                   RETURN
      **********************************************************************
     C/SPACE 5
      **********************************************************************
     C     ROUND         BEGSR
      *
     C                   SELECT
     C     I#ACUR        WHENEQ    1
     C                   Z-ADD(H)  O#INTP        W#INP1           30 1
     C                   Z-ADD     W#INP1        O#INTP
     C     I#ACUR        WHENEQ    2
     C                   Z-ADD(H)  O#INTP        W#INP2           30 2
     C                   Z-ADD     W#INP2        O#INTP
     C     I#ACUR        WHENEQ    3
     C                   Z-ADD(H)  O#INTP        W#INP3           30 3
     C                   Z-ADD     W#INP3        O#INTP
     C     I#ACUR        WHENEQ    4
     C                   Z-ADD(H)  O#INTP        W#INP4           30 4
     C                   Z-ADD     W#INP4        O#INTP
     C     I#ACUR        WHENEQ    5
     C                   Z-ADD(H)  O#INTP        W#INP5           30 5
     C                   Z-ADD     W#INP5        O#INTP
     C     I#ACUR        WHENEQ    6
     C                   Z-ADD(H)  O#INTP        W#INP6           30 6
     C                   Z-ADD     W#INP6        O#INTP
     C     I#ACUR        WHENEQ    7
     C                   Z-ADD(H)  O#INTP        W#INP7           30 7
     C                   Z-ADD     W#INP7        O#INTP
     C     I#ACUR        WHENEQ    8
     C                   Z-ADD(H)  O#INTP        W#INP8           30 8
     C                   Z-ADD     W#INP8        O#INTP
     C                   ENDSL
      *
      * Now re-work interest
      *
     C     O#INTP        MULT      I#NOML        O#INT
     C                   MULT(H)   POWER8(W#D)   O#INT
      *
     C                   ENDSR
      **********************************************************************
     C/SPACE 5
      **********************************************************************
     C     EARLYEXIT     BEGSR
      *
      * RETURN IF NO NOMINAL, YIELD RATE, OR NO. OF DAYS
      *
     C     I#NOML        IFEQ      *ZERO
     C     I#YRAT        OREQ      *ZERO
     C     I#NDYS        OREQ      *ZERO
     C                   RETURN
     C                   END
      *
      * EXIT IN ERROR IF YEAR BASIS IS ZERO
      *
     C     I#YBAS        IFEQ      *ZERO
     C                   EVAL      I#ERMS = 'YEAR BASIS IS ZERO'
     C                   EXSR      *PSSR
     C                   END
      *
      * EXIT IN ERROR IF INVALID DECIMAL PLACES
      *
     C     I#NCDP        IFLT      0
     C     I#NCDP        ORGT      3
     C     I#NMDP        ORLT      0
     C     I#NMDP        ORGT      4
     C                   EVAL      I#ERMS = 'INVALID DECIMAL PLACES'
     C                   EXSR      *PSSR
     C                   END
      *
      * EXIT IN ERROR IF INVALID ACCURACY
      *
     C     I#ACUR        IFLE      0
     C                   EVAL      I#ERMS = 'INVALID ACCURACY'
     C                   EXSR      *PSSR
     C                   END
      *
     C                   ENDSR
      **********************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY DECPYSRC,DEPSSR
      *****************************************************************
      *
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
