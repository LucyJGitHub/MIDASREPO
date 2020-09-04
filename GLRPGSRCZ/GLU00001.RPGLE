     H DEBUG
     H CVTOPT(*VARCHAR)
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2008')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  ALWNULL(*USRCTL)                                             *
/*EXI *  TEXT('Midas GL Drop T_GZBITPEX by Zone')                     *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GLU00001 - Midas GL Drop T_GZBITPEX by Zone                  *
      *                                                               *
      *  Function:  This program deletes records from T_GZBITPEX.     *
      *  (phase(s)) I/C Initiation.                                   *
      *                                                               *
      *  Called By: GLC01 - Midas GL Next day set up                  *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2008            *
      *                                                               *
      *  Last Amend No. EML102  *CREATE    Date 28Nov19               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  EML102 - Upgrade of UNL007 to FB2.1 SP23                     *
      *           UNL007 - Extended Narratives                        *
      *                                                               *
      *****************************************************************
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
     FGZBITPV0  UF   E           K DISK
      *** Midas GL Extended Narrative Details - T_GZBITPEX
      *
     FGPZONEL2  IF   E           K DISK
      ***   Retrieve Zone once
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     D LDA           E DS           256    EXTNAME(LDA)
      *
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
      *
     D SDSTAT        E DS                  EXTNAME(SDSTAT)
      ***  need to retrieve Prefix (LIBR) to handled "Zone" records
      *

      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.

     D/COPY ZACPYSRC,PSDS
      *
      ** Program Status Data Structure
      *
      ** +-----------------------------------------------------------------+
      ** D specs of the following types should be inserted after the
      ** relevant box.  *** Remove this text afterwards. ***
      ** +-----------------------------------------------------------------+

      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

     D @RUN            S              1

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
      *
      ***  Read GZBITHEX records corresponding to the zone and delete them.
      *
     C     ZOZONE        SETLL     GZBITPEX                           9999
     C                   DOW       NOT *IN99
     C     ZOZONE        DELETE    GZBITPEX                           99
     C                   ENDDO
      *
      ****  End process
      *
     C                   MOVE      *ON           *INLR
     C                   RETURN

      **********************************************************************
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

     C     *DTAARA       DEFINE                  LDA
      *
      ** Retrieve Zone
      *
     C     *DTAARA       DEFINE                  SDSTAT
     C                   IN        SDSTAT
      *
     C     LIBR          CHAIN     GPZONEL2
     C                   IF        Not %Found(GPZONEL2)
     C                   MOVE      *ON           *INLR
     C                   RETURN
     C                   ENDIF

     C                   ENDSR

      *
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
      *
     C     *PSSR         BEGSR
      *
     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'
     C                   DUMP
     C                   ENDIF
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C                   ENDSR
      *
