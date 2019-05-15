     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
     H THREAD(*SERIALIZE)
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Case management watch list match enquiry')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data module                                 *
      *                                                               *
      *  SDCWLMENQ - Case Management Watch List Match Enquiry         *
      *                                                               *
      *  Function:  This module will display the details of the       *
      *             watch list case.                                  *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD031             Date 10Apr06               *
      *                 CSD019  *CREATE    Date 02Jun03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD019 - Midas Compliance Watch - Entry Level Watch List     *
      *           Checking.                                           *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRExtSrchD - Extract search data and put into arrays         *
      *  SRBldSfl1  - Build Subfile1 Processing                       *
      *  SRBldSfl2  - Build Subfile2 Processing                       *
      *  SRFormat   - Format other fields for output                  *
      *  SRCvtDate  - Convert date from file format to screen format  *
      *  SRCvtAmt   - Convert amount from file format to screen format*
      *                                                               *
      * *PSSR - Error processing                                      *
      * *INZSR - Initialise                                           *
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
 
      ** Case Management Watch List Enquiry Display File
     FSDCWLMDF  CF   E             WORKSTN INFSR(*PSSR)
     F                                     SFILE(SDCWLMS1:WkSRRN1)
     F                                     SFILE(SDCWLMS2:WkSRRN2)
 
      ** Midas SD CW Case External Match Details File
     FSDCWCSL0  IF   E           K DISK
 
      ** Midas SD CW Case Matched Name Synonyms File
     FSDCWNML0  IF   E           K DISK
 
      ** Midas SD CW Case Matched Address Synonyms File
     FSDCWADL0  IF   E           K DISK
 
      ** Midas SD CW Case Matched City Synonyms File
     FSDCWCTL0  IF   E           K DISK
 
      ** Midas SD CW Case Matched Country Synonyms File
     FSDCWCOL0  IF   E           K DISK
 
      ** Midas SD CW List Item Type Code Details File
     FSDWLITL0  IF   E           K DISK
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
      **
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indicator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Details of Name synonym
     D NameSyn         S            105    DIM(99)
 
      ** Details of Address synonym
     D AddrSyn         S             70    DIM(99)
 
      ** Details of City synonym
     D CitySyn         S             35    DIM(99)
 
      ** Details of Country synonym
     D CtrySyn         S             35    DIM(99)
 
      ** Field name array
     D WFldname        S             25    DIM(99)
 
      ** Content of field names
     D WFldCont        S            210    DIM(99)
 
      ** Variable to check if field content needed to be highlighted
     D WFldHigh        S              1    DIM(99)
 
      ** Midas SD Bank details ICD files
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** Midas SC Switchable features descriptions
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
 
      ** Midas SD Currency codes
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      ** Short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** 24X7 status data area
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)
 
      ** SD data area
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)
 
      ** Match Data Line1
     D MatchL1DS       DS            77
     D                         1     11    INZ('Identifier:')
     D                        12     15    INZ(*BLANKS)
     D  W8WLID                16     20
     D                        21     24    INZ(*BLANKS)
     D                        25     31    INZ('Origin:')
     D                        32     33    INZ(*BLANKS)
     D  W8EORG                34     43
     D                        44     49    INZ(*BLANKS)
     D                        50     54    INZ('Type:')
     D                        55     56    INZ(*BLANKS)
     D  W8ETYP                57     71
     D                        72     77    INZ(*BLANKS)
 
      ** Match Data Name DS
     D MtchNamDS       DS
     D  WMNLn1                 1     77
     D  WMNLn2                78    154
     D                         1      5    INZ('Name:')
     D                         6     15    INZ(*BLANKS)
     D  WMName                16    120
     D                       121    154    INZ(*BLANKS)
 
      ** Match Data Address DS
     D MtchAddDS       DS
     D  WMALn1                 1     77
     D  WMALn2                78    154
     D                         1      8    INZ('Address:')
     D                         9     15    INZ(*BLANKS)
     D  WMAddr                16     85
     D                        86    154    INZ(*BLANKS)
 
      ** Match Data City DS
     D MtchCtyDS       DS
     D  WMCLn1                 1     77
     D                         1      5    INZ('City:')
     D                         6     15    INZ(*BLANKS)
     D  WMCity                16     50
     D                        51     77    INZ(*BLANKS)
 
      ** Match Data Country DS
     D MtchCtrDS       DS
     D  WMRLn1                 1     77
     D                         1      8    INZ('Country:')
     D                         9     15    INZ(*BLANKS)
     D  WMCtry                16     50
     D                        51     77    INZ(*BLANKS)
 
      ** Search Data DS
     D SrchDtaDS       DS
     D  WFldNam                1     25
     D  WFldCnt               26    235
     D  WFldCnt1              26     72
     D  WFldCnt2              73    119
     D  WFldCnt3             120    166
     D  WFldCnt4             167    213
     D  WFldCnt5             214    235
 
      **---------------------------------------------------------
      ** Indicator Array
     D Indicators      DS                  BASED(IndicatorP)
     D  EndOfFile1            01     01
     D  EndOfFile2            02     02
     D  RecNotFnd             03     03
     D  SflActive             12     12
     D  SflEnd                13     13
     D  EnableF6              16     16
     D  EnableF7              17     17
     D  SFlClr                18     18
     D  EnableF16             19     19
     D  WHighlite             20     20
 
      ** Pointer for the indicator Array
     D IndicatorP      S               *   INZ(%Addr(*IN))
      **---------------------------------------------------------
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Entry Parameters
     D PRetCode        S              7A
     D PFuncType       S              8A
     D PIdentifier     S             40A
     D PBranch         S              3A
 
      ** Parameter for calling AOCWCDR0
     D P_Retcd         S              7
     D P_Optn          S              7
 
      ** Parameter for calling AOCURRR0
     D PRtnCde         S              7
     D POptn           S              7
     D PAJCD           S              3
 
      ** Parameter for calling AOSARDR0
     D P_Sard          S              6
     D CSC011          S              1
 
      ** Parameters for ZDATE2
     D PZDayNo         S              5P 0
     D PZDate          S              6P 0
     D PZADate         S              7A
 
      ** ZSEDIT fields
     D PZFLD15         S             15  0
     D PZDECS          S              1  0
     D PZECODE         S              1
     D PZOUT21         S             21
 
      ** Variable to hold hexadecimal value for tab and carriage return.
     D WTAB            S              1A   INZ(X'05')
     D WCLRF           S              2A   INZ(X'0D25')
 
     D @RUN            S              1
     D WCtr            S              5  0
     D WkCnt           S              5  0
     D S               S              5  0
     D E               S              5  0
     D X               S              5  0
     D C               S              5  0
     D I               S              5  0
     D WDecP1          S              1  0
     D WDecP2          S              1  0
     D WRcdCtr1        S              5  0
     D WRcdCtr2        S              5  0
     D WkSRRN1         S              5  0
     D WkSRRN2         S              5  0
 
     D KSysPrfx        S              2A
     D MatchItemFLag   S              1A
     D WEnd            S              1A
     D WItemTDes       S             35A
     D WSkipBld        S              1A
 
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
 
      ** Access CW External Match Details for a match record.
 
     C     KEXTMD        SETLL     SDCWCSL0
     C     KEXTMD        READE     SDCWCSL0                               01
     C                   EVAL      WRcdCtr1 = 0
     C                   DOW       EndOfFile1 = *OFF
     C                   EVAL      WRcdCtr1 = WRcdCtr1 + 1
     C     KEXTMD        READE     SDCWCSL0                               01
     C                   ENDDO
 
     C     KEXTMD        SETLL     SDCWCSL0
     C     KEXTMD        READE     SDCWCSL0                               01
 
     C                   IF        EndOfFile1 = *ON
 
     C                   EXFMT     SDCWLMNR
 
     C                   ELSE
 
      ** Do until F3 or F12 is pressed
 
     C                   EVAL      WRcdCtr2 = 1
     C                   EVAL      MatchItemFLag = 'M'
     C                   EVAL      WSkipBld = 'N'
     C                   DOW       *INKC = *OFF and *INKL = *OFF
 
     C                   IF        WSkipBld = 'N'
 
      ** Fill Name Synonym Array
 
     C     W8MATC        SETLL     SDCWNML0
     C     W8MATC        READE     SDCWNML0                               02
     C                   IF        EndOfFile2 = *OFF
     C                   EVAL      WCtr = 0
     C                   DOW       EndOfFile2 = *OFF
     C                   EVAL      WCtr = WCtr + 1
     C                   EVAL      NameSyn(WCtr) = W9ENAM
     C     W8MATC        READE     SDCWNML0                               02
     C                   ENDDO
     C                   ENDIF
 
      ** Fill Address Synonym Array
 
     C     W8MATC        SETLL     SDCWADL0
     C     W8MATC        READE     SDCWADL0                               02
     C                   IF        EndOfFile2 = *OFF
     C                   EVAL      WCtr = 0
     C                   DOW       EndOfFile2 = *OFF
     C                   EVAL      WCtr = WCtr + 1
     C                   EVAL      AddrSyn(WCtr) = W9EADD
     C     W8MATC        READE     SDCWADL0                               02
     C                   ENDDO
     C                   ENDIF
 
      ** Fill City Synonym Array
 
     C     W8MATC        SETLL     SDCWCTL0
     C     W8MATC        READE     SDCWCTL0                               02
     C                   IF        EndOfFile2 = *OFF
     C                   EVAL      WCtr = 0
     C                   DOW       EndOfFile2 = *OFF
     C                   EVAL      WCtr = WCtr + 1
     C                   EVAL      CitySyn(WCtr) = W9ECTY
     C     W8MATC        READE     SDCWCTL0                               02
     C                   ENDDO
     C                   ENDIF
 
      ** Fill Country Synonym Array
 
     C     W8MATC        SETLL     SDCWCOL0
     C     W8MATC        READE     SDCWCOL0                               02
     C                   IF        EndOfFile2 = *OFF
     C                   EVAL      WCtr = 0
     C                   DOW       EndOfFile2 = *OFF
     C                   EVAL      WCtr = WCtr + 1
     C                   EVAL      CtrySyn(WCtr) = W9ECTR
     C     W8MATC        READE     SDCWCOL0                               02
     C                   ENDDO
     C                   ENDIF
 
      ** Get Item Type Description
 
     C     W8ITEM        CHAIN     SDWLITL0                             03
     C                   IF        RecNotFnd = *OFF
     C                   EVAL      WItemTDes = W1IDES
     C                   ENDIF
 
     C                   ENDIF
 
     C                   EVAL      EnableF6 = *ON
     C                   EVAL      EnableF7 = *ON
 
      ** If only one record exist disable F6 and F7
 
     C                   IF        WRcdCtr1 = 1
     C                   EVAL      EnableF6 = *OFF
     C                   EVAL      EnableF7 = *OFF
     C                   ENDIF
 
      ** If first record being shown disable F6
 
     C                   IF        WRcdCtr1 > 1 and WRcdCtr2 = 1
     C                   EVAL      EnableF6 = *OFF
     C                   ENDIF
 
      ** If last record being shown disable F7
 
     C                   IF        WRcdCtr1 > 1 and WRcdCtr2 = WRcdCtr1
     C                   EVAL      EnableF7 = *OFF
     C                   ENDIF
 
 
      ** Extract value of search data into array
 
     C                   EXSR      SRExtSrchD
 
      ** Build subfile 1 and subfile 2
 
     C                   EXSR      SRBldSfl1
     C                   EXSR      SRBldSfl2
 
      ** Format file data to screen fields
 
     C                   EXSR      SRFormat
 
      ** Display Screens
 
     C                   IF        MatchItemFLag = 'M'
     C                   EVAL      EnableF16 = *OFF
     C                   EVAL      SflActive = *ON
     C                   WRITE     SDCWLMF1
     C                   WRITE     SDCWLMD1
     C                   WRITE     SDCWLMC2
     C                   WRITE     SDCWLMC1
     C                   ELSE
     C                   EVAL      EnableF16 = *ON
     C                   WRITE     SDCWLMF1
     C                   WRITE     SDCWLMD2
     C                   ENDIF
 
      ** Read screens
 
     C                   IF        MatchItemFLag = 'M'
     C                   READ      SDCWLMC1
     C                   ELSE
     C                   READ      SDCWLMD2
     C                   ENDIF
 
      ** Process user input
 
     C                   SELECT
 
      ** User enters F3
 
     C                   WHEN      *INKC = *ON
     C                   EVAL      PRetCode = '*EXIT  '
 
      ** User enters F12
 
     C                   WHEN      *INKL = *ON
 
      ** User enters F6
 
     C                   WHEN      *INKF = *ON
     C                   EVAL      WRcdCtr2 = WRcdCtr2 - 1
     C                   EVAL      WSkipBld = 'N'
     C     KEXTMD        READPE    SDCWCSL0                               01
 
      ** User enters F7
 
     C                   WHEN      *INKG = *ON
     C                   EVAL      WRcdCtr2 = WRcdCtr2 + 1
     C                   EVAL      WSkipBld = 'N'
     C                   EVAL      EnableF6 = *ON
     C     KEXTMD        READE     SDCWCSL0                               01
 
      ** User enters F16
 
     C                   WHEN      *INKQ = *ON
     C                   EVAL      MatchItemFLag = 'M'
     C                   EVAL      WSkipBld = 'Y'
 
      ** User enters F17
 
     C                   WHEN      *INKR = *ON
     C                   EVAL      MatchItemFLag = 'D'
     C                   EVAL      WSkipBld = 'Y'
 
      ** Others
 
     C                   OTHER
     C                   ENDSL
     C                   ENDDO
     C                   ENDIF
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRExtSrchD - Extract search data and put into arrays          *
      *                                                               *
      *****************************************************************
     C     SRExtSrchD    BEGSR
 
     C                   IF        W8DATA <> *BLANKS
     C                   EVAL      WEnd = 'N'
     C                   EVAL      S = 1
     C                   EVAL      E = 1
     C                   EVAL      C = 1
     C                   EVAL      I = 1
     C                   EVAL      S = %SCAN(WTAB:W8DATA:1)
     C                   EVAL      WFldName(I) = %SUBST(W8DATA:1:S-1)
     C                   EVAL      E = %SCAN(WCLRF:W8DATA:S+1)
     C                   EVAL      X = E - (S + 1)
     C                   EVAL      WFldCont(I) = %SUBST(W8DATA:S+1:X)
 
      ** Check if field needs to be highlighted
 
     C                   IF        W8NAM1 >= S + 1 and W8NAM1 <= E or
     C                             W8ADD1 >= S + 1 and W8ADD1 <= E or
     C                             W8CTY1 >= S + 1 and W8CTY1 <= E or
     C                             W8CTR1 > S + 1 and W8CTR1 <= E
     C                   EVAL      WFldHigh(I) = 'Y'
     C                   ELSE
     C                   EVAL      WFldHigh(I) = 'N'
     C                   ENDIF
 
     C                   DOW       WEnd = 'N'
     C                   EVAL      S = %SCAN(WTAB:W8DATA:E+1)
     C                   IF        S <> 0
     C                   EVAL      I = I + 1
     C                   EVAL      X = S - (E + 1)
     C                   EVAL      WFldName(I) = %SUBST(W8DATA:E+2:X-1)
     C                   EVAL      E = %SCAN(WCLRF:W8DATA:S+1)
     C                   EVAL      X = E - (S + 1)
     C                   EVAL      WFldCont(I) = %SUBST(W8DATA:S+1:X)
 
      ** Check if field needs to be highlighted
 
     C                   IF        W8NAM1 >= S + 1 and W8NAM1 <= E or
     C                             W8ADD1 >= S + 1 and W8ADD1 <= E or
     C                             W8CTY1 >= S + 1 and W8CTY1 <= E or
     C                             W8CTR1 >= S + 1 and W8CTR1 <= E
     C                   EVAL      WFldHigh(I) = 'Y'
     C                   ELSE
     C                   EVAL      WFldHigh(I) = 'N'
     C                   ENDIF
 
     C                   ELSE
     C                   EVAL      WEnd = 'Y'
     C                   ENDIF
     C                   ENDDO
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRBldSfl1 - Build Subfile1 Processing                         *
      *                                                               *
      *****************************************************************
     C     SRBldSfl1     BEGSR
 
      ** Clear Subfile
 
     C                   EVAL      SflClr = *ON
     C                   WRITE     SDCWLMC1
     C                   EVAL      SFlClr = *OFF
     C                   EVAL      SflEnd = *OFF
 
      ** Initialise count of records written to subfile page.
      ** Initialise subfile relative record number.
 
     C                   EVAL      WkCnt = 0
     C                   EVAL      WkSRRN1 = 0
 
      ** Write field name and field content into subfile
 
     C                   EVAL      WCtr = 1
     C                   EVAL      WHighlite = *OFF
     C                   DOW       WFldName(WCtr) <> *BLANKS
     C                   EVAL      WFldNam = WFldName(WCtr)
     C                   EVAL      WFldCnt = WFldCont(WCtr)
     C                   IF        WFldHigh(WCtr) = 'Y'
     C                   EVAL      WHighlite = *ON
     C                   ELSE
     C                   EVAL      WHighlite = *OFF
     C                   ENDIF
     C                   EVAL      #1FLD1 = WFldNam
     C                   EVAL      #1FLD2 = WFldCnt1
     C                   EVAL      WkCnt = WkCnt + 1
     C                   EVAL      WkSRRN1 = WkSRRN1 + 1
     C                   WRITE     SDCWLMS1
     C                   IF        WFldCnt2 <> *BLANKS
     C                   EVAL      #1FLD1 = *BLANKS
     C                   EVAL      #1FLD2 = WFldCnt2
     C                   EVAL      WkCnt = WkCnt + 1
     C                   EVAL      WkSRRN1 = WkSRRN1 + 1
     C                   WRITE     SDCWLMS1
     C                   ENDIF
     C                   IF        WFldCnt3 <> *BLANKS
     C                   EVAL      #1FLD1 = *BLANKS
     C                   EVAL      #1FLD2 = WFldCnt3
     C                   EVAL      WkCnt = WkCnt + 1
     C                   EVAL      WkSRRN1 = WkSRRN1 + 1
     C                   WRITE     SDCWLMS1
     C                   ENDIF
     C                   IF        WFldCnt4 <> *BLANKS
     C                   EVAL      #1FLD1 = *BLANKS
     C                   EVAL      #1FLD2 = WFldCnt4
     C                   EVAL      WkCnt = WkCnt + 1
     C                   EVAL      WkSRRN1 = WkSRRN1 + 1
     C                   WRITE     SDCWLMS1
     C                   ENDIF
     C                   IF        WFldCnt5 <> *BLANKS
     C                   EVAL      #1FLD1 = *BLANKS
     C                   EVAL      #1FLD2 = WFldCnt5
     C                   EVAL      WkCnt = WkCnt + 1
     C                   EVAL      WkSRRN1 = WkSRRN1 + 1
     C                   WRITE     SDCWLMS1
     C                   ENDIF
     C                   EVAL      WCtr = WCtr + 1
     C                   ENDDO
     C                   EVAL      SflEnd = *ON
     C                   IF        WkSRRN1 > 0
     C                   EVAL      #1RRN1 = 1
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRBldSfl2 - Build Subfile2 Processing                         *
      *                                                               *
      *****************************************************************
     C     SRBldSfl2     BEGSR
 
      ** Clear Subfile
 
     C                   EVAL      SflClr = *ON
     C                   WRITE     SDCWLMC2
     C                   EVAL      SFlClr = *OFF
     C                   EVAL      SflEnd = *OFF
 
      ** Initialise count of records written to subfile page.
      ** Initialise subfile relative record number.
 
     C                   EVAL      WkCnt = 0
     C                   EVAL      WkSRRN2 = 0
 
      ** Write Identifier, Origin and Type into subfile
 
     C                   EVAL      #2FLD1 = MatchL1DS
     C                   EVAL      WkCnt = WkCnt + 1
     C                   EVAL      WkSRRN2 = WkSRRN2 + 1
     C                   WRITE     SDCWLMS2
 
      ** Write Entry Name into subfile
 
     C                   EVAL      WMName = W8ENAM
     C                   EVAL      #2FLD1 = WMNLn1
     C                   EVAL      WkCnt = WkCnt + 1
     C                   EVAL      WkSRRN2 = WkSRRN2 + 1
     C                   WRITE     SDCWLMS2
     C                   IF        WMNLn2 <> *BLANKS
     C                   EVAL      #2FLD1 = WMNLn2
     C                   EVAL      WkCnt = WkCnt + 1
     C                   EVAL      WkSRRN2 = WkSRRN2 + 1
     C                   WRITE     SDCWLMS2
     C                   ENDIF
 
      ** Write all name synonym into subfile
 
     C                   EVAL      WCtr = 1
     C                   DOW       NameSyn(WCtr) <> *BLANKS
     C                   EVAL      WMName = NameSyn(WCtr)
     C                   EVAL      #2FLD1 = WMNLn1
     C                   EVAL      WkCnt = WkCnt + 1
     C                   EVAL      WkSRRN2 = WkSRRN2 + 1
     C                   WRITE     SDCWLMS2
     C                   IF        WMNLn2 <> *BLANKS
     C                   EVAL      #2FLD1 = WMNLn2
     C                   EVAL      WkCnt = WkCnt + 1
     C                   EVAL      WkSRRN2 = WkSRRN2 + 1
     C                   WRITE     SDCWLMS2
     C                   ENDIF
     C                   EVAL      WCtr = WCtr + 1
     C                   ENDDO
     C                   CLEAR                   NameSyn
 
      ** Write Entry Address into subfile
 
     C                   EVAL      WMAddr = W8EADD
     C                   EVAL      #2FLD1 = WMALn1
     C                   EVAL      WkCnt = WkCnt + 1
     C                   EVAL      WkSRRN2 = WkSRRN2 + 1
     C                   WRITE     SDCWLMS2
     C                   IF        WMALn2 <> *BLANKS
     C                   EVAL      #2FLD1 = WMALn2
     C                   EVAL      WkCnt = WkCnt + 1
     C                   EVAL      WkSRRN2 = WkSRRN2 + 1
     C                   WRITE     SDCWLMS2
     C                   ENDIF
 
      ** Write all address synonym into subfile
 
     C                   EVAL      WCtr = 1
     C                   DOW       AddrSyn(WCtr) <> *BLANKS
     C                   EVAL      WMAddr = AddrSyn(WCtr)
     C                   EVAL      #2FLD1 = WMALn1
     C                   EVAL      WkCnt = WkCnt + 1
     C                   EVAL      WkSRRN2 = WkSRRN2 + 1
     C                   WRITE     SDCWLMS2
     C                   IF        WMALn2 <> *BLANKS
     C                   EVAL      #2FLD1 = WMALn2
     C                   EVAL      WkCnt = WkCnt + 1
     C                   EVAL      WkSRRN2 = WkSRRN2 + 1
     C                   WRITE     SDCWLMS2
     C                   ENDIF
     C                   EVAL      WCtr = WCtr + 1
     C                   ENDDO
     C                   CLEAR                   AddrSyn
 
      ** Write Entry City into subfile
 
     C                   EVAL      WMCity = W8ECTY
     C                   EVAL      #2FLD1 = WMCLn1
     C                   EVAL      WkCnt = WkCnt + 1
     C                   EVAL      WkSRRN2 = WkSRRN2 + 1
     C                   WRITE     SDCWLMS2
 
      ** Write all city synonym into subfile
 
     C                   EVAL      WCtr = 1
     C                   DOW       CitySyn(WCtr) <> *BLANKS
     C                   EVAL      WMCity = CitySyn(WCtr)
     C                   EVAL      #2FLD1 = WMCLn1
     C                   EVAL      WkCnt = WkCnt + 1
     C                   EVAL      WkSRRN2 = WkSRRN2 + 1
     C                   WRITE     SDCWLMS2
     C                   EVAL      WCtr = WCtr + 1
     C                   ENDDO
     C                   CLEAR                   CitySyn
 
      ** Write Entry Country into subfile
 
     C                   EVAL      WMCtry = W8ECTR
     C                   EVAL      #2FLD1 = WMRLn1
     C                   EVAL      WkCnt = WkCnt + 1
     C                   EVAL      WkSRRN2 = WkSRRN2 + 1
     C                   WRITE     SDCWLMS2
 
      ** Write all country synonym into subfile
 
     C                   EVAL      WCtr = 1
     C                   DOW       CtrySyn(WCtr) <> *BLANKS
     C                   EVAL      WMCtry = CtrySyn(WCtr)
     C                   EVAL      #2FLD1 = WMRLn1
     C                   EVAL      WkCnt = WkCnt + 1
     C                   EVAL      WkSRRN2 = WkSRRN2 + 1
     C                   WRITE     SDCWLMS2
     C                   EVAL      WCtr = WCtr + 1
     C                   ENDDO
     C                   CLEAR                   CtrySyn
 
     C                   EVAL      SflEnd = *ON
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRFormat - Format other fields for output                     *
      *                                                               *
      *****************************************************************
     C     SRFormat      BEGSR
 
      ** Item type description
 
     C                   EVAL      #1IDES = WItemTDes
 
      ** Branch code
 
     C                   EVAL      #1BRCH = PBranch
 
      ** Midas identifier
 
     C                   EVAL      #1IDEN = PIdentifier
 
      ** System prefix of system
 
     C                   EVAL      #1SYSM = KSysPrfx
 
      ** Counterparty number
 
     C                   EVAL      #2CNUM = W8CNUM
 
      ** Counterparty name
 
     C                   EVAL      #2CUST = W8CUST
 
      ** Deal date
 
     C                   IF        W8DDAT <> *ZEROS
     C                   EVAL      PZDayNo = W8DDAT
     C                   EXSR      SRCvtDate
     C                   IF        PZDate <> 010101
     C                   MOVE      PZDate        #2DDAT
     C                   ENDIF
     C                   ENDIF
 
      ** Value date
 
     C                   IF        W8VDAT <> *ZEROS
     C                   EVAL      PZDayNo = W8VDAT
     C                   EXSR      SRCvtDate
     C                   IF        PZDate <> 010101
     C                   MOVE      PZDate        #2VDAT
     C                   ENDIF
     C                   ENDIF
 
      ** Maturity date
 
     C                   IF        W8MDAT <> *ZEROS
     C                   EVAL      PZDayNo = W8MDAT
     C                   EXSR      SRCvtDate
     C                   IF        PZDate <> 010101
     C                   MOVE      PZDate        #2MDAT
     C                   ENDIF
     C                   ENDIF
 
      ** Denomination side 1
 
     C                   EVAL      #2DEN1 = W8DEN1
     C                   IF        W8DEN1 <> *BLANKS
     C                   EVAL      PAJCD = W8DEN1
     C                   EXSR      SRCurr
     C                   EVAL      WDECP1 = A6NBDP
     C                   ENDIF
 
      ** Denomination side 2
 
     C                   EVAL      #2DEN2 = W8DEN2
     C                   IF        W8DEN2 <> *BLANKS
     C                   EVAL      PAJCD = W8DEN2
     C                   EXSR      SRCurr
     C                   EVAL      WDECP2 = A6NBDP
     C                   ENDIF
 
      ** Amount side 1
 
     C                   IF        W8AMT1 <> *ZEROS
     C                   MOVE      W8AMT1        PZFLD15
     C                   Z-ADD     WDECP1        PZDECS
     C                   EXSR      SRCvtAmt
     C                   MOVE      PZOUT21       #2AMT1
     C                   ENDIF
 
      ** Amount side 2
 
     C                   IF        W8AMT2 <> *ZEROS
     C                   MOVE      W8AMT2        PZFLD15
     C                   Z-ADD     WDECP2        PZDECS
     C                   EXSR      SRCvtAmt
     C                   MOVE      PZOUT21       #2AMT2
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRCvtDate - Convert date from file format to screen format    *
      *                                                               *
      *****************************************************************
     C     SRCvtDate     BEGSR
 
      ** Call ZDATE2 to convert date from Midas Dayno. format to
      ** DDMMYY format.
 
     C                   CALLB     'ZDATE2'
     C                   PARM                    PZDayno
     C                   PARM                    BJDFIN
     C                   PARM      *ZEROS        PZDate
     C                   PARM      *BLANKS       PZADate
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRCvtAmt  - Convert amount from file format to screen format  *
      *                                                               *
      *****************************************************************
     C     SRCvtAmt      BEGSR
 
 
     C                   CALLB     'ZSEDIT'
 
      ** Field to edit
      ** Decimal places
      ** Edit code ('J', 'L' or ' ')
 
     C                   PARM                    PZFLD15
     C                   PARM                    PZDECS
     C                   PARM      'L'           PZECODE
 
      ** Output
 
     C                   PARM                    PZOUT21
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRCurr - Access Currency Details                              *
      *                                                               *
      *****************************************************************
     C     SRCurr        BEGSR
 
      ** Access currency details using deal currency.
 
     C                   CALLB     'AOCURRR0'
     C                   PARM      '*MSG   '     PRtnCde
     C                   PARM      '*KEY   '     POptn
     C                   PARM                    PAJCD
     C     SDCURR        PARM      SDCURR        DSSDY
 
      ** Database error
 
     C                   IF        PRtnCde <> *BLANK
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = PAJCD
     C                   EVAL      DBFILE = 'SDCURRPD'
     C                   EVAL      DBASE = 003
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    PRetCode
     C                   PARM                    PFuncType
     C                   PARM                    PIdentifier
     C                   PARM                    PBranch
 
      ** Access bank details.
 
     C                   CALLB     'AOBANKR0'
     C                   PARM      *BLANKS       P_RetCd
     C                   PARM      '*FIRST '     P_Optn
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database error
 
     C                   IF        P_RetCd <> *BLANK
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE= 'SDBANKPD'
     C                   EVAL      DBKEY = P_Optn
     C                   EVAL      DBASE = 001
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Check if CSC011 is installed
 
     C                   EVAL      CSC011 = 'N'
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       P_RetCd
     C                   PARM      '*VERIFY'     P_Optn
     C                   PARM      'CSC011'      P_Sard
     C     SCSARD        PARM      SCSARD        DSFDY
 
      ** Database error
 
     C                   IF        P_RetCd = *BLANKS
     C                   EVAL      CSC011 = 'Y'
     C                   ENDIF
 
     C                   IF        (P_RetCd <> *BLANKS) and
     C                             (P_RetCd <> '*NRF   ')
     C                   EVAL      DBKEY = 'CSC011'
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE = 002
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        CSC011 = 'Y'
     C                   IN        SC24X7
     C                   EVAL      KSysPrfx = S1MAIN
     C                   ELSE
     C                   IN        SDSTAT
     C                   EVAL      KSysPrfx = LIBR
     C                   ENDIF
 
     C                   EVAL      DDUSER = PSUser
     C                   EVAL      DDWID = PSJobName
 
      ** Key list for CW Case External Match Details
 
     C     KEXTMD        KLIST
     C                   KFLD                    PFuncType
     C                   KFLD                    PIdentifier
     C                   KFLD                    PBranch
     C                   KFLD                    KSysPrfx
 
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
 
     C                   EVAL      PRetCode = '*ERROR'
 
     C                   DUMP
 
     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'
 
     C                   CALLB     'DBERRCTL'
 
     C                   ENDIF
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
 
      ********************************************************************
