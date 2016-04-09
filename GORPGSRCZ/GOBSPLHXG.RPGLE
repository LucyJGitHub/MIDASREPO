     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  ALWNULL(*YES)                                                *
/*EXI *  TEXT('Midas GO BSPL Hierarchies Extract - Global')
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GOBSPLHXG - BSPL Hierarchies Extract - Global                *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2005            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CGP010  *CREATE    Date 17Jan05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CGP010 - Global BSPL                                         *
      *                                                               *
      *****************************************************************
 
     FGPBSPLCPD IF   E           K DISK    INFSR(*PSSR)
 
     FGPACODL0  IF   E           K DISK    INFSR(*PSSR)
 
     FI_GRBSPLH1IF   E           K DISK    INFSR(*PSSR)
     FI_GRBSPLL0IF   E           K DISK    INFSR(*PSSR)
     FI_GRBSPLG0IF   E           K DISK    INFSR(*PSSR)
 
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
 
     C     *BLANK        SETLL     GPACODL0
     C                   READ      GPACODL0                               99
     C     *IN99         DOWEQ     *OFF
     C                   EXSR      EXT_CHARTOFACS
     C                   READ      GPACODL0                               99
     C                   ENDDO
     C                   ELSE
 
      * Get Report Set Name
 
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVEL     I#RPSET       ZFIELD
     C                   Z-ADD     0             ZADEC
     C                   Z-ADD     15            ZADIG
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        RHID
     C     RHID          CHAIN     I_GRBSPLH1                         99        *
     C                   MOVEL     RHSNAME       O#RSNAME
 
      * Extract report set hierarchy
 
     C     GRBSPLLK      SETLL     I_GRBSPLL0
     C     GRBSPLLK      READE     I_GRBSPLL0                             99
     C     *IN99         DOWEQ     *OFF
     C                   EXSR      EXT_REPORTSET
     C     GRBSPLLK      READE     I_GRBSPLL0                             99
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
 
     C     ACTOIN        IFEQ      'Y'
 
     C     ACACSC        IFNE      PrevACSC
     C                   EVAL      BSPLHIER(1) = ACGACD + ACDESC
     C                   EVAL      BSPLHIER(2) = *BLANK
     C                   Z-ADD     1             Level
     C                   ELSE
     C                   EVAL      BSPLHIER(2) = ACGACD + ACDESC
     C                   Z-ADD     2             Level
     C                   ENDIF
 
     C                   MOVEL     ACACSC        PrevACSC          2
 
     C                   ELSE
 
     C                   EVAL      GRACOD = ACGACD
     C                   EVAL      GRDRCR = '0'
     C                   EVAL      GRDESC = ACDESC
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
 
      * Access level description
 
     C     RLGRPID       IFNE      0
     C     GRBSPLGK      CHAIN     I_GRBSPLG0                         99        *
     C                   Z-ADD     RLLEVEL       Level             2 0
     C                   MOVE      RLGRPID       GroupNo          10
     C                   EVAL      BSPLHIER(Level) = GroupNo + RGNAME
     C                   ENDIF
 
      * Update maximum level
 
     C     Level         IFGT      MaxLevel
     C                   Z-ADD     Level         MaxLevel          2 0
     C                   ENDIF
 
      * Update hierarchy
 
     C                   Z-ADD     20            L                 2 0
     C     L             DOUEQ     1
     C     Level         IFLT      L
     C                   MOVEL     *BLANK        BSPLHIER(L)
     C                   ENDIF
     C                   SUB       1             L
     C                   ENDDO
 
     C     RLACCCODE     IFNE      *BLANK
     C                   MOVEL     RLACCCODE     GRACOD
     C     RLCRDRI       IFEQ      'D'
     C                   MOVEL     '0'           GRDRCR
     C                   ELSE
     C                   MOVEL     '1'           GRDRCR
     C                   ENDIF
     C     RLACCCODE     CHAIN     GPACODL0                           99
     C   99              EVAL      GRDESC = *BLANK
     C  N99              EVAL      GRDESC = ACDESC
     C                   EXSR      OUTPUT
     C                   ENDIF
 
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
 
      * Report Set
      * Chart of Accounts
 
     C                   PARM                    I#RPSET          15
     C                   PARM                    I#CHART           1
 
      * Report Set Name
      * Maximum Level
 
     C                   PARM                    O#RSNAME         50
     C                   PARM                    O#MAXLVL          2
 
     C     GRBSPLLK      KLIST
     C                   KFLD                    RHID
 
     C     GRBSPLGK      KLIST
     C                   KFLD                    RHID
     C                   KFLD                    RLGRPID
 
     C                   ENDSR
      **********************************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY GOCPYSRC,GOPSSR
      *****************************************************************
