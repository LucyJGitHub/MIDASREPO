     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas ZS Cvt amount fm one ccy to another')
      *****************************************************************
      *                                                               *
      *    Midas - Copy Source converted into ILE procedures          *
      *                                                               *
      *    ZCONV - MODULE TO CONVERT AN  AMOUNT FROM ONE CURRENCY     *
      *            TO ANOTHER                                         *
      *                                                               *
      *                                                               *
      *    INPUT  - ZAMTCI (15,0) AMOUNT INPUT                        *
      *             ZEXCH  (13,8) EXCHANGE RATE                       *
      *             ZMD    (1)    MULTIPLY/DIVIDE INDICATOR           *
      *             ZCCYI  (3)    CURRENCY INPUT                      *
      *             ZCCYO  (3)    CURRENCY TO BE CONVERTED TO         *
      *             POWER   -     COMPILE TIME ARRAY MUST BE INCLUDED *
      *                           IN THE PROGRAM SOURCE               *
      *             ZCDPI  (1,0)  (FROM) CURRENCY DECIMAL PLACES      *
      *             ZCDPO  (1,0)  (TO) CURRENCY DECIMAL PLACES        *
      *                                                               *
      *   OUTPUT -  ZAMTCO (15,0) AMOUNT OUTPUT                       *
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
      *  Last Amend No. CAP002  *CREATE    Date 30Jan98               *
      *  Prev Amend No.                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CAP002 - Conversion of SE inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** Include the MM standard declares
     D/COPY ZACPYSRC,STDDECLARE
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** +-------- The converted ZPOWERZ1 starts here --------------------+
      *
     D POArr           S              7  3 DIM(7) CTDATA PERRCD(1)              POWER ARRAY
      *
      ** +-------- The converted ZPOWERZ1 ends here ----------------------+
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      **
      ***INPUT***
      ** AMOUNT INPUT
     D ZAMTCI          S             15P 0
      *
      ** EXCHANGE RATE
     D ZEXCH           S             13P 8
      *
      ** MULTIPLY/DIVIDE INDICATOR
     D ZMD             S              1A
      *
      ** CURRENCY INPUT
     D ZCCYI           S              3A
      *
      ** CURRENCY TO BE CONVERTED TO
     D ZCCYO           S              3A
      *
      ** (FROM) CURRENCY DECIMAL PLACES
     D ZCDPI           S              1P 0
      *
      * (TO) CURRENCY DECIMAL PLACES
     D ZCDPO           S              1P 0
      *
      ***OUTPUT***
      ** AMOUNT OUTPUT
     D ZAMTCO          S             15P 0
      *
      ***WORKING VARIABLES***
      ** VARIABLE
     D Work1           S             15P 3
      ** POArr ARRAY INDEX
     D ZPXIdx          S              1P 0
      *
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
 
     C
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
     C*
     C** +-------- The converted ZCONVZ1 starts here ---------------------+
     C*
     C* IF EXCHANGE RATE IS 0 - OUTPUT CURRENCY AMOUNT AS ZERO
     C*
     C     ZEXCH         IFEQ      0
     C                   Z-ADD     0             ZAMTCO
     C                   GOTO      EZCONV
     C                   END
     C*
     C* IF DECIMAL PLACES ARE THE SAME FOR BOTH CURRENCIES
     C*
     C     ZCDPI         IFEQ      ZCDPO
     C*
     C*** CALCULATE OUTPUT CURRENCY AMOUNT BY DIVIDING EXCHANGE RATE INTO
     C*** OR MULTIPLYING EXCHANGE RATE BY CURRENCY AMOUNT INPUT DEPENDING
     C*** ON INDICATOR
     C*
     C     ZMD           IFEQ      'D'
     C     ZAMTCI        DIV(H)    ZEXCH         ZAMTCO
     C                   ELSE
     C     ZAMTCI        MULT(H)   ZEXCH         ZAMTCO
     C                   END
     C*
     C                   ELSE
     C*
     C*** IF DECIMAL PLACES DIFFER -
     C*** CALCULATE DIFFERENCE IN DECIMAL PLACES TO USE AS POArr INDEX
     C*
     C     ZCDPO         SUB       ZCDPI         ZPXIdx
     C                   ADD       4             ZPXIdx
     C*
     C*** CALCULATE CURRENCY AMOUNT OUTPUT BY MULTIPLYING INPUT AMOUNT BY
     C*** POWER ARRAY ENTRY AND THEN MULTIPLYING RESULT BY EXCHANGE RATE
     C*** DEPENDING ON INDICATOR
     C*
     C     POArr(ZPXIdx) IFLT      1                                            from d.p *LT
     C     ZAMTCI        MULT      POArr(ZPXIdx) Work1                           to d.p.
     C*
     C     ZMD           IFEQ      'D'
     C     Work1         DIV(H)    ZEXCH         ZAMTCO
     C                   ELSE
     C     Work1         MULT(H)   ZEXCH         ZAMTCO
     C                   END
     C*
     C                   ELSE                                                   from d.p. *GT
     C     ZAMTCI        MULT      POArr(ZPXIdx) ZAMTCI                           to d.p.
      *
     C     ZMD           IFEQ      'D'
     C     ZAMTCI        DIV(H)    ZEXCH         ZAMTCO
     C                   ELSE
     C     ZAMTCI        MULT(H)   ZEXCH         ZAMTCO
     C                   END
     C*
     C                   END
     C*
     C                   END
     C*
     C     EZCONV        TAG                                                    ** EZCONV **
     C*
     C                   RETURN
     C*
     C** +-------- The converted ZCONVZ1 ends here -----------------------+
     C*
      *****************************************************************
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
     C                   PARM                    ZAMTCI
     C                   PARM                    ZEXCH
     C                   PARM                    ZMD
     C                   PARM                    ZCCYI
     C                   PARM                    ZCCYO
     C                   PARM                    ZCDPI
     C                   PARM                    ZCDPO
      ***OUTPUT***
     C                   PARM                    ZAMTCO
 
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
**  POArr - ARRAY OF POWERS FOR CURRENCY CONVERSION  (MEMBER ZPOWERZ2)
0000001
0000010
0000100
0001000
0010000
0100000
1000000
