     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas Global Historic Spot Rates')                     *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GO002438 - Midas Global Historic Spot Rates                  *
      *                                                               *
      *  Function:  This program takes a copy of the current global   *
      *             spot rates for the day from PF/GPCURRPD and will  *
      *             copy the value in the global daily rates historic *
      *             in global database library in **GMLIB             *
      *                                                               *
      *  (c) Finastra International Limited 2005                      *
      *                                                               *
      *  Last Amend No. MD056838           Date 01Oct20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CLE134             Date 01Aug12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CAS014  *CREATE    Date 10Aug05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD056838 - Amend SFNUM type to packed decimal                *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CAS014 - IAS21 The Effects of Changes in Foreign Exchange    *
      *           Rates                                               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    U7+U8      Database Error                                  *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * SRProcess  - Write or update records to global historic file  *
      * SRAudit    - Audit Subroutine                                 *
      * *PSSR      - Error processing                                 *
      * *INZSR     - Initialise                                       *
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
      ** Midas GP Global Daily Historic Spot Rates
     FGPCUHSL0  UF A E           K DISK    INFSR(*PSSR)

      ** Midas Global Daily Historic Spot Rates File - Audit
     FGPCUHSPA  UF A E           K DISK    INFSR(*PSSR)

      ** Midas GP Global Currencies
     FGPCURRL0  IF   E           K DISK    INFSR(*PSSR)

      ** Print File for Midas Global Daily Historic Spot Rate - Audit
     FGO002438AUO    E             PRINTER INFDS(SPOOLA)
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
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

      ** Program Status Data Structure

     D RUNDAT        E DS                  EXTNAME(RUNDAT)

      ** First DS for Access programs - short data structure

     D DSFDY         E DS                  EXTNAME(DSFDY)

      ** External data structure for Bank Details

     D SDBANK        E DS                  EXTNAME(SDBANKPD)

      ** INFDS for GO002438AU
     D SPOOLA          DS
     D  SFILEA                83     92
     D  SFNUMA               123    124B 0
     D  OFLLNA               188    189B 0
     D  PRTLNA               367    368B 0

      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** parameters for AOBANKRO

     D PRTCD           S              7A
     D POPTN           S              7A

      ** Variables for key list GHCUHS

     D K1CYCD          S              3
     D K1PRDT          S              5  0

      ** Work variables

     D WRecCtr         S             10  0

      *
      ** Calling parameters for ZSFILE
      *
     D ZSEQ            S              5A
     D ZSENTY          S              3A
     D**ZSNUM***        S              6S 0                                                 MD056838
     D ZSNUM           S              6  0                                                  MD056838
     D ZSERR           S              1A
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

     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT

      ** Write or update records to global historic spot rate file

     C                   EXSR      SRProcess

      ** Detail Report

     C                   EXSR      SRAudit

      ** End of program

     C                   EVAL      *INLR = *ON
     C                   RETURN
      *********************************************************************
      /EJECT
      *********************************************************************
      *                                                                   *
      * SRProcess - Write/update records to global historic spot rate file*
      *             This subroutine transfers data from global currencies *
      *             file (PF/GPCURRPD) to Global Historic Spot Rate file  *
      *             (PF/GPCUHSPD)                                         *
      *                                                                   *
      * Called by: Main Routine                                           *
      *                                                                   *
      * Calls: None                                                       *
      *                                                                   *
      *********************************************************************
     C     SRProcess     BEGSR

     C                   EVAL      WRecCtr = 0

     C                   READ      GPCURRL0
     C                   DOW       NOT %EOF(GPCURRL0)

     C                   EVAL      K1CYCD = GCCYCD
     C                   EVAL      K1PRDT = BJRDNB
     C     GHCUHS        CHAIN     GPCUHSL0
     C                   EVAL      GHCYCD = GCCYCD
     C                   EVAL      GHDESC = GCDESC
     C                   EVAL      GHNBDP = GCNBDP
     C                   EVAL      GHSPRT = GCSPRT
     C                   EVAL      GHMDIN = GCMDIN
     C                   EVAL      GHLCD  = GCLCD
     C                   EVAL      GHCHTP = GCCHTP
     C                   EVAL      GHCUSR = GCCUSR
     C                   EVAL      GHPRDT = BJRDNB

     C                   IF        %FOUND(GPCUHSL0)
     C                   UPDATE    GPCUHSD0
     C                   ELSE

      ** Count records

     C                   WRITE     GPCUHSD0

     C                   EVAL      WRecCtr = WRecCtr + 1
     C                   ENDIF

     C                   READ      GPCURRL0
     C                   ENDDO

     C                   ENDSR
      *********************************************************************
      /EJECT
      *********************************************************************
      *                                                                   *
      * SRAudit  -  Audit Subroutine                                      *
      *                                                                   *
      * Called by: Main Routine                                           *
      *                                                                   *
      * Calls: None                                                       *
      *                                                                   *
      *********************************************************************
     C     SRAudit       BEGSR

      ** Write report GO002438AU
      ** Write audit report heading

     C                   WRITE     HEADAU

      ** Check Counter

     C                   IF        WRecCtr = 0

      ** Write 'NO DETAILS' updated

     C                   WRITE     DTAILA2

     C                   ELSE

      ** Read audit file

     C                   READ      GPCUHSPA
     C                   EVAL      RRNO   = GHNORE
     C                   EVAL      GHNORE = GHNORE + WRecCtr

     C                   IF        %EOF(GPCUHSPA)
     C                   WRITE     GPCUHSA0
     C                   ELSE
     C                   UPDATE    GPCUHSA0
     C                   ENDIF
     C

      ** Set report fields

     C                   EVAL      RADD = WRecCtr
     C                   EVAL      RTOT = RRNO + RADD

      ** Write no. of records updated

     C                   WRITE     DTAILA1

     C                   ENDIF

      ** Write end of report

     C                   WRITE     ENDREAU

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: AOBANKR0                                               *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR

      ** LDA Data area

     C     *DTAARA       DEFINE                  LDA

      *
      ** Ensure Report Spool File recorded by RCF.
      *
     C                   Z-ADD     SFNUMA        ZSNUM

     C                   CALL      'ZSFILE'
     C                   PARM                    ZSEQ
     C                   PARM                    ZSENTY
     C                   PARM                    SFILEA
     C                   PARM                    ZSNUM
     C                   PARM                    ZSERR

      *
      ** If Error occurs during ZSFILE processing, then return to the
      ** Calling Program.
      *
     C     ZSERR         IFEQ      'Y'
     C                   SETON                                        U7U8LR
     C                   RETURN
     C                   ENDIF
      ** Access Bank Details

     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDBANK        PARM      SDBANK        DSFDY

      ** Database Error

     C                   IF        PRTCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'SDBANKPD'
     C                   EVAL      DBKEY  =  POPTN
     C                   EVAL      DBPGM = 'GO002438'
     C                   EVAL      DBASE  =  001
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Key list for GPCUHSL0

     C     GHCUHS        KLIST
     C                   KFLD                    K1CYCD
     C                   KFLD                    K1PRDT

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

     C                   DUMP

      ** Write audit report heading

     C                   WRITE     HEADAU

      ** Write audit report details

     C                   WRITE     DTAILA3

      ** Write end of report

     C                   WRITE     ENDREAU

      ** End of Program

     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN

     C                   ENDSR
      *********************************************************************
