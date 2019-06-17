     H DEBUG
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL Drop Historic GCMS msgs')                     *
      *****************************************************************
      *                                                               *
      *  Midas - GL module                                            *
      *                                                               *
      ***GLJ029M*-*Drop*Historic*GCMS*Messages*************************                   JMI113
      *  XX113029 - Drop Historic GCMS Messages                       *                   JMI113
      *                                                               *
      *  Function:  This program output all non-historic GCMS         *
      *             and messages                                      *
      *                                                               *
      ***Called*By:*GLCJ029*-*(Drop*Historic*GCMS*Messages)************                   JMI113
      *  Called By: XXC113029 - Drop Historic GCMS Messages           *                   JMI113
      *                                                               *
      ***(c)*Misys*International*Banking*Systems*Ltd.*2003*************                   JMI113
      *  (c) Finastra International Limited 2018                      *                   JMI113
      *                                                               *
      *  Last Amend No. JMI113             Date 22May18               *
      *  Prev Amend No. JMI019             Date 23Feb07               *
      *                 JMI020             Date 11Feb04               *
      *                 JMI019  *CREATE    Date 23Jul03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  JMI113 - Midas GCMS Interface. Upgrade to FBM 2.1            *
      *  JMI019 - Upgrade as is remove JMI020                         *
      *  JMI020 - Midas GCMS Interface for manual CSV file upload     *
      *           (network SPEM).                                     *
      *  JMI019 - Midas GCMS Interface                                *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *****50*********EOF*of*MGGCMXPD**********************************                   JMI113
      *****51*********EOF*of*MGGCMMPD**********************************                   JMI113
      *****54*********EOF*of*MGG101PD**********************************                   JMI113
      *    50         EOF of XXGCMXPD                                 *                   JMI113
      *    51         EOF of XXGCMMPD                                 *                   JMI113
      *    54         EOF of XXG101PD                                 *                   JMI113
      *    90         General error indicator                         *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  *PSSR  - Error processing                                    *
      *  *INZSR - Initialise                                          *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      ** GCMS message Index
     F**********MGGCMXPD  IF   E           K DISK    INFSR(*PSSR)                         JMI113
     FXXGCMXPD  IF   E           K DISK    INFSR(*PSSR)                                   JMI113
      ** GCMS Data
     F**********MGGCMMPD  IF   E           K DISK    INFSR(*PSSR)                         JMI113
     FXXGCMMPD  IF   E           K DISK    INFSR(*PSSR)                                   JMI113
      ** GCMS MT101 Processed File
     F**********MGG101PD  IF   E           K DISK    INFSR(*PSSR)                         JMI113
     FXXG101PD  IF   E           K DISK    INFSR(*PSSR)                                   JMI113
      ** Backup GCMS message Index
     F**********MGGCMXBK  O    E             DISK    INFSR(*PSSR)                         JMI113
     F**********                                     RENAME(MGGCMXD0:MGGCXBK1)            JMI113
     FXXGCMXBK  O    E             DISK    INFSR(*PSSR)                                   JMI113
     F                                     RENAME(XXGCMXD0:XXGCXBK1)                      JMI113
      ** Backup GCMS message Data
     F**********MGGCMMBK  O    E             DISK    INFSR(*PSSR)                         JMI113
     F**********                                     RENAME(MGGCMMD0:MGGCMBK1)            JMI113
     FXXGCMMBK  O    E             DISK    INFSR(*PSSR)                                   JMI113
     F                                     RENAME(XXGCMMD0:XXGCMBK1)                      JMI113
      ** Backup GCMS MT101 Processed File
     F**********MGG101BK  O    E             DISK    INFSR(*PSSR)                         JMI113
     F**********                                     RENAME(MGG101D0:MGG101K1)            JMI113
     FXXG101BK  O    E             DISK    INFSR(*PSSR)                                   JMI113
     F                                     RENAME(XXG101D0:XXG101K1)                      JMI113
      /EJECT
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      *
      ** Array containing Copyright statement
      *
      /SPACE 3
      *
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
     D LDA           E DS           256    EXTNAME(LDA)
      *
      ** Data Area giving Installation Control Details
      *
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
      *
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
      ** Bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      ** GCMS Interface ICD
     D**********SDGCMS        E DS                  EXTNAME(SDGCMSPD)                     JMI113
     D SDGCMS        E DS                  EXTNAME(XXGCMSPD)                              JMI113
      *
      ** Working
     DWTPP             S                   LIKE(BJRDNB)
     DWMODT            S                   LIKE(BJRDNB)
      *
      ** Parameters for ZDATE10
     DZZDTIN           S              8S 0
     DZZMDNO           S                   LIKE(BJRDNB)
      /EJECT
      /SPACE 3
      *
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
      *****************************************************************
      * MAIN PROCEDURE
      *
     C                   EXSR      SRTPP
     C                   EXSR      SR101
     C                   SETON                                        LR
      *
      *****************************************************************
      *
     C     SRTPP         BEGSR
      *
     C**********         READ      MGGCMXPD                               50              JMI113
     C                   READ      XXGCMXPD                               50              JMI113
     C     *IN50         DOWEQ     '0'
      *
      ** Convert message date to Midas Day number
     C                   CALLB     'ZDATE10'                            90
     C                   PARM      J0MODE        ZZDTIN
     C     WMODT         PARM                    ZZMDNO
      *
     C     *IN90         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   SETON                                          U7U8
     C                   Z-ADD     003           DBASE
     C                   MOVEL(P)  'ZDATE10'     DBFILE
     C                   MOVEL(P)  J0MODE        DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Output non-historic GCMS messages
      ** Non-historic messages are those with receipt date >= retention
      ** date
     C     WMODT         IFGE      WTPP
     C**********         WRITE     MGGCXBK1                                               JMI113
     C                   WRITE     XXGCXBK1                                               JMI113
      *
     C*****J0MIRF        SETLL     MGGCMMPD                               51              JMI113
     C     J0MIRF        SETLL     XXGCMMPD                               51              JMI113
     C     *IN51         IFEQ      '1'
     C*****J0MIRF        READE     MGGCMMPD                               51              JMI113
     C     J0MIRF        READE     XXGCMMPD                               51              JMI113
     C     *IN51         DOWEQ     '0'
     C**********         WRITE     MGGCMBK1                                               JMI113
     C*****J0MIRF        READE     MGGCMMPD                               51              JMI113
     C                   WRITE     XXGCMBK1                                               JMI113
     C     J0MIRF        READE     XxGCMMPD                               51              JMI113
     C                   ENDDO
      ** Detail record not found
     C                   ELSE
     C     *LOCK         IN        LDA
     C                   SETON                                          U7U8
     C                   Z-ADD     004           DBASE
     C**********         MOVEL(P)  'MGGCMMPD'    DBFILE                                   JMI113
     C                   MOVEL(P)  'XXGCMMPD'    DBFILE                                   JMI113
     C                   MOVEL(P)  J0MIRF        DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDIF
      *
     C**********         READ      MGGCMXPD                               50              JMI113
     C                   READ      XXGCMXPD                               50              JMI113
     C                   ENDDO
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *
     C     SR101         BEGSR
      *
     C***********        READ      MGG101PD                               54              JMI113
     C                   READ      XXG101PD                               54              JMI113
     C     *IN54         DOWEQ     '0'
      *
      ** Output non-historic GCMS messages
      ** Non-historic messages are those with receipt date >= retention
      ** date
     C     J0PRDT        IFGE      WTPP
     C**********         WRITE     MGG101K1                                               JMI113
     C                   WRITE     XXG101K1                                               JMI113
      **********
      ***Detail*record not found
     C**********         ELSE
     C******LOCK         IN        LDA
     C**********         SETON                                          U7U8
     C**********         Z-ADD     005           DBASE
     C**********         MOVEL(P)  'MGG101PD'    DBFILE
     C**********         MOVEL(P)  J0REF#        DBKEY
     C**********         OUT       LDA
     C**********         EXSR      *PSSR
     C                   ENDIF
      *
     C**********         READ      MGG101PD                               54              JMI113
     C                   READ      XXG101PD                               54              JMI113
     C                   ENDDO
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: (**calling routines**)                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      ************ CALL DBERRCTL IF INTERACTIVE PROGRAM ***************
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C     @RUN          IFEQ      *BLANK
     C                   MOVE      'Y'           @RUN              1
     C                   DUMP
     C                   END
      *
      ************ END PROGRAM IF DBERRCTL NOT CALLED ********************
     C                   SETON                                        U7U8LR
     C                   RETURN
      ********************************************************************
      *
     C                   ENDSR
      *****************************************************************
      * *INZSR - INITIAL PROCESSING                                   *
      *****************************************************************
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
     C                   PARM                    P#PARM1          10
      *
      ** Set up copyright parameter
      *
     C                   MOVEA     CPY@          CPY2@            80
      *
      ** Read in Installation Data
      *
     C     *DTAARA       DEFINE                  RUNDAT
     C     *DTAARA       DEFINE                  LDA
     C                   IN        RUNDAT
      *
      ** Set Date Format Indicator *IN98  on if date format is MMDDYY
      *
     C     AGDFF         IFEQ      'M'
     C                   SETON                                        98
     C                   ENDIF
      *
      ** Retrieve Bank Details
     C                   CALLB     'AOBANKR0'                           90
     C                   PARM                    P@RTCD            7            B:Return code
     C                   PARM      '*FIRST'      P@OPTN            7            I:Option
     C     SDBANK        PARM      SDBANK        DSFDY                          O:Format
      *
     C     P@RTCD        IFNE      *BLANK
     C     *IN90         OREQ      '1'
     C     *LOCK         IN        LDA
     C                   SETON                                          U7U8
     C                   Z-ADD     005           DBASE
     C                   MOVEL(P)  'AOBANKR0'    DBFILE
     C                   MOVEL(P)  '*FIRST'      DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Retrieve Electronic Banking ICD record
     C**********         CALL      'AOGCMSR0'                           90                JMI113
     C                   CALL      'XXGCMSR0'                           90                JMI113
     C                   PARM                    P@RTCD            7            B:Return code
     C                   PARM      '*FIRST'      P@OPTN            7            I:Option
     C     SDGCMS        PARM      SDGCMS        DSSDY                          O:Format
      *
     C     P@RTCD        IFNE      *BLANK
     C     *IN90         OREQ      '1'
     C     *LOCK         IN        LDA
     C                   SETON                                          U7U8
     C                   Z-ADD     006           DBASE
     C**********         MOVEL(P)  'AOGCMSR0'    DBFILE                                   JMI113
     C                   MOVEL(P)  'XXGCMSR0'    DBFILE                                   JMI113
     C                   MOVEL(P)  '*FIRST'      DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Set retention base date
     C     BJRDNB        SUB       J0PYMR        WTPP
     C                   ENDSR
      *****************************************************************
      * SAMPLE ERROR                                                  *
      * Its a sample to show how handle errors. Don't call it         *
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2018
