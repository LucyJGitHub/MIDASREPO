     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas RP FF Commis. & Charges - COB changes')
      *****************************************************************
      *                                                               *
      *  Midas - Meridian DBA Replication                             *
      *                                                               *
      *  RP1415 - FF Commis. & Charges - COB Changes - Reset/Reports. *
      *                                                               *
      *  Function:  This program resets FF Commis. & Charges          *
      *  (COB)      Replication Indicator field for records that have *
      *             been changed during previous COB and data of      *
      *             which have been passed to remote systems by       *
      *             change the Replication field to 'C' (like COB).   *
      *                                                               *
      *             Basic informations of records, that have been     *
      *             changed during current COB, are printed on report *
      *                                                               *
      *             These two functions are mutually exclusive and    *
      *             conditionned by external indicator U1.            *
      *                                                               *
      *  Component of: RPC1415 - FF Commis. & Charges - COB Changes   *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSD031             Date 10Apr06               *
      *  Prev Amend No. CSD027             Date 09Dec05               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CFF007   *CREATE   Date 13Feb01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CFF007 - Futures and Options Enhancement for Private Banking *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    01         End of file FFCOCHL0                            *
      *    30         Controls text in header                         *
      *    83         General file access indicator                   *
      *    U1         Print on report / reset flag                    *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRReport - Subroutine to print details of processed record.  *
      *  SRRCFP1 - Subroutine to register the P1 Printer File via RCF *
      *  SRRCFAU - Subroutine to register the AU Printer File via RCF *
      *  SRAudit - Subroutine to Output Audit report.                 *
      *  *PSSR   - Program exception error routine                    *
      *  *INZSR  - Program Initialization routine.                    *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** FF Commissions and Charges Details
     FFFCOCHL0  UF   E           K DISK    INFSR(*PSSR)
 
      ** FF Instrument type
     FINTYP     IF   E           K DISK    INFSR(*PSSR)
 
      ** FF Trans2.
     FTRANS2    IF   E           K DISK    INFSR(*PSSR)
 
      ** PB FF Commis. & charges COB changes replication audit report.
     FRP1415AU  O    E             PRINTER INFDS(SpoolU)
     F                                     INFSR(*PSSR)
 
      ** PB FF Commis. & Charges COB changes replication report.
     FRP1415P1  O    E             PRINTER INFDS(Spool1)
     F                                     INFSR(*PSSR)
     F                                     USROPN
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** External Data structure for Local data area (db error details)
     D LDA           E DS           256    EXTNAME(LDA) DTAARA(LDA)
      ** The following fields are defined in the external file:
      **                                    134 141 DBFile
      **                                    142 170 DBKey
      **                                    171 180 DBPgm
      **                                    181 1830DBase
      **                                    184 193 DBMod
      **                                    194 203 DBProc
 
      ** The following /COPY line includes all the defined fields in
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Data structure for access programs, long data structure.
     D Dssdy         E DS                  EXTNAME(DSSDY)
 
      ** External data structure for Bank Details.
     D SdBank        E DS                  EXTNAME(SDBANKPD)
 
      ** External data structure for Currency Details.
     D SdCurr        E DS                  EXTNAME(SDCURRPD)
 
      ** Array used to align all amounts on decimal point.
     D WArAmount       S              1    DIM(25)
 
      ** File Information Data Structure for printer file RP1415AU.
     D SpoolU          DS
     D  SFNameU               83     92
     D  SFNumU               123    124B 0
 
      ** File Information Data Structure for printer file RP1415P1.
     D Spool1          DS
     D  SFName1               83     92
     D  SFNum1               123    124B 0
     D  SFOflLn1             188    189B 0
     D  SFPrtLn1             367    368B 0
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** --------- Start of fields used by access programs ----------**
      ** Return code.
     D PRtnCde         S              7A
      ** Option.
     D POption         S              7A
      ** Currency.
     D PCurr           S              3A
      ** ---------- End of fields used by access programs -----------**
 
      ** Parameter fields used by standard programs
     D PZFld15         S             15P 0
     D PZDecs          S              1P 0
     D PZEdtCde        S              1A
     D PZOut21         S             21A
     D PZSeq           S              5A
     D PZEntity        S              3A
     D PZSFName        S             10A
     D PZSFNum         S              6P 0
     D PZError         S              1A
 
      ** Fields used to check that sufficient lines remain for the
      ** printer file record format.
     D WDifLn1         S              2  0
     D WRqdLn1         S              2  0
 
      ** Work Field used to produce only one dump.
     D WRunBefore      S              1A
 
      ** Work Field used to open P1 printer file only once.
     D WOpenP1         S              1A
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
     ITRANSDF
      ** Transaction
      *
     I              RECI                        RECI2
 
      /EJECT
      *****************************************************************
      *                                                               *
      *                  M A I N  P R O C E S S I N G                 *
      **   +------------------------------------------------------+   *
      **   ¦                                                      ¦   *
      **   ¦ Initial processing is performed automatically: the   ¦   *
      **   ¦ *INZSR is executed at program activation.            ¦   *
      **   ¦                                                      ¦   *
      **   +------------------------------------------------------+   *
      *                                                               *
      *****************************************************************
 
      ** Read first FF FFCOCHL0
     C                   READ      FFCOCHD0                               01
 
      ** Do while FF Commis. & charges be processed.
     C     *IN01         DOWEQ     *OFF
 
      ** If Replication field has to be reset.
     C     *INU1         IFEQ      *OFF
     C                   EVAL      CCREPI = *BLANK
     C                   UPDATE    FFCOCHD0
     C                   ELSE
     C                   EVAL      CCREPI = 'C'
     C                   UPDATE    FFCOCHD0
     C                   EXSR      SRReport
     C                   ENDIF
 
     C                   EVAL      RCOUNT = RCOUNT + 1
 
      ** Read next FF Commis. & Charges file record.
     C                   READ      FFCOCHD0                               01
 
     C                   ENDDO
 
      ** If printing of reports required.
     C     *INU1         IFEQ      *ON
 
      ** If at least one line has been printed.
     C     RCOUNT        IFGT      0
     C                   WRITE     ENDPAG1
 
      ** Check that sufficient lines remain for the Format. If not,
      ** write out the Main Headings on a new page.
     C                   EVAL      WRqdLn1 = 4
     C                   EVAL      WDifLn1 = SFOflLn1 - SFPrtLn1
 
     C     WDifLn1       IFLE      WRqdLn1
     C                   WRITE     HEADP1
     C                   ENDIF
 
      ** Write out Trailer Format.
     C                   WRITE     TRAILP1
 
      ** Commis. & Charges  Details COB changes Report printer file.
     C                   CLOSE     RP1415P1
 
     C                   ENDIF
 
     C                   ENDIF
 
      ** Print Audit Report.
     C                   EXSR      SRAudit
 
      ** End Program and Return.
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRReport - Subroutine to print details of processed record.  *
      *                                                               *
      *  Called By: Main processing                                   *
      *                                                               *
      *  Calls:     SRRCFP1, *PSSR, AOCURRR0, ZSEDIT                  *
      *                                                               *
      *****************************************************************
     C     SRReport      BEGSR
 
      ** Insure Audit Report Spool File was recorded by RCF.
     C     WOpenP1       IFEQ      *BLANK
     C                   EVAL      WOpenP1 = 'Y'
     C                   OPEN      RP1415P1
     C                   EXSR      SRRCFP1
      ** Force header format printing.
     C                   EVAL      SFPrtLn1 =  SFOflLn1
     C                   ENDIF
 
      ** Set up report printer file fields.
 
      ** Retrieve The instrument indicator
     C     CCTNBR        CHAIN     Trans2                             83
     C                   IF        *IN83 = *ON  OR RECI2 <> 'D'
     C     *LOCK         IN        LDA
     C                   Z-ADD     01            DBASE
     C                   MOVEL     'TRANS2'      DBFILE
     C                   MOVEL     CCTNBR        DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Retrieve currency number of decimal places.
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANK        PRtnCde
     C                   PARM      '*KEY   '     POption
     C                   PARM      ISCY          PCurr
     C     Sdcurr        PARM      Sdcurr        Dssdy
 
      ** If currency does not exist, handle database error.
     C     PRtnCde       IFNE      *BLANKS
     C     *LOCK         IN        Lda
     C                   EVAL      Dbpgm  = PSProcName
     C                   EVAL      Dbfile = 'SDCURRPD'
     C                   EVAL      Dbase  = 02
     C                   EVAL      Dbkey  = ISCY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Broker Commission amount
     C                   MOVE      CCBCMA        PZFld15
     C                   EVAL      PZDecs  = A6NBDP
 
     C                   CALLB     'ZSEDIT'
     C                   PARM                    PZFld15
     C                   PARM                    PZDecs
     C                   PARM      'J'           PZEdtCde
     C                   PARM      *BLANKS       PZOut21
 
     C                   EVAL      WArAmount = *BLANKS
 
      ** See to it that amounts would be aligned on decimal point.
     C     PZDecs        IFEQ      0
     C                   EVAL      A = 1
     C                   ELSE
     C     PZDecs        ADD       2             A                 1 0
     C                   ENDIF
 
     C                   MOVEA     PZOut21       WArAmount(A)
     C                   MOVEA     WArAmount(1)  P1BCMA
 
      ** Broker Charges amount
     C                   MOVE      CCBCHA        PZFld15
     C                   EVAL      PZDecs  = A6NBDP
 
     C                   CALLB     'ZSEDIT'
     C                   PARM                    PZFld15
     C                   PARM                    PZDecs
     C                   PARM      'J'           PZEdtCde
     C                   PARM      *BLANKS       PZOut21
 
     C                   EVAL      WArAmount = *BLANKS
 
      ** See to it that amounts would be aligned on decimal point.
     C     PZDecs        IFEQ      0
     C                   EVAL      A = 1
     C                   ELSE
     C     PZDecs        ADD       2             A
     C                   ENDIF
 
     C                   MOVEA     PZOut21       WArAmount(A)
     C                   MOVEA     WArAmount(1)  P1BCHA
 
      ** Customer Commission amount
     C                   MOVE      CCCCMA        PZFld15
     C                   EVAL      PZDecs  = A6NBDP
 
     C                   CALLB     'ZSEDIT'
     C                   PARM                    PZFld15
     C                   PARM                    PZDecs
     C                   PARM      'J'           PZEdtCde
     C                   PARM      *BLANKS       PZOut21
 
     C                   EVAL      WArAmount = *BLANKS
 
      ** See to it that amounts would be aligned on decimal point.
     C     PZDecs        IFEQ      0
     C                   EVAL      A = 1
     C                   ELSE
     C     PZDecs        ADD       2             A
     C                   ENDIF
 
     C                   MOVEA     PZOut21       WArAmount(A)
     C                   MOVEA     WArAmount(1)  P1CCMA
 
      ** Customer Charges amount
     C                   MOVE      CCCCHA        PZFld15
     C                   EVAL      PZDecs  = A6NBDP
 
     C                   CALLB     'ZSEDIT'
     C                   PARM                    PZFld15
     C                   PARM                    PZDecs
     C                   PARM      'J'           PZEdtCde
     C                   PARM      *BLANKS       PZOut21
 
     C                   EVAL      WArAmount = *BLANKS
 
      ** See to it that amounts would be aligned on decimal point.
     C     PZDecs        IFEQ      0
     C                   EVAL      A = 1
     C                   ELSE
     C     PZDecs        ADD       2             A
     C                   ENDIF
 
     C                   MOVEA     PZOut21       WArAmount(A)
     C                   MOVEA     WArAmount(1)  P1CCHA
 
      ** Transaction Number
     C                   IF        CCTNBR <> *zero
     C                   MOVE      CCTNBR        P1TNBR
     C                   ELSE
     C                   CLEAR                   P1TNBR
     C                   ENDIF
 
      ** Customer
     C**********         IF        CCCUST <> *zero                                            CSD027
     C                   MOVE      CCCUST        P1CUST
     C**********         ELSE                                                                 CSD027
     C**********         CLEAR                   P1CUST                                       CSD027
     C**********         ENDIF                                                                CSD027
 
      ** Broker Commission Code
     C                   IF        CCBCMC <> *zero
     C                   MOVE      CCBCMC        P1BCMC
     C                   ELSE
     C                   CLEAR                   P1BCMC
     C                   ENDIF
 
      ** Customer Commission Code
     C                   IF        CCCCMC <> *zero
     C                   MOVE      CCCCMC        P1CCMC
     C                   ELSE
     C                   CLEAR                   P1CCMC
     C                   ENDIF
 
      ** Broker Charges Code
     C                   IF        CCBCHC <> *zero
     C                   MOVE      CCBCHC        P1BCHC
     C                   ELSE
     C                   CLEAR                   P1BCHC
     C                   ENDIF
 
      ** Customer Charges Code
     C                   IF        CCCCHC <> *zero
     C                   MOVE      CCCCHC        P1CCHC
     C                   ELSE
     C                   CLEAR                   P1CCHC
     C                   ENDIF
 
 
      ** Check that sufficient lines remain for the Format. If not,
      ** write out the Main Headings on a new page.
     C                   EVAL      WRqdLn1 = 3
     C                   EVAL      WDifLn1 = SFOflLn1 - SFPrtLn1
     C     WDifLn1       IFLE      WRqdLn1
 
      ** If end of page, print relevant record format.
     C     RCOUNT        IFGT      0
     C                   WRITE     ENDPAG1
     C                   ENDIF
 
     C                   WRITE     HEADP1
 
     C                   ENDIF
 
      ** Write record details.
     C                   WRITE     DETAIL1
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRCFP1  - Subroutine to register the P1 Printer File via RCF*
      *                                                               *
      *  Called by: SRReport                                          *
      *                                                               *
      *  Calls:     ZSFILE                                            *
      *                                                               *
      *****************************************************************
     C     SRRCFP1       BEGSR
 
      ** Ensure Report Spool File recorded by RCF.
 
     C                   Z-ADD     SFNum1        PZSFNum
 
     C                   CALL      'ZSFILE'
     C                   PARM      *BLANKS       PZSeq
     C                   PARM                    PZEntity
     C                   PARM      SFName1       PZSFName
     C                   PARM                    PZSFNum
     C                   PARM      *BLANK        PZError
 
      ** If any Error occurred during ZSFILE processing, then return
      ** to calling program.
     C     PZError       IFEQ      'Y'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRCFAU  - Subroutine to register the AU Printer File via RCF*
      *                                                               *
      *  Called by: SRAudit                                           *
      *                                                               *
      *  Calls:     ZSFILE                                            *
      *                                                               *
      *****************************************************************
     C     SRRCFAU       BEGSR
 
      ** Ensure Audit Spool File recorded by RCF.
     C                   Z-ADD     SFNumU        PZSFNum
 
     C                   CALL      'ZSFILE'
     C                   PARM      *BLANKS       PZSeq
     C                   PARM      *BLANKS       PZEntity
     C                   PARM      SFNameU       PZSFName
     C                   PARM                    PZSFNum
     C                   PARM      *BLANK        PZError
 
      ** If Error occurs during ZSFILE processing, then return to the
      ** calling program.
     C     PZError       IFEQ      'Y'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAudit - Subroutine to output Audit report.                 *
      *                                                               *
      *  Called By: Main Processing, *PSSR                            *
      *                                                               *
      *  Calls:     SRRCFAU                                           *
      *                                                               *
      *****************************************************************
     C     SRAudit       BEGSR
 
      ** Ensure Audit Report Spool File Recorded by RCF.
     C                   EXSR      SRRCFAU
 
      ** Output Report Header and File Controls.
     C                   WRITE     HEADAU
     C                   WRITE     CONTROL
 
      ** If there is a DB Error, output the DB Error Information.
     C     *INU7         IFEQ      *ON
 
     C                   WRITE     DBERROR
 
     C                   ELSE
 
      ** Or, if no records read, output "No Details" message.
     C     RCOUNT        IFEQ      0
     C                   WRITE     NODTLS
     C                   ENDIF
 
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
      * Calls:     SRAudit                                            *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
 
     C     WRunBefore    IFNE      'Y'
     C                   EVAL      WRunBefore = 'Y'
     C                   DUMP
     C                   CALLB     'DBERRCTL'
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
      ** Ouput Audit Report.
     C                   EXSR      SRAudit
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR  - Program Initialization routine.                    *
      *                                                               *
      *  Called By: Implicitly on program activation.                 *
      *                                                               *
      *  Calls:     AOBANKR0, *PSSR                                   *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
      ** Access Bank details by using access program.
     C                   CALLB     'AOBANKR0'
     C                   PARM      *BLANKS       PRtnCde
     C                   PARM      '*FIRST '     POption
     C     Sdbank        PARM      Sdbank        Dssdy
 
      ** If Bank details do not exist, handle database error.
     C     PRtnCde       IFNE      *BLANKS
     C     *LOCK         IN        Lda
     C                   EVAL      Dbpgm  = PSProcName
     C                   EVAL      Dbfile = 'SDBANKPD'
     C                   EVAL      Dbase  = 03
     C                   EVAL      Dbkey  = '*FIRST'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Set on indicator to print appropriate audit report header.
     C     *INU1         IFEQ      *ON
     C                   EVAL      *IN30 = *ON
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
