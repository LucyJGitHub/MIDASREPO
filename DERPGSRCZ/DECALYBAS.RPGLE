     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas DE Calculate year basis')
      *****************************************************************
      *                                                               *
      *  Midas - Data Export module                                   *
      *                                                               *
      *  DECALYBAS - Calculate Year Basis                             *
      *                                                               *
      *  Function:  This module calculates the year divisor basis     *
      *             from the interest calculation method passed.      *
      *                                                               *
      *  Component of: DECALFWRT, DECALINTM, DECALNDYS, DEWRKEDTA     *
      *                DEWRKEDTS                                      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.03 -----------------------------------------------*
      *  Last Amend No. CDE001  *CREATE    Date 16Dec99               *
      *  Prev Amend No.                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CDE001 - Data Export - CCRM Limits.                          *
      *                                                               *
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
 
      *
      * INPUT PARAMETERS
      *
     C     *ENTRY        PLIST
     C                   PARM                    I#RTCD            7            * RETURN CODE
     C                   PARM                    I#ERMS           30            * ERROR MESSAGE
      * INPUTS
      * int.calc method
     C                   PARM                    I#ICMT            7            * INT CAL MTHD
      * int paymts/year
     C                   PARM                    I#IPY             2 0          * INT PAY PER YR
      * last/next int date
     C                   PARM                    I#LIDT            5 0          * LAST INT DATE
     C                   PARM                    I#NIDT            5 0          * NEXT INT DATE
      * OUTPUTS
      * year basis
     C                   PARM                    O#YBAS            5 0          * YEAR BASIS
      *
      * INITIALIZE OUTGOING YEAR BASIS
      *
     C                   Z-ADD     *ZERO         O#YBAS               98        *
      *
      * EARLY EXIT CONDITIONS
      *
     C                   EXSR      EARLYEXIT
      *
      * CALCULATE YEAR BASIS
      *
     C                   EXSR      CALBAS
      *
      * RETURN FROM PROGRAM
      *
     C                   RETURN
      *
      **********************************************************************
      * CALBAS - CALCULATE YEAR BASIS
      **********************************************************************
     C     CALBAS        BEGSR
      *
      * 360 DAY YEAR
      *
     C     I#ICMT        IFEQ      '30/360'
     C     I#ICMT        OREQ      '30E/360'
     C     I#ICMT        OREQ      'ACT/360'
     C     I#ICMT        OREQ      'ACX/360'
     C                   Z-ADD     360           O#YBAS
     C                   END
      *
      * 365 DAY YEAR
      *
     C     I#ICMT        IFEQ      'ACT/365'
     C     I#ICMT        OREQ      'ACX/365'
     C                   Z-ADD     365           O#YBAS
     C                   END
      *
      * 365/366 DAY YEAR
      *
     C     I#ICMT        IFEQ      'ACT/366'
     C     I#ICMT        OREQ      'ACX/366'
      *
      * GET YEAR OF NEXT INTEREST DATE
      *
     C                   Z-ADD     I#NIDT        ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVE      ZDATE         W#YEAR            2 0
      *
      * IS 365 OR 366 ACCORDING TO YEAR OF NEXT INTEREST DATE
      *
     C     W#YEAR        DIV       4             W#020             2 0
     C                   MVR                     W#010             1 0
     C     W#010         IFNE      0
     C                   Z-ADD     365           O#YBAS
     C                   ELSE
     C                   Z-ADD     366           O#YBAS
     C                   END
     C                   END
      *
      * ACTUAL/ACTUAL
      *
     C     I#ICMT        IFEQ      'ACT/ACT'
     C     I#ICMT        OREQ      'ACX/ACX'
      *
      * CALCULATE NO OF DAYS IN CURRENT INTEREST PERIOD
      *
     C                   CALLB     'DECALNDYS'
     C                   PARM      *BLANK        W#RTCD            7            * RETURN CODE
     C                   PARM      *BLANK        W#ERMS           30            * ERROR MESSAGE
     C                   PARM      I#ICMT        W#ICMT            7            * INT CAL MTHD
     C                   PARM      I#LIDT        W#SDAT            5 0          * START DATE
     C                   PARM      I#NIDT        W#EDAT            5 0          * END DATE
     C                   PARM      *ZERO         W#NDYS            5 0          * NO. OF DAYS
 
     C     W#RTCD        IFEQ      '*ERROR'
     C                   EVAL      I#ERMS = 'ERROR IN CALL TO DECALNDYS'
     C                   EXSR      *PSSR
     C                   END
      *
      *    CALCULATE NO OF DAYS = NO DAYS IN CURRENT INTEREST PERIOD X
      *                           NO INTEREST PERIODS IN A YEAR
      *
     C     W#NDYS        MULT      I#IPY         O#YBAS
      *
     C                   END
      *
     C                   ENDSR
      **********************************************************************
     C/SPACE 5
      **********************************************************************
     C     EARLYEXIT     BEGSR
      *
      * EXIT IN ERROR IF INTEREST CALCULATION METHOD IS INVALID
      *
     C     I#ICMT        IFNE      '30/360 '
     C     I#ICMT        ANDNE     '30E/360'
     C     I#ICMT        ANDNE     'ACT/360'
     C     I#ICMT        ANDNE     'ACX/360'
     C     I#ICMT        ANDNE     'ACT/365'
     C     I#ICMT        ANDNE     'ACX/365'
     C     I#ICMT        ANDNE     'ACT/366'
     C     I#ICMT        ANDNE     'ACX/366'
     C     I#ICMT        ANDNE     'ACT/ACT'
     C     I#ICMT        ANDNE     'ACX/ACX'
     C                   EVAL      I#ERMS = 'INT. CALC. METHOD IS INVALID'
     C                   EXSR      *PSSR
     C                   END
      *
     C                   ENDSR
      **********************************************************************
     C/SPACE 5
      **********************************************************************
      * CONVERT DATE TO DAY NUMBER
      **********************************************************************
     C     ZDATE2        BEGSR
     C                   CALLB     'ZDATE2'
     C                   PARM                    ZDAYNO            5 0          Value date
     C                   PARM      'D'           ZDATFM            1            Date format ind
     C                   PARM      *ZERO         ZDATE             6 0          Value date
     C                   PARM      *BLANK        ZADATE            7            Run-date in DDM
     C                   ENDSR
      **********************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY DECPYSRC,DEPSSR
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
