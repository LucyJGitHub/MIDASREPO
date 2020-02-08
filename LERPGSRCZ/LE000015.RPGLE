     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas LE Manual Fclty Util. Exchange Rate Update')
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LE000015 - Manual Facility Utilisation Exchange Rate Update  *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *  Last Amend No. AR674226           Date 04Dec19               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CLE042             Date 06Sep05               *
      *                 CLE025  *CREATE    Date 20Oct03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR674226 - Manual transaction reached 999. Increase the size *
      *             of utilisation sequence no. and transaction       *
      *             sequence. Recompile. (Child: AR674227)            *
      *           - Applied for MD054782.                             *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  CLE025 - Credit Lines                                        *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
     FLEMNFUL0  UF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(F1)
      ** Manual Utilisation Transaction
 
     FFCLTYL1   IF   E           K DISK    INFSR(*PSSR)
      ** Facility File
 
     ******************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     D LDA           E DS           256    EXTNAME(LDA) DTAARA(LDA)
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
 
      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** External DS for Currency Details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      ** Short Data Structure for Access Programs
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Long Data Structure for Access Programs
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Pameters/Variables/Keys
     D PRetCode        S              7
     D POption         S              7
     D WkCurr          S              3
     D PCurr           S              3
     D WRun            S              1
     D WkRate1         S             16P 9
     D WkRate2         S             16P 9
     D WkUXRT          S             16P 9
     D WkIntg          S             16P 9
 
      ** Main Processing
 
     C     *LOVAL        SETLL     LEMNFUL0
     C                   READ      LEMNFUL0
 
     C                   DOW       NOT %EOF(LEMNFUL0)
 
     C     KlFclt        CHAIN     FCLTYL1                            60
 
      ** Only perform update when:
 
      ** 1. utilisation transaction is a LIVE record (RECI='D')
      ** 2. facility being used is defined in the Facilities file and is
      **    a LIVE facility (Found in FCLTYL1 and RECI='D')
      ** 3. transaction has already started (Run Date > Start Date)
      ** 4. transaction prefers NOT to use fixed rate (Use Fixed Rate
      **    flag = 'N')
      ** 5. transaction has different currency as that of the facility
      **    (Utilisation currency <> facility currency)
 
     C                   IF        F1RECI = 'D' AND *IN60 = *OFF AND
     C                             RECI = 'D' AND BJRDNB > F1STDT AND
     C                             F1FIXR = 'N' AND F1UCCY <> FCCY
 
     C                   EVAL      WkCurr = F1UCCY
     C                   EXSR      SRGetCurD
 
     C                   IF        A6MDIN = 'D'
     C                   EVAL      WkRate1 = 1/A6SPRT
     C                   ELSE
     C                   EVAL      WkRate1 = A6SPRT
     C                   ENDIF
     C                   EVAL      WkCurr = FCCY
     C                   EXSR      SRGetCurD
 
     C                   IF        A6MDIN = 'D'
     C                   EVAL      WkRate2 = 1/A6SPRT
     C                   ELSE
     C                   EVAL      WkRate2 = A6SPRT
     C                   ENDIF
 
      ** Since length of Utilisation Exchange Rate field in the file allows
      ** only 4 digit for whole numbers, so once it exceeds this, invert rate
      ** and set multiply/divide indicator to 'D'
 
     C                   EVAL      WkUXRT = WkRate1/WkRate2
     C                   EVAL      WkIntg = WkUXRT/10000
 
     C                   IF        WkIntg >= 1
     C                   EVAL      F1UXRT = 1/WkUXRT
     C                   EVAL      F1UXID = 'D'
     C                   ELSE
     C                   EVAL      F1UXRT = WkRate1/WkRate2
     C                   EVAL      F1UXID = 'M'
     C                   ENDIF
 
     C                   UPDATE    LEMNFUPF
 
     C                   ENDIF
 
     C                   READ      LEMNFUL0
 
     C                   ENDDO
 
     C                   EVAL      *INLR = *ON
 
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation Routine                      *
      *                                                               *
      *  Called by: Main Subroutine                                   *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     KlFclt        KLIST
     C                   KFLD                    F1BRCA
     C                   KFLD                    F1CNUM
     C                   KFLD                    F1FACT
     C                   KFLD                    F1FCNO
 
      ** Access bank details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      '*MSG   '     PRetCode
     C                   PARM      '*FIRST '     POption
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database error
     C                   IF        PRetCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBKEY  = '*CALL'
     C                   EVAL      DBASE  = 001
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRGetCurD - Subroutine that Accesses Currency Details        *
      *                                                               *
      *****************************************************************
     C     SRGetCurD     BEGSR
 
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      '*KEY   '     POption
     C                   PARM      WkCurr        PCurr
     C     SDCURR        PARM      SDCURR        DSSDY
 
      ** Database Error
 
     C                   IF        PRetCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDCURRPD'
     C                   EVAL      DBASE = 002
     C                   EVAL      DBKEY = WkCurr
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
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
      *********************************************************************
     C     *PSSR         BEGSR
 
     C                   DUMP
 
     C                   IF        WRun = *BLANK
     C                   EVAL      WRun = 'Y'
 
     C                   CALL      'DBERRCTL'
 
     C                   ENDIF
 
     C                   EVAL      *INU7 = '1'
     C                   EVAL      *INU8 = '1'
     C                   EVAL      *INLR = '1'
     C                   RETURN
      *
     C                   ENDSR
