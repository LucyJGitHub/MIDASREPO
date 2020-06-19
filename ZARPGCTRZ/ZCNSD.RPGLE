000100200529     H DEBUG
000200200529     H COPYRIGHT('(c) Finastra International Limited 2002')
000300200529      *****************************************************************
000400200529/*STD *  RPGBASEMOD                                                   *
000500200529/*EXI *  TEXT('Midas ZA: Calculate consideration')
000600200529      *****************************************************************
000700200529      *                                                               *
000800200529      *  Midas - Copy Source converted into ILE procedures            *
000900200529      *                                                               *
001000200529      *  ZCNSD   -   Calculate consideration                          *
001100200529      *                                                               *
001200200529      *  This module is an ILE/RPG IV conversion of the ZCNSD         *
001300200529      *  subroutine.  The subroutine consists of one /COPY member.    *
001400200529      *  Each of these has been converted to ILE RPG and copied into  *
001500200529      *  this member.  Necessary code to make this compileable has    *
001600200529      *  been added (entry and exit points and some declares).  The   *
001700200529      *  existing code has not been changed except to remove dead     *
001800200529      *  lines, and the boundaries of the original /COPY members have *
001900200529      *  been marked, to facilitate future maintenance of both the    *
002000200529      *  old members and this one.  If this member has to change, the *
002100200529      *  change should ALMOST CERTAINLY be implemented by changing    *
002200200529      *  the old /COPY member, reconverting it using CVTRPGSRC, and   *
002300200529      *  copying it into this member, replacing the existing section. *
002400200529      *                                                               *
002500200529      *  (c) Finastra International Limited 2001                      *
002600200529      *                                                               *
002700200529      *    This source is centrally supported and must ONLY be        *
002800200529      *    amended by Core Development Personnel                      *
002900200529      *                                                               *
003000200529      *    /COPY, Client or Country amendments must not be            *
003100200529      *    applied to this source.                                    *
003200200529      *                                                               *
003300200604      *  Last Amend No. 250223             Date 22May20               *
003400200529      *  Prev Amend No. MD046248           Date 27Oct17               *
003500200529      * Bank Fusion Midas 1.4 Base -----------------------------------*
003600200529      * Midas Plus 1.4 Base 04 ---------------------------------------*
003700200529      * Midas Plus 1.4 Base ------------------------------------------*
003800200529      * Midas Plus 1.3 ----------- Base ------------------------------*
003900200529      * Midas Release 4 --------------- Base -------------------------*
004000200529      * Midas DBA 3.00 ---------------- Base -------------------------*
004100200529      *                 CAP002  *CREATE    Date 21Apr98               *
004200200529      *                                    Date DDMmmYY               *
004300200529      *                                                               *
004400200529      *---------------------------------------------------------------*
004500200529      *                                                               *
004600200529      *  250023 - Redefine ZNOMLC as 24,9 for correct consideration   *
004700200529      *           computation.                                        *
004800200529      *  MD046248 - Finastra Rebranding                               *
004900200529      *  CAP002 - Conversion of Midas inputs to modular API structure *
005000200529      *                                                               *
005100200529      *****************************************************************
005200200529
005300200529      ** +-----------------------------------------------------------------+
005400200529      ** Declares for variables that were defined externally for the
005500200529      ** original copy members
005600200529      ** +-----------------------------------------------------------------+
005700200529
005800200529     D POWER8          S              8  4 DIM(8) CTDATA PERRCD(1)
005900200529
006000200529
006100200529      ** INPUTS **
006200200529
006300200529     **  Price basis
006400200529     D   SPBS          S              1A
006500200529     **  Nominal decimal places
006600200529     D   NMDP          S              1P 0
006700200529     **  Nominal currecy decimal places
006800200529     D   NomCcyDec     S              1P 0
006900200529
007000200529
007100200529      ** +-----------------------------------------------------------------+
007200200529
007300200529      ** Nominal currency decimal places
007400200529
007500200529     C                   Z-ADD     NomCcyDec     ZCDP
007600200529
007700200529      ** Execute the standard subroutine
007800200529     C                   EXSR      ZCNSD
007900200529
008000200529     C                   RETURN
008100200529      /EJECT
008200200529      ** +--- The converted ZCNSDZ1 starts here --------------------------+
008300200529      *****************************************************************
008400200529      *                                                               *
008500200529      *  ZCNSD - SUBROUTINE TO CALCULATE CONSIDERATION                *
008600200529      *                                                               *
008700200529      *  INPUT  - FROM TRADE FILE - ZPRC (16,9) TRADE PRICE           *   052254
008800200529      *                             ZNOML (11,0) NOMINAL              *
008900200529      *           FROM SECTYD     - SPBS (1) PRICE BASIS              *
009000200529      *                           - NMDP (1,0) NOMINAL DECIMAL PLACES *
009100200529      *           FROM CURRENCIES - ZCDP (1,0) CURRENCY DECIMAL PLACES*   S01117
009200200529      *           ARRAY           - POWER8                            *
009300200529      *                                                               *
009400200529      *  OUTPUT - ZCONS  (15,0) CONSIDERATION                         *
009500200529      *                                                               *
009600200529      *  CALLS - NONE                                                 *
009700200529      *                                                               *
009800200529      *****************************************************************
009900200529      *                                                               *
010000200529      *  LAST AMEND NO. 052254             DATE 07JAN94               *
010100200529      *  PREV AMEND NO. S01117             DATE 22JAN91               *
010200200529      *                 E20232             DATE 13DEC89               *
010300200529      *                                                               *
010400200529      *---------------------------------------------------------------*
010500200529      *                                                               *
010600200529      *  052254 - CURRENT FACTOR amended from 9,8 to 10,9. ZPRC       *
010700200529      *           increased to 16,9 to handle change.                 *
010800200529      *  S01117 - New SD file changes (Release 10 Multibranching).    *
010900200529      *  E20232 - This subroutine created for use in SE0050, SE0090   *   E20232
011000200529      *           and SE2220 to resolve high order truncation of field*   E20232
011100200529      *                                                               *
011200200529      *****************************************************************
011300200529      *
011400200529     C     ZCNSD         BEGSR                                                  **ZCNSD  BEGSR
011500200529     C*
011600200529     C* Define fields
011700200529     C*
011800200529     C                   Z-ADD     0             ZCONS            15 0
011900200529     C                   Z-ADD     ZNOML         ZNOML            15 0
012000200529     C**********         Z-ADD     0             ZNOMLC           15 0                        250023
012100200529     C                   Z-ADD     0             ZNOMLC           24 9                        250023
012200200529     C                   Z-ADD     ZPRC          ZPRC             16 9                         05225
012300200529     C                   Z-ADD     ZCDP          ZCDP              1 0                         S0111
012400200529     C                   Z-ADD     0             WDIF             15 0
012500200529     C*
012600200529     C*     Convert Nominal Dec places to Currency Dec. Places
012700200529     C*
012800200529     C     5             SUB       NMDP          DC                1 0
012900200529     C                   ADD       ZCDP          DC                                            S0111
013000200529     C*
013100200529     C     ZNOML         MULT(H)   POWER8(DC)    ZNOMLC
013200200529     C*
013300200529     C* Check for rounding errors
013400200529     C*
013500200529     C     ZNOMLC        DIV(H)    POWER8(DC)    WDIF
013600200529     C     ZNOML         SUB       WDIF          WDIF
013700200529     C     WDIF          MULT(H)   ZPRC          WDIF
013800200529     C     WDIF          MULT(H)   POWER8(DC)    WDIF
013900200529     C*
014000200529     C* Calculate consideration = face value(=nominal) x trade price
014100200529     C*
014200200529     C     ZNOMLC        MULT(H)   ZPRC          ZCONS
014300200529     C                   ADD       WDIF          ZCONS
014400200529     C*
014500200529     C*     If price basis is P, divide consideration by 100
014600200529     C*
014700200529     C     SPBS          IFEQ      'P'
014800200529     C     ZCONS         DIV(H)    100           ZCONS
014900200529     C                   END
015000200529     C*
015100200529     C     EZCNSD        ENDSR                                                  *** ENDSR    ***
015200200529     C*
015300200529     C*****************************************************************
015400200529      ** +--- The converted ZCNSDZ1 ends here ----------------------------+
015500200529
015600200529      /EJECT
015700200529      *****************************************************************
015800200529      *                                                               *
015900200529      * *INZSR - Program Initialisation routine                       *
016000200529      *                                                               *
016100200529      * Called by: Implicitly on program activation                   *
016200200529      *                                                               *
016300200529      * Calls: None                                                   *
016400200529      *                                                               *
016500200529      *****************************************************************
016600200529
016700200529     C     *INZSR        BEGSR
016800200529
016900200529     C     *entry        PLIST
017000200529
017100200529      * INPUTS
017200200529
017300200529      ** Nominal
017400200529      ** Price
017500200529      ** Price basis
017600200529      ** Nominal decimal places
017700200529      ** Nominal currecy decimal places
017800200529     C                   PARM                    ZNOML
017900200529     C                   PARM                    ZPRC
018000200529     C                   PARM                    SPBS
018100200529     C                   PARM                    NMDP
018200200529     C                   PARM                    NomCcyDec
018300200529
018400200529      * OUTPUTS
018500200529
018600200529      **  Consideration
018700200529     C                   PARM                    ZCONS
018800200529
018900200529     C                   ENDSR
019000200529      *****************************************************************
019100200529**  POWER8 - ARRAY OF POWERS FOR CURRENCY CONVERSION
01920020052900000001
01930020052900000010
01940020052900000100
01950020052900001000
01960020052900010000
01970020052900100000
01980020052901000000
01990020052910000000
