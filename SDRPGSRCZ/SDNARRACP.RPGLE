     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2006')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Narrative Codes Acceptance')                  *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  SDNARRACP - SD Narrative Codes Acceptance                    *
      *                                                               *
      *  Function:  This program updates the Zonal file and the       *
      *             Acceptance file based on the data sent by the     *
      *             background jobs.                                  *
      *                                                               *
      *  Called By: SDC000060 - SD Central Data Acceptance Job        *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2006            *
      *                                                               *
      *  Last Amend No. CLE134             Date 01Aug12               *
      *  Prev Amend No. CER059             Date 19Jul10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031  *CREATE    Date 10Apr06               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CSD031 - Enhanced Centralised Static Data                    *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  *PSSR - Error processing                                     *
      *  *INZSR - Initialise                                          *
      *  SrZone - Zonal File Update Routine                           *
      *  Sr_UpdNarCod - Narrative Code Update Routine                 *
      *  Sr_UpdTrailr - Trailer File Update Routine                   *
      *  SrAccp - Acceptane File Update Routine                       *
      *  SrQcmd - Job Command Execution routine                       *
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
 
      ** Midas SD Standing Data Control File
     FSDFCTLL0  UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
 
      ** Midas SD Narrative Codes File
     FSDNARRL0  UF A E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
 
      ** Midas SD Narrative Codes Acceptance File
     FSDANARL0  UF A E           K DISK    INFSR(*PSSR)
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
      *
 
      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** First DS for access programs, short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
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
      *
      ** Midas SD Narrative Codes Acceptance file
     D Ds_AcceptFile E DS                  ExtName(SDANARPD)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D @RUN            S              1
 
      ** Entry Parameters
 
     D PData           S           4000A
     D PRetCode        S              7A
     D PProgram        S             10A
 
     D p_Cmd           S             13A
     D p_CmdLen        S             15  5 Inz(%Len(p_Cmd))
 
     D w_NarCod        S                   Like(ALNVCD)
     D w_ALAACC        S                   Like(ALAACC)
     D w_ALDON         S                   Like(ALDON)
     D w_Action        S              1A
 
     D v_Count         S              3  0
 
     D i_Success       S               N
 
     D c_Yes           C                   Const('Y')
     D c_Insert        C                   Const('I')
     D c_Amend         C                   Const('A')
     D c_AcceptEffDte  C                   Const('SDC000061')
     D c_File          C                   Const('SDNARRPD  ')
     D c_DelayJob      C                   Const('DLYJOB DLY(1)')
 
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
      *  MAIN PROCEDURE                                               *
      *****************************************************************
 
      ** Read in Installation Data
 
     C     *DTAARA       DEFINE                  LDA
 
     C                   EVAL      Ds_AcceptFile = PData
     C                   EVAL      w_NarCod = ALNVCD
     C                   EVAL      w_ALAACC = ALAACC
     C                   EVAL      w_ALDON  = ALDON
 
     C                   IF        ALAACC = c_Yes or
     C                             PProgram = c_AcceptEffDte
     C                   EXSR      SrZone
     C                   ELSE
     C                   EXSR      SrAccp
     C                   ENDIF
 
      ** Commit changes if there are no errors
 
     C                   IF        PRetCode = *Blanks
     C                   COMMIT
     C                   ENDIF
 
     C                   EVAL      *INLR = *On
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrZone - Zonal File Update Routine                           *
      *                                                               *
      *  Called by: Main Routine                                      *
      *                                                               *
      *  Calls: Sr_UpdNarCod / Sr_UpdTrailr                           *
      *                                                               *
      *****************************************************************
 
     C     SrZone        BEGSR
 
      ** Update Narrative Code
 
     C                   EXSR      Sr_UpdNarCod
 
      ** Update Trailer File
 
     C                   EXSR      Sr_UpdTrailr
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  Sr_UpdNarCod - Narrative Code Update Routine                 *
      *                                                               *
      *  Called by: SrZone                                            *
      *                                                               *
      *  Calls: SrQcmd                                                *
      *                                                               *
      *****************************************************************
 
     C     Sr_UpdNarCod  BEGSR
 
      ** Update Narrative code with data from Acceptance File
      ** ...retry file processing until successful or until loop
      **    count is 100
 
     C                   DO        100           v_Count
 
      ** ...only process delay when error is encountered, that is
      **    when loop is iterated
 
     C                   IF        v_Count > 1
     C                   EXSR      SrQcmd
     C                   ENDIF
 
      ** ...if there are errors, iterate and start anew with processing
      **    until updates are successful
 
     C     w_NarCod      CHAIN(e)  @ALRECZ
     C                   IF        %Error
     C                   ITER
     C                   ENDIF
     C                   IF        %Found(SDNARRL0)
     C                   EVAL      ALLCD  = BJRDNB
     C                   EVAL      ALTYLC = c_Amend
     C                   EVAL      ALDON  = w_ALDON
     C                   EVAL      ALAACC = w_ALAACC
     C                   EVAL      ALEACC = BJRDNB
     C                   UPDATE(e) @ALRECZ
     C                   IF        %Error
     C                   ITER
     C                   ENDIF
     C                   EVAL      w_Action = c_Amend
 
     C                   ELSE
 
     C                   EVAL      Ds_AcceptFile = PData
     C                   EVAL      ALLCD  = BJRDNB
     C                   EVAL      ALTYLC = c_Insert
     C                   EVAL      ALEACC = BJRDNB
     C                   WRITE(e)  @ALRECZ
     C                   IF        %Error
     C                   ITER
     C                   ENDIF
     C                   EVAL      w_Action = c_Insert
     C                   ENDIF
 
      ** ...if the program reaches this point, no errors
      **    were encountered
 
     C                   EVAL      i_Success = *On
     C                   LEAVE
 
     C                   ENDDO
 
     C                   IF        i_Success = *Off
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'SDNARRL0'
     C                   EVAL      DBKEY  =  w_NarCod
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   EVAL      DBASE  =  001
     C                   EVAL      DBMOD  =  PSProcMod
     C                   EVAL      DBPROC =  'SR/Sr_UpdNarCod'
     C                   OUT       LDA
     C                   EVAL      PRetCode = '*ERROR'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  Sr_UpdTrailr - Trailer File Update Routine                   *
      *                                                               *
      *  Called by: SrZone                                            *
      *                                                               *
      *  Calls: SrQcmd                                                *
      *                                                               *
      *****************************************************************
 
     C     Sr_UpdTrailr  BEGSR
 
      ** Update Trailer File
      ** ...retry file processing until successful or until loop
      **    count is 100
 
     C                   DO        100           v_Count
 
      ** ...only process delay when error is encountered, that is
      **    when loop is iterated
 
     C                   IF        v_Count > 1
     C                   EXSR      SrQcmd
     C                   ENDIF
 
      ** ...check if file is existing in trailer file
 
     C     c_File        CHAIN(e)  @AHREAU
     C                   IF        Not %Found(SDFCTLL0)
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'SDFCTLL0'
     C                   EVAL      DBKEY  =  c_File
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   EVAL      DBASE  =  002
     C                   EVAL      DBMOD  =  PSProcMod
     C                   EVAL      DBPROC =  'SR/Sr_UpdTrailr'
     C                   OUT       LDA
     C                   EXSR      *PSSR
 
     C                   ELSEIF    %Error
     C                   ITER
     C                   ENDIF
 
      ** ...update necessary fields based on action performed in
      **    facility update routine
 
     C                   IF        w_Action = c_Insert
     C                   EVAL      AHNORC = AHNORC + 1
     C                   EVAL      AHNOIN = AHNOIN + 1
     C                   ELSE
     C                   EVAL      AHNOAM = AHNOAM + 1
     C                   ENDIF
     C                   UPDATE(e) @AHREAU
     C                   IF        %Error
     C                   ITER
     C                   ENDIF
 
      ** ...if the program reaches this point, no errors were
      **    encountered
 
     C                   EVAL      i_Success = *On
     C                   LEAVE
 
     C                   ENDDO
 
     C                   IF        i_Success = *Off
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'SDFCTLL0'
     C                   EVAL      DBKEY  =  c_File
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   EVAL      DBASE  =  003
     C                   EVAL      DBMOD  =  PSProcMod
     C                   EVAL      DBPROC =  'SR/Sr_UpdTrailr'
     C                   OUT       LDA
     C                   EVAL      PRetCode = '*ERROR'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrAccp - Acceptane File Update Routine                       *
      *                                                               *
      *  Called by: Main Routine                                      *
      *                                                               *
      *  Calls: SrQcmd                                                *
      *                                                               *
      *****************************************************************
 
     C     SrAccp        BEGSR
 
      ** Update Acceptance File
      ** ...retry file processing until successful or until loop
      **    count is 100
 
     C                   DO        100           v_Count
 
      ** ...only process delay when error is encountered, that is
      **    when loop is iterated
 
     C                   IF        v_Count > 1
     C                   EXSR      SrQcmd
     C                   ENDIF
 
      ** ...if there are errors, iterate and start anew with processing
      **    until updates are successful
 
     C     w_NarCod      CHAIN(e)  SDNARRD0
     C                   IF        %Error
     C                   ITER
     C                   ENDIF
     C                   EVAL      Ds_AcceptFile = PData
     C                   IF        %Found(SDANARL0)
     C                   UPDATE(e) SDNARRD0
     C                   IF        %Error
     C                   ITER
     C                   ENDIF
     C                   ELSE
     C                   WRITE(e)  SDNARRD0
     C                   IF        %Error
     C                   ITER
     C                   ENDIF
     C                   ENDIF
 
      ** ...if the program reaches this point, no errors
      **    were encountered
 
     C                   EVAL      i_Success = *On
     C                   LEAVE
 
     C                   ENDDO
 
     C                   IF        i_Success = *Off
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'SDANARL0'
     C                   EVAL      DBKEY  =  w_NarCod
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   EVAL      DBASE  =  004
     C                   EVAL      DBMOD  =  PSProcMod
     C                   EVAL      DBPROC =  'SR/SrAccp'
     C                   OUT       LDA
     C                   EVAL      PRetCode = '*ERROR'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrQcmd - Job Command Execution routine                       *
      *                                                               *
      *  Called by: Sr_UpdNarCod / Sr_UpdTrailr / SrAccp              *
      *                                                               *
      *  Calls: QCMDEXC                                               *
      *                                                               *
      *****************************************************************
 
     C     SrQcmd        BEGSR
 
     C                   CALL      'QCMDEXC'
     C                   PARM      c_DelayJob    p_Cmd
     C                   PARM                    p_CmdLen
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation routine                      *
      *                                                               *
      *  Called by: Implicitly on program activation                  *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *entry        PLIST
     C                   PARM                    PData
     C                   PARM                    PRetCode
     C                   PARM                    PProgram
 
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
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR  - Program exception error routine                     *
      *           Called automatically if a program error occurs,     *
      *           or directly by the program code using EXSR.         *
      *           This subroutine DUMPs the program just once.        *
      *                                                               *
      *  Called by: (**calling routines**)                            *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
 
     C     *PSSR         BEGSR
 
     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'
     C                   DUMP
 
     C                   CALL      'DBERRCTL'
 
     C                   ENDIF
 
     C                   ROLBK
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
 
