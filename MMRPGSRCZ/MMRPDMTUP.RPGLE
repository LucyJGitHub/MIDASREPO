     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM Temporary Repo Depot Mvt update')
      *****************************************************************
      *                                                               *
      *  Midas - MM Dealer Module                                     *
      *                                                               *
      *  MMRPDMTUP - TEMPORARY REPO DEPOT MVT UPDATE                  *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Last Amend No. 256564             Date 17Sep08               *
      *  Prev Amend No. 247785             Date 15May07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 233352  *CREATE    Date 06May05               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAP067  *CREATE    Date 24Sep01               *
      *                                    Date                       *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  247785 - Recompile on MMTRPDMPD.                             *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  233352 - Problem in REPO API (Recompile)                     *
      *  CAP067 - Repurchase Agreements API.                          *
      *                                                               *
      *****************************************************************
     FMMTRPDML0 UF A E           K DISK
     F
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** Include the MM standard declares
     D/COPY ZACPYSRC,STDDECLARE
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      *****************************************************************
     D MMTRPDM       E DS                  EXTNAME(MMTRPDMPD)
      * EXTERNALLY DESCRIBED DATA STRUCTURE FOR VALID DEPOT MOVEMENT
 
     D XXTRPDM       E DS                  EXTNAME(MMTRPDMPD)
     D                                     PREFIX(XX)
      * EXTERNALLY DESCRIBED DATA STRUCTURE FOR VALID DEPOT MOVEMENT
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      * FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      * SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE
 
 
     D @@DPSS          S             10A
     D @@AFRT          S             20A
 
      /EJECT
     C*****************************************************************
     C*                                                               *
     C* MAIN - MAIN BODY                                              *
     C*                                                               *
     C*****************************************************************
 
     C/COPY WNCPYSRC,MMTRPDUC01
 
     C     UMODE         IFEQ      'I'
     C                   EXSR      INSERT
     C                   ENDIF
     C*
     C* Delete all Depot Movements for the deal
     C     UMODE         IFEQ      'D'
     C                   EXSR      DELETE
     C                   ENDIF
      *
     C* Remove a specific Depot Movement
     C     UMODE         IFEQ      'R'
     C                   EXSR      REMOVE
     C                   ENDIF
      *
     C* Insert Fee details into first Depot Movement
     C     UMODE         IFEQ      'F'
     C                   EXSR      INSFEE
     C                   ENDIF
      *
      * EXIT FROM PROGRAM
      *
     C                   RETURN
     C****************************************************************
      /EJECT
     C****************************************************************
     C*                                                              *
     C* INSERT - INSERT DEPOT MOVEMENT INTO TEMPORARY FILE           *
     C*                                                              *
     C****************************************************************
     C     INSERT        BEGSR
     C*
     C* Store the record to be inserted in a temporary DS
     C                   MOVE      MMTRPDM       XXTRPDM
     C*
     C* Delete any records with the same Asso FO Tran# and Security Name
     C                   MOVE      DMAFRT        @@AFRT
     C                   MOVE      DPSS          @@DPSS
     C     @@AFRT        CHAIN     MMTRPDMD0                          99
     C*
     C     *IN99         DOWEQ     *OFF
     C                   IF        DPSS=@@DPSS
     C                   DELETE    MMTRPDMD0
     C                   ENDIF
     C     @@AFRT        READE     MMTRPDMD0                              99
     C                   ENDDO
     C*
     C* Now write in the new record
     C                   MOVE      XXTRPDM       MMTRPDM
     C                   WRITE     MMTRPDMD0
     C*
     C                   ENDSR
     C****************************************************************
      /EJECT
     C****************************************************************
     C*                                                              *
     C* DELETE - DELETE LOAN/DEPOSITS FROM TEMPORARY FILE            *
     C*                                                              *
     C****************************************************************
     C     DELETE        BEGSR
      *
     C                   MOVE      DMAFRT        @@AFRT
     C     @@AFRT        CHAIN     MMTRPDMD0                          99
      *
     C     *IN99         DOWEQ     *OFF
     C                   DELETE    MMTRPDMD0
     C     @@AFRT        READE     MMTRPDMD0                              99
     C                   ENDDO
      *
     C                   ENDSR
     C****************************************************************
      /EJECT
     C****************************************************************
     C*                                                              *
     C* INSFEE - INSERT FEE DETAILS INTO THE FIRST DEPOT MOVEMENT    *
     C*                                                              *
     C****************************************************************
     C     INSFEE        BEGSR
      *
     C* Store fees detail in the temporary DS
     C                   CLEAR                   XXTRPDM
     C                   MOVE      DCCE          XXDCCE
     C                   Z-ADD     DCHA          XXDCHA
     C                   Z-ADD     DCSE          XXDCSE
     C                   MOVE      DCAB          XXDCAB
     C                   MOVE      DCAT          XXDCAT
     C*
     C* Retrieve the first depot movement
     C                   MOVE      DMAFRT        @@AFRT
     C     @@AFRT        CHAIN     MMTRPDMD0                          99
     C*
     C* Add the fee details
     C                   IF        *IN99=*ON
     C                   EXSR      SRERR
     C*
     C                   ELSE
     C                   MOVE      XXDCCE        DCCE
     C                   Z-ADD     XXDCHA        DCHA
     C                   Z-ADD     XXDCSE        DCSE
     C                   MOVE      XXDCAB        DCAB
     C                   MOVE      XXDCAT        DCAT
     C                   UPDATE    MMTRPDMD0
     C                   ENDIF
     C*
     C* Ensure other Depot Movements for the same deal have no fees
     C     @@AFRT        READE     MMTRPDMD0                              99
     C     *IN99         DOWEQ     *OFF
     C                   MOVE      *BLANKS       DCCE
     C                   Z-ADD     *ZERO         DCHA
     C                   Z-ADD     *ZERO         DCSE
     C                   MOVE      *BLANKS       DCAB
     C                   MOVE      *BLANKS       DCAT
     C                   UPDATE    MMTRPDMD0
     C     @@AFRT        READE     MMTRPDMD0                              99
     C                   ENDDO
      *
     C                   ENDSR
     C****************************************************************
      /EJECT
     C****************************************************************
     C*                                                              *
     C* REMOVE - REMOVE A SPECIFIC DEPOT MOVEMENT                    *
     C*                                                              *
     C****************************************************************
     C     REMOVE        BEGSR
      *
     C                   CLEAR                   XXTRPDM
     C                   MOVE      DPSS          XXDPSS
     C                   MOVE      DMAFRT        @@AFRT
     C*
     C     @@AFRT        CHAIN     MMTRPDMD0                          99
     C*
     C     *IN99         DOWEQ     *OFF
     C                   IF        DPSS = XXDPSS
     C                   DELETE    MMTRPDMD0
     C                   ENDIF
     C*
     C     @@AFRT        READE     MMTRPDMD0                              99
     C                   ENDDO
      *
     C                   ENDSR
     C****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
      *
      **  PROGRAM PARAMETERS
      *
     C     *ENTRY        PLIST
     C                   PARM                    @@RTCD            7
     C                   PARM                    UMODE             1
     C                   PARM                    MMTRPDM
      *
     C*
     C                   ENDSR
     C****************************************************************
      /EJECT
     C****************************************************************
     C*                                                              *
     C* SRERR - EXCEPTION ERRORS                                     *
     C*                                                              *
     C****************************************************************
     C     SRERR         BEGSR
     C*
     C                   MOVEL     '*ERROR '     @@RTCD
     C                   MOVEL     'MMRPDMTUP'   DBPGM            10
     C                   MOVE      '1'           *INU7
     C                   MOVE      '1'           *INU8
     C                   MOVE      '1'           *INLR
     C                   DUMP
     C*
     C**  TERMINATE THE PROGRAM
     C*
     C                   RETURN
     C*
     C                   ENDSR
     C****************************************************************
**  CPY@
(C) Copyright Misys International Banking Systems Ltd. 2001
