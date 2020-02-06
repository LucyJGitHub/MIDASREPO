     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GO BSPL Hierarchies Extract - Zone')
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GOBSPLHXZ - BSPL Hierarchies Extract - Zone                  *
      *                                                               *
      *  (c) Finastra International Limited 2005                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CGP010  *CREATE    Date 17Jan05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CGP010 - Global BSPL                                         *
      *                                                               *
      *****************************************************************
 
     FGPBSPLCPD IF   E           K DISK    INFSR(*PSSR)
 
     FSDACODL0  IF   E           K DISK    INFSR(*PSSR)
 
     FSDRPSTL0  IF   E           K DISK    INFSR(*PSSR)
     FSDREPCL1  IF   E           K DISK    INFSR(*PSSR)
     FSDACRCL1  IF   E           K DISK    INFSR(*PSSR)
     FSDACODL1  IF   E           K DISK    INFSR(*PSSR)
 
     FGPBSPLHPD O    E             DISK    INFSR(*PSSR)
 
 
     D BRCY            S              6A   DIM(9999)
 
 
     D GPBSPLH       E DS                  EXTNAME(GPBSPLHPD)
     D BSPLHIER                1   1200    DIM(20)
 
 
      * Load all branches/currencies involved in the reporting
 
     C                   EXSR      LOAD_BRCY
 
     C                   MOVEL     *BLANK        BSPLHIER
 
      * Extract chart of accounts
 
     C     I#CHART       IFEQ      'Y'
 
     C                   EVAL      O#RSNAME = 'CHART OF ACCOUNTS'
 
     C     *BLANK        SETLL     SDACODL0
     C                   READ      SDACODL0                               99
     C     *IN99         DOWEQ     *OFF
     C                   EXSR      EXT_CHARTOFACS
     C                   READ      SDACODL0                               99
     C                   ENDDO
     C                   ELSE
 
      * Get Report Set Name
 
     C                   MOVEL     I#RPSET       G4RSNO
     C     G4RSNO        CHAIN     SDRPSTL0                           99        *
     C                   MOVEL     G5RSNM        O#RSNAME
 
      * Extract report set hierarchy
 
     C     SDREPCK       SETLL     SDREPCL1
     C     SDREPCK       READE     SDREPCL1                               99
     C     *IN99         DOWEQ     *OFF
     C                   EXSR      EXT_REPORTSET
     C     SDREPCK       READE     SDREPCL1                               99
     C                   ENDDO
     C                   ENDIF
 
      * Maximum Level
 
     C                   MOVEL     MaxLevel      O#MAXLVL
 
     C                   SETON                                        LR
     C                   RETURN
 
      /SPACE 5
      ********************************************************************
      * Extract chart of accounts
      ********************************************************************
     C     EXT_CHARTOFACSBEGSR
 
      * Default first level
 
     C     BSPLHIER(1)   IFEQ      *BLANK
     C                   EVAL      BSPLHIER(1) = '0000000000' + 'UNALLOCATED'
     C                   Z-ADD     1             Level
     C                   ENDIF
 
      * Update hierarchy
 
     C     A5TOIN        IFEQ      'Y'
 
     C     A5ACSC        IFNE      PrevACSC
     C                   EVAL      BSPLHIER(1) = A5ACCD + A5ACCN
     C                   EVAL      BSPLHIER(2) = *BLANK
     C                   Z-ADD     1             Level
     C                   ELSE
     C                   EVAL      BSPLHIER(2) = A5ACCD + A5ACCN
     C                   Z-ADD     2             Level
     C                   ENDIF
 
     C                   MOVEL     A5ACSC        PrevACSC          2
 
     C                   ELSE
 
     C                   EVAL      GRACOD = A5ACCD
     C                   EVAL      GRDRCR = '0'
     C                   EVAL      GRDESC = A5ACCN
     C                   EXSR      OUTPUT
     C                   EVAL      GRDRCR = '1'
     C                   EXSR      OUTPUT
 
     C                   ENDIF
 
      * Update maximum level
 
     C     Level         IFGT      MaxLevel
     C                   Z-ADD     Level         MaxLevel          2 0
     C                   ENDIF
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * Extract report set hierarchy
      ********************************************************************
     C     EXT_REPORTSET BEGSR
 
     C                   MOVEL     G4LVNB        Level             1 0
     C                   EVAL      BSPLHIER(Level) = G4RSCD + G4RPNA
 
      * Update maximum level
 
     C     Level         IFGT      MaxLevel
     C                   Z-ADD     Level         MaxLevel          2 0
     C                   ENDIF
 
      * Update hierarchy
 
     C                   Z-ADD     9             L                 1 0
     C     L             DOUEQ     1
     C     Level         IFLT      L
     C                   MOVEL     *BLANK        BSPLHIER(L)
     C                   ENDIF
     C                   SUB       1             L
     C                   ENDDO
 
     C     SDACRCK       SETLL     SDACRCL1                           99
     C     SDACRCK       READE     SDACRCL1                               99    *
     C     *IN99         DOWEQ     *OFF
     C                   MOVEL     G6ACCD        GRACOD
     C                   MOVEL     G6DRCR        GRDRCR
     C     G6ACCD        CHAIN     @A5REA6                            99
     C   99              EVAL      GRDESC = *BLANK
     C  N99              EVAL      GRDESC = A5ACCN
     C                   EXSR      OUTPUT
     C     SDACRCK       READE     SDACRCL1                               99    *
     C                   ENDDO
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      **********************************************************************************
      * Output to file GPBSPLHPD
      **********************************************************************************
     C     OUTPUT        BEGSR
     C                   Z-ADD     1             Ix
     C     BRCY(Ix)      DOWNE     *BLANK
     C                   MOVEL     BRCY(Ix)      A8BRCD
     C                   MOVE      BRCY(Ix)      A6CYCD
     C                   WRITE     GPBSPLHD0
     C                   ADD       1             Ix
     C                   ENDDO
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      **********************************************************************************
      * Load all branches/currencies involved in the reporting
      **********************************************************************************
     C     LOAD_BRCY     BEGSR
 
     C                   MOVEL     *BLANK        BRCY
 
     C                   Z-ADD     1             Ix                3 0
     C     *LOVAL        SETLL     GPBSPLCD0
     C                   READ      GPBSPLCD0                              99
     C     *IN99         DOWEQ     *OFF
     C                   MOVEL     A8BRCD        BRCY(Ix)
     C                   MOVE      A6CYCD        BRCY(Ix)
     C                   ADD       1             Ix
     C                   READ      GPBSPLCD0                              99
     C                   ENDDO
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      **********************************************************************************
      * *INZSR - Initial Processing
      **********************************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           50
 
      * Report Set
      * Chart of Accounts
 
     C                   PARM                    I#RPSET           1
     C                   PARM                    I#CHART           1
 
      * Report Set Name
      * Maximum Level
 
     C                   PARM                    O#RSNAME         50
     C                   PARM                    O#MAXLVL          2
 
     C     SDREPCK       KLIST
     C                   KFLD                    G4RSNO
 
     C     SDACRCK       KLIST
     C                   KFLD                    G4RSNO
     C                   KFLD                    G4RSCD
 
     C                   ENDSR
      **********************************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY GOCPYSRC,GOPSSR
      *****************************************************************
