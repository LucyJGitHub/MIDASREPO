     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2006')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Branch Code Acceptance')                      *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  SDBRCHACP - SD Branch Code Acceptance                        *
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
      *                 BUG11887           Date 11Aug06               *
      *                 BUG11898           Date 14Aug06               *
      *                 BUG11897           Date 14Aug06               *
      *                 CSD031  *CREATE    Date 10Apr06               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  BUG11887 - Syndication Agent defaults to blank.              *
      *  BUG11898 - Accept to zone display did not default to 'N'     *
      *             in acceptance list view if not defined in         *
      *             Global Layer                                      *
      *  BUG11897 - Effective date is not displayed in acceptance     *
      *             List View                                         *
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
      *  SRBANK    - Update Bank Details ICD
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
 
      ** SD Branch Code Update Logical File
     FSDBRCHL0  UF A E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
 
      ** SD Branch Code Extension Update Logical File
     FSDBRCHEXL0UF A E           K DISK    INFSR(*PSSR)
     F                                     RENAME(GPBRCHEXD0: SDBRCHEXD0)
     F                                     COMMIT
 
      ** SD Control Update Logical File
     FSDFCTLL0  UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
 
      ** Bank Details Update Logical File
     FSDBANKL0  UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
 
      ** SD Branch Code Acceptance Update Logical File
     FSDABRCL0  UF A E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
 
      ** SD Branch Code Extension Acceptance Update Logical File
     FSDABRCEXL0UF A E           K DISK    INFSR(*PSSR)
     F                                     RENAME(GPBRCHEXD0: SDABRCEXD0)
     F                                     COMMIT
 
      ** Midas GP Zones
     FGPZONEL2  IF   E           K DISK    INFSR(*PSSR)
 
 
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
 
     D SDSTAT        E DS
 
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
     D C_Filename      C                   CONST('SDBRCHPD  ')
     D C_SingleBranch  C                   CONST('N')
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Data structure to hold the char format fields
     D W_SDZBRCHPD   E DS                  EXTNAME(SDZBRCHPD)
 
      ** Data structure to hold the extension data
     D W_SDBRCHEXPD  E DS                  EXTNAME(SDBRCHEXPD)
     D                                     PREFIX(X_)
 
      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** First DS for Access Programs, Short Data Structure
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
 
      ** Key fields
     D KA8Brcd         S                   LIKE(A8BRCD)
     D KAHFlnm         S                   LIKE(AHFLNM)
     D KBJBank         S                   LIKE(BJBANK)
 
      ** Parameters
     D QCMD            S             80A
     D QLEN            S             15  5
     D PZreturn        S              1
     D PZfield         S             16
     D PZdecimals      S              1P 0
     D PZdigits        S              2P 0
 
      ** Work variables
     D WAHNORC         S                   LIKE(AHNORC)
     D WAHNOIN         S                   LIKE(AHNOIN)
     D WAHNOAM         S                   LIKE(AHNOAM)
     D W_Attempt       S              3  0
 
     D W8LCD           S                   LIKE(A8LCD )
     D W8STCD          S                   LIKE(A8STCD)
     D W8SUOP          S                   LIKE(A8SUOP)
     D W8SUCL          S                   LIKE(A8SUCL)
     D W8MOOP          S                   LIKE(A8MOOP)
     D W8MOCL          S                   LIKE(A8MOCL)
     D W8TUOP          S                   LIKE(A8TUOP)
     D W8TUCL          S                   LIKE(A8TUCL)
     D W8WEOP          S                   LIKE(A8WEOP)
     D W8WECL          S                   LIKE(A8WECL)
     D W8THOP          S                   LIKE(A8THOP)
     D W8THCL          S                   LIKE(A8THCL)
     D W8FYOP          S                   LIKE(A8FYOP)
     D W8FYCL          S                   LIKE(A8FYCL)
     D W8SAOP          S                   LIKE(A8SAOP)
     D W8SACL          S                   LIKE(A8SACL)
     D W8SYCU          S                   LIKE(A8SYCU)
     D W8EDAT          S                   LIKE(A8EDAT)
     D W8COTI          S                   LIKE(A8COTI)
     D W8TCPP          S                   LIKE(A8TCPP)
     D W8TMOF          S                   LIKE(A8TMOF)
     D W8STOF          S                   LIKE(A8STOF)
     D W8EACC          S                   LIKE(A8EACC)
 
     D WZonePrefix     S              2A
     D WStart          S              4P 0
     D WLength         S              4P 0
 
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
     C     *DTAARA       DEFINE                  SDSTAT
     C                   IN        RUNDAT
     C                   IN        SDSTAT
 
      ** Move branch code data for processing
 
     C                   EVAL      PRetcode = *Blanks
     C                   EVAL      W_SDZBRCHPD = PData
     C                   EVAL      WStart = %LEN(W_SDZBRCHPD) + 1
     C                   EVAL      WLength = %LEN(W_SDBRCHEXPD)
     C                   EVAL      W_SDBRCHEXPD = %SUBST(PData: WStart: WLength)
     C                   EXSR      SRCONVERT
 
      ** Get Zone Name
 
     C                   EXSR      SRGetZone
 
      ** Check if auto accept to zone or accept on effective date
 
     C                   IF        A8AACC   = C_AutoAccept   OR
     C                             PProgram = C_AcceptEffDte
 
     C                   EXSR      SRZONE
     C                   ELSE
 
      ** Check value of A8AACC if it is not 'Y' then it can either be ' '                   BUG11898
      ** or 'N'. If it is a space then force it to be 'N'                                   BUG11898
                                                                                            BUG11898
     C     A8AACC        IFEQ      *BLANKS                                                  BUG11898
     C                   EVAL      A8AACC = 'N'                                             BUG11898
     C                   ENDIF                                                              BUG11898
                                                                                            BUG11898
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
 
      ** Update branch code
 
     C                   EVAL      KA8Brcd = A8BRCD
     C                   EVAL      W_Attempt = 0
 
     C                   DOW       W_Attempt < 100
     C     K@Sdbrchl0    CHAIN(E)  SDBRCHL0
 
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
     C                   EVAL      DBFILE =  'SDBRCHL0'
     C                   EVAL      DBKEY  =  KA8Brcd
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   EVAL      DBASE  =  001
     C                   EVAL      DBMOD  =  PSProcMod
     C                   EVAL      DBPROC =  'SR/SRZONE '
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        %FOUND(SDBRCHL0)
 
      ** Reload input data before updating record,
      ** all fields are maintained centrally
 
     C                   EVAL      W_SDZBRCHPD = PData
     C                   EXSR      SRRESTORE
     C                   EVAL      A8TYLC = 'A'
     C                   EVAL      A8EACC = BJRDNB
     C                   UPDATE    @A8REB1
 
      ** Setup 'amend' count
 
     C                   EVAL      WAHNORC = 0
     C                   EVAL      WAHNOIN = 0
     C                   EVAL      WAHNOAM = 1
 
     C                   ELSE
 
      ** Write to zonal file if not found
 
     C                   EVAL      A8TYLC = 'I'
     C                   EVAL      A8EACC = BJRDNB
     C                   WRITE     @A8REB1
 
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
 
      ** Update bank details in single branch environment,
      ** check the indicator from RUNDAT data area
 
     C                   IF        AGMBIN = C_SingleBranch
 
     C                   EXSR      SRBANK
 
     C                   ENDIF
 
      ** Update the extension file.
 
     C     KA8Brcd       CHAIN     SDBRCHEXL0
 
     C                   IF        %FOUND
     C                   EVAL      BXACOC = X_BXACOC
     C                   UPDATE    SDBRCHEXD0
     C                   ELSE
     C                   EVAL      BXBRCD = X_BXBRCD
     C                   EVAL      BXACOC = X_BXACOC
     C                   WRITE     SDBRCHEXD0
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRBANK - Update Bank Details                                  *
      *                                                               *
      *****************************************************************
 
     C     SRBANK        BEGSR
 
      ** Check branch code in bank details
 
     C                   EVAL      KBJBank = 'BANK'
     C                   EVAL      W_Attempt = 0
 
     C                   DOW       W_Attempt < 100
     C     K@Sdbankl0    CHAIN(E)  SDBANKL0
 
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
     C                   EVAL      DBFILE =  'SDBANKL0'
     C                   EVAL      DBKEY  =  KBJBank
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   EVAL      DBASE  =  005
     C                   EVAL      DBMOD  =  PSProcMod
     C                   EVAL      DBPROC =  'SR/SRBANK '
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        %FOUND(SDBANKL0)
 
      ** Update single branch code
 
     C                   IF        BJSBRC <> A8BRCD
     C                   EVAL      BJSBRC = A8BRCD
     C                   UPDATE    @BJREEE
     C                   ELSE
     C                   UNLOCK    SDBANKL0
     C                   ENDIF
 
     C                   ELSE
 
      ** Database update error
 
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'SDBANKL0'
     C                   EVAL      DBKEY  =  KBJBank
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   EVAL      DBASE  =  006
     C                   EVAL      DBMOD  =  PSProcMod
     C                   EVAL      DBPROC =  'SR/SRBANK '
     C                   OUT       LDA
     C                   EXSR      *PSSR
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRGetZone - Get Zone Name                                     *
      *                                                               *
      *****************************************************************
 
     C     SRGetZone     BEGSR
 
     C     LIBR          CHAIN     GPZONEL2
     C                   IF        %FOUND
     C                   EVAL      A8ZONE = ZOZONE
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
 
     C                   EVAL      KA8Brcd = A8BRCD
     C                   EVAL      W_Attempt = 0
 
     C                   DOW       W_Attempt < 100
     C     K@Sdabrcl0    CHAIN(E)  SDABRCL0
 
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
     C                   EVAL      DBFILE =  'SDABRCL0'
     C                   EVAL      DBKEY  =  KA8Brcd
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   EVAL      DBASE  =  004
     C                   EVAL      DBMOD  =  PSProcMod
     C                   EVAL      DBPROC =  'SR/SRACCP '
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        %FOUND(SDABRCL0)
 
      ** Reload input data before updating record
 
     C                   EVAL      W_SDZBRCHPD = PData
     C                   EXSR      SRRESTORE
     C                   UPDATE    SDBRCHD0
     C                   ELSE
 
      ** Write to acceptance file if not found
 
     C                   WRITE     SDBRCHD0
     C                   ENDIF
 
      ** Update the extension acceptance file.
 
     C     KA8Brcd       CHAIN     SDABRCEXL0
 
     C                   IF        %FOUND
     C                   EVAL      BXACOC = X_BXACOC
     C                   UPDATE    SDABRCEXD0
     C                   ELSE
     C                   EVAL      BXBRCD = X_BXBRCD
     C                   EVAL      BXACOC = X_BXACOC
     C                   WRITE     SDABRCEXD0
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRCONVERT - Convert Fields to Numeric Definition              *
      *                                                               *
      *****************************************************************
 
     C     SRCONVERT     BEGSR
 
     C                   IF        Z8LCD  = *Blanks
     C                   EVAL      A8LCD  = *Zeros
     C                   ELSE
     C                   MOVE      Z8LCD         PZfield
     C                   EVAL      PZdecimals = 0
     C                   EVAL      PZdigits   = 5
     C                   EXSR      SrAlign
     C                   MOVE      PZfield       A8LCD
     C                   ENDIF
     C                   EVAL      W8LCD = A8LCD
 
     C                   IF        Z8STCD = *Blanks
     C                   EVAL      A8STCD = *Zeros
     C                   ELSE
     C                   MOVE      Z8STCD        PZfield
     C                   EVAL      PZdecimals = 0
     C                   EVAL      PZdigits   = 6
     C                   EXSR      SrAlign
     C                   MOVE      PZfield       A8STCD
     C                   ENDIF
     C                   EVAL      W8STCD = A8STCD
 
     C                   IF        Z8SUOP = *Blanks
     C                   EVAL      A8SUOP = *Zeros
     C                   ELSE
     C                   MOVE      Z8SUOP        PZfield
     C                   EVAL      PZdecimals = 0
     C                   EVAL      PZdigits   = 4
     C                   EXSR      SrAlign
     C                   MOVE      PZfield       A8SUOP
     C                   ENDIF
     C                   EVAL      W8SUOP = A8SUOP
 
     C                   IF        Z8SUCL = *Blanks
     C                   EVAL      A8SUCL = *Zeros
     C                   ELSE
     C                   MOVE      Z8SUCL        PZfield
     C                   EVAL      PZdecimals = 0
     C                   EVAL      PZdigits   = 4
     C                   EXSR      SrAlign
     C                   MOVE      PZfield       A8SUCL
     C                   ENDIF
     C                   EVAL      W8SUCL = A8SUCL
 
     C                   IF        Z8MOOP = *Blanks
     C                   EVAL      A8MOOP = *Zeros
     C                   ELSE
     C                   MOVE      Z8MOOP        PZfield
     C                   EVAL      PZdecimals = 0
     C                   EVAL      PZdigits   = 4
     C                   EXSR      SrAlign
     C                   MOVE      PZfield       A8MOOP
     C                   ENDIF
     C                   EVAL      W8MOOP = A8MOOP
 
     C                   IF        Z8MOCL = *Blanks
     C                   EVAL      A8MOCL = *Zeros
     C                   ELSE
     C                   MOVE      Z8MOCL        PZfield
     C                   EVAL      PZdecimals = 0
     C                   EVAL      PZdigits   = 4
     C                   EXSR      SrAlign
     C                   MOVE      PZfield       A8MOCL
     C                   ENDIF
     C                   EVAL      W8MOCL = A8MOCL
 
     C                   IF        Z8TUOP = *Blanks
     C                   EVAL      A8TUOP = *Zeros
     C                   ELSE
     C                   MOVE      Z8TUOP        PZfield
     C                   EVAL      PZdecimals = 0
     C                   EVAL      PZdigits   = 4
     C                   EXSR      SrAlign
     C                   MOVE      PZfield       A8TUOP
     C                   ENDIF
     C                   EVAL      W8TUOP = A8TUOP
 
     C                   IF        Z8TUCL = *Blanks
     C                   EVAL      A8TUCL = *Zeros
     C                   ELSE
     C                   MOVE      Z8TUCL        PZfield
     C                   EVAL      PZdecimals = 0
     C                   EVAL      PZdigits   = 4
     C                   EXSR      SrAlign
     C                   MOVE      PZfield       A8TUCL
     C                   ENDIF
     C                   EVAL      W8TUCL = A8TUCL
 
     C                   IF        Z8WEOP = *Blanks
     C                   EVAL      A8WEOP = *Zeros
     C                   ELSE
     C                   MOVE      Z8WEOP        PZfield
     C                   EVAL      PZdecimals = 0
     C                   EVAL      PZdigits   = 4
     C                   EXSR      SrAlign
     C                   MOVE      PZfield       A8WEOP
     C                   ENDIF
     C                   EVAL      W8WEOP = A8WEOP
 
     C                   IF        Z8WECL = *Blanks
     C                   EVAL      A8WECL = *Zeros
     C                   ELSE
     C                   MOVE      Z8WECL        PZfield
     C                   EVAL      PZdecimals = 0
     C                   EVAL      PZdigits   = 4
     C                   EXSR      SrAlign
     C                   MOVE      PZfield       A8WECL
     C                   ENDIF
     C                   EVAL      W8WECL = A8WECL
 
     C                   IF        Z8THOP = *Blanks
     C                   EVAL      A8THOP = *Zeros
     C                   ELSE
     C                   MOVE      Z8THOP        PZfield
     C                   EVAL      PZdecimals = 0
     C                   EVAL      PZdigits   = 4
     C                   EXSR      SrAlign
     C                   MOVE      PZfield       A8THOP
     C                   ENDIF
     C                   EVAL      W8THOP = A8THOP
 
     C                   IF        Z8THCL = *Blanks
     C                   EVAL      A8THCL = *Zeros
     C                   ELSE
     C                   MOVE      Z8THCL        PZfield
     C                   EVAL      PZdecimals = 0
     C                   EVAL      PZdigits   = 4
     C                   EXSR      SrAlign
     C                   MOVE      PZfield       A8THCL
     C                   ENDIF
     C                   EVAL      W8THCL = A8THCL
 
     C                   IF        Z8FYOP = *Blanks
     C                   EVAL      A8FYOP = *Zeros
     C                   ELSE
     C                   MOVE      Z8FYOP        PZfield
     C                   EVAL      PZdecimals = 0
     C                   EVAL      PZdigits   = 4
     C                   EXSR      SrAlign
     C                   MOVE      PZfield       A8FYOP
     C                   ENDIF
     C                   EVAL      W8FYOP = A8FYOP
 
     C                   IF        Z8FYCL = *Blanks
     C                   EVAL      A8FYCL = *Zeros
     C                   ELSE
     C                   MOVE      Z8FYCL        PZfield
     C                   EVAL      PZdecimals = 0
     C                   EVAL      PZdigits   = 4
     C                   EXSR      SrAlign
     C                   MOVE      PZfield       A8FYCL
     C                   ENDIF
     C                   EVAL      W8FYCL = A8FYCL
 
     C                   IF        Z8SAOP = *Blanks
     C                   EVAL      A8SAOP = *Zeros
     C                   ELSE
     C                   MOVE      Z8SAOP        PZfield
     C                   EVAL      PZdecimals = 0
     C                   EVAL      PZdigits   = 4
     C                   EXSR      SrAlign
     C                   MOVE      PZfield       A8SAOP
     C                   ENDIF
     C                   EVAL      W8SAOP = A8SAOP
 
     C                   IF        Z8SACL = *Blanks
     C                   EVAL      A8SACL = *Zeros
     C                   ELSE
     C                   MOVE      Z8SACL        PZfield
     C                   EVAL      PZdecimals = 0
     C                   EVAL      PZdigits   = 4
     C                   EXSR      SrAlign
     C                   MOVE      PZfield       A8SACL
     C                   ENDIF
     C                   EVAL      W8SACL = A8SACL
 
     C                   IF        Z8SYCU = *Blanks
     C                   EVAL      A8SYCU = *Zeros
     C                   ELSE
     C                   MOVE      Z8SYCU        A8SYCU                                     BUG11887
     C**********         MOVE      Z8SYCU        PZfield                                    BUG11887
     C**********         EVAL      PZdecimals = 0                                           BUG11887
     C**********         EVAL      PZdigits   = 6                                           BUG11887
     C**********         EXSR      SrAlign                                                  BUG11887
     C**********         MOVE      PZfield       A8SYCU                                     BUG11887
     C                   ENDIF
     C                   EVAL      W8SYCU = A8SYCU
 
     C                   IF        Z8EDAT = *Blanks
     C                   EVAL      A8EDAT = *Zeros
     C                   ELSE
     C                   MOVE      Z8EDAT        PZfield
     C                   EVAL      PZdecimals = 0
     C                   EVAL      PZdigits   = 1
     C                   EXSR      SrAlign
     C                   MOVE      PZfield       A8EDAT
     C                   ENDIF
     C                   EVAL      W8EDAT = A8EDAT
 
     C                   IF        Z8COTI = *Blanks
     C                   EVAL      A8COTI = *Zeros
     C                   ELSE
     C                   MOVE      Z8COTI        PZfield
     C                   EVAL      PZdecimals = 0
     C                   EVAL      PZdigits   = 4
     C                   EXSR      SrAlign
     C                   MOVE      PZfield       A8COTI
     C                   ENDIF
     C                   EVAL      W8COTI = A8COTI
 
     C                   IF        Z8TCPP = *Blanks
     C                   EVAL      A8TCPP = *Zeros
     C                   ELSE
     C                   MOVE      Z8TCPP        PZfield
     C                   EVAL      PZdecimals = 0
     C                   EVAL      PZdigits   = 4
     C                   EXSR      SrAlign
     C                   MOVE      PZfield       A8TCPP
     C                   ENDIF
     C                   EVAL      W8TCPP = A8TCPP
 
     C                   IF        Z8TMOF = *Blanks
     C                   EVAL      A8TMOF = *Zeros
     C                   ELSE
     C                   MOVE      Z8TMOF        PZfield
     C                   EVAL      PZdecimals = 0
     C                   EVAL      PZdigits   = 4
     C                   EXSR      SrAlign
     C                   MOVE      PZfield       A8TMOF
     C                   ENDIF
     C                   EVAL      W8TMOF = A8TMOF
 
     C                   IF        Z8STOF = *Blanks
     C                   EVAL      A8STOF = *Zeros
     C                   ELSE
     C                   MOVE      Z8STOF        PZfield
     C                   EVAL      PZdecimals = 0
     C                   EVAL      PZdigits   = 4
     C                   EXSR      SrAlign
     C                   MOVE      PZfield       A8STOF
     C                   ENDIF
     C                   EVAL      W8STOF = A8STOF
 
     C                   IF        Z8EACC = *Blanks
     C                   EVAL      A8EACC = *Zeros
     C                   ELSE
     C                   MOVE      *BLANKS       PZfield                                    BUG11897
     C                   MOVE      Z8EACC        PZfield
     C                   EVAL      PZdecimals = 0
     C                   EVAL      PZdigits   = 5
     C                   EXSR      SrAlign
     C                   MOVE      PZfield       A8EACC
     C                   ENDIF
     C                   EVAL      W8EACC = A8EACC
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRALIGN - Align Numeric Values                                *
      *                                                               *
      *****************************************************************
 
     C     SRALIGN       BEGSR
 
     C                   CALLB     'ZALIGN'
     C                   PARM                    PZreturn
     C                   PARM                    PZfield
     C                   PARM                    PZdecimals
     C                   PARM                    PZdigits
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRRESTORE - Restore Saved Fields to File Fields               *
      *                                                               *
      *****************************************************************
 
     C     SRRESTORE     BEGSR
 
      ** Restore converted fields to file fields
 
     C                   EVAL      A8LCD  = W8LCD
     C                   EVAL      A8STCD = W8STCD
     C                   EVAL      A8SUOP = W8SUOP
     C                   EVAL      A8SUCL = W8SUCL
     C                   EVAL      A8MOOP = W8MOOP
     C                   EVAL      A8MOCL = W8MOCL
     C                   EVAL      A8TUOP = W8TUOP
     C                   EVAL      A8TUCL = W8TUCL
     C                   EVAL      A8WEOP = W8WEOP
     C                   EVAL      A8WECL = W8WECL
     C                   EVAL      A8THOP = W8THOP
     C                   EVAL      A8THCL = W8THCL
     C                   EVAL      A8FYOP = W8FYOP
     C                   EVAL      A8FYCL = W8FYCL
     C                   EVAL      A8SAOP = W8SAOP
     C                   EVAL      A8SACL = W8SACL
     C                   EVAL      A8SYCU = W8SYCU
     C                   EVAL      A8EDAT = W8EDAT
     C                   EVAL      A8COTI = W8COTI
     C                   EVAL      A8TCPP = W8TCPP
     C                   EVAL      A8TMOF = W8TMOF
     C                   EVAL      A8STOF = W8STOF
     C                   EVAL      A8EACC = W8EACC
 
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
 
      ** Branch code keylist
 
     C     K@SDBRCHL0    KLIST
     C                   KFLD                    KA8BRCD
 
      ** SD Control keylist
 
     C     K@SDFCTLL0    KLIST
     C                   KFLD                    KAHFLNM
 
      ** Bank details keylist
 
     C     K@SDBANKL0    KLIST
     C                   KFLD                    KBJBANK
 
      ** Branch code acceptance keylist
 
     C     K@SDABRCL0    KLIST
     C                   KFLD                    KA8BRCD
 
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
 
