     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2006')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Deal Sub-Type Acceptance')                    *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  SDDLSTACP - SD Deal Subtype Acceptance                       *
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
 
      ** SD Deal Subtype Update Logical File
     FSDDLSTL0  UF A E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
 
      ** SD Control Update Logical File
     FSDFCTLL0  UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
 
      ** SD Deal Subtype Acceptance Update Logical File
     FSDADSTL0  UF A E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
 
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
 
      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** Data Area giving Installation Control Details
 
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
      ** First DS for access programs, short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
     D/COPY ZACPYSRC,PSDS
 
      ** Program Status Data Structure
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
     D C_AutoAccept    C                   CONST('Y')
     D C_AcceptEffDte  C                   CONST('SDC000061')
     D C_Filename      C                   CONST('SDDLSTPD  ')
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D W_SDADSTPD    E DS                  EXTNAME(SDADSTPD)
 
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
     D KASDstc         S                   LIKE(ASDSTC)
     D KAHFlnm         S                   LIKE(AHFLNM)
 
      ** QCMDEXC Parameters
     D QCMD            S             80A
     D QLEN            S             15  5
 
      ** Work variables
     D WAHNORC         S                   LIKE(AHNORC)
     D WAHNOIN         S                   LIKE(AHNOIN)
     D WAHNOAM         S                   LIKE(AHNOAM)
     D W_Attempt       S              3  0
     D W0RTN           S              7
     D WQ0005          S              5  0
 
 
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
 
      ** Read in Installation Data
 
     C     *DTAARA       DEFINE                  RUNDAT
     C     *DTAARA       DEFINE                  LDA
     C                   IN        RUNDAT
 
      ** Set Date Format Indicator *IN98  on if date format is MMDDYY
 
     C                   IF        AGDFF = 'M'
     C                   EVAL      *IN98 = *ON
     C                   ENDIF
 
      ** Move deal subtype data for processing
 
     C                   EVAL      PRetcode = *Blanks
     C                   EVAL      W_Sdadstpd = PData
 
     C                   IF        ASAACC   = C_AutoAccept   OR
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
 
      ** Update deal subtype
 
     C                   EVAL      KASDstc = ASDSTC
     C                   EVAL      W_Attempt = 0
 
     C                   DOW       W_Attempt < 100
     C     K@Sddlstl0    CHAIN(E)  SDDLSTL0
 
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
     C                   EVAL      DBFILE =  'SDDLSTL0'
     C                   EVAL      DBKEY  =  KASDstc
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   EVAL      DBASE  =  001
     C                   EVAL      DBMOD  =  PSProcMod
     C                   EVAL      DBPROC =  'SR/SRZONE '
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        %FOUND(SDDLSTL0)
 
      ** Reload input data before updating record,
      ** all fields are maintained centrally
 
     C                   EVAL      W_Sdadstpd = PData
     C                   EVAL      ASTYLC = 'A'
     C                   EVAL      ASLCD  = BJRDNB
     C                   EVAL      ASEACC = BJRDNB
     C                   UPDATE    @ASRECN
 
      ** Setup 'amend' count
 
     C                   EVAL      WAHNORC = 0
     C                   EVAL      WAHNOIN = 0
     C                   EVAL      WAHNOAM = 1
     C                   ELSE
 
      ** Write to zonal file if not found
 
     C                   EVAL      ASTYLC = 'I'
     C                   EVAL      ASLCD  = BJRDNB
     C                   EVAL      ASEACC = BJRDNB
     C                   WRITE     @ASRECN
 
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
 
      ** Update TABLET5 - Deal Sub-types  *
 
     C                   CALL      'TABLET5'                            90
     C                   PARM      *BLANK        W0RTN
     C                   PARM                    ASDSTC
     C                   PARM                    ASDSTN
     C                   PARM                    ASTYLC
     C                   PARM      BJRDNB        WQ0005
 
      ** Call to program ended in error
 
     C                   IF        *IN90 = '1'  OR
     C                             W0RTN <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'TABLET5'
     C                   EVAL      DBKEY  =  KASDSTC
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   EVAL      DBASE  =  004
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
 
     C                   EVAL      KASDstc = ASDSTC
     C                   EVAL      W_Attempt = 0
 
     C                   DOW       W_Attempt < 100
     C     K@Sdadstl0    CHAIN(E)  SDADSTL0
 
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
     C                   EVAL      DBFILE =  'SDADSTL0'
     C                   EVAL      DBKEY  =  KASDstc
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   EVAL      DBASE  =  004
     C                   EVAL      DBMOD  =  PSProcMod
     C                   EVAL      DBPROC =  'SR/SRACCP '
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        %FOUND(SDADSTL0)
 
      ** Reload input data before updating record
 
     C                   EVAL      W_Sdadstpd = PData
     C                   UPDATE    SDDLSTD0
     C                   ELSE
 
      ** Write to acceptance file if not found
 
     C                   WRITE     SDDLSTD0
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
 
      ** Deal subtype code keylist
 
     C     K@SDDLSTL0    KLIST
     C                   KFLD                    KASDSTC
 
      ** SD Control keylist
 
     C     K@SDFCTLL0    KLIST
     C                   KFLD                    KAHFLNM
 
      ** Deal subtype code acceptance keylist
 
     C     K@SDADSTL0    KLIST
     C                   KFLD                    KASDSTC
 
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
      *
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
 
