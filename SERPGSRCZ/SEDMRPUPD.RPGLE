     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM Update temp SE Depot Movement file')          *
/*OVRF*: OVRDBF SEDMRPXX DPTMVD                                     : *
/*OVRF*: OVRDBF SEDMRPX1 DPTMVDY1                                   : *
/*OVRF*: OVRDBF SEDMRPX2 DPTMVDY2                                   : *
      *****************************************************************
      *                                                               *
      *  Midas - Money Market Dealing Module                          *
      *                                                               *
      *  SEDMRPUPD - MM Update SE temporary Depot file                *
      *                                                               *
      *  Function: This Program clears and updates the three files    *
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
      *                 233352             Date 06May05               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAP067  *CREATE    Date 24Sep01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSW210 - SWIFT 2010 Changes (Recompile)                      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  233352 - Problem in REPO API (Recompile)                     *
      *  CAP067 - Repurchase Agreements API.                          *
      *                                                               *
      *****************************************************************
 
     FSEDMRPXX  UF A E             DISK    USROPN
     F                                     INFSR(*PSSR)
 
     FSEDMRPX1  UF A E           K DISK    USROPN
     F                                     INFSR(*PSSR)
 
     FSEDMRPX2  UF A E           K DISK    USROPN
     F                                     INFSR(*PSSR)
 
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
 
     D**  Data structure of Temporary Depot Movement Extension File
     D SEDXX         E DS                  EXTNAME(SEDMRPXX)
 
     D**  Data structure of Temporary Depot Movement Extension File
     D SEDX1         E DS                  EXTNAME(SEDMRPX1)
 
     D**  Data structure of Temporary Depot Movement Extension File
     D SEDX2         E DS                  EXTNAME(SEDMRPX2)
 
     D**  Long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
     D**  Short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
      *
     C                   OPEN      SEDMRPXX
     C                   OPEN      SEDMRPX1
     C                   OPEN      SEDMRPX2
     C*
     C     DMRPMode      IFEQ      '*ClrXX '
     C                   EXSR      CLRXX
     C                   ENDIF
     C
     C     DMRPMode      IFEQ      '*ClrExt'
     C                   EXSR      CLREXT
     C                   ENDIF
     C
     C     DMRPMode      IFEQ      '*WrtXX '
     C                   EXSR      WRTXX
     C                   ENDIF
     C
     C     DMRPMode      IFEQ      '*WrtX1 '
     C                   EXSR      WRTX1
     C                   ENDIF
     C
     C     DMRPMode      IFEQ      '*WrtX2 '
     C                   EXSR      WRTX2
     C                   ENDIF
     C
     C                   CLOSE     SEDMRPXX
     C                   CLOSE     SEDMRPX1
     C                   CLOSE     SEDMRPX2
     C
     C                   RETURN
     C********************************************************************
     C* CLRXX - CLEAR SEDMRPXX
     C********************************************************************
     C     CLRXX         BEGSR
     C*
      *
     C* Clear temporary depot movements file
     C*
     C                   Z-ADD     21            MESLEN           15 5
     C                   CALL      'QCMDEXC'                            9999    *
     C                   PARM                    ##CF
     C                   PARM                    MESLEN
     C*
     C*
     C                   ENDSR
     C********************************************************************
     C* CLREXT - CLEAR SEDMRPX1, X2
     C********************************************************************
     C     CLREXT        BEGSR
     C*
     C* Clear temporary depot movements extention files
     C*
     C                   Z-ADD     21            MESLEN
     C                   CALL      'QCMDEXC'                            9999    *
     C                   PARM                    ##CF1
     C                   PARM                    MESLEN
     C*
     C                   Z-ADD     21            MESLEN
     C                   CALL      'QCMDEXC'                            9999    *
     C                   PARM                    ##CF2
     C                   PARM                    MESLEN
     C*
     C                   ENDSR
     C********************************************************************
     C* WRTX1  - WRITE TO SEDMRPX1
     C********************************************************************
     C     WRTX1         BEGSR
     C*
     C* Write to SEDMRPX1
     C*
     C                   WRITE     DPTMVDD1
     C*
     C                   ENDSR
     C********************************************************************
     C* WRTX2  - WRITE TO SEDMRPX2
     C********************************************************************
     C     WRTX2         BEGSR
     C*
     C* Write to SEDMRPX2
     C*
     C                   WRITE     DPTMVDD2
     C*
     C                   ENDSR
     C********************************************************************
     C* WRTXX  - WRITE TO SEDMRPXX
     C********************************************************************
     C     WRTXX         BEGSR
     C*
     C* Write to SEDMRPXX
     C*
     C                   WRITE     DPTMVDF
     C*
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
 
     C     *ENTRY        PLIST
     C                   PARM                    ReturnCode
     C                   PARM                    DMRPMode
     C                   PARM                    SEDXX
     C                   PARM                    SEDX1
     C                   PARM                    SEDX2
      *
      **  Move program name into *LDA field.
      *
     C     *LOCK         IN        LDA
     C                   MOVEL     'SEDMRPUPD'   DBPGM
     C                   OUT       LDA
      *
      *
     C                   ENDSR
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(C) Copyright Finastra International Limited 2001
** ##CF
CLRPFM QTEMP/SEDMRPXX
** ##CF1
CLRPFM QTEMP/SEDMRPX1
** ##CF2
CLRPFM QTEMP/SEDMRPX2
