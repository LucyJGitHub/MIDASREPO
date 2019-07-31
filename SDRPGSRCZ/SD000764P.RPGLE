     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Non-A/c Holders Audit List')                  *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD000764P - SD Non-A/c Holders Audit List                    *
      *                                                               *
      *  Function:   This program generates                           *
      *              Non-A/c Holders Audit List                       *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *  Last Amend No. CGL177             Date 11Jan16               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CGL132             Date 01May13               *
      *                 AR745942           Date 13Apr11               *
      *                 CER059             Date 19Jul10               *
      *                 BUG24402           Date 17Jun09               *
      *                 BUG23642           Date 26May09               *
      *                 CER054             Date 07Apr09               *
      *                 BUG22580           Date 02Feb09               *
      *                 BUG22457           Date 23Jan09               *
      *                 CER048             Date 19May08               *
      *                 CER047             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 CSW207             Date 23Jun07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 236137             Date 21Sep05               *
      *                 232543             Date 31Mar05               *
      *                 CGL032  *CREATE    Date 05Jul04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CGL177 - CRS Reporting Phase 2                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CGL132 - FATCA Phase 1 - Customers' Identification and       *
      *           Classification - Master                             *
      *  AR745942 - Incorrect state code description was printed      *
      *             (Child: AR745943)                                 *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG24402 - SDC541P 10082 Failed                              *
      *  BUG23642 - Non - Account holders - 2 Issues                  *
      *             (Recompile)                                       *
      *  CER054 - German Features - Church Tax                        *
      *  BUG22580 - Fields incorrectly labeled and lengths            *
      *             (Recompile)                                       *
      *  BUG22457 - Data in "Country of Domicile" field went to       *
      *             "Country of Citizenship" (Recompile)              *
      *  CER048 - German Features - Taxes                             *
      *  CER047 - German Features LF037-00 Reporting §24c KWG         *
      *  CSW207 - SWIFT 2007 Changes                                  *
      *  236137 - Change Control for CGL031                           *
      *  232543 - Fix to CGL032                                       *
      *  CGL032 - Automatic Exchange of Information                   *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** SD Non-A/c Holders
     FSDNAHOL1  IF   E           K DISK    INFSR(*PSSR)
 
      ** SD Non-A/c Holders by Country of Tax
     FSDNHTXL1  IF   E           K DISK    INFSR(*PSSR)
 
      ** SD Non-A/c Holders by Country of Tax                                                 CGL177
     FSDCRSNL2  IF   E           K DISK    INFSR(*PSSR)                                       CGL177
     FSDCRSNL0  IF   E           K DISK    INFSR(*PSSR)                                       CGL177
     F                                     RENAME(SDCRSND0:SDCRSND1)                          CGL177
                                                                                              CGL177
      ** Control file retrieval index
     FSDFCTLL1  IF   E           K DISK    INFSR(*PSSR)
                                                                                              CER054
      ** Federal State Codes Keyed by State Codes                                             CER054
     FSDGESTL0  IF   E           K DISK    INFSR(*PSSR)                                       CER054
                                                                                              CER054
      ** Religious Affiliation Codes Keyed by Religious Affiliation                           CER054
     FSDRLAFL0  IF   E           K DISK    INFSR(*PSSR)                                       CER054
 
      ** SD Non-A/c Holders Audit List - Detail
     FSD000764P1O    E             PRINTER INFSR(*PSSR)
     F                                     INFDS(SPOOL1)
 
      ** SD Non-A/c Holders Audit List - Audit
     FSD000764AUO    E             PRINTER INFDS(SPOOLU)
     F                                     INFSR(*PSSR)
 
      ** +--------------------------------------+
      ** ¦ D-specs: Arrays and Data Structures  ¦
      ** ¦ =======  ==========================  ¦
      ** +--------------------------------------+
      ** Local data area for database error details
     D LDA           E DS           256    EXTNAME(LDA)
      ** The following fields are defined in the external file:
      **                                    134 141 DBFile
      **                                    142 170 DBKey
      **                                    171 180 DBPgm
      **                                    181 1830DBase
      **                                    184 193 DBMod
      **                                    194 203 DBProc
 
      ** Program Status Data Structure
     D/COPY ZACPYSRC,PSDS
 
      ** External DS for Bank Details
     D SDBANK        E DS                  Extname(SDBANKPD)
 
      ** Externally described DS for Country Details
     D SDCTRY        E DS                  EXTNAME(SDCTRYPD)
 
      ** External DS for SAR Details
     D SCSARD        E DS                  Extname(SCSARDPD)
                                                                                              CSW207
      ** External DS for Midas modules details                                                CSW207
     D SDMMOD        E DS                  Extname(SDMMODPD)                                  CSW207
 
      **  Short DS for access programs
     D DSFDY         E DS                  Extname(DSFDY)
 
      **  Long DS for access programs
     D DSSDY         E DS                  Extname(DSSDY)
 
      ** File Information Data Structure for SD000764P1.
     D SPOOL1          DS
     D   SFILE1               83     92
     D   SFNUM1              123    124B 0
     D   OFLLN1              188    189B 0
     D   PRTLN1              367    368B 0
 
      ** File Information Data Structure for SD000764AU.
     D SPOOLU          DS
     D   SFILEU               83     92
     D   SFNUMU              123    124B 0
 
      ** +--------------------------------------+
      ** ¦ D-specs: Declared variables          ¦
      ** ¦ =======  ==================          ¦
      ** +--------------------------------------+
 
      ** Parameters for access object programs
     D PRtCd           S              7
     D POptn           S              7
     D PSARD           S              6
 
      ** Parameters for ZSFILE
     D PSeq            S              5
     D SEnty           S              3
     D ZSnum           S              6  0
     D ZSnumU          S              6  0
     D ZSerr           S              1
 
      ** Parameter list fields
     D PMode           S              1
     D PLevl           S              1
     D PEnty           S              3
 
      ** Other fields used
     D WRun            S              1A   Inz
     D WRecNo          S              7S 0 Inz
     D ZDAYNO          S              5P 0 Inz
     D ZDATE           S              6P 0 Inz
     D ZADATE          S              7A   Inz
     D WDateDD         S              2A   Inz
     D WDateMM         S              2A   Inz
     D WDateYY         S              2A   Inz
     D WDateDMY        S              6A   Inz
     D WFName          S             10A
     D PCtyCd          S                   Like(NXCTTX)
     D DateIn          S              6A
     D DaynoOut        S              5P 0
     D ErrorFlag       S              1A
     D RqdLn1          S              3  0
     D DifLn1          S              4  0
     D CSW207          S              1    INZ(' ')                                           CSW207
     D CGL031          S              1    INZ(' ')                                           CSW207
     D CGL032          S              1    INZ(' ')                                           CSW207
     D PrivBank        S              1    INZ(' ')                                           CSW207
     D CGL157          S              1A                                                      CGL177
     D CRSCTR          S              5  0                                                    CGL177
     D KDNAHO          S             10                                                       CGL177
     D KDCTRY          S              2                                                       CGL177
      *                                                                                       CER047
     D CER047          S              1A                                                      CER047
     D CER048          S              1A                                                      CER048
     D CER054          S              1A                                                      CER054
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ *InzSR is executed at program activation.                  ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
 
      ** Set file pointer to first record and do initial read.
 
     C     *Loval        SETLL     SDNAHOL1
     C                   READ      SDNAHOL1
 
      ** Read SD Non-A/c Holders File until end of file
 
     C                   DOW       Not %EOF(SDNAHOL1)
 
      ** Print Report Header 1
 
     C                   EXSR      SRPrintHdr1
 
      ** Print Report Header 2
 
     C                   EXSR      SRPrintHdr2
 
      ** Print Non-A/c Holders' Country of Tax Code/s
 
     C                   EXSR      SRPrintDtl
 
     C                   EVAL      WRecNo = WRecNo + 1
 
     C                   READ      SDNAHOL1
 
     C                   ENDDO
 
     C                   EXSR      SRPrintFtr
 
     C                   EVAL      *INLR = *ON
 
     C                   RETURN
      *****************************************************************
      *  P R O G R A M   E N D                                        *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPrintHdr1- Print Header 1 Routine                          *
      *                                                               *
      *****************************************************************
     C     SRPrintHdr1   BEGSR
 
     C                   WRITE     HEADER1
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPrintHdr2- Print Header 2 Routine                          *
      *                                                               *
      *****************************************************************
     C     SRPrintHdr2   BEGSR
 
      ** Set up Header 2 details
      ** Non-A/c Holder Reference
 
     C                   EVAL      RREFNO = NHNAHO
 
      ** Non-A/c Holder Report Name
 
     C                   EVAL      RRPTNM = NHNARN
 
      ** Private Individual
 
     C                   EVAL      RPRVIN = NHPIND
 
      ** TIN
 
     C                   EVAL      RTIN   = NHTINO
 
      ** Identification Type
     C                   EVAL      RIDTYP = NHIDTP
 
      ** Issuing Country
 
     C                   EVAL      RISCNT = NHISCT
 
      ** Issuing Date
 
     C**********         IF        NHISDT = 0                                                 232543
     C**********         EVAL      RISDTE = *Blanks                                           232543
     C**********         ELSE                                                                 232543
     C**********         EVAL      ZDAYNO = NHISDT                                            232543
     C**********         EXSR      ZDATE2                                                     232543
     C**********         MOVEL(P)  ZADATE        RISDTE                                       232543
     C**********         ENDIF                                                                232543
                                                                                              232543
     C                   EVAL      WDateDD = %SubSt(NHISDT:7:2)                               232543
     C                   EVAL      WDateMM = %SubSt(NHISDT:5:2)                               232543
     C                   EVAL      WDateYY = %SubSt(NHISDT:3:2)                               232543
     C                   EVAL      WDateDMY= WDateDD + WDateMM + WDateYY                      232543
                                                                                              232543
     C                   CALLB     'ZDATE1'                                                   232543
     C                   PARM      WDateDMY      DateIn                                       232543
     C                   PARM                    DayNoOut                                     232543
     C                   PARM                    BJDFIN                                       232543
     C                   PARM                    ErrorFlag                                    232543
                                                                                              232543
     C                   IF        ErrorFlag = 'Y'                                            232543
     C                   EVAL      RISDTE = *Blanks                                           232543
     C                   ELSE                                                                 232543
     C                   EVAL      ZDAYNO = DayNoOut                                          232543
     C                   EXSR      ZDATE2                                                     232543
     C                   MOVEL(P)  ZADATE        RISDTE                                       232543
     C                   ENDIF                                                                232543
 
      **   Last Change Date
 
     C                   IF        NHLCDT = 0
     C                   EVAL      RLCDTE = *Blanks
     C                   ELSE
     C                   EVAL      ZDAYNO = NHLCDT
     C                   EXSR      ZDATE2
     C                   MOVEL(P)  ZADATE        RLCDTE
     C                   ENDIF
 
      **   Last Change Type
 
     C                   SELECT
     C                   WHEN      NHREPI = 'I'
     C                   EVAL      RLCTYP = 'Inserted'
     C                   WHEN      NHREPI = 'A'
     C                   EVAL      RLCTYP = 'Amended'
     C                   WHEN      NHREPI = 'D'
     C                   EVAL      RLCTYP = 'Deleted'
     C                   OTHER
     C                   EVAL      RLCTYP = *Blanks
     C                   ENDSL
 
      **   Date of Birth
 
     C                   EVAL      WDateDD = %SubSt(NHDBTH:7:2)
     C                   EVAL      WDateMM = %SubSt(NHDBTH:5:2)
     C                   EVAL      WDateYY = %SubSt(NHDBTH:3:2)
     C                   EVAL      WDateDMY= WDateDD + WDateMM + WDateYY
 
     C                   CALLB     'ZDATE1'
     C                   PARM      WDateDMY      DateIn
     C                   PARM                    DayNoOut
     C                   PARM                    BJDFIN
     C                   PARM                    ErrorFlag
 
     C                   IF        ErrorFlag = 'Y'
     C                   EVAL      RDOB = *Blanks
     C                   ELSE
     C                   EVAL      ZDAYNO = DayNoOut
     C                   EXSR      ZDATE2
     C                   MOVEL(P)  ZADATE        RDOB
     C                   ENDIF
 
      **   Place of Birth - Country
 
     C                   EVAL      RCTYOB = NHBTHC
 
      **   Place of Birth - Town
 
     C                   EVAL      RTWNOB = NHBTHT
 
      ** Country of Residence
 
     C                   EVAL      RCTYRS = NHCOLC
 
      ** Mailing Address (Lines 1 - 4)
 
     C                   EVAL      RADD1  = NHCNA1
     C                   EVAL      RADD2  = NHCNA2
     C                   EVAL      RADD3  = NHCNA3
     C                   EVAL      RADD4  = NHCNA4
 
      ** Family Name/First Name
 
     C                   EVAL      RLSTNM = NHIDE1
     C                   EVAL      RFSTNM = NHIDE2
 
      ** Street
 
     C                   EVAL      RST1   = NHIDE3
     C                   EVAL      RST2   = NHIDE4
 
      **   City
 
     C                   EVAL      RCITY  = NHCITY
 
      **   Zip Code
 
     C                   EVAL      RZIPCD = NHZIPC
      ** Issuing Authority                                                                    CSW207
     C                   IF        CSW207 = 'Y' OR                                            CSW207
     C                             PrivBank = 'Y'                                             CSW207
     C                   EVAL      RISSAU = NHISAU                                            CSW207
     C                   ENDIF                                                                CSW207
 
      *                                                                                       CER047
     C                   IF        CER047 = 'Y' OR                                            CER048
     C                             CER048 = 'Y'                                               CER048
      *                                                                                       CER047
      ** Title                                                                                CER047
      *                                                                                       CER047
     C                   EVAL      RCTITL = NHTITL                                            CER047
      *                                                                                       CER047
      ** Maiden Name                                                                          CER047
      *                                                                                       CER047
     C                   EVAL      RCMDNM = NHMDNM                                            CER047
      *                                                                                       CER054
     C                   IF        CER054 = 'Y'                                               CER054
      *                                                                                       CER054
      ** State Code                                                                           CER054
      *                                                                                       CER054
     C                   EVAL      RCSTCD = NHSTCD                                            CER054
     C                   EVAL      RCSTNM = *BLANKS                                         AR745942
      *                                                                                       CER054
     C     NHSTCD        CHAIN     SDGESTL0                                                   CER054
     C                   IF        %FOUND(SDGESTL0)                                           CER054
     C                             OR NOT %FOUND(SDGESTL0)                                  BUG24402
     C                             AND NHSTCD = *BLANKS                                     BUG24402
     C                   IF        %FOUND(SDGESTL0)                                         AR745942
     C                   EVAL      RCSTNM = GESTNM                                            CER054
     C                   ENDIF                                                              AR745942
     C                   ELSE                                                                 CER054
     C     *LOCK         IN        LDA                                                        CER054
     C                   EVAL      DBFile = 'SDGESTL0'                                        CER054
     C                   EVAL      DBKey = POptn                                              CER054
     C                   EVAL      DBase = 010                                                CER054
     C                   OUT       LDA                                                        CER054
     C                   EXSR      *PSSR                                                      CER054
     C                   ENDIF                                                                CER054
      *                                                                                       CER054
      ** Religious Affiliation                                                                CER054
      *                                                                                       CER054
     C                   EVAL      RCRLAF = NHRLAF                                            CER054
      *                                                                                       CER054
     C     NHRLAF        CHAIN     SDRLAFL0                                                   CER054
     C                   IF        %FOUND(SDRLAFL0)                                           CER054
     C                   EVAL      RCNARR = AFNARR                                            CER054
     C                   ELSE                                                                 CER054
     C     *LOCK         IN        LDA                                                        CER054
     C                   EVAL      DBFile = 'SDRLAFL0'                                        CER054
     C                   EVAL      DBKey = POptn                                              CER054
     C                   EVAL      DBase = 011                                                CER054
     C                   OUT       LDA                                                        CER054
     C                   EXSR      *PSSR                                                      CER054
     C                   ENDIF                                                                CER054
      *                                                                                       CER054
     C                   ENDIF                                                                CER054
      *                                                                                       CER047
      ** Issued Place                                                                         CER047
      *                                                                                       CER047
     C                   EVAL      RCISUP = NHISUP                                            CER047
      *                                                                                       CER048
      ** Document Number/Id                                                                   CER048
      *                                                                                       CER048
     C                   EVAL      RCDOCN = NHDOCN                                            CER048
      *                                                                                       CER048
      ** Industry Code                                                                        CER048
      *                                                                                       CER048
     C                   EVAL      RCINDC = NHINDC                                            CER048
      *                                                                                       CER048
      ** Spouse Reference                                                                     CER048
      *                                                                                       CER048
     C                   EVAL      RCSREF = NHSREF                                            CER048
      *                                                                                       CER048
     C                   ENDIF                                                                CER048
      *                                                                                       CER048
     C                   IF        CER047 = 'Y'                                               CER048
      *                                                                                       CER047
      ** Remark1                                                                              CER047
      *                                                                                       CER047
     C                   EVAL      RCRMK1 = NHRMK1                                            CER047
      *                                                                                       CER047
      ** Remark2                                                                              CER047
      *                                                                                       CER047
     C                   EVAL      RCRMK2 = NHRMK2                                            CER047
      *                                                                                       CER047
      ** Remark3                                                                              CER047
      *                                                                                       CER047
     C                   EVAL      RCRMK3 = NHRMK3                                            CER047
      *                                                                                       CER047
      ** Short Name                                                                           CER047
      *                                                                                       CER047
     C                   EVAL      RCSHNM = NHSHNM                                            CER047
      *                                                                                       CER047
      ** Country of Citizenship                                                               CER047
      *                                                                                       CER047
     C                   EVAL      RCCTYC = NHCTYC                                            CER047
      *                                                                                       CER047
      ** Country of Domicile                                                                  CER047
      *                                                                                       CER047
     C                   EVAL      RCCTYD = NHCTYD                                            CER047
      *                                                                                       CER047
      ** Expiry Date                                                                          CER047
      *                                                                                       CER047
     C                   EVAL      WDateDD = %SubSt(NHEXDT:7:2)                               CER047
     C                   EVAL      WDateMM = %SubSt(NHEXDT:5:2)                               CER047
     C                   EVAL      WDateYY = %SubSt(NHEXDT:3:2)                               CER047
     C                   EVAL      WDateDMY = WDateDD + WDateMM + WDateYY                     CER047
      *                                                                                       CER047
     C                   CALLB     'ZDATE1'                                                   CER047
     C                   PARM      WDateDMY      DateIn                                       CER047
     C                   PARM                    DayNoOut                                     CER047
     C                   PARM                    BJDFIN                                       CER047
     C                   PARM                    ErrorFlag                                    CER047
      *                                                                                       CER047
     C                   IF        ErrorFlag = 'Y'                                            CER047
     C                   EVAL      RCEXDT = *BLANKS                                           CER047
     C                   ELSE                                                                 CER047
     C                   EVAL      ZDAYNO = DayNoOut                                          CER047
     C                   EXSR      ZDATE2                                                     CER047
     C                   MOVEL(P)  ZADATE        RCEXDT                                       CER047
     C                   ENDIF                                                                CER047
      *                                                                                       CER047
      ** Phone                                                                                CER047
      *                                                                                       CER047
     C                   EVAL      RCPHON = NHPHON                                            CER047
      *                                                                                       CER047
     C                   ENDIF                                                                CER047
      *                                                                                       CER047
      ** Country of Citizenship                                                               CGL132
      ** Alternative Country of Citizenship                                                   CGL132
      ** TIN 2-5                                                                              CGL132
      ** Country of TIN 2-5                                                                   CGL132
      ** Creation Date                                                                        CGL132
      ** User Name                                                                            CGL132
                                                                                              CGL132
     C                   EVAL      RCOCZ = NHCOCZ                                             CGL132
     C                   EVAL      RACCZ = NHACCZ                                             CGL132
     C                   EVAL      RTIN2 = NHTIN2                                             CGL132
     C                   EVAL      RTIN3 = NHTIN3                                             CGL132
     C                   EVAL      RTIN4 = NHTIN4                                             CGL132
     C                   EVAL      RTIN5 = NHTIN5                                             CGL132
     C                   EVAL      RCTIN2 = NHCTN2                                            CGL132
     C                   EVAL      RCTIN3 = NHCTN3                                            CGL132
     C                   EVAL      RCTIN4 = NHCTN4                                            CGL132
     C                   EVAL      RCTIN5 = NHCTN5                                            CGL132
                                                                                              CGL132
     C                   IF        CGL157 = 'N'                                               CGL177
      ** TIN 6-10                                                                             CGL177
     C                   EVAL      RTIN6 = NHTIN6                                             CGL177
     C                   EVAL      RTIN7 = NHTIN7                                             CGL177
     C                   EVAL      RTIN8 = NHTIN8                                             CGL177
     C                   EVAL      RTIN8 = NHTIN9                                             CGL177
     C                   EVAL      RTIN0 = NHTIN0                                             CGL177
      ** Country of TIN 6-10                                                                  CGL177
     C                   EVAL      RCTIN6 = NHCTN6                                            CGL177
     C                   EVAL      RCTIN7 = NHCTN7                                            CGL177
     C                   EVAL      RCTIN8 = NHCTN8                                            CGL177
     C                   EVAL      RCTIN9 = NHCTN9                                            CGL177
     C                   EVAL      RCTIN0 = NHCTN0                                            CGL177
     C                   ENDIF                                                                CGL177
      *                                                                                       CGL177
      ** Additional TINs when CRS is ON, initialize fields                                    CGL177
     C                   IF        CGL157 = 'Y'                                               CGL177
      *                                                                                       CGL177
     C                   EVAL      CRSCTR = *ZERO                                             CGL177
      ** TIN                                                                                  CGL177
     C                   EVAL      RTIN2 = *BLANKS                                            CGL177
     C                   EVAL      RTIN3 = *BLANKS                                            CGL177
     C                   EVAL      RTIN4 = *BLANKS                                            CGL177
     C                   EVAL      RTIN5 = *BLANKS                                            CGL177
     C                   EVAL      RTIN6 = *BLANKS                                            CGL177
     C                   EVAL      RTIN7 = *BLANKS                                            CGL177
     C                   EVAL      RTIN8 = *BLANKS                                            CGL177
     C                   EVAL      RTIN9 = *BLANKS                                            CGL177
     C                   EVAL      RTIN0 = *BLANKS                                            CGL177
      ** Country of TIN                                                                       CGL177
     C                   EVAL      RCTIN = *BLANKS                                           CGL177
     C                   EVAL      RCTIN2 = *BLANKS                                           CGL177
     C                   EVAL      RCTIN3 = *BLANKS                                           CGL177
     C                   EVAL      RCTIN4 = *BLANKS                                           CGL177
     C                   EVAL      RCTIN5 = *BLANKS                                           CGL177
     C                   EVAL      RCTIN6 = *BLANKS                                           CGL177
     C                   EVAL      RCTIN7 = *BLANKS                                           CGL177
     C                   EVAL      RCTIN8 = *BLANKS                                           CGL177
     C                   EVAL      RCTIN9 = *BLANKS                                           CGL177
     C                   EVAL      RCTIN0 = *BLANKS                                           CGL177
      *                                                                                       CGL177
     C                   EVAL      KDNAHO = *BLANKS                                           CGL177
     C                   EVAL      KDCTRY = *BLANKS                                           CGL177
     C                   EVAL      KDNAHO = NHNAHO                                            CGL177
     C                   EVAL      KDCTRY = NHCOLC                                            CGL177
     C     KCRSN         KLIST                                                                CGL177
     C                   KFLD                    KDNAHO                                       CGL177
     C                   KFLD                    KDCTRY                                       CGL177
      *                                                                                       CGL177
     C     KCRSN         CHAIN     SDCRSNL0                           03                      CGL177
     C                   IF        %FOUND(SDCRSNL0)                                           CGL177
     C                   EVAL      RTIN  = *BLANKS                                            CGL177
     C                   EVAL      RTIN  = CNTINN                                             CGL177
     C                   EVAL      RCTIN = CNCTRY                                             CGL177
     C                   ENDIF                                                                CGL177
      *                                                                                       CGL177
      ** Read through CRS NAHO Country Detail File - Detail                                   CGL177
     C     NHNAHO        SETLL     SDCRSND0                                                   CGL177
     C     NHNAHO        READE     SDCRSND0                                                   CGL177
      *                                                                                       CGL177
     C                   DOW       NOT %EOF (SDCRSNL2)                                        CGL177
     C                             AND CRSCTR <= 9                                            CGL177
     C                             AND NHNAHO = CNNAHO                                        CGL177
      *                                                                                       CGL177
     C                   IF        NHCOLC <> CNCTRY                                           CGL177
     C                   EVAL      CRSCTR = CRSCTR + 1                                        CGL177
      *                                                                                       CGL177
     C                   SELECT                                                               CGL177
     C                   WHEN      CRSCTR = 1                                                 CGL177
     C                   EVAL      RTIN2 = CNTINN                                             CGL177
     C                   EVAL      RCTIN2 = CNCTRY                                            CGL177
     C                   WHEN      CRSCTR = 2                                                 CGL177
     C                   EVAL      RTIN3 = CNTINN                                             CGL177
     C                   EVAL      RCTIN3 = CNCTRY                                            CGL177
     C                   WHEN      CRSCTR = 3                                                 CGL177
     C                   EVAL      RTIN4 = CNTINN                                             CGL177
     C                   EVAL      RCTIN4 = CNCTRY                                            CGL177
     C                   WHEN      CRSCTR = 4                                                 CGL177
     C                   EVAL      RTIN5 = CNTINN                                             CGL177
     C                   EVAL      RCTIN5 = CNCTRY                                            CGL177
     C                   WHEN      CRSCTR = 5                                                 CGL177
     C                   EVAL      RTIN6 = CNTINN                                             CGL177
     C                   EVAL      RCTIN6 = CNCTRY                                            CGL177
     C                   WHEN      CRSCTR = 6                                                 CGL177
     C                   EVAL      RTIN7 = CNTINN                                             CGL177
     C                   EVAL      RCTIN7 = CNCTRY                                            CGL177
     C                   WHEN      CRSCTR = 7                                                 CGL177
     C                   EVAL      RTIN8 = CNTINN                                             CGL177
     C                   EVAL      RCTIN8 = CNCTRY                                            CGL177
     C                   WHEN      CRSCTR = 8                                                 CGL177
     C                   EVAL      RTIN9 = CNTINN                                             CGL177
     C                   EVAL      RCTIN9 = CNCTRY                                            CGL177
     C                   WHEN      CRSCTR = 9                                                 CGL177
     C                   EVAL      RTIN0 = CNTINN                                             CGL177
     C                   EVAL      RCTIN0 = CNCTRY                                            CGL177
     C                   ENDSL                                                                CGL177
      *                                                                                       CGL177
     C                   ENDIF                                                                CGL177
      *                                                                                       CGL177
     C     NHNAHO        READE     SDCRSND0                                                   CGL177
     C                   ENDDO                                                                CGL177
      *                                                                                       CGL177
     C                   ENDIF                                                                CGL177
      *                                                                                       CGL177
      ** Mailing Country 1-5                                                                  CGL177
     C                   EVAL      R2CTR1 = NHMCT1                                            CGL177
     C                   EVAL      R2CTR2 = NHMCT2                                            CGL177
     C                   EVAL      R2CTR3 = NHMCT3                                            CGL177
     C                   EVAL      R2CTR4 = NHMCT4                                            CGL177
     C                   EVAL      R2CTR5 = NHMCT5                                            CGL177
      ** Phone Number Country 1-5                                                             CGL177
     C                   EVAL      R2PHN1 = NHPCT1                                            CGL177
     C                   EVAL      R2PHN2 = NHPCT2                                            CGL177
     C                   EVAL      R2PHN3 = NHPCT3                                            CGL177
     C                   EVAL      R2PHN4 = NHPCT4                                            CGL177
     C                   EVAL      R2PHN5 = NHPCT5                                            CGL177
     C                                                                                        CGL177
     C                   EVAL      WDateDD = %SubSt(NHCRDT:7:2)                               CGL132
     C                   EVAL      WDateMM = %SubSt(NHCRDT:5:2)                               CGL132
     C                   EVAL      WDateYY = %SubSt(NHCRDT:3:2)                               CGL132
                                                                                              CGL132
     C                   IF        BJDFIN = 'D'                                               CGL132
     C                   EVAL      DateIn = WDateDD + WDateMM + WDateYY                       CGL132
     C                   ELSE                                                                 CGL132
     C                   EVAL      DateIn = WDateMM + WDateDD + WDateYY                       CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
     C                   CALLB     'ZDATE1'                                                   CGL132
     C                   PARM                    DateIn                                       CGL132
     C                   PARM                    DayNoOut                                     CGL132
     C                   PARM                    BJDFIN                                       CGL132
     C                   PARM                    ErrorFlag                                    CGL132
                                                                                              CGL132
     C                   IF        ErrorFlag = 'Y'                                            CGL132
     C                   EVAL      RCRDT = *Blanks                                            CGL132
     C                   ELSE                                                                 CGL132
     C                   EVAL      ZDAYNO = DayNoOut                                          CGL132
     C                   EXSR      ZDATE2                                                     CGL132
     C                   MOVEL(P)  ZADATE        RCRDT                                        CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
     C                   EVAL      RLUSR = NHLUSR                                             CGL132
                                                                                              CGL132
     C                   WRITE     HEADER2
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPrintDtl - Print Detail Routine                            *
      *                                                               *
      *****************************************************************
     C     SRPrintDtl    BEGSR
 
     C     NHNAHO        SETLL     SDNHTXL1
     C     NHNAHO        READE     SDNHTXL1                               77
 
      ** Print Country Tax Code/s Details
 
     C                   DOW       *IN77  = *OFF
 
      **   Country of Tax Code
 
     C                   EVAL      RCTYTX = NXCTTX
 
      **   Country Name
 
     C                   CALL      'AOCTRYR0'
     C                   PARM      *Blanks       PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      NXCTTX        PCtyCd
     C     SDCTRY        PARM      SDCTRY        DSFDY
 
     C                   IF        PRtcd <> *Blanks
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDCTRYL0'
     C                   EVAL      DBKEY  = PCtyCd
     C                   EVAL      DBASE  = 003
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE
     C                   EVAL      RCTYNM = A4CNNM
     C                   ENDIF
 
      **   European Tax Status
 
     C                   EVAL      REUTAX = NXETXS
 
      **   Certificate Tax Reference
 
     C                   EVAL      RCRREF = NXCERF
 
      **   Certificate Expiry Date
 
     C                   IF        NXCEEX = 0
     C                   EVAL      RCREXP = *Blanks
     C                   ELSE
     C                   EVAL      ZDAYNO = NXCEEX
     C                   EXSR      ZDATE2
     C                   MOVEL(P)  ZADATE        RCREXP
     C                   ENDIF
                                                                                              236137
      **   Non-account Holder Tax Status                                                      236137
                                                                                              236137
     C                   EVAL      RCNSTS = NXNSTS                                            236137
 
      ** Print Report Headers for every change in
      **   Non-A/c Reference or for every new page
 
     C                   EVAL      RqdLn1 = 1
     C                   EVAL      DifLn1 = OFLLN1 - PRTLN1
 
     C                   IF        DifLn1 <= RqdLn1
     C                   EXSR      SRPrintHdr1
     C                   EXSR      SRPrintHdr2
     C                   ENDIF
 
     C                   WRITE     DETAIL
 
     C     NHNAHO        READE     SDNHTXL1                               77
 
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPrintFtr - Print Footer Routine                            *
      *                                                               *
      *****************************************************************
     C     SRPrintFtr    BEGSR
 
     C                   IF        WRecNo > 0
     C                   WRITE     FOOTER
     C                   ENDIF
 
     C                   EXSR      SRAudit
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAudit - Write audit report                                 *
      *                                                               *
      *****************************************************************
     C     SRAudit       BEGSR
 
      ** Ensure Audit Spool File recorded by RCF.
 
     C                   EVAL      ZSnumU = SFNUMU
 
     C                   CALL      'ZSFILE'
     C                   PARM                    PSeq
     C                   PARM      *Blanks       SEnty
     C                   PARM                    SFILEU
     C                   PARM                    ZSnumU
     C                   PARM      *Blank        ZSerr
 
      ** If Error occurs during ZSFILE processing, then return to the
      ** Calling Program.
 
     C                   IF        ZSERR = 'Y'
     C                   EVAL      *InU7 = *On
     C                   EVAL      *InU8 = *On
     C                   EVAL      *InLR = *On
     C                   RETURN
     C                   ENDIF
 
     C                   WRITE     HEADAU
 
      ** Retrieve control details.
 
     C                   EVAL      WFName = 'SDNAHOPD'
     C     WFName        CHAIN     SDFCTLL1                           03
 
      ** Database error.
 
     C                   IF        NOT %FOUND(SDFCTLL1)
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = WFName
     C                   EVAL      DBFile = 'SDFCTLPA'
     C                   EVAL      DBase = 002
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      RINSER = AHNOIN
     C                   EVAL      RAMEND = AHNOAM
     C                   EVAL      RDELET = AHNODL
     C                   EVAL      RAUDIT = AHNORC
     C                   EVAL      RCOUNT = WRecNo
 
     C                   IF        RCOUNT <> RAUDIT
     C                   EVAL      *IN21 = *ON
     C                   ELSE
     C                   EVAL      *IN21 = *OFF
     C                   ENDIF
 
      ** If there is a DB Error, Output the DB Error Information.
 
     C                   IF        *INU7 = *ON
     C                   WRITE     DBERROR
     C                   ELSE
 
      ** If there is a record read, write audit control report.
 
     C                   IF        WRecNo <> 0
     C                   WRITE     CONTROL
     C                   ELSE
 
      ** Or, if no records read, Output "No Details" message.
 
     C                   WRITE     NODTLS
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *InzSr - Program Initialisation routine                      *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    PRtcd
     C                   PARM                    PMode
     C                   PARM                    PSeq
     C                   PARM                    PLevl
     C                   PARM                    PEnty
 
      ** Set off program indicators
 
     C                   EVAL      *INU7 = *OFF
     C                   EVAL      *INU8 = *OFF
 
     C     *DTAARA       DEFINE                  LDA
 
     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   OUT       LDA
 
      ** Access Bank details
      **   Retrieve Run day number
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *Blanks       PRtCd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY
 
     C                   IF        PRtCd <> *Blanks
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = POptn
     C                   EVAL      DBFile = 'SDBANKPD'
     C                   EVAL      DBase = 001
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE
     C                   EVAL      RRPTDS = BJURPT
     C                   ENDIF
      ** Check CSW207 feature                                                                 CSW207
     C                   CALL      'SWIF2007'                                                 CSW207
     C                   PARM      *BLANKS       PRtCd                                        CSW207
                                                                                              CSW207
     C                   IF        PRtCd = 'CSW2007'                                          CSW207
     C                   EVAL      CSW207 = 'Y'                                               CSW207
     C                   ELSE                                                                 CSW207
     C                   EVAL      CSW207 = 'N'                                               CSW207
     C                   ENDif                                                                CSW207
      ** Check CGL031 feature                                                                 CSW207
     C                   Call      'AOSARDR0'                                                 CSW207
     C                   Parm      *Blanks       PRtCd                                        CSW207
     C                   Parm      '*VERIFY'     POptn                                        CSW207
     C                   Parm      'CGL031'      PSARD                                        CSW207
     C                   Parm                    DSFDY                                        CSW207
                                                                                              CSW207
     C                   IF        PRtCd <> *BLANKS AND                                       CSW207
     C                             PRtCd <> '*NRF'                                            CSW207
     C     *LOCK         IN        LDA                                                        CSW207
     C                   EVAL      DBFile = 'CGL031'                                          CSW207
     C                   EVAL      DBKey = POptn                                              CSW207
     C                   EVAL      DBase = 004                                                CSW207
     C                   OUT       LDA                                                        CSW207
     C                   EXSR      *PSSR                                                      CSW207
     C                   ELSE                                                                 CSW207
     C                   IF        PRtCd = '*NRF   '                                          CSW207
     C                   EVAL      CGL031 = 'N'                                               CSW207
     C                   ELSE                                                                 CSW207
     C                   EVAL      CGL031 = 'Y'                                               CSW207
     C                   ENDIF                                                                CSW207
     C                   ENDIF                                                                CSW207
      ** Check CGL032 feature                                                                 CSW207
     C                   Call      'AOSARDR0'                                                 CSW207
     C                   Parm      *Blanks       PRtCd                                        CSW207
     C                   Parm      '*VERIFY'     POptn                                        CSW207
     C                   Parm      'CGL032'      PSARD                                        CSW207
     C                   Parm                    DSFDY                                        CSW207
                                                                                              CSW207
     C                   IF        PRtCd <> *BLANKS AND                                       CSW207
     C                             PRtCd <> '*NRF'                                            CSW207
     C     *LOCK         IN        LDA                                                        CSW207
     C                   EVAL      DBFile = 'CGL032'                                          CSW207
     C                   EVAL      DBKey = POptn                                              CSW207
     C                   EVAL      DBase = 005                                                CSW207
     C                   OUT       LDA                                                        CSW207
     C                   EXSR      *PSSR                                                      CSW207
     C                   ELSE                                                                 CSW207
     C                   IF        PRtCd = '*NRF   '                                          CSW207
     C                   EVAL      CGL032 = 'N'                                               CSW207
     C                   ELSE                                                                 CSW207
     C                   EVAL      CGL032 = 'Y'                                               CSW207
     C                   ENDIF                                                                CSW207
     C                   ENDIF                                                                CSW207
      *                                                                                       CER047
      ** Call AOSARDR0 to check for CER047                                                    CER047
      *                                                                                       CER047
     C                   CALL      'AOSARDR0'                                                 CER047
     C                   PARM      *Blanks       PRtCd                                        CER047
     C                   PARM      '*VERIFY'     POptn                                        CER047
     C                   PARM      'CER047'      PSARD                                        CER047
     C                   PARM                    DSFDY                                        CER047
      *                                                                                       CER047
     C                   IF        PRtCd = *BLANKS                                            CER047
     C                   EVAL      CER047 = 'Y'                                               CER047
     C                   EVAL      *IN37 = *ON                                                CER047
     C                   ELSE                                                                 CER047
     C                   EVAL      CER047 = 'N'                                               CER047
     C                   EVAL      *IN37 = *OFF                                               CER047
     C                   ENDIF                                                                CER047
      *                                                                                       CER047
     C                   IF        PRtCd <> *BLANKS AND                                       CER047
     C                             PRtCd <> '*NRF'                                            CER047
     C     *LOCK         IN        LDA                                                        CER047
     C                   EVAL      DBFile = 'SCSARDPD'                                        CER047
     C                   EVAL      DBKey = 'CER047'                                           CER047
     C                   EVAL      DBase = 007                                                CER047
     C                   OUT       LDA                                                        CER047
     C                   EXSR      *PSSR                                                      CER047
     C                   ENDIF                                                                CER047
      *                                                                                       CER048
      ** Call AOSARDR0 to check for CER048                                                    CER048
      *                                                                                       CER048
     C                   CALL      'AOSARDR0'                                                 CER048
     C                   PARM      *BLANKS       PRtCd                                        CER048
     C                   PARM      '*VERIFY'     POptn                                        CER048
     C                   PARM      'CER048'      PSARD                                        CER048
     C                   PARM                    DSFDY                                        CER048
      *                                                                                       CER048
     C                   IF        PRtCd <> *BLANKS AND                                       CER048
     C                             PRtCd <> '*NRF'                                            CER048
     C     *LOCK         IN        LDA                                                        CER048
     C                   EVAL      DBFile = 'SCSARDPD'                                        CER048
     C                   EVAL      DBKey = 'CER048'                                           CER048
     C                   EVAL      DBase = 008                                                CER048
     C                   OUT       LDA                                                        CER048
     C                   EXSR      *PSSR                                                      CER048
     C                   ENDIF                                                                CER048
      *                                                                                       CER048
     C                   IF        PRtCd = *BLANKS                                            CER048
     C                   EVAL      CER048 = 'Y'                                               CER048
     C                   EVAL      *IN38 = *ON                                                CER048
     C                   ELSE                                                                 CER048
     C                   EVAL      CER048 = 'N'                                               CER048
     C                   EVAL      *IN38 = *OFF                                               CER048
     C                   ENDIF                                                                CER048
      *                                                                                       CER054
      ** Call AOSARDR0 to check for CER054                                                    CER054
      *                                                                                       CER054
     C                   CALL      'AOSARDR0'                                                 CER054
     C                   PARM      *BLANKS       PRtCd                                        CER054
     C                   PARM      '*VERIFY'     POptn                                        CER054
     C                   PARM      'CER054'      PSARD                                        CER054
     C                   PARM                    DSFDY                                        CER054
      *                                                                                       CER054
     C                   IF        PRtCd <> *BLANKS AND                                       CER054
     C                             PRtCd <> '*NRF'                                            CER054
     C     *LOCK         IN        LDA                                                        CER054
     C                   EVAL      DBFile = 'SCSARDPD'                                        CER054
     C                   EVAL      DBKey = 'CER054'                                           CER054
     C                   EVAL      DBase = 009                                                CER054
     C                   OUT       LDA                                                        CER054
     C                   EXSR      *PSSR                                                      CER054
     C                   ENDIF                                                                CER054
      *                                                                                       CER054
     C                   IF        PRtCd = *BLANKS                                            CER054
     C                   EVAL      CER054 = 'Y'                                               CER054
     C                   EVAL      *IN39 = *ON                                                CER054
     C                   ELSE                                                                 CER054
     C                   EVAL      CER054 = 'N'                                               CER054
     C                   EVAL      *IN39 = *OFF                                               CER054
     C                   ENDIF                                                                CER054
      *                                                                                       CER048
      ** Check if Private Banking Module is available                                         CSW207
     C                   Call      'AOMMODR0'                                                 CSW207
     C                   Parm      *Blanks       PRtCd                                        CSW207
     C                   Parm      '*FIRST'      POptn                                        CSW207
     C     SDMMOD        PARM      SDMMOD        DSFDY                                        CSW207
                                                                                              CSW207
     C                   IF        PRtCd <> *BLANKS                                           CSW207
     C     *LOCK         IN        LDA                                                        CSW207
     C                   EVAL      DBFile = 'SDMMODPD'                                        CSW207
     C                   EVAL      DBKey = POptn                                              CSW207
     C                   EVAL      DBase = 006                                                CSW207
     C                   OUT       LDA                                                        CSW207
     C                   EXSR      *PSSR                                                      CSW207
     C                   ENDIF                                                                CSW207
     C                   IF        BGN4ST = 'Y'                                               CSW207
     C                   EVAL      PrivBank = 'Y'                                             CSW207
     C                   ENDIF                                                                CSW207
                                                                                              CSW207
     C                   IF        CSW207 = 'Y' OR                                            CSW207
     C                             PrivBank = 'Y'                                             CSW207
     C                   EVAL      *IN35 = *ON                                                CSW207
     C                   ELSE                                                                 CSW207
     C                   EVAL      *IN35 = *OFF                                               CSW207
     C                   ENDIF                                                                CSW207
     C                   IF        CGL031 = 'Y' AND                                           CSW207
     C                             CGL032 = 'Y'                                               CSW207
     C                   EVAL      *IN36 = *ON                                                CSW207
     C                   ELSE                                                                 CSW207
     C                   EVAL      *IN36 = *OFF                                               CSW207
     C                   ENDIF                                                                CSW207
                                                                                              CSW207
                                                                                              CGL177
      ** Check if enhancement CGL157 (CRS Reporting) is on                                    CGL177
                                                                                              CGL177
     C                   CALLB     'AOSARDR0'                                                 CGL177
     C                   PARM      *BLANKS       PRtCd                                        CGL177
     C                   PARM      '*VERIFY'     POptn                                        CGL177
     C                   PARM      'CGL157'      PSARD                                        CGL177
     C     SCSARD        PARM      SCSARD        DSFDY                                        CGL177
                                                                                              CGL177
     C                   IF        PRTCD <> *BLANKS  AND  PRTCD <> '*NRF   '                  CGL177
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CGL177
     C                   EVAL      DBKEY  = 'CGL157'                                          CGL177
     C                   EVAL      DBASE  = 4                                                 CGL177
     C                   EXSR      *PSSR                                                      CGL177
     C                   ENDIF                                                                CGL177
      *                                                                                       CGL177
     C                   IF        PRTCD = *BLANKS                                            CGL177
     C                   EVAL      CGL157 = 'Y'                                               CGL177
     C                   ELSE                                                                 CGL177
     C                   EVAL      CGL157 = 'N'                                               CGL177
     C                   ENDIF                                                                CGL177
                                                                                              CGL177
 
      ** Ensure Detail Spool File recorded by RCF.
 
     C                   EVAL      ZSnum = SFNUM1
 
     C                   CALL      'ZSFILE'
     C                   PARM                    PSeq
     C                   PARM      *Blanks       SEnty
     C                   PARM                    SFILE1
     C                   PARM                    ZSnum
     C                   PARM      *Blanks       ZSerr
 
     C                   IF        ZSErr = 'Y'
     C                   EVAL      *INU7 = *On
     C                   EVAL      *INU8 = *On
     C                   EVAL      *INLR = *On
     C                   RETURN
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ZDATE2 - Format a date for output                             *
      *                                                               *
      *****************************************************************
     C     ZDATE2        BEGSR
 
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
      *  *PSSR  - Program exception error routine                     *
      *           Called automatically if a program error occurs,     *
      *           or directly by the program code using EXSR.         *
      *           This subroutine DUMPs the program just once.        *
      *                                                               *
      *  Called by:                                                   *
      *                                                               *
      *  Calls:          None                                         *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
 
     C                   IF        WRun = *Blanks
     C                   EVAL      WRun = 'Y'
     C                   DUMP
     C                   ENDIF
 
     C                   EVAL      *INU7 = *On
     C                   EVAL      *INU8 = *On
     C                   EVAL      *INLR = *On
 
     C                   EXSR      SRAUDIT                                                    CER054
                                                                                              CER054
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
