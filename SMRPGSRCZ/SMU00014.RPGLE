     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2007')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SM API Upgrade Program for CAP007')
      *****************************************************************
      *                                                               *
      *  Midas - Implementation module                                *
      *                                                               *
      *  SMU00014 - API Upgrade for CAP007                            *
      *                                                               *
      *  Function:  This program upgrades the file APINVLPD to move   *
      *             the values of APDLNO to a new field which is      *
      *             APTRAN                                            *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *  Last Amend No. BG26993            Date 26Jan10               *
      *  Prev Amend No. CAP007  *CREATE    Date 03Feb00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  BG26993 - Delivery of upgrade programs to core.              *
      *          - Renamed program CAP00701.                          *
      *  CAP007  - Conversion of PM inputs into modular structure     *
      *            to use as APIs                                     *
      *                                                               *
      *****************************************************************
     FAPINVLPD  UF   E             DISK    INFSR(*PSSR)
      ** Midas API Invalid Records
      *
      /EJECT
      *
      ** Data Area giving Installation Control Details
      *
     D PSDS           SDS
      *
      ** Program Status Data Structure
      *
     D  PGM              *PROC
     D  WSID                 244    253
     D  USER                 254    263
      *
      * Read all records to initialise field APTRAN
     C     1             SETLL     APINVLD0
     C                   READ      APINVLD0                               90
      *
     C     *IN90         DOWEQ     '0'
     C                   MOVEL     APDLNO        APTRAN
     C                   MOVEL     *BLANKS       APDLNO
     C                   UPDATE    APINVLD0
     C                   READ      APINVLD0                               90
     C                   ENDDO
      *
      * Set on *INLR
      *
     C                   MOVE      '1'           *INLR
     C                   RETURN
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C     Recursive     IFEQ      *BLANK
     C                   MOVE      'Y'           Recursive         1
     C                   DUMP
      *
     C                   ENDIF
      *
     C                   SETON                                        U7U8LR
     C                   RETURN
      *
     C                   ENDSR
      *
      ********************************************************************
