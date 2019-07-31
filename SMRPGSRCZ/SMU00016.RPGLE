     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SM Initialise Transaction Seq Number')           *
      *****************************************************************
      *                                                               *
      *  Midas - Implementation module                                *
      *                                                               *
      *  SMU00016 - Datapatch to initialise transaction seq. number   *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CLE148             Date 23Jul12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 BG26993            Date 26Jan10               *
      *                 CLE023 *CREATE     Date 25Feb02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE148 - Alpha Loan Reference (Recompile)                    *
      *  BG26993 - Delivery of upgrade programs to core.              *
      *          - Renamed program CLE02301.                          *
      *  CLE023  - Lending Facility History Improvements.             *
      *                                                               *
      *****************************************************************
      *
      * Facility History file.
     FFACHISA   UF   E           K DISK
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *  FUNCTION OF INDICATORS                                       *
      *                                                               *
      *   70 -  EOF in FACHISAF                                       *
      *                                                               *
      *****************************************************************
      /SPACE 3
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E   I N D E X                              *
      *                                                               *
      *  SRMAIN - Detail Processing                                   *
      *                                                               *
      *****************************************************************
      /EJECT
      *================================================================
      *  P R O G R A M   S T A R T                                    *
      *================================================================
      *
     C                   READ      FACHISAF                               70
      *
     C     *IN70         DOWEQ     '0'
      *
      * Update main facility history file
     C                   Z-ADD     FAFSEQ        FATSEQ
     C                   UPDATE    FACHISAF
      *
     C                   READ      FACHISAF                               70
     C                   ENDDO
      *
     C                   MOVE      '1'           *INLR
      *
      *****************************************************************
      *                                                               *
      *  *PSSR  - Program Error Processing Subroutine                 *
      *                                                               *
      *  Called By: Various                                           *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
      * Check to see that *PSSR has not already been called.
     C     *INLR         IFNE      *ON
     C                   EVAL      *INLR = *ON
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   DUMP
     C                   ENDIF
      *
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
