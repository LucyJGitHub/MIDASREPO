      *****************************************************************
     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2005')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  ALWNULL(*USRCTL)                                             *
/*EXI *  TEXT('Midas UP Data validation of T_GRMENU* files')
      *****************************************************************
      *                                                               *
      *  Midas - Bridge                                               *
      *                                                               *
      *  UP1729 - Data validation of T_GRMENU* files                  *
      *                                                               *
      *  (c) Finastra International Limited 2005                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Prev Amend No. 256038 *CREATE     Date 23Feb05               *
      *                 xxxxxx             Date ddmmmyy               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  256038 - This program will check validity of data in         *
      *           T_GRMENU* files.  Also delete the shortname from    *
      *           T_USERMENU if it does not exist on T_GRMENUH.       *
      *                                                               *
      *****************************************************************
      * Function of indicators
      *
      *       20      End of file
      *       22      Record not found or EOF
      *       23      End of file or records not matched (READE GPGMULL3)
      *       30      Chain - record not found
      *       40      match entry found in an array
      *       60      Data error in records on T_GRMENUL
      *
     FGPGMUHL0  IF   E           K DISK    INFSR(*PSSR)
      *  RTV:  Menu group header by Hierarchy Id.
      *
     FGPGMUHL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(T_GRMENUH:GMUH1F) PREFIX(S_)
      *  RTV:  Live Menu group header by Short Name
      *
     FGPGMUGL0  IF   E           K DISK    INFSR(*PSSR)
      *  RTV:  Menu subgroup by Group id.
      *
     FGPGMUGL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(T_GRMENUG:GMUG1F) PREFIX(HG_)
      *  RTV:  Live Menu subgroup by Hierarchy id, Group id.
      *
     FGPGMULL1  IF   E           K DISK    INFSR(*PSSR)
      *  RTV:  Menu records by Hierarchy Id, Link Id
      *
     FGPGMULL2  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(T_GRMENUL:GMUL2F) PREFIX(G_)
      *  RTV:  Group menu records by Hierarchy Id, Group Id
      *
     FGPGMULL3  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(T_GRMENUL:GMUL3F) PREFIX(I_)
      *  RTV:  Menu items by Hierarchy Id, Parent, Link Id. Link Id in descending order.
      *
     FGPMTXTL0  IF   E           K DISK    INFSR(*PSSR)
      *  RTV:  Global Menu Item Text by Unique Code
      *
     FGZSFMENUL0IF   E           K DISK    INFSR(*PSSR) PREFIX(Z_)
      *  RTV:  Menu Master Data by Unique Code
      *
     FGPMENUL0  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SFMENUD0:GPMENUD0) PREFIX(G_)
      *  RTV:  Global Menu Master Data by Unique Code
      *
     FT_USERMENUUF   E             DISK    INFSR(*PSSR)
     F                                     RENAME(T_USERMENU:UMENUF)
      *  RTV:  User to Menu config file
      *
      /EJECT
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
      ** Arrays containing Section id and Section Descriptions
     DA_SectId         S             10    DIM(33) CTDATA PERRCD(1) ASCEND
     DA_SectTxt        S             90    DIM(33) ALT(A_SectId)
      *
      ** Array containing report heading information
     DA_SectPref       S              2    DIM(4) CTDATA PERRCD(1) ASCEND
     DA_SectInfo       S              9    DIM(4) ALT(A_SectPref)
      *
      ** Array containing column lines of each section
     DA_ColLines       S            100    DIM(9) CTDATA PERRCD(1)
      *
      * Array holding Level, Parent, Group, Last Grp Id and End id details
     D @LvlParGrp      S             64    DIM(2000)
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
      * Array holding Menu Code, Link id, Parent details of a hierachy:
     D @MenuCode       S             30    DIM(5000)
     D                                     ASCEND
      *
      * Entry for array A_SectInfo
     D                 DS
     DSectInfoEntry            1      9
     D  SInfo_SHSPos           1      3  0                                      Details start positi
     D  SInfo_ColSLin          4      6  0                                      start entry for sect
     D  SInfo_ColELin          7      9  0                                      End entry for sect
      *
      * Entry for array @LvlParGrp
     D                 DS
     DLvlParGrpEntry           1     64
     D  LPaGrp_Level           1      4  0
     D  LPaGrp_Parent          5     24  0
     D  LPaGrp_GrpId          25     44  0
     D  LPaGrp_Endid          45     64  0
      *
      * Entry for array @MenuCode
     D                 DS
     DMenuCodeEntry            1     30
     D  MC_MenuCode            1     10
     D  MC_Id                 11     30  0
      *
      * Data structure for Section Headers file
     D                 DS
     DSectHeader               1    116
     D  SHID                   1     10
     D  SPref                  1      2
     D  SHSEQ                 11     13  0
     D  SHDSPos               14     16  0
     D  SHHdr                 17    116
      *
      * Data structure for Error Messages file
     D                 DS
     DErrorMsg                 1    197
     D  SEID                   1     10
     D  SEKFLD                11     97
     D  SEMDTL                98    197
      *
      * Data structure for link details to be output to Error Messages file
     D                 DS
     DOpLkKFld                 1     22
     D  OpLkHyId               1      9
     D  OpLkId                14     22
      *
     D                 DS
     DOpLkDtls                 1     65
     D  OpLkEndId              1      9
     D  OpLkGrpId             14     25
     D  OpLkLevel             30     33
     D  OpLkParent            38     49
     D  OpLkMenuCode          54     65
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
     D K1_MLHYID       S                   LIKE(MLHYID)                         key fld in GMUL1Key
     D K1_MLID         S                   LIKE(MLID)                           key fld in GMUL1Key
      *
     D K2_HyId         S                   LIKE(MLHYID)                         key fld in GMUL2Key
     D K2_GrpId        S                   LIKE(MLGRPID)                        key fld in GMUL2Key
      *
     D K3_MLHyId       S                   LIKE(MLHYID)                         key fld in GMUL3Key
     D K3_MLParent     S                   LIKE(MLPARENT)                       key fld in GMUL3Keu
      *
     D KH_HyId         S                   LIKE(MLHYID)                         key fld in HyidKey
      *
     D KH0_MHID        S                   LIKE(MHID)                           key fld in GMUH0Key
      *
     D KG1_MGHYID      S                   LIKE(MGHYID)                         key fld in GMUG1Key
     D KG1_MGID        S                   LIKE(MGID)                           key fld in GMUG1Key
      *
     D SectPrefix      S              2                                         Section Prefix
     D A_Idx           S              3  0                                      A_SectId n A_SectTxt
                                                                                index
     D Ix              S              2  0                                      A_SectPref index
     D CIdx            S              2  0                                      A_ColLines index
     D TtlSectEntry    S              3  0 INZ(33)                              = DIM of A_SectId
     D TtlSPrefEntry   S              3  0 INZ(4)                               =DIM of A_SectPref
      *
     D Idx             S              4  0                                      @LvlParGrp indx
     D PIdx            S              4  0                                      @Parent array index
     D TtlEntry        S              4  0                                      Total entry of grp
      *                                                                         G_GRPId found
     D McIdx           S              4  0                                      @MenuCode array indx
     D TtlMCEntry      S              4  0                                      Ttl entry @MenuCode
      *
     D PrevHyid        S                   LIKE(MLHYID)                         Prev. Hierarchy Id
     D PrevId          S                   LIKE(MLID)                           Prev. Link Id
     D PrevMenuCode    S                   LIKE(MLMenuCode)                     Prev. Menu code
     D HyGrpId         S                   LIKE(MLGRPID)                        Group id for Hy rec
     D CurrentHyId     S                   LIKE(MLHYID)                         Current Hierarchy Id
     D CurrentId       S                   LIKE(MLID)                           Current Link Id
     D MCHyIdA         S              7                                         Hy (A)for *SS *SN mc
     D MCHyId          S                   LIKE(MLHYID)                         Hy id for *SS *SN mc
     D MGHYIDA         S              9                                         MGHYID in character
      *
      *****************************************************************
      * Main processing
      *****************************************************************
      *
      * Set up key list to access GPGMULL2, GPGMUGL1
     C     HyidKey       KLIST
     C                   KFLD                    KH_HyId
      *
      * Set up key list to access GPGMUHL0
     C     GMUH0Key      KLIST
     C                   KFLD                    KH0_MHID
      *
      * Set up key list to access GPGMUGL1
     C     GMUG1Key      KLIST
     C                   KFLD                    KG1_MGHYID
     C                   KFLD                    KG1_MGID
      *
      * Set up key list to access GPGMULL1
     C     GMUL1Key      KLIST
     C                   KFLD                    K1_MLHYID
     C                   KFLD                    K1_MLID
      *
      * Set up key list to access GPGMULL2
     C     GMUL2Key      KLIST
     C                   KFLD                    K2_HYID
     C                   KFLD                    K2_GRPID
      *
      * Set up key list to access GPGMULL3
     C     GMUL3Key      KLIST
     C                   KFLD                    K3_MLHYID
     C                   KFLD                    K3_MLPARENT
      *
      * Output section headers to file UPSHDRPD.
     C                   EXSR      OpSectHdrs
      *
      * X-check hierarchy from T_GRMENUH record against T_GRMENUG and T_GRMENUL:
     C                   EXSR      XChkGMUH
      *
      * X-check hierarchy and group from T_GRMENUG record against T_GRMENUG and T_GRMENUL:
     C                   EXSR      XChkGMUG
      *
      * X-check hierarchy and group from T_GRMENUL record against T_GRMENUH and T_GRMENUG:
     C                   EXSR      XChkGMUL
      *
      * Validate records on T_GRMENUL:
     C                   EXSR      ValGMUL
      *
      * Validate Shortname on T_USERMENU against T_GRMENUH:
     C                   EXSR      ChkSName
      *
     C     ENDPGM        TAG
     C                   SETON                                        LR
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * CallToWrtMsg  - Call program UP008020 to write message to     *
      *                 UPSERRPD.                                     *
      *                                                               *
      * Called from - Main processing                                 *
      *                                                               *
      * Call        - None                                            *
      *                                                               *
      *****************************************************************
     C     CallToWrtMsg  BEGSR
      *
     C                   CALL      'UP008020'
     C                   PARM      '*WRTDTL'     Mode              7
     C                   PARM      ErrorMsg      PassDtl         197
      *
     C     CallToWrtMsgE ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * OpGMUL2EMsg - Output link details error message from GPGMULL2.*
      *                                                               *
      * Called from - XChkGMUL                                        *
      *                                                               *
      * Call        - CallToWrtMsg                                    *
      *                                                               *
      *****************************************************************
     C     OpGMUL2EMsg   BEGSR
      *
     C                   EVAL      OpLkHyid = %EDITC(G_MLHYID:'3')
     C                   EVALR     OpLkid   = %EDITC(G_MLID  :'3')
     C                   EVAL      SEKFLD   = OpLkKFld
      *
     C                   EVALR     OpLkEndId    = %EDITC(G_MLENDID:'3')
      *
     C                   IF        %NULLIND(G_MLGRPID)
     C                   EVALR     OpLkGrpId    = '= null value'
     C                   ELSE
     C                   EVALR     OpLkGrpId    = %EDITC(G_MLGRPID:'3')
     C                   ENDIF
      *
     C                   EVALR     OpLkLevel    = %EDITC(G_MLLEVEL:'3')
     C                   EVALR     OpLkParent   = %EDITC(G_MLPARENT:'3')
      *
     C                   IF        %NULLIND(G_MLMENUCODE)
     C                   EVAL      OpLkMenuCode = '= null value'
     C                   ELSE
     C                   EVAL      OpLkMenuCode = G_MLMENUCODE
     C                   ENDIF
      *
     C                   EVAL      SEMDTL   = OpLkDtls
     C                   EXSR      CallToWrtMsg
      *
     C     OpGMUL2EMsgE  ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * OpLinkEMsg  - Output link details error message from GPGMULL1.*
      *                                                               *
      * Called from - Val1stHyRec                                     *
      *                                                               *
      * Call        - CallToWrtMsg                                    *
      *                                                               *
      *****************************************************************
     C     OpLinkEMsg    BEGSR
      *
     C                   EVAL      OpLkHyid = %EDITC(MLHYID:'3')
     C                   EVALR     OpLkid   = %EDITC(MLID  :'3')
     C                   EVAL      SEKFLD   = OpLkKFld
      *
     C                   EVALR     OpLkEndId    = %EDITC(MLENDID:'3')
      *
     C                   IF        %NULLIND(MLGRPID)
     C                   EVALR     OpLkGrpId    = '= null value'
     C                   ELSE
     C                   EVALR     OpLkGrpId    = %EDITC(MLGRPID:'3')
     C                   ENDIF
      *
     C                   EVALR     OpLkLevel    = %EDITC(MLLEVEL:'3')
     C                   EVALR     OpLkParent   = %EDITC(MLPARENT:'3')
      *
     C                   IF        %NULLIND(MLMENUCODE)
     C                   EVAL      OpLkMenuCode = '= null value'
     C                   ELSE
     C                   EVAL      OpLkMenuCode = MLMENUCODE
     C                   ENDIF
      *
     C                   EVAL      SEMDTL   = OpLkDtls
     C                   EXSR      CallToWrtMsg
      *
     C     OpLinkEMsgE   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * XChkGMUH    - X-check hierarchy from T_GRMENUH against        *
      *               T_GRMENUG and T_GRMENUL.                        *
      *               Each Hierarchy from T_GRMENUH should have at    *
      *               least a group with same hierarchy in T_GRMNEUG  *
      *               and T_GRMENUL.                                  *
      *                                                               *
      * Called from - Main processing                                 *
      *                                                               *
      * Call        - CalToWrtMsg                                     *
      *                                                               *
      *****************************************************************
     C     XChkGMUH      BEGSR
      *
     C     *LOVAL        SETLL     GPGMUHL0
      *
     C                   READ      GPGMUHL0                               20    EOF
      *
     C                   DOW       *IN20 = *OFF
      *
      * Skip the logically deleted record.
     C                   IF        MHDELETED = 'Y'
     C                   GOTO      ReadNGMUHL0
     C                   ELSE
      * Field MHDELETED should only have null value or 'Y'.
     C                   IF        %NULLIND(MHDELETED) = *OFF
     C                   EVAL      SEID     = 'AY01DELETE'
     C                   EVAL      SEKFLD   = %EDITC(MHID:'3')
     C                   EVAL      SEKFLD   = %SUBST(SEKFLD:4:15)
     C                   EVAL      SEMDTL   = MHSNAME
     C                   EVAL      %SUBST(SEMDTL:79) = MHDELETED
     C                   EXSR      CallToWrtMsg
     C                   ENDIF                                                  FI MHDELETED<> null
     C                   ENDIF                                                  FI MHDELETED = 'Y'
      *
      * Check if each hierarchy has at least one group in T_GRMENUG.
      *
     C                   EVAL      KH_HyId   = MHID
     C     HyidKey       CHAIN     GPGMUGL1                           30        record not found
      *
      * If no record with same hierarchy is found, output line (AY02NOGRP)
     C                   IF        *IN30    = *ON
     C                   EVAL      SEID     = 'AY02NOGRP'
     C                   EVAL      SEKFLD   = %EDITC(MHID:'3')
     C                   EVAL      SEKFLD   = %SUBST(SEKFLD:4:15)
     C                   EVAL      SEMDTL   = MHSNAME
     C                   IF        %NULLIND(MHDELETED) = *ON
     C                   EVAL      %SUBST(SEMDTL:79) = '= null value'
     C                   ELSE
     C                   EVAL      %SUBST(SEMDTL:79) = MHDELETED
     C                   ENDIF                                                  FI null MHDELETED
     C                   EXSR      CallToWrtMsg
     C                   ENDIF                                                  FI *IN30 = *ON
      *
      * Check if each hierarchy can be found in T_GRMENUL.
      *
     C     HyidKey       CHAIN     GPGMULL2                           30        record not found
      *
      * If no record with same hierarchy is found, output line (AY03NOLINK)
     C                   IF        *IN30    = *ON
     C                   EVAL      SEID     = 'AY03NOLINK'
     C                   EVAL      SEKFLD   = %EDITC(MHID:'3')
     C                   EVAL      SEKFLD   = %SUBST(SEKFLD:4:15)
     C                   EVAL      SEMDTL   = MHSNAME
     C                   IF        %NULLIND(MHDELETED) = *ON
     C                   EVAL      %SUBST(SEMDTL:79) = '= null value'
     C                   ELSE
     C                   EVAL      %SUBST(SEMDTL:79) = MHDELETED
     C                   ENDIF                                                  FI null MHDELETED
     C                   EXSR      CallToWrtMsg
     C                   ENDIF                                                  FI *IN30 = *ON
      *
     C     ReadNGMUHL0   Tag
     C                   READ      GPGMUHL0                               20    EOF
     C                   ENDDO
      *
      *
     C     XChkGMUHE     ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * XChkGMUG    - X-check hierarchy and group from T_GRMENUG      *
      *               against T_GRMENUH and T_GRMENUL.                *
      *               The hierarchy from T_GRMENUG should be in       *
      *               T_GRMNEUH and the hierarchy and group should be *
      *               in T_GRMENUL.                                   *
      *                                                               *
      * Called from - Main processing                                 *
      *                                                               *
      * Call        - CalToWrtMsg                                     *
      *                                                               *
      *****************************************************************
     C     XChkGMUG      BEGSR
      *
     C     *LOVAL        SETLL     GPGMUGL0
      *
     C                   READ      GPGMUGL0                               20    EOF
      *
     C                   DOW       *IN20 = *OFF
      *
      * Skip the logically deleted record.
     C                   IF        MGDELETED = 'Y'
     C                   GOTO      ReadNGMUGL0
     C                   ELSE
      * Field MGDELETED should noly have null value or 'Y'.
     C                   IF        %NULLIND(MGDELETED) = *OFF
     C                   EVAL      SEID     = 'GP01DELETE'
     C                   EVAL      SEKFLD   = %EDITC(MGID:'3')
     C                   EVAL      SEKFLD   = %SUBST(SEKFLD:4:12)
     C                   EVAL      MGHYIDA  = %EDITC(MGHYID:'3')
     C                   EVAL      %SUBST(SEKFLD:19) = MGHYIDA
     C                   EVAL      SEMDTL   = MGNAME
     C                   EVAL      %SUBST(SEMDTL:62) = MGDELETED
     C                   EXSR      CallToWrtMsg
     C                   ENDIF                                                  FI MGDELETED<> null
     C                   ENDIF                                                  FI MGDELETED = 'Y'
      *
      * Check if the hierarchy of the group from T_GRMENUG is in T_GRMENUH.
     C                   EVAL      KH0_MHID = MGHYID
     C     KH0_MHID      CHAIN     GPGMUHL0                           30        record not found
      *
      * If no record with same hierarchy is found, output line (GP02NOHY)
     C                   IF        *IN30    = *ON  OR
     C                             (*IN30   = *OFF  AND
     C                             MHDELETED = 'Y')
     C                   EVAL      SEID     = 'GP02NOHY'
     C                   EVAL      SEKFLD   = %EDITC(MGID:'3')
     C                   EVAL      SEKFLD   = %SUBST(SEKFLD:4:12)
     C                   EVAL      MGHYIDA  = %EDITC(MGHYID:'3')
     C                   EVAL      %SUBST(SEKFLD:19) = MGHYIDA
     C                   EVAL      SEMDTL   = MGNAME
     C                   IF        %NULLIND(MGDELETED) = *ON
     C                   EVAL      %SUBST(SEMDTL:62) = '= null value'
     C                   ELSE
     C                   EVAL      %SUBST(SEMDTL:62) = MGDELETED
     C                   ENDIF                                                  FI null MGDELETED
     C                   EXSR      CallToWrtMsg
     C                   ENDIF                                                  FI *IN30 = *ON
      *
      * Check if the hierarchy and group from T_GRMENUG is in T_GRMENUL.
     C                   EVAL      K2_HyId   = MGHYID
     C                   EVAL      K2_GrpId  = MGID
     C     GMUL2Key      CHAIN     GPGMULL2                           30        record not found
      *
      * If no record found, output line (GP03NOLINK)
     C                   IF        *IN30    = *ON
     C                   EVAL      SEID     = 'GP03NOLINK'
     C                   EVAL      SEKFLD   = %EDITC(MGID:'3')
     C                   EVAL      SEKFLD   = %SUBST(SEKFLD:4:12)
     C                   EVAL      MGHYIDA  = %EDITC(MGHYID:'3')
     C                   EVAL      %SUBST(SEKFLD:19) = MGHYIDA
     C                   EVAL      SEMDTL   = MGNAME
     C                   IF        %NULLIND(MGDELETED) = *ON
     C                   EVAL      %SUBST(SEMDTL:62) = '= null value'
     C                   ELSE
     C                   EVAL      %SUBST(SEMDTL:62) = MGDELETED
     C                   ENDIF                                                  FI null MGDELETED
     C                   EXSR      CallToWrtMsg
     C                   ENDIF                                                  FI *IN30 = *ON
      *
     C     ReadNGMUGL0   TAG
     C                   READ      GPGMUGL0                               20    EOF
      *
     C                   ENDDO
      *
     C     XChkGMUGE     ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * XChkGMUL    - X-check hierarchy and group from T_GRMENUL      *
      *               against T_GRMENUH and T_GRMENUG.                *
      *               The hierarchy from T_GRMENUL should be in       *
      *               T_GRMNEUH and the hierarchy and group should be *
      *               in T_GRMENUG.                                   *
      *                                                               *
      * Called from - Main processing                                 *
      *                                                               *
      * Call        - OpGMUL2EMsg                                     *
      *                                                               *
      *****************************************************************
     C     XChkGMUL      BEGSR
      *
     C     *LOVAL        SETLL     GPGMULL2
      *
     C                   READ      GPGMULL2                               20    EOF
      *
     C                   DOW       *IN20 = *OFF
      *
      * Check if the hierarchy of the group from T_GRMENUL is in T_GRMENUH.
     C                   EVAL      KH0_MHID = G_MLHYID
     C     GMUH0Key      CHAIN     GPGMUHL0                           30        record not found
      *
      * If no record with same hierarchy is found, output line (LK01NOHY)
     C                   IF        *IN30    = *ON   OR
     C                             (*IN30   = *OFF  AND
     C                             %NULLIND(MHDELETED) = *OFF)
      *
     C                   EVAL      SEID     = 'LK01NOHY'
     C                   EXSR      OpGMUL2EMsg
     C                   ENDIF                                                  FI *IN30 = *ON
      *
      * Check if the hierarchy and group from T_GRMENUL is in T_GRMENUG.
     C                   EVAL      KG1_MGHYID = G_MLHYID
     C                   EVAL      KG1_MGID   = G_MLGRPID
     C     GMUG1Key      CHAIN     GPGMUGL1                           30        record not found
      *
      * If no record found, output line (LK02NOGRP)
     C                   IF        *IN30    = *ON
     C                   EVAL      SEID     = 'LK02NOGRP'
     C                   EXSR      OpGMUL2EMsg
     C                   ENDIF                                                  FI *IN30 = *ON
      *
     C                   READ      GPGMULL2                               20    EOF
     C                   ENDDO
      *
     C     XChkGMULE     ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * ValGMUL     - Validate records on T_GRMENUL.                  *
      *                                                               *
      * Called from - Main processing                                 *
      *                                                               *
      * Call        - Val1stHyRec                                     *
      *                                                               *
      *****************************************************************
     C     ValGMUL       BEGSR
      *
     C     *LOVAL        SETLL     GPGMULL1
      *
     C                   READ      GPGMULL1                               20    EOF
      *
     C                   DOW       *IN20 = *OFF
      *
      * For each new hierarchy,
     C                   SETOFF                                       60        Data error indicator
      * Validate the first record of each hierarchy:
     C                   EXSR      Val1stHyRec
      *
      * Initialise variables for a new hierarchy.
     C                   EVAL      McIdx      = 0
     C                   MOVE      *ALL'9'       @MenuCode
      *
     C                   EVAL      PrevId     = MLID
     C                   EVAL      PrevHYID   = MLHYID
      *
     C                   READ      GPGMULL1                               20    EOF
      *
      * Validate groups under the same hierarchy.
     C                   DOW       *IN20     = *OFF AND
     C                             PrevHyId  = MLHYID
      *
      * If it is a group record, validate the group record.
     C                   IF        %NULLIND(MLGRPID) = *OFF
      *
     C                   EXSR      ValGrpRec
      *
      * else (ie, menu link record)
     C                   ELSE
     C                   EXSR      ValMenuLink
     C                   ENDIF
      *
      * Read next record
     C                   EVAL      PrevId     = MLID
      *
     C                   READ      GPGMULL1                               20    EOF
      *
     C                   ENDDO                                                  ODW *IN20 = *ON and
      *                                                                         same hy and same gp.
      *
      *  At the end of each hierarchy, if not EOF, save current hierarchy and link id.
     C                   IF        *IN20 = *OFF
     C                   EVAL      CurrentHyid = MLHYID
     C                   EVAL      CurrentId   = MLID
     C                   ENDIF
      *
      *  If there is no data error, validate the Endid of the hierarchy record
      *  and each group record.
     C  N60              EXSR      ValEndIds
      *  Validate Menucodes to be unique within a hierarchy.
     C                   EXSR      ChkDupMCode
      *
      *  If not EOF, set the pointer back to current hierarchy and link id record.
     C                   IF        *IN20 = *OFF
     C                   EVAL      K1_MLHYID  = CurrentHyid
     C                   EVAL      K1_MLID    = CurrentId
     C     GMUL1Key      CHAIN     GPGMULL1                           30
     C   30              EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDDO                                                  ODW *IN20 = *ON
      *
     C     ValGMULE      ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * Val1stHyRec - Validate first record of each hierachy on file  *
      *               GPGMULL1.                                       *
      *                                                               *
      * Called from - ValGMUL                                         *
      *                                                               *
      * Call        - CalToWrtMsg                                     *
      *                                                               *
      *****************************************************************
     C     Val1stHyRec   BEGSR
      *
      * The link id of the first record of each hierarchy should be 1.
     C                   IF        MLID <> 1
     C                   EVAL      SEID            = 'LK03NHYID1'
     C                   EXSR      OpLinkEMsg
     C  N60              SETON                                        60        Data error
     C                   ENDIF                                                  FI MLID <> 1
      *
      * The Group id of the first record of each hierarchy should be > 0 and
      * not null value.
     C                   IF        %NULLIND(MLGRPID) = *ON  OR
     C                             MLGRPID = 0
     C                   EVAL      SEID            = 'LK04NHYGPN'
     C                   EXSR      OpLinkEMsg
     C  N60              SETON                                        60        Data error
     C                   ENDIF                                                  FI %NULLIND(MLGRPID)
      *                                                                          = *ON or MLGRPID=0
      * Save Group id for the hierarchy record.
     C                   EVAL      HyGrpId = MLGRPID
      *
      * The level of the first record of each hierarchy should be 1.
     C                   IF        MLLEVEL <> 1
     C                   EVAL      SEID            = 'LK05NHYLVL'
     C                   EXSR      OpLinkEMsg
     C  N60              SETON                                        60        Data error
     C                   ENDIF                                                  FI MLLEVEL <> 1
      *
      * The Parent group of the first record of each hierarchy should be 0.
     C                   IF        MLPARENT <> 0
     C                   EVAL      SEID            = 'LK06NHYPAR'
     C                   EXSR      OpLinkEMsg
     C  N60              SETON                                        60        Data error
     C                   ENDIF                                                  FI MLPARENT <> 0
      *
      * The Menu code of the first record of each hierarchy should be at null value.
     C                   IF        %NULLIND(MLMENUCODE) = *OFF
     C                   EVAL      SEID            = 'LK07NHYMCN'
     C                   EXSR      OpLinkEMsg
     C                   ENDIF                                                  FI MLMENUCODE <>null
      *
     C     Val1stHyRecE  ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * ValGrpRec   - Validate first record of each group on GPGMULL1 *
      *                                                               *
      *                                                               *
      * Called from - ValGMUL                                         *
      *                                                               *
      * Call        - CalToWrtMsg                                     *
      *                                                               *
      *****************************************************************
     C     ValGrpRec     BEGSR
      *
      * The link id should be 1 later than the link id of previous rec.
     C                   IF        MLID <> PrevId + 1
     C                   EVAL      SEID            = 'LK08LNKID'
     C                   EXSR      OpLinkEMsg
     C  N60              SETON                                        60        Data error
     C                   ENDIF                                                  FI MLID <> PrevId+1
      *
      * The Group id of each group should be > 0.
     C                   IF        MLGRPID = 0
     C                   EVAL      SEID            = 'LK09NGRPID'
     C                   EXSR      OpLinkEMsg
     C  N60              SETON                                        60        Data error
     C                   GOTO      ValGrpMenCode
     C                   ENDIF                                                  FI %NULLIND(MLGRPID)
      *                                                                          = *ON or MLGRPID=0
      *
      * If the Parent group of the group record is 0, level should be 2.
     C                   IF        MLPARENT = 0
     C                   IF        MLLEVEL  <> 2
     C                   EVAL      SEID            = 'LK10PAR0L2'
     C                   EXSR      OpLinkEMsg
     C  N60              SETON                                        60        Data error
     C                   ENDIF                                                  FI MLLEVEL <> 2
     C                   GOTO      ValGrpMenCode
     C                   ENDIF                                                  FI MLPARENT = 0
      *
      * The parent group should be <> its group Id.
     C                   IF        MLGRPID  = MLPARENT
     C                   EVAL      SEID            = 'LK11SPARGP'
     C                   EXSR      OpLinkEMsg
     C  N60              SETON                                        60        Data error
     C                   GOTO      ValGrpMenCode
     C                   ENDIF                                                  FI MLGRPID=MLPARENT
      *
      * The parent group should not be same as the group in the hierarchy rec.
     C                   IF        MLPARENT = HyGrpId
     C                   EVAL      SEID            = 'LK20LHYGRP'
     C                   EXSR      OpLinkEMsg
     C  N60              SETON                                        60        Data error
     C                   GOTO      ValGrpMenCode
     C                   ENDIF                                                  FI MLPARENT=HyGrpId
      *
      * The parent group should be another group within the hierarchy.
     C                   EVAL      K2_HYID  = MLHYID
     C                   EVAL      K2_GRPID = MLPARENT
     C     GMUL2Key      CHAIN     GPGMULL2                           30        record not found
     C                   IF        *IN30    = *ON
     C                   EVAL      SEID            = 'LK12PARGRP'
     C                   EXSR      OpLinkEMsg
     C  N60              SETON                                        60        Data error
     C                   ELSE                                                   ie record found
      *  If group of the parent group is found, the level should be 1 greater
      *  than its parent group's.
     C                   IF        MLLEVEL <> G_MLLEVEL + 1
     C                   EVAL      SEID            = 'LK13GRPLVL'
     C                   EXSR      OpLinkEMsg
     C  N60              SETON                                        60        Data error
     C                   ENDIF                                                  FI MLLEVEL <>
      *                                                                            G_MLLEVEL + 1
      *
     C                   ENDIF                                                  FI *IN30 = *ON
      *
     C     ValGrpMenCode TAG
      *    =============
      * The Menu code of group record should be at null value.
     C                   IF        %NULLIND(MLMENUCODE) = *OFF
     C                   EVAL      SEID            = 'LK14GRPMCN'
     C                   EXSR      OpLinkEMsg
     C                   ENDIF                                                  FI MLMENUCODE <>null
      *
     C     ValGrpRecE    ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * ValMenuLink - Validate a menu link record on GPGMULL1         *
      *                                                               *
      *                                                               *
      * Called from - ValGMUL                                         *
      *                                                               *
      * Call        - CalToWrtMsg                                     *
      *                                                               *
      *****************************************************************
     C     ValMenuLink   BEGSR
      *
      * The link id should be 1 later than the link id of previous rec.
     C                   IF        MLID <> PrevId + 1
     C                   EVAL      SEID            = 'LK08LNKID'
     C                   EXSR      OpLinkEMsg
     C  N60              SETON                                        60        Data error
     C                   ENDIF                                                  FI MLID <> PrevId+1
      *
      * The link id and end id of menu link should be the same.
     C                   IF        MLID <> MLENDID
     C                   EVAL      SEID            = 'LK15LSAMID'
     C                   EXSR      OpLinkEMsg
     C  N60              SETON                                        60        Data error
     C                   ENDIF                                                  FI MLID = MLENDID
      *
      * If the Parent group of the link record is 0, level should be = 2.
     C                   IF        MLPARENT = 0
     C                   IF        MLLEVEL  <> 2
     C                   EVAL      SEID            = 'LK16MPARL2'
     C                   EXSR      OpLinkEMsg
     C  N60              SETON                                        60        Data error
     C                   ENDIF                                                  FI MLLEVEL < 2
     C                   GOTO      ValLnkMenCode
     C                   ENDIF                                                  FI MLPARENT = 0
      *
      * If parent group is not 0,
      *    the parent group should not be same as the group in the hierarchy rec.
     C                   IF        MLPARENT = HyGrpId
     C                   EVAL      SEID            = 'LK20LHYGRP'
     C                   EXSR      OpLinkEMsg
     C  N60              SETON                                        60        Data error
     C                   GOTO      ValLnkMenCode
     C                   ENDIF                                                  FI MLPARENT=HyGrpId
      *
      * The parent group should be another group within the hierarchy.
     C                   EVAL      K2_HYID  = MLHYID
     C                   EVAL      K2_GRPID = MLPARENT
     C     GMUL2Key      CHAIN     GPGMULL2                           30        record not found
     C                   IF        *IN30    = *ON
     C                   EVAL      SEID            = 'LK12PARGRP'
     C                   EXSR      OpLinkEMsg
     C                   ELSE                                                   ie record found
      *  If the parent group is found, the level should be 1 greater
      *  than its parent group's level.
     C                   IF        MLLEVEL <> G_MLLEVEL + 1
     C                   EVAL      SEID            = 'LK13GRPLVL'
     C                   EXSR      OpLinkEMsg
     C  N60              SETON                                        60        Data error
     C                   ENDIF                                                  FI MLLEVEL <>
      *                                                                            G_MLLEVEL + 1
     C                   ENDIF                                                  FI *IN30 = *ON
      *
     C     ValLnkMenCode TAG
      *    =============
      * The Menu code of menu link record should not be at null value or blank
     C                   IF        %NULLIND(MLMENUCODE) = *ON  OR
     C                             MLMENUCODE  = *BLANK
     C                   EVAL      SEID            = 'LK17NULLMC'
     C                   EXSR      OpLinkEMsg
     C                   GOTO      ValMenuLinkE
     C                   ENDIF                                                  FI MLMENUCODE <>null
      *
      * Add the non-null menu code to array @MenuCode
     C                   EVAL      MC_MenuCode  = MLMENUCODE
     C                   EVAL      MC_Id        = MLID
     C                   EVAL      McIdx        = McIdx + 1
     C                   EVAL      @MenuCode(McIdx) = MenuCodeEntry
      *
      * For menucode starting with *SS or *SN,
     C                   IF        %SUBST(MLMENUCODE:1:3) = '*SS' OR
     C                             %SUBST(MLMENUCODE:1:3) = '*SN'
     C                   EVAL      MCHyIdA  = %SUBST(MLMENUCODE:4:7)
     C                   EVAL      MCHYId   = %DEC(MCHyIdA:9:0)
      *
      *  hierarchy referred by *SS and SN menu code should not refer back to its own hierarchy's.
     C                   IF        MCHyId   = MLHYID
     C                   EVAL      SEID            = 'LK18MHYITS'
     C                   EXSR      OpLinkEMsg
      *
     C                   ELSE
      *  the hierarchy refereed by *SS and *SN menu code should exist in the file.
     C                   EVAL      KH_HyId  = MCHyId
     C     HyidKey       CHAIN     GPGMULL2                           30        Record not found
     C                   IF        *IN30    = *ON
     C                   EVAL      SEID            = 'LK23MHYNEX'
     C                   EXSR      OpLinkEMsg
     C                   ENDIF                                                  FI *IN30 = *ON
     C                   ENDIF                                                  FI MCHYId = MLHYID
      *
     C                   GOTO      ValMenuLinkE
     C                   ENDIF                                                  FI menucode starting
      *                                                                         with *SS or *SN
      * Menucode not starting with *SS nor *SN is menu item unique code.
      * The menu item unique code should exist in GPGMTXTPD.
     C     MLMENUCODE    CHAIN     GPMTXTL0                           30        Rec not found
     C                   IF        *IN30 = *ON OR
     C                             (*IN30 = *OFF AND
     C                             MIDEL  = 'Y')
     C                   EVAL      SEID            = 'LK24MCGTXT'
     C                   EXSR      OpLinkEMsg
     C                   ENDIF
      *
      * The menu item unique code starting with *G should exist in GPMENUPD.
     C                   IF        %SUBST(MLMENUCODE:1:2) = '*G'
     C     MLMENUCODE    CHAIN     GPMENUL0                           30        Rec not found
     C                   IF        *IN30 = *ON
     C                   EVAL      SEID            = 'LK25MCGPMU'
     C                   EXSR      OpLinkEMsg
     C                   ENDIF
      *
     C                   ELSE
      * Menu item unique code not starting with *G should exist in GZMENUPD.
     C     MLMENUCODE    CHAIN     GZSFMENUL0                         30        Rec not found
     C                   IF        *IN30 = *ON
     C                   EVAL      SEID            = 'LK26MCGZMU'
     C                   EXSR      OpLinkEMsg
     C                   ENDIF
      *
     C                   ENDIF                                                  FI %SUBST(MLMENUCODE
      *                                                                         = '*G'
     C     ValMenuLinkE  ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * ValEndIds - Validate End Ids of the hierarchy record and all  *
      *             group records.                                    *
      *                                                               *
      * Called from - ValGMUL                                         *
      *                                                               *
      * Call        - SetArrays                                       *
      *               OpGMUL2EMsg                                     *
      *                                                               *
      *****************************************************************
     C     ValEndIds     BEGSR
      *
      * Set up arrays @LvlParGrp, @Parent, ...@EndId.
     C                   EXSR      SetArrays
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
      * Get EndId in the file GPGMULL2.
     C                   EVAL      K2_HyId    = PrevHYID
     C                   EVAL      K2_GrpId   = @Group(Idx)
     C     GMUL2Key      CHAIN     GPGMULL2                           30        Record not found
     C   30              EXSR      *PSSR
      *
      * If EndId in file GPGMULL2 is different from the caculated end id, report.
     C                   IF        G_MLENDID  <> @Endid(Idx)
     C                   EVAL      SEID            = 'LK19GENDID'
     C                   EXSR      OpGMUL2EMsg
     C                   ELSE
      * Each group should have at least one menu item or one sub-group.
     C                   IF        G_MLENDID = G_MLID
     C                   EVAL      SEID            = 'LK21GNOITM'
     C                   EXSR      OpGMUL2EMsg
     C                   ENDIF                                                  FI G_MLENDID=G_MLID
     C                   ENDIF                                                  FI G_MLENDID <>
      *                                                                            @Endid(Idx)
      *
     C                   EVAL      Idx     = Idx + 1
     C                   ENDDO                                                  ODW Idx <= TtlEntry
      *
     C     ValEndIdsE    ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * SetArrays    - Set up array @LvlParGrp and Sort in descending *
      *                order.                                         *
      *                Set up arrays @Parent, @Group, @LstGId and     *
      *                @Endid corresponding to @LvlParGrp.            *
      *                                                               *
      * Called from - ValEndIds                                       *
      *                                                               *
      * Call        -                                                 *
      *                                                               *
      *****************************************************************
     C     SetArrays     BEGSR
      *
      * Initialize variables.
     C                   EVAL      Idx           = 0
     C                   EVAL      KH_HyId       = PrevHYID
     C                   EVAL      K3_MLHYID     = PrevHYID
     C                   EVAL      @LvlParGrp    = *BLANK
      *
      * Fill array @LvlParGrp
     C     HyidKey       SETLL     GPGMULL2
      *
     C     HyidKey       CHAIN     GPGMULL2                           22        RNF
      *  22              EXSR      *PSSR
      *
      * Check records until all records of same hierarchy have been read.
     C                   DOW       *IN22     = *OFF  AND
     C                             G_MLHYID  = PrevHYID
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
      *                                                                       and G_MLHYID=PrevHYID
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
     C                   EVAL      LPaGrp_Endid    = PrevId
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
      * ChkDupMCode - Validate Menu codes for its uniqueness within   *
      *               same hierarchy.                                 *
      *                                                               *
      * Called from - ValGMUL                                         *
      *                                                               *
      * Call        - OpLinkEMsg                                      *
      *                                                               *
      *****************************************************************
     C     ChkDupMCode   BEGSR
      *
      * Save McIdx as TtlMCEntry
     C                   EVAL      TtlMCEntry = McIdx
      *
      * Sort @MenuCode in ascending order
     C                   SORTA     @MenuCode
      *
     C                   EVAL      McIdx   = 1
      *
     C                   DOW       McIdx <= TtlMCEntry
      *
     C                   EVAL      MenuCodeEntry = @MenuCode(McIdx)
      *
      * Do not check the first entry of the array
     C                   IF        MCIdx    =   1
     C                   EVAL      PrevMenuCode = MC_MenuCode
      *
     C                   ELSE
      *
      * If menucode same as previous menucode in the arrary @Menucode, report.
     C                   IF        PrevMenuCode = MC_MenuCode
     C                   EVAL      SEID       = 'LK22MCDUP'
      * Retrieve record details from file GPGMULL1
     C                   EVAL      K1_MLHYID  = PrevHyid
     C                   EVAL      K1_MLID    = MC_ID
     C     GMUL1Key      CHAIN     GPGMULL1                           30
     C   30              EXSR      *PSSR
     C                   EXSR      OpLinkEMsg
      *
     C                   ELSE
     C                   EVAL      PrevMenuCode = MC_MenuCode
     C                   ENDIF                                                  FI PrevMenuCodee =
      *                                                                            MC_MenuCode
     C                   ENDIF                                                  FI MCIdx = 1
      *
     C                   EVAL      McIdx   = McIdx  + 1
     C                   ENDDO                                                  ODW McIdx<=TtlMCEntr
      *
     C     ChkDupMCodeE  ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * ChkSName    - Report and delete any shortnames in T_USERMENU  *
      *               but do not exist in T GRMENUH.                  *
      *                                                               *
      * Called from - Main processing                                 *
      *                                                               *
      * Call        - CallToWrtMsg                                    *
      *                                                               *
      *****************************************************************
     C     ChkSName      BEGSR
      *
     C                   READ      T_USERMENU                             20    EOF
      *
     C                   DOW       *IN20  = *OFF
      *
      * If Short name is null or blank, skip the check and go to read next record.
     C                   IF        %NULLIND(SHNAME) = *ON OR
     C                             SHNAME  = *BLANK
     C                   GOTO      ReadNUserMenu
     C                   ENDIF
      *
      * Check if short name exists in T_GRMENUH
     C     SHNAME        CHAIN     GPGMUHL1                           30        Record not found
      *
      * If not exist (ie, no record with MHDELETED = *NULL found for the hierarchy),
      *    report the short name and delete the record from T_USERMENU.
     C                   IF        *IN30  = *ON
     C                   EVAL      SEID   = 'SN01NOSNAM'
     C                   EVAL      SEKFLD = SHNAME
     C                   EVAL      SEMDTL = MUSERNAME
     C                   EVAL      %SUBST(SEMDTL:24) = TZONE
     C                   EXSR      CallToWrtMsg
      *
     C                   DELETE    T_USERMENU
     C                   ENDIF                                                  FI *IN30 = *ON
      *
     C     ReadNUserMenu TAG
      *
     C                   READ      T_USERMENU                             20    EOF
      *
     C                   ENDDO                                                  ODW *IN20 = *OFF
      *
     C     ChkSNameE     ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * CallToWrtSect - Call program UP008020 to write section header.*
      *                                                               *
      * Called from - OpSectHdrs                                      *
      *                                                               *
      * Call        - None                                            *
      *                                                               *
      *****************************************************************
     C     CallToWrtSect BEGSR
      *
     C                   CALL      'UP008020'
     C                   PARM      '*WRTHDR'     Mode              7
     C                   PARM      SectHeader    PassDtl         197
      *
     C     CallToWrtSectEENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * OpSectHdrs - Output secition header records to file UPSHDRPD. *
      *                                                               *
      * Called from - Main processing                                 *
      *                                                               *
      * Call        - CallToWrtSect                                   *
      *                                                               *
      *****************************************************************
     C     OpSectHdrs    BEGSR
      *
      * Output section text lines:
      * =========================
      *
      * Initialise variables.
     C                   EVAL      A_Idx = 1                                    A_SectId index
     C                   EVAL      SHSEQ = 0
     C                   EVAL      SHID  = *BLANK
      *
     C                   DOW       A_Idx <= TtlSectEntry
      *
      * If change of section prefix,
      *   get descriptions starting positions for the section type from Table TabSectInfo
     C                   IF        SPref <> %SUBST(A_SectId(A_Idx):1:2)
     C                   EVAL      SectPrefix  = %SUBST(A_SectId(A_Idx):1:2)
     C                   EVAL      Ix = 1                                       A_SectPref index
     C     SectPrefix    LOOKUP    A_SectPref(Ix)                         40
     C  N40              EXSR      *PSSR
      *
     C                   EVAL      SectInfoEntry = A_SectInfo(Ix)
     C                   EVAL      SHDSPOS = SInfo_SHSPos
     C                   ENDIF                                                  ENDIF diff. s prefix
      *
     C                   IF        SHID  <> A_SectId(A_Idx)
     C                   EVAL      SHID    = A_SectId(A_Idx)
     C                   EVAL      SHSEQ   = 1
     C                   ELSE
     C                   EVAL      SHSEQ   = SHSEQ + 1
     C                   ENDIF
      *
     C                   EVAL      SHHDR   = A_SectTxt(A_Idx)
      *
     C                   EXSR      CallToWrtSect
      *
     C                   EVAL      A_Idx = A_Idx + 1
     C                   ENDDO                                                  DOW A_Idx <=
      *                                                                             TtlSectEntry
      * Output column lines:
      * ===================                                                         TtlSectEntry
      *
     C                   EVAL      A_Idx = 1                                    A_SectInfo index
      *
     C                   DOW       A_Idx <= TtlSPrefEntry
      *
      * Get one section prefix information entry from A_SectInfo.
     C                   EVAL      SectInfoEntry = A_SectInfo(A_Idx)
      *
     C                   EVAL      SHID    = A_SectPref(A_Idx) + 'COL'
     C                   EVAL      SHDSPOS = SInfo_SHSPos
      *
     C                   EVAL      CIdx    = SInfo_ColSLin
     C                   EVAL      SHSEQ   = 0
      *
      * Write all column lines for the section prefix.
     C                   DOW       CIdx    <= SInfo_ColELin
      *
     C                   EVAL      SHSEQ   = SHSEQ + 1
     C                   EVAL      SHHDR   = A_ColLines(CIdx)
      *
     C                   EXSR      CallToWrtSect
      *
     C                   EVAL      CIdx    = Cidx  + 1
     C                   ENDDO                                                  WDO CIdx <=
      *                                                                             SInfo_ColELin
      * Increment index for next section info entry
     C                   EVAL      A_Idx    = A_Idx  + 1
     C                   ENDDO                                                  UDO A_Idx =
      *                                                                             TtlSPrefEntry
      *
     C     OpSectHdrsE   ENDSR
      *
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
**  A_SectId, T_SectTxt
AY01DELETERecords in T_GRMENUH have field MHDELETED not = 'Y' nor at null value:
AY02NOGRP Hierarchies in T_GRMENUH do not have Group in T_GRMENUG:
AY03NOLINKHierarchies in T_GRMENUH cannot be found in T_GRMENUL:
GP01DELETERecords in T_GRMENUG have field MGDELETED not = 'Y' nor at null value:
GP02NOHY  Groups in T_GRMENUG have Hierarchies not found in T_GRMENUH:
GP03NOLINKGroups in T_GRMENUG have a Hierarchy/Group combination not found in T_GRMENUL:
LK01NOHY  Records in T_GRMENUL have Hierarchies not found in T_GRMENUH:
LK02NOGRP Records in T_GREMNUL have a Hierarchy/Group combination not found in T_GRMENUG:
LK03NHYID1First record of each hierarchy in T_GRMENUL does not have Link Id = 1:
LK04NHYGPNFirst record of each hierarchy in T_GRMENUL has Group Id at null or = 0:
LK05NHYLVLFirst record of each hierarchy in T_GRMENUL does not have Level = 1:
LK06NHYPARFirst record of each hierarchy in T_GRMENUL does not have Parent Group = 0:
LK07NHYMCNFirst record of each hierarchy in T_GRMENUL does not have Menu Code at null value:
LK08LNKID Menu records in T_GRMENUL do not have Link Id incremented by 1 from the previous record:
LK09NGRPIDT_GRMENUL records (except first record of each hierarchy) have Group Ids not null nor > 0:
LK10PAR0L2Group records in T_GRMENUL have Parent Groups = 0 but Levels not = 2:
LK11SPARGPGroup records in T_GRMENUL have same Group Ids and Parent Groups:
LK12PARGRPGroup/Menu link recs. in T_GRMENUL have the Parent Groups not found in their hierarchies:
LK13GRPLVLGroup/Menu link records in T_GRMENUL have Levels not 1 greater than the Parents' Level:
LK14GRPMCNGroup records in T_GRMENUL do not have Menu Codes at null value:
LK15LSAMIDMenu link records in T_GRMENUL do not have Link Ids = End Ids:
LK16MPARL2Menu link records in T_GRMENUL have Parent Groups = 0 but Levels not = 2:
LK17NULLMCMenu link records in T_GRMENUL have Menu Codes at null value or blank:
LK18MHYITSMenu link records in T_GRMENUL have Menu Codes referring to its hierarchy:
LK19GENDIDGroup/Hierarchy records in T_GRMENUL do not have correct End Ids:
LK20LHYGRPGroup/Menu link recs in T_GRMENUL have Parents = Group Id of 1st rec of their hierarchies:
LK21GNOITMGroup records in T_GRMENUL do not have any menu items nor any sub-groups:
LK22MCDUP Menu link recs in T_GRMENUL have Menu Codes already existed in same hierarchies:
LK23MHYNEXMenu link recs in T_GRMENUL have Menu Codes referring to Hierarchies not in T_GRMENUL:
LK24MCGTXTMenu link records in T_GRMENUL have Menu Codes not found in GPMTXTPD:
LK25MCGPMUMenu link records in T_GRMENUL have Menu Codes start with *G but not found in GPMENUPD:
LK26MCGZMUMenu link records in T_GRMENUL have Menu Codes not start with *G but not in GZSFMENUPD:
SN01NOSNAMShortnames have been deleted from T_USERMENU because they do not exist in T_GRMENUH:
**  A_SectPref, A_SectInfo
AY016001002
GP033003004
LK027005007
SN068008009
**       A_ColLines
Hierarchy Id   Short Name                                                                    Deleted
------------   ----------                                                                    -------
Group Id       Hierarchy Id     Name                                                         Deleted
------------   ------------     ----                                                         -------
Hierarchy     Link Id      End Id        Group Id     Level       Parent        Menu Code
Id.
---------    ---------    ---------    ------------   -----    ------------    ------------
Short Name                                                         User Name              Zone
----------------------------------------------------------------   --------------------   ----------
