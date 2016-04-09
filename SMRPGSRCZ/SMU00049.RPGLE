     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2002')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SM Add new SDBROKPD records if missing')
      *****************************************************************
      *                                                               *
      *  Midas - Implementation module                                *
      *                                                               *
      *  SMU00049 - Add New SDBROKPD Records If Missing.              *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *  Last Amend No. BG26993            Date 26Jan10               *
      *  Prev Amend No. CPK016  *CREATE    Date 10Jun03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  BG26993 - Delivery of upgrade programs to core.              *
      *          - Rename program CPK016R01.                          *
      *  CPK016  - Preparation for Global Processing.                 *
      *                                                               *
      *****************************************************************
     FSDBROKL2  UF A E           K DISK    INFSR(*PSSR)
      *
      /EJECT
      *
      /SPACE 3
     D PSDS           SDS
      *
      ** Program Status Data Structure
      *
     D  PGM              *PROC
     D  WSID                 244    253
     D  USER                 254    263
      *
      * Read all records to initialise field A9BROK
      * Check for MAIL record
     C     *LOVAL        SETLL     @BROKL2
     C     'MAIL'        CHAIN     @BROKL2                            90
      *
     C     *IN90         IFEQ      '1'
      * If MAIL record missing then add it.
     C                   MOVEL     'MAIL'        A9BROK
     C                   WRITE     @BROKL2
     C                   ENDIF
      *
      * Check for PHON record
     C     *LOVAL        SETLL     @BROKL2
     C     'PHON'        CHAIN     @BROKL2                            90
      *
     C     *IN90         IFEQ      '1'
      * If PHON record missing then add it.
     C                   MOVEL     'PHON'        A9BROK
     C                   WRITE     @BROKL2
     C                   ENDIF
      *
      * Check for SWAP record
     C     *LOVAL        SETLL     @BROKL2
     C     'SWAP'        CHAIN     @BROKL2                            90
      *
     C     *IN90         IFEQ      '1'
      * If SWAP record missing then add it.
     C                   MOVEL     'SWAP'        A9BROK
     C                   WRITE     @BROKL2
     C                   ENDIF
      *
      * Check for TELX record
     C     *LOVAL        SETLL     @BROKL2
     C     'TELX'        CHAIN     @BROKL2                            90
      *
     C     *IN90         IFEQ      '1'
      * If TELX record missing then add it.
     C                   MOVEL     'TELX'        A9BROK
     C                   WRITE     @BROKL2
     C                   ENDIF
      *
      * Set on *INLR
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
     C     @RUN          IFEQ      *BLANK
     C                   MOVE      'Y'           @RUN              1
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
