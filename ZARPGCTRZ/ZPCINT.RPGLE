     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas ZA Calculate purchased interest on gvade')       *
      *****************************************************************
      *                                                               *
      *  Midas - Copy Source converted into ILE procedures            *
      *                                                               *
      *  ZPCINT  -   Calculate purchased interest on trade            *
      *                                                               *
      *  This module is an ILE/RPG IV conversion of the ZPCINT        *
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
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CRE073             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      *                 230608             Date 01Dec06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG11193           Date 02May06               *
      *                 BUG11009           Date 30Mar06               *
      *                 CSD027             Date 09Dec05               *
      *                 CSE075             Date 17Nov05               *
      *                 233881             Date 02Jun05               *
      *                 CGL031             Date 05Jul04               *
      *                 CSE071             Date 19Jul05               *
      *                 CAS006             Date 21Jan03               *
      *                 CSE037             Date 06Jun03               *
      *                 206316             Date 19Jul02               *
      * Midas Release 4.01.02 ----------------------------------------*
      *                 212939             Date 06Dec02               *
      *                 209875             Date 08Nov02               *
      * Midas Release 4.01 -------------------------------------------*
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
      *  MD046248 - Finastra Rebranding                               *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  230608 - OPEN file with different format                     *
      *  BUG11193 - Purchased Interest not calculated on BackValued   *
      *             Trade. (Recompile)                                *
      *  BUG11009 - Wrong calculation of purchased interest.          *
      *             Applied fix 231841.                               *
      *  CSE075 - US Enhanced Treasury Upgrade to MidasPlus           *
      *           (Recompile)                                         *
      *  233881 - EU Tax amount should be subtracted from the         *
      *           Countervalue.                                       *
      *  CGL031 - Taxation of Savings Income                          *
      *  CSE071 - Multiple Holidays Re Securities                     *
      *  CAS006 - Hedge Accounting Phase B (Recompile)                *
      *  CSE037 - Bond Pricing - 3 Decimal Places in Trades Input     *
      *  206316 - Recompiled over changed ZLCD.                       *
      *  212939 - Purchased interest is not recomputed if the value   *
      *           date of the trade is changed.                       *
      *  209875 - Purchase interest computed is wrong.  Last coupon   *
      *           date was taken from the coupon date array.  Fix is  *
      *           add coding to check if a CP event is existing in    *
      *           SNDEVD and use this date as the last coupon date.   *
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
 
     FSEDEV     IF   E           K DISK
     F***SECEO     IF   E           K DISK    RENAME(SEDEVDF:SEDEVDO)                         230608
     F***                                     RENAME(SNDEVDF:SNDEVDO)                         230608
     FSECEO4    IF   E           K DISK    RENAME(SEDEVDF:SEDEVDO)                            230608
     F                                     RENAME(SNDEVDF:SNDEVDO2)                           230608
     FSECEO3    IF   E           K DISK    RENAME(SEDEVDF:SEDEVDO2)                           230608
     F                                     RENAME(SNDEVDF:SNDEVDO)                            230608
 
      ** +-----------------------------------------------------------------+
      ** Declares for variables that were defined externally for the
      ** original copy members
      ** +-----------------------------------------------------------------+
 
     D LDA           E DS           256    EXTNAME(LDA) DTAARA(LDA)                         BUG11009
      ** The following fields are defined in the external file:                             BUG11009
      **                                    134 141 DBFile                                  BUG11009
      **                                    142 170 DBKey                                   BUG11009
      **                                    171 180 DBPgm                                   BUG11009
      **                                    181 1830DBase                                   BUG11009
      **                                    184 193 DBMod                                   BUG11009
      **                                    194 203 DBProc                                  BUG11009
      ** First DS for Access programs - short data structure                                  CSE037
     D DSFDY         E DS                  EXTNAME(DSFDY)                                     CSE037
                                                                                              CSE037
      **  Data structure for Switchable features                                              CSE037
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CSE037
     D                                     PREFIX(S_)                                         CSE037
      ** Security Details
     D SECTY         E DS                  EXTNAME(SECTYD)
     D CDArr                 183    230
     D CRArr                 231    242
 
 
     D POWER8          S              8  4 DIM(8) CTDATA PERRCD(1)
 
 
      ** Input fields
 
      ** Interest days adjustment
     D  DADJN          S              1A
      ** Nominal currency decimal places
     D NomCcyDec       S              1P 0
      ** Processing type
     D PROT            S              1A
 
      ** Nominal
     D  NOML           S             11P 0
      ** Accrued indicator
     D  ZACIN          S              1A
      ** Day adjustment
     D  ZDADJ          S              3P 0
      ** Actual Difference indicator
     D  ZADIN          S              1A
      ** Coupon rate (trade)
     D TDCR            S             11P 7
      ** Overide Indicator
     D  ZCPOVR         S              1A
      ** Date format
     D  BJDFIN         S              1A
      ** Event Control Date
     D  ECD            S              5P 0
 
      ** Working Variables
 
      ** Interest Accrued (1)   (ZACCR)
     D ZACCRD          S             15P 0
      ** Interest Accrued (2)   (ZACCR)
     D ZACCXD          S             15P 1
      ** Pay/Rec/Zero Indicator (ZACCR)
     D ZRP             S              1A
      ** Interest rate     (ZRATE)
     D  IRATE          S             15P 9
 
      ** Last Coupon Date before Control Date  (ZLCD)
     D  ZZLCD          S              5P 0
      ** Next Coupon Date (ZNCD)
     D**NCD********    S              5P 0                                                    CSE031
      ** Start date
     D  ZSDATE         S              5P 0
      ** End date
     D  ZEDATE         S              5P 0
      ** Principal amount
     D ZAMT            S             15P 0
 
 
      ** Interest work fields
     D  ZDDAYS         S              5P 0
     D  LCDD5          S              5P 0
 
     D  ZECD           S              5P 0
     D  ZINTDD         S              5P 0
 
     D  ZCPNR          S             11P 7
     D  ZCFCT          S             10P 9
     D  ZPPCP          S             15P 0
     D  ZPPDI          S              1A
     D  ZPROT          S              1A
     D  ZSFPP          S             15P 0
 
 
     ISEDEVDF
     I              RECI                        RECI_X
     I              NMCY                        NMCY_X
     I              SETX                        SETX_X                                        CGL031
     ISEDEVDO
     I              RECI                        RECI_X
     I              NMCY                        NMCY_X
     I              SETX                        SETX_X                                        233881
     ISNDEVDO
     I              RECI                        RECI_X
     I              MDTI                        MDTI_X
 
 
      ** Working Variables
      ** +-----------------------------------------------------------------+
 
      ** Nominal currency decimal places
 
     C                   Z-ADD     NomCcyDec     ZCDP              1 0
 
      ** Execute the standard subroutine
     C                   EXSR      ZPCINT
 
     C                   RETURN
      /EJECT
 
      ** +--- The converted ZPCINTZ1 starts here --------------------------+
      *****************************************************************
      **                                                             **
      ** ZPCINT - Subroutine to calculate the Purchased Interest     **
      **          on a Trade.                                        **
      **                                                             **
      ** INPUT  - ECD    (5,0)  Event Control Date.                  **
      **          NOML   (11,0) Nominal from Trade.                  **
      **          ZACIN  (1A)   Accrued Indicator.                   **
      **          ZDADJ  (3,0)  Days Adjustment.                     **
      **          ZADIN  (1A)   Actual/Difference Indicator.         **
      **          ZCPOVR (1A)   Coupon Rate overridden IF = 'Y'.     **
      **          TDCR   (11,7) Coupon Rate from Trade.              **
      **          ZCDP   (1,0)  Currency decimal places              **   S01117
      **          and various fields from Security.                  **
      **                                                             **
      ** OUTPUT - ZITRA  (13,0) Total Purchased Interest             **
      **          ZTINA  (13,0) Interest Adjustment                  **
      **                                                             **
      ** CALLS  - ZLCD   (Calculate Last Coupon Date)                **
      **          ZNCD   (Calculate Next Coupon Date)                **
      **          ZRATE  (Calculate Effective Interest Rate)         **
      **          ZACCR  (Calculate Accrued Interest)                **
      **          ZDYYR  (Calculate Number of days in Interest Year) **
      **                                                             **
      ** NOTE   - Should only be called for Interest Bearing         **
      **          Securities.                                        **
      **                                                             **
      *****************************************************************
      **                                                             **
      ** LAST AMEND NO. 099649             DATE 17APR96              **
      ** PREV AMEND NO. S01117             DATE 22JAN91              **
      **                E23204             DATE 06AUG90              **
      **                E21718             DATE 26APR90              **
      **                E20654             DATE 18DEC89              **
      **                E20085             DATE 06NOV89              **
      **                                                             **
      *---------------------------------------------------------------*
      **                                                             **
      ** 099649 - If day adjustment on the trade is the same as on   **
      **          the security, do not treat as an interest          **
      **          discrepancy.                                       **
      ** S01117 - SD New file changes (multibranching)               **
      ** E23204 - DIVIDE BY ZERO, Cause by E21718                    **
      ** E21718 - Days adjustment should be used separately to       **   E21718
      **          calculate interest using value date interest rate  **   E21718
      **          to avoid calculating interest for fewer days than  **   E21718
      **          entered if 30 day months are used and to avoid     **   E21718
      **          any difficulty with FRNs - (the user must override **   E21718
      **          purchase interest amount if necessary)             **   E21718
      ** E20654 - ITRA must be calculated for flat trades and        **   E20654
      **          Schuldshceins.                                     **   E20654
      ** E20085 - Interest and Coupon Calculations Rewrite - this    **   E20085
      **          is a rewrite of CPCINT and CPCADJ for Input Cycle. **   E20085
      **         - Interest Adjustments were not being calculated on **   E20085
      **           flat Trades.                                      **   E20085
      **         - Initial defaults were sometimes being calculated  **   E20085
      **           incorrectly.                                      **   E20085
      **         - Ex-Coupon calculation was incorrect and was also  **   E20085
      **           not being done the same way as COB does it.       **   E20085
      **         - fix to backvaluing into previous Coupon periods.  **   E20085
      **         - work on ZLCD/ZNCD.                                **   E20085
      **         - Generally: restructures the whole subroutine to   **   E20085
      **           make it correct, efficient and easy to read.      **   E20085
      **                                                             **
      *****************************************************************
      *
     C     ZPCINT        BEGSR                                                  *** ZPCINT ***
      *
      ***  Define the Keylists for SEDEV/SEDEVDF and SECEO/SEDEVDO.
      ***  NOTE: SECEO is Keyed by Security/Event Type/REVERSE Date.
      *
     C     KPSEDF        KLIST
     C                   KFLD                    SESN
     C                   KFLD                    ZZLCD
     C                   KFLD                    SDET
      *
     C     KPSEDO        KLIST
     C                   KFLD                    SESN
     C                   KFLD                    SDET
     C                   KFLD                    ZZLCD
      *                                                                                       209875
      ** Define the keylist for SNDEVDO in SECEO.                                             209875
      *                                                                                       209875
     C     KPSNDO        KLIST                                                                209875
     C                   KFLD                    SESN                                         209875
     C                   KFLD                    SNET                                         209875
     C                   KFLD                    SNDT                                         209875
      *
      ***  Define and zeroize the Purchased Interest and Interest
      ***  Adjustment Output fields and Interest work fields.
      *
     C                   Z-ADD     *ZEROS        ZITRA            13 0
     C                   Z-ADD     *ZEROS        ZTINA            13 0
     C                   Z-ADD     *ZEROS        ZADJ             13 0
     C                   Z-ADD     *ZEROS        ZCUM             13 0
     C                   Z-ADD     *ZEROS        ZEX              13 0
     C                   MOVE      ZACIN         ZACIN             1
     C                   Z-ADD     ZDADJ         ZDADJ             3 0
     C                   MOVE      ZADIN         ZADIN             1
     C                   MOVE      ZCPOVR        ZCPOVR            1
     C                   Z-ADD     IADJ          @IADJ             3 0                         09964
      *
      ***  Initialize the fields that won't change that are required by
      ***  other Standard SRs that are called.
      *
     C                   Z-ADD     NOML          ZAMT
     C                   MOVE      PPDI          ZPPDI
     C                   MOVE      PROT          ZPROT
     C                   Z-ADD     SFPP          ZSFPP
     C*                                                                   099649
     C***  The interest adjustment on the trade is used to determine      099649
     C***  whether the interest adjustment should be included in the      099649
     C***  purchase interest caluclation.                                 099649
     C*                                                                   099649
     C     ZDADJ         IFEQ      *ZEROS                                                      09964
     C                   Z-ADD     0             IADJ                                          09964
     C                   END                                                                   09964
     C*                                                                   099649
      *
      ***  If the Trade is Flat, or the Value Date of the Trade is Less
      ***  Than the Initial Date, Interest Accrual is zero, so set on
      ***  indicator 97. This will enable determination of the Interest
      ***  Rate as at Value Date, but will skip calculations of Accrued
      ***  Interest.
      *
     C     ECD           IFLT      ITLD                                                      E20654
     C                   SETON                                        97
     C                   ELSE
     C                   SETOFF                                       97
     C                   END
      *---------------------------------------------------------------*
      ***  Accrued Interest section                                   *
      *---------------------------------------------------------------*
      *
      ***  Determine Coupon Dates prior to and after the Value Date
      *
     C                   Z-ADD     ECD           ZECD
     C                   EXSR      ZLCD
      *****************************************************************              212939 BUG11193
      ***Store*the*value*of*Last*Change*Date*for*comparison*later.*****              212939 BUG11193
      *****************************************************************              212939 BUG11193
     C**********         Z-ADD     ZZLCD         ZZLCD1            5 0               212939 BUG11193
                                                                                              209875
      *                                                                                     BUG11009
      ** Verify and retrieve the correct last coupon date from file                         BUG11009
      ** SNDEVD if CSE031 is off or CSE031 is on and BCNV is blank.                         BUG11009
      *                                                                                     BUG11009
     C     CSE031        IFEQ      'N'                                                      BUG11009
     C     CSE031        OREQ      'Y'                                                      BUG11009
     C     BCNV          ANDEQ     'N'                                                      BUG11009
      *                                                                                       209875
      ** Check if previous settlement generated to ensure that                                209875
      ** the correct last coupon is passed in case the coupon date                            209875
      ** was amended after settlements had already been generated                             209875
      ** for original date.                                                                   209875
      *                                                                                       209875
     C                   MOVE      'CP'          SNET                                         209875
     C**********         MOVE      *HIVAL        SNDT                                209875 BUG11193
     C                   MOVE      ECD           SNDT                                       BUG11193
     C     KPSNDO        SETLL     SNDEVDO                                                    209875
     C                   READ      SNDEVDO                                60                  209875
     C     *IN60         IFEQ      '0'                                                        209875
     C     SNSN          ANDEQ     SESN                                                       209875
     C     SNET          ANDEQ     'CP'                                                       209875
     C                   Z-ADD     SNDT          ZZLCD                                        209875
     C                   ENDIF                                                                209875
      *                                                                                     BUG11009
     C                   ENDIF                                                              BUG11009
      *****************************************************************              212939 BUG11193
      ** Check*if*there*is*another*coupon*date*in*between*the*Value****              212939 BUG11193
      ***Date*and*the*Last*Change*Date*from*SNDEVD.********************              212939 BUG11193
      *****************************************************************              212939 BUG11193
     C******IN60         IFEQ      '0'                                               212939 BUG11193
     C*****ZZLCD1        IFGT      ZZLCD                                             212939 BUG11193
     C*****ZZLCD1        ANDLE     ECD                                               212939 BUG11193
     C**********         Z-ADD     ZZLCD1        ZZLCD                               212939 BUG11193
     C**********         ENDIF                                                       212939 BUG11193
     C**********         ENDIF                                                       212939 BUG11193
                                                                                              209875
     C                   EXSR      ZNCD
      *
      ***  If the Security has no interest changes ...
      *
     C     CPNR          IFNE      *ZEROS
     C     PPDI          ANDEQ     'N'
     C     PROT          ANDNE     '3'
     C     PROT          ANDNE     '5'
     C     PROT          ANDNE     '8'
      *
      ***  Set up the Interest Rate
      ***  Trade Coupon Rate contains either CPNR or the overridden,
      ***  Coupon Rate, as appropriate, so use TDCR.
      *
     C                   Z-ADD     TDCR          IRATE
      *
      ***  Calculate the Accrued Interest
      *
     C     *IN97         IFEQ      '0'
      *
      ***  Set up the Start and End Dates...
      ***  IF Cum-Coupon, just calculate from the Last Coupon Date to
      ***  the Event Control Date. For Ex-coupon, calculate on up to
      ***  the Next Coupon Date and subtract the Cum-Coupon portion.
      *
     C                   Z-ADD     ZZLCD         ZSDATE
     C                   Z-ADD     ECD           ZEDATE
     C                   EXSR      ZACCR
     C                   Z-ADD     ZACCRD        ZITRA
      *
     C     ZACIN         IFEQ      'X'
     C                   Z-ADD     ZZLCD         ZSDATE
     C                   Z-ADD     NCD           ZEDATE
     C                   EXSR      ZACCR
     C                   Z-ADD     ZACCRD        ZITRX            13 0
     C     ZITRA         SUB       ZITRX         ZITRA
     C                   END
      *
     C                   END
      *
      *---------------------------------------------------------------*
      ***  ELSE the Security may have Interest changes ...
      *
     C                   ELSE
      *
      ***  Initialize with the values from SECTYD.
      ***  But use Trade Coupon Rate, if overridden.
      *
     C     ZCPOVR        IFNE      'Y'
     C                   Z-ADD     CPNR          ZCPNR
     C                   ELSE
     C                   Z-ADD     TDCR          ZCPNR
     C                   END
      *
     C                   Z-ADD     CFCT          ZCFCT
     C                   Z-ADD     *ZEROS        ZPPCP
     C                   MOVE      CPDP          ZPPCP
      *
      ***  Defaults: The values on the Security File may have been
      ***  changed since Last Coupon prior to the Value Date of the
      ***  Trade, so check the Security Diary Events File for each one.
      *
     C     ZCPOVR        IFNE      'Y'
     C                   MOVE      'IR'          SDET
     C     KPSEDO        SETLL     SEDEVDO
     C                   READ      SEDEVDO                                96
      *
     C     *IN96         IFEQ      '0'
     C     SDSN          ANDEQ     SESN
     C     SDET          ANDEQ     'IR'
     C                   Z-ADD     SDNC          ZCPNR
     C                   END
     C                   END
      *
     C     PROT          IFEQ      '8'
     C                   MOVE      'MP'          SDET
     C     KPSEDO        SETLL     SEDEVDO
     C                   READ      SEDEVDO                                96
      *
     C     *IN96         IFEQ      '0'
     C     SDSN          ANDEQ     SESN
     C     SDET          ANDEQ     'MP'
     C                   Z-ADD     SDCP          ZCFCT
     C                   END
     C                   END
      *
     C     PPDI          IFEQ      'Y'
     C                   MOVE      'PP'          SDET
     C     KPSEDO        SETLL     SEDEVDO
     C                   READ      SEDEVDO                                96
      *
     C     *IN96         IFEQ      '0'
     C     SDSN          ANDEQ     SESN
     C     SDET          ANDEQ     'PP'
     C                   Z-ADD     *ZEROS        ZPPCP
     C                   MOVE      SDTP          ZPPCP
     C                   END
     C                   END
      *
      ***  Calculate the Effective Starting Interest Rate
      *
     C                   EXSR      ZRATE
      *
      *---------------------------------------------------------------*
      ***  Access the Security Diary Events File to accumulate interest
      ***  over the period from the Previous Coupon Date to the Event
      ***  Control Date, taking account of Event Types IR/MP/PP.
      *
     C                   Z-ADD     ZZLCD         ZSDATE
      *
     C                   MOVE      'IR'          SDET
     C     KPSEDF        SETLL     SEDEVDF
     C     SESN          READE     SEDEVDF                                96
      *
     C     *IN96         DOWEQ     '0'
     C     SDED          ANDLT     ECD
      *
     C     SDET          IFEQ      'IR'
     C     ZCPOVR        ANDNE     'Y'
     C     SDET          OREQ      'MP'
     C     SDET          OREQ      'PP'
      *
      ***  Calculate the Accrued Interest UP TO the Event Date.
      *
     C     *IN97         IFEQ      '0'
     C                   Z-ADD     SDED          ZEDATE
     C                   EXSR      ZACCR
     C                   ADD       ZACCRD        ZCUM
     C                   END
      *
      ***  Set the fields to the new values and calculate new Rate.
      ***  NOTE: New Rate affects the Period FROM the Event Date.
      ***  Only update the relevant field to the Event Type.
      *
     C     SDET          IFEQ      'IR'
     C                   Z-ADD     SDNC          ZCPNR
     C                   END
     C     SDET          IFEQ      'MP'
     C                   Z-ADD     SDCP          ZCFCT
     C                   END
     C     SDET          IFEQ      'PP'
     C                   Z-ADD     *ZEROS        ZPPCP
     C                   MOVE      SDTP          ZPPCP
     C                   END
      *
     C                   EXSR      ZRATE
     C                   Z-ADD     SDED          ZSDATE
      *
      ***  END of Event Types IR/MP/PP
     C                   END
      *
     C     SESN          READE     SEDEVDF                                96
     C                   END
      *
      ***  At this point, if Indicator 97 is on, we have the Effective
      ***  Interest Rate at the Event Control Date and can proceed to
      ***  the Interest Adjustment Section.
      *
      ***  If Indicator 97 is off we carry on with the Accrued Interest
      ***  calculation: Save the Interest as of the last Event Date for
      ***  Ex-Coupon calculation and then calculate the last bit of
      ***  the Cum-Coupon Accrued Interest up to Event Control Date.
      *
     C     *IN97         IFEQ      '0'
      *
     C                   Z-ADD     ZCUM          ZEX
      *
     C                   Z-ADD     ECD           ZEDATE
     C                   EXSR      ZACCR
     C                   ADD       ZACCRD        ZCUM
      *
      ***  If the Trade is Cum-Coupon, we now have the Accrued Interest
      ***  and can proceed to the Interest Adjustment Section, ELSE the
      ***  Trade must be Ex-Coupon so carry on calculating Accrued
      ***  Interest from where we left off up to the Next Coupon Date.
      *
     C     ZACIN         IFEQ      'C'
     C                   Z-ADD     ZCUM          ZITRA
     C                   ELSE
      *
     C     *IN96         DOWEQ     '0'
     C     SDED          ANDLT     NCD
      *
     C     SDET          IFEQ      'IR'
     C     ZCPOVR        ANDNE     'Y'
     C     SDET          OREQ      'MP'
     C     SDET          OREQ      'PP'
      *
      ***  Calculate the Accrued Interest up to the Event Date.
      *
     C                   Z-ADD     SDED          ZEDATE
     C                   EXSR      ZACCR
     C                   ADD       ZACCRD        ZEX
      *
      ***  Set the fields to the new values and calculate new Rate.
      ***  NOTE: New Rate affects the Period AFTER the Event Date.
      ***  Only update the relevant field to the Event Type as all the
      ***  other fields will be set to zero.
      *
     C     SDET          IFEQ      'IR'
     C                   Z-ADD     SDNC          ZCPNR
     C                   END
     C     SDET          IFEQ      'MP'
     C                   Z-ADD     SDCP          ZCFCT
     C                   END
     C     SDET          IFEQ      'PP'
     C                   Z-ADD     *ZEROS        ZPPCP
     C                   MOVE      SDTP          ZPPCP
     C                   END
      *
     C                   EXSR      ZRATE
     C                   Z-ADD     SDED          ZSDATE
      *
      ***  END of Event Types IR/MP/PP
     C                   END
      *
     C     SESN          READE     SEDEVDF                                96
     C                   END
      *
      ***  When all Events before Next Coupon Date have been processed,
      ***  calculate the last bit of Accrued Interest up to NCD.
      *
     C                   Z-ADD     NCD           ZEDATE
     C                   EXSR      ZACCR
     C                   ADD       ZACCRD        ZEX
      *
      ***  We now have the Total Accrued Interest from Last Coupon to
      ***  Next Coupon. The Ex-Coupon Purchased Interest is obtained by
      ***  subtracting the Cum-Coupon Accrued Interest from the Total.
      *
     C     ZCUM          SUB       ZEX           ZITRA
      *
     C                   END
     C                   END
     C                   END
     C*                                                                   099649
     C*** Only Calculate Interest Adjustment if it is different to        099649
     C*** the interest adjustment on the security.                        099649
     C*                                                                   099649
     C     ZDADJ         IFNE      *ZERO                                                       09964
     C                   SUB       IADJ          ZDADJ                                         09964
     C                   END                                                                   09964
      *
      *---------------------------------------------------------------*
      ***  Interest Adjustment Section (calculated as follows)        *
      *                                                               *
      *    Nominal amount * Current coupon * Days adjustment          *
      *    -------------------------------------------------          *
      *                Days in interest year * 100                    *
      *                                                               *
      *---------------------------------------------------------------*
      *
      ***  Calculate Interest Adjustment and new Purchased Interest.
      *
      *
      ***  Calculate the number of days in the Interest Year.             E23204
      *                                                                   E23204
     C                   EXSR      ZDYYR                                                       E2320
      *                                                                   E23204
      ***  Calculate Interest Adjustment and new Purchased Interest.      E23204
      *                                                                   E23204
     C     ZINTDD        IFNE      *ZEROS                                                      E2320
     C     ZDADJ         ANDNE     *ZEROS                                                      E2320
      *
     C     ZCDP          SUB       NMDP          DC                                            S0111
     C     DC            ADD       5             DC                1 0                         E2171
      *                                                                   E21718
     C     CSE037        IFEQ      'Y'                                                        CSE037
     C     PROT          IFNE      '5'                                                        CSE037
      *                                                                                       CSE037
      ** Changed to calculate the interest per 100 first rounded                              CSE037
      ** to no. of decimal places required by client                                          CSE037
      *                                                                                       CSE037
     C     IRATE         MULT(H)   ZDADJ         ZWAMT1           15 8                        CSE037
     C     ZWAMT1        DIV(H)    ZINTDD        ZWAMT1                                       CSE037
      *                                                                                       CSE037
      ** Adjust no. of decimal places                                                         CSE037
      *                                                                                       CSE037
     C                   MOVE      SESN          ZSESN            10                          CSE037
     C                   Z-ADD     ZWAMT1        ZINPF            15 8                        CSE037
     C                   Z-ADD     *ZEROS        ZOUTF            15 8                        CSE037
      *                                                                                       CSE037
     C                   CALLB     'SEADJPRI'                                                 CSE037
     C                   PARM      *BLANKS       @RTCD                                        CSE037
     C                   PARM      ZSESN         @SEKEY           10                          CSE037
     C     ZINPF         PARM      ZINPF         @INAMT           15 8                        CSE037
     C     ZOUTF         PARM      ZOUTF         @OUAMT           15 8                        CSE037
      *                                                                                       CSE037
     C     NCD           IFGE      MATY                                                       CSE037
     C     SYBS          ANDEQ     'AU'                                                       CSE037
     C                   Z-ADD     ZINPF         ZOUTF                                        CSE037
     C                   END                                                                  CSE037
      *                                                                                       CSE037
     C     ZAMT          MULT(H)   ZOUTF         ZWACCR           15 3                        CSE037
     C     ZWACCR        MULT(H)   POWER8(DC)    ZACCRD                                       CSE037
     C     ZACCRD        DIV(H)    100           ZACCRD                                       CSE037
      *                                                                                       CSE037
      ** If Yen Bond                                                                          CSE037
      *                                                                                       CSE037
     C                   ELSE                                                                 CSE037
      *                                                                                       CSE037
      ** Calc Factor                                                                          CSE037
      *                                                                                       CSE037
     C     IRATE         MULT(H)   ZDADJ         ZFAC1            15 8                        CSE037
     C     ZFAC1         DIV       ZINTDD        ZFAC1                                        CSE037
      *                                                                                       CSE037
      ** Adjust no. of decimal places                                                         CSE037
      *                                                                                       CSE037
     C                   MOVE      SESN          ZSESN                                        CSE037
     C                   Z-ADD     ZFAC1         ZINPF                                        CSE037
     C                   Z-ADD     *ZEROS        ZOUTF                                        CSE037
      *                                                                                       CSE037
     C                   CALLB     'SEADJPRI'                                                 CSE037
     C                   PARM      *BLANKS       @RTCD                                        CSE037
     C                   PARM      ZSESN         @SEKEY                                       CSE037
     C     ZINPF         PARM      ZINPF         @INAMT                                       CSE037
     C     ZOUTF         PARM      ZOUTF         @OUAMT                                       CSE037
      *                                                                                       CSE037
     C     NCD           IFGE      MATY                                                       CSE037
     C     SYBS          ANDEQ     'AU'                                                       CSE037
     C                   Z-ADD     ZINPF         ZOUTF                                        CSE037
     C                   ENDIF                                                                CSE037
      **  Calc. Interest                                                                      CSE037
     C     ZAMT          MULT(H)   ZOUTF         ZWACCR           15 3                        CSE037
      *                                                                                       CSE037
      ** Allow for ccy Dec Places                                                             CSE037
      *                                                                                       CSE037
     C     ZWACCR        MULT(H)   POWER8(DC)    ZACCRD                                       CSE037
     C     ZACCRD        DIV(H)    100           ZACCRD                                       CSE037
     C                   ENDIF                                                                CSE037
      *                                                                                       CSE037
     C                   ELSE                                                                 CSE037
      *                                                                                       CSE037
     C     PROT          IFNE      '5'                                                         E2171
     C     ZAMT          MULT(H)   IRATE         ZWMLT            15 0                         E2171
     C     ZWMLT         DIV       100           ZWAMT            15 2                         E2171
     C*                                                                   E21718
     C                   MULT      ZDADJ         ZWAMT                                         E2171
     C*                                                                   E21718
     C     ZINTDD        DIV       POWER8(DC)    ZDIV             15 6                         E2171
     C     ZWAMT         DIV(H)    ZDIV          ZACCRD                                        E2171
     C*                                                                   E21718
     C* If Yen Bond                                                       E21718
     C                   ELSE                                                                  E2171
     C*  Calc. Factor                                                     E21718
     C     IRATE         MULT      ZDADJ         ZFAC             15 7                         E2171
     C     ZFAC          DIV       ZINTDD        ZFAC                                          E2171
     C*  Calc. Interest                                                   E21718
     C     ZAMT          MULT(H)   ZFAC          ZWACCR           15 3                         E2171
     C*  Allow for ccy Dec Places                                         E21718
     C     ZWACCR        MULT      POWER8(DC)    ZACCRD                                        E2171
     C     ZACCRD        DIV       100           ZACCRD                                        E2171
     C                   END                                                                   E2171
      *
     C                   ENDIF                                                                CSE037
      *                                                                                       CSE037
     C     ZADIN         IFEQ      'D'
     C                   Z-ADD     ZACCRD        ZTINA
     C                   ADD       ZTINA         ZITRA
      *
      ***  ELSE Adjustment is Actual Interest Amount.
     C                   ELSE
     C     ZACCRD        SUB       ZITRA         ZTINA
     C                   Z-ADD     ZACCRD        ZITRA
     C                   END
      *
     C                   END
     C*                                                                   099649
     C                   Z-ADD     @IADJ         IADJ                                          09964
      *
     C                   ENDSR
      *
      *****************************************************************
      ** +--- The converted ZPCINTZ1 ends here ----------------------------+
 
      /EJECT
      **********************************************************************
      *                                                                    *
      *  This subroutine is to cater for the fact that standard subroutine *
      *   ZPCINT in this module executes another standard subroutine,      *
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
     C                   PARM                    ZINTDD
     C                   PARM                    LCDD5
 
     C                   ENDSR
      **********************************************************************
      /EJECT
      **********************************************************************
      *                                                                    *
      *  This subroutine is to cater for the fact that standard subroutine *
      *   ZPCINT in this module executes another standard subroutine,      *
      *   ZRATE, which has also been converted to a module.                *
      *  This subroutine is also called ZRATE and simply does a CALLB to   *
      *   the module that contains subroutine ZRATE                        *
      *                                                                    *
     C     ZRATE         BEGSR
 
     C                   CALLB     'ZRATE'
     C                   PARM                    ZCPNR
     C                   PARM                    ZPPDI
     C                   PARM                    ZPPCP
     C                   PARM                    ZSFPP
     C                   PARM                    ZPROT
     C                   PARM                    ZCFCT
     C                   PARM                    IRATE
 
     C                   ENDSR
      **********************************************************************
      /EJECT
      **********************************************************************
      *                                                                    *
      *  This subroutine is to cater for the fact that standard subroutine *
      *   ZPCINT in this module executes another standard subroutine,      *
      *   ZACCR, which has also been converted to a module.                *
      *  This subroutine is also called ZACCR and simply does a CALLB to   *
      *   the module that contains subroutine ZACCR                        *
      *                                                                    *
     C     ZACCR         BEGSR
 
     C                   CALLB     'ZACCR'
     C                   PARM                    ZAMT
     C                   PARM                    IRATE
     C                   PARM                    ZSDATE
     C                   PARM                    ZEDATE
     C                   PARM                    SECTY
     C                   PARM                    DADJN
     C                   PARM                    NCD
     C                   PARM                    NomCcyDec
     C                   PARM                    PROT
     C                   PARM                    BJDFIN
     C                   PARM                    ZACCRD
     C                   PARM                    ZACCXD
     C                   PARM                    ZRP
     C                   PARM                    ZDDAYS
     C                   PARM                    ZINTDD
 
     C                   ENDSR
      **********************************************************************
      /EJECT
      **********************************************************************
      *                                                                    *
      *  This subroutine is to cater for the fact that standard subroutine *
      *   ZPCINT in this module executes another standard subroutine,      *
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
     C                   PARM                    NMCY                                         CSE005
     C                   PARM                    SITP                                         CSE005
     C                   PARM                    BCNV                                         CSE005
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
      **********************************************************************
      *                                                                    *
      *  This subroutine is to cater for the fact that standard subroutine *
      *   ZPCINT in this module executes another standard subroutine,      *
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
 
      ** Security Details
      ** Interest days adjustment
      ** Nominal currency decimal places
      ** Processing type
     C                   PARM                    SECTY
     C                   PARM                    DADJN
     C                   PARM                    NomCcyDec
     C                   PARM                    PROT
      ** Nominal
      ** Accrued indicator
      ** Day adjustment
      ** Actual Difference indicator
      ** 'Trade' coupon rate
      ** Overide Indicator
     C                   PARM                    NOML
     C                   PARM                    ZACIN
     C                   PARM                    ZDADJ
     C                   PARM                    ZADIN
     C                   PARM                    TDCR
     C                   PARM                    ZCPOVR
 
      ** System Info
      ** Date format
      ** Event Control Date
     C                   PARM                    BJDFIN
     C                   PARM                    ECD
 
      * OUTPUTS
 
      ** Total Purchased Interest
      ** Interest Adjustment
     C                   PARM                    ZITRA
     C                   PARM                    ZTINA
                                                                                              CSE037
      ** Access SAR details file to determine if Countervalue                                 CSE037
      ** rounding processing is switched on                                                   CSE037
                                                                                              CSE037
     C                   CALLB     'AOSARDR0'                                                 CSE037
     C                   PARM      *BLANKS       @RTCD             7                          CSE037
     C                   PARM      '*VERIFY'     @OPTN             7                          CSE037
     C                   PARM      'CSE037'      @SARD             6                          CSE037
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSE037
     C     @RTCD         IFEQ      *BLANK                                                     CSE037
     C                   MOVEL     'Y'           CSE037            1                          CSE037
     C                   ELSE                                                                 CSE037
     C                   MOVEL     'N'           CSE037                                       CSE037
     C                   END                                                                  CSE037
      *                                                                                     BUG11009
      ** Check if CSE031 is installed                                                       BUG11009
      *                                                                                     BUG11009
     C                   CALLB     'AOSARDR0'                                               BUG11009
     C                   PARM      *BLANKS       @RTCD             7                        BUG11009
     C                   PARM      '*VERIFY'     @OPTN             7                        BUG11009
     C                   PARM      'CSE031'      @SARD             6                        BUG11009
     C                   PARM                    DSFDY                                      BUG11009
     C     @RTCD         IFEQ      *BLANK                                                   BUG11009
     C                   MOVE      'Y'           CSE031            1                        BUG11009
     C                   ELSE                                                               BUG11009
     C     @RTCD         IFEQ      '*NRF'                                                   BUG11009
     C                   MOVE      'N'           CSE031                                     BUG11009
     C                   ELSE                                                               BUG11009
      *                                                                                     BUG11009
      ** Database error                                                                     BUG11009
      *                                                                                     BUG11009
     C     *LOCK         IN        LDA                                                      BUG11009
     C                   MOVEL     'SCSARDPD'    DBFILE                                     BUG11009
     C                   MOVEL     '005'         DBASE                                      BUG11009
     C                   MOVEL     'CSE031'      DBKEY                                      BUG11009
     C                   OUT       LDA                                                      BUG11009
     C                   DUMP                                                               BUG11009
     C                   MOVE      '1'           *INLR                                      BUG11009
     C                   RETURN                                                             BUG11009
     C                   ENDIF                                                              BUG11009
     C                   ENDIF                                                              BUG11009
      *                                                                                     BUG11009
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
