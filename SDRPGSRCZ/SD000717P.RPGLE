     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2013')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD FATCA Non-account Holder Details Report')     *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD000717P - Midas SD FATCA Non-account Holder Details Report *
      *                                                               *
      *  Function:  This is a new program to list the details of all  *
      *             FATCA NAHO Details Report in the system.          *
      *                                                               *
      *  (c) Finastra International Limited 2013                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CGL154             Date 13Oct14               *
      *                 MD027545           Date 01Aug14               *
      *                 MD027439           Date 18Jun14               *
      *                 MD024592           Date 28Jan14               *
      *                 CGL132  *CREATE    Date 01May13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CGL154 - FATCA Reporting (Recompile)                         *
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
      *    05  - Overflow Indicator SD000717P1                        *
      *    14  - End of File SDFTNHL1                                 *
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
      *  SRNHOLDER - SD NAHO Details processing                       *
      *  SRNAHOSET - Set-up the data of NAHO records and print        *
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
 
      ** Midas SD NAHO Details retrieval index
     FSDFTNHL1  IF   E           K DISK
 
      ** NAHO Details Master File Retrieval
     FSDNAHOL1  IF   E           K DISK
 
      ** RPT: FATCA NAHO details report
     FSD000717P1O    E             PRINTER INFSR(*PSSR)
     F                                     OFLIND(*IN05)
     F                                     USROPN
     F                                     INFDS(SPOOL)
 
      ** RPT: FATCA NAHO details report audit.
     FSD000717AUO    E             PRINTER INFSR(*PSSR)
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
     D WNahoCtr        S              5  0
     D WNahoCnt        S              5  0
     D WTempDate       S              5  0
     D @PFTC           S              5
     D WReqLin         S              4P 0
     D WPrvNaho        S             10    INZ(*BLANKS)
 
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
      *            Controls Set-up of SD000717 Details                *
      *            Outputs SD000717 Details                           *
      *                                                               *
      * Called by: Main Routine                                       *
      *                                                               *
      *****************************************************************
 
     C     SRMAIN        BEGSR
 
      ** For NAHO
 
     C                   EXSR      SRNHOLDER
     C                   EVAL      *INLR = *ON
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRNHOLDER - Look up SD NonAccount Holder Details retrieval    *
      *              index and handles the set-up.                    *
      *                                                               *
      * Called by: SRMAIN                                             *
      *                                                               *
      * Calls: SRNAHOSET, SROPENP1                                    *
      *                                                               *
      *****************************************************************
 
     C     SRNHOLDER     BEGSR
 
      ** Read until end of SD FATCA NAHO Details retrieval index.
 
     C                   READ      SDFTNHL1                               14
     C     FNNAHO        SETLL     SDFTNHL1
     C                   DOW       NOT %EOF (SDFTNHL1)
 
      ** Read through SD FATCA NAHO Details retrieval index.
 
     C                   READ      SDFTNHL1                               14
     C                   IF        NOT %EOF (SDFTNHL1)
     C                   EVAL      WNahoCtr = WNahoCtr + 1
 
      ** Opens printer file once/on first NAHO reading including the header.
 
     C                   IF        WNahoCtr = 1
     C                   EXSR      SROPENP1
     C                   WRITE     SD0717R0
     C                   ENDIF
     C                   EXSR      SRNAHOSET
     C                   ENDIF
 
     C                   ENDDO
 
 
     ** Close Printer file if it is open and records have been printed.
 
     C                   EXSR      SRCLOSEP1
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRNAHOSET - Set-ups the data of NAHO records and print.       *
      *                                                               *
      * Called by: SRNHOLDER                                          *
      *                                                               *
      * Calls    : *PSSR, SROPENP1, SRBLANKS, SRDETAILS               *
      *                                                               *
      *****************************************************************
 
     C     SRNAHOSET     BEGSR
 
     C     FNNAHO        CHAIN     SDNAHOL1                           16
     C                   IF        NOT %FOUND (SDNAHOL1)
     C                   EVAL      DBFILE = 'SDNAHOL1'
     C                   EVAL      DBASE = 1
     C                   EVAL      DBKEY = '*FIRST'
     C                   EXSR      *PSSR
     C                   ELSE
 
      ** Non-account holder, report name, report town.
 
     C                   EVAL      DDNAHO = FNNAHO
     C                   EVAL      DDCRNM = NHNARN
     C                   EVAL      DDCRTN = NHNATW
 
     C                   ENDIF
 
      ** Report in List or Audit Mode
 
     C                   IF        (PMode = 'A' AND NHLCDT = BJRDNB)
     C                             OR PMode = 'L' OR PMode = ' '
 
      ** Initiate fields to blanks before writing details.
 
     C                   EXSR      SRBLANKS
 
      ** Invoke records from database to fields.
 
     C                   EXSR      SRDETAILS
 
      ** Display NAHO details and information.
      ** Print Header and NAHO details if overflow occurs.
 
     C                   EVAL      WReqLin = 2
     C                   IF        PrtLn1 + WReqLin >= OflLn1
     C                             or (WPrvNaho <> DDNAHO                                   MD026607
     C                             and WPrvNaho <> *BLANKS)                                 MD026607
     C                   EXSR      SROVRFLOW
     C                   ELSE
     C                   WRITE     SD0717R1
     C                   ENDIF
 
     C                   EVAL      WReqLin = 4
     C                   IF        PrtLn1 + WReqLin >= OflLn1
     C                   EXSR      SROVRFLOW
     C                   ENDIF
     C                   WRITE     SD0717R2
 
     C                   EVAL      WReqLin = 4
     C                   IF        PrtLn1 + WReqLin >= OflLn1
     C                   EXSR      SROVRFLOW
     C                   ENDIF
     C                   WRITE     SD0717R3
 
     C                   EVAL      WReqLin = 4
     C                   IF        PrtLn1 + WReqLin >= OflLn1
     C                   EXSR      SROVRFLOW
     C                   ENDIF
     C                   WRITE     SD0717R4
 
     C                   EVAL      WReqLin = 4
     C                   IF        PrtLn1 + WReqLin >= OflLn1
     C                   EXSR      SROVRFLOW
     C                   ENDIF
     C                   WRITE     SD0717R5
 
     C                   EVAL      WReqLin = 3
     C                   IF        PrtLn1 + WReqLin >= OflLn1
     C                   EXSR      SROVRFLOW
     C                   ENDIF
     C                   WRITE     SD0717R6
 
     C                   EVAL      WReqLin = 3
     C                   IF        PrtLn1 + WReqLin >= OflLn1
     C                   EXSR      SROVRFLOW
     C                   ENDIF
     C                   WRITE     SD0717R7
 
     C                   EVAL      WReqLin = 3
     C                   IF        PrtLn1 + WReqLin >= OflLn1
     C                   EXSR      SROVRFLOW
     C                   ENDIF
     C                   WRITE     SD0717R8
 
     C                   EVAL      WReqLin = 3
     C                   IF        PrtLn1 + WReqLin >= OflLn1
     C                   EXSR      SROVRFLOW
     C                   ENDIF
     C                   WRITE     SD0717R9
 
     C                   EVAL      WReqLin = 3
     C                   IF        PrtLn1 + WReqLin >= OflLn1
     C                   EXSR      SROVRFLOW
     C                   ENDIF
     C                   WRITE     SD0717R10
 
     C                   EVAL      WReqLin = 3
     C                   IF        PrtLn1 + WReqLin >= OflLn1
     C                   EXSR      SROVRFLOW
     C                   ENDIF
     C                   WRITE     SD0717R11
 
     C                   EVAL      WReqLin = 3
     C                   IF        PrtLn1 + WReqLin >= OflLn1
     C                   EXSR      SROVRFLOW
     C                   ENDIF
     C                   WRITE     SD0717R12
 
     C                   EVAL      WReqLin = 3
     C                   IF        PrtLn1 + WReqLin >= OflLn1
     C                   EXSR      SROVRFLOW
     C                   ENDIF
     C                   WRITE     SD0717R13
 
     C                   EVAL      WReqLin = 3
     C                   IF        PrtLn1 + WReqLin >= OflLn1
     C                   EXSR      SROVRFLOW
     C                   ENDIF
     C                   WRITE     SD0717R14
 
     C                   EVAL      WReqLin = 3
     C                   IF        PrtLn1 + WReqLin >= OflLn1
     C                   EXSR      SROVRFLOW
     C                   ENDIF
     C                   WRITE     SD0717R15
 
     C                   EVAL      WReqLin = 3
     C                   IF        PrtLn1 + WReqLin >= OflLn1
     C                   EXSR      SROVRFLOW
     C                   ENDIF
     C                   WRITE     SD0717R16
 
     C                   EVAL      WReqLin = 3
     C                   IF        PrtLn1 + WReqLin >= OflLn1
     C                   EXSR      SROVRFLOW
     C                   ENDIF
     C                   WRITE     SD0717R17
 
     C                   EVAL      WReqLin = 3                                              MD026607
     C                   IF        PrtLn1 + WReqLin >= OflLn1                               MD026607
     C                   EXSR      SROVRFLOW                                                MD026607
     C                   ENDIF                                                              MD026607
     C                   WRITE     SD0717R19                                                MD026607
                                                                                            MD026607
     C                   EVAL      WNahoCnt = WNahoCnt + 1
     C                   EVAL      WPrvNaho = DDNAHO                                        MD026607
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SROVVRFLOW - Prints Title and NAHO Details if Overflow        *
      *                                                               *
      * Called by: SRNAHOSET                                          *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SROVRFLOW     BEGSR
      *
      ** Prints title and NAHO details
      *
     C                   WRITE     SD0717R0
     C                   WRITE     SD0717R1
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SROPENP1 - Open printer file SD000717P1                       *
      *                                                               *
      * Called by: SRNAHOSET                                          *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SROPENP1      BEGSR
 
      ** open printer file and indicate that there is atleast one
      ** detail to report; ensure report spool file recorded by RCF
 
     C                   IF        NOT %OPEN (SD000717P1)
     C                   OPEN      SD000717P1
 
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
      * SRCLOSEP1 - Closes printer file SD000717P1                    *
      *                                                               *
      * Called by: SRNHOLDER                                          *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SRCLOSEP1     BEGSR
 
     C                   IF        %OPEN (SD000717P1)
     C                   EVAL      WReqLin = 2
     C                   IF        PrtLn1 + WReqLin >= OflLn1
     C                   EXSR      SROVRFLOW
     C                   ENDIF
     C                   WRITE     SD0717R18
     C                   CLOSE     SD000717P1
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRBLANKS - Initiate all fields to blanks.                     *
      *                                                               *
      * Called by: SRNAHOSET                                          *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SRBLANKS      BEGSR
                                                                                            MD026607
      ** US Indicia of US Authority Holder Details                                          MD026607
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
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRDETAILS - Initiate details to fields from database          *
      *                                                               *
      * Called by: SRNAHOSET                                          *
      *                                                               *
      * Calls: SRZDate2                                               *
      *                                                               *
      *****************************************************************
 
     C     SRDETAILS     BEGSR
                                                                                            MD026607
      ** US Indicia of US Authority Holder Details                                          MD026607
                                                                                            MD026607
     C                   EVAL      DDAUSV = FNAUSV                                          MD026607
     C                   EVAL      WTempDate = FNAUSD                                       MD026607
     C                   EXSR      SRZDate2                                                 MD026607
     C                   IF        ZDATE > 0                                                MD026607
     C                   MOVEL     ZADATE        DDAUSD                                     MD026607
     C                   ELSE                                                               MD026607
     C                   EVAL      DDAUSD = *BLANKS                                         MD026607
     C                   ENDIF                                                              MD026607
     C                   MOVEL     FNAUST        DDAUST                                     MD026607
     C                   EVAL      DDAUOV = FNAUOV                                          MD026607
     C                   EVAL      DDAUD1 = FNAUD1                                          MD026607
     C                   EVAL      DDAUD2 = FNAUD2                                          MD026607
     C                   EVAL      DDAUD3 = FNAUD3                                          MD026607
     C                   EVAL      DDAUD4 = FNAUD4                                          MD026607
     C                   EVAL      DDAUD5 = FNAUD5                                          MD026607
     C                   EVAL      DDAUON = FNAUON                                          MD026607
     C                   EVAL      WTempDate = FNAUOD                                       MD026607
     C                   EXSR      SRZDate2                                                 MD026607
                                                                                            MD026607
     C                   IF        ZDATE > 0                                                MD026607
     C                   MOVEL     ZADATE        DDAUOD                                     MD026607
     C                   ELSE                                                               MD026607
     C                   EVAL      DDAUOD = *BLANKS                                         MD026607
     C                   ENDIF                                                              MD026607
                                                                                            MD026607
     C                   MOVEL     FNAUOT        DDAUOM                                     MD026607
     C                   EVAL      DDAUC1 = FNAUCO                                          MD026607
     C                   EVALR     DDAUC2 = FNAUCO                                          MD026607
 
      ** US Indicia of US Hold Mail details
 
     C                   EVAL      DDHMSV = FNHMSV
     C                   EVAL      WTempDate = FNHMSD
     C                   EXSR      SRZDate2
     C                   IF        ZDATE > 0
     C                   MOVEL     ZADATE        DDHMSD
     C                   ELSE
     C                   EVAL      DDHMSD = *BLANKS
     C                   ENDIF
     C                   MOVEL     FNHMST        DDHMST
     C                   EVAL      DDHMOV = FNHMOV
     C                   EVAL      DDHMD1 = FNHMD1
     C                   EVAL      DDHMD2 = FNHMD2
     C                   EVAL      DDHMD3 = FNHMD3
     C                   EVAL      DDHMD4 = FNHMD4
     C                   EVAL      DDHMD5 = FNHMD5
     C                   EVAL      DDHMON = FNHMON
     C                   EVAL      WTempDate = FNHMOD
     C                   EXSR      SRZDate2
 
     C                   IF        ZDATE > 0
     C                   MOVEL     ZADATE        DDHMOD
     C                   ELSE
     C                   EVAL      DDHMOD = *BLANKS
     C                   ENDIF
 
     C                   MOVEL     FNHMOT        DDHMOM
     C                   EVAL      DDHMC1 = FNHMCO
     C                   EVALR     DDHMC2 = FNHMCO
 
      ** US Indicia of Mailing Country details
 
     C                   EVAL      DDMCSV = FNMCSV
     C                   EVAL      WTempDate = FNMCSD
     C                   EXSR      SRZDate2
 
     C                   IF        ZDATE > 0
     C                   MOVEL     ZADATE        DDMCSD
     C                   ELSE
     C                   EVAL      DDMCSD = *BLANKS
     C                   ENDIF
     C
     C                   MOVEL     FNMCST        DDMCST
     C                   EVAL      DDMCOV = FNMCOV
     C                   EVAL      DDMCD1 = FNMCD1
     C                   EVAL      DDMCD2 = FNMCD2
     C                   EVAL      DDMCD3 = FNMCD3
     C                   EVAL      DDMCD4 = FNMCD4
     C                   EVAL      DDMCD5 = FNMCD5
     C                   EVAL      DDMCON = FNMCON
     C                   EVAL      WTempDate = FNMCOD
     C                   EXSR      SRZDate2
 
     C                   IF        ZDATE > 0
     C                   MOVEL     ZADATE        DDMCOD
     C                   ELSE
     C                   EVAL      DDMCOD = *BLANKS
     C                   ENDIF
 
     C                   MOVEL     FNMCOT        DDMCMM
     C                   EVAL      DDMCC1 = FNMCCO
     C                   EVALR     DDMCC2 = FNMCCO
 
      ** US Indicia of Regular Payment Ins. to US details
 
     C                   EVAL      DDRPSV = FNRPSV
     C                   EVAL      WTempDate = FNRPSD
     C                   EXSR      SRZDate2
 
     C                   IF        ZDATE > 0
     C                   MOVEL     ZADATE        DDRPSD
     C                   ELSE
     C                   EVAL      DDRPSD = *BLANKS
     C                   ENDIF
 
     C                   MOVEL     FNRPST        DDRPST
     C                   EVAL      DDRPOV = FNRPOV
     C                   EVAL      DDRPD1 = FNRPD1
     C                   EVAL      DDRPD2 = FNRPD2
     C                   EVAL      DDRPD3 = FNRPD3
     C                   EVAL      DDRPD4 = FNRPD4
     C                   EVAL      DDRPD5 = FNRPD5
     C                   EVAL      DDRPON = FNRPON
     C                   EVAL      WTempDate = FNRPOD
     C                   EXSR      SRZDate2
 
     C                   IF        ZDATE > 0
     C                   MOVEL     ZADATE        DDRPOD
     C                   ELSE
     C                   EVAL      DDRPOD = *BLANKS
     C                   ENDIF
 
     C                   MOVEL     FNRPOT        DDRPOM
     C                   EVAL      DDRPC1 = FNRPCO
     C                   EVALR     DDRPC2 = FNRPCO
 
      ** US Indicia of Citizenship details
 
     C                   EVAL      DDCISV = FNCISV
     C                   EVAL      WTempDate = FNCISD
     C                   EXSR      SRZDate2
 
     C                   IF        ZDATE > 0
     C                   MOVEL     ZADATE        DDCISD
     C                   ELSE
     C                   EVAL      DDCISD = *BLANKS
     C                   ENDIF
 
     C                   MOVEL     FNCIST        DDCIST
     C                   EVAL      DDCIOV = FNCIOV
     C                   EVAL      DDCID1 = FNCID1
     C                   EVAL      DDCID2 = FNCID2
     C                   EVAL      DDCID3 = FNCID3
     C                   EVAL      DDCID4 = FNCID4
     C                   EVAL      DDCID5 = FNCID5
     C                   EVAL      DDCION = FNCION
     C                   EVAL      WTempDate = FNCIOD
     C                   EXSR      SRZDate2
 
     C                   IF        ZDATE > 0
     C                   MOVEL     ZADATE        DDCIOD
     C                   ELSE
     C                   EVAL      DDCIOD = *BLANKS
     C                   ENDIF
 
     C                   MOVEL     FNCIOT        DDCIOM
     C                   EVAL      DDCIC1 = FNCICO
     C                   EVALR     DDCIC2 = FNCICO
 
      ** US Indicia of US Country of Birth details
 
     C                   EVAL      DDCBSV = FNCBSV
     C                   EVAL      WTempDate = FNCBSD
     C                   EXSR      SRZDate2
 
     C                   IF        ZDATE > 0
     C                   MOVEL     ZADATE        DDCBSD
     C                   ELSE
     C                   EVAL      DDCBSD = *BLANKS
     C                   ENDIF
 
     C                   MOVEL     FNCBST        DDCBST
     C                   EVAL      DDCBOV = FNCBOV
     C                   EVAL      DDCBD1 = FNCBD1
     C                   EVAL      DDCBD2 = FNCBD2
     C                   EVAL      DDCBD3 = FNCBD3
     C                   EVAL      DDCBD4 = FNCBD4
     C                   EVAL      DDCBD5 = FNCBD5
     C                   EVAL      DDCBON = FNCBON
     C                   EVAL      WTempDate = FNCBOD
     C                   EXSR      SRZDate2
 
     C                   IF        ZDATE > 0
     C                   MOVEL     ZADATE        DDCBOD
     C                   ELSE
     C                   EVAL      DDCBOD = *BLANKS
     C                   ENDIF
 
     C                   MOVEL     FNCBOT        DDCBOM
     C                   EVAL      DDCBC1 = FNCBCO
     C                   EVALR     DDCBC2 = FNCBCO
 
      ** US Indicia of US Country of Domicile details
 
     C                   EVAL      DDCDSV = FNCDSV
     C                   EVAL      WTempDate = FNCDSD
     C                   EXSR      SRZDate2
 
     C                   IF        ZDATE > 0
     C                   MOVEL     ZADATE        DDCDSD
     C                   ELSE
     C                   EVAL      DDCDSD = *BLANKS
     C                   ENDIF
 
     C                   MOVEL     FNCDST        DDCDST
     C                   EVAL      DDCDOV = FNCDOV
     C                   EVAL      DDCDD1 = FNCDD1
     C                   EVAL      DDCDD2 = FNCDD2
     C                   EVAL      DDCDD3 = FNCDD3
     C                   EVAL      DDCDD4 = FNCDD4
     C                   EVAL      DDCDD5 = FNCDD5
     C                   EVAL      DDCDON = FNCDON
     C                   EVAL      WTempDate = FNCDOD
     C                   EXSR      SRZDate2
 
     C                   IF        ZDATE > 0
     C                   MOVEL     ZADATE        DDCDOD
     C                   ELSE
     C                   EVAL      DDCDOD = *BLANKS
     C                   ENDIF
 
     C                   MOVEL     FNCDOT        DDCDMM
     C                   EVAL      DDCDC1 = FNCDCO
     C                   EVALR     DDCDC2 = FNCDCO
 
      ** US Indicia of US Green Card details
 
     C                   EVAL      DDGCSV = FNGCSV
     C                   EVAL      WTempDate = FNGCSD
     C                   EXSR      SRZDate2
 
     C                   IF        ZDATE > 0
     C                   MOVEL     ZADATE        DDGCSD
     C                   ELSE
     C                   EVAL      DDGCSD =  *BLANKS
     C                   ENDIF
 
     C                   MOVEL     FNGCST        DDGCST
     C                   EVAL      DDGCOV = FNGCOV
     C                   EVAL      DDGCD1 = FNGCD1
     C                   EVAL      DDGCD2 = FNGCD2
     C                   EVAL      DDGCD3 = FNGCD3
     C                   EVAL      DDGCD4 = FNGCD4
     C                   EVAL      DDGCD5 = FNGCD5
     C                   EVAL      DDGCON = FNGCON
     C                   EVAL      WTempDate = FNGCOD
     C                   EXSR      SRZDate2
 
     C                   IF        ZDATE > 0
     C                   MOVEL     ZADATE        DDGCOD
     C                   ELSE
     C                   EVAL      DDGCOD = *BLANKS
     C                   ENDIF
 
     C                   MOVEL     FNGCOT        DDGCOM
     C                   EVAL      DDGCC1 = FNGCCO
     C                   EVALR     DDGCC2 = FNGCCO
 
      ** US Indicia of Citizenship details
 
     C                   EVAL      DDIDSV = FNIDSV
     C                   EVAL      WTempDate = FNIDSD
     C                   EXSR      SRZDate2
 
     C                   IF        ZDATE > 0
     C                   MOVEL     ZADATE        DDIDSD
     C                   ELSE
     C                   EVAL      DDIDSD = *BLANKS
     C                   ENDIF
 
     C                   MOVEL     FNIDST        DDIDST
     C                   EVAL      DDIDOV = FNIDOV
     C                   EVAL      DDIDD1 = FNIDD1
     C                   EVAL      DDIDD2 = FNIDD2
     C                   EVAL      DDIDD3 = FNIDD3
     C                   EVAL      DDIDD4 = FNIDD4
     C                   EVAL      DDIDD5 = FNIDD5
     C                   EVAL      DDIDON = FNIDON
     C                   EVAL      WTempDate = FNIDOD
     C                   EXSR      SRZDate2
 
     C                   IF        ZDATE > 0
     C                   MOVEL     ZADATE        DDIDOD
     C                   ELSE
     C                   EVAL      DDIDOD = *BLANKS
     C                   ENDIF
 
     C                   MOVEL     FNIDOT        DDIDOM
     C                   EVAL      DDIDC1 = FNIDCO
     C                   EVALR     DDIDC2 = FNIDCO
 
      ** US Indicia of US Joint Account Member details
 
     C                   EVAL      DDJASV = FNJASV
     C                   EVAL      WTempDate = FNJASD
     C                   EXSR      SRZDate2
 
     C                   IF        ZDATE > 0
     C                   MOVEL     ZADATE        DDJASD
     C                   ELSE
     C                   EVAL      DDJASD = *BLANKS
     C                   ENDIF
 
     C                   MOVEL     FNJAST        DDJAST
     C                   EVAL      DDJAOV = FNJAOV
     C                   EVAL      DDJAD1 = FNJAD1
     C                   EVAL      DDJAD2 = FNJAD2
     C                   EVAL      DDJAD3 = FNJAD3
     C                   EVAL      DDJAD4 = FNJAD4
     C                   EVAL      DDJAD5 = FNJAD5
     C                   EVAL      DDJAON = FNJAON
     C                   EVAL      WTempDate = FNJAOD
     C                   EXSR      SRZDate2
 
     C                   IF        ZDATE > 0
     C                   MOVEL     ZADATE        DDJAOD
     C                   ELSE
     C                   EVAL      DDJAOD = *BLANKS
     C                   ENDIF
 
     C                   MOVEL     FNJAOT        DDJAMM
     C                   EVAL      DDJAC1 = FNJACO
     C                   EVALR     DDJAC2 = FNJACO
 
      ** US Indicia of US Telephone details
 
     C                   EVAL      DDTESV = FNTESV
     C                   EVAL      WTempDate = FNTESD
     C                   EXSR      SRZDate2
 
     C                   IF        ZDATE > 0
     C                   MOVEL     ZADATE        DDTESD
     C                   ELSE
     C                   EVAL      DDTESD = *BLANKS
     C                   ENDIF
 
     C                   MOVEL     FNTEST        DDTEST
     C                   EVAL      DDTEOV = FNTEOV
     C                   EVAL      DDTED1 = FNTED1
     C                   EVAL      DDTED2 = FNTED2
     C                   EVAL      DDTED3 = FNTED3
     C                   EVAL      DDTED4 = FNTED4
     C                   EVAL      DDTED5 = FNTED5
     C                   EVAL      DDTEON = FNTEON
     C                   EVAL      WTempDate = FNTEOD
     C                   EXSR      SRZDate2
 
     C                   IF        ZDATE > 0
     C                   MOVEL     ZADATE        DDTEOD
     C                   ELSE
     C                   EVAL      DDTEOD = *BLANKS
     C                   ENDIF
 
     C                   MOVEL     FNTEOT        DDTEOM
     C                   EVAL      DDTEC1 = FNTECO
     C                   EVALR     DDTEC2 = FNTECO
 
      ** US Indicia of US Tax Identification Number  details
 
     C                   EVAL      DDTXSV = FNTXSV
     C                   EVAL      WTempDate = FNTXSD
     C                   EXSR      SRZDate2
 
     C                   IF        ZDATE > 0
     C                   MOVEL     ZADATE        DDTXSD
     C                   ELSE
     C                   EVAL      DDTXSD = *BLANKS
     C                   ENDIF
 
     C                   MOVEL     FNTXST        DDTXST
     C                   EVAL      DDTXOV = FNTXOV
     C                   EVAL      DDTXD1 = FNTXD1
     C                   EVAL      DDTXD2 = FNTXD2
     C                   EVAL      DDTXD3 = FNTXD3
     C                   EVAL      DDTXD4 = FNTXD4
     C                   EVAL      DDTXD5 = FNTXD5
     C                   EVAL      DDTXON = FNTXON
     C                   EVAL      WTempDate = FNTXOD
     C                   EXSR      SRZDate2
 
     C                   IF        ZDATE > 0
     C                   MOVEL     ZADATE        DDTXOD
     C                   ELSE
     C                   EVAL      DDTXOD = *BLANKS
     C                   ENDIF
 
     C                   MOVEL     FNTXOT        DDTXOM
     C                   EVAL      DDTXC1 = FNTXCO
     C                   EVALR     DDTXC2 = FNTXCO
 
      ** Other FATCA details.
 
     C                   EVAL      DDCLAC = FNCLAC
     C                   EVAL      WTempDate = FNCLAD
     C                   EXSR      SRZDate2
 
     C                   IF        ZDATE > 0
     C                   MOVEL     ZADATE        DDCLAF
     C                   ELSE
     C                   EVAL      DDCLAF = *BLANKS
     C                   ENDIF
 
     C                   EVAL      DDPCLA = FNPCLA
     C                   EVAL      DDEXEM = FNEXEM
     C                   EVAL      WTempDate = FNEXED
     C                   EXSR      SRZDate2
 
     C                   IF        ZDATE > 0
     C                   MOVEL     ZADATE        DDEXED
     C                   ELSE
     C                   EVAL      DDEXED = *BLANKS
     C                   ENDIF
 
     C                   MOVEL     FNEXET        DDEXET
     C                   EVAL      DDEXEU = FNEXEU
     C                   EVAL      DDEXE1 = %SUBST(FNEXER:1:64)
     C                   EVAL      DDEXE2 = %SUBST(FNEXER:65:64)
     C                   EVAL      DDEXE3 = %SUBST(FNEXER:129:64)
     C                   EVALR     DDEXE4 = %SUBST(FNEXER:193:64)
     C                   EVAL      DDRPTT = FNRPTT
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
     C                   EVAL      WTempDate = FNRPTD
     C                   EXSR      SRZDate2
 
     C                   IF        ZDATE > 0
     C                   MOVEL     ZADATE        DDRPTD
     C                   ELSE
     C                   EVAL      DDRPTD = *BLANKS
     C                   ENDIF
 
     C                   MOVEL     FNRPTM        DDRPTM
     C                   EVAL      DDRPTU = FNRPTU
     C                   EVAL      DDRPT1 = FNRPTR
     C                   EVALR     DDRPT2 = FNRPTR
     C                   EVAL      DDGIIN = FNGIIN
     C                   EVAL      WTempDate = FNGIID
     C                   EXSR      SRZDate2
 
     C                   IF        ZDATE > 0
     C                   MOVEL     ZADATE        DDGIIF
     C                   ELSE
     C                   EVAL      DDGIIF = *BLANKS
     C                   ENDIF
 
     C                   EVAL      DDGIIO = FNGIIO
     C                   EVAL      DDUTIN = FNUTIN
     C                   EVAL      DDMAIL = FNMAIL
     C                   EVAL      DDPHON = FNPHON
     C                   EVAL      DDGREC = FNGREC
     C                   EVAL      DDHVAC = FNHVAC
     C                   EVAL      DDCSTP = FNNHTY
      *
      ** Load FATCA NAHO Description
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
 
     C                   EVAL      DDCSST = FNNHST
      *
      ** Load NAHO Sub-type Description.
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
 
     C                   EVAL      DDREPT = FNREPT
     C                   EVAL      DDINFC = FNINFC
     C                   EVAL      DDEXMA = FNEXMA
 
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
     C                   PARM      FNPCLA        @PFTC
     C     SDFATC        PARM      SDFATC        DSFDY
 
     C                   IF        @RTCD <> '*NRF      '                                    MD028123
     C                   EVAL      DDPFCE = FCDESC
     C                   ELSE                                                               MD028123
     C                   EVAL      DDPFCE = *BLANKS                                         MD028123
     C                   ENDIF                                                              MD028123
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRZDate2   - Calls ZDATE2 to convert  day no. to ddMMMyy      *
      *                                                               *
      * Called by:  SRNAHOSET                                         *
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
 
     C                   Z-ADD     WNahoCnt      RRCUST
 
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
     C                   PARM                    PINtyp
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
 
     C                   EVAL      WNahoCtr = 0
     C                   EVAL      WNahoCnt = 0
 
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
     C                   EVAL      DBPGM = 'SD000717'
 
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
(c) Finastra International Limited 2013
