     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2005')
      *****************************************************************
      *                                                               *
      *  MidasPlus System Control                                     *
      *                                                               *
      *  SCUPGOOS - Update journal sequence number on GOOSJSPD        *
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
      *  C R E A T I O N     P A R A M E T E R S                      *
      *                                                               *
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SC Update journal sequence on GOOSJSPD')
      *                                                               *
      *****************************************************************
     FGOOSJSPD  UF A E             DISK
     C     *ENTRY        PLIST
     C                   PARM                    JRNRCV           10
     C                   PARM                    JRNSEQ           10 0
      *
      *  Set first record flag to 'Y'
      *
     C                   MOVE      'Y'           FIRST             1
      *
      *  While end of file has not been reached,
      *
     C     *IN01         DOWEQ     '0'
      *
      *  read record from GOOSJSPD.
      *
     C                   READ      GOOSJSD0                               01
      *
      *  If a record was read,
      *
     C     *IN01         IFEQ      '0'
      *
      *  update the file with the journal receiver and sequence number received.
      *
     C                   MOVE      JRNSEQ        I#LASTSEQ
     C                   UPDATE    GOOSJSD0
      *
      *  Set first record flag to 'N'
      *
     C                   MOVE      'N'           FIRST             1
      *
      *  If a record was NOT read,
      *
     C                   ELSE
      *
      *  If this was the first attempt to read a record,
      *
     C     FIRST         IFEQ      'Y'                                          B003
      *
      *  write a record to GOOSJSPD.
      *
     C                   WRITE     GOOSJSD0
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDDO
      *
     C                   MOVE      '1'           *INLR
     C                   RETURN
      **********************************************************************************************
