     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*XBIA*  DSPFD FILE(GPZONEPD) TYPE(*ACCPTH)                           *
/*XBIA*  OUTPUT(*OUTFILE) OUTFILE(QTEMP/GPFDA)                        *
/*XBIB*  DSPFFD FILE(GPZONEPD) OUTPUT(*OUTFILE) OUTFILE(QTEMP/GPFFD)  *
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas GP Generate key data')                           *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GPGENKEYD - Generate Key Data                                *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      *  Last Amend No. AR863597           Date 09Dec11               *
      *  Prev Amend No. AR807623           Date 03Aug11               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CGP009             Date 22Dec04               *
      *                 CGP001  *CREATE    Date 23May03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR863597 - Duplicate record created when the branch was      *
      *             amended                                           *
      *  AR807623 - OPEN was issued to opened file GPKEYDPD           *
      *  CGP009 - Local Zone Time Difference (Recompile)              *
      *  CGP001 - Global Processing                                   *
      *                                                               *
      *****************************************************************
 
     FGPFDA     IP   E           K DISK    INFSR(*PSSR)
     FGPFFD     IS   E           K DISK    INFSR(*PSSR)
     FGPKEYDPD  UF A E           K DISK    INFSR(*PSSR)
 
 
      * Key fields
     D #_KEYFLDS       S             10    DIM(200)
 
 
     IQWHFDACP      01
     IQWHDRFFD      02
 
 
      * File descriptions
 
     C     Keys_ProtectedIFNE      'Y'
     C   01              EXSR      FD
     C                   ENDIF
 
      * Field descriptions
 
     C   02              EXSR      FFD
     C**********         SETON                                        LR           AR807623 AR863597
     CLR                 CLOSE     GPKEYDPD                                                 AR863597
 
      /SPACE 5
      *********************************************************************
      * File descriptions
      *********************************************************************
     C     FD            BEGSR
 
     C     APKEYF        IFNE      *BLANK
     C                   ADD       1             #K
     C                   MOVEL     APKEYF        #_KEYFLDS(#K)
     C                   ENDIF
 
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      *********************************************************************
      * Field descriptions
      *********************************************************************
     C     FFD           BEGSR
 
     C                   Z-ADD     1             #K
     C     WHFLDI        LOOKUP    #_KEYFLDS(#K)                          99
     C     *IN99         IFEQ      *ON
     C                   MOVEL     I#ZONE        FDZONE
     C                   MOVEL     I#FILE        FDFILE
     C                   MOVE      WHFLDI        FDFNAM
     C                   MOVE      WHFLDT        FDFTYP
     C                   Z-ADD     WHIBO         FDSPOS
     C                   Z-ADD     WHFLDB        FDSIZE
     C                   WRITE     GPKEYDD0
     C                   ENDIF
 
     C                   ENDSR
      *********************************************************************
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
 
     C                   Z-ADD     1             #K                3 0
     C                   MOVE      'N'           Keys_Protected    1
 
      * Delete all 'unprotected' records for this zone and file
 
     C     GPKEYDK       SETLL     GPKEYDD0
     C     GPKEYDK       READE     GPKEYDD0                               99
     C     *IN99         DOWEQ     *OFF
     C     FDPROT        IFNE      'Y'
     C                   DELETE    GPKEYDD0
     C                   ELSE
     C                   MOVE      'Y'           Keys_Protected
     C                   ENDIF
     C     GPKEYDK       READE     GPKEYDD0                               99
     C                   ENDDO
 
      * Key lists
 
     C     GPKEYDK       KLIST
     C                   KFLD                    I#ZONE
     C                   KFLD                    I#FILE
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      *****************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY GPCPYSRCG,GPPSSR
      *****************************************************************
