     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2005')
      *****************************************************************
      *                                                               *
      *  MidasPlus Global Processing                                  *
      *                                                               *
      *  GPUTJSEQ - Update journal sequence number on GPUTJSPD        *
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
/*EXI *  TEXT('Midas GP Update journal sequence on GPUTJSPD')
      *                                                               *
      *****************************************************************
     H
     FGPUTJSPD  UF A E             DISK
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
     C     *IN01         DOWEQ     '0'                                          B001
      *
      *  read record from GPUTJSPD.
      *
     C                   READ      GPUTJSD0                               01
      *
      *  If a record was read,
      *
     C     *IN01         IFEQ      '0'                                          B002
      *
      *  update the file with the journal sequence number received.
      *
     C                   MOVE      JRNSEQ        I#LASTSEQ
     C                   UPDATE    GPUTJSD0
      *
      *  Set first record flag to 'N'
      *
     C                   MOVE      'N'           FIRST             1
      *
      *  If a record was NOT read,
      *
     C                   ELSE                                                   X002
      *
      *  If this was the first attempt to read a record,
      *
     C     FIRST         IFEQ      'Y'                                          B003
      *
      *  write a record to GPUTJSPD.
      *
     C                   WRITE     GPUTJSD0
      *
     C                   ENDIF                                                  E003
      *
     C                   ENDIF                                                  E002
      *
     C                   ENDDO                                                  E001
      *
     C                   MOVE      '1'           *INLR
     C                   RETURN
      **********************************************************************************************
