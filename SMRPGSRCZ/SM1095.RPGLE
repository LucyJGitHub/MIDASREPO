     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SM Supsect fields report')
      *****************************************************************
      *                                                               *
      *  Midas - Implementation module                                *
      *                                                               *
      *  SM1095  - Suspect fields report                              *
      *                                                               *
      *  Function:  This program prints data from file SMSUSFLDPD to  *
      *             report SM1095P1.                                  *
      *                                                               *
      *  Called By: SMC1091 after branch conversion has stopped.      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2004            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CUP025  *CREATE    Date 10Jun04               *
      *  Prev Amend No.                    Date ddmmmyy               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  CUP025 - Change branches utility                             *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *       10      End of file SMSUSFLDPD.                         *
      *       25      Print file name.                                *
      *       26      Print file member.                              *
      *       27      Print old branch code.                          *
      *       37      Report overflow indicator.                      *
      *       40      New page indicator.                             *
      *       72      There is record to report in SM1095P1.          *
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
 
     FSMSUSFLDPDIF   E           K DISK    INFSR(*PSSR)
 
     FSM1095P1  O    E             PRINTER INFSR(*PSSR)
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
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D @RUN            S              1
     D PrevFile        S                   LIKE(SFFILE)                         Previous file
     D PrevFilMbr      S                   LIKE(SFFMBR)                         Previous file member
     D PrevOldBrc      S                   LIKE(SFOLDB)                         Previous old branch
 
      *****************************************************************
      /EJECT
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
      *
      * Set off 'record to report' to SM1095P1 indicators.
     C                   SETOFF                                       72
      *
     C                   WRITE     HEAD
      * Set on New page indicator.
     C                   SETON                                        40
      *
     C                   READ      SMSUSFLDPD                             10    EOF
      *
     C                   DOW       *IN10 = '0'
      *
      * Set indicators to display file, file member, old branch:
      *   IF new page, set on indicators to print file, file member and old branch.
     C                   IF        *IN40 = '1'
     C                   SETON                                        252627
      *
      *   Else (ie, not new page) check difference of file, file member and old branch:
     C                   ELSE
     C                   IF        PrevFile <> SFFILE
     C                   SETON                                        252627
     C                   ELSE                                                   same file name
     C                   IF        PrevFilMbr <> SFFMBR
     C                   SETON                                        2627
     C                   SETOFF                                       25
     C                   ELSE                                                   Same file, file mbr
     C                   IF        PrevOldBrc <> SFOLDB
     C                   SETON                                        27
     C                   SETOFF                                       2526
     C                   ELSE                                                   same file, mbr, brc
     C                   SETOFF                                       252627
     C                   ENDIF                                                  FI old brc differenc
     C                   ENDIF                                                  FI SFFMBR difference
     C                   ENDIF                                                  FI SFFILe difference
     C                   ENDIF                                                  FI *IN40  = '1'
      *
      * If not new page and new file name, print blank line first
     C                   IF        *IN40  = '0'   AND
     C                             *IN25  = '1'
     C                   WRITE     BLNK
     C                   ENDIF
      *
     C                   WRITE     DTL
      *
      * Set on 'Record to Report' indicator.
     C  N72              SETON                                        72
      * Set off 'New Page' indicator.
     C   40              SETOFF                                       40
      *
      * If overflow on, write header and set on new page indicator
     C                   IF        *IN37 = '1'
     C                   WRITE     HEAD
     C                   SETOFF                                       37
     C                   SETON                                        40
     C                   ENDIF
      *
      * Save the reported file, file member and old branch........
     C                   EVAL      PrevFile   = SFFILE
     C                   EVAL      PrevFilMbr = SFFMBR
     C                   EVAL      PrevOldBrc = SFOLDB
      *
     C                   READ      SMSUSFLDPD                             10    EOF
      *
     C                   ENDDO                                                  WO *IN10 = '0'
      *
      * If no items written to SM1095P1,  write 'no records' to SM1095P1.
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
