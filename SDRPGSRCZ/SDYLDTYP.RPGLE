     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2004')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SD Yield Curve Type 'Z' to 'S'')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  RPGLE/SDYLDTYP - Amend Yield Curve Type  'Z' to 'S'          *
      *                                                               *
      *  Function: Read through Yield Curve master file and change    *
      *            all yield type = 'Z' to 'S'.                       *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2004            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Last Amend No. CRE026             Date 24May06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. 228390  *CREATE    Date 14Jul04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CRE026 - Consumer Banking (Recompile)                        *
      *  228390 - Introduce a new yield curve type 'S' (for swap      *
      *           rates) which will apply the formula currently being *
      *           used by curve type 'Z' and a new formula for type   *
      *           'Z' is to be introduced.                            *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of Indicators                                            *
      *                                                               *
      *  10 - End of File                                             *
      *                                                               *
      *  LR - Last record indicator (program termination)             *
      *  U7 and U8 - DB error processing indicator                    *
      *                                                               *
      *****************************************************************
      /SPACE
      *****************************************************************
 
     FSDYLDCL0  UF   E           K DISK    INFSR(*PSSR)
      ** Yield Curve Master file
 
 
      ** Array containing Copyright statement
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
 
      ** Work Variable
     D WkUpdate        S              1A
     D WkDump          S              1A   INZ(' ')
     D WkCountF        S              9  0
 
      *****************************************************************
      *                                                               *
      *  Main Processing                                              *
      *                                                               *
      *****************************************************************
 
      ** Read all reord Yield Curve Master File
 
     C     *LOVAL        SETLL     SDYLDCL0
     C                   READ      SDYLDCL0                               10
     C                   DOW       *IN10 = *OFF
     C                   EVAL      WkCountF = WkCountF + 1
     C                   EVAL      WkUpdate = 'N'
 
     C                   IF        FSYLDT = 'Z'
     C                   EVAL      FSYLDT = 'S'
     C                   EVAL      WkUpdate = 'Y'
     C                   ENDIF
 
     C                   IF        FSINTP = 'Z'
     C                   EVAL      FSINTP = 'S'
     C                   EVAL      WkUpdate = 'Y'
     C                   ENDIF
 
     C                   IF        WkUpdate = 'Y'
     C                   UPDATE    SDYLDCD0
     C                   ENDIF
 
     C                   READ      SDYLDCL0                               10
     C                   ENDDO
 
     C                   EVAL      *INLR = *ON
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Subroutine for Initial First Cycle processing        *
      *                                                               *
      * Called by: Automatically called upon entry to the module      *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C                   EVAL      WkCountF = 0
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *                                                               *
      * Called by: *INZSR                                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
 
     C                   IF        WkDump = *BLANKS
     C                   MOVE      'Y'           WkDump
     C                   MOVE      *ON           *INU7
     C                   MOVE      *ON           *INU8
     C                   MOVE      *ON           *INLR
     C                   DUMP
     C                   RETURN
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
** WCPY@
(c) Misys International Banking Systems Ltd. 2004
