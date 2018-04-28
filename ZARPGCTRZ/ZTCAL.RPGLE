     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas ZA Calculate tax on charges/commissions')
      *****************************************************************
      *                                                               *
      *  Midas - Copy Source converted into ILE procedures            *
      *                                                               *
      *  ZTCAL   -   Calculate Tax on Charges/Commissions             *
      *                                                               *
      *  This module is an ILE/RPG IV conversion of the ZTCAL         *
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
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *  Last Amend No. CAP003  *CREATE    Date 21Apr98               *
      *  Prev Amend No.                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CAP003 - Conversion of Midas inputs to modular API structure *
      *                                                               *
      *****************************************************************
 
      ** +-----------------------------------------------------------------+
      ** Declares for variables that were defined externally for the
      ** original copy members
      ** +-----------------------------------------------------------------+
 
      ** +--- The converted ZTCAL1Z1 starts here --------------------------+
     D ZRA             S             15  0 DIM(15)                              RANGE LIMITS
     D ZPC             S              7  4 DIM(15)                              PERCENTAGES
     D ZCG             S             15  0 DIM(15)                              FLAT CHARGES
      ** +--- The converted ZTCAL1Z1 ends here ----------------------------+
 
      ** +-----------------------------------------------------------------+
 
      ** Execute the standard subroutine
     C                   EXSR      ZTCAL1
 
     C                   RETURN
      /EJECT
 
      ** +--- The converted ZTCAL1Z2 starts here --------------------------+
 
     C********************************************************************
     C**
     C**   ZTCAL1 SR. TO CALCULATE TAX ON CHARGES/COMMISSIONS
     C**
     C********************************************************************
     C*                                                                  *
     C*  LAST AMEND NO. S01446             DATE 14OCT93                  *
     C*                                                                  *
     C*------------------------------------------------------------------*
     C*                                                                  *
     C*  S01446 - Customer Commissions (Courtage) enhancement:
     C*           Amended to cater for single charge currency            *
     C*                                                                  *
     C********************************************************************
     C*                                                                  *
     C**  ** INPUT CHARGE/COMMISSION AMOUNTS MUST BE SIGNED POSITIVE **
     C**
     C     ZTCAL1        BEGSR
     C*
     C*  WORK FIELDS
     C*
     C                   Z-ADD     *ZERO         ZZ                2 0
     C                   Z-ADD     *ZERO         ZAM0             15 0
     C                   Z-ADD     *ZERO         ZAM1             15 1
     C                   Z-ADD     *ZERO         ZAM2             15 2
     C                   Z-ADD     *ZERO         ZAM3             15 3
     C                   Z-ADD     *ZERO         ZCHG0            15 0
     C                   Z-ADD     *ZERO         ZCHG1            15 1
     C                   Z-ADD     *ZERO         ZCHG2            15 2
     C                   Z-ADD     *ZERO         ZCHG3            15 3
     C                   Z-ADD     *ZERO         ZCG0             15 0
     C                   Z-ADD     *ZERO         ZCG1             15 1
     C                   Z-ADD     *ZERO         ZCG2             15 2
     C                   Z-ADD     *ZERO         ZCG3             15 3
     C                   MOVEL     *BLANK        ZFLAG             1
     C                   MOVE      *BLANK        UZCCY             3                           S0144
     C                   MOVE      *ZERO         UZCDP             1 0                         S0144
     C                   MOVE      S01446        S01446            1                           S0144
     C*
     C*  INPUT PARAMETERS
     C*
     C* FROM THE CHARGE TYPES FILE
     C*
     C                   MOVE      ZCHGB         ZCHGB             1
     C                   MOVE      ZTHRI         ZTHRI             1
     C                   Z-ADD     ZRA           ZRA
     C                   Z-ADD     ZPC           ZPC
     C                   Z-ADD     ZCG           ZCG
     C                   Z-ADD     ZMNCH         ZMNCH            15 0
     C                   Z-ADD     ZMXCH         ZMXCH            15 0
     C*
     C* THE CHARGE/COMMISSION AMOUNT ON WHICH THE TAX IS TO BE LEVIED
     C* (ZCHGA) PLUS THE CHARGE CURRENCY NUMBER OF DECIMAL PLACES
     C*
     C                   Z-ADD     ZCHGA         ZCHGA            15 0
     C                   Z-ADD     ZDECS         ZDECS             1 0
     C*
     C*  OUTPUT PARAMETERS - THE TAX CALCULATED (ZTAXA)
     C*
     C                   Z-ADD     *ZERO         ZTAXA            15 0
      *                                                                   S01446
      *  Convert Charge Amount to nominal currency if S01446 is on the    S01446
      *  switchable features file and the Charge Currency on SE ICD is    S01446
      *  not blank                                                        S01446
      *                                                                   S01446
     C     S01446        IFEQ      'Y'                                                         S0144
     C     ZCCYI         ANDNE     *BLANK                                                      S0144
     C                   Z-ADD     ZCHGA         ZAMTCI                                        S0144
     C                   EXSR      ZCONV                                                       S0144
     C                   Z-ADD     ZAMTCO        ZCHGA                                         S0144
     C                   END                                                                   S0144
      *
      ** ADJUST CHARGE/COMMISSION AMOUNT IN FOR NO.OF DECIMAL PLACES
      *
     C     ZDECS         IFEQ      0
     C                   MOVE      ZCHGA         ZCHG0
     C                   END
      *
     C     ZDECS         IFEQ      1
     C                   MOVE      ZCHGA         ZCHG1
     C                   END
      *
     C     ZDECS         IFEQ      2
     C                   MOVE      ZCHGA         ZCHG2
     C                   END
      *
     C     ZDECS         IFEQ      3
     C                   MOVE      ZCHGA         ZCHG3
     C                   END
     C*------------------------------------------------------------------*
     C*------------------------------------------------------------------*
     C*
     C*  CALCULATE FLAT TAX
     C*
     C*------------------------------------------------------------------*
     C*------------------------------------------------------------------*
     C     ZCHGB         IFEQ      'F'
     C                   Z-ADD     *ZEROS        ZZ
     C*
     C*  LOOP UNTIL LIMIT FOUND
     C*
     C                   MOVE      *BLANK        ZFLAG
     C     ZFLAG         DOUEQ     'Y'
     C                   ADD       1             ZZ
     C*
     C*  RANGE NUMBER REACHES THE LIMIT
     C*
     C     ZZ            IFEQ      15
     C                   MOVE      'Y'           ZFLAG
     C                   END
     C*
     C*  CHARGE/COMMISSION AMOUNT LESS THAN RANGE LIMIT
     C*
     C     ZCHGA         IFLE      ZRA(ZZ)
     C                   MOVE      'Y'           ZFLAG
     C                   END
     C*
     C*  RANGE LIMIT IS ZERO
     C*
     C     ZRA(ZZ)       IFEQ      *ZERO
     C                   MOVE      'Y'           ZFLAG
     C                   END
     C*
     C                   END
     C*
     C*  ADD FLAT RATE TO WORK FIELD
     C*
     C                   Z-ADD     ZCG(ZZ)       ZTAXA
     C                   END
     C*------------------------------------------------------------------*
     C*------------------------------------------------------------------*
     C*
     C*  CALCULATE Threshold BASED TAXES
     C*
     C*------------------------------------------------------------------*
     C*------------------------------------------------------------------*
     C     ZCHGB         IFNE      'F'
     C     ZTHRI         ANDEQ     'Y'
     C                   Z-ADD     *ZEROS        ZZ
     C*
     C*  LOOP UNTIL LIMIT FOUND
     C*
     C                   MOVE      *BLANK        ZFLAG
     C     ZFLAG         DOUEQ     'Y'
     C                   ADD       1             ZZ
     C*
     C*  RANGE NUMBER REACHES THE LIMIT
     C*
     C     ZZ            IFEQ      15
     C                   MOVE      'Y'           ZFLAG
     C                   END
     C*
     C*  CHARGE/COMMISSION AMOUNT LESS THAN RANGE LIMIT
     C*
     C     ZCHGA         IFLE      ZRA(ZZ)
     C                   MOVE      'Y'           ZFLAG
     C                   END
     C*
     C*  RANGE LIMIT IS ZERO
     C*
     C     ZRA(ZZ)       IFEQ      *ZEROS
     C                   MOVE      'Y'           ZFLAG
     C                   END
     C*
     C                   END
     C*
     C*  CALCULATE AMOUNT
     C*
     C     ZDECS         IFEQ      0
     C     ZCHG0         MULT      ZPC(ZZ)       ZAM0
     C                   DIV(H)    100           ZAM0
     C                   MOVE      ZCG(ZZ)       ZCG0
     C                   ADD       ZCG0          ZAM0
     C                   MOVE      ZAM0          ZTAXA
     C                   END
     C*
     C     ZDECS         IFEQ      1
     C     ZCHG1         MULT      ZPC(ZZ)       ZAM1
     C                   DIV(H)    100           ZAM1
     C                   MOVE      ZCG(ZZ)       ZCG1
     C                   ADD       ZCG1          ZAM1
     C                   MOVE      ZAM1          ZTAXA
     C                   END
     C*
     C     ZDECS         IFEQ      2
     C     ZCHG2         MULT      ZPC(ZZ)       ZAM2
     C                   DIV(H)    100           ZAM2
     C                   MOVE      ZCG(ZZ)       ZCG2
     C                   ADD       ZCG2          ZAM2
     C                   MOVE      ZAM2          ZTAXA
     C                   END
     C*
     C     ZDECS         IFEQ      3
     C     ZCHG3         MULT      ZPC(ZZ)       ZAM3
     C                   DIV(H)    100           ZAM3
     C                   MOVE      ZCG(ZZ)       ZCG3
     C                   ADD       ZCG3          ZAM3
     C                   MOVE      ZAM3          ZTAXA
     C                   END
     C                   END
     C*------------------------------------------------------------------*
     C*------------------------------------------------------------------*
     C*
     C*  CALCULATE Tiered BASED TAXES
     C*
     C*------------------------------------------------------------------*
     C*------------------------------------------------------------------*
     C     ZCHGB         IFNE      'F'
     C     ZTHRI         ANDEQ     'N'
     C                   Z-ADD     *ZEROS        ZZ
     C*
     C*  LOOP UNTIL LIMIT FOUND
     C*
     C                   MOVE      *BLANK        ZFLAG
     C     ZFLAG         DOUEQ     'Y'
     C                   ADD       1             ZZ
     C*
     C*  RANGE NUMBER REACHES THE LIMIT
     C*
     C     ZZ            IFEQ      15
     C                   MOVE      'Y'           ZFLAG
     C                   END
     C*
     C*  CHARGE/COMMISSION AMOUNT LESS THAN RANGE LIMIT
     C*
     C     ZCHGA         IFLE      ZRA(ZZ)
     C                   MOVE      'Y'           ZFLAG
     C                   END
     C*
     C*  RANGE LIMIT IS ZERO
     C*
     C     ZRA(ZZ)       IFEQ      *ZEROS
     C                   MOVE      'Y'           ZFLAG
     C                   END
     C*
     C                   END
     C*
     C*  CALCULATE AMOUNT
     C*
     C                   EXSR      ZTCAL2
     C*
     C     ZDECS         IFEQ      0
     C                   MOVE      ZCG(ZZ)       ZCG0
     C                   ADD       ZCG0          ZAM0
     C                   MOVE      ZAM0          ZTAXA
     C                   END
     C*
     C     ZDECS         IFEQ      1
     C                   MOVE      ZCG(ZZ)       ZCG1
     C                   ADD       ZCG1          ZAM1
     C                   MOVE      ZAM1          ZTAXA
     C                   END
     C*
     C     ZDECS         IFEQ      2
     C                   MOVE      ZCG(ZZ)       ZCG2
     C                   ADD       ZCG2          ZAM2
     C                   MOVE      ZAM2          ZTAXA
     C                   END
     C*
     C     ZDECS         IFEQ      3
     C                   MOVE      ZCG(ZZ)       ZCG3
     C                   ADD       ZCG3          ZAM3
     C                   MOVE      ZAM3          ZTAXA
     C                   END
     C*
     C                   END
     C*
     C*  SET MINIMUM AMOUNT
     C*
     C     ZTAXA         IFLT      ZMNCH
     C                   Z-ADD     ZMNCH         ZTAXA
     C                   END
     C*
     C*  SET MAXIMUM AMOUNT
     C*
     C     ZMXCH         IFNE      *ZERO
     C     ZTAXA         ANDGT     ZMXCH
     C                   Z-ADD     ZMXCH         ZTAXA
     C                   END
      *                                                                   S01446
      *  Convert output amount to charge currency if S01446 is on the     S01446
      *  switchable features file and the Charge Currency on SE ICD is    S01446
      *  not blank                                                        S01446
      *                                                                   S01446
     C     S01446        IFEQ      'Y'                                                         S0144
     C     ZCCYI         ANDNE     *BLANK                                                      S0144
     C                   MOVE      ZCCYO         UZCCY                                         S0144
     C                   MOVE      ZCCYI         ZCCYO                                         S0144
     C                   MOVE      UZCCY         ZCCYI                                         S0144
     C                   MOVE      ZCDPO         UZCDP                                         S0144
     C                   MOVE      ZCDPI         ZCDPO                                         S0144
     C                   MOVE      UZCDP         ZCDPI                                         S0144
     C     ZMD           IFEQ      'M'                                                         S0144
     C                   MOVE      'D'           ZMD                                           S0144
     C                   ELSE                                                                  S0144
     C                   MOVE      'M'           ZMD                                           S0144
     C                   END                                                                   S0144
     C                   Z-ADD     ZTAXA         ZAMTCI                                        S0144
     C                   EXSR      ZCONV                                                       S0144
     C                   Z-ADD     ZAMTCO        ZTAXA                                         S0144
     C                   END                                                                   S0144
     C*
     C                   ENDSR
     C*
     C********************************************************************
 
      ** +--- The converted ZTCAL1Z2 ends here ----------------------------+
      /EJECT
      ** +--- The converted ZTCAL2Z1 starts here --------------------------+
 
     C********************************************************************
     C**
     C**   ZTCAL2 SR. TO CALCULATE TAX ON CHARGES/COMMISSIONS
     C**
     C     ZTCAL2        BEGSR
     C*
     C*  WORK FIELDS
     C*
     C                   Z-ADD     *ZEROS        ZAMTX            15 0
     C                   Z-ADD     *ZEROS        ZAMT0            15 0
     C                   Z-ADD     *ZEROS        ZAMT1            15 1
     C                   Z-ADD     *ZEROS        ZAMT2            15 2
     C                   Z-ADD     *ZEROS        ZAMT3            15 3
     C                   Z-ADD     *ZEROS        ZCN               2 0
     C                   Z-ADD     *ZEROS        ZCP               2 0
     C*
     C*  LOOP UNTIL ALL RANGES CONSIDERED
     C*
     C     ZCN           DOUEQ     ZZ
     C                   ADD       1             ZCN
     C     ZCN           SUB       1             ZCP
     C*
     C*  NO UPPER LIMITS
     C*
     C     ZRA(ZCN)      IFEQ      *ZEROS
     C     ZCN           ANDEQ     1
     C*
     C*  STRAIGHT % CALCULATED
     C*
     C     ZDECS         IFEQ      0
     C     ZCHG0         MULT      ZPC(ZZ)       ZAM0
     C                   DIV(H)    100           ZAM0
     C                   END
     C*
     C     ZDECS         IFEQ      1
     C     ZCHG1         MULT      ZPC(ZZ)       ZAM1
     C                   DIV(H)    100           ZAM1
     C                   END
     C*
     C     ZDECS         IFEQ      2
     C     ZCHG2         MULT      ZPC(ZZ)       ZAM2
     C                   DIV(H)    100           ZAM2
     C                   END
     C*
     C     ZDECS         IFEQ      3
     C     ZCHG3         MULT      ZPC(ZZ)       ZAM3
     C                   DIV(H)    100           ZAM3
     C                   END
     C*
     C                   GOTO      ZDAN
     C                   END
     C*
     C*  UPPER LIMIT ARRIVED AT.
     C*
     C     ZRA(ZCN)      IFEQ      *ZEROS
     C     ZCN           ANDNE     1
     C     ZCN           OREQ      15
     C*
     C*  FINAL % CALCULATED
     C*
     C     ZDECS         IFEQ      0
     C     ZCHGA         SUB       ZRA(ZCP)      ZAMTX
     C                   MOVE      ZAMTX         ZAMT0
     C                   MULT      ZPC(ZCN)      ZAMT0
     C                   DIV(H)    100           ZAMT0
     C                   ADD       ZAMT0         ZAM0
     C                   GOTO      ZDAN
     C                   END
     C*
     C     ZDECS         IFEQ      1
     C     ZCHGA         SUB       ZRA(ZCP)      ZAMTX
     C                   MOVE      ZAMTX         ZAMT1
     C                   MULT      ZPC(ZCN)      ZAMT1
     C                   DIV(H)    100           ZAMT1
     C                   ADD       ZAMT1         ZAM1
     C                   GOTO      ZDAN
     C                   END
     C*
     C     ZDECS         IFEQ      2
     C     ZCHGA         SUB       ZRA(ZCP)      ZAMTX
     C                   MOVE      ZAMTX         ZAMT2
     C                   MULT      ZPC(ZCN)      ZAMT2
     C                   DIV(H)    100           ZAMT2
     C                   ADD       ZAMT2         ZAM2
     C                   GOTO      ZDAN
     C                   END
     C*
     C     ZDECS         IFEQ      3
     C     ZCHGA         SUB       ZRA(ZCP)      ZAMTX
     C                   MOVE      ZAMTX         ZAMT3
     C                   MULT      ZPC(ZCN)      ZAMT3
     C                   DIV(H)    100           ZAMT3
     C                   ADD       ZAMT3         ZAM3
     C                   GOTO      ZDAN
     C                   END
     C*
     C                   END
     C*
     C*  CHECK FIRST RANGE CALCULATION
     C*
     C     ZRA(ZCN)      IFNE      *ZEROS
     C     ZCN           ANDEQ     1
     C*
     C     ZCHGA         IFGT      ZRA(1)
     C*
     C     ZDECS         IFEQ      0
     C                   MOVE      ZRA(1)        ZAMT0
     C     ZAMT0         MULT      ZPC(1)        ZAM0
     C                   DIV(H)    100           ZAM0
     C                   END
     C*
     C     ZDECS         IFEQ      1
     C                   MOVE      ZRA(1)        ZAMT1
     C     ZAMT1         MULT      ZPC(1)        ZAM1
     C                   DIV(H)    100           ZAM1
     C                   END
     C*
     C     ZDECS         IFEQ      2
     C                   MOVE      ZRA(1)        ZAMT2
     C     ZAMT2         MULT      ZPC(1)        ZAM2
     C                   DIV(H)    100           ZAM2
     C                   END
     C*
     C     ZDECS         IFEQ      3
     C                   MOVE      ZRA(1)        ZAMT3
     C     ZAMT3         MULT      ZPC(1)        ZAM3
     C                   DIV(H)    100           ZAM3
     C                   END
     C*
     C                   END
     C*
     C     ZCHGA         IFLE      ZRA(1)
     C*
     C     ZDECS         IFEQ      0
     C     ZCHG0         MULT      ZPC(1)        ZAM0
     C                   DIV(H)    100           ZAM0
     C                   GOTO      ZDAN
     C                   END
     C*
     C     ZDECS         IFEQ      1
     C     ZCHG1         MULT      ZPC(1)        ZAM1
     C                   DIV(H)    100           ZAM1
     C                   GOTO      ZDAN
     C                   END
     C*
     C     ZDECS         IFEQ      2
     C     ZCHG2         MULT      ZPC(1)        ZAM2
     C                   DIV(H)    100           ZAM2
     C                   GOTO      ZDAN
     C                   END
     C*
     C     ZDECS         IFEQ      3
     C     ZCHG3         MULT      ZPC(1)        ZAM3
     C                   DIV(H)    100           ZAM3
     C                   GOTO      ZDAN
     C                   END
     C*
     C                   END
     C*
     C                   END
     C*
     C*  ADD TO THE LOOP FOR MIDDLE VALUES
     C*
     C     ZRA(ZCN)      IFNE      *ZEROS
     C     ZCN           ANDNE     1
     C*
     C     ZCHGA         IFGT      ZRA(ZCN)
     C*
     C     ZDECS         IFEQ      0
     C     ZRA(ZCN)      SUB       ZRA(ZCP)      ZAMTX
     C                   MOVE      ZAMTX         ZAMT0
     C                   MULT      ZPC(ZCN)      ZAMT0
     C                   DIV(H)    100           ZAMT0
     C                   ADD       ZAMT0         ZAM0
     C                   END
     C*
     C     ZDECS         IFEQ      1
     C     ZRA(ZCN)      SUB       ZRA(ZCP)      ZAMTX
     C                   MOVE      ZAMTX         ZAMT1
     C                   MULT      ZPC(ZCN)      ZAMT1
     C                   DIV(H)    100           ZAMT1
     C                   ADD       ZAMT1         ZAM1
     C                   END
     C*
     C     ZDECS         IFEQ      2
     C     ZRA(ZCN)      SUB       ZRA(ZCP)      ZAMTX
     C                   MOVE      ZAMTX         ZAMT2
     C                   MULT      ZPC(ZCN)      ZAMT2
     C                   DIV(H)    100           ZAMT2
     C                   ADD       ZAMT2         ZAM2
     C                   END
     C*
     C     ZDECS         IFEQ      3
     C     ZRA(ZCN)      SUB       ZRA(ZCP)      ZAMTX
     C                   MOVE      ZAMTX         ZAMT3
     C                   MULT      ZPC(ZCN)      ZAMT3
     C                   DIV(H)    100           ZAMT3
     C                   ADD       ZAMT3         ZAM3
     C                   END
     C*
     C                   END
     C*
     C     ZCHGA         IFLE      ZRA(ZCN)
     C*
     C     ZDECS         IFEQ      0
     C     ZCHGA         SUB       ZRA(ZCP)      ZAMTX
     C                   MOVE      ZAMTX         ZAMT0
     C                   MULT      ZPC(ZCN)      ZAMT0
     C                   DIV(H)    100           ZAMT0
     C                   ADD       ZAMT0         ZAM0
     C                   GOTO      ZDAN
     C                   END
     C*
     C     ZDECS         IFEQ      1
     C     ZCHGA         SUB       ZRA(ZCP)      ZAMTX
     C                   MOVE      ZAMTX         ZAMT1
     C                   MULT      ZPC(ZCN)      ZAMT1
     C                   DIV(H)    100           ZAMT1
     C                   ADD       ZAMT1         ZAM1
     C                   GOTO      ZDAN
     C                   END
     C*
     C     ZDECS         IFEQ      2
     C     ZCHGA         SUB       ZRA(ZCP)      ZAMTX
     C                   MOVE      ZAMTX         ZAMT2
     C                   MULT      ZPC(ZCN)      ZAMT2
     C                   DIV(H)    100           ZAMT2
     C                   ADD       ZAMT2         ZAM2
     C                   GOTO      ZDAN
     C                   END
     C*
     C     ZDECS         IFEQ      3
     C     ZCHGA         SUB       ZRA(ZCP)      ZAMTX
     C                   MOVE      ZAMTX         ZAMT3
     C                   MULT      ZPC(ZCN)      ZAMT3
     C                   DIV(H)    100           ZAMT3
     C                   ADD       ZAMT3         ZAM3
     C                   GOTO      ZDAN
     C                   END
     C*
     C                   END
     C*
     C                   END
     C*
     C                   END
     C*
     C     ZDAN          ENDSR
     C*
     C********************************************************************
 
      ** +--- The converted ZTCAL2Z1 ends here ----------------------------+
 
      /EJECT
      **********************************************************************
      *                                                                    *
      *  This subroutine is to cater for the fact that standard subroutine *
      *   ZTCAL1 in this module executes another standard subroutine,      *
      *   ZCONV, which has also been converted to a module.                *
      *  This subroutine is also called ZCONV and simply does a CALLB to   *
      *   the module that contains subroutine ZCONV                        *
      *                                                                    *
      **********************************************************************
     C     ZCONV         BEGSR
 
     C                   CALLB     'ZCONV'
     C                   PARM                    ZAMTCI           15 0
     C                   PARM                    ZEXCH            13 8
     C                   PARM                    ZMD               1
     C                   PARM                    ZCCYI             3
     C                   PARM                    ZCCYO             3
     C                   PARM                    ZCDPI             1 0
     C                   PARM                    ZCDPO             1 0
      ***OUTPUT***
     C                   PARM                    ZAMTCO           15 0
 
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
 
      *
      * FROM THE CHARGE TYPES FILE
      *
     C                   PARM                    ZCHGB
     C                   PARM                    ZTHRI
     C                   PARM                    ZRA
     C                   PARM                    ZPC
     C                   PARM                    ZCG
     C                   PARM                    ZMNCH
     C                   PARM                    ZMXCH
      *
      * THE CHARGE/COMMISSION AMOUNT ON WHICH THE TAX IS TO BE LEVIED
      * (ZCHGA) PLUS THE CHARGE CURRENCY NUMBER OF DECIMAL PLACES
      *
     C                   PARM                    ZCHGA
     C                   PARM                    ZDECS
      *
      * EXCHANGE RATE, M/D IND, CURRENCIES & CURRENCY DECIMAL PLACES
      * FOR CHARGE CURRENCY TO NOMINAL CURRENCY CONVERSION
      *
     C                   PARM                    ZEXCH
     C                   PARM                    ZMD
     C                   PARM                    ZCCYI
     C                   PARM                    ZCCYO
     C                   PARM                    ZCDPI
     C                   PARM                    ZCDPO
      *
      *  New parameters for S01446
      *
     C                   PARM                    S01446
 
      * OUTPUTS
 
      * THE TAX CALCULATED (ZTAXA)
     C                   PARM                    ZTAXA
 
     C                   ENDSR
      *****************************************************************
