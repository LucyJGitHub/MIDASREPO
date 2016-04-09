     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2005')
      *****************************************************************
      *                                                               *
      *  MidasPlus System Control                                     *
      *                                                               *
      *  SCUPEMCE - Update receiver name and sequence number          *
      *             on EMCEXX1.                                       *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2005            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSC025  *CREATE    Date 03May05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSC025 - Exit program for high availability switchover.      *
      *                                                               *
      *****************************************************************
      *  C R E A T I O N     P A R A M E T E R S                      *
      *                                                               *
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SC Update receiver and sequence on EMCEXX1')
      *                                                               *
      *****************************************************************
     FEMCEXX1   UF   E             DISK
     C     *ENTRY        PLIST
     C                   PARM                    JRNRCV           10
     C                   PARM                    JRNSEQ           10 0
      *
      *  While end of file has not been reached,
      *
     C     *IN01         DOWEQ     '0'
      *
      *  read record from EMCEXX1.
      *
     C                   READ      EMCEXX1F                               01
      *
      *  If a record was read,
      *
     C     *IN01         IFEQ      '0'
      *
      *  update the file with the journal receiver and sequence number received.
      *
     C                   MOVE      JRNRCV        JNRCN
     C                   MOVE      JRNSEQ        JOSEQN
     C                   UPDATE    EMCEXX1F
      *
     C                   ENDIF
      *
     C                   ENDDO
      *
     C                   MOVE      '1'           *INLR
     C                   RETURN
      **********************************************************************************************
