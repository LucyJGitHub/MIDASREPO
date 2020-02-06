     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MX Extract General Ledger Statement Lines')
      *****************************************************************
      *                                                               *
      *  Midas - Meridian Export Module                               *
      *                                                               *
      *  MXEXTGLSL - Extract General Ledger Statement Lines           *
      *                                                               *
      *  Function:  This module extracts general ledger statement     *
      *             lines                                             *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD027             Date 09Dec05               *
      *                 CGL029             Date 01Sep03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CMX001  *CREATE    Data 01Jan00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CMX003 - Meridian Export Enhancements - Phase 2              *
      *                                                               *
      *****************************************************************
 
     FAPOST     IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(O_)
     FMXGLSLPD  O    E             DISK    INFSR(*PSSR)
     F                                     PREFIX(O_)
 
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
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
 
     D GLSLX         E DS                  EXTNAME(MXGLSLPD)
     D                                     PREFIX(O_)
 
     D P_ACOD          S             10S 0                                                    CGL029
 
     C                   CLEAR                   GLSLX
 
     C                   MOVE      P_BRCA        O_BRCA
     C                   MOVE      P_CNUM        O_CNUM
     C                   MOVE      P_CCY         O_CCY
     C                   MOVE      P_ACOD        O_ACOD
     C                   MOVE      P_ACSQ        O_ACSQ
 
     C                   EXSR      POSTINGS
 
     C                   Z-ADD     O_SEQN        P_SEQN
 
     C                   RETURN
 
      ********************************************************************
     C     POSTINGS      BEGSR
 
      *  OUTPUT B/F STATEMENT BALANCE
 
     C                   MOVEL     'B'           O_RECTYP
     C                   Z-ADD     P_CFSB        O_ACBAL
     C                   ADD       1             O_SEQN
     C                   WRITE     MXGLSLP0
 
      ** Get first posting record after at last statement date
 
     C     klistLSTD     SETGT     APOSTPDF
     C     klist         READE     APOSTPDF                               99
 
      ** Loop through all postings
 
     C     *IN99         DOWEQ     '0'                                          - B1
 
      ** OUTPUT POSTING
 
     C                   MOVEL     ' '           O_RECTYP
     C                   ADD       1             O_SEQN
     C                   WRITE     MXGLSLP0
 
     C     O_DRCR        IFEQ      1
     C                   SUB       O_PSTA        O_ACBAL
     C                   ELSE
     C                   ADD       O_PSTA        O_ACBAL
     C                   ENDIF
 
     C     klist         READE     APOSTPDF                               99
      *
     C                   ENDDO
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           30
 
     C                   PARM                    P_BRCA            3
     C**********         PARM                    P_CNUM            6 0                        CSD027
     C                   PARM                    P_CNUM            6                          CSD027
     C                   PARM                    P_CCY             3
     C**********         PARM                    P_ACOD            4 0                        CGL029
     C                   PARM                    P_ACOD                                       CGL029
     C                   PARM                    P_ACSQ            2 0
 
     C                   PARM                    P_CFSB           15 0
     C                   PARM                    P_LSTD            5 0
     C                   PARM                    P_NSTD            5 0
 
     C                   PARM                    P_SEQN            5 0
 
      **  KLIST to read APOSTPD
 
     C     klist         KLIST
     C                   KFLD                    O_BRCA
     C                   KFLD                    O_CNUM
     C                   KFLD                    O_CCY
     C                   KFLD                    O_ACOD
     C                   KFLD                    O_ACSQ
 
      **  KLIST to SETLL on APOSTPD
 
     C     klistLSTD     KLIST
     C                   KFLD                    O_BRCA
     C                   KFLD                    O_CNUM
     C                   KFLD                    O_CCY
     C                   KFLD                    O_ACOD
     C                   KFLD                    O_ACSQ
     C                   KFLD                    P_LSTD
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY MXCPYSRC,MXPSSR
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2001
