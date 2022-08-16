     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2022')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas LE Fee Rate Change Amendment Audit Report')      *
      *****************************************************************
      *                                                               *
      *  Midas - Lending Module                                       *
      *                                                               *
      *  UTLE0441 - Utility program for SC263582.                     *
      *                                                               *
      *  Function: Update blank percentage indicator field on LEFEED  *
      *            and corresponding rate change event on LEFHST.     *
      *                                                               *
      *  Called By: UTCLE441 - Calling program for %indicator update. *
      *                                                               *
      *  (c) Finastra International Limited 2022                      *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  Last Amend No. 263582  *CREATE    Date 29Jul22               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  263582 - Wrong 'Total Accrued to Date' in Fee Detail Enquiry *
      *           Correct the NoOfDays in computations and update the *
      *           value of %indicator field in LEFEED and LEFHST.     *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    09         Audit and update indicator                      *
      *    12         Work indicator if history is processed          *
      *    20         Display detail line for fee cust & facility     *
      *    21         Display detail line for fee rate history        *
      *    26         Work Indicator (chain, read on file)            *
      *    50         OverFlow Indicator                              *
      *    U7+U8      Database Error                                  *
      *    98         Date Format                                     *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * SRFeeFmtP1  - Formats fields of P1 report before the output   *
      * SROutputP1  - Writes P1 report and handles page overflow.     *
      * SRClrFlds   - Clears all the fields except Fee Rate and Amount*
      * SRFrtNum1   - Formats amount fields with significant figures  *
      *               decimal places                                  *
      * SRZDate2    - Convert MIDAS day Number to Date Format(DDMmmYY)*
      * *PSSR       - Error processing                                *
      * *INZSR      - Initialise                                      *
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
      *
      ** Midas LE Fees Master Detail File
      *
     FUTL441L1  UF A E           K DISK
      *
      ** Midas LE Fees Master Detail File
      *
     FUTL441L2  IF   E           K DISK    RENAME(LEFEEDF:LEFEEF0)
      *
      ** Midas Lending Fees History for Rate Changes
      *
     FUTL441L3  UF   E           K DISK
      *
      ** Midas Lending Fees Extract File
      *
     FUTEXTFEE  UF A E           K DISK
      *
      ** Fee Rate Change Amendment Report file
      *
     FUTL441P1  O    E             PRINTER INFSR(*PSSR)
     F                                     INFDS(SPOOL1)
     F                                     OFLIND(*IN50)
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
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
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
      *
     D/COPY ZACPYSRC,PSDS
      *
      ** Program Status Data Structure
      *
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
      ** Data structure for access objects, first DS
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** Data structure for access objects, second DS
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
      ** Data structure for Bank ICD
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      ** Data structure for Currency details
      *
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      *
      ** Data structure for Customer details
      *
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      *
      ** File Information Data Structure for UTL441P1 .
      *
     D SPOOL1          DS
     D  SFILE1                83     92
     D  SFNUM1               123    124B 0
     D  OFLLN1               188    189B 0
     D  PRTLN1               367    368B 0
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
     D @RUN            S              1
      *
     D WZFIELD         S             14
     D WFIELD1         S             16
     D WZADEC          S              1  0
     D WSFPIND         S                   LIKE(FEPIND)
     D WRKNUM          S                   LIKE(FEXNUM)
     D WRKFAC          S                   LIKE(FEXFAC)
     D WRKSEQ          S                   LIKE(FEXSEQ)
     D WRKID1          S                   LIKE(FEPIND)
     D WRKRT1          S                   LIKE(HIFRT1)
     D WRKRT2          S                   LIKE(HIFRT2)
     D WRKRT3          S                   LIKE(HIFRT3)
     D WRKRT4          S                   LIKE(HIFRT4)
     D WRKRT5          S                   LIKE(HIFRT5)
     D WRKCVD          S                   LIKE(HIRCVD)
     D WRKCTP          S                   LIKE(HIRCTP)
     D WRKID2          S                   LIKE(HIPIND)
      *
      ** Key Fields
      *
     D KFCNUM          S                   LIKE(FEXNUM)
     D KFFACL          S                   LIKE(FEXFAC)
     D KFFSEQ          S                   LIKE(FEXSEQ)

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
      *
      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************
      *
      ** Read in Installation Data
      *
     C     *DTAARA       DEFINE                  LDA
      *
      ** Set Date Format Indicator *IN98  on if date format is MMDDYY
      *
     C                   IF        BJDFIN = 'M'
     C                   EVAL      *IN98 = *ON
     C                   ENDIF
      *
     C                   EVAL      WCOUNT = 0
     C                   EVAL      RHEAD = ' '
     C                   EVAL      *IN20 = *ON
     C                   EVAL      *IN21 = *ON
      *
     C                   READ      UTL441L1
     C                   DOW       NOT %EOF(UTL441L1)
     C                   EVAL      *IN12 = *OFF
      *
     C                   IF        FECALT <> *BLANKS
     C                   EVAL      WSFPIND = 'A'
     C
     C                   EVAL      KFCNUM = FECNUM
     C                   EVAL      KFFACL = FEFACL
     C                   EVAL      KFFSEQ = FEFSEQ
     C
     C     *LOVAL        SETLL     UTL441L3
     C     FEKEY1        CHAIN     UTL441L3                           26
     C                   IF        *IN26 = '0'
     C                   DOW       *IN26 = '0'
      *
     C                   IF        HIPIND = *BLANK
      *
     C                   IF        HIRCTP = 'RC'
     C                   IF        *IN09 = *ON
     C                   EVAL      HIPIND = WSFPIND
     C                   UPDATE    LEFHSTF
     C                   ENDIF
      *
      ** Write the records to extract file for printing
      *
     C                   EVAL      WRKID1 =  HIPIND
     C                   EVAL      WRKRT1 =  HIFRT1
     C                   EVAL      WRKRT2 =  HIFRT2
     C                   EVAL      WRKRT3 =  HIFRT3
     C                   EVAL      WRKRT4 =  HIFRT4
     C                   EVAL      WRKRT5 =  HIFRT5
     C                   EVAL      WRKCVD =  HIRCVD
     C                   EVAL      WRKCTP =  HIRCTP
     C                   EVAL      WRKID2 =  HIPIND
      *
     C                   EXSR      SRSaveExtr
     C                   IF        *IN12 = *OFF
     C                   EVAL      *IN12  = *ON
     C                   ENDIF
     C                   ENDIF
     C                   ELSE
     C                   EVAL      WSFPIND = HIPIND
     C                   ENDIF
      *
     C     FEKEY1        READE     UTL441L3                               26
     C                   ENDDO
     C                   ENDIF
      *
     C                   IF        *IN09  = *ON
     C                   EVAL      RPIND  = WSFPIND
     C                   EVAL      FEPIND = WSFPIND
     C                   UPDATE    LEFEEDF
     C                   ENDIF
      *
      ** Write records to extract file for printing if no history.
      *
     C                   IF        *IN12 = *OFF
     C                   IF        *IN09 = *ON
     C                   EVAL      WRKID1 = WSFPIND
     C                   EndIf
     C                   EXSR      SRSaveExtr
     C                   EndIf
      *
     C                   ENDIF
      *
     C                   READ      UTL441L1
      *
     C                   ENDDO
      *
      ** Produce Report file
      *
     C                   EVAL      RHEAD = 'FEE RATE CHANGE - %INDICATOR'
      *
      *
     C                   EVAL      *IN20 = *ON
      *
     C     *LOVAL        SETLL     UTEXTFEE
     C                   READ      UTEXTFEE
     C                   DOW       NOT %EOF(UTEXTFEE)
      *
     C                   EXSR      SRClrFlds
     C                   EXSR      SRFeeFmtP1
      *
     C                   EVAL      *IN20 = *ON
     C                   IF        FEXNUM  =  WRKNUM  and
     C                             FEXFAC  =  WRKFAC  and
     C                             FEXSEQ  =  WRKSEQ
     C                   EVAL      RCUST = ' '
     C                   EVAL      RFATP = 0
     C                   EVAL      RFCNO = 0
     C                   EVAL      RSEQ  = ' '
     C                   EVAL      RCOD  = ' '
     C                   EVAL      RCCY  = ' '
     C                   EVAL      RCALT = ' '
     C                   EVAL      RPIND = ' '
     C                   EVAL      *IN20 = *OFF
     C                   ELSE
     C                   EVAL      WCOUNT = WCOUNT + 1
     C                   ENDIF
      *
     C                   EXSR      SROutPutP1
     C                   EVAL      *IN20 = *OFF
     C                   EVAL      WRKNUM  =  FEXNUM
     C                   EVAL      WRKFAC  =  FEXFAC
     C                   EVAL      WRKSEQ  =  FEXSEQ
      *
     C                   READ      UTEXTFEE
      *
     C                   ENDDO
      *
     C                   IF        *IN50 = *ON
     C                   WRITE     UTLE441H1
     C                   ENDIF
      *
     C                   EVAL      RTOTAL = WCOUNT
     C                   WRITE     UTLE441T2
     C                   WRITE     UTLE441T1
     C
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
      *****************************************************************
      *                                                               *
      ** SRSaveExtr - Save extract details for printing purpose.      *
      ** Called by: Main processing                                   *
      ** Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SRSaveExtr    BegSr
      *
     C                   CLEAR                   LEFEEXF
     C                   EVAL      FEXNUM =  FECNUM
     C                   EVAL      FEXFAC =  FEFACL
     C                   EVAL      FEXSEQ =  FEFSEQ
     C                   EVAL      FEXCOD =  FEFCOD
     C                   EVAL      FEXCCY =  FEFCCY
     C                   EVAL      FEXCAL =  FECALT
     C                   EVAL      FEXID1 =  WRKID1
      *
     C                   EVAL      FEXRT1 =  WRKRT1
     C                   EVAL      FEXRT2 =  WRKRT2
     C                   EVAL      FEXRT3 =  WRKRT3
     C                   EVAL      FEXRT4 =  WRKRT4
     C                   EVAL      FEXRT5 =  WRKRT5
     C                   EVAL      FEXCVD =  WRKCVD
     C                   EVAL      FEXCTP =  WRKCTP
     C                   EVAL      FEXID2 =  WRKID2
      *
     C                   Write     LEFEEXF
      *
      ** Clear variables
      *
     C                   EVAL      WRKID1 =  '  '
     C                   EVAL      WRKRT1 =  0
     C                   EVAL      WRKRT2 =  0
     C                   EVAL      WRKRT3 =  0
     C                   EVAL      WRKRT4 =  0
     C                   EVAL      WRKRT5 =  0
     C                   EVAL      WRKCVD =  0
     C                   EVAL      WRKCTP =  '  '
     C                   EVAL      WRKID2 =  '  '
      *
     C                   EndSr
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      ** SRFeeFmtP1 - Formats fields of P1 report before the output.  *
      ** Called by: Main processing                                   *
      ** Calls:  SRZDate2,SRFrtNum1,SROutPutP1                        *
      *                                                               *
      *****************************************************************
     C     SRFeeFmtP1    BEGSR
      *
      ** Fee master file details
      *
     C                   MOVE      '000000'      RCUST
     C                   MOVE      FEXNUM        RCUST
     C                   MOVEL     FEXFAC        RFATP
     C                   MOVE      FEXFAC        RFCNO
     C                   MOVEL     FEXSEQ        RSEQ
     C                   MOVEL     FEXCOD        RCOD
     C                   EVAL      RCCY = FEXCCY
     C                   EVAL      RCALT = FEXCAL
     C                   MOVE      *BLANKS       WFVAMT           11
      *
     C                   EVAL      KFCNUM = FEXNUM
     C                   EVAL      KFFACL = FEXFAC
     C                   EVAL      KFFSEQ = FEXSEQ
     C     *LOVAL        SETLL     UTL441L2
     C     FEKEY1        CHAIN     UTL441L2                           27
     C                   IF        *IN27 = '0' and *IN09 = '1'
     C                   EVAL      RPIND = FEPIND
     C                   ELSE
     C                   EVAL      RPIND = FEXID1
     C                   ENDIF
      *
      ** Fee history details
      *
     C                   EVAL      *IN21 = *ON
     C                   IF        FEXCTP = *BLANKS
     C                   EVAL      *IN21 = *OFF
     C                   ENDIF
      *
     C                   MOVE      FEXRT1        WFVAMT
     C                   EVAL      WZADEC = 5
     C                   EXSR      SRFrtNum1
     C                   EVAL      RRTE1 = WZFIELD
      *
     C                   MOVE      FEXRT2        WFVAMT
     C                   EVAL      WZADEC = 5
     C                   EXSR      SRFrtNum1
     C                   EVAL      RRTE2 = WZFIELD
      *
     C                   MOVE      FEXRT3        WFVAMT
     C                   EVAL      WZADEC = 5
     C                   EXSR      SRFrtNum1
     C                   EVAL      RRTE3 = WZFIELD
      *
     C                   MOVE      FEXRT4        WFVAMT
     C                   EVAL      WZADEC = 5
     C                   EXSR      SRFrtNum1
     C                   EVAL      RRTE4 = WZFIELD
      *
     C                   MOVE      FEXRT5        WFVAMT
     C                   EVAL      WZADEC = 5
     C                   EXSR      SRFrtNum1
     C                   EVAL      RRTE5 = WZFIELD
      *
     C                   Z-ADD     FEXCVD        ZDAYNO
     C                   EXSR      SRZDate2
     C                   EVAL      RRCVD = PADATE
      *
     C                   MOVEL     FEXCTP        RRCTP
      *
     C                   MOVEL     FEXID2        RRPIN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      ** SRFrtNum1- Formats amount fields with significant figures    *
      **            and decimal places                                *
      ** Called by: SRFeeFmtP1                                        *
      ** Calls:  ZEDIT                                                *
      *                                                               *
      *****************************************************************
     C     SRFrtNum1     BEGSR
      *
     C                   MOVE      *BLANKS       WFIELD1
     C                   MOVE      WFVAMT        WFIELD1
     C                   CALL      'ZEDIT'
     C                   PARM                    WFIELD1
     C                   PARM                    WZADEC
     C                   EVAL      WZFIELD = %TRIM(WFIELD1)
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      ** SROutputP1 - Writes P1 report and handles page overflow      *
      ** Called by: SRFeeFmtP1                                        *
      ** Calls:  None.                                                *
      *                                                               *
      *****************************************************************
     C     SROutputP1    BEGSR
      *
     C                   IF        *IN50 = *ON
     C                   WRITE     UTLE441H1
     C                   WRITE     UTLE441D1
     C                   EVAL      *IN50 = *OFF
     C                   ELSE
     C                   WRITE     UTLE441D1
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      ** SRClrflds -Clears all report fields.                         *
      ** Called by: SRFeeFmtP1                                        *
      ** Calls:  None.                                                *
      *                                                               *
      *****************************************************************
     C     SRClrflds     BEGSR
      *
     C                   EVAL      RCUST = ' '
     C                   EVAL      RFATP = 0
     C                   EVAL      RFCNO = 0
     C                   EVAL      RSEQ  = ' '
     C                   EVAL      RCOD  = ' '
     C                   EVAL      RCCY  = ' '
     C                   EVAL      RCALT = ' '
     C                   EVAL      RPIND = ' '
     C                   EVAL      RRTE1 = ' '
     C                   EVAL      RRTE2 = ' '
     C                   EVAL      RRTE3 = ' '
     C                   EVAL      RRTE4 = ' '
     C                   EVAL      RRTE5 = ' '
     C                   EVAL      RRCVD = ' '
     C                   EVAL      RRCTP = ' '
     C                   EVAL      RRPIN = ' '
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      ** SRZDate2  - Convert MIDAS Day number to Date Format(DDMmmYY) *
      ** Called by: SRFeeFmtP1                                        *
      ** Calls:  None                                                 *
      *                                                               *
      *****************************************************************
     C     SRZdate2      BEGSR
      *
     C                   CALL      'ZDATE2'
     C                   PARM                    ZDAYNO            5 0
     C                   PARM                    BJDFIN
     C                   PARM      *ZERO         PDateOut          6 0
     C                   PARM      *BLANK        PADate            7
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      ** INZSR - Program Initialisation routine                       *
      ** Called by: Implicitly on program activation                  *
      ** Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
     C                   PARM                    WMODE             1
      *
      ** Call Access Program for Bank Details - Title, Run Date and
      ** Run Day Number.
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      '*MSG'        PRTCD             7
     C                   PARM      '*FIRST'      POPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Handle Database Error.
      *
     C     PRTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVE      'SDBANKPD'    DBFILE
     C                   MOVEL     POPTN         DBKEY
     C                   Z-ADD     1             DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Define key list for read of file
      *
     C     FEKEY1        KLIST
     C                   KFLD                    KFCNUM
     C                   KFLD                    KFFACL
     C                   KFLD                    KFFSEQ
      *
      ** Number of record Printed
      *
     C                   Z-ADD     0             WCOUNT            4 0
      *
      ** Set on the Overflow Indicator
      *
     C                   EVAL      *IN50 = *ON
      *
      ** Set mode status
      *
     C                   IF        WMODE = 'A' or  WMODE = 'a'
     C                   EVAL      *IN09 = *OFF
     C                   ELSE
     C                   EVAL      *IN09 = *ON
     C                   ENDIF
      *
     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      ** *PSSR  - Program exception error routine                     *
      **          Called automatically if a program error occurs,     *
      **          or directly by the program code using EXSR.         *
      **          This subroutine DUMPs the program just once.        *
      ** Called by:                                                   *
      ** Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'
     C                   DUMP
      *
     C                   CALL      'DBERRCTL'
      *
     C                   ENDIF
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C                   ENDSR
      *
