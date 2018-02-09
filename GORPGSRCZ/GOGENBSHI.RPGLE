     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  ALWNULL(*USRCTL)                                             *
/*EXI *  TEXT('Midas GO Generate BSPL Hierarchies')
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GOGENBSHI - Generate BSPL Hierarchies                        *
      *                                                               *
      *  (c) Finastra International Limited 2005                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. BUG7244            Date 20May05               *
      *                 CGP010  *CREATE    Date 17Jan05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  BUG7244 - Problem while generating the BSPL Hierarchies      *
      *  CGP010 - Global BSPL                                         *
      *                                                               *
      *****************************************************************
 
     FSDRPSTL0  IF   E           K DISK
     FSDREPCL0  IF   E           K DISK
     FSDACRCL0  IF   E           K DISK
 
     FT_GRBSPLH UF A E             DISK    RENAME(T_GRBSPLH:GRBSPLH)
     FT_GRBSPLG UF A E             DISK    RENAME(T_GRBSPLG:GRBSPLG)
     FT_GRBSPLL IF A E             DISK    RENAME(T_GRBSPLL:GRBSPLL)
 
 
     D Groups          S             30    DIM(1000)
     D Links           S             47    DIM(9900)
 
 
     D                 DS
     D LinkDetails             1     47
     D LinkEndId               1     15  0
     D LinkGroupID            16     30  0
     D LinkLevel              31     35  0
     D LinkACOD               36     45
     D LinkDRCR               46     46
     D LinkRecord             47     47
 
 
     C                   Z-ADD     1             TopNo            15 0
     C     SDREPCK       SETLL     SDREPCL0
     C     SDREPCK       READE     SDREPCL0                               99
     C     *IN99         DOWEQ     *OFF
     C                   EXSR      REPC
 
     C     SDACRCK       SETLL     SDACRCL0
     C     SDACRCK       READE     SDACRCL0                               99
     C     *IN99         DOWEQ     *OFF
     C     G6ACCD        IFNE      *BLANK                                                    BUG7244
     C                   EXSR      ACRC
     C                   ENDIF                                                               BUG7244
     C     SDACRCK       READE     SDACRCL0                               99
     C                   ENDDO
 
     C     SDREPCK       READE     SDREPCL0                               99
     C                   ENDDO
 
     C                   EXSR      DET_ENDID
 
      * Write hierarchy, groups and links
 
     C                   EXSR      WRT_HIER
     C                   EXSR      WRT_GRUPS
     C                   EXSR      WRT_LINKS
 
     C                   SETON                                        LR
     C                   RETURN
 
      /SPACE 5
      *****************************************************************
      * Report Code Processing                                        *
      *****************************************************************
     C     REPC          BEGSR
 
     C                   ADD       1             GrpID
     C                   MOVEL     G4RPNA        Groups(GrpID)
 
     C                   ADD       1             LnkID
 
     C                   MOVE      *ZEROS        LinkDetails
     C                   Z-ADD     GrpID         LinkGroupID
     C                   Z-ADD     *ZERO         LinkLevel
     C                   MOVE      G4LVNB        LinkLevel
     C                   ADD       1             LinkLevel
     C                   MOVE      'Y'           LinkRecord
     C                   MOVEL     LinkDetails   Links(LnkID)
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Account Code Processing                                       *
      *****************************************************************
     C     ACRC          BEGSR
 
     C                   ADD       1             LnkID
 
     C                   MOVE      *ZEROS        LinkDetails
     C                   MOVE      G4LVNB        LinkLevel
     C                   ADD       2             LinkLevel
     C                   MOVEL     G6ACCD        LinkACOD
     C     G6DRCR        IFEQ      '0'
     C                   MOVEL     'D'           LinkDRCR
     C                   ELSE
     C                   MOVEL     'C'           LinkDRCR
     C                   ENDIF
     C                   MOVE      'Y'           LinkRecord
     C                   MOVEL     LinkDetails   Links(LnkID)
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Determine end ID                                              *
      *****************************************************************
     C     DET_ENDID     BEGSR
 
     C                   Z-ADD     1             Lk                4 0
     C                   MOVEL     Links(Lk)     LinkDetails
     C     LinkRecord    DOWEQ     'Y'
     C                   Z-ADD     LinkLevel     C_LinkLevel      15 0
     C                   EXSR      ENDID
     C                   ADD       1             Lk
     C                   MOVEL     Links(Lk)     LinkDetails
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * End ID                                                        *
      *****************************************************************
     C     ENDID         BEGSR
 
     C     Lk            ADD       1             C_Lk             15 0
     C                   MOVEL     Links(C_Lk)   LinkDetails
     C     LinkRecord    DOWEQ     'Y'
     C     LinkLevel     ANDGT     C_LinkLevel
     C                   ADD       1             C_Lk
     C                   MOVEL     Links(C_Lk)   LinkDetails
     C                   ENDDO
     C                   SUB       1             C_Lk
 
     C                   MOVEL     Links(Lk)     LinkDetails
     C                   Z-ADD     C_Lk          LinkEndId
     C                   MOVEL     LinkDetails   Links(Lk)
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Write Hierarchy                                               *
      *****************************************************************
     C     WRT_HIER      BEGSR
 
     C                   EVAL      RHID    = *ZERO
     C                   EVAL      RHSNAME = G5RSNM
     C                   EVAL      RHNAME  = G5RSNM
     C                   EVAL      RHDELETED = '?'
     C                   WRITE     GRBSPLH
 
      * Determine hierarchy id assigned
 
     C                   READ      GRBSPLH                                99
     C     *IN99         DOWEQ     *OFF
     C     RHDELETED     IFEQ      '?'
     C                   Z-ADD     RHID          HierarchyID      15 0
     C                   EVAL      RHDELETED = ' '
     C                   UPDATE    GRBSPLH
     C                   ENDIF
     C                   READ      GRBSPLH                                99
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Write Groups                                                  *
      *****************************************************************
     C     WRT_GRUPS     BEGSR
 
     C                   Z-ADD     1             GrpID
     C     Groups(GrpID) IFNE      *BLANK
     C                   EVAL      RGID      = *ZERO
     C                   EVAL      RGHYID    = HierarchyID
     C                   EVAL      RGNAME    = Groups(GrpID)
     C                   EVAL      RGDELETED = '?'
     C                   WRITE     GRBSPLG
 
      * Determine group id assigned
 
     C                   READ      GRBSPLG                                99
     C     *IN99         DOWEQ     *OFF
     C     RGDELETED     IFEQ      '?'
     C                   Z-ADD     RGID          GroupID          15 0
     C                   EVAL      RGDELETED = ' '
     C                   UPDATE    GRBSPLG
     C                   ENDIF
     C                   READ      GRBSPLG                                99
     C                   ENDDO
     C                   ENDIF
 
     C                   ADD       1             GrpID
 
     C     Groups(GrpID) DOWNE     *BLANK
     C                   EVAL      RGID      = GroupID + GrpID - 1
     C                   EVAL      RGHYID    = HierarchyID
     C                   EVAL      RGNAME    = Groups(GrpID)
     C                   EVAL      RGDELETED = ' '
     C                   WRITE     GRBSPLG
     C                   ADD       1             GrpID
     C                   ENDDO
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Write Links                                                   *
      *****************************************************************
     C     WRT_LINKS     BEGSR
     C                   Z-ADD     1             LnkID
     C                   MOVEL     Links(LnkID)  LinkDetails
     C     LinkRecord    DOWEQ     'Y'
     C                   EVAL      RLHYID    = HierarchyID
     C                   EVAL      RLID      = LnkID
     C                   EVAL      RLENDID   = LinkEndID
     C                   EVAL      RLGRPID   = GroupID + LinkGroupID -1
     C                   EVAL      RLLEVEL   = LinkLevel
     C                   EVAL      RLACCCODE = LinkACOD
     C                   EVAL      RLCRDRI   = LinkDRCR
     C                   IF        RLACCCODE <> '0000000000'
     C                   EVAL      %nullind(RLGRPID  ) = *ON
     C                   ELSE
     C                   EVAL      %nullind(RLACCCODE) = *ON
     C                   EVAL      %nullind(RLCRDRI  ) = *ON
     C                   ENDIF
     C                   WRITE     GRBSPLL
     C                   EVAL      %nullind(RLGRPID  ) = *OFF
     C                   EVAL      %nullind(RLACCCODE) = *OFF
     C                   EVAL      %nullind(RLCRDRI  ) = *OFF
     C                   ADD       1             LnkID
     C                   MOVEL     Links(LnkID)  LinkDetails
     C                   ENDDO
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
     C     *ENTRY        PLIST
 
      * Report Set
     C                   PARM                    ReportSet         1
 
      * Access report set name
 
     C     ReportSet     CHAIN     SDRPSTL0                           99
     C     *IN99         IFEQ      *ON
     C                   DUMP
     C                   RETURN
     C                   ENDIF
 
     C                   Z-ADD     1             LnkID            15 0
     C                   Z-ADD     1             Level             2 0
 
      * First Group is for report set as a whole
 
     C                   Z-ADD     1             GrpID            15 0
     C                   EVAL      Groups(GrpID) = G5RSNM
 
      * First Link is for report set as a whole
 
     C                   MOVE      *ZEROS        LinkDetails
     C                   Z-ADD     GrpID         LinkGroupID
     C                   Z-ADD     1             LinkLevel
     C                   MOVE      'Y'           LinkRecord
     C                   MOVEL     LinkDetails   Links(LnkID)
 
      * Key lists
 
     C     SDREPCK       KLIST
     C                   KFLD                    ReportSet
     C     SDACRCK       KLIST
     C                   KFLD                    ReportSet
     C                   KFLD                    G4RSCD
     C                   ENDSR
      *****************************************************************
