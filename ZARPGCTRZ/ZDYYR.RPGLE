     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas ZA Calculate number of days in interst year')
      *****************************************************************
      *                                                               *
      *  Midas - Copy Source converted into ILE procedures            *
      *                                                               *
      *  ZDYYR   -   Calculat enumber of days in interst year         *
      *                                                               *
      *  This module is an ILE/RPG IV conversion of the ZDYYR         *
      *  subroutine.  The subroutine consists of three /COPY members. *
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
      *  Last Amend No. 226449             Date 24Jun15               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. BUG11193           Date 02May06               *
      *                 BUG11009           Date 30Mar06               *
      *                 CSE071             Date 19Jul05               *
      *                 180056             Date 28Sep00               *
      *                 206316             Date 19Jul02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CSE031             Date 13Dec01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CSE005             Date 20Jun00               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 149162             Date 07Dec98               *
      *                 CAP002  *CREATE    Date 21Apr98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  226449 - Wrong interest calculated due to wrong number of    *
      *           days in interest used for divisor basis 3. Fix is to*
      *           avoid comparing month of next coupon date to month  *
      *           of maturity date. Applied fix 211867.               *
      *         - Applied for MD034387.                               *
      *  BUG11193 - Purchased Interest not calculated on BackValued   *
      *             Trade. (Recompile)                                *
      *  BUG11009 - Wrong calculation of purchased interest.          *
      *             Applied fix 231841.                               *
      *  CSE071 - Multiple Holidays Re Securities                     *
      *  180056 - The number of days in interest year is being calcu- *
      *           lated incorrectly for divisor basis 5 if the coupon *
      *           days between the initial date and the first coupon  *
      *           date is significantly shorter or longer than the    *
      *           coupon days between periods as defined on the array.*
      *           Applied the complete version of core fix 151945.    *
      *  206316 - Recompiled over changed ZLCD.                       *
      *  CSE031 - Coupon Fixing for Floating Rate Notes.              *
      *  CSE005 - Added  3 more Parameters  when calling  ZLCD  & ZNCD*
      *           modules , which were introduced in them  by this    *
      *           amendment in  the  old  /COPY s  ZLCDZ1 &  ZNCDZ3 . *
      *  149162 - Int. calc. incorrect at end of Feb for 30 day method*
      *           (core fix 102506 changes ZDAYS and ZDYYR)           *
      *  CAP002 - Conversion of Midas inputs to modular API structure *
      *                                                               *
      *****************************************************************
 
      ** +-----------------------------------------------------------------+
      ** Declares for variables that were defined externally for the
      ** original copy members
      ** +-----------------------------------------------------------------+
 
      ***INPUT***
      * day basis from sectyd
     D  DYBS           S              1A
      * DIVISOR BASIS FROM SECTYD
     D  DVBS           S              1A
      * INITIAL DATE FROM SECTYD
     D  ITLD           S              5P 0
      ** Issue Date from SECTYD
     D  ISSD           S              5P 0
      * LAST COUPON DATE FROM SECTYD
     D  LCPN           S              5P 0
      ** First Coupon Date of the security
     D  FCPN           S              5P 0
      * MATURITY DATE FROM SECTYD
     D  MATY           S              5P 0
      * interest adjustment days from sectyd
     D  IADJ           S              3P 0
      ** Coupon Dates array
     D  CDArr          S             48A
      ** Coupon Rate Indicator array
     D  CRArr          S             12A
      * Coupon rate from sectyd                                                 149162
     D  CPNR           S             11P 7                                      149162
      * Interest days adjustment
     D  DADJN          S              1A
      * Next coupon date
     D  NCD            S              5P 0
      ** Event Control Date
     D ECD             S              5P 0
      ** Date format indicator
     D  BJDFIN         S              1A
 
      ***OUTPUT***
      * NO OF DAYS IN INTEREST YEAR
     D  ZINTDD         S              5P 0
 
      ***Internal Work Variables.***
      * start date (before call module ZDATE2)
     D  ZDAYNO         S              5P 0
      **  Date field returned from ZDATE2 after conversion from MIDAS day number.
     D  ZADATE         S              7A
      ** Numerical date format after conversion from MIDAS day number from ZDATE2
     D  ZDATE          S              6P 0
      * no of days
     D  ZDDAYS         S              5P 0
      ** Event Control Date
     D ZECD            S              5P 0
      ** Last Coupon Date (Output)
     D ZZLCD           S              5P 0
 
      ***Internal Work Variables.***
     D  ZWRK4          S              4P 0
     D  ZS             S              2P 0
 
 
      ** +-----------------------------------------------------------------+
 
 
      ** +--- The merged & converted ZDYYRZ1 & ZDYYRZ2 start here --------+
     D CRDS            DS
     D  CR01                   1      1
     D  CR02                   2      2
     D  CR03                   3      3
     D  CR04                   4      4
     D  CR05                   5      5
     D  CR06                   6      6
     D  CR07                   7      7
     D  CR08                   8      8
     D  CR09                   9      9
     D  CR10                  10     10
     D  CR11                  11     11
     D  CR12                  12     12
     D  CR                     1     12
     D                                     DIM(12)                              CR01-12 ARRAY
      ** +--- The merged & converted ZDYYRZ1 & ZDYYRZ2 end here ----------+
 
      ** For 180056 - module version - to compile requires various defns **                   180056
                                                                                              180056
      ** taken from ZNCD module source                                                        180056
     D CDDS            DS                                                                     180056
     D  CD01                   1      4  0                                                    180056
     D  CD02                   5      8  0                                                    180056
     D  CD03                   9     12  0                                                    180056
     D  CD04                  13     16  0                                                    180056
     D  CD05                  17     20  0                                                    180056
     D  CD06                  21     24  0                                                    180056
     D  CD07                  25     28  0                                                    180056
     D  CD08                  29     32  0                                                    180056
     D  CD09                  33     36  0                                                    180056
     D  CD10                  37     40  0                                                    180056
     D  CD11                  41     44  0                                                    180056
     D  CD12                  45     48  0                                                    180056
     D  CD                     1     48  0                                                    180056
     D                                     DIM(12)                                            180056
                                                                                              180056
      ** For 180056 - non-numeric version of CD array                                         180056
     D CDDSnn          DS                                                                     180056
     D  CD01nn                 1      4                                                       180056
     D  CD02nn                 5      8                                                       180056
     D  CD03nn                 9     12                                                       180056
     D  CD04nn                13     16                                                       180056
     D  CD05nn                17     20                                                       180056
     D  CD06nn                21     24                                                       180056
     D  CD07nn                25     28                                                       180056
     D  CD08nn                29     32                                                       180056
     D  CD09nn                33     36                                                       180056
     D  CD10nn                37     40                                                       180056
     D  CD11nn                41     44                                                       180056
     D  CD12nn                45     48                                                       180056
     D  CDnn                   1     48                                                       180056
     D                                     DIM(12)                                            180056
                                                                                              180056
      ** Numerical date format after to be converted to Midas date in ZDATE1                  180056
     D  ZDATEZ         S              6S 0                                                    180056
     D  ZDATEA         S              6                                                       180056
                                                                                              180056
      ** END 180056 - module version - to compile requires various defns **                   180056
      * Set indicator 98 from BJDFIN
 
     C     BJDFIN        IFEQ      'M'
     C                   SETON                                        98
     C                   ELSE
     C                   SETOFF                                       98
     C                   END
 
      ** Set up coupon indicator array
 
     C                   MOVEA     CRarr         CR
 
      ** For 180056 - set up coupon date array                                                180056
     C                   MOVEA     CDArr         CDnn                                         180056
     C                   Do        12            XX                2 0                        180056
     C                   Move      CDnn(xx)      CD(xx)                                       180056
     C                   Enddo                                                                180056
 
      ** Execute the standard subroutine
     C                   EXSR      ZDYYR
 
     C                   RETURN
      /EJECT
 
      ** +--- The converted ZDYYRZ3  starts here --------------------------+
     C**********************************************************************
     C**
     C** ZDYYR - SUBROUTINE TO CALCULATE NO OF DAYS IN INTEREST YEAR
     C**
     C**  INPUT  -  NCD (5,0) NEXT COUPON DATE FROM ZNCD
     C**            DVBS (1)  DIVISOR BASIS FROM SECTYD
     C**            LCPN (5,0) LAST COUPON DATE FROM SECTYD
     C**            ITLD (5,0) INITIAL DATE FROM SECTYD
     C**            MATY (5,0) MATURITY DATE FROM SECTYD
     C**            CR01/12 (1*12) RATE/PAYMENT INDS FROM SECTYD
     C**
     C**
     C**  OUTPUT -  ZINTDD (5,0) NO OF DAYS IN INTEREST YEAR
     C**
     C**  CALLS ZDAYS (ZDATE2)
     C**  USES ARRAY CR FOR RATE/PAYMENT INDICATORS
     C**
     C**  LAST AMEND NO. 100228           DATE 10JAN96
     C**  PREV AMEND NO. S01117           DATE 21JAN91
     C**                 E14496           DATE 02NOV89
     C**                 E17303           DATE 15/03/89
     C**
     C**-----------------------------------------------------------------*
     C**                                                                 *
     C**  100228 - Call ZLCD and ZNCD instead of ZD5DYS for coupon date  *
     C**           calculation to ensure 29FEB is considered valid.      *
     C**  S01117 - New SD files (Multibranching)                         *
     C**  E14496 - FOR DIV. BASIS 5 DETERMINATION OF LENGTH OF            E14496
     C**           COUPON PERIOD DOES NOT HANDLE SHORT/LONG COUPONS.      E14496
     C**  E17303 - TO SAVE FIELD 'ZDDAYS' THAT IS ALSO USED IN           *E17303
     C**           SUBROUTINE ZDAYS.                                     *E17303
     C**                                                                 *
     C********************************************************************
     C*
     C     ZDYYR         BEGSR                                                  ** ZDYYR BEGSR **
     C*
     C* DIVISOR BASIS 1
     C*
     C     DVBS          IFEQ      '1'
     C                   Z-ADD     360           ZINTDD            5 0
     C                   ELSE
     C*
     C* DIVISOR BASIS 2
     C*
     C     DVBS          IFEQ      '2'
     C                   Z-ADD     365           ZINTDD
     C                   ELSE
     C*
     C* DIVISOR BASIS 3
     C*    CHECK WHETHER INTEREST YEAR IS LEAP YEAR (DEFINED ACCORDING  TO
     C*     TO MATURITY DATE OF THE SECURITY)
     C*
     C     DVBS          IFEQ      '3'
     C* GET MMDD FOR NEXT COUPON DATE
     C                   Z-ADD     NCD           ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVE      ZDATE         ZNCDY             2 0
     C*
     C*  CHECK FORMAT DD/MM/YY OR MM/DD/YY
     C*
     C******IN98         IFEQ      '0'                                                        226449
     C**********         MOVE      ZDATE         ZNCDMD            4 0                        226449
     C**********         MOVEL     ZDATE         ZNCDD             2 0                        226449
     C**********         MOVE      ZNCDD         ZNCDMD                                       226449
     C**********         ELSE                                                                 226449
     C**********         MOVEL     ZDATE         ZNCDMD                                       226449
     C**********         END                                                                  226449
     C*
     C* GET MMDD FOR MATURITY DATE
     C**********         Z-ADD     MATY          ZDAYNO                                       226449
     C**********         EXSR      ZDATE2                                                     226449
     C*
     C*  CHECK FORMAT DD/MM/YY OR MM/DD/YY
     C*
     C     *IN98         IFEQ      '0'
     C                   MOVE      ZDATE         ZMATMD            4 0
     C                   MOVEL     ZDATE         ZMATD             2 0
     C                   MOVE      ZMATD         ZMATMD
     C                   MOVEL     ZMATMD        ZMATM             2 0
     C                   ELSE
     C                   MOVEL     ZDATE         ZMATMD
     C                   MOVEL     ZWRK4         ZMATM
     C                   END
     C*
     C* ESTABLISH START OF YEAR, END OF YEAR, IN WHICH NEXT COUPON DATE
     C* FALLS ( YEAR NOS ONLY NEEDED)
     C*
     C*****ZNCDMD        IFGT      ZMATMD                                                     226449
     C**********         Z-ADD     ZNCDY         ZSOY              2 0                        226449
     C*****ZNCDY         ADD       1             ZEOY              2 0                        226449
     C**********         ELSE                                                                 226449
     C*****ZNCDY         SUB       1             ZSOY                                         226449
     C**********         Z-ADD     ZNCDY         ZEOY                                         226449
     C**********         END                                                                  226449
     C* DOES THIS YEAR ALSO CONTAIN FEB29, IE IS IT A LEAP YEAR?
     C*
     C*  MAT MONTH GT FEB
     C     ZMATM         IFGT      02
     C                   Z-ADD     ZNCDY         ZEOY                                         226449
     C                   ELSE                                                                 226449
     C     ZNCDY         SUB       1             ZEOY              2 0                        226449
     C                   ENDIF                                                                226449
     C     ZEOY          DIV       4             ZWK               2 0
     C                   MVR                     ZREM              1 0
     C     ZREM          IFNE      0
     C                   Z-ADD     365           ZINTDD
     C                   ELSE
     C                   Z-ADD     366           ZINTDD
     C                   END
     C**********         ELSE                                                                 226449
     C*  MAT MONTH IS JAN OR FEB
     C*****ZSOY*         DIV       4             ZWK                                          226449
     C**********         MVR                     ZREM                                         226449
     C*****ZREM*         IFNE      0                                                          226449
     C**********         Z-ADD     365           ZINTDD                                       226449
     C**********         ELSE                                                                 226449
     C**********         Z-ADD     366           ZINTDD                                       226449
     C**********         END                                                                  226449
     C**********         END                                                                  226449
     C*
     C                   ELSE
     C*
     C* DIVISOR BASIS 5
     C     DVBS          IFEQ      '5'
     C*
     C**CALL ZLCD + ZNCD TO DETERMINE NEXT AND LAST COUPON DATES                       100228 180056
     C**********         Z-ADD     NCD           @NCD              5 0                 100228 180056
     C**********         EXSR      ZNCD                                                100228 180056
     C**********         Z-ADD     NCD           NCDD5             5 0                 100228 180056
     C**********         Z-ADD     @NCD          NCD                                   100228 180056
     C**********         Z-ADD     ZZLCD         @LCD              5 0                 100228 180056
     C*****NCDD5         SUB       1             ZECD                                  100228 180056
     C**********         EXSR      ZLCD                                                100228 180056
     C**********         Z-ADD     ZZLCD         LCDD5             5 0                 100228 180056
     C**********         Z-ADD     @LCD          ZZLCD                                 100228 180056
      *                                                                                180056
      ** Call ZD5DYS to determine the hypothetical next and last                       180056
      ** coupon dates.                                                                 180056
      *                                                                                180056
     C                   EXSR      ZD5DYS                                              180056
     C*
     C*     CALCULATE NO OF DAYS IN CURRENT COUPON PERIOD
     C*
     C* SAVE START AND END DATES                                          E14496
     C*                                                                   E14496
     C                   Z-ADD     ZSDATE        ZSSDAT            5 0                         E1449
     C                   Z-ADD     ZEDATE        ZESDAT            5 0                         E1449
     C                   Z-ADD     ZDDAYS        SVDAYS            5 0                         E1730
     C                   Z-ADD     LCDD5         ZSDATE            5 0                         E1449
     C                   Z-ADD     NCDD5         ZEDATE            5 0                         E1449
     C                   EXSR      ZDAYS
     C*
     C* CALCULATE NO OF COUPON PERIODS IN A YEAR
     C*
     C*
     C                   Z-ADD     0             ZS
     C                   Z-ADD     0             ZWCP              2 0
     C*
     C     ZS            DOUEQ     12
     C                   ADD       1             ZS
     C     CR(ZS)        IFEQ      'P'
     C     CR(ZS)        OREQ      'C'
     C                   ADD       1             ZWCP
     C                   END
     C                   END
     C*
     C*    CALCULATE NO OF DAYS = NO DAYS IN CURRENT COUPON PERIOD *
     C*                           NO COUPON PERIODS IN A YEAR
     C*
     C     ZDDAYS        MULT      ZWCP          ZINTDD
     C                   Z-ADD     SVDAYS        ZDDAYS                                        E1730
     C*
     C*RESTORE ORIGINAL START AND END DATES FOR PASSING BACK              E14496
     C*                                                                   E14496
     C                   Z-ADD     ZSSDAT        ZSDATE                                        E1449
     C                   Z-ADD     ZESDAT        ZEDATE                                        E1449
     C                   END
     C*
     C                   END
     C                   END
     C                   END
     C*
     C                   ENDSR                                                  *** ENDSR ***
     C*
     C**************************************************************E14496100228
      ** +--- The converted ZDYYRZ3 ends here ----------------------------+
 
      /EJECT
      **********************************************************************
      *                                                                    *
      *  This subroutine is to cater for the fact that standard subroutine *
      *   ZDYYR in this module executes another standard subroutine,       *
      *   ZDATE2, which has also been converted to a module.               *
      *  This subroutine is also called ZDATE2 and simply does a CALLB to  *
      *   the module that contains subroutine ZDATE2                       *
      *                                                                    *
     C     ZDATE2        BEGSR
 
     C                   CALLB     'ZDATE2'
     C                   PARM                    ZDAYNO
     C                   PARM                    BJDFIN
     C                   PARM                    ZDATE
     C                   PARM                    ZADATE
 
     C                   ENDSR
      **********************************************************************
      /EJECT
      **********************************************************************
      *                                                                    *
      *  This subroutine is to cater for the fact that standard subroutine *
      *   ZDYYR in this module executes another standard subroutine,       *
      *   ZNCD, which has also been converted to a module.                 *
      *  This subroutine is also called ZNCD and simply does a CALLB to    *
      *   the module that contains subroutine ZNCD                         *
      *                                                                    *
     C     ZNCD          BEGSR
 
     C                   CALLB     'ZNCD'
     C                   PARM                    ITLD
     C                   PARM                    FCPN
     C                   PARM                    MATY
     C                   PARM                    CDArr
     C                   PARM                    CRArr
     C                   PARM                    ECD
     C                   PARM                    BJDFIN
      *                                                                                       CSE005
      ** Nominal Currency                                                                     CSE005
      ** Security Investment Type                                                             CSE005
      ** Effect on Holidays on Coupon Dates                                                   CSE005
     C                   PARM                    NMCY              3                          CSE005
     C                   PARM                    SITP              3                          CSE005
     C                   PARM                    BCNV              1                          CSE005
      ** Last Coupon Date                                                                     CSE031
     C                   PARM                    LCPN                                         CSE031
      ** Effect of Holidays on Dates                                                          CSE071
     C                   PARM                    HCY1              3                          CSE071
     C                   PARM                    HCY2              3                          CSE071
     C                   PARM                    HCY3              3                          CSE071
     C                   PARM                    HCY4              3                          CSE071
     C                   PARM                    HCY5              3                          CSE071
     C                   PARM                    HCY6              3                          CSE071
     C                   PARM                    HCY7              3                          CSE071
     C                   PARM                    HCY8              3                          CSE071
     C                   PARM                    HCY9              3                          CSE071
     C                   PARM                    NCD
 
     C                   ENDSR
      **********************************************************************
      /EJECT
      **********************************************************************
      *                                                                    *
      *  This subroutine is to cater for the fact that standard subroutine *
      *   ZDYYR in this module executes another standard subroutine,       *
      *   ZLCD, which has also been converted to a module.                 *
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
     C                   PARM                    NMCY                                         CSE005
     C                   PARM                    SITP                                         CSE005
     C                   PARM                    BCNV                                         CSE005
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
      *   ZDYYR in this module executes another standard subroutine,       *
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
     C                   PARM                    NCD                            149162
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
 
      * Security details
     C                   PARM                    DYBS
     C                   PARM                    DVBS
     C                   PARM                    ISSD
     C                   PARM                    ITLD
     C                   PARM                    LCPN
     C                   PARM                    FCPN
     C                   PARM                    MATY
     C                   PARM                    IADJ
     C                   PARM                    CDArr
     C                   PARM                    CRArr
     C                   PARM                    CPNR                           149162
 
      * interest days adjustment
     C                   PARM                    DADJN
 
      * Next coupon date
     C                   PARM                    NCD
      *
      ** Event Control Date
      ** Date format indicator
     C                   PARM                    ECD
     C                   PARM                    BJDFIN
                                                                                              CSE071
      ** Holiday Currencies                                                                   CSE071
     C                   PARM                    HCY1                                         CSE071
     C                   PARM                    HCY2                                         CSE071
     C                   PARM                    HCY3                                         CSE071
     C                   PARM                    HCY4                                         CSE071
     C                   PARM                    HCY5                                         CSE071
     C                   PARM                    HCY6                                         CSE071
     C                   PARM                    HCY7                                         CSE071
     C                   PARM                    HCY8                                         CSE071
     C                   PARM                    HCY9                                         CSE071
 
      * OUTPUTS
 
      ** No. of days in interest year
      ** Last Coupon date for div basis 5
     C                   PARM                    ZINTDD
     C                   PARM                    LCDD5
 
     C                   ENDSR
 
      *****************************************************************
      *****************************************************************                       180056
      *    SUBROUTINE- ZD5DYS                                         *                       180056
      *    DETERMINE NUMBER OF DAYS IN COUPON PERIOD FOR DIV. BASIS 5 *                       180056
      *                                                               *                       180056
      *                                                               *                       180056
      *   INPUT - CD ARRAY - COUPON DATES - SECTYD SECURITY FILE      *                       180056
      *           CR ARRAY - RATE/PAYT INDICS - SECTYD SECURITY FILE  *                       180056
      *           MATY - MATURITY DATE - SECTYD SECURITY FILE         *                       180056
      *           ECD - EVENT CONTROL DTAE - ZEVCD PROCESS            *                       180056
      *                 (EXCEPT IN SE0050 INTEREST CALCULATIONS,      *                       180056
      *                  WHERE THE TRADE VALUE DATE MUST BE USED.)    *                       180056
      *           *IN98 - DATE FORMAT - FROM RUNDAT VIA PROGRAM       *                       180056
      *                                                               *                       180056
      *   OUTPUT - NCDD5 (5,0) - HYPOTHETICAL NEXT COUPON DATE        *                       180056
      *            LCDD5 (5,0) - HYPOTHETICAL LAST COUPON DATE        *                       180056
      *                                                               *                       180056
      *   CALLS  - ZDATE1                                             *                       180056
      *            ZDATE2                                             *                       180056
      *                                                               *                       180056
      *****************************************************************                       180056
      *                                                                                       180056
     C     ZD5DYS        BEGSR                                                                180056
      *                                                                                       180056
     C                   Z-ADD     0             TX                2 0                        180056
      *                                                                                       180056
      ** Call ZDATE2 to obtain MMDD for event control date                                    180056
      *                                                                                       180056
     C                   Z-ADD     ECD           ZDAYNO                                       180056
     C                   EXSR      ZDATE2                                                     180056
     C                   MOVEL     ZDATE         ZZECD4            4 0                        180056
     C     *IN98         IFEQ      '0'                                                        180056
     C                   MOVEL     ZZECD4        ZZWRKD                                       180056
     C                   MOVE      ZZECD4        ZZWRKM                                       180056
     C                   Z-ADD     ZZWRKD        ZZECD4                                       180056
     C                   MOVEL     ZZWRKM        ZZECD4                                       180056
     C                   ENDIF                                                                180056
      *                                                                                       180056
      ** If date format is DDMMYY turn round array of coupon dates                            180056
      ** to MM/DD                                                                             180056
      *                                                                                       180056
     C     *IN98         IFEQ      '0'                                                        180056
     C                   DO        12            ZQI               2 0                        180056
     C                   MOVE      CD(ZQI)       ZZWRKM            2 0                        180056
     C                   MOVEL     CD(ZQI)       ZZWRKD            2 0                        180056
     C                   Z-ADD     ZZWRKD        CD(ZQI)                                      180056
     C                   MOVEL     ZZWRKM        CD(ZQI)                                      180056
     C                   ENDDO                                                                180056
     C                   ENDIF                                                                180056
      *                                                                                       180056
      ** Get year for ECD                                                                     180056
      *                                                                                       180056
     C                   MOVE      ZDATE         ZECDYR            2 0                        180056
      *                                                                                       180056
      ** Find next coupon date from arrays -                                                  180056
      ** If rate/payt inds all blank NCD=maturity date LCD=initial date                       180056
      ** Should never happen for divisor basis 5                                              180056
      *                                                                                       180056
     C                   Z-ADD     MATY          NCDD5             5 0                        180056
     C                   Z-ADD     ITLD          LCDD5             5 0                        180056
     C     CRDS          IFNE      *BLANKS                                                    180056
      *                                                                                       180056
      ** If rate/payt inds not all blank                                                      180056
      ** Search for next highest coupon                                                       180056
      *                                                                                       180056
     C                   MOVE      '0'           ZFOUND            1                          180056
     C                   MOVE      '0'           YFOUND            1                          180056
     C                   DO        12            ZQI                                          180056
     C     CR(ZQI)       IFEQ      'P'                                                        180056
     C     CR(ZQI)       OREQ      'C'                                                        180056
      *                                                                                       180056
      ** If 29Feb is used in the coupon array, then there is a need to                        180056
      ** check if the current year is a leap year. If it is not,                              180056
      ** the coupon date is changed to 28.                                                    180056
      *                                                                                       180056
     C                   MOVEL     CD(ZQI)       ZZWRKM                                       180056
     C                   MOVE      CD(ZQI)       ZZWRKD                                       180056
     C     ZZWRKM        IFEQ      2                                                          180056
     C     ZZWRKD        ANDEQ     29                                                         180056
     C                   Z-ADD     ZECDYR        ZZYR              2 0                        180056
     C     ZZYR          ADD       28            ZZYR                                         180056
     C     ZZYR          DIV       4             ZZYR                                         180056
     C                   MVR                     ZMVR              1 0                        180056
     C     ZMVR          IFGT      0                                                          180056
     C                   Z-ADD     ZQI           TX                                           180056
     C                   MOVE      '28'          CD(ZQI)                                      180056
     C                   END                                                                  180056
     C                   END                                                                  180056
      *                                                                                       180056
     C     ZZECD4        IFLE      CD(ZQI)                                                    180056
     C     ZFOUND        ANDEQ     '0'                                                        180056
      *                                                                                       180056
      ** NCD Found - Add ECD'S YY to form date                                                180056
      *                                                                                       180056
     C                   Z-ADD     ZECDYR        ZDATE                                        180056
     C                   MOVEL     CD(ZQI)       ZDATE                                        180056
     C                   MOVE      '1'           ZFOUND                                       180056
     C                   END                                                                  180056
      *                                                                                       180056
     C     ZZECD4        IFGT      CD(ZQI)                                                    180056
     C                   Z-ADD     ZQI           ZRI               2 0                        180056
     C                   MOVE      '1'           YFOUND            1                          180056
     C                   END                                                                  180056
     C                   END                                                                  180056
     C                   END                                                                  180056
      *                                                                                       180056
      ** LCD Found - Add ECD'S YY to form date                                                180056
      *                                                                                       180056
     C     YFOUND        IFEQ      '1'                                                        180056
     C                   Z-ADD     ZECDYR        YDATE             6 0                        180056
     C                   MOVEL     CD(ZRI)       YDATE                                        180056
     C                   END                                                                  180056
      *                                                                                       180056
      ** Restored array back after the check.                                                 180056
      *                                                                                       180056
     C     TX            IFNE      0                                                          180056
     C                   MOVE      '29'          CD(TX)                                       180056
     C                   Z-ADD     0             TX                                           180056
     C                   END                                                                  180056
      *                                                                                       180056
      **  NCD Not Found - Use first coupon for next coupon date                               180056
      **                  Add next year's YY to form date                                     180056
      **  LCD Not Found - Use last coupon for last coupon date                                180056
      **                  Add last year's YY to form date                                     180056
      *                                                                                       180056
     C     ZFOUND        IFNE      '1'                                                        180056
     C     YFOUND        ORNE      '1'                                                        180056
     C                   DO        12            ZQI                                          180056
     C     CR(ZQI)       IFEQ      'P'                                                        180056
     C     CR(ZQI)       OREQ      'C'                                                        180056
     C                   Z-ADD     ZQI           ZRI                                          180056
     C     ZFOUND        IFEQ      '0'                                                        180056
     C                   Z-ADD     ZECDYR        ZDATE                                        180056
     C                   ADD       1             ZDATE                                        180056
      *                                                                                       180056
      ** If 29Feb is used in the coupon array, then there is a need to                        180056
      ** check if the current year is a leap year. If it is not,                              180056
      ** the coupon date is changed to 28.                                                    180056
      *                                                                                       180056
     C                   MOVEL     CD(ZQI)       ZZWRKM                                       180056
     C                   MOVE      CD(ZQI)       ZZWRKD                                       180056
     C     ZZWRKM        IFEQ      2                                                          180056
     C     ZZWRKD        ANDEQ     29                                                         180056
     C                   Z-ADD     ZECDYR        ZZYR              2 0                        180056
     C                   ADD       1             ZZYR                                         180056
     C     ZZYR          ADD       28            ZZYR                                         180056
     C     ZZYR          DIV       4             ZZYR                                         180056
     C                   MVR                     ZMVR              1 0                        180056
     C     ZMVR          IFGT      0                                                          180056
     C                   Z-ADD     ZQI           TX                                           180056
     C                   MOVE      '28'          CD(ZQI)                                      180056
     C                   END                                                                  180056
     C                   END                                                                  180056
      *                                                                                       180056
     C                   MOVEL     CD(ZQI)       ZDATE                                        180056
     C                   MOVE      '1'           ZFOUND                                       180056
      *                                                                                       180056
      ** Restored array back after the check.                                                 180056
      *                                                                                       180056
     C     TX            IFNE      0                                                          180056
     C                   MOVE      '29'          CD(TX)                                       180056
     C                   Z-ADD     0             TX                                           180056
     C                   END                                                                  180056
      *                                                                                       180056
     C                   END                                                                  180056
     C                   END                                                                  180056
     C                   END                                                                  180056
      *                                                                                       180056
     C     YFOUND        IFEQ      '0'                                                        180056
      *                                                                                       180056
      ** If ECD year is 00 and ECD year - 1, should be 99 not -01                             180056
      *                                                                                       180056
     C     ZECDYR        IFEQ      0                                                          180056
     C                   Z-ADD     99            YDATE                                        180056
     C                   ELSE                                                                 180056
     C     ZECDYR        SUB       1             YDATE             6 0                        180056
     C                   END                                                                  180056
      *                                                                                       180056
      ** If 29Feb is used in the coupon array, then there is a need to                        180056
      ** check if the current year is a leap year. If it is not,                              180056
      ** the coupon date is changed to 28.                                                    180056
      *                                                                                       180056
     C                   MOVEL     CD(ZRI)       ZZWRKM                                       180056
     C                   MOVE      CD(ZRI)       ZZWRKD                                       180056
     C     ZZWRKM        IFEQ      2                                                          180056
     C     ZZWRKD        ANDEQ     29                                                         180056
     C                   Z-ADD     ZECDYR        ZZYR              2 0                        180056
     C                   SUB       1             ZZYR                                         180056
     C     ZZYR          ADD       28            ZZYR                                         180056
     C     ZZYR          DIV       4             ZZYR                                         180056
     C                   MVR                     ZMVR              1 0                        180056
     C     ZMVR          IFGT      0                                                          180056
     C                   Z-ADD     ZRI           TX                                           180056
     C                   MOVE      '28'          CD(ZRI)                                      180056
     C                   END                                                                  180056
     C                   END                                                                  180056
      *                                                                                       180056
     C                   MOVEL     CD(ZRI)       YDATE                                        180056
      *                                                                                       180056
      ** Restored array back after the check.                                                 180056
      *                                                                                       180056
     C     TX            IFNE      0                                                          180056
     C                   MOVE      '29'          CD(TX)                                       180056
     C                   Z-ADD     0             TX                                           180056
     C                   END                                                                  180056
      *                                                                                       180056
     C                   MOVE      '1'           YFOUND            1                          180056
     C                   END                                                                  180056
     C                   END                                                                  180056
      *                                                                                       180056
      ** Convert date to day number using ZDATE1                                              180056
      ** (Not done if no rate/payt ind is P or C)                                             180056
      ** If DDMMYY format turn round to MMDDYY                                                180056
      *                                                                                       180056
     C     ZFOUND        IFEQ      '1'                                                        180056
     C     *IN98         IFEQ      '0'                                                        180056
     C                   MOVEL     ZDATE         ZZWRK             4 0                        180056
     C                   MOVE      ZZWRK         ZZWRKM                                       180056
     C                   MOVEL     ZZWRK         ZZWRKD                                       180056
     C                   Z-ADD     ZZWRKD        ZZWRK                                        180056
     C                   MOVEL     ZZWRKM        ZZWRK                                        180056
     C                   MOVEL     ZZWRK         ZDATE                                        180056
     C                   END                                                                  180056
                                                                                              180056
      ** FOR 180056, amend to call the module...                                              180056
     C*****              EXSR      ZDATE1                                                     180056
     C                   Eval      ZDATEZ = ZDATE                                             180056
     C                   MOVEL     ZDATEZ        ZDATEA                                       180056
     C                   CALLB     'ZDATE1'                                                   180056
     C                   PARM                    ZDATEA                                       180056
     C                   PARM                    ZDAYNO                                       180056
     C                   PARM                    BJDFIN                                       180056
     C                   PARM                    ERRORFLAG         1                          180056
      ** END 180056, amend to call the module...                                              180056
     C                   Z-ADD     ZDAYNO        NCDD5                                        180056
     C                   END                                                                  180056
      *                                                                                       180056
     C     YFOUND        IFEQ      '1'                                                        180056
     C                   MOVE      YDATE         ZDATE                                        180056
     C     *IN98         IFEQ      '0'                                                        180056
     C                   MOVEL     ZDATE         ZZWRK             4 0                        180056
     C                   MOVE      ZZWRK         ZZWRKM                                       180056
     C                   MOVEL     ZZWRK         ZZWRKD                                       180056
     C                   Z-ADD     ZZWRKD        ZZWRK                                        180056
     C                   MOVEL     ZZWRKM        ZZWRK                                        180056
     C                   MOVEL     ZZWRK         ZDATE                                        180056
     C                   END                                                                  180056
                                                                                              180056
      ** FOR 180056, amend to call the module...                                              180056
     C*****              EXSR      ZDATE1                                                     180056
     C                   Eval      ZDATEZ = ZDATE                                             180056
     C                   MOVEL     ZDATEZ        ZDATEA                                       180056
     C                   CALLB     'ZDATE1'                                                   180056
     C                   PARM                    ZDATEA                                       180056
     C                   PARM                    ZDAYNO                                       180056
      ** TCV will never change this flag, so for expediencies sake...                         180056
     C                   PARM                    BJDFIN                                       180056
     C                   PARM                    ERRORFLAG         1                          180056
      ** END 180056, amend to call the module...                                              180056
     C                   Z-ADD     ZDAYNO        LCDD5                                        180056
     C                   END                                                                  180056
     C                   END                                                                  180056
      *                                                                                       180056
      ** If date format is DDMMYY turn back array of coupon dates                             180056
      ** to DD/MM                                                                             180056
     C     *IN98         IFEQ      '0'                                                        180056
     C                   DO        12            ZQI               2 0                        180056
     C                   MOVEL     CD(ZQI)       ZZWRKM            2 0                        180056
     C                   MOVE      CD(ZQI)       ZZWRKD            2 0                        180056
     C                   Z-ADD     ZZWRKM        CD(ZQI)                                      180056
     C                   MOVEL     ZZWRKD        CD(ZQI)                                      180056
     C                   END                                                                  180056
     C                   END                                                                  180056
      *                                                                                       180056
     C                   ENDSR                                                                180056
     C*****************************************************************                       180056
