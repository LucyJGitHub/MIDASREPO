     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas ZS Add amounts into hash fields MODULE')
      *****************************************************************
      *  Midas/TI Interface                                           *
      *                                                               *
      *   Module ZZADD  -  ADD AMOUNTS INTO HASH FIELDS               *
      *                                                               *
      *  Function:    This module returns the integer and decimal     *
      *               parts of the parameter Amount                   *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *  LAST AMEND NO. CTI001    Create   DATE 02Sep97               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CTI001 - Midas/TI Interface (Phase 1)                        *
      *                                                               *
     D****************************************************************
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
     D*
     D****************************************************************
     C*
     C     *ENTRY        PLIST
     C     ZZAMT         PARM      ZZAMT         Amount           15 3
     C     ZZTOTI        PARM      ZZTOTI        IntPart          15 0
     C     ZZTOTD        PARM      ZZTOTD        DecPart           3 0
     C*
     C                   EXSR      ZZADD
     C*
     C                   RETURN
     C*
     C********       The converted ZZADDZ1 starts here   *************
     C****************************************************************
     C**                                                             *
     C**  SR:ZZADD    - TO ADD AMOUNTS INTO HASH FIELDS              *
     C**                                                             *
     C**  INPUTS      - ZZAMT  (15,3) AMOUNT                         *
     C**              - ZZTOTI (15,0) INITIAL INTEGER PART OF THE    *
     C**                HASH FEILD                                   *
     C**                ZZTOTD (3,0)  INITIAL DECIMAL PART OF THE    *
     C**                HASH FEILD                                   *
     C**  OUTPUTS     - ZZTOTI (15,0) INTEGER PART OF THE HASH FIELD *
     C**                ZZTOTD (3,0)  DECIMAL PART OF THE HASH FIELD *
     C**                                                             *
     C****************************************************************
     C**
     C     ZZADD         BEGSR                                                  ** ZZADD  SR **
     C**
     C**   SET UP FIELDS TO BE HASHED
     C**
     C                   Z-ADD     ZZAMT         ZZAMT            15 3  91
     C   91              Z-SUB     ZZAMT         ZZAMT
     C                   Z-ADD     ZZAMT         ZZAMTI           15 0
     C                   MOVE      ZZAMT         ZZAMTD            3 0
     C**
     C**  ADD DECIMAL PART AND CHECK FOR CARRY
     C**
     C                   ADD       ZZAMTD        ZZTOTD            3 0
     C     ZZTOTD        COMP      ZZAMTD                               91
     C   91              ADD       1             ZZAMTI
     C**
     C**  ADD INTEGER PART
     C**
     C                   ADD       ZZAMTI        ZZTOTI           15 0
     C**
     C                   ENDSR
     C*
     C********************************************************************
     C********       The converted ZZADDZ1 ends here   *************
     C*
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
