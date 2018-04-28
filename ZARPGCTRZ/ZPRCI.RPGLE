     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas ZA Output price as a percentage price')          *
      *****************************************************************
      *                                                               *
      *  Midas - Copy Source converted into ILE procedures            *
      *                                                               *
      *  ZPRCI   -   Output price as a %age price                     *
      *                                                               *
      *  This module is an ILE/RPG IV conversion of the ZPRCI         *
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
      *  Prev Amend No. CSD027             Date 09Dec05               *
      *                 CSE075             Date 17Nov05               *
      *                 CSE071             Date 19Jul05               *
      *                 CAS006             Date 21Jan03               *
      *                 CSE035             Date 22Apr02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CSE031             Date 13Dec01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CSD006             Date 11Oct00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CAP137             Date 07Feb00               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 149162             Date 07Dec98               *
      *                 CAP002  *CREATE    Date 21Apr98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSE075 - US Enhanced Treasury Upgrade to MidasPlus           *
      *           (Recompile)                                         *
      *  CSE071 - Multiple Holidays Re Securities                     *
      *  CAS006 - Hedge Accounting Phase B (Recompile)                *
      *  CSE035 - NX/NNX Coupon Payment Processing.                   *
      *  CSE031 - Coupon Fixing for Floating Rate Notes.              *
      *           Recompiled due to changes in SECTYD.                *
      *  CSD006 - Recompiled over changed SECTYD.                     *
      *  CAP137 - Conversion of SE Security inputs into modular       *
      *           structure to use as APIs (SECTYD)                   *
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
 
     D ZPARMS          DS
     D  PRCYLD                 1      1
     D  METHOD                 2      3
     D  SEMANN                 4      4
     D  ErrInd                 5      5
     D  PRICEC                 6     13P 9
     D  YIELDC                14     21P 9
     D  CPRTE                 22     27P 7
     D  NMAT                  28     29P 0
     D  FMAT                  30     35P 9
     D  KPRICE                36     43P 9
     D  YISVAL                44     50P 9
     D  ACCRCY                51     51P 0
     D  CPYEAR                52     53P 0
     D  DYLSTC                54     55P 0
     D  PERIOD                56     57P 0
     D  PAYYRS                58     64P 9
     D  PAYDYS                65     67P 0
     D  VALDTE                68     70P 0
     D  NCPDTE                71     73P 0
     D  MATDTE                74     76P 0
     D  CPTOMT                77     78P 0
     D  PURINT                79     86P 9
     D  DSFCTM                87     88P 0
     D  DYSTNC                89     90P 0
     D  CUMEXF                91     91
     D  COMFRQ                92     93P 0
     D  DSCBSS                94     94
     D  DLCOUP                95     95
                                                                                              CSE035
     D  ISSDTE                96     98P 0                                                    CSE035
     D  WBENCD                99    101P 0                                                    CSE035
                                                                                              CSE035
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CSE035
     D SAR_LCD       E                     EXTFLD(LCD)                                        CSE035
     D DSFDY         E DS                  EXTNAME(DSFDY)                                     CSE035
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE                                   CSE035
 
 
      ** INPUTS **
 
     D DADJN           S              1A
     D NomCcyDec       S              1P 0
     D PROT            S              1A
     D ZNOML           S             15P 0
     D WRKPI           S             15P 9
     D SCUMEX          S              1A
     D BJDFIN          S              1A
 
      ** OUTPUTS **
 
     D ZYLDOk          S              1A
 
      ** WORKING VARIABLES ***
 
     D*NCD****         S              5P 0                                                    CSE031
     D NextCoupDate    S              5P 0                                                    CSE031
     D ECD             S              5P 0
     D ZDDAYS          S              5P 0
     D ZSDATE          S              5P 0
     D ZEDATE          S              5P 0
     D ZINTDD          S              5P 0
     D LCDD5           S              5P 0
     D #DDAYS          S              5P 0
 
 
      ** +-----------------------------------------------------------------+
 
      ** Execute the standard subroutine
     C                   EXSR      ZPRCI
 
     C                   RETURN
      /EJECT
 
      ** +--- The converted ZPRCIZ1 starts here --------------------------+
     C*****************************************************************
     C*
     C*  ZPRCI - SUBROUTINE TO OUTPUT PRICE AS %PRICE
     C*
     C*  INPUT  - ZPRCIN (15,8) PRICE IN AS PRICE/DISC/YIELD
     C*           ZFDATE (5,0) FROM DATE
     C*           STBS (1) TRADE BASIS FROM SECURITY
     C*           MATY (5,0) MATURITY DATE FROM SECURITY
     C*           SYBS (2) YIELD BASIS FROM SECURITY
     C*
     C*  OUTPUT - ZPRCOT (15,8) OUTPUT PRICE AS PERCENTAGE
     C*
     C*  CALLS  - ZDAYS (ZDATE2)      YOU WILL ALSO NEED; ZDATE1,
     C*           ZDYYR (ZDAYS)                           ZYLD,
     C*           ZYLDI                                   ZNCD, ZLCD
     C********************************************************************
     C*                                                                  *
     C*    LAST AMEND NO.E20019                   DATE 03NOV89           *S01199
     C*                                                                  *
     C********************************************************************
     C*                                                                  *
     C* E20019 - Discount-to-Price conversion truncates discount rate.   *E20019
     C*                                                                  *
     C********************************************************************
     C*
     C     ZPRCI         BEGSR                                                  ** ZPRCI **
     C*
     C* DEFINE INPUT FIELDS
     C*
     C                   Z-ADD     ZPRCIN        ZPRCIN           15 8
     C                   Z-ADD     ZFDATE        ZFDATE            5 0
     C                   Z-ADD     0             ZPRCOT           15 8
     C*
     C* TRADE BASIS IS 'P' (PRICE)
     C*
     C     STBS          IFEQ      'P'
     C                   Z-ADD     ZPRCIN        ZPRCOT
     C                   ELSE
     C*
     C* TRADE BASIS IS 'D' (DISCOUNT)
     C*
     C     STBS          IFEQ      'D'
     C*
     C***** CALCULATE NO OF DAYS BETWEEN FROM DATE AND MATURITY DATE
     C*     D = ZDDAYS
     C                   Z-ADD     ZFDATE        ZSDATE
     C                   Z-ADD     MATY          ZEDATE
     C                   EXSR      ZDAYS
     C                   Z-ADD     ZDDAYS        #DDAYS            5 0
     C*
     C**** CALCULATE NO OF DAYS IN INTEREST YEAR
     C*    Y = ZINTDD
     C                   EXSR      ZDYYR
     C*
     C     ZINTDD        IFEQ      0
     C                   Z-ADD     0             ZPRCOT
     C                   ELSE
     C*
     C*                   (     (  PRICE IN    DAYS BETWEEN DATES ) )
     C*  PRICE OUT= 100 X ( 1 - ( ---------- * ------------------ ) )
     C*                   (     (    100       INTEREST YEAR DAYS ) )
     C*
     C     ZPRCIN        MULT      #DDAYS        WPRICE           15 8                         E2001
     C     WPRICE        DIV(H)    ZINTDD        WPRICE
     C     100           SUB       WPRICE        ZPRCOT                                        E2001
     C                   END
     C*
     C                   ELSE
     C*
     C* TRADE BASIS IS 'Y' (YIELD)
     C*
     C     STBS          IFEQ      'Y'
     C                   EXSR      ZYLDI
     C                   Z-ADD     ZYLDOT        ZPRCOT
     C                   END
     C                   END
     C                   END
     C*
     C                   ENDSR
     C*****************************************************************
      ** +--- The converted ZPRCIZ1 ends here ----------------------------+
 
      /EJECT
      **********************************************************************
      *                                                                    *
      *  This subroutine is to cater for the fact that standard subroutine *
      *   ZPRCI in this module executes another standard subroutine,       *
      *   ZYLDI, which has also been converted to a module.                *
      *                                                                    *
      *  This subroutine is also called ZYLDI and physically includes      *
      *   the code from standard ZYLDI as that code is so small            *
      *                                                                    *
 
     C*****************************************************************
     C*
     C*  ZYLDI - SUBROUTINE TO OUTPUT YIELD AS PERCENTAGE PRICE
     C*
     C*  INPUT  - ZPRCIN (15,8) INPUT PRICE AS YIELD
     C*
     C*  OUTPUT - ZYLDOT (15,8) PRICE AS PERCENTAGE
     C*                                                                  *
      *  (c) Misys International Banking Systems Ltd. 2001            *
     C*                                                                  *
     C*    LAST AMEND NO  E15823                  DATE 21/10/88          *
     C*                                                                  *
     C*------------------------------------------------------------------*
     C*                                                                  *
     C*    E15823 - INCREASE ZYIELD ACCURACY BY ENLARGING FIELDS         *E15823
     C*
     C*****************************************************************
     C*
     C     ZYLDI         BEGSR
     C*
     C                   MOVE      'I'           CTYPE             1
     C                   Z-ADD     ZPRCIN        YPARM            15 9                         E1582
     C                   Z-ADD     *ZERO         PPARM            15 9                         E1582
     C                   Z-ADD     ZFDATE        VDATE             5 0
     C*
     C                   EXSR      ZYLD
     C*
     C                   Z-ADD     PRICEC        ZYLDOT           15 8
     C*
     C                   ENDSR
     C*****************************************************************
      /EJECT
      **********************************************************************
      *                                                                    *
      *  This subroutine is to cater for the fact that standard subroutine *
      *   ZPRCI in this module (via SR/ZYLDI) executes another standard    *
      *   subroutine ZYLD, which has also been converted to a module.      *
      *  This subroutine is also called ZYLD and simply does a CALLB to    *
      *   the module that contains subroutine ZYLD                         *
      *                                                                    *
     C     ZYLD          BEGSR
 
     C                   CALLB     'ZYLD'
     C                   PARM                    CTYPE
     C                   PARM                    PPARM
     C                   PARM                    YPARM
     C                   PARM                    VDATE
     C                   PARM                    SECTY
     C                   PARM                    DADJN
     C                   PARM                    NomCcyDec
     C                   PARM                    PROT
     C                   PARM                    ZNOML
     C                   PARM                    WRKPI
     C                   PARM                    SCUMEX
     C                   PARM                    BJDFIN
     C                   PARM                    ZYLDOk
     C                   PARM                    ZPARMS
 
     C                   ENDSR
      **********************************************************************
      /EJECT
      **********************************************************************
      *                                                                    *
      *  This subroutine is to cater for the fact that standard subroutine *
      *   ZPRCI in this module executes another standard subroutine,       *
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
     C                   PARM                    NextCoupDate                                 CSE031
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
      **********************************************************************
      *                                                                    *
      *  This subroutine is to cater for the fact that standard subroutine *
      *   ZPRCI in this module executes another standard subroutine,       *
      *   ZDYYR, which has also been converted to a module.                *
      *  This subroutine is also called ZDYYR and simply does a CALLB to   *
      *   the module that contains subroutine ZDYYR                        *
      *                                                                    *
     C     ZDYYR         BEGSR
 
     C                   CALLB     'ZDYYR'
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
     C                   PARM                    DADJN
     C*****              PARM                    NCD                                          CSE031
     C                   PARM                    NextCoupDate                                 CSE031
     C                   PARM                    ECD
     C                   PARM                    BJDFIN
     C                   PARM                    HCY1                                         CSE071
     C                   PARM                    HCY2                                         CSE071
     C                   PARM                    HCY3                                         CSE071
     C                   PARM                    HCY4                                         CSE071
     C                   PARM                    HCY5                                         CSE071
     C                   PARM                    HCY6                                         CSE071
     C                   PARM                    HCY7                                         CSE071
     C                   PARM                    HCY8                                         CSE071
     C                   PARM                    HCY9                                         CSE071
     C                   PARM                    ZINTDD
     C                   PARM                    LCDD5
 
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
 
      ** Yield to be converted to % price (15P 8)
      ** Yield Effective Date   (5P 0)
     C                   PARM                    ZPRCIN
     C                   PARM                    ZFDATE
      *
      ** Security Details
      ** Nominal currency decimal position  (1P 0)
      ** Processing type (1A)
     C                   PARM                    SECTY
     C                   PARM                    NomCcyDec
     C                   PARM                    PROT
      *
      ** Nominal (15P 0)
      ** Purchased interest working variable (15P 9)
      ** CUM/Ex-coupon indicator (1A)
     C                   PARM                    ZNOML
     C                   PARM                    WRKPI
     C                   PARM                    SCUMEX
 
      ** System Info
      ** Date format (1A)
     C                   PARM                    BJDFIN
 
      * OUTPUTS
 
      ** Zyld Ok indicator (1A)
      ** Price as Percentage (15P 8)
     C                   PARM                    ZYLDOk
     C                   PARM                    ZPRCOT
      *                                                                                       CSE035
     C                   CALLB     'AOSARDR0'                                                 CSE035
     C                   PARM      *BLANKS       @RTCD             7                          CSE035
     C                   PARM      '*VERIFY'     @OPTN             7                          CSE035
     C                   PARM      'CSE035'      @SARD             6                          CSE035
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSE035
      *                                                                                       CSE035
     C     @RTCD         IFEQ      *BLANK                                                     CSE035
     C                   MOVEL     'Y'           CSE035            1                          CSE035
     C                   ELSE                                                                 CSE035
     C                   MOVEL     'N'           CSE035                                       CSE035
     C                   END                                                                  CSE035
 
 
 
     C                   ENDSR
      *****************************************************************
