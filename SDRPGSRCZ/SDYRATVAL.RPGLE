     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Yield rates validation')                      *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  SDYRATVAL - Yield Rates Validation                           *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CER059             Date 19Jul10               *
      *  Prev Amend No. CER043             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 CRE026             Date 24May06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 228390             Date 14Jul04               *
      *                 CAS008             Date 16Jun04               *
      *                 220004             Date 24Jul03               *
      *                 208179             Date 05Aug02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAS001  *CREATE    Date 23Nov01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER043 - German Features LF041-00 New Fields and Defaulting  *
      *           (Recompile)                                         *
      *  CRE026 - Consumer Banking                                    *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  228390 - Introduce a new yield curve type 'S' (for swap      *
      *           rates) which will apply the formula currently being *
      *           used by curve type 'Z' and a new formula for type   *
      *           'Z' is to be introduced.                            *
      *  CAS008 - IAS 39 Enhancements                                 *
      *  220004 - Change call to AOCURRR0 to use DSSDY not DSFDY.     *
      *  208179 - 24x7 Midas Availability                             *
      *  CAS001 - Net Present Value (NPV) Accounting                  *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      *****************************************************************
      *                                                               *
      *  F U N C T I O N   O F   I N D I C A T O R S                  *
      *                                                               *
      *  80  - LOOKUP Indicator                                       *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRINIT      - Initialisation Processing                      *
      *  SRVALINPUT  - Validate Input Details                         *
      *  SRVSFSC     - Validate Subfile Screen                        *
      *  SRSETERRFLD - Set up error field                             *
      *  SRVPDYR     - Validate Spot Years                            *
      *  SRVPDMN     - Validate Spot Months                           *
      *  SRVPDDY     - Validate Spot Days                             *
      *  SRVMDAT     - Validate Maturity Date                         *
      *  SRVYRAT     - Validate Rate/Discount Factor                  *
      *  SRSETUPVLD  - Set Up Valid File                              *
      *  SRRESETERRS - Reset error information that is received back  *
      *               from each validation module                     *
      *  SRUPDATERRS - Update error information with that received    *
      *               back from each validation module                *
      *  *INZSR      - Initialisation                                 *
      *  *PSSR       - DB Error Processing                            *
      *                                                               *
      *****************************************************************
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARR1
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the size
      ** of the arrays.
     D/COPY ZACPYSRC,ERR_XARR1
      **--------------------------------------------------------------------------------------------
 
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
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Maturity Date
     D PMatAr          S              7    DIM(98)
 
      ** Maturity Date (Numeric)
     D PNMatAr         S              5P 0 DIM(98)
 
      ** Period Years Array
     D PYrAr           S              2    DIM(98)
 
      ** Period Years Array (Numeric)
     D PNYrAr          S              2  0 DIM(98)
 
      ** Period Month Array
     D PMnAr           S              2    DIM(98)
 
      ** Period Month Array (Numeric)
     D PNMnAr          S              2  0 DIM(98)
 
      ** Period Days Array
     D PDyAr           S              2    DIM(98)
 
      ** Period Days Array (Numeric)
     D PNDyAr          S              2  0 DIM(98)
 
      ** Yield Rate Array
     D PYRteAr         S             14    DIM(98)
 
      ** Yield Rate Array (Numeric)
     D PNYRteAr        S             13P 9 DIM(98)
 
      ** Maturity Date
     D PMatArW         S              7    DIM(98)
 
      ** Maturity Date (Numeric)
     D PNMatArW        S              5P 0 DIM(98)
 
      ** Period Years Array
     D PYrArW          S              2    DIM(98)
 
      ** Period Years Array (Numeric)
     D PNYrArW         S              2  0 DIM(98)
 
      ** Period Month Array
     D PMnArW          S              2    DIM(98)
 
      ** Period Month Array (Numeric)
     D PNMnArW         S              2  0 DIM(98)
 
      ** Period Days Array
     D PDyArW          S              2    DIM(98)
 
      ** Period Days Array (Numeric)
     D PNDyArW         S              2  0 DIM(98)
 
      ** Yield Rate Array
     D PYRteArW        S             14    DIM(98)
 
      ** Yield Rate Array (Numeric)
     D PNYRteArW       S             13P 9 DIM(98)
 
      ** Subfile Record Array
     D PSflRAr         S             20    DIM(98)
 
      ** Yield Rates Details in screen format
     D YRATScnFmt    E DS                  EXTNAME(SDYRATPD)
 
      ** Yield Rates Details OK indicators
     D YRATOKFlgs    E DS                  EXTNAME(SDEYRATPD)
 
      ** Valid Yield Rates Details layout
     D YRATValid     E DS                  EXTNAME(SDVYRATPD)
 
      ** Previous Yield Rates Details layout
     D YRATPrev      E DS                  EXTNAME(SDVYRATPD)
     D                                     PREFIX(P_)
 
      ** Yield Rates Extra Data
     D YRATExtDta    E DS                  EXTNAME(SDYREXPD)
 
      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** External DS for Yield Curve Details
     D SDYLDC        E DS                  EXTNAME(SDYLDCPD)
     D                                     PREFIX(P)
 
      ** External DS for Currency Details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      ** Short DS for access programs
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Long DS for access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** Output parameter of ZDATE2
     D PADate          DS             7
     D  PDay                   1      2
     D  PMonth                 3      5
     D  PYear                  6      7
 
      ** Period date DS
     D PeriodDS        DS
     D WPerYr                  1      2
     D WPerMn                  3      4
     D WPerDy                  5      6
 
      ** External DS for SAR details                                                          208179
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  208179
                                                                                              208179
      ** 24X7 status data area                                                                208179
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)                     208179
                                                                                              208179
      ** SD data area                                                                         208179
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)                     208179
                                                                                              208179
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Response mode
     D RespMode        S              1
 
      ** Mode of operation
     D PModeOfOp       S              6
 
      ** Work fields for bank data
     D WKDFIN          S                   LIKE(BJDFIN)
     D WKRDNB          S                   LIKE(BJRDNB)
     D WKCYCD          S                   LIKE(BJCYCD)
 
      ** Index for arrays of of error message ids etc
     D Idx             S              3P 0
 
      ** Index for arrays of of warning message ids etc
     D WIdx            S              3P 0
 
      ** Fields used in mapping subfile fields and error data
     D WSFDta          S           1960
     D A               S              4  0
     D B               S              4  0
     D C               S              4  0
     D D               S              4  0
     D E               S              4  0
     D F               S              4  0
     D I               S              4  0
 
      ** ZDATE2 parameters
     D PDayNo          S                   LIKE(BJRDNB)
     D PDtFmt          S                   LIKE(BJDFIN)
     D PDate           S              6  0
 
      ** Access Objects parameters
     D PRTCD           S              7
     D POPTN           S              7
     D PYLDC           S              5
     D PCURR           S              3
 
      ** Other work fields/parameter fields
     D WElementN       S              2
     D WErrFld         S             10
     D WSFInp          S           1960
     D PYrOK           S              1
     D PMnOK           S              1
     D PDyOK           S              1
     D PYRteOK         S              1
     D PerYear         S              2
     D PerNYear        S              2  0
     D PerMonth        S              2
     D PerNMonth       S              2  0
     D PerDay          S              2
     D PerNDay         S              2  0
     D PerYRte         S             14
     D PerNYRte        S             13P 9
     D PPrvRate        S             13P 9
     D PPrvPDte        S              5P 0
     D PEntry          S              5  0
                                                                                              208179
     D CSC011          S              1A                                                      208179
     D PSard           S              6A                                                      208179
     D CAS008          S              1A                                                      CAS008
     D WRKPDY          S              2  0                                                    CRE026
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *inzsr is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      ** Initialisation Processing
 
     C                   EXSR      SRINIT
 
      ** Validate input fields
 
     C                   EXSR      SRVALINPUT
 
      ** If no errors set up outstanding fields for valid file
 
     C                   IF        Idx = 0
     C                   EXSR      SRSETUPVLD
     C                   ENDIF
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRINIT  - Initialisation Processing                           *
      *                                                               *
      * Called By : Main Processing                                   *
      *                                                               *
      * Calls : None                                                  *
      *                                                               *
      *****************************************************************
 
     C     SRINIT        BEGSR
 
      ** Initialise valid file
 
     C                   CLEAR                   YRATValid
 
      ** Initialise fields and arrays
 
     C                   EVAL      PPrvPDte = *ZERO
     C                   EVAL      PPrvRate = *ZERO
     C                   EVAL      PMatAr = *BLANK
     C                   EVAL      PNMatAr = *ZERO
     C                   EVAL      PYrAr = *BLANK
     C                   EVAL      PNYrAr = *ZERO
     C                   EVAL      PMnAr = *BLANK
     C                   EVAL      PNMnAr = *ZERO
     C                   EVAL      PDyAr = *BLANK
     C                   EVAL      PNDyAr = *ZERO
     C                   EVAL      PYRteAr = *BLANK
     C                   EVAL      PNYRteAr = *ZERO
     C                   EVAL      PSflRAr = *BLANK
 
      ** If amend move previous details to the valid file to include
      ** unchanged details.
 
     C                   IF        #0ACTN = 'A'
     C                   EVAL      YRATValid = YRATPrev
     C                   ENDIF
 
      ** Access yield curve details via access object AOYLDCR0 if no error
      ** from RTV module
 
     C                   CALL      'AOYLDCR0'
     C                   PARM      *BLANK        PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      #0YLDC        PYLDC
     C     SDYLDC        PARM      SDYLDC        DSFDY
 
      ** Database Error
 
     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      DBFILE = 'SDYLDCPD'
     C                   EVAL      DBASE  = 2
     C                   EVAL      DBKEY  = PYLDC
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Access currency details via access object AOCURRR0 if no error from
      ** RTV module
 
     C                   IF        #0YCCY <> *BLANK
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANK        PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      #0YCCY        PCURR
     C*****SDCURR        PARM      SDCURR        DSFDY                                        220004
     C     SDCURR        PARM      SDCURR        DSSDY                                        220004
 
      ** Database Error
 
     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      DBFILE = 'SDCURRPD'
     C                   EVAL      DBASE  = 3
     C                   EVAL      DBKEY  = PCURR
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRVALINPUT - Validate Input Details                           *
      *                                                               *
      * Called By : Main Processing                                   *
      *                                                               *
      * Calls :                                                       *
      * SRVPDYR     - Validate Period Year                            *
      * SRVPDMN     - Validate Period Month                           *
      * SRVPDDY     - Validate Period Days                            *
      * SRVMDAT     - Validate Maturity Date                          *
      * SRVYRAT     - Validate Yield Rate                             *
      *                                                               *
      *****************************************************************
 
     C     SRVALINPUT    BEGSR
 
      ** Reset record entry workfield
 
     C                   EVAL      PEntry = *ZERO
 
      ** Reset Counter to be use in mapping subfile fields from screen DS
 
     C                   EVAL      A = *ZERO
     C                   EVAL      B = *ZERO
     C                   EVAL      C = *ZERO
     C                   EVAL      D = *ZERO
     C                   EVAL      E = *ZERO
     C                   EVAL      F = *ZERO
 
     C                   EVAL      A = A + 1
     C                   EVAL      B = B + 1
     C                   EVAL      C = B + 2
     C                   EVAL      D = C + 2
     C                   EVAL      E = D + 2
     C**********         EVAL      F = F + 6                                                  CAS008
     C                   EVAL      F = F + 7                                                  CAS008
 
      ** Save subfile screen data to a workfield
 
     C**********         EVAL      WSFDta = (%SUBST(YRATScnFmt:12:1960))                      CAS008
     C                   EVAL      WSFDta = (%SUBST(YRATScnFmt:14:1960))                      CAS008
 
      ** Set years, months, days, and discount factor arrays
 
     C                   DOW       A <= 98
 
      ** Details
 
     C                   EVAL      PYrAr(A) = (%SUBST(WSFDta:B:2))
     C                   EVAL      PMnAr(A) = (%SUBST(WSFDta:C:2))
     C                   EVAL      PDyAr(A) = (%SUBST(WSFDta:D:2))
     C                   EVAL      PYRteAr(A) = (%SUBST(WSFDta:E:14))
     C                   EVAL      PSflRAr(A) = (%SUBST(WSFDta:B:20))
 
      ** Validate subfile record if not blank
 
     C                   IF        (PSflRAr(A) <> *BLANK) OR
     C                             (WSFDta = *BLANK) AND (A = 1)
 
     C                   EVAL      WPerYr = PYrAr(A)
     C                   EVAL      WPerMn = PMnAr(A)
     C                   EVAL      WPerDy = PDyAr(A)
 
      ** Validate Period from Spot Year
 
     C                   EXSR      SRVPDYR
 
      ** Validate Period from Spot Month
 
     C                   EXSR      SRVPDMN
 
      ** Validate Period from Spot Days
 
     C                   EXSR      SRVPDDY
 
      ** Validate and Calculate Maturity Date
 
     C                   IF        (PYrOK = 'Y') AND (PMnOK = 'Y') AND
     C**********                   (PDyOK = 'Y')                                              CAS008
     C                             (PDyOK = 'Y') AND (CAS008 = 'N') OR                        CAS008
     C                             (PYrOK = 'Y') AND (PMnOK = 'Y') AND                        CAS008
     C                             (PDyOK = 'Y') AND (OKSPDY = 'Y') AND                       CAS008
     C                             (CAS008 = 'Y')                                             CAS008
     C                   EVAL      PEntry = PEntry + 1
     C                   EXSR      SRVMDAT
     C                   ENDIF
 
      ** Validate Rate/Discount Factor
 
     C                   EXSR      SRVYRAT
 
     C                   ENDIF
 
      ** Get next subfile data
 
     C                   EVAL      A = A + 1
     C                   EVAL      B = B + 20
     C                   EVAL      C = B + 2
     C                   EVAL      D = C + 2
     C                   EVAL      E = D + 2
     C                   EVAL      F = F + 4
     C                   ENDDO
 
      ** Move formatted year/month/days and yield rate to screen fields
 
     C                   EVAL      A = 1
     C**********         EVAL      B = 12                                                     CAS008
     C                   EVAL      B = 14                                                     CAS008
 
      ** Period Years
 
     C                   DOW       A < 98
     C                   EVAL      %SUBST(YRATScnFmt:B:2) = PYrAr(A)
     C                   EVAL      A = A + 1
     C                   EVAL      B = B + 20
     C                   ENDDO
 
      ** Period Months
 
     C                   EVAL      A = 1
     C**********         EVAL      B = 14                                                     CAS008
     C                   EVAL      B = 16                                                     CAS008
 
     C                   DOW       A < 98
     C                   EVAL      %SUBST(YRATScnFmt:B:2) = PMnAr(A)
     C                   EVAL      A = A + 1
     C                   EVAL      B = B + 20
     C                   ENDDO
 
      ** Period Days
 
     C                   EVAL      A = 1
     C**********         EVAL      B = 16                                                     CAS008
     C                   EVAL      B = 18                                                     CAS008
 
     C                   DOW       A < 98
     C                   EVAL      %SUBST(YRATScnFmt:B:2) = PDyAr(A)
     C                   EVAL      A = A + 1
     C                   EVAL      B = B + 20
     C                   ENDDO
 
      ** Yield Rates
 
     C                   EVAL      A = 1
     C**********         EVAL      B = 18                                                     CAS008
     C                   EVAL      B = 20                                                     CAS008
 
     C                   DOW       A < 98
     C                   EVAL      %SUBST(YRATScnFmt:B:14) = PYRteAr(A)
     C                   EVAL      A = A + 1
     C                   EVAL      B = B + 20
     C                   ENDDO
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRVSFSC - Validate Subfile Screen                             *
      *                                                               *
      * Called By : SRVALINPUT subroutine                             *
      *                                                               *
      * Calls :                                                       *
      * SRRESETERRS - Reset variables updated by validation           *
      * SRSETERRFLD - Setup Error Field                               *
      * SRUPDATERRS - Update error info                               *
      *                                                               *
      *****************************************************************
 
     C     SRVSFSC       BEGSR
 
      ** Initialise ok flags
 
     C                   EVAL      PYrOK = 'Y'
     C                   EVAL      PMnOK = 'Y'
     C                   EVAL      PDyOK = 'Y'
     C                   EVAL      PYRteOK = 'Y'
 
      ** Validate subfile screen. Check whether a blank line exists before the value
      ** entered
 
     C                   IF        (PSflRAr(A) = *BLANK) AND (A < 98)
     C                   EVAL      WSFInp = *BLANK
 
      ** Move data after the current subfile record to a work field
      ** to be use in checking whether a non-blank line exists after
      ** a blank line
 
     C                   EVAL      WSFInp = %SUBST(WSFDta:B+20)
 
      ** A blank line is found before the value, error message
 
     C                   IF        WSFInp <> *BLANK
   70C                   EVAL      PYrOK = 'N'
   70C                   EVAL      Idx = Idx + 1
   70C                   EVAL      WErrFld = '#0PDYR    '
   71C                   EXSR      SRSETERRFLD
   71C                   EVAL      FldNameAr2(Idx) = WErrFld
   71C                   EVAL      MsgIdAr2(Idx) = 'USR9203'
   71C                   EVAL      MsgDtaAr2(Idx) = *BLANK
 
   70C                   EVAL      PMnOK = 'N'
   70C                   EVAL      Idx = Idx + 1
   70C                   EVAL      WErrFld = '#0PDMN    '
   71C                   EXSR      SRSETERRFLD
   71C                   EVAL      FldNameAr2(Idx) = WErrFld
   71C                   EVAL      MsgIdAr2(Idx) = 'USR9203'
   71C                   EVAL      MsgDtaAr2(Idx) = *BLANK
 
   70C                   EVAL      PDyOK = 'N'
   70C                   EVAL      Idx = Idx + 1
   70C                   EVAL      WErrFld = '#0PDDY    '
   71C                   EXSR      SRSETERRFLD
   71C                   EVAL      FldNameAr2(Idx) = WErrFld
   71C                   EVAL      MsgIdAr2(Idx) = 'USR9203'
   71C                   EVAL      MsgDtaAr2(Idx) = *BLANK
 
   70C                   EVAL      PYRteOK = 'N'
   70C                   EVAL      Idx = Idx + 1
   70C                   EVAL      WErrFld = '#0YRAT    '
   71C                   EXSR      SRSETERRFLD
   71C                   EVAL      FldNameAr2(Idx) = WErrFld
   71C                   EVAL      MsgIdAr2(Idx) = 'USR9203'
   71C                   EVAL      MsgDtaAr2(Idx) = *BLANK
     C                   ENDIF
     C                   ENDIF
 
      ** Update subfile fields error indicator
 
     C                   IF        PYrOK = 'N'
     C                   EVAL      %SUBST(YRATOKFlgs:F:1) = PYrOK
     C                   ENDIF
 
     C                   IF        PMnOK = 'N'
     C                   EVAL      %SUBST(YRATOKFlgs:F+1:1) = PMnOK
     C                   ENDIF
 
     C                   IF        PDyOK = 'N'
     C                   EVAL      %SUBST(YRATOKFlgs:F+2:1) = PDyOK
     C                   ENDIF
 
     C                   IF        PYRteOK = 'N'
     C                   EVAL      %SUBST(YRATOKFlgs:F+3:1) = PYRteOK
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRSETERRFLD - Set up error field                              *
      *                                                               *
      * Called By : SRVSFSC subroutine                                *
      *                                                               *
      * Calls : None                                                  *
      *                                                               *
      *****************************************************************
 
     C     SRSETERRFLD   BEGSR
 
      ** Add Element number
 
     C                   MOVE      A             WElementN
     C                   EVAL      WErrFld = %Trim(WErrFld) + WElementN
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRVPDYR - Validate Spot Years                                 *
      *                                                               *
      * Called By : SRVALINPUT subroutine                             *
      *                                                               *
      * Calls :                                                       *
      * SRRESETERRS - Reset variables updated by validation           *
      * SDVPDYR01   - Validate Spot Years                             *
      * SRUPDATERRS - Update error info                               *
      *                                                               *
      *****************************************************************
 
     C     SRVPDYR       BEGSR
 
      ** Reset variables updated by this routine
 
     C                   EXSR      SRRESETERRS
 
      ** Years should not be blank if months and days are not entered
 
     C                   IF        (PYrAr(A) = *BLANK) AND (PeriodDS = *BLANK)
     C                   EVAL      PYrOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      WErrFld = '#0PDYR    '
     C                   EXSR      SRSETERRFLD
     C                   EVAL      FldNameAr2(Idx) = WErrFld
     C                   EVAL      MsgIdAr2(Idx) = 'USR9205'
     C                   ELSE
 
      ** Call SDVPDYR01 to validate spot years
 
     C                   CALLB     'SDVPDYR01'
     C                   PARM                    RetCodeOut
     C                   PARM                    A
     C     PYrAr(A)      PARM      PYrAr(A)      PerYear
     C                   PARM      *ZERO         PerNYear
     C                   PARM                    FldNamXAr2
     C                   PARM                    MsgIdXAr2
     C                   PARM                    MsgDtaXAr2
     C                   PARM      'Y'           PYrOK
     C                   ENDIF
 
      ** Update error info with that produced by this subroutine
 
     C                   EXSR      SRUPDATERRS
 
      ** Update subfile fields (Year) error indicator
 
     C                   IF        PYrOK = 'N'
     C                   EVAL      %SUBST(YRATOKFlgs:F:1) = PYrOK
     C                   ENDIF
 
      ** Update numeric year array
 
     C                   EVAL      PNYrAr(A) = PerNYear
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRVPDMN - Validate Spot Months                                *
      *                                                               *
      * Called By : SRVALINPUT subroutine                             *
      *                                                               *
      * Calls :                                                       *
      * SRRESETERRS - Reset variables updated by validation           *
      * SDVPDMN01   - Validate Spot Months                            *
      * SRUPDATERRS - Update error info                               *
      *                                                               *
      *****************************************************************
 
     C     SRVPDMN       BEGSR
 
      ** Reset variables updated by this routine
 
     C                   EXSR      SRRESETERRS
 
      ** Months should not be blank if years and days are not entered
 
     C                   IF        (PMnAr(A) = *BLANK) AND (PeriodDS = *BLANK)
     C                   EVAL      PMnOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      WErrFld = '#0PDMN    '
     C                   EXSR      SRSETERRFLD
     C                   EVAL      FldNameAr2(Idx) = WErrFld
     C                   EVAL      MsgIdAr2(Idx) = 'USR9207'
     C                   ELSE
 
      ** Call SDVPDMN01 to validate spot months
 
     C                   CALLB     'SDVPDMN01'
     C                   PARM                    RetCodeOut
     C                   PARM                    A
     C     PMnAr(A)      PARM      PMnAr(A)      PerMonth
     C                   PARM      *ZERO         PerNMonth
     C                   PARM                    FldNamXAr2
     C                   PARM                    MsgIdXAr2
     C                   PARM                    MsgDtaXAr2
     C                   PARM      'Y'           PMnOK
     C                   ENDIF
 
      ** Update error info with that produced by this subroutine
 
     C                   EXSR      SRUPDATERRS
 
      ** Update subfile fields (Month) error indicator
 
     C                   IF        PMnOK = 'N'
     C                   EVAL      %SUBST(YRATOKFlgs:F+1:1) = PMnOK
     C                   ENDIF
 
      ** Update numeric month array
 
     C                   EVAL      PNMnAr(A) = PerNMonth
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRVPDDY - Validate Spot Days                                  *
      *                                                               *
      * Called By : SRVALINPUT subroutine                             *
      *                                                               *
      * Calls :                                                       *
      * SRRESETERRS - Reset variables updated by validation           *
      * SDVPDDY01   - Validate Spot Days                              *
      * SRUPDATERRS - Update error info                               *
      *                                                               *
      *****************************************************************
 
     C     SRVPDDY       BEGSR
 
      ** Reset variables updated by this routine
 
     C                   EXSR      SRRESETERRS
   70
   70 ** Days should not be blank if years and months not entered
   70
   70C                   IF        (PDyAr(A) = *BLANK) AND (PeriodDS = *BLANK)
   70C                   EVAL      PDyOK = 'N'
   70C                   EVAL      Idx = Idx + 1
   70C                   EVAL      WErrFld = '#0PDDY    '
   71C                   EXSR      SRSETERRFLD
   71C                   EVAL      FldNameAr2(Idx) = WErrFld
   71C                   EVAL      MsgIdAr2(Idx) = 'USR9209'
   71C                   ELSE
 
      ** Call SDVPDDY01 to validate spot days
 
     C                   CALLB     'SDVPDDY01'
     C                   PARM                    RetCodeOut
     C                   PARM                    A
     C     PDyAr(A)      PARM      PDyAr(A)      PerDay
     C                   PARM      *ZERO         PerNDay
     C                   PARM                    FldNamXAr2
     C                   PARM                    MsgIdXAr2
     C                   PARM                    MsgDtaXAr2
     C                   PARM      'Y'           PDyOK
     C                   ENDIF
 
      ** Update error info with that produced by this subroutine
 
     C                   EXSR      SRUPDATERRS
 
      ** Update subfile fields (Days) error indicator
 
     C                   IF        PDyOK = 'N'
     C                   EVAL      %SUBST(YRATOKFlgs:F+2:1) = PDyOK
     C                   ENDIF
 
      ** Update numeric days array
 
     C                   EVAL      PNDyAr(A) = PerNDay
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRVMDAT - Validate Maturity Date                              *
      *                                                               *
      * Called By : SRVALINPUT subroutine                             *
      *                                                               *
      * Calls :                                                       *
      * SRRESETERRS - Reset variables updated by validation           *
      * SDVMDAT01   - Validate Maturity Date                          *
      * SRUPDATERRS - Update error info                               *
      *                                                               *
      *****************************************************************
 
     C     SRVMDAT       BEGSR
 
      ** Reset variables updated by this routine
 
     C                   EXSR      SRRESETERRS
 
      ** Call SDVMDAT01 to validate and calculate maturity date
 
     C                   CALLB     'SDVMDAT01'
     C                   PARM                    RetCodeOut
     C                   PARM                    A
     C                   PARM                    PEntry
     C                   PARM                    PerNYear
     C                   PARM                    PerNMonth
     C                   PARM                    PerNDay
     C                   PARM                    PPrvPDte
     C                   PARM                    WKRDNB
     C                   PARM                    #0YCCY
     C                   PARM                    #0YCFQ
     C                   PARM                    #0SPDY                                       CAS008
     C                   PARM                    SDCURR
     C                   PARM                    SDYLDC
     C                   PARM                    FldNamXAr2
     C                   PARM                    MsgIdXAr2
     C                   PARM                    MsgDtaXAr2
     C                   PARM                    PYrOK
     C                   PARM                    PMnOK
     C                   PARM                    PDyOK
     C                   PARM                    PMatAr
     C                   PARM                    PNMatAr
 
      ** Save previous period date
 
     C                   EVAL      PPrvPDte = PNMatAr(A)
 
      ** Update error info with that produced by this subroutine
 
     C                   EXSR      SRUPDATERRS
 
      ** Update subfile fields error indicator
 
     C                   IF        PYrOK = 'N'
     C                   EVAL      %SUBST(YRATOKFlgs:F:1) = PYrOK
     C                   ENDIF
 
     C                   IF        PMnOK = 'N'
     C                   EVAL      %SUBST(YRATOKFlgs:F+1:1) = PMnOK
     C                   ENDIF
 
     C                   IF        PDyOK = 'N'
     C                   EVAL      %SUBST(YRATOKFlgs:F+2:1) = PDyOK
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRVYRAT - Validate Rate/Discount Factor                       *
      *                                                               *
      * Called By : SRVALINPUT subroutine                             *
      *                                                               *
      * Calls :                                                       *
      * SRRESETERRS - Reset variables updated by validation           *
      * SDVYRAT01   - Validate Rate/Discount Factor                   *
      * SRUPDATERRS - Update error info                               *
      *                                                               *
      *****************************************************************
 
     C     SRVYRAT       BEGSR
 
      ** Reset variables updated by this routine
 
     C                   EXSR      SRRESETERRS
 
      ** Call SDVYRAT01 to validate rate/discount factor
 
     C                   CALLB     'SDVYRAT01'
     C                   PARM                    RetCodeOut
     C                   PARM                    A
     C     PYRteAr(A)    PARM      PYRteAr(A)    PerYRte
     C                   PARM      *ZERO         PerNYRte
     C                   PARM                    PPrvRate
     C                   PARM                    SDYLDC
     C                   PARM                    FldNamXAr2
     C                   PARM                    MsgIdXAr2
     C                   PARM                    MsgDtaXAr2
     C                   PARM      'Y'           PYRteOK
 
      ** Save previous yield rate
 
     C                   EVAL      PPrvRate = PerNYRte
 
      ** Update error info with that produced by this subroutine
 
     C                   EXSR      SRUPDATERRS
 
      ** Update subfile fields error indicator
 
     C                   IF        PYRteOK = 'N'
     C                   EVAL      %SUBST(YRATOKFlgs:F+3:1) = PYRteOK
     C                   ENDIF
 
      ** Update yield rate array
 
     C                   EVAL      PNYRteAr(A) = PerNYRte
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRSETUPVLD - Set Up Valid File                                *
      *                                                               *
      * Called By : SRVALINPUT subroutine                             *
      *                                                               *
      * Calls : None                                                  *
      *                                                               *
      *****************************************************************
 
     C     SRSETUPVLD    BEGSR
 
     C                   EVAL      FSRECI = 'D'
     C                   EVAL      FSYLDC = #0YLDC
     C                   EVAL      FSYCCY = #0YCCY
     C                   EVAL      FSYICM = #0YICM
     C                   EVAL      FSYCFQ = #0YCFQ
      *                                                                                       CRE026
     C                   IF        CAS008 = 'Y'                                               CAS008
     C**********         MOVE      #0SPDY        FSSPDY                                       CAS008
     C                   TESTN                   #0SPDY               89                      CRE026
     C                   IF        *IN89 = *ON                                                CRE026
     C                   MOVE      #0SPDY        WRKPDY                                       CRE026
     C                   Z-ADD     WRKPDY        FSSPDY                                       CRE026
     C                   ELSE                                                                 CRE026
     C                   EVAL      FSSPDY = *zero                                             CRE026
     C                   END                                                                  CRE026
     C                   ELSE                                                                 CAS008
      *                                                                                       CRE026
     C**********         MOVE      *BLANKS       FSSPDY                                CAS008 CRE026
     C                   EVAL      FSSPDY = *zero                                             CRE026
     C                   ENDIF                                                                CAS008
      *                                                                                       CRE026
     C                   EVAL      FSCHTP = #0ACTN
     C                   EVAL      FSLUSI = PSUser
     C                   EVAL      FSLCD = WKRDNB
     C                   TIME                    FSTLUP
 
      ** Call ZDATE2 to convert rundate to date format
 
     C                   CALLB     'ZDATE2'
     C                   PARM      WKRDNB        PDayNo
     C                   PARM      WKDFIN        PDtFmt
     C                   PARM      *ZEROS        PDate
     C                   PARM      *BLANK        PADate
 
      ** Set day of last update
 
     C                   MOVE      PDay          FSDLUP
     C                   MOVE      PMonth        FSMLUP
     C                   MOVE      PYear         FSYLUP
 
      ** Omit blank subfile records
 
     C                   EVAL      PMatArW = *BLANKS
     C                   EVAL      PNMatArW = *ZEROS
     C                   EVAL      PYrArW = *BLANKS
     C                   EVAL      PNYrArW = *ZEROS
     C                   EVAL      PMnArW = *BLANKS
     C                   EVAL      PNMnArW = *ZEROS
     C                   EVAL      PDyArW = *BLANK
     C                   EVAL      PNDyArW = *ZEROS
     C                   EVAL      PYRteArW = *BLANKS
     C                   EVAL      PNYRteArW = *ZEROS
 
     C                   EVAL      A = 1
     C                   EVAL      B = 1
 
     C                   DOW       A < 99
     C                   IF        (PSflRAr(A) <> *BLANK)
     C                   EVAL      PMatArW(B) = PMatAr(A)
     C                   EVAL      PNMatArW(B) = PNMatAr(A)
     C                   EVAL      PYrArW(B) = PYrAr(A)
     C                   EVAL      PNYrArW(B) = PNYrAr(A)
     C                   EVAL      PMnArW(B) = PMnAr(A)
     C                   EVAL      PNMnArW(B) = PNMnAr(A)
     C                   EVAL      PDyArW(B) = PDyAr(A)
     C                   EVAL      PNDyArW(B) = PNDyAr(A)
     C                   EVAL      PYRteArW(B) = PYRteAr(A)
     C                   EVAL      PNYRteArW(B) = PNYRteAr(A)
     C                   EVAL      B = B + 1
     C                   ENDIF
     C                   EVAL      A = A + 1
     C                   ENDDO
 
      ** Move formatted year/month/days and yield rate to screen fields
 
     C                   EVAL      A = 1
     C**********         EVAL      B = 12                                                     CAS008
     C                   EVAL      B = 14                                                     CAS008
 
      ** Period Years
 
     C                   DOW       A < 98
     C                   EVAL      %SUBST(YRATScnFmt:B:2) = PYrArW(A)
     C                   EVAL      A = A + 1
     C                   EVAL      B = B + 20
     C                   ENDDO
 
      ** Period Months
 
     C                   EVAL      A = 1
     C**********         EVAL      B = 14                                                     CAS008
     C                   EVAL      B = 16                                                     CAS008
 
     C                   DOW       A < 98
     C                   EVAL      %SUBST(YRATScnFmt:B:2) = PMnArW(A)
     C                   EVAL      A = A + 1
     C                   EVAL      B = B + 20
     C                   ENDDO
 
      ** Period Days
 
     C                   EVAL      A = 1
     C**********         EVAL      B = 16                                                     CAS008
     C                   EVAL      B = 18                                                     CAS008
 
     C                   DOW       A < 98
     C                   EVAL      %SUBST(YRATScnFmt:B:2) = PDyArW(A)
     C                   EVAL      A = A + 1
     C                   EVAL      B = B + 20
     C                   ENDDO
 
      ** Yield Rates
 
     C                   EVAL      A = 1
     C**********         EVAL      B = 18                                                     CAS008
     C                   EVAL      B = 20                                                     CAS008
 
     C                   DOW       A < 98
     C                   EVAL      %SUBST(YRATScnFmt:B:14) = PYRteArW(A)
     C                   EVAL      A = A + 1
     C                   EVAL      B = B + 20
     C                   ENDDO
 
     C                   MOVEA     PMatArW       PMatAr
     C                   MOVEA     PNMatArW      PNMatAr
     C                   MOVEA     PYrArW        PYrAr
     C                   MOVEA     PNYrArW       PNYrAr
     C                   MOVEA     PMnArW        PMnAr
     C                   MOVEA     PNMnArW       PNMnAr
     C                   MOVEA     PDyArW        PDyAr
     C                   MOVEA     PNDyArW       PNDyAr
     C                   MOVEA     PYRteArW      PYRteAr
     C                   MOVEA     PNYRteArW     PNYRteAr
 
      ** Maturity Date
 
     C                   EVAL      FSMMDN01 = PNMatAr(1)
     C                   EVAL      FSMMDN02 = PNMatAr(2)
     C                   EVAL      FSMMDN03 = PNMatAr(3)
     C                   EVAL      FSMMDN04 = PNMatAr(4)
     C                   EVAL      FSMMDN05 = PNMatAr(5)
     C                   EVAL      FSMMDN06 = PNMatAr(6)
     C                   EVAL      FSMMDN07 = PNMatAr(7)
     C                   EVAL      FSMMDN08 = PNMatAr(8)
     C                   EVAL      FSMMDN09 = PNMatAr(9)
     C                   EVAL      FSMMDN10 = PNMatAr(10)
     C                   EVAL      FSMMDN11 = PNMatAr(11)
     C                   EVAL      FSMMDN12 = PNMatAr(12)
     C                   EVAL      FSMMDN13 = PNMatAr(13)
     C                   EVAL      FSMMDN14 = PNMatAr(14)
     C                   EVAL      FSMMDN15 = PNMatAr(15)
     C                   EVAL      FSMMDN16 = PNMatAr(16)
     C                   EVAL      FSMMDN17 = PNMatAr(17)
     C                   EVAL      FSMMDN18 = PNMatAr(18)
     C                   EVAL      FSMMDN19 = PNMatAr(19)
     C                   EVAL      FSMMDN20 = PNMatAr(20)
     C                   EVAL      FSMMDN21 = PNMatAr(21)
     C                   EVAL      FSMMDN22 = PNMatAr(22)
     C                   EVAL      FSMMDN23 = PNMatAr(23)
     C                   EVAL      FSMMDN24 = PNMatAr(24)
     C                   EVAL      FSMMDN25 = PNMatAr(25)
     C                   EVAL      FSMMDN26 = PNMatAr(26)
     C                   EVAL      FSMMDN27 = PNMatAr(27)
     C                   EVAL      FSMMDN28 = PNMatAr(28)
     C                   EVAL      FSMMDN29 = PNMatAr(29)
     C                   EVAL      FSMMDN30 = PNMatAr(30)
     C                   EVAL      FSMMDN31 = PNMatAr(31)
     C                   EVAL      FSMMDN32 = PNMatAr(32)
     C                   EVAL      FSMMDN33 = PNMatAr(33)
     C                   EVAL      FSMMDN34 = PNMatAr(34)
     C                   EVAL      FSMMDN35 = PNMatAr(35)
     C                   EVAL      FSMMDN36 = PNMatAr(36)
     C                   EVAL      FSMMDN37 = PNMatAr(37)
     C                   EVAL      FSMMDN38 = PNMatAr(38)
     C                   EVAL      FSMMDN39 = PNMatAr(39)
     C                   EVAL      FSMMDN40 = PNMatAr(40)
     C                   EVAL      FSMMDN41 = PNMatAr(41)
     C                   EVAL      FSMMDN42 = PNMatAr(42)
     C                   EVAL      FSMMDN43 = PNMatAr(43)
     C                   EVAL      FSMMDN44 = PNMatAr(44)
     C                   EVAL      FSMMDN45 = PNMatAr(45)
     C                   EVAL      FSMMDN46 = PNMatAr(46)
     C                   EVAL      FSMMDN47 = PNMatAr(47)
     C                   EVAL      FSMMDN48 = PNMatAr(48)
     C                   EVAL      FSMMDN49 = PNMatAr(49)
     C                   EVAL      FSMMDN50 = PNMatAr(50)
     C                   EVAL      FSMMDN51 = PNMatAr(51)
     C                   EVAL      FSMMDN52 = PNMatAr(52)
     C                   EVAL      FSMMDN53 = PNMatAr(53)
     C                   EVAL      FSMMDN54 = PNMatAr(54)
     C                   EVAL      FSMMDN55 = PNMatAr(55)
     C                   EVAL      FSMMDN56 = PNMatAr(56)
     C                   EVAL      FSMMDN57 = PNMatAr(57)
     C                   EVAL      FSMMDN58 = PNMatAr(58)
     C                   EVAL      FSMMDN59 = PNMatAr(59)
     C                   EVAL      FSMMDN60 = PNMatAr(60)
     C                   EVAL      FSMMDN61 = PNMatAr(61)
     C                   EVAL      FSMMDN62 = PNMatAr(62)
     C                   EVAL      FSMMDN63 = PNMatAr(63)
     C                   EVAL      FSMMDN64 = PNMatAr(64)
     C                   EVAL      FSMMDN65 = PNMatAr(65)
     C                   EVAL      FSMMDN66 = PNMatAr(66)
     C                   EVAL      FSMMDN67 = PNMatAr(67)
     C                   EVAL      FSMMDN68 = PNMatAr(68)
     C                   EVAL      FSMMDN69 = PNMatAr(69)
     C                   EVAL      FSMMDN70 = PNMatAr(70)
     C                   EVAL      FSMMDN71 = PNMatAr(71)
     C                   EVAL      FSMMDN72 = PNMatAr(72)
     C                   EVAL      FSMMDN73 = PNMatAr(73)
     C                   EVAL      FSMMDN74 = PNMatAr(74)
     C                   EVAL      FSMMDN75 = PNMatAr(75)
     C                   EVAL      FSMMDN76 = PNMatAr(76)
     C                   EVAL      FSMMDN77 = PNMatAr(77)
     C                   EVAL      FSMMDN78 = PNMatAr(78)
     C                   EVAL      FSMMDN79 = PNMatAr(79)
     C                   EVAL      FSMMDN80 = PNMatAr(80)
     C                   EVAL      FSMMDN81 = PNMatAr(81)
     C                   EVAL      FSMMDN82 = PNMatAr(82)
     C                   EVAL      FSMMDN83 = PNMatAr(83)
     C                   EVAL      FSMMDN84 = PNMatAr(84)
     C                   EVAL      FSMMDN85 = PNMatAr(85)
     C                   EVAL      FSMMDN86 = PNMatAr(86)
     C                   EVAL      FSMMDN87 = PNMatAr(87)
     C                   EVAL      FSMMDN88 = PNMatAr(88)
     C                   EVAL      FSMMDN89 = PNMatAr(89)
     C                   EVAL      FSMMDN90 = PNMatAr(90)
     C                   EVAL      FSMMDN91 = PNMatAr(91)
     C                   EVAL      FSMMDN92 = PNMatAr(92)
     C                   EVAL      FSMMDN93 = PNMatAr(93)
     C                   EVAL      FSMMDN94 = PNMatAr(94)
     C                   EVAL      FSMMDN95 = PNMatAr(95)
     C                   EVAL      FSMMDN96 = PNMatAr(96)
     C                   EVAL      FSMMDN97 = PNMatAr(97)
     C                   EVAL      FSMMDN98 = PNMatAr(98)
 
      ** Period Year
 
     C                   EVAL      FSPDYR01 = PNYrAr(1)
     C                   EVAL      FSPDYR02 = PNYrAr(2)
     C                   EVAL      FSPDYR03 = PNYrAr(3)
     C                   EVAL      FSPDYR04 = PNYrAr(4)
     C                   EVAL      FSPDYR05 = PNYrAr(5)
     C                   EVAL      FSPDYR06 = PNYrAr(6)
     C                   EVAL      FSPDYR07 = PNYrAr(7)
     C                   EVAL      FSPDYR08 = PNYrAr(8)
     C                   EVAL      FSPDYR09 = PNYrAr(9)
     C                   EVAL      FSPDYR10 = PNYrAr(10)
     C                   EVAL      FSPDYR11 = PNYrAr(11)
     C                   EVAL      FSPDYR12 = PNYrAr(12)
     C                   EVAL      FSPDYR13 = PNYrAr(13)
     C                   EVAL      FSPDYR14 = PNYrAr(14)
     C                   EVAL      FSPDYR15 = PNYrAr(15)
     C                   EVAL      FSPDYR16 = PNYrAr(16)
     C                   EVAL      FSPDYR17 = PNYrAr(17)
     C                   EVAL      FSPDYR18 = PNYrAr(18)
     C                   EVAL      FSPDYR19 = PNYrAr(19)
     C                   EVAL      FSPDYR20 = PNYrAr(20)
     C                   EVAL      FSPDYR21 = PNYrAr(21)
     C                   EVAL      FSPDYR22 = PNYrAr(22)
     C                   EVAL      FSPDYR23 = PNYrAr(23)
     C                   EVAL      FSPDYR24 = PNYrAr(24)
     C                   EVAL      FSPDYR25 = PNYrAr(25)
     C                   EVAL      FSPDYR26 = PNYrAr(26)
     C                   EVAL      FSPDYR27 = PNYrAr(27)
     C                   EVAL      FSPDYR28 = PNYrAr(28)
     C                   EVAL      FSPDYR29 = PNYrAr(29)
     C                   EVAL      FSPDYR30 = PNYrAr(30)
     C                   EVAL      FSPDYR31 = PNYrAr(31)
     C                   EVAL      FSPDYR32 = PNYrAr(32)
     C                   EVAL      FSPDYR33 = PNYrAr(33)
     C                   EVAL      FSPDYR34 = PNYrAr(34)
     C                   EVAL      FSPDYR35 = PNYrAr(35)
     C                   EVAL      FSPDYR36 = PNYrAr(36)
     C                   EVAL      FSPDYR37 = PNYrAr(37)
     C                   EVAL      FSPDYR38 = PNYrAr(38)
     C                   EVAL      FSPDYR39 = PNYrAr(39)
     C                   EVAL      FSPDYR40 = PNYrAr(40)
     C                   EVAL      FSPDYR41 = PNYrAr(41)
     C                   EVAL      FSPDYR42 = PNYrAr(42)
     C                   EVAL      FSPDYR43 = PNYrAr(43)
     C                   EVAL      FSPDYR44 = PNYrAr(44)
     C                   EVAL      FSPDYR45 = PNYrAr(45)
     C                   EVAL      FSPDYR46 = PNYrAr(46)
     C                   EVAL      FSPDYR47 = PNYrAr(47)
     C                   EVAL      FSPDYR48 = PNYrAr(48)
     C                   EVAL      FSPDYR49 = PNYrAr(49)
     C                   EVAL      FSPDYR50 = PNYrAr(50)
     C                   EVAL      FSPDYR51 = PNYrAr(51)
     C                   EVAL      FSPDYR52 = PNYrAr(52)
     C                   EVAL      FSPDYR53 = PNYrAr(53)
     C                   EVAL      FSPDYR54 = PNYrAr(54)
     C                   EVAL      FSPDYR55 = PNYrAr(55)
     C                   EVAL      FSPDYR56 = PNYrAr(56)
     C                   EVAL      FSPDYR57 = PNYrAr(57)
     C                   EVAL      FSPDYR58 = PNYrAr(58)
     C                   EVAL      FSPDYR59 = PNYrAr(59)
     C                   EVAL      FSPDYR60 = PNYrAr(60)
     C                   EVAL      FSPDYR61 = PNYrAr(61)
     C                   EVAL      FSPDYR62 = PNYrAr(62)
     C                   EVAL      FSPDYR63 = PNYrAr(63)
     C                   EVAL      FSPDYR64 = PNYrAr(64)
     C                   EVAL      FSPDYR65 = PNYrAr(65)
     C                   EVAL      FSPDYR66 = PNYrAr(66)
     C                   EVAL      FSPDYR67 = PNYrAr(67)
     C                   EVAL      FSPDYR68 = PNYrAr(68)
     C                   EVAL      FSPDYR69 = PNYrAr(69)
     C                   EVAL      FSPDYR70 = PNYrAr(70)
     C                   EVAL      FSPDYR71 = PNYrAr(71)
     C                   EVAL      FSPDYR72 = PNYrAr(72)
     C                   EVAL      FSPDYR73 = PNYrAr(73)
     C                   EVAL      FSPDYR74 = PNYrAr(74)
     C                   EVAL      FSPDYR75 = PNYrAr(75)
     C                   EVAL      FSPDYR76 = PNYrAr(76)
     C                   EVAL      FSPDYR77 = PNYrAr(77)
     C                   EVAL      FSPDYR78 = PNYrAr(78)
     C                   EVAL      FSPDYR79 = PNYrAr(79)
     C                   EVAL      FSPDYR80 = PNYrAr(80)
     C                   EVAL      FSPDYR81 = PNYrAr(81)
     C                   EVAL      FSPDYR82 = PNYrAr(82)
     C                   EVAL      FSPDYR83 = PNYrAr(83)
     C                   EVAL      FSPDYR84 = PNYrAr(84)
     C                   EVAL      FSPDYR85 = PNYrAr(85)
     C                   EVAL      FSPDYR86 = PNYrAr(86)
     C                   EVAL      FSPDYR87 = PNYrAr(87)
     C                   EVAL      FSPDYR88 = PNYrAr(88)
     C                   EVAL      FSPDYR89 = PNYrAr(89)
     C                   EVAL      FSPDYR90 = PNYrAr(90)
     C                   EVAL      FSPDYR91 = PNYrAr(91)
     C                   EVAL      FSPDYR92 = PNYrAr(92)
     C                   EVAL      FSPDYR93 = PNYrAr(93)
     C                   EVAL      FSPDYR94 = PNYrAr(94)
     C                   EVAL      FSPDYR95 = PNYrAr(95)
     C                   EVAL      FSPDYR96 = PNYrAr(96)
     C                   EVAL      FSPDYR97 = PNYrAr(97)
     C                   EVAL      FSPDYR98 = PNYrAr(98)
 
      ** Period Month
 
     C                   EVAL      FSPDMN01 = PNMnAr(1)
     C                   EVAL      FSPDMN02 = PNMnAr(2)
     C                   EVAL      FSPDMN03 = PNMnAr(3)
     C                   EVAL      FSPDMN04 = PNMnAr(4)
     C                   EVAL      FSPDMN05 = PNMnAr(5)
     C                   EVAL      FSPDMN06 = PNMnAr(6)
     C                   EVAL      FSPDMN07 = PNMnAr(7)
     C                   EVAL      FSPDMN08 = PNMnAr(8)
     C                   EVAL      FSPDMN09 = PNMnAr(9)
     C                   EVAL      FSPDMN10 = PNMnAr(10)
     C                   EVAL      FSPDMN11 = PNMnAr(11)
     C                   EVAL      FSPDMN12 = PNMnAr(12)
     C                   EVAL      FSPDMN13 = PNMnAr(13)
     C                   EVAL      FSPDMN14 = PNMnAr(14)
     C                   EVAL      FSPDMN15 = PNMnAr(15)
     C                   EVAL      FSPDMN16 = PNMnAr(16)
     C                   EVAL      FSPDMN17 = PNMnAr(17)
     C                   EVAL      FSPDMN18 = PNMnAr(18)
     C                   EVAL      FSPDMN19 = PNMnAr(19)
     C                   EVAL      FSPDMN20 = PNMnAr(20)
     C                   EVAL      FSPDMN21 = PNMnAr(21)
     C                   EVAL      FSPDMN22 = PNMnAr(22)
     C                   EVAL      FSPDMN23 = PNMnAr(23)
     C                   EVAL      FSPDMN24 = PNMnAr(24)
     C                   EVAL      FSPDMN25 = PNMnAr(25)
     C                   EVAL      FSPDMN26 = PNMnAr(26)
     C                   EVAL      FSPDMN27 = PNMnAr(27)
     C                   EVAL      FSPDMN28 = PNMnAr(28)
     C                   EVAL      FSPDMN29 = PNMnAr(29)
     C                   EVAL      FSPDMN30 = PNMnAr(30)
     C                   EVAL      FSPDMN31 = PNMnAr(31)
     C                   EVAL      FSPDMN32 = PNMnAr(32)
     C                   EVAL      FSPDMN33 = PNMnAr(33)
     C                   EVAL      FSPDMN34 = PNMnAr(34)
     C                   EVAL      FSPDMN35 = PNMnAr(35)
     C                   EVAL      FSPDMN36 = PNMnAr(36)
     C                   EVAL      FSPDMN37 = PNMnAr(37)
     C                   EVAL      FSPDMN38 = PNMnAr(38)
     C                   EVAL      FSPDMN39 = PNMnAr(39)
     C                   EVAL      FSPDMN40 = PNMnAr(40)
     C                   EVAL      FSPDMN41 = PNMnAr(41)
     C                   EVAL      FSPDMN42 = PNMnAr(42)
     C                   EVAL      FSPDMN43 = PNMnAr(43)
     C                   EVAL      FSPDMN44 = PNMnAr(44)
     C                   EVAL      FSPDMN45 = PNMnAr(45)
     C                   EVAL      FSPDMN46 = PNMnAr(46)
     C                   EVAL      FSPDMN47 = PNMnAr(47)
     C                   EVAL      FSPDMN48 = PNMnAr(48)
     C                   EVAL      FSPDMN49 = PNMnAr(49)
     C                   EVAL      FSPDMN50 = PNMnAr(50)
     C                   EVAL      FSPDMN51 = PNMnAr(51)
     C                   EVAL      FSPDMN52 = PNMnAr(52)
     C                   EVAL      FSPDMN53 = PNMnAr(53)
     C                   EVAL      FSPDMN54 = PNMnAr(54)
     C                   EVAL      FSPDMN55 = PNMnAr(55)
     C                   EVAL      FSPDMN56 = PNMnAr(56)
     C                   EVAL      FSPDMN57 = PNMnAr(57)
     C                   EVAL      FSPDMN58 = PNMnAr(58)
     C                   EVAL      FSPDMN59 = PNMnAr(59)
     C                   EVAL      FSPDMN60 = PNMnAr(60)
     C                   EVAL      FSPDMN61 = PNMnAr(61)
     C                   EVAL      FSPDMN62 = PNMnAr(62)
     C                   EVAL      FSPDMN63 = PNMnAr(63)
     C                   EVAL      FSPDMN64 = PNMnAr(64)
     C                   EVAL      FSPDMN65 = PNMnAr(65)
     C                   EVAL      FSPDMN66 = PNMnAr(66)
     C                   EVAL      FSPDMN67 = PNMnAr(67)
     C                   EVAL      FSPDMN68 = PNMnAr(68)
     C                   EVAL      FSPDMN69 = PNMnAr(69)
     C                   EVAL      FSPDMN70 = PNMnAr(70)
     C                   EVAL      FSPDMN71 = PNMnAr(71)
     C                   EVAL      FSPDMN72 = PNMnAr(72)
     C                   EVAL      FSPDMN73 = PNMnAr(73)
     C                   EVAL      FSPDMN74 = PNMnAr(74)
     C                   EVAL      FSPDMN75 = PNMnAr(75)
     C                   EVAL      FSPDMN76 = PNMnAr(76)
     C                   EVAL      FSPDMN77 = PNMnAr(77)
     C                   EVAL      FSPDMN78 = PNMnAr(78)
     C                   EVAL      FSPDMN79 = PNMnAr(79)
     C                   EVAL      FSPDMN80 = PNMnAr(80)
     C                   EVAL      FSPDMN81 = PNMnAr(81)
     C                   EVAL      FSPDMN82 = PNMnAr(82)
     C                   EVAL      FSPDMN83 = PNMnAr(83)
     C                   EVAL      FSPDMN84 = PNMnAr(84)
     C                   EVAL      FSPDMN85 = PNMnAr(85)
     C                   EVAL      FSPDMN86 = PNMnAr(86)
     C                   EVAL      FSPDMN87 = PNMnAr(87)
     C                   EVAL      FSPDMN88 = PNMnAr(88)
     C                   EVAL      FSPDMN89 = PNMnAr(89)
     C                   EVAL      FSPDMN90 = PNMnAr(90)
     C                   EVAL      FSPDMN91 = PNMnAr(91)
     C                   EVAL      FSPDMN92 = PNMnAr(92)
     C                   EVAL      FSPDMN93 = PNMnAr(93)
     C                   EVAL      FSPDMN94 = PNMnAr(94)
     C                   EVAL      FSPDMN95 = PNMnAr(95)
     C                   EVAL      FSPDMN96 = PNMnAr(96)
     C                   EVAL      FSPDMN97 = PNMnAr(97)
     C                   EVAL      FSPDMN98 = PNMnAr(98)
 
      ** Period Days
 
     C                   EVAL      FSPDDY01 = PNDyAr(1)
     C                   EVAL      FSPDDY02 = PNDyAr(2)
     C                   EVAL      FSPDDY03 = PNDyAr(3)
     C                   EVAL      FSPDDY04 = PNDyAr(4)
     C                   EVAL      FSPDDY05 = PNDyAr(5)
     C                   EVAL      FSPDDY06 = PNDyAr(6)
     C                   EVAL      FSPDDY07 = PNDyAr(7)
     C                   EVAL      FSPDDY08 = PNDyAr(8)
     C                   EVAL      FSPDDY09 = PNDyAr(9)
     C                   EVAL      FSPDDY10 = PNDyAr(10)
     C                   EVAL      FSPDDY11 = PNDyAr(11)
     C                   EVAL      FSPDDY12 = PNDyAr(12)
     C                   EVAL      FSPDDY13 = PNDyAr(13)
     C                   EVAL      FSPDDY14 = PNDyAr(14)
     C                   EVAL      FSPDDY15 = PNDyAr(15)
     C                   EVAL      FSPDDY16 = PNDyAr(16)
     C                   EVAL      FSPDDY17 = PNDyAr(17)
     C                   EVAL      FSPDDY18 = PNDyAr(18)
     C                   EVAL      FSPDDY19 = PNDyAr(19)
     C                   EVAL      FSPDDY20 = PNDyAr(20)
     C                   EVAL      FSPDDY21 = PNDyAr(21)
     C                   EVAL      FSPDDY22 = PNDyAr(22)
     C                   EVAL      FSPDDY23 = PNDyAr(23)
     C                   EVAL      FSPDDY24 = PNDyAr(24)
     C                   EVAL      FSPDDY25 = PNDyAr(25)
     C                   EVAL      FSPDDY26 = PNDyAr(26)
     C                   EVAL      FSPDDY27 = PNDyAr(27)
     C                   EVAL      FSPDDY28 = PNDyAr(28)
     C                   EVAL      FSPDDY29 = PNDyAr(29)
     C                   EVAL      FSPDDY30 = PNDyAr(30)
     C                   EVAL      FSPDDY31 = PNDyAr(31)
     C                   EVAL      FSPDDY32 = PNDyAr(32)
     C                   EVAL      FSPDDY33 = PNDyAr(33)
     C                   EVAL      FSPDDY34 = PNDyAr(34)
     C                   EVAL      FSPDDY35 = PNDyAr(35)
     C                   EVAL      FSPDDY36 = PNDyAr(36)
     C                   EVAL      FSPDDY37 = PNDyAr(37)
     C                   EVAL      FSPDDY38 = PNDyAr(38)
     C                   EVAL      FSPDDY39 = PNDyAr(39)
     C                   EVAL      FSPDDY40 = PNDyAr(40)
     C                   EVAL      FSPDDY41 = PNDyAr(41)
     C                   EVAL      FSPDDY42 = PNDyAr(42)
     C                   EVAL      FSPDDY43 = PNDyAr(43)
     C                   EVAL      FSPDDY44 = PNDyAr(44)
     C                   EVAL      FSPDDY45 = PNDyAr(45)
     C                   EVAL      FSPDDY46 = PNDyAr(46)
     C                   EVAL      FSPDDY47 = PNDyAr(47)
     C                   EVAL      FSPDDY48 = PNDyAr(48)
     C                   EVAL      FSPDDY49 = PNDyAr(49)
     C                   EVAL      FSPDDY50 = PNDyAr(50)
     C                   EVAL      FSPDDY51 = PNDyAr(51)
     C                   EVAL      FSPDDY52 = PNDyAr(52)
     C                   EVAL      FSPDDY53 = PNDyAr(53)
     C                   EVAL      FSPDDY54 = PNDyAr(54)
     C                   EVAL      FSPDDY55 = PNDyAr(55)
     C                   EVAL      FSPDDY56 = PNDyAr(56)
     C                   EVAL      FSPDDY57 = PNDyAr(57)
     C                   EVAL      FSPDDY58 = PNDyAr(58)
     C                   EVAL      FSPDDY59 = PNDyAr(59)
     C                   EVAL      FSPDDY60 = PNDyAr(60)
     C                   EVAL      FSPDDY61 = PNDyAr(61)
     C                   EVAL      FSPDDY62 = PNDyAr(62)
     C                   EVAL      FSPDDY63 = PNDyAr(63)
     C                   EVAL      FSPDDY64 = PNDyAr(64)
     C                   EVAL      FSPDDY65 = PNDyAr(65)
     C                   EVAL      FSPDDY66 = PNDyAr(66)
     C                   EVAL      FSPDDY67 = PNDyAr(67)
     C                   EVAL      FSPDDY68 = PNDyAr(68)
     C                   EVAL      FSPDDY69 = PNDyAr(69)
     C                   EVAL      FSPDDY70 = PNDyAr(70)
     C                   EVAL      FSPDDY71 = PNDyAr(71)
     C                   EVAL      FSPDDY72 = PNDyAr(72)
     C                   EVAL      FSPDDY73 = PNDyAr(73)
     C                   EVAL      FSPDDY74 = PNDyAr(74)
     C                   EVAL      FSPDDY75 = PNDyAr(75)
     C                   EVAL      FSPDDY76 = PNDyAr(76)
     C                   EVAL      FSPDDY77 = PNDyAr(77)
     C                   EVAL      FSPDDY78 = PNDyAr(78)
     C                   EVAL      FSPDDY79 = PNDyAr(79)
     C                   EVAL      FSPDDY80 = PNDyAr(80)
     C                   EVAL      FSPDDY81 = PNDyAr(81)
     C                   EVAL      FSPDDY82 = PNDyAr(82)
     C                   EVAL      FSPDDY83 = PNDyAr(83)
     C                   EVAL      FSPDDY84 = PNDyAr(84)
     C                   EVAL      FSPDDY85 = PNDyAr(85)
     C                   EVAL      FSPDDY86 = PNDyAr(86)
     C                   EVAL      FSPDDY87 = PNDyAr(87)
     C                   EVAL      FSPDDY88 = PNDyAr(88)
     C                   EVAL      FSPDDY89 = PNDyAr(89)
     C                   EVAL      FSPDDY90 = PNDyAr(90)
     C                   EVAL      FSPDDY91 = PNDyAr(91)
     C                   EVAL      FSPDDY92 = PNDyAr(92)
     C                   EVAL      FSPDDY93 = PNDyAr(93)
     C                   EVAL      FSPDDY94 = PNDyAr(94)
     C                   EVAL      FSPDDY95 = PNDyAr(95)
     C                   EVAL      FSPDDY96 = PNDyAr(96)
     C                   EVAL      FSPDDY97 = PNDyAr(97)
     C                   EVAL      FSPDDY98 = PNDyAr(98)
 
      ** Yield Rates
 
     C                   IF        PFSYLDT = 'Z'
     C                             OR PFSYLDT = 'S'                                           228390
     C                   EVAL      FSYRAT01 = PNYRteAr(1)
     C                   EVAL      FSYRAT02 = PNYRteAr(2)
     C                   EVAL      FSYRAT03 = PNYRteAr(3)
     C                   EVAL      FSYRAT04 = PNYRteAr(4)
     C                   EVAL      FSYRAT05 = PNYRteAr(5)
     C                   EVAL      FSYRAT06 = PNYRteAr(6)
     C                   EVAL      FSYRAT07 = PNYRteAr(7)
     C                   EVAL      FSYRAT08 = PNYRteAr(8)
     C                   EVAL      FSYRAT09 = PNYRteAr(9)
     C                   EVAL      FSYRAT10 = PNYRteAr(10)
     C                   EVAL      FSYRAT11 = PNYRteAr(11)
     C                   EVAL      FSYRAT12 = PNYRteAr(12)
     C                   EVAL      FSYRAT13 = PNYRteAr(13)
     C                   EVAL      FSYRAT14 = PNYRteAr(14)
     C                   EVAL      FSYRAT15 = PNYRteAr(15)
     C                   EVAL      FSYRAT16 = PNYRteAr(16)
     C                   EVAL      FSYRAT17 = PNYRteAr(17)
     C                   EVAL      FSYRAT18 = PNYRteAr(18)
     C                   EVAL      FSYRAT19 = PNYRteAr(19)
     C                   EVAL      FSYRAT20 = PNYRteAr(20)
     C                   EVAL      FSYRAT21 = PNYRteAr(21)
     C                   EVAL      FSYRAT22 = PNYRteAr(22)
     C                   EVAL      FSYRAT23 = PNYRteAr(23)
     C                   EVAL      FSYRAT24 = PNYRteAr(24)
     C                   EVAL      FSYRAT25 = PNYRteAr(25)
     C                   EVAL      FSYRAT26 = PNYRteAr(26)
     C                   EVAL      FSYRAT27 = PNYRteAr(27)
     C                   EVAL      FSYRAT28 = PNYRteAr(28)
     C                   EVAL      FSYRAT29 = PNYRteAr(29)
     C                   EVAL      FSYRAT30 = PNYRteAr(30)
     C                   EVAL      FSYRAT31 = PNYRteAr(31)
     C                   EVAL      FSYRAT32 = PNYRteAr(32)
     C                   EVAL      FSYRAT33 = PNYRteAr(33)
     C                   EVAL      FSYRAT34 = PNYRteAr(34)
     C                   EVAL      FSYRAT35 = PNYRteAr(35)
     C                   EVAL      FSYRAT36 = PNYRteAr(36)
     C                   EVAL      FSYRAT37 = PNYRteAr(37)
     C                   EVAL      FSYRAT38 = PNYRteAr(38)
     C                   EVAL      FSYRAT39 = PNYRteAr(39)
     C                   EVAL      FSYRAT40 = PNYRteAr(40)
     C                   EVAL      FSYRAT41 = PNYRteAr(41)
     C                   EVAL      FSYRAT42 = PNYRteAr(42)
     C                   EVAL      FSYRAT43 = PNYRteAr(43)
     C                   EVAL      FSYRAT44 = PNYRteAr(44)
     C                   EVAL      FSYRAT45 = PNYRteAr(45)
     C                   EVAL      FSYRAT46 = PNYRteAr(46)
     C                   EVAL      FSYRAT47 = PNYRteAr(47)
     C                   EVAL      FSYRAT48 = PNYRteAr(48)
     C                   EVAL      FSYRAT49 = PNYRteAr(49)
     C                   EVAL      FSYRAT50 = PNYRteAr(50)
     C                   EVAL      FSYRAT51 = PNYRteAr(51)
     C                   EVAL      FSYRAT52 = PNYRteAr(52)
     C                   EVAL      FSYRAT53 = PNYRteAr(53)
     C                   EVAL      FSYRAT54 = PNYRteAr(54)
     C                   EVAL      FSYRAT55 = PNYRteAr(55)
     C                   EVAL      FSYRAT56 = PNYRteAr(56)
     C                   EVAL      FSYRAT57 = PNYRteAr(57)
     C                   EVAL      FSYRAT58 = PNYRteAr(58)
     C                   EVAL      FSYRAT59 = PNYRteAr(59)
     C                   EVAL      FSYRAT60 = PNYRteAr(60)
     C                   EVAL      FSYRAT61 = PNYRteAr(61)
     C                   EVAL      FSYRAT62 = PNYRteAr(62)
     C                   EVAL      FSYRAT63 = PNYRteAr(63)
     C                   EVAL      FSYRAT64 = PNYRteAr(64)
     C                   EVAL      FSYRAT65 = PNYRteAr(65)
     C                   EVAL      FSYRAT66 = PNYRteAr(66)
     C                   EVAL      FSYRAT67 = PNYRteAr(67)
     C                   EVAL      FSYRAT68 = PNYRteAr(68)
     C                   EVAL      FSYRAT69 = PNYRteAr(69)
     C                   EVAL      FSYRAT70 = PNYRteAr(70)
     C                   EVAL      FSYRAT71 = PNYRteAr(71)
     C                   EVAL      FSYRAT72 = PNYRteAr(72)
     C                   EVAL      FSYRAT73 = PNYRteAr(73)
     C                   EVAL      FSYRAT74 = PNYRteAr(74)
     C                   EVAL      FSYRAT75 = PNYRteAr(75)
     C                   EVAL      FSYRAT76 = PNYRteAr(76)
     C                   EVAL      FSYRAT77 = PNYRteAr(77)
     C                   EVAL      FSYRAT78 = PNYRteAr(78)
     C                   EVAL      FSYRAT79 = PNYRteAr(79)
     C                   EVAL      FSYRAT80 = PNYRteAr(80)
     C                   EVAL      FSYRAT81 = PNYRteAr(81)
     C                   EVAL      FSYRAT82 = PNYRteAr(82)
     C                   EVAL      FSYRAT83 = PNYRteAr(83)
     C                   EVAL      FSYRAT84 = PNYRteAr(84)
     C                   EVAL      FSYRAT85 = PNYRteAr(85)
     C                   EVAL      FSYRAT86 = PNYRteAr(86)
     C                   EVAL      FSYRAT87 = PNYRteAr(87)
     C                   EVAL      FSYRAT88 = PNYRteAr(88)
     C                   EVAL      FSYRAT89 = PNYRteAr(89)
     C                   EVAL      FSYRAT90 = PNYRteAr(90)
     C                   EVAL      FSYRAT91 = PNYRteAr(91)
     C                   EVAL      FSYRAT92 = PNYRteAr(92)
     C                   EVAL      FSYRAT93 = PNYRteAr(93)
     C                   EVAL      FSYRAT94 = PNYRteAr(94)
     C                   EVAL      FSYRAT95 = PNYRteAr(95)
     C                   EVAL      FSYRAT96 = PNYRteAr(96)
     C                   EVAL      FSYRAT97 = PNYRteAr(97)
     C                   EVAL      FSYRAT98 = PNYRteAr(98)
     C                   EVAL      FSDSCF01 = *ZERO
     C                   EVAL      FSDSCF02 = *ZERO
     C                   EVAL      FSDSCF03 = *ZERO
     C                   EVAL      FSDSCF04 = *ZERO
     C                   EVAL      FSDSCF05 = *ZERO
     C                   EVAL      FSDSCF06 = *ZERO
     C                   EVAL      FSDSCF07 = *ZERO
     C                   EVAL      FSDSCF08 = *ZERO
     C                   EVAL      FSDSCF09 = *ZERO
     C                   EVAL      FSDSCF10 = *ZERO
     C                   EVAL      FSDSCF11 = *ZERO
     C                   EVAL      FSDSCF12 = *ZERO
     C                   EVAL      FSDSCF13 = *ZERO
     C                   EVAL      FSDSCF14 = *ZERO
     C                   EVAL      FSDSCF15 = *ZERO
     C                   EVAL      FSDSCF16 = *ZERO
     C                   EVAL      FSDSCF17 = *ZERO
     C                   EVAL      FSDSCF18 = *ZERO
     C                   EVAL      FSDSCF19 = *ZERO
     C                   EVAL      FSDSCF20 = *ZERO
     C                   EVAL      FSDSCF21 = *ZERO
     C                   EVAL      FSDSCF22 = *ZERO
     C                   EVAL      FSDSCF23 = *ZERO
     C                   EVAL      FSDSCF24 = *ZERO
     C                   EVAL      FSDSCF25 = *ZERO
     C                   EVAL      FSDSCF26 = *ZERO
     C                   EVAL      FSDSCF27 = *ZERO
     C                   EVAL      FSDSCF28 = *ZERO
     C                   EVAL      FSDSCF29 = *ZERO
     C                   EVAL      FSDSCF30 = *ZERO
     C                   EVAL      FSDSCF31 = *ZERO
     C                   EVAL      FSDSCF32 = *ZERO
     C                   EVAL      FSDSCF33 = *ZERO
     C                   EVAL      FSDSCF34 = *ZERO
     C                   EVAL      FSDSCF35 = *ZERO
     C                   EVAL      FSDSCF36 = *ZERO
     C                   EVAL      FSDSCF37 = *ZERO
     C                   EVAL      FSDSCF38 = *ZERO
     C                   EVAL      FSDSCF39 = *ZERO
     C                   EVAL      FSDSCF40 = *ZERO
     C                   EVAL      FSDSCF41 = *ZERO
     C                   EVAL      FSDSCF42 = *ZERO
     C                   EVAL      FSDSCF43 = *ZERO
     C                   EVAL      FSDSCF44 = *ZERO
     C                   EVAL      FSDSCF45 = *ZERO
     C                   EVAL      FSDSCF46 = *ZERO
     C                   EVAL      FSDSCF47 = *ZERO
     C                   EVAL      FSDSCF48 = *ZERO
     C                   EVAL      FSDSCF49 = *ZERO
     C                   EVAL      FSDSCF50 = *ZERO
     C                   EVAL      FSDSCF51 = *ZERO
     C                   EVAL      FSDSCF52 = *ZERO
     C                   EVAL      FSDSCF53 = *ZERO
     C                   EVAL      FSDSCF54 = *ZERO
     C                   EVAL      FSDSCF55 = *ZERO
     C                   EVAL      FSDSCF56 = *ZERO
     C                   EVAL      FSDSCF57 = *ZERO
     C                   EVAL      FSDSCF58 = *ZERO
     C                   EVAL      FSDSCF59 = *ZERO
     C                   EVAL      FSDSCF60 = *ZERO
     C                   EVAL      FSDSCF61 = *ZERO
     C                   EVAL      FSDSCF62 = *ZERO
     C                   EVAL      FSDSCF63 = *ZERO
     C                   EVAL      FSDSCF64 = *ZERO
     C                   EVAL      FSDSCF65 = *ZERO
     C                   EVAL      FSDSCF66 = *ZERO
     C                   EVAL      FSDSCF67 = *ZERO
     C                   EVAL      FSDSCF68 = *ZERO
     C                   EVAL      FSDSCF69 = *ZERO
     C                   EVAL      FSDSCF70 = *ZERO
     C                   EVAL      FSDSCF71 = *ZERO
     C                   EVAL      FSDSCF72 = *ZERO
     C                   EVAL      FSDSCF73 = *ZERO
     C                   EVAL      FSDSCF74 = *ZERO
     C                   EVAL      FSDSCF75 = *ZERO
     C                   EVAL      FSDSCF76 = *ZERO
     C                   EVAL      FSDSCF77 = *ZERO
     C                   EVAL      FSDSCF78 = *ZERO
     C                   EVAL      FSDSCF79 = *ZERO
     C                   EVAL      FSDSCF80 = *ZERO
     C                   EVAL      FSDSCF81 = *ZERO
     C                   EVAL      FSDSCF82 = *ZERO
     C                   EVAL      FSDSCF83 = *ZERO
     C                   EVAL      FSDSCF84 = *ZERO
     C                   EVAL      FSDSCF85 = *ZERO
     C                   EVAL      FSDSCF86 = *ZERO
     C                   EVAL      FSDSCF87 = *ZERO
     C                   EVAL      FSDSCF88 = *ZERO
     C                   EVAL      FSDSCF89 = *ZERO
     C                   EVAL      FSDSCF90 = *ZERO
     C                   EVAL      FSDSCF91 = *ZERO
     C                   EVAL      FSDSCF92 = *ZERO
     C                   EVAL      FSDSCF93 = *ZERO
     C                   EVAL      FSDSCF94 = *ZERO
     C                   EVAL      FSDSCF95 = *ZERO
     C                   EVAL      FSDSCF96 = *ZERO
     C                   EVAL      FSDSCF97 = *ZERO
     C                   EVAL      FSDSCF98 = *ZERO
     C                   ENDIF
 
      ** Discount Factor
 
     C                   IF        PFSYLDT = 'D'
     C                   EVAL      FSDSCF01 = PNYRteAr(1)
     C                   EVAL      FSDSCF02 = PNYRteAr(2)
     C                   EVAL      FSDSCF03 = PNYRteAr(3)
     C                   EVAL      FSDSCF04 = PNYRteAr(4)
     C                   EVAL      FSDSCF05 = PNYRteAr(5)
     C                   EVAL      FSDSCF06 = PNYRteAr(6)
     C                   EVAL      FSDSCF07 = PNYRteAr(7)
     C                   EVAL      FSDSCF08 = PNYRteAr(8)
     C                   EVAL      FSDSCF09 = PNYRteAr(9)
     C                   EVAL      FSDSCF10 = PNYRteAr(10)
     C                   EVAL      FSDSCF11 = PNYRteAr(11)
     C                   EVAL      FSDSCF12 = PNYRteAr(12)
     C                   EVAL      FSDSCF13 = PNYRteAr(13)
     C                   EVAL      FSDSCF14 = PNYRteAr(14)
     C                   EVAL      FSDSCF15 = PNYRteAr(15)
     C                   EVAL      FSDSCF16 = PNYRteAr(16)
     C                   EVAL      FSDSCF17 = PNYRteAr(17)
     C                   EVAL      FSDSCF18 = PNYRteAr(18)
     C                   EVAL      FSDSCF19 = PNYRteAr(19)
     C                   EVAL      FSDSCF20 = PNYRteAr(20)
     C                   EVAL      FSDSCF21 = PNYRteAr(21)
     C                   EVAL      FSDSCF22 = PNYRteAr(22)
     C                   EVAL      FSDSCF23 = PNYRteAr(23)
     C                   EVAL      FSDSCF24 = PNYRteAr(24)
     C                   EVAL      FSDSCF25 = PNYRteAr(25)
     C                   EVAL      FSDSCF26 = PNYRteAr(26)
     C                   EVAL      FSDSCF27 = PNYRteAr(27)
     C                   EVAL      FSDSCF28 = PNYRteAr(28)
     C                   EVAL      FSDSCF29 = PNYRteAr(29)
     C                   EVAL      FSDSCF30 = PNYRteAr(30)
     C                   EVAL      FSDSCF31 = PNYRteAr(31)
     C                   EVAL      FSDSCF32 = PNYRteAr(32)
     C                   EVAL      FSDSCF33 = PNYRteAr(33)
     C                   EVAL      FSDSCF34 = PNYRteAr(34)
     C                   EVAL      FSDSCF35 = PNYRteAr(35)
     C                   EVAL      FSDSCF36 = PNYRteAr(36)
     C                   EVAL      FSDSCF37 = PNYRteAr(37)
     C                   EVAL      FSDSCF38 = PNYRteAr(38)
     C                   EVAL      FSDSCF39 = PNYRteAr(39)
     C                   EVAL      FSDSCF40 = PNYRteAr(40)
     C                   EVAL      FSDSCF41 = PNYRteAr(41)
     C                   EVAL      FSDSCF42 = PNYRteAr(42)
     C                   EVAL      FSDSCF43 = PNYRteAr(43)
     C                   EVAL      FSDSCF44 = PNYRteAr(44)
     C                   EVAL      FSDSCF45 = PNYRteAr(45)
     C                   EVAL      FSDSCF46 = PNYRteAr(46)
     C                   EVAL      FSDSCF47 = PNYRteAr(47)
     C                   EVAL      FSDSCF48 = PNYRteAr(48)
     C                   EVAL      FSDSCF49 = PNYRteAr(49)
     C                   EVAL      FSDSCF50 = PNYRteAr(50)
     C                   EVAL      FSDSCF51 = PNYRteAr(51)
     C                   EVAL      FSDSCF52 = PNYRteAr(52)
     C                   EVAL      FSDSCF53 = PNYRteAr(53)
     C                   EVAL      FSDSCF54 = PNYRteAr(54)
     C                   EVAL      FSDSCF55 = PNYRteAr(55)
     C                   EVAL      FSDSCF56 = PNYRteAr(56)
     C                   EVAL      FSDSCF57 = PNYRteAr(57)
     C                   EVAL      FSDSCF58 = PNYRteAr(58)
     C                   EVAL      FSDSCF59 = PNYRteAr(59)
     C                   EVAL      FSDSCF60 = PNYRteAr(60)
     C                   EVAL      FSDSCF61 = PNYRteAr(61)
     C                   EVAL      FSDSCF62 = PNYRteAr(62)
     C                   EVAL      FSDSCF63 = PNYRteAr(63)
     C                   EVAL      FSDSCF64 = PNYRteAr(64)
     C                   EVAL      FSDSCF65 = PNYRteAr(65)
     C                   EVAL      FSDSCF66 = PNYRteAr(66)
     C                   EVAL      FSDSCF67 = PNYRteAr(67)
     C                   EVAL      FSDSCF68 = PNYRteAr(68)
     C                   EVAL      FSDSCF69 = PNYRteAr(69)
     C                   EVAL      FSDSCF70 = PNYRteAr(70)
     C                   EVAL      FSDSCF71 = PNYRteAr(71)
     C                   EVAL      FSDSCF72 = PNYRteAr(72)
     C                   EVAL      FSDSCF73 = PNYRteAr(73)
     C                   EVAL      FSDSCF74 = PNYRteAr(74)
     C                   EVAL      FSDSCF75 = PNYRteAr(75)
     C                   EVAL      FSDSCF76 = PNYRteAr(76)
     C                   EVAL      FSDSCF77 = PNYRteAr(77)
     C                   EVAL      FSDSCF78 = PNYRteAr(78)
     C                   EVAL      FSDSCF79 = PNYRteAr(79)
     C                   EVAL      FSDSCF80 = PNYRteAr(80)
     C                   EVAL      FSDSCF81 = PNYRteAr(81)
     C                   EVAL      FSDSCF82 = PNYRteAr(82)
     C                   EVAL      FSDSCF83 = PNYRteAr(83)
     C                   EVAL      FSDSCF84 = PNYRteAr(84)
     C                   EVAL      FSDSCF85 = PNYRteAr(85)
     C                   EVAL      FSDSCF86 = PNYRteAr(86)
     C                   EVAL      FSDSCF87 = PNYRteAr(87)
     C                   EVAL      FSDSCF88 = PNYRteAr(88)
     C                   EVAL      FSDSCF89 = PNYRteAr(89)
     C                   EVAL      FSDSCF90 = PNYRteAr(90)
     C                   EVAL      FSDSCF91 = PNYRteAr(91)
     C                   EVAL      FSDSCF92 = PNYRteAr(92)
     C                   EVAL      FSDSCF93 = PNYRteAr(93)
     C                   EVAL      FSDSCF94 = PNYRteAr(94)
     C                   EVAL      FSDSCF95 = PNYRteAr(95)
     C                   EVAL      FSDSCF96 = PNYRteAr(96)
     C                   EVAL      FSDSCF97 = PNYRteAr(97)
     C                   EVAL      FSDSCF98 = PNYRteAr(98)
     C                   EVAL      FSYRAT01 = *ZERO
     C                   EVAL      FSYRAT02 = *ZERO
     C                   EVAL      FSYRAT03 = *ZERO
     C                   EVAL      FSYRAT04 = *ZERO
     C                   EVAL      FSYRAT05 = *ZERO
     C                   EVAL      FSYRAT06 = *ZERO
     C                   EVAL      FSYRAT07 = *ZERO
     C                   EVAL      FSYRAT08 = *ZERO
     C                   EVAL      FSYRAT09 = *ZERO
     C                   EVAL      FSYRAT10 = *ZERO
     C                   EVAL      FSYRAT11 = *ZERO
     C                   EVAL      FSYRAT12 = *ZERO
     C                   EVAL      FSYRAT13 = *ZERO
     C                   EVAL      FSYRAT14 = *ZERO
     C                   EVAL      FSYRAT15 = *ZERO
     C                   EVAL      FSYRAT16 = *ZERO
     C                   EVAL      FSYRAT17 = *ZERO
     C                   EVAL      FSYRAT18 = *ZERO
     C                   EVAL      FSYRAT19 = *ZERO
     C                   EVAL      FSYRAT20 = *ZERO
     C                   EVAL      FSYRAT21 = *ZERO
     C                   EVAL      FSYRAT22 = *ZERO
     C                   EVAL      FSYRAT23 = *ZERO
     C                   EVAL      FSYRAT24 = *ZERO
     C                   EVAL      FSYRAT25 = *ZERO
     C                   EVAL      FSYRAT26 = *ZERO
     C                   EVAL      FSYRAT27 = *ZERO
     C                   EVAL      FSYRAT28 = *ZERO
     C                   EVAL      FSYRAT29 = *ZERO
     C                   EVAL      FSYRAT30 = *ZERO
     C                   EVAL      FSYRAT31 = *ZERO
     C                   EVAL      FSYRAT32 = *ZERO
     C                   EVAL      FSYRAT33 = *ZERO
     C                   EVAL      FSYRAT34 = *ZERO
     C                   EVAL      FSYRAT35 = *ZERO
     C                   EVAL      FSYRAT36 = *ZERO
     C                   EVAL      FSYRAT37 = *ZERO
     C                   EVAL      FSYRAT38 = *ZERO
     C                   EVAL      FSYRAT39 = *ZERO
     C                   EVAL      FSYRAT40 = *ZERO
     C                   EVAL      FSYRAT41 = *ZERO
     C                   EVAL      FSYRAT42 = *ZERO
     C                   EVAL      FSYRAT43 = *ZERO
     C                   EVAL      FSYRAT44 = *ZERO
     C                   EVAL      FSYRAT45 = *ZERO
     C                   EVAL      FSYRAT46 = *ZERO
     C                   EVAL      FSYRAT47 = *ZERO
     C                   EVAL      FSYRAT48 = *ZERO
     C                   EVAL      FSYRAT49 = *ZERO
     C                   EVAL      FSYRAT50 = *ZERO
     C                   EVAL      FSYRAT51 = *ZERO
     C                   EVAL      FSYRAT52 = *ZERO
     C                   EVAL      FSYRAT53 = *ZERO
     C                   EVAL      FSYRAT54 = *ZERO
     C                   EVAL      FSYRAT55 = *ZERO
     C                   EVAL      FSYRAT56 = *ZERO
     C                   EVAL      FSYRAT57 = *ZERO
     C                   EVAL      FSYRAT58 = *ZERO
     C                   EVAL      FSYRAT59 = *ZERO
     C                   EVAL      FSYRAT60 = *ZERO
     C                   EVAL      FSYRAT61 = *ZERO
     C                   EVAL      FSYRAT62 = *ZERO
     C                   EVAL      FSYRAT63 = *ZERO
     C                   EVAL      FSYRAT64 = *ZERO
     C                   EVAL      FSYRAT65 = *ZERO
     C                   EVAL      FSYRAT66 = *ZERO
     C                   EVAL      FSYRAT67 = *ZERO
     C                   EVAL      FSYRAT68 = *ZERO
     C                   EVAL      FSYRAT69 = *ZERO
     C                   EVAL      FSYRAT70 = *ZERO
     C                   EVAL      FSYRAT71 = *ZERO
     C                   EVAL      FSYRAT72 = *ZERO
     C                   EVAL      FSYRAT73 = *ZERO
     C                   EVAL      FSYRAT74 = *ZERO
     C                   EVAL      FSYRAT75 = *ZERO
     C                   EVAL      FSYRAT76 = *ZERO
     C                   EVAL      FSYRAT77 = *ZERO
     C                   EVAL      FSYRAT78 = *ZERO
     C                   EVAL      FSYRAT79 = *ZERO
     C                   EVAL      FSYRAT80 = *ZERO
     C                   EVAL      FSYRAT81 = *ZERO
     C                   EVAL      FSYRAT82 = *ZERO
     C                   EVAL      FSYRAT83 = *ZERO
     C                   EVAL      FSYRAT84 = *ZERO
     C                   EVAL      FSYRAT85 = *ZERO
     C                   EVAL      FSYRAT86 = *ZERO
     C                   EVAL      FSYRAT87 = *ZERO
     C                   EVAL      FSYRAT88 = *ZERO
     C                   EVAL      FSYRAT89 = *ZERO
     C                   EVAL      FSYRAT90 = *ZERO
     C                   EVAL      FSYRAT91 = *ZERO
     C                   EVAL      FSYRAT92 = *ZERO
     C                   EVAL      FSYRAT93 = *ZERO
     C                   EVAL      FSYRAT94 = *ZERO
     C                   EVAL      FSYRAT95 = *ZERO
     C                   EVAL      FSYRAT96 = *ZERO
     C                   EVAL      FSYRAT97 = *ZERO
     C                   EVAL      FSYRAT98 = *ZERO
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRRESETERRS - Reset error information that is received back   *
      *               from each validation module                     *
      *                                                               *
      * Called By: SRVALINPUT subroutine                              *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SRRESETERRS   BEGSR
 
     C                   EVAL      RetCodeOut = *Blanks
 
      ** Reset error & warning fields/message IDs/message data (arrays)
 
     C                   EVAL      FldNamXAr2= *BLANKS
     C                   EVAL      MsgIdXAr2 = *BLANKS
     C                   EVAL      MsgDtaXAr2= *BLANKS
     C                   EVAL      WFldNmXAr2 = *BLANKS
     C                   EVAL      WMsgIdXAr2= *BLANKS
     C                   EVAL      WMsgDtXAr2 = *BLANKS
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRUPDATERRS - Update error information with that received     *
      *               back from each validation module                *
      *                                                               *
      * Called By: SRVALINPUT subroutine                              *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SRUPDATERRS   BEGSR
 
      ** Update error fields/message IDs/message data (arrays)
 
     C                   Z-ADD     1             I
     C     *BLANK        LOOKUP    FldNameAr2(I)                          99
 
     C                   IF        *IN99 = *ON
     C                   MOVEA     FldNamXar2    FlDNameAr2(I)
     C                   MOVEA     MsgIdXar2     MsgIdAr2(I)
     C                   MOVEA     MsgDtaXar2    MsgDtaAr2(I)
     C                   ENDIF
 
      ** Set Error Index
 
     C                   Z-ADD     1             I
     C     *BLANK        LOOKUP    FldNameAr2(I)                          99
     C     I             SUB       1             Idx
 
      ** Update warning fields/message IDs/message data (arrays)
 
     C                   Z-ADD     1             I
     C     *BLANK        LOOKUP    WFldNamAr2(I)                          99
 
     C                   IF        *IN99 = *ON
     C                   MOVEA     WFldNmXAr2    WFldNamAr2(I)
     C                   MOVEA     WMsgIdXAr2    WMsgIDAr2(I)
     C                   MOVEA     WMsgDtXAr2    WMsgDtaAr2(I)
     C                   ENDIF
 
      **  Set Warning Index
 
     C                   Z-ADD     1             I
     C     *BLANK        LOOKUP    WFldNamAr2(I)                          99
     C     I             SUB       1             WIdx
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called By: Called automatically upon module execution         *
      *                                                               *
      * Calls:                                                        *
      * AOBANKR0  - Access Bank Details                               *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    RespMode
     C                   PARM                    PModeOfOp
     C                   PARM                    YRATScnFmt
     C                   PARM                    YRATExtDta
     C                   PARM                    YRATPrev
     C                   PARM                    YRATOKFlgs
     C                   PARM                    FldNameAr2
     C                   PARM                    MsgIDAr2
     C                   PARM                    MsgDtaAr2
     C                   PARM                    Idx
     C                   PARM                    WFldNamAr2
     C                   PARM                    WMsgIDAr2
     C                   PARM                    WMsgDtaAr2
     C                   PARM                    WIdx
     C                   PARM                    PMatAr
     C                   PARM                    YRATValid
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY sets the values of program, module and
      ** procedure names for database error processing.
     C/COPY ZACPYSRC,DBFIELDS
      **--------------------------------------------------------------------------------------------
 
      ** Access Bank Details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database Error
 
     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE  = 1
     C                   EVAL      DBKEY  = POPTN
     C                   EXSR      *PSSR
     C                   ELSE
     C                   EVAL      WKDFIN = BJDFIN
     C                   EVAL      WKRDNB = BJRDNB
     C                   EVAL      WKCYCD = BJCYCD
     C                   ENDIF
                                                                                              208179
      ** Check if switchable feature CSC011 is switched on.                                   208179
                                                                                              208179
     C                   EVAL      CSC011 = 'N'                                               208179
                                                                                              208179
     C                   CALL      'AOSARDR0'                                                 208179
     C                   PARM      *BLANKS       PRtCd                                        208179
     C                   PARM      '*VERIFY'     POptn                                        208179
     C                   PARM      'CSC011'      PSard                                        208179
     C     SCSARD        PARM      SCSARD        DSFDY                                        208179
                                                                                              208179
      ** Database error                                                                       208179
                                                                                              208179
     C                   IF        (PRtCd <> *BLANKS) and                                     208179
     C                             (PRtCd <> '*NRF   ')                                       208179
     C                   EVAL      DBKEY = 'CSC011'                                           208179
     C                   EVAL      DBFILE = 'SCSARDPD'                                        208179
     C                   EVAL      DBASE = 4                                                  208179
     C                   EXSR      *PSSR                                                      208179
     C                   ENDIF                                                                208179
                                                                                              208179
     C                   IF        PRtCd = *BLANKS                                            208179
     C                   EVAL      CSC011 = 'Y'                                               208179
     C                   IN        SDSTAT                                                     208179
     C                   IN        SC24X7                                                     208179
     C                   IF        LIBR = S1SUPP                                              208179
     C                   EVAL      WKRDNB = S1DATE                                            208179
     C                   ENDIF                                                                208179
     C                   ENDIF                                                                208179
 
                                                                                              CAS008
      ** Check if switchable feature CAS008 is switched on.                                   CAS008
                                                                                              CAS008
     C                   EVAL      CAS008 = 'N'                                               CAS008
                                                                                              CAS008
     C                   CALL      'AOSARDR0'                                                 CAS008
     C                   PARM      *BLANKS       PRtCd                                        CAS008
     C                   PARM      '*VERIFY'     POptn                                        CAS008
     C                   PARM      'CAS008'      PSard                                        CAS008
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAS008
                                                                                              CAS008
      ** Database error                                                                       CAS008
                                                                                              CAS008
     C                   IF        (PRtCd <> *BLANKS) AND                                     CAS008
     C                             (PRtCd <> '*NRF   ')                                       CAS008
     C                   EVAL      DBKEY = 'CAS008'                                           CAS008
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CAS008
     C                   EVAL      DBASE = 5                                                  CAS008
     C                   EXSR      *PSSR                                                      CAS008
     C                   ENDIF                                                                CAS008
                                                                                              CAS008
     C                   IF        PRtCd = *BLANKS                                            CAS008
     C                   EVAL      CAS008 = 'Y'                                               CAS008
     C                   ENDIF                                                                CAS008
                                                                                              CAS008
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      **--------------------------------------------------------------------------------------------
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILE
      **--------------------------------------------------------------------------------------------
      ********************************************************************
