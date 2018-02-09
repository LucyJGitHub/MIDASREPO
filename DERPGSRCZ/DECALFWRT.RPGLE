     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas DE Calculate forward rate')
      *****************************************************************
      *                                                               *
      *  Midas - Data Export module                                   *
      *                                                               *
      *  DECALFWRT - Calculate Forward Rate                           *
      *                                                               *
      *  Function:  This module calculates forward rates.             *
      *             Note that this module must match the calculation  *
      *             in SR/DLRADS in DL0279 thus when applying fixes,  *
      *             the same changes are required to both programs.   *
      *                                                               *
      *  Component of: DEWRKEDTA                                      *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. 208221             Date 11Dec02               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CDE002             Date 05Dec00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CDE001  *CREATE    Date 23Nov99               *
      *                                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  208221 - Changes identified during alpha site                *
      *  CDE002 - Revenue Analysis                                    *
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
 
 
     C     *ENTRY        PLIST
     C                   PARM                    I#RTCD            7            * RETURN CODE
     C                   PARM                    I#ERMS           30            * ERROR MESSAGE
 
      * INPUTS
      * currency
     C                   PARM                    I#CCY             3            * CURRENCY
      * int.calc. method
     C                   PARM                    I#ICMT            7            * INT.CALC.METH.
      * spot date
     C                   PARM                    I#SPDT            5 0          * SPOT DATE
      * near date
     C                   PARM                    I#NRDT            5 0          * NEAR DATE
      * far date
     C                   PARM                    I#FRDT            5 0          * FAR DATE
      * int.paymts/year
     C                   PARM                    I#IPY             2 0          * INT PAY PER YR
      * last int date
     C                   PARM                    I#LIDT            5 0          * LAST INT DATE
      * next int date
     C                   PARM                    I#NIDT            5 0          * NEXT INT DATE
      * OUTPUTS
      * forward rate
     C                   PARM                    O#FWRT           11 7          * FORWARD RATE
      *
      ***  Initialise output forward rate
      *
     C                   Z-ADD     0             O#FWRT
      *
      ** CALCULATE DISCOUNT FACTOR AS AT NEAR DATE
      *
     C                   Z-ADD     I#NRDT        W#FWDT
     C                   EXSR      CALDF
     C                   Z-ADD(H)  W#DF          W#NRDF           11 9
      *
      ** CALCULATE DISCOUNT FACTOR AS AT FAR DATE
      *
     C                   Z-ADD     I#FRDT        W#FWDT
     C                   EXSR      CALDF
     C                   Z-ADD(H)  W#DF          W#FRDF           11 9
      *
      ** Calculate the number of days/divisor basis
      ** from near date to far date
      *
     C                   EXSR      CAL_NDYS
     C                   EXSR      CAL_YBAS
      *
      ** FORWARD RATE = {(NEAR DISCOUNT FACTOR/FAR DISCOUNT FACTOR) - 1}
      **                X DIVISOR BASIS / DAY BASIS
      *
     C     W#FRDF        IFNE      *ZERO
     C     W#NRDF        DIV(H)    W#FRDF        W#W219           21 9
     C                   SUB       1             W#W219
     C                   ELSE
     C                   Z-ADD     *ZERO         W#W219
     C                   END
      *
     C                   MULT      W#YBAS        W#W219
     C                   MULT      100           W#W219
      *
     C     W#NDYS        IFNE      *ZERO
     C                   DIV       W#NDYS        W#W219
     C                   ELSE
     C                   Z-ADD     *ZERO         W#W219
     C                   END
      *
      ** OUTPUT FORWARD RATE
      *
     C                   Z-ADD     W#W219        O#FWRT
      *
     C                   RETURN
      *
     C**************************************************************************
      /SPACE 5
      ********************************************************************
      * CALCULATE DISCOUNT FACTOR
      ********************************************************************
     C     CALDF         BEGSR
      *
     C                   CALLB     'DECALNPVL'
     C                   PARM      *BLANK        W#RTCD            7
     C                   PARM      *BLANK        W#ERMS           30
     C                   PARM      I#CCY         W#CCY             3            * CURRENCY
     C                   PARM      I#SPDT        W#SPDT            5 0          * SPOT DATE
     C                   PARM                    W#FWDT            5 0          * FORWARD DATE
     C                   PARM      *ZERO         W#FWAM           13 0          * FORWARD AMOUNT
     C                   PARM      *ZERO         W#DF             11 9          * DISC FACTOR
     C                   PARM      *ZERO         W#SPAM           13 0          * SPOT AMOUNT
      *
     C     W#RTCD        IFEQ      '*ERROR'
     C                   EVAL      I#ERMS = 'ERROR IN CALL TO DECALNPVL'
     C                   EXSR      *PSSR
     C                   END
      *
     C                   ENDSR
      **************************************************************************
      /SPACE 5
      *********************************************************************
      ** CALCULATE NUMBER OF DAYS
      **************************************************************************
     C     CAL_NDYS      BEGSR
      *
     C                   CALLB     'DECALNDYS'
     C                   PARM      *BLANK        W#RTCD            7            * RETURN CODE
     C                   PARM      *BLANK        W#ERMS           30
     C                   PARM      I#ICMT        W#ICMT            7            * INT CAL MTHD
     C                   PARM      I#NRDT        W#SDAT            5 0          * START DATE
     C                   PARM      I#FRDT        W#EDAT            5 0          * END DATE
     C                   PARM      *ZERO         W#NDYS            5 0          * NO. OF DAYS
      *
     C     W#RTCD        IFEQ      '*ERROR'
     C                   EVAL      I#ERMS = 'ERROR IN CALL TO DECALNDYS'
     C                   EXSR      *PSSR
     C                   END
      *
     C                   ENDSR
      **************************************************************************
      /SPACE 5
      *********************************************************************
      ** CALCULATE YEAR BASIS
      *********************************************************************
     C     CAL_YBAS      BEGSR
      *
     C                   CALLB     'DECALYBAS'
     C                   PARM      *BLANK        W#RTCD            7            * RETURN CODE
     C                   PARM      *BLANK        W#ERMS           30
     C                   PARM      I#ICMT        W#ICMT            7            * INT CAL MTHD
     C                   PARM      I#IPY         W#IPY             2 0          * INT PAY PER YR
     C                   PARM      I#LIDT        W#LIDT            5 0          * LAST INT DATE
     C                   PARM      I#NIDT        W#NIDT            5 0          * NEXT INT DATE
     C                   PARM      *ZERO         W#YBAS            5 0          * YEAR BASIS
      *
     C     W#RTCD        IFEQ      '*ERROR'
     C                   EVAL      I#ERMS = 'ERROR IN CALL TO DECALYBAS'
     C                   EXSR      *PSSR
     C                   END
      *
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY DECPYSRC,DEPSSR
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2001
