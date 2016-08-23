     H DEBUG
     H COPYRIGHT ('(c) Misys International Banking System Ltd. 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD File Drop of RWA files')
      *****************************************************************
      *                                                               *
      *  Midas - SD Module                                            *
      *                                                               *
      *  SD001245  - File Drop/Maintenance of RWA files               *
      *                                                               *
      *                                                               *
      *  Function:  This programm will be used to drop deleted        *
      *             RWA sets and RWA assets code during COB           *
      *                                                               *
      *                                                               *
      *  (c) Misys International Banking System Ltd. 2002             *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CGL018  *CREATE    Date 01OCT02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CGL018 - Risk Weighted Assets                                *
      *                                                               *
      *****************************************************************
      *                                                               *
      * Use of Indicators                                             *
      *                                                               *
      * Database Access Indicators                                    *
      *                                                               *
      * 20 - Access file SDRWACL0                                     *
      * 21 - Access file SDRWASL0                                     *
      * 30 - Database error - delete - file SDRWACL0                  *
      * 31 - Database error - delete - file SDRWASL0                  *
      *                                                               *
      * Other Indicators                                              *
      *                                                               *
      * 99 - Multi-purpose                                            *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * *PSSR  - Error processing                                     *
      * *INZSR - Initialise                                           *
      *                                                               *
      * DropRWA0     : Delete records flagged for deletion -          *
      *                                               RWA code        *
      * DropRWA1     : Delete records flagged for deletion -          *
      *                                               RWA assets code *
      * ExitPgm      : Exit Program                                   *
      *****************************************************************
      ** +--------------------------------------+
      ** | F-specs                              |
      ** | =======                              |
      ** +--------------------------------------+
      *
      **  Risk Weighted Asset Codes Master File
      *
     F****SDRWACL0  UF   E           K DISK    INFSR(*PSSR)  COMMIT
     FSDRWACL0  UF   E           K DISK    INFSR(*PSSR)
      *
      **  Risk Weighted Asset Master File
      *
     F****SDRWASL0  UF   E           K DISK    INFSR(*PSSR)  COMMIT
     FSDRWASL0  UF   E           K DISK    INFSR(*PSSR)
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** | D-specs                              |
      ** | =======                              |
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** | Arrays and Data Structures           |
      ** | ==========================           |
      ** +--------------------------------------+
      *
      **  Rundat DS
      *
     DRUNDAT         E DS                  EXTNAME(RUNDAT) DTAARA(RUNDAT)
      *
      *
      ** +--------------------------------------+
      ** | Declared variables                   |
      ** | ==================                   |
      ** +--------------------------------------+
      *
     D @RUN            S              1
      *
      *------------------------------------------------------------------------*
      /COPY ZACPYSRC,PSDS
      /COPY ZACPYSRC,STD_D_SPEC
      *------------------------------------------------------------------------*
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -----------------------------------+
      ** |                                                                |
      ** | Initial processing is performed automatically: the *INZSR is   |
      ** | executed at program activation.                                |
      ** |                                                                |
      ** +----------------------------------------------------------------+
      *
      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************
      *
      **  Start Main Process
      *
     C                   Exsr      DropRWA0
      *
     C                   Exsr      DropRWA1
      *
     C                   Exsr      ExitPgm
      *
      /EJECT
      *========================================================================*
      *                    S  U  B  R  O  U  T  I  N  E  S                     *
      *========================================================================*
      *
      *========================================================================*
      **************************************************************************
      * DropRWA0  : Delete records flagged for deletion - RWA code             *
      * ---------                                                              *
      * Called by : Main Procedure                                             *
      * Calls     :                                                            *
      **************************************************************************
     C     DropRWA0      BEGSR
      *
     C                   Read      SDRWACD0                               20
     C     *IN20         DowEq     *OFF
      *
     C                   If        RwReci='*' and RwLcd<=AGRDNB
      *
     C                   Delete    SDRWACD0                             30
      *
     C                   If        *IN30=*ON                                    ************
     C                   Eval      DBFILE = 'SDRWACPD'                          * DBERR 01 *
     C                   Eval      DBASE = 1                                    ************
     C                   Eval      DBKEY = RWCODE+RWSETN
     C                   Exsr      *PSSR
     C                   EndIf
      *
     C                   EndIf
      *
     C                   Read      SDRWACD0                               20
      *
     C                   EndDo
      *
     C                   ENDSR
      /EJECT
      **************************************************************************
      * DropRWA1  : Delete records flagged for deletion - RWA assets code      *
      * ---------                                                              *
      * Called by : Main Procedure                                             *
      * Calls     :                                                            *
      **************************************************************************
     C     DropRWA1      BEGSR
      *
     C                   Read      SDRWASD0                               21
     C     *IN21         DowEq     *OFF
      *
     C                   If        RwReci='*' and RwLcd<=AGRDNB
      *
     C                   Delete    SDRWASD0                             31
      *
     C                   If        *IN31=*ON                                    ************
     C                   Eval      DBFILE = 'SDRWASPD'                          * DBERR 02 *
     C                   Eval      DBASE = 2                                    ************
     C                   Eval      DBKEY = RWCODE+RWSETN
     C                   Exsr      *PSSR
     C                   EndIf
      *
     C                   EndIf
      *
     C                   Read      SDRWASD0                               21
      *
     C                   EndDo
      *
     C                   ENDSR
      /EJECT
     ******************************************************************
      * *INZSR - Program Initialisation routine                       *
      * ------                                                        *
      * Called by: Implicitly on program activation                   *
      * Calls    : None                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
      **  Initialise Copyright Array
      *
     C                   MOVEA     CPY@          CPY@@            80
      *
      **  Retrieve current Run Date
      *
     C                   IN        RUNDAT
      *
     C     *LOCK         IN        LDA
     C                   Eval      DBPGM='SD001245'
      *
     C                   ENDSR
      /EJECT
     ******************************************************************
      * ExitPgm - Exit Program                                        *
      * -------                                                       *
      * Called by : Main Process                                      *
      * Calls     : None                                              *
      *****************************************************************
     C     ExitPgm       BEGSR
      *
     C                   MOVE      *ON           *INLR
     C                   RETURN
      *
     C                   ENDSR
      /EJECT
     ******************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *  ----    Called automatically if a program error occurs,      *
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
     C                   ROLBK
      *
     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'
     C                   DUMP
     C                   ENDIF
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   OUT       LDA
     C                   RETURN
     C
      *
     C                   ENDSR
      *
**  CPY@
(c) Misys International Banking System Ltd. 2002.
