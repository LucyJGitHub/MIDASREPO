     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas ZA: Calculate consideration')
      *****************************************************************
      *                                                               *
      *  Midas - Copy Source converted into ILE procedures            *
      *                                                               *
      *  ZCNSD   -   Calculate consideration                          *
      *                                                               *
      *  This module is an ILE/RPG IV conversion of the ZCNSD         *
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
      *  Last Amend No. 250223             Date 22May20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP002  *CREATE    Date 21Apr98               *
      *                                    Date DDMmmYY               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  250023 - Redefine ZNOMLC as 24,9 for correct consideration   *
      *           computation.                                        *
      *  MD046248 - Finastra Rebranding                               *
      *  CAP002 - Conversion of Midas inputs to modular API structure *
      *                                                               *
      *****************************************************************

      ** +-----------------------------------------------------------------+
      ** Declares for variables that were defined externally for the
      ** original copy members
      ** +-----------------------------------------------------------------+

     D POWER8          S              8  4 DIM(8) CTDATA PERRCD(1)


      ** INPUTS **

     **  Price basis
     D   SPBS          S              1A
     **  Nominal decimal places
     D   NMDP          S              1P 0
     **  Nominal currecy decimal places
     D   NomCcyDec     S              1P 0


      ** +-----------------------------------------------------------------+

      ** Nominal currency decimal places

     C                   Z-ADD     NomCcyDec     ZCDP

      ** Execute the standard subroutine
     C                   EXSR      ZCNSD

     C                   RETURN
      /EJECT
      ** +--- The converted ZCNSDZ1 starts here --------------------------+
      *****************************************************************
      *                                                               *
      *  ZCNSD - SUBROUTINE TO CALCULATE CONSIDERATION                *
      *                                                               *
      *  INPUT  - FROM TRADE FILE - ZPRC (16,9) TRADE PRICE           *   052254
      *                             ZNOML (11,0) NOMINAL              *
      *           FROM SECTYD     - SPBS (1) PRICE BASIS              *
      *                           - NMDP (1,0) NOMINAL DECIMAL PLACES *
      *           FROM CURRENCIES - ZCDP (1,0) CURRENCY DECIMAL PLACES*   S01117
      *           ARRAY           - POWER8                            *
      *                                                               *
      *  OUTPUT - ZCONS  (15,0) CONSIDERATION                         *
      *                                                               *
      *  CALLS - NONE                                                 *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  LAST AMEND NO. 052254             DATE 07JAN94               *
      *  PREV AMEND NO. S01117             DATE 22JAN91               *
      *                 E20232             DATE 13DEC89               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  052254 - CURRENT FACTOR amended from 9,8 to 10,9. ZPRC       *
      *           increased to 16,9 to handle change.                 *
      *  S01117 - New SD file changes (Release 10 Multibranching).    *
      *  E20232 - This subroutine created for use in SE0050, SE0090   *   E20232
      *           and SE2220 to resolve high order truncation of field*   E20232
      *                                                               *
      *****************************************************************
      *
     C     ZCNSD         BEGSR                                                  **ZCNSD  BEGSR
     C*
     C* Define fields
     C*
     C                   Z-ADD     0             ZCONS            15 0
     C                   Z-ADD     ZNOML         ZNOML            15 0
     C**********         Z-ADD     0             ZNOMLC           15 0                        250023
     C                   Z-ADD     0             ZNOMLC           24 9                        250023
     C                   Z-ADD     ZPRC          ZPRC             16 9                         05225
     C                   Z-ADD     ZCDP          ZCDP              1 0                         S0111
     C                   Z-ADD     0             WDIF             15 0
     C*
     C*     Convert Nominal Dec places to Currency Dec. Places
     C*
     C     5             SUB       NMDP          DC                1 0
     C                   ADD       ZCDP          DC                                            S0111
     C*
     C     ZNOML         MULT(H)   POWER8(DC)    ZNOMLC
     C*
     C* Check for rounding errors
     C*
     C     ZNOMLC        DIV(H)    POWER8(DC)    WDIF
     C     ZNOML         SUB       WDIF          WDIF
     C     WDIF          MULT(H)   ZPRC          WDIF
     C     WDIF          MULT(H)   POWER8(DC)    WDIF
     C*
     C* Calculate consideration = face value(=nominal) x trade price
     C*
     C     ZNOMLC        MULT(H)   ZPRC          ZCONS
     C                   ADD       WDIF          ZCONS
     C*
     C*     If price basis is P, divide consideration by 100
     C*
     C     SPBS          IFEQ      'P'
     C     ZCONS         DIV(H)    100           ZCONS
     C                   END
     C*
     C     EZCNSD        ENDSR                                                  *** ENDSR    ***
     C*
     C*****************************************************************
      ** +--- The converted ZCNSDZ1 ends here ----------------------------+

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

      ** Nominal
      ** Price
      ** Price basis
      ** Nominal decimal places
      ** Nominal currecy decimal places
     C                   PARM                    ZNOML
     C                   PARM                    ZPRC
     C                   PARM                    SPBS
     C                   PARM                    NMDP
     C                   PARM                    NomCcyDec

      * OUTPUTS

      **  Consideration
     C                   PARM                    ZCONS

     C                   ENDSR
      *****************************************************************
**  POWER8 - ARRAY OF POWERS FOR CURRENCY CONVERSION
00000001
00000010
00000100
00001000
00010000
00100000
01000000
10000000
