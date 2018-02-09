     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  ALWNULL(*YES)                                                *
/*EXI *  TEXT('Midas GO BSPL Branches Extract')
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GOBSPLBEX - BSPL Branches Extract                            *
      *                                                               *
      *  (c) Finastra International Limited 2005                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD027             Date 09Dec05               *
      *                 CGP010  *CREATE    Date 17Jan05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGP010 - Global BSPL                                         *
      *                                                               *
      *****************************************************************
 
     FGZSDBRCHL0IF   E           K DISK    INFSR(*PSSR)
     FGZSDBRCHL1IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SDBRCHD0:SDBRCHD1)
     FI_GRBRCHG1IF   E           K DISK    INFSR(*PSSR)
     FI_GRBRCHL0IF   E           K DISK    INFSR(*PSSR)
     FI_GRBRCHL2IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(T_GRBRCHL:T_GRBRCHL2)
 
     FGPBSPLBPD O    E           K DISK    INFSR(*PSSR)
 
 
     C     I#ZNGL        IFEQ      'Z'
 
      * Zone Reporting
 
     C     I#BRC         IFNE      *BLANKS
     C                   EXSR      SINGLE_BRANCH
     C                   ELSE
     C     I#BRGRP       IFNE      *BLANKS
     C                   EXSR      COMPANY
     C                   ELSE
     C                   EXSR      ALLZ_BRANCHES
     C                   ENDIF
     C                   ENDIF
 
     C                   ELSE
 
      * Global Reporting
 
     C     I#BRC         IFNE      *BLANKS
     C                   EXSR      SINGLE_BRANCH
     C                   ELSE
     C     I#BRGRP       IFNE      *BLANKS
     C                   EXSR      BRANCH_GROUP
     C                   ELSE
     C                   EXSR      ALLG_BRANCHES
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
 
     C                   SETON                                        LR
     C                   RETURN
 
      /SPACE 5
      ********************************************************************
      * Extract a Single Branch
      ********************************************************************
     C     SINGLE_BRANCH BEGSR
     C     I#BRC         CHAIN     SDBRCHD0                           99
     C  N99              WRITE     GPBSPLBD0
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * Extract all Zone Branches
      ********************************************************************
     C     ALLZ_BRANCHES BEGSR
     C     I#ZONE        SETLL     SDBRCHD1
     C     I#ZONE        READE     SDBRCHD1                               99
     C     *IN99         DOWEQ     *OFF
     C                   WRITE     GPBSPLBD0
     C     I#ZONE        READE     SDBRCHD1                               99
     C                   ENDDO
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * Extract all Global Branches
      ********************************************************************
     C     ALLG_BRANCHES BEGSR
     C     *LOVAL        SETLL     SDBRCHD1
     C                   READ      SDBRCHD1                               99
     C     *IN99         DOWEQ     *OFF
     C                   WRITE     GPBSPLBD0
     C                   READ      SDBRCHD1                               99
     C                   ENDDO
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * Extract a Company
      ********************************************************************
     C     COMPANY       BEGSR
 
     C                   MOVEL     I#BRGRP       CompanyCode       3
 
     C     I#ZONE        SETLL     SDBRCHD1
     C     I#ZONE        READE     SDBRCHD1                               99
     C     *IN99         DOWEQ     *OFF
     C     A8CMCD        IFEQ      CompanyCode
     C                   WRITE     GPBSPLBD0
     C                   ENDIF
     C     I#ZONE        READE     SDBRCHD1                               99
     C                   ENDDO
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * Extract a Branch Group
      ********************************************************************
     C     BRANCH_GROUP  BEGSR
 
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVEL     I#BRGRP       ZFIELD
     C                   Z-ADD     0             ZADEC
     C                   Z-ADD     15            ZADIG
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        BGID
 
      * Access branch group for hierarchy id in which group is present
 
     C     BGID          CHAIN     I_GRBRCHG1                         99
     C     *IN99         CABEQ     *ON           E_BRANCH_GROUP
 
      * Access group within hierarchy
 
     C                   Z-ADD     *ZERO         BLGRPID
     C     I_GRBRCHL0K   SETLL     I_GRBRCHL0
     C     I_GRBRCHL0K   READE     I_GRBRCHL0                             99
     C     *IN99         DOWEQ     *OFF
     C     BLGRPID       ANDNE     BGID
     C     I_GRBRCHL0K   READE     I_GRBRCHL0                             99
     C                   ENDDO
 
     C     BLGRPID       CABNE     BGID          E_BRANCH_GROUP
 
      * Access lines within start ID and end ID
 
     C                   Z-ADD     BLID          StartID          20 0
     C                   Z-ADD     BLENDID       EndID            20 0
 
     C     I_GRBRCHL2K   SETLL     I_GRBRCHL2
     C     I_GRBRCHL2KP  READE     I_GRBRCHL2                             99
     C     *IN99         DOWEQ     *OFF
     C     BLID          ANDLE     EndID
     C     BLBRCHCODE    IFNE      *BLANK
     C     BLBRCHCODE    CHAIN     SDBRCHD0                           99
     C  N99              WRITE     GPBSPLBD0
     C                   ENDIF
     C     I_GRBRCHL2KP  READE     I_GRBRCHL2                             99
     C                   ENDDO
 
     C     E_BRANCH_GROUPENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * Convert Digits to a Number
      ********************************************************************
     C     ZALIGN        BEGSR
     C                   CALLB     'ZALIGN'
     C                   PARM                    ZALIGNok          1
     C                   PARM                    ZFIELD           16
     C                   PARM                    ZADEC             1 0
     C                   PARM                    ZADIG             2 0
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      **********************************************************************************
      * *INZSR - Initial Processing
      **********************************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           50
 
      * Zone or Global
      * Zone
      * Branch
      * Branch Group
 
     C                   PARM                    I#ZNGL            1
     C                   PARM                    I#ZONE           10
     C                   PARM                    I#BRC             3
     C                   PARM                    I#BRGRP          15
 
     C     I_GRBRCHL0K   KLIST
     C                   KFLD                    BGHYID
     C     I_GRBRCHL2K   KLIST
     C                   KFLD                    BLHYID
     C                   KFLD                    StartID
     C     I_GRBRCHL2KP  KLIST
     C                   KFLD                    BLHYID
 
     C                   ENDSR
     C**********************************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY GOCPYSRC,GOPSSR
      *****************************************************************
