     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2008')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL Journal Entry Interface')                     *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      ***GL001600 - Midas GL Journal Entry Interface                  *                       CER059
      *  GL001601 - Midas GL Journal Entry Interface                  *                       CER059
      *                                                               *
      *  Function: This program does the validation on the basis of   *
      *            the status of batch number.                        *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2008            *
      *                                                               *
      *  Last Amend No. CGL182             Date 11May17               *
      *  Prev Amend No. MD040602           Date 19Aug16               *
      *                 MD025865           Date 20Mar14               *
      *                 CER059             Date 19Jul10               *
      *                 BUG26846           Date 14Dec09               *
      *                 BUG26406           Date 13Oct09               *
      *                 BUG26086           Date 22Sep09               *
      *                 BUG25452           Date 11Aug09               *
      *                 BUG25184           Date 24Jul09               *
      *                 BUG25187           Date 24Jul09               *
      *                 BUG23669           Date 27Mar09               *
      *                 BUG23397           Date 17Mar09               *
      *                 BUG23217           Date 06Mar09               *
      *                 CER046   *CREATE   Date 19May08               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CGL182 - Journal Entry via the Interface File - Java Version *
      *           (Recompile)                                         *
      *  MD040602 - Initialise HQJETP to 'R' as otherwise inteface    *
      *             batched will not appear in JRNE ListView          *
      *  MD025865 - Transactions generated are on 'HELD' status and   *
      *             encounter errors.                                 *
      *           - Records for extension file GLJENHQD and GLJENPQD  *
      *             are not created.                                  *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG26846 - Batch could not be accepted                       *
      *  BUG26406 - Do not process batches that has no batch items    *
      *  BUG26086 - When system value is blank, override the status   *
      *             of the batch only if no errors were found         *
      *  BUG25452 - Interface Batches can be set to 'Accepted'        *
      *             even when in error                                *
      *  BUG25184 - Journal Batches interface process all Batches in  *
      *             in the interface file - even if they've been      *
      *             processed before.                                 *
      *  BUG25187 - Interface Batches do not update Projected Account *
      *             Movements.                                        *
      *  BUG23669 - Various errors in batch processing                *
      *  BUG23397 - Batch without details shows "Successful Transfer" *
      *  BUG23217 - Detail Reports were not processed                 *
      *  CER046 - German Features LF033-00 Payments & Clearing        *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** GL journal entry header interface
     FGLJEIHL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(@BRREAH:GLBRREAH)
      ** GL journal entry header interface                                                  BUG26406
     FGLJEIPL1  IF   E           K DISK    INFSR(*PSSR)                                     BUG26406
      *
      ** GL journal entry header
     FGLJENHL1  UF A E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(G_)
      ** GL journal entry header                                                            MD025865
     FGLJEHQL0  UF A E           K DISK    INFSR(*PSSR)                                     MD025865
     F                                     PREFIX(Q_)                                       MD025865
      *
      ** GL journal entry Report
     F***GL001600P1O    E             PRINTER INFSR(*PSSR)                                    CER059
     FGL001601P1O    E             PRINTER INFSR(*PSSR)                                       CER059
     F                                     INFDS(SPOOL1)
     F                                     USROPN
      *
      ** GL journal Postings Audit
     F***GL001600AUO    E             PRINTER INFSR(*PSSR)                                    CER059
     FGL001601AUO    E             PRINTER INFSR(*PSSR)                                       CER059
     F                                     INFDS(SPOOLU)
     F                                     USROPN
      *****************************************************************
      *                                                               *
      * ID F  C  H  L    FUNCTION OF INDICATORS                       *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E   I N D E X                              *
      *                                                               *
      *  *INZSR    - Program Initialisation Routine                   *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *  SRMain  - Main processing                                    *
      *  SRProceBcno- Processing for batch                            *
      *  SRBrchDtl-Access Branch Details                              *
      *  SRDeptCode- Access department code                           *
      *  SRWrite - Write the values to the fields of file GLJENHL1    *
      *  SRErrChk- Check for error and print the record in P1         *
      *  SRPrint - Print the record in P1                             *
      *  SRAudit - Write the report in AU (Audit)                     *
      *  SRZSfile- Process Report Lines                               *
      *  *PSSR  - Program Error Processing Subroutine                 *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      *
      ** The following /COPY line includes (among others) the LDA
      ** layout and the copyright array definition:
      *
      /COPY ZACPYSRC,STD_D_SPEC
      *
      ** The following /COPY includes the MM standard declares:
      *
      /COPY ZACPYSRC,STDDECLARE
      *
      ** The following /COPY line includes all the defined fields in
      ** the Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
      *
      /COPY ZACPYSRC,PSDS
      **---------------------------------------------------------------
 
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
     D DSSDY         E DS                  EXTNAME(DSSDY)
     D SDUSER        E DS                  EXTNAME(MUSERDD)
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
     D DSFDY         E DS                  EXTNAME(DSFDY)
     D SDDEPT        E DS                  EXTNAME(SDDEPTPD)
      *
      ***File*Information*Data*Structure*for*GL001600P1                                       CER059
      ** File Information Data Structure for GL001601P1                                       CER059
      *
     D SPOOL1          DS
     D   SFILE1               83     92
     D   SFNUM1              123    124B 0
     D   OFLLN1              188    189B 0
     D   PRTLN1              367    368B 0
      *
      ** File Information Data Structure for GL001600AU
      *
     D SPOOLU          DS
     D   SFILEU               83     92
     D   SFNUMU              123    124B 0
      *
     DPBatchParm       DS           200
     D WMode                          1A   INZ('E')
     D WBatchNum                      3A   INZ(*BLANKS)
     D WErrorFlag                     1A   INZ(*BLANKS)
     D WTotalInt                     15A   INZ(*BLANKS)
     D WTotalDecimal                  3A   INZ(*BLANKS)
     D WTotalItems                    3A   INZ(*BLANKS)
     D WHeadBranch                    3A   INZ(*BLANKS)
      *
      ** Array for the error
      *
     D ErrFlg          S              1A   DIM(3)
     D Err_Dtl         S             25A   DIM(4) CTDATA PERRCD(1)
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      ** Program Variables used
      *
     D PRtncd          S              7A   INZ(*BLANKS)
     D POptn           S              7A   INZ(*BLANKS)
     D PBrca           S              3A   INZ(*BLANKS)
     D PSeq            S              5A   INZ(*BLANKS)
     D PSenty          S              3A   INZ(*BLANKS)
     D PZSerr          S              1A   INZ(*BLANKS)
     D PSbcno          S                   LIKE(BRBTNB)
     D PDept           S                   LIKE(BRDPCD)
      ** Parameters for call to AOSARDRO                                                    BUG25187
      *                                                                                     BUG25187
     D PSard           S              6A                                                    BUG25187
     D PRTCD           S              7A                                                    BUG25187
      *                                                                                     BUG25187
     D CGL016          S              1A                                                    BUG25187
      *                                                                                     BUG25187
     D PBTNB           S              3A                                                    BUG25187
      *
      ** Parameter Variables to call 'AOSVALR0'
      *
     D PSValK1         S             20A
     D PSValK2         S             20A
     D PSValK3         S             20A
     D PSValK4         S             20A
     D PSValK5         S             20A
     D PSValK6         S             20A
     D PSValK7         S             20A
     D PSValK8         S             20A
     D PSValK9         S             20A
     D PSValK10        S             20A
     D PSVal1          S            200A
     D PSVal2          S            200A
     D PSVal3          S            200A
     D PSVal4          S            200A
     D PSVal5          S            200A
     D PSVal6          S            200A
     D PSVal7          S            200A
     D PSVal8          S            200A
     D PSVal9          S            200A
     D PSVal10         S            200A
      *
     D ZSfile          S             10A   INZ(*BLANKS)
     D*ZSnum****       S              1B 0 INZ(0)                                           BUG23217
     D ZSnum           S              6B 0 INZ(0)                                           BUG23217
      *
     D KBcno           S                   LIKE(BRBTNB)
      *
      ** Work variables used in the program
      *
     D WPrtCnt         S              1A   INZ(*BLANKS)
     D WOBcno          S                   LIKE(BRBTNB)
     D WFirst          S              1A   INZ(*BLANKS)
     D WKBcno          S                   LIKE(BRBTNB)
     D WCnt            S              1P 0 INZ(1)
     D WRqdln          S              1B 0
     D WDifl           S              2B 0
     D WBcno           S              3P 0
     D WValidCnt       S              6P 0
     D WInValidCnt     S              6P 0
     D WTotProcesd     S              6P 0
     D WTotalItemP     S              3P 0                                                  BUG23397
     D WTotalIntP      S             15P 0                                                  BUG23397
     D WTotalDecimalP  S              3P 0                                                  BUG23397
 
      ** Externally described DS for SAR details                                            BUG25187
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                BUG25187
     D L_CD          E                     EXTFLD(LCD)                                      BUG25187
                                                                                            BUG25187
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ Initial processing is performed automatically:the *INZSR is¦
      ** ¦ executed at program activation.                            ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *
      ** Main processing
      *
     C                   EXSR      SRMain
      *
      ** End the program
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRMain - Processing subroutine                                *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: SRProcsBcno, SRAudit                                   *
      *                                                               *
      *****************************************************************
     C     SRMain        BEGSR
      *
     C     *LOVAL        SETLL     GLJEIHL1
     C                   READ      GLJEIHL1
      *
     C                   DOW       NOT %EOF(GLJEIHL1)
      *
      ** Reset the values
      *
     C                   CLEAR                   ErrFlg
     C**********         MOVE      BRBTNB        WBcno                                      BUG25184
     C**********         MOVE      WBcno         KBcno                                      BUG25184
     C                   EVAL      KBcno  = BRBTNB                                          BUG25184
     C                   EVAL      PRtncd = *BLANKS
     C                   EVAL      WOBcno = BRBTNB
     C                   EVAL      PSbcno = *BLANKS
     C                   EVAL      WCnt = 1
      *
      ** Processing for the validation of batch numbers
      *
     C     KBcno         CHAIN     GLJEIPL1                                                 BUG26406
     C                   IF        %FOUND(GLJEIPL1)                                         BUG26406
     C                   EXSR      SRProcsBcno
     C                   ENDIF                                                              BUG26406
      *
     C                   READ      GLJEIHL1
     C                   ENDDO
      *
      ** Write the report in AU
      *
     C                   EXSR      SRAudit
      *
      ** Close the Spool Files
      *
     C**********         IF        %OPEN(GL001600P1)                                          CER059
     C**********         CLOSE     GL001600P1                                                 CER059
     C                   IF        %OPEN(GL001601P1)                                          CER059
     C                   CLOSE     GL001601P1                                                 CER059
     C                   ENDIF
      *
     C**********         IF        %OPEN(GL001600AU)                                          CER059
     C**********         CLOSE     GL001600AU                                                 CER059
     C                   IF        %OPEN(GL001601AU)                                          CER059
     C                   CLOSE     GL001601AU                                                 CER059
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRProcsBcno - Processing for the validation of the batch no.  *
      *                                                               *
      * Called by: SRMain                                             *
      *                                                               *
      * Calls: SRBrchDtl, SRDeptCode, SRErrChk, SRWrite               *
      *                                                               *
      *****************************************************************
     C     SRProcsBcno   BEGSR
      *
      ** Access branch details
      *
     C                   EXSR      SRBrchDtl
      *
     C                   IF        PRtncd <> *BLANKS
     C                   MOVEA     'Y'           ErrFlg(1)
     C                   ENDIF
      *
      ** Access department codes
      *
     C                   EXSR      SRDeptCode
      *
     C                   IF        PRtncd <> *BLANKS
     C                   MOVEA     'Y'           ErrFlg(2)
     C                   ENDIF
      *
      ***Check*for new available batch number, If batch number exists                       BUG25184
      ***then*increment by 1 and check again                                                BUG25184
      *********                                                                             BUG25184
     C**********         EVAL      WKBcno = KBcno                                           BUG25184
      **********                                                                            BUG25184
     C**********         DOW       NOT %EOF(GLJENHL1)                                       BUG25184
     C     KBcno         CHAIN(N)  GLJENHL1
      *
     C**********         IF        %FOUND(GLJENHL1)                                         BUG25184
     C                   IF        NOT %FOUND(GLJENHL1)                                     BUG25184
      *
      ***Check*if batch number is reached upto 999                                          BUG25184
      **********                                                                            BUG25184
     C**********         IF        WBcno = 999                                              BUG25184
     C**********         EVAL      WBcno = *ZEROS                                           BUG25184
     C**********         ENDIF                                                              BUG25184
      *********                                                                             BUG25184
     C**********         EVAL      WBcno = WBcno + 1                                        BUG25184
     C**********         MOVE      WBcno         KBcno                                      BUG25184
      *
      ** Check if batch number is reached upto old batch number, means
      ** no batch number is free from 001 to 999. Hence an error
      *
     C**********         IF        WKBcno = KBcno                                           BUG25184
     C                   IF        KBcno = '999'                                            BUG25184
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C**********         ELSE                                                               BUG25184
     C**********         LEAVE                                                              BUG25184
     C**********         ENDIF                                                              BUG25184
      *
     C**********         ENDDO                                                              BUG25184
      *
     C                   EVAL      WTotalItemP = *ZEROS                                     BUG23397
     C                   EVAL      WTotalIntP = *ZEROS                                      BUG23397
     C                   EVAL      WTotalDecimalP = *ZEROS                                  BUG23397
     C                   EVAL      WBatchNum   = KBcno
     C                   EVAL      WHeadBranch = BRBCDA
     C                   EVAL      WErrorFlag = 'N'                                         BUG26846
      *
     C                   CALL(E)   'GL0150U'
     C                   PARM                    WOBcno
     C                   PARM                    PSbcno
     C                   PARM                    PBatchParm
      *
     C                   IF        %ERROR
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   MOVE      WTotalItems   WTotalItemP                                BUG23397
     C                   MOVE      WTotalInt     WTotalIntP                                 BUG23397
     C                   MOVE      WTotalDecimal WTotalDecimalP                             BUG23397
      *                                                                                     BUG23397
     C**********         IF        WErrorFlag = 'Y'                                         BUG23397
     C                   IF        WErrorFlag = 'Y' OR                                      BUG23397
     C                             BRHINI <> WTotalItemP OR                                 BUG23397
     C                             BRHIIN <> WTotalIntP OR                                  BUG23397
     C                             BRHDIN <> WTotalDecimalP                                 BUG23397
     C                   MOVEA     'Y'           ErrFlg(3)
     C                   ENDIF
      *
      ** Check for error and print the record in P1
      *
     C                   EXSR      SRErrChk
      *
      ** If Branch is in Error, this cannot be repaired and therefore
      ** there is no need to write it on the file anymore
 
     C                   IF        ErrFlg(1) <> 'Y'
     C                   EXSR      SRWrite
     C                   ENDIF
      *
     C                   ENDIF                                                              BUG25184
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRBrchDtl - Access Branch Details                             *
      *                                                               *
      * Called by: SRProcsBcno                                        *
      *                                                               *
      * Calls:   AOBRCHR0                                             *
      *                                                               *
      *****************************************************************
     C     SRBrchDtl     BEGSR
      *
      ** Access branch details
      *
     C                   CALL      'AOBRCHR0'
     C                   PARM      '*MSG   '     PRtncd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      BRBCDA        PBrca
     C     SDBRCH        PARM      SDBRCH        DSFDY
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRDeptCode - Access department code                           *
      *                                                               *
      * Called by: SRProcsBcno                                        *
      *                                                               *
      * Calls:   AODEPTR0                                             *
      *                                                               *
      *****************************************************************
     C     SRDeptCode    BEGSR
      *
      ** Access department code
      *
     C                   CALL      'AODEPTR0'
     C                   PARM      '*BLANKS '    PRtncd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      BRDPCD        PDept
     C     SDDEPT        PARM      SDDEPT        DSFDY
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRWrite -  Write the values to the fields of file GLJENHL1    *
      *                                                               *
      * Called by: SRProcsBcno                                        *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRWrite       BEGSR
      *
      ** Write the values to the fields of file GLJENHL1
      ** for error in processing
      *
     C                   IF        ErrFlg(2) = *BLANKS AND
     C                             ErrFlg(3) = *BLANKS
     C                   EVAL      G_BRVALI = 'Y'
     C                   MOVE      WTotalInt     G_BRHIIN
     C                   MOVE      WTotalDecimal G_BRHDIN
     C                   MOVE      WTotalItems   G_BRHINI
     C                   EVAL      WValidCnt = WValidCnt + 1
      *
      ** Write the values to the fields of file GLJENHL1
      ** for valid Branch or no error in processing
      *
     C                   ELSE
     C                   EVAL      G_BRVALI = 'N'
     C                   EVAL      G_BRHIIN = BRHIIN
     C                   EVAL      G_BRHDIN = BRHDIN
     C                   EVAL      G_BRHINI = BRHINI
     C                   EVAL      BRBTSF = 'H'
     C                   EVAL      WInValidCnt = WInValidCnt + 1
     C                   ENDIF
      *
      ** Set Hash integer, decimal, item calculated
      *
     C                   MOVE      WTotalInt     BRHICC                                     BUG23669
     C                   MOVE      WTotalDecimal BRHDCC                                     BUG23669
     C                   MOVE      WTotalItems   BRHINC                                     BUG23669
      *
      ** Override status with the system value
 
     C                   IF        PSVal1 <> *BLANKS
     C**********                   and %LOOKUP('Y':ErrFlg) = 0                     BUG25452 BUG26086
     C                   EVAL      BRBTSF = PSVal1
     C**********         Else                                                      BUG25452 BUG26086
     C                   ENDIF                                                              BUG26086
                                                                                            BUG26086
     C                   IF        %LOOKUP('Y':ErrFlg) <> 0                                 BUG26086
     C                   EVAL      BRBTSF = 'H'                                             BUG25452
     C                   ENDIF
 
     C                   EVAL      G_BRBTNB = KBCNO
     C                   EVAL      G_BRBCDA = BRBCDA
     C                   EVAL      G_BRDPCD = BRDPCD
     C                   EVAL      G_BRWSID = BRWSID
     C                   EVAL      G_BRHICC = BRHICC
     C                   EVAL      G_BRHDCC = BRHDCC
     C                   EVAL      G_BRHINC = BRHINC
     C                   EVAL      G_BRBTSF = BRBTSF
     C                   EVAL      G_BRBIUF = BRBIUF
     C                   EVAL      G_BRSHPI = BRSHPI
     C                   EVAL      G_BRRAPI = BRRAPI
     C                   EVAL      G_BRMBRB = BRMBRB
     C                   EVAL      G_BRRVVD = BRRVVD
     C                   EVAL      G_BRBDES = BRBDES
     C                   EVAL      G_BRSPTT = BRSPTT
     C                   EVAL      G_BRNIST = BRNIST
     C                   EVAL      G_BRSPRF = BRSPRF
     C                   EVAL      G_BRDCIN = BRDCIN
     C                   EVAL      G_BRIBCF = BRIBCF
     C                   EVAL      G_BRCUSF = BRCUSF
     C                   EVAL      G_BRCYCF = BRCYCF
     C                   EVAL      G_BRACCF = BRACCF
     C                   EVAL      G_BRACSF = BRACSF
     C                   EVAL      G_BRNNBF = BRNNBF
     C                   EVAL      G_BRRACF = BRRACF
     C                   EVAL      G_BRPRCF = BRPRCF
     C                   EVAL      G_BRAMTF = BRAMTF
     C                   EVAL      G_BRIBCT = BRIBCT
     C                   EVAL      G_BRCYCT = BRCYCT
     C                   EVAL      G_BRCNAT = BRCNAT
     C                   EVAL      G_BRACCT = BRACCT
     C                   EVAL      G_BRASNT = BRASNT
     C                   EVAL      G_BRNNBT = BRNNBT
     C                   EVAL      G_BRRACT = BRRACT
     C                   EVAL      G_BRTOJE = BRTOJE
     C                   EVAL      G_BRUSRI = *BLANKS
     C                   EVAL      G_BRUSRA = *BLANKS
     C                   EVAL      G_BRFRNT = *BLANKS
     C                   EVAL      G_BRAFRT = *BLANKS
     C                   EVAL      G_BRTMST = *LOVAL
     C**********         EVAL      G_BRBHAI = *BLANKS                                       BUG23669
     C                   EVAL      G_BRBHAI = BRBTSF                                        BUG23669
     C                   EVAL      G_BRACCF = *BLANKS
     C                   EVAL      G_BRACCT = *BLANKS
     C                   EVAL      G_BRMEAB = *BLANKS
     C                   EVAL      G_BRAUTH = *BLANKS
      *
     C                   WRITE(E)  @BRREAH
      *                                                                                     MD025865
     C                   EVAL      Q_HQBTCH = BRBTNB                                        MD025865
     C                   EVAL      Q_HQBRCD = BRBCDA                                        MD025865
     C                   EVAL      Q_HQFRID = *BLANKS                                       MD025865
     C**********         EVAL      Q_HQJETP = BRTOJE                               MD025865 MD040602
     C                   EVAL      Q_HQJETP = 'R'                                           MD040602
      *                                                                                     MD025865
     C                   WRITE(E)  GLJEHQD0                                                 MD025865
      *
     C                   IF        %ERROR
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** If batch status is accepted, submit batch for shadow posting                       BUG25187
      *                                                                                     BUG25187
     C                   IF        (BRBTSF = 'A') AND                                       BUG25187
     C                             (BRSHPI <> 'Y') AND                                      BUG25187
     C                             (CGL016 <> 'Y')                                          BUG25187
     C                   CALL      'GLSBMBCH'                                               BUG25187
     C                   PARM      *BLANK        PRTCD                                      BUG25187
     C                   PARM      BRBTNB        PBTNB                                      BUG25187
     C                   ENDIF                                                              BUG25187
                                                                                            BUG25187
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRErrChk -  Check for error and print the record in P1        *
      *                                                               *
      * Called by: SRProcsBcno                                        *
      *                                                               *
      * Calls: SRZSfile, SRPrint                                      *
      *                                                               *
      *****************************************************************
     C     SRErrChk      BEGSR
      *
     C                   EVAL      WPrtCnt = *BLANKS
     C                   EVAL      *IN30 = *OFF
      *
      ** Ensure Detail Spool File recorded by RCF
      *
     C**********         IF        NOT %OPEN(GL001600P1)                                      CER059
     C**********         OPEN      GL001600P1                                                 CER059
     C                   IF        NOT %OPEN(GL001601P1)                                      CER059
     C                   OPEN      GL001601P1                                                 CER059
     C                   EVAL      WFirst = 'Y'
      *
     C                   EVAL      ZSfile = SFILE1
     C                   EVAL      ZSnum  = SFNUM1
      *
     C                   EXSR      SRZSfile
     C                   ENDIF
      *
      ** Generate the P1 report
      *
     C                   IF        %LOOKUP('Y':ErrFlg) = 0
      *
     C                   EVAL      RBSTAT = Err_Dtl(4)
     C                   EXSR      SRPrint
      *
     C                   ELSE
      *
     C                   DOW       WCnt <= 3
     C                   EVAL      WCnt = %LOOKUP('Y':ErrFlg:WCnt)
      *
     C                   IF        WCnt<>0
     C
     C                   IF        WPrtCnt = 'Y'
     C                   EVAL      *IN30 = *ON
     C                   ENDIF
      *
     C                   EVAL      RBSTAT = Err_Dtl(WCnt)
     C                   EXSR      SRPrint
     C                   EVAL      WPrtCnt = 'Y'
     C                   EVAL      WCnt = WCnt + 1
      *
     C                   ELSE
     C                   LEAVE
      *
     C                   ENDIF
     C                   ENDDO
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRPrint -  Print the record in P1                             *
      *                                                               *
      * Called by: SRErrChk                                           *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRPrint       BEGSR
      *
     C                   IF        *IN30 = *OFF
     C                   EVAL      RBBTNB = WOBCNO
     C                   EVAL      RBNBTN = KBCNO
     C                   EVAL      RBDPCD = BRDPCD
     C                   EVAL      RBBDES = BRBDES
     C                   MOVE      BRHINI        RBHINI
     C                   MOVE      BRHINC        RBHINC
     C                   ENDIF
      *
      ** For initial print of details
      *
     C                   IF        WFirst = 'Y'
     C                   WRITE(E)  HEADER1
      *
     C                   IF        %ERROR
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   EVAL      WFirst = *BLANKS
     C                   ELSE
      *
      ** For overflow has occured print the Header of the report
      *
     C                   EVAL      WRqdln = 1
     C                   EVAL      WDifl = OFLLN1 - PRTLN1
      *
     C                   IF        WDifl <= WRqdln
     C                   WRITE(E)  HEADER1
      *
     C                   IF        %ERROR
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Write details to printer fields
      *
     C                   WRITE(E)  DEATIL1
      *
     C                   IF        %ERROR
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRAudit -  Write the report in AU (Audit)                     *
      *                                                               *
      * Called by: SRMain                                             *
      *                                                               *
      * Calls: SRZSfile                                               *
      *                                                               *
      *****************************************************************
     C     SRAudit       BEGSR
      *
      ** Ensure Detail Spool File recorded by RCF
      *
     C**********         IF        NOT %OPEN(GL001600AU)                                      CER059
     C**********         OPEN      GL001600AU                                                 CER059
     C                   IF        NOT %OPEN(GL001601AU)                                      CER059
     C                   OPEN      GL001601AU                                                 CER059
     C                   EVAL      ZSfile = SFILEU
     C                   EVAL      ZSnum  = SFNUMU
     C                   EXSR      SRZSfile
     C                   ENDIF
      *
     C                   EVAL      WTotProcesd = WValidCnt +
     C                                           WInValidCnt
      *
     C                   WRITE(E)  HEADERU
      *
     C                   IF        %ERROR
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   MOVE      WValidCnt     RBTVAL
     C                   MOVE      WInValidCnt   RBTIVL
     C                   MOVE      WTotProcesd   RBTIPRC
      *
     C                   WRITE(E)  DETAILU
      *
     C                   IF        %ERROR
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRZSfile - Process Report Lines                               *
      *                                                               *
      * Called by: SRPrint                                            *
      *                                                               *
      * Calls: ZSFILE                                                 *
      *****************************************************************
     C     SRZSfile      BEGSR
      *
     C                   CALL      'ZSFILE'
     C                   PARM                    PSeq
     C                   PARM      *BLANKS       PSenty
     C                   PARM                    ZSfile
     C                   PARM                    ZSnum
     C                   PARM      *BLANKS       PZSerr
      *
      ** If Error occurs during ZSFILE processing, then return to the
      ** Calling Program.
      *
     C                   IF        PZSerr = 'Y'
     C                   SETON                                        U7U8LR
     C                   RETURN
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Initial Processing                                   *
      *                                                               *
      * Called by:                                                    *
      *                                                               *
      * Calls: AOUSERR0                                               *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
      *
     C                   CALL      'AOUSERR0'
     C                   PARM      *BLANKS       PRtncd
     C                   PARM      '*KEY   '     POptn
     C                   PARM                    PSUser
     C     SDUSER        PARM      SDUSER        DSSDY
      *
      ** An NRF (No Record Found) return code is valid.
      ** Issue database error only for error return codes.
      *
     C                   IF        PRtncd <> *BLANKS AND
     C                                    PRtncd <> '*NRF   '
     C                   EVAL      DBFile = 'ZMUSER'
     C                   EVAL      DBKey = PSUser
     C                   EVAL      DBase = 001
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   CALL      'AOSVALR0'
     C                   PARM      *BLANKS       PRtncd
     C                   PARM      'SWITIDefSts' PSValK1
     C                   PARM                    PSVal1
     C                   PARM      *BLANKS       PSValK2
     C                   PARM                    PSVal2
     C                   PARM      *BLANKS       PSValK3
     C                   PARM                    PSVal3
     C                   PARM      *BLANKS       PSValK4
     C                   PARM                    PSVal4
     C                   PARM      *BLANKS       PSValK5
     C                   PARM                    PSVal5
     C                   PARM      *BLANKS       PSValK6
     C                   PARM                    PSVal6
     C                   PARM      *BLANKS       PSValK7
     C                   PARM                    PSVal7
     C                   PARM      *BLANKS       PSValK8
     C                   PARM                    PSVal8
     C                   PARM      *BLANKS       PSValK9
     C                   PARM                    PSVal9
     C                   PARM      *BLANKS       PSValK10
     C                   PARM                    PSVal10
      *
     C                   IF        PRtncd <> *BLANKS
      *
     C     *LOCK         IN        LDA
     C**********         EVAL      DBPGM = 'GL001600'                                         CER059
     C                   EVAL      DBPGM = 'GL001601'                                         CER059
     C                   EVAL      DBFILE = 'SDSVALPD'
     C                   EVAL      DBASE = 001
     C                   EVAL      DBKEY = %TRIM(PSValK1)
     C                   OUT       LDA
      *
     C                   EXSR      *PSSR
      *
     C                   ENDIF
 
     ** Access SAR details for Projected Movements Update Prior to Auth.                    BUG25187
                                                                                            BUG25187
     C                   MOVEL     'N'           CGL016                                     BUG25187
     C                   CALLB     'AOSARDR0'                                               BUG25187
     C                   PARM      *BLANKS       PRTCD                                      BUG25187
     C                   PARM      '*VERIFY'     POPTN                                      BUG25187
     C                   PARM      'CGL016'      PSARD                                      BUG25187
     C     SCSARD        PARM      SCSARD        DSFDY                                      BUG25187
                                                                                            BUG25187
     C     PRTCD         IFEQ      *BLANK                                                   BUG25187
     C                   MOVEL     'Y'           CGL016                                     BUG25187
     C                   ENDIF                                                              BUG25187
                                                                                            BUG25187
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** Program, module and procedure names for database error
      ** processing.
      *****************************************************************
      *
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      *
     C/COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
      /EJECT
      *****************************************************************
** CTDATA CPY@
(c) Misys International Banking Systems Ltd. 2004
** CTDATA Err_Dtl
Error in Branch
Error in Dept Code
Error in Batch
Successful Transfer
