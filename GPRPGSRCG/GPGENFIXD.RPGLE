     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*XBIA*  DSPFFD FILE(LDA) OUTPUT(*OUTFILE) OUTFILE(QTEMP/GPFFD)       *
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas GP Generate fix data')
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GPGENFIXD - Generate Fix Data                                *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CGP001  *CREATE    Date 23May03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CGP001 - Global Processing                                   *
      *                                                               *
      *****************************************************************
 
     FGPFFD     IP   E           K DISK    INFSR(*PSSR)
     FGPFIXDPD  UF A E           K DISK    INFSR(*PSSR)
 
 
     D GPREPNLOG       DS             2
     D FixDiagnost             1      1
     D UpdDiagnost             2      2
 
 
     C                   MOVEL     I#ZONE        FDZONE
     C                   MOVEL     I#FILE        FDFILE
     C                   MOVE      WHFLDI        FDFNAM
     C                   MOVE      WHFLDT        FDFTYP
     C                   Z-ADD     WHIBO         FDSPOS
     C     WHIBO         ADD       WHFLDB        FDEPOS
     C                   SUB       1             FDEPOS
 
     C     WHFLDT        IFEQ      'P'
     C     WHFLDT        OREQ      'Z'
     C                   WRITE     GPFIXDD0
     C                   ENDIF
 
      /SPACE 5
      *********************************************************************
      * *INZSR - Initial subroutine called automatically at program start
      *********************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    I#ZONE           10
     C                   PARM                    I#FILE           10
 
     C                   MOVE      *BLANK        I#RTCD            7
     C                   MOVE      *BLANK        I#ERMS           50
 
      * Get replication diagnostics status
 
     C     *DTAARA       DEFINE                  GPREPNLOG
     C     *LOCK         IN        GPREPNLOG
     C                   OUT       GPREPNLOG
 
      * Delete all records for this zone and file
 
     C     GPFIXDK       SETLL     GPFIXDD0
     C     GPFIXDK       READE     GPFIXDD0                               99
     C     *IN99         DOWEQ     *OFF
     C                   DELETE    GPFIXDD0
     C     GPFIXDK       READE     GPFIXDD0                               99
     C                   ENDDO
 
      * End if no diagnostics
 
     C     FixDiagnost   IFNE      'Y'
     C                   SETON                                        LR
     C                   RETURN
     C                   ENDIF
 
      * Key lists
 
     C     GPFIXDK       KLIST
     C                   KFLD                    I#ZONE
     C                   KFLD                    I#FILE
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      *****************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY GPCPYSRCG,GPPSSR
      *****************************************************************
