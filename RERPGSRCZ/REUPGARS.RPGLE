     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2005')
      *****************************************************************
      *                                                               *
      *  MidasPlus Retail Module                                      *
      *                                                               *
      *  REUPGARS - Update journal sequence number on REGARSPD        *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2005            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. BUG7278 *CREATE    Date 20May05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  BUG7278 - Error in initialisation of REGARSPD.               *
      *                                                               *
      *****************************************************************
      *  C R E A T I O N     P A R A M E T E R S                      *
      *                                                               *
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas RE Update journal sequence on REGARSPD')
      *                                                               *
      *****************************************************************
     FREGARSPD  UF A E             DISK
     C     *ENTRY        PLIST
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
      *  read record from REGARSPD
      *
     C                   READ      REGARSD0                               01
      *
      *  If a record was read,
      *
     C     *IN01         IFEQ      '0'
      *
      *  update the file with the journal sequence number received.
      *
     C                   MOVE      JRNSEQ        GSLJES
     C                   UPDATE    REGARSD0
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
      *  write a record to REGARSPD.
      *
     C                   WRITE     REGARSD0
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDDO
      *
     C                   MOVE      '1'           *INLR
     C                   RETURN
      *
      **********************************************************************************************
