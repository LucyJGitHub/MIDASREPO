     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas ZA Calculate Charges/Commissions')
      *****************************************************************
      *                                                               *
      *  Midas - Copy Source converted into ILE procedures            *
      *                                                               *
      *  ZCCAL   -   Calculate Charges/Commissions                    *
      *                                                               *
      *  This module is an ILE/RPG IV conversion of the ZCCAL         *
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
 
      ** +--- The converted ZCCAL1Z1 starts here --------------------------+
     D ZRA             S             15  0 DIM(15)                              RANGE LIMITS
     D ZPC             S              7  4 DIM(15)                              PERCENTAGES
     D ZCG             S             15  0 DIM(15)                              FLAT CHARGES
      ** +--- The converted ZCCAL1Z1 ends here ----------------------------+
 
      ** +--- The converted ZPOWER8Z1 starts here -------------------------+
     D POWER8          S              8  4 DIM(8) CTDATA PERRCD(1)              POWER8 ARRAY
      ** +--- The converted ZPOWER8Z1 ends here ---------------------------+
 
      ** +-----------------------------------------------------------------+
 
      ** Execute the standard subroutine
     C                   EXSR      ZCCAL1
 
     C                   RETURN
      /EJECT
 
      ** +--- The converted ZCCAL1Z2 starts here --------------------------+
 
     C********************************************************************
     C**
     C**   ZCCAL1 SR. TO CALCULATE CHARGES/COMMISSIONS
     C**
     C********************************************************************
     C*                                                                  *
     C*  LAST AMEND NO. S01446             DATE 07OCT93                  *
     C*  PREV AMEND NO. 052254             DATE 07JAN94                  *
     C*             NO. E20232             DATE 11DEC89                  *
     C*                                                                  *
     C*------------------------------------------------------------------*
     C*                                                                  *
     C*  S01446 - Customer Commissions (Courtage) enhancement:
     C*           1) Accomodate new charge method 'I'                    *
     C*           2) Convert charges/commissions from charge to nominal  *
     C*              currency if charge currency used on SE ICD          *
     C*           3) New code for accumulation of consideration and      *
     C*              nominal amounts for adjusting commission for same   *
     C*              day trades                                          *
     C*           N.B. SE ICD (SDSTRDPD) file must be defined in the     *
     C*                program using this subroutine                     *
     C*                                                                  *
     C*  052254 - CURRENT FACTOR amended from 9,8 to 10,9                *
     C*                                                                  *
     C*  E20232 - Countervalue truncation error.                         *
     C*                                                                  *
     C********************************************************************
     C*
     C     ZCCAL1        BEGSR
     C*
     C*  WORK FIELDS
     C*
     C                   Z-ADD     *ZERO         ZZ                2 0
     C                   Z-ADD     *ZERO         ZAM0             15 0
     C                   Z-ADD     *ZERO         ZAM1             15 1
     C                   Z-ADD     *ZERO         ZAM2             15 2
     C                   Z-ADD     *ZERO         ZAM3             15 3
     C                   Z-ADD     *ZERO         ZCON0            15 0
     C                   Z-ADD     *ZERO         ZCON1            15 1
     C                   Z-ADD     *ZERO         ZCON2            15 2
     C                   Z-ADD     *ZERO         ZCON3            15 3
     C                   Z-ADD     *ZERO         ZCONS            15 0
     C                   Z-ADD     *ZERO         ZCG0             15 0
     C                   Z-ADD     *ZERO         ZCG1             15 1
     C                   Z-ADD     *ZERO         ZCG2             15 2
     C                   Z-ADD     *ZERO         ZCG3             15 3
     C                   Z-ADD     *ZERO         ZPRICX           15 0
     C                   Z-ADD     *ZEROS        ZNOMLX           15 0
     C                   MOVEL     *BLANK        ZFLAG             1
     C                   Z-ADD     *ZERO         X                 2 0                         S0144
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
     C* FROM THE TRADE/SECURITY
     C*
     C                   Z-ADD     ZNOML         ZNOML            15 0                         E2023
     C                   Z-ADD     ZPRICE        ZPRICE           15 8
     C                   Z-ADD     ZDECS         ZDECS             1 0
     C                   Z-ADD     ZNMDP         ZNMDP             1 0
     C                   MOVE      ZPROT         ZPROT             1
     C                   Z-ADD     ZTCFC         ZTCFC            10 9                         05225
     C                   MOVE      ZSPBS         ZSPBS             1
     C*                                                                   S01446
     C*  New parameters for S01446                                        S01446
     C*                                                                   S01446
     C                   Z-ADD     ZTCON         ZTCON            15 0                         S0144
     C                   Z-ADD     ZTNOM         ZTNOM            15 0                         S0144
     C                   Z-ADD     ZTPI          ZTPI             15 0                         S0144
     C                   MOVE      S01446        S01446            1                           S0144
     C*
     C*  OUTPUT PARAMETERS - CHARGE/COMMISSION AMOUNT CALCULATED
     C*
     C                   Z-ADD     *ZERO         ZCHGA            15 0
      *
      ** Calculate CONSIDERATION
      *
      *
     C     ZDECS         IFEQ      0
     C     ZNOML         MULT(H)   ZPRICE        ZCON0
      *
     C** If mortgage backed security then multiply by current factor
      *
     C     ZPROT         IFEQ      '8'
     C                   MULT      ZTCFC         ZCON0
     C                   END
      *
     C** If price is % basis divide by 100
      *
     C     ZSPBS         IFEQ      'P'
     C                   DIV(H)    100           ZCON0
     C                   END
      *
     C*  allow for nominal decimal places of security
      *
     C     5             SUB       ZNMDP         ZZ
     C                   MULT      POWER8(ZZ)    ZCON0
     C                   MOVE      ZCON0         ZCONS
      *                                                                   S01446
      *  Condition the following processing on whether Autocharges is     S01446
      *  switched on and whether the Customer Commissions (Courtage)      S01446
      *  enhancement is on the switchable features file                   S01446
      *                                                                   S01446
     C     BVACOP        IFEQ      'Y'                                                         S0144
     C     S01446        ANDEQ     'Y'                                                         S0144
      *                                                                   S01446
      *  If morgage backed security, multiply by current factor           S01446
      *                                                                   S01446
     C     ZPROT         IFEQ      '8'                                                         S0144
     C     ZTCON         MULT      ZTCFC         ZTCON                                         S0144
     C                   END                                                                   S0144
      *                                                                   S01446
      *  Accumulate Total Consideration and Total Nominal                 S01446
      *                                                                   S01446
     C     ZTCON         ADD       ZCONS         ZCONS                                         S0144
     C     ZTNOM         ADD       ZNOML         ZNOML                                         S0144
      *                                                                   S01446
      *  If Charge Basis is 'I' add Total Purchased Interest to           S01446
      *  consideration and set Charge Basis to 'C'                        S01446
      *                                                                   S01446
     C     ZCHGB         IFEQ      'I'                                                         S0144
     C     ZTPI          ADD       ZCONS         ZCONS                                         S0144
     C                   MOVE      'C'           ZCHGB                                         S0144
     C                   END                                                                   S0144
     C                   MOVE      ZCONS         ZCON0                                         S0144
     C                   END                                                                   S0144
     C                   END
      *
     C     ZDECS         IFEQ      1
     C     ZNOML         MULT(H)   ZPRICE        ZCON1
     C     ZPROT         IFEQ      '8'
     C                   MULT      ZTCFC         ZCON1
     C                   END
     C     ZSPBS         IFEQ      'P'
     C                   DIV(H)    100           ZCON1
     C                   END
     C     5             SUB       ZNMDP         ZZ
     C                   MULT      POWER8(ZZ)    ZCON1
     C                   MOVE      ZCON1         ZCONS
      *                                                                   S01446
      *  Condition the following processing on whether Autocharges is     S01446
      *  switched on and whether the Customer Commissions (Courtage)      S01446
      *  enhancement is on the switchable features file                   S01446
      *                                                                   S01446
     C     BVACOP        IFEQ      'Y'                                                         S0144
     C     S01446        ANDEQ     'Y'                                                         S0144
      *                                                                   S01446
      *  If morgage backed security, multiply by current factor           S01446
      *                                                                   S01446
     C     ZPROT         IFEQ      '8'                                                         S0144
     C     ZTCON         MULT      ZTCFC         ZTCON                                         S0144
     C                   END                                                                   S0144
      *                                                                   S01446
      *  Accumulate Total Consideration and Total Nominal                 S01446
      *                                                                   S01446
     C     ZTCON         ADD       ZCONS         ZCONS                                         S0144
     C     ZTNOM         ADD       ZNOML         ZNOML                                         S0144
      *                                                                   S01446
      *  If Charge Basis is 'I' add Total Purchased Interest to           S01446
      *  consideration and set Charge Basis to 'C'                        S01446
      *                                                                   S01446
     C     ZCHGB         IFEQ      'I'                                                         S0144
     C     ZTPI          ADD       ZCONS         ZCONS                                         S0144
     C                   MOVE      'C'           ZCHGB                                         S0144
     C                   END                                                                   S0144
     C                   MOVE      ZCONS         ZCON1                                         S0144
     C                   END                                                                   S0144
     C                   END
      *
     C     ZDECS         IFEQ      2
     C     ZNOML         MULT(H)   ZPRICE        ZCON2
     C     ZPROT         IFEQ      '8'
     C                   MULT      ZTCFC         ZCON2
     C                   END
     C     ZSPBS         IFEQ      'P'
     C                   DIV(H)    100           ZCON2
     C                   END
     C     5             SUB       ZNMDP         ZZ
     C                   MULT      POWER8(ZZ)    ZCON2
     C                   MOVE      ZCON2         ZCONS
      *                                                                   S01446
      *  Condition the following processing on whether Autocharges is     S01446
      *  switched on and whether the Customer Commissions (Courtage)      S01446
      *  enhancement is on the switchable features file                   S01446
      *                                                                   S01446
     C     BVACOP        IFEQ      'Y'                                                         S0144
     C     S01446        ANDEQ     'Y'                                                         S0144
      *                                                                   S01446
      *  If morgage backed security, multiply by current factor           S01446
      *                                                                   S01446
     C     ZPROT         IFEQ      '8'                                                         S0144
     C     ZTCON         MULT      ZTCFC         ZTCON                                         S0144
     C                   END                                                                   S0144
      *                                                                   S01446
      *  Accumulate Total Consideration and Total Nominal                 S01446
      *                                                                   S01446
     C     ZTCON         ADD       ZCONS         ZCONS                                         S0144
     C     ZTNOM         ADD       ZNOML         ZNOML                                         S0144
      *                                                                   S01446
      *  If Charge Basis is 'I' add Total Purchased Interest to           S01446
      *  consideration and set Charge Basis to 'C'                        S01446
      *                                                                   S01446
     C     ZCHGB         IFEQ      'I'                                                         S0144
     C     ZTPI          ADD       ZCONS         ZCONS                                         S0144
     C                   MOVE      'C'           ZCHGB                                         S0144
     C                   END                                                                   S0144
     C                   MOVE      ZCONS         ZCON2                                         S0144
     C                   END                                                                   S0144
     C                   END
      *
     C     ZDECS         IFEQ      3
     C     ZNOML         MULT(H)   ZPRICE        ZCON3
     C     ZPROT         IFEQ      '8'
     C                   MULT      ZTCFC         ZCON3
     C                   END
     C     ZSPBS         IFEQ      'P'
     C                   DIV(H)    100           ZCON3
     C                   END
     C     5             SUB       ZNMDP         ZZ
     C                   MULT      POWER8(ZZ)    ZCON3
     C                   MOVE      ZCON3         ZCONS
      *                                                                   S01446
      *  Condition the following processing on whether Autocharges is     S01446
      *  switched on and whether the Customer Commissions (Courtage)      S01446
      *  enhancement is on the switchable features file                   S01446
      *                                                                   S01446
     C     BVACOP        IFEQ      'Y'                                                         S0144
     C     S01446        ANDEQ     'Y'                                                         S0144
      *                                                                   S01446
      *  If morgage backed security, multiply by current factor           S01446
      *                                                                   S01446
     C     ZPROT         IFEQ      '8'                                                         S0144
     C     ZTCON         MULT      ZTCFC         ZTCON                                         S0144
     C                   END                                                                   S0144
      *                                                                   S01446
      *  Accumulate Total Consideration and Total Nominal                 S01446
      *                                                                   S01446
     C     ZTCON         ADD       ZCONS         ZCONS                                         S0144
     C     ZTNOM         ADD       ZNOML         ZNOML                                         S0144
      *                                                                   S01446
      *  If Charge Basis is 'I' add Total Purchased Interest to           S01446
      *  consideration and set Charge Basis to 'C'                        S01446
      *                                                                   S01446
     C     ZCHGB         IFEQ      'I'                                                         S0144
     C     ZTPI          ADD       ZCONS         ZCONS                                         S0144
     C                   MOVE      'C'           ZCHGB                                         S0144
     C                   END                                                                   S0144
     C                   MOVE      ZCONS         ZCON3                                         S0144
     C                   END                                                                   S0144
     C                   END
      *                                                                   S01446
      *  Convert upper range limit amounts and flat charge amounts        S01446
      *  into charge currency if the input currency is not blank          S01446
      *  Input currency is charge currency from SE ICD                    S01446
      *  (for switchable feature S01446)                                  S01446
      *                                                                   S01446
     C     S01446        IFEQ      'Y'                                                         S0144
     C     ZCCYI         ANDNE     *BLANK                                                      S0144
     C                   DO        15            X                                             S0144
     C     ZRA(X)        IFNE      *ZERO                                                       S0144
     C                   Z-ADD     ZRA(X)        ZAMTCI                                        S0144
     C                   EXSR      ZCONV                                                       S0144
     C                   Z-ADD     ZAMTCO        ZRA(X)                                        S0144
     C                   END                                                                   S0144
     C                   END                                                                   S0144
     C                   Z-ADD     *ZERO         X                                             S0144
     C                   DO        15            X                                             S0144
     C     ZCG(X)        IFNE      *ZERO                                                       S0144
     C                   Z-ADD     ZCG(X)        ZAMTCI                                        S0144
     C                   EXSR      ZCONV                                                       S0144
     C                   Z-ADD     ZAMTCO        ZCG(X)                                        S0144
     C                   END                                                                   S0144
     C                   END                                                                   S0144
     C                   END                                                                   S0144
     C*------------------------------------------------------------------*
     C*------------------------------------------------------------------*
     C*
     C*  CALCULATE FLAT CHARGES
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
     C*  CONSIDERATION LESS THAN RANGE LIMIT
     C*
     C     ZCONS         IFLE      ZRA(ZZ)
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
     C                   Z-ADD     ZCG(ZZ)       ZCHGA
     C                   END
     C*------------------------------------------------------------------*
     C*------------------------------------------------------------------*
     C*
     C*  CALCULATE PRICE CHARGE RATE
     C*
     C*------------------------------------------------------------------*
     C*------------------------------------------------------------------*
     C     ZCHGB         IFEQ      'P'
     C                   Z-ADD     *ZEROS        ZZ
     C                   MOVE      ZPRICE        ZPRICX
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
     C*  PRICE LESS THAN RANGE LIMIT
     C*
     C     ZPRICX        IFLE      ZRA(ZZ)
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
     C     ZCON0         MULT      ZPC(ZZ)       ZAM0
     C                   DIV(H)    100           ZAM0
     C                   MOVE      ZCG(ZZ)       ZCG0
     C                   ADD       ZCG0          ZAM0
     C                   MOVE      ZAM0          ZCHGA
     C                   END
     C*
     C     ZDECS         IFEQ      1
     C     ZCON1         MULT      ZPC(ZZ)       ZAM1
     C                   DIV(H)    100           ZAM1
     C                   MOVE      ZCG(ZZ)       ZCG1
     C                   ADD       ZCG1          ZAM1
     C                   MOVE      ZAM1          ZCHGA
     C                   END
     C*
     C     ZDECS         IFEQ      2
     C     ZCON2         MULT      ZPC(ZZ)       ZAM2
     C                   DIV(H)    100           ZAM2
     C                   MOVE      ZCG(ZZ)       ZCG2
     C                   ADD       ZCG2          ZAM2
     C                   MOVE      ZAM2          ZCHGA
     C                   END
     C*
     C     ZDECS         IFEQ      3
     C     ZCON3         MULT      ZPC(ZZ)       ZAM3
     C                   DIV(H)    100           ZAM3
     C                   MOVE      ZCG(ZZ)       ZCG3
     C                   ADD       ZCG3          ZAM3
     C                   MOVE      ZAM3          ZCHGA
     C                   END
     C*
     C                   END
     C*------------------------------------------------------------------*
     C*------------------------------------------------------------------*
     C*
     C*  CALCULATE CONSIDERATION/Threshold BASED CHARGES
     C*
     C*------------------------------------------------------------------*
     C*------------------------------------------------------------------*
     C     ZCHGB         IFEQ      'C'
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
     C*  CONSIDERATION LESS THAN RANGE LIMIT
     C*
     C     ZCONS         IFLE      ZRA(ZZ)
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
     C     ZCON0         MULT      ZPC(ZZ)       ZAM0
     C                   DIV(H)    100           ZAM0
     C                   MOVE      ZCG(ZZ)       ZCG0
     C                   ADD       ZCG0          ZAM0
     C                   MOVE      ZAM0          ZCHGA
     C                   END
     C*
     C     ZDECS         IFEQ      1
     C     ZCON1         MULT      ZPC(ZZ)       ZAM1
     C                   DIV(H)    100           ZAM1
     C                   MOVE      ZCG(ZZ)       ZCG1
     C                   ADD       ZCG1          ZAM1
     C                   MOVE      ZAM1          ZCHGA
     C                   END
     C*
     C     ZDECS         IFEQ      2
     C     ZCON2         MULT      ZPC(ZZ)       ZAM2
     C                   DIV(H)    100           ZAM2
     C                   MOVE      ZCG(ZZ)       ZCG2
     C                   ADD       ZCG2          ZAM2
     C                   MOVE      ZAM2          ZCHGA
     C                   END
     C*
     C     ZDECS         IFEQ      3
     C     ZCON3         MULT      ZPC(ZZ)       ZAM3
     C                   DIV(H)    100           ZAM3
     C                   MOVE      ZCG(ZZ)       ZCG3
     C                   ADD       ZCG3          ZAM3
     C                   MOVE      ZAM3          ZCHGA
     C                   END
     C                   END
     C*------------------------------------------------------------------*
     C*------------------------------------------------------------------*
     C*
     C*  CALCULATE CONSIDERATION/Tiered BASED CHARGES
     C*
     C*------------------------------------------------------------------*
     C*------------------------------------------------------------------*
     C     ZCHGB         IFEQ      'C'
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
     C*  CONSIDERATION LESS THAN RANGE LIMIT
     C*
     C     ZCONS         IFLE      ZRA(ZZ)
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
     C                   EXSR      ZCCAL2
     C*
     C     ZDECS         IFEQ      0
     C                   MOVE      ZCG(ZZ)       ZCG0
     C                   ADD       ZCG0          ZAM0
     C                   MOVE      ZAM0          ZCHGA
     C                   END
     C*
     C     ZDECS         IFEQ      1
     C                   MOVE      ZCG(ZZ)       ZCG1
     C                   ADD       ZCG1          ZAM1
     C                   MOVE      ZAM1          ZCHGA
     C                   END
     C*
     C     ZDECS         IFEQ      2
     C                   MOVE      ZCG(ZZ)       ZCG2
     C                   ADD       ZCG2          ZAM2
     C                   MOVE      ZAM2          ZCHGA
     C                   END
     C*
     C     ZDECS         IFEQ      3
     C                   MOVE      ZCG(ZZ)       ZCG3
     C                   ADD       ZCG3          ZAM3
     C                   MOVE      ZAM3          ZCHGA
     C                   END
     C*
     C                   END
     C*------------------------------------------------------------------*
     C*------------------------------------------------------------------*
     C*
     C*  CALCULATE NOMINAL/Threshold BASED CHARGES
     C*
     C*------------------------------------------------------------------*
     C*------------------------------------------------------------------*
     C     ZCHGB         IFEQ      'N'
     C     ZTHRI         ANDEQ     'Y'
     C*
     C** ADJUST FOR NOMINAL DEC.PLACES (IMPLICIT 4 D.P.s ON LF/SECGT)
     C*
     C     8             SUB       ZNMDP         ZZ
     C     ZNOML         MULT      POWER8(ZZ)    ZNOMLX
     C                   MULT      10            ZNOMLX
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
     C*  NOMINAL LESS THAN RANGE LIMIT
     C*
     C     ZNOMLX        IFLE      ZRA(ZZ)
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
     C     ZCON0         MULT      ZPC(ZZ)       ZAM0
     C                   DIV(H)    100           ZAM0
     C                   MOVE      ZCG(ZZ)       ZCG0
     C                   ADD       ZCG0          ZAM0
     C                   MOVE      ZAM0          ZCHGA
     C                   END
     C*
     C     ZDECS         IFEQ      1
     C     ZCON1         MULT      ZPC(ZZ)       ZAM1
     C                   DIV(H)    100           ZAM1
     C                   MOVE      ZCG(ZZ)       ZCG1
     C                   ADD       ZCG1          ZAM1
     C                   MOVE      ZAM1          ZCHGA
     C                   END
     C*
     C     ZDECS         IFEQ      2
     C     ZCON2         MULT      ZPC(ZZ)       ZAM2
     C                   DIV(H)    100           ZAM2
     C                   MOVE      ZCG(ZZ)       ZCG2
     C                   ADD       ZCG2          ZAM2
     C                   MOVE      ZAM2          ZCHGA
     C                   END
     C*
     C     ZDECS         IFEQ      3
     C     ZCON3         MULT      ZPC(ZZ)       ZAM3
     C                   DIV(H)    100           ZAM3
     C                   MOVE      ZCG(ZZ)       ZCG3
     C                   ADD       ZCG3          ZAM3
     C                   MOVE      ZAM3          ZCHGA
     C                   END
     C*
     C                   END
     C*------------------------------------------------------------------*
     C*------------------------------------------------------------------*
     C*
     C*  CALCULATE NOMINAL/Tiered BASED CHARGES
     C*
     C*------------------------------------------------------------------*
     C*------------------------------------------------------------------*
     C     ZCHGB         IFEQ      'N'
     C     ZTHRI         ANDEQ     'N'
     C*
     C** ADJUST FOR NOMINAL DEC.PLACES (IMPLICIT 4 D.P.s ON LF/SECGT)
     C*
     C     8             SUB       ZNMDP         ZZ
     C     ZNOML         MULT      POWER8(ZZ)    ZNOMLX
     C                   MULT      10            ZNOMLX
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
     C*  NOMINAL LESS THAN RANGE LIMIT
     C*
     C     ZNOMLX        IFLE      ZRA(ZZ)
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
     C                   EXSR      ZCCAL2
     C*
     C     ZDECS         IFEQ      0
     C                   MOVE      ZCG(ZZ)       ZCG0
     C                   ADD       ZCG0          ZAM0
     C                   MOVE      ZAM0          ZCHGA
     C                   END
     C*
     C     ZDECS         IFEQ      1
     C                   MOVE      ZCG(ZZ)       ZCG1
     C                   ADD       ZCG1          ZAM1
     C                   MOVE      ZAM1          ZCHGA
     C                   END
     C*
     C     ZDECS         IFEQ      2
     C                   MOVE      ZCG(ZZ)       ZCG2
     C                   ADD       ZCG2          ZAM2
     C                   MOVE      ZAM2          ZCHGA
     C                   END
     C*
     C     ZDECS         IFEQ      3
     C                   MOVE      ZCG(ZZ)       ZCG3
     C                   ADD       ZCG3          ZAM3
     C                   MOVE      ZAM3          ZCHGA
     C                   END
     C*
     C                   END
     C*                                                                   S01446
     C*  Convert minimum and maximum amounts to charge currency           S01446
     C*  if the input currency is not blank.                              S01446
     C*  Input currency is charge currency from SE ICD                    S01446
     C*  (for switchable feature S01446)                                  S01446
     C*                                                                   S01446
     C     S01446        IFEQ      'Y'                                                         S0144
     C     ZCCYI         ANDNE     *BLANK                                                      S0144
     C                   Z-ADD     ZMNCH         ZAMTCI                                        S0144
     C                   EXSR      ZCONV                                                       S0144
     C                   Z-ADD     ZAMTCO        ZMNCH                                         S0144
     C*                                                                   S01446
     C                   Z-ADD     ZMXCH         ZAMTCI                                        S0144
     C                   EXSR      ZCONV                                                       S0144
     C                   Z-ADD     ZAMTCO        ZMXCH                                         S0144
     C                   END                                                                   S0144
     C*
     C*  SET MINIMUM AMOUNT
     C*
     C     ZCHGA         IFLT      ZMNCH
     C                   Z-ADD     ZMNCH         ZCHGA
     C                   END
     C*
     C*  SET MAXIMUM AMOUNT
     C*
     C     ZMXCH         IFNE      *ZERO
     C     ZCHGA         ANDGT     ZMXCH
     C                   Z-ADD     ZMXCH         ZCHGA
     C                   END
     C*
     C                   ENDSR
     C*
     C********************************************************************
 
      ** +--- The converted ZCCAL1Z2 ends here ----------------------------+
      /EJECT
      ** +--- The converted ZCCAL2Z1 starts here --------------------------+
 
     C********************************************************************
     C**
     C**   ZCCAL2 SR. TO CALCULATE CHARGES/COMMISSIONS
     C**
     C     ZCCAL2        BEGSR
     C*
     C*  WORK FIELDS
     C*
     C                   Z-ADD     *ZEROS        ZW                2 0
     C                   Z-ADD     *ZEROS        ZAMTX            15 0
     C                   Z-ADD     *ZEROS        ZAMT0            15 0
     C                   Z-ADD     *ZEROS        ZAMT1            15 1
     C                   Z-ADD     *ZEROS        ZAMT2            15 2
     C                   Z-ADD     *ZEROS        ZAMT3            15 3
     C                   Z-ADD     *ZEROS        ZAMTXX           15 4
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
     C     ZCON0         MULT      ZPC(ZZ)       ZAM0
     C                   DIV(H)    100           ZAM0
     C                   END
     C*
     C     ZDECS         IFEQ      1
     C     ZCON1         MULT      ZPC(ZZ)       ZAM1
     C                   DIV(H)    100           ZAM1
     C                   END
     C*
     C     ZDECS         IFEQ      2
     C     ZCON2         MULT      ZPC(ZZ)       ZAM2
     C                   DIV(H)    100           ZAM2
     C                   END
     C*
     C     ZDECS         IFEQ      3
     C     ZCON3         MULT      ZPC(ZZ)       ZAM3
     C                   DIV(H)    100           ZAM3
     C                   END
     C*
     C                   GOTO      ZKYU
     C                   END
     C*
     C*  IF CHARGE BASIS IS 'C'
     C*
     C     ZCHGB         IFEQ      'C'
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
     C     ZCONS         SUB       ZRA(ZCP)      ZAMTX
     C                   MOVE      ZAMTX         ZAMT0
     C                   MULT      ZPC(ZCN)      ZAMT0
     C                   DIV(H)    100           ZAMT0
     C                   ADD       ZAMT0         ZAM0
     C                   GOTO      ZKYU
     C                   END
     C*
     C     ZDECS         IFEQ      1
     C     ZCONS         SUB       ZRA(ZCP)      ZAMTX
     C                   MOVE      ZAMTX         ZAMT1
     C                   MULT      ZPC(ZCN)      ZAMT1
     C                   DIV(H)    100           ZAMT1
     C                   ADD       ZAMT1         ZAM1
     C                   GOTO      ZKYU
     C                   END
     C*
     C     ZDECS         IFEQ      2
     C     ZCONS         SUB       ZRA(ZCP)      ZAMTX
     C                   MOVE      ZAMTX         ZAMT2
     C                   MULT      ZPC(ZCN)      ZAMT2
     C                   DIV(H)    100           ZAMT2
     C                   ADD       ZAMT2         ZAM2
     C                   GOTO      ZKYU
     C                   END
     C*
     C     ZDECS         IFEQ      3
     C     ZCONS         SUB       ZRA(ZCP)      ZAMTX
     C                   MOVE      ZAMTX         ZAMT3
     C                   MULT      ZPC(ZCN)      ZAMT3
     C                   DIV(H)    100           ZAMT3
     C                   ADD       ZAMT3         ZAM3
     C                   GOTO      ZKYU
     C                   END
     C*
     C                   END
     C*
     C*  CHECK FIRST RANGE CALCULATION
     C*
     C     ZRA(ZCN)      IFNE      *ZEROS
     C     ZCN           ANDEQ     1
     C*
     C     ZCONS         IFGT      ZRA(1)
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
     C     ZCONS         IFLE      ZRA(1)
     C*
     C     ZDECS         IFEQ      0
     C     ZCON0         MULT      ZPC(1)        ZAM0
     C                   DIV(H)    100           ZAM0
     C                   GOTO      ZKYU
     C                   END
     C*
     C     ZDECS         IFEQ      1
     C     ZCON1         MULT      ZPC(1)        ZAM1
     C                   DIV(H)    100           ZAM1
     C                   GOTO      ZKYU
     C                   END
     C*
     C     ZDECS         IFEQ      2
     C     ZCON2         MULT      ZPC(1)        ZAM2
     C                   DIV(H)    100           ZAM2
     C                   GOTO      ZKYU
     C                   END
     C*
     C     ZDECS         IFEQ      3
     C     ZCON3         MULT      ZPC(1)        ZAM3
     C                   DIV(H)    100           ZAM3
     C                   GOTO      ZKYU
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
     C     ZCONS         IFGT      ZRA(ZCN)
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
     C     ZCONS         IFLE      ZRA(ZCN)
     C*
     C     ZDECS         IFEQ      0
     C     ZCONS         SUB       ZRA(ZCP)      ZAMTX
     C                   MOVE      ZAMTX         ZAMT0
     C                   MULT      ZPC(ZCN)      ZAMT0
     C                   DIV(H)    100           ZAMT0
     C                   ADD       ZAMT0         ZAM0
     C                   GOTO      ZKYU
     C                   END
     C*
     C     ZDECS         IFEQ      1
     C     ZCONS         SUB       ZRA(ZCP)      ZAMTX
     C                   MOVE      ZAMTX         ZAMT1
     C                   MULT      ZPC(ZCN)      ZAMT1
     C                   DIV(H)    100           ZAMT1
     C                   ADD       ZAMT1         ZAM1
     C                   GOTO      ZKYU
     C                   END
     C*
     C     ZDECS         IFEQ      2
     C     ZCONS         SUB       ZRA(ZCP)      ZAMTX
     C                   MOVE      ZAMTX         ZAMT2
     C                   MULT      ZPC(ZCN)      ZAMT2
     C                   DIV(H)    100           ZAMT2
     C                   ADD       ZAMT2         ZAM2
     C                   GOTO      ZKYU
     C                   END
     C*
     C     ZDECS         IFEQ      3
     C     ZCONS         SUB       ZRA(ZCP)      ZAMTX
     C                   MOVE      ZAMTX         ZAMT3
     C                   MULT      ZPC(ZCN)      ZAMT3
     C                   DIV(H)    100           ZAMT3
     C                   ADD       ZAMT3         ZAM3
     C                   GOTO      ZKYU
     C                   END
     C*
     C                   END
     C*
     C                   END
     C*
     C                   END
     C*
     C*  IF CHARGE BASIS IS 'N'
     C*
     C     ZCHGB         IFEQ      'N'
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
     C     ZNOMLX        SUB       ZRA(ZCP)      ZAMTX
     C                   MOVE      ZAMTX         ZAMTXX
     C     ZAMTXX        MULT(H)   ZPRICE        ZAMT0
      *
     C** If mortgage backed security then multiply by current factor
      *
     C     ZPROT         IFEQ      '8'
     C                   MULT      ZTCFC         ZAMT0
     C                   END
      *
     C** If price is % basis divide by 100
      *
     C     ZSPBS         IFEQ      'P'
     C                   DIV(H)    100           ZAMT0
     C                   END
      *
     C                   MULT      ZPC(ZCN)      ZAMT0
     C                   DIV(H)    100           ZAMT0
     C                   ADD       ZAMT0         ZAM0
     C                   GOTO      ZKYU
     C                   END
     C*
     C     ZDECS         IFEQ      1
     C     ZNOMLX        SUB       ZRA(ZCP)      ZAMTX
     C                   MOVE      ZAMTX         ZAMTXX
     C     ZAMTXX        MULT(H)   ZPRICE        ZAMT1
     C     ZPROT         IFEQ      '8'
     C                   MULT      ZTCFC         ZAMT1
     C                   END
     C     ZSPBS         IFEQ      'P'
     C                   DIV(H)    100           ZAMT1
     C                   END
     C                   MULT      ZPC(ZCN)      ZAMT1
     C                   DIV(H)    100           ZAMT1
     C                   ADD       ZAMT1         ZAM1
     C                   GOTO      ZKYU
     C                   END
     C*
     C     ZDECS         IFEQ      2
     C     ZNOMLX        SUB       ZRA(ZCP)      ZAMTX
     C                   MOVE      ZAMTX         ZAMTXX
     C     ZAMTXX        MULT(H)   ZPRICE        ZAMT2
     C     ZPROT         IFEQ      '8'
     C                   MULT      ZTCFC         ZAMT2
     C                   END
     C     ZSPBS         IFEQ      'P'
     C                   DIV(H)    100           ZAMT2
     C                   END
     C                   MULT      ZPC(ZCN)      ZAMT2
     C                   DIV(H)    100           ZAMT2
     C                   ADD       ZAMT2         ZAM2
     C                   GOTO      ZKYU
     C                   END
     C*
     C     ZDECS         IFEQ      3
     C     ZNOMLX        SUB       ZRA(ZCP)      ZAMTX
     C                   MOVE      ZAMTX         ZAMTXX
     C     ZAMTXX        MULT(H)   ZPRICE        ZAMT3
     C     ZPROT         IFEQ      '8'
     C                   MULT      ZTCFC         ZAMT3
     C                   END
     C     ZSPBS         IFEQ      'P'
     C                   DIV(H)    100           ZAMT3
     C                   END
     C                   MULT      ZPC(ZCN)      ZAMT3
     C                   DIV(H)    100           ZAMT3
     C                   ADD       ZAMT3         ZAM3
     C                   GOTO      ZKYU
     C                   END
     C*
     C                   END
     C*
     C*  CHECK FIRST RANGE CALCULATION
     C*
     C     ZRA(ZCN)      IFNE      *ZEROS
     C     ZCN           ANDEQ     1
     C*
     C     ZNOMLX        IFGT      ZRA(1)
     C*
     C     ZDECS         IFEQ      0
     C                   MOVE      ZRA(1)        ZAMTXX
     C     ZAMTXX        MULT(H)   ZPRICE        ZAM0
     C     ZPROT         IFEQ      '8'
     C                   MULT      ZTCFC         ZAM0
     C                   END
     C     ZSPBS         IFEQ      'P'
     C                   DIV(H)    100           ZAM0
     C                   END
     C                   MULT      ZPC(1)        ZAM0
     C                   DIV(H)    100           ZAM0
     C                   END
     C*
     C     ZDECS         IFEQ      1
     C                   MOVE      ZRA(1)        ZAMTXX
     C     ZAMTXX        MULT(H)   ZPRICE        ZAM1
     C     ZPROT         IFEQ      '8'
     C                   MULT      ZTCFC         ZAM1
     C                   END
     C     ZSPBS         IFEQ      'P'
     C                   DIV(H)    100           ZAM1
     C                   END
     C                   MULT      ZPC(1)        ZAM1
     C                   DIV(H)    100           ZAM1
     C                   END
     C*
     C     ZDECS         IFEQ      2
     C                   MOVE      ZRA(1)        ZAMTXX
     C     ZAMTXX        MULT(H)   ZPRICE        ZAM2
     C     ZPROT         IFEQ      '8'
     C                   MULT      ZTCFC         ZAM2
     C                   END
     C     ZSPBS         IFEQ      'P'
     C                   DIV(H)    100           ZAM2
     C                   END
     C                   MULT      ZPC(1)        ZAM2
     C                   DIV(H)    100           ZAM2
     C                   END
     C*
     C     ZDECS         IFEQ      3
     C                   MOVE      ZRA(1)        ZAMTXX
     C     ZAMTXX        MULT(H)   ZPRICE        ZAM3
     C     ZPROT         IFEQ      '8'
     C                   MULT      ZTCFC         ZAM3
     C                   END
     C     ZSPBS         IFEQ      'P'
     C                   DIV(H)    100           ZAM3
     C                   END
     C                   MULT      ZPC(1)        ZAM3
     C                   DIV(H)    100           ZAM3
     C                   END
     C*
     C                   END
     C*
     C     ZNOMLX        IFLE      ZRA(1)
     C*
     C     ZDECS         IFEQ      0
     C     ZCON0         MULT      ZPC(1)        ZAM0
     C                   DIV(H)    100           ZAM0
     C                   GOTO      ZKYU
     C                   END
     C*
     C     ZDECS         IFEQ      1
     C     ZCON1         MULT      ZPC(1)        ZAM1
     C                   DIV(H)    100           ZAM1
     C                   GOTO      ZKYU
     C                   END
     C*
     C     ZDECS         IFEQ      2
     C     ZCON2         MULT      ZPC(1)        ZAM2
     C                   DIV(H)    100           ZAM2
     C                   GOTO      ZKYU
     C                   END
     C*
     C     ZDECS         IFEQ      3
     C     ZCON3         MULT      ZPC(1)        ZAM3
     C                   DIV(H)    100           ZAM3
     C                   GOTO      ZKYU
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
     C     ZNOMLX        IFGT      ZRA(ZCN)
     C*
     C     ZDECS         IFEQ      0
     C     ZRA(ZCN)      SUB       ZRA(ZCP)      ZAMTX
     C                   MOVE      ZAMTX         ZAMTXX
     C     ZAMTXX        MULT(H)   ZPRICE        ZAMT0
     C     ZPROT         IFEQ      '8'
     C                   MULT      ZTCFC         ZAMT0
     C                   END
     C     ZSPBS         IFEQ      'P'
     C                   DIV(H)    100           ZAMT0
     C                   END
     C                   MULT      ZPC(ZCN)      ZAMT0
     C                   DIV(H)    100           ZAMT0
     C                   ADD       ZAMT0         ZAM0
     C                   END
     C*
     C     ZDECS         IFEQ      1
     C     ZRA(ZCN)      SUB       ZRA(ZCP)      ZAMTX
     C                   MOVE      ZAMTX         ZAMTXX
     C     ZAMTXX        MULT(H)   ZPRICE        ZAMT1
     C     ZPROT         IFEQ      '8'
     C                   MULT      ZTCFC         ZAMT1
     C                   END
     C     ZSPBS         IFEQ      'P'
     C                   DIV(H)    100           ZAMT1
     C                   END
     C                   MULT      ZPC(ZCN)      ZAMT1
     C                   DIV(H)    100           ZAMT1
     C                   ADD       ZAMT1         ZAM1
     C                   END
     C*
     C     ZDECS         IFEQ      2
     C     ZRA(ZCN)      SUB       ZRA(ZCP)      ZAMTX
     C                   MOVE      ZAMTX         ZAMTXX
     C     ZAMTXX        MULT(H)   ZPRICE        ZAMT2
     C     ZPROT         IFEQ      '8'
     C                   MULT      ZTCFC         ZAMT2
     C                   END
     C     ZSPBS         IFEQ      'P'
     C                   DIV(H)    100           ZAMT2
     C                   END
     C                   MULT      ZPC(ZCN)      ZAMT2
     C                   DIV(H)    100           ZAMT2
     C                   ADD       ZAMT2         ZAM2
     C                   END
     C*
     C     ZDECS         IFEQ      3
     C     ZRA(ZCN)      SUB       ZRA(ZCP)      ZAMTX
     C                   MOVE      ZAMTX         ZAMTXX
     C     ZAMTXX        MULT(H)   ZPRICE        ZAMT3
     C     ZPROT         IFEQ      '8'
     C                   MULT      ZTCFC         ZAMT3
     C                   END
     C     ZSPBS         IFEQ      'P'
     C                   DIV(H)    100           ZAMT3
     C                   END
     C                   MULT      ZPC(ZCN)      ZAMT3
     C                   DIV(H)    100           ZAMT3
     C                   ADD       ZAMT3         ZAM3
     C                   END
     C*
     C                   END
     C*
     C     ZNOMLX        IFLE      ZRA(ZCN)
     C*
     C     ZDECS         IFEQ      0
     C     ZNOMLX        SUB       ZRA(ZCP)      ZAMTX
     C                   MOVE      ZAMTX         ZAMTXX
     C     ZAMTXX        MULT(H)   ZPRICE        ZAMT0
     C     ZPROT         IFEQ      '8'
     C                   MULT      ZTCFC         ZAMT0
     C                   END
     C     ZSPBS         IFEQ      'P'
     C                   DIV(H)    100           ZAMT0
     C                   END
     C                   MULT      ZPC(ZCN)      ZAMT0
     C                   DIV(H)    100           ZAMT0
     C                   ADD       ZAMT0         ZAM0
     C                   GOTO      ZKYU
     C                   END
     C*
     C     ZDECS         IFEQ      1
     C     ZNOMLX        SUB       ZRA(ZCP)      ZAMTX
     C                   MOVE      ZAMTX         ZAMTXX
     C     ZAMTXX        MULT(H)   ZPRICE        ZAMT1
     C     ZPROT         IFEQ      '8'
     C                   MULT      ZTCFC         ZAMT1
     C                   END
     C     ZSPBS         IFEQ      'P'
     C                   DIV(H)    100           ZAMT1
     C                   END
     C                   MULT      ZPC(ZCN)      ZAMT1
     C                   DIV(H)    100           ZAMT1
     C                   ADD       ZAMT1         ZAM1
     C                   GOTO      ZKYU
     C                   END
     C*
     C     ZDECS         IFEQ      2
     C     ZNOMLX        SUB       ZRA(ZCP)      ZAMTX
     C                   MOVE      ZAMTX         ZAMTXX
     C     ZAMTXX        MULT(H)   ZPRICE        ZAMT2
     C     ZPROT         IFEQ      '8'
     C                   MULT      ZTCFC         ZAMT2
     C                   END
     C     ZSPBS         IFEQ      'P'
     C                   DIV(H)    100           ZAMT2
     C                   END
     C                   MULT      ZPC(ZCN)      ZAMT2
     C                   DIV(H)    100           ZAMT2
     C                   ADD       ZAMT2         ZAM2
     C                   GOTO      ZKYU
     C                   END
     C*
     C     ZDECS         IFEQ      3
     C     ZNOMLX        SUB       ZRA(ZCP)      ZAMTX
     C                   MOVE      ZAMTX         ZAMTXX
     C     ZAMTXX        MULT(H)   ZPRICE        ZAMT3
     C     ZPROT         IFEQ      '8'
     C                   MULT      ZTCFC         ZAMT3
     C                   END
     C     ZSPBS         IFEQ      'P'
     C                   DIV(H)    100           ZAMT3
     C                   END
     C                   MULT      ZPC(ZCN)      ZAMT3
     C                   DIV(H)    100           ZAMT3
     C                   ADD       ZAMT3         ZAM3
     C                   GOTO      ZKYU
     C                   END
     C*
     C                   END
     C*
     C                   END
     C*
     C                   END
     C*
     C                   END
     C*
     C     ZKYU          ENDSR
     C*
     C********************************************************************
 
      ** +--- The converted ZCCAL2Z1 ends here ----------------------------+
 
      /EJECT
      **********************************************************************
      *                                                                    *
      *  This subroutine is to cater for the fact that standard subroutine *
      *   ZCCAL1 in this module executes another standard subroutine,      *
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
      * FROM THE TRADE/SECURITY
      *
     C                   PARM                    ZNOML
     C                   PARM                    ZPRICE
     C                   PARM                    ZDECS
     C                   PARM                    ZNMDP
     C                   PARM                    ZPROT
     C                   PARM                    ZTCFC
     C                   PARM                    ZSPBS
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
     C                   PARM                    ZTCON
     C                   PARM                    ZTNOM
     C                   PARM                    ZTPI
     C                   PARM                    S01446
     C                   PARM                    BVACOP            1
 
      * OUTPUTS
 
      * CHARGE/COMMISSION AMOUNT CALCULATED
     C                   PARM                    ZCHGA
 
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
