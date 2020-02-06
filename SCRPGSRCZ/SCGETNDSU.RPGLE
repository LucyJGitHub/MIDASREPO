      *****************************************************************
      *                                                               *
      *  MidasPlus System Control                                     *
      *                                                               *
      *  SCGETNDSU - Get journal sequence number of next day set up   *
      *                                                               *
      *  (c) Finastra International Limited 2005                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSC025  *CREATE    Date 03May05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSC025 - Exit program for high availability switchover.      *
      *                                                               *
      *****************************************************************
      *****************************************************************
      *  C R E A T I O N     P A R A M E T E R S                      *
      *                                                               *
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SC Get next day set up journal sequence')
      *                                                               *
      *****************************************************************
     H
     FQADSPJRN  UF   E             DISK
     C     *ENTRY        PLIST
     C                   PARM                    JRNSEQ           10 0
      *
      *  Start at the end of the file.
      *
     C     *HIVAL        SETGT     QADSPJRN
      *
      *  While beginning of file has not been reached,
      *
     C     *IN01         DOWEQ     '0'
      *
      *  read the previous record.
      *
     C                   READP     QJORDJE                                01
      *
      *  If a record was read,
      *
     C     *IN01         IFEQ      '0'
      *
      *  If the record is a next day set up record,
      *
     C     6             SUBST     JOESD:1       NDSUJR            6
     C     NDSUJR        IFEQ      'NDSUJR'
      *
      *  return the journal sequence number,
      *
     C                   MOVE      JOSEQN        JRNSEQ
      *
      *  and exit the program.
      *
     C                   MOVE      '1'           *INLR
     C                   RETURN
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDDO
      *
     C                   MOVE      '1'           *INLR
     C                   RETURN
