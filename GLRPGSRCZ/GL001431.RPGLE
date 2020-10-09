     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL MT950 File Extract')                          *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GL001431 - Midas GL MT950 File Extract                       *
      *                                                               *
      *  Function: This program extracts data from Posting file to    *
      *            MGx950PD                                           *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. CMG008             Date 20Feb20               *
      *                 AR401845           Date 12Mar20               *
      *                 MD045952           Date 06Jul17               *
      *                 MD046248           Date 27Oct17               *
      *                 CGL178             Date 04Aug16               *
      *                 AR549926           Date 19Aug14               *
      *                 CGL146A            Date 10Jun13               *
      *                 CRE075             Date 06Dec10               *
      *                 AR702741           Date 02Feb11               *
      *                 CER059             Date 19Jul10               *
      *                 BUG26810           Date 04Dec09               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      *                 216937             Date 28Apr03               *
      *                 CRE008             Date 31May02               *
      *                 216935             Date 15Apr03               *
      *                 CGL013  *CREATE    Date 25Apr02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *           (Recompile)                                         *
      *  CMG008 - SWIFT Character Translation Table (Recompile)       *
      *  AR401845 - MT940 generation does not take into account       *
      *             regional holidays (CHILD: AR401846)               *
      *           - Replace ZFREQB with ZFRQB2 which considers        *
      *             system location.                                  *
      *  MD045952 - Ensure that COB MT940s only generated if          *
      *             calling pgm is GLC001430.                         *
      *           - Recompile due to changes to CGL146_043, CGL146_044*
      *             CGL146_068, CGL146_070, CGL146_077                *
      *  MD046248 - Finastra Rebranding                               *
      *  CGL178 - Generate MT942 based on MT950.                      *
      *  AR549926 - GLPOSTPD and MGX950PD tables have a total size    *
      *             of about 1.4GB. These tables hold  records printed*
      *             on the MT9xx SWIFT messages. Amended program to   *
      *             tag records in GLPOSTPD file as processed even    *
      *             though there is a conflict between MT Generate    *
      *             flags in Network File and in Message Suppression  *
      *             in Customer Details File.                         *
      *  CGL146A - MT940/MT950 Production in Input Cycle              *
      *            Added hooks: CGL146_043, CGL146_044, CGL146_068    *
      *                         CGL146_069, CGL146_070, CGL146_071    *
      *                         CGL146_072, CGL146_077, CGL146_079    *
      *                         CGL146_080, CGL146_081, CGL146_082    *
      *                         CGL146_083, CGL146_084, CGL146_085    *
      *                         CGL146_086, CGL146_112                *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  AR702741 - Include location as parameter in ZFREQB to        *
      *             determine the next settlement date                *
      *             (Child: AR702742)                                 *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG26810 - MT940/950 should be independent of the network    *
      *             "activity"                                        *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  216937 - If GA account, include source account (recompile)   *
      *  CRE008 - Cash Management  (Recompile Only)                   *
      *  216935 - Correct the processing for frequency 'On Movement   *
      *  CGL013 - MT94x Messages Generation                           *
      *                                                               *
      *****************************************************************

     FGLNWACL4  IF   E           K DISK                   INFSR(*PSSR)
      ** Midas GL Network Accounts - MT950 - Live/Accnt+Dst. - Retrieve

     FGLPOSTL0  UF   E           K DISK    COMMIT         INFSR(*PSSR)
     F                                     PREFIX(GL)
      ** Midas GL Posting sorted by Network Account, Message Type, destination.

     FGLNWKAPD  IF   E           K DISK                   INFSR(*PSSR)
      ** Midas GL Network Activity Control File.
     FGLNW94L5  IF   E           K DISK                   INFSR(*PSSR)                        CGL178
      ** Midas GL Network accounts - MT94x - live+gen.MT940                                   CGL178

     FGLNWACL0  UF   E           K DISK    COMMIT         INFSR(*PSSR)
     F                                     PREFIX(Up)
     F                                     RENAME(GLNWACD0:UpGLNWACD0)
      ** Midas GL Network Accounts - MT950 - Live/Accnt+Dst. - Update

     FMGF950PD  O    E             DISK    COMMIT         INFSR(*PSSR)
      ** Midas MG MT950 Generation Extract - Account Detail.

     FMGX950PD  O    E             DISK    COMMIT         INFSR(*PSSR)
      ** Midas MG MT950 Generation Extract - Posting Detail.

     FGL001431AUO    E             PRINTER OFLIND(*IN21)  INFSR(*PSSR)
      ** Midas GL MT950 File Extract - Audit Report.

      /COPY OFCPYSRCZ,CGL146_079                                                             CGL146A
      *========================================================================*
      *                                                                        *
      * Use of Indicators                                                      *
      *                                                                        *
      * Database Access Indicators                                             *
      *                                                                        *
      * 21 - Audit report overflow indicator                                   *
      * 27 - Access Network Account (LF/GLNWACL4)                              *
      * 28 - Access Postings        (LF/GLPOSTL0)                              *
      * 40 - General Error                                                     *
      *    41         For tagging as Processed                        *                     AR549926
      *                                                                        *
      * Database Error Indicators                                              *
      *                                                                        *
      * U7 - Abnormal Completion                                               *
      * U8 - File Out of Balance                                               *
      * U7 + U8 - Database Error                                               *
      *                                                                        *
      * Other Indicators                                                       *
      *                                                                        *
      * 99 - Multi-purpose                                                     *
      *                                                                        *
      *========================================================================*

      *========================================================================*
      ** Automatically included D-specs
      ** ==============================

      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)

     D/COPY ZACPYSRC,STD_D_SPEC

      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.

     D/COPY ZACPYSRC,PSDS

      ** Manually included D-specs
      ** =========================

      ** Named constants
      ** ---------------

      ** Arrays and Data Structures
      ** --------------------------

      /COPY OFCPYSRCZ,CGL146_043                                                             CGL146A
                                                                                             CGL146A
     D GLposting     E DS                  EXTNAME(GLPOSTPD) PREFIX(GL)
      **  Data Structure for Posting detail in General Ledger format.
     D   EXMGADI1    E                     EXTFLD(MGADI1)                       Additional Inf 1
     D   EXMGADI2    E                     EXTFLD(MGADI2)                       Additional Inf 2
     D   EXMGADI3    E                     EXTFLD(MGADI3)                       Additional Inf 3
     D   EXMGADI4    E                     EXTFLD(MGADI4)                       Additional Inf 4
     D   EXMGADI5    E                     EXTFLD(MGADI5)                       Additional Inf 5
     D   EXMGADI6    E                     EXTFLD(MGADI6)                       Additional Inf 6
     D   EXMGAERI    E                     EXTFLD(MGAERI)                       ERI Indicator

     D MGposting     E DS                  EXTNAME(MGX940PD)
      **  Data Structure for Posting detail in Message Genration Format.
      ********************************************************************
      **  THIS DATA STRUCTURE USES MGX940PD, IT IS NOT AN ERROR         **
      **  MGX940PD CONTAINS THE SAME FIELDS AS MGX950PD PLUS FEW FIELDS **
      ********************************************************************
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      **  Data Structure for Bank Details.

     D SDGELR        E DS                  EXTNAME(SDGELRPD)
     D  QQACCD1      E                     EXTFLD(QQACCD)                                     CGL029
      **  Data Structure for SD General ledger ICD

     D SDNWRK        E DS                  EXTNAME(SDNWRKPD)
      **  Data Structure for Network Details.

     D GLACCNT       E DS                  EXTNAME(ACCNTAB)
      **  Data Structure for Account Details.

     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      **  Data Structure for Customer Details.

     D SCSARD        E DS                  EXTNAME(SCSARDPD) PREFIX(SS)
      **  Data Structure for Switchable features descriptions.

     D DSSDY         E DS                  EXTNAME(DSSDY)
      **  First DS for access programs, long data structure.

     D DSFDY         E DS                  EXTNAME(DSFDY)
      **  Second DS for access programs, short data structure.

     D DSLDY         E DS                  EXTNAME(DSLDY)
      **  Third DS for access programs, very long data structure.

      ** Define an array for the non generated messages number
      ** contained in the DsCUST data structure
      *
     D  BBNGEN         S              3A   DIM(15)
     D                                     BASED(Pointer1)
     D  Pointer1       S               *   INZ(%Addr(BBNG01))

      ** Declared variables
      ** ------------------

     D KeyNWRK         S                   LIKE(GLMGNWRK)                       Network
     D KeyBRCA         S                   LIKE(GLBRCA)                         Branch Code - Alpha
     D KeyCNUM         S                   LIKE(GLCNUM)                         Customer number
     D KeyCCY          S                   LIKE(GLCCY)                          Currency code
     D KeyACOD         S                   LIKE(GLACOD)                         Account code
     D KeyACSQ         S                   LIKE(GLACSQ)                         Account sequence num
     D KeyNATY         S                   LIKE(GLMGNATY)                       Network Account Type
     D KeyDSTN         S                   LIKE(GLMGDSTN)                       Destination
     D KeyMTPY         S                   LIKE(GLMGMTPY)                       Message Type

     D KeyNwNWRK       S                   LIKE(NANWRK)                         Network
     D KeyNwBRCA       S                   LIKE(NABRCH)                         Branch Code - Alpha
     D KeyNwCNUM       S                   LIKE(NACNUM)                         Customer number
     D KeyNwCCY        S                   LIKE(NACCY)                          Currency code
     D KeyNwACCD       S                   LIKE(NAACOD)                         Account code
     D KeyNwACSQ       S                   LIKE(NAACSQ)                         Account sequence num
     D KeyNwNATY       S                   LIKE(NANATY)                         Network Account Type

     D P@RTCD          S              7A                                        Return Code
     D P@OPTN          S              7A                                        Option
     D P@RETL          S             10A                                        Retail Number
     D P@CNUM          S              6A                                        Customer
     D P@CUCD          S              3A                                        Currency
     D*P@ACCD***       S              4A                                        Account code  CGL029
     D P@ACCD          S             10A                                                      CGL029
     D P@ACSQ          S              2A                                        Account Sequence
     D P@BRCA          S              3A                                        Branch Code
     D P@KEY1          S             10A                                        Customer
     D P@KYST          S              7A                                        Key Status
     D P@SARD          S              6A                                        Feature Ref.
     D P@NWRK          S              6A                                        Network

     D ZFREQ           S              1A                                        Frequence
     D ZDAYNO          S              5  0                                      Day Number
     D ZCCY            S              3A                                        Currency
     D ZLOC            S              3A                                                    AR702741
     D ZMDAY           S              2  0                                      Day in month
     D ZDFIN           S              1A                                        Date Format

     D CSW022          S              1A                                        Feature CSW022
     D WkBalance       S             15P 0                                      Intermediary Balance
     D WkNbMvts        S             10U 0                                      Nb. Movements
     D SavNWRK         S                   LIKE(EDNWRK) INZ(*BLANKS)            Network
     D WkNxtStatDt     S                   LIKE(NA5NSD)                         Next Statement Date
     D WkErrRpt        S              1A   INZ('N')                             Error Reported
     D X               S              5U 0                                      Working Index

      ** Input Specs
      ** -----------


      *------------------------------------------------------------------------*
      ** C Spec. Declaratives
      ** ====================

      *========================================================================*
      *              M  A  I  N     P  R  O  C  E  S  S  I  N  G               *
      *========================================================================*

      ** Init processing uses the standard *INZSR subroutine

      ** Read each Live Network Account.

      /COPY OFCPYSRCZ,CGL146_044                                                             CGL146A
                                                                                             CGL146A
     C     *LOVAL        SETLL     GLNWACL4
     C                   READ      GLNWACL4                               27
                                                                                             CGL146A
      /COPY OFCPYSRCZ,CGL146_080                                                             CGL146A

     C                   DOW       NOT *IN27

      ** Initialize working fields.

     C                   EXSR      $InitWkFld

     C                   DO

      ** If the next statement date is greater than or equal to the next working date,
      ** and there is no demand,
      ** read the next record.

     C                   IF        NA5NSD >= BJDNWD AND NA5DSI <> 'Y'
      /COPY OFCPYSRCZ,CGL146_081                                                             CGL146A
     C                   LEAVE
     C                   ENDIF

      ** Check if the network is active

     C                   EXSR      $ChkNwrk

     C   40              LEAVE

      ** Check Account Details.

     C                   EXSR      $ChkAccnt

     C   40              LEAVE

      ** Check if the customer allows MT950 generation.

     C                   EXSR      $ChkCust

     C   40              LEAVE

      ** Process Posting Details

     C                   EXSR      $MGX950PD

     C   40              LEAVE

     C*********          IF        CSW022 <> 'Y'                                Feature Off   216935
     C*********                    OR WkNbMvts > *ZEROS                         Or Movements  216935
     C                   IF        WkNbMvts > *ZEROS                            Movements     216935
     C                             OR CSW022 <> 'Y'                             Feature Off   216935
     C                             AND NA5SFQ <> *blanks                        On Movement F.216935

      ** Process Account Details

     C                   EXSR      $MGF950PD

     C   40              LEAVE

     C                   ENDIF

      ** Update Network Account details.

     C                   EXSR      $GLNWACPD

     C   40              LEAVE
                                                                                              CGL178
      ** Update MT941 & MT942 Postings for the Network Account                                CGL178
                                                                                              CGL178
     C                   EXSR      $GLPOSTPD                                                  CGL178
                                                                                              CGL178
     C   40              LEAVE                                                                CGL178

     C                   ENDDO

     C**N40*****         COMMIT                                                             AR549926
     C  N40                                                                                 AR549926
     COR 41              COMMIT                                                             AR549926
     C***40*****         ROLBK                                                              AR549926
     C   40                                                                                 AR549926
     CANN41              ROLBK                                                              AR549926

      ** Read next Live Network Account.

      /COPY OFCPYSRCZ,CGL146_068                                                             CGL146A
     C                   READ      GLNWACL4                               27
      /COPY OFCPYSRCZ,CGL146_069                                                             CGL146A

     C                   ENDDO

      ** End of processing

     C                   IF        WkErrRpt = 'N'
     C                   WRITE     NODTLS
     C                   ENDIF

     C                   WRITE     ENDRPT

     C                   EVAL      *INLR = *ON

      *========================================================================*
      * $MGX950PD: Extract Posting Details                                     *
      *------------------------------------------------------------------------*

     C     $MGX950PD     BEGSR
      *    ---------     -----

     C                   EVAL      KeyNWRK = NANWRK                             Network
     C                   EVAL      KeyBRCA = NABRCH                             Branch Code - Alpha
     C                   EVAL      KeyCNUM = NACNUM                             Customer number
     C                   EVAL      KeyCCY  = NACCY                              Currency code
     C                   EVAL      KeyACOD = NAACOD                             Account code
     C                   EVAL      KeyACSQ = NAACSQ                             Account sequence num
     C                   EVAL      KeyNATY = NANATY                             Network Account Type
     C                   EVAL      KeyDSTN = *BLANKS                            Destination
     C                   EVAL      KeyMTPY = '950'                              Message Type

      ** Read Postings for this Network Account.

     C     KeyPost       SETLL     GLPOSTD0
     C     KeyPost       READE     GLPOSTD0                               28

     C                   DOW       NOT *IN28 AND NOT *IN40
                                                                                             CGL146A
      /COPY OFCPYSRCZ,CGL146_070                                                             CGL146A

      ** Report only movements in General Ledger (from EODPOPD)

     C                   IF        GLRECI = 'P'
     C                             AND GLMGPROC <> 'Y'

     C                   EVAL      WkNbMvts = WkNbMvts + 1

      ** Calculate the new balance

     C                   IF        GLDRCR = 0                                   Debit
     C                   EVAL      WkBalance = WkBalance + GLPSTA
     C                   ELSE                                                   Credit
     C                   EVAL      WkBalance = WkBalance - GLPSTA
     C                   ENDIF

      ** If Extended narrative is allowed for the Network.

     C                   IF        EDENRA = 'Y'
     C                   EVAL      EXMGADI1 =  GLMGADI1                         Additional Inf 1
     C                   EVAL      EXMGADI2 =  GLMGADI2                         Additional Inf 2
     C                   EVAL      EXMGADI3 =  GLMGADI3                         Additional Inf 3
     C                   EVAL      EXMGADI4 =  GLMGADI4                         Additional Inf 4
     C                   EVAL      EXMGADI5 =  GLMGADI5                         Additional Inf 5
     C                   EVAL      EXMGADI6 =  GLMGADI6                         Additional Inf 6
     C                   EVAL      EXMGAERI =  GLMGAERI                         ERI Indicator
     C                   ELSE
     C                   EVAL      EXMGADI1 =  *BLANKS                          Additional Inf 1
     C                   EVAL      EXMGADI2 =  *BLANKS                          Additional Inf 2
     C                   EVAL      EXMGADI3 =  *BLANKS                          Additional Inf 3
     C                   EVAL      EXMGADI4 =  *BLANKS                          Additional Inf 4
     C                   EVAL      EXMGADI5 =  *BLANKS                          Additional Inf 5
     C                   EVAL      EXMGADI6 =  *BLANKS                          Additional Inf 6
     C                   EVAL      EXMGAERI =  *BLANKS                          ERI Indicator
     C                   ENDIF

      ** Format the posting details

     C                   CALLB     'GL001432'                           99
     C                   PARM      *BLANKS       ReturnCode                     Return Code
     C                   PARM                    GLPosting                      GL Posting Detail
     C                   PARM      *BLANKS       MGPosting                      MG Posting Detail

     C                   IF        ReturnCode = 'PSSR_ERROR'
     C                             OR *IN99 = *ON
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   IF        ReturnCode = *BLANKS

      ** Add record in MT950 Generation Extract - Posting Detail

     C                   WRITE     MGX950D0

     C                   ELSE

      ** Add the issue on the audit report.

     C                   EVAL      *IN40 = *ON
     C                   EVAL      PACMNT = 'Posting extract failed'
     C                   DUMP
     C                   EXSR      $AuditRpt                                    Report Issue
     C                   GOTO      @MGX950PD
     C                   ENDIF

     C                   ENDIF

      ** Mark the posting as processed

     C                   EVAL      GLMGPROC = 'Y'
     C                   UPDATE    GLPOSTD0
      /COPY OFCPYSRCZ,CGL146_071                                                             CGL146A

      ** Read Next Posting for this Network Account.

     C     KeyPost       READE     GLPOSTD0                               28

     C                   ENDDO

      *    ---------     -----
     C     @MGX950PD     ENDSR

      *========================================================================*
      * $MGF950PD: Extract Account Details                                     *
      *------------------------------------------------------------------------*

     C     $MGF950PD     BEGSR
      *    ---------     -----

     C                   EVAL      MGNWRK = NANWRK                              Network
     C                   EVAL      MGBRCA = NABRCH                              Branch Code - Alpha
     C                   EVAL      MGCNUM = NACNUM                              Customer number
     C                   EVAL      MGCCY  = NACCY                               Currency code
     C                   EVAL      MGACCD = NAACOD                              Account code
     C                   EVAL      MGACSQ = NAACSQ                              Account sequence num
     C                   EVAL      MGNATY = NANATY                              Network Account Type
     C                   IF        ED5DMS <> *BLANKS
     C                   EVAL      MGDMST = ED5DMS                              Default Message Stat
     C                   ELSE
     C                   EVAL      MGDMST = 'C'                                 Default Message Stat
     C                   ENDIF
     C                   EVAL      MGACNO = ACNO                                Retail account numbe
     C                   EVAL      MGIBAN = IBAN                                IBAN
     C                   EVAL      MGSTNO = NA5LSN + 1                          Last Statement Page
     C                   EVAL      MGLSDT = NA5LSD                              Last Statement Date
     C                   EVAL      MGIOBL = NA5LCB                              Initial Opening Bala
     C                   EVAL      MGFCBL = NA5LCB + WkBalance                  Final Closing Balanc
     C                   EVAL      MGCLBL = CLBL                                Available Balance
                                                                                             CGL146A
      /COPY OFCPYSRCZ,CGL146_072                                                             CGL146A

     C                   WRITE     MGF950D0
                                                                                             CGL146A
      /COPY OFCPYSRCZ,CGL146_082                                                             CGL146A

      *    ---------     -----
     C     @MGF950PD     ENDSR

      *========================================================================*
      * $GLNWACPD: Update Network Account details.                             *
      *------------------------------------------------------------------------*

     C     $GLNWACPD     BEGSR
      *    ---------     -----

      ** Retrieve next statement date

      ** Only if it is not a demand.

     C                   IF        NA5NSD < BJDNWD

      ** If frequency is 'Z' on request, the next statement date is in 6 months.

     C                   IF        NA5SFQ = 'Z'
     C                   EVAL      WkNxtStatDt = BJRDNB + 183                   Next statement Date
     C                   ELSE

      ** Otherwise, calculate the next working date.

     C                   IF        NA5SFQ = *Blanks                             On Movement   216935
     C                   EVAL      ZFREQ = 'D'                                  Frequence     216935
     C                   ELSE                                                                 216935
     C                   EVAL      ZFREQ = NA5SFQ                               Frequence     216935
     C                   ENDIF                                                                216935

     C**********         CALLB     'ZFREQB'                                                 AR401845
     C                   CALLB     'ZFRQB2'                                                 AR401845
     C                   PARM      *BLANKS       RetCodeIn                      Return Code
     C***********        PARM      NA5SFQ        ZFREQ                          Frequence     216935
     C                   PARM                    ZFREQ                          Frequence     216935
     C                   PARM      BJRDNB        ZDAYNO                         Start Date
     C                   PARM      BJLCCY        ZCCY                           Local Currency
     C**********         PARM      *BLANKS       ZLOC                              AR702741 AR401845
     C                   PARM      BJSLCD        ZLOC                                       AR401845
     C                   PARM      NA5SDY        ZMDAY                          Day in Month
     C                   PARM      BJDFIN        ZDFIN                          Date Format Indicato
     C     SDGELR        PARM      SDGELR        DSFDY                          General ledger ICD
     C
     C                   IF        RetCodeIn = *BLANKS
     C                   EVAL      WkNxtStatDt = ZDAYNO                         Next statement Date
     C                   ELSE
     C
     C                   EVAL      *IN40 = *ON
     C                   EVAL      PACMNT = 'Calculation of the next +
     C                                       statement date failed'
     C                   DUMP
     C                   EXSR      $AuditRpt                                    Report Issue
     C                   GOTO      @GLNWACPD
     C                   ENDIF

     C                   ENDIF
     C                   ENDIF

      ** Access the Networl Account for update

     C                   EVAL      KeyNwNWRK = NANWRK                           Network
     C                   EVAL      KeyNwBRCA = NABRCH                           Branch Code - Alpha
     C                   EVAL      KeyNwCNUM = NACNUM                           Customer number
     C                   EVAL      KeyNwCCY  = NACCY                            Currency code
     C                   EVAL      KeyNwACCD = NAACOD                           Account code
     C                   EVAL      KeyNwACSQ = NAACSQ                           Account sequence num
     C                   EVAL      KeyNwNATY = NANATY                           Network Account Type

     C     KeyNwrkAc     CHAIN     GLNWACL0                           99

     C                   IF        *IN99
     C                   EVAL      *IN40 = *ON
     C                   EVAL      PACMNT = 'Network Account not found +
     C                                       for update'
     C                   DUMP
     C                   EXSR      $AuditRpt                                    Report Issue
     C                   GOTO      @GLNWACPD
     C                   ENDIF

      ** Process MT950 Details.

      ** If no message generation due to no movement to report,                               216935
      ** update only the next statement date                                                  216935
      *                                                                                       216935
     C                   IF        WkNbMvts    = *ZEROS                         Movements     216935
     C                             AND CSW022  = 'Y'                            Feature Off   216935
     C                             OR WkNbMvts = *ZEROS                         Movements     216935
     C                             AND NA5SFQ  = *BLANKS                        On Movement F.216935
     C                   EVAL      UpNA5DSI = 'N'                               Demand Stateme216935
     C                   IF        NA5NSD < BJDNWD                              Not a demand  216935
     C/COPY OFCPYSRCZ,CGL146_083                                                             CGL146A
     C                   EVAL      UpNA5NSD = WkNxtStatDt                       Next statement216935
     C                   ENDIF                                                                216935
      *                                                                                       216935
      ** Otherwise, update all details                                                        216935
      *                                                                                       216935
     C                   ELSE                                                                 216935
      *                                                                                       216935
     C                   EVAL      UpNA5DSI = 'N'                               Demand Statement ind
     C                   EVAL      UpNA5LSD = BJRDNB                            Last Statement Date
     C/COPY OFCPYSRCZ,CGL146_084                                                             CGL146A
     C                   TIME                    UpNA5LST                       Last Statement Time
     C                   EVAL      UpNA5LSN = NA5LSN + 1                        Last Statement Page
     C                   EVAL      UpNA5LCB = NA5LCB + WkBalance                Final Closing Balanc
     C                   IF        NA5NSD < BJDNWD                              Not a demand
     C/COPY OFCPYSRCZ,CGL146_083                                                             CGL146A
     C                   EVAL      UpNA5NSD = WkNxtStatDt                       Next statement Date
     C                   ENDIF
      *                                                                                       216935
     C                   ENDIF                                                                216935

     C                   UPDATE    UpGLNWACD0

     C/COPY OFCPYSRCZ,CGL146_112                                                             CGL146A
      *    ---------     -----
     C     @GLNWACPD     ENDSR

      *========================================================================*              CGL178
      * $GLPOSTPD: Update MT941 & MT942 Posting for the Network account        *              CGL178
      *------------------------------------------------------------------------*              CGL178
                                                                                              CGL178
     C     $GLPOSTPD     BEGSR                                                                CGL178
      *    ---------     -----                                                                CGL178
      ** If CGL178 is on and no MT940 is to be generated, tag postings for MT941              CGL178
      ** and MT942 as Processed.                                                              CGL178
                                                                                              CGL178
     C     CGL178        IFEQ      'Y'                                                        CGL178
     C                   EVAL      KeyNWRK = NANWRK                                           CGL178
     C                   EVAL      KeyBRCA = NABRCH                                           CGL178
     C                   EVAL      KeyCNUM = NACNUM                                           CGL178
     C                   EVAL      KeyCCY  = NACCY                                            CGL178
     C                   EVAL      KeyACOD = NAACOD                                           CGL178
     C                   EVAL      KeyACSQ = NAACSQ                                           CGL178
     C                   EVAL      KeyNATY = NANATY                                           CGL178
     C                   EVAL      KeyDSTN = *BLANKS                                          CGL178
     C     Key940L       SETLL     GLNW94D0                                                   CGL178
     C     Key940R       READE     GLNW94D0                               29                  CGL178
     C     *IN29         DOWEQ     *OFF                                                       CGL178
      *                                                                                       CGL178
     C     N4G940        IFEQ      'N'                                                        CGL178
     C                   EVAL      KeyDSTN = N4DSTN                                           CGL178
     C                   EVAL      KeyMTPY = '941'                                            CGL178
      ** Read Postings for this Network Account and tagged as Processed                       CGL178
      *                                                                                       CGL178
     C     KeyPost       SETLL     GLPOSTD0                                                   CGL178
     C     KeyPost       READE     GLPOSTD0                               28                  CGL178
     C                   DOW       NOT *IN28                                                  CGL178
     C                   EVAL      GLMGPROC = 'Y'                                             CGL178
     C                   UPDATE    GLPOSTD0                                                   CGL178
     C     KeyPost       READE     GLPOSTD0                               28                  CGL178
     C                   ENDDO                                                                CGL178
      *                                                                                       CGL178
     C                   EVAL      KeyMTPY = '942'                                            CGL178
      ** Read Postings for this Network Account and tagged as Processed                       CGL178
      *                                                                                       CGL178
     C     KeyPost       SETLL     GLPOSTD0                                                   CGL178
     C     KeyPost       READE     GLPOSTD0                               28                  CGL178
     C                   DOW       NOT *IN28                                                  CGL178
     C                   EVAL      GLMGPROC = 'Y'                                             CGL178
     C                   UPDATE    GLPOSTD0                                                   CGL178
     C     KeyPost       READE     GLPOSTD0                               28                  CGL178
     C                   ENDDO                                                                CGL178
      *                                                                                       CGL178
     C                   ENDIF                                                                CGL178
     C                   EVAL      KeyDSTN = *BLANKS                                          CGL178
     C     Key940R       READE     GLNW94D0                               29                  CGL178
     C                   ENDDO                                                                CGL178
     C                   ENDIF                                                                CGL178
                                                                                              CGL178
     C                   ENDSR                                                                CGL178

      *========================================================================*
      * $InitWkFld: Initialize working fields.                                 *
      *------------------------------------------------------------------------*

     C     $InitWkFld    BEGSR
      *    ----------    -----

     C                   EVAL      *IN40 = *OFF                                 General Indicator
     C                   EVAL      *IN41 = *OFF                                             AR549926

     C                   EVAL      WkBalance = *ZEROS                           Intermediary Balance

     C                   EVAL      WkNbMvts = *ZEROS                            Nb. Movements

     C                   EVAL      WkNxtStatDt = NA5NSD                         Next Statement Date

     C     @InitWkFld    ENDSR
      *    --------      -----

      *========================================================================*
      * $ChkNwrk: Check if the Network is active.                              *
      *------------------------------------------------------------------------*

     C     $ChkNwrk      BEGSR
      *    --------      -----

     C                   IF        NANWRK <> SavNWRK

      **  Check if the Network exists.

     C                   CALLB     'AONWRKR1'
     C                   PARM      *BLANKS       P@RTCD                         Return Code
     C                   PARM      '*KEY'        P@OPTN                         Option
     C                   PARM      NANWRK        P@NWRK                         Network
     C     SDNWRK        PARM      SDNWRK        DSLDY

      ** Add the issue on the audit report.

     C                   IF        P@RTCD <> *BLANKS
     C                   EVAL      *IN40 = *ON
     C                   EVAL      PACMNT = 'Network ' + %TRIM(NANWRK) +
     C                                      ' does not exist'
     C                   EXSR      $AuditRpt                                    Report Issue
     C                   GOTO      @ChkNwrk
     C                   ENDIF

      **  Check if the Network authorizes MT950.

     C                   IF        EDM950 <> 'Y'
     C                   EVAL      *IN40 = *ON
     C                   EVAL      PACMNT = 'Network ' + %TRIM(NANWRK) +
     C                                      ' does not authorize MT950'
     C                   EXSR      $AuditRpt                                    Report Issue
     C                   GOTO      @ChkNwrk
     C                   ENDIF

      ****Check*if*the*network*is*active.                                                   BUG26810

     C*****NANWRK        CHAIN     GLNWKAPD                           99                    BUG26810

     C**********         IF        *IN99                                                    BUG26810
     C**********                   OR NOT *IN99 AND MTSSTS <> 'A'                           BUG26810
     C**********         EVAL      *IN40 = *ON                                              BUG26810
     C**********         EVAL      PACMNT = 'Network ' + %TRIM(NANWRK) + ' is +             BUG26810
     C**********                             not active'                                    BUG26810
     C**********         EXSR      $AuditRpt                                    Report IssueBUG26810
     C**********         GOTO      @ChkNwrk                                                 BUG26810
     C**********         ENDIF                                                              BUG26810

     C  N40              EVAL      SAvNWRK = NANWRK
                                                                                             CGL146A
     C/COPY OFCPYSRCZ,CGL146_085                                                             CGL146A

     C                   ENDIF

      *    ---------     -----
     C     @ChkNwrk      ENDSR

      *========================================================================*
      * $ChkAccnt: Check Account details                                       *
      *------------------------------------------------------------------------*

     C     $ChkAccnt     BEGSR
      *    ---------     -----

     C                   MOVE      NACNUM        P@CNUM                         Customer
     C                   MOVE      NAACOD        P@ACCD                         Account code
     C                   MOVE      NAACSQ        P@ACSQ                         Account Sequence

     C                   CALLB     'AOACCTR0'
     C                   PARM      *BLANKS       P@RTCD                         Return Code
     C                   PARM      '*KEY'        P@OPTN                         Option
     C                   PARM      *BLANKS       P@RETL                         Retail Number
     C                   PARM                    P@CNUM                         Customer
     C                   PARM      NACCY         P@CUCD                         Currency
     C                   PARM                    P@ACCD                         Account code
     C                   PARM                    P@ACSQ                         Account Sequence
     C                   PARM      NABRCH        P@BRCA                         Branch Code
     C     GLACCNT       PARM      GLACCNT       DSSDY

      ** Add the issue on the audit report.

     C                   IF        P@RTCD <> *BLANKS
     C                   EVAL      *IN40 = *ON
     C                   EVAL      PACMNT = 'Midas Account Detail not found'
     C                   EXSR      $AuditRpt                                    Report Issue
     C                   ENDIF

      *    ---------     -----
     C     @ChkAccnt     ENDSR

      *========================================================================*
      * $ChkCust: Check if the customer allows MT950 generation.               *
      *------------------------------------------------------------------------*

     C     $ChkCust      BEGSR
      *    --------      -----

     C                   MOVEL(P)  NACNUM        P@KEY1                         Customer

     C                   CALLB     'AOCUSTR0'
     C                   PARM      *BLANKS       P@RTCD                         Return Code
     C                   PARM      '*KEY'        P@OPTN                         Option
     C                   PARM                    P@KEY1                         Customer
     C                   PARM                    P@KYST                         Key Status
     C     SDCUST        PARM      SDCUST        DSSDY

      ** Add the issue on the audit report.

     C                   IF        P@RTCD <> *BLANKS
     C                   EVAL      *IN40 = *ON
     C                   EVAL      PACMNT = 'Customer ' + %TRIM(P@KEY1) +
     C                                      ' not found'
     C                   EXSR      $AuditRpt                                    Report Issue
     C                   GOTO      @ChkCust
     C                   ENDIF
      *                                                                                     AR549926
     C                   EVAL      *IN41 = *OFF                                             AR549926

      ** Add the issue on the audit report.

     C     '950'         LOOKUP    BBNGEN                                 99
     C                   IF        *IN99
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN41 = *ON                                              AR549926
     C                   EVAL      PACMNT = 'Customer ' + %TRIM(P@KEY1) +
     C                                      ' does not allow MT950 generation'
     C                   EXSR      $AuditRpt                                    Report Issue
     C                   ENDIF

     C                   IF        *IN41                                                    AR549926
     C                   EXSR      $TAGPROC                                                 AR549926
     C                   ENDIF                                                              AR549926
      *    ---------     -----
     C     @ChkCust      ENDSR

      *========================================================================*
      * $AuditRpt: Report issues                                               *
      *------------------------------------------------------------------------*

     C     $AuditRpt     BEGSR
      *    ---------     -----

     C                   IF        *IN21                                        Printer Overflow
     C                   WRITE     HEADAU
     C                   WRITE     SUBTL                                21
     C                   ENDIF
     C                   WRITE     DETAIL

     C                   EVAL      WkErrRpt = 'Y'                               Error Reported

      *    ---------     -----
     C     @AuditRpt     ENDSR

      *****************************************************************                     AR549926
      *  $TAGPROC: Tag Records as Processed                           *                     AR549926
      *****************************************************************                     AR549926
      *                                                                                     AR549926
     C     $TAGPROC      BEGSR                                                              AR549926
      *                                                                                     AR549926
     C                   EVAL      KeyNWRK = NANWRK                                         AR549926
     C                   EVAL      KeyBRCA = NABRCH                                         AR549926
     C                   EVAL      KeyCNUM = NACNUM                                         AR549926
     C                   EVAL      KeyCCY  = NACCY                                          AR549926
     C                   EVAL      KeyACOD = NAACOD                                         AR549926
     C                   EVAL      KeyACSQ = NAACSQ                                         AR549926
     C                   EVAL      KeyNATY = NANATY                                         AR549926
     C                   EVAL      KeyDSTN = *BLANKS                                        AR549926
     C                   EVAL      KeyMTPY = '950'                                          AR549926
      *                                                                                     AR549926
      ** Read Postings for this Network Account and tagged as Processed                     AR549926
      *                                                                                     AR549926
     C     KeyPost       SETLL     GLPOSTD0                                                 AR549926
     C     KeyPost       READE     GLPOSTD0                               28                AR549926
     C                   DOW       NOT *IN28                                                AR549926
     C                   EVAL      GLMGPROC = 'Y'                                           AR549926
     C                   UPDATE    GLPOSTD0                                                 AR549926
     C     KeyPost       READE     GLPOSTD0                               28                AR549926
     C                   ENDDO                                                              AR549926
      *                                                                                     AR549926
     C                   ENDSR                                                              AR549926
      *========================================================================*
      * *INSZR: Initial Sub-routine                                            *
      *------------------------------------------------------------------------*

     C     *INZSR        BEGSR
      *    ------        -----
                                                                                             CGL146A
      /COPY OFCPYSRCZ,CGL146_077                                                             CGL146A

      ** Initialise Copyright Array
     C                   MOVEA     CPY@          CPY@@            80

      ** Initialise LDA.

     C     *LOCK         IN        LDA
     C                   MOVEL     PSProcPgm     DBpgm
     C                   OUT       LDA

      ** Retrieve Bank details.

     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR '     P@RTCD                         Return Code
     C                   PARM      '*FIRST '     P@OPTN                         Option
     C     SDBANK        PARM      SDBANK        DSFDY

      ** Check if feature CSW022 is installed
      ** CSW022 - Suppress generation of SWIFT Statement messages if account has no movements.

     C                   EVAL      CSW022 = 'N'

     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       P@RTCD                         Return Code
     C                   PARM      '*VERIFY'     P@OPTN                         Option
     C                   PARM      'CSW022 '     P@SARD                         Feature Ref.
     C     SCSARD        PARM      SCSARD        DSFDY

     C                   IF        P@RTCD = *BLANKS
     C                   EVAL      CSW022 = 'Y'
     C                   ENDIF
                                                                                              CGL178
      ** Check if CGL178 is installed                                                         CGL178
      *                                                                                       CGL178
     C                   MOVEL     'N'           CGL178            1                          CGL178
     C                   CALLB     'AOSARDR0'                                                 CGL178
     C                   PARM      *BLANKS       P@RTCD                                       CGL178
     C                   PARM      '*VERIFY'     P@OPTN                                       CGL178
     C                   PARM      'CGL178'      P@SARD                                       CGL178
     C     SCSARD        PARM      SCSARD        DSFDY                                        CGL178
                                                                                              CGL178
     C                   IF        P@RTCD= *BLANKS                                            CGL178
     C                   MOVEL     'Y'           CGL178                                       CGL178
     C                   ENDIF                                                                CGL178
                                                                                             CGL146A
      /COPY OFCPYSRCZ,CGL146_086                                                             CGL146A

      ** Write audit report title.

     C                   WRITE     HEADAU
     C                   WRITE     SUBTL                                21

      ** Key to access Posting details.

     C     KeyPost       KLIST
     C                   KFLD                    KeyNWRK                        Network
     C                   KFLD                    KeyBRCA                        Branch Code - Alpha
     C                   KFLD                    KeyCNUM                        Customer number
     C                   KFLD                    KeyCCY                         Currency code
     C                   KFLD                    KeyACOD                        Account code
     C                   KFLD                    KeyACSQ                        Account sequence num
     C                   KFLD                    KeyNATY                        Network Account Type
     C                   KFLD                    KeyDSTN                        Destination
     C                   KFLD                    KeyMTPY                        Message Type

      ** Key to access Network Account for Update.

     C     KeyNwrkAc     KLIST
     C                   KFLD                    KeyNwNWRK                      Network
     C                   KFLD                    KeyNwBRCA                      Branch Code - Alpha
     C                   KFLD                    KeyNwCNUM                      Customer number
     C                   KFLD                    KeyNwCCY                       Currency code
     C                   KFLD                    KeyNwACCD                      Account code
     C                   KFLD                    KeyNwACSQ                      Account sequence num
     C                   KFLD                    KeyNwNATY                      Network Account Type

      ** Key to access MT940                                                                  CGL178
                                                                                              CGL178
     C     Key940L       KLIST                                                                CGL178
     C                   KFLD                    KeyNWRK                                      CGL178
     C                   KFLD                    KeyBRCA                                      CGL178
     C                   KFLD                    KeyCNUM                                      CGL178
     C                   KFLD                    KeyCCY                                       CGL178
     C                   KFLD                    KeyACOD                                      CGL178
     C                   KFLD                    KeyACSQ                                      CGL178
     C                   KFLD                    KeyNATY                                      CGL178
     C                   KFLD                    KeyDSTN                                      CGL178
                                                                                              CGL178
     C     Key940R       KLIST                                                                CGL178
     C                   KFLD                    KeyNWRK                                      CGL178
     C                   KFLD                    KeyBRCA                                      CGL178
     C                   KFLD                    KeyCNUM                                      CGL178
     C                   KFLD                    KeyCCY                                       CGL178
     C                   KFLD                    KeyACOD                                      CGL178
     C                   KFLD                    KeyACSQ                                      CGL178
     C                   KFLD                    KeyNATY                                      CGL178
                                                                                              CGL178
      *    ------        -----
     C     @INZSR        ENDSR

      *========================================================================*
      * *PSSR     : Program exception error subroutine                         *
      *------------------------------------------------------------------------*

     C     *PSSR         BEGSR
      *    -----         -----

     C                   DUMP
     C                   ROLBK

     C                   EVAL      *INU7 = *On
     C                   EVAL      *INU8 = *On
     C                   EVAL      *INLR = *On

      *    -----         -----
     C     @PSSR         ENDSR

      *========================================================================*
**CTDATA CPY@
(c) Finastra International Limited 2002
