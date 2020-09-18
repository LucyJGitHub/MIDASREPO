     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas ZA Calculate yield or price')                    *
      *****************************************************************
      *                                                               *
      *  Midas - Copy Source converted into ILE procedures            *
      *                                                               *
      *  ZYIELD  -   Calculate yield or price                         *
      *                                                               *
      *  This module is an ILE/RPG IV conversion of the ZYIELD        *
      *  subroutine.  The subroutine consists of two /COPY members.   *
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
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CRE073             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG11193           Date 02May06               *
      *                 BUG11009           Date 30Mar06               *
      *                 CSD027             Date 09Dec05               *
      *                 CSE075             Date 17Nov05               *
      *                 CSE071             Date 19Jul05               *
      *                 229857             Date 07Oct04               *
      *                 226570             Date 27Jun04               *
      *                 194370             Date 12Jul01               *
      *                 CAS006             Date 21Jan03               *
      *                 211407             Date 07Nov02               *
      *                 207543             Date 17Jul02               *
      *                 CSE035             Date 22Apr02               *
      *                 206316             Date 19Jul02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CPK015             Date 17Jun02               *
      *                 CSE031             Date 13Dec01               *
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
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *             (Recompile)                                       *
      *  MD046248 - Finastra Rebranding                               *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  BUG11193 - Purchased Interest not calculated on BackValued   *
      *             Trade. (Recompile)                                *
      *  BUG11009 - Wrong calculation of purchased interest.          *
      *             Applied fix 231841.                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSE075 - US Enhanced Treasury Upgrade to MidasPlus           *
      *           (Recompile)                                         *
      *  CSE071 - Multiple Holidays Re Securities                     *
      *  229857 - Calculate the correct NMAT and FMAT for divisor     *
      *           basis 1 and 2. Applied fix 188723.                  *
      *  226570 - Calculate fraction of year to maturity from         *
      *           valuation date to anniversary of maturity date.     *
      *  194370 - Recompile after change on copy sources ZYLDZ2,      *
      *           For securities with divisor basis = '5' and first   *
      *           coupon date > valuation date (rundate + 1), set     *
      *           event control date to first coupon date before      *
      *           processing SR/ZDYYR. This is to ensure that the     *
      *           correct hypothetical last and next coupon dates are *
      *           used in deriving the price/yield rate.              *
      *  CAS006 - Hedge Accounting Phase B (Recompile)                *
      *  211407 - Amend to call ZLCD1 and ZNCD1 in getting the PERIOD *
      *           and WBENCD                                          *
      *  207543 - CEU018 not working on a price basis, missing a part *
      *           of AUS047.                                          *
      *  CSE035 - NX/NNX Coupon Payment Processing.                   *
      *  206316 - Recompiled over changed ZLCD.                       *
      *  CPK015 - Conversion of ZYIELD from PLI to RPG                *
      *  CSE031 - Coupon Fixing for Floating Rate Notes.              *
      *  CSD006 - Recompiled over changed SECTYD.                     *
      *  CSE005 - Added  3 more Parameters  when calling  ZLCD  & ZNCD
      *           modules , which were introduced in them  by this    *
      *           amendment in  the  old  /COPY s  ZLCDZ1 &  ZNCDZ3 . *
      *  149162 - Int. calc. incorrect at end of Feb for 30 day method*
      *           (core fix 102506 changes ZDAYS and ZDYYR)           *
      *  CAP002 - Conversion of Midas inputs to modular API structure *
      *                                                               *
      *****************************************************************
 
      * F spec for record format SEDEVDF.
     FSEDEV     IF   E           K DISK
 
      ** +-----------------------------------------------------------------+
      ** Declares for variables that were defined externally for the
      ** original copy members
      ** +-----------------------------------------------------------------+
 
 
      ** Security Details
     D SECTY         E DS                  EXTNAME(SECTYD)
     D CDArr                 183    230
     D CRArr                 231    242
 
 
     D CDDS            DS
     D  CD                     1     48  0
     D                                     DIM(12)                              CD01-12 ARRAY
     D CRDS            DS
     D  CR                     1     12
     D                                     DIM(12)                              CR01-12 ARRAY
 
 
     D POWER8          S              8P 4 DIM(8) CTDATA PERRCD(1)
 
 
      ** WORKING VARIABLES **
 
     D ECD             S              5P 0
     D*NCD*******      S              5P 0                                                    CSE031
     D ZZLCD           S              5P 0
     D ZDATE           S              6P 0
     D ZADATE          S              7A
     D ZAMT            S             15P 0
     D ZDCEDT          S              5P 0
     D ZDCSDT          S              5P 0
     D ZDCINT          S             13P 0
     D ZDXINT          S             15P 1
 
      ** +-----------------------------------------------------------------+
 
 
      ** +--- The converted ZYLDZ1 starts here --------------------------+
     D********************************************************************
     D**                                                                 *
     D**   ZYLDZ1 DATA STRUCTURE CONTAINING PARAMETERS FOR ZYIELD ROUTINE*
     D**                                                                 *
     D**   LAST AMEND NO. S01397                  DATE 10SEP92           *
     D**   PREV AMEND NO. E21034                  DATE 06FEB90           *
     D**                  S01231                  DATE 24NOV89           *
     D**                  E20380                  DATE 24NOV89           *
     D**                  E17303                  DATE 15/03/89          *
     D**                  E15823                  DATE 21/10/88          *
     D**                                                                 *
     D**-----------------------------------------------------------------*
     D**                                                                 *
     D*  S01397 - Rel 10 Incorporation of BNZ SARs A46008 and A46013.    *
     D*          - Fields added for New Yield method.                    *
     D**   E21034 - ERROR FIX FOR HANDLING MATURITIES AFTER 2099.        *E21034
     D**   S01231 - MODIFICATIONS FOR AUSTRALIAN YIELD FORMULAE.         *S01231
     D**   E20380 - MORE PROBLEMS WITH DIVISOR BASIS 5                   *E20380
     D**   E17303 - FIELD HAS NOT THE SAME LENGTH IN ZYLDZ1 AND ZYIELD.  *E17303
     D**   E15823 - PREVENT ROUNDING OF INPUT PRICE/YIELD.               *E15823
     D**                                                                 *
     D********************************************************************
     D ZPARMS          DS
     D  PRCYLD                 1      1
     D  METHOD                 2      3
     D  SEMANN                 4      4
     D  ERRIND                 5      5
     D  PRICEC                 6     13P 9                                      E15823
     D  YIELDC                14     21P 9                                      E15823
     D  CPRTE                 22     27P 7                                      E15823
     D  NMAT                  28     29P 0                                      E15823
     D  FMAT                  30     35P 9                                      E15823
     D  KPRICE                36     43P 9                                      E15823
     D  YISVAL                44     50P 9                                      E17303
     D  ACCRCY                51     51P 0                                      E15823
     D  CPYEAR                52     53P 0                                      E15823
     D  DYLSTC                54     55P 0                                      E15823
     D  PERIOD                56     57P 0                                      E15823
     D  PAYYRS                58     64P 9                                      E15823
     D  PAYDYS                65     67P 0                                      E15823
     D  VALDTE                68     70P 0                                      E15823
     D  NCPDTE                71     73P 0                                      E15823
     D  MATDTE                74     76P 0                                      E15823
     D  CPTOMT                77     78P 0                                      S01231
     D  PURINT                79     86P 9                                      S01231
     D  DSFCTM                87     88P 0                                      S01231
     D  DYSTNC                89     90P 0                                      S01231
     D  CUMEXF                91     91                                         S01231
     D  COMFRQ                92     93P 0                                      S01397
     D  DSCBSS                94     94                                         S01397
     D  DLCOUP                95     95                                         S01397
 
     D  ISSDTE                96     98P 0                                                    CSE035
     D  WBENCD                99    101P 0                                                    CSE035
                                                                                              CSE035
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CSE035
     D SAR_LCD       E                     EXTFLD(LCD)                                        CSE035
     D DSFDY         E DS                  EXTNAME(DSFDY)                                     CSE035
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE                                   CSE035
     D*                                                                   E21034
     D**  OBTAIN DATE IN YYYYMMDD FORMAT                                  E21034
     D                 DS                                                       E21034
     D  ZCENT                  1      2  0                                      E21034
     D  ZYEAR                  3      4  0                                      E21034
     D  ZMTH                   5      6  0                                      E21034
     D  ZDAY                   7      8  0                                      E21034
     D  WRKYMD                 1      8  0                                      E21034
     D*                                                                   E20380
     D**  NEXT COUPON DATE AS MMDD                                        E20380
     D                 DS                                                       E20380
     D  NCMM                   1      2  0                                      E20380
     D  NCDD                   3      4  0                                      E20380
     D  NCMDD                  1      4  0                                      E20380
 
     D*   MATURITY DATE AS MMDD                                           E20380
     D                 DS                                                       E20380
     D  MTMM                   1      2  0                                      E20380
     D  MTDD                   3      4  0                                      E20380
     D  MATMD                  1      4  0                                      E20380
      ** +--- The converted ZYLDZ1 ends here ----------------------------+
 
 
     ISEDEVDF
     I              RECI                        RECI_X
     I              NMCY                        NMCY_X
 
      *
      * Set indicator 98 from BJDFIN
      *
     C     BJDFIN        IFEQ      'M'
     C                   SETON                                        98
     C                   ELSE
     C                   SETOFF                                       98
     C                   END
 
      ** Nominal currency decimal places
 
     C                   Z-ADD     NomCcyDec     NCDP
 
      ** Set up effective date and input price for CD calculation
 
     C                   Z-ADD     VDATE         ZFDATE            5 0
     C                   Z-ADD     YPARM         ZPRCIN           15 8
 
      ** Set up coupon date and indicator arrays
 
     C                   MOVE      CDarr         CDDS
     C                   MOVE      CRarr         CRDS
 
      ** Execute the standard subroutine
     C                   EXSR      ZYLD
 
     C                   RETURN
      /EJECT
      ** +--- The converted ZYLDZ2 starts here --------------------------+
     C*****************************************************************
     C**                                                              *
     C** ZYLD subroutine sets up parameter values and calls the       *
     C** ZYIELD routine for calculating yields or prices              *
     C**                                                              *
     C** LAST AMEND NO. 084704             DATE 01AUG96               *
     C** PREV AMEND NO. 083039             DATE 01AUG96               *
     C**                059110             DATE 25JUL96               *
     C**                088047             DATE 26JUN96               *
     C**                064575             DATE 15AUG94               *
     C**                E39495             DATE 02NOV92               *
     C**                E47922             DATE 01FEB93               *
     C**                S01397             DATE 10SEP92               *
     C**                E21668             DATE 20APR90               *
     C**                E21256             DATE 26FEB90               *
     C**                E21105             DATE 12FEB90               *
     C**                E21034             DATE 06FEB90               *
     C**                S01232             DATE 28NOV89               *
     C**                E20380             DATE 28NOV89               *
     C**                E14496             DATE 02NOV89               *
     C**                E19635             DATE 20SEP89               *
     C**                E17303             DATE 15/03/89              *
     C**                E15823             DATE 21/10/88              *
     C**                E14053             DATE 17/09/88              *
     C**                                                              *
     C**--------------------------------------------------------------*
     C**                                                              *
     C** 084704 - For DYBS=3 and DVBS=2, should use actual no. of days*
     C** 083039 - Error indicator added to call to ZYIELD             *
     C**          Applied GEMS 076187                                 *
     C** 059110 - Last Coupon Date should be calculated and not taken *
     C**          off the security file                               *
     C** 088047 - For CD yield should use the last coupon date as     *
     C**          start date.                                         *
     C** 064575 - Apply Gems fix 047976: Error in array index.        *
     C** E39495 - Long term CD yield to price calculation is now      *
     C**          done outside PL1 program ZYIELD by new subroutine   *
     C**          ZCALCD                                              *
     C**          Note: Fields ZNOML, SCUMEX must be set up outside   *
     C**          ZYLD                                                *
     C** E47922 - Ex-Coupon yields incorrect if last coupon period    *
     C** S01397 - Rel 10 Incorporation of BNZ SARs A46008 and A46013. *
     C**        - New Zealand Bond formula added.                     *
     C** E21668 - Next Coupon Date should be after Value Date.        *
     C** E21256 - DEFINE SCUMEX CORRECTLY.                            *
     C** E21105 - INCOMPLETE KEY USED TO PICK UP REDEMPTION PRICE     *
     C** E21034 - ERROR FIX FOR HANDLING MATURITIES AFTER 2099.       *
     C**          ALSO RENAME WORK96 TO WRK159 TO AVOID CONFUSION     *
     C**          (THIS HAS NOT BEEN COMMENTED OUT, SIMPLY A SUBSTI-  *
     C**          TUTION MADE).                                       *
     C**          ALSO FORCED ECD PARAMETER FOR ZNCD IN CASE          *
     C**          IT IS NOT DONE IN THE CALLING PROGRAM.              *
     C** S01232 - ADD AUSTRALIAN YIELD CALCULATION METHODS. ALSO      *
     C**          CORRECTED SOME FURTHER PROBLEMS WITH DIV BASIS 5.   *
     C** E20380 - MORE ERRORS IN DIVISOR BASIS 5.                     *
     C** E19635 - ERRORS IN CALCULATING PARAMETER VALUES FOR DIVISOR  *
     C**          BASIS 5.                                            *
     C** E14496 - CHANGE TO ZDYYR FOR DIV BASIS 5 - OUTPUT            *
     C**          THEORETICAL LAST COUPON DATE.                       *
     C** E17303 - FIELD 'MTYDTE' NOT CORRECTLY SET UP                 *
     C** E15823 - INCREASE YIELD ACCURACY BY ENLARGING FIELDS         *
     C** E14053 - SEMI-ANNUAL INDICATOR IS NOT BEING SET PRIOR TO     *
     C**          CALL OF ZYIELD.                                     *
     C**                                                              *
     C*****************************************************************
     C**                                                              *
     C** Inputs:     CTYPE, calculation type ('O' = Yield)            *
     C**                                     ('I' = Price)            *
     C**             PPARM, price value for yield calculation         *
     C**             YPARM, yield value for price calculation         *
     C**             VDATE, valuation date (MIDAS day number)         *
     C**                                                              *
     C** Calls:      ZDAYS                                            *
     C**             ZDYYR                                            *
     C**             ZLCD                                             *
     C**             ZNCD                                             *
     C**             ZDATE1                                           *
     C**             ZDATE2                                           *
     C**                                                              *
     C     ZYLD          BEGSR                                                  ** ZYLD   *
     C**
     C*****PARAMETER*LIST*FOR*ZYIELD*ROUTINE***************************                       CPK015
     C*****YPARMS        PLIST                                                                CPK015
     C**********         PARM                    ZPARMS                                       CPK015
     C**
     C**  KEY LIST FOR ACCESSING SEDEVED
     C     SEDKY         KLIST
     C                   KFLD                    SESN
     C                   KFLD                    MATY                                          E2110
     C**
     C**  SET ERROR INDICATOR TO BLANK
     C                   MOVE      *BLANK        ERRIND
     C**                                                                  E21034
     C**  STORE ECD TO PREVENT CORRUPTION - SET ECD TO VALUE DATE +1      E21034
     C                   Z-ADD     ECD           WECD              5 0                         E2103
     C     VDATE         ADD       1             ECD                                           E2166
     C**
     C**  PRICE/YIELD INDICATOR & PRICE / YIELD VALUE
     C     CTYPE         IFEQ      'O'
     C                   MOVE      'Y'           PRCYLD
     C                   Z-ADD     PPARM         PRICEC
     C                   Z-ADD     *ZERO         YIELDC
     C                   ELSE
     C     CTYPE         IFEQ      'I'
     C                   MOVE      'P'           PRCYLD
     C                   Z-ADD     YPARM         YIELDC
     C                   Z-ADD     *ZERO         PRICEC
     C                   ELSE
     C                   MOVE      '1'           *IN99
     C                   GOTO      ZYEND1
     C                   END
     C                   END
     C**
     C**  YIELD CALCULATION METHOD
     C                   MOVE      SYBS          METHOD
     C**
     C**  COUPONS PER YEAR
     C                   Z-ADD     1             I                 2 0
     C                   Z-ADD     *ZERO         CPYEAR
     C                   MOVE      'N'           CDLAST            1                           06457
     C     I             DOWLT     13                                                          06457
     C     CDLAST        ANDNE     'Y'                                                         06457
     C     CD(I)         IFNE      *ZERO                                                       06457
     C     CR(I)         IFEQ      'C'
     C     CR(I)         OREQ      'P'
     C                   ADD       1             CPYEAR
     C                   END
     C                   ADD       1             I
     C                   ELSE                                                                  06457
     C                   MOVE      'Y'           CDLAST                                        06457
     C                   END
     C                   END                                                                   06457
     C**                                                                  E14053
     C**  SET SEMI ANNUAL INDICATOR. IF COUPONS PER YEAR GT 1 THEN        E14053
     C**    SET EQUAL TO 'Y' ELSE SET EQUAL TO 'N'                        E14053
     C     CPYEAR        IFGT      1                                                           E1405
     C                   MOVE      'Y'           SEMANN                                        E1405
     C                   ELSE                                                                  E1405
     C                   MOVE      'N'           SEMANN                                        E1405
     C                   END                                                                   E1405
     C**                                                                  S01232
     C**  INITIALISE (AUSTRALIAN) SHORT LAST COUPON FIELDS                S01232
     C**                                                                  S01232
     C                   Z-ADD     0             DSFCTM                                        S0123
     C                   Z-ADD     0             DYSTNC                                        S0123
     C**
     C**  YEARS UNTIL PAYMENT (PAYYRS), WHOLE YEARS TO MATURITY (NMAT)
     C**  & FRACTIONAL YEAR TO MATURITY (FMAT)
     C**
     C                   Z-ADD     VDATE         ZSDATE
     C                   Z-ADD     MATY          ZEDATE
     C                   EXSR      ZDAYS
     C                   Z-ADD     ZDDAYS        #DDAYS            5 0
     C                   EXSR      ZNCD
     C                   Z-ADD     0             WSNCD             5 0                        226570
     C     NCD           IFEQ      MATY                                                       226570
     C     CRDS          ANDEQ     *BLANKS                                                    226570
     C     DVBS          ANDEQ     '3'                                                        226570
      *                                                                                       226570
      ** Save original NCD value.                                                             226570
      *                                                                                       226570
     C                   Z-ADD     NCD           WSNCD                                        226570
      *                                                                                       226570
     C                   Z-ADD     VDATE         ZDAYNO                                       226570
     C                   EXSR      ZDATE2                                                     226570
      *                                                                                       226570
      ** Set correct century on value date.                                                   226570
      *                                                                                       226570
     C     VDATE         IFLT      10228                                                      226570
     C                   MOVE      '19'          ZCENT                                        226570
     C                   ELSE                                                                 226570
     C     VDATE         IFLT      46753                                                      226570
     C                   MOVE      '20'          ZCENT                                        226570
     C                   ELSE                                                                 226570
     C                   MOVE      '21'          ZCENT                                        226570
     C                   ENDIF                                                                226570
     C                   ENDIF                                                                226570
     C                   Z-ADD     WRKYMD        HLDDTE                                       226570
      *                                                                                       226570
     C                   Z-ADD     MATY          ZDAYNO                                       226570
     C                   EXSR      ZDATE2                                                     226570
      *                                                                                       226570
      ** Set correct century on maturity date.                                                226570
      *                                                                                       226570
     C     MATY          IFLT      10228                                                      226570
     C                   MOVE      '19'          ZCENT                                        226570
     C                   ELSE                                                                 226570
     C     MATY          IFLT      46753                                                      226570
     C                   MOVE      '20'          ZCENT                                        226570
     C                   ELSE                                                                 226570
     C                   MOVE      '21'          ZCENT                                        226570
     C                   ENDIF                                                                226570
     C                   ENDIF                                                                226570
     C                   Z-ADD     WRKYMD        MTYDTE                                       226570
      *                                                                                       226570
     C     MTYDTE        SUB       HLDDTE        WORK70                                       226570
     C     WORK70        DIV       10000         NMAT                                         226570
     C     NMAT          IFGE      1                                                          226570
     C     NMAT          MULT      10000         WORK70                                       226570
     C                   SUB       WORK70        MTYDTE                                       226570
     C                   MOVEL     MTYDTE        WORK40                                       226570
     C                   MOVE      WORK40        WORKYR                                       226570
     C                   MOVE      MTYDTE        WORK40                                       226570
     C   98              MOVEL     WORK40        ZDATE                                        226570
     C  N98              MOVE      WORK40        WORK20                                       226570
     C  N98              MOVE      WORK40        ZDATE                                        226570
     C  N98              MOVEL     WORK20        ZDATE                                        226570
     C                   MOVE      WORKYR        ZDATE                                        226570
     C                   EXSR      ZDATE1                                                     226570
     C                   Z-ADD     ZDAYNO        NCD                                          226570
     C                   ENDIF                                                                226570
     C                   ENDIF                                                                226570
     C                   EXSR      ZDYYR
      *                                                                                       226570
      ** Restore original NCD if value has changed.                                           226570
      *                                                                                       226570
     C     WSNCD         IFNE      0                                                          226570
     C                   Z-ADD     WSNCD         NCD                                          226570
     C                   ENDIF                                                                226570
     C**
     C**   Day and divisor basis both 1 or both 2
     C**
     C*****DYBS*         IFEQ      '1'                                                        229857
     C*****DVBS*         ANDEQ     '1'                                                        229857
     C*****DYBS*         OREQ      '2'                                                        229857
     C*****DVBS*         ANDEQ     '2'                                                        229857
     C     DVBS          IFEQ      '1'                                                        229857
     C     DVBS          OREQ      '2'                                                        229857
     C     DYBS          OREQ      '3'                                                         08470
     C     DVBS          ANDEQ     '2'                                                         08470
     C     #DDAYS        DIV       ZINTDD        NMAT
     C     #DDAYS        DIV       ZINTDD        WRK159           15 9                         E1582
     C     WRK159        SUB       NMAT          FMAT
     C                   ELSE
     C**
     C**   Other day/divisor bases except Divisor basis 5
     C**
     C     DVBS          IFNE      '5'
     C     CPYEAR        OREQ      *ZERO
     C                   Z-ADD     VDATE         ZDAYNO
     C                   EXSR      ZDATE2
     C*                                                                   E21034
     C*        Set correct century on value date                          E21034
     C*                                                                   E21034
     C     VDATE         IFLT      10228                                                       E2103
     C                   MOVE      '19'          ZCENT                                         E2103
     C                   ELSE                                                                  E2103
     C     VDATE         IFLT      46753                                                       E2103
     C                   MOVE      '20'          ZCENT                                         E2103
     C                   ELSE                                                                  E2103
     C                   MOVE      '21'          ZCENT                                         E2103
     C                   END                                                                   E2103
     C                   END                                                                   E2103
     C                   Z-ADD     WRKYMD        HLDDTE            8 0                         E2103
     C*                                                                   E21034
     C                   Z-ADD     MATY          ZDAYNO
     C                   EXSR      ZDATE2
     C*                                                                   E21034
     C*        Set correct century on maturity date                       E21034
     C*                                                                   E21034
     C     MATY          IFLT      10228                                                       E2103
     C                   MOVE      '19'          ZCENT                                         E2103
     C                   ELSE                                                                  E2103
     C     MATY          IFLT      46753                                                       E2103
     C                   MOVE      '20'          ZCENT                                         E2103
     C                   ELSE                                                                  E2103
     C                   MOVE      '21'          ZCENT                                         E2103
     C                   END                                                                   E2103
     C                   END                                                                   E2103
     C                   Z-ADD     WRKYMD        MTYDTE            8 0                         E2103
     C     MTYDTE        SUB       HLDDTE        WORK70            7 0
     C     WORK70        DIV       10000         NMAT
     C     NMAT          MULT      10000         WORK70
     C**********         ADD       WORK70        HLDDTE                                       226570
     C                   SUB       WORK70        MTYDTE                                       226570
     C**********         MOVEL     HLDDTE        WORK40                                 E2103 226570
     C                   MOVEL     MTYDTE        WORK40                                       226570
     C                   MOVE      WORK40        WORKYR            2 0                         E2103
     C**********         MOVE      HLDDTE        WORK40            4 0                        226570
     C                   MOVE      MTYDTE        WORK40            4 0                        226570
     C   98              MOVEL     WORK40        ZDATE
     C  N98              MOVE      WORK40        WORK20            2 0
     C  N98              MOVE      WORK40        ZDATE
     C  N98              MOVEL     WORK20        ZDATE
     C                   MOVE      WORKYR        ZDATE
     C                   EXSR      ZDATE1
     C**********         Z-ADD     ZDAYNO        ZSDATE                                       226570
     C**********         Z-ADD     MATY          ZEDATE                                       226570
     C                   Z-ADD     ZDAYNO        ZEDATE                                       226570
     C                   Z-ADD     VDATE         ZSDATE                                       226570
     C                   EXSR      ZDAYS
     C     ZDDAYS        DIV       ZINTDD        FMAT
     C                   ELSE
     C**                                                                  E20380
     C**   All day bases when Divisor basis  = 5                          E20380
     C**                                                                  E20380
     C**      Reverse security events array if date format is DDMM        E20380
     C**                                                                  E20380
     C     *IN98         IFEQ      '0'                                                         E2038
     C                   DO        12            I                                             E2038
     C                   MOVE      CD(I)         WORK20                                        E2038
     C                   MOVEL     WORK20        WORK40                                        E2038
     C                   MOVEL     CD(I)         WORK20                                        E2038
     C                   MOVE      WORK20        WORK40                                        E2038
     C                   MOVE      WORK40        CD(I)                                         E2038
     C                   END                                                                   E2038
     C                   END                                                                   E2038
     C**                                                                  E20380
     C**      Fraction of year till next coupon                           E20380
     C**                                                                  E20380
     C     NCD           SUB       VDATE         DYSNCP            5 0
     C     DYSNCP        DIV       ZINTDD        FMAT
     C**                                                                  E20380
     C**      Whole years from NCD to year of maturity                    E20380
     C**                                                                  E20380
     C                   Z-ADD     NCD           ZDAYNO
     C                   EXSR      ZDATE2
     C*                                                                   E21034
     C*          Set correct century on Next Coupon Date                  E21034
     C*                                                                   E21034
     C     NCD           IFLT      10228                                                       E2103
     C                   MOVE      '19'          ZCENT                                         E2103
     C                   ELSE                                                                  E2103
     C     NCD           IFLT      46753                                                       E2103
     C                   MOVE      '20'          ZCENT                                         E2103
     C                   ELSE                                                                  E2103
     C                   MOVE      '21'          ZCENT                                         E2103
     C                   END                                                                   E2103
     C                   END                                                                   E2103
     C                   Z-ADD     WRKYMD        HLDDTE
     C                   Z-ADD     ZDAY          NCDD
     C                   Z-ADD     ZMTH          NCMM
     C                   Z-ADD     MATY          ZDAYNO                                        E1730
     C                   EXSR      ZDATE2                                                      E1730
     C*                                                                   E21034
     C*          Set correct century on Maturity Date                     E21034
     C*                                                                   E21034
     C     MATY          IFLT      10228                                                       E2103
     C                   MOVE      '19'          ZCENT                                         E2103
     C                   ELSE                                                                  E2103
     C     MATY          IFLT      46753                                                       E2103
     C                   MOVE      '20'          ZCENT                                         E2103
     C                   ELSE                                                                  E2103
     C                   MOVE      '21'          ZCENT                                         E2103
     C                   END                                                                   E2103
     C                   END                                                                   E2103
     C                   Z-ADD     WRKYMD        MTYDTE                                        E1730
     C                   MOVE      MTYDTE        MATMD                                         E2038
     C     MTYDTE        SUB       HLDDTE        WORK70
     C     WORK70        DIV       10000         NMAT
     C**
     C**     Whole coupon periods from NCD till final one on array
     C**
     C                   Z-ADD     *ZERO         CB4MAT                                        E4792
     C     NCD           IFNE      MATY                                                        E2038
     C*                                                                   E20380
     C                   Z-ADD     1             I                                             E2038
     C                   MOVE      'N'           CRLAST            1                           06457
     C     I             DOWLT     13                                                          06457
     C     CRLAST        ANDNE     'Y'                                                         06457
     C     CR(I)         IFNE      'C'                                                         06457
     C     CR(I)         ANDNE     'P'                                                         06457
     C                   ADD       1             I                                             E2038
     C                   ELSE                                                                  06457
     C                   MOVE      'Y'           CRLAST                                        06457
     C                   END                                                                   E2038
     C                   END                                                                   06457
     C                   Z-ADD     I             ZFSCPN            2 0                         E2038
     C*                                                                   E20380
     C                   Z-ADD     12            I                                             E2038
     C                   MOVE      'N'           CRLAST                                        06457
     C     I             DOWNE     *ZERO                                                       06457
     C     CRLAST        ANDNE     'Y'                                                         06457
     C     CR(I)         IFNE      'C'                                                         06457
     C     CR(I)         ANDNE     'P'                                                         E2038
     C                   SUB       1             I                                             E2038
     C                   ELSE                                                                  06457
     C                   MOVE      'Y'           CRLAST                                        06457
     C                   END                                                                   E2038
     C                   END                                                                   06457
     C                   Z-ADD     I             ZLSCPN            2 0                         E2038
     C*                                                                   E20380
     C                   MOVE      '0'           ZNCFND            1                           E2038
     C                   Z-ADD     ZFSCPN        I                                             E2038
     C     ZNCFND        DOWEQ     '0'                                                         E2038
     C     I             ANDLT     13                                                          E2038
     C     NCMDD         IFEQ      CD(I)                                                       E2038
     C     CR(I)         IFEQ      'C'                                                         E2038
     C     CR(I)         OREQ      'P'                                                         E2038
     C                   MOVE      '1'           ZNCFND                                        E2038
     C                   ELSE                                                                  E2038
     C                   ADD       1             I                                             E2038
     C                   END                                                                   E2038
     C                   ELSE                                                                  E2038
     C                   ADD       1             I                                             E2038
     C                   END                                                                   E2038
     C                   END                                                                   E2038
     C                   Z-SUB     1             CB4MAT            3 0                         E2038
     C*                                                                   E20380
     C     HLDDTE        DOWLE     MTYDTE                                                      E2038
     C                   ADD       1             CB4MAT                                        E2038
     C     I             IFGE      ZLSCPN                                                      E2038
     C                   Z-ADD     ZFSCPN        I                                             E2038
     C                   ADD       10000         HLDDTE                                        E2038
     C                   ELSE                                                                  E2038
     C                   ADD       1             I                                             E2038
     C     CR(I)         DOWNE     'C'                                                         E2038
     C     CR(I)         ANDNE     'P'                                                         E2038
     C                   ADD       1             I                                             E2038
     C                   END                                                                   E2038
     C                   END                                                                   E2038
     C                   MOVE      CD(I)         HLDDTE                                        E2038
     C                   END                                                                   E2038
     C*
     C     CB4MAT        DIV       CPYEAR        WRK159
     C                   Z-ADD     WRK159        WRK99             9 9                         E1963
     C                   ADD       WRK99         FMAT                                          E1963
     C*
     C*                                                                   E20380
     C*                                                                   E20380
     C**    Find if there is a short last coupon and if there is, add     E20380
     C**    these days to FMAT. (If Mat date NE normal coupon date then   E20380
     C**    ZLCD will return last normal coupon date.) Must also store    E20380
     C**    current values of ZECD and ZZLCD to reset after use.          E20380
     C**    (As array is already in MMDD form - force IN98 to 1 for the   E20380
     C**     call to ZLCD).                                               E20380
     C**                                                                  E20380
     C                   Z-ADD     ZECD          ZWECD             5 0                         E2038
     C                   Z-ADD     MATY          ZECD                                          E2038
     C                   Z-ADD     ZZLCD         ZWLCD             5 0                         E2038
     C                   MOVE      *IN98         ZIN98             1                           E2038
     C                   SETON                                        98                       E2038
     C                   EXSR      ZLCD                                                        E2038
     C                   MOVE      ZIN98         *IN98                                         E2038
     C     ZZLCD         IFNE      MATY                                                        E2038
     C**                                                                  E20380
     C     MATY          SUB       ZZLCD         ZDDAYS                                        E2038
     C     ZDDAYS        DIV       ZINTDD        WRK159
     C                   Z-ADD     WRK159        WRK99                                         E1963
     C                   ADD       WRK99         FMAT                                          E1963
     C*                                                                   S01232
     C*      Also set up parameters for short last coupon for Australian  S01232
     C*      yields: days from coupon to maturity and from penultimate    S01232
     C*      coupon to next coupon according to array.                    S01232
     C*                                                                   S01232
     C     SYBS          IFEQ      'AU'                                                        S0123
     C                   Z-ADD     ZDDAYS        DSFCTM                                        S0123
     C*                                                                   S01232
     C                   MOVEL     MTYDTE        WORK40                                        E2103
     C                   MOVE      WORK40        WORKYR                                        E2103
     C*                                                                   S01232
     C*            Find next coupon                                       S01232
     C*                                                                   S01232
     C                   MOVE      '0'           ZNCFND                                        S0123
     C                   Z-ADD     1             I                                             S0123
     C     ZNCFND        DOWEQ     '0'                                                         S0123
     C     I             ANDLT     13                                                          S0123
     C     CD(I)         IFGT      MATMD                                                       S0123
     C     CR(I)         IFEQ      'P'                                                         S0123
     C     CR(I)         OREQ      'C'                                                         S0123
     C                   MOVE      WORKYR        ZDATE                                         S0123
     C                   MOVEL     CD(I)         ZDATE                                         S0123
     C                   MOVE      '1'           ZNCFND                                        S0123
     C                   ELSE                                                                  S0123
     C                   ADD       1             I                                             S0123
     C                   END                                                                   S0123
     C                   ELSE                                                                  S0123
     C                   ADD       1             I                                             S0123
     C                   END                                                                   S0123
     C                   END                                                                   S0123
     C*                                                                   S01232
     C*            If next coupon not found then use 1st coupon next year S01232
     C*                                                                   S01232
     C     ZNCFND        IFEQ      '0'                                                         S0123
     C                   Z-ADD     1             I                                             S0123
     C     ZNCFND        DOWEQ     '0'                                                         S0123
     C     CR(I)         IFEQ      'P'                                                         S0123
     C     CR(I)         OREQ      'C'                                                         S0123
     C                   MOVE      WORKYR        ZDATE                                         S0123
     C                   ADD       1             ZDATE                                         S0123
     C                   MOVEL     CD(I)         ZDATE                                         S0123
     C                   MOVE      '1'           ZNCFND                                        S0123
     C                   ELSE                                                                  S0123
     C                   ADD       1             I                                             S0123
     C                   END                                                                   S0123
     C                   END                                                                   S0123
     C                   END                                                                   S0123
     C*                                                                   S01232
     C*                                                                   S01232
     C*            Convert hypothetical NCD to day number using ZDATE1    S01232
     C*                                                                   S01232
     C     *IN98         IFEQ      '0'                                                         S0123
     C                   MOVE      ZDATE         WORK40                                        S0123
     C                   MOVEL     ZDATE         WORK20                                        S0123
     C                   MOVE      WORK20        WORK40                                        S0123
     C                   MOVEL     WORK40        ZDATE                                         S0123
     C                   END                                                                   S0123
     C*                                                                   S01232
     C*            Calculate days from LCD to hypothetical NCD            S01232
     C*                                                                   S01232
     C                   EXSR      ZDATE1                                                      S0123
     C     ZDAYNO        SUB       ZZLCD         DYSTNC                                        S0123
     C*                                                                   S01232
     C                   END                                                                   S0123
     C                   END                                                                   S0123
     C                   END
     C**                                                                  E20380
     C**      Revert security events array if date format is DDMM         E20380
     C**      and revert LCD.                                             E20380
     C**                                                                  E20380
     C     *IN98         IFEQ      '0'                                                         E2038
     C                   DO        12            I                                             E2038
     C                   MOVE      CD(I)         WORK20                                        E2038
     C                   MOVEL     WORK20        WORK40                                        E2038
     C                   MOVEL     CD(I)         WORK20                                        E2038
     C                   MOVE      WORK20        WORK40                                        E2038
     C                   MOVE      WORK40        CD(I)                                         E2038
     C                   END                                                                   E2038
     C                   END                                                                   E2038
     C                   Z-ADD     ZWLCD         ZZLCD                                         E2038
     C                   Z-ADD     ZWECD         ZECD                                          E2038
     C*                                                                   E20380
     C                   END
     C                   END
     C**
     C**  ADJUST WHOLE YEARS FOR FRACTIONS OF YEARS GT 1
     C**
     C     FMAT          IFGE      1
     C                   SUB       1             FMAT
     C                   ADD       1             NMAT
     C                   END
     C**
     C     NMAT          ADD       FMAT          PAYYRS
     C**
     C**  WHOLE COUPON PERIODS FOR MATURITY - (USED IN AUST. YIELDS)      S01232
     C                   Z-ADD     CB4MAT        CPTOMT                                        S0123
     C**
     C**  COUPON RATE
     C                   Z-ADD     CPNR          CPRTE
     C**
     C**  REDEMPTION PRICE
     C**    EVENT MUST BE ACTIVE, FOR MATURITY DATE AND OF THE RIGHT TYPE E21105
     C**                                                                  E21105
     C     SEDKY         SETLL     SEDEVDF
     C     SEDKY         READE     SEDEVDF                                90
     C                   SETOFF                                       91                       E2110
     C     *IN90         DOWEQ     '0'                                                         E2110
     C     *IN91         ANDEQ     '0'                                                         E2110
     C     RECI          IFNE      '*'                                                         E2110
     C     SDET          ANDEQ     'RC'                                                        E2110
     C     RECI          ORNE      '*'                                                         E2110
     C     SDET          ANDEQ     'RP'                                                        E2110
     C                   SETON                                        91                       E2110
     C                   Z-ADD     SDRP          KPRICE
     C                   ELSE
     C     SEDKY         READE     SEDEVDF                                90                   E2110
     C                   END                                                                   E2110
     C                   END                                                                   E2110
     C**
     C     *IN90         IFEQ      '1'                                                         E2110
     C                   Z-ADD     100           KPRICE
     C                   END
     C**
     C**  YEARS FROM ISSUE TO VALUATION
     C     SYBS          IFEQ      'C '                                                        08804
     C                   Z-ADD     ZECD          @ECD              5 0                         08804
     C                   Z-ADD     ZZLCD         @LCD              5 0                         08804
     C                   Z-ADD     VDATE         ZECD                                          08804
     C                   EXSR      ZLCD                                                        08804
     C                   Z-ADD     ZZLCD         ZSDATE                                        08804
     C                   Z-ADD     @ECD          ZECD                                          08804
     C                   Z-ADD     @LCD          ZZLCD                                         08804
     C                   ELSE                                                                  08804
     C                   Z-ADD     ISSD          ZSDATE
     C                   END                                                                   08804
     C                   Z-ADD     VDATE         ZEDATE
     C                   EXSR      ZDAYS
     C     ZDDAYS        DIV       ZINTDD        YISVAL
     C**
     C**  ACCURACY
     C                   Z-ADD     9             ACCRCY
     C**
     C**  DAYS SINCE LAST COUPON
     C     NCD           SUB       1             ZECD                                          05911
     C                   EXSR      ZLCD                                                        05911
     C     DVBS          IFNE      '5'                                                         E1449
     C     VDATE         SUB       ZZLCD         DYLSTC                                        05911
     C                   ELSE                                                                  E1449
     C     VDATE         SUB       LCDD5         DYLSTC                                        E1449
     C                   END                                                                   E1449
     C**
     C**  PERIOD BETWEEN COUPONS
     C     DVBS          IFNE      '5'                                                         E1449
     C     NCD           SUB       ZZLCD         PERIOD                                        05911
     C                   ELSE                                                                  E1449
     C     NCD           SUB       LCDD5         PERIOD                                        E1449
     C                   END                                                                   E1449
     C**
     C**  DAYS UNTIL PAYMENT
     C                   Z-ADD     VDATE         ZSDATE
     C                   Z-ADD     MATY          ZEDATE
     C                   EXSR      ZDAYS
     C                   Z-ADD     ZDDAYS        PAYDYS
     C**
     C**  VALUATION DATE
     C                   Z-ADD     VDATE         VALDTE
     C**
     C**  NEXT COUPON DATE
     C                   Z-ADD     NCD           NCPDTE
     C**
     C**  MATURITY DATE
     C                   Z-ADD     MATY          MATDTE
     C**                                                                  S01232
     C**  CUM OR EX COUPON FORMULA (FOR AUSTRALIAN METHODS)               S01232
     C**                                                                  S01232
     C                   MOVE      SCUMEX        CUMEXF                                        S0123
     C                   MOVE      SCUMEX        SCUMEX            1                           E2125
     C**                                                                  S01232
     C**  PURCHASED INTEREST (NEEDED FOR AUSTRALIAN METHODS AND           S01232
     C**   CALCULATED IN CALLING PROGRAM) COPIED TO PARAMETER FIELD       S01232
     C**                                                                  S01232
     C     CEU018        IFEQ      'Y'                                                        207543
      *                                                                                       207543
     C     5             ADD       NMDP          I                                            207543
     C     WRKPI         MULT      POWER8(I)     WRKPI                                        207543
     C                   Z-ADD     WRKPI         PURINT                                       207543
      *                                                                                       207543
     C                   ELSE                                                                 207543
      *                                                                                       207543
     C     5             SUB       NCDP          I                                             S0123
     C     WRKPI         MULT      POWER8(I)     WRKPI                                         S0123
     C     WRKPI         MULT      100           PURINT                                        S0123
      *                                                                                       207543
     C                   ENDIF                                                                207543
      *                                                                   S01397
      ***  Compound Frequency.                                            S01397
      *                                                                   S01397
     C                   Z-ADD     CMFQ          COMFRQ                                        S0139
      *                                                                   S01397
      ***  Discount Last Coupon.                                          S01397
      *                                                                   S01397
     C                   MOVEL     DSLC          DLCOUP                                        S0139
      *                                                                   S01397
      ***  Discount Basis.                                                S01397
      *                                                                   S01397
     C                   MOVEL     DSCB          DSCBSS                                        S0139
     C**                                                                  S01232
     C**  DEFINE FIELDS                                                   S01232
     C                   Z-ADD     WRKPI         WRKPI            15 9                         S0123
     C                   Z-ADD     NCDP          NCDP              1 0                         S0123
      *                                                                                       CSE035
      *   FOR NX & NNX PROCESSING                                                             CSE035
      *                                                                                       CSE035
     C     CSE035        IFEQ      'Y'                                                        CSE035
      *                                                                                       CSE035
     C                   Z-ADD     *ZEROS        ISSDTE                                       CSE035
     C                   Z-ADD     *ZEROS        WBENCD                                       CSE035
     C     SCUMEX        IFEQ      'N'                                                        CSE035
     C                   Z-ADD     ITLD          ISSDTE                                       CSE035
     C                   ELSE                                                                 CSE035
     C     SCUMEX        IFEQ      'D'                                                        CSE035
     C                   Z-ADD     ECD           SECD              5 0                        CSE035
     C                   Z-ADD     NCDD5         SNCDD5            5 0                        CSE035
     C                   Z-ADD     LCDD5         SLCDD5            5 0                        CSE035
     C                   Z-ADD     ITLD          ECD                                          CSE035
     C*                                                                                       CSE035
     C**CALL*ZLCD*+*ZNCD*TO*DETERMINE*NEXT*AND*LAST*COUPON*DATES*****                  CSE035 211407
     C* CALL ZLCD + ZNCD1 TO DETERMINE LAST AND NEXT COUPON DATES                             211407
     C                   Z-ADD     NCD           @NCD              5 0                        CSE035
     C*******************EXSR      ZNCD                                                CSE035 211407
     C*******************Z-ADD     NCD           NCDD5             5 0                 CSE035 211407
     C                   EXSR      ZNCD1                                                      211407
     C                   Z-ADD     NCD1          NCDD5             5 0                        211407
     C                   Z-ADD     @NCD          NCD                                          CSE035
     C                   Z-ADD     ZZLCD         @LCD              5 0                        CSE035
     C     NCDD5         SUB       1             ZECD                                         CSE035
     C*******************EXSR      ZLCD                                                CSE035 211407
     C*******************Z-ADD     ZZLCD         LCDD5             5 0                 CSE035 211407
     C                   EXSR      ZLCD1                                                      211407
     C                   Z-ADD     ZZLCD1        LCDD5             5 0                        211407
     C                   Z-ADD     @LCD          ZZLCD                                        CSE035
     C*                                                                                       CSE035
     C                   Z-ADD     ITLD          ISSDTE                                       CSE035
     C                   Z-ADD     NCDD5         WBENCD                                       CSE035
      *                                                                                       CSE035
      *   ADJUST PERIOD IF VALUE DATE LESS THAN WOULD-BE COUPON DATE                          CSE035
      *                                                                                       CSE035
     C     VDATE         IFLT      NCDD5                                                      CSE035
     C     NCDD5         SUB       LCDD5         PERIOD                                       CSE035
     C                   END                                                                  CSE035
     C                   Z-ADD     SECD          ECD                                          CSE035
     C                   Z-ADD     SNCDD5        NCDD5                                        CSE035
     C                   Z-ADD     SLCDD5        LCDD5                                        CSE035
     C                   END                                                                  CSE035
     C                   END                                                                  CSE035
      *                                                                                       CSE035
     C                   END                                                                  CSE035
      *                                                                                       CSE035
     C*                                                                   E39495
     C**  If long term CD (Long term = greater than 1 year to maturity)   E39495
     C**  calculate Purchased Interest.  Used in adjustment of price      E39495
     C*                                                                   E39495
     C     METHOD        IFEQ      'C '                                                        E3949
     C     NMAT          ANDGE     1                                                           E3949
     C*                                                                   E39495
     C**  Set up From/To dates according to whether Cum or Ex Coupon      E39495
     C*                                                                   E39495
     C     CUMEXF        IFEQ      'X'                                                         E3949
     C                   Z-ADD     ZFDATE        ZDCSDT                                        E3949
     C                   Z-ADD     NCD           ZDCEDT                                        E3949
     C                   ELSE                                                                  E3949
     C                   Z-ADD     LCPN          ZDCSDT                                        E3949
     C                   Z-ADD     ZFDATE        ZDCEDT                                        E3949
     C                   END                                                                   E3949
     C                   Z-ADD     ZNOML         ZAMT                                          E3949
     C*                                                                   E39495
     C**  Calculate Interest                                              E39495
     C*                                                                   E39495
     C                   EXSR      ZACCZ                                                       E3949
     C*                                                                   E39495
     C**  Convert nominal at maturity to face  value                      E39495
     C**  (ZNOML X ZPRC = ZCONS)                                          E39495
     C*                                                                   E39495
     C                   Z-ADD     100           ZPRC                                          E3949
     C                   EXSR      ZCNSD                                                       E3949
     C                   Z-ADD     ZCONS         ZPNPL            15 0                         E3949
     C*                                                                   E39495
     C**  Make interest figure a percentage                               E39495
     C*                                                                   E39495
     C     ZPNPL         IFNE      *ZERO                                                       E3949
     C                   MULT      100           ZDCINT                                        E3949
     C     ZDCINT        DIV(H)    ZPNPL         PURINT                                        E3949
     C                   ELSE                                                                  E3949
     C                   Z-ADD     *ZERO         PURINT                                        E3949
     C                   END                                                                   E3949
     C                   END                                                                   E3949
     C*                                                                   E39495
     C**  If long term CD and Yield to Price conversion required,         E39495
     C**  use subroutine ZCALCD                                           E39495
     C*                                                                   E39495
     C     METHOD        IFEQ      'C '                                                        E3949
     C     NMAT          ANDGE     1                                                           E3949
     C     PRCYLD        ANDEQ     'P'                                                         E3949
     C                   EXSR      ZCALCD                                                      E3949
     C                   ELSE                                                                  E3949
     C**
     C**  ALL PARAMETERS SET UP CALL ZYIELD ROUTINE
     C**********         CALL      'ZYIELD'      YPARMS                 99              08303 CPK015
     C                   CALL      'ZYIELD'                             99                    CPK015
     C                   PARM                    PRCYLD                                       CPK015
     C                   PARM                    METHOD                                       CPK015
     C                   PARM                    SEMANN                                       CPK015
     C                   PARM                    ERRIND                                       CPK015
     C                   PARM                    PRICEC                                       CPK015
     C                   PARM                    YIELDC                                       CPK015
     C                   PARM                    CPRTE                                        CPK015
     C                   PARM                    NMAT                                         CPK015
     C                   PARM                    FMAT                                         CPK015
     C                   PARM                    KPRICE                                       CPK015
     C                   PARM                    YISVAL                                       CPK015
     C                   PARM                    ACCRCY                                       CPK015
     C                   PARM                    CPYEAR                                       CPK015
     C                   PARM                    DYLSTC                                       CPK015
     C                   PARM                    PERIOD                                       CPK015
     C                   PARM                    PAYYRS                                       CPK015
     C                   PARM                    PAYDYS                                       CPK015
     C                   PARM                    VALDTE                                       CPK015
     C                   PARM                    NCPDTE                                       CPK015
     C                   PARM                    MATDTE                                       CPK015
     C                   PARM                    CPTOMT                                       CPK015
     C                   PARM                    PURINT                                       CPK015
     C                   PARM                    DSFCTM                                       CPK015
     C                   PARM                    DYSTNC                                       CPK015
     C                   PARM                    CUMEXF                                       CPK015
     C                   PARM                    COMFRQ                                       CPK015
     C                   PARM                    DSCBSS                                       CPK015
     C                   PARM                    DLCOUP                                       CPK015
     C                   PARM                    ISSDTE                                       CSE035
     C                   PARM                    WBENCD                                       CSE035
                                                                                              CPK015
     C                   END                                                                   E3949
     C*                                                                   E39495
     C**  IF  long term CD and Price to Yield conversion required,        E39495
     C**  round outgoing yield to 3 decimal places                        E39495
     C*                                                                   E39495
     C     METHOD        IFEQ      'C '                                                        E3949
     C     NMAT          ANDGE     1                                                           E3949
     C     PRCYLD        ANDEQ     'Y'                                                         E3949
     C                   Z-ADD(H)  YIELDC        ZYLDRN           13 3                         E3949
     C                   Z-ADD     ZYLDRN        YIELDC                                        E3949
     C                   END                                                                   E3949
     C*                                                                   E21034
     C*   RESET ECD                                                       E21034
     C                   Z-ADD     WECD          ECD                                           E2103
     C**
     C**  CHECK FOR ERRORS
     C     ERRIND        IFEQ      'P'
     C     ERRIND        OREQ      'R'
     C                   MOVE      '1'           *IN99
     C                   END
     C**
     C     ZYEND1        TAG
     C     ZYLD9         ENDSR                                                  ** ZYLD9  **
     C*****************************************************************
      ** +--- The converted ZYLDZ1 ends here ----------------------------+
 
      /EJECT
      **********************************************************************
      *                                                                    *
      *  This subroutine is to cater for the fact that standard subroutine *
      *   ZYLD in this module executes another standard subroutine,        *
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
     C                   PARM                    NCD
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
     C                   PARM                    ZINTDD            5 0
     C                   PARM                    LCDD5             5 0
 
     C                   ENDSR
      **********************************************************************
      /EJECT
      **********************************************************************
      *                                                                    *
      *  This subroutine is to cater for the fact that standard subroutine *
      *   ZYLD in this module executes another standard subroutine,        *
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
     C                   PARM                    HCY1                                         CSE071
     C                   PARM                    HCY2                                         CSE071
     C                   PARM                    HCY3                                         CSE071
     C                   PARM                    HCY4                                         CSE071
     C                   PARM                    HCY5                                         CSE071
     C                   PARM                    HCY6                                         CSE071
     C                   PARM                    HCY7                                         CSE071
     C                   PARM                    HCY8                                         CSE071
     C                   PARM                    HCY9                                         CSE071
     C                   PARM                    NCD
 
     C                   ENDSR
      **********************************************************************
      /EJECT
      **********************************************************************                  211407
     C     ZNCD1         BEGSR                                                                211407
                                                                                              211407
     C                   CALLB     'ZNCD1'                                                    211407
     C                   PARM                    ITLD                                         211407
     C                   PARM                    FCPN                                         211407
     C                   PARM                    MATY                                         211407
     C                   PARM                    CDArr                                        211407
     C                   PARM                    CRArr                                        211407
     C                   PARM                    ECD                                          211407
     C                   PARM                    BJDFIN                                       211407
     C                   PARM                    NMCY                                         211407
     C                   PARM                    SITP                                         211407
     C                   PARM                    BCNV                                         211407
     C                   PARM                    LCPN                                         211407
     C                   PARM                    HCY1                                         CSE071
     C                   PARM                    HCY2                                         CSE071
     C                   PARM                    HCY3                                         CSE071
     C                   PARM                    HCY4                                         CSE071
     C                   PARM                    HCY5                                         CSE071
     C                   PARM                    HCY6                                         CSE071
     C                   PARM                    HCY7                                         CSE071
     C                   PARM                    HCY8                                         CSE071
     C                   PARM                    HCY9                                         CSE071
     C                   PARM                    NCD1              5 0                        211407
                                                                                              211407
     C                   ENDSR                                                                211407
      **********************************************************************                  211407
      /EJECT                                                                                  211407
      **********************************************************************
      *                                                                    *
      *  This subroutine is to cater for the fact that standard subroutine *
      *   ZYLD in this module executes another standard subroutine,        *
      *   ZLCD, which has also been converted to a module.                 *
      *  This subroutine is also called ZLCD and simply does a CALLB to    *
      *   the module that contains subroutine ZLCD                         *
      *                                                                    *
     C     ZLCD          BEGSR
 
      * in ZLCD use 'temporary' version of date format ind according
      * to current value of indicator 98.
 
     C     *IN98         IFEQ      '1'
     C                   MOVE      'M'           T_BJDFIN          1
     C                   ELSE
     C                   MOVE      'D'           T_BJDFIN          1
     C                   END
 
     C                   CALLB     'ZLCD'
     C                   PARM                    ISSD
     C                   PARM                    ITLD
     C                   PARM                    FCPN
     C                   PARM                    MATY
     C                   PARM                    CDArr
     C                   PARM                    CRArr
     C                   PARM                    LCPN                                       BUG11009
     C                   PARM                    ZECD              5 0
     C                   PARM                    T_BJDFIN
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
      **********************************************************************                  211407
     C     ZLCD1         BEGSR                                                                211407
                                                                                              211407
                                                                                              211407
     C     *IN98         IFEQ      '1'                                                        211407
     C                   MOVE      'M'           T_BJDFIN          1                          211407
     C                   ELSE                                                                 211407
     C                   MOVE      'D'           T_BJDFIN          1                          211407
     C                   END                                                                  211407
                                                                                              211407
     C                   CALLB     'ZLCD1'                                                    211407
     C                   PARM                    ISSD                                         211407
     C                   PARM                    ITLD                                         211407
     C                   PARM                    FCPN                                         211407
     C                   PARM                    MATY                                         211407
     C                   PARM                    CDArr                                        211407
     C                   PARM                    CRArr                                        211407
     C                   PARM                    ZECD                                         211407
     C                   PARM                    T_BJDFIN                                     211407
     C                   PARM                    NMCY                                         211407
     C                   PARM                    SITP                                         211407
     C                   PARM                    BCNV                                         211407
     C                   PARM                    HCY1                                         CSE071
     C                   PARM                    HCY2                                         CSE071
     C                   PARM                    HCY3                                         CSE071
     C                   PARM                    HCY4                                         CSE071
     C                   PARM                    HCY5                                         CSE071
     C                   PARM                    HCY6                                         CSE071
     C                   PARM                    HCY7                                         CSE071
     C                   PARM                    HCY8                                         CSE071
     C                   PARM                    HCY9                                         CSE071
     C                   PARM                    ZZLCD1            5 0                        211407
                                                                                              211407
     C                   ENDSR                                                                211407
      **********************************************************************                  211407
      /EJECT                                                                                  211407
      **********************************************************************
      *                                                                    *
      *  This subroutine is to cater for the fact that standard subroutine *
      *   ZYLD in this module executes another standard subroutine,        *
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
 
     C                   MOVEL     ZDATE         ZWRK4             4 0
     C                   MOVE      ZDATE         ZYEAR
     C     BJDFIN        IFEQ      'D'
     C                   MOVEL     ZWRK4         ZDAY
     C                   MOVE      ZWRK4         ZMTH
     C                   ELSE
     C                   MOVEL     ZWRK4         ZMTH
     C                   MOVE      ZWRK4         ZDAY
     C                   ENDIF
 
     C                   ENDSR
      **********************************************************************
      /EJECT
      **********************************************************************
      *                                                                    *
      *  This subroutine is to cater for the fact that standard subroutine *
      *   ZYLD in this module executes another standard subroutine,        *
      *   ZDATE1, which has also been converted to a module.               *
      *  This subroutine is also called ZDATE1 and simply does a CALLB to  *
      *   the module that contains subroutine ZDATE1                       *
      *                                                                    *
     C     ZDATE1        BEGSR
      *
     C                   MOVE      ZDATE         ZDATEA
      *
     C                   CALLB     'ZDATE1'
     C                   PARM                    ZDATEA            6
     C                   PARM                    ZDAYNO            5 0
     C                   PARM                    BJDFIN
     C                   PARM                    ErrorFlag         1
 
     C                   ENDSR
      **********************************************************************
      /EJECT
      **********************************************************************
      *                                                                    *
      *  This subroutine is to cater for the fact that standard subroutine *
      *   ZYLD in this module executes another standard subroutine,        *
      *   ZDAYS, which has also been converted to a module.                *
      *  This subroutine is also called ZDAYS and simply does a CALLB to   *
      *   the module that contains subroutine ZDAYS                        *
      *                                                                    *
     C     ZDAYS         BEGSR
 
     C                   CALLB     'ZDAYS'
     C                   PARM                    ZSDATE            5 0
     C                   PARM                    ZEDATE            5 0
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
     C                   PARM                    ZDDAYS            5 0
     C                   PARM                    ZODNAT            2 0          149162
 
     C                   ENDSR
      **********************************************************************
      /EJECT
      **********************************************************************
      *                                                                    *
      *  This subroutine is to cater for the fact that standard subroutine *
      *   ZYLD in this module executes another standard subroutine,        *
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
     C                   PARM                    NCD
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
      *   ZYLD in this module executes another standard subroutine,        *
      *   ZCNSD, which has also been converted to a module.                *
      *  This subroutine is also called ZCNSD and simply does a CALLB to   *
      *   the module that contains subroutine ZCNSD                        *
      *                                                                    *
     C     ZCNSD         BEGSR
 
     C                   CALLB     'ZCNSD'
     C                   PARM                    ZNOML
     C                   PARM                    ZPRC             16 9
     C                   PARM                    SPBS
     C                   PARM                    NMDP
     C                   PARM                    NomCcyDec
     C                   PARM                    ZCONS            15 0
 
     C                   ENDSR
      **********************************************************************
      /EJECT
      **********************************************************************
      *                                                                    *
      *  This subroutine is to cater for the fact that standard subroutine *
      *   ZYLD in this module executes another standard subroutine,        *
      *   ZCALCD, which has also been converted to a module.               *
      *  This subroutine is also called ZCALCD and simply does a CALLB to  *
      *   the module that contains subroutine ZCALCD                       *
      *                                                                    *
     C     ZCALCD        BEGSR
 
     C                   CALLB     'ZCALCD'
     C                   PARM                    ZNOML
     C                   PARM                    ZPNPL
     C                   PARM                    ZCONS
     C                   PARM                    ZFDATE
     C                   PARM                    ZPRCIN
     C                   PARM                    CUMEXF
     C                   PARM                    PURINT
     C                   PARM                    SECTY
     C                   PARM                    DADJN
     C                   PARM                    NomCcyDec
     C                   PARM                    PROT
     C                   PARM                    BJDFIN
     C                   PARM                    PRICEC
 
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
 
      ** Calculation Type (1A)
      ** Price Value for yield calculation (15P 9)
      ** Yield Value for price calculation (15P 9)
      ** Value date (5P 0)
     C                   PARM                    CTYPE             1
     C                   PARM                    PPARM            15 9
     C                   PARM                    YPARM            15 9
     C                   PARM                    VDATE             5 0
 
      ** Security Details
      ** interest days adjustment
      ** Nominal currency decimal places  (1P 0)
      ** Processing type (1A)
     C                   PARM                    SECTY
     C                   PARM                    DADJN             1
     C                   PARM                    NomCcyDec         1 0
     C                   PARM                    PROT              1
 
      ** Nominal (15P 0)
      ** Purchased interest (15P 9)
      ** Cum/Ex-coupon indicator (1A)
     C                   PARM                    ZNOML            15 0
     C                   PARM                    WRKPI            15 9
     C                   PARM                    SCUMEX            1
 
      ** System Info
      ** Date format (1A)
     C                   PARM                    BJDFIN            1
 
      * OUTPUTS
 
      ** Yield Ok indicator (1A)
      ** Yield information DS
     C                   PARM                    ZYLDOk            1
     C                   PARM                    ZPARMS
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
      *                                                                                       207543
     C                   CALLB     'AOSARDR0'                                                 207543
     C                   PARM      *BLANKS       @RTCD                                        207543
     C                   PARM      '*VERIFY'     @OPTN                                        207543
     C                   PARM      'CEU018'      @SARD                                        207543
     C     SCSARD        PARM      SCSARD        DSFDY                                        207543
      *                                                                                       207543
     C     @RTCD         IFEQ      *BLANK                                                     207543
     C                   MOVEL     'Y'           CEU018            1                          207543
     C                   ELSE                                                                 207543
     C                   MOVEL     'N'           CEU018                                       207543
     C                   END                                                                  207543
 
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
