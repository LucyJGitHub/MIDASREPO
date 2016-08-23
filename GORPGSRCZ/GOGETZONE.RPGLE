     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GO Get Zone')
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GOGETZONE - Get Zone                                         *
      *                                                               *
      *  Function:  This module returns details of the zone the       *
      *             program is running in.                            *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSD027             Date 09Dec05               *
      *  Prev Amend No. CGP009             Date 22Dec04               *
      *                 CGP001  *CREATE    Date 23May03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGP009 - Local Zone Time Difference (Recompile)              *
      *  CGP001 - Global Processing                                   *
      *                                                               *
      *****************************************************************
 
     FSDBRCHL0  IF   E           K DISK    INFSR(*PSSR)
     FGZSDBRCHL0IF   E           K DISK    INFSR(*PSSR)
     FGPZONEL0  IF   E           K DISK    INFSR(*PSSR)
 
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
 
     C     *ENTRY        PLIST
 
     C                   PARM                    I#RTCD            7            * RETURN CODE
     C                   PARM                    I#ERMS           50            * ERROR MESSAGE
      * INPUTS
     C                   PARM                    I#FULLCHECK       1
      * OUTPUTS
     C                   PARM                    O#ZONE           10
     C                   PARM                    O#SHTC            4
     C                   PARM                    O#RDNB            5 0
     C                   PARM                    O#DNWD            5 0
     C                   PARM                    O#BCCY            3
     C                   PARM                    O#NJOB            1 0
 
      * Access the first branch in the zone
 
     C     *LOVAL        SETLL     @A8REB1
     C                   READ      @A8REB1                                60
 
      * error
     C     *IN99         IFEQ      *ON
     C                   EVAL      I#ERMS = 'NO BRANCHES IN '
     C                                    + 'THIS SYSTEM'
     C                   EXSR      *PSSR
     C                   ENDIF
 
      * Access zone for first branch
 
     C                   EXSR      ACCESS_ZONE
 
     C                   MOVEL     ZOZONE        O#ZONE
     C                   MOVEL     ZOSHTC        O#SHTC
     C                   MOVEL     ZORDNB        O#RDNB
     C                   MOVEL     ZODNWD        O#DNWD
     C                   MOVEL     ZOBCCY        O#BCCY
     C                   MOVEL     ZONJOB        O#NJOB
 
      * If a full check (of all branches) is being done
      *    Read the remaining branches
      *    Access zone for each branch
 
     C     I#FULLCHECK   IFEQ      'Y'
     C     *IN60         DOWEQ     *OFF
     C                   READ      @A8REB1                                60
     C     *IN60         IFEQ      *OFF
     C                   EXSR      ACCESS_ZONE
     C     ZOZONE        IFNE      O#ZONE
     C                   EVAL      I#ERMS = 'MORE THAN ONE ZONE IN '
     C                                    + 'THIS SYSTEM'
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
     C                   ENDDO
     C                   ENDIF
 
     C                   SETON                                        LR
     C                   RETURN
     C/SPACE 5
      **********************************************************************
      * ACCESS ZONE
      **********************************************************************
     C     ACCESS_ZONE   BEGSR
 
      * Recover the zone attached to the branch
 
     C     A8BRCD        CHAIN     SDBRCHD0                           99
      * error
     C     *IN99         IFEQ      *ON
     C                   EVAL      I#ERMS = 'BRANCH ' + A8BRCD + ' NOT IN '
     C                                    + 'GLOBAL LAYER'
     C                   EXSR      *PSSR
     C                   ENDIF
 
      * Get zone details
 
     C     A8ZONE        CHAIN     GPZONED0                           99
      * error
     C     *IN99         IFEQ      *ON
     C                   EVAL      I#ERMS = 'ZONE ' + A8ZONE + ' NOT IN '
     C                                    + 'GLOBAL LAYER'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      **********************************************************************
     C/SPACE 5
      *********************************************************************
      * *INZSR - Initial subroutine called automatically at program start
      *********************************************************************
     C     *INZSR        BEGSR
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY GOCPYSRC,GOPSSR
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2003
