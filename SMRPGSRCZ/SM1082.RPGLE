     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2004')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SM Migration Items from MITEMDD report')
      *****************************************************************
      *                                                               *
      *  Midas - Implementation module                                *
      *                                                               *
      *  SM1082 - Migration Items from MITEMDD report                 *
      *                                                               *
      *  Function:  This program prints data from file SMMIGIPD to    *
      *             report SM1082P1.                                  *
      *                                                               *
      *  Called By: SMC1080 after SM1080 has been run.                *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2004            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CPK019  *CREATE    Date 18Jun04               *
      *  Prev Amend No.                    Date ddmmmyy               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  CPK019 - Change branches utility                             *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *       10      End of file SMMIGIPD.                           *
      *       37      Report overflow indicator.                      *
      *       72      There is record to report in SM1082P1.          *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  *PSSR - Error processing                                     *
      * *INZSR - Initialise                                           *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FSMMIGIPD  IF   E           K DISK    INFSR(*PSSR)
 
     FSM1082P1  O    E             PRINTER INFSR(*PSSR)
     F                                     OFLIND(*IN37)
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
      *
      ** Program Status Data Structure
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D @RUN            S              1
 
      *****************************************************************
      /EJECT
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
      *
      * Set off 'record to report' to SM1082P1 indicators.
     C                   SETOFF                                       72
      *
     C                   WRITE     HEAD
      *
     C                   READ      SMMIGIPD                               10    EOF
      *
     C                   DOW       *IN10 = '0'
      *
     C                   WRITE     DTL
      *
      * Set on 'Record to Report' indicator.
     C  N72              SETON                                        72
      *
      * If overflow indicator ON, write header.
     C                   IF        *IN37 = '1'
     C                   WRITE     HEAD
     C                   SETOFF                                       37
     C                   ENDIF
      *
     C                   READ      SMMIGIPD                               10    EOF
      *
     C                   ENDDO                                                  WO *IN10 = '0'
      *
      * If no items written to SM1082P1,  write 'no records' to SM1082P1.
     C                   IF        *IN72 = '0'
     C                   WRITE     NORECS
     C                   ENDIF
      *
     C                   WRITE     TRAILP
      *
     C                   SETON                                        LR
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: (**calling routines**)                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'
     C                   DUMP
      *
     C                   ENDIF
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C                   ENDSR
      *
      *****************************************************************
