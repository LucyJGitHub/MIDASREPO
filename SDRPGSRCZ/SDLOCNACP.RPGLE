     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2006')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Location Code Acceptance')                    *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  SDLOCNACP - SD Location Code Acceptance                      *
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
      *  (c) Misys International Banking Systems Ltd. 2006            *
      *                                                               *
      *  Last Amend No. CLE134             Date 01Aug12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD031  *CREATE    Date 10Apr06               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
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
 
      ** SD Location Code Update Logical File
     FSDLOCNL0  UF A E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
 
      ** SD Control Update Logical File
     FSDFCTLL0  UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
 
      ** SD Location Code Acceptance Update Logical File
     FSDALCNL0  UF A E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     D LDA           E DS           256    EXTNAME(LDA)
 
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
     D C_Filename      C                   CONST('SDLOCNPD  ')
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** First DS for access programs, short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
     D W_SDALCNPD    E DS                  EXTNAME(SDALCNPD)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D @RUN            S              1
 
      ** Entry parameters
     D PData           S           4000A
     D PRetCode        S              7A
     D PProgram        S             10A
 
      ** Key fields
     D KDvlccd         S                   LIKE(DVLCCD)
     D KAHFlnm         S                   LIKE(AHFLNM)
 
      ** QCMDEXC Parameters
     D QCMD            S             80A
     D QLEN            S             15  5
 
      ** Work variables
     D WAHNORC         S                   LIKE(AHNORC)
     D WAHNOIN         S                   LIKE(AHNOIN)
     D WAHNOAM         S                   LIKE(AHNOAM)
     D W_Attempt       S              3  0
 
      ** Rename non-amendable fields
     I@DVREHI
     I              DVISFC                      ZVISFC
 
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
 
      ** Move location code data for processing
 
     C                   EVAL      PRetcode = *Blanks
     C                   EVAL      W_Sdalcnpd = PData
 
      ** Check if auto accept to zone or accept on effective date
 
     C                   IF        DVAACC   = C_AutoAccept   OR
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
 
      ** Update location code
 
     C                   EVAL      KDvlccd = DVLCCD
     C                   EVAL      W_Attempt = 0
 
     C                   DOW       W_Attempt < 100
     C     K@Sdlocnl0    CHAIN(E)  SDLOCNL0
 
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
     C                   EVAL      DBFILE =  'SDLOCNL0'
     C                   EVAL      DBKEY  =  KDvlccd
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   EVAL      DBASE  =  001
     C                   EVAL      DBMOD  =  PSProcMod
     C                   EVAL      DBPROC =  'SR/SRZONE '
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        %FOUND(SDLOCNL0)
 
      ** Reload input data before updating record,
      ** only central fields will be overwritten
 
     C                   EVAL      W_Sdalcnpd = PData
     C                   EVAL      DVTYLC = 'A'
     C                   EVAL      DVEACC = BJRDNB
     C                   EVAL      DVLCD  = BJRDNB
     C                   UPDATE    @DVREHI
 
      ** Setup 'amend' count
 
     C                   EVAL      WAHNORC = 0
     C                   EVAL      WAHNOIN = 0
     C                   EVAL      WAHNOAM = 1
     C                   ELSE
 
      ** Write to zonal file if not found, get value of renamed
      ** fields during insert
 
     C                   EVAL      ZVISFC = DVISFC
     C                   EVAL      DVTYLC = 'I'
     C                   EVAL      DVEACC = BJRDNB
     C                   EVAL      DVLCD  = BJRDNB
     C                   WRITE     @DVREHI
 
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
 
     C                   EVAL      KDvlccd = DVLCCD
     C                   EVAL      W_Attempt = 0
 
     C                   DOW       W_Attempt < 100
     C     K@Sdalcnl0    CHAIN(E)  SDALCNL0
 
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
     C                   EVAL      DBFILE =  'SDALCNL0'
     C                   EVAL      DBKEY  =  KDvlccd
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   EVAL      DBASE  =  004
     C                   EVAL      DBMOD  =  PSProcMod
     C                   EVAL      DBPROC =  'SR/SRACCP '
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        %FOUND(SDALCNL0)
 
      ** Reload input data before updating record
 
     C                   EVAL      W_Sdalcnpd = PData
     C                   UPDATE    SDLOCND0
     C                   ELSE
 
      ** Write to acceptance file if not found
 
     C                   WRITE     SDLOCND0
     C                   ENDIF
 
     C                   ENDSR
 
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
 
      ** Location code keylist
 
     C     K@SDLOCNL0    KLIST
     C                   KFLD                    KDVLCCD
 
      ** SD Control keylist
 
     C     K@SDFCTLL0    KLIST
     C                   KFLD                    KAHFLNM
 
      ** Location code acceptance keylist
 
     C     K@SDALCNL0    KLIST
     C                   KFLD                    KDVLCCD
 
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
 
