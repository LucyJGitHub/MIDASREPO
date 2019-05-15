     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas RE Cash Management Live Back End Hier Update')   *
      *****************************************************************
      *                                                               *
      *  Midas - Retail Module                                        *
      *                                                               *
      *  RE100405 - Cash Management 'Live' Back End Hierarchy Update  *
      *                                                               *
      *  Function:  This program sets the 'live' cash management      *
      *             back end hierarchy files with data from the       *
      *             cash management front end hierarchy files.        *
      *             Only hierarchies that are live and not future     *
      *             dated are held on the 'live' cash management      *
      *             back end hierarchy files.                         *
      *             'Live' cash management back end hierarchy files:  *
      *             RELCMHDPD, RELCMHLPD, RELZSHDPD, RELZSHLPD        *
      *             RELGAHDPD, RELGAHLPD                              *
      *             Cash management front end hierarchy files:        *
      *             REACCHPD, REACCMPD, REZSHXPD, REZSMXPD            *
      *             REGAHXPD, REGAMXPD                                *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. AR676213           Date 19Nov10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 214360             Date 03Feb03               *
      *                 212840             Date 10Jan03               *
      *                 212466             Date 10Jan03               *
      *                 CRE008  *CREATE    Date 06Mar02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  AR676213 - Incorrect definition of CLGLAI field (Recompile)  *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  214360 - Cash Management Deferred Posting                    *
      *  212840 - Authorising user not present                        *
      *  212466 - Hierarchies become effective from next working day  *
      *  CRE008 - Cash Management                                     *
      *                                                               *
      *****************************************************************
 
      * F R O N T  E N D  F I L E S
      * ---------------------------
 
      * Account Hierarchy Header
      * Account Hierarchy Member
     FREACCHPD  UF   E           K DISK    INFSR(*PSSR)
 
 
      * C U R R E N T  ' L I V E '  B A C K  E N D  F I L E S
      * -----------------------------------------------------
 
      * Cash Management Hierarchy Details
      * Cash Management Hierarchy Links - by Parent
     FRECMHDL0  IF   E           K DISK    INFSR(*PSSR)
     FRECMHLL1  IF   E           K DISK    INFSR(*PSSR)
 
      * Zero Balancing/Sweeping Hierarchy Details
      * Zero Balancing/Sweeping Hierarchy Links
     FREZSHDL0  IF   E           K DISK    INFSR(*PSSR)
     FREZSHLL0  IF   E           K DISK    INFSR(*PSSR)
 
      * Group Account Hierarchy Details
      * Group Account Hierarchy Links
     FREGAHDL0  IF   E           K DISK    INFSR(*PSSR)
     FREGAHLL0  IF   E           K DISK    INFSR(*PSSR)
 
      * N E W  ' L I V E '  B A C K  E N D  F I L E S
      * ---------------------------------------------
 
      * Live Cash Management Hierarchy Details
      * Live Cash Management Hierarchy Links
     FRELCMHDL0 UF A E           K DISK    INFSR(*PSSR)
     F                                     RENAME(RECMHDD0:O_LCMHDD0)
     FRELCMHLL4 UF A E           K DISK    INFSR(*PSSR)
     F                                     RENAME(RECMHLD0:O_LCMHLD0)
 
      * Live Zero Balancing/Sweeping Hierarchy Details
      * Live Zero Balancing/Sweeping Hierarchy Links
     FRELZSHDL0 UF A E           K DISK    INFSR(*PSSR)
     F                                     RENAME(REZSHDD0:O_LZSHDD0)
     FRELZSHLL0 UF A E           K DISK    INFSR(*PSSR)
     F                                     RENAME(REZSHLD0:O_LZSHLD0)
 
      * Live Group Account Hierarchy Details
      * Live Group Account Hierarchy Links
     FRELGAHDL0 UF A E           K DISK    INFSR(*PSSR)
     F                                     RENAME(REGAHDD0:O_LGAHDD0)
     FRELGAHLL0 UF A E           K DISK    INFSR(*PSSR)
     F                                     RENAME(REGAHLD0:O_LGAHLD0)
 
 
      ** Cash Management 'Live' Back End Hierarchy Update Audit
     FRE100405AUO    E             PRINTER
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
 
 
      ** File Information Data Structure for RE100405
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
 
      * If the hierarchy has a status of 'WORK IN PROGRESS' or 'ERRORS'
      * or if the date effective is in the future
      *  Remove New 'Live' Hierarchy Details and Links
      *  and Carry over Current 'Live' Hierarchy Details and Links
 
     C     HISTAT        IFEQ      'W'
     C     HISTAT        OREQ      'E'
     C     HIDEFR        ORGT      BJDNWD                                       212466
     C*****HIDEFR********ORGT      BJRDNB                                       212466
 
     C                   EXSR      REMOVE_D
     C                   EXSR      REMOVE_L
 
     C                   EXSR      CARRYOVER_D
     C                   EXSR      CARRYOVER_L
 
     C                   ELSE
 
     C                   ADD       1             TOCNT
 
     C                   ENDIF
 
      **Blank*out*authorizing user                                              212840
      *******************                                                       212840
     C*******************MOVE      *BLANK        HIAUBU                         212840
 
      * If status is not 'LIVE'
      *   Set status to 'WORK IN PROGRESS'
      *   (This means the back-office data may not match the front office data)
 
      * ('LIVE' means the back-office data is the same as the front office data
      *   unless the hierarchy's date effective from is in the future)
 
     C     HISTAT        IFNE      'L'
     C                   MOVE      'W'           HISTAT
     C                   ENDIF
 
     C                   EXCEPT    U_REACCH
 
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
      * REMOVE_D - Remove Hierarchy Details from the 'Live' files
      ********************************************************************
     C     REMOVE_D      BEGSR
 
      * Delete any 'Live' cash management header records
      * ------------------------------------------------
 
     C     HIID          SETLL     O_LCMHDD0
     C     HIID          READE     O_LCMHDD0                              60
     C     *IN60         DOWEQ     '0'
     C                   DELETE    O_LCMHDD0
     C     HIID          READE     O_LCMHDD0                              60
     C                   ENDDO
 
      * Delete any 'Live' zero balancing/sweeping header records
      * --------------------------------------------------------
 
     C     HIID          SETLL     O_LZSHDD0
     C     HIID          READE     O_LZSHDD0                              60
     C     *IN60         DOWEQ     '0'
     C                   DELETE    O_LZSHDD0
     C     HIID          READE     O_LZSHDD0                              60
     C                   ENDDO
 
      * Delete any 'Live' group a/c hierarchy header records
      * ----------------------------------------------------
 
     C     HIID          SETLL     O_LGAHDD0
     C     HIID          READE     O_LGAHDD0                              60
     C     *IN60         DOWEQ     '0'
     C                   DELETE    O_LGAHDD0
     C     HIID          READE     O_LGAHDD0                              60
     C                   ENDDO
      *
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * REMOVE_L - Remove Hierarchy Links from the 'Live' files
      ********************************************************************
     C     REMOVE_L      BEGSR
 
      * Delete any 'Live' cash management link records
      * -----------------------------------------------
 
     C     HIID          SETLL     O_LCMHLD0
     C     HIID          READE     O_LCMHLD0                              60
     C     *IN60         DOWEQ     '0'
     C                   DELETE    O_LCMHLD0
     C     HIID          READE     O_LCMHLD0                              60
     C                   ENDDO
 
      * Delete any 'Live' zero balancing/sweeping link records
      * ------------------------------------------------------
 
     C     HIID          SETLL     O_LZSHLD0
     C     HIID          READE     O_LZSHLD0                              60
     C     *IN60         DOWEQ     '0'
     C                   DELETE    O_LZSHLD0
     C     HIID          READE     O_LZSHLD0                              60
     C                   ENDDO
 
      * Delete any 'Live' group a/c hierarchy header records
      * ----------------------------------------------------
 
     C     HIID          SETLL     O_LGAHLD0
     C     HIID          READE     O_LGAHLD0                              60
     C     *IN60         DOWEQ     '0'
     C                   DELETE    O_LGAHLD0
     C     HIID          READE     O_LGAHLD0                              60
     C                   ENDDO
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * CARRYOVER_D - Carry over Hierarchy Details
      ********************************************************************
     C     CARRYOVER_D   BEGSR
 
     C     HIID          CHAIN     RECMHDL0                           60
 
      * If no record currently, then end
 
     C     *IN60         IFEQ      *ON
     C                   GOTO      ECARRYOVER_D
     C                   ENDIF
 
     C                   ADD       1             COCNT
 
      * Write a record to the 'Live' RECMHDPD
 
     C                   Z-ADD     0             CDNODH
     C                   Z-ADD     0             CDNODN
     C                   Z-ADD     0             CDPRSQ
     C                   MOVEL     'N'           CDHLKT
 
     C                   WRITE     O_LCMHDD0
 
      * If a zero-balancing/sweeping hierarchy
      * ---------------------------------------
 
     C     HIHTYP        IFEQ      'ZS'
 
      * Pick up Zero Balancing/Sweeping Hierarchy Detail record
      * (If no record is found, it's a database error)
 
     C     HIID          CHAIN     REZSHDL0                           60
     C     *IN60         IFEQ      *ON
     C                   MOVE      HIID          W_HIER            9
     C                   EVAL      X_ERMS = 'No REZSHDL0 for ' + W_HIER
     C                   EXSR      *PSSR
     C                   ENDIF
 
      * Write a record to the 'Live' REZSHDPD
 
     C                   WRITE     O_LZSHDD0
 
     C                   ENDIF
 
      * If a group account hierarchy
      * ----------------------------
 
     C     HIHTYP        IFEQ      'GA'
 
      * Pick up Group Account Hierarchy Detail record
      * (If no record is found, it's a database error)
 
     C     HIID          CHAIN     REGAHDL0                           60
     C     *IN60         IFEQ      *ON
     C                   MOVE      HIID          W_HIER
     C                   EVAL      X_ERMS = 'No REGAHDL0 for ' + W_HIER
     C                   EXSR      *PSSR
     C                   ENDIF
 
      * Write a record to the 'Live' REGAHDPD
 
     C                   WRITE     O_LGAHDD0
 
     C                   ENDIF
 
     C     ECARRYOVER_D  ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * CARRYOVER_L - Carry over Hierarchy Links
      ********************************************************************
     C     CARRYOVER_L   BEGSR
 
     C     HIID          SETLL     RECMHLL1
     C     HIID          READE     RECMHLL1                               60
 
      * Read all links for this hierarchy
 
     C     *IN60         DOWEQ     *OFF
 
      * Write a record to the 'Live' RECMHLPD
 
     C                   Z-ADD     0             CLNASN
 
     C                   WRITE     O_LCMHLD0
 
      * If a zero-balancing/sweeping hierarchy
      * ---------------------------------------
 
     C     HIHTYP        IFEQ      'ZS'
 
      * Pick up Zero Balancing/Sweeping Link record.
      * (If no record is found, it's a database error)
 
     C     LINKK         CHAIN     REZSHLL0                           60
     C     *IN60         IFEQ      *ON
     C                   MOVE      CLLINK        W_LINK            9
     C                   EVAL      X_ERMS = 'No REZSHLL0 for ' + W_LINK
     C                   EXSR      *PSSR
     C                   ENDIF
 
      * Write a record to the 'Live' REZSHLPD
 
     C                   Z-ADD     0             ZLTVDR
     C                   Z-ADD     0             ZLTCDR
     C                   Z-ADD     0             ZLNASN
 
     C                   WRITE     O_LZSHLD0
 
     C                   ENDIF
 
      * If a group account hierarchy
      * ----------------------------
 
     C     HIHTYP        IFEQ      'GA'
 
      * Pick up Group Account Hierarchy Link record
      * (If no record is found, it's a database error)
 
     C     LINKK         CHAIN     REGAHLL0                           60
     C     *IN60         IFEQ      *ON
     C                   MOVE      CLLINK        W_LINK
     C                   EVAL      X_ERMS = 'No REGAHLL0 for ' + W_LINK
     C                   EXSR      *PSSR
     C                   ENDIF
 
      * Write a record to the 'Live' REGAHLPD
 
     C                   WRITE     O_LGAHLD0
 
     C                   ENDIF
 
      * Read next Link
 
     C     HIID          READE     RECMHLL1                               60
 
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
 
      * Key lists
 
     C     LINKK         KLIST
     C                   KFLD                    CLHIER
     C                   KFLD                    CLLINK
 
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
     OREACCHD0  E            U_REACCH
     O***********************HIAUBU                                             212840
     O                       HISTAT
