     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas RE Cash Management Live Frnt End Hier Update')
/*XBIA*  OVRDBF FILE(RELACCHPDN) TOFILE(RELACCHPD) SHARE(*NO)         *
/*XBIB*  OVRDBF FILE(RELACCMPDN) TOFILE(RELACCMPD) SHARE(*NO)         *
/*XBIC*  OVRDBF FILE(RELZSHXPDN) TOFILE(RELZSHXPD) SHARE(*NO)         *
/*XBID*  OVRDBF FILE(RELZSMXPDN) TOFILE(RELZSMXPD) SHARE(*NO)         *
/*XBIE*  OVRDBF FILE(RELGAHXPDN) TOFILE(RELGAHXPD) SHARE(*NO)         *
/*XBIF*  OVRDBF FILE(RELGAMXPDN) TOFILE(RELGAMXPD) SHARE(*NO)         *
      *****************************************************************
      *                                                               *
      *  Midas - Retail Module                                        *
      *                                                               *
      *  RE100406 - Cash Management 'Live' Front End Hierarchy Update *
      *                                                               *
      *  Function:  This program sets the 'live' cash management      *
      *             front end hierarchy files with data from the      *
      *             cash management front end hierarchy files.        *
      *             Only hierarchies that are live and not future     *
      *             dated are held on the 'live' cash management      *
      *             front end hierarchy files.                        *
      *             'Live' cash management front end hierarchy files: *
      *             RELACCHPD, RELACCMPD, RELZSHXPD, RELZSMXPD        *
      *             RELGAHXPD, RELGAMXPD                              *
      *             Cash management front end hierarchy files:        *
      *             REACCHPD, REACCMPD, REZSHXPD, REZSMXPD            *
      *             REGAHXPD, REGAMXPD                                *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD027             Date 09Dec05               *
      *                 214360             Date 03Feb03               *
      *                 212466             Date 10Jan03               *
      *                 CRE008  *CREATE    Date 06Mar02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  214360 - Cash Management Deferred Posting                    *
      *  212466 - Hierarchies become effective from next working day  *
      *  CRE008 - Cash Management                                     *
      *                                                               *
      *****************************************************************
 
 
      * F R O N T   E N D   F I L E S
      * -----------------------------
 
      * Account Hierarchy Header
      * Account Hierarchy Member
     FREACCHPD  IF   E           K DISK    INFSR(*PSSR)
     FREACCML0  IF   E           K DISK    INFSR(*PSSR)
 
      * Zero Balance/Sweeping Header Extension
      * Zero Balance/Sweeping Member Extension
     FREZSHXPD  IF   E           K DISK    INFSR(*PSSR)
     FREZSMXPD  IF   E           K DISK    INFSR(*PSSR)
 
      * Group Account Header Extension
      * Group Account Member Extension
     FREGAHXPD  IF   E           K DISK    INFSR(*PSSR)
     FREGAMXPD  IF   E           K DISK    INFSR(*PSSR)
 
 
      * C U R R E N T  ' L I V E '  F R O N T   E N D   F I L E S
      * ---------------------------------------------------------
 
      * Live Account Hierarchy Header
      * Live Account Hierarchy Member
     FRELACCHPD IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(REACCHD0:C_REACCHD0)
     FRELACCML0 IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(REACCMD0:C_REACCMD0)
 
      * Live Zero Balancing/Sweeping Header Extension
      * Live Zero Balancing/Sweeping Member Extension
     FRELZSHXPD IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(REZSHXD0:C_REZSHXD0)
     FRELZSMXPD IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(REZSMXD0:C_REZSMXD0)
 
      * Live Group Account Header Extension
      * Live Group Account Member Extension
     FRELGAHXPD IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(REGAHXD0:C_REGAHXD0)
     FRELGAMXPD IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(REGAMXD0:C_REGAMXD0)
 
      * N E W  ' L I V E '  F R O N T   E N D   F I L E S
      * -------------------------------------------------
 
      * Cash Management Live Account Hierarchy Header
      * Cash Management Live Account Hierarchy Member
     FRELACCHPDNO    E           K DISK    INFSR(*PSSR)
     F                                     RENAME(REACCHD0:N_REACCHD0)
     FRELACCMPDNO    E           K DISK    INFSR(*PSSR)
     F                                     RENAME(REACCMD0:N_REACCMD0)
 
      * Cash Management Live Zero/Sweeping Header Extension
      * Cash Management Live Zero/Sweeping Member Extension
     FRELZSHXPDNO    E           K DISK    INFSR(*PSSR)
     F                                     RENAME(REZSHXD0:N_REZSHXD0)
     FRELZSMXPDNO    E           K DISK    INFSR(*PSSR)
     F                                     RENAME(REZSMXD0:N_REZSMXD0)
 
      * Cash Management Live Group Account Header Extension
      * Cash Management Live Group Account Member Extension
     FRELGAHXPDNO    E           K DISK    INFSR(*PSSR)
     F                                     RENAME(REGAHXD0:N_REGAHXD0)
     FRELGAMXPDNO    E           K DISK    INFSR(*PSSR)
     F                                     RENAME(REGAMXD0:N_REGAMXD0)
 
 
      ** Cash Management 'Live' Front End Hierarchy Update Audit
     FRE100406AUO    E             PRINTER
     F                                     INFSR(*PSSR)
     F                                     INFDS(SPOOLU)
 
      *****************************************************************
      * Standard D Specifications
     D/COPY ZACPYSRC,RECMSTDD
      * Program Status Data Structure
     D/COPY ZACPYSRC,PSDS
      *****************************************************************
 
 
      ** Parameters for ZSFILE
     D PSeq            S              5
     D PEnty           S              3
     D ZSnum           S              6  0
     D ZSnumU          S              6  0
     D ZSerr           S              1
 
 
      ** File Information Data Structure for RE100406
     D SPOOLU          DS
     D  PSFileU               83     92
     D  PSFNumU              123    124B 0
 
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** Externally described DS for bank details
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** DS for access programs - short data structure
 
 
      /SPACE 5
 
 
      * Read all Account Hierarchy Header records
 
     C                   READ      REACCHPD                               60
 
     C     *IN60         DOWEQ     *OFF
 
     C                   ADD       1             INCNT
 
      * If the hierarchy has a status of 'WORK IN PROGRESS'
      * or if the date effective is in the future
      *     Carry over 'Current' Hierarchy data
      * Otherwise
      *     Take On 'New' Hierarchy data
 
     C     HISTAT        IFEQ      'W'
     C     HIDEFR        ORGT      BJDNWD                                       212466
     C*****HIDEFR********ORGT      BJRDNB                                       212466
 
     C                   EXSR      CARRYOVER_H
     C                   EXSR      CARRYOVER_M
 
     C                   ELSE
 
     C                   ADD       1             TOCNT
 
     C                   EXSR      TAKEON_H
     C                   EXSR      TAKEON_M
 
     C                   ENDIF
 
      * Read next Account Hierarchy Header record
 
     C                   READ      REACCHPD                               60
 
     C                   ENDDO
 
      * Write Audit Report
 
     C                   EXSR      AUDIT
 
     C                   SETON                                        LR
     C                   RETURN
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * CARRYOVER_H - Carry over Hierarchy Headers
      ********************************************************************
     C     CARRYOVER_H   BEGSR
 
      * Pick up 'Current' REACCHPD record
 
     C     HIID          CHAIN     C_REACCHD0                         60
 
      * If no record currently, then end
 
     C     *IN60         IFEQ      *ON
     C                   GOTO      ECARRYOVER_H
     C                   ENDIF
 
     C                   ADD       1             COCNT
 
      * Write a record to the 'New' REACCHPD
 
     C                   WRITE     N_REACCHD0
 
      * Pick up 'Current' REZSHXPD record
 
     C     HIID          CHAIN     C_REZSHXD0                         60
 
      * Write a record to the 'New' REZSHXPD
 
     C     *IN60         IFEQ      *OFF
     C                   WRITE     N_REZSHXD0
     C                   ENDIF
 
      * Pick up 'Current' REGAHXPD record
 
     C     HIID          CHAIN     C_REGAHXD0                         60
 
      * Write a record to the 'New' REGAHXPD
 
     C     *IN60         IFEQ      *OFF
     C                   WRITE     N_REGAHXD0
     C                   ENDIF
 
     C     ECARRYOVER_H  ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * CARRYOVER_M - Carry over Hierarchy Members
      ********************************************************************
     C     CARRYOVER_M   BEGSR
 
     C     HIID          SETLL     C_REACCMD0
     C     HIID          READE     C_REACCMD0                             60
 
      * Read all members for this hierarchy
 
     C     *IN60         DOWEQ     *OFF
 
      * Write a record to the 'New' REACCMPD
 
     C                   WRITE     N_REACCMD0
 
      * Pick up 'Current' REZSMXPD record
 
     C     MEID          CHAIN     C_REZSMXD0                         60
 
      * Write a record to the 'New' REZSMXPD
 
     C     *IN60         IFEQ      *OFF
     C                   WRITE     N_REZSMXD0
     C                   ENDIF
 
      * Pick up 'Current' REGAMXPD record
 
     C     MEID          CHAIN     C_REGAMXD0                         60
 
      * Write a record to the 'New' REGAMXPD
 
     C     *IN60         IFEQ      *OFF
     C                   WRITE     N_REGAMXD0
     C                   ENDIF
 
      * Read next member
 
     C     HIID          READE     C_REACCMD0                             60
 
     C                   ENDDO
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * TAKEON_H - Take On Hierarchy Headers
      ********************************************************************
     C     TAKEON_H      BEGSR
 
      * Write a record to the 'New' REACCHPD
 
     C                   WRITE     N_REACCHD0
 
      * Pick up REZSHXPD record
 
     C     HIID          CHAIN     REZSHXD0                           60
 
      * Write a record to the 'New' REZSHXPD
 
     C     *IN60         IFEQ      *OFF
     C                   WRITE     N_REZSHXD0
     C                   ENDIF
 
      * Pick up REGAHXPD record
 
     C     HIID          CHAIN     REGAHXD0                           60
 
      * Write a record to the 'New' REGAHXPD
 
     C     *IN60         IFEQ      *OFF
     C                   WRITE     N_REGAHXD0
     C                   ENDIF
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * TAKEON_M - Take On Hierarchy Members
      ********************************************************************
     C     TAKEON_M      BEGSR
 
     C     HIID          SETLL     REACCMD0
     C     HIID          READE     REACCMD0                               60
 
      * Read all members for this hierarchy
 
     C     *IN60         DOWEQ     *OFF
 
      * Write a record to the 'New' REACCMPD
 
     C                   WRITE     N_REACCMD0
 
      * Pick up REZSMXPD record
 
     C     MEID          CHAIN     REZSMXD0                           60
 
      * Write a record to the 'New' REZSMXPD
 
     C     *IN60         IFEQ      *OFF
     C                   WRITE     N_REZSMXD0
     C                   ENDIF
 
      * Pick up REGAMXPD record
 
     C     MEID          CHAIN     REGAMXD0                           60
 
      * Write a record to the 'New' REGAMXPD
 
     C     *IN60         IFEQ      *OFF
     C                   WRITE     N_REGAMXD0
     C                   ENDIF
 
      * Read next member
 
     C     HIID          READE     REACCMD0                               60
 
     C                   ENDDO
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * *INZSR --- INITIAL PROCESSING
      ********************************************************************
     C     *INZSR        BEGSR
 
     C                   Z-ADD     0             INCNT             9 0          Pending
     C                   Z-ADD     0             COCNT             9 0          Pending
     C                   Z-ADD     0             TOCNT             9 0          Authorised
 
      * Access Bank Details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR  '    @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * AUDIT - Write Audit Report.
      ********************************************************************
     C     AUDIT         BEGSR
 
      * Ensure Detail Spool File recorded by RCF.
 
     C                   EVAL      ZSnum = PSFNumU
 
     C                   CALL      'ZSFILE'
     C                   PARM                    PSeq
     C                   PARM                    PEnty
     C                   PARM                    PSFileU
     C                   PARM                    ZSnum
     C                   PARM      *Blank        ZSErr
 
      ** If Error occurs during ZSFILE processing, then end abnormally
 
     C                   IF        ZSErr = 'Y'
     C                   EVAL      X_ERMS = 'Call to ZSFILE in error'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   WRITE     HEADAU
     C                   WRITE     DETAILAU
      *
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY ZACPYSRC,RECMPSSR
      *****************************************************************
