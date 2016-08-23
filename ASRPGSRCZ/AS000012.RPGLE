     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas AS Hedge Transactions Initialisation Program')   *
      *****************************************************************
      *                                                               *
      *  Midas - Accounting Standards Module                          *
      *                                                               *
      *  AS000012 - Hedge Transactions Initialisation Program         *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      *  Last Amend No. CLE148             Date 23Jul12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CAS005             Date 16Dec02               *
      *                 CAS004  *CREATE    Date 26Jun02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CLE148 - Alpha Loan Reference (Recompile)                    *
      *  CAS005 - Enhancements to CAS001, CAS002 and CAS004           *
      *           (Recompile)                                         *
      *  CAS004 - Hedge Accounting Phase A                            *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    LR         Last record indicator (program termination)     *
      *    U7 and U8  DB error processing indicator                   *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * SRAudit - Write Audit Report                                  *
      * *PSSR - Error processing                                      *
      * *INZSR - Initialise                                           *
      *                                                               *
      *****************************************************************
     FASHTRNPD  UF   E           K DISK    INFSR(*PSSR)
      ** Hedge Transactions File
 
     FASHGLKL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(H)
      ** Hedge Linkages File
 
     FAS000012AUO    E             PRINTER
      ** Hedge Transactions Initialisation Audit Report
 
      *****************************************************************
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
 
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      ** Program Status Data Structure
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** Short Data Structure for Access programs
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D PRtCd           S              7A
     D POption         S              7A
     D WDump           S              1
 
      *****************************************************************
      /EJECT
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
 
      ** Initialise Hedge Transaction ID (FSHTID) = 'D',
      ** Last Change Type (FSHTCT) = 'I' and Last Change Date
      ** (FSHTCD) = BJRDNB
 
     C                   READ      ASHTRNPD
 
     C                   DOW       NOT %EOF(ASHTRNPD)
 
     C     FSHEDI        CHAIN     ASHGLKL1
 
     C                   IF        %FOUND(ASHGLKL1)
 
     C                   IF        HFSRECI = '*'
     C                   EVAL      FSHTID = '*'
     C                   EVAL      FSHTCT = 'D'
     C                   ELSE
     C                   EVAL      FSHTID = 'D'
     C                   EVAL      FSHTCT = 'I'
     C                   ENDIF
 
     C                   EVAL      FSHTCD = BJRDNB
     C                   UPDATE    ASHTRND0
     C                   ADD       1             COUNT
     C                   ENDIF
 
     C                   READ      ASHTRNPD
     C                   ENDDO
 
      ** Write File Controls Report
 
     C                   EXSR      SRAudit
 
     C                   EVAL      *INLR = *ON
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRAudit - Subroutine to Write Audit Report                    *
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SRAudit       BEGSR
 
      ** Write File Control Report Heading
 
     C                   WRITE     HEADAU
 
     C                   IF        COUNT <> 0
     C                   WRITE     CONTROL
 
     C                   ELSE
     C                   WRITE     NODTLS
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Subroutine for First Cycle Processing                *
      *                                                               *
      * Called by: None                                               *
      *                                                               *
      * Calls: AOBANKR0                                               *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
      ** The following /COPY sets the program, module and procedure
      ** names for database error processing.
 
     C/COPY ZACPYSRC,DBFIELDS
 
      ** Access Bank Details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*FIRST '     POption
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** If not found, database error
 
     C     PRtCd         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 1
     C                   EVAL      DBFile = 'SDBANKPD'
     C                   EVAL      DBKEY = '*FIRST'
     C                   EVAL      DBPGM = 'AS000012'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   Z-ADD     *ZERO         COUNT
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR - Program exception error routine                       *
      *                                                               *
      * Called by: SR/*INZSR                                          *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *PSSR         BEGSR
 
     C                   IF        WDUMP = *BLANKS
     C                   EVAL      WDUMP = 'Y'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   DUMP
 
      ** Write File Control Report Heading
 
     C                   WRITE     HEADAU
 
      ** Write Database error
 
     C                   WRITE     DBERROR
 
     C                   RETURN
 
     C                   ENDIF
 
     C                   ENDSR
      ****************************************************************
