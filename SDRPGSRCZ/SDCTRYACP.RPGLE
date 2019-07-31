     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2006')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Country Code Acceptance')                     *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  SDCTRYACP - SD Account Code Acceptance                       *
      *                                                               *
      *  Function:  This program updates the zonal file and the       *
      *             acceptance file based on the data sent by the     *
      *             background job SDC000060.                         *
      *                                                               *
      *  Called By: SDC000060 - SD Central Data Acceptance Background *
      *                         Job                                   *
      *             SDC000061 - SD Central Data Acceptance on         *
      *                         Effective Date                        *
      *                                                               *
      *  (c) Finastra International Limited 2006                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CLE134             Date 01Aug12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG11806           Date 30Jul06               *
      *                 CSD031  *CREATE    Date 10Apr06               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  BUG11806 - Extension tables processing.                      *
      *  CSD031 - Enhanced Centralised Static Data                    *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    XX         Function of Indicator                           *
      *    98         Date Format                                     *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRZONE    - Zonal file update routine                        *
      *  SRACCP    - Acceptance file update routine                   *
      *  SRDELAY   - Delay job routine                                *
      * *PSSR      - Error processing                                 *
      * *INZSR     - Initialise                                       *
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
 
      ** SD Country Code Update Logical File
     FSDCTRYL0  UF A E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
 
      ** SD Control Update Logical File
     FSDFCTLL0  UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
 
      ** SD Country Code Acceptance Update Logical File
     FSDACTYL0  UF A E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
 
      ** SD Country Code Details Extension                                                  BUG11806
     FSDCTX1L0  IF A E           K DISK    INFSR(*PSSR)                                     BUG11806
     F                                     RENAME(SDCTRYDL: SDCTX1D0)                       BUG11806
     F                                     COMMIT                                           BUG11806
                                                                                            BUG11806
      ** SD Country Code LU Extension                                                       BUG11806
     FSDCTX2L0  IF A E           K DISK    INFSR(*PSSR)                                     BUG11806
     F                                     RENAME(SDCTRYF6: SDCTX2D0)                       BUG11806
     F                                     COMMIT                                           BUG11806
                                                                                            BUG11806
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
 
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
 
      ** Data Area giving Installation Control Details
 
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
      ** Program Status Data Structure
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
     D C_AutoAccept    C                   CONST('Y')
     D C_AcceptEffDte  C                   CONST('SDC000061')
     D C_Filename      C                   CONST('SDCTRYPD  ')
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D W_SDACTYPD    E DS                  EXTNAME(SDACTYPD)
 
      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** External DS for Switchable Feature Details                                         BUG11806
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                BUG11806
                                                                                            BUG11806
      ** First DS for access programs, short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D @RUN            S              1
 
      ** Entry parameters
     D PData           S           4000A
     D PRetCode        S              7A
     D PProgram        S             10A
 
      ** Access Object Parameters                                                           BUG11806
     D PRtCd           S              7A                                                    BUG11806
     D POptn           S              7A                                                    BUG11806
     D PSARD           S              6A                                                    BUG11806
                                                                                            BUG11806
      ** Switchable Features                                                                BUG11806
     D ULX004          S              1A                                                    BUG11806
     D ULX043          S              1A                                                    BUG11806
                                                                                            BUG11806
      ** Key fields
     D KA4Cncd         S                   LIKE(A4CNCD)
     D KAHFlnm         S                   LIKE(AHFLNM)
     D KCTXn           S                   LIKE(A4CNCD)                                     BUG11806
 
      ** QCMDEXC Parameters
     D QCMD            S             80A
     D QLEN            S             15  5
 
      ** Work variables
     D WAHNORC         S                   LIKE(AHNORC)
     D WAHNOIN         S                   LIKE(AHNOIN)
     D WAHNOAM         S                   LIKE(AHNOAM)
     D W_Attempt       S              3  0
 
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
 
      ** Read in Installation Data
 
     C     *DTAARA       DEFINE                  RUNDAT
     C     *DTAARA       DEFINE                  LDA
     C                   IN        RUNDAT
 
      ** Set Date Format Indicator *IN98  on if date format is MMDDYY
 
     C                   IF        AGDFF = 'M'
     C                   EVAL      *IN98 = *ON
     C                   ENDIF
 
      ** Move country code data for processing
 
     C                   EVAL      PRetcode = *Blanks
     C                   EVAL      W_Sdactypd = PData
 
     C                   IF        A4AACC   = C_AutoAccept   OR
     C                             PProgram = C_AcceptEffDte
 
     C                   EXSR      SRZONE
     C                   ELSE
 
     C                   EXSR      SRACCP
     C                   ENDIF
 
      ** Commit changes if no error was encountered
 
     C                   IF        PRetcode = *Blanks
     C                   COMMIT
     C                   ELSE
     C                   ROLBK
     C                   ENDIF
 
      ** Exit program
 
     C                   EVAL      *Inlr = *On
     C                   RETURN
 
      *****************************************************************
      *                                                               *
      * SRZONE - Zonal File Update Routine                            *
      *                                                               *
      *****************************************************************
 
     C     SRZONE        BEGSR
 
      ** Update country code
 
     C                   EVAL      KA4Cncd = A4CNCD
     C                   EVAL      W_Attempt = 0
 
     C                   DOW       W_Attempt < 100
     C     K@Sdctryl0    CHAIN(E)  SDCTRYL0
 
      ** If record is locked to another job, wait 1 second and try again
 
     C                   IF        %ERROR
     C                   EXSR      SRDELAY
     C                   EVAL      W_Attempt = W_Attempt + 1
     C                   ELSE
     C                   LEAVE
     C                   ENDIF
 
     C                   ENDDO
 
     C                   IF        %ERROR
 
      ** Database update error
 
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'SDCTRYL0'
     C                   EVAL      DBKEY  =  KA4Cncd
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   EVAL      DBASE  =  001
     C                   EVAL      DBMOD  =  PSProcMod
     C                   EVAL      DBPROC =  'SR/SRZONE '
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        %FOUND(SDCTRYL0)
 
      ** Reload input data before updating record,
      ** all fields are maintained centrally
 
     C                   EVAL      W_Sdactypd = PData
     C                   EVAL      A4TYLC  = 'A'
     C                   EVAL      A4EACC  = BJRDNB
     C                   EVAL      A4LCD   = BJRDNB
     C                   UPDATE    @A4REBS
 
      ** Setup 'amend' count
 
     C                   EVAL      WAHNORC = 0
     C                   EVAL      WAHNOIN = 0
     C                   EVAL      WAHNOAM = 1
     C                   ELSE
 
      ** Write to zonal file if not found
 
     C                   EVAL      A4TYLC  = 'I'
     C                   EVAL      A4EACC  = BJRDNB
     C                   EVAL      A4LCD   = BJRDNB
     C                   WRITE     @A4REBS
 
      ** Setup 'insert' count
 
     C                   EVAL      WAHNORC = 1
     C                   EVAL      WAHNOIN = 1
     C                   EVAL      WAHNOAM = 0
     C                   ENDIF
 
      ** Update control file
 
     C                   EVAL      KAHFlnm = C_Filename
     C                   EVAL      W_Attempt = 0
 
     C                   DOW       W_Attempt < 100
     C     K@Sdfctll0    CHAIN(E)  SDFCTLL0
 
      ** If record is locked to another job, wait 1 second and try again
 
     C                   IF        %ERROR
     C                   EXSR      SRDELAY
     C                   EVAL      W_Attempt = W_Attempt + 1
     C                   ELSE
     C                   LEAVE
     C                   ENDIF
 
     C                   ENDDO
 
     C                   IF        %ERROR
 
      ** Database update error
 
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'SDFCTLL0'
     C                   EVAL      DBKEY  =  KAHFlnm
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   EVAL      DBASE  =  002
     C                   EVAL      DBMOD  =  PSProcMod
     C                   EVAL      DBPROC =  'SR/SRZONE '
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        %FOUND(SDFCTLL0)
 
     C                   EVAL      AHNORC = AHNORC + WAHNORC
     C                   EVAL      AHNOIN = AHNOIN + WAHNOIN
     C                   EVAL      AHNOAM = AHNOAM + WAHNOAM
 
     C                   UPDATE    @AHREAU
     C                   ELSE
 
      ** Database update error
 
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'SDFCTLL0'
     C                   EVAL      DBKEY  =  KAHFlnm
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   EVAL      DBASE  =  003
     C                   EVAL      DBMOD  =  PSProcMod
     C                   EVAL      DBPROC =  'SR/SRZONE '
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Write to extension tables.                                                         BUG11806
                                                                                            BUG11806
     C                   IF        A4TYLC = 'I'                                             BUG11806
     C                   EXSR      SREXTN                                                   BUG11806
     C                   ENDIF                                                              BUG11806
                                                                                            BUG11806
     C                   CALL      'TABLETH'
     C     W0RTN         PARM      *BLANKS       W0RTN             7
     C                   PARM                    A4CNCD
     C                   PARM                    A4RGCD
     C                   PARM                    A4CNNM
     C                   PARM                    A4TYLC
     C                   PARM                    BJRDNB
 
     C                   IF        W0RTN <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'TABLETH'
     C                   EVAL      DBKEY  =  KA4Cncd
     C                   EVAL      DBASE  =  004
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRACCP - Acceptance File Update Routine                       *
      *                                                               *
      *****************************************************************
 
     C     SRACCP        BEGSR
 
      ** Check if record exists
 
     C                   EVAL      KA4Cncd = A4CNCD
     C                   EVAL      W_Attempt = 0
 
     C                   DOW       W_Attempt < 100
     C     K@Sdactyl0    CHAIN(E)  SDACTYL0
 
      ** If record is locked to another job, wait 1 second and try again
 
     C                   IF        %ERROR
     C                   EXSR      SRDELAY
     C                   EVAL      W_Attempt = W_Attempt + 1
     C                   ELSE
     C                   LEAVE
     C                   ENDIF
 
     C                   ENDDO
 
     C                   IF        %ERROR
 
      ** Database update error
 
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'SDACTYL0'
     C                   EVAL      DBKEY  =  KA4Cncd
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   EVAL      DBASE  =  004
     C                   EVAL      DBMOD  =  PSProcMod
     C                   EVAL      DBPROC =  'SR/SRACCP '
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        %FOUND(SDACTYL0)
 
      ** Reload input data before updating record
 
     C                   EVAL      W_Sdactypd = PData
     C                   UPDATE    SDCTRYD0
     C                   ELSE
 
      ** Write to acceptance file if not found
 
     C                   WRITE     SDCTRYD0
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************                     BUG11806
      /EJECT                                                                                BUG11806
      *****************************************************************                     BUG11806
      *                                                               *                     BUG11806
      * SREXTN - Extension File Update Routine                        *                     BUG11806
      *                                                               *                     BUG11806
      *****************************************************************                     BUG11806
                                                                                            BUG11806
     C     SREXTN        BEGSR                                                              BUG11806
                                                                                            BUG11806
     C                   EVAL      KCTXn = A4CNCD                                           BUG11806
                                                                                            BUG11806
      ** IBLC Extension                                                                     BUG11806
                                                                                            BUG11806
     C                   IF        ULX043 = 'Y'                                             BUG11806
                                                                                            BUG11806
     C     KCTXn         CHAIN     SDCTX1L0                                                 BUG11806
                                                                                            BUG11806
     C                   IF        NOT %FOUND(SDCTX1L0)                                     BUG11806
     C                   EVAL      CTCTRY = A4CNCD                                          BUG11806
     C                   EVAL      CTEMUZ = 'N'                                             BUG11806
     C                   WRITE     SDCTX1D0                                                 BUG11806
     C                   ENDIF                                                              BUG11806
                                                                                            BUG11806
     C                   ENDIF                                                              BUG11806
                                                                                            BUG11806
      ** LU Extension                                                                       BUG11806
                                                                                            BUG11806
     C                   IF        ULX004 = 'Y'                                             BUG11806
                                                                                            BUG11806
     C     KCTXn         CHAIN     SDCTX2L0                                                 BUG11806
                                                                                            BUG11806
     C                   IF        NOT %FOUND(SDCTX2L0)                                     BUG11806
     C                   EVAL      WFCTRY = A4CNCD                                          BUG11806
     C                   EVAL      WFICTR = 'Y'                                             BUG11806
     C                   EVAL      WFEMUM = 'N'                                             BUG11806
     C                   EVAL      WFISOC = *BLANKS                                         BUG11806
     C                   WRITE     SDCTX2D0                                                 BUG11806
     C                   ENDIF                                                              BUG11806
                                                                                            BUG11806
     C                   ENDIF                                                              BUG11806
                                                                                            BUG11806
     C                   ENDSR                                                              BUG11806
                                                                                            BUG11806
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRDELAY - Delay Job Routine                                   *
      *                                                               *
      *****************************************************************
 
     C     SRDELAY       BEGSR
 
      ** Execute Delay Job command
 
     C                   CALL      'QCMDEXC'
     C                   PARM                    QCMD
     C                   PARM                    QLEN
 
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
     C                   PARM                    PData
     C                   PARM                    PRetcode
     C                   PARM                    PProgram
 
      ** Initialize command exec parameters
 
     C                   EVAL      QCMD = 'DLYJOB DLY(1)'
     C                   EVAL      QLEN = 80
 
      ** Country code keylist
 
     C     K@SDCTRYL0    KLIST
     C                   KFLD                    KA4CNCD
 
      ** SD Control keylist
 
     C     K@SDFCTLL0    KLIST
     C                   KFLD                    KAHFLNM
 
      ** Country code acceptance keylist
 
     C     K@SDACTYL0    KLIST
     C                   KFLD                    KA4CNCD
 
      ** Access Bank Details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Datebase error
 
     C     @RTCD         IFNE      *BLANKS
 
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'SDBANKPD'
     C                   EVAL      DBKEY  =  @OPTN
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   EVAL      DBASE  =  001
     C                   EVAL      DBMOD  =  PSProcMod
     C                   EVAL      DBPROC =  'SR/*INZSR '
     C                   EXSR      *PSSR
     C                   OUT       LDA
 
     C                   ENDIF
 
      ** Check if ULX004 is enabled.                                                        BUG11806
                                                                                            BUG11806
     C                   CALL      'AOSARDR0'                                               BUG11806
     C                   PARM      *BLANKS       PRtCd                                      BUG11806
     C                   PARM      '*VERIFY'     POptn                                      BUG11806
     C                   PARM      'ULX004'      PSARD                                      BUG11806
     C     SCSARD        PARM      SCSARD        DSFDY                                      BUG11806
                                                                                            BUG11806
     C                   EVAL      ULX004 = 'N'                                             BUG11806
                                                                                            BUG11806
     C                   IF        PRtCd = *BLANKS                                          BUG11806
     C                   EVAL      ULX004 = 'Y'                                             BUG11806
     C                   ELSE                                                               BUG11806
                                                                                            BUG11806
     C                   IF        PRtCd <> '*NRF   '                                       BUG11806
     C     *LOCK         IN        LDA                                                      BUG11806
     C                   EVAL      DBFile = 'SCSARDPD'                                      BUG11806
     C                   EVAL      DBKey = PSARD                                            BUG11806
     C                   EVAL      DBase = 101                                              BUG11806
     C                   OUT       LDA                                                      BUG11806
     C                   EXSR      *PSSR                                                    BUG11806
     C                   ENDIF                                                              BUG11806
                                                                                            BUG11806
     C                   ENDIF                                                              BUG11806
                                                                                            BUG11806
      ** Check if ULX043 is enabled.                                                        BUG11806
                                                                                            BUG11806
     C                   CALL      'AOSARDR0'                                               BUG11806
     C                   PARM      *BLANKS       PRtCd                                      BUG11806
     C                   PARM      '*VERIFY'     POptn                                      BUG11806
     C                   PARM      'ULX043'      PSARD                                      BUG11806
     C     SCSARD        PARM      SCSARD        DSFDY                                      BUG11806
                                                                                            BUG11806
     C                   EVAL      ULX043 = 'N'                                             BUG11806
                                                                                            BUG11806
     C                   IF        PRtCd = *BLANKS                                          BUG11806
     C                   EVAL      ULX043 = 'Y'                                             BUG11806
     C                   ELSE                                                               BUG11806
                                                                                            BUG11806
     C                   IF        PRtCd <> '*NRF   '                                       BUG11806
     C     *LOCK         IN        LDA                                                      BUG11806
     C                   EVAL      DBFile = 'SCSARDPD'                                      BUG11806
     C                   EVAL      DBKey = PSARD                                            BUG11806
     C                   EVAL      DBase = 102                                              BUG11806
     C                   OUT       LDA                                                      BUG11806
     C                   EXSR      *PSSR                                                    BUG11806
     C                   ENDIF                                                              BUG11806
                                                                                            BUG11806
     C                   ENDIF                                                              BUG11806
                                                                                            BUG11806
     C                   ENDSR
 
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      *****************************************************************
 
     C     *PSSR         BEGSR
 
     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'
     C                   DUMP
 
     C                   CALL      'DBERRCTL'
 
     C                   ENDIF
 
      ** Update return code and rollback file updates
 
     C                   EVAL      PRetcode = '*ERROR '
     C                   ROLBK
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
 
