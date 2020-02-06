     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Commitment Fees Enquiry')                     *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LE000250 - Commitment Fees Enquiry                           *
      *                                                               *
      *  Function:  This module will allow the user to browse the fee *
      *             amounts to be charged at the next fee payment and *
      *             how these are calculated based on the previous    *
      *             Close of Business(COB).                           *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CLE134             Date 01Aug12               *
      *                 CLE148             Date 23Jul12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CLE042             Date 06Sep05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE037  *CREATE    Date 09Dec03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CLE148 - Alpha Loan Reference (Recompile)                    *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE037 - Nordea Commitment Fee Update                        *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Midas LE Fee detail file
     FLEFEEDL1  IF   E           K DISK    INFSR(*PSSR)
 
      ** Midas LE commitment fee detail file
     FLECFEEL0  IF   E           K DISK    INFSR(*PSSR)
 
      ** Midas LE commitment fee display file
     FLE000250DFCF   E             WORKSTN SFILE(LE000250S0:#0FREC)
     F                                     SFILE(LE000250S1:#1FREC)
     F                                     SFILE(LE000250S2:#2FREC)
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      **---------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA
      ** layout and the copyright array definition.
     D/COPY ZACPYSRC,STD_D_SPEC
      **---------------------------------------------------------------
 
      **---------------------------------------------------------------
      ** The following /COPY line includes all of the defined fields
      ** in the PSDS. They have meaningful names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
 
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
 
     D/COPY ZACPYSRC,ERR_ARRAYS
 
      **---------------------------------------------------------------
 
      ** +--------------------------------------+
      ** ¦ Named Constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Customer Details Data Structure
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** Customer Details Data Structure
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
 
      ** External data structure for Currency Details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      ** Dummy Data Structure (Short) for Access Objects' use
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Dummy Data Structure (Long) for Access Objects' use
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** +--------------------------------------+
      ** ¦ Declared Variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Keylist for Commitment Fee File
     D WKeyBRCA        S              3A
     D*WKeyCNUM*       S              6  0                                                    CSD027
     D WKeyCNUM        S              6                                                       CSD027
     D WKeyFACT        S              3  0
     D WKeyFACN        S              2  0
     D WKeyFSEQ        S              2  0
 
      ** Access Object Parameters
     D PRetCode        S              7A
     D POption         S              7A
     D PCurrency       S              3A
 
      ** ZEDIT/ZALIGN Parameters
     D PzAlignOK       S              1A   INZ('Y')
     D PzField         S             16A
     D PzADec          S              1P 0
     D PzADig          S              2P 0
 
      ** ZDATE2 Parameters
     D PzDayNo         S              5  0
     D PzDate          S              6  0
     D PzADate         S              7A
 
      ** ZSEDIT fields
     D PzFld15         S             15  0
     D PzDecs          S              1  0
     D PzECode         S              1
     D PzOut21         S             21
 
      ** Parameters for SDRTVTXT
     D PMsgId          S              7A
     D PMsgFNm         S             10A
     D PMsgDesc        S             80A
 
      ** Parameters for ZA0350
     D PMsgFileZ       S             10A   INZ('LERMSGF')
     D PMsgIdZ         S             10A
     D PMsgDataZ       S             45A
 
      ** Index for arrays
     D Idx             S              3P 0
     D WIdx            S              3P 0
 
      ** Subfile relative record no.
     D #0FREC          S              5S 0
     D #1FREC          S              5S 0
     D #2FREC          S              5S 0
 
      ** Work and key variables
     D*WrkKeyCust      S              6S 0                                                    CSD027
     D WrkKeyCust      S              6A                                                      CSD027
     D WrkSFCT         S              3A
     D WrkSFCN         S              2A
     D WrkOldSFCT      S              3A
     D WrkOldSFCN      S              2A
     D WrkPDST         S              7A
     D WrkPDEN         S              7A
     D WrkTNUM         S              3A
     D WrkCALT         S              2  0
     D WrkPeriod       S              8A
     D WrkNoYear       S              4A
     D WrkTotDay       S              5P 0
     D WrkTotAmt       S             13P 0
     D WrkCount        S              3  0
     D WrkFREC         S              5S 0
     D WrkTemp4        S              4A
     D WCaltTier       S              1A
     D WrkError        S              1A
     D WrkPrntPRD      S              1A
     D WrkDspRec       S              1A
     D WrkScrn         S              1A   INZ('B')
     D WrkFld11        S             11A
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +---------------- Start of Main Processing ------------------+
      ** ¦                                                            ¦
      ** ¦  *INZSR is automatically executed at program activation.   ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
 
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
 
     C                   DOU       *INKC = *ON
 
      ** Build and validate screen 1
 
     C                   IF        WrkScrn = 'B'
 
     C                   IF        *INKL = *OFF
     C                   EXSR      SrInit
     C                   ENDIF
     C                   EXSR      SrBldSfl1
 
     C                   ENDIF
 
      ** Process valid subfile and display details(screen 2)
 
     C                   IF        WrkScrn = 'D'
 
     C                   READC     LE000250S0                             89
     C                   DOW       *IN89 = *OFF AND
     C                             *INKC = *OFF AND
     C                             *INKL = *OFF
 
     C                   IF        #0SEL = 'E'
     C                   EVAL      #0SEL = *BLANK
     C                   EXSR      SrUpdSfl1
     C                   EXSR      SrBldSfl2
     C                   ENDIF
 
     C                   READC     LE000250S0                             89
 
      ** Display previous screen if necessary
 
     C                   EXSR      SrPrevSCrn
     C                   ENDDO
 
     C                   EVAL      WrkScrn = 'B'
     C                   ENDIF
 
     C                   ENDDO
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrBldSfl1 - Build Subfile (Screen 1)                         *
      *                                                               *
      *****************************************************************
 
     C     SrBldSfl1     BEGSR
 
      ** Set on ROLLUP indicator to drive initial loop.
 
     C                   EVAL      *IN88 = *ON
 
      ** Read records from the file into the subfile until a page has
      ** been filled or there are no more records.
      ** Repeat the process until either the end of file, ROLLUP
      ** has not been entered or F3 or F5  is input.
 
     C                   DOW       *INKC = *OFF AND
     C                             *IN88 = *ON
 
      ** Bypass build subfile if not from Screen 2
 
     C                   IF        *INKL = *OFF
 
      ** Initialise count of records written to subfile page.
 
     C                   EVAL      WrkCount = *ZERO
 
      ** For each record read, write it to the subfile.
      ** Do this until end of file or the subfile page is full.
 
     C                   DOW       NOT %EOF(LEFEEDL1) AND
     C                             WrkCount < 14
 
      ** Select data to be displayed
 
     C                   EXSR      SrSelect
     C                   IF        WrkDspRec = 'Y'
 
      ** Increment the subfile record no. and records written fields.
 
     C                   EVAL      #0FREC   = #0FREC + 1
     C                   EVAL      WrkCount = WrkCount + 1
 
      ** Format fields for output
 
     C                   EXSR      SrFmtDetl1
 
     C                   EVAL      #0SFRN = #0FREC
     C                   EVAL      WrkFREC = #0FREC
     C                   WRITE     LE000250S0
 
     C                   ENDIF
 
      ** Read a valid record
 
     C                   READ      LEFEEDF                                86
     C                   ENDDO
 
      ** Set up footer toggle text and write the footer
 
     C                   EVAL      *IN11 = *OFF
     C                   WRITE     LE000250F1
 
      ** If there is no data to display, set on SFLCLR condition and
      ** write the subfile control record
 
     C                   IF        WrkCount = 0
     C                   EVAL      *IN87 = *ON
     C                   WRITE     LE000250C0
     C                   EVAL      *IN87 = *OFF
     C                   EVAL      #0FREC = 1
     C                   EVAL      #0SFRN = 1
 
     C                   EXSR      SRClrMsg
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdArr(Idx) = 'LEE0308'
     C                   EXSR      SRSndMsg
 
      ** Write the message subfile
 
     C                   WRITE     LE000250CM
 
      ** Write to the subfile with non-display set on
 
     C                   EVAL      *IN14 = *ON
     C                   WRITE     LE000250S0
     C                   EVAL      *IN14 = *OFF
     C                   WRITE     LE000250C0
 
     C                   ELSE
 
      ** Write the subfile control record to the screen to display
      ** the subfile.
 
     C                   WRITE     LE000250CM
     C                   WRITE     LE000250C0
     C                   ENDIF
     C                   ENDIF
 
      ** Read the subfile control record to determine whether records
      ** have been selected or whether ROLLUP is required.
 
     C                   EXSR      SrRdSfl1
 
     C                   ENDDO
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrRdSfl1 - Read Subfile                                      *
      *                                                               *
      *****************************************************************
 
     C     SrRdSfl1      BEGSR
 
     C                   IF        *INKL = *OFF
     C                   READ      LE000250C0                             89
     C                   ENDIF
 
      ** Clear any messages before processing user input
 
     C                   EVAL      MsgIdArr   = *BLANKS
     C                   EVAL      MsgDtaArr  = *BLANKS
 
     C                   SELECT
     C                   WHEN      *INKC = *ON OR
     C                             *IN88 = *ON AND *INKL = *OFF
 
      ** If F3 is pressed, or ROLLUP, goto end subroutine
 
     C                   WHEN      *INKE = *ON
 
      ** If F5 is pressed, clear selection field
 
     C                   EVAL      #0SCNM = *BLANKS
     C                   EVAL      #0SFCT = *BLANKS
     C                   EVAL      #0SFCN = *BLANKS
 
     C                   OTHER
 
      ** Else, validate subfile
 
     C                   IF        *INKL = *OFF
     C                   EXSR      SrValSfl1
     C                   ENDIF
     C                   EXSR      SrReDsp
 
     C                   ENDSL
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrSetupKey1 - Set-up key field                               *
      *                                                               *
      *****************************************************************
 
     C     SrSetupKey1   BEGSR
 
      ** Run check to see if selection field is valid (#0SCNM)
      ** If the selection field is invalid, blank out Key
 
     C                   MOVE      *BLANKS       PzField
     C                   IF        #0SCNM <> *BLANKS
     C                   MOVE      #0SCNM        PzField
     C                   EVAL      PzADec = 0
     C                   EVAL      PzADig = 6
     C                   EXSR      SrZAlign
 
     C                   IF        PZAlignOk = 'N'
     C**********         EVAL      WrkKeyCust  = *ZEROS                                       CSD027
     C                   EVAL      WrkKeyCust  = *BLANKS                                      CSD027
     C                   ELSE
     C                   MOVE      PzField       WrkKeyCust
     C                   ENDIF
 
     C                   ELSE
     C**********         EVAL      WrkKeyCust  = *ZEROS                                       CSD027
     C                   EVAL      WrkKeyCust  = *BLANKS                                      CSD027
     C                   ENDIF
 
      ** Store facility type and number
 
     C                   EVAL      WrkOldSFCT = #0SFCT
     C                   EVAL      WrkOldSFCN = #0SFCN
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrValSfl1 - Validate Subfile                                  *
      *                                                               *
      *****************************************************************
 
     C     SrValSfl1     BEGSR
 
     C                   EVAL      WrkError = 'N'
     C                   EXSR      SRClrMsg
 
     C                   READC     LE000250S0                             89
 
     C                   DOW       *IN89 = *OFF
 
     C                   IF        #0SEL <> 'E' AND #0SEL <> ' '
     C                   EVAL      *IN13 = *ON
     C                   IF        WrkError = 'N'
     C                   EVAL      #0SFRN = #0FREC
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdArr(Idx) = 'LEE0001'
     C                   EXSR      SRSndMsg
     C                   WRITE     LE000250CM
     C                   EVAL      WrkError = 'Y'
     C                   ENDIF
     C                   ENDIF
 
      ** Update record in subfile
 
     C                   EXSR      SrUpdSfl1
     C                   EVAL      *IN13 = *OFF
 
      ** Read subfile
 
     C                   READC     LE000250S0                             89
 
     C                   ENDDO
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrUpdSfl1 - Update subfile record                            *
      *                                                               *
      *****************************************************************
 
     C     SrUpdSfl1     BEGSR
 
     C                   EVAL      *IN82 = *ON
     C                   UPDATE    LE000250S0
     C                   EVAL      *IN82 = *OFF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrFmtDetl1 - format details for output                        *
      *                                                               *
      *****************************************************************
 
     C     SrFmtDetl1    BEGSR
 
     C                   EVAL      #0SEL  = *BLANK
     C                   MOVE      FECNUM        #0CNUM
     C                   MOVEL     FEFACL        #0FACT
     C                   MOVE      FEFACL        #0FACN
     C                   MOVEL     FEFSEQ        #0FSEQ
     C                   EVAL      #0FCCY = FEFCCY
 
     C                   EVAL      PzDayNo = FELPDT
     C                   IF        PzDayNo <> *ZERO
     C                   EXSR      SrZDate2
     C                   EVAL      #0LPDT = PzADate
     C                   ELSE
     C                   EVAL      #0LPDT = *BLANKS
     C                   ENDIF
 
     C                   EVAL      PzDayNo = FENPYD
     C                   IF        PzDayNo <> *ZERO
     C                   EXSR      SrZDate2
     C                   EVAL      #0NPYD = PzADate
     C                   ELSE
     C                   EVAL      #0NPYD = *BLANKS
     C                   ENDIF
 
      ** Hidden fields
 
     C                   EVAL      #0BRCA = FEBRCA
     C                   MOVEL     FEPSTD        #0PSTD
     C                   MOVEL     FEPEND        #0PEND
     C                   EVAL      #0CALT = FECALT
     C                   EVAL      #0CALC = FECALC
 
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrBldSfl2 - Build Subfile (Screen 2)                         *
      *                                                               *
      *****************************************************************
 
     C     SrBldSfl2     BEGSR
 
      ** Setup Key Fee file
 
     C                   EXSR      SrSetupKey2
 
      ** Clear message subfile
 
     C                   EXSR      SRClrMsg
 
     C                   EVAL      WrkTotDay = *ZERO
     C                   EVAL      WrkTotAmt = *ZERO
 
      ** Initialise subfile relative record number.
 
     C                   EVAL      #1FREC = *ZERO
     C                   EVAL      #2FREC = *ZERO
     C                   MOVEA     '000'         *IN(21)
     C                   EVAL      *IN11 = *ON
 
      ** Set file pointer on key displayed on screen.
 
     C     KComFee       CHAIN     LECFEED0                           24
     C                   IF        *IN24 = *ON
     C                   EVAL      *IN22 = *ON
 
      ** Write the message subfile
 
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdArr(Idx) = 'LEE0308'
     C                   EXSR      SRSndMsg
     C                   ELSE
 
     C                   EVAL      *IN21 = *ON
     C                   EVAL      *IN22 = *ON
     C                   EVAL      *IN23 = *ON
     C                   EVAL      #1FREC = 1
     C                   EVAL      #2FREC = 1
 
     C                   DOU       *IN24 = *ON
     C                   EVAL      WrkTotDay = WrkTotDay + CFNUMD
     C                   IF        WCaltTier = 'N'
     C                   EXSR      SrFmtDetl2
     C                   WRITE     LE000250S1
     C                   EVAL      #1FREC = #1FREC + 1
     C                   ELSE
     C                   EXSR      SrFmtDetl3
     C                   WRITE     LE000250S2
     C                   EVAL      #2FREC = #2FREC + 1
     C                   ENDIF
     C     KComFee       READE     LECFEED0                               24
     C                   ENDDO
     C                   ENDIF
 
     C                   EXSR      SrFmtTot
 
     C                   IF        WCaltTier = 'N'
     C                   WRITE     LE000250C1
     C                   ELSE
     C                   WRITE     LE000250C2
     C                   ENDIF
 
     C                   WRITE     LE000250H0
     C                   WRITE     LE000250F1
     C                   WRITE     LE000250CM
 
     C                   IF        WCaltTier = 'N'
     C                   READ      LE000250C1
     C                   ELSE
     C                   READ      LE000250C2
     C                   ENDIF
 
      ** Clear subfile
 
     C                   MOVEA     '000'         *IN(21)
     C                   IF        WCaltTier = 'N'
     C                   WRITE     LE000250C1
     C                   ELSE
     C                   WRITE     LE000250C2
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrSetupKey2 - Set-up Key Fields for Screen 2                 *
      *                                                               *
      *****************************************************************
 
     C     SrSetupKey2   BEGSR
 
      ** Set-up key field
 
     C                   EVAL      WKeyBRCA = #0BRCA
     C                   MOVEL     #0CNUM        WKeyCNUM
     C                   MOVEL     #0FACT        WKeyFACT
     C                   MOVEL     #0FACN        WKeyFACN
     C                   MOVEL     #0FSEQ        WKeyFSEQ
 
      ** Customer number, Facility type, sequence and currency
 
     C                   EVAL      #1CNUM = #0CNUM
     C     #0FACT        CAT       '/'           WrkTemp4
     C     WrkTemp4      CAT       #0FACN        #1FCLT
     C                   EVAL      #1FSEQ = #0FSEQ
     C                   EVAL      #1FCCY = #0FCCY
 
      ** Get currency details
 
     C                   EVAL      PCurrency = #0FCCY
     C                   EXSR      SrSDCURR
 
      ** Calculation Type
 
     C                   EVAL      #1CALT = #0CALT
     C                   MOVE      #1CALT        WrkCALT
     C                   MOVEA     '00000'       *IN(14)
 
     C                   SELECT
     C                   WHEN      WrkCALT <= 6
     C                   EVAL      *IN15 = *ON
     C                   WHEN      WrkCALT <= 16
     C                   EVAL      *IN16 = *ON
     C                   WHEN      WrkCALT <= 22
     C                   EVAL      *IN17 = *ON
     C                   ENDSL
 
      ** If Calculation type is Tiered
 
     C                   EVAL      WCaltTier = 'N'
     C                   IF        WrkCALT =  1 OR
     C                             WrkCALT =  4 OR
     C                             WrkCALT = 11 OR
     C                             WrkCALT = 14
     C                   EVAL      WCaltTier = 'Y'
     C                   EVAL      WrkPrntPRD  = 'Y'
     C                   ENDIF
 
      ** Start Date
 
     C                   MOVE      #0PSTD        PzDayNo
     C                   IF        PzDayNo <> *ZERO
     C                   EXSR      SrZDate2
     C                   EVAL      #1PSTD = PzADate
     C                   ELSE
     C                   EVAL      #1PSTD = *BLANKS
     C                   ENDIF
 
      ** End Date
 
     C                   MOVE      #0PEND        PzDayNo
     C                   IF        PzDayNo <> *ZERO
     C                   EXSR      SrZDate2
     C                   EVAL      #1PEND = PzADate
     C                   ELSE
     C                   EVAL      #1PEND = *BLANKS
     C                   ENDIF
 
      ** Calculation type Narrative
 
     C                   EVAL      #1NARR = *BLANKS
     C                   SELECT
     C                   WHEN      #1CALT = '01'
     C                   EVAL      PMsgID = 'LER1185'
     C                   WHEN      #1CALT = '02'
     C                   EVAL      PMsgID = 'LER1186'
     C                   WHEN      #1CALT = '03'
     C                   EVAL      PMsgID = 'LER1187'
     C                   WHEN      #1CALT = '04'
     C                   EVAL      PMsgID = 'LER1188'
     C                   WHEN      #1CALT = '05'
     C                   EVAL      PMsgID = 'LER1189'
     C                   WHEN      #1CALT = '06'
     C                   EVAL      PMsgID = 'LER1190'
     C                   WHEN      #1CALT = '11'
     C                   EVAL      PMsgID = 'LER1191'
     C                   WHEN      #1CALT = '12'
     C                   EVAL      PMsgID = 'LER1192'
     C                   WHEN      #1CALT = '13'
     C                   EVAL      PMsgID = 'LER1193'
     C                   WHEN      #1CALT = '14'
     C                   EVAL      PMsgID = 'LER1194'
     C                   WHEN      #1CALT = '15'
     C                   EVAL      PMsgID = 'LER1195'
     C                   WHEN      #1CALT = '16'
     C                   EVAL      PMsgID = 'LER1196'
     C                   WHEN      #1CALT = '21'
     C                   EVAL      PMsgID = 'LER1197'
     C                   WHEN      #1CALT = '22'
     C                   EVAL      PMsgID = 'LER1198'
     C                   ENDSL
 
     C                   EXSR      SrRtvTxt
     C                   EVAL      #1NARR = PMsgDesc
 
      ** Payment Dates
 
     C                   EVAL      #1LPDT = #0LPDT
     C                   EVAL      #1NPYD = #0NPYD
 
     C                   SELECT
     C                   WHEN      #0CALC = 1 OR
     C                             #0CALC = 4
     C                   EVAL      WrkNoYear = '/365'
 
     C                   WHEN      #0CALC = 2 OR
     C                             #0CALC = 3 OR
     C                             #0CALC = 5
     C                   EVAL      WrkNoYear = '/360'
 
     C                   WHEN      #0CALC = 6
     C                   EVAL      WrkNoYear = '/366'
 
     C                   ENDSL
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrFmtDetl2 - format details for output(screen2;non-tiered)    *
      *                                                               *
      *****************************************************************
 
     C     SrFmtDetl2    BEGSR
 
      ** Amount
 
     C                   EVAL      #1BALA  = *BLANKS
     C                   MOVE      *BLANKS       PzFld15
     C                   MOVE      CFBALA        PzFld15
     C                   EVAL      PzDecs = A6NBDP
     C                   EVAL      PzECode = 'L'
     C                   EXSR      SrZSEdit
     C                   MOVE      PzOut21       #1BALA
 
      ** Percentage
 
     C                   EVAL      #1PCT = *BLANKS
     C                   IF        CFPCT <> *ZEROS
     C                   MOVE      *BLANKS       PzField
     C                   MOVE      CFPCT         PzField
     C                   EVAL      PzADec = 3
     C                   EXSR      SrZEdit
     C                   MOVE      PzField       #1PCT
     C                   ENDIF
 
      ** Rate
 
     C                   EVAL      #1RATE = *BLANKS
     C                   MOVE      *BLANKS       PzField
     C                   MOVE      CFRATE        PzField
     C                   EVAL      PzADec = 5
     C                   EXSR      SrZEdit
     C                   MOVE      PzField       #1RATE
 
      ** Number of Days
 
     C                   EVAL      #1NUMD  = *BLANKS
     C                   MOVE      *BLANKS       PzField
     C                   MOVE      CFNUMD        PzField
     C                   EVAL      PzADec = 0
     C                   EXSR      SrZEdit
     C                   MOVE      PzField       #1NUMD
 
      ** Fee Amount
 
     C                   EVAL      #1FAMT  = *BLANKS
     C                   MOVE      *BLANKS       PzFld15
     C                   MOVE      CFFAMT        PzFld15
     C                   EVAL      PzDecs = A6NBDP
     C                   EVAL      PzECode = 'L'
     C                   EXSR      SrZSEdit
     C                   MOVE      PzOut21       #1FAMT
 
      ** Period
 
     C                   EVAL      #1PRD = *BLANKS
     C                   EVAL      PzDayNo = CFPDST
     C                   IF        PzDayNo <> *ZERO
     C                   EXSR      SrZDate2
     C                   EVAL      WrkPDST = PzADate
     C                   ELSE
     C                   EVAL      WrkPDST = *ZERO
     C                   ENDIF
 
     C                   EVAL      PzDayNo = CFPDEN
     C                   IF        PzDayNo <> *ZERO
     C                   EXSR      SrZDate2
     C                   EVAL      WrkPDEN = PzADate
     C                   ELSE
     C                   EVAL      WrkPDEN = *ZERO
     C                   ENDIF
     C     WrkPDST       CAT       '-'           WrkPeriod
     C     WrkPeriod     CAT       WrkPDEN       #1PRD
 
     C                   EVAL      WrkTotAmt = WrkTotAmt + CFFAMT
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrFmtDetl3 - format details for output(screen2; Tiered)       *
      *                                                               *
      *****************************************************************
 
     C     SrFmtDetl3    BEGSR
 
      ** Amount
 
     C                   EVAL      #2BALA  = *BLANKS
     C                   EVAL      #2BALA  = *BLANKS
     C                   MOVE      *BLANKS       PzFld15
     C                   MOVE      CFBALA        PzFld15
     C                   EVAL      PzDecs = A6NBDP
     C                   EVAL      PzECode = 'L'
     C                   EXSR      SrZSEdit
     C                   MOVE      PzOut21       #2BALA
 
      ** Tiered Amount
 
     C                   EVAL      #2TAMT = *BLANKS
     C                   IF        CFTAMT <> *ZERO
     C                   EVAL      *IN18 = *ON
     C                   EVAL      #2TAMT  = *BLANKS
     C                   MOVE      *BLANKS       PzFld15
     C                   MOVE      CFTAMT        PzFld15
     C                   EVAL      PzDecs = A6NBDP
     C                   EVAL      PzECode = 'L'
     C                   EXSR      SrZSEdit
     C                   MOVE      PzOut21       #2TAMT
     C                   ELSE
 
      ** Percentage
 
     C                   IF        CFPCT <> *ZEROS
     C                   EVAL      *IN18 = *OFF
     C                   EVAL      WrkFld11 = *BLANKS
     C                   MOVE      *BLANKS       PzField
     C                   MOVE      CFPCT         PzField
     C                   EVAL      PzADec = 3
     C                   EXSR      SrZEdit
     C                   MOVE      PzField       WrkFld11
     C                   MOVEL     WrkFld11      #2TAMT
     C                   ELSE
     C                   EVAL      #2TAMT = *BLANKS
     C                   ENDIF
     C                   ENDIF
 
      ** Rate
 
     C                   EVAL      #2RATE = *BLANKS
     C                   MOVE      *BLANKS       PzField
     C                   MOVE      CFRATE        PzField
     C                   EVAL      PzADec = 5
     C                   EXSR      SrZEdit
     C                   MOVE      PzField       #2RATE
 
      ** Number of Days
 
     C                   EVAL      #2NUMD = *BLANKS
     C                   MOVE      *BLANKS       PzField
     C                   MOVE      CFNUMD        PzField
     C                   EVAL      PzADec = 0
     C                   EXSR      SrZEdit
     C                   MOVE      PzField       #2NUMD
 
      ** Fee Amount
 
     C                   EVAL      #2FAMT = *BLANKS
     C                   MOVE      *BLANKS       PzFld15
     C                   MOVE      CFFAMT        PzFld15
     C                   EVAL      PzDecs = A6NBDP
     C                   EVAL      PzECode = 'L'
     C                   EXSR      SrZSEdit
     C                   MOVE      PzOut21       #2FAMT
 
      ** Period
 
     C                   EVAL      #2PRD = *BLANKS
     C                   IF        WrkPrntPRD = 'Y'
 
     C                   EVAL      PzDayNo = CFPDST
     C                   IF        PzDayNo <> *ZERO
     C                   EXSR      SrZDate2
     C                   EVAL      WrkPDST = PzADate
     C                   ELSE
     C                   EVAL      WrkPDST = *ZERO
     C                   ENDIF
 
     C                   EVAL      PzDayNo = CFPDEN
     C                   IF        PzDayNo <> *ZERO
     C                   EXSR      SrZDate2
     C                   EVAL      WrkPDEN = PzADate
     C                   ELSE
     C                   EVAL      WrkPDEN = *ZERO
     C                   ENDIF
     C     WrkPDST       CAT       '-'           WrkPeriod
     C     WrkPeriod     CAT       WrkPDEN       #2PRD
 
     C                   EVAL      *IN14 = *ON
     C                   EVAL      WrkPrntPRD = 'N'
 
     C                   ELSE
 
     C                   EVAL      *IN19 = *ON
     C                   IF        CFTAMT = 0  AND CFNUMD <> 0
     C                   EVAL      *IN14 = *OFF
     C                   EVAL      *IN19 = *OFF
     C                   EVAL      WrkPrntPRD = 'Y'
     C                   EVAL      WrkTotAmt = WrkTotAmt + CFFAMT
     C                   EVAL      #2PRD = '  TOTAL TIERED:'
     C                   EVAL      #2RATE = *BLANKS
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrFmtTot -  Format total fee amount and total no. of days    *
      *                                                               *
      *****************************************************************
 
     C     SrFmtTot      BEGSR
 
     C                   MOVE      *BLANKS       PzField
     C                   MOVE      WrkTotDay     PzField
     C                   EVAL      PzADec = 0
     C                   EXSR      SrZEdit
     C                   MOVE      PzField       WrkTNUM
     C     WrkTNUM       CAT       WrkNoYear     #1TNUM
 
     C                   MOVE      *BLANKS       PzFld15
     C                   MOVE      WrkTotAmt     PzFld15
     C                   EVAL      PzDecs = A6NBDP
     C                   EVAL      PzECode = 'J'
     C                   EXSR      SrZSEdit
     C                   MOVE      PzOut21       #1TFAM
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrReDsp  - Re-display screen 1                               *
      *                                                               *
      *****************************************************************
 
     C     SrReDsp       BEGSR
 
     C                   DOW       WrkError = 'Y' AND
     C                             *INKC = *OFF   AND
     C                             *INKE = *OFF   AND
     C                             *IN88 = *OFF   OR
     C                             *INKL = *ON
     C                   EVAL      *IN11 = *OFF
     C                   WRITE     LE000250F1
     C                   EXFMT     LE000250C0
 
     C                   SELECT
     C                   WHEN      *INKE = *ON
     C                   EVAL      #0SCNM = *BLANKS
     C                   EVAL      #0SFCT = *BLANKS
     C                   EVAL      #0SFCN = *BLANKS
 
     C                   WHEN      *IN88 = *ON
     C                   EVAL      #0FREC = WrkFREC
 
     C                   OTHER
     C                   EXSR      SrValSfl1
     C                   ENDSL
 
     C                   ENDDO
 
     C                   IF        WrkError <> 'Y' AND
     C                             *INKC = *OFF    AND
     C                             *INKE = *OFF
     C                   EVAL      WrkScrn = 'D'
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrPrevScrn - Display previous screen                         *
      *                                                               *
      *****************************************************************
 
     C     SrPrevScrn    BEGSR
 
     C                   IF        *INKL = *ON AND
     C                             *IN89 = *OFF
 
     C                   EXSR      SRClrMsg
     C                   WRITE     LE000250CM
 
     C                   DOW       #0SEL = *BLANKS AND
     C                             *IN89 = *OFF
     C                   READC     LE000250S0                             89
     C                   ENDDO
 
     C                   IF        #0SEL = 'E'
     C                   EVAL      #0SFRN = #0FREC
     C                   EXSR      SrUpdSfl1
     C                   ENDIF
 
     C                   ENDIF
 
     C                   IF        *IN89 = *ON
     C                   EVAL      *INKL = *OFF
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrSelect - Select data to be displayed                       *
      *                                                               *
      *****************************************************************
 
     C     SrSelect      BEGSR
 
     C                   EVAL      WrkDspRec = 'N'
 
      ** The record must be a live facility loan
 
     C                   IF        FERECI = 'D' AND
     C                             FECALT <> *BLANKS
 
      ** End date must be less than or equal to rundate else,
      ** end date is not last payment date.
 
     C                   IF        FEPEND >= BJRDNB OR
     C                             FEPEND <  BJRDNB AND
     C                             FEPEND <> FELPDT
     C
 
     C                   MOVEL     FEFACL        WrkSFCT
     C                   MOVE      FEFACL        WrkSFCN
 
      ** display the selected facility type and/or facility number
 
     C                   IF        WrkOldSFCT = *BLANKS AND
     C                             WrkOldSFCN = *BLANKS OR
     C                             WrkOldSFCT = WrkSFCT AND
     C                             WrkOldSFCN = *BLANKS OR
     C                             WrkOldSFCT = *BLANKS AND
     C                             WrkOldSFCN = WrkSFCN OR
     C                             WrkOldSFCT = WrkSFCT AND
     C                             WrkOldSFCN = WrkSFCN
 
     C                   EVAL      WrkDspRec = 'Y'
 
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrSDCURR - Get Currency Details                              *
      *                                                               *
      *****************************************************************
 
     C     SrSDCURR      BEGSR
 
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      '*KEY'        POption
     C                   PARM                    PCurrency
     C     SDCURR        PARM      SDCURR        DSSDY
 
     C                   IF        PRetCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDCURRPD'
     C                   EVAL      DBKEY = #0FCCY
     C                   EVAL      DBASE = 2
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrZDate2 - Format Date from Midas Day No to ddmmmyy          *
      *                                                               *
      *****************************************************************
 
     C     SrZDate2      BEGSR
 
     C                   CALLB     'ZDATE2'
     C                   PARM                    PzDayNo
     C                   PARM                    BJDFIN
     C                   PARM      *ZEROS        PzDate
     C                   PARM                    PzADate
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrZAlign   - Format Alphanumeric Fields                      *
      *                                                               *
      *****************************************************************
 
     C     SrZAlign      BEGSR
 
     C                   CALLB     'ZALIGN'
     C                   PARM                    PzAlignOk
     C                   PARM                    PzField
     C                   PARM                    PzADec
     C                   PARM                    PzADig
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrZEdit    - Format Numeric Fields                           *
      *                                                               *
      *****************************************************************
 
     C     SrZEdit       BEGSR
 
     C                   CALLB     'ZEDIT'
     C                   PARM                    PzField
     C                   PARM                    PzADec
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrZSEdit  - Convert amount from file format to screen format  *
      *                                                               *
      *****************************************************************
 
     C     SrZSEdit      BEGSR
 
     C                   CALLB     'ZSEDIT'
     C                   PARM                    PzFld15
     C                   PARM                    PzDecs
     C                   PARM                    PzECode
     C                   PARM                    PzOut21
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRSndMsg - Send message to subfile                            *
      *                                                               *
      *****************************************************************
 
     C     SRSndMsg      BEGSR
 
      ** Send message to subfile
 
     C                   EVAL      Idx = 1
     C                   DOW       MsgIdArr(Idx) <> *BLANKS
 
     C                   CALL      'ZA0350'
     C                   PARM                    PMsgFileZ
     C                   PARM      MsgIdArr(Idx) PMsgIdZ
     C                   PARM      MsgDtaArr(Idx)PMsgDataZ
     C                   EVAL      Idx = Idx + 1
 
     C                   ENDDO
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrRtvTxt - Retrieve text                                      *
      *                                                               *
      *****************************************************************
 
     C     SrRtvTxt      BEGSR
 
     C                   CALL      'SDRTVTXT'
     C                   PARM                    PMsgID
     C                   PARM      'GBLERMSGF '  PMsgFNm
     C                   PARM      *BLANK        PMsgDesc
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRClrMsg - Clear message subfile and data                     *
      *                                                               *
      *****************************************************************
 
     C     SRClrMsg      BEGSR
 
     C                   CLEAR                   MsgIdArr
     C                   CLEAR                   MsgDtaArr
     C                   EVAL      Idx = 0
     C                   EVAL      WIdx = 0
 
      ** Clear message subfile.
 
     C                   CALL      'ZA0250'
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrInit   - Initialize necessary field                        *
      *                                                               *
      *****************************************************************
 
     C     SrInit        BEGSR
 
      ** Setup key field
 
     C                   EXSR      SrSetupKey1
 
      ** Clear message subfile
 
     C                   EXSR      SRClrMsg
 
      ** Initialise subfile relative record number.
 
     C                   EVAL      #0FREC = *ZERO
 
      ** Clear subfile before refilling by writing control record
      ** with SFLCLR active.
 
     C                   EVAL      *IN87 = *ON
     C                   WRITE     LE000250C0
     C                   EVAL      *IN87 = *OFF
 
      ** Set file pointer on key displayed on screen.
 
     C**********         IF        WrkKeyCust <> *ZEROS                                       CSD027
     C                   IF        WrkKeyCust <> *BLANKS                                      CSD027
     C     WrkKeyCust    SETLL     LEFEEDF
     C                   ELSE
     C     *LOVAL        SETLL     LEFEEDF
     C                   ENDIF
 
      ** Read a Valid Record
 
     C                   READ      LEFEEDF                                86
 
      ** Set up message 'No data to display'
 
     C                   IF        %EOF(LEFEEDL1)
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdArr(Idx) = 'LEE0308'
     C                   EXSR      SRSndMsg
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR   - Initialization procedures                         *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
      ** Initialize program name
 
     C                   EVAL      DBPGM = 'LE000250'
 
     C                   EVAL      *IN84 = *ON
     C                   EVAL      DDPGMQ = '*'
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      '*FIRST '     POption
     C     SDBANK        PARM      *BLANKS       DSFDY
 
     C                   IF        PRetCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBKEY = '*CALL'
     C                   EVAL      DBASE = 1
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   MOVE      BJMRDT        #0RUNA
     C                   EVAL      #0USER = PSUser
     C                   EVAL      #0WSID = PSJobName
 
     C     KComFee       KLIST
     C                   KFLD                    WKeyBRCA
     C                   KFLD                    WKeyCNUM
     C                   KFLD                    WKeyFACT
     C                   KFLD                    WKeyFACN
     C                   KFLD                    WKeyFSEQ
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
** CPY@
(c) Finastra International Limited 2003
