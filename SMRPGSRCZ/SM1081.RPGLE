     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SM Generate duplicate pgm, parameters report')
      *****************************************************************
      *                                                               *
      *  Midas - Implementation module                                *
      *                                                               *
      *  SM1081 - Generate duplicate program, parameters report       *
      *                                                               *
      *  Function:  This program prints duplicate program, parameters *
      *             report by order of menu group and item, based     *
      *             on file SMDPGMPD.                                 *
      *                                                               *
      *  Called By: SMC1080 after running SM1080.                     *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSF002  *CREATE    Date 07Oct03               *
      *                                    Date DDMmmYY               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSF002 - Global Processing changes for SPF.                  *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *       10      End of file SDDPGMPD.                           *
      *       72      There is record to report in SM1081P1.          *
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
 
     FSMDPGMPD  IF   E           K DISK    INFSR(*PSSR)                         by PCMD PARA MGRP
                                                                                   MGRP ICDE unique
     FSM1081P1  O    E             PRINTER INFSR(*PSSR)
 
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
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
     D PARA            DS
     D  PARA1                  1     35
     D  PARA2                 36     70
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D @RUN            S              1
     D LineCount       S              2S 0
 
      *****************************************************************
      /EJECT
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
      *
      * Set off 'record to report' to SM1081P1 indicators.
     C                   SETOFF                                       72
      *
     C                   WRITE     HEAD2
     C                   EVAL      LineCount  = 9
      *
     C                   READ      SMDPGMPD                               10    EOF
      *
     C                   DOW       *IN10 = '0'
      *
     C                   WRITE     DTL2
     C                   SETON                                        72
     C                   EVAL      LineCount =  LineCount + 2
      *
      * If line printed exceeds 56, write header
     C                   IF        LineCount > 56
     C                   WRITE     HEAD2
     C                   EVAL      LineCount = 9
     C                   ENDIF
      *
     C                   READ      SMDPGMPD                               10
     C                   ENDDO                                                  WO *IN10 = '0'
      *
      * If no items written to SM1081P1,  write 'no records' to SM1081P1.
     C     *IN72         IFEQ      *OFF
     C                   WRITE     NORECS2
     C                   ENDIF
      *
     C                   WRITE     TRAILP2
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
