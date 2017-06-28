     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2013')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD FATCA Customer Details Report')               *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD000716P - Midas SD FATCA Customer Details Report           *
      *                                                               *
      *  Function:  This is a new program to list the details of all  *
      *             FATCA Customer Details Report in the system.      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2013            *
      *                                                               *
      *  Last Amend No. MD041709           Date 28Sep16               *      
      *  Prev Amend No. MD030151           Date 05Sep14               *
      *                 MD030165           Date 03Sep14               *
      *                 MD027545           Date 01Aug14               *
      *                 MD027439           Date 18Jun14               *
      *                 MD024592           Date 28Jan14               *
      *                 CGL132  *CREATE    Date 01May13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD041709 - Component SDC000716 failure. Adjusted customer    *
      *             counter to 10 numeric.                            *      
      *  MD030151 - Exceptions with JACM Update - The customer is not *
      *             exempt and flagged as joint account but there is  *
      *             no joint account members defined                  *
      *             Applied fix MD027576 MD027115 MD026790 MD025161   *
      *  MD030165 -  OCBC FATCA - report SD000716P1 is being truncated*
      *              Apply Fix MD026653                               *
      *  MD027545 - Previous FATCA Classification Description is      *
      *             Populated in Reports even if it is not yet Defined*
      *             Applied fix MD028123                              *
      *  MD027439 - US Account Authority Holder field missing         *
      *           - Apply fix MD026607                                *
      *  MD024592 - FATCA Missing Report Programs (Recompile)         *
      *  CGL132 - FATCA Phase 1 - Customers' Identification and       *
      *           Classification - Master                             *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    05  - Overflow Indicator SD000716P1                        *
      *    14  - End of File SDFTCSL1                                 *
      *    54  - At least one set of details output - used for        *
      *          printer file conditioning                            *
      *    80  - Data Base Error Indicator                            *
      *                                                               *
      *  U7+U8 - Data Base Error (job switch)                         *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E   I N D E X                              *
      *                                                               *
      *  SRMAIN - Main Processing                                     *
      *  SRINIT - Initial Processing                                  *
      *  SRTERM - Termination Processing                              *
      *  SRFCP  - File Control Processing                             *
      *  *PSSR  - Error Handling Subroutine                           *
      *  SRCUSTOMER - SD Customer Customer Details processing         *
      *  SRCUSTSET - Set-up the data of customer records and print    *
      *  SROPENP1 - Open printer file                                 *
      *  SRCLOSEP1 - Close printer file                               *
      *  SRBLANKS - Initiate all fields to blanks.                    *
      *  SRDETAILS - Initiate details to fields from database         *
      *  SRZDate2  - Calls ZDATE2 to convert                          *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+                     *
      ** ¦ F-specs                              ¦                     *
      ** ¦ =======                              ¦                     *
      ** +--------------------------------------+                     *
 
      ** Midas SD FATCA Customer Details retrieval index
     FSDFTCSL1  IF   E           K DISK
 
      ** Customer Details Master File Retrieval
     FSDCUSTL1  IF   E           K DISK
 
      ** Midas SD Customer Details Ext C - Keyed                                            MD025161
     FSDCUSXL0  IF   E           K DISK                                                     MD025161
                                                                                            MD025161
      ** Additional customer details retrieval                                              MD025161
     FSDACUSL1  IF   E           K DISK                                                     MD025161
                                                                                            MD025161
      ** RPT: FATCA Customer details report
     FSD000716P1O    E             PRINTER INFSR(*PSSR)
     F                                     OFLIND(*IN05)
     F                                     USROPN
     F                                     INFDS(SPOOL)
 
      ** RPT: FATCA Customer details report audit.
     FSD000716AUO    E             PRINTER INFSR(*PSSR)
     F                                     INFDS(SPOOLU)
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      *
      **------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      ** Data Area giving Installation Control Details
 
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      ** Program Status Data Structure
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** First DS for Access Programs, Short Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Second DS for Aacces Programs, Long Data Structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** Bank Details Accessed via Access Program
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** Midas FATCA Classification Code
     D SDFATC        E DS                  EXTNAME(SDFATCPD)
 
      ** SPOOL Information Data Structure for ZSFILE
     D SPOOL           DS
     D  SFILE                 83     92
     D  SFNUM                123    124B 0
     D  OflLn1               188    189B 0
     D  PrtLn1               367    368B 0
 
      ** SPOOL Information Data Structure for AU
     D SPOOLU          DS
 
     D  SFILEU                83     92
     D  SFNUMU               123    124B 0
 
     D WCOMM           DS
     D  WCOM1                  1     64
     D  WCOM2                 65    128
     D  WCOM3                129    192
     D  WCOM4                193    256
 
     D WDTMST          DS
     D  WWMn                   1      2
     D  WWDy                   3      4
     D  WWYr                   5      6
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D WRUN            S              1
     D DRUND           S              5  0
     D SENTY           S              3
     D***WCustCtr      S              5  0                                                  MD041709
     D***WCustCnt      S              5  0                                                  MD041709
     D WCustCtr        S             10  0                                                  MD041709
     D WCustCnt        S             10  0                                                  MD041709
     D WTempDate       S              5  0
     D @PFTC           S              5
     D WReqLin         S              4P 0
     D WPrvCust        S              6    INZ(*BLANKS)                                     MD026607
 
      ** ZSFILE Parameters
     D ZSERR           S              1
     D ZSNUM           S              6  0
     D KCUST           S              6
 
      ** ZDATE2 Parameters
     D ZDAYNO          S              5  0
     D ZDATE           S              6  0
     D ZADATE          S              7
 
      ** PLIST Parameters
     D PMode           S              1
     D PSeq            S              5
     D PEnty           S              3
     D PIntyp          S              1
 
      ** AOCTRY Parameters
     D PRTCD           S              7
     D POPTN           S              7
     D PDCCD           S              2
     D PCTRY           S              2
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
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
 
      ** Initial Processing
 
     C                   EXSR      SRINIT
 
      ** Main Processing
 
     C                   EXSR      SRMAIN
 
      ** Termination Processing
 
     C                   EXSR      SRTERM
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRMAIN   - Main Processing                                    *
      *            Controls Set-up of SD000716 Details                *
      *            Outputs SD000716 Details                           *
      *                                                               *
      * Called by: Main Routine                                       *
      *                                                               *
      *****************************************************************
 
     C     SRMAIN        BEGSR
 
      ** For customers
 
     C                   EXSR      SRCUSTOMER
     C                   EVAL      *INLR = *ON
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRCUSTOMER - Look up SD Customer Customer Details retrieval   *
      *              index and handles the set-up.                    *
      *                                                               *
      * Called by: SRMAIN                                             *
      *                                                               *
      * Calls: SRCUSTSET, SROPENP1                                    *
      *                                                               *
      *****************************************************************
 
     C     SRCUSTOMER    BEGSR
 
      ** Do unit end of  SD FATCA Customer Details retrieval index.
 
     C                   READ      SDFTCSL1                               14
     C     FACUST        SETLL     SDFTCSL1
     C                   DOW       NOT %EOF (SDFTCSL1)
 
      ** Read through SD FATCA Customer Details retrieval index.
 
     C                   READ      SDFTCSL1                               14
     C                   IF        NOT %EOF (SDFTCSL1)
     C                   EVAL      WCustCtr = WCustCtr + 1
 
      ** Opens printer file once/on first customer reading including the header.
 
     C                   IF        WCustCtr = 1
     C                   EXSR      SROPENP1
     C                   WRITE     SD0716R0
     C                   ENDIF
 
     C                   EXSR      SRCUSTSET
     C                   ENDIF
 
     C                   ENDDO
 
 
     ** Close Printer file if it is open and records have been printed.
 
     C                   EXSR      SRCLOSEP1
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRCUSTSET - Set-ups the data of customer records and print.   *
      *                                                               *
      * Called by: SRCUSTOMER                                         *
      *                                                               *
      * Calls    : *PSSR, SROPENP1, SRBLANKS, SRDETAILS               *
      *                                                               *
      *****************************************************************
 
     C     SRCUSTSET     BEGSR
 
     C     FACUST        CHAIN     SDCUSTL1                           16
     C                   IF        NOT %FOUND (SDCUSTL1)
     C                   EVAL      DBFILE = 'SDCUSTL1'
     C                   EVAL      DBASE = 1
     C**********         EVAL      DBKEY = '*FIRST'                                         MD026653
     C                   EVAL      DBKEY = FACUST                                           MD026653
     C                   EXSR      *PSSR
     C                   ELSE
 
      ***customer*no,*customer*shortname,*report*name,*report*town.****                     MD026653
 
     C**********         EVAL      DDCUST = FACUST                                          MD026653
     C**********         EVAL      DDCSSN = BBCSSN                                          MD026653
     C**********         EVAL      DDCRNM = BBCRNM                                          MD026653
     C**********         EVAL      DDCRTN = BBCRTN                                          MD026653
                                                                                            MD025161
     ** Add-on Country of Citizenship and Country of Domicile                               MD025161
                                                                                            MD025161
     C                   EVAL      DDCNCZ = *BLANKS                                         MD025161
     C                   EVAL      DDCOLC = *BLANKS                                         MD025161
     C                   EVAL      DDCNCZ = BBCNCZ                                          MD025161
     C                   EVAL      DDCOLC = BBCOLC                                          MD025161
 
     C                   ENDIF
 
      ** Report in List or Audit Mode
 
     C                   IF        (PMode = 'A' AND BBLCD = BJRDNB)
     C                             OR PMode = 'L' OR PMode = ' '
                                                                                            MD026653
      ** customer no, customer shortname, report name, report town.                         MD026653
                                                                                            MD026653
     C                   EVAL      DDCUST = FACUST                                          MD026653
     C                   EVAL      DDCSSN = BBCSSN                                          MD026653
     C                   EVAL      DDCRNM = BBCRNM                                          MD026653
     C                   EVAL      DDCRTN = BBCRTN                                          MD026653
 
      ** Initiate fields to blanks before writing details.
 
     C                   EXSR      SRBLANKS
 
      ** Invoke records from database to fields.
 
     C                   EXSR      SRDETAILS
 
      ** Display Customer details and information.
      ** Print Header and customer details if overflow occurs.
 
     C                   EVAL      WReqLin = 2
     C                   IF        PrtLn1 + WReqLin >= OflLn1
     C                             or ( WPrvCust <> DDCUST                                  MD026607
     C                             and WPrvCust <> *BLANKS)                                 MD026607
     C                   EXSR      SROVRFLOW
     C                   ELSE
     C                   WRITE     SD0716R1
     C                   ENDIF
 
     C                   EVAL      WReqLin = 4
     C                   IF        PrtLn1 + WReqLin >= OflLn1
     C                   EXSR      SROVRFLOW
     C                   ENDIF
     C                   WRITE     SD0716R2
 
     C                   EVAL      WReqLin = 4
     C                   IF        PrtLn1 + WReqLin >= OflLn1
     C                   EXSR      SROVRFLOW
     C                   ENDIF
     C                   WRITE     SD0716R3
 
     C                   EVAL      WReqLin = 4
     C                   IF        PrtLn1 + WReqLin >= OflLn1
     C                   EXSR      SROVRFLOW
     C                   ENDIF
     C                   WRITE     SD0716R4
 
     C**********         EVAL      WReqLin = 4                                              MD025161
     C                   EVAL      WReqLin = 5                                              MD025161
     C                   IF        PrtLn1 + WReqLin >= OflLn1
     C                   EXSR      SROVRFLOW
     C                   ENDIF
     C                   WRITE     SD0716R5
 
     C                   EVAL      WReqLin = 3
     C                   IF        PrtLn1 + WReqLin >= OflLn1
     C                   EXSR      SROVRFLOW
     C                   ENDIF
     C                   WRITE     SD0716R6
 
     C                   EVAL      WReqLin = 3
     C                   IF        PrtLn1 + WReqLin >= OflLn1
     C                   EXSR      SROVRFLOW
     C                   ENDIF
     C                   WRITE     SD0716R7
 
     C                   EVAL      WReqLin = 3
     C                   IF        PrtLn1 + WReqLin >= OflLn1
     C                   EXSR      SROVRFLOW
     C                   ENDIF
     C                   WRITE     SD0716R8
 
     C                   EVAL      WReqLin = 3
     C                   IF        PrtLn1 + WReqLin >= OflLn1
     C                   EXSR      SROVRFLOW
     C                   ENDIF
     C                   WRITE     SD0716R9
 
     C                   EVAL      WReqLin = 3
     C                   IF        PrtLn1 + WReqLin >= OflLn1
     C                   EXSR      SROVRFLOW
     C                   ENDIF
     C                   WRITE     SD0716R10
 
     C                   EVAL      WReqLin = 3
     C                   IF        PrtLn1 + WReqLin >= OflLn1
     C                   EXSR      SROVRFLOW
     C                   ENDIF
     C                   WRITE     SD0716R11
 
     C                   EVAL      WReqLin = 3
     C                   IF        PrtLn1 + WReqLin >= OflLn1
     C                   EXSR      SROVRFLOW
     C                   ENDIF
     C                   WRITE     SD0716R12
 
     C                   EVAL      WReqLin = 3
     C                   IF        PrtLn1 + WReqLin >= OflLn1
     C                   EXSR      SROVRFLOW
     C                   ENDIF
     C                   WRITE     SD0716R13
 
     C                   EVAL      WReqLin = 3
     C                   IF        PrtLn1 + WReqLin >= OflLn1
     C                   EXSR      SROVRFLOW
     C                   ENDIF
     C                   WRITE     SD0716R14
 
     C                   EVAL      WReqLin = 3
     C                   IF        PrtLn1 + WReqLin >= OflLn1
     C                   EXSR      SROVRFLOW
     C                   ENDIF
     C                   WRITE     SD0716R15
 
     C                   EVAL      WReqLin = 3
     C                   IF        PrtLn1 + WReqLin >= OflLn1
     C                   EXSR      SROVRFLOW
     C                   ENDIF
     C                   WRITE     SD0716R16
 
     C                   EVAL      WReqLin = 3
     C                   IF        PrtLn1 + WReqLin >= OflLn1
     C                   EXSR      SROVRFLOW
     C                   ENDIF
     C                   WRITE     SD0716R17
                                                                                            MD026607
     C                   EVAL      WReqLin = 3                                              MD026607
     C                   IF        PrtLn1 + WReqLin >= OflLn1                               MD026607
     C                   EXSR      SROVRFLOW                                                MD026607
     C                   ENDIF                                                              MD026607
     C                   WRITE     SD0716R19                                                MD026607
 
     C                   EVAL      WCustCnt = WCustCnt + 1
     C                   EVAL      WPrvCust = DDCUST                                        MD026607
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SROVRFLOW - Prints Title and Customer Details if Overflow     *
      *                                                               *
      * Called by: SRCUSTSET                                          *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SROVRFLOW     BEGSR
      *
      ** Prints title and customer details
      *
     C                   WRITE     SD0716R0
     C                   WRITE     SD0716R1
 
     C                   ENDSR
 
      *****************************************************************
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SROPENP1 - Open printer file SD000716P1                       *
      *                                                               *
      * Called by: SRCUSTSET                                          *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SROPENP1      BEGSR
 
      ** open printer file and indicate that there is atleast one
      ** detail to report; ensure report spool file recorded by RCF
 
     C                   IF        NOT %OPEN (SD000716P1)
     C                   OPEN      SD000716P1
 
     C                   Z-ADD     SFNUM         ZSNUM
     C                   CALL      'ZSFILE'
     C                   PARM                    PSEQ
     C                   PARM      *BLANKS       SENTY
     C                   PARM                    SFILE
     C                   PARM                    ZSNUM
     C                   PARM                    ZSERR
 
      ** error during ZSFILE processing, return to calling program
 
     C                   IF        ZSERR = 'Y'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRCLOSEP1 - Closes printer file SD000716P1                    *
      *                                                               *
      * Called by: SRCUSTOMER                                         *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SRCLOSEP1     BEGSR
 
     C                   IF        %OPEN (SD000716P1)
     C                   EVAL      WReqLin = 2
     C                   IF        PrtLn1 + WReqLin >= OflLn1
     C**********         EXSR      SROVRFLOW                                                MD026653
     C                   WRITE     SD0716R0                                                 MD026653
     C                   ENDIF
     C                   WRITE     SD0716R18
     C                   CLOSE     SD000716P1
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRBLANKS - Initiate all fields to blanks.                     *
      *                                                               *
      * Called by: SRCUSTSET                                          *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SRBLANKS      BEGSR
                                                                                            MD026607
      ** US Indicia of Authority Holder Details                                             MD026607
                                                                                            MD026607
     C                   EVAL      DDAUSV = *BLANKS                                         MD026607
     C                   EVAL      DDAUOV = *BLANKS                                         MD026607
     C                   EVAL      DDAUD1 = *BLANKS                                         MD026607
     C                   EVAL      DDAUD2 = *BLANKS                                         MD026607
     C                   EVAL      DDAUD3 = *BLANKS                                         MD026607
     C                   EVAL      DDAUD4 = *BLANKS                                         MD026607
     C                   EVAL      DDAUD5 = *BLANKS                                         MD026607
     C                   EVAL      DDAUON = *BLANKS                                         MD026607
     C                   EVAL      DDAUC1 = *BLANKS                                         MD026607
     C                   EVAL      DDAUC2 = *BLANKS                                         MD026607
 
      ** US Indicia of US Hold Mail details
 
     C                   EVAL      DDHMSV = *BLANKS
     C                   EVAL      DDHMOV = *BLANKS
     C                   EVAL      DDHMD1 = *BLANKS
     C                   EVAL      DDHMD2 = *BLANKS
     C                   EVAL      DDHMD3 = *BLANKS
     C                   EVAL      DDHMD4 = *BLANKS
     C                   EVAL      DDHMD5 = *BLANKS
     C                   EVAL      DDHMON = *BLANKS
     C                   EVAL      DDHMC1 = *BLANKS
     C                   EVAL      DDHMC2 = *BLANKS
 
      ** US Indicia of Mailing Country details
 
     C                   EVAL      DDMCSV = *BLANKS
     C                   EVAL      DDMCOV = *BLANKS
     C                   EVAL      DDMCD1 = *BLANKS
     C                   EVAL      DDMCD2 = *BLANKS
     C                   EVAL      DDMCD3 = *BLANKS
     C                   EVAL      DDMCD4 = *BLANKS
     C                   EVAL      DDMCD5 = *BLANKS
     C                   EVAL      DDMCON = *BLANKS
     C                   EVAL      DDMCC1 = *BLANKS
     C                   EVAL      DDMCC2 = *BLANKS
 
      ** US Indicia of Regular Payment Ins. to US details
 
     C                   EVAL      DDRPSV = *BLANKS
     C                   EVAL      DDRPOV = *BLANKS
     C                   EVAL      DDRPD1 = *BLANKS
     C                   EVAL      DDRPD2 = *BLANKS
     C                   EVAL      DDRPD3 = *BLANKS
     C                   EVAL      DDRPD4 = *BLANKS
     C                   EVAL      DDRPD5 = *BLANKS
     C                   EVAL      DDRPON = *BLANKS
     C                   EVAL      DDRPC1 = *BLANKS
     C                   EVAL      DDRPC2 = *BLANKS
 
      ** US Indicia of Citizenship details
 
     C                   EVAL      DDCISV = *BLANKS
     C                   EVAL      DDCIOV = *BLANKS
     C                   EVAL      DDCID1 = *BLANKS
     C                   EVAL      DDCID2 = *BLANKS
     C                   EVAL      DDCID3 = *BLANKS
     C                   EVAL      DDCID4 = *BLANKS
     C                   EVAL      DDCID5 = *BLANKS
     C                   EVAL      DDCION = *BLANKS
     C                   EVAL      DDCIC1 = *BLANKS
     C                   EVAL      DDCIC2 = *BLANKS
 
      ** US Indicia of US Country of Birth details
 
     C                   EVAL      DDCBSV = *BLANKS
     C                   EVAL      DDCBOV = *BLANKS
     C                   EVAL      DDCBD1 = *BLANKS
     C                   EVAL      DDCBD2 = *BLANKS
     C                   EVAL      DDCBD3 = *BLANKS
     C                   EVAL      DDCBD4 = *BLANKS
     C                   EVAL      DDCBD5 = *BLANKS
     C                   EVAL      DDCBON = *BLANKS
     C                   EVAL      DDCBC1 = *BLANKS
     C                   EVAL      DDCBC2 = *BLANKS
 
      ** US Indicia of US Country of Domicile details
 
     C                   EVAL      DDCDSV = *BLANKS
     C                   EVAL      DDCDOV = *BLANKS
     C                   EVAL      DDCDD1 = *BLANKS
     C                   EVAL      DDCDD2 = *BLANKS
     C                   EVAL      DDCDD3 = *BLANKS
     C                   EVAL      DDCDD4 = *BLANKS
     C                   EVAL      DDCDD5 = *BLANKS
     C                   EVAL      DDCDON = *BLANKS
     C                   EVAL      DDCDC1 = *BLANKS
     C                   EVAL      DDCDC2 = *BLANKS
 
      ** US Indicia of US Green Card details
 
     C                   EVAL      DDGCSV = *BLANKS
     C                   EVAL      DDGCOV = *BLANKS
     C                   EVAL      DDGCD1 = *BLANKS
     C                   EVAL      DDGCD2 = *BLANKS
     C                   EVAL      DDGCD3 = *BLANKS
     C                   EVAL      DDGCD4 = *BLANKS
     C                   EVAL      DDGCD5 = *BLANKS
     C                   EVAL      DDGCON = *BLANKS
     C                   EVAL      DDGCC1 = *BLANKS
     C                   EVAL      DDGCC2 = *BLANKS
 
      ** US Indicia of Citizenship details
 
     C                   EVAL      DDIDSV = *BLANKS
     C                   EVAL      DDIDOV = *BLANKS
     C                   EVAL      DDIDD1 = *BLANKS
     C                   EVAL      DDIDD2 = *BLANKS
     C                   EVAL      DDIDD3 = *BLANKS
     C                   EVAL      DDIDD4 = *BLANKS
     C                   EVAL      DDIDD5 = *BLANKS
     C                   EVAL      DDIDON = *BLANKS
     C                   EVAL      DDIDC1 = *BLANKS
     C                   EVAL      DDIDC2 = *BLANKS
 
      ** US Indicia of US Joint Account Member details
 
     C                   EVAL      DDJASV = *BLANKS
     C                   EVAL      DDJAOV = *BLANKS
     C                   EVAL      DDJAD1 = *BLANKS
     C                   EVAL      DDJAD2 = *BLANKS
     C                   EVAL      DDJAD3 = *BLANKS
     C                   EVAL      DDJAD4 = *BLANKS
     C                   EVAL      DDJAD5 = *BLANKS
     C                   EVAL      DDJAON = *BLANKS
     C                   EVAL      DDJAC1 = *BLANKS
     C                   EVAL      DDJAC2 = *BLANKS
 
      ** US Indicia of US Telephone details
 
     C                   EVAL      DDTESV = *BLANKS
     C                   EVAL      DDTEOV = *BLANKS
     C                   EVAL      DDTED1 = *BLANKS
     C                   EVAL      DDTED2 = *BLANKS
     C                   EVAL      DDTED3 = *BLANKS
     C                   EVAL      DDTED4 = *BLANKS
     C                   EVAL      DDTED5 = *BLANKS
     C                   EVAL      DDTEON = *BLANKS
     C                   EVAL      DDTEC1 = *BLANKS
     C                   EVAL      DDTEC2 = *BLANKS
 
      ** US Indicia of US Tax Identification Number  details
 
     C                   EVAL      DDTXSV = *BLANKS
     C                   EVAL      DDTXOV = *BLANKS
     C                   EVAL      DDTXD1 = *BLANKS
     C                   EVAL      DDTXD2 = *BLANKS
     C                   EVAL      DDTXD3 = *BLANKS
     C                   EVAL      DDTXD4 = *BLANKS
     C                   EVAL      DDTXD5 = *BLANKS
     C                   EVAL      DDTXON = *BLANKS
     C                   EVAL      DDTXC1 = *BLANKS
     C                   EVAL      DDTXC2 = *BLANKS
 
      ** Other FATCA details.
 
     C                   EVAL      DDCLAC = *BLANKS
     C                   EVAL      DDCLDS = *BLANKS
     C                   EVAL      DDPCLA = *BLANKS
     C                   EVAL      DDPFCE = *BLANKS
     C                   EVAL      DDEXEM = *BLANKS
     C                   EVAL      DDEXEU = *BLANKS
     C                   EVAL      DDEXE1 = *BLANKS
     C                   EVAL      DDEXE2 = *BLANKS
     C                   EVAL      DDEXE3 = *BLANKS
     C                   EVAL      DDEXE4 = *BLANKS
     C                   EVAL      DDRPTT = *BLANKS
     C                   EVAL      DDRPDE = *BLANKS
     C                   EVAL      DDRPTU = *BLANKS
     C                   EVAL      DDRPT1 = *BLANKS
     C                   EVAL      DDRPT2 = *BLANKS
     C                   EVAL      DDGIIN = *BLANKS
     C                   EVAL      DDGIIO = *BLANKS
     C                   EVAL      DDUTIN = *BLANKS
     C                   EVAL      DDMAIL = *BLANKS
     C                   EVAL      DDPHON = *BLANKS
     C                   EVAL      DDGREC = *BLANKS
     C                   EVAL      DDHVAC = *BLANKS
     C                   EVAL      DDCSTP = *BLANKS
     C                   EVAL      DDCSTD = *BLANKS
     C                   EVAL      DDCSST = *BLANKS
     C                   EVAL      DDCSSD = *BLANKS
     C                   EVAL      DDREPT = *BLANKS
     C                   EVAL      DDINFC = *BLANKS
     C                   EVAL      DDEXMA = *BLANKS
     C                   EVAL      DDACCZ = *BLANKS                                         MD025161
     C                   EVAL      DDBRTH = *BLANKS                                         MD025161
     C                   EVAL      DDBTHT = *BLANKS                                         MD025161
     C                   EVAL      DDCBTH = *BLANKS                                         MD025161
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRDETAILS - Initiate details to fields from database          *
      *                                                               *
      * Called by: SRCUSTSET                                          *
      *                                                               *
      * Calls: SRZDate2                                               *
      *                                                               *
      *****************************************************************
 
     C     SRDETAILS     BEGSR
                                                                                            MD026607
      ** US Indicia of Authority Holder Details                                             MD026607
                                                                                            MD026607
     C                   EVAL      DDAUSV = FAAUSV                                          MD026607
     C                   EVAL      WTempDate = FAAUSD                                       MD026607
     C                   EXSR      SRZDate2                                                 MD026607
     C                   IF        ZDATE > 0                                                MD026607
     C                   MOVEL     ZADATE        DDAUSD                                     MD026607
     C                   ELSE                                                               MD026607
     C                   EVAL      DDAUSD = *BLANKS                                         MD026607
     C                   ENDIF                                                              MD026607
     C                   MOVEL     FAAUST        DDAUST                                     MD026607
     C                   EVAL      DDAUOV = FAAUOV                                          MD026607
     C                   EVAL      DDAUD1 = FAAUD1                                          MD026607
     C                   EVAL      DDAUD2 = FAAUD2                                          MD026607
     C                   EVAL      DDAUD3 = FAAUD3                                          MD026607
     C                   EVAL      DDAUD4 = FAAUD4                                          MD026607
     C                   EVAL      DDAUD5 = FAAUD5                                          MD026607
     C                   EVAL      DDAUON = FAAUON                                          MD026607
     C                   EVAL      WTempDate = FAAUOD                                       MD026607
     C                   EXSR      SRZDate2                                                 MD026607
                                                                                            MD026607
     C                   IF        ZDATE > 0                                                MD026607
     C                   MOVEL     ZADATE        DDAUOD                                     MD026607
     C                   ELSE                                                               MD026607
     C                   EVAL      DDAUOD = *BLANKS                                         MD026607
     C                   ENDIF                                                              MD026607
                                                                                            MD026607
     C                   MOVEL     FAAUOT        DDAUOM                                     MD026607
     C                   EVAL      DDAUC1 = FAAUCO                                          MD026607
     C                   EVALR     DDAUC2 = FAAUCO                                          MD026607
 
      ** US Indicia of US Hold Mail details
 
     C                   EVAL      DDHMSV = FAHMSV
     C                   EVAL      WTempDate = FAHMSD
     C                   EXSR      SRZDate2
     C                   IF        ZDATE > 0
     C                   MOVEL     ZADATE        DDHMSD
     C                   ELSE
     C                   EVAL      DDHMSD = *BLANKS
     C                   ENDIF
     C                   MOVEL     FAHMST        DDHMST
     C                   EVAL      DDHMOV = FAHMOV
     C                   EVAL      DDHMD1 = FAHMD1
     C                   EVAL      DDHMD2 = FAHMD2
     C                   EVAL      DDHMD3 = FAHMD3
     C                   EVAL      DDHMD4 = FAHMD4
     C                   EVAL      DDHMD5 = FAHMD5
     C                   EVAL      DDHMON = FAHMON
     C                   EVAL      WTempDate = FAHMOD
     C                   EXSR      SRZDate2
 
     C                   IF        ZDATE > 0
     C                   MOVEL     ZADATE        DDHMOD
     C                   ELSE
     C                   EVAL      DDHMOD = *BLANKS
     C                   ENDIF
 
     C                   MOVEL     FAHMOT        DDHMOM
     C                   EVAL      DDHMC1 = FAHMCO
     C                   EVALR     DDHMC2 = FAHMCO
 
      ** US Indicia of Mailing Country details
 
     C                   EVAL      DDMCSV = FAMCSV
     C                   EVAL      WTempDate = FAMCSD
     C                   EXSR      SRZDate2
 
     C                   IF        ZDATE > 0
     C                   MOVEL     ZADATE        DDMCSD
     C                   ELSE
     C                   EVAL      DDMCSD = *BLANKS
     C                   ENDIF
     C
     C                   MOVEL     FAMCST        DDMCST
     C                   EVAL      DDMCOV = FAMCOV
     C                   EVAL      DDMCD1 = FAMCD1
     C                   EVAL      DDMCD2 = FAMCD2
     C                   EVAL      DDMCD3 = FAMCD3
     C                   EVAL      DDMCD4 = FAMCD4
     C                   EVAL      DDMCD5 = FAMCD5
     C                   EVAL      DDMCON = FAMCON
     C                   EVAL      WTempDate = FAMCOD
     C                   EXSR      SRZDate2
 
     C                   IF        ZDATE > 0
     C                   MOVEL     ZADATE        DDMCOD
     C                   ELSE
     C                   EVAL      DDMCOD = *BLANKS
     C                   ENDIF
 
     C                   MOVEL     FAMCOT        DDMCMM
     C                   EVAL      DDMCC1 = FAMCCO
     C                   EVALR     DDMCC2 = FAMCCO
 
      ** US Indicia of Regular Payment Ins. to US details
 
     C                   EVAL      DDRPSV = FARPSV
     C                   EVAL      WTempDate = FARPSD
     C                   EXSR      SRZDate2
 
     C                   IF        ZDATE > 0
     C                   MOVEL     ZADATE        DDRPSD
     C                   ELSE
     C                   EVAL      DDRPSD = *BLANKS
     C                   ENDIF
 
     C                   MOVEL     FARPST        DDRPST
     C                   EVAL      DDRPOV = FARPOV
     C                   EVAL      DDRPD1 = FARPD1
     C                   EVAL      DDRPD2 = FARPD2
     C                   EVAL      DDRPD3 = FARPD3
     C                   EVAL      DDRPD4 = FARPD4
     C                   EVAL      DDRPD5 = FARPD5
     C                   EVAL      DDRPON = FARPON
     C                   EVAL      WTempDate = FARPOD
     C                   EXSR      SRZDate2
 
     C                   IF        ZDATE > 0
     C                   MOVEL     ZADATE        DDRPOD
     C                   ELSE
     C                   EVAL      DDRPOD = *BLANKS
     C                   ENDIF
 
     C                   MOVEL     FARPOT        DDRPOM
     C                   EVAL      DDRPC1 = FARPCO
     C                   EVALR     DDRPC2 = FARPCO
 
      ** US Indicia of Citizenship details
 
     C                   EVAL      DDCISV = FACISV
     C                   EVAL      WTempDate = FACISD
     C                   EXSR      SRZDate2
 
     C                   IF        ZDATE > 0
     C                   MOVEL     ZADATE        DDCISD
     C                   ELSE
     C                   EVAL      DDCISD = *BLANKS
     C                   ENDIF
 
     C                   MOVEL     FACIST        DDCIST
     C                   EVAL      DDCIOV = FACIOV
     C                   EVAL      DDCID1 = FACID1
     C                   EVAL      DDCID2 = FACID2
     C                   EVAL      DDCID3 = FACID3
     C                   EVAL      DDCID4 = FACID4
     C                   EVAL      DDCID5 = FACID5
     C                   EVAL      DDCION = FACION
     C                   EVAL      WTempDate = FACIOD
     C                   EXSR      SRZDate2
 
     C                   IF        ZDATE > 0
     C                   MOVEL     ZADATE        DDCIOD
     C                   ELSE
     C                   EVAL      DDCIOD = *BLANKS
     C                   ENDIF
 
     C                   MOVEL     FACIOT        DDCIOM
     C                   EVAL      DDCIC1 = FACICO
     C                   EVALR     DDCIC2 = FACICO
 
      ** US Indicia of US Country of Birth details
 
     C                   EVAL      DDCBSV = FACBSV
     C                   EVAL      WTempDate = FACBSD
     C                   EXSR      SRZDate2
 
     C                   IF        ZDATE > 0
     C                   MOVEL     ZADATE        DDCBSD
     C                   ELSE
     C                   EVAL      DDCBSD = *BLANKS
     C                   ENDIF
 
     C                   MOVEL     FACBST        DDCBST
     C                   EVAL      DDCBOV = FACBOV
     C                   EVAL      DDCBD1 = FACBD1
     C                   EVAL      DDCBD2 = FACBD2
     C                   EVAL      DDCBD3 = FACBD3
     C                   EVAL      DDCBD4 = FACBD4
     C                   EVAL      DDCBD5 = FACBD5
     C                   EVAL      DDCBON = FACBON
     C                   EVAL      WTempDate = FACBOD
     C                   EXSR      SRZDate2
 
     C                   IF        ZDATE > 0
     C                   MOVEL     ZADATE        DDCBOD
     C                   ELSE
     C                   EVAL      DDCBOD = *BLANKS
     C                   ENDIF
 
     C                   MOVEL     FACBOT        DDCBOM
     C                   EVAL      DDCBC1 = FACBCO
     C                   EVALR     DDCBC2 = FACBCO
 
      ** US Indicia of US Country of Domicile details
 
     C                   EVAL      DDCDSV = FACDSV
     C                   EVAL      WTempDate = FACDSD
     C                   EXSR      SRZDate2
 
     C                   IF        ZDATE > 0
     C                   MOVEL     ZADATE        DDCDSD
     C                   ELSE
     C                   EVAL      DDCDSD = *BLANKS
     C                   ENDIF
 
     C                   MOVEL     FACDST        DDCDST
     C                   EVAL      DDCDOV = FACDOV
     C                   EVAL      DDCDD1 = FACDD1
     C                   EVAL      DDCDD2 = FACDD2
     C                   EVAL      DDCDD3 = FACDD3
     C                   EVAL      DDCDD4 = FACDD4
     C                   EVAL      DDCDD5 = FACDD5
     C                   EVAL      DDCDON = FACDON
     C                   EVAL      WTempDate = FACDOD
     C                   EXSR      SRZDate2
 
     C                   IF        ZDATE > 0
     C                   MOVEL     ZADATE        DDCDOD
     C                   ELSE
     C                   EVAL      DDCDOD = *BLANKS
     C                   ENDIF
 
     C                   MOVEL     FACDOT        DDCDMM
     C                   EVAL      DDCDC1 = FACDCO
     C                   EVALR     DDCDC2 = FACDCO
 
      ** US Indicia of US Green Card details
 
     C                   EVAL      DDGCSV = FAGCSV
     C                   EVAL      WTempDate = FAGCSD
     C                   EXSR      SRZDate2
 
     C                   IF        ZDATE > 0
     C                   MOVEL     ZADATE        DDGCSD
     C                   ELSE
     C                   EVAL      DDGCSD =  *BLANKS
     C                   ENDIF
 
     C                   MOVEL     FAGCST        DDGCST
     C                   EVAL      DDGCOV = FAGCOV
     C                   EVAL      DDGCD1 = FAGCD1
     C                   EVAL      DDGCD2 = FAGCD2
     C                   EVAL      DDGCD3 = FAGCD3
     C                   EVAL      DDGCD4 = FAGCD4
     C                   EVAL      DDGCD5 = FAGCD5
     C                   EVAL      DDGCON = FAGCON
     C                   EVAL      WTempDate = FAGCOD
     C                   EXSR      SRZDate2
 
     C                   IF        ZDATE > 0
     C                   MOVEL     ZADATE        DDGCOD
     C                   ELSE
     C                   EVAL      DDGCOD = *BLANKS
     C                   ENDIF
 
     C                   MOVEL     FAGCOT        DDGCOM
     C                   EVAL      DDGCC1 = FAGCCO
     C                   EVALR     DDGCC2 = FAGCCO
 
      ** US Indicia of Citizenship details
 
     C                   EVAL      DDIDSV = FAIDSV
     C                   EVAL      WTempDate = FAIDSD
     C                   EXSR      SRZDate2
 
     C                   IF        ZDATE > 0
     C                   MOVEL     ZADATE        DDIDSD
     C                   ELSE
     C                   EVAL      DDIDSD = *BLANKS
     C                   ENDIF
 
     C                   MOVEL     FAIDST        DDIDST
     C                   EVAL      DDIDOV = FAIDOV
     C                   EVAL      DDIDD1 = FAIDD1
     C                   EVAL      DDIDD2 = FAIDD2
     C                   EVAL      DDIDD3 = FAIDD3
     C                   EVAL      DDIDD4 = FAIDD4
     C                   EVAL      DDIDD5 = FAIDD5
     C                   EVAL      DDIDON = FAIDON
     C                   EVAL      WTempDate = FAIDOD
     C                   EXSR      SRZDate2
 
     C                   IF        ZDATE > 0
     C                   MOVEL     ZADATE        DDIDOD
     C                   ELSE
     C                   EVAL      DDIDOD = *BLANKS
     C                   ENDIF
 
     C                   MOVEL     FAIDOT        DDIDOM
     C                   EVAL      DDIDC1 = FAIDCO
     C                   EVALR     DDIDC2 = FAIDCO
 
      ** US Indicia of US Joint Account Member details
 
     C                   EVAL      DDJASV = FAJASV
     C                   EVAL      WTempDate = FAJASD
     C                   EXSR      SRZDate2
 
     C                   IF        ZDATE > 0
     C                   MOVEL     ZADATE        DDJASD
     C                   ELSE
     C                   EVAL      DDJASD = *BLANKS
     C                   ENDIF
 
     C                   MOVEL     FAJAST        DDJAST
     C                   EVAL      DDJAOV = FAJAOV
     C                   EVAL      DDJAD1 = FAJAD1
     C                   EVAL      DDJAD2 = FAJAD2
     C                   EVAL      DDJAD3 = FAJAD3
     C                   EVAL      DDJAD4 = FAJAD4
     C                   EVAL      DDJAD5 = FAJAD5
     C                   EVAL      DDJAON = FAJAON
     C                   EVAL      WTempDate = FAJAOD
     C                   EXSR      SRZDate2
 
     C                   IF        ZDATE > 0
     C                   MOVEL     ZADATE        DDJAOD
     C                   ELSE
     C                   EVAL      DDJAOD = *BLANKS
     C                   ENDIF
 
     C                   MOVEL     FAJAOT        DDJAMM
     C                   EVAL      DDJAC1 = FAJACO
     C                   EVALR     DDJAC2 = FAJACO
 
      ** US Indicia of US Telephone details
 
     C                   EVAL      DDTESV = FATESV
     C                   EVAL      WTempDate = FATESD
     C                   EXSR      SRZDate2
 
     C                   IF        ZDATE > 0
     C                   MOVEL     ZADATE        DDTESD
     C                   ELSE
     C                   EVAL      DDTESD = *BLANKS
     C                   ENDIF
 
     C                   MOVEL     FATEST        DDTEST
     C                   EVAL      DDTEOV = FATEOV
     C                   EVAL      DDTED1 = FATED1
     C                   EVAL      DDTED2 = FATED2
     C                   EVAL      DDTED3 = FATED3
     C                   EVAL      DDTED4 = FATED4
     C                   EVAL      DDTED5 = FATED5
     C                   EVAL      DDTEON = FATEON
     C                   EVAL      WTempDate = FATEOD
     C                   EXSR      SRZDate2
 
     C                   IF        ZDATE > 0
     C                   MOVEL     ZADATE        DDTEOD
     C                   ELSE
     C                   EVAL      DDTEOD = *BLANKS
     C                   ENDIF
 
     C                   MOVEL     FATEOT        DDTEOM
     C                   EVAL      DDTEC1 = FATECO
     C                   EVALR     DDTEC2 = FATECO
 
      ** US Indicia of US Tax Identification Number  details
 
     C                   EVAL      DDTXSV = FATXSV
     C                   EVAL      WTempDate = FATXSD
     C                   EXSR      SRZDate2
 
     C                   IF        ZDATE > 0
     C                   MOVEL     ZADATE        DDTXSD
     C                   ELSE
     C                   EVAL      DDTXSD = *BLANKS
     C                   ENDIF
 
     C                   MOVEL     FATXST        DDTXST
     C                   EVAL      DDTXOV = FATXOV
     C                   EVAL      DDTXD1 = FATXD1
     C                   EVAL      DDTXD2 = FATXD2
     C                   EVAL      DDTXD3 = FATXD3
     C                   EVAL      DDTXD4 = FATXD4
     C                   EVAL      DDTXD5 = FATXD5
     C                   EVAL      DDTXON = FATXON
     C                   EVAL      WTempDate = FATXOD
     C                   EXSR      SRZDate2
 
     C                   IF        ZDATE > 0
     C                   MOVEL     ZADATE        DDTXOD
     C                   ELSE
     C                   EVAL      DDTXOD = *BLANKS
     C                   ENDIF
 
     C                   MOVEL     FATXOT        DDTXOM
     C                   EVAL      DDTXC1 = FATXCO
     C                   EVALR     DDTXC2 = FATXCO
 
      ** Other FATCA details.
 
     C                   EVAL      DDCLAC = FACLAC
     C                   EVAL      WTempDate = FACLAD
     C                   EXSR      SRZDate2
 
     C                   IF        ZDATE > 0
     C                   MOVEL     ZADATE        DDCLAF
     C                   ELSE
     C                   EVAL      DDCLAF = *BLANKS
     C                   ENDIF
 
     C                   EVAL      DDPCLA = FAPCLA
     C                   EVAL      DDEXEM = FAEXEM
     C                   EVAL      WTempDate = FAEXED
     C                   EXSR      SRZDate2
 
     C                   IF        ZDATE > 0
     C                   MOVEL     ZADATE        DDEXED
     C                   ELSE
     C                   EVAL      DDEXED = *BLANKS
     C                   ENDIF
 
     C                   MOVEL     FAEXET        DDEXET
     C                   EVAL      DDEXEU = FAEXEU
     C                   EVAL      DDEXE1 = %SUBST(FAEXER:1:64)
     C                   EVAL      DDEXE2 = %SUBST(FAEXER:65:64)
     C                   EVAL      DDEXE3 = %SUBST(FAEXER:129:64)
     C                   EVALR     DDEXE4 = %SUBST(FAEXER:193:64)
     C                   EVAL      DDRPTT = FARPTT
      *
      ** Load reporting type description values.
      *
     C                   IF        DDRPTT = 'C'
     C                   EVAL      DDRPDE = 'ConsentReceived'
     C                   ENDIF
     C                   IF        DDRPTT = 'N'
     C                   EVAL      DDRPDE = 'Not Relevant'
     C                   ENDIF
     C                   IF        DDRPTT = 'P'
     C                   EVAL      DDRPDE = 'Pending'
     C                   ENDIF
     C                   IF        DDRPTT = 'R'
     C                   EVAL      DDRPDE = 'Recalcitrant'
     C                   ENDIF
     C                   IF        DDRPTT = 'U'
     C                   EVAL      DDRPDE = 'Unknown'
     C                   ENDIF
     C                   EVAL      WTempDate = FARPTD
     C                   EXSR      SRZDate2
 
     C                   IF        ZDATE > 0
     C                   MOVEL     ZADATE        DDRPTD
     C                   ELSE
     C                   EVAL      DDRPTD = *BLANKS
     C                   ENDIF
 
     C                   MOVEL     FARPTM        DDRPTM
     C                   EVAL      DDRPTU = FARPTU
     C                   EVAL      DDRPT1 = FARPTR
     C                   EVALR     DDRPT2 = FARPTR
     C                   EVAL      DDGIIN = FAGIIN
     C                   EVAL      WTempDate = FAGIID
     C                   EXSR      SRZDate2
 
     C                   IF        ZDATE > 0
     C                   MOVEL     ZADATE        DDGIIF
     C                   ELSE
     C                   EVAL      DDGIIF = *BLANKS
     C                   ENDIF
 
     C                   EVAL      DDGIIO = FAGIIO
     C                   EVAL      DDUTIN = FAUTIN
     C                   EVAL      DDMAIL = FAMAIL
     C                   EVAL      DDPHON = FAPHON
     C                   EVAL      DDGREC = FAGREC
     C                   EVAL      DDHVAC = FAHVAC
     C                   EVAL      DDCSTP = FACSTY
      *
      ** Load FATCA Customer Type Description
      *
     C                   IF        DDCSTP = 'F'
     C                   EVAL      DDCSTD = 'Foreign Financial +
     C                                      Institution'
     C                   ENDIF
 
     C                   IF        DDCSTP = 'N'
     C                   EVAL      DDCSTD = 'Non-financial +
     C                                      Entity'
     C                   ENDIF
 
     C                   IF        DDCSTP = 'P'
     C                   EVAL      DDCSTD = 'Physical Person'
     C                   ENDIF
 
     C                   IF        DDCSTP = 'J'
     C                   EVAL      DDCSTD = 'Joint Account'
     C                   ENDIF
 
     C                   IF        DDCSTP = 'O'
     C                   EVAL      DDCSTD = 'Other'
     C                   ENDIF
 
     C                   EVAL      DDCSST = FACSST
      *
      ** Load Customer Sub-type Description.
      *
     C                   IF        DDCSTP = 'F'
     C                   IF        DDCSST = 'PO'
     C                   EVAL      DDCSSD = 'Participating +
     C                                      - Own GIIN'
     C                   ENDIF
 
     C                   IF        DDCSST = 'PW'
     C                   EVAL      DDCSSD = 'Participating +
     C                                      - W/o GIIN'
     C                   ENDIF
 
     C                   IF        DDCSST = 'PS'
     C                   EVAL      DDCSSD = 'Part. w/ +
     C                                      someone elses GIIN'
     C                   ENDIF
 
     C                   IF        DDCSST = 'NP'
     C                   EVAL      DDCSSD = 'Non-participating'
     C                   ENDIF
 
     C                   IF        DDCSST = 'OW'
     C                   EVAL      DDCSSD = 'Owner Document +
     C                                      FFI'
     C                   ENDIF
 
     C                   IF        DDCSST = 'UN'
     C                   EVAL      DDCSSD = 'Unknown'
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        DDCSTP = 'N'
     C                   IF        DDCSST = 'AC'
     C                   EVAL      DDCSSD = 'Active'
     C                   ENDIF
 
     C                   IF        DDCSST = 'PA'
     C                   EVAL      DDCSSD = 'Passive'
     C                   ENDIF
 
     C                   IF        DDCSST = 'UN'
     C                   EVAL      DDCSSD = 'Unknown'
     C                   ENDIF
     C                   ENDIF
 
     C                   EVAL      DDREPT = FAREPT
     C                   EVAL      DDINFC = FAINFC
     C                   EVAL      DDEXMA = FAEXMA
 
      ** Access SDFATCPD for FATCA Classification Descriptions
 
     C                   CALL      'AOFATCR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY    '    @OPTN
     C                   PARM      DDCLAC        @PFTC
     C     SDFATC        PARM      SDFATC        DSFDY
 
     C                   EVAL      DDCLDS = FCDESC
 
      ** Access SDFATCPD for Prev FATCA Classification Descriptions
 
     C                   CALL      'AOFATCR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY    '    @OPTN
     C                   PARM      FAPCLA        @PFTC
     C     SDFATC        PARM      SDFATC        DSFDY
 
     C                   IF        @RTCD <> '*NRF      '                                    MD028123
     C                   EVAL      DDPFCE = FCDESC
     C                   ELSE                                                               MD028123
     C                   EVAL      DDPFCE = *BLANKS                                         MD028123
     C                   ENDIF                                                              MD028123
                                                                                            MD025161
      ** Set-up Alternative Citizenship                                                     MD025161
                                                                                            MD025161
     C     FACUST        CHAIN     SDCUSXL0                           17                    MD025161
     C                   IF        NOT %FOUND (SDCUSXL0)                                    MD025161
     C                   EVAL      DBFILE = 'SDCUSXL0'                                      MD025161
     C                   EVAL      DBASE = 3                                                MD025161
     C                   EVAL      DBKEY = FACUST                                          MD025161A
     C                   EXSR      *PSSR                                                    MD025161
     C                   ELSE                                                               MD025161
     C                   EVAL      DDACCZ = XCACCZ                                          MD025161
     C                   ENDIF                                                              MD025161
                                                                                            MD025161
      ** Setup date of birth, town and country                                              MD025161
                                                                                            MD025161
     C     FACUST        CHAIN     SDACUSL1                           18                    MD025161
     C                   IF        %FOUND(SDACUSL1)                                        MD025161A
     C                   EVAL      WTempDate = E5BRTH                                       MD025161
     C                   EXSR      SRZDate2                                                 MD025161
     C                   IF        ZDATE > 0                                                MD025161
     C                   MOVEL     ZADATE        DDBRTH                                     MD025161
     C                   ELSE                                                               MD025161
     C                   EVAL      DDBRTH = *BLANKS                                         MD025161
     C                   ENDIF                                                              MD025161
                                                                                            MD025161
     C                   EVAL      DDBTHT = E5BTHT                                          MD025161
     C                   EVAL      DDCBTH = E5BTHC                                          MD025161
     C                   ENDIF                                                              MD025161
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRZDate2   - Calls ZDATE2 to convert  day no. to ddMMMyy      *
      *                                                               *
      * Called by:  SRCUSTSET                                         *
      *                                                               *
      * Calls: ZDATE                                                  *
      *                                                               *
      *****************************************************************
 
     C     SRZDate2      BEGSR
 
     C                   EVAL      ZDAYNO = WTempDate
     C                   CALLB     'ZDATE2'
     C                   PARM                    ZDAYNO
     C                   PARM                    BJDFIN
     C                   PARM                    ZDATE
     C                   PARM                    ZADATE
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRTERM   - Termination processing                             *
      *                                                               *
      * Called by: Main Routine                                       *
      *                                                               *
      * Calls    : SRFCP - File Control Processing                    *
      *                                                               *
      *****************************************************************
 
     C     SRTERM        BEGSR
 
      ** if database error has occured, output total report headings;
      ** print error message and exit program.
 
     C                   IF        *IN80 = *ON
     C                   Z-ADD     WCustCnt      RRCUST                                     MD026653
     C                   WRITE     CONTROL
     C                   WRITE     DBERROR
     C                   GOTO      TEND
     C                   ENDIF
 
      ** produce standard totals report
 
     C                   EXSR      SRFCP
 
      ** if a database error has occured, bypass further processing
 
     C     *INU7         CABEQ     *ON           TEND
 
     C                   EVAL      *INLR = *ON
 
     C                   RETURN
 
     C     TEND          ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRFCP    - Produces Standard Totals Report                    *
      *                                                               *
      * Called by: SRTERM - Termination Processing                    *
      *                                                               *
      * Calls    : None                                               *
      *                                                               *
      *****************************************************************
 
     C     SRFCP         BEGSR
 
      ** set-up calculated number of records fields
 
     C                   Z-ADD     WCustCnt      RRCUST
 
      ** print standard totals report
 
     C                   IF        RRCUST > 0
     C                   EVAL      *IN54 = *ON
     C                   ELSE
     C                   EVAL      *IN54 = *OFF
     C                   ENDIF
 
     C                   WRITE     CONTROL
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRINIT   - Initial processing                                 *
      *                                                               *
      * Called by: Main Routine                                       *
      *                                                               *
      * Calls    : *PSSR  - Error handling subroutine                 *
      *                                                               *
      *****************************************************************
     C     SRINIT        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    PMode
     C                   PARM                    PIntyp
     C                   PARM                    PSeq
     C                   PARM                    PEnty
 
      ** access installation control data
      ** access bank details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      '*MSG   '     PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** if access program fails call SR. *PSSR
 
     C                   IF        PRTCD <> *BLANK
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBKEY  = '*FIRST'
     C                   EVAL      DBASE  = 2
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** if fails goto END
 
     C                   IF        *IN80 = *ON
     C                   GOTO      IEND
     C                   ENDIF
 
      ** load printer file fields with date and title
 
     C                   EVAL      RRTITL = BJURPT
     C                   EVAL      RRRUNA = BJMRDT
     C                   EVAL      DRUND  = BJRDNB
 
      ** Set counters to 0
 
     C                   EVAL      WCustCtr = 0
     C                   EVAL      WCustCnt = 0
 
     C     IEND          ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR    - Error handling subroutine                          *
      *            Executes whenever field or program exception       *
      *            error occurs                                       *
      *                                                               *
      * Called by: SRINIT - Initial processing                        *
      *                                                               *
      * Calls    : None                                               *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
 
     C                   IF        WRUN  = *BLANK
     C                   EVAL      WRUN = 'Y'
     C                   EVAL      DBPGM = 'SD000716'
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
 
      ** set on database error indicator and dump
 
     C                   EVAL      *IN80 = *ON
     C                   DUMP
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
** CPY@
(c) Misys International Banking Systems Ltd. 2013
