     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas ZS Cvt amount fm one ccy to another MODULE')
      *****************************************************************
      *  Midas/TI Interface                                           *
      *                                                               *
      *   Module ZCONVZ1 - Convert an Amount from one currency to     *
      *                       another                                 *
      *                                                               *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *  Prev Amend No. CTI001             Date 25Nov97               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CTI001 - Midas/TI Interface (Phase 1)                        *
      *                                                               *
      ****************************************************************
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
     D*
     D***********    The converted ZPOWERZ1 starts here  *************
     D POWER           S              7  3 DIM(7) CTDATA PERRCD(1)              POWER ARRAY
     D*
     D***********    The converted ZPOWERZ1 ends here  *************
     C*
     C     *ENTRY        PLIST
     C     ZAMTCI        PARM                    InputAmnt        15 0
     C     ZEXCH         PARM                    ExchRate         13 8
     C     ZMD           PARM                    MultDivInd        1
     C     ZCCYI         PARM                    FrCurrency        3
     C     ZCCYO         PARM                    ToCurrency        3
     C     ZCDPI         PARM                    FrDecPlace        1 0
     C     ZCDPO         PARM                    ToDecPlace        1 0
     C                   PARM      ZAMTCO        OutputAmnt       15 0
     C*
     C                   EXSR      ZCONV
     C*
     C                   RETURN
     C*
     C***********    The converted ZCONVZ1 starts here  *************
     C**********************************************************************
     C**
     C**   ZCONV - SUBROUTINE TO CONVERT AN  AMOUNT FROM ONE CURRENCY
     C**               TO ANOTHER
     C**
     C**   INPUT  - ZAMTCI (15,0) AMOUNT INPUT
     C**            ZEXCH  (13,8) EXCHANGE RATE
     C**            ZMD    (1)    MULTIPLY/DIVIDE INDICATOR
     C**            ZCCYI  (3)    CURRENCY INPUT
     C**            ZCCYO  (3)    CURRENCY TO BE CONVERTED TO
     C**            POWER   -     COMPILE TIME ARRAY MUST BE INCLUDED
     C**                          IN THE PROGRAM SOURCE
     C**            ZCDPI  (1,0)  (FROM) CURRENCY DECIMAL PLACES          S01117
     C**            ZCDPO  (1,0)  (TO) CURRENCY DECIMAL PLACES            S01117
     C**
     C**  OUTPUT -  ZAMTCO (15,0) AMOUNT OUTPUT
     C**
     C**  CALLS  -  NONE
     C**
     C**  USES *IN90
     C**
     C********************************************************************
     C**                                                                 *
     C** LAST AMEND NO. S01117             DATE 07JAN91                  *
     C**                                                                 *
     C**-----------------------------------------------------------------*
     C**                                                                 *
     C** S01117 - SD file changes (multibranching)                       *
     C**                                                                 *
     C**********************************************************************
     C*
     C     ZCONV         BEGSR                                                  ** ZCONV **
     C*
     C* DEFINE INPUT AND OUTPUT FIELDS
     C*
     C                   MOVE      ZCCYI         ZCCYI             3
     C                   MOVE      ZCCYO         ZCCYO             3
     C                   Z-ADD     ZCDPI         ZCDPI             1 0                         S0111
     C                   Z-ADD     ZCDPO         ZCDPO             1 0                         S0111
     C                   Z-ADD     ZAMTCI        ZAMTCI           15 0
     C                   Z-ADD     0             ZAMTCO           15 0
     C                   Z-ADD     ZEXCH         ZEXCH            13 8
     C                   MOVE      ZMD           ZMD               1
     C*
     C* IF EXCHANGE RATE IS 0 - OUTPUT CURRENCY AMOUNT AS ZERO
     C*
     C     ZEXCH         IFEQ      0
     C                   Z-ADD     0             ZAMTCO
     C                   GOTO      EZCONV
     C                   END
     C*
     C* IF DECIMAL PLACES ARE THE SAME FOR BOTH CURRENCIES
     C*
     C     ZCDPI         IFEQ      ZCDPO                                                       S0111
     C*
     C***  CALCULATE OUTPUT CURRENCY AMOUNT BY DIVIDING EXCHANGE RATE INTO
     C*** OR MULTIPLYING EXCHANGE RATE BY CURRENCY AMOUNT INPUT DEPENDING
     C*** ON INDICATOR
     C*
     C     ZMD           IFEQ      'D'
     C     ZAMTCI        DIV(H)    ZEXCH         ZAMTCO
     C                   ELSE
     C     ZAMTCI        MULT(H)   ZEXCH         ZAMTCO
     C                   END
     C*
     C                   ELSE
     C*
     C*** IF DECIMAL PLACES DIFFER -
     C***      CALCULATE DIFFERENCE IN DECIMAL PLACES TO USE AS POWER INDEX
     C*
     C     ZCDPO         SUB       ZCDPI         ZPX               1 0                         S0111
     C                   ADD       4             ZPX
     C*
     C*** CALCULATE CURRENCY AMOUNT OUTPUT BY MULTIPLYING INPUT AMOUNT BY
     C***  POWER ARRAY ENTRY AND THEN MULTIPLYING RESULT BY EXCHANGE RATE
     C***  DEPENDING ON INDICATOR
     C*
     C     POWER(ZPX)    IFLT      1                                            from d.p *LT
     C     ZAMTCI        MULT      POWER(ZPX)    Z15#3            15 3           to d.p.
      *
     C     ZMD           IFEQ      'D'
     C     Z15#3         DIV(H)    ZEXCH         ZAMTCO
     C                   ELSE
     C     Z15#3         MULT(H)   ZEXCH         ZAMTCO
     C                   END
      *
     C                   ELSE                                                   from d.p. *GT
     C     ZAMTCI        MULT      POWER(ZPX)    ZAMTCI                           to d.p.
      *
     C     ZMD           IFEQ      'D'
     C     ZAMTCI        DIV(H)    ZEXCH         ZAMTCO
     C                   ELSE
     C     ZAMTCI        MULT(H)   ZEXCH         ZAMTCO
     C                   END
     C*
     C                   END
      *
     C*
     C                   END
     C*
     C     EZCONV        ENDSR                                                  ** EZCONV **
     C*
     C*****************************************************************
     C***********    The converted ZCONVZ1 ends here  *************
     C*
**  CPY@
(c) Finastra International Limited 2001
**  POWER - ARRAY OF POWERS FOR CURRENCY CONVERSION
0000001
0000010
0000100
0001000
0010000
0100000
1000000
