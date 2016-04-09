     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Beneficial Owner Details')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data module                                 *
      *                                                               *
      *  SD0378 - Beneficial Owner Details                            *
      *                                                               *
      *  Function:  This module maintains the details of underlying   *
      *             beneficial holders, where the holders can be      *
      *             seen to own a percentage of the shares, then the  *
      *             percentage of the holding may be entered, to      *
      *             allow the same split to be used for dividends/    *
      *             coupon payments.                                  *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      *  Last Amend No. CSD079             Date 05Feb07               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD031             Date 10Apr06               *
      *                 BUG3644            Date 12Jul04               *
      *                 BUG3122            Date 17Jul04               *
      *                 CGP001             Date 18Dec03               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CSE022             Date 29Mar01               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 186054             Date 08Nov00               *
      *                 185994             Date 08Nov00               *
      *                 185255             Date 20Oct00               *
      *                 CSE024  *CREATE    Date 12Jul00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD079 - Enhanced Customer Maintenance API (Recompile)       *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  BUG3644 - Serious Error in Collateralised Lending (Recompile)*
      *  BUG3122 - Recompiled due to changes in SDSECSPD.             *
      *  CGP001 - Global Processing (Recompile)                       *
      *  CSE022 - Depository Definition Enhancement                   *
      *  186054 - Exemption Code should be optional if documentation  *
      *           received is not 'E'                                 *
      *  185994 - Additional validation on Country of Residence and   *
      *           Documentation receive.                              *
      *  185255 - Documentation Received for Beneficial Owner cannot  *
      *           equal to 'I'.                                       *
      *  CSE024 - Withholding Tax - Sub account processing            *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    02         Read/Chain indicator                            *
      *    03         Record not found for CHAIN of SDFCTLL0          *
      *    19-22      Error indicator                                 *
      *    27-35      Error indicator                                 *
      *    70         Read change indicator for subfile               *
      *    71         Subfile end                                     *
      *    72         Subfile next change                             *
      *    73         Subfile display                                 *
      *    74         Subfile clear                                   *
      *    75         Rollup pressed                                  *
      *    76         Subfile message control indicator               *
      *    80         Protect screen fields                           *
      *    81         Protect on Beneficial owner number field        *
      *    82         Enquiry mode, PMODE is 'E'                      *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * *PSSR        - Error processing                               *
      * *INZSR       - Initialise                                     *
      *  SRFirst      - Process first screen                          *
      *  SRSecond     - Process second screen                         *
      *  SRReview     - Build and Read subfile                        *
      *  SRBldSfl     - Build subfile                                 *
      *  SRRdSflR     - Read Subfile Record                           *
      *  SRBldPag     - Build Subfile Page                            *
      *  SRRdBenOw    - Read Beneficial Owner details                 *
      *  SRFmtDet     - Format fields for subfile display             *
      *  SRRtvBenOw   - Retrieve Beneficial Owner details             *
      *  SRUpdate     - Update beneficial owners file                 *
      *  SRCkPct      - Checks Total percentage holding for customer  *
      *  SRVCNUM      - Validate Customer number                      *
      *  SRVCTTX      - Validate Country of tax treaty                *
      *  SRVDPTN      - Validate Depot                                *
      *  SRVScn2Det   - Validate second screen details                *
      *  SRVBenefDet  - Validate beneficial owner detail              *
      *  SRVDCRC      - Validate Documentation Receive                *
      *  SRVBCWA      - Validate Backup Withholding                   *
      *  SRVEXCD      - Validate Exemption code                       *
      *  SRVCTRS      - Validate country of residence                 *
      *  SRVTXBS      - Validate tax basket                           *
      *  SRVRPCD      - Validate Recipient Code                       *
      *  SRVPAHD      - Validate Percentage Allocation of holding     *
      *  SRVDFRD      - Validate Default Beneficial Owner for rounding*
      *  SRFmtPct     - Format amount for display using ZEDIT         *
      *  SRSndM       - Handles the display of error messages         *
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
      ** Beneficial owner details display file.
     FSD0378DF  CF   E             WORKSTN INFSR(*PSSR)
     F                                     SFILE(SD0378S0:W_Rrn)
      *
      ** Withholding tax customer details - retrieve
     FSDWTCSL1  IF   E           K DISK    INFSR(*PSSR)
      *
      ** Beneficial owner details - retrieve
     FSDBNFOL1  IF   E           K DISK    INFSR(*PSSR)
      *
      ** Beneficial owner details - update
     FSDBNFOL0  UF A E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
     F                                     RENAME(SDBNFOD0:@BNFOL0)
      *
      ** Standing data controls by filename - update
     FSDFCTLL0  UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
      *
      ** Tax basket - retrieve
     FSDTXBSL1  IF   E           K DISK    INFSR(*PSSR)
      *
      ** Exemption code - retrieve
     FSDEXEML1  IF   E           K DISK    INFSR(*PSSR)
      *
      ** Recipient code - retrieve
     FSDRPCDL1  IF   E           K DISK    INFSR(*PSSR)
 
      *****************************************************************
      /EJECT
      *****************************************************************
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
      **                                    184 193 DBMOD
      **                                    194 203 DBPROC
      *
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
      *
      ** Program Status Data Structure
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
     D DIGITS          C                   '0123456789'
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
      ** Array containing copyright statement
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      *
      ** DS for current second screen details
     D WCurDet2        DS
     D  SBONO                  1     20
     D  SBONM                 21     55
     D  SBOA1                 56     90
     D  SBOA2                 91    125
     D  SBOA3                126    160
     D  SDCRC                161    161
     D  SBCWA                162    162
     D  SEXCD                163    164
     D  SCTRS                165    166
     D  STXID                167    186
     D  STXBS                187    188
     D  SRPCD                189    190
     D  SPAHD                191    197
     D  SDFRD                198    198
      *
      ** DS for previous second screen details
     D WPrevDet2       DS
     D  WPrBONO                1     20
     D  WPrBONM               21     55
     D  WPrBOA1               56     90
     D  WPrBOA2               91    125
     D  WPrBOA3              126    160
     D  WPrDCRC              161    161
     D  WPrBCWA              162    162
     D  WPrEXCD              163    164
     D  WPrCTRS              165    166
     D  WPrTXID              167    186
     D  WPrTXBS              187    188
     D  WPrRPCD              189    190
     D  WPrPAHD              191    197
     D  WPrDfrd              198    198
      *
      ** Externally described DS for New detail file retrieved
     D WNewDet       E DS                  EXTNAME(SDBNFOPD)
      *
      ** Externally described DS for Old detail file retrieved
     D WOldDet       E DS                  EXTNAME(SDBNFOPD)
     D                                     PREFIX(O)
      *
      ** Externally described DS for bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      ** Externally described DS for securities client
     D SDSECS        E DS                  EXTNAME(SDSECSPD)
      *
      ** Externally described DS for country codes
     D SDCTRY        E DS                  EXTNAME(SDCTRYPD)
      *
      ** DS for access objects - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D WRun            S              1
      *
      ** Work variables
     D WAction         S              1A   INZ(*BLANK)
     D WScrn           S              1A   INZ('P')
     D WPrevScrn       S              1A   INZ(' ')
     D WBldPag         S              1A   INZ('N')
     D WRbldSf         S              1A   INZ('Y')
     D Wchange         S              1A   INZ('N')
     D WBdSfl          S              1A
     D WRdSfl          S              1A
     D WChkDR          S              1A
     D WDFRDSw         S              1A
     D WExit           S              1A
     D WBONO           S             20A
     D W_Cnt           S              3P 0
     D WError          S              1A
     D WPAHd           S              6S 4
     D WTotPal         S              7S 4
     D WLRcd           S              4S 0
     D WLCnum          S              6A
     D WLCttx          S              2A
     D WLDptn          S              6A
     D WLBono          S             26A
     D @@EOF           S              1A
     D N               S              2S 0
     D X               S              2S 0
      *
      ** Work parameters
     D ZAlignok        S              1A
     D ZADec           S              1P 0
     D ZADig           S              2P 0
     D PCrtt           S              2A
     D PCust           S              6A
     D PRtCd           S              7A
     D POptn           S              7A
     D P_MsgFile       S             10A
     D P_MsgID         S             10A
     D ZField          S             16A
      *
      ** Work key fields
     D KCNUM           S              6A
     D KCTTX           S              2A
     D KDPTN           S              6A
     D KBONO           S             26A
     D KEXCD           S              2A
     D KTXBS           S              2A
     D KRPCD           S              2A
     D KFLNM           S             10A
 
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
 
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
      *
      ** Process initial screen
      *
     C                   IF        WScrn = 'P'
     C                   EXSR      SRFirst
     C                   ENDIF
      *
      ** Process second screen
      *
     C                   IF        WScrn = 'S'
     C                   EXSR      SRSecond
     C                   ENDIF
      *
      ** Process review screen
      *
     C                   IF        WScrn = 'R'
     C                   EXSR      SRReview
     C                   ENDIF
      *
      ** Terminate program
      *
     C                   IF        WScrn = 'T'
     C                   EVAL      *INLR = *On
     C                   RETURN
     C                   ENDIF
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRFirst - Process first screen                               *
      *                                                               *
      *****************************************************************
     C     SRFirst       BEGSR
      *
      ** Write first screen detail
      *
     C                   WRITE     SD0378F0
     C                   WRITE     SD0378C1
     C                   EXFMT     SD0378D0
      *
      ** Clear message subfile.
      *
     C                   CALL      'ZA0250'
     C                   EVAL      WError = 'N'
      *
      ** Set screen error indicators off.
      *
     C                   MOVEA     '0000'        *IN(19)
     C                   MOVEA     '000000000'   *IN(27)
      *
      ** F3 - end program.
      *
     C                   IF        *INKC
     C                   EVAL      WScrn = 'T'
      *
      ** F9/Enter key - validate first screen entries.
      *
     C                   ELSE
      *
      ** Validate Customer number
      *
     C                   EXSR      SRVCNUM
      *
      ** Validate Country of tax treaty
      *
     C                   EXSR      SRVCTTX
      *
      ** Validate Depot
      *
     C                   EXSR      SRVDPTN
      *
      ** Display first screen while there's an error
      *
     C                   IF        *IN20 OR *IN21 OR *IN19
     C                   EVAL      WScrn = 'P'
     C                   ELSE
      *
      ** If F9 was pressed move on to the second screen. Otherwise, move on
      ** to the review screen.
      *
     C                   IF        *INKI = *ON
     C                   EVAL      WPrevScrn = WScrn
     C                   EVAL      WAction = 'I'
     C                   EVAL      WScrn = 'S'
     C                   CLEAR                   WCurDet2
     C                   CLEAR                   WPrevDet2
     C                   ELSE
     C                   EVAL      WPrevScrn = WScrn
     C                   EVAL      WScrn = 'R'
     C                   EVAL      WAction = *BLANK
     C                   EVAL      WRDSfl = 'N'
     C                   EVAL      WBDSfl = 'Y'
     C                   EVAL      WRbldSf = 'Y'
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSecond - Process second screen                             *
      *                                                               *
      *****************************************************************
     C     SRSecond      BEGSR
      *
      ** Write second screen detail
      *
      *
     C                   SELECT
      *
     C                   WHEN      WAction = 'E' OR
     C                             WAction = 'D'
     C                   EVAL      *IN80 = *ON
      *
     C                   WHEN      WAction = 'A'
     C                   EVAL      *IN80 = *OFF
     C                   EVAL      *IN81 = *ON
      *
     C                   WHEN      WAction = 'I'
     C                   EVAL      *IN80 = *OFF
     C                   EVAL      *IN81 = *OFF
      *
     C                   ENDSL
      *
     C                   WRITE     SD0378F1
     C                   WRITE     SD0378C1
     C                   EXFMT     SD0378D1
      *
      ** Clear message subfile.
      *
     C                   CALL      'ZA0250'
     C                   EVAL      WError = 'N'
      *
      ** Set screen error indicators off.
      *
     C                   MOVEA     '0000'        *IN(19)
     C                   MOVEA     '000000000'   *IN(27)
 
     C                   SELECT
      *
      ** F3 - Check if total percentage is less than 100
      *
     C                   WHEN      *INKC = *ON
      *
      ** Check total percentage only if in maintenance screen
      *
     C                   IF        PMODE = 'M'
     C                   EXSR      SRCKPct
     C                   ENDIF
      *
      ** Display initial screen if total percentage is less than 100
      ** only if in maintenance screen, otherwise, exit the program
      *
     C                   IF        WError = 'Y' AND PMODE = 'M'
     C                   EVAL      WScrn = 'P'
     C                   ELSE
     C                   EVAL      WScrn = 'T'
     C                   ENDIF
      *
      ** F5 - refresh first screen details.
      *
     C                   WHEN      *INKE = *ON
     C                   EVAL      WCurDet2 = WPrevDet2
      *
      ** F12 - previous screen details.
      *
     C                   WHEN      *INKL = *ON
     C                   EVAL      WScrn = WPrevScrn
      *
     C                   IF        WScrn = 'R'
      *
     C                   IF        WChange = 'Y'
     C                   EVAL      WRbldSf = 'Y'
     C                   ELSE
     C                   EVAL      WRbldSf = 'N'
     C                   ENDIF
      *
     C                   ELSE
     C                   IF        PMODE = 'M'
     C                   EXSR      SRCKPct
     C                   ENDIF
     C                   ENDIF
      *
      ** Enter key was pressed, validate second screen entries.
      *
     C                   OTHER
      *
      ** Validate second screen details if insert or amend action
      *
     C                   IF        WAction = 'I' or WAction = 'A'
     C                   EXSR      SRVScn2Det
     C                   ENDIF
      *
      ** Update Beneficial Owner detail file if all fields are valid
      *
     C                   IF        Werror  = 'N'
     C                   IF        WAction <> 'E'
     C                   EXSR      SRUpdate
     C                   IF        WError = 'N'
     C                   CLEAR                   WCurDet2
     C                   ENDIF
     C                   ENDIF
      *
     C                   IF        WAction = 'I'
     C                   EVAL      WScrn = 'S'
     C                   ELSE
     C                   EVAL      WScrn = 'R'
     C                   EVAL      WRbldSf = 'Y'
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSL
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRReview - Build and Read subfile                            *
      *                                                               *
      *****************************************************************
     C     SRReview      BEGSR
      *
      ** Build Sub-File
      *
     C     WBdSfl        IFEQ      'Y'
     C                   EXSR      SRBldSfl
     C                   ENDIF
      *
      ** Read Subfile Record
      *
     C     WRdSfl        IFEQ      'Y'
     C                   EXSR      SRRdSflR
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRBldSfl - Build Subfile                                     *
      *                                                               *
      *****************************************************************
     C     SRBldSfl      BEGSR
      *
      ** Build Subfile
      *
     C                   IF        WRbldSf = 'Y'
      *
      ** Initialise subfile relative record number.
      *
     C                   Z-ADD     0             W_Rrn
     C                   EVAL      *IN35 = *OFF
     C                   EVAL      Wchange = 'N'
      *
      ** Clear subfile before refilling by writing control
      ** record with SFLCLR active.
      *
     C                   EVAL      *IN74 = *ON
     C                   WRITE     SD0378C0
     C                   EVAL      *IN74 = *OFF
      *
     C                   EVAL      *IN73 = *OFF
     C                   EVAL      WTOTPAL = 0
     C                   EVAL      WLRcd = 0
      *
      ** Position record pointer to the top record.
      *
     C                   EVAL      KCNUM = SCNUM
     C                   EVAL      KCTTX = SCTTX
     C                   EVAL      KDPTN = SDPTN
      *
     C     KYBOCC        SETLL     SDBNFOL1
     C                   ENDIF
      *
      ** Set WExit = 'N' to drive initial loop.
      *
     C                   EVAL      WExit = 'N'
     C                   EVAL      WBldPag = 'N'
      *
      ** While rollup, build a subfile page
      *
     C                   DOW       WExit = 'N'
      *
     C                   IF        WRbldSf = 'Y' OR
     C                             WBldPag = 'Y'
     C                   EXSR      SRBldPag
     C                   ENDIF
      *
      ** Write screen footer for this screen.
      *
     C                   WRITE     SD0378F2
      *
      ** Write message subfile for error messages
      *
     C                   WRITE     SD0378C1
      *
      ** Write the subfile control.
      *
     C                   EXFMT     SD0378C0
      *
      ** Clear message subfile.
      *
     C                   CALL      'ZA0250'
     C                   EVAL      WError = 'N'
 
     C                   SELECT
      *
      ** F3 - end program.
      *
     C                   WHEN      *INKC = *ON
     C                   EVAL      WExit = 'Y'
      *
      ** Check total percentage only if in maintenance screen
      *
     C                   IF        PMODE = 'M'
     C                   EXSR      SRCkPct
     C                   ENDIF
      *
     C                   IF        WError = 'Y' AND PMODE = 'M'
     C                   EVAL      WScrn = 'P'
     C                   ELSE
     C                   EVAL      WScrn = 'T'
     C                   ENDIF
      *
      ** F5 - refresh screen.
      *
     C                   WHEN      *INKE = *ON
     C                   EVAL      WScrn = 'R'
     C                   EVAL      WRbldSf = 'Y'
     C                   EVAL      WBdSfl = 'Y'
     C                   EVAL      WRdSfl = 'N'
     C                   EVAL      WExit = 'Y'
      *
      ** F12 - previous screen.
      *
     C                   WHEN      *INKL = *ON
      *
      ** Check total percentage only if in maintenance screen
      *
     C                   IF        PMODE = 'M'
     C                   EXSR      SRCKPct
     C                   ENDIF
      *
     C                   EVAL      WScrn = 'P'
     C                   EVAL      WExit = 'Y'
      *
      ** F9 - goto add mode.
      *
     C                   WHEN      *INKI = *ON
     C                   EVAL      WScrn = 'S'
     C                   EVAL      WAction = 'I'
     C                   EVAL      WPrevScrn = 'R'
     C                   CLEAR                   WCurDet2
     C                   CLEAR                   WPrevDet2
     C                   EVAL      WExit = 'Y'
      *
      ** Exit this loop if any of the key pressed except for rollup
      *
     C                   WHEN      *IN75
     C                   EVAL      WBldPag = 'Y'
      *
     C                   EVAL      KCNUM = WLCnum
     C                   EVAL      KCTTX = WLCttx
     C                   EVAL      KDPTN = WLDptn
     C                   EVAL      KBONO = WLBono
     C     KYBNFO        SETLL     SDBNFOL1
      *
      ** Enter key - read subfile for option.
      *
     C                   OTHER
     C                   EVAL      WRdsfl = 'Y'
     C                   EVAL      WBdsfl = 'N'
     C                   EVAL      WExit = 'Y'
      *
     C                   ENDSL
     C                   ENDDO
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      ********************************************************************
      * SRRdSflR - Read Subfile Record
      ********************************************************************
     C     SRRdSflR      BEGSR
      *
      ** Read subfile if an option has been selected.
      *
     C                   READC     SD0378S0                               70
      *
     C                   IF        NOT *IN70
      *
     C                   EVAL      WAction = SOPTN
      *
      ** Retrieve beneficial owner details
      *
     C                   EXSR      SRRtvBenOw
      *
     C                   IF        WError = 'N'
     C                   IF        WACtion <> *BLANK
      *
     C                   EVAL      WSCRN = 'S'
     C                   EVAL      WPrevScrn = 'R'
     C                   EVAL      SOPTN = *BLANK
      *
      ** Format screen details
      *
     C                   EXSR      SRFmtDet
      *
      ** Save screen details.
      *
     C                   EVAL      WPrevDet2 = WCurDet2
     C                   ENDIF
      *
     C                   EVAL      WRBldSf = 'Y'
     C                   ELSE
      *
     C                   EVAL      WRBldSf = 'N'
     C                   ENDIF
      *
     C                   EVAL      WRDSfl = 'Y'
     C                   EVAL      WBDSfl = 'N'
      *
     C                   EVAL      *IN72 = *ON
     C                   UPDATE    SD0378S0
     C                   EVAL      *IN72 = *OFF
     C                   EVAL      *IN35 = *OFF
      *
     C                   ELSE
     C                   EVAL      WRDSfl = 'N'
     C                   EVAL      WBDSfl = 'Y'
     C                   ENDIF
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRBldPag - Build Subfile page                                *
      *                                                               *
      *****************************************************************
     C     SRBldPag      BEGSR
      *
      ** Initialise count of records written to subfile page.
      *
     C                   Z-ADD     0             W_Cnt
     C                   Z-Add     WLrcd         W_Rrn
      *
      ** Read through Beneficial owner details.
      *
     C                   EXSR      SRRdBenOw
      *
      ** If no record was read, send an error message "No Beneficial Owners
      ** to display".
      *
     C                   IF        @@EOF = 'Y'  AND WLrcd = *ZERO
     C                   EVAL      WScrn = 'P'
     C                   IF        PMODE = 'M'
     C                   EVAL      P_MsgID = 'USR7704'
     C                   ELSE
     C                   EVAL      P_MsgID = 'USR7715'
     C                   ENDIF
     C                   EXSR      SRSndM
     C                   ENDIF
      *
      ** For each record read, write it to the subfile.
      ** Do this until end of file or the subfile page is full.
      *
     C                   DOW       @@EOF <> 'Y' AND
     C                             W_Cnt < 13
      *
      ** Increment the subfile record no. and records written counter.
      *
     C                   ADD       1             W_Rrn
     C                   ADD       1             W_Cnt
     C                   EVAL      *IN73 = *ON
      *
      ** Format fields for output.
      *
     C                   EXSR      SRFmtDet
     C                   Z-ADD     BNPAHD        #SPAHD
      *
      ** Write Beneficial owner to subfile.
      *
     C                   EVAL      SOPTN = *BLANK
     C                   WRITE     SD0378S0
      *
      ** Read next beneficial owner
      *
     C                   EXSR      SRRdBenOw
 
     C                   ENDDO
      *
      ** Set the record pointer to the previous record retrieved, using
      ** READPE if not yet end of file
      *
     C                   If        @@EOF = 'N'
     C     KYBOCC        ReadPE    SDBNFOL1                               71
     C                   EndIf
      *
      ** Save last relative record number to workfield to be use when rollup
      ** is pressed
      *
     C                   Z-Add     W_Rrn         WLRcd
      *
     C                   ENDSR
      *
      ********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRdBenOw - Read Beneficial Owner details.                   *
      *                                                               *
      *****************************************************************
     C     SRRdBenOw     BEGSR
      *
      ** Read Beneficial Owners file
      *
     C                   EVAL      @@EOF = 'N'
      *
      ** Read Beneficial Owner detail file.
      *
     C     KYBOCC        READE     SDBNFOL1                               71
      *
      ** End of file
      *
     C                   IF        *IN71
     C                   EVAL      @@EOF = 'Y'
     C                   ENDIF
      *
      ** Save last record read
      *
     C                   EVAL      WLCnum = BNCNUM
     C                   EVAL      WLCttx = BNCTTX
     C                   EVAL      WLDptn = BNDEPT
     C                   EVAL      WLBono = BNBONO
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRFmtDet - Format fields for subfile display.                *
      *                                                               *
      *****************************************************************
     C     SRFmtDet      BEGSR
      *
     C                   IF        WSCRN = 'S'
     C                   CLEAR                   WCurDet2
      *
      ** Customer number
      *
     C                   EVAL      SCNUM = BNCNUM
      *
      ** Country of tax treaty
      *
     C                   EVAL      SCTTX = BNCTTX
      *
      ** Depot
      *
     C                   EVAL      SDPTN = BNDEPT
      *
      ** Beneficial Owner name
      *
     C                   EVAL      SBONM = BNBONM
      *
      ** Beneficial Owner Address 1
      *
     C                   EVAL      SBOA1 = BNBOA1
      *
      ** Beneficial Owner Address 2
      *
     C                   EVAL      SBOA2 = BNBOA2
      *
      ** Beneficial Owner Address 3
      *
     C                   EVAL      SBOA3 = BNBOA3
      *
      ** Exemption code
      *
     C                   EVAL      SEXCD = BNEXCD
      *
      ** Country of residence
      *
     C                   EVAL      SCTRS = BNCTRS
      *
      ** Tax Identification number
      *
     C                   EVAL      STXID = BNTXID
      *
      ** Tax basket
      *
     C                   EVAL      STXBS  = BNTXBS
      *
      ** Default beneficial owner for rounding
      *
     C                   EVAL      SDFRD  = BNDFRD
      *
      ** Documentation receive
      *
     C                   EVAL      SDCRC = BNDCRC
      *
      ** Backup withholding
      *
     C                   EVAL      SBCWA = BNBCWA
      *
      ** Recipient code
      *
     C                   EVAL      SRPCD = BNRPCD
     C                   ENDIF
      *
      ** Beneficial owner number
      *
     C                   MOVE      BNBONO        SBONO
      *
      ** Percentage allocation holding
      *
     C                   MOVEL     *BLANKS       ZField
     C                   MOVE      BNPAHD        ZField
     C                   Z-ADD     4             ZADec
     C                   EXSR      SRFmtPct
     C                   MOVE      ZFIELD        SPAHD
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRtvBenOw - Retrieve Beneficial Owner details.              *
      *                                                               *
      *****************************************************************
     C     SRRtvBenOw    BEGSR
      *
      ** Validate Action code
      *
     C                   EVAL      *IN35 = *OFF
     C                   SELECT
     C                   WHEN      PMODE = 'M'
     C                   IF        WAction <> 'E' AND
     C                             WAction <> 'D' AND
     C                             WAction <> 'A' AND
     C                             WAction <> *BLANKS
     C                   EVAL      *IN35 = *ON
     C                   EVAL      P_MsgID = 'USR7709'
     C                   EXSR      SRSndM
     C                   ENDIF
      *
     C                   WHEN      PMODE = 'E'
     C                   IF        WAction <> 'E' AND
     C                             WAction <> *BLANKS
     C                   EVAL      *IN35 = *ON
     C                   EVAL      P_MsgID = 'USR7710'
     C                   EXSR      SRSndM
     C                   ENDIF
      *
     C                   ENDSL
      *
     C                   IF        WError = 'N' AND
     C                             WAction <> *BLANK
     C                   EVAL      KCNUM = SCNUM
     C                   EVAL      KCTTX = SCTTX
     C                   EVAL      KDPTN = SDPTN
     C                   EVAL      KBONO = SCNUM + SBONO
      *
     C     KYBNFO        CHAIN     SDBNFOL1                           02
     C                   IF        *IN02
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = SCNUM + SCTTX + SBONO
     C                   EVAL      DBFILE = 'SDBNFOL1'
     C                   EVAL      DBASE = 001
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Issue warning msg if action is delete and beneficial owner for
      ** rounding is "Y"
      *
     C                   IF        WAction = 'D' AND
     C                             BNDFRD = 'Y'
     C                   EVAL      P_MsgID = 'USR7705'
     C                   EXSR      SRSndM
     C                   EVAL      WError = 'N'
     C                   ENDIF
      *
     C                   EVAL      WOldDet = WNewDet
     C                   ENDIF
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRUpdate - Update beneficial owners file.                    *
      *                                                               *
      *****************************************************************
     C     SRUpdate      BEGSR
      *
     C                   IF        WAction = 'A' OR WAction = 'D'
      *
     C     KYBNFO        CHAIN     @BNFOL0                            02
      *
      ** If record was not found, send "Record missing on file."
      *
     C                   IF        *IN02 = *ON
     C                   EVAL      P_MsgID = 'USR7706'
     C                   EXSR      SRSndM
     C                   ENDIF
      *
      ** If record was found but is not equal with the newly
      ** retrieved record, send "Record has been updated by another
      ** workstation.".  Otherwise, update record.
      *
     C                   IF        NOT *IN02 AND
     C                             WOldDet <> WNewDet
     C                   EVAL      P_MsgID = 'USR7707'
     C                   EXSR      SRSndM
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   IF        WError = 'N'
      *
      ** Record ID
      *
     C                   IF        SOPTN <> 'D'
      *
     C                   EVAL      BNRECI = 'D'
      *
      ** Customer number
      *
     C                   EVAL      BNCNUM = SCNUM
      *
      ** Country of tax treaty
      *
     C                   EVAL      BNCTTX = SCTTX
      *
      ** Depot
      *
     C                   EVAL      BNDEPT = SDPTN
      *
      ** Beneficial owner number
      *
     C                   EVAL      BNBONO = SCNUM + SBONO
      *
      ** Beneficial owner name
      *
     C                   EVAL      BNBONM = SBONM
      *
      ** Beneficial owner address 1
      *
     C                   MOVE      SBOA1         BNBOA1
      *
      ** Beneficial owner address 2
      *
     C                   MOVE      SBOA2         BNBOA2
      *
      ** Beneficial owner address 3
      *
     C                   MOVE      SBOA3         BNBOA3
      *
      ** Exemption code
      *
     C                   EVAL      BNEXCD = SEXCD
      *
      ** Country of residence
      *
     C                   EVAL      BNCTRS = SCTRS
      *
      ** Tax identification number
      *
     C                   EVAL      BNTXID = STXID
      *
      ** Tax basket
      *
     C                   EVAL      BNTXBS = STXBS
      *
      ** Default Beneficial owner for rounding
      *
     C                   EVAL      BNDFRD = SDFRD
      *
      ** Percentage allocation of holding
      *
     C                   EVAL      BNPAHD = WPAHD
      *
      ** Documentation receive
      *
     C                   EVAL      BNDCRC = SDCRC
      *
      ** Backup Withholding applicable
      *
     C                   EVAL      BNBCWA = SBCWA
      *
      ** Recipient Code
      *
     C                   EVAL      BNRPCD = SRPCD
     C                   ENDIF
      *
      ** Last change date
      *
     C                   EVAL      BNLCD = BJRDNB
      *
      ** If record was amended update record, if action is delete, delete
      ** record, if action is insert, write new record
      *
     C                   SELECT
      *
     C                   WHEN      WAction = 'A'
     C                   UPDATE    @BNFOL0
      *
     C                   WHEN      WAction = 'D'
     C                   DELETE    @BNFOL0
      *
     C                   WHEN      WAction = 'I'
     C                   WRITE     @BNFOL0
     C                   ENDSL
      *
      ** Update file controls
      *
     C                   EVAL      KFLNM = 'SDBNFOPD'
      *
     C     KYFLNM        CHAIN     @AHREAU                            03
     C                   IF        NOT *IN03
      *
     C                   SELECT
     C                   WHEN      WAction = 'I'
     C                   EVAL      AHNOIN = AHNOIN + 1
     C                   EVAL      AHNORC = AHNORC + 1
      *
     C                   WHEN      WAction = 'A'
     C                   EVAL      AHNOAM = AHNOAM + 1
      *
     C                   WHEN      WAction = 'D'
     C                   EVAL      AHNODL = AHNODL + 1
     C                   EVAL      AHNORC = AHNORC - 1
      *
     C                   ENDSL
      *
     C                   Update    @AHREAU
     C                   ENDIF
     C                   EVAL      WChange = 'Y'
     C                   COMMIT
      *
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRCKPCT - Checks Total Percentage holding                    *
      *****************************************************************
     C     SRCKPCT       BEGSR
      *
      ** Issue warning msg and redisplay screen if F3 pressed and
      ** total percentage allocation is not 100%
      *
     C                   EVAL      KCNUM = SCNUM
     C                   EVAL      KCTTX = SCTTX
     C                   EVAL      KDPTN = SDPTN
     C                   EVAL      WDFRDSw = 'N'
     C                   EVAL      WTOTPAL = 0
      *
     C     KYBOCC        SETLL     SDBNFOL1
     C     KYBOCC        READE     SDBNFOL1                               02
      *
     C                   DOW       NOT *IN02
      *
     C                   EVAL      WTOTPAL = WTOTPAL + BNPAHD
      *
     C                   IF        BNDFRD = 'Y'
     C                   EVAL      WDFRDSw = 'Y'
     C                   ENDIF
      *
     C     KYBOCC        READE     SDBNFOL1                               02
     C                   ENDDO
      *
     C                   IF        WTOTPAL <> 100
     C                   EVAL      P_MsgID = 'USR7708'
     C                   EXSR      SRSndM
     C                   ENDIF
      *
      ** If no DFRD = 'Y' exist on beneficial owners, issue warning msg
      *
     C                   IF        WDFRDSw = 'N'
     C                   EVAL      P_MsgID = 'USR7712'
     C                   EXSR      SRSndM
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVCNUM - Validate customer number                           *
      *                                                               *
      *****************************************************************
     C     SRVCNUM       BEGSR
      *
      ** Customer number is mandatory
      *
     C                   IF        SCNUM = *BLANKS
     C                   EVAL      *IN20 = *ON
     C                   EVAL      P_MsgID = 'USR7680'
     C                   EXSR      SRSndM
      *
      ** Must be a valid security customer.
      *
     C                   ELSE
     C                   CALL      'AOSECSR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      SCNUM         PCust
     C     SDSECS        PARM      SDSECS        DSFDY
      *
      ** Entry is not a valid security customer
      *
     C                   IF        PRtcd <> *BLANKS
     C                   EVAL      *IN20 = *ON
     C                   EVAL      P_MsgID = 'USR7682'
     C                   EXSR      SRSndM
     C                   ELSE
     C                   MOVE      BFCUST        SCNUM
      *
      ** Entry must be a valid portfolio customer
      *
     C                   IF        BFCLAS <> 'S'  AND
     C                             BFCLAS <> 'D'
     C                   EVAL      *IN20 = *ON
     C                   EVAL      P_MsgID = 'USR7683'
     C                   EXSR      SRSndM
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVCTTX - Validate Country of Tax Treaty                     *
      *                                                               *
      *****************************************************************
     C     SRVCTTX       BEGSR
      *
      ** Country of tax treaty must not be blanks
      *
     C                   IF        SCTTX = *Blanks
     C                   EVAL      *IN21 = *ON
     C                   EVAL      P_MsgID = 'USR7686'
     C                   EXSR      SRSndM
     C                   ELSE
      *
      ** Access country code details
      *
     C                   CALL      'AOCTRYR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY   '     POptn
     C     SCTTX         PARM      SCTTX         PCrtt
     C     SDCTRY        PARM      SDCTRY        DSFDY
      *
      ** Country of tax treaty must be a valid country def in the system
      *
     C                   IF        PRtcd <> *BLANKS
     C                   EVAL      *IN21 = *ON
     C                   EVAL      P_MsgID = 'USR7687'
     C                   EXSR      SRSndM
     C                   ENDIF
     C                   ENDIF
      *
     C                   IF        NOT *IN20 AND
     C                             NOT *IN21
      *
     C                   EVAL      KCTTX = SCTTX
     C                   EVAL      KCNUM = SCNUM
      *
      ** Customer and country of tax treaty must exist in W/H tax file
      *
     C     KYWTCS        CHAIN     SDWTCSL1                           02
      *
     C                   IF        *IN02 = *ON
     C                   EVAL      *IN20 = *ON
     C                   EVAL      *IN21 = *ON
     C                   EVAL      P_MsgID = 'USR7684'
     C                   EXSR      SRSndM
     C                   ELSE
      *
      ** Intermediary status for this customer and country of tax
      ** treaty must not be blanks
      *
     C                   IF        WHINTS = *BLANKS
     C                   EVAL      *IN20 = *ON
     C                   EVAL      *IN21 = *ON
     C                   EVAL      P_MsgID = 'USR7685'
     C                   EXSR      SRSndM
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVDPTN - Validate Depot                                     *
      *                                                               *
      *****************************************************************
     C     SRVDPTN       BEGSR
      *
      ** Must be a valid security customer.
      *
     C                   IF        SDPTN <> *BLANKS
     C                   CALL      'AOSECSR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      SDPTN         PCust
     C     SDSECS        PARM      SDSECS        DSFDY
      *
      ** Entry is not a valid depot
      *
     C                   IF        PRtcd <> *BLANKS
     C                   EVAL      *IN19 = *ON
     C                   EVAL      P_MsgID = 'USR7714'
     C                   EXSR      SRSndM
     C                   ELSE
     C                   MOVE      BFCUST        SDPTN
      *
      ** Entry must be a valid depot
      *
     C                   IF        BFCLAS <> 'X'  AND
     C                             BFCLAS <> 'E'  AND
     C**********                   BFCLAS <> 'C'  AND                                         CSE022
     C**********                   BFCLAS <> 'K'                                              CSE022
     C                             BFCLAS <> 'C'                                              CSE022
     C                   EVAL      *IN19 = *ON
     C                   EVAL      P_MsgID = 'USR7714'
     C                   EXSR      SRSndM
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVScn2Det - Validate second screen details                  *
      *                                                               *
      *****************************************************************
     C     SRVScn2Det    BEGSR
      *
      ** Validate beneficial owner details
      *
     C                   EXSR      SRVBenefDet
      *
      ** Validate Documentation Receive
      *
     C                   EXSR      SRVDCRC
      *
      ** Validate Backup Withholding
      *
     C                   EXSR      SRVBCWA
      *
      ** Validate Exemption code
      *
     C                   EXSR      SRVEXCD
      *
      ** Validate country of residence
      *
     C                   EXSR      SRVCTRS
      *
      ** Validate tax basket
      *
     C                   EXSR      SRVTXBS
      *
      ** Validate Recipient code
      *
     C                   EXSR      SRVRPCD
      *
      ** Validate Percentage allocation holding
      *
     C                   EXSR      SRVPAHD
      *
      ** Validate Beneficial Owner for rounding indicator
      *
     C                   EXSR      SRVDFRD
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVBenefDet - Validate beneficial owner detail               *
      *                                                               *
      *****************************************************************
     C     SRVBenefDet   BEGSR
      *
      ** Beneficial owner number
      *
     C                   IF        SBONO = *BLANKS
     C                   EVAL      *IN22 = *ON
     C                   EVAL      P_MsgID = 'USR7688'
     C                   EXSR      SRSndM
     C                   ELSE
      *
      ** Check if embedded blanks was entered
      *
     C                   Z-ADD     0             X
     C     DIGITS        CHECK     SBONO         N
     C                   IF        N > 0 AND N <= 20
     C     ' '           CHECK     SBONO:N       X
     C                   ENDIF
      *
      ** Entry is not a valid numeric.
      *
     C                   IF        X > 0
     C                   EVAL      *IN22 = *ON
     C                   EVAL      P_MsgID = 'USR7688'
     C                   EXSR      SRSndM
     C                   ELSE
      *
      ** Check if beneficial owner already exist
      *
     C                   IF        WAction = 'I'
     C                   EVAL      KBONO = SCNUM + SBONO
      *
     C     KYBNFO        CHAIN     SDBNFOL1                           02
      *
      ** Beneficial owner must be unique
      *
     C                   IF        *IN02 = *OFF
     C                   EVAL      *IN22 = *ON
     C                   EVAL      P_MsgID = 'USR7689'
     C                   EXSR      SRSndM
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVDCRC  - Validate Documentation Receive                    *
      *                                                               *
      *****************************************************************
     C     SRVDCRC       BEGSR
      *
     C                   IF        SDCRC = *BLANKS
     C                   EVAL      *IN27 = *ON
     C                   EVAL      P_MsgID = 'USR7690'
     C                   EXSR      SRSndM
     C                   ELSE
      *                                                                         185994
      ** Documentation receive must only be 'U', 'D', 'E', 'C' or 'L'           185994
      ** if country of residence and country of tax treaty is the same          185994
      *                                                                         185994
     C                   IF        SCTTX = SCTRS                                185994
     C                   IF        SDCRC <> 'U' AND                             185994
     C                             SDCRC <> 'D' AND                             185994
     C                             SDCRC <> 'E' AND                             185994
     C                             SDCRC <> 'C' AND                             185994
     C                             SDCRC <> 'L'                                 185994
      *                                                                         185994
     C                   EVAL      *IN27 = *ON                                  185994
     C                   EVAL      P_MsgID = 'USR7716'                          185994
     C                   EXSR      SRSndM                                       185994
     C                   ENDIF                                                  185994
     C                   ELSE                                                   185994
      *
     C                   IF        SDCRC <> 'Y' AND
     C                             SDCRC <> 'N' AND
     C                             SDCRC <> 'D' AND
     C                             SDCRC <> 'U' AND
     C                             SDCRC <> 'C' AND
     C                             SDCRC <> 'L' AND
     C*******************          SDCRC <> 'I' AND                       185255
     C                             SDCRC <> 'E'
      *
     C                   EVAL      *IN27 = *ON
     C                   EVAL      P_MsgID = 'USR7691'
     C                   EXSR      SRSndM
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF                                                  185994
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVBCWA  - Validate Backup Withholding                       *
      *                                                               *
      *****************************************************************
     C     SRVBCWA       BEGSR
      *
     C                   IF        SBCWA = *BLANK
     C                   IF        SDCRC = 'U'
     C                   EVAL      SBCWA  = 'Y'
     C                   ELSE
     C                   EVAL      SBCWA  = 'N'
     C                   ENDIF
      *
      ** Backup withholding must be 'Y' or 'N' if entered
      *
     C                   ELSE
     C                   IF        SBCWA <> 'Y' AND SBCWA <> 'N'
     C                   EVAL      *IN28 = *ON
     C                   EVAL      P_MsgID = 'USR7692'
     C                   EXSR      SRSndM
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVEXCD  - Validate Exemption code                           *
      *                                                               *
      *****************************************************************
     C     SRVEXCD       BEGSR
      *
      ** Exemption code is mandatory if documentation rcv is 'E'
      *
     C                   IF        SDCRC = 'E'
     C                   IF        SEXCD = *BLANKS
     C                   EVAL      *IN29 = *ON
     C                   EVAL      P_MsgID = 'USR7693'
     C                   EXSR      SRSndM
     C                   ENDIF                                                  186054
     C                   ENDIF                                                  186054
     C                                                                          186054
     C***********        ELSE                                                   186054
      *
     C                   IF        SEXCD <> *BLANKS                             186054
     C                   MOVE      SCTTX         KCTTX
     C                   MOVE      SEXCD         KEXCD
      *
      ** Exemption code must exist on exemption code table
      *
     C     KYEXCD        CHAIN     SDEXEML1                           02
     C                   IF        *IN02
     C                   EVAL      *IN29 = *ON
     C                   EVAL      P_MsgID = 'USR7694'
     C                   EXSR      SRSndM
     C                   ENDIF
     C                   ENDIF
      ***********                                                               186054
      ***Entry*of*exemption*code*is*not*allowed*if*doc*rcv*is*not*'E'           186054
      ***********                                                               186054
     C***********        ELSE                                                   186054
     C***********        IF        SEXCD <> *BLANKS                             186054
     C***********        EVAL      *IN29 = *ON                                  186054
     C***********        EVAL      P_MsgID = 'USR7695'                          186054
     C***********        EXSR      SRSndM                                       186054
     C***********        ENDIF                                                  186054
     C***********        ENDIF                                                  186054
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVCTRS - Validate country of residence                      *
      *                                                               *
      *****************************************************************
     C     SRVCTRS       BEGSR
      *
     C***********        IF        SCTRS <> *BLANKS                             185994
     C                   CALL      'AOCTRYR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY   '     POptn
     C     SCTRS         PARM      SCTRS         PCrtt
     C     SDCTRY        PARM      SDCTRY        DSFDY
      *
      ** Country of residence must be a live country code
      *
     C                   IF        PRtcd <> *BLANKS
     C                   EVAL      *IN30 = *ON
     C                   EVAL      P_MsgID = 'USR7696'
     C                   EXSR      SRSndM
     C                   ENDIF
     C***********        ENDIF                                                  185994
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVTXBS - Validate tax basket                                *
      *                                                               *
      *****************************************************************
     C     SRVTXBS       BEGSR
      *
     C                   IF        STXBS <> *BLANKS
     C                   EVAL      KCTTX = SCTTX
     C                   EVAL      KTXBS = STXBS
      *
     C     KYTXBS        CHAIN     SDTXBSL1                           02
      *
      ** Tax basket must exist on tax basket table
      *
     C                   IF        *IN02 = *ON
     C                   EVAL      *IN31 = *ON
     C                   EVAL      P_MsgID = 'USR7697'
     C                   EXSR      SRSndM
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVRPCD - Validate Recipient Code                            *
      *                                                               *
      *****************************************************************
     C     SRVRPCD       BEGSR
      *
     C                   IF        SRPCD = *BLANKS
     C                   EVAL      *IN32 = *ON
     C                   EVAL      P_MsgID = 'USR7698'
     C                   EXSR      SRSndM
     C                   ELSE
      *
     C                   EVAL      KCTTX = SCTTX
     C                   EVAL      KRPCD = SRPCD
      *
     C     KYRPCD        CHAIN     SDRPCDL1                           02
      *
      ** Recipient code must exist on recipient code table
      *
     C                   IF        *IN02 = *ON
     C                   EVAL      *IN32 = *ON
     C                   EVAL      P_MsgID = 'USR7699'
     C                   EXSR      SRSndM
     C                   ENDIF
     C
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVPAHD - Validate Percentage Allocation of holding          *
      *                                                               *
      *****************************************************************
     C     SRVPAHD       BEGSR
      *
     C                   EVAL      WTOTPAL  = 0
     C     KYBOCC        SETLL     SDBNFOL1
     C     KYBOCC        READE     SDBNFOL1                               02
      *
      ** Read Beneficial Owner detail file to compute for total
      ** Percentage Withholding.
      *
     C                   DOW       NOT *IN02
     C                   EVAL      WTOTPAL = WTOTPAL + BNPAHD
     C     KYBOCC        READE     SDBNFOL1                               02
     C                   ENDDO
      *
      ** Convert input field to numeric field
      *
     C                   IF        SPAHD <> *BLANKS
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVEL     SPAHD         ZFIELD
     C                   Z-ADD     2             ZADIG
     C                   Z-ADD     4             ZADEC
      *
     C                   CALLB     'ZALIGN'
     C                   PARM      'Y'           ZALIGNok
     C                   PARM                    ZFIELD
     C                   PARM                    ZADEC
     C                   PARM                    ZADIG
      *
     C                   IF        ZalignOK = 'N'
     C                   EVAL      *IN33 = *ON
     C                   EVAL      P_MsgID = 'USR7700'
     C                   EXSR      SRSndM
     C                   ELSE
      *
      ** Subtract the previous percentage allocation holding if amend
      *
     C                   IF        WAction = 'A'
     C                   EVAL      WTOTPAL = WTOTPAL - #SPAHD
     C                   ENDIF
      *
      ** Add the percentage allocation holding entered to the total
      *
     C                   MOVE      ZFIELD        WPAHD
     C                   EVAL      WTOTPAL = WTOTPAL + WPAHD
      *
      ** Total percentage allocation holding must not be more than 100
      *
     C                   IF        WTOTPAL > 100
     C                   EVAL      *IN33 = *ON
     C                   EVAL      P_MsgID = 'USR7701'
     C                   EXSR      SRSndM
     C                   ENDIF
     C                   ENDIF
     C                   ELSE
     C                   EVAL      WPAHD = 0
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVDFRD - Validate Default Beneficial Owner for rounding     *
      *                                                               *
      *****************************************************************
     C     SRVDFRD       BEGSR
      *
      ** If default beneficial owner for rounding is blank, check if
      ** the record being inserted is the first record
      *
     C                   IF        SDFRD = *BLANK
     C     KYBOCC        SETLL     SDBNFOL1
     C     KYBOCC        READE     SDBNFOL1                               02
      *
     C                   IF        *IN02
     C                   EVAL      SDFRD = 'Y'
     C                   ELSE
     C                   EVAL      SDFRD = 'N'
     C                   ENDIF
      *
     C                   ELSE
     C                   IF        SDFRD =  'Y'
     C     KYBOCC        SETLL     SDBNFOL1
     C     KYBOCC        READE     SDBNFOL1                               02
      *
      ** Read through beneficial owners file to check if there's a live
      ** record exist with BNDFRD = 'Y'
      *
     C                   EVAL      WChkDR = 'N'
     C                   DOW       NOT *IN02 AND
     C                             WChkDR = 'N'
     C                   MOVE      BNBONO        WBONO
     C                   IF        BNDFRD = 'Y' AND
     C                             SBONO <> WBONO
     C                   EVAL      WChkDR = 'Y'
     C                   ENDIF
      *
     C     KYBOCC        READE     SDBNFOL1                               02
      *
     C                   ENDDO
      *
     C                   IF        WChkDr = 'Y'
     C                   EVAL      *IN34 = *ON
     C                   EVAL      P_MsgID = 'USR7702'
     C                   EXSR      SRSndM
     C                   ENDIF
     C                   ELSE
      *
     C                   IF        SDFRD <> 'N'
     C                   EVAL      *IN34 = *ON
     C                   EVAL      P_MsgID = 'USR7703'
     C                   EXSR      SRSndM
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRFmtPct - Format amount for display using ZEDIT             *
      *                                                               *
      *****************************************************************
 
     C     SRFmtPct      BEGSR
 
     C                   CALLB     'ZEDIT'
     C                   PARM                    ZField
     C                   PARM                    ZADec
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSndM - Handles the display of error messages.              *
      *                                                               *
      *****************************************************************
     C     SRSndM        BEGSR
 
     C                   CALL      'ZA0340'
     C                   PARM                    P_MsgFile
     C                   PARM                    P_MsgID
 
     C                   EVAL      WError = 'Y'
     C                   ENDSR
      *
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
 
     C     *ENTRY        Plist
     C                   PARM                    PMODE             1
      *
     C     *DTAARA       DEFINE                  LDA
     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   EVAL      DBMOD  =  PSProcMod
     C                   OUT       LDA
      *
      ** Access bank details.
      *
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR '     PRtCd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Initialise job information & message file to use.
      *
     C                   EVAL      SUSER = PSUser
     C                   EVAL      SRUNA = BJMRDT
     C                   EVAL      SWSID = PSJOBNAME
     C                   EVAL      P_MsgFile = 'SDUSRMSG'
      *
      ** Key list for beneficial owner
      *
     C     KYBNFO        KLIST
     C                   KFLD                    KCNUM
     C                   KFLD                    KCTTX
     C                   KFLD                    KDPTN
     C                   KFLD                    KBONO
      *
      ** Partial key list for beneficial owners file
      *
     C     KYBOCC        KLIST
     C                   KFLD                    KCNUM
     C                   KFLD                    KCTTX
     C                   KFLD                    KDPTN
      *
      ** Key list for Withholding tax customer details
      *
     C     KYWTCS        KLIST
     C                   KFLD                    KCNUM
     C                   KFLD                    KCTTX
      *
      ** Key list for Exemption code file
      *
     C     KYEXCD        KLIST
     C                   KFLD                    KCTTX
     C                   KFLD                    KEXCD
      *
      ** Key list for Tax basket table file
      *
     C     KYTXBS        KLIST
     C                   KFLD                    KCTTX
     C                   KFLD                    KTXBS
      *
      ** Key list for Recipient code file
      *
     C     KYRPCD        KLIST
     C                   KFLD                    KCTTX
     C                   KFLD                    KRPCD
      *
      ** Key list for Standing data controls
      *
     C     KYFLNM        KLIST
     C                   KFLD                    KFLNM
      *
      ** Set indicator for enquiry or maintenance mode
      *
     C                   IF        PMODE = 'E'
     C                   EVAL      *IN82 = *ON
     C                   ELSE
     C                   EVAL      *IN82 = *OFF
     C                   ENDIF
      *
      ** Message subfile control and program queue initialisation.
      *
     C                   EVAL      *IN76 = *ON
     C                   EVAL      SPGMQ = '*'
     C                   EVAL      SCNUM = *BLANKS
     C                   EVAL      SCTTX = *BLANKS
     C                   EVAL      SDPTN = *BLANKS
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: (**calling routines**)                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *PSSR         BEGSR
 
     C                   IF        WRun = *BLANK
     C                   EVAL      WRun = 'Y'
     C                   DUMP
 
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
 
     C                   CALLB     'DBERRCTL'
 
     C                   ENDSR
 
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
