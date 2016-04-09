     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas DL Initialisation Program for CAS005')
      *****************************************************************
      *                                                               *
      *  Midas - Dealing Module                                       *
      *                                                               *
      *  DL000016 - Initialisation Program for CAS005                 *
      *                                                               *
      *  Function:  This module will initialise the new file          *
      *             DLPOSTPD.                                         *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSD027             Date 09Dec05               *
      *  Prev Amend No. CGL029             Date 01Sep03               *
      *                 CAS005  *CREATE    Date 16Dec02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CAS005 - Enhancements to CAS001, CAS002 and CAS004           *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    01         Read indicator                                  *
      *    02         Read indicator                                  *
      *    U7         Database error indicator                        *
      *    U8         Database error indicator                        *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * *PSSR - Error processing                                      *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Midas GL Account Postings Logical File
     FAPOSTL10  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(APOSTPDF:XAPOSTPDF)
 
      ** Midas DL Postings for Today - Detail File
     FDLPOSTPD  O    E             DISK    INFSR(*PSSR)
     F                                     RENAME(APOSTPDF:MAPOSTPDF)
     F                                     COMMIT
 
      ** Midas SD Customer Branch - Detail File
     FSDBRCHPD  IF   E             DISK    INFSR(*PSSR)
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     D LDA           E DS           256    EXTNAME(LDA)
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
      **                                    184 193 DBMOD
      **                                    194 203 DBPROC
 
      ** Data Area giving Installation Control Details
     D JNSTAT        E DS                  EXTNAME(JNSTAT)
 
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
      ** Program Status Data Structure
     D/COPY ZACPYSRC,PSDS
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** External Data Structure for Deal Deatails
     D SDDEAL        E DS                  EXTNAME(SDDEALPD)
 
      ** Short Data Structure for Access Programs
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
     D***ACCTCDE         S              6    DIM(4) CTDATA PERRCD(1)                          CGL029
     D ACCTCDE         S              6    DIM(10) CTDATA PERRCD(1)                           CGL029
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D WRUN            S              1A
     D CTR             S              1S 0
     D PRTCD           S              7A
     D POPTN           S              7A
 
      ** KLIST Fields
 
     D*KCNUM****       S              6S 0                                                    CSD027
     D KCNUM           S              6A                                                      CSD027
     D***KACOD**         S              4S 0                                                  CGL029
     D KACOD           S             10S 0                                                    CGL029
     D KPSTD           S              5P 0
     D KSPOS           S              7A
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************
 
      ** Access data area JNSTAT to retrieve the previous rundate
 
     C     *DTAARA       DEFINE                  JNSTAT
     C                   IN        JNSTAT
 
     C     KAPOST        KLIST
     C                   KFLD                    KCNUM
     C                   KFLD                    KACOD
     C                   KFLD                    KPSTD
     C                   KFLD                    KSPOS
 
     C                   EVAL      KSPOS = '  GE-FR'
 
      ** Access Dealing ICD
 
     C**********         CALL      'AODEALR0'                                                 CGL029
     C                   CALL      'AODEALR1'                                                 CGL029
     C                   PARM      *BLANK        PRTCD
     C                   PARM      '*FIRST'      POPTN
     C     SDDEAL        PARM      SDDEAL        DSSDY
 
      ** Database Error
 
     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      DBFILE = 'SDDEALPD'
     C                   EVAL      DBASE = 1
     C                   EVAL      DBKEY = POPTN
     C                   EXSR      *PSSR
     C                   ELSE
     C                   MOVEL     BNACCD        ACCTCDE(1)
     C                   MOVEL     BNFRPL        ACCTCDE(2)
     C                   ENDIF
 
     C                   EVAL      KPSTD = PRUN
     C                   EVAL      CTR = 1
     C                   DOW       CTR <= 2
     C                   MOVEL     ACCTCDE(CTR)  KACOD
 
     C     1             SETLL     SDBRCHPD
     C                   READ      SDBRCHPD                               01
     C                   DOW       *IN01 = *OFF
     C                   MOVEL     A8BICN        KCNUM
 
     C     KAPOST        SETLL     APOSTL10
     C     KAPOST        READE     APOSTL10                               02
 
     C                   DOW       *IN02 = *OFF
     C                   WRITE     MAPOSTPDF
     C     KAPOST        READE     APOSTL10                               02
     C                   ENDDO
     C                   READ      SDBRCHPD                               01
     C                   ENDDO
 
     C                   EVAL      CTR = CTR + 1
     C                   ENDDO
 
     C                   COMMIT
     C                   EVAL      *INLR = *ON
 
      *********************************************************************
      /EJECT
      *********************************************************************
      *                                                                   *
      * *PSSR  - Program exception error routine                          *
      *          Called automatically if a program error occurs,          *
      *          or directly by the program code using EXSR.              *
      *          This subroutine DUMPs the program just once.             *
      *                                                                   *
      * Called by: Main Processing                                        *
      *                                                                   *
      * Calls: DBERRCTL                                                   *
      *                                                                   *
      *********************************************************************
 
     C     *PSSR         BEGSR
 
     C                   IF        WRUN = *BLANK
     C                   EVAL      WRUN = 'Y'
     C                   DUMP
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
 
      ********************************************************************
