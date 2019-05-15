     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2016')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD CRS Non-Account Holder Details Report')       *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD000721P - Midas SD CRS Non-Account Holder Details Report   *
      *                                                               *
      *  Function:  This is a new program to list the details of all  *
      *             CRS NAHO Details Report in the system.            *
      *                                                               *
      *  (c) Finastra International Limited 2016                      *
      *                                                               *
      *  Last Amend No. MD039670           Date 26Jul16               *
      *  Prev Amend No. CGL177  *CREATE    Date 11Jan16               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD039670 - FATCA Housekeeping program                        *
      *  CGL177 - CRS Reporting Phase 2                               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    05  - Overflow Indicator SD000721P1                        *
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

      ** Midas SD CRS Non-Account Holder Details retrieval index
     F*SDFTNHL1  IF   E           K DISK
     FSDCRNHL0  IF   E           K DISK

      ** Midas SD CRS Non-Account Holder Country Details retrieval index
     FSDCRSNL2  IF   E           K DISK

      ** Non-Account Holder Details Master File Retrieval
     FSDNAHOL1  IF   E           K DISK

      ** RPT: CRS Non-Account Holder details report
     FSD000721P1O    E             PRINTER INFSR(*PSSR)
     F                                     OFLIND(*IN05)
     F                                     USROPN
     F                                     INFDS(SPOOL)

      ** RPT: CRS Non-Account Holder details report audit.
     FSD000721AUO    E             PRINTER INFSR(*PSSR)
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

      ** Non-account Holder Details Data Structure
     D SDNAHO        E DS                  EXTNAME(SDNAHOPD)

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
     D PNAHo           S             10A

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
      *            Controls Set-up of SD000721 Details                *
      *            Outputs SD000721 Details                           *
      *                                                               *
      * Called by: Main Routine                                       *
      *                                                               *
      *****************************************************************

     C     SRMAIN        BEGSR

      ** For customers

     C                   EXSR      SRNHOLDER
     C                   EVAL      *INLR = *ON

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRNHOLDER - Look up SD Non-Account Holder Details retrieval   *
      *              index and handles the set-up.                    *
      *                                                               *
      * Called by: SRMAIN                                             *
      *                                                               *
      * Calls: SRNAHOSET, SROPENP1                                    *
      *                                                               *
      *****************************************************************

     C     SRNHOLDER     BEGSR

      ** Do unit end of  SD CRS Customer Details retrieval index.

     C                   READ      SDCRNHL0                               14
     C     NRNAHO        SETLL     SDCRNHL0
     C                   DOW       NOT %EOF (SDCRNHL0)

      ** Read through SD CRS Customer Details retrieval index.

     C                   READ      SDCRNHL0                               14
                                                                                            MD039670
     C                   CALL      'AONAHOR0'                                               MD039670
     C                   PARM      *BLANKS       PRtCd                                      MD039670
     C                   PARM      '*KEY   '     POptn                                      MD039670
     C                   PARM      NRNAHO        PNAHo                                      MD039670
     C     SDNAHO        PARM      SDNAHO        DSSDY                                      MD039670
                                                                                            MD039670
     C                   IF        PRTCD = '*NRF'                                           MD039670
     C                             OR NHCHTP = 'D'                                          MD039670
     C                   READ      SDCRNHL0                                                 MD039670
     C                   ITER                                                               MD039670
     C                   ENDIF                                                              MD039670
     C                   IF        NOT %EOF (SDCRNHL0)
     C                   EVAL      WNahoCtr = WNahoCtr + 1

      ** Opens printer file once/on first customer reading including the header.

     C                   IF        WNahoCtr = 1
     C                   EXSR      SROPENP1
     C                   WRITE     SD0721R0
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

     C     NRNAHO        CHAIN     SDNAHOL1                           16
     C                   IF        NOT %FOUND (SDNAHOL1)
     C                   EVAL      DBFILE = 'SDNAHOL1'
     C                   EVAL      DBASE = 1
     C                   EVAL      DBKEY = NRNAHO
     C                   EXSR      *PSSR
     C                   ELSE

      ** Non-account holder, report name, report town.

     C                   EVAL      DDNAHO = NRNAHO
     C                   EVAL      DDCRNM = NHNARN
     C                   EVAL      DDCRTN = NHNATW

     C                   ENDIF

      ** Report in List or Audit Mode

     C                   IF        (PMode = 'A' AND NHLCDT = BJRDNB)
     C                             OR PMode = 'L' OR PMode = ' '

      ** Initiate fields to blanks before writing details.

     C                   EXSR      SRBLANK1

      ** Invoke records from database to fields.

     C                   EXSR      SRDETAILS

      ** Display NAHO details and information.
      ** Print Header and NAHO details if overflow occurs.

     C                   EVAL      WReqLin = 3
     C                   IF        PrtLn1 + WReqLin >= OflLn1
     C                   EXSR      SROVRFLOW
     C                   ELSE
     C                   WRITE     SD0721R1
     C                   ENDIF

     C                   EVAL      WReqLin = 10
     C                   IF        PrtLn1 + WReqLin >= OflLn1
     C                   EXSR      SROVRFLOW
     C                   ENDIF
     C                   WRITE     SD0721R2

     C                   EVAL      WNahoCnt = WNahoCnt + 1

      ** Process CRS Country Details per NAHO
     C                   EXSR      SRCTRYDET

     C                   ENDIF

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


      ** CRS Main details

      ** CRS Type
     C                   EVAL      DDTYPE = NRTYPE
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

      ** CRS Subtype
     C                   EVAL      DDSTYP = NRSTYP
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
     C                   EVAL      DDHVAL = NRHVAL

      ** CRS Country of Domicile
     C                   EVAL      DDCODM = NHCOLC

      ** CRS Exempt Flag
     C                   EVAL      DDEXMP = NREXMP

      ** CRS CRS Exemption Date/Time
     C                   EVAL      WTempDate = NREXMD
     C                   EXSR      SRZDate2

     C                   IF        ZDATE > 0
     C                   MOVEL     ZADATE        DDEXDT
     C                   ELSE
     C                   EVAL      DDEXDT = *BLANKS
     C                   ENDIF
      *
     C                   MOVEL     NREXMT        DDEXTM

      ** CRS Exemption - User
     C                   EVAL      DDEXMU = NREXMU

      ** CRS Exempt Remark
     C                   EVAL      DDEXR1 = %SUBST(NREXMR:1:64)
     C                   EVAL      DDEXR2 = %SUBST(NREXMR:65:64)
     C                   EVAL      DDEXR3 = %SUBST(NREXMR:129:64)
     C                   EVALR     DDEXR4 = %SUBST(NREXMR:193:64)

      ** CRS Info Complete
     C                   EVAL      DDINFO = NRINFO

      ** CRS Exception Management Flag
     C                   EVAL      DDEXMG = NREXMG

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRCTRYDET - Process CRS Country Details per NAHO              *
      *                                                               *
      * Called by: SRNAHOSET                                          *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     SRCTRYDET     BEGSR

      ** Process CRS Country fields details.
     C     NRNAHO        SETLL     SDCRSNL2
     C                   READ      SDCRSNL2

     C                   DOW       NOT %EOF (SDCRSNL2)

     C                   IF        NRNAHO = CNNAHO

      ** Initiate CRS Country fields to blanks before writing details.
     C                   EXSR      SRBLANK2

      ** Country field
     C                   EVAL      DDCTRY = CNCTRY

      ** Subject to Reporting
     C                   EVAL      DDREPT = CNREPT

      ** Reporting - User
     C                   EVAL      DDREPU = CNREPU

      ** Reporting - Date/Time
     C                   EVAL      WTempDate = CNREPD
     C                   EXSR      SRZDate2

     C                   IF        ZDATE > 0
     C                   MOVEL     ZADATE        DDRPDT
     C                   ELSE
     C                   EVAL      DDRPDT = *BLANKS
     C                   ENDIF
      *
     C                   MOVEL     CNREPM        DDRPTM

      ** Reason fields
     C                   EVAL      DDRPR1 = %SUBST(CNREPR:1:64)
     C                   EVAL      DDRPR2 = %SUBST(CNREPR:65:64)

      ** Evidence fields
     C                   EVAL      DDEVE1 = CNEVE1
     C                   EVAL      DDEVE2 = CNEVE2
     C                   EVAL      DDEVE3 = CNEVE3
     C                   EVAL      DDEVE4 = CNEVE4
     C                   EVAL      DDEVE5 = CNEVE5

      ** Effective Date
     C                   EVAL      WTempDate = CNEFFD
     C                   EXSR      SRZDate2

     C                   IF        ZDATE > 0
     C                   MOVEL     ZADATE        DDEFFD
     C                   ELSE
     C                   EVAL      DDEFFD = *BLANKS
     C                   ENDIF

      ** Tax Id. No
     C                   EVAL      DDTINN = CNTINN

      ** Expiry Date
     C                   EVAL      WTempDate = CNEXPD
     C                   EXSR      SRZDate2

     C                   IF        ZDATE > 0
     C                   MOVEL     ZADATE        DDEXPD
     C                   ELSE
     C                   EVAL      DDEXPD = *BLANKS
     C                   ENDIF

      ** CRS Agreement
     C                   CALL      'AONAHOR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      NRNAHO        PNAHo
     C     SDNAHO        PARM      SDNAHO        DSSDY

     C                   EVAL      WCOLC = NHCOLC
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
     C                   EVAL      DDCODO = CNCODO

      ** Joint Account Member
     C                   EVAL      DDJACM = CNJACM

      ** Mailing Country
     C                   EVAL      DDMAIL = CNMAIL

      ** Phone Number Ctry
     C                   EVAL      DDPHON = CNPHON

      ** Regular Payment
     C                   EVAL      DDRPAY = CNRPAY

      ** Write Country Details
     C                   EVAL      WReqLin = 8
     C                   IF        PrtLn1 + WReqLin >= OflLn1
     C                   EXSR      SROVRFLOW
     C                   ENDIF
     C                   WRITE     SD0721R3

     C                   ENDIF

     C                   READ      SDCRSNL2

     C                   ENDDO


     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SROVRFLOW - Prints Title and Customer Details if Overflow     *
      *                                                               *
      * Called by: SRNAHOSET                                          *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     SROVRFLOW     BEGSR
      *
      ** Prints title and customer details
      *
     C                   WRITE     SD0721R0
     C                   WRITE     SD0721R1

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SROPENP1 - Open printer file SD000721P1                       *
      *                                                               *
      * Called by: SRNAHOSET                                          *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     SROPENP1      BEGSR

      ** open printer file and indicate that there is atleast one
      ** detail to report; ensure report spool file recorded by RCF

     C                   IF        NOT %OPEN (SD000721P1)
     C                   OPEN      SD000721P1

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
      * SRCLOSEP1 - Closes printer file SD000721P1                    *
      *                                                               *
      * Called by: SRNHOLDER                                          *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     SRCLOSEP1     BEGSR

     C                   IF        %OPEN (SD000721P1)
     C                   EVAL      WReqLin = 2
     C                   IF        PrtLn1 + WReqLin >= OflLn1
     C                   WRITE     SD0721R0
     C                   ENDIF
     C                   WRITE     SD0721R14
     C                   CLOSE     SD000721P1
     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRBLANK1 - Initiate all CRS Main fields to blanks.            *
      *                                                               *
      * Called by: SRNAHOSET                                          *
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
      * Called by: SRNAHOSET                                          *
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
     C                   Z-ADD     WNahoCnt      RRNAHL
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

     C                   Z-ADD     WNahoCnt      RRNAHL

      ** print standard totals report

     C                   IF        RRNAHL > 0
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
