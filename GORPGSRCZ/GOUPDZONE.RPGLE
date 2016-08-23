     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GO Update Zone')
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GOUPDZONE - Update Zone                                      *
      *                                                               *
      *  Function:  This module updates certain fields in a zone      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CGP009             Date 22Dec04               *
      *  Prev Amend No. CGP001  *CREATE    Date 23May03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CGP009 - Local Zone Time Difference (Recompile)              *
      *  CGP001 - Global Processing                                   *
      *                                                               *
      *****************************************************************
 
     FGPZONEL0  UF   E           K DISK    INFSR(*PSSR)
 
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
 
     C     *ENTRY        PLIST
 
     C                   PARM                    I#RTCD            7            * RETURN CODE
     C                   PARM                    I#ERMS           50            * ERROR MESSAGE
      * INPUTS
     C                   PARM                    I#ZONE           10
     C                   PARM                    I#SHTC            4
     C                   PARM                    I#RDNB            5 0
     C                   PARM                    I#DNWD            5 0
     C                   PARM                    I#BCCY            3
     C                   PARM                    I#NJOB            1 0
 
      * Get zone details
 
     C     I#ZONE        CHAIN     GPZONED0                           99
      * error
     C     *IN99         IFEQ      *ON
     C                   EVAL      I#ERMS = 'ZONE ' + I#ZONE + ' NOT IN '
     C                                    + 'GLOBAL LAYER'
     C                   EXSR      *PSSR
     C                   ENDIF
 
      * update fields
 
     C                   MOVEL     I#ZONE        ZOZONE
     C                   MOVEL     I#SHTC        ZOSHTC
     C                   MOVEL     I#RDNB        ZORDNB
     C                   MOVEL     I#DNWD        ZODNWD
     C                   MOVEL     I#BCCY        ZOBCCY
     C                   MOVEL     I#NJOB        ZONJOB
 
     C                   UPDATE    GPZONED0
 
     C                   SETON                                        LR
     C                   RETURN
 
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
