      *****************************************************************
     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2005')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  ALWNULL(*USRCTL)                                             *
/*EXI *  TEXT('Midas UP Process Action File for T_GRMENUL')
      *****************************************************************
      *                                                               *
      *  Midas - Bridge                                               *
      *                                                               *
      *  UP1727 - Process Action File for T_GRMENUL                   *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2005            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CUP031 *CREATE     Date 21Jan05               *
      *  Prev Amend No. xxxxxx             Date ddmmmyy               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  CUP031 - Creation of new set of Action File utilities.       *
      *                                                               *
      *****************************************************************
      * Function of indicators
      *
      *       20      End of file
      *       22      Record not found or EOF
      *       23      End of file or records not matched (READE GPGMULL3)
      *       30      Chain - record not found
      *       40      match entry found in an array
      *       51      Null indicator for field MLGRPID
      *       52      Null indicator for field MLMENUCODE
      *
     FUPGMULL1  IF   E           K DISK    INFSR(*PSSR)                         by HYID,ACTC,ID,ENDI
     FGPGMULL1  UF   E           K DISK    INFSR(*PSSR)                         by HYID, ID
     F                                     RENAME(T_GRMENUL:GMUL1F) PREFIX(U_)
     FGPGMULL0  UF A E           K DISK    INFSR(*PSSR)                         by HYID, GRPID,
     F                                     RENAME(T_GRMENUL:GMULF)              LEVEL, PARENT,MENCOD
     F                                     PREFIX(X)
     FGPGMULL2  UF   E           K DISK    INFSR(*PSSR)                         Group recs only
     F                                     RENAME(T_GRMENUL:GMUL2F) PREFIX(G_)  by HYID, GRPID
     FGPGMULL3  IF   E           K DISK    INFSR(*PSSR)                         Menu items only
     F                                     RENAME(T_GRMENUL:GMUL3F) PREFIX(I_)  by HYID, PARENT, Id
     FGPGMULL4  UF   E           K DISK    INFSR(*PSSR)                         by MLMENUCODE
     F                                     RENAME(T_GRMENUL:GMUL4F) PREFIX(M_)
      /EJECT
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
      * Array holding Level, Parent, Group, Last Grp Id and End id details
     D @LvlParGrp      S             64    DIM(2000)                            MaxEntry size of grp
     D                                     DESCEND
      *
      * Array holding Parent entries from @LvlParGrp array
     D @Parent         S             20  0 DIM(2000)
      *
      * Array holding Group entries from @LvlParGrp array
     D @Group          S             20  0 DIM(2000)
      *
      * Array holding Endid entries from @LvlParGrp array
     D @Endid          S             20  0 DIM(2000)
      *
      * Array holding hierarchies of the deleted link records in client changes
      * section.
     D @UpdClntHi      S              9  0 DIM(300)
      *
      * Array holding Link Id of moved link records in a hierarchy
     D @MovedId        S             20  0 DIM(2000)
      *
      * Array holding Positonal data of the moved link records in a hierarchy
     D @MovedPosD      S             65    DIM(2000)
      *
      * Entry for array @LvlParGrp
     D                 DS
     DLvlParGrpEntry           1     64
     D  LPaGrp_Level           1      4  0
     D  LPaGrp_Parent          5     24  0
     D  LPaGrp_GrpId          25     44  0
     D  LPaGrp_Endid          45     64  0
      *
      * Entry for array @MovedPosD
     D                 DS
     DMovedPosDEntry           1     65
     D  MPos_HyId              1      9  0
     D  MPos_GrpId            10     29  0
     D  Mpos_GrpIdNId         30     30N
     D  MPos_Level            30     34  0
     D  MPos_Parent           34     54  0
     D  MPos_MuCd             55     64
     D  MPos_MuCdNId          65     65N
      *
     D LDA           E DS           256    EXTNAME(LDA)
      *
      * Local data area for database error details
      * *LOCK IN LDA immediately before and OUT LDA immediately
      * after each database error handling.
      *
      *                                     134 141 DBFILE
      *        Defines:                     142 170 DBKEY
      *                                     171 180 DBPGM
      *                                     181 1830DBASE
      *
     D PSDS           SDS
      *
      ** Program Status Data Structure.
      *
     D  PGM              *PROC
     D  WSID                 244    253
     D  USER                 254    263
      *
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
     D K_MLHYID        S                   LIKE(MLHYID)                         key fld in KLST COMP
     D K_MLGRPID       S                   LIKE(MLGRPID)                        key fld in KLST COMP
     D K_MLLEVEL       S                   LIKE(MLLEVEL)                        key fld in KLST COMP
     D K_MLPARENT      S                   LIKE(MLPARENT)                       key fld in KLST COMP
     D K_MLMENUCODE    S                   LIKE(MLMENUCODE)                     key fld in KLST COMP
     D K2_MLHYID       S                   LIKE(MLHYID)                         key fld in GMUL2Key
     D K2_MLGRPID      S                   LIKE(MLGRPID)                        key fld in GMUL2Key
     D K3_MLHYID       S                   LIKE(MLHYID)                         key fld in GMUL3Key
     D K3_MLPARENT     S                   LIKE(MLPARENT)                       key fld in GMUL3Keu
     D K4_MLMENUCODE   S                   LIKE(MLMENUCODE)                     key fld in GMUL4Key
     D UPK_MLHYID      S                   LIKE(MLHYID)                         key field in UP_Key
     D UPK_MLACTC      S                   LIKE(MLACTC) INZ('M')                key field in UP_Key
     D UPK_MLID        S                   LIKE(MLID)                           key field in UP_Key
     D PrevHYID        S                   LIKE(MLHYID)                         Prev. Hierarchy Id
     D ActionHYID      S                   LIKE(MLHYID)                         UpdForDlt, UpdEndIds
     D ActionId        S                   LIKE(MLID)                           UpdForIns,UpdForDlt
     D UpdNeeded       S              1                                         Y if rec upd is need
     D NoItemForHyid   S              1                                         Y if no more items
                                                                                for the hierarchy
     D Idx             S              4  0                                      @LvlParGrp indx
     D PIdx            S              4  0                                      @Parent array index
     D TtlEntry        S              4  0                                      Total entry of grp
     D Lvl1Endid       S              8B 0                                      Endid of Level 1
     D MoveFromId      S                   LIKE(MLID)                           Link Id (move from)
     D MoveToId        S                   LIKE(MLID)                           Link Id (move to)
     D ClntStrHyid     S                   LIKE(MLHYID)                         Start hyid 4 client
     D                                     INZ(10000)
     D I               S              4  0                                      @UpdClntHi   index
     D TtlCHyidEntry   S              4  0 INZ(0)                               Ttl entry @UpdClntHi
     D M               S              4  0 INZ(0)                               @Moved..arrary index
     D SaveId          S                   LIKE(MLID)
      *
      * Set up key list to access GPGMULL2
     C     GMUL2Key      KLIST
     C                   KFLD                    K2_MLHYID
     C                   KFLD                    K2_MLGRPID
      *
      * Set up key list to access GPGMULL3
     C     GMUL3Key      KLIST
     C                   KFLD                    K3_MLHYID
     C                   KFLD                    K3_MLPARENT
      *
      * Set up key list to access GPGMULL4
     C     GMUL4Key      KLIST
     C                   KFLD      *IN52         K4_MLMENUCODE
      *
      * Set up key list to access GPGMULL0
     C     COMP          KLIST
     C                   KFLD                    K_MLHYID
     C                   KFLD      *IN51         K_MLGRPID
     C                   KFLD                    K_MLLEVEL
     C                   KFLD                    K_MLPARENT
     C                   KFLD      *IN52         K_MLMENUCODE
      *
      * Set up key list to access UPGMULL1
     C     UP_Key        KLIST
     C                   KFLD                    UPK_MLHYID
     C                   KFLD                    UPK_MLACTC
     C                   KFLD                    UPK_MLID
      *
     C     *LOVAL        SETLL     UPGMULL1
      *
     C                   READ      UPGMULL1                               20    EOF
      *
     C  N20              EVAL      PrevHYID  = MLHYID
      *
     C     *IN20         DOWEQ     '0'
      *
     C                   IF        MLACTC = 'I'
      *
      * Get Link Id for the record to be inserted.
     C                   EXSR      GetInsertId
      *
      * Increase all the Link Id after the ActionId by 1 because of insert.
     C                   EXSR      UpdForIns
      *
      * Set values for the insert record and write to file GPGMULL0.
     C                   EXSR      SETVAL
     C                   WRITE     GMULF
     C                   ENDIF                                                  FI MLACTC = 'I'
      *
     C     MLACTC        IFEQ      'D'
      *
      *  Get Link Id for the record to be deleted.
     C                   EXSR      GetDeleteId
      *
     C                   DELETE    GMULF
      *
      *  Check and update the Link Id and End Id of records for same hierarchy for delete.
     C                   EXSR      UpdforDlt
      *
     C                   IF        %NULLIND(MLMENUCODE) = *OFF                  Menucode <> null
      *  Delete any records with same Menucode in the client change section of T_GRMENUL.
     C                   EXSR      DltClntMenuC
     C                   ENDIF                                                  FI Menucode <> null
      *
     C                   ENDIF                                                  FI MLACTC = 'D'
      *
      *  Move record will be same as 'deleting' record from its old position
      *  'inserting' the record to its new position.
     C     MLACTC        IFEQ      'M'
      *
     C                   EXSR      MoveRec
      *
      *  Store the move rec info in @MovedId and @MovedPosD arraries.
     C                   EVAL      M = M + 1
      *
     C                   EVAL      @MovedId(M)      = MLID
      *
     C                   EVAL      MPos_Hyid        = MLKHYID
     C                   EVAL      MPos_GrpId       = MLKGRPID
     C                   EVAL      MPos_GrpIdNId    = %NULLIND(MLKGRPID)
     C                   EVAL      MPos_Level       = MLKLEVEL
     C                   EVAL      MPos_Parent      = MLKPARENT
     C                   EVAL      MPos_MuCd        = MLKMENUCOD
     C                   EVAL      MPos_MuCdNId     = %NULLIND(MLKMENUCOD)
     C                   EVAL      @MovedPosD(M)    = MovedPosDEntry
      *
      *  Move records which have previously been moved after the moved record.
     C                   EXSR      MovePrevMRecs
      *
     C                   ENDIF                                                  FI MLACTC = 'M'
      *
     C                   READ      UPGMULL1                               20    EOF
      *
      * If hierarchy has been changed or end of file reached,
      * update to ensure the End Id of group records are correct.
     C                   IF        MLHYID <> PrevHYID OR
     C                             *IN20  = *ON
      *
      *  Release the locks of GPGMULL0, GPGMULL1.
     C                   UNLOCK    GPGMULL1
     C                   UNLOCK    GPGMULL0
      *
      *  Update End ids for the previous hierarchy.
     C                   EVAL      ActionHYID = PrevHYID
     C                   EXSR      UpdEndIds
      *
      *  If not eof, update or initialise variables for the change of hierarchy.
     C                   IF        *IN20 = *OFF
     C                   EVAL      PrevHYID = MLHYID
     C                   EVAL      M        = 0
     C                   CLEAR                   @MovedId
     C                   CLEAR                   @MovedPosD
     C                   ENDIF                                                  FI *IN20 = *OFF
      *
     C                   ENDIF                                                  FI MLHYID<>PrevHYID
      *                                                                         OR IN20 = *ON
     C                   ENDDO                                                  ODW *IN20 = *ON
      *
      * If records in the client section of T_GRMENUL have been deleted,
      * update the end ids of the records in the client section.
     C                   IF        TtlCHyidEntry > 0
     C                   EXSR      UpdClntEndIds
     C                   ENdIF                                                  FI TtlCHyidEntry > 0
      *
     C     ENDPGM        TAG
     C                   SETON                                        LR
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * GetInsertId - Get the Link Id for the record to be inserted.  *
      *                                                               *
      * Called from - Main processing                                 *
      *               MoveRec                                         *
      *                                                               *
      * Call        - none                                            *
      *                                                               *
      *****************************************************************
     C     GetInsertId   BEGSR
      *
     C                   IF        MLPOS    = '*AFTER'  AND
     C                             MLHYID   = MLKHYID
      *
      * Set up key fields to access GPGMULL0 for the positional data (*AFTER).
     C                   EVAL      K_MLHYID     = MLKHYID
     C                   EVAL      K_MLGRPID    = MLKGRPID
     C                   EVAL      K_MLLEVEL    = MLKLEVEL
     C                   EVAL      K_MLPARENT   = MLKPARENT
     C                   EVAL      K_MLMENUCODE = MLKMENUCOD
      *
     C                   EVAL      *IN51  = %NULLIND(MLKGRPID)
     C                   EVAL      *IN52  = %NULLIND(MLKMENUCOD)
      *
     C     COMP          CHAIN     GPGMULL0                           30        Record not found
      *  If record not found, error.
     C   30              EXSR      *PSSR
      *
      *  The Link Id for the record to be inserted will be at next one.
     C                   EVAL      ActionId = XMLID + 1
      *  Release the positional rec from file GPGMULL0.
     C                   UNLOCK    GPGMULL0
      *
     C                   ELSE
      * Else the insert record is 1st record of a heirarchy.
     C                   EVAL      ActionId = 1
     C                   ENDIF                                                  FI MLPOS = *AFTER
      *
     C     GetInsertIdE  ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * GetDeleteId - Get the Link Id for the record to be deleted.   *
      *                                                               *
      * Called from - Main processing                                 *
      *               MoveRec                                         *
      *                                                               *
      * Call        - none                                            *
      *                                                               *
      *****************************************************************
     C     GetDeleteId   BEGSR
      *
      * Set up key fields to access GPGMULL0.
     C                   EVAL      K_MLHYID     = MLHYID
     C                   EVAL      K_MLGRPID    = MLGRPID
     C                   EVAL      K_MLLEVEL    = MLLEVEL
     C                   EVAL      K_MLPARENT   = MLPARENT
     C                   EVAL      K_MLMENUCODE = MLMENUCODE
      *
     C                   EVAL      *IN51  = %NULLIND(MLGRPID)
     C                   EVAL      *IN52  = %NULLIND(MLMENUCODE)
      * Chain to GPGMULL0 for record with same MLHYID, MLGRPID, MLLEVEL, MLPARENT and
      * MLMENUCODE.
     C     COMP          CHAIN     GPGMULL0                           30        Record not found
      *  If record not found, error.
     C   30              EXSR      *PSSR
      *
      *  Store the Hierarchy and Link Id of the record to be deleted.
     C                   EVAL      ActionId   = XMLID
     C                   EVAL      ActionHyid = XMLHYID
      *
     C     GetDeleteIdE  ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * MoveRec -  Move a record = Delete the record + insert same    *
      *            record at new position. Link ids and End ids will  *
      *            be adjusted.                                       *
      *                                                               *
      * Called from - Main processing                                 *
      *               MovePrevMRecs                                   *
      *                                                               *
      * Call        - GetDeleteId                                     *
      *               GetInsertId                                     *
      *               UpdforMov                                       *
      *               SETVAL                                          *
      *                                                               *
      *****************************************************************
     C     MoveRec       BEGSR
      *
     C                   EXSR      GetDeleteId
      * Store the link id of the delete record as MoveFromId.
     C                   EVAL      MoveFromId = ActionId
     C                   DELETE    GMULF
      *
     C                   EXSR      GetInsertId
      * Store the link id of the insert record as MoveToId.
     C                   EVAL      MoveToId   = ActionId
      *
      * Check and update the Link Id and End Id of records for same hierarchy for the move.
     C                   EXSR      UpdforMov
      *
      * Set values for the insert record and write to file GPGMULL0.
     C                   EVAL      ActionId = MoveToId
     C                   EXSR      SETVAL
     C                   WRITE     GMULF
      *
     C     MoveRecE      EndSR
      /EJECT
      *****************************************************************
      *                                                               *
      * MovePrevMRecs - Move records which have previously been moved *
      *                 to after the moved record.                    *
      *                                                               *
      * Called from - Main processing                                 *
      *                                                               *
      * Call        - MoveRec                                         *
      *                                                               *
      *****************************************************************
     C     MovePrevMRecs BEGSR
      *
      *  Save the MLID of the record being processed.
     C                   EVAL      SaveId           = MLID
      *
      *  Search @MovedPosD for the moved record.
     C                   EVAL      MPos_Hyid        = MLHYID
     C                   EVAL      MPos_GrpId       = MLGRPID
     C                   EVAL      MPos_GrpIdNId    = %NULLIND(MLGRPID)
     C                   EVAL      MPos_Level       = MLLEVEL
     C                   EVAL      MPos_Parent      = MLPARENT
     C                   EVAL      MPos_MuCd        = MLMENUCODe
     C                   EVAL      MPos_MuCdNId     = %NULLIND(MLMENUCODE)
      *
     C                   EVAL      I = 1
     C     MovedPosDEntryLOOKUP    @MovedPosD(I)                          40    match found
     C  N40              GOTO      MovePrevMRecsE
      *
      * Move the records that have previously been moved to after the moved rec.
     C                   DOW       *IN40 = '1'
      *
      * Get the move action record for the previously moved record.
     C                   EVAL      UPK_MLHYID = MLHYID
     C                   EVAL      UPK_MLID   = @MovedId(I)
     C     UP_Key        CHAIN     UPGMULL1                           30        record not found
     C   30              EXSR      *PSSR
      *
     C                   EXSR      MoveRec
      *
      *  Search @MovedPosD for the new moved record.
     C                   EVAL      MPos_Hyid        = MLHYID
     C                   EVAL      MPos_GrpId       = MLGRPID
     C                   EVAL      MPos_GrpIdNId    = %NULLIND(MLGRPID)
     C                   EVAL      MPos_Level       = MLLEVEL
     C                   EVAL      MPos_Parent      = MLPARENT
     C                   EVAL      MPos_MuCd        = MLMENUCODE
     C                   EVAL      MPos_MuCdNId     = %NULLIND(MLMENUCODE)
      *
     C                   EVAL      I = 1
     C     MovedPosDEntryLOOKUP    @MovedPosD(I)                          40    match found
      *
     C                   ENDDO                                                  DOW *IN40 = '1'
      *
      * Position pointer back to the original action file record (Save Id).
     C                   EVAL      UPK_MLHYID = MLHYID
     C                   EVAL      UPK_MLID   = SaveId
     C     UP_Key        CHAIN     UPGMULL1                           30        record not found
     C   30              EXSR      *PSSR
     c
     C     MovePrevMRecsEEndSR
      /EJECT
      *****************************************************************
      *                                                               *
      * DltClntMenuC - Delete all records with same menucode in the   *
      *                customer section                               *
      *                                                               *
      * Called from - Main processing                                 *
      *                                                               *
      * Call        - UpdforDlt                                       *
      *                                                               *
      *****************************************************************
     C     DltClntMenuC  BEGSR
      *
      * Set up key fields to access GPGMULL4
     C                   EVAL      K4_MLMENUCODE = MLMENUCODE
     C                   EVAL      *IN52  = %NULLIND(MLKMENUCOD)
      *
      * Chain to GPGMULL4 for record with same MLMENUCODE.
     C     GMUL4Key      CHAIN     GPGMULL4                           30        Record not found
      *
     C                   DOW       *IN30 = '0'
      *
      * Only delete the records in client section (ie, hyid >= 10000)
     C                   IF        M_MLHYID >= ClntStrHyid
      *
      * Store the Hierarchy and Link Id of the record to be deleted.
     C                   EVAL      ActionId   = M_MLID
     C                   EVAL      ActionHyid = M_MLHYID
      *
      * Delete the record with same hierarchy.
     C                   DELETE    GMUL4F
      *
      * Update the Link Id and End Id of records for same hierarchy in client
      * section because of the deletion
     C                   EXSR      UpdforDlt
      *
      * Add the hierarchy of deleted link record to arrary @UpdClntHi
     C                   EVAL      I = 1
     C     ActionHyid    LOOKUP    @UpdClntHi(I)                          40    match found
      *
      * Only add to the array if there is no entry for the hierarchy in
      * the arrary.
     C                   IF        *IN40 = *OFF
     C                   EVAL      TtlCHyidEntry = TtlCHyidEntry + 1
     C                   EVAL      I             = TtlCHyidEntry
     C                   EVAL      @UpdClntHi(I) = ActionHyid
     C                   ENDIF                                                  FI *IN40 = *OFF
      *
     C                   ENDIF                                                  FI M_MLHYID >=
      *                                                                            ClntStrHyid
      * Get next record with same menucode.
     C     GMUL4Key      READE     GPGMULL4                               30    Record not found
     C                   ENDDO                                                  ODW *IN30 = '0'
      *
     C     DltClntMenuCE ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * UpdForDlt - Update records of same hierarchy in increasing    *
      *             order of link id. when action = 'D'               *
      *                                                               *
      * Called from - Main processing                                 *
      *                                                               *
      * Call        - none                                            *
      *                                                               *
      *****************************************************************
     C     UpdForDlt     BEGSR
      *
      * Access GPGMULL1 for the first record with the same hierarchy.
     C     ActionHyid    SETLL     GPGMULL1
     C     ActionHyid    READE     GPGMULL1                               22    Rec not found
      *
      * Check records until all records of same hierarchy have been read.
     C                   DOW       *IN22     = *OFF  AND
     C                             U_MLHYID  = ActionHyid
      *
     C                   EVAL      UpdNeeded = *BLANK
      *
     C                   IF        U_MLID  > ActionId
     C                   EVAL      U_MLId  = U_MLID - 1
     C                   EVAL      UpdNeeded = 'Y'
     C                   ENDIF
      *
     C                   IF        U_MLENDID >= ActionId
     C                   EVAL      U_MLENDID = U_MLENDID - 1
     C                   EVAL      UpdNeeded = 'Y'
     C                   ENDIF
      *
     C                   IF        UpdNeeded = 'Y'
     C                   UPDATE    GMUL1F
     C                   ENDIF
      *
      * Read next rec of same hierarchy.
     C                   READ      GPGMULL1                               22    EOF
      *
     C                   ENDDO                                                  ODW *IN22 = *OFF
      *
     C     UpdForDltE    ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * UpdForIns - Update records of same hierarchy in decreasing    *
      *             order of link id. when action = 'I'               *
      *                                                               *
      * Called from - Main processing                                 *
      *                                                               *
      * Call        - none                                            *
      *                                                               *
      *****************************************************************
     C     UpdForIns     BEGSR
      *
     C     MLHYID        SETGT     GPGMULL1
     C     MLHYID        READPE    GPGMULL1                               22    no record found
      *
      * Check records until all records of same hierarchy have been read.
     C                   DOW       *IN22     = *OFF  AND
     C                             U_MLHYID  = MLHYID
      *
     C                   EVAL      UpdNeeded = *BLANK
      *
     C                   IF        U_MLID   >= ActionId
     C                   EVAL      U_MLId    = U_MLID + 1
     C                   EVAL      UpdNeeded = 'Y'
     C                   ENDIF
      *
     C                   IF        U_MLENDID >= ActionId
     C                   EVAL      U_MLENDID  = U_MLENDID + 1
     C                   EVAL      UpdNeeded  = 'Y'
     C                   ENDIF
      *
     C                   IF        UpdNeeded = 'Y'
     C                   UPDATE    GMUL1F
     C                   ENDIF
      *
      * Read next rec of same hierarchy.
     C                   READP     GPGMULL1                               22    BOF
      *
     C                   ENDDO                                                  ODW *IN22 = *OFF
      *                                                                         and U_MLHYID =MLHYID
     C     UpdForInsE    ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * UpdForMov - Update records of same hierarchy when action = 'M'*
      *                                                               *
      * Called from - Main processing                                 *
      *                                                               *
      * Call        - none                                            *
      *               MoveRec                                         *
      *                                                               *
      *****************************************************************
     C     UpdForMov     BEGSR
      *
      * If record is moved up, increment ids between the MoveToId and the MoveFromId.
     C                   IF        MoveToId < MoveFromId
      *
     C     MLHYID        SETGT     GPGMULL1
     C     MLHYID        READPE    GPGMULL1                               22    no record found
      *
      * Check records in decreasing order until all records of same hierarchy have been read.
     C                   DOW       *IN22     = *OFF  AND
     C                             U_MLHYID  = MLHYID
      *
     C                   EVAL      UpdNeeded = *BLANK
      *
     C                   IF        U_MLID   >= MoveToId  AND
     C                             U_MLID   <  MoveFromId
     C                   EVAL      U_MLId    = U_MLID + 1
     C                   EVAL      UpdNeeded = 'Y'
     C                   ENDIF
      *
     C                   IF        U_MLENDID >= MoveToId  AND
     C                             U_MLENDID <  MoveFromId
     C                   EVAL      U_MLENDID  = U_MLENDID + 1
     C                   EVAL      UpdNeeded  = 'Y'
     C                   ENDIF
      * Record with End id equals to MoveFromId should be group record and the
      * End id will be caculated in SR. UpdEndIds.
      *
     C                   IF        UpdNeeded = 'Y'
     C                   UPDATE    GMUL1F
     C                   ENDIF
      *
      * Read next rec of same hierarchy.
     C                   READP     GPGMULL1                               22    BOF
      *
     C                   ENDDO                                                  ODW *IN22 = *OFF
      *                                                                         and U_MLHYID =MLHYID
      *
     C                   ENDIF                                                  FI MoveToId < MoveFr
      *
      * If record is moved down, decrease ids between the MoveFromId and the MoveToId.
     C                   IF        MoveToId > MoveFromId
      *
      * Since the from record is deleted, the MoveToId will be 1 less.
     C                   EVAL      MoveToId = MoveToId - 1
      *
      * Access GPGMULL1 for the first record with the same hierarchy.
     C     MLHYID        SETLL     GPGMULL1
     C     MLHYID        READE     GPGMULL1                               22    Rec not found
      *
      * Check records until all records of same hierarchy have been read.
     C                   DOW       *IN22     = *OFF  AND
     C                             U_MLHYID  = MLHYID
      *
     C                   EVAL      UpdNeeded = *BLANK
      *
     C                   IF        U_MLID  > MoveFromId AND
     C                             U_MLID  <= MoveToId
     C                   EVAL      U_MLID  = U_MLID - 1
     C                   EVAL      UpdNeeded = 'Y'
     C                   ENDIF
      *
     C                   IF        U_MLENDID > MoveFromId AND
     C                             U_MLENDID <= MoveToId
     C                   EVAL      U_MLENDID = U_MLENDID - 1
     C                   EVAL      UpdNeeded = 'Y'
     C                   ENDIF
      * Record with End Id equals to MoveFromId should be group record and the
      * End id will be caculated in SR. UpdEndIds.
      *
     C                   IF        UpdNeeded = 'Y'
     C                   UPDATE    GMUL1F
     C                   ENDIF
      *
      * Read next rec of same hierarchy.
     C                   READ      GPGMULL1                               22    EOF
      *
     C                   ENDDO                                                  ODW *IN22 = *OFF
      *
     C                   ENDIF                                                  FI MoveToId > MoveFr
      *
     C     UpdForMovE    ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * SETVAL subroutine - set values for write                      *
      *                                                               *
      * Called from - Main processing                                 *
      *                                                               *
      * Call        - none                                            *
      *                                                               *
      *****************************************************************
     C     SETVAL        BEGSR
      *
      * Set values to write record.
     C                   EVAL      XMLHYID     = MLHYID
     C                   EVAL      XMLID       = ActionId
     C                   EVAL      XMLENDId    = ActionId
     C                   IF        NOT %NULLIND(MLGRPID)
     C                   EVAL      XMLGRPID    = MLGRPID
     C                   ENDIF
     C                   EVAL      %NULLIND(XMLGRPID) = %NULLIND(MLGRPID)
      *
     C                   EVAL      XMLLEVEL    = MLLEVEL
     C                   EVAL      XMLPARENT   = MLPARENT
     C                   IF        NOT %NULLIND(MLMENUCODE)
     C                   EVAL      XMLMENUCODE = MLMENUCODE
     C                   ENDIF
     C                   EVAL      %NULLIND(XMLMENUCODE) = %NULLIND(MLMENUCODE)
      *
     C     SETVALE       ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * UpdEndIds - Ensure and update all End Ids of the group records*
      *             for a hierarchy (ActionHYID)                      *
      *                                                               *
      * Called from - Main processing                                 *
      *               UpdClntEndIds                                   *
      *                                                               *
      * Call        - SetArrays                                       *
      *                                                               *
      *****************************************************************
     C     UpdEndIds     BEGSR
      *
      * Set up arrays @LvlParGrp, @Parent, ...@EndId.
     C                   EXSR      SetArrays
      *
      * If there is no more records for the hierachy (ActionHYID), exit this SR.
     C                   IF        NoItemForHyid = 'Y'
     C                   GOTO      UpdEndIdsE
     C                   ENDIF                                                  FI *IN22 = *ON
      *
      * Find the Endid of each group in @LvlParGrp starting from highest level and Group Id.
     C                   EVAL      Idx     = 1
      *
     C                   DOW       Idx  <= TtlEntry
      *
     C                   EVAL      PIdx    = 1
      *
      * If the group is parent of other group(s), EndId of the group will be
      * the greatest Endid of the group and its subgroup.
     C     @Group(Idx)   LOOKUP    @Parent(PIdx)                          40    Match found
      *
     C                   DOW       *IN40  = *ON
      *
     C                   IF        @EndId(Idx)  < @EndId(PIdx)
     C                   EVAL      @EndId(Idx)  = @EndId(PIdx)
     C                   ENDIF
      *
      *  Look up in array for another group with same parent.
     C                   EVAL      PIdx   = PIdx + 1
     C     @Group(Idx)   LOOKUP    @Parent(PIdx)                          40    Match found
     C                   ENDDO                                                  ODW *IN40  = *ON
      *
      * Update EndID in the file GPGMULL2.
     C                   EVAL      K2_MLHYID  = ActionHYID
     C                   EVAL      K2_MLGRPID = @Group(Idx)
     C     GMUL2Key      CHAIN     GPGMULL2                           30        Record not found
     C   30              EXSR      *PSSR
      *
     C                   IF        G_MLEndId  <> @Endid(Idx)
     C                   EVAL      G_MLEndId  = @Endid(Idx)
     C                   UPDATE    GMUL2F
     C                   ENDIF
      *
     C                   EVAL      Idx     = Idx + 1
     C                   ENDDO
      *
      *  Release the lock of GPGMULL2
     C                   UNLOCK    GPGMULL2
      *
     C     UpdEndIdsE    ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * SetArrays    - Set up array @LvlParGrp and Sort in descending *
      *                order.                                         *
      *                Set up arrays @Parent, @Group, @LstGId and     *
      *                @Endid corresponding to @LvlParGrp.            *
      *                                                               *
      * Called from - UpdEndIds                                       *
      *                                                               *
      * Call        - None                                            *
      *                                                               *
      *****************************************************************
     C     SetArrays     BEGSR
      *
      * Initialize variables.
     C                   EVAL      Idx           = 0
     C                   EVAL      K2_MLHYID     = ActionHYID
     C                   EVAL      K3_MLHYID     = ActionHYID
     C                   EVAL      @LvlParGrp    = *BLANK
     C                   EVAL      Lvl1Endid     = 0
     C                   EVAL      NoItemForHyid = *BLANK
      *
      * Fill array @LvlParGrp
     C     ActionHYID    SETLL     GPGMULL2
      *
     C     ActionHYID    CHAIN     GPGMULL2                           22        RNF
      *
      * If there is no more records for the hierachy (ActionHYID),
      *    set 'Y' to NoItemForHyid and exit this SR.
     C                   IF        *IN22 = *ON
     C                   EVAL      NoItemForHyid = 'Y'
     C                   GOTO      SetArraysE
     C                   ENDIF                                                  FI *IN22 = *ON
      *
      * Do until all group records of same hierarchy have been read.
     C                   DOW       *IN22     = *OFF  AND
     C                             G_MLHYID  = ActionHYID
      *
      * Chain to GPGMULL3 to get the last link id of group with same parent group.
     C                   EVAL      K3_MLPARENT = G_MLGRPID
     C     GMUL3Key      SETLL     GPGMULL3
     C     GMUL3Key      READE     GPGMULL3                               23    ON EOF or unmatch
      *
     C                   EVAL      LPaGrp_Level        = G_MLLEVEL
     C                   EVAL      LPaGrp_Parent       = G_MLPARENT
     C                   EVAL      LPaGrp_GrpId        = G_MLGRPID
      *
     C                   IF        *IN23  = *ON
     C                   EVAL      LPaGrp_Endid        = G_MLID
     C                   ELSE
     C                   EVAL      LPaGrp_Endid        = I_MLID
     C                   ENDIF                                                  FI *IN23 = *ON
      *
     C                   EVAL      Idx     = Idx + 1
      * Load to array @LvlParGrp.
     C                   EVAL      @LvlParGrp(Idx)     = LvlParGrpEntry
      *
     C                   READ      GPGMULL2                               22    EOF
      *
     C                   ENDDO                                                  ODW *IN22 = *OFF
      *                                                                         and U_MLHYID=MLHYID
      * Save Idx as TtlEntry
     C                   EVAL      TtlEntry = Idx
      *
      * Sort @LvlParGrp in descending order
     C                   SORTA     @LvlParGrp
      *
      * Initialise @Parent, @Group and @Endid
     C                   CLEAR                   @Parent
     C                   CLEAR                   @Group
     C                   CLEAR                   @Endid
      *
      * Get the Last End id for the hierarchy.
     C     ActionHYID    SETGT     GPGMULL1
     C     ActionHYID    READPE    GPGMULL1                               22    no record found
     C   22              EXSR      *PSSR
     C                   EVAL      Lvl1Endid = U_MLID
     C                   UNLOCK    GPGMULL1
      *
      * Fill up arrays @Parent, @Group, @LstGId and @Endid from @LvlParGrp
     C                   EVAL      Idx = 1
      *
     C                   DOW       Idx <= TtlEntry
      *
     C                   EVAL      LvlParGrpEntry = @LvlParGrp(Idx)
      *
     C                   EVAL      @Parent(Idx)  = LPaGrp_PARENT
     C                   EVAL      @Group(Idx)   = LPaGrp_GrpId
      *
     C                   IF        LPaGrp_Level    = 1
     C                   EVAL      LPaGrp_Endid    = Lvl1Endid
      * Update Endid in array @LvlParGrp for level 1.
     C                   EVAL      @LvlParGrp(Idx) = LvlParGrpEntry
     C                   ENDIF
      *
     C                   EVAL      @Endid(Idx)     = LPaGrp_Endid
      *
     C                   EVAL      Idx = Idx + 1
      *
     C                   ENDDO                                                  ODW Idx <= TtlEntry
      *
     C     SetArraysE    ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * UpdClntEndIds - Update all End Ids of the group records in    *
      *                 the client section.                           *
      *                                                               *
      * Called from - Main processing                                 *
      *                                                               *
      * Call        - UpdEndIds                                       *
      *                                                               *
      *****************************************************************
     C     UpdClntEndIds BEGSR
      *
     C                   EVAL      I = 1
      *
     C                   DOW       I <= TtlCHyidEntry
      *
     C                   EVAL      ActionHYID = @UpdClntHi(I)
     C                   EXSR      UpdEndIds
      *
     C                   EVAL      I = I + 1
     C                   ENDDO                                                  DOW I<=TtlCHyidEntry
      *
     C     UpdClntEndIdsEENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: None                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR                                                  ** *PSSR SR **
      *
     C     @RUN          IFEQ      *BLANK
     C                   MOVE      'Y'           @RUN              1
     C                   DUMP
     C                   END
      *
     C                   SETON                                        U7U8LR
     C                   RETURN
      *
     C                   ENDSR
      ********************************************************************
