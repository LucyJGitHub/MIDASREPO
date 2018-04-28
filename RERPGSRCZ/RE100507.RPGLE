     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas RE Cash Management Hierarchy Review Report')
      *****************************************************************
      *                                                               *
      *  Midas - Retail Module                                        *
      *                                                               *
      *  RE100507  - Cash Management Hierarchy Review Report          *
      *                                                               *
      *  Function: This module lists cash management hierarchies      *
      *            whose review date is due or past due.              *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CRE008  *CREATE    Date 19Feb02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CRE008 - Cash Management                                     *
      *                                                               *
      *****************************************************************
 
     FRECMHDL5  IF   E           K DISK    INFSR(*PSSR)
     FRE100507P1O    E             PRINTER INFSR(*PSSR) USROPN
     F                                     INFDS(SPOOL1)
 
      *****************************************************************
      * Standard D Specifications
     D/COPY ZACPYSRC,RECMSTDD
      * Program Status Data Structure
     D/COPY ZACPYSRC,PSDS
      *****************************************************************
 
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for BANK details
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for access programs
 
 
      ** File Information Data Structure for RE100507P1
     D SPOOL1          DS
     D  PSFile1               83     92
     D  PSFNum1              123    124B 0
 
 
      ** Parameters for ZSFILE
     D PSeq            S              5
     D PLevel          S              1
     D PEnty           S              3
     D ZSnum           S              6  0
     D ZSerr           S              1
 
 
 
      * Calculate report horizon date (run date + 5 working days)
 
     C                   EXSR      CAL_RH_DATE
 
      * Read the cash management hierarchies in review date sequence
 
     C     *LOVAL        SETLL     RECMHDD0
     C                   READ      RECMHDD0                               60
 
      * Read until EOF or report horizon date passed
 
     C     *IN60         DOWEQ     '0'
     C     CDRVDT        ANDLE     RH_DATE
 
      * Print hierarchies with a due or past due review date
 
     C                   EXSR      PRT_RVDTDUE
 
     C                   READ      RECMHDD0                               60
     C                   ENDDO
 
      *  Produce end of report
 
     C                   EXSR      END_OF_REP
     C                   CLOSE     RE100507P1
 
      * Return
 
     C                   SETON                                        LR
     C                   RETURN
      *
      /SPACE 5
      ********************************************************************
      * Calculate report horizon date (run date + 5 working days)
      ********************************************************************
     C     CAL_RH_DATE   BEGSR
 
     C                   CALLB     'ZFWDT'
     C                   PARM      BJRDNB        ZDAYNO            5 0
     C                   PARM      5             ZNRDYS            2 0
     C                   PARM      *ZERO         ZDYNBR            5 0
     C                   PARM      BJLCCY        ZCCY              3
     C                   PARM      BJSLCD        ZLOC              3
 
     C                   Z-ADD     ZDYNBR        RH_DATE           5 0
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * Print hierarchies due or past due
      ********************************************************************
     C     PRT_RVDTDUE   BEGSR
 
     C                   Z-ADD     CDRVDT        ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVEL     ZADATE        RRVDT
 
      * If review date is prior to run date, it is overdue
 
     C     CDRVDT        COMP      BJRDNB                               30
 
     C                   Z-ADD     1             CHLINE            3 0
     C                   EXSR      PAG
     C                   WRITE     RVDTDUE
 
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * End of Report
      ********************************************************************
     C     END_OF_REP    BEGSR
 
      * Output 'end of report'
 
     C                   Z-ADD     3             CHLINE
     C                   EXSR      PAG
     C                   WRITE     ENDOFREP
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * Convert a day number into a date
      ********************************************************************
     C     ZDATE2        BEGSR
     C                   CALLB     'ZDATE2'
     C                   PARM                    ZDAYNO            5 0
     C                   PARM                    BJDFIN
     C                   PARM      *ZERO         ZDATEN            6 0
     C                   PARM      *BLANK        ZADATE            7
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      ********************************************************************
      * Throw page headings (if required)
      ********************************************************************
     C     PAG           BEGSR
 
     C                   ADD       CHLINE        LINENO
     C     LINENO        IFGT      59
     C                   ADD       1             PAGNUM
     C                   WRITE     PAGEHEAD
     C     4             ADD       CHLINE        LINENO            3 0
     C                   ENDIF
 
     C                   ENDSR
     C********************************************************************
      /SPACE 5
      ********************************************************************
      * Register P1 printer file with RCF
      ********************************************************************
     C     RCFP1         BEGSR
 
     C                   EVAL      ZSnum = PSFNum1
 
     C                   CALL      'ZSFILE'
     C                   PARM                    PSeq
     C                   PARM                    PEnty
     C                   PARM                    PSFile1
     C                   PARM                    ZSnum
     C                   PARM      *Blank        ZSErr
 
      ** If Error occurs during ZSFILE processing, then end abnormally
 
     C                   IF        ZSErr = 'Y'
     C                   EVAL      X_ERMS = 'Call to ZSFILE in error'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *********************************************************************
     C/SPACE 5
      ********************************************************************
      * *INZSR --- INITIAL PROCESSING
      ********************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    PSeq
     C                   PARM                    PLevel
     C                   PARM                    PEnty
 
      *  Access Bank Details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR  '    @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
 
      * Throw a page
 
     C                   Z-ADD     99            LINENO
 
      * Open files
     C                   OPEN      RE100507P1
 
      * Register P1 printer file with RCF
     C                   EXSR      RCFP1
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY ZACPYSRC,RECMPSSR
      *****************************************************************
