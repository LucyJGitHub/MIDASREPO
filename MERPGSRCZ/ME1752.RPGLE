     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2006')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas ME Outgoing Message Field Management Excpt R')   *
      *****************************************************************
      *                                                               *
      *  Midas - Message Management Module                            *
      *                                                               *
      *  ME1752   - ME Outgoing Message Field Management              *
      *             Exception Report.                                 *
      *                                                               *
      *  Function:  To report outgoing payment failing the validation *
      *             set-up in outgoing message field management.      *
      *             One report will list the error, the other the     *
      *             warning.                                          *
      *                                                               *
      *  Called By: MEC1752 - ME Outgoing Message Field Management    *
      *             Exception Report Control.                         *
      *                                                               *
      *  (c) Finastra International Limited 2006                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. CER050             Date 16Jun19               *
      *                 MD046248           Date 27Oct17               *
      *                 CER070             Date 19Aug14               *
      *                 CLE134             Date 01Aug12               *
      *                 CRE075             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER034             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 BUG15195           Date 30Oct07               *
      *                 CSW207             Date 08Jun07               *
      *                 BUG14042           Date 24May07               *
      *                 BUG13798           Date 26Apr07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CFT032  *CREATE    Date 11Sep06               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *  CER050 - Annualised Percentage Rate (Recompile)              *
      *  MD046248 - Finastra Rebranding                               *
      *  CER070 - BuBa Reporting / BAIS V.1.16.0 (Recompile)          *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER034 - German Features - New Fields and Enquiries          *
      *           (Recompile)                                         *
      *  BUG15195 - ME1752 call FT001000 with wrong order of          *
      *             parameters                                        *
      *  CSW207 - SWIFT 2007 Standard Changes                         *
      *  BUG14042 - CFT032 errors ; applied fix 13798                 *
      *  BUG13798 - CFT032 errors                                     *
      *  CFT032 - Account line in field 50X in MT103                  *
      *                                                               *
      *****************************************************************
     FOTPAYBB   IF   E           K DISK    INFSR(*PSSR)
 
     FME1752P1  O    E             PRINTER
     F                                     INFDS(SPOOL1)
 
     FME1752P2  O    E             PRINTER
     F                                     INFDS(SPOOL2)
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
      ** Midas FT general address data structure
 
      /COPY FTCPYSRC,SFTADDRILE
 
     D LDA           E DS           256    EXTNAME(LDA)
 
     D SPOOL1          DS
     D  SFILE1                83     92
     D  SFNUM1               123    124B 0
     D  OFLLN1               188    189B 0
     D  PRTLN1               367    368B 0
 
     D SPOOL2          DS
     D  SFILE2                83     92
     D  SFNUM2               123    124B 0
     D  OFLLN2               188    189B 0
     D  PRTLN2               367    368B 0
 
      ** External data structures for Bank Details
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** External DS for Branch details
 
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
     D  QQDFAC#      E                     EXTFLD(QQDFAC)
 
      ** Customer details
 
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
 
      ** External data structure for Account
 
     D SDACCNT       E DS                  EXTNAME(ACCNTAB)
 
      ** External DS for Midas modules details
 
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
 
      ** External data structure for Nostro customer number
 
     D SDNOST        E DS                  EXTNAME(SDNOSTPD)
 
      ** Data Structures for Access Objects
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Data Structures for SAR details
 
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
     D  LCD#         E                     EXTFLD(LCD)
 
      ** External data structure for access programs
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** Outgoing message
 
     D MEOUFM        E DS                  EXTNAME(MEOUFMPD)
                                                                                            BUG15195
     D SDACUS        E DS                  EXTNAME(SDACUSPD)                                BUG15195
     D DSLDY         E DS                  EXTNAME(DSLDY)                                   BUG15195
      * Customer details parameter ME1400                                                   BUG15195
     D D_SDCUST      E DS                  Extname(SDCUSTPD)                                BUG15195
     D                                     Prefix(D_)                                       BUG15195
      * Counterparty Nostro parameter ME1400                                                BUG15195
     D SDCNST        E DS                  Extname(SDCNSTPD)                                BUG15195
      *                                                                                     BUG15195
      * BIC directory parameter ME1400                                                      BUG15195
     D MEBICD        E DS                  Extname(MEBICDPD)                                BUG15195
      *                                                                                     BUG15195
 
     D ORDCST          DS           175
     D  ORC1                   1     35
     D  ORC2                  36     70
     D  ORC3                  71    105
     D  ORC4                 106    140
     D  ORC5                 141    175
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
     D PETTY           S              3A
     D PSEQ            S              5A
     D P@RTCD          S              7A
     D P@KEY           S              7A                                                    BUG15195
     D P@CUST1         S              6A                                                    BUG15195
     D P@OPTN          S              7A
     D P@SARD          S              6A
     D P@RETL          S             10A
     D*P@CTRY***       S              2A                                                    BUG13798
     D P@CTRY          S              4A                                                    BUG13798
     D P@CUST          S             10A
     D P@CYCD          S              3A
     D P@ACCD          S             10A
     D P@ACSQ          S              2A
     D P@BRCD          S              3A
     D P@BRCD4A        S              4A                                                    BUG13798
     D P@NONB          S              2A
     D P@CSSN          S             10A
     D P@PNOI          S              1A
     D P@IBAN          S             34A
     D P@NET           S              6A
     D P@TYP           S             10A
     D P@STR           S             35A
     D P@TAG           S              5A
     D P@NOS           S              2A
     D*P@ACT****       S             15A                                                    BUG13798
     D P@ACT           S             10A                                                    BUG13798
     D P@ERR           S              1  0
     D P@ERRC          S              7A
     D PZSERR          S              1A
     D PZSNUM          S              6  0
     D PSFILE          S             10A
     D WRUN            S              1A
     D WOPEN           S              1A
     D WRQDLN          S              3  0
     D WDIFLN          S              3  0
     D WEntryType      S              1A
     D WFieldTag       S              5A
     D WCountry        S              2A
     D WCurrency       S              3A
     D WCustomer       S              6A
     D WAddress        S             35A
     D WNetwork        S             10A
     D WNostro         S              2A
     D ExcptReport     S               N
     D WarngReport     S               N
     D WIdx            S              5  0
     D WCount1         S              5  0
     D WCount2         S              5  0
 
     D CSW024          S              1A
                                                                                              CSW207
     D CSW207          S              1A                                                      CSW207
     D PrtCd           S              7A                                                      CSW207
     D PAccount        S             34A                                                      CSW207
     D PAcctyp         S              1A                                                      CSW207
     D PCust           S              6A                                                      CSW207
     D PNonActH        S             10A                                                      CSW207
     D PNetwork        S              6A                                                      CSW207
     D PMsgType        S              3A                                                      CSW207
     D PMsgTag         S              5A                                                      CSW207
     D PMsgFld         S              5A                                                      CSW207
     D PBranch         S              3A                                                      CSW207
     D PCountry        S              2A                                                      CSW207
     D PNostro         S              2A                                                      CSW207
     D PCurrency       S              3A                                                      CSW207
     D PVType          S              4A                                                      CSW207
     D PMsgID          S              7A                                                      CSW207
     D P50F1           S             35A                                                      CSW207
     D P50F2           S             35A                                                      CSW207
     D P50F3           S             35A                                                      CSW207
     D P50F4           S             35A                                                      CSW207
     D P50F5           S             35A                                                      CSW207
     D @@IBAN          S              1A                                                      CSW207
     D WCNUM           S              6A                                                      CSW207
     D WACOD           S             10A                                                      CSW207
     D WACSQ           S              2A                                                      CSW207
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
     C/TITLE Main Processing
      *================================================================
      *  P R O G R A M   S T A R T                                    *
      *================================================================
 
      ** Perform Detail Processing
 
     C                   EXSR      SRPROCESS
     C                   EVAL      *INLR = *ON
 
      *================================================================
      *  P R O G R A M   E N D                                        *
      *================================================================
     C/EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Subroutine to do Program Initialisation.            *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
      ** Parameter Entry
 
     C     *ENTRY        PLIST
     C                   PARM                    PSEQ
     C                   PARM                    PETTY
 
      ** Parameter List for Calling AOOUFMR0
 
     C     PLAOOUFMR0    PLIST
     C                   PARM      *BLANKS       P@RTCD
     C                   PARM      '*KEY'        P@OPTN
     C                   PARM      WNetwork      P@NET
     C                   PARM      '103'         P@TYP
     C                   PARM      WFieldTag     P@TAG
     C**********         PARM                    P@BRCD                                     BUG13798
     C                   PARM                    P@BRCD4A                                   BUG13798
     C                   PARM      WCountry      P@CTRY
     C                   PARM                    P@CYCD
     C                   PARM      WNostro       P@NOS
     C                   PARM                    P@ACT
     C     MEOUFM        PARM      MEOUFM        DSSDY
 
      ** Initialise LDA field
 
     C     *DTAARA       DEFINE                  LDA
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE  = *ZEROS
     C                   EVAL      DBFILE = *BLANKS
     C                   EVAL      DBKEY  = *BLANKS
     C                   EVAL      DBMOD  = *BLANKS
     C                   EVAL      DBPGM  = 'ME1752'
     C                   OUT       LDA
 
      ** Call Access Program for Bank Details - Title, Run Date and
      ** Run Day Number
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       P@RTCD
     C                   PARM      '*FIRST '     P@OPTN
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Handle Database Error
 
     C                   IF        P@RTCD<> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE  = 1
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBKEY  = P@RTCD
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Access Module Details
 
     C                   CALL      'AOMMODR0'
     C                   PARM      *BLANKS       P@RTCD
     C                   PARM      '*FIRST '     P@OPTN
     C     SDMMOD        PARM      SDMMOD        DSFDY
      *
      * DATABASE ERROR
      *
     C     P@RTCD        IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDMMODPD'    DBFILE
     C                   MOVEL     2             DBASE
     C                   MOVEL     P@OPTN        DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END
 
      ** Check if feature CSW024 is installed
 
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       P@RTCD
     C                   PARM      '*VERIFY'     P@OPTN
     C                   PARM      'CSW024'      P@SARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C                   IF        P@RTCD <> *BLANKS  AND  P@RTCD <> '*NRF   '
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBKEY  = 'CSW024'
     C                   EVAL      DBASE  = 3
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        P@RTCD = *BLANKS
     C                   EVAL      CSW024 = 'Y'
     C                   ELSE
     C                   EVAL      CSW024 = 'N'
     C                   ENDIF
 
      ** Report Work fields
 
     C                   EVAL      WDIFLN = *ZEROS
 
      *                                                                                       CSW207
      ** Check if SWIFT 2007 is installed                                                     CSW207
      *                                                                                       CSW207
     C                   CALL      'SWIF2007'                                                 CSW207
     C                   PARM      *BLANKS       PRTCD                                        CSW207
     C                   IF        PRTCD = 'CSW2007'                                          CSW207
     C                   EVAL      CSW207 = 'Y'                                               CSW207
     C                   ELSE                                                                 CSW207
     C                   EVAL      CSW207 = 'N'                                               CSW207
     C                   ENDIF                                                                CSW207
      *                                                                                       CSW207
     C                   ENDSR
 
      *****************************************************************
      /TITLE SR/SRPROCESS
      *****************************************************************
      *                                                               *
      *  SRPROCESS - Subroutine to do the Detail Processing           *
      *                                                               *
      *****************************************************************
 
     C     SRPROCESS     BEGSR
 
      ** Read first record from file
 
     C                   READ      OTPAYBB
 
      ** Do Until End of File
 
     C                   DOW       NOT %EOF(OTPAYBB)
 
      ** select non-authorised and process report lines
 
     C                   IF        AUIN <> 'Y'
 
     C                   EXSR      SROUFM
                                                                                              CSW207
     C                   IF        CSW207 = 'Y' AND                                           CSW207
     C                             WFieldTag = ':50F:'                                        CSW207
     C                   EVAL      P@ACT = '*FORMAT'                                          CSW207
     C                   CALL      'AOOUFMR0'    PLAOOUFMR0                                   CSW207
                                                                                              CSW207
     C                   IF        P@RTCD = *BLANKS                                           CSW207
     C                   EVAL      ExcptReport = *OFF                                         CSW207
     C                   EVAL      WarngReport = *OFF                                         CSW207
                                                                                              CSW207
     C                   IF        OMFLAG = 'P' OR                                            CSW207
     C                             OMFLAG = 'M'                                               CSW207
     C                   EVAL      ExcptReport = *ON                                          CSW207
     C                   EXSR      SRREPORT                                                   CSW207
     C                   ENDIF                                                                CSW207
                                                                                              CSW207
     C                   IF        OMFLAG = 'W'                                               CSW207
     C                   EVAL      WarngReport = *ON                                          CSW207
     C                   EXSR      SRREPORT                                                   CSW207
     C                   ENDIF                                                                CSW207
                                                                                              CSW207
     C                   ENDIF                                                                CSW207
                                                                                              CSW207
     C                   ENDIF                                                                CSW207
 
     C                   DO        2             WIdx
 
     C                   IF        WIdx = 1
     C**********         EVAL      P@ACT = 'ACCOUNTLINE'                                    BUG13798
     C                   EVAL      P@ACT = 'ACOUNTLINE'                                     BUG13798
     C                   ELSE
     C**********         EVAL      P@ACT = 'ACCOUNTIBAN'                                    BUG13798
     C                   EVAL      P@ACT = 'ACOUNTIBAN'                                     BUG13798
     C                   ENDIF
 
     C                   CALL      'AOOUFMR0'    PLAOOUFMR0
 
     C                   IF        P@RTCD = *BLANKS
 
     C                   EVAL      ExcptReport = *OFF
     C                   EVAL      WarngReport = *OFF
 
      ** Exception report
 
     C                   IF        (OMFLAG = 'P'                 AND
     C                             (%SUBST(ORC1 : 1 : 1) = '/'   OR
     C                              %SUBST(BNC1 : 1 : 1) = '/')) OR
     C                             (OMFLAG = 'M'                 AND
     C                             (%SUBST(ORC1 : 1 : 1) <> '/'  OR
     C                              %SUBST(BNC1 : 1 : 1) <> '/'))
     C                   EVAL      ExcptReport = *ON
     C                   ENDIF
 
      ** Warning report
 
     C                   IF        OMFLAG = 'W'                 AND
     C                             (%SUBST(ORC1 : 1 : 1) <> '/' OR
     C                              %SUBST(BNC1 : 1 : 1) <> '/')
     C                   EVAL      WarngReport = *ON
     C                   ENDIF
 
     C                   IF        ExcptReport = *ON OR
     C                             WarngReport = *ON
     C                   EXSR      SRREPORT
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDDO
 
     C                   ENDIF
 
      ** Read next record
 
     C                   READ      OTPAYBB
 
      ** End of Do Until End of Valid Records
 
     C                   ENDDO
 
      ** Write end of report
 
     C                   EXSR      SRWEND
 
     C                   ENDSR
      *
      *****************************************************************
      /TITLE SR/SRREPORT
      *****************************************************************
      *                                                               *
      *  SRREPORT - Process Report Lines                              *
      *                                                               *
      *****************************************************************
 
     C     SRREPORT      BEGSR
 
     C                   EXSR      SRFORMAT
 
      ** If branch is not the same as previous branch, new page
 
     C                   IF        R1BRCA <> BRCA OR
     C                             R2BRCA <> BRCA
      *
      ** check if user is authorized to the given branch
      *
     C                   CALL      'ZVBBU'
     C                   PARM      BRCA          P@BRCD
     C                   PARM                    P@ERR
      *
      ** get branch description
      *
     C                   CALL      'AOBRCHR1'
     C                   PARM      *BLANKS       P@RTCD
     C                   PARM      '*KEY   '     P@OPTN
     C                   PARM      BRCA          P@BRCD
     C     SDBRCH        PARM      SDBRCH        DSSDY
     C                   EVAL      R1BRCA = BRCA
     C                   EVAL      R2BRCA = BRCA
     C                   EVAL      R1BRCH = A8BRNM
     C                   EVAL      R2BRCH = A8BRNM
      **********                                                                            BUG13798
      ***print*heading                                                                      BUG13798
      **********                                                                            BUG13798
     C**********         IF        ExcptReport = *ON                                        BUG13798
     C**********         WRITE     HEADP1                                                   BUG13798
     C**********         ELSE                                                               BUG13798
     C**********         WRITE     HEADP2                                                   BUG13798
     C**********         ENDIF                                                              BUG13798
     C                   ENDIF
 
      ** Write Detail
 
     C                   EXSR      SRWREC
 
     C                   ENDSR
 
      *****************************************************************
      /TITLE SR/SRFORMAT
      *****************************************************************
      *                                                               *
      *  SRFORMAT - Subroutine to Format Details                      *
      *                                                               *
      *****************************************************************
 
     C     SRFORMAT      BEGSR
 
      ** Populate printer file detail fields
 
     C                   IF        ExcptReport = *ON
 
     C                   EVAL      R1PREF = PREF
     C                   EVAL      R1ACTP = P@ACT
     C                   EVAL      R1VALU = OMFLAG
     C                   EVAL      R1FLDN = 'ORC1/BNC1'
     C                   EVAL      R1FLDD = %TRIM(ORC1) + '/' + %TRIM(BNC1)
     C                   IF        P@ERR = 2
     C                   MOVE      *ALL'*'       R1FLDN
     C                   ENDIF
 
     C                   ELSE
 
     C                   EVAL      R2PREF = PREF
     C                   EVAL      R2ACTP = P@ACT
     C                   EVAL      R2VALU = OMFLAG
     C                   EVAL      R2FLDN = 'ORC1/BNC1'
     C                   EVAL      R2FLDD = %TRIM(ORC1) + '/' + %TRIM(BNC1)
     C                   IF        P@ERR = 2
     C                   MOVE      *ALL'*'       R2FLDN
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /TITLE SR/SRWREC
      *****************************************************************
      *                                                               *
      *  SRWREC - Subroutine to Write a Detail Record to the Report   *
      *                                                               *
      *****************************************************************
 
     C     SRWREC        BEGSR
 
      ** Check that sufficient lines remain for the Format. If not,
      ** write out the Main Headings on a new page
 
     C                   EVAL      WRqdln = 2
 
     C                   IF        ExcptReport = *ON
 
     C                   IF        Wcount1 = 0    OR                                        BUG13798
     C                             R1BRCA <> BRCA OR                                        BUG13798
     C                             R2BRCA <> BRCA                                           BUG13798
     C                   WRITE     HEADP1                                                   BUG13798
     C                   ENDIF                                                              BUG13798
     C                   EVAL      WCount1 = Wcount1 + 1
     C                   EVAL      WDifln = OFLLN1 - PRTLN1
     C                   IF        WDifln < WRqdln
     C                   WRITE     HEADP1
     C                   ENDIF
     C                   WRITE     DTLP1
 
     C                   ELSE
 
     C                   IF        Wcount2 = 0    OR                                        BUG13798
     C                             R1BRCA <> BRCA OR                                        BUG13798
     C                             R2BRCA <> BRCA                                           BUG13798
     C                   WRITE     HEADP2                                                   BUG13798
     C                   ENDIF                                                              BUG13798
     C                   EVAL      WCount2 = Wcount2 + 1
     C                   EVAL      WDifln = OFLLN2 - PRTLN2
     C                   IF        WDifln < WRqdln
     C                   WRITE     HEADP2
     C                   ENDIF
     C                   WRITE     DTLP2
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /TITLE SR/SRWP1END
      *****************************************************************
      *                                                               *
      *  SRWEND - Subroutine to Write End of Report.                  *
      *                                                               *
      *****************************************************************
 
     C     SRWEND        BEGSR
 
      ** Check that sufficient lines remain for the Format. If not,
      ** write out the Main Headings on a new page
 
     C                   EVAL      WRqdln = 4
 
     C                   IF        WCount1 > *ZERO
     C                   EVAL      WDifln = OFLLN1 - PRTLN1
     C                   IF        WDifln < WRqdln
     C                   WRITE     HEADP1
     C                   ENDIF
     C                   WRITE     TRAILP1
     C                   ENDIF
 
     C                   IF        WCount2 > *ZERO
     C                   EVAL      WDifln = OFLLN2 - PRTLN2
     C                   IF        WDifln < WRqdln
     C                   WRITE     HEADP2
     C                   ENDIF
     C                   WRITE     TRAILP2
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      *****************************************************************
      /TITLE SR/*PSSR
      *****************************************************************
      *                                                               *
      *  *PSSR  - Error control subroutine                            *
      *                                                               *
      *****************************************************************
 
     C     *PSSR         BEGSR
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
      *
      ** Check to see that *PSSR has not already been Called
      *
     C                   IF        WRUN = *BLANK
     C                   EVAL      WRUN = 'Y'
     C                   DUMP
     C                   ENDIF
      *
      ** If *PSSR already run, then just end the program here
      *
     C                   RETURN
      *
     C                   ENDSR
      *
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SROUFM - Retrieve Outgoing Message Field Management          *
      *                                                               *
      *****************************************************************
 
     C     SROUFM        BEGSR
 
     C                   Eval      P@TYP = *BLANKS                                          BUG15195
     C                   Eval      Paccount = *BLANKS                                       BUG15195
     C                   Eval      Wcountry = *BLANKS                                       BUG15195
     C                   Eval      PCUST   = *BLANKS                                        BUG15195
     C                   EVAL      Pacctyp = *BLANKS                                        BUG15195
     C                   EVAL      @@IBAN = *BLANKS                                           CSW207
     C                   EVAL      WEntryType = ODMTT
 
      ** Retrive Customer Details
 
 
      ** Network
 
     C                   If        STMT = 8
     C                   EVAL      WNetwork = 'SWIFT'
     C                   ELSE
     C                   EVAL      WNetwork = 'Telex'
     C                   ENDIF
 
      ** Message tag
 
     C                   EVAL      WFieldTag = ':50K:'
 
     C                   IF        ODMTT  = 'S'      OR
     C                             BBCSID <> *BLANKS OR
     C                             CSW024 = 'Y'      AND
     C                             BBCBEI <> *BLANKS
     C                   EVAL      WFieldTag = ':50A:'
     C                   ENDIF
 
      ** Sender's branch
 
     C                   EVAL      P@BRCD = BBBRCD
     C                   EVAL      P@BRCD4A = BBBRCD                                        BUG13798
 
      ** Country of location
 
     C                   SELECT
     C                   WHEN      DSTT = 'A'
     C                   EVAL      WCountry = ' '
     C                   WHEN      DSTT = 'S'
      *                                                                                     BUG15195
     C                   Movel     ORC1          W9BICC                                     BUG15195
     C                   CALL      'ME1400'                                                 BUG15195
     C                   PARM      *BLANKS       W9RTN             7                        BUG15195
     C                   PARM                    W9BICC            8                        BUG15195
     C                   PARM      *BLANKS       W9BICB            3                        BUG15195
     C                   PARM                    D_SDCUST                                   BUG15195
     C                   PARM                    SDCNST                                     BUG15195
     C                   PARM                    MEBICD                                     BUG15195
     C                   PARM      *BLANKS       W9CUST            1                        BUG15195
     C                   PARM      *BLANKS       W9CNST            1                        BUG15195
     C                   PARM      *BLANKS       W9BICD            1                        BUG15195
      *                                                                                     BUG15195
     C                   IF        W9RTN <> *BLANKS                                         BUG15195
     C                   IF        %SUBST(ORDCST:1:1) = '/'                                 BUG15195
     C                   EVAL      P@STR = %SUBST(ORDCST:2:34)                              BUG15195
     C                   ELSE                                                               BUG15195
     C                   EVAL      P@STR = %SUBST(ORDCST:1:34)                              BUG15195
     C                   ENDIF                                                              BUG15195
     C                   CALL      'AOACCTV1'                                               BUG15195
     C                   PARM      *BLANKS       P@RTCD                                     BUG15195
     C                   PARM      *BLANKS       P@TYP                                      BUG15195
     C                   PARM                    P@STR                                      BUG15195
     C                   PARM                    DSSDY                                      BUG15195
                                                                                            BUG15195
     C                   IF        P@RTCD = '*NRF' and P@TYP = '*NRF'                       BUG15195
                                                                                            BUG15195
     C                   IF        %SUBST(ORDCST:1:1) = '/'                                 BUG15195
     C                   Eval      P@IBAN = %SUBST(ORDCST:2:34)                             BUG15195
     C                   Else                                                               BUG15195
     C                   Eval      P@IBAN = %SUBST(ORDCST:1:34)                             BUG15195
     C                   ENDIF                                                              BUG15195
                                                                                            BUG15195
     C                   CALL      'AOIBANR4'                                               BUG15195
     C                   PARM      *BLANKS       P@RTCD                                     BUG15195
     C                   PARM      '*KEY'        P@OPTN                                     BUG15195
     C                   PARM                    P@IBAN                                     BUG15195
     C     SDACCNT       PARM      SDACCNT       DSSDY                                      BUG15195
     C                   ENDIF                                                              BUG15195
     C                   ENDIF                                                              BUG15195
                                                                                            BUG15195
     C                   SELECT                                                             BUG15195
     C                   WHEN      P@RTCD = *BLANKS and P@TYP = '*NRF'                      BUG15195
     C                   IF        %SUBST(ORDCST:1:1) = '/'                                 BUG15195
     C                   Eval      Wcountry =  %SUBST(ORDCST:2:2)                           BUG15195
     C                   ELSE                                                               BUG15195
     C                   Eval      Wcountry =  %SUBST(ORDCST:1:2)                           BUG15195
     C                   ENDIF                                                              BUG15195
     C                   Eval      @@IBAN = 'Y'                                             BUG15195
     C                   Eval      P@TYP = *BLANKS                                          BUG15195
     C                   WHEN      (%SUBST(ORDCST:1:1) = '/' AND                            BUG15195
     C                             %LEN(%TRIM(ORDCST)) = 12) OR                             BUG15195
     C                             (%SUBST(ORDCST:1:1) <> '/' AND                           BUG15195
     C                             %LEN(%TRIM(ORDCST)) = 11) OR                             BUG15195
      ** Customer                                                                           BUG15195
     C                             (%LEN(%TRIM(ORDCST)) = 7 AND                             BUG15195
     C                             %SUBST(ORDCST:1:1) = '/') OR                             BUG15195
     C                             (%LEN(%TRIM(ORDCST)) = 6 AND                             BUG15195
     C                             %SUBST(ORDCST:1:1) <> '/') OR                            BUG15195
      ** Shortname                                                                          BUG15195
     C                             P@TYP = '*SHNAME'                                        BUG15195
                                                                                            BUG15195
     C                   IF        %SUBST(ORDCST:1:1) = '/'                                 BUG15195
     C                   EVAL      P@STR = %SUBST(ORDCST:2:34)                              BUG15195
     C                   ELSE                                                               BUG15195
     C                   EVAL      P@STR = %SUBST(ORDCST:1:34)                              BUG15195
     C                   ENDIF                                                              BUG15195
                                                                                            BUG15195
     C                   CALL      'AOACCTV1'                                               BUG15195
     C                   PARM      *BLANKS       P@RTCD                                     BUG15195
     C                   PARM      *BLANKS       P@TYP                                      BUG15195
     C                   PARM                    P@STR                                      BUG15195
     C                   PARM                    DSSDY                                      BUG15195
                                                                                            BUG15195
     C                   IF        P@TYP = '*RETAIL' OR                                     BUG15195
     C                             P@TYP = '*LEDGER'                                        BUG15195
     C                   EVAL      SDACCNT = DSSDY                                          BUG15195
     C                   MOVE      CNUM          WCustomer                                  BUG15195
     C                   IF        P@Typ = '*RETAIL'                                        BUG15195
     C                   MOVEL     CNUM          PCUST                                      BUG15195
     C                   MOVEL     ACOD          WACODC           10                        BUG15195
     C                   MOVEL     ACSQ          WACSQC            2                        BUG15195
     C                   EVAL      PAcctyp = 'R'                                            BUG15195
     C                   ELSE                                                               BUG15195
     C                   EVAL      PAcctyp = 'G'                                            BUG15195
     C                   ENDIF                                                              BUG15195
     C                   EVAL      PAccount = BRCA + PCUST + CCY                            BUG15195
     C                                      + WACODC + WACSQC                               BUG15195
     C                   ENDIF                                                              BUG15195
                                                                                            BUG15195
     C                   IF        P@TYP = '*CUSTNO' OR                                     BUG15195
     C                             P@TYP = '*SHNAME'                                        BUG15195
     C                   EVAL      SDCUST    = DSSDY                                        BUG15195
     C                   MOVE      BBCUST        WCustomer                                  BUG15195
     C                   IF        P@Typ = '*CUSTNO'                                        BUG15195
     C                   EVAL      PAcctyp = 'C'                                            BUG15195
     C                   IF        %Subst(ORC1:1:1) = '/'                                   BUG15195
     C                   EVAL      PCust = %Subst(ORC1:2:6)                                 BUG15195
     C                   ELSE                                                               BUG15195
     C                   EVAL      PCust = %Subst(ORC1:1:6)                                 BUG15195
     C                   ENDIF                                                              BUG15195
     C                   EndIf                                                              BUG15195
     C                   ENDIF                                                              BUG15195
     C                   WHEN      (%SUBST(ORDCST:1:1) = '/' AND                            BUG15195
     C                             %LEN(%TRIM(ORDCST)) = 22) OR                             BUG15195
     C                             (%SUBST(ORDCST:1:1) <> '/' AND                           BUG15195
     C                             %LEN(%TRIM(ORDCST)) = 21) OR                             BUG15195
     C                             (%SUBST(ORDCST:1:1) = '/' AND                            BUG15195
     C                             %LEN(%TRIM(ORDCST)) = 25) OR                             BUG15195
     C                             (%SUBST(ORDCST:1:1) <> '/' AND                           BUG15195
     C                             %LEN(%TRIM(ORDCST)) = 24)                                BUG15195
                                                                                            BUG15195
     C                   Eval      P@CUST = %SUBST(ORDCST:1:6)                              BUG15195
     C                   Eval      P@ACCD = %SUBST(ORDCST:7:10)                             BUG15195
     C                   Eval      P@ACSQ = %SUBST(ORDCST:17:2)                             BUG15195
     C                   Eval      P@CYCD = PDCY                                            BUG15195
     C                   IF        BGMBIN = 'Y'                                             BUG15195
     C                   EVAL      P@Brcd = ADPBRC                                          BUG15195
     C                   ELSE                                                               BUG15195
     C                   EVAL      P@Brcd = BJSBRC                                          BUG15195
     C                   ENDIF                                                              BUG15195
                                                                                            BUG15195
     C                   CALL      'AOACCTR0'                                               BUG15195
     C                   PARM      *BLANKS       P@RTCD                                     BUG15195
     C                   PARM      '*KEY'        P@OPTN                                     BUG15195
     C                   PARM      *Zeros        P@RETL                                     BUG15195
     C                   PARM                    P@CUST                                     BUG15195
     C                   PARM                    P@CYCD                                     BUG15195
     C                   PARM                    P@ACCD                                     BUG15195
     C                   PARM                    P@ACSQ                                     BUG15195
     C                   PARM                    P@BRCD                                     BUG15195
     C     SDACCNT       PARM      SDACCNT       DSSDY                                      BUG15195
                                                                                            BUG15195
     C                   IF        P@RTCD = *BLANKS                                         BUG15195
     C                   MOVE      CNUM          P@CUST                                     BUG15195
     C                   Eval      Pacctyp = 'P'                                            BUG15195
     C                   Eval      Pcust = P@CUST                                           BUG15195
     C                   Eval      Pcurrency = P@CYCD                                       BUG15195
     C                   Eval      PAccount = P@BRCD + P@CUST + P@CYCD                      BUG15195
     C                                      + P@ACCD + P@ACSQ                               BUG15195
      *                                                                                     BUG15195
     C                   ENDIF                                                              BUG15195
     C                   WHEN      W9RTN = *BLANKS                                          BUG15195
     C                   Eval      PCUST = D_BBCUST                                         BUG15195
     C                   EVAL      WCountry = %Subst(ORDCST:5:2)                            BUG15195
     C                   IF        %SUBST(WCountry:1:1) = '/'                               BUG15195
     C                   EVAL      WCountry = %Subst(ORDCST:6:2)                            BUG15195
     C                   ENDIF                                                              BUG15195
     C                   Eval      P@TYP = *BLANKS                                          BUG15195
     C                   Eval      Pacctyp = 'S'                                            BUG15195
                                                                                            BUG15195
 
      ** ordcst is the swift address
 
     C                   OTHER                                                              BUG15195
     C                   IF        (%LEN(%TRIM(ORC1)) = 7 AND                               BUG15195
     C                             %SUBST(ORDCST:1:1) = '/') OR                             BUG15195
     C                             (%LEN(%TRIM(ORC1)) = 6 AND                               BUG15195
     C                             %SUBST(ORDCST:1:1) <> '/')                               BUG15195
                                                                                            BUG15195
     C                   IF        %SUBST(ORDCST:1:1) = '/'                                 BUG15195
     C                   EVAL      P@STR = %SUBST(ORDCST:2:34)                              BUG15195
     C                   ELSE                                                               BUG15195
     C                   EVAL      P@STR = %SUBST(ORDCST:1:34)                              BUG15195
     C                   ENDIF                                                              BUG15195
                                                                                            BUG15195
     C                   CALL      'AOACCTV1'                                               BUG15195
     C                   PARM      *BLANKS       P@RTCD                                     BUG15195
     C                   PARM      *BLANKS       P@TYP                                      BUG15195
     C                   PARM                    P@STR                                      BUG15195
     C                   PARM                    DSSDY                                      BUG15195
                                                                                            BUG15195
     C                   IF        P@TYP = '*CUSTNO' OR                                     BUG15195
     C                             P@TYP = '*SHNAME'                                        BUG15195
     C                   EVAL      SDCUST    = DSSDY                                        BUG15195
     C                   MOVE      BBCUST        WCustomer                                  BUG15195
     C                   IF        P@Typ = '*CUSTNO'                                        BUG15195
     C                   EVAL      PAcctyp = 'C'                                            BUG15195
     C                   IF        %Subst(ORC1:1:1) = '/'                                   BUG15195
     C                   EVAL      PCust = %Subst(ORC1:2:6)                                 BUG15195
     C                   ELSE                                                               BUG15195
     C                   EVAL      PCust = %Subst(ORC1:1:6)                                 BUG15195
     C                   ENDIF                                                              BUG15195
     C                   EndIf                                                              BUG15195
                                                                                            BUG15195
     C                   Eval      P@CUST1 = P@STR                                          BUG15195
                                                                                            BUG15195
     C                   CALL      'AOACUSR0'                                               BUG15195
     C                   PARM      *BLANKS       P@RTCD                                     BUG15195
     C                   PARM      '*KEY'        P@KEY                                      BUG15195
     C                   PARM                    P@Cust1                                    BUG15195
     C     SDACUS        PARM      SDACUS        DSLDY                                      BUG15195
                                                                                            BUG15195
     C                   Eval      WCountry = BBCOLC                                        BUG15195
     C                   Eval      Paccount = *BLANKS                                       BUG15195
     C                                                                                      BUG15195
     C                   ENDIF                                                              BUG15195
                                                                                            BUG15195
     C                   ENDIF                                                              BUG15195
                                                                                            BUG15195
     C                   IF        ORC3 <> *BLANKS and                                      BUG15195
     C                             ORC4 <> *BLANKS                                          BUG15195
     C                   EVAL      WCountry = %Subst(ORDCST:5:2)
     C                   IF        %SUBST(WCountry:1:1) = '/'                               BUG15195
     C                   EVAL      WCountry = %Subst(ORDCST:6:2)                            BUG15195
     C                   ENDIF                                                              BUG15195
     C                   ENDIF                                                              BUG15195
     C                   Eval      Pacctyp = 'A'                                            BUG15195
     C                   Eval      P@TYP = *BLANKS                                          BUG15195
                                                                                            BUG15195
     C                   ENDSL                                                              BUG15195
 
     C                   OTHER
 
     C                   CALL      'AOACCTV1'
     C                   PARM      *BLANKS       P@RTCD
     C                   PARM      *BLANKS       P@TYP
     C                   PARM      ORDCST        P@STR
     C                   PARM                    DSSDY
                                                                                              CSW207
     C                   EVAL      PAcctyp = *Blanks                                          CSW207
 
     C                   SELECT
 
     C                   WHEN      P@TYP = '*RETAIL' OR
     C                             P@TYP = '*LEDGER'
     C                   EVAL      SDACCNT = DSSDY
     C                   EVAL      WCustomer = CNUM
     C                   IF        P@Typ = '*RETAIL'                                          CSW207
     C                   EVAL      PAcctyp = 'R'                                              CSW207
     C                   MOVEL     CNUM          PCUST                                      BUG15195
     C                   MOVEL     ACOD          WACODC           10                        BUG15195
     C                   MOVEL     ACSQ          WACSQC            2                        BUG15195
     C                   ELSE                                                                 CSW207
     C                   EVAL      PAcctyp = 'G'                                              CSW207
     C                   ENDIF                                                                CSW207
     C**********         EVAL      PAccount = %Subst(ORC1:2:34)                      CSW207 BUG15195
     C                   EVAL      PAccount = BRCA + PCUST + CCY                            BUG15195
     C                                      + WACODC + WACSQC                               BUG15195
 
     C                   WHEN      P@TYP = '*NOSTRO'
     C                   EVAL      SDNOST    = DSSDY
     C                   EVAL      WCustomer = A7CUST
     C                   EVAL      PAcctyp = 'N'                                              CSW207
     C                   EVAL      PCurrency = %Subst(ORC1:2:3)                               CSW207
     C                   EVAL      PNostro = %Subst(ORC1:5:2)                                 CSW207
 
     C                   WHEN      P@TYP = '*CUSTNO' OR
     C                             P@TYP = '*SHNAME'
     C                   EVAL      SDCUST    = DSSDY
     C                   EVAL      WCustomer = BBCUST
     C                   IF        P@Typ = '*CUSTNO'                                          CSW207
     C                   EVAL      PAcctyp = 'C'                                              CSW207
     C                   IF        %Subst(ORC1:1:1) = '/'                                     CSW207
     C                   EVAL      PCust = %Subst(ORC1:2:6)                                   CSW207
     C                   ELSE                                                                 CSW207
     C                   EVAL      PCust = %Subst(ORC1:1:6)                                   CSW207
     C                   ENDIF                                                                CSW207
     C                   EndIf                                                                CSW207
 
     C                   ENDSL
 
     C                   ENDSL
 
      ** Currency
 
     C                   EVAL      WCurrency = PDCY
 
      ** Determine from where to get Nostro: Sender Correspondent
      ** or Destination (1st field)
 
     C                   EVAL      WAddress = ' '
     C                   IF        SNCO <> *BLANKS
     C                   EVAL      WAddress = SNCO
     C                   ELSE
     C                   IF        DST1 <> *BLANKS
     C                   EVAL      WAddress = DST1
     C                   ENDIF
     C                   ENDIF
 
      ** Prepare to extract the nostro number
 
     C                   SELECT
     C                   WHEN      WEntryType = 'P' OR
     C                             WEntryType = 'G'
 
      ** Check if multi-branch to determine how the branch is retrieved.
 
     C                   IF        BGMBIN = 'Y'
     C                   EVAL      P@Brcd = ADPBRC
     C                   ELSE
     C                   EVAL      P@Brcd = BJSBRC
     C                   ENDIF
 
     C                   IF        WEntryType = 'P'
     C                   EVAL      P@Cust = ADPCNM
     C                   EVAL      P@Accd = ADPACD
     C                   EVAL      P@ACSQ = ADPASQ
     C                   EVAL      P@CYCD = WCurrency
     C                   ELSE
     C                   EVAL      P@Cust = ADGCNM
     C                   EVAL      P@Accd = ADGACD
     C                   EVAL      P@ACSQ = ADGASQ
     C                   EVAL      P@CYCD = WCurrency
     C                   ENDIF
 
     C                   WHEN      WEntryType = 'R'
 
     C                   CALL      'AOACCTR0'
     C                   PARM      *BLANKS       P@RTCD
     C                   PARM      '*KEY'        P@OPTN
     C                   PARM      WAddress      P@RETL
     C                   PARM      *BLANKS       P@CUST
     C                   PARM      *BLANKS       P@CYCD
     C                   PARM      *BLANKS       P@ACCD
     C                   PARM      *BLANKS       P@ACSQ
     C                   PARM      *BLANKS       P@BRCD
     C     SDACCNT       PARM      SDACCNT       DSSDY
 
     C                   IF        P@RTCD = *BLANKS
     C                   EVAL      P@CUST = CNUM
     C                   EVAL      P@ACCD = %EDITC(ACOD:'X')
     C                   EVAL      P@CYCD = PDCY
     C                   EVAL      P@BRCD = BRCA
     C                   EVAL      P@ACSQ = %EDITC(ACSQ:'X')
     C                   ENDIF
 
     C                   WHEN      WEntryType = 'I'
     C                   CALL      'AOIBANR4'
     C                   PARM      *BLANKS       P@RTCD
     C                   PARM      '*KEY'        P@OPTN
     C                   PARM      WAddress      P@IBAN
     C     SDACCNT       PARM      SDACCNT       DSSDY
 
     C                   IF        P@RTCD = *BLANKS
     C                   EVAL      @@IBAN = 'Y'                                               CSW207
     C                   EVAL      P@CUST = CNUM
     C                   EVAL      P@ACCD = %EDITC(ACOD:'X')
     C                   EVAL      P@CYCD = WCurrency
     C                   EVAL      P@BRCD = BRCA
     C                   EVAL      P@ACSQ = %EDITC(ACSQ:'X')
     C                   ENDIF
 
     C                   ENDSL
 
      ** Retrieve nostro number for diffent types
 
     C                   SELECT
 
      ** For Entry Type 'N', just get it directly from input
 
     C                   WHEN      WEntryType = 'N'
     C                   EVAL      WNostro = ADNOSN
 
 
      ** For Entry Type 'F', just get it directly from input
 
     C                   WHEN      WEntryType = 'F'
     C                   EVAL      WNostro = ADFNNB
 
      ** For other types, get it from SDNOSTPD
 
     C                   WHEN      WEntryType = 'P' Or
     C                             WEntryType = 'G' Or
     C                             WEntryType = 'R' Or
     C                             WEntryType = 'I'
 
     C                   CALL      'AONOSTR0'
     C                   PARM      *BLANKS       P@RTCD
     C                   PARM      '*KEY'        P@OPTN
     C                   PARM                    P@CUST
     C                   PARM                    P@CYCD
     C                   PARM                    P@ACCD
     C                   PARM                    P@ACSQ
     C                   PARM      *BLANKS       P@NONB
     C                   PARM                    P@BRCD
     C                   PARM      *BLANKS       P@CSSN
     C                   PARM      *BLANKS       P@PNOI
     C     SDNOST        PARM      SDNOST        DSSDY
 
     C                   If        P@RTCD = *BLANKS
     C                   EVAL      WNostro = A7NONB
     C                   ENDIF
 
     C                   ENDSL
                                                                                              CSW207
      ** Validate 50F Format                                                                  CSW207
                                                                                              CSW207
     C                   IF        CSW207 = 'Y'                                               CSW207
                                                                                              CSW207
     C                   If        @@IBAN = 'Y'                                               CSW207
     C                             And PAcctyp = *Blanks                                      CSW207
     C                   Eval      PAcctyp = 'I'                                              CSW207
     C                   Eval      PCUST = *BLANKS                                          BUG15195
     C                   MOVEL     CCY           PCurrency                                  BUG15195
     C                   Eval      P@BRCD = BRCA                                            BUG15195
     C                   Move      CNUM          WCNUM                                        CSW207
     C                   Move      ACOD          WACOD                                        CSW207
     C                   Move      ACSQ          WACSQ                                        CSW207
     C                   Eval      PAccount = BRCA + WCNUM + CCY                              CSW207
     C                                      + WACOD + WACSQ                                   CSW207
     C                   EndIf                                                                CSW207
                                                                                              CSW207
     C                   CALL      'FT001000'                                                 CSW207
     C                   PARM      *BLANKS       PrtCd                                        CSW207
     C                   PARM      *BLANKS       PMsgID                                       CSW207
     C                   PARM      *BLANK        PErrTyp           1                          CSW207
     C                   PARM      'TRAN'        PVType                                       CSW207
     C                   PARM      ORC1          P50F1                                        CSW207
     C                   PARM      ORC2          P50F2                                        CSW207
     C                   PARM      ORC3          P50F3                                        CSW207
     C                   PARM      ORC4          P50F4                                        CSW207
     C                   PARM      ORC5          P50F5                                        CSW207
     C**********         PARM                    PAccount                            CSW207 BUG15195
     C                   PARM                    PAcctyp                                      CSW207
     C                   PARM                    PAccount                                   BUG15195
     C                   PARM                    PCust                                        CSW207
     C                   PARM      *BLANKS       PNonActH                                     CSW207
     C                   PARM      WNetwork      PNetwork                                     CSW207
     C                   PARM      P@TYP         PMsgType                                     CSW207
     C                   PARM      WFieldTag     PMsgTag                                      CSW207
     C**********         PARM      P@BRCD        PBranch                             CSW207 BUG15195
     C                   PARM      WCountry      PCountry                                     CSW207
     C                   PARM      P@BRCD        PBranch                                    BUG15195
     C                   PARM                    PCurrency                                    CSW207
     C                   PARM                    PNostro                                      CSW207
     C                   PARM                    PModInd           2                          CSW207
     C                   PARM                    POut1            35                          CSW207
     C                   PARM                    POut2            35                          CSW207
     C                   PARM                    POut3            35                          CSW207
     C                   PARM                    POut4            35                          CSW207
     C                   PARM                    POut5            35                          CSW207
                                                                                              CSW207
     C                   IF        PrtCd  = *BLANKS                                           CSW207
     C                   EVAL      WFieldTag = ':50F:'                                        CSW207
     C                   ENDIF                                                                CSW207
                                                                                              CSW207
     C                   ENDIF                                                                CSW207
 
     C                   ENDSR
 
      *****************************************************************
      /TITLE SR/SRRCFP
      *****************************************************************
      *                                                               *
      *  SRRCFP - Subroutine to register the Printer Files via RCF.   *
      *                                                               *
      *****************************************************************
      *
     C     SRRCFP        BEGSR
 
      ** Ensure Report Spool File recorded by RCF
 
     C                   Z-ADD     SFNUM1        PZSNUM
 
     C                   CALL      'ZSFILE'
     C                   PARM                    PSEQ
     C                   PARM                    PETTY
     C                   PARM      SFILE1        PSFILE
     C                   PARM                    PZSNUM
     C                   PARM      *BLANK        PZSERR
 
      ** If Error occurs during ZSFILE processing, then return to the
      ** Calling Program
 
     C                   IF        PZSERR = 'Y'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
 
      ** Ensure Report Spool File recorded by RCF
 
     C                   Z-ADD     SFNUM2        PZSNUM
 
     C                   CALL      'ZSFILE'
     C                   PARM                    PSEQ
     C                   PARM                    PETTY
     C                   PARM      SFILE2        PSFILE
     C                   PARM                    PZSNUM
     C                   PARM      *BLANK        PZSERR
 
      ** If Error occurs during ZSFILE processing, then return to the
      ** Calling Program
 
     C                   IF        PZSERR = 'Y'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
 
     C                   ENDSR
 
      /TITLE SR/SRCUST
      *****************************************************************
      *                                                               *
      *  SRCUST   - Check for Customer                                *
      *                                                               *
      *****************************************************************
 
     C     SRCUST        BEGSR
 
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       P@RTCD
     C                   PARM      '*KEY'        P@OPTN
     C                   PARM      WCustomer     P@CUST
     C                   PARM      *BLANKS       P@ERRC
     C     SDCUST        PARM      SDCUST        DSSDY
 
     C                   ENDSR
      *****************************************************************
