     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM Create temp SE Depot Movement file')          *
/*OVRF*: OVRDBF SEDMRPXX DPTMVD                                     : *
/*OVRF*: OVRDBF SEDMRPX1 DPTMVDY1                                   : *
/*OVRF*: OVRDBF SEDMRPX2 DPTMVDY2                                   : *
      *****************************************************************
      *                                                               *
      *  Midas - Money Market Dealing Module                          *
      *                                                               *
      *  SEDMRPCRT - MM Create SE temporary Depot file                *
      *                                                               *
      *  Function: This Program creates the three files               *
      *            SEDMRPXX                                           *
      *            SEDMRPX1                                           *
      *            SEDMRPX2                                           *
      *            Which are used as temporary files to store depot   *
      *            movements before they are updated to the Midas     *
      *            database                                           *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CSW210             Date 04May10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 222727             Date 05Nov03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAP067  *CREATE    Date 24Sep01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSW210 - SWIFT 2010 Changes (Recompile)                      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  222727 - Release 5.0 errors  (Recompile)                     *
      *  CAP067 - Repurchase Agreements API.                          *
      *                                                               *
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
 
 
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
      **--------------------------------------------------------------------------------------------
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D ##C1            S              1    DIM(77) CTDATA PERRCD(77)
     D ##C2            S              1    DIM(77) CTDATA PERRCD(77)
     D ##CM            S              1    DIM(77) CTDATA PERRCD(77)
     D ##CF            S              1    DIM(21) CTDATA PERRCD(21)
     D ##CF1           S              1    DIM(21) CTDATA PERRCD(21)
     D ##CF2           S              1    DIM(21) CTDATA PERRCD(21)
 
     D DMRPMode        S              7A
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      **  Data structure of Temporary Depot Movement Extension File
     D SEDXX         E DS                  EXTNAME(SEDMRPXX)
 
      **  Data structure of Temporary Depot Movement Extension File
     D SEDX1         E DS                  EXTNAME(SEDMRPX1)
 
      **  Data structure of Temporary Depot Movement Extension File
     D SEDX2         E DS                  EXTNAME(SEDMRPX2)
 
      **  Long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      **  Short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
 
      *
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
      *
 
     C                   EXSR      CREATE
 
     C
     C                   RETURN
 
      ********************************************************************
      * CREATE - CREATE FILES
      ********************************************************************
     C     CREATE        BEGSR
      *
      ** Create Temporary Depot Movements for Repos File
      *
     C                   Z-ADD     58            MESLEN           15 5
     C                   CALL      'QCMDEXC'                            9999    *
     C                   PARM                    ##CM
     C                   PARM                    MESLEN
      *
      ** Clear temporary depot movements file
      *
     C                   Z-ADD     21            MESLEN
     C                   CALL      'QCMDEXC'                            9999    *
     C                   PARM                    ##CF
     C                   PARM                    MESLEN
      *
      ** Create Temporary Depot Movements for Repos Extension File 1
      *
     C                   Z-ADD     60            MESLEN
     C                   CALL      'QCMDEXC'                            9999    *
     C                   PARM                    ##C1
     C                   PARM                    MESLEN
      *
      ** Clear temporary depot movements extention file 1
      *
     C                   Z-ADD     21            MESLEN
     C                   CALL      'QCMDEXC'                            9999    *
     C                   PARM                    ##CF1
     C                   PARM                    MESLEN
      *
      ** Create Temporary Depot Movements for Repos Extension File 2
      *
     C                   Z-ADD     60            MESLEN
     C                   CALL      'QCMDEXC'                            9999    *
     C                   PARM                    ##C2
     C                   PARM                    MESLEN
      *
      ** Clear temporary depot movements extention file 2
      *
     C                   Z-ADD     21            MESLEN
     C                   CALL      'QCMDEXC'                            9999    *
     C                   PARM                    ##CF2
     C                   PARM                    MESLEN
 
     C                   ENDSR
     C********************************************************************
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
 
      **  Move program name into *LDA field.
      *
     C     *LOCK         IN        LDA
     C                   MOVEL     'SEDMRPCRT'   DBPGM
     C                   OUT       LDA
      *
     C                   ENDSR
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(C) Copyright Finastra International Limited 2001
** ##C1
CPYF FROMFILE(DPTMVDY1) TOFILE(QTEMP/SEDMRPX1) CRTFILE(*YES) MBROPT(*REPLACE)
** ##C2
CPYF FROMFILE(DPTMVDY2) TOFILE(QTEMP/SEDMRPX2) CRTFILE(*YES) MBROPT(*REPLACE)
** ##CM
CPYF FROMFILE(DPTMVD) TOFILE(QTEMP/SEDMRPXX) CRTFILE(*YES) MBROPT(*REPLACE)
** ##CF
CLRPFM QTEMP/SEDMRPXX
** ##CF1
CLRPFM QTEMP/SEDMRPX1
** ##CF2
CLRPFM QTEMP/SEDMRPX2
