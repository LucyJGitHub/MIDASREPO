     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2009')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SM Process CAR migration SDTHRHPD')              *
      *****************************************************************
      *                                                               *
      *  Midas - Implementation Module                                *
      *                                                               *
      *  SMU00006 - German Feature migration for SDTHRHPD             *
      *                                                               *
      *  Called By: SMUC00000                                         *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2009            *
      *                                                               *
      *  Last Amend No. CER059             Date 19Jul10               *
      *  Prev Amend No. CSM011  *CREATE    Date 08May09               *
      *                 XXXXXX             Date DDMmmYY               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CSM011 - Midas SM Process CAR migration                      *
      *                                                               *
      *****************************************************************
     FSMUGF06PD IF   E             DISK
      * Template file for KETHISPP
     FSDTHRHPD  UF A E             DISK
      *
      /EJECT
      *
     D Recursive       S              1
      *
      * Read template file.
     C     1             SETLL     SMUGF06PD
     C                   READ      SMUGF06PD
     C                   DOW       NOT %EOF
      *
     C                   EVAL      TECUST = FCUST
     C                   EVAL      TEACTD = FACTD
     C                   EVAL      TECEXT = FCEXT
     C                   EVAL      TETRAD = FTRAP
     C                   EVAL      TETRVD = FTRVD
     C                   EVAL      TETRMD = FTRMD
     C                   WRITE     SDTHRHD0
      *
     C                   READ      SMUGF06PD
     C                   ENDDO
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *                                                               *
      * Called by: (**calling routines**)                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C                   IF        Recursive = *blanks
     C                   EVAL      Recursive = 'Y'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
      *
     C                   ENDSR
      *
