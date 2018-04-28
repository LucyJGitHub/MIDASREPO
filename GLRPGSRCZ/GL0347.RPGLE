     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2011')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas GL Generated entries audit report 2 - GL/RE')    *
      *****************************************************************
      *                                                               *
      *  Midas - GL Module                                            *
      *                                                               *
      *  GL0347 - Midas GL Generated entries audit report 2 - GL/RE   *
      *                                                               *
      *  Function:  This program compares the number/value of         *
      *             postings on the COB Generated Entries files       *
      *             against the hash totals on the trailer files,     *
      *             listing all the totals and printing DIFFERENCE    *
      *             against any files which do not tally.             *
      *                                                               *
      *  Called By: GL0345                                            *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2011            *
      *                                                               *
      *  Last Amend No. AR722462  *CREATE  Date 10Jun11               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR722462 - Add GESPPD and GESP2PD in the report              *
      *             (Child:AR722468)                                  *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    U7+U8      Database Errors                                 *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * *PSSR - Error processing                                      *
      * *INZSR - Initialise Subroutine                                *
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
 
     FGESP2ZZ   IF   E             DISK    INFSR(*PSSR)
     F                                     RENAME(APOSTZZF:GESP2ZZF)
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     D @RUN            S              1
 
      ** Additional Field Definitions
     D PRTCD           S              6
     D PFILE           S             10
     D PNORE           S              5  0
     D PPSTA           S             18  0
     D WRK18           S             18  0
 
      *****************************************************************
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ Initial processing is performed automatically: the *INZSR  ¦
      ** ¦ is executed at program activation.                         ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
 
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
 
     C                   SELECT
     C                   WHEN      PFILE = 'GESP2ZZ'
     C                   EXSR      SrGESP2ZZ
     C                   ENDSL
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrGESP2ZZ - Process GESP2ZZ File                              *
      *                                                               *
      *****************************************************************
     C     SrGESP2ZZ     BEGSR
 
     C                   READ      GESP2ZZ
     C                   IF        %EOF
     C                   Z-ADD     0             PNORE
     C                   Z-ADD     0             PPSTA
     C                   ELSE
     C     HRWN          MULT      1000          WRK18
     C     WRK18         ADD       HRDC          PPSTA
     C     NORE1         SUB       2             PNORE
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    PRTCD
     C                   PARM                    PFILE
     C                   PARM                    PNORE
     C                   PARM                    PPSTA
 
     C                   ENDSR
 
      *****************************************************************
 
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      *****************************************************************
 
     C     *PSSR         BEGSR
 
     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'
     C                   DUMP
 
     C                   ENDIF
 
     C                   EVAL      PRTCD = '*ERROR'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
