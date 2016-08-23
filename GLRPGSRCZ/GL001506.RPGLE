     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2006')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL Collateral Entry Generation')
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GL001506 - Generate Account Keys Header                      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2006            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. 240858  *CREATE    Date 11Jul06               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  240848 - This program will generate Header record of        r*
      *           Collateral Account Keys Header.                     *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    90   If Record header is existing.                         *
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
 
      ** Midas GL Collateral Account Keys Details
     FGLCOAKPD  IF   E             DISK    INFSR(*PSSR)
 
      ** Midas GL Collateral Account Keys Header
     FGLCOAHPD  UF A E           K DISK    INFSR(*PSSR)
 
      ** Midas GL Collateral Entry Generation - Audit
     FGL001506AUO    E             PRINTER INFSR(*PSSR)
 
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
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Work variables
     D WDBerror        S              1
     D WRun            S              1
 
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
     C     1             SETLL     GLCOAKPD
     C                   READ      GLCOAKPD
 
      ** Read through all collateral account keys records
 
     C                   DOW       NOT %EOF(GLCOAKPD)
     C                   EVAL      RnRec = RnRec + 1
     C                   EVAL      RnRc1 = RnRc1 + 1
 
     C                   If        CoRECI='*'
     C                   EVAL      RnDel = RnDel + 1
     C                   Endif
 
     C                   READ      GLCOAKPD
     C                   ENDDO
 
      ** Check the Header if record "H" is existing.
 
     C                   READ      GLCOAHPD
     C                   DOW       NOT %EOF(GLCOAHPD)
     C                   IF        CHRECI = 'H'
     C                   EVAL      CHNREC = RnRec
     C                   EVAL      CHNINS = *ZERO
     C                   EVAL      CHNDEL = RnDel
     C                   EVAL      CHNAMD = *ZERO
     C                   EVAL      CHNRC1 = RnRec
     C                   UPDATE    GLCOAHD0
     C                   SETON                                        90
     C                   ELSE
     C                   EVAL      DBFILE = 'GLCOAHPD'
     C                   EVAL      DBKEY  = 'With non-H Record ID'
     C                   EVAL      DBPGM  = 'GL001506'
     C                   EVAL      DBASE  = 1
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   READ      GLCOAHPD
     C                   ENDDO
 
     C                   IF        *IN90=*OFF
     C                   EVAL      CHRECI = 'H'
     C                   EVAL      CHAKEY = *BLANK
     C                   EVAL      CHZZ02 = *BLANK
     C                   EVAL      CHZZ64 = *BLANK
     C                   EVAL      CHNREC = RnRec
     C                   EVAL      CHNINS = *ZERO
     C                   EVAL      CHNDEL = RnDel
     C                   EVAL      CHNAMD = *ZERO
     C                   EVAL      CHNRC1 = RnRec
     C                   WRITE     GLCOAHD0
     C                   ENDIF
 
      ** Produce audit report
 
     C                   EXSR      SRAudit
 
     C                   EVAL      *INLR = *ON
 
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAudit - Produce audit report                               *
      *                                                               *
      *****************************************************************
     C     SRAudit       BEGSR
 
      ** Print header
 
     C                   WRITE     HEADAU
 
      ** Database Error
 
     C                   IF        WDBerror = 'Y'
     C                   WRITE     ERROR
 
     C                   ELSE
 
      ** Empty file GLACKYPD
 
     C                   IF        RnRec = *ZERO
     C                   WRITE     NOREC
 
     C                   ELSE
     C                   EVAL      RNORE = RnRec
     C                   WRITE     CONTROL
     C                   ENDIF
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
 
      ** Initialise work fields
 
     C*                  EVAL      WNumRec = *ZERO
     C*                  EVAL      WGenRec = *ZERO
     C*                  EVAL      WMissRec = *ZERO
     C                   EVAL      WDBerror = *BLANK
     C                   EVAL      RnRec = *ZERO
     C                   EVAL      RnIns = *ZERO
     C                   EVAL      RnDel = *ZERO
     C                   EVAL      RnAmd = *ZERO
     C                   EVAL      RnRC1 = *ZERO
     C                   SETOFF                                       90
 
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
 
     C                   Eval      DBPGM = 'GL001506'
     C                   DUMP
 
     C                   IF        WRun = *BLANK
     C                   EVAL      WRun = 'Y'
     C                   EVAL      WDBerror = 'Y'
     C                   EXSR      SRAudit
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
