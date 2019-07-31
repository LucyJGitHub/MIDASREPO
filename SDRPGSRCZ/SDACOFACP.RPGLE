     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2006')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Account Officers Acceptance')                 *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  SDACOFACP - SD Account Officers Acceptance                   *
      *                                                               *
      *  Function:  This program updates the zonal file and the       *
      *             acceptance file based on the data sent by the     *
      *             background job SDC000060.                         *
      *                                                               *
      *  Called By: SDC000060 - SD Central Data Acceptance BG Job     *
      *                                                               *
      *  (c) Finastra International Limited 2006                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CLE134             Date 01Aug12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG11892           Date 14Aug06               *
      *                 BUG11863           Date 10Aug06               *
      *                 CSD031  *CREATE    Date 20Apr06               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  BUG11892 - Effective date defaults to blank on zonal         *
      *             acceptance
      *  BUG11863 - Manager Type not being cascaded properly.         *
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
      * *PSSR - Error processing                                      *
      * *INZSR - Initialise                                           *
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
 
      ** SD Narrative Code Update Logical File
     FSDACOFL0  UF A E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
 
      ** SD Control Update Logical File
     FSDFCTLL0  UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
 
      ** SD Account Officer Update Logical File
     FSDAACOL0  UF A E           K DISK    INFSR(*PSSR)
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
 
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
      *
      ** Program Status Data Structure
      *
      ** +-----------------------------------------------------------------+
      ** D specs of the following types should be inserted after the
      ** relevant box.  *** Remove this text afterwards. ***
      ** +-----------------------------------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** First DS for access programs, short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** Midas SD Account Officer Acceptance File
     D AACOFilFmt    E DS                  ExtName(SDZACOFPD)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D @RUN            S              1
 
      ** Entry Parameters
     D PData           S           4000A
     D PRetCode        S              7A
     D PProgram        S             10A
 
      ** Parameters
     D PCommand        S             80A
     D PLength         S             15  5
     D PFile           S              7
     D PKey            S             28
     D PProc           S             15
     D PDbase          S              3  0
     D PZreturn        S              1
     D PZfield         S             16
     D PZdecimals      S              1P 0
     D PZdigits        S              2P 0
 
      ** Work Fields
     D WUNORC          S              5  0
     D WUNOAM          S              5  0
     D WUNODL          S              5  0
     D WUNOIN          S              5  0
 
      ** Variables
     D C_Count         S              3  0
     D C_Update        S              1
 
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
 
      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************
 
      ** Read in Installation Data
 
     C                   EVAL      AACOFilFmt = PData
     C                   EXSR      SrConvert
 
     C                   IF        AZAACC = 'Y' or
     C                             PProgram = 'SDC000061'
     C                   EXSR      SrZone
     C                   ELSE
     C                   EXSR      SrAccp
     C                   ENDIF
 
      ** Commit changes if there are no errors, otherwise rollback
 
     C                   IF        PRetCode = *BLANKS
     C                   COMMIT
     C                   ELSE
     C                   ROLBK
     C                   ENDIF
 
     C                   EVAL      *INLR = *On
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRCONVERT - Convert Fields to Numeric Definition              *
      *                                                               *
      *****************************************************************
 
     C     SRCONVERT     BEGSR
 
      ** Convert fields from character to numeric format
 
     C                   IF        ZZLCD  = *Blanks
     C                   EVAL      AZLCD  = *Zeros
     C                   ELSE
     C                   MOVE      ZZLCD         PZfield
     C                   EVAL      PZdecimals = 0
     C                   EVAL      PZdigits   = 5
     C                   EXSR      SrAlign
     C                   MOVE      PZfield       AZLCD
     C                   ENDIF
 
     C                   IF        ZZACOT = *Blanks
     C                   EVAL      AZACOT = *Zeros
     C                   ELSE
     C                   MOVE      ZZACOT        AZACOT                                     BUG11863
     C                   ENDIF                                                              BUG11863
     C**********         MOVE      ZZACOT        PZfield                                    BUG11863
     C**********         EVAL      PZdecimals = 0                                           BUG11863
     C**********         EVAL      PZdigits   = 1                                           BUG11863
     C**********         EXSR      SrAlign                                                  BUG11863
     C**********         MOVE      PZfield       AZACOT                                     BUG11863
     C**********         ENDIF                                                              BUG11863
 
     C                   IF        ZZEACC = *Blanks
     C                   EVAL      AZEACC = *Zeros
     C                   ELSE
     C                   Eval      PZfield = *Blanks                                        BUG11892
     C                   MOVE      ZZEACC        PZfield
     C                   EVAL      PZdecimals = 0
     C                   EVAL      PZdigits   = 5
     C                   EXSR      SrAlign
     C                   MOVE      PZfield       AZEACC
     C                   ENDIF
 
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
 
      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRZONE - Zonal File Update routine                            *
      *                                                               *
      * Called by: Main Procedure                                     *
      *                                                               *
      * Calls: Sr_UpdTrl                                              *
      *                                                               *
      *****************************************************************
 
     C     SRZONE        BEGSR
 
      ** Update Account Officer File
 
     C                   EXSR      Sr_UpdAcc
 
      ** Update Trailer File
 
     C                   EXSR      Sr_UpdTrl
 
     C                   ENDSR
 
      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * Sr_UpdAcc - Account Officer File Update routine               *
      *                                                               *
      * Called by: SRZONE                                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     Sr_UpdAcc     BEGSR
 
     C                   EVAL      C_Count = 0
     C                   DO        100           C_Count
 
     C                   IF        C_Count <> 1
     C                   EXSR      Sr_Qcmd
     C                   ENDIF
 
     C     AZACOC        CHAIN(E)  @AZREBP
     C                   IF        %ERROR
     C                   ITER
     C                   ENDIF
 
     C                   IF        %FOUND(SDACOFL0)
 
      ** Reload input data
 
     C                   EVAL      AACOFilFmt = PData
     C                   EXSR      SrConvert
 
     C                   EVAL      AZTYLC = 'A'
     C                   EVAL      AZEACC = BJRDNB
     C                   EVAL      AZLCD  = BJRDNB
 
     C                   UPDATE(E) @AZREBP
     C                   IF        %ERROR
     C                   ITER
     C                   ELSE
 
      ** USER: Processing after Data update
 
     C                   EVAL      WUNORC = 0
     C                   EVAL      WUNOAM = 1
     C                   EVAL      WUNODL = 0
     C                   EVAL      WUNOIN = 0
     C                   ENDIF
 
     C                   Else
 
     C                   EVAL      AZTYLC = 'I'
     C                   EVAL      AZEACC = BJRDNB
     C                   EVAL      AZLCD  = BJRDNB
 
     C                   WRITE(E)  @AZREBP
     C                   IF        %ERROR
     C                   ITER
     C                   ELSE
 
      ** USER: Processing after Data update
 
     C                   EVAL      WUNORC = 1
     C                   EVAL      WUNOAM = 0
     C                   EVAL      WUNODL = 0
     C                   EVAL      WUNOIN = 1
     C                   ENDIF
     C                   ENDIF
 
     C                   EVAL      C_Update = 'Y'
     C                   LEAVE
 
     C                   ENDDO
 
     C                   IF        C_Update <> 'Y'
     C                   EVAL      PFile =  'SDACOFL0'
     C                   EVAL      PKey  =  AZACOC
     C                   EVAL      PDbase = 001
     C                   EVAL      PProc =  'SR/Sr_UpdAcc'
     C                   EXSR      Sr_DbError
     C                   ENDIF
 
     C                   ENDSR
 
      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * Sr_UpdTrl - Trailer File Update routine                       *
      *                                                               *
      * Called by: SRZONE                                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     Sr_UpdTrl     BEGSR
 
     C                   EVAL      C_Count = 0
     C                   DO        100           C_Count
 
     C                   IF        C_Count <> 1
     C                   EXSR      Sr_Qcmd
     C                   ENDIF
 
     C                   EVAL      AHFLNM = 'SDACOFPD'
     C     AHFLNM        CHAIN(E)  @AHREAU
     C                   IF        %ERROR
     C                   ITER
     C                   ENDIF
 
     C                   IF        %FOUND(SDFCTLL0)
 
      ** Move non-key fields to @AHREAU
 
     C                   ADD       WUNORC        AHNORC
     C                   ADD       WUNOIN        AHNOIN
     C                   ADD       WUNOAM        AHNOAM
     C                   UPDATE(E) @AHREAU
     C                   IF        %ERROR
     C                   ITER
     C                   ENDIF
 
     C                   ELSE
     C                   EVAL      PFile =  'SDFCTLL0'
     C                   EVAL      PKey  =  AHFLNM
     C                   EVAL      PDbase = 002
     C                   EVAL      PProc =  'SR/Sr_UpdTrl'
     C                   EXSR      Sr_DbError
     C                   ENDIF
 
     C                   EVAL      C_Update = 'Y'
     C                   LEAVE
 
     C                   ENDDO
 
     C                   IF        C_Update <> 'Y'
     C                   EVAL      PFile =  'SDFCTLL0'
     C                   EVAL      PKey  =  AHFLNM
     C                   EVAL      PDbase = 003
     C                   EVAL      PProc =  'SR/Sr_UpdTrl'
     C                   EXSR      Sr_DbError
     C                   ENDIF
 
     C                   ENDSR
 
      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRACCP - Acceptance File Update routine                       *
      *                                                               *
      * Called by: Main Procedure                                     *
      *                                                               *
      * Calls: *None                                                  *
      *                                                               *
      *****************************************************************
 
     C     SRACCP        BEGSR
 
     C                   EVAL      C_Count = 0
     C                   DO        100           C_Count
 
     C                   IF        C_Count <> 1
     C                   EXSR      Sr_Qcmd
     C                   ENDIF
 
     C     AZACOC        CHAIN(E)  SDACOFD0
     C                   IF        %ERROR
     C                   ITER
     C                   ENDIF
 
     C                   IF        %FOUND(SDAACOL0)
 
      ** Reload input data
 
     C                   EVAL      AACOFilFmt = PData
     C                   EXSR      SrConvert
 
     C                   UPDATE(E) SDACOFD0
     C                   IF        %ERROR
     C                   ITER
     C                   ENDIF
 
     C                   ELSE
 
     C                   WRITE(E)  SDACOFD0
     C                   IF        %ERROR
     C                   ITER
     C                   ENDIF
     C                   ENDIF
 
     C                   EVAL      C_Update = 'Y'
     C                   LEAVE
 
     C                   ENDDO
 
     C                   IF        C_Update <> 'Y'
     C                   EVAL      PFile =  'SDAACOL0'
     C                   EVAL      PKey  =  AZACOC
     C                   EVAL      PDbase = 005
     C                   EVAL      PProc =  'SR/SRACCP'
     C                   EXSR      Sr_DbError
     C                   ENDIF
 
     C                   ENDSR
 
      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * Sr_Qcmd - Call to QCMDEXC routine                             *
      *                                                               *
      * Called by: Sr_UpdTrl                                          *
      *                                                               *
      * Calls: *None                                                  *
      *                                                               *
      *****************************************************************
 
     C     Sr_Qcmd       BEGSR
 
     C                   EVAL      PCommand = 'DLYJOB DLY(1)'
 
     C                   CALL      'QCMDEXC'
     C                   PARM                    PCommand
     C                   PARM      80            PLength
 
     C                   ENDSR
 
      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * Sr_DbError - Call to Database Error routine                   *
      *                                                               *
      * Called by: Sr_DbError                                         *
      *                                                               *
      * Calls: *None                                                  *
      *                                                               *
      *****************************************************************
 
     C     Sr_DbError    BEGSR
 
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  PFile
     C                   EVAL      DBKEY  =  PKey
     C                   EVAL      DBPGM  =  'SDACOFCP'
     C                   EVAL      DBASE  =  PDbase
     C                   EVAL      DBMOD  =  PSProcMod
     C                   EVAL      DBPROC =  PProc
     C                   OUT       LDA
     C                   EVAL      PRetCode = '*ERROR'
     C                   EXSR      *PSSR
 
     C                   ENDSR
 
      **********************************************************************
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
 
     C     *entry        PLIST
     C                   PARM                    PData
     C                   PARM                    PRetcode
     C                   PARM                    PProgram
 
     C     *DTAARA       DEFINE                  LDA
 
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
      * Called by: (**calling routines**)                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'
     C                   DUMP
      *
     C                   CALL      'DBERRCTL'
      *
     C                   ENDIF
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C                   ENDSR
      *
