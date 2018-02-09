     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SM Initialise new field on EDBUTFPD')
      *****************************************************************
      *                                                               *
      *  Midas - Implementation module                                *
      *                                                               *
      *  SMU00010 - Initialise new field on EDBUTFPD                  *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *  Prev Amend No. BG26993            Date 26Jan10               *
      *                 CED002  *CREATE    Date 29Feb00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  BG26993 - Delivery of upgrade programs to core.              *
      *          - Renamed program CED00201.                          *
      *  CED002  - Created for Midas ED Enhancements                  *
      *                                                               *
      *****************************************************************
      *
     FEDBUTFPD  UP   E             DISK    INFSR(*PSSR)
      *
     D C#ESEQ          C                   CONST('0000000001')
      *
      *****************************************************************
      *  P R O G R A M     S T A R T                                  *
      *****************************************************************
      *
      * Perform Initialisation.
     C                   MOVE      C#ESEQ        EDEXSC
     C                   UPDATE    EDBUTFD0
      *
     CLR                 RETURN
      *
      *****************************************************************
     C     INZSR         BEGSR
      *
     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  *PSSR  - Program Error Processing Subroutine.                *
      *                                                               *
      *  Called By: Various                                           *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR                                                  *** *PSSR  ***
      *
     C                   SETON                                        U7U8LR
      *
      * Check to see that *PSSR has not already been called.
     C     WRUN          IFEQ      *BLANK
     C                   MOVE      'Y'           WRUN              1
     C                   DUMP
     C                   ENDIF
      *
      * Exit program
     C                   RETURN
      *
     C                   ENDSR
      *
      *****************************************************************
