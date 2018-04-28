     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Re-Generation of Position Sett for WTax')
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SE7608UPD - Re-Generation of Position Settlement for         *
      *            withholding tax.                                   *
      *                                                               *
      *  Function:  This module provides the input screen for         *
      *             the user selection input of Re-Generation of      *
      *             position settlement for withholding tax.          *
      *                                                               *
      *  Component of: SEC7608 Re-Generation of position settlement   *
      *                for withholding tax.                           *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSD027             Date 09Dec05               *
      *  Prev Amend No. CAS008             Date 11May04               *
      *                 CAS006             Date 21Jan03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.04 -----------------------------------------------*
      *                 186109             Date 09Nov00               *
      *                 CSE023  *CREATE    Date 12Jul00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CAS008 - Delayed Hedge Assessment (Recompile)                *
      *  CAS006 - Hedge Accounting Phase B (Recompile)                *
      *  186109 - FCOOB encountered in SE2300 file POSETA due to      *
      *           regeneration                                        *
      *  CSE023 - Treaty Withholding Tax                              *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    01         Error while reading POSETW6                     *
      *    02         End of file for POSETW6                         *
      *    03         No record found in SECEO                        *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * SRProc - Read file and process details                        *
      * *PSSR - Error processing                                      *
      * *INZSR - Initialisation routine                               *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Position Settlement by Security, Due Date, and Event Type
     FPOSETW6   UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
 
      ** Security Events by type, desc., date
     FSECEO     UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
 
      ** Security Non-Diary events - Audit
     FSNDEVA    UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
 
      ** Position Settlements - Audit
     FPOSETA    UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     D LDA           E DS           256    EXTNAME(LDA)
      *
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
      *
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
      *
      ** Data Area giving Installation Control Details
      *
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
      *
      ** Program Status Data Structure
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Externally described DS for bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** Externally described DS for SAR details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
 
      ** DS for access programs - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Parameters for module AOBANKR0
     D PRtCd           S              7A
     D POptn           S              7A
 
     D PPSSH           S             10A
     D PCDUD           S              5A
     D PPDUD           S              5S 0
     D PPEVT           S              2A
     D PEVTP           S              2A
 
     D WDltCtr         S              2  0
     D WError          S              1A
     D WRun            S              1
 
     ISNDEVAF
      ** Rename fields for PF/SNDEVA
     I              NORE                        NOREA
     I              TNLU                        TNLUA
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************
 
      ** Process inputs.
     C                   EXSR      SRProc
 
     C                   EVAL      *INLR = *ON
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRProc - Read file and process details                       *
      *                                                               *
      *****************************************************************
     C     SRProc        BEGSR
 
     C     WKey1         SETLL     POSETW6
     C                   EVAL      WDltCtr = 0
     C                   DOW       *IN02 = *OFF
 
     C     WKey1         READE     POSETW6                              0102
 
      ** Database error
 
     C                   IF        *IN01
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = '*FIRST'
     C                   EVAL      DBFILE = 'POSETW6'
     C                   EVAL      DBASE = 002
     C                   OUT       LDA
     C                   EVAL      *INU7 = '1'
     C                   EVAL      *INU8 = '1'
     C                   EVAL      WError = 'Y'
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Record found  and not deleted nor matured.
 
     C                   IF        *IN02 = *OFF AND
     C                             RECI <> '*' AND
     C                             RECI <> 'M'
 
     C                   EVAL      RECI = '*'
     C                   EVAL      LCD = BJRDNB
     C                   EVAL      CHTP = 'D'
 
      ** If message already generated for the record, re-generate.
 
     C                   IF        MT5G = 'Y'
     C                   EVAL      MT5G = 'R'
     C                   ENDIF
 
      ** Update position settlement file.
 
     C                   UPDATE    POSETDF
     C                   EVAL      WDltCtr = WDltCtr + 1
 
     C                   ENDIF
 
     C                   ENDDO
 
      ** No errors found.
 
      ** Update position settlement audit file
 
     C                   IF        WError <> 'Y'
     C                   READ      POSETAF                                02
     C                   EVAL      NODE = NODE + WDltCtr
     C                   EVAL      NORE = NORE - WDltCtr                        186109
     C                   UPDATE    POSETAF
 
      ** Event type is equal to 'DV'
 
     C                   IF        PPEVT = 'DV'
     C                   EVAL      PEVTP = PPEVT
     C     WKey2         CHAIN     SECEO                              03
     C                   IF        *IN03 = *OFF
     C                   EVAL      SDDT = 0
     C                   UPDATE    SEDEVDF
     C                   ENDIF
     C                   ENDIF
 
      ** Event type is equal to 'CP'
 
     C                   IF        PPEVT = 'CP'
     C                   EVAL      PEVTP = 'CG'
     C     WKey2         CHAIN     SECEO                              03
     C                   IF        *IN03 = *OFF
     C                   DELETE    SECEO
     C                   READ      SNDEVAF                                02
     C                   EVAL      NOREA = NOREA - 1
     C                   UPDATE    SNDEVAF
     C                   ENDIF
     C                   ENDIF
 
      ** Event type is equal to 'MT'
 
     C                   IF        PPEVT = 'MT'
     C                   EVAL      PEVTP = 'MG'
     C     WKey2         CHAIN     SECEO                              03
     C                   IF        *IN03 = *OFF
     C                   DELETE    SECEO
     C                   READ      SNDEVAF                                02
     C                   EVAL      NOREA = NOREA - 1
     C                   UPDATE    SNDEVAF
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
 
      ** Error found.
 
     C                   IF        WError = 'Y'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   ROLBK
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    PPSSH
     C                   PARM                    PCDUD
     C                   PARM                    PPEVT
 
     C                   MOVE      PCDUD         PPDUD
 
      ** Read in Installation Data
 
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
     C     *DTAARA       DEFINE                  LDA
 
     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   OUT       LDA
 
     C                   CALLB     'AOBANKR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database error.
 
     C                   IF        PRtcd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = POptn
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE = 001
     C                   OUT       LDA
     C                   EVAL      *INU7 = '1'
     C                   EVAL      *INU8 = '1'
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Key fields for POSETW6
     C     WKEY1         KLIST
     C                   KFLD                    PPSSH
     C                   KFLD                    PPDUD
     C                   KFLD                    PPEVT
 
      ** Key fields for SECEO
     C     WKEY2         KLIST
     C                   KFLD                    PPSSH
     C                   KFLD                    PEVTP
     C                   KFLD                    PPDUD
 
     C                   ENDSR
      *********************************************************************
      /EJECT
      *********************************************************************
      *                                                                   *
      * *PSSR  - Program exception error routine                          *
      *          Called automatically if a program error occurs,          *
      *          or directly by the program code using EXSR.              *
      *          This subroutine DUMPs the program just once.             *
      *                                                                   *
      * Called by: (**calling routines**)                                 *
      *                                                                   *
      * Calls: None                                                       *
      *                                                                   *
      *********************************************************************
     C     *PSSR         BEGSR
 
     C                   IF        WRun = *BLANK
     C                   EVAL      WRun = 'Y'
     C                   DUMP
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
