     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL Population of Review and Valuation Date')     *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GL009052 - Population of Review Date and Valuation Date      *
      *                                                               *
      *  Function: This COB program will populate the Review Date     *
      *            and Valuation Date in Collateral Details File      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2004            *
      *                                                               *
      *  Last Amend No. CLE134             Date 01Aug12               *
      *  Prev Amend No. CLE148             Date 23Jul12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CLE040             Date 05Jul04               *
      *                 CGL014  *CREATE    Date 20Oct03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CLE148 - Alpha Loan Reference (Recompile)                    *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE040 - Collateralised Lending Phase 2 (Recompile)          *
      *  CGL014 - Collaterals Processing                              *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * *PSSR - Error processing                                      *
      * *INZSR - Initialise                                           *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Midas GL Collateral Details select on RECI <> 'M'
     FGLCOLLLF  UF   E           K DISK    INFSR(*PSSR)
 
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
 
      ** Data structure to hold Bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** First DS for Access Programs, Short Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Variables
     D PRetCode        S              7
     D POption         S              7
     D WRun            S              1
     D PZFreq          S              1
     D PZDayNo         S              5  0
     D PZMDay          S              2  0
     D PZCcy           S              3
     D PZLoc           S              3
 
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
 
      *****************************************************************
      *                                                               *
      *  MAIN PROCEDURE                                               *
      *                                                               *
      *****************************************************************
 
     C     *LOVAL        SETLL     GLCOLLLF
     C                   READ      GLCOLLLF
 
      ** Read through all collateral detail records with CDRECI <> 'M'
 
     C                   DOW       NOT %EOF(GLCOLLLF)
      ** Live record
 
     C                   IF        CDRECI = 'D'
 
     C                   MOVE      CDCCY         PZCcy
     C                   MOVE      CDCOLO        PZLoc
 
      ** If Review date has passed (less than the next working day) and
      ** frequency is defined, calculate for the next review date and
      ** store this in the Review date field
 
     C                   IF        CDRVDT < BJDNWD AND CDRFRQ <> *BLANKS
     C                   MOVE      CDRFRQ        PZFreq
     C                   Z-ADD     CDRVDT        PZDayNo
     C                   Z-ADD     CDRDNO        PZMDay
     C                   EXSR      SRCall
     C                   Z-ADD     PZDayNo       CDRVDT
     C                   ENDIF
 
      ** If Valuation date has passed (less than the next working day) and
      ** frequency is defined, move the NEXT valuation date to the valuation
      ** date field. Then, compute for the next next valuation date and
      ** and store this in the Next Valuation date field
 
     C                   IF        CDVLDT < BJDNWD AND CDVFRQ <> *BLANKS
     C                   MOVE      CDVFRQ        PZFreq
     C                   Z-ADD     CDNVDT        PZDayNo
     C                   Z-ADD     CDVDNO        PZMDay
     C                   EXSR      SRCall
     C                   Z-ADD     CDNVDT        CDVLDT
     C                   Z-ADD     PZDayNo       CDNVDT
     C                   ENDIF
 
     C                   UPDATE    GLCOLLD0
 
     C                   ENDIF
 
      ** Read next record
     C                   READ      GLCOLLLF
 
     C                   ENDDO
 
     C                   EVAL      *INLR = *ON
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCall - Subroutine that calls *MODULE/ZFRQA which calcu-    *
      *           lates the day number of the next review/valuation   *
      *           date based on the Date, Day of Month and Frequency  *
      *           Code passed as parameters                           *
      *                                                               *
      *****************************************************************
     C     SRCall        BEGSR
 
     C                   CALLB     'ZFRQA'                              31
     C                   PARM                    PZFreq
     C                   PARM                    PZDayNo
     C                   PARM                    PZMDay
     C                   PARM                    PZCcy
     C                   PARM                    PZLoc
     C                   PARM                    BJDFIN
 
     C     *IN31         IFEQ      *ON
     C                   EVAL      DBMOD = 'ZFREQA'
     C                   EVAL      DBFILE = *BLANKS
     C                   EVAL      DBFILE = 'GLCOLLPD'
     C                   EVAL      DBKEY  = CDCREF
     C                   EVAL      DBASE  = 2
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation routine                      *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
      ** Access Bank details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      '*FIRST '     POption
     C     SDBANK        PARM      SDBANK        DSFDY
 
     C                   IF        PRetCode <> *BLANKS
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBKEY  = POption
     C                   EVAL      DBASE  = 1
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR  - Program exception error routine                     *
      *           Called automatically if a program error occurs,     *
      *           or directly by the program code using EXSR.         *
      *           This subroutine DUMPs the program just once.        *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
 
     C                   DUMP
 
     C                   IF        WRun = *BLANK
     C                   EVAL      WRun = 'Y'
     C                   DUMP
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
