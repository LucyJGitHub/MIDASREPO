     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas ZA Calculate Countervalue of Trades')
      *****************************************************************
      *                                                               *
      *  Midas - Copy Source converted into ILE procedures            *
      *                                                               *
      *  ZCOTR   -   Calculate Countervalue of Trades                 *
      *                                                               *
      *  This module is an ILE/RPG IV conversion of the ZCOTR         *
      *  subroutine.  The subroutine consists of one /COPY member.    *
      *  Each of these has been converted to ILE RPG and copied into  *
      *  this member.  Necessary code to make this compileable has    *
      *  been added (entry and exit points and some declares).  The   *
      *  existing code has not been changed except to remove dead     *
      *  lines, and the boundaries of the original /COPY members have *
      *  been marked, to facilitate future maintenance of both the    *
      *  old members and this one.  If this member has to change, the *
      *  change should ALMOST CERTAINLY be implemented by changing    *
      *  the old /COPY member, reconverting it using CVTRPGSRC, and   *
      *  copying it into this member, replacing the existing section. *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. 260909             Date 04Apr19               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Prev Amend No. 246535             Date 20Mar07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. BUG9883            Date 19Jan06               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP003  *CREATE    Date 21Apr98               *
      *                                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *  260909 - Security Trade calculates wrong consideration on MBS*
      *         - Applied for MD-51447                                *
      *  MD046248 - Finastra Rebranding                               *
      *  246535 - Incorrect calculation of consideration for securi-  *
      *           ties using processing type 8.                       *
      *  BUG9883- Reallowance not being set up correctly              *
      *  CAP003 - Conversion of Midas inputs to modular API structure *
      *                                                               *
      *****************************************************************

      ** +-----------------------------------------------------------------+
      ** Declares for variables that were defined externally for the
      ** original copy members
      ** +-----------------------------------------------------------------+

      ** +--- The converted ZPOWER8Z1 starts here -------------------------+
     D POWER8          S              8  4 DIM(8) CTDATA PERRCD(1)              POWER8 ARRAY
      ** +--- The converted ZPOWER8Z1 ends here ---------------------------+

      ** +-----------------------------------------------------------------+

      ** Execute the standard subroutine
     C                   EXSR      ZCOTR

     C                   RETURN
      /EJECT

      ** +--- The converted ZCOTRZ1 starts here --------------------------+

     C**********************************************************************
     C*
     C*  ZCOTR - SUBROUTINE TO CALCULATE COUNTERVALUE OF TRADES
     C*
     C*  INPUT  - FROM TRADE FILE - PRIC (15,8) TRADE PRICE
     C*                             NOML (11,0) NOMINAL
     C*                             RALL (9,5)  REALLOWANCE
     C*                             ITRA (13,0) INTEREST AMOUNT
     C*                             TCA1,TCA2,TCA3,TCA4,TCA5,TCA6         S01176
     C*                             TCA7,TAXA (13,0) CHARGES              S01176
     C*                             TBCA,TCCA (13,0) COMMISSIONS
     C*                             TDTP (2) TRADE TYPE
     C*           FROM ZCONS      - CONSIDERATION (15,0)
     C*           FROM INVTPD     - PROT (1) PROCESSING TYPE OF SECURITY
     C*           FROM SECTYD     - SPBS (1) PRICE BASIS
     C*                           - NMCY (3) NOMINAL CURRENCY
     C*                           - NMDP (1,0) NOMINAL DECIMAL PLACES
     C*                           - CFCT (9,8) CURRENT FACTOR             S01117
     C*           FROM CURRENCIES - ZCDP                                  S01117
     C*           ARRAY           - POWER8
     C*
     C*  OUTPUT - ZCTRVL (15,0) COUNTERVALUE
     C*
     C*  CALLS - ZCNSD
     C*
     C*
     C*  INDICATORS USED  - 90 NOMINAL CURRENCY HAS 0 DECIMAL PLACES
     C*                     91 NOMINAL CURRENCY HAS 1 DECIMAL PLACE
     C*                     92 NOMINAL CURRENCY HAS 2 DECIMAL PLACES
     C*                     93 NOMINAL CURRENCY HAS 3 DECIMAL PLACES
     C*                     99 NOMINAL CURRENCY NOT ON FILE
     C*                                                                  *
     C********************************************************************
     C**                                                                 *
     C** LAST AMEND NO. 055420             DATE 24NOV93                  *
     C** PREV AMEND NO. S01117             DATE 07JAN91                  *
     C**                E21099             DATE 14FEB90                  *
     C**                E20232             DATE 13DEC89                  *
     C**                                                                 *
     C**-----------------------------------------------------------------*
     C**                                                                 *
     C** 055420 - COUNTERVALUE SHOULD BE HALF-ADJUSTED.                  *
     C** S01117 - SD file changes (multibranching)                       *
     C** E21099 - Should use CFCT for Current FActor and not TCFC.       *E21099
     C** E20232 - This subroutine created for use in SE0050 and SE0090   *E20232
     C**          to resolve high order truncation of fields.            *E20232
     C**                                                                 *
     C**=================================================================*
     C*
     C     ZCOTR         BEGSR                                                  **ZCOTR  BEGSR
     C*
     C* Define fields
     C*
     C                   Z-ADD     0             ZCTRVL           15 0
     C                   Z-ADD     0             ZCCTOT           15 2
     C                   Z-ADD     0             ZRALL            15 0
     C                   Z-ADD     0             ZRALL0           15 0
     C                   Z-ADD     0             ZRALL1           15 1
     C                   Z-ADD     0             ZRALL2           15 2
     C                   Z-ADD     0             ZRALL3           15 3
     C**************     Z-ADD     ZWRALL        ZWRALL           15 8                       BUG9883
     C                   Z-ADD     RALL          ZWRALL           15 8                       BUG9883
     C*
     C* Set indicator for number of decimal places
     C*
     C                   MOVEA     '0000'        *IN(90)
     C     90            ADD       ZCDP          V                 2 0                         S0111
     C                   MOVEA     '1'           *IN(V)
     C*
     C*    Calculate the reallowance amount -
     C*        = reallowance x face value (=nominal)
     C*    If price basis is P divide reallowance amount by 100
     C*
     C   90ZWRALL        MULT(H)   NOML          ZRALL0
     C   91ZWRALL        MULT(H)   NOML          ZRALL1
     C   92ZWRALL        MULT(H)   NOML          ZRALL2
     C   93ZWRALL        MULT(H)   NOML          ZRALL3
     C*
     C     SPBS          IFEQ      'P'
     C   90ZRALL0        DIV(H)    100           ZRALL0
     C   91ZRALL1        DIV(H)    100           ZRALL1
     C   92ZRALL2        DIV(H)    100           ZRALL2
     C   93ZRALL3        DIV(H)    100           ZRALL3
     C                   END
     C*
     C   90              MOVE      ZRALL0        ZRALL
     C   91              MOVE      ZRALL1        ZRALL
     C   92              MOVE      ZRALL2        ZRALL
     C   93              MOVE      ZRALL3        ZRALL
     C*
     C*  ALLOW FOR NOMINAL DECIMAL PLACES
     C*
     C     5             SUB       NMDP          DC                1 0
     C     ZRALL         MULT      POWER8(DC)    ZRALL
     C*
     C*  Calculate consideration
     C*
     C                   Z-ADD     PRIC          ZPRC
     C                   Z-ADD     NOML          ZNOML
     C                   EXSR      ZCNSD
     C*
     C* Calculate total charge/commission -
     C*    add the two commission amounts
     C*    add the five charge amounts to the contract price total
     C*
     C                   ADD       TBCA          ZCCTOT
     C                   ADD       TCCA          ZCCTOT
     C                   ADD       TCA1          ZCCTOT
     C                   ADD       TCA2          ZCCTOT
     C                   ADD       TCA3          ZCCTOT
     C                   ADD       TCA4          ZCCTOT
     C                   ADD       TCA5          ZCCTOT
     C                   ADD       TCA6          ZCCTOT
     C                   ADD       TCA7          ZCCTOT
     C                   ADD       TAXA          ZCCTOT
     C*
     C*  Countervalue = Consideration + Reallowance amount +
     C*         Total c/c payable + Purchased interest.                e
     C*
     C     PROT          IFEQ      '8'
     C     ZCONS         MULT(H)   CFCT          ZCTRVL                                        05542
     C*****ZCONS*****    MULT(H)   CFCT          ZCONS                                 246535 260909
     C                   ELSE
     C                   Z-ADD     ZCONS         ZCTRVL
     C                   END
     C*
     C                   ADD       ZRALL         ZCTRVL
     C                   ADD       ZCCTOT        ZCTRVL
     C                   ADD       ITRA          ZCTRVL
     C*
     C     EZCOTR        ENDSR                                                  *** ENDSR    ***
     C*
     C*****************************************************************

      ** +--- The converted ZCOTRZ1 ends here ----------------------------+
      /EJECT
      **********************************************************************
      *                                                                    *
      *  This subroutine is to cater for the fact that standard subroutine *
      *   ZCOTR in this module executes another standard subroutine,       *
      *   ZCNSD, which has also been converted to a module.                *
      *  This subroutine is also called ZCNSD and simply does a CALLB to   *
      *   the module that contains subroutine ZCNSD                        *
      *                                                                    *
      **********************************************************************
     C     ZCNSD         BEGSR

     C                   CALLB     'ZCNSD'
     C                   PARM                    ZNOML            15 0
     C                   PARM                    ZPRC             16 9
     C                   PARM                    SPBS
     C                   PARM                    NMDP
     C                   PARM                    ZCDP
     C                   PARM      *ZERO         ZCONS            15 0

     C                   ENDSR
      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     *INZSR        BEGSR

     C     *entry        PLIST

      * INPUTS


      ** Trade details
     C                   PARM                    NOML             11 0
     C                   PARM                    PRIC             15 8
     C                   PARM                    RALL              9 5
     C                   PARM                    ITRA             13 0
     C                   PARM                    TBCA             13 0
     C                   PARM                    TCCA             13 0
     C                   PARM                    TCA1             13 0
     C                   PARM                    TCA2             13 0
     C                   PARM                    TCA3             13 0
     C                   PARM                    TCA4             13 0
     C                   PARM                    TCA5             13 0
     C                   PARM                    TCA6             13 0
     C                   PARM                    TCA7             13 0
     C                   PARM                    TAXA             13 0

      ** Security details
     C                   PARM                    PROT              1
     C                   PARM                    SPBS              1
     C                   PARM                    CFCT             10 9
     C                   PARM                    NMCY              3
     C                   PARM                    NMDP              1 0
     C                   PARM                    ZCDP              1 0

      * OUTPUTS

      * CONSIDERATION CALCULATED
      * COUNTERVALUE CALCULATED
     C                   PARM                    ZCONS            15 0
     C                   PARM                    ZCTRVL           15 0

     C                   ENDSR
      *****************************************************************
      ** +--- The converted ZPOWER8Z2 starts here -------------------------+
**  POWER8 - ARRAY OF POWERS FOR CURRENCY CONVERSION
00000001
00000010
00000100
00001000
00010000
00100000
01000000
10000000
