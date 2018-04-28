     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MA Retrieve Microfiche OutQs Details')
      *****************************************************************
      *                                                               *
      *  Midas - Microfiche Module                                    *
      *                                                               *
      *  MA000011 - Microfiche Output Queue Retrieval Run             *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CFC002  *CREATE    Date 29Apr02               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  CFC002 - Multiple Output Queues In Std Output Instructions   *
      *                                                               *
      *****************************************************************
     FMAFOQPPD  IF   E             DISK
      *
      /EJECT
      *****************************************************************
      *
      /EJECT
      *****************************************************************
      *
      *                M A I N  P R O C E S S I N G
      *
      *****************************************************************
     C     *ENTRY        PLIST
     C                   PARM                    PFLG              1            Mfiche Flag
     C                   PARM                    POQ1             10            Mfiche Outq
     C                   PARM                    POQ2             10            Mfiche Outq
     C                   PARM                    POQ3             10            Mfiche Outq
     C                   PARM                    POQ4             10            Mfiche Outq
     C                   PARM                    POQ5             10            Mfiche Outq
     C                   PARM                    POQ6             10            Mfiche Outq
     C                   PARM                    POQ7             10            Mfiche Outq
     C                   PARM                    POQ8             10            Mfiche Outq
     C                   PARM                    POQ9             10            Mfiche Outq
     C                   PARM                    POQ10            10            Mfiche Outq
      *
     C                   READ      MAFOQPPD                               55
      *
      ** If record found, retrieve outq names
      *
     C     *IN55         IFEQ      '0'
     C                   MOVE      MFOQ01        POQ1
     C                   MOVE      MFOQ02        POQ2
     C                   MOVE      MFOQ03        POQ3
     C                   MOVE      MFOQ04        POQ4
     C                   MOVE      MFOQ05        POQ5
     C                   MOVE      MFOQ06        POQ6
     C                   MOVE      MFOQ07        POQ7
     C                   MOVE      MFOQ08        POQ8
     C                   MOVE      MFOQ09        POQ9
     C                   MOVE      MFOQ10        POQ10
     C                   MOVE      MFMCRO        PFLG
     C                   ENDIF
      *
     C                   MOVE      '1'           *INLR
     C                   RETURN
      *
