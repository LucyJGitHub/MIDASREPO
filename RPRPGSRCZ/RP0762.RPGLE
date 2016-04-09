     H DEBUG
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas RP Replication starting journal entry reset.')   *
      *****************************************************************
      *                                                               *
      *  Private Banking Module                                       *
      *                                                               *
      *  RP0762 - Replication starting journal entry reset.           *
      *                                                               *
      *  Function:  This module resets starting journal entry from    *
      *             file REPBASExx/RPFEEDSQNO for all feeder jobs.    *
      *  (phase(s)) Input Cycle, Close of Business                    *
      *                                                               *
      *  Component of: RP0762                                         *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2012            *
      *                                                               *
      *  Last Amend No. 240771  *CREATE    Date 16Jul12               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  240771 - To take in account Replication V3R6M0 changes and   *
      *           more specially new Feeder Sequence Number file.     *
      *           Applied fix for AR995681.                           *
      *           (Child:AR995682)                                    *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    81         Replication Feeder Sequence Number file - EOF   *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * *PSSR - Error processing                                      *
      * *INZSR - Initialise                                           *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      **  Replication Feeder Sequence Number.
     FRPFEEDSQNOUF   E           K Disk
     F                                     Infsr(*Pssr)
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      /Eject
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      **  Array containing Copyright statement.
     D Cpy@            S             80    Dim(1) Ctdata Perrcd(1)
 
      **  External Data structure for Local data area (database error details).
     D LDA           E DS           256    Extname(LDA) Dtaara(LDA)
      ** The following fields are defined in the external file:
      **                                    134 141 DBFile
      **                                    142 170 DBKey
      **                                    171 180 DBPgm
      **                                    181 1830DBase
      **                                    184 193 DBMod
      **                                    194 203 DBProc
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      **  Feeder job number.
     D WFeedNumber     S              1
 
      **  Last journal sequence
     D PLastSeqNo      S             10
 
      **  Work Field used to produce only one dump.
     D @RUN            S              1
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************
 
      ** Bypass first '000000000000' record.
     C                   EVAL      RGFDRNUM ='1'
     C     RGFDRNUM      SETLL     RPFEEDSQNO
 
      ** Process all Feeder records.
 
     C                   READ      RPFEEDSQNO                             81
     C     *IN81         DOWEQ     *OFF
     C                   MOVE      PLastSeqNo    RGSEQNUM
     C                   UPDATE    RPFDSQNOD0
 
      ** Read next feeder record.
 
     C                   READ      RPFEEDSQNO                             81
 
     C                   END
 
      **  End Program and Return.
     C                   EVAL      *inlr = *ON
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *entry        PLIST
      ** Last journal sequence entry.
     C                   PARM                    PLastSeqNo
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: (**calling routines**)                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
      *
     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'
     C                   DUMP
      *
     C                   CALL      'DBERRCTL'
      *
     C                   ENDIF
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C                   ENDSR
 
      ********************************************************************
 
      *****************************************************************
**Ctdata Cpy@
(c) Misys International Banking Systems Ltd. 2012
