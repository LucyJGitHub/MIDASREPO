     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2008')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Network Transaction Identifier subfile')      *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  RPGLE/SD001300 - Network Transaction Identifier subfile      *
      *                                                               *
      *  Function : This Module handles networks and network          *
      *             Identification Transaction Code                   *
      *  (c) Misys International Banking Systems Ltd. 2008            *
      *                                                               *
      *  Last Amend No. CGL152             Date 02Dec13               *
      *  Prev Amend No. CER059             Date 19Jul10               *
      *                 BUG22693           Date 05Feb09               *
      *                 BG22303            Date 19Jan08               *
      *                 CER030  *CREATE    Date 09Jul08               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CGL152 - Include Transaction Type Identification Code on     *
      *           MT940/MT950 (Recompile)                             *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG22693 - The system should do validation based on length   *
      *             for network that does not have live code file     *
      *  BG22303 - Validation Error with Transaction Type length      *
      *  CER030 - Multicash German Feature                            *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *  Display Conditioning Indicators                              *
      *    20         Protect the field                               *
      *    21         Position cursor and reverse image               *
      *    40         Overlay indicator                               *
      *                                                               *
      *  Subfile Management Indicators                                *
      *    30         SFLDSP                                          *
      *    31         SFLCLR                                          *
      *    32         SFLEND                                          *
      *    80         SFLEND (Message Subfile)                        *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRInit    - Initialisation processing                        *
      *  SRClearSfl- Clear the Subfile                                *
      *  SRLoadSfl - Load the subfile                                 *
      *  SRDspScn  - Display Screen                                   *
      *  SRProcess - Process the Subfile                              *
      *  SRError   - On Error, send message to message subfile        *
      *  SRRecord  - For Recored loading when RRN is greater than 0   *
      *  SRDelete  - To delete the record                             *
      *  *INZSR    - Initialisation Subroutine                        *
      *  *PSSR - Error processing                                     *
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
      ** Midas SD Network Transaction Identifier
      *
     FSDNTTIL0  UF A E           K DISK    INFSR(*PSSR)
      *
      ** Midas SD Message network details - retrieval
      *
     FSDNWRKL1  IF   E           K DISK    INFSR(*PSSR)
      *
      ** Midas SD Network Transaction Code file
      *
     FSDNTCDL0  IF   E           K DISK    INFSR(*PSSR)
      *
      ** Midas SD Network Transaction Identifier - display file
      *
     FSD001300DFCF   E             WORKSTN
     F                                     SFILE(SD001300S1:RRN)
     F                                     INFSR(*PSSR)
      *
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
      *
     D/COPY ZACPYSRC,PSDS
      *
      ** Program Status Data Structure
      *
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
      ** First DS For Access Programs, Short Data Structure
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *                                                                                      BG22303
      ** Long Access Object Data Structure                                                   BG22303
      *                                                                                      BG22303
     D DSLDY         E DS                  EXTNAME(DSLDY)                                    BG22303
      *
      ** Bank Details
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      ** Externally described DS for Midas Modules details
      *
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      *
      ** Externally described DS for SAR details
      *
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      *                                                                                      BG22303
      ** Network details record format data structure                                        BG22303
      *                                                                                      BG22303
     D DSNwrk        E DS                  EXTNAME(SDNWRKPD)                                 BG22303
      *
      ** Indicators Data Structure
      *
     D Indiactors      DS                  BASED(IND_POINTER)
     D  Exit                  03     03
     D  Cancel                12     12
     D  Refresh               05     05
     D  SFLDisp               30     30
     D  SFLClear              31     31
     D  SFLEND                32     32
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
     D Ind_Pointer     S               *   Inz(%Addr(*IN))
      *
     D PRtCd           S              7A
      *
     D POptn           S              7A
      *
     D PActn           S              1A
      *
     D PRtTyp          S              5A
      *
     D PRtDes          S             30A
      *
     D PWrtf           S              1A
      *
     D PSard           S              6A
      *
     D WError          S              1A   Inz('N')
      *
     D WRtTyp          S              5A
      *
     D WriteFlag       S              1A
     D WRun            S              1A
     D WNwrk           S                   LIKE(EDNWRK)
     D WNtti           S                   LIKE(NINTTI)
     D NWRKOK          S              1A
     D WLenOk          S              1A                                                     BG22303
     D WLen            S              2  0                                                   BG22303
     D RRN             S              5  0
      *
     D Idx             S              2S 0
     D CER030          S              1A
     D CGL013          S              1A
     D CER044          S              1A
      *
      ** Parameters for ZA0350
      *
     D PMsgFile        S             10A   INZ('SDUSRMSG')
      *
     D PMsgId          S             10A
      *
     D PMsgData        S             45A
      *
      * Start of BG9999 Changes
      * Create DS for *FT - Fund Transfer network type
     D FT              DS            10
     D FT1                     1      1A
     D FT2                     2      2A
     D FT3                     3      3A
     D FT4                     4     10A
      *
      * End of BG9999 Changes
      *
     D POptnIn         S              7A                                                     BG22303
     D PRtcdIn         S              7A                                                     BG22303
     D PNwrkIn         S              6A                                                     BG22303
      *                                                                                      BG22303
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
      *
      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************
      *
      ** Initial Processing
      *
     C                   EXSR      SRInit
      *
      ** Main Processing
      *
     C                   DOW       Exit = *OFF AND Cancel = *OFF
      *
     C                   EXSR      SRDspScn
      *
      ** Clear Program Message Queue
      *
     C                   CALL      'ZA0250'
      *
     C                   EVAL      *IN40 = *OFF
      *
     C                   SELECT
     C                   WHEN      Exit  = *ON
     C                   EVAL      PRtcd = 'F3'
     C                   LEAVE
      *
     C                   WHEN      Cancel  = *ON
     C                   EVAL      PRtcd = 'F12'
     C                   LEAVE
      *
     C                   WHEN      Refresh = *ON
     C                   EVAL      D1NWRK = *BLANKS
     C                   EVAL      D1NTTI = *BLANKS
     C                   EVAL      D2NTTI = *BLANKS
      *
     C                   EXSR      SRClearSfl
     C                   EXSR      SRLoadSfl
      *
     C                   WHEN      D1NWRK <> *BLANKS OR
     C                             D1NTTI <> *BLANKS
      *
     C                   EXSR      SRClearSfl
     C                   EXSR      SRLoadSfl
      *
      ** User has pressed 'Enter' - Process Subfile
      *
     C                   OTHER
     C                   EXSR      SRProcess
      *
     C                   IF        WError = 'N'
     C                   EVAL      Exit = *ON
     C                   ENDIF
      *
     C                   ENDSL
      *
     C                   ENDDO
      *
     C                   EVAL      *INLR = *ON
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRInit - Initialisation processing                            *
      *                                                               *
      * Called By : Main Processing                                   *
      *                                                               *
      * Calls : SRLoadSfl,SRDelete                                    *
      *                                                               *
      *****************************************************************
      *
     C     SRInit        BEGSR
      *
      ** Format Header Information
      *
     C                   EVAL      D1MRDT = BJMRDT
     C                   EVAL      D1USRP = PSUSER
     C                   EVAL      D1WOID = PSJOBNAME
      *
      ** Clear Screen Fields
      *
     C                   EVAL      D1NWRK = *BLANKS
     C                   EVAL      D1NTTI = *BLANKS
     C                   EVAL      D2NWRK = *BLANKS
     C                   EVAL      D2NTTI = *BLANKS
     C                   EVAL      D2DESC = *BLANKS
     C                   EVAL      *IN20  = *OFF
      *
      ** Protect Screen Fields
      *
     C                   IF        PActn = 'E'
     C                   EVAL      *IN20 = *ON
     C                   ENDIF
      *
      ** Delete  Record
      *
     C                   IF        PActn = 'D'
     C                   EXSR      SRDelete
     C                   EVAL      PWrtf = 'Y'
     C                   EVAL      Exit  = *ON
     C                   EVAL      PRtcd = 'F3'
     C                   LEAVESR
     C                   ENDIF
      *
      ** Populate Screen fields
      *
     C                   EVAL      D1RTTYP = PRtTyp
     C                   EVAL      D1RTDES = PRtDes
      *
      ** Clear Program Message Queue
      *
     C                   CALL      'ZA0250'
      *
      ** Load the subfile
      *
     C                   EXSR      SRLoadSfl
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDelete - Delete Record                                     *
      *                                                               *
      *  Called By : SRINIT                                           *
      *                                                               *
      *  Calls : None                                                 *
      *                                                               *
      *****************************************************************
      *
     C     SRDelete      BEGSR
      *
     C     PRtTyp        SETLL     SDNTTIL0
     C                   READ      SDNTTIL0
      *
     C                   DOW       NOT %EOF(SDNTTIL0)
      *
     C                   IF        PRtTyp = NIRTTY
     C                   DELETE    SDNTTIL0
     C                   ENDIF
     C     PRtTyp        READE     SDNTTIL0
      *
     C                   ENDDO
      *
     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  SRClearSFL - Clear the Subfile                               *
      *                                                               *
      *  Called By : Main Processing, SRRecord                        *
      *                                                               *
      *  Calls : None                                                 *
      *                                                               *
      *****************************************************************
      *
     C     SRClearSFL    BEGSR
      *
     C                   EVAL      RRN = 0
      *
     C                   EVAL      SFLClear = *ON
     C                   WRITE     SD001300C1
     C                   EVAL      SFLClear = *OFF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRLoadSfl - Load the subfile                                 *
      *                                                               *
      *  Called by : Main Processing, SRINIT                          *
      *                                                               *
      *  Calls : SRRecord                                             *
      *                                                               *
      *****************************************************************
      *
     C     SRLoadSfl     BEGSR
      *
     C                   EVAL      RRN = 0
     C                   IF        CGL013 = 'Y' Or CER030 = 'Y'
      *
      ** Check the Selection Criteria
      *
     C                   IF        D1NWRK <> *BLANKS
     C     D1NWRK        SETLL     SDNWRKL1
     C                   ELSE
     C     *LOVAL        SETLL     SDNWRKL1
     C                   ENDIF
      *
     C                   EVAL      D1NWRK = *BLANKS
     C                   READ      SDNWRKL1
      *
     C                   EVAL      WriteFlag = 'N'
     C                   DOW       NOT %EOF(SDNWRKL1)
      *
      ** Display only the networks whose Transaction type length is
      ** greater than Zero
      *
     C                   IF        EDTRTP > 0
     C                   EVAL      D2NWRK = EDNWRK
      *
      ** Access the Network Transaction Identification code file
      *
     C                   EVAL      WRtTyp = PRtTyp
     C                   EVAL      WNwrk = EDNWRK
     C                   EVAL      WriteFlag = 'Y'
      *
     C                   EXSR      SRChkNtti
      *
     C                   ENDIF
      *
      ** Read the next record
      *
     C                   READ      SDNWRKL1
      *
     C                   ENDDO
      *
      ** For Fund Transfer
      *
     C                   IF        BGFDTR = 'Y'
     C                   EVAL      D2NWRK = *BLANKS
     C                   EVAL      D2NWRK = '*FT'
     C                   EVAL      WRTTYP = PRTTYP
     C                   EVAL      WNWRK = D2NWRK
     C                   EVAL      WriteFlag = 'Y'
      *
     C                   EXSR      SRChkNtti
      *
     C                   ENDIF
     C                   ENDIF
      *
      ** For AWV reporting
      *
     C                   IF        CER044 = 'Y'
     C                   EVAL      D2NWRK = *BLANKS
     C                   EVAL      D2NWRK = '*GVC'
     C                   EVAL      WRTTYP = PRTTYP
     C                   EVAL      WNWRK = D2NWRK
     C                   EVAL      WriteFlag = 'Y'
      *
     C                   EXSR      SRChkNtti
      *
     C                   ENDIF
      *
     C                   EVAL      D1NTTI = *BLANKS
      *
      ** Display the records only when  RRN is greatre than zero
      *
     C                   EXSR      SRRecord
      *
      ** Last Record reached
      *
     C                   IF        %EOF(SDNWRKL1) AND RRN > 0
     C                   EVAL      SflEnd = *ON
     C                   ELSE
     C                   EVAL      SflEnd = *OFF
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRChkNtti- Check the Network Tr code selection criteria      *
      *                                                               *
      *  Called by : SrLoadSfl                                        *
      *                                                               *
      *  Calls :                                                      *
      *                                                               *
      *****************************************************************
     C     SRChkNtti     BEGSR
      *
     C     KNtti         CHAIN     SDNTTIL0
     C                   IF        %FOUND(SDNTTIL0)
      *
     C                   EVAL      D2NTTI = NINTTI
     C                   EVAL      WNtti = D2NTTI
      *
     C                   IF        D1NTTI <> *BLANKS
      *
     C                   IF        D1NTTI = NINTTI
     C                   EVAL      WriteFlag = 'Y'
     C                   ELSE
     C                   EVAL      WriteFlag = 'N'
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Get the Network Transaction type Description
      *
     C                   IF        D2NTTI <> *BLANKS
     C     KNtCd         CHAIN     SDNTCDL0
      *
     C                   IF        %FOUND(SDNTCDL0)
     C                   EVAL      D2DESC = NTDESC
     C                   ELSE
     C                   EVAL      D2DESC = *BLANKS
     C                   ENDIF
      *
     C                   ELSE
     C                   EVAL      D2DESC = *BLANKS
     C                   ENDIF
      *
     C                   ELSE
      *
     C                   IF        D1NTTI <> *BLANKS
     C                   EVAL      WriteFlag = 'N'
     C                   ENDIF
     C
     C                   EVAL      D2NTTI = *BLANKS
     C                   EVAL      D2DESC = *BLANKS
      *
     C                   ENDIF
      *
      ** If record found and selection criteria matches
      *
     C                   IF        WriteFlag = 'Y'
     C                   EVAL      RRN = RRN + 1
     C                   WRITE     SD001300S1
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRecord - Display record when RRN is Greater than zero      *
      *                                                               *
      *  Called by : SrLoadSfl                                        *
      *                                                               *
      *  Calls : SRClearSFL,SRError                                  *
      *                                                               *
      *****************************************************************
     C     SRRecord      BEGSR
      *
     C                   IF        RRN > 0
     C                   EVAL      SFLDisp= *ON
     C                   ELSE
      *
     C                   EXSR      SRClearSfl
      *
     C                   EVAL      SFLDisp= *OFF
     C                   EVAL      *IN40 = *ON
     C                   EVAL      PMsgId = 'ASM0001'
     C                   EVAL      Idx = Idx + 1
     C                   EXSR      SRError
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDspScn - Display Screen                                    *
      *                                                               *
      *  Called by : Main Processing                                  *
      *                                                               *
      *  Calls : None                                                 *
      *                                                               *
      *****************************************************************
      *
     C     SRDspScn      BEGSR
      *
     C                   WRITE     SD001300C0
      *
     C                   WRITE     SD001300F0
     C                   EXFMT     SD001300C1
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRProcess - Process the Subfile                              *
      *                                                               *
      *  Called by : Main Processing                                  *
      *                                                               *
      *  Calls : SRError                                              *
      *                                                               *
      *****************************************************************
      *
     C     SRProcess     BEGSR
      *
      ** Read Changed records from Subfile
      *
     C                   EVAL      WError = 'N'
     C                   READC     SD001300S1
     C                   DOW       NOT %EOF
      *
      ** Validate Transaction Type Code
      *
     C                   IF        D2NTTI <> *BLANKS
     C                   EVAL      WNwrk = D2NWRK
     C                   EVAL      WNtti = D2NTTI
     C                   EVAL      FT = WNtti
     C                   EVAL      NWRKOK = 'N'
     C                   EVAL      WLen = *ZEROS                                             BG22303
     C                   EVAL      WLenOk = *BLANKS                                          BG22303
      *                                                                                      BG22303
      ** Geting transaction code length specified at network level                           BG22303
      *                                                                                      BG22303
     C                   IF        WNwrk <> '*FT' AND WNwrk <> '*GVC'                        BG22303
     C                   CALL      'AONWRKR1'                                                BG22303
     C                   PARM      *BLANKS       PRtCdIn                                     BG22303
     C                   PARM      '*KEY'        POptnIn                                     BG22303
     C                   PARM      WNwrk         PNwrkIn                                     BG22303
     C     DSNwrk        PARM                    DSLDY                                       BG22303
      *                                                                                      BG22303
     C                   IF        PRtCdIn <> *BLANKS                                        BG22303
      *                                                                                      BG22303
     C     *LOCK         IN        LDA                                                       BG22303
      *                                                                                      BG22303
     C                   EVAL      DBASE = 999                                               BG22303
     C                   EVAL      DBFILE = 'SDNWRKPD'                                       BG22303
     C                   EVAL      DBKEY  = WNwrk                                            BG22303
     C                   EVAL      DBPGM = 'SD001300'                                        BG22303
      *                                                                                      BG22303
     C                   OUT       LDA                                                       BG22303
     C                   EXSR      *PSSR                                                     BG22303
     C                   ENDIF                                                               BG22303
     C                   ENDIF                                                               BG22303
      *                                                                                      BG22303
      ** Validating Transaction code length                                                  BG22303
      ** For *FT network, D2NTTI should only have 3 chars
      *
     C*****KNtCd         CHAIN     SDNTCDL0                                                  BG22303
     C**********         IF        %FOUND(SDNTCDL0) OR (D2NWRK = '*FT' AND                   BG22303
      *                                                                                      BG22303
     C                   EVAL      WLen = %LEN(%TRIM(FT))                                    BG22303
      *                                                                                      BG22303
     C                   IF        ((D2NWRK <> '*FT' OR D2NWRK <> '*GVC')                    BG22303
     C                             AND WLen = EDTRTP) OR                                     BG22303
     C                             ((D2NWRK = '*FT' OR D2NWRK = '*GVC')                      BG22303
     C                             AND                                                       BG22303
     C                             FT1 <> *BLANKS AND FT2 <> *BLANKS AND
     C                             FT3 <> *BLANKS AND FT4 = *BLANKS)
     C**********         EVAL      NWRKOK = 'Y'                                              BG22303
     C                   EVAL      WLenOk = 'Y'                                              BG22303
     C                   ENDIF
      *
     C                   IF        WlenOk = 'Y'                                              BG22303
      *                                                                                      BG22303
     C     KNtCd         CHAIN     SDNTCDL0                                                  BG22303
     C                   IF        %FOUND(SDNTCDL0)                                          BG22303
     C                             OR D2NWRK = '*FT'                                        BUG22693
     C                   EVAL      NWRKOK = 'Y'                                              BG22303
     C                   ENDIF                                                               BG22303
      *                                                                                      BG22303
     C                   IF        NWRKOK = 'Y'
     C                   EVAL      WRtTyp = D1RTTYP
     C                   EVAL      WNwrk  = D2NWRK
     C                   EVAL      D2DESC = NTDESC
     C     KNtti         CHAIN     SDNTTIL0
      *
     C                   IF        %FOUND(SDNTTIL0)
     C                   IF        NINTTI <> D2NTTI
     C                   EVAL      NINTTI = D2NTTI
     C                   EVAL      NILCD = BJRDNB
     C                   EVAL      NICHTP = 'A'
     C                   UPDATE    SDNTTID0
     C                   EVAL      PWrtf = 'Y'
     C                   ENDIF
      *
     C                   ELSE
     C                   EVAL      NIRTTY = D1RTTYP
     C                   EVAL      NINWRK = D2NWRK
     C                   EVAL      NINTTI = D2NTTI
     C                   EVAL      NILCD = *ZEROS
     C                   EVAL      NICHTP = 'I'
     C                   WRITE     SDNTTID0
     C                   EVAL      PWrtf = 'Y'
      *
     C                   ENDIF
      *
      ** Invalid Transaction Type code
      *
     C                   ELSE
     C                   EVAL      WError = 'Y'
     C                   EVAL      PMsgId = 'USR8288'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      *IN21 = *ON
     C                   EXSR      SRError
      *
     C                   ENDIF
      *
      ** Invalid Transaction Type code length                                                BG22303
      *                                                                                      BG22303
     C                   ELSE                                                                BG22303
     C                   EVAL      WError = 'Y'                                              BG22303
     C                   EVAL      PMsgId = 'USR8288'                                        BG22303
     C                   EVAL      Idx = Idx + 1                                             BG22303
     C                   EVAL      *IN21 = *ON                                               BG22303
     C                   EXSR      SRError                                                   BG22303
      *                                                                                      BG22303
     C                   ENDIF                                                               BG22303
      *                                                                                      BG22303
     C                   ELSE
     C                   EVAL      WRtTyp = D1RTTYP
     C                   EVAL      WNwrk = D2NWRK
     C     KNtti         CHAIN     SDNTTIL0
      *
     C                   IF        %FOUND(SDNTTIL0)
     C                   EVAL      D2DESC = *BLANKS
     C                   DELETE    SDNTTID0
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** F3 Pressed
      *
     C                   IF        PRTCD = 'F03'
     C                   EVAL      Exit = *ON
     C                   LEAVE
     C                   ENDIF
      *
      ** Update and Read Changed records from Subfile
      *
     C                   UPDATE    SD001300S1
     C                   READC     SD001300S1
      *
     C                   EVAL      *IN21 = *OFF
     C                   ENDDO
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRError - On Error, send message to message subfile          *
      *                                                               *
      *  Called by : SRProcess,SRRecord                               *
      *                                                               *
      *  Calls : None                                                 *
      *                                                               *
      *****************************************************************
      *
     C     SRError       BEGSR
      *
     C                   CALL      'ZA0350'
     C                   PARM                    PMsgFile
     C                   PARM                    PMsgId
     C                   PARM      *BLANKS       PMsgData
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation routine                      *
      *                                                               *
      *  Called by : Implicitly on program activation                 *
      *                                                               *
      *  Calls : *PSSR                                                *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
     C     *DTAARA       DEFINE                  LDA
      *
      ** Intialise Working Fields
      *
     C                   EVAL      DBASE  = *ZEROS
     C                   EVAL      DBFILE = *BLANKS
     C                   EVAL      DBKEY  = *BLANKS
     C                   EVAL      DBPROC = *BLANKS
      *
      ** Define the Entry Parameter list
      *
     C     *ENTRY        PLIST
     C                   PARM                    PRTCD
     C                   PARM                    PActn
     C                   PARM                    PRtTyp
     C                   PARM                    PRtDes
     C                   PARM                    PWrtf
      *
      ** Key List for the file SDNTTIL0
      *
     C     KNtti         KLIST
     C                   KFLD                    WRtTyp
     C                   KFLD                    WNwrk
      *
      ** Key List for the file SDNTCDL0
      *
     C     KNtCd         KLIST
     C                   KFLD                    WNwrk
     C                   KFLD                    WNtti
      *
      ** Access Bank Details
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*FIRST'      POptn
     C     SDBANK        PARM      SDBANK        DSFDY
      *
     C                   IF        PRtcd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = POptn
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE = 001
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Access Module to verify if Funds Tr feature is Active or not
      *
     C                   CALL      'AOMMODR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*FIRST'      POptn
     C     SDMMOD        PARM      SDMMOD        DSFDY
      *
     C                   IF        PRtcd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = '*FIRST'
     C                   EVAL      DBFILE = 'SDMMODPD'
     C                   EVAL      DBASE = 002
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C
      *
      ** Check Switchable Feature CER044
      *
     C                   EVAL      CER044 ='N'
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'CER044'      PSard
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C                   IF        Prtcd = *Blanks
     C                   EVAL      CER044 ='Y'
     C                   Else
      *
     C                   IF        PRtcd <> '*NRF'
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = '*VERIFY'
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE = 003
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
      *
      ** Check Switchable Feature CER030
      *
     C                   EVAL      CER030 ='N'
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'CER030'      PSard
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C                   IF        Prtcd = *Blanks
     C                   EVAL      CER030 ='Y'
     C                   Else
      *
     C                   IF        PRtcd <> '*NRF'
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = '*VERIFY'
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE = 004
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
      *
      ** Check Switchable Feature CGL013
      *
     C                   EVAL      CGL013 ='N'
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'CGL013'      PSard
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C                   IF        Prtcd = *Blanks
     C                   EVAL      CGL013 ='Y'
     C                   Else
      *
     C                   IF        PRtcd <> '*NRF'
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = '*VERIFY'
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE = 005
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
      *
      ** Populate Program Message queue
      *
     C                   EVAL      D1PGMQ =  '*'
      *
     C                   ENDSR
      *
      *********************************************************************
      /EJECT
      *********************************************************************
      *                                                                   *
      *  *PSSR  - Program exception error routine                         *
      *           Called automatically if a program error occurs,         *
      *           or directly by the program code using EXSR.             *
      *           This subroutine DUMPs the program just once.            *
      *                                                                   *
      *  Called by : (**calling routines**)                               *
      *                                                                   *
      *  Calls : None                                                     *
      *                                                                   *
      *********************************************************************
     C     *PSSR         BEGSR
      *
     C                   IF        WRun = *BLANKS
      *
     C                   EVAL      WRun = 'Y'
     C                   DUMP
     C                   CALLB     'DBERRCTL'
      *
     C                   ENDIF
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
      *
     C                   RETURN
      *
     C                   ENDSR
      *
