     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2016')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD CRS Customer Details Report')                 *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD000720P - Midas SD CRS Customer Details Report             *
      *                                                               *
      *  Function:  This is a new program to list the details of all  *
      *             CRS Customer Details Report in the system.        *
      *                                                               *
      *  (c) Finastra International Limited 2016                      *
      *                                                               *
      *  Last Amend No. CGL177  *CREATE    Date 11Jan16               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CGL177 - CRS Reporting Phase 2                               *
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

      ** Midas SD CRS Customer Details retrieval index
     FSDCRSHL0  IF   E           K DISK

      ** Midas SD CRS Customer Country Details retrieval index
     FSDCRSDL2  IF   E           K DISK

      ** Customer Details Master File Retrieval
     FSDCUSTL1  IF   E           K DISK

      ** Midas SD Customer Details Ext C - Keyed                                            MD025161
     FSDCUSXL0  IF   E           K DISK                                                     MD025161
                                                                                            MD025161
      ** Additional customer details retrieval                                              MD025161
     FSDACUSL1  IF   E           K DISK                                                     MD025161
                                                                                            MD025161
      ** RPT: CRS Customer details report
     FSD000720P1O    E             PRINTER INFSR(*PSSR)
     F                                     OFLIND(*IN05)
     F                                     USROPN
     F                                     INFDS(SPOOL)

      ** RPT: CRS Customer details report audit.
     FSD000720AUO    E             PRINTER INFSR(*PSSR)
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

      ** External DS for Country of Tax Codes
     D SDCTTX        E DS                  EXTNAME(SDCTTXPD)

      ** External DS for Custoter Details
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)

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
     D WCustCtr        S              5  0
     D WCustCnt        S              5  0
     D WTempDate       S              5  0
     D @PFTC           S              5
     D WReqLin         S              4P 0

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

     D WCNCD           S              2A
     D WCOLC           S              2A
     D @PCTRT          S              2A
     D @PCTRR          S              2A
     D PKey2           S             10A
     D PKySt           S              7A

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
      *            Controls Set-up of SD000720 Details                *
      *            Outputs SD000720 Details                           *
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

      ** Do unit end of  SD CRS Customer Details retrieval index.

     C                   READ      SDCRSHL0                               14
     C     CRCUST        SETLL     SDCRSHL0
     C                   DOW       NOT %EOF (SDCRSHL0)

      ** Read through SD CRS Customer Details retrieval index.

     C                   READ      SDCRSHL0                               14
     C                   IF        NOT %EOF (SDCRSHL0)
     C                   EVAL      WCustCtr = WCustCtr + 1

      ** Opens printer file once/on first customer reading including the header.

     C                   IF        WCustCtr = 1
     C                   EXSR      SROPENP1
     C                   WRITE     SD0720R0
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

     C     CRCUST        CHAIN     SDCUSTL1                           16
     C                   IF        NOT %FOUND (SDCUSTL1)
     C                   EVAL      DBFILE = 'SDCUSTL1'
     C                   EVAL      DBASE = 1
     C                   EVAL      DBKEY = CRCUST                                          MD026653
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Report in List or Audit Mode

     C                   IF        (PMode = 'A' AND BBLCD = BJRDNB)
     C                             OR PMode = 'L' OR PMode = ' '
                                                                                            MD026653
      ** customer no, customer shortname, report name, report town.                         MD026653
                                                                                            MD026653
     C                   EVAL      DDCUST = CRCUST                                          MD026653
     C                   EVAL      DDCSSN = BBCSSN                                          MD026653
     C                   EVAL      DDCRNM = BBCRNM                                          MD026653
     C                   EVAL      DDCRTN = BBCRTN                                          MD026653

      ** Initiate fields to blanks before writing details.

     C                   EXSR      SRBLANK1

      ** Invoke records from database to fields.

     C                   EXSR      SRDETAILS

      ** Display Customer details and information.
      ** Print Header and customer details if overflow occurs.

     C                   EVAL      WReqLin = 3
     C                   IF        PrtLn1 + WReqLin >= OflLn1
     C                   EXSR      SROVRFLOW
     C                   ELSE
     C                   WRITE     SD0720R1
     C                   ENDIF

     C                   EVAL      WReqLin = 10
     C                   IF        PrtLn1 + WReqLin >= OflLn1
     C                   EXSR      SROVRFLOW
     C                   ENDIF
     C                   WRITE     SD0720R2

     C                   EVAL      WCustCnt = WCustCnt + 1

      ** Process CRS Country Details per Customer
     C                   EXSR      SRCTRYDET

     C                   ENDIF

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


      ** CRS Main details

      ** CRS Customer Type
     C                   EVAL      DDTYPE = CRTYPE
      *
      ** Load CRS Customer Type Description
      *
     C                   IF        DDTYPE = 'F'
     C                   EVAL      DDCSTD = 'Foreign Financial +
     C                                      Institution'
     C                   ENDIF

     C                   IF        DDTYPE = 'N'
     C                   EVAL      DDCSTD = 'Non-financial +
     C                                      Entity'
     C                   ENDIF

     C                   IF        DDTYPE = 'P'
     C                   EVAL      DDCSTD = 'Physical Person'
     C                   ENDIF

     C                   IF        DDTYPE = 'J'
     C                   EVAL      DDCSTD = 'Joint Account'
     C                   ENDIF

     C                   IF        DDTYPE = 'O'
     C                   EVAL      DDCSTD = 'Other'
     C                   ENDIF

      ** CRS Customer Subtype
     C                   EVAL      DDSTYP = CRSTYP
      *
      ** Load CRS Customer Sub-type Description.
      *
     C                   IF        DDTYPE = 'F'
     C                   IF        DDSTYP = 'PO'
     C                   EVAL      DDCSSD = 'Participating +
     C                                      - Own GIIN'
     C                   ENDIF

     C                   IF        DDSTYP = 'PW'
     C                   EVAL      DDCSSD = 'Participating +
     C                                      - W/o GIIN'
     C                   ENDIF

     C                   IF        DDSTYP = 'PS'
     C                   EVAL      DDCSSD = 'Part. w/ +
     C                                      someone elses GIIN'
     C                   ENDIF

     C                   IF        DDSTYP = 'NP'
     C                   EVAL      DDCSSD = 'Non-participating'
     C                   ENDIF

     C                   IF        DDSTYP = 'OW'
     C                   EVAL      DDCSSD = 'Owner Document +
     C                                      FFI'
     C                   ENDIF

     C                   IF        DDSTYP = 'UN'
     C                   EVAL      DDCSSD = 'Unknown'
     C                   ENDIF
     C                   ENDIF

     C                   IF        DDTYPE = 'N'
     C                   IF        DDSTYP = 'AC'
     C                   EVAL      DDCSSD = 'Active'
     C                   ENDIF

     C                   IF        DDSTYP = 'PA'
     C                   EVAL      DDCSSD = 'Passive'
     C                   ENDIF

     C                   IF        DDSTYP = 'UN'
     C                   EVAL      DDCSSD = 'Unknown'
     C                   ENDIF
     C                   ENDIF

      ** CRS High Value Account
     C                   EVAL      DDHVAL = CRHVAL

      ** CRS Country of Domicile
     C                   EVAL      DDCODM = BBCOLC

      ** CRS Exempt Flag
     C                   EVAL      DDEXMP = CREXMP

      ** CRS CRS Exemption Date/Time
     C                   EVAL      WTempDate = CREXMD
     C                   EXSR      SRZDate2

     C                   IF        ZDATE > 0
     C                   MOVEL     ZADATE        DDEXDT
     C                   ELSE
     C                   EVAL      DDEXDT = *BLANKS
     C                   ENDIF
      *
     C                   MOVEL     CREXMT        DDEXTM

      ** CRS Exemption - User
     C                   EVAL      DDEXMU = CREXMU

      ** CRS Exempt Remark
     C                   EVAL      DDEXR1 = %SUBST(CREXMR:1:64)
     C                   EVAL      DDEXR2 = %SUBST(CREXMR:65:64)
     C                   EVAL      DDEXR3 = %SUBST(CREXMR:129:64)
     C                   EVALR     DDEXR4 = %SUBST(CREXMR:193:64)

      ** CRS Info Complete
     C                   EVAL      DDINFO = CRINFO

      ** CRS Exception Management Flag
     C                   EVAL      DDEXMG = CREXMG

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRCTRYDET - Process CRS Country Details per Customer          *
      *                                                               *
      * Called by: SRCUSTSET                                          *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     SRCTRYDET     BEGSR

      ** Process CRS Country fields details.
     C     CRCUST        SETLL     SDCRSDL2
     C                   READ      SDCRSDL2

     C                   DOW       NOT %EOF (SDCRSDL2)

     C                   IF        CRCUST = CDCUST

      ** Initiate CRS Country fields to blanks before writing details.
     C                   EXSR      SRBLANK2

      ** Country field
     C                   EVAL      DDCTRY = CDCTRY

      ** Subject to Reporting
     C                   EVAL      DDREPT = CDREPT

      ** Reporting - User
     C                   EVAL      DDREPU = CDREPU

      ** Reporting - Date/Time
     C                   EVAL      WTempDate = CDREPD
     C                   EXSR      SRZDate2

     C                   IF        ZDATE > 0
     C                   MOVEL     ZADATE        DDRPDT
     C                   ELSE
     C                   EVAL      DDRPDT = *BLANKS
     C                   ENDIF
      *
     C                   MOVEL     CDREPM        DDRPTM

      ** Reason fields
     C                   EVAL      DDRPR1 = %SUBST(CDREPR:1:64)
     C                   EVAL      DDRPR2 = %SUBST(CDREPR:65:64)

      ** Evidence fields
     C                   EVAL      DDEVE1 = CDEVE1
     C                   EVAL      DDEVE2 = CDEVE2
     C                   EVAL      DDEVE3 = CDEVE3
     C                   EVAL      DDEVE4 = CDEVE4
     C                   EVAL      DDEVE5 = CDEVE5

      ** Effective Date
     C                   EVAL      WTempDate = CDEFFD
     C                   EXSR      SRZDate2

     C                   IF        ZDATE > 0
     C                   MOVEL     ZADATE        DDEFFD
     C                   ELSE
     C                   EVAL      DDEFFD = *BLANKS
     C                   ENDIF

      ** Tax Id. No
     C                   EVAL      DDTINN = CDTINN

      ** Expiry Date
     C                   EVAL      WTempDate = CDEXPD
     C                   EXSR      SRZDate2

     C                   IF        ZDATE > 0
     C                   MOVEL     ZADATE        DDEXPD
     C                   ELSE
     C                   EVAL      DDEXPD = *BLANKS
     C                   ENDIF

      ** CRS Agreement
     C                   EVAL      PKey2 = CRCUST

     C                   CALL      'AOCUSTR0'
     C                   PARM      *Blanks       PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM                    PKey2
     C                   PARM                    PKySt
     C     SDCUST        PARM      SDCUST        DSSDY

     C                   EVAL      WCOLC = BBCOLC
     C                   EVAL      WCNCD = DDCTRY

      ** Get CRS agreement

     C                   CALL      'AOCTTXR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      WCNCD         @PCTRT
     C                   PARM      WCOLC         @PCTRR
     C     SDCTTX        PARM      SDCTTX        DSFDY

     C                   IF        PRTCD = '*NRF   '
     C                   EVAL      @PCTRR = *Blanks
     C                   CALL      'AOCTTXR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      WCNCD         @PCTRT
     C                   PARM                    @PCTRR
     C     SDCTTX        PARM      SDCTTX        DSFDY
     C                   ENDIF

     C                   IF        PRTCD = *BLANK
     C                   EVAL      DDCRSA = EWCRSA
     C                   ELSE
     C                   EVAL      DDCRSA = *Blanks
     C                   ENDIF

      ** Country of Domicile
     C                   EVAL      DDCODO = CDCODO

      ** Joint Account Member
     C                   EVAL      DDJACM = CDJACM

      ** Mailing Country
     C                   EVAL      DDMAIL = CDMAIL

      ** Phone Number Ctry
     C                   EVAL      DDPHON = CDPHON

      ** Regular Payment
     C                   EVAL      DDRPAY = CDRPAY

      ** Authority Holder
     C                   EVAL      DDAUHO = CDAUHO

      ** Write Country Details
     C                   EVAL      WReqLin = 8
     C                   IF        PrtLn1 + WReqLin >= OflLn1
     C                   EXSR      SROVRFLOW
     C                   ENDIF
     C                   WRITE     SD0720R3

     C                   ENDIF

     C                   READ      SDCRSDL2

     C                   ENDDO


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
     C                   WRITE     SD0720R0
     C                   WRITE     SD0720R1

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SROPENP1 - Open printer file SD000720P1                       *
      *                                                               *
      * Called by: SRCUSTSET                                          *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     SROPENP1      BEGSR

      ** open printer file and indicate that there is atleast one
      ** detail to report; ensure report spool file recorded by RCF

     C                   IF        NOT %OPEN (SD000720P1)
     C                   OPEN      SD000720P1

     C***                Z-ADD     SFNUM         ZSNUM
     C***                CALL      'ZSFILE'
     C***                PARM                    PSEQ
     C***                PARM      *BLANKS       SENTY
     C***                PARM                    SFILE
     C***                PARM                    ZSNUM
     C***                PARM                    ZSERR

      ** error during ZSFILE processing, return to calling program

     C***                IF        ZSERR = 'Y'
     C***                EVAL      *INU7 = *ON
     C***                EVAL      *INU8 = *ON
     C***                EVAL      *INLR = *ON
     C***                RETURN
     C***                ENDIF
     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRCLOSEP1 - Closes printer file SD000720P1                    *
      *                                                               *
      * Called by: SRCUSTOMER                                         *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     SRCLOSEP1     BEGSR

     C                   IF        %OPEN (SD000720P1)
     C                   EVAL      WReqLin = 2
     C                   IF        PrtLn1 + WReqLin >= OflLn1
     C                   WRITE     SD0720R0                                                 MD026653
     C                   ENDIF
     C                   WRITE     SD0720R14
     C                   CLOSE     SD000720P1
     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRBLANK1 - Initiate all CRS Main fields to blanks.            *
      *                                                               *
      * Called by: SRCUSTSET                                          *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     SRBLANK1      BEGSR

      ** CRS Main field details.

     C                   EVAL      DDTYPE = *BLANKS
     C                   EVAL      DDCSTD = *BLANKS
     C                   EVAL      DDHVAL = *BLANKS
     C                   EVAL      DDSTYP = *BLANKS
     C                   EVAL      DDCSSD = *BLANKS
     C                   EVAL      DDCODM = *BLANKS
     C                   EVAL      DDEXMP = *BLANKS
     C                   EVAL      DDEXDT = *BLANKS
     C                   EVAL      DDEXMU = *BLANKS
     C                   EVAL      DDEXR1 = *BLANKS
     C                   EVAL      DDEXR2 = *BLANKS
     C                   EVAL      DDEXR3 = *BLANKS
     C                   EVAL      DDEXR4 = *BLANKS
     C                   EVAL      DDINFO = *BLANKS
     C                   EVAL      DDEXMG = *BLANKS

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRBLANK2 - Initiate all Country fields details to blanks      *
      *                                                               *
      * Called by: SRCUSTSET                                          *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     SRBLANK2      BEGSR

      ** CRS Country field details.

     C                   EVAL      DDCTRY = *BLANKS
     C                   EVAL      DDREPT = *BLANKS
     C                   EVAL      DDREPU = *BLANKS
     C                   EVAL      DDRPDT = *BLANKS
     C                   EVAL      DDRPR1 = *BLANKS
     C                   EVAL      DDRPR2 = *BLANKS
     C                   EVAL      DDEVE1 = *BLANKS
     C                   EVAL      DDEVE2 = *BLANKS
     C                   EVAL      DDEVE3 = *BLANKS
     C                   EVAL      DDEVE4 = *BLANKS
     C                   EVAL      DDEFFD = *BLANKS
     C                   EVAL      DDTINN = *BLANKS
     C                   EVAL      DDEXPD = *BLANKS
     C                   EVAL      DDCRSA = *BLANKS
     C                   EVAL      DDCODO = *BLANKS
     C                   EVAL      DDJACM = *BLANKS
     C                   EVAL      DDMAIL = *BLANKS
     C                   EVAL      DDPHON = *BLANKS
     C                   EVAL      DDRPAY = *BLANKS
     C                   EVAL      DDAUHO = *BLANKS

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
(c) Finastra International Limited 2016
