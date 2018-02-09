     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*OVR *: OVRDBF FILE(LEITISLX) TOFILE(LEITISL0) SHARE(*NO)          : *
/*OVR *: OVRDBF FILE(LEITISLY) TOFILE(LEITISL1) SHARE(*NO)          : *
/*OVR *: OVRDBF FILE(LEITISLZ) TOFILE(LEITISL2) SHARE(*NO)          : *
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Transaction Income Splits Repair')            *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LE2081 - Transaction Income Splits Repair                    *
      *                                                               *
      *  Function: This function allows invalid loan and fee income   *
      *            splits to be 'repaired' and applied to the Midas   *
      *            database.                                          *
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
      *                 CSD027A            Date 10May06               *
      *                 CLE042             Date 06Sep05               *
      *                 CLE106             Date 01Aug04               *
      *                 CLE035  *CREATE    Date 22Sep03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CLE148 - Alpha Loan Reference                                *
      *  CSD027A - Conversion Of Customer Number to Alpha             *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  CLE106 - Syndications Manager.                               *
      *  CLE035 - Lending Enhancements for Nordea Phase 1 Priority 2: *
      *           Income Splits                                       *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * SRBldSubFil - Build subfile screen                            *
      * SRProcSubfil - Process subfile screen                         *
      * SRProcSel - Process selected/validated subfile selections     *
      * SRValSubfil  - Validate subfile selections                    *
      * SRDelete - Delete invalid record from invalid file            *
      * SRAmend - Process amendment of invalid record                 *
      * SRValLoans - Validate loan income split screen                *
      * SRValFees - Validate fees income split screen                 *
      * SRValCust - Validate customer                                 *
      * SRValIPA - Validate income percentage allocation              *
      * SRUpdFile - Update file                                       *
      * SRInsertRec - Insert repaired record to LETISPPD              *
      * SRAmendRec - Amend repaired record in LETISPPD                *
      * SRDeleteRec - Delete record in LETISPPD                       *
      * SRReplace - Physically delete records from LETISPPD           *
      * SRClrMsg - Clear message subfile and data                     *
      * SRSndMsg - Send message to subfile                            *
      * LOGDEL - Delete record from 24x7 Midas Availability Log       *
      * LOG247 - Convert fields to the 24x7 Midas Availability Log    *
      * APLGTR - Write Transaction to 24x7 Midas Availability Log     *
      * SRZEdit - Format fields                                       *
      * SRFmtDet - Format details for output                          *
      * SRInit - Initial processing                                   *
      * *PSSR - Error processing                                      *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FLEITISLX  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(LEITISD0:LEITISDX)
      ** Midas LE Invalid Income Splits - Loan
 
     FLEITISLY  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(LEITISD0:LEITISDY)
      ** Midas LE Invalid Income Splits - Fees
 
     FLEITISLZ  UF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(LEITISD0:LEITISD2)
      ** Midas LE Invalid Income Splits by Repair Number
 
     FLETISPL0  UF A E           K DISK    INFSR(*PSSR)
     F                                     RENAME(LETISPD0:LETISP0)
      ** Midas LE Loan Income Splits
 
     FLETISPL1  UF A E           K DISK    INFSR(*PSSR)
     F                                     RENAME(LETISPD0:LETISP1)
      ** Midas LE Fee Income Splits
 
     FLETISPL3  UF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(LETISPD0:LETISP3)
      ** Midas LE Loan Income Splits - All record ID status
 
     FLETISPL4  UF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(LETISPD0:LETISP4)
      ** Midas LE Fee Income Splits - All record ID status
 
     FFCLTYL0   IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(F_)
      ** Midas LE Facilities file
 
     FCLOAN     IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(C_)
     F                                     IGNORE(CLOANHHF)
     F                                     IGNORE(CLOANCKF)
     F                                     IGNORE(CLOANZ1F)
      ** Midas LE Loans File
 
     FLEFEEDL1  IF   E           K DISK    INFSR(*PSSR)
      ** Midas LE Fee details - active
 
     FAPILOGL0  UF   E           K DISK    INFSR(*PSSR) USROPN
     F                                     RENAME(APILOGD0:APILOG0)
     F                                     COMMIT
      ** API Invalid Log File from Support Database
 
     FAPVLOGPD  UF A E           K DISK     INFSR(*PSSR) USROPN
      ** API Valid Log File
 
     FLE2081DF  CF   E             WORKSTN
     F                                     SFILE(LE2081S1 : #1RLRN)
      ** Midas LE Transaction Income Splits Repair display
 
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
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
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
     D/COPY ZACPYSRC,ERR_ARRAYS
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
 
     D NUMERIC         C                   '0123456789'
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      **---------------------------------------------------------
      ** Indicator Array
     D Indicators      DS                  BASED(IndicatorP)
     D  EndOfFile             01     01
     D  ErrSelOpt             31     31
     D  DspNoData             30     30
     D  SflActive             92     92
     D  MsgSFleEnd            94     94
     D  SFleNxtChg            95     95
     D  SFleEnd               96     96
     D  SFleClr               97     97
     D  RollUp                98     98
 
      ** Pointer for the indicator Array
     D IndicatorP      S               *   INZ(%Addr(*IN))
      **---------------------------------------------------------
 
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      ** External DS for SAR details
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for access programs, short date structure
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Second DS for access programs, long date structure
 
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)
      ** 24X7 status data area
 
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)
      ** SD data area
 
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      ** DS for SD Bank details ICD file
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** DS for SD Bank details ICD file
 
      ** Branch Details Data Structure
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
     D QQDFACX       E                     EXTFLD(QQDFAC)                                     CLE106
 
      ** Midas LE PC Msg Trans. Income Splits
     D I1MFPD        E DS                  EXTNAME(LEI1MFPD)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Entry parameter
     D POption         S              1A
 
      ** SAR access variables
     D CSC011          S              1A
 
      ** Access objects parameters
     D PRtCd           S              7A
     D POptn           S              7A
     D PSard           S              6A
     D PCustomer       S             10A
     D PKyst           S              7A
     D PBranch         S              3A
 
     D CurSelFlds      DS
     D  #1KEY1                        6A
     D  #1KEY2                        6A
     D  #1KEY3                        2A
 
      ** Subfile detail line for invalid loans income splits
     D WLoanDetl       DS
     D  WLLNRF                        6A
     D  WLFIL1                        4A
     D  WLACTN                        1A
     D  WLFIL2                        5A
     D  WLCNUM                        6A
     D  WLFIL3                       11A
     D  WLIPAL                       13A
 
      ** Subfile detail line for invalid fees income splits
     D WFeesDetl       DS
     D  WFCNUM                        6A
     D  WFFIL1                        7A
     D  WFLNFC                        6A
     D  WFFIL2                        4A
     D  WFFESQ                        2A
     D  WFFIL3                        6A
     D  WFACTN                        1A
     D  WFFIL4                        5A
     D  WFISCN                        6A
     D  WFFIL5                        7A
     D  WFIPAL                       13A
 
      ** Index for arrays of error message ids
     D Idx             S              3P 0
 
      ** Y2SNMGC/Y2RVMGC Parameters
     D ZAPGMQ          S             10A
     D ZAPGRL          S              5A
     D ZAMSID          S              7A
     D ZAMSGF          S             10A   INZ('GBLERMSGF')
     D ZAMSDA          S            132A
     D ZAMSTP          S              7A
 
      ** Parameters for ZA0350
     D PMsgFile        S             10A   INZ('GBLERMSGF')
     D PMsgId          S             10A
     D PMsgData        S             45A
 
      ** Parameters for LE2031
     D PInvFil         S              8A   INZ('LEITISPD')
     D PRepNum         S              5  0
 
      ** ZALIGN Parameters
     D ZAlignOk        S              1A
     D ZFLD16          S             16A
     D ZSDEC           S              1  0
     D ZSDIG           S              2  0
 
      ** ZEDIT Parameters
     D ZField          S             16A
     D ZADEC           S              1P 0
 
     D WLinePerPage    S              2  0 INZ(14)
     D ResetSbFl       S              1A
     D KeyFlag         S              1A
     D WError          S              1A
     D WCustErr        S              1A
     D WIPALErr        S              1A
     D W1stRec         S              1A
     D WScrn           S              1A
     D WReplace        S              1A
     D WSupSys         S              1A
     D WrkTMST         S             26Z
     D WTimeStamp      S             26Z
     D WMsgType        S              8A
     D WFrOffId        S             20A
 
     D WkSRRN1         S              5  0
     D WkCnt           S              5  0
     D WSelCnt         S              2  0
     D WLastChr        S              1A
     D WBranch         S                   LIKE(BRCA)
 
     D KCNUM           S                   LIKE(SNCUS)
     D KLNRF           S                   LIKE(SNLON)
     D KFACL           S                   LIKE(SFACL)
     D KFESQ           S                   LIKE(SFESQ)
     D KISCN           S                   LIKE(SISCN)
     D KFACT           S              3  0
     D KFCNO           S              2  0
     D KREPN           S                   LIKE(XREPN)
 
     D WrkIPAL         S             12  9
     D WTotAlloc       S             12  9
     D WFilIPAL        S             12  9
     D WScnIPAL        S             13A
 
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
 
      ** Initialisation
 
     C                   EXSR      SRInit
 
      ** Build initial subfile
 
     C                   EXSR      SRBldSubFil
 
      ** Process until user exits (F3)
 
     C                   DOW       *INKC = *OFF
 
      ** Process subfile screen
 
     C                   EXSR      SRProcSubfil
 
     C                   ENDDO
 
      ** End program
 
     C                   EVAL      *INLR = *ON
 
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRBldSubFil - Build subfile screen
      *****************************************************************
     C     SRBldSubFil   BEGSR
 
      ** Clear appropriate select fields if F5 is pressed
 
     C                   IF        *INKE = *ON
     C                   EVAL      CurSelFlds = *BLANKS
     C                   ENDIF
 
      ** If first time in
 
     C                   IF        ResetSbFl = 'Y'
     C                   EVAL      SFleClr = *ON
     C                   WRITE     LE2081C1
     C                   EVAL      SFleClr = *OFF
     C                   EVAL      #1RLRN = *ZERO
     C                   EVAL      WkSRRN1 = *ZERO
     C                   EVAL      ErrSelOpt = *OFF
     C                   EVAL      ResetSbFl = 'N'
     C                   EVAL      SFleEnd = *OFF
     C                   ENDIF
 
      ** Initialise count of records written to subfile page
 
     C                   EVAL      WkCnt = *ZERO
     C                   EVAL      EndOfFile = *OFF
 
      ** Set file pointer on key displayed on screen.
      ** Read a Valid Transaction
 
     C                   IF        POption = 'L'
     C                   SELECT
     C                   WHEN      KeyFlag = 'Y'
     C                   MOVE      #1KEY1        KLNRF
     C     KLNRF         SETLL     LEITISLX
     C                   WHEN      KeyFlag = 'R'
     C     KLNRF         SETGT     LEITISLX
     C                   OTHER
     C     *LOVAL        SETLL     LEITISLX
     C                   ENDSL
     C                   READ      LEITISLX                               01
     C                   ELSE
     C                   SELECT
     C                   WHEN      KeyFlag = 'Y'
     C                   MOVE      #1KEY1        KCNUM
     C                   MOVE      #1KEY3        KFESQ
 
     C                   MOVEL     WFLNFC        WLastChr
     C                   IF        WLastChr = *BLANK
     C                   MOVE      #1KEY2        KFACL
     C**********         EVAL      KLNRF = *ZERO                                              CLE148
     C                   EVAL      KLNRF = *BLANKS                                            CLE148
     C                   ELSE
     C                   MOVE      #1KEY2        KLNRF
     C                   EVAL      KFACL = *ZERO
     C                   ENDIF
 
     C     KFEESPAR      SETLL     LEITISLY
     C                   WHEN      KeyFlag = 'R'
     C     KFEESPAR      SETGT     LEITISLY
     C                   OTHER
     C     *LOVAL        SETLL     LEITISLY
     C                   ENDSL
     C                   READ      LEITISLY                               01
     C                   ENDIF
 
      ** If end of file is reached, no records is displayed
 
     C                   IF        EndOfFile = *ON
 
     C                   EVAL      DspNoData = *ON
     C                   MOVE      *BLANKS       CurSelFlds
     C                   EVAL      Idx = 1
     C                   EVAL      MsgIdArr(Idx) = 'LEV1005'
     C                   Z-ADD     1             #1RLRN
     C                   WRITE     LE2081S1
 
     C                   ELSE
 
      ** There is data so turn off DspNoData indicator
 
     C                   EVAL      DspNoData = *OFF
 
      ** For each record read, write it to the subfile.
      ** Do this until end of file or the subfile page is full.
 
     C                   DOW       EndOfFile = *OFF AND
     C                             WKCnt < WLinePerPage
 
      ** Increment the subfile record no. and records written fields.
 
     C                   EVAL      WkCnt = WkCnt + 1
     C                   EVAL      WkSRRN1 = WkSRRN1 + 1
 
 
      ** Format transaction fields for output
 
     C                   EXSR      SRFmtDet
 
      ** Write details to the subfile.
 
     C                   Z-ADD     WkSRRN1       #1RLRN
     C                   WRITE     LE2081S1
 
     C                   IF        POption = 'L'
     C                   EVAL      KLNRF = SNLON
     C                   ELSE
     C                   EVAL      KCNUM = SNCUS
     C                   EVAL      KFESQ = SFESQ
 
     C                   MOVEL     WFLNFC        WLastChr
     C                   IF        WLastChr = *BLANK
     C                   EVAL      KFACL = SFACL
     C**********         EVAL      KLNRF = *ZERO                                              CLE148
     C                   EVAL      KLNRF = *BLANKS                                            CLE148
     C                   ELSE
     C                   EVAL      KLNRF = SNLON
     C                   EVAL      KFACL = *ZERO
     C                   ENDIF
     C                   ENDIF
 
      ** Read next record in file LEITISLX/LY
 
     C                   IF        POption = 'L'
     C                   READ      LEITISLX                               01
     C                   ELSE
     C                   READ      LEITISLY                               01
     C                   ENDIF
     C                   ENDDO
     C                   ENDIF
 
      ** Set the record pointer to the previous record retrieved, using
      ** READPE if not yet end of file
 
     C                   IF        EndOfFile = False
     C                   IF        POption = 'L'
     C     KLNRF         READPE    LEITISLX                               01
     C                   ELSE
     C     KFEESPAR      READPE    LEITISLY                               01
     C                   ENDIF
     C                   IF        EndOfFile = True
     C                   EVAL      SfleEnd = True
     C                   ENDIF
     C                   ELSE
     C                   EVAL      SFleEnd = True
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRProcSubfil - Process subfile screen
      *****************************************************************
     C     SRProcSubfil  BEGSR
 
      ** Send message to subfile if any.
 
     C                   EXSR      SRSndMsg
 
      ** Display screen header and footer
 
     C                   WRITE     LE2081F0
     C                   EVAL      *IN81 = *ON
     C                   WRITE     LE2081F4
 
      ** Display screen subfile
 
     C                   EVAL      SflActive = True
     C                   WRITE     LE2081C2
     C                   EXFMT     LE2081C1
 
      ** Clear message queue
 
     C                   EXSR      SRClrMsg
 
      ** Select processing type
 
     C                   SELECT
 
      ** F3 Exit
     C                   WHEN      *INKC = True
 
      ** F5 Refresh
     C                   WHEN      *INKE = True
     C                   EVAL      KeyFlag = 'N'
     C                   EVAL      ResetSbFl  = 'Y'
     C                   EXSR      SRBldSubFil
 
      ** RollUp pressed
     C                   WHEN      RollUp = True
     C                   EVAL      KeyFlag = 'R'
     C                   EXSR      SRBldSubFil
 
     C                   OTHER
 
      ** Validate user selection input
 
     C                   EXSR      SRValSubfil
 
     C                   IF        WError = 'N'
     C                   EXSR      SRProcSel
     C                   IF        CurSelFlds <> *BLANK
     C                   EVAL      KeyFlag = 'Y'
     C                   EVAL      ResetSbFl  = 'Y'
     C                   ELSE
     C                   EVAL      KeyFlag = 'N'
     C                   EVAL      ResetSbFl  = 'Y'
     C                   ENDIF
     C                   EXSR      SRBldSubFil
     C                   ENDIF
 
     C                   ENDSL
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRProcSel - Process selected/validated subfile selections
      *****************************************************************
     C     SRProcSel     BEGSR
 
      ** Read subfile
 
     C                   READC     LE2081S1                               01
 
     C                   DOW       EndOfFile = False AND
     C                             *INKC = *OFF
 
     C                   IF        #1SEL <> *BLANK
     C                   SELECT
 
      ** Action Code is 'Q' (Delete)
     C                   WHEN      #1SEL = 'Q'
     C                   EXSR      SRDelete
 
      ** Action Code is 'U' (Amend)
     C                   WHEN      #1SEL = 'U'
     C                   EXSR      SRAmend
 
     C                   ENDSL
     C                   ENDIF
 
     C                   EVAL      SFleNxtChg = *ON
     C                   UPDATE    LE2081S1
     C                   EVAL      SFleNxtChg = *OFF
 
      ** Read subfile again
 
     C                   READC     LE2081S1                               01
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRValSubfil  - Validate subfile selections
      *****************************************************************
     C     SRValSubfil   BEGSR
 
     C                   EVAL      WError  = 'N'
     C                   EVAL      Idx = *ZERO
 
      ** Read subfile that has changed
 
     C                   READC     LE2081S1                               01
 
     C                   DOW       EndOfFile = False
 
     C                   EVAL      ErrSelOpt  = *OFF
 
      ** Action Code must be either 'U' OR 'Q'
 
     C                   IF        #1SEL <> *BLANK AND
     C                             #1SEL <> 'Q'    AND
     C                             #1SEL <> 'U'
     C                   EVAL      ErrSelOpt = *ON
     C                   EVAL      WError  = 'Y'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdArr(Idx) = 'LEA1044'
     C                   ENDIF
 
     C                   EVAL      SFleNxtChg = *ON
     C                   UPDATE    LE2081S1
     C                   EVAL      SFleNxtChg = *OFF
 
      ** Read subfile again
 
     C                   READC     LE2081S1                               01
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRDelete - Delete invalid record from invalid file
      *****************************************************************
     C     SRDelete      BEGSR
 
     C                   MOVE      #1REPN        PRepNum
 
     C                   CALL      'LE2031'
     C                   PARM      'LEITISPD'    PInvFil
     C                   PARM                    PRepNum
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRAmend - Process amendment of invalid record
      *****************************************************************
     C     SRAmend       BEGSR
 
      ** Initialisations
 
     C                   EVAL      WError  = 'Y'
     C                   EVAL      *IN81 = *OFF
 
      ** Set initial error message
 
     C                   EVAL      Idx = 1
     C                   EVAL      MsgIdArr(Idx) = #1MSID
 
      ** Format visible details
 
     C                   IF        POption = 'L'
     C                   MOVEL     #1DETL        WLoanDetl
     C                   MOVE      WLACTN        #3ACTN
     C                   MOVE      WLLNRF        #3LNRF
     C                   MOVE      WLCNUM        #3CUST
     C                   MOVE      WLIPAL        #3LIPA
     C                   ELSE
 
     C                   MOVEL     #1DETL        WFeesDetl
     C                   MOVEL     WFLNFC        WLastChr
     C                   IF        WLastChr = *BLANK
     C                   MOVE      *BLANK        #3LNRF
     C                   MOVE      WFLNFC        #3FFAC
     C                   ELSE
     C                   MOVE      WFLNFC        #3LNRF
     C                   MOVE      *BLANK        #3FFAC
     C                   ENDIF
     C                   MOVE      WFACTN        #3ACTN
     C                   MOVE      WFCNUM        #3CUST
     C                   MOVE      WFFESQ        #3FFES
     C                   MOVE      WFISCN        #3FISC
     C                   MOVE      WFIPAL        #3FIPA
     C                   ENDIF
 
      ** Protect Income split customer is action code is not insert
 
     C                   IF        #3ACTN = 'I'
     C                   EVAL      *IN22 = *OFF
     C                   ELSE
     C                   EVAL      *IN22 = *ON
     C                   ENDIF
 
      ** Process screen
 
     C                   DOU       *INKC = True OR
     C                             *INKL = True OR
     C                             WError  = 'N'
 
     C                   EXSR      SRSndMsg
 
     C                   WRITE     LE2081F0
     C                   WRITE     LE2081F4
     C                   WRITE     LE2081C2
     C                   EXFMT     LE2081F3
 
      ** Clear message queue
 
     C                   EXSR      SRClrMsg
 
     C                   SELECT
 
      ** F3 Pressed or F12 Refresh
     C                   WHEN      *INKC = True OR
     C                             *INKL = True
     C                   OTHER
 
      ** Validate and update if no errors
 
     C                   EVAL      WError  = 'N'
     C                   EVAL      Idx = *ZERO
 
      ** Action code must be 'A', 'I', or 'D'
 
     C                   IF        #3ACTN <> 'A' AND
     C                             #3ACTN <> 'I' AND
     C                             #3ACTN <> 'D'
     C                   EVAL      WError  = 'Y'
     C                   EVAL      *IN32 = *ON
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdArr(Idx) = 'LEI0017'
     C                   ELSE
 
     C                   IF        POption = 'L'
     C                   EXSR      SRValLoans
     C                   ELSE
     C                   EXSR      SRValFees
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        WError = 'N'
     C                   EXSR      SrUpdFile
     C                   ENDIF
     C                   ENDSL
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRValLoans - Validate Loan income split screen
      *****************************************************************
     C     SRValLoans    BEGSR
 
      ** LOAN: Must refer to a valid loan in the system
 
     C                   IF        #3LNRF = *BLANKS
     C                   EVAL      *IN33 = *ON
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdArr(Idx) = 'LEI0002'
     C                   ELSE
 
     C                   MOVE      #3LNRF        KLNRF
     C     KLNRF         CHAIN     CLOAN
     C                   IF        NOT %FOUND(CLOAN)  OR  %FOUND(CLOAN)  AND
     C                             C_RECI <> 'D'
     C                   EVAL      *IN33 = *ON
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdArr(Idx) = 'LEI0002'
     C                   ELSE
     C                   EVAL      WBranch = C_BRCA
     C                   ENDIF
     C                   ENDIF
 
      ** SPLIT CUSTOMER: Mandatory and must exist in the system
 
     C                   EVAL      PCustomer = #3CUST
     C                   EXSR      SRValCust
     C                   IF        WCustErr = 'Y'
     C                   EVAL      *IN34 = *ON
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdArr(Idx) = 'LEI0006'
     C                   ELSE
     C                   EVAL      #3CUST = BBCUST
     C                   ENDIF
 
      ** LOAN KEYS: Validate input against Loan transaction income splits
 
     C                   IF        *IN33 = *OFF AND
     C                             *IN34 = *OFF
     C                   MOVE      #3CUST        KISCN
     C     KLOANFUL      CHAIN     LETISPL0
 
      ** For amd/del, there must be an existing live record
 
     C                   IF        NOT %FOUND(LETISPL0)  AND  #3ACTN = 'A'  OR
     C                             NOT %FOUND(LETISPL0)  AND  #3ACTN = 'D'
     C                   EVAL      *IN33 = *ON
     C                   EVAL      *IN34 = *ON
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdArr(Idx) = 'LEI0004'
     C                   ENDIF
 
      ** For insert, there must be no existing live record
 
     C                   IF        %FOUND(LETISPL0) AND #3ACTN = 'I'
     C                   EVAL      *IN33 = *ON
     C                   EVAL      *IN34 = *ON
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdArr(Idx) = 'LEI0003'
     C                   ENDIF
 
      ** Save income percentage allocation for calculations later.
 
     C                   EVAL      WFilIPAL = *ZERO
     C                   IF        %FOUND(LETISPL0) AND #3ACTN = 'A'
     C                   EVAL      WFilIPAL = IPAL
     C                   ENDIF
 
      ** For insert, check if record exists but already deleted;
      ** if yes, set flag to replace these records
 
     C                   IF        NOT %FOUND(LETISPL0) AND #3ACTN = 'I'
     C     KLOANFUL      CHAIN     LETISPL3
     C                   IF        %FOUND(LETISPL3)
     C                   EVAL      WReplace = 'Y'
     C                   ELSE
     C                   EVAL      WReplace = 'N'
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
      ** Get total income percent allocation
 
     C                   IF        *IN33 = *OFF AND
     C                             *IN34 = *OFF
     C     KLNRF         SETLL     LETISPL0
     C     KLNRF         READE     LETISPL0                               01
     C                   EVAL      WTotAlloc = *ZERO
     C                   DOW       EndOfFile = *OFF
     C                   EVAL      WTotAlloc = WTotAlloc + IPAL
     C     KLNRF         READE     LETISPL0                               01
     C                   ENDDO
 
      ** Validate income percentage allocation
 
     C                   IF        #3ACTN <> 'D'
     C                   EVAL      WScnIPAL = #3LIPA
     C                   EXSR      SRValIPA
     C                   EVAL      #3LIPA = WScnIPAL
     C                   IF        WIPALErr = 'Y'
     C                   EVAL      *IN35 = *ON
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
      ** Set error flag
 
     C                   IF        Idx > 0
     C                   EVAL      WError  = 'Y'
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRValFees - Validate Fees income split screen
      *****************************************************************
     C     SRValFees     BEGSR
 
      ** LOAN OR FACILITY: Only one of the two must be entered
 
     C                   IF        #3FFAC <> *BLANKS  AND  #3LNRF <> *BLANKS  OR
     C                             #3FFAC = *BLANKS  AND  #3LNRF = *BLANKS
     C                   EVAL      *IN33 = *ON
     C                   EVAL      *IN36 = *ON
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdArr(Idx) = 'LEI0009'
     C                   ENDIF
 
      ** LOAN: Must refer to a valid loan in the system
 
     C                   IF        #3LNRF <> *BLANKS  AND  *IN33 = *OFF
     C                   MOVE      #3LNRF        KLNRF
     C     KLNRF         CHAIN     CLOAN
     C                   IF        NOT %FOUND(CLOAN)  OR  %FOUND(CLOAN)  AND
     C                             C_RECI <> 'D'
     C                   EVAL      *IN33 = *ON
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdArr(Idx) = 'LEI0002'
     C                   ENDIF
     C                   ENDIF
 
      ** CUSTOMER: Mandatory and must exist in the system
 
     C                   EVAL      PCustomer = #3CUST
     C                   EXSR      SRValCust
     C                   IF        WCustErr = 'Y'
     C                   EVAL      *IN34 = *ON
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdArr(Idx) = 'LEI0006'
     C                   ELSE
     C                   EVAL      #3CUST = BBCUST
     C                   ENDIF
 
      ** FACILITY/CUSTOMER: If entered, together, these
      ** should refer to a live facility in the system
 
     C                   IF        #3FFAC <> *BLANKS  AND  *IN36 = *OFF  AND
     C                             *IN34 = *OFF
     C                   MOVEL     #3CUST        KCNUM
     C                   MOVEL     #3FFAC        KFACT
     C                   MOVE      #3FFAC        KFCNO
     C     KFCLT0        CHAIN     FCLTYL0
     C                   IF        NOT %FOUND(FCLTYL0)
     C                   EVAL      *IN34 = *ON
     C                   EVAL      *IN36 = *ON
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdArr(Idx) = 'LEI0011'
     C                   ENDIF
     C                   ENDIF
 
      ** FEE SEQUENCE: must be numeric
 
     C                   IF        %CHECK(NUMERIC:#3FFES) = 1
     C                   EVAL      *IN37 = *ON
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdArr(Idx) = 'LEI0010'
     C                   ENDIF
 
      ** SPLIT CUSTOMER: Mandatory and must exist in the system
 
     C                   EVAL      PCustomer = #3FISC
     C                   EXSR      SRValCust
     C                   IF        WCustErr = 'Y'
     C                   EVAL      *IN38 = *ON
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdArr(Idx) = 'LEI0006'
     C                   ELSE
     C                   EVAL      #3FISC = BBCUST
     C                   ENDIF
 
      ** FEE KEYS: Validate input against Fee transaction income splits
 
     C                   IF        *IN33 = *OFF  AND  *IN34 = *OFF  AND
     C                             *IN36 = *OFF  AND  *IN37 = *OFF  AND
     C                             *IN38 = *OFF
     C                   MOVEL     #3CUST        KCNUM
     C                   MOVE      #3LNRF        KLNRF
     C                   MOVE      #3FFAC        KFACL
     C                   MOVE      #3FFES        KFESQ
     C                   MOVE      #3FISC        KISCN
 
      ** Check if fee record exists in the system (LEFEED)
 
     C     KFEED1        CHAIN     LEFEEDL1
 
     C                   IF        NOT %FOUND(LEFEEDL1)
     C                   EVAL      *IN34 = *ON
     C                   EVAL      *IN37 = *ON
     C                   IF        #3FFAC <> *BLANKS
     C                   EVAL      *IN36 = *ON
     C                   ELSE
     C                   EVAL      *IN33 = *ON
     C                   ENDIF
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdArr(Idx) = 'LEI0015'
 
     C                   ELSE
 
      ** Save Fee's branch for use in insert later
 
     C                   EVAL      WBranch = FEBRCA
 
     C     KFEESFUL      CHAIN     LETISPL1
 
      ** For amd/del, there must be an existing live record
 
     C                   IF        NOT %FOUND(LETISPL1)  AND  #3ACTN = 'A'  OR
     C                             NOT %FOUND(LETISPL1)  AND  #3ACTN = 'D'
     C                   EVAL      *IN28 = *ON
     C                   EVAL      *IN31 = *ON
     C                   IF        #3FFAC <> *BLANKS
     C                   EVAL      *IN29 = *ON
     C                   ELSE
     C                   EVAL      *IN30 = *ON
     C                   ENDIF
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdArr(Idx) = 'LEI0004'
     C                   ENDIF
 
      ** For insert, there must be no existing live record
 
     C                   IF        %FOUND(LETISPL1)  AND  #3ACTN = 'I'
     C                   EVAL      *IN28 = *ON
     C                   EVAL      *IN31 = *ON
     C                   EVAL      *IN38 = *ON
     C                   IF        #3FFAC <> *BLANKS
     C                   EVAL      *IN29 = *ON
     C                   ELSE
     C                   EVAL      *IN30 = *ON
     C                   ENDIF
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdArr(Idx) = 'LEI0003'
     C                   ENDIF
 
      ** Save income percentage allocation for calculations later
 
     C                   EVAL      WFilIPAL = *ZERO
     C                   IF        %FOUND(LETISPL1) AND #3ACTN = 'A'
     C                   EVAL      WFilIPAL = IPAL
     C                   ENDIF
 
      ** For insert, check if record exists but already deleted;
      ** if yes, set flag to replace these records
 
     C                   IF        NOT %FOUND(LETISPL1)  AND  #3ACTN = 'I'
     C     KFEESFUL      CHAIN     LETISPL4
     C                   IF        %FOUND(LETISPL4)
     C                   EVAL      WReplace = 'Y'
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
      ** Get total income percent allocation
 
     C                   IF        *IN33 = *OFF  AND  *IN34 = *OFF  AND
     C                             *IN36 = *OFF  AND  *IN37 = *OFF  AND
     C                             *IN38 = *OFF
     C     KFEESPAR      SETLL     LETISPL1
     C     KFEESPAR      READE     LETISPL1                               01
     C                   EVAL      WTotAlloc = *ZERO
     C                   DOW       EndOfFile = *OFF
     C                   EVAL      WTotAlloc = WTotAlloc + IPAL
     C     KFEESPAR      READE     LETISPL1                               01
     C                   ENDDO
 
      ** Validate income percentage allocation
 
     C                   IF        #3ACTN <> 'D'
     C                   EVAL      WScnIPAL = #3FIPA
     C                   EXSR      SRValIPA
     C                   EVAL      #3FIPA = WScnIPAL
     C                   IF        WIPALErr = 'Y'
     C                   EVAL      *IN39 = *ON
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
      ** Set error flag
     C                   IF        Idx > 0
     C                   EVAL      WError  = 'Y'
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRValCust - Validate customer
      *****************************************************************
     C     SRValCust     BEGSR
 
      ** Validate customer number
 
     C                   IF        PCustomer = *BLANKS
     C                   EVAL      WCustErr = 'Y'
     C                   ELSE
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY   '     POptn
     C                   PARM                    PCustomer
     C                   PARM      *BLANKS       PKyst
     C     SDCUST        PARM      *BLANKS       DSSDY
 
     C                   IF        PRtCd <> *BLANKS AND
     C                             PRtCd <> '*NRF   ' AND
     C                             PRtCd <> '*KEY   ' AND
     C                             PRtCd <> '*NOSEL '
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDCUSTPD'
     C                   EVAL      DBKEY = PCustomer
     C                   EVAL      DBASE = 1
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
 
     C                   IF        PRtCd = *BLANKS
     C                   EVAL      WCustErr = 'N'
     C                   ELSE
     C                   EVAL      WCustErr = 'Y'
     C                   ENDIF
     C                   ENDIF
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRValIPA - Validate income percentage allocation
      *****************************************************************
     C     SRValIPA      BEGSR
 
     C                   EVAL      WIPALErr = 'N'
 
     C                   IF        WScnIPAL = *BLANKS
     C                   EVAL      WIPALErr = 'Y'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdArr(Idx) = 'LEI0008'
 
     C                   ELSE
     C                   MOVE      *BLANKS       ZFLD16
     C                   MOVEL     WScnIPAL      ZFLD16
     C                   Z-ADD     9             ZSDEC
     C                   Z-ADD     3             ZSDIG
 
     C                   CALLB     'ZALIGN'
     C                   PARM                    ZAlignOk
     C                   PARM                    ZFLD16
     C                   PARM                    ZSDEC
     C                   PARM                    ZSDIG
 
     C                   EVAL      WrkIPAL = *ZERO
     C                   MOVE      ZFLD16        WrkIPAL
 
     C                   IF        ZAlignOk = 'N' OR
     C                             WrkIPAL = *ZERO
     C                   EVAL      WIPALErr = 'Y'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdArr(Idx) = 'LEI0008'
 
     C                   ELSE
 
     C                   MOVE      *BLANKS       ZField
     C                   MOVE      ZFLD16        ZField
     C                   EVAL      ZADEC = 9
     C                   EXSR      SRZEdit
 
     C                   MOVE      ZField        WScnIPAL
     C                   ENDIF
 
      ** Total income percentage allocation must not exceed 100%
 
     C                   IF        WIPALErr = 'N'
     C                   IF        #3ACTN = 'I'
     C                   EVAL      WTotAlloc = WTotAlloc + WrkIPAL
 
     C                   ELSE
     C                   EVAL      WTotAlloc = WTotAlloc - WFilIPAL
     C                   EVAL      WTotAlloc = WTotAlloc + WrkIPAL
     C                   ENDIF
 
     C                   IF        WTotAlloc > 100
     C                   EVAL      WIPALErr = 'Y'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdArr(Idx) = 'LEI0012'
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRUpdFile - Update file
      *****************************************************************
     C     SRUpdFile     BEGSR
 
      ** Update LETISPPD depending on action code
 
     C                   SELECT
     C                   WHEN      #3ACTN = 'I'
 
     C                   IF        WReplace = 'Y'
     C                   EXSR      SRReplace
     C                   ENDIF
 
     C                   EXSR      SRInsertRec
 
     C                   WHEN      #3ACTN = 'A'
     C                   EXSR      SRAmendRec
 
     C                   WHEN      #3ACTN = 'D'
     C                   EXSR      SRDeleteRec
 
     C                   ENDSL
 
      ** Delete invalid record
 
     C                   MOVE      #1REPN        KREPN
     C     KREPN         CHAIN     LEITISLZ
 
     C                   IF        %FOUND(LEITISLZ)
     C                   DELETE    LEITISLZ
     C                   ENDIF
 
     C                   IF        WSupSys = 'Y'
     C                   EXSR      LOG247
     C                   EXSR      APLGTR
     C                   EXSR      LOGDEL
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRInsertRec - Insert repaired record to LETISPPD
      *****************************************************************
     C     SRInsertRec   BEGSR
 
     C                   EVAL      RECI = 'D'
     C                   MOVE      #3LNRF        LNRF
 
     C                   MOVE      *BLANKS       ZFLD16
     C                   IF        POption = 'L'
     C**********         EVAL      CNUM = *ZERO                                              CSD027A
     C                   EVAL      CNUM = *BLANKS                                            CSD027A
     C                   EVAL      FACL = *ZERO
     C                   EVAL      FESQ = *ZERO
     C                   MOVEL     #3CUST        ISCN
     C                   MOVEL     #3LIPA        ZFLD16
     C                   ELSE
     C                   MOVEL     #3CUST        CNUM
     C                   MOVE      #3FFAC        FACL
     C                   MOVE      #3FFES        FESQ
     C                   MOVEL     #3FISC        ISCN
     C                   MOVEL     #3FIPA        ZFLD16
     C                   ENDIF
     C                   Z-ADD     9             ZSDEC
     C                   Z-ADD     3             ZSDIG
 
     C                   CALLB     'ZALIGN'
     C                   PARM                    ZAlignOk
     C                   PARM                    ZFLD16
     C                   PARM                    ZSDEC
     C                   PARM                    ZSDIG
 
     C                   MOVE      ZFLD16        IPAL
 
     C                   EVAL      LCD = BJRDNB
     C                   EVAL      CHTP = 'I'
     C                   EVAL      PCRF = #1PCRF
     C                   EVAL      PPCR = #1PPCR
     C                   EVAL      BRCA = WBranch
     C                   EVAL      PBranch = WBranch
 
      ** Access Branch Code Details
 
     C                   CALL      'AOBRCHR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY   '     POptn
     C                   PARM                    PBranch
     C     SDBRCH        PARM      SDBRCH        DSFDY
 
     C                   IF        PRtCd <> *BLANKS  AND
     C                             PRtCd <> '*NRF   '
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDBRCHPD'
     C                   EVAL      DBKEY  = PBranch
     C                   EVAL      DBASE  = 2
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   WRITE     LETISP0
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRAmendRec - Amend repaired record in LETISPPD
      *****************************************************************
     C     SRAmendRec    BEGSR
 
     C                   MOVE      *BLANKS       ZFLD16
 
      ** LOAN
 
     C                   IF        POption = 'L'
     C                   MOVE      #3LNRF        KLNRF
     C                   MOVEL     #3CUST        KISCN
     C     KLOANFUL      CHAIN     LETISPL0
 
     C                   MOVEL     #3LIPA        ZFLD16
     C                   ELSE
 
      ** FEE
 
     C                   MOVEL     #3CUST        KCNUM
     C                   MOVE      #3LNRF        KLNRF
     C                   MOVE      #3FFAC        KFACL
     C                   MOVE      #3FFES        KFESQ
     C                   MOVEL     #3FISC        KISCN
     C     KFEESFUL      CHAIN     LETISPL1
 
     C                   MOVEL     #3FIPA        ZFLD16
     C                   ENDIF
 
      ** Update record if found
 
     C                   Z-ADD     9             ZSDEC
     C                   Z-ADD     3             ZSDIG
 
     C                   CALLB     'ZALIGN'
     C                   PARM                    ZAlignOk
     C                   PARM                    ZFLD16
     C                   PARM                    ZSDEC
     C                   PARM                    ZSDIG
 
     C                   MOVE      ZFLD16        IPAL
     C                   EVAL      LCD = BJRDNB
     C                   EVAL      CHTP = 'A'
 
     C                   IF        POption = 'L'
     C                   UPDATE    LETISP0
     C                   ELSE
     C                   UPDATE    LETISP1
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRDeleteRec - Delete record in LETISPPD
      *****************************************************************
     C     SRDeleteRec   BEGSR
 
      ** LOAN
 
     C                   IF        POption = 'L'
     C                   MOVE      #3LNRF        KLNRF
     C                   MOVEL     #3CUST        KISCN
     C     KLOANFUL      CHAIN     LETISPL0
     C                   ENDIF
 
      ** FEE
 
     C                   IF        POption = 'F'
     C                   MOVEL     #3CUST        KCNUM
     C                   MOVE      #3LNRF        KLNRF
     C                   MOVE      #3FFAC        KFACL
     C                   MOVE      #3FFES        KFESQ
     C                   MOVEL     #3FISC        KISCN
     C     KFEESFUL      CHAIN     LETISPL1
     C                   ENDIF
 
     C                   EVAL      RECI = 'R'
     C                   EVAL      LCD = BJRDNB
     C                   EVAL      CHTP = 'D'
 
     C                   IF        POption = 'L'
     C                   UPDATE    LETISP0
     C                   ENDIF
 
     C                   IF        POption = 'F'
     C                   UPDATE    LETISP1
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRReplace - Physically delete records from LETISPPD
      *****************************************************************
     C     SRReplace     BEGSR
 
      ** LOAN
 
     C                   IF        POption = 'L'
     C                   MOVE      #3LNRF        KLNRF
     C                   MOVE      #3CUST        KISCN
 
     C     KLOANFUL      CHAIN     LETISPL3
 
      ** Delete record for loan so another may be inserted
 
     C                   IF        %FOUND(LETISPL3) AND
     C                             RECI = 'R'
     C                   DELETE    LETISPL3
     C                   ENDIF
     C                   ENDIF
 
      ** FEE
 
     C                   IF        POption = 'F'
     C                   MOVEL     #3CUST        KCNUM
     C                   MOVE      #3LNRF        KLNRF
     C                   MOVE      #3FFAC        KFACL
     C                   MOVE      #3FFES        KFESQ
     C                   MOVE      #3FISC        KISCN
 
      ** Delete record for Fee so another may be inserted
 
     C     KFEESFUL      CHAIN     LETISPL4
 
     C                   IF        %FOUND(LETISPL4) AND
     C                             RECI = 'R'
     C                   DELETE    LETISPL4
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * LOGDEL - Delete record from 24x7 Midas Availability Log
      *****************************************************************
     C     LOGDEL        BEGSR
 
     C                   EVAL      WMsgType = 'LE' + 'TISP'
     C                   EVAL      WFrOffId = PCRF
     C                   MOVE      #1TMST        WTimeStamp
 
     C                   OPEN      APILOGL0
 
     C     KAPILOG       CHAIN     APILOG0
 
     C                   IF        %FOUND(APILOGL0)
     C                   DELETE    APILOG0
     C                   ENDIF
 
     C                   CLOSE     APILOGL0
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * LOG247 - Convert fields to the 24x7 Midas Availability Log
      *****************************************************************
     C     LOG247        BEGSR
 
     C                   EVAL      I1MSGT = *BLANKS
     C                   EVAL      I1TRUS = *BLANKS
     C                   EVAL      I1TRWS = *BLANKS
     C                   EVAL      I1TNRF = *BLANKS
     C                   EVAL      I1TRSN = *BLANKS
     C                   EVAL      I1ACTN = *BLANKS
     C                   EVAL      I1TRDS = *BLANKS
     C                   EVAL      I1TRTS = *BLANKS
     C                   EVAL      I1NRBA = *ZERO
 
     C                   MOVE      #3LNRF        I1LNRF
     C                   MOVE      #3FFAC        I1FACL
     C                   MOVE      #3FFES        I1FESQ
 
     C                   IF        POption = 'L'
     C                   MOVEL     *BLANK        I1CNUM
     C                   MOVEL     #3CUST        I1ISCN
     C                   MOVEL     #3LIPA        I1IPAL
     C                   ELSE
     C                   MOVEL     #3CUST        I1CNUM
     C                   MOVEL     #3FISC        I1ISCN
     C                   MOVEL     #3FIPA        I1IPAL
     C                   ENDIF
 
     C                   EVAL      I1PCRF = *BLANKS
     C                   EVAL      I1PPCR = *BLANKS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * APLGTR - Write transaction to 24x7 Midas Availability Log
      *****************************************************************
     C     APLGTR        BEGSR
 
     C                   EVAL      APTRAN = I1MFPD
     C                   EVAL      APMTYP = 'LE' + 'TISP'
     C                   EVAL      APSOFC = PCRF
 
      ** Generate timestamp
 
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    WrkTMST
 
     C                   MOVE      WrkTMST       APSTMS
 
     C                   OPEN      APVLOGPD
     C                   WRITE     APVLOGD0
     C                   CLOSE     APVLOGPD
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRClrMsg - Clear message subfile and data
      *****************************************************************
     C     SRClrMsg      BEGSR
 
     C                   CLEAR                   MsgIdArr
     C                   CLEAR                   MsgDtaArr
     C                   CLEAR                   FldNameArr
 
      ** Clear message subfile
 
     C                   CALL      'ZA0250'
 
      ** Reset error indicators
 
     C                   EVAL      ErrSelOpt = *OFF
     C                   EVAL      *IN31 = *OFF
     C                   EVAL      *IN32 = *OFF
     C                   EVAL      *IN33 = *OFF
     C                   EVAL      *IN34 = *OFF
     C                   EVAL      *IN35 = *OFF
     C                   EVAL      *IN36 = *OFF
     C                   EVAL      *IN37 = *OFF
     C                   EVAL      *IN38 = *OFF
     C                   EVAL      *IN39 = *OFF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRZEdit - Format fields
      *****************************************************************
     C     SRZEdit       BEGSR
 
     C                   CALLB     'ZEDIT'
     C                   PARM                    ZField
     C                   PARM                    ZADEC
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRFmtDet - Format details for output
      *****************************************************************
     C     SRFmtDet      BEGSR
 
     C                   EVAL      #1SEL = *BLANK
     C                   EVAL      #1DETL = *BLANK
     C                   CLEAR                   WLoanDetl
     C                   CLEAR                   WFeesDetl
 
     C                   IF        POption = 'L'
     C                   MOVE      SNLON         WLLNRF
     C                   MOVE      SACTN         WLACTN
     C                   MOVE      SISCN         WLCNUM
     C                   MOVE      SIPAL         WLIPAL
     C                   MOVEL     WLoanDetl     #1DETL
     C                   ELSE
 
     C                   MOVE      SNCUS         WFCNUM
     C**********         IF        SNLON <> *ZERO                                             CLE148
     C                   IF        SNLON <> *BLANKS                                           CLE148
     C                   MOVE      SNLON         WFLNFC
     C                   ELSE
     C                   MOVE      SFACL         WFLNFC
     C                   ENDIF
     C                   MOVE      SFESQ         WFFESQ
     C                   MOVE      SACTN         WFACTN
     C                   MOVE      SISCN         WFISCN
     C                   MOVE      SIPAL         WFIPAL
     C                   MOVEL     WFeesDetl     #1DETL
     C                   ENDIF
 
      ** Hidden Details
     C                   MOVE      XREPN         #1REPN
     C                   MOVE      XMSID         #1MSID
     C                   MOVE      STMST         #1TMST
     C                   MOVE      SPCRF         #1PCRF
     C                   MOVE      SPPRF         #1PPCR
 
     C                   ENDSR
      ******************************************************************
      /EJECT
      *****************************************************************
      * SRSndMsg - Send message to subfile
      *****************************************************************
     C     SRSndMsg      BEGSR
 
      ** Send message to subfile
 
     C                   EVAL      Idx = 1
     C                   DOW       MsgIdArr(Idx) <> *BLANKS
     C                   CALL      'ZA0350'
     C                   PARM                    PMsgFile
     C                   PARM      MsgIdArr(Idx) PMsgId
     C                   PARM      *BLANKS       PMsgData
     C                   EVAL      Idx = Idx + 1
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRInit - Initial processing
      *****************************************************************
     C     SRInit        BEGSR
 
      ** Entry parameters
     C     *ENTRY        PLIST
 
      ** Input: Option ('F'ee or 'L'oan)
     C                   PARM                    POption
 
      ** Determine if switchable feature CSC011 is switched on
 
     C                   EVAL      CSC011 = 'N'
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'CSC011'      PSard
     C     SCSARD        PARM      SCSARD        DSFDY
 
      ** Database error
 
     C                   IF        (PRtCd <> *BLANKS) AND
     C                             (PRtCd <> '*NRF   ')
     C                   EVAL      DBKEY = 'CSC011'
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE = 3
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        PRtCd = *BLANKS
     C                   EVAL      CSC011 = 'Y'
     C                   IN        SDSTAT
     C                   IN        SC24X7
     C                   ENDIF
 
     C                   IF        CSC011 = *ON AND
     C                             S1SUPP = LIBR
     C                   EVAL      WSupSys = 'Y'
     C                   ELSE
     C                   EVAL      WSupSys = 'N'
     C                   ENDIF
 
      ** Setup correct header in screen
 
     C                   EVAL      *IN21 = *ON
     C                   IF        POption <> 'L'
     C                   EVAL      *IN21 = *OFF
     C                   ENDIF
 
      ** Key list for LEITISLX (full)
 
     C     KLOANFUL      KLIST
     C                   KFLD                    KLNRF
     C                   KFLD                    KISCN
 
      ** Key list for LEITISLY (full)
 
     C     KFEESFUL      KLIST
     C                   KFLD                    KCNUM
     C                   KFLD                    KLNRF
     C                   KFLD                    KFACL
     C                   KFLD                    KFESQ
     C                   KFLD                    KISCN
 
      ** Key list for LEITISLY (partial)
 
     C     KFEESPAR      KLIST
     C                   KFLD                    KCNUM
     C                   KFLD                    KLNRF
     C                   KFLD                    KFACL
     C                   KFLD                    KFESQ
 
      ** Key list for FCLTYL0
 
     C     KFCLT0        KLIST
     C                   KFLD                    KCNUM
     C                   KFLD                    KFACT
     C                   KFLD                    KFCNO
 
      ** Key list for LEFEEDL1
 
     C     KFEED1        KLIST
     C                   KFLD                    KCNUM
     C                   KFLD                    KFACL
     C                   KFLD                    KLNRF
     C                   KFLD                    KFESQ
 
      ** First key list for LETISPL1 (complete keys)
 
     C     KTISP1A       KLIST
     C                   KFLD                    KCNUM
     C                   KFLD                    KLNRF
     C                   KFLD                    KFACL
     C                   KFLD                    KFESQ
     C                   KFLD                    KISCN
 
      ** Second key list for LETISPL1 (partial keys)
 
     C     KTISP1B       KLIST
     C                   KFLD                    KCNUM
     C                   KFLD                    KLNRF
     C                   KFLD                    KFACL
     C                   KFLD                    KFESQ
 
      ** API Invalid Log File Key List
 
     C     KAPILOG       KLIST
     C                   KFLD                    WMsgType
     C                   KFLD                    WFrOffId
     C                   KFLD                    WTimeStamp
 
      ** Access bank details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database error
 
     C                   IF        PRtcd <> *BLANK
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE= 'SDBANKPD'
     C                   EVAL      DBKEY = POptn
     C                   EVAL      DBASE = 4
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Initialize program name
 
     C                   EVAL      DBPGM = 'LE2081'
 
      ** Move workstation ID to screen field
 
     C                   EVAL      #0WSID = PsJobName
     C                   EVAL      #0USER = PsUser
     C                   EVAL      #0RUNA = BJMRDT
 
     C                   EVAL      #2PGMQ = '*'
 
     C                   EVAL      ResetSbFl = 'Y'
     C                   EVAL      WScrn = '1'
 
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
**  CPY@
(c) Finastra International Limited 2003
