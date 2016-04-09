     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas ZA Calculate long term CD price from yield')     *
      *****************************************************************
      *                                                               *
      *  Midas - Copy Source converted into ILE procedures            *
      *                                                               *
      *  ZCALCD  -   Calculate long term CD price from yield          *
      *                                                               *
      *  This module is an ILE/RPG IV conversion of the ZCALCD        *
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
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. CRE073             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. BUG11193           Date 02Apr06               *
      *                 BUG11009           Date 30Mar06               *
      *                 CSD027             Date 09Dec05               *
      *                 CSE075             Date 17Nov05               *
      *                 CSE071             Date 19Jul05               *
      *                 CAS006             Date 21Jan03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CSE031             Date 24Apr02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CSD006             Date 11Oct00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CSE005             Date 20Jun00               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 149162             Date 07Dec98               *
      *                 CAP002  *CREATE    Date 21Apr98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  BUG11193 - Purchased Interest not calculated on BackValued   *
      *             Trade. (Recompile)                                *
      *  BUG11009 - Wrong calculation of purchased interest.          *
      *             Applied fix 231841.                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSE075 - US Enhanced Treasury Upgrade to MidasPlus           *
      *           (Recompile)                                         *
      *  CSE071 - Multiple Holidays Re Securities                     *
      *  CAS006 - Hedge Accounting Phase B (Recompile)                *
      *  CSE031 - Field NCD on SECTYD already used in program.        *
      *  CSD006 - Recompiled over changed SECTYD.                     *
      *  CSE005 - Added  3 more Parameters  when calling  ZLCD  module*
      *           which were introduced in it  by this  amendment .   *
      *  149162 - Int. calc. incorrect at end of Feb for 30 day method*
      *           (core fix 102506 changes ZDAYS and ZDYYR)           *
      *  CAP002 - Conversion of Midas inputs to modular API structure *
      *                                                               *
      *****************************************************************
 
      ** +-----------------------------------------------------------------+
      ** Declares for variables that were defined externally for the
      ** original copy members
      ** +-----------------------------------------------------------------+
 
      ** Security Details
     D SECTY         E DS                  EXTNAME(SECTYD)
     D CDArr                 183    230
     D CRArr                 231    242
 
 
      ** Input fields
 
     D ZNOML           S             15P 0
     D ZPNPL           S             15P 0
     D ZCONS           S             15P 0
     D ZFDATE          S              5P 0
     D ZPRCIN          S             15P 8
     D CUMEXF          S              1A
     D PURINT          S             15P 9
 
     D  DADJN          S              1A
     D  NomCcyDec      S              1P 0
     D  PROT           S              1A
 
     D  BJDFIN         S              1A
 
      ** Output  field
 
     D PRICEC          S             15P 9
 
      ** Working Variables
 
     D ZZLCD           S              5P 0
     D*NCD***********  S              5P 0                                                    CSE031
     D ZNCD            S              5P 0                                                    CSE031
     D ZAMT            S             15P 0
     D ZDCSDT          S              5P 0
     D ZDCEDT          S              5P 0
     D ZDCINT          S             13P 0
     D ZDXINT          S             15P 1
     D ZDDAYS          S              5P 0
     D ZECD            S              5P 0
     D ZSDATE          S              5P 0
     D ZEDATE          S              5P 0
     D ZINTDD          S              5P 0
     D LCDD5           S              5P 0
 
 
      ** +-----------------------------------------------------------------+
 
 
      ** Execute the standard subroutine
     C                   EXSR      ZCALCD
 
     C                   RETURN
      /EJECT
      ** +--- The converted ZCALCD starts here --------------------------+
 
     C********************************************************************
     C**                                                                 *
     C** ZCALCD SR. TO CALCULATE LONG TERM CD PRICE FROM INPUT YIELD     *
     C**                                                                 *
     C** LAST AMEND NO. E39495             DATE 02NOV92                  *
     C**                                                                 *
     C**-----------------------------------------------------------------*
     C**                                                                 *
     C** E39495 - New subroutine to calculate Long term CD price from    *
     C**          input yield (previously done in PL1 program zyield)    *
     C**                                                                 *
     C********************************************************************
     C**
     C** Inputs     - ZNOML  = nominal
     C**              ZPNPL  = current principal      (calculated in ZYLD)
     C**              ZCONS  = face value at maturity (calculated in ZYLD)
     C**              CUMEXF = CUM or EX coupon  (set from SCUMEX in ZYLD)
     C**              PURINT = purchased interest     (calculated in ZYLD)
     C**              ZFDATE = date at which yield is effective
     C**              ZPRCIN = yield to be converted to % price
     C**
     C**  Output    - PRICEC = % price
     C**
     C**  Calls     - ZDAYS
     C**              ZLCD
     C**              ZACCZ
     C**
     C     ZCALCD        BEGSR                                                  *** ZCALCD ***
     C*
     C**  Define parameter
     C*
     C                   Z-ADD     ZPRCIN        ZPRCIN           15 8
     C*
     C**  Set output price to 100 %
     C*
     C                   Z-ADD     100           PRICEC
     C*
     C**  If nominal is zero, then end
     C*
     C     ZNOML         CABEQ     *ZERO         ZECALC
     C*
     C**  If value date at, or after, maturity, then end
     C*
     C     ZFDATE        CABGE     MATY          ZECALC
     C*
     C**  If value date at, or before, initial date, then end
     C*
     C     ZFDATE        CABLE     ITLD          ZECALC
     C*
     C**  Set final coupon date equal to maturity date
     C*
     C*****              Z-ADD     MATY          NCD                                          CSE031
     C                   Z-ADD     MATY          ZNCD                                         CSE031
     C*
     C**  Do while the next coupon date is greater than the value date
     C*
     C*****NCD           DOWGT     ZFDATE                                                     CSE031
     C     ZNCD          DOWGT     ZFDATE                                                     CSE031
     C*
     C**  Calculate previous coupon date to latest next coupon date
     C**  (ZZLCD)
     C*
     C*****NCD           SUB       1             ZECD                                         CSE031
     C     ZNCD          SUB       1             ZECD                                         CSE031
     C                   EXSR      ZLCD
     C*
     C**  Set up start and end dates of interest calculation
     C*
     C                   Z-ADD     ZZLCD         ZDCSDT
     C*****              Z-ADD     NCD           ZDCEDT                                       CSE031
     C                   Z-ADD     ZNCD          ZDCEDT                                       CSE031
     C*
     C**  Nominal used in interest calculation
     C*
     C                   Z-ADD     ZNOML         ZAMT
     C*
     C**  Calculate interest (& no. of days  & no. of days in a yr)
     C*
     C                   EXSR      ZACCZ
     C*
     C**  Add calculated interest to principal
     C*
     C                   ADD       ZDCINT        ZPNPL
     C*
     C**  If the previous coupon date is less than the value date
     C*
     C     ZZLCD         IFLT      ZFDATE
     C*
     C**  Calculate no. of days from value date to next coupon date
     C**  (ZDDAYS)
     C*
     C                   Z-ADD     ZFDATE        ZSDATE
     C*****              Z-ADD     NCD           ZEDATE                                       CSE031
     C                   Z-ADD     ZNCD          ZEDATE                                       CSE031
     C                   EXSR      ZDAYS
     C                   END
     C*
     C**  Discount factor = 1 + (No. of Days X Yield)/N0. of Days in Yr
     C**  (Note: No. of Days & No. of Days in Year calculated by ZACCZ,
     C**  ZDAYS)
     C*
     C     ZDDAYS        MULT      ZPRCIN        ZDSCF            15 8
     C     ZINTDD        IFNE      *ZERO
     C                   DIV       ZINTDD        ZDSCF
     C                   ELSE
     C                   Z-ADD     *ZERO         ZDSCF
     C                   END
     C                   DIV(H)    100           ZDSCF
     C                   ADD       1             ZDSCF
     C*
     C**  Discount new principal to previous coupon date/value date
     C*
     C     ZDSCF         IFNE      *ZERO
     C                   DIV       ZDSCF         ZPNPL
     C                   END
     C*
     C**  Set the next coupon date to the last date calculated
     C*
     C*****              Z-ADD     ZZLCD         NCD                                          CSE031
     C                   Z-ADD     ZZLCD         ZNCD                                         CSE031
     C                   END
     C*
     C**  Calculated price = principal/face value
     C*
     C                   MULT      100           ZPNPL
     C     ZPNPL         DIV       ZCONS         PRICEC
     C*
     C**  Price obtained so far is a 'dirty' price, ie, it includes
     C**  purchased interest
     C**  subtract the purchased interest tp get a 'clean' price
     C*
     C     CUMEXF        IFEQ      'C'
     C                   SUB       PURINT        PRICEC
     C                   ELSE
     C                   ADD       PURINT        PRICEC
     C                   END
     C     ZECALC        ENDSR
     C*****************************************************************
      ** +--- The converted ZCALCD ends here ----------------------------+
 
      /EJECT
      **********************************************************************
      *                                                                    *
      *  This subroutine is to cater for the fact that standard subroutine *
      *   ZCALCD in this module executes another standard subroutine,      *
      *
      *  This subroutine is also called ZLCD and simply does a CALLB to    *
      *   the module that contains subroutine ZLCD                         *
      *                                                                    *
     C     ZLCD          BEGSR
 
     C                   CALLB     'ZLCD'
     C                   PARM                    ISSD
     C                   PARM                    ITLD
     C                   PARM                    FCPN
     C                   PARM                    MATY
     C                   PARM                    CDArr
     C                   PARM                    CRArr
     C                   PARM                    LCPN                                       BUG11009
     C                   PARM                    ZECD
     C                   PARM                    BJDFIN
      *                                                                                       CSE005
      ** Nominal Currency                                                                     CSE005
      ** Security Investment Type                                                             CSE005
      ** Effect on Holidays on Coupon Dates                                                   CSE005
     C                   PARM                    NMCY              3                          CSE005
     C                   PARM                    SITP              3                          CSE005
     C                   PARM                    BCNV              1                          CSE005
      ** Effect of Holidays on Dates                                                          CSE071
     C                   PARM                    HCY1                                         CSE071
     C                   PARM                    HCY2                                         CSE071
     C                   PARM                    HCY3                                         CSE071
     C                   PARM                    HCY4                                         CSE071
     C                   PARM                    HCY5                                         CSE071
     C                   PARM                    HCY6                                         CSE071
     C                   PARM                    HCY7                                         CSE071
     C                   PARM                    HCY8                                         CSE071
     C                   PARM                    HCY9                                         CSE071
     C                   PARM                    ZZLCD
 
     C                   ENDSR
      **********************************************************************
      /EJECT
      **********************************************************************
      *                                                                    *
      *  This subroutine is to cater for the fact that standard subroutine *
      *   ZCALCD in this module executes another standard subroutine,      *
      *   ZACCZ, which has also been converted to a module.                *
      *  This subroutine is also called ZACCZ and simply does a CALLB to   *
      *   the module that contains subroutine ZACCZ                        *
      *                                                                    *
     C     ZACCZ         BEGSR
 
     C                   CALLB     'ZACCZ'
     C                   PARM                    ZAMT
     C                   PARM                    ZDCSDT
     C                   PARM                    ZDCEDT
     C                   PARM                    SECTY
     C                   PARM                    DADJN
     C*****              PARM                    NCD                                          CSE031
     C                   PARM                    ZNCD                                         CSE031
     C                   PARM                    NomCcyDec
     C                   PARM                    PROT
     C                   PARM                    BJDFIN
     C                   PARM                    ZDCINT
     C                   PARM                    ZDXINT
     C                   PARM                    ZDDAYS
     C                   PARM                    ZINTDD
 
     C                   ENDSR
      **********************************************************************
      /EJECT
      **********************************************************************
      *                                                                    *
      *  This subroutine is to cater for the fact that standard subroutine *
      *   ZCALCD in this module executes another standard subroutine,      *
      *   ZDAYS, which has also been converted to a module.                *
      *  This subroutine is also called ZDAYS and simply does a CALLB to   *
      *   the module that contains subroutine ZDAYS                        *
      *                                                                    *
     C     ZDAYS         BEGSR
 
     C                   CALLB     'ZDAYS'
     C                   PARM                    ZSDATE
     C                   PARM                    ZEDATE
     C                   PARM                    DYBS
     C                   PARM                    ITLD
     C                   PARM                    LCPN
     C                   PARM                    IADJ
     C                   PARM                    CPNR                           149162
     C                   PARM                    MATY                           149162
     C*****              PARM                    NCD                                   149162 CSE031
     C                   PARM                    ZNCD                                         CSE031
     C                   PARM                    DADJN
     C                   PARM                    ZIDNAT            2 0          149162
     C                   PARM                    ZACLT             1            149162
     C                   PARM                    ACLD              1            149162
     C                   PARM                    BJDFIN
     C                   PARM                    ZDDAYS
     C                   PARM                    ZODNAT            2 0          149162
 
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
 
      ** Nominal (15P 0)
      ** Current Principal  (15P 0)
      ** Face Value at maturity (15P 0)
      ** Yield effective date  (5P 0)
      ** Yield to be converted to % price (15P 3)
      ** CUM or EX coupon indicator  (1A)
      ** Purchased Interest   (15P 9)
     C                   PARM                    ZNOML
     C                   PARM                    ZPNPL
     C                   PARM                    ZCONS
     C                   PARM                    ZFDATE
     C                   PARM                    ZPRCIN
     C                   PARM                    CUMEXF
     C                   PARM                    PURINT
      ** Security details
      ** interest days adjustment
      ** Nomial currency decimal places  (1P 0)
      ** Processing type (1A)
     C                   PARM                    SECTY
     C                   PARM                    DADJN
     C                   PARM                    NomCcyDec
     C                   PARM                    PROT
 
      ** System input
      ** Date Format (1A)
     C                   PARM                    BJDFIN
 
      * OUTPUTS
 
      **  % Price  (15P 9)
     C                   PARM                    PRICEC
 
     C                   ENDSR
 
      *****************************************************************
 
