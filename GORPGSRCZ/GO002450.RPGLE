     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2013')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas GO Initialisation for GOLSTUPD')                 *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GO002450 - Midas GO Initialisation for GOLSTUPD              *
      *                                                               *
      *  (c) Finastra International Limited 2015                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. AR1082904 *CREATE  Date 09Feb15               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  AR1082904 - Credit Lines - Performance Issues - Critical     *
      *              (Child: AR1084389)                               *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** � F-specs                              �
      ** � =======                              �
      ** +--------------------------------------+
      ** Midas GO Universal Trans Updater's Last Update by Key
     FGOLSTUL0  UF A E           K DISK    INFSR(*PSSR)
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** � D-specs                              �
      ** � =======                              �
      ** +--------------------------------------+
     D LDA           E DS           256    EXTNAME(LDA) DTAARA(LDA)
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
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
      *
      ** Data Area giving Installation Control Details
      *
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
      *
     D/COPY ZACPYSRC,PSDS
      *
      ** Program Status Data Structure
      *
      ** +-----------------------------------------------------------------+
      ** D specs of the following types should be inserted after the
      ** relevant box.  *** Remove this text afterwards. ***
      ** +-----------------------------------------------------------------+
      *
      ** +--------------------------------------+
      ** � Declared variables                   �
      ** � ==================                   �
      ** +--------------------------------------+
     D WRun            S              1
     D Key_LSTU        S             20
      *
      ** +--------------------------------------+
      ** � Named constants                      �
      ** � ===============                      �
      ** +--------------------------------------+
     D Key_LSTU_ML     C                   'MLCommitId          '
     D Key_LSTU_CL     C                   'CLCommitId          '
     D Key_LSTU_ABC    C                   'ABCCommitId         '
      *
      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************
      *
      * Default last update CCID of ML
     C                   EVAL      Key_LSTU  = Key_LSTU_ML
     C                   EXSR      SRDefault
      *
      * Default last update CCID of CL
     C                   EVAL      Key_LSTU  = Key_LSTU_CL
     C                   EXSR      SRDefault
      *
      * Default last update CCID of ABC
     C                   EVAL      Key_LSTU  = Key_LSTU_ABC
     C                   EXSR      SRDefault
      *
     C                   SETON                                        LR
     C                   RETURN
      *
      ****************************************************************
      /EJECT
      ****************************************************************
      *                                                              *
      * SRDefault - Set default for 3 items                          *
      *                                                              *
      ****************************************************************
     C     SRDefault     BEGSR
      *
     C     Key_LSTU      CHAIN     GOLSTUL0
     C                   EVAL      LUPVAL = 0
     C                   IF        %FOUND(GOLSTUL0)
     C                   UPDATE    GOLSTUD0
     C                   ELSE
     C                   EVAL      LUPKEY = Key_LSTU
     C                   WRITE     GOLSTUD0
     C                   ENDIF
      *
     C                   ENDSR
      ****************************************************************
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
     C                   IF        WRun = *BLANK
     C                   EVAL      WRun = 'Y'
     C                   DUMP
     C                   ENDIF
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
      *
     C                   RETURN
      *
     C                   ENDSR
