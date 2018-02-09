     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas GL Initialise GLGCOLPD (CGL014)')                *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GL000002 - Initialise GLGCOLPD (CGL014)                      *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CLE134             Date 01Aug12               *
      *                 CLE148             Date 23Jul12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 BUG3069  *CREATE   Date 15Jul04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CLE148 - Alpha Loan Reference (Recompile)                    *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG3069 - Empty GLGCOLPD produces error when entering a      *
      *            collateral                                         *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    XX         Function of Indicator                           *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRProcess - Process files                                    *
      *  SRFacLoan - Update Facility/Loan file                        *
      *  SRGenRefNo - Generate Reference Number processing            *
      *  SRGenTrnNo - Generate Transaction Number processing          *
      *  *INZSR    - Initialise                                       *
      *  *PSSR     - Error processing                                 *
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
 
      ** Midas GL Live Collateral Details by Collateral Ref
     FGLCOLLL1  IF   E           K DISK    INFSR(*PSSR)
 
      ** Midas GL Collateral Details Generated Reference
     FGLGCOLPD  UF A E             DISK    INFSR(*PSSR)
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
     D LDA           E DS           256    EXTNAME(LDA)
 
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D WCGLCRF         S                   LIKE(CGLCRF)
     D WRun            S              1
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ Initial processing is performed automatically: the *INZSR  ¦
      ** ¦ is executed at program activation.                         ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
 
      ** Process files
 
     C                   EXSR      SRProcess
 
      ** End program
 
     C                   EVAL      *INLR = *ON
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRProcess - Process files                                    *
      *                                                               *
      *****************************************************************
 
     C     SRProcess     BEGSR
 
      ** Set Last Collateral Reference to zero if GLCOLLPD is empty
      ** Else, set it to the last/highest collateral reference in GLCOLLPD
 
     C     *HIVAL        SETLL     GLCOLLL1
     C                   READP     GLCOLLL1
 
     C                   IF        NOT %EOF(GLCOLLL1)
     C                   MOVEL     CDCREF        WCGLCRF
     C                   ELSE
     C                   EVAL      WCGLCRF = 0
     C                   ENDIF
 
      ** Update GLGCOLPD
 
     C     1             SETLL     GLGCOLPD
     C                   READ      GLGCOLPD
 
     C                   EVAL      CGLCRF = WCGLCRF
 
     C                   IF        NOT %EOF(GLGCOLPD)
     C                   UPDATE    GLGCOLD0
     C                   ELSE
     C                   WRITE     GLGCOLD0
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation routine                      *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR  - Program exception error routine                     *
      *           Called automatically if a program error occurs,     *
      *           or directly by the program code using EXSR.         *
      *           This subroutine DUMPs the program just once.        *
      *                                                               *
      *****************************************************************
 
     C     *PSSR         BEGSR
 
     C                   IF        WRun = *BLANK
     C                   EVAL      WRun = 'Y'
     C                   DUMP
     C                   CALL      'DBERRCTL'
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
 
     C                   RETURN
 
     C                   ENDSR
 
      *****************************************************************
