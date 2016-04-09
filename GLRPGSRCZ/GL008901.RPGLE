     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2012')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas GL Corrective Batch Register Housekeeping')      *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GL008901 - Midas GL Corrective Batch Register Housekeeping   *
      *                                                               *
      *  Function:  This program housekeep the Corrective Batch       *
      *             Register File introduced by Period End            *
      *             Adjustments.                                      *
      *                                                               *
      *  Called By: GLC008901 - Midas GL Corrective Batch Register    *
      *                         Housekeeping                          *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2012            *
      *                                                               *
      *  Last Amend No. CSC054 *CREATE     Date 23Feb12               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSC054 - Period End Adjustments                              *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    70      Correction batch register file - EOF               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * SRHousekp - Subroutine to housekeep GLCORBPD                  *
      * SRAudit - Generate audit report                               *
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
 
      ** Midas GL Corrective Batch Register File
     FGLCORBPD  UF   E             DISK    INFSR(*PSSR)
     F                                     COMMIT
      ** Midas GL Corrective Batch Register Houskeeping Audit
     FGL008901AUO    E             PRINTER
 
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
      *
      ** Data Area giving Installation Control Details
      *
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
      *
     D/COPY ZACPYSRC,PSDS
      *
      ** Program Status Data Structure
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Bank Details Data Structure
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** General Ledger Details Data Structure
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
 
      ** Short Access Object Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Long Access Object Data Structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
     D PRtCd           S              7A
     D POptn           S              7A
     D WRun            S              1A
     D WDelet          S              5  0
     D WRead           S              5  0
     D WRetenDay       S              3  0
     D WJournRet       S              6  0
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
     C     *DTAARA       DEFINE                  LDA
 
      ** Housekeep corrective batch register file
 
     C                   EXSR      SRHousekp
 
      ** Generate audit report
 
     C                   EXSR      SRAudit
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRHousekp  - Subroutine to housekeep GLCORBPD                *
      *                                                               *
      *****************************************************************
     C     SRHousekp     BEGSR
 
     C     BKJREP        MULT      31            WRetenDay
     C     BJRDNB        SUB       WRetenDay     WJournRet
 
     C     1             SETLL     GLCORBPD
     C                   READ      GLCORBPD                               70
 
     C     *IN70         DOWEQ     '0'
 
      ** Delete record when Midas Date is passed the journal
      ** retention period
 
     C                   IF        CRMDTE < WJournRet
     C                   DELETE    GLCORBPD
     C                   EVAL      WDelet = WDelet + 1
     C                   ENDIF
 
     C                   EVAL      WRead  = WRead + 1
     C                   READ      GLCORBPD                               70
 
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAudit - Generate audit report                              *
      *                                                               *
      *****************************************************************
     C     SRAudit       BEGSR
 
     C                   WRITE     HEADAU
     C                   IF        *INU7 = *OFF AND
     C                             *INU8 = *OFF
 
     C                   EVAL      RNDELT = WDelet
     C                   EVAL      RNREAD = WRead
     C                   WRITE     CONTROL
     C                   ELSE
     C                   WRITE     DBERROR
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program initialisation subroutine                   *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
      ** Access bank details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY
 
     C                   IF        PRtCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'SDBANKPD'
     C                   EVAL      DBKey = POptn
     C                   EVAL      DBase = 001
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Access general ledger details
 
     C                   CALL      'AOGELRR1'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*FIRST '     POptn
     C     SDGELR        PARM      SDGELR        DSSDY
 
     C                   IF        PRtCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'SDGELRPD'
     C                   EVAL      DBKey =  POptn
     C                   EVAL      DBase =  002
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
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
      *****************************************************************
     C     *PSSR         BEGSR
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
 
     C                   IF        WRun = *BLANK
     C                   EVAL      WRun = 'Y'
     C                   DUMP
     C                   EXSR      SRAudit
     C                   ENDIF
     C                   RETURN
 
     C                   ENDSR
