     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2006')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Facility Type Acceptance')                    *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  SDFACTACP - SD Facility Type Acceptance                      *
      *                                                               *
      *  Function:  This program updates the Zonal file and the       *
      *             Acceptance file based on the data sent by the     *
      *             background jobs.                                  *
      *                                                               *
      *  Called By: SDC000060 - SD Central Data Acceptance Job        *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2006            *
      *                                                               *
      *  Last Amend No. CLE164             Date 18Aug14               *
      *  Prev Amend No. CLE134             Date 01Aug12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031  *CREATE    Date 10Apr06               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CLE164 - CLE134 Enhancement F (Repayment Methodology)        *
      *           (Recompile)                                         *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CSD031 - Enhanced Centralised Static Data                    *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  *PSSR - Error processing                                     *
      *  *INZSR - Initialise                                          *
      *  SrZone - Entry routine to update Zonal files                 *
      *  Sr_UpdFaclty - Routine to update Facility File               *
      *  Sr_UpdTrailr - Routine to update Trailer File                *
      *  SrAccp - Entry routine to update Acceptance files            *
      *  SrQcmd - Routine to submit delay job via QCMDEXC             *
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
 
      ** Midas SD Facility Types
     FSDFACTL0  UF A E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
 
      ** Midas SD Facility Type Acceptance File
     FSDAFCTL0  UF A E           K DISK    INFSR(*PSSR)
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
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
      *
      ** Data Area giving Installation Control Details
 
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
 
      ** Midas SD Facility Type Acceptance file
 
     D Ds_AcceptFile E DS                  ExtName(SDAFCTPD)
 
      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** First DS for access programs, short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
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
 
     D w_FcltyTyp      S                   Like(AMFCTY)
     D w_Action        S              1A
 
     D v_Count         S              3  0
 
     D i_Success       S               N
 
     D W0RTN           S              7
 
     D c_Yes           C                   Const('Y')
     D c_Insert        C                   Const('I')
     D c_Amend         C                   Const('A')
     D c_File          C                   Const('SDFACTPD  ')
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
      * MAIN PROCEDURE                                                *
      *****************************************************************
 
      ** Read in Installation Data
 
     C     *DTAARA       DEFINE                  RUNDAT
     C     *DTAARA       DEFINE                  LDA
     C                   IN        RUNDAT
      *
     C                   EVAL      Ds_AcceptFile = PData
     C                   EVAL      w_FcltyTyp = AMFCTY
      *
     C                   IF        AMAACC = c_Yes or
     C                             PProgram = 'SDC000061'
     C                   EXSR      SrZone
     C                   ELSE
     C                   EXSR      SrAccp
     C                   ENDIF
 
      ** Commit changes if there are no errors, otherwise rollback
 
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
      *  Calls: Sr_UpdFaclty / Sr_UpdTrailr                           *
      *                                                               *
      *****************************************************************
 
     C     SrZone        BEGSR
 
      ** Update Facility File
 
     C                   EXSR      Sr_UpdFaclty
 
      ** Update Trailer File
 
     C                   EXSR      Sr_UpdTrailr
      *
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  Sr_UpdFaclty - Facility File Update Routine                  *
      *                                                               *
      *  Called by: SrZone                                            *
      *                                                               *
      *  Calls: SrQcmd                                                *
      *                                                               *
      *****************************************************************
 
     C     Sr_UpdFaclty  BEGSR
 
      ** Update Facility File with data from Acceptance File
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
 
     C     w_FcltyTyp    CHAIN(e)  @AMRECT
     C                   IF        %Error
     C                   ITER
     C                   ENDIF
     C                   EVAL      Ds_AcceptFile = PData
     C                   IF        %Found(SDFACTL0)
     C                   EVAL      AMTYLC = c_Amend
     C                   EVAL      AMEACC = BJRDNB
     C                   EVAL      AMLCD  = BJRDNB
     C                   UPDATE(e) @AMRECT
     C                   IF        %Error
     C                   ITER
     C                   ENDIF
     C                   EVAL      w_Action = c_Amend
     C                   ELSE
     C                   EVAL      AMTYLC = c_Insert
     C                   EVAL      AMEACC = BJRDNB
     C                   EVAL      AMLCD  = BJRDNB
     C                   WRITE(e)  @AMRECT
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
     C                   EVAL      DBFILE =  'SDFACTL0'
     C                   EVAL      DBKEY  =  w_FcltyTyp
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   EVAL      DBASE  =  002
     C                   EVAL      DBMOD  =  PSProcMod
     C                   EVAL      DBPROC =  'SR/Sr_UpdFaclty'
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
     C                   EVAL      DBASE  =  003
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
 
      ** Update TABLETQ file
 
     C                   CALL      'TABLETQ'
     C     W0RTN         PARM      W0RTN         WQ0007            7
     C                   PARM      AMFCTY        WQ0008            3
     C                   PARM      AMFCNM        WQ0009           30
     C                   PARM      AMTYLC        WQ0010            1
     C                   PARM      BJRDNB        WQ0011            5 0                        CSD031
 
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
     C                   EVAL      DBASE  =  004
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
 
     C     w_FcltyTyp    CHAIN(e)  SDFACTD0
     C                   IF        %Error
     C                   ITER
     C                   ENDIF
     C                   EVAL      Ds_AcceptFile = PData
     C                   IF        %Found(SDAFCTL0)
     C                   UPDATE(e) SDFACTD0
     C                   IF        %Error
     C                   ITER
     C                   ENDIF
     C                   ELSE
     C                   WRITE(e)  SDFACTD0
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
     C                   EVAL      DBFILE =  'SDAFCTL0'
     C                   EVAL      DBKEY  =  w_FcltyTyp
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   EVAL      DBASE  =  005
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
      *  Called by: Sr_UpdFaclty / Sr_UpdTrailr / SrAccp              *
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
      *  Called by: Sr_UpdFaclty / Su_UpdTrailr / SrAccp              *
      *                                                               *
      *  Calls: DBERRCTL                                              *
      *                                                               *
      *****************************************************************
      *
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
      *
