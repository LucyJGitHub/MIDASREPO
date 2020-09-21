     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas ZA calc. accrued int. to a specified date')      *
      *****************************************************************
      *                                                               *
      *  Midas - Copy Source converted into ILE procedures            *
      *                                                               *
      *  ZACCZ   -   Calculate accrued interest to a specified date   *
      *                                                               *
      *  This module is an ILE/RPG IV conversion of the ZACCZ         *
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
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CRE073             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CSE075             Date 17Nov05               *
      *                 CSE071             Date 19Jul05               *
      *                 CAS006             Date 21Jan03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CSE031             Date 13Dec01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CSD006             Date 11Oct00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CAP137             Date 07Feb00               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CPL002             Date 08Mar99               *
      *                 CAP002  *CREATE    Date 21Apr98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *             (Recompile)                                       *
      *  MD046248 - Finastra Rebranding                               *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSE075 - US Enhanced Treasury Upgrade to MidasPlus           *
      *           (Recompile)                                         *
      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
      *  CAS006 - Hedge Accounting Phase B (Recompile)                *
      *  CSE031 - Coupon Fixing for Floating Rate Notes.              *
      *           Recompiled due to changes in SECTYD.                *
      *  CSD006 - Recompiled over changed SECTYD.                     *
      *  CAP137 - Conversion of SE Security inputs into modular       *
      *           structure to use as APIs (SECTYD)                   *
      *  CPL002 - Midas-Plato Interface (Recompiled)                  *
      *  CAP002 - Conversion of Midas inputs to modular API structure *
      *                                                               *
      *****************************************************************
 
      *  Logical files used by the standard subroutine
     FSEDEV     IF   E           K DISK
     FSECEO     IF   E           K DISK    RENAME(SEDEVDF:SEDEVDO)
     F                                     RENAME(SNDEVDF:SNDEVDO)
 
      ** +-----------------------------------------------------------------+
      ** Declares for variables that were defined externally for the
      ** original copy members
      ** +-----------------------------------------------------------------+
 
      ** Security Details
     D SECTY         E DS                  EXTNAME(SECTYD)
     D CDArr                 183    230
     D CRArr                 231    242
 
 
      ** INPUT
      ** -----
 
      * Principal amount
     D ZAMT            S             15P 0
      ** Interest days adjustment
     D  DADJN          S              1A
      ** Next Coupon Date
     D**NCD***         S              5P 0                                                    CSE031
     D  NextCoupDate   S              5P 0                                                    CSE031
      ** Nominal currency decimal places
     D NomCcyDec       S              1P 0
      * Procesing Type Indicator
     D  PROT           S              1A
      ** Date format
     D  BJDFIN         S              1A
 
      ** OUTPUT
      ** ------
     D  ZINTDD         S              5P 0
 
 
      ** OTHERS
      ** ------
     D  ZDDAYS         S              5P 0
 
     D  ZACCRD         S             15P 0
     D  ZACCXD         S             15P 1
     D  ZRP            S              1A
 
     D  ZCPNR          S             11P 7
     D  ZCFCT          S             10P 9
     D  ZPPCP          S             15P 0
     D  ZSFPP          S             15P 0
     D  ZPPDI          S              1A
     D  ZPROT          S              1A
     D  IRATE          S             15P 9
     D  ZSDATE         S              5P 0
     D  ZEDATE         S              5P 0
 
     ISEDEVDF
     I              RECI                        RECI_X
     I              NMCY                        NMCY_X
     ISEDEVDO
     I              RECI                        RECI_X
     I              NMCY                        NMCY_X
     ISNDEVDO
     I              RECI                        RECI_X
     I              MDTI                        MDTI_X
 
 
      ** +-----------------------------------------------------------------+
 
     C                   EXSR      ZACCZ
 
     C                   RETURN
      /EJECT
      ** +--- The converted ZACCZ1 starts here --------------------------+
 
      *****************************************************************
      **                                                             **
      ** ZACCZ  - Subroutine to calculate Accrued Interest between   **
      **          two specified Dates. (The Start Date will usually  **
      **          be a Coupon Payment Date or Initial Date).         **
      **                                                             **
      ** INPUT  - ZDCSDT (5,0)  Start Date                           **
      **          ZDCEDT (5,0)  End Date                             **
      **          ZAMT   (11,0) Nominal Amount (for ZACCR)           **
      **                                                             **
      ** READS  - SEDEV/SEDEVDF                                      **
      **          SECEO/SEDEVDO                                      **
      **          SECEO/SNDEVDO                                      **   E20568
      **                                                             **
      ** OUTPUT - ZDCINT (13,0) Accrued Interest                     **
      **          ZDXINT (15,1) Accrued Interest                     **   055420
      **                                                             **
      ** CALLS  - ZRATE  (Calculate Effective Interest Rate)         **
      **          ZACCR  (Calculate Accrued Interest)                **
      **                                                             **
      *****************************************************************
      **                                                             **
      ** LAST AMEND NO. 099886             DATE 17APR96              **
      ** PREV AMEND NO. 055420             DATE 24NOV93              **
      **                E21131             DATE 14FEB90              **
      **                E20568             DATE 08DEC89              **
      **                E20085             DATE 06NOV89              **
      **                                                             **
      *--------------------------------------------------------------**
      **                                                             **
      ** 099886 - Rounding problem for partly paid securities.       **
      **          Changed this routine to use 15,1 work field for    **
      **          calculation, and then round up to 15,0.            **
      ** 055420 - ROUNDING PROBLEM FOR MORTGAGE BACKED SECURITIES.   **   E20568
      ** E21131 - Incorrect interest calculation on discounts.       **   E20568
      ** E20568 - Read non-diary events file before diary events file**   E20568
      **          to pick up coupon rate, current factor and PP price**   E20568
      ** E20085 - Interest and Coupon Calculations Rewrite:          **   E20085
      **         - This subroutine has been rewritten to perform the **   E20085
      **           Interest Accrual calculations throughout the      **   E20085
      **           system. Numerous errors are corrected with this   **   E20085
      **           rewrite. It will be called from the routines and  **   E20085
      **           programs listed below.                            **   E20085
      **                                                             **
      *---------------------------------------------------------------*
      **                                                             **
      ** This Subroutine is called from:                             **
      **    Programs: SE0920, SE2210, SE2220, SE2270                 **
      **              ZACRBD, ZACRCD, ZACRFB, ZACRFC, ZACRFD,        **
      **              ZACCRC, ZACCRD.                                **
      **                                                             **
      ** Similar Subroutine: ZPCINT (for Input Cycle).               **
      ** Program SE0901 uses Internal SR based on this one.          **
      **                                                             **
      *****************************************************************
      *
     C     ZACCZ         BEGSR                                                  *** ZACCDC ***
      *
      ***  Define the Keylists for SEDEV/SEDEVDF and SECEO/SEDEVDO.
      ***  NOTE: SECEO is Keyed by Security/Event Type/REVERSE Date.
      *
     C     KZSEDF        KLIST
     C                   KFLD                    SESN
     C                   KFLD                    ZDCSDT
     C                   KFLD                    SDET
      *
     C     KZSEDO        KLIST
     C                   KFLD                    SESN
     C                   KFLD                    SDET
     C                   KFLD                    ZDCSDT
      *
      ***  Define the Input Date fields.
      *
     C                   Z-ADD     ZDCSDT        ZDCSDT            5 0
     C                   Z-ADD     ZDCEDT        ZDCEDT            5 0
      *
      ***  Define and zeroize the Accrued Interest Output field.
      *
     C                   Z-ADD     *ZEROS        ZDCINT           13 0
     C                   Z-ADD     *ZEROS        ZDXINT           15 1                         05542
      *
      ***  Initialize the fields that won't change that are required by
      ***  other Standard SRs that are called.
      *
     C                   MOVE      PPDI          ZPPDI
     C                   MOVE      PROT          ZPROT
     C                   Z-ADD     SFPP          ZSFPP
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
      *
     C                   Z-ADD     CPNR          IRATE
      *
      ***  Calculate the Accrued Interest
      *
     C                   Z-ADD     ZDCSDT        ZSDATE
     C                   Z-ADD     ZDCEDT        ZEDATE
      *
     C                   EXSR      ZACCR
     C                   Z-ADD     ZACCRD        ZDCINT
     C                   Z-ADD     ZACCXD        ZDXINT                                        05542
      *
      *---------------------------------------------------------------*
      ***  ELSE the Security may have Interest changes ...
      *
     C                   ELSE
      *
      ***  Initialize with the values from SECTYD.
      *
     C                   Z-ADD     CPNR          ZCPNR
     C                   Z-ADD     CFCT          ZCFCT
     C                   Z-ADD     *ZEROS        ZPPCP
     C                   MOVE      CPDP          ZPPCP
     C                   Z-ADD     0             SAVDT                                         E2113
      *                                                                   E20568
      ***  Defaults: The values on the Security File may have been        E20568
      ***  changed since the Start Date, so check the Security Non-Diary  E20568
      ***  Events File for each one.                                      E20568
      *                                                                   E20568
     C                   MOVE      'CP'          SDET                                          E2056
     C     KZSEDO        SETLL     SNDEVDO                                                     E2056
     C                   READ      SNDEVDO                                96                   E2056
     C     *IN96         IFEQ      '0'                                                         E2056
     C     SNSN          ANDEQ     SESN                                                        E2113
     C     SNET          ANDEQ     'CP'                                                        E2113
     C                   Z-ADD     SNDT          SAVDT             5 0                         E2113
     C                   Z-ADD     SNCR          ZCPNR                                         E2056
     C                   Z-ADD     SNCF          ZCFCT                                         E2056
     C                   MOVE      SNCP          ZPPCP                                         E2056
     C                   END                                                                   E2056
      *
      ***  Defaults: If no last coupon record exists then read            E20568
      ***  initial records from diary events file.                        E20568
      *
     C                   MOVE      'IR'          SDET
     C     KZSEDO        SETLL     SEDEVDO
     C                   READ      SEDEVDO                                96
     C     *IN96         IFEQ      '0'
     C     SDSN          ANDEQ     SESN
     C     SDET          ANDEQ     'IR'
     C     SDDT          ANDGE     SAVDT                                                       E2113
     C                   Z-ADD     SDNC          ZCPNR
     C                   END
      *
     C     PROT          IFEQ      '8'
     C                   MOVE      'MP'          SDET
     C     KZSEDO        SETLL     SEDEVDO
     C                   READ      SEDEVDO                                96
     C     *IN96         IFEQ      '0'
     C     SDSN          ANDEQ     SESN
     C     SDET          ANDEQ     'MP'
     C     SDDT          ANDGE     SAVDT                                                       E2113
     C                   Z-ADD     SDCP          ZCFCT
     C                   END
     C                   END
      *
     C     PPDI          IFEQ      'Y'
     C                   MOVE      'PP'          SDET
     C     KZSEDO        SETLL     SEDEVDO
     C                   READ      SEDEVDO                                96
     C     *IN96         IFEQ      '0'
     C     SDSN          ANDEQ     SESN
     C     SDET          ANDEQ     'PP'
     C     SDDT          ANDGE     SAVDT                                                       E2113
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
      ***  over the period from the Start Date to the End Date, taking
      ***  account of Event Types IR/MP/PP.
      *
     C                   Z-ADD     ZDCSDT        ZSDATE
      *
     C                   MOVE      'IR'          SDET
     C     KZSEDF        SETLL     SEDEVDF
     C     SESN          READE     SEDEVDF                                96
      *
     C     *IN96         DOWEQ     '0'
     C     SDED          ANDLT     ZDCEDT
      *
     C     SDET          IFEQ      'IR'
     C     SDET          OREQ      'MP'
     C     SDET          OREQ      'PP'
      *
      ***  Calculate the Accrued Interest UP TO the Event Date.
      *
     C                   Z-ADD     SDED          ZEDATE
     C                   EXSR      ZACCR
     C                   ADD       ZACCRD        ZDCINT
     C                   ADD       ZACCXD        ZDXINT                                        05542
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
      ***  Calculate the last bit of Accrued Interest up to End Date.
      *
     C                   Z-ADD     ZDCEDT        ZEDATE
     C                   EXSR      ZACCR
     C                   ADD       ZACCXD        ZDXINT                                        05542
     C                   Z-ADD(H)  ZDXINT        ZDCINT                                        09988
      *
     C                   END
      *
     C                   ENDSR
      *
      *****************************************************************
 
      ** +--- The converted ZACCZ1 ends here ----------------------------+
      /EJECT
      **********************************************************************
      *                                                                    *
      *  This subroutine is to cater for the fact that standard subroutine *
      *   ZACCZ in this module executes another standard subroutine,       *
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
     C*****              PARM                    NCD                                          CSE031
     C                   PARM                    NextCoupDate                                 CSE031
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
      *   ZACCZ in this module executes another standard subroutine,       *
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
 
     C     *ENTRY        PLIST
 
      * INPUTS
 
      ** Nominal Amount (11P 0)
      ** Start Date (5P 0)
      ** End Date (5P 0)
     C                   PARM                    ZAMT
     C                   PARM                    ZDCSDT
     C                   PARM                    ZDCEDT
      *
      ** Security Details
      ** interest days adjustment
      ** Next Coupon Date (5P 0)
      ** Nominal currency decimal places (1P 0)
      ** Processing Type (1A)
     C                   PARM                    SECTY
     C                   PARM                    DADJN
     C*****              PARM                    NCD                                          CSE031
     C                   PARM                    NextCoupDate                                 CSE031
     C                   PARM                    NomCcyDec
     C                   PARM                    PROT
      *
      ** System Date Format (1A)
     C                   PARM                    BJDFIN
 
      * OUTPUTS
 
      ** Accrued Interest  (13P 0)
      ** Accrued Interest  (15P 1)
      ** No. of days (ZDAYS output)
      ** No. of days in interest year (ZDYYR output)
     C                   PARM                    ZDCINT
     C                   PARM                    ZDXINT
     C                   PARM                    ZDDAYS
     C                   PARM                    ZINTDD
 
     C                   ENDSR
      *****************************************************************
