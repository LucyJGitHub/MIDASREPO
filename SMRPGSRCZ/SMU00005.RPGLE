     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2009')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SM Process CAR migration SDECTYPD')              *
      *****************************************************************
      *                                                               *
      *  Midas - Implementation Module                                *
      *                                                               *
      *  SMU00005 - German Feature migration for SDECTYPD             *
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
     FSMUGF05PD IF   E             DISK
      * Template file for KENVTYPP
     FSDECTYPD  UF A E           K DISK
      *
      /EJECT
      *
     D Recursive       S              1
      *
     C     1             SETLL     SMUGF05PD
     C                   READ      SMUGF05PD
     C                   DOW       NOT %EOF
      *
     C                   EVAL      TCTYPE = FNVTY
     C                   EVAL      TCTDES = FNVDE
     C                   EVAL      TCLCD  = FLCHD
     C                   WRITE     SDECTYD0
 
     C                   READ      SMUGF05PD
     C                   ENDDO
      *
     C                   EVAL      *INLR=*ON
     C                   RETURN
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
      *
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
