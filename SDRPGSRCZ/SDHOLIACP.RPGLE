     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2006')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Holidays Acceptance')                         *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  SDHOLIACP - SD Holidays Acceptance                           *
      *                                                               *
      *  Function:  This program updates the Zonal file and the       *
      *             Acceptance file based on the data sent by the     *
      *             background jobs.                                  *
      *                                                               *
      *  Called By: SDC000060 - SD Central Data Acceptance Job        *
      *                                                               *
      *  (c) Finastra International Limited 2006                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CLE134             Date 01Aug12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031  *CREATE    Date 10Apr06               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CSD031 - Enhanced Centralised Static Data                    *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  *PSSR - Error processing                                     *
      *  *INZSR - Initialise                                          *
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
 
      ** Midas SD Holidays File
     FSDHOLL0   UF A E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
 
      ** Midas SD Holidays Acceptance File
     FSDAHDYL0  UF A E           K DISK    INFSR(*PSSR)
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
 
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
      *
      ** Program Status Data Structure
      *
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
     D c_Yes           C                   Const('Y')
     D c_Insert        C                   Const('I')
     D c_Amend         C                   Const('A')
     D c_Holiday       C                   Const('X')
     D c_File          C                   Const('SDHOLPD   ')
     D c_DelayJob      C                   Const('DLYJOB DLY(1)')
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** First DS for access programs, short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** Midas SD Holidays Acceptance File
     D Ds_AcceptFile E DS                  ExtName(SDAHDYPD)
 
      ** Global Holidays Array File
     D Arr_Global      S              1    Dim(%Len(Ds_AcceptFile))
 
      ** Zonal/Acceptance Holidays Array File
     D Arr_Zonal       S              1    Dim(%Len(Ds_AcceptFile))
 
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
 
     D k_CurCode       S                   Like(DGCYCD)
     D k_LocCode       S                   Like(DGLCCD)
     D k_YearNbr       S                   Like(DGYRNB)
 
     D w_Action        S              1A
     D w_AccZone       S                   Like(DGAACC)
 
     D v_Count         S              3  0
     D v_Idx           S              3  0
     D v_AccEffD       S                   Like(DGEACC)
 
     D i_Success       S               N
 
 
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
 
      ** Read in Local Data Area
 
     C     *DTAARA       DEFINE                  LDA
 
     C                   EVAL      Ds_AcceptFile = PData
     C                   MOVEA     PData         Arr_Global
     C                   EVAL      k_CurCode = DGCYCD
     C                   EVAL      k_LocCode = DGLCCD
     C                   EVAL      k_YearNbr = DGYRNB
     C                   EVAL      v_AccEffD = DGEACC
     C                   EVAL      w_AccZone = DGAACC
 
     C                   IF        DGAACC = c_Yes or
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
      *  Calls: Sr_UpdHolFil / Sr_UpdTrailr                           *
      *                                                               *
      *****************************************************************
 
     C     SrZone        BEGSR
 
      ** Update Facility File
 
     C                   EXSR      Sr_UpdHolFil
 
      ** Update Trailer File
 
     C                   EXSR      Sr_UpdTrailr
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  Sr_UpdHolFil - Holiday File Update Routine                   *
      *                                                               *
      *  Called by: SrZone                                            *
      *                                                               *
      *  Calls: SrQcmd / *PSSR                                        *
      *                                                               *
      *****************************************************************
 
     C     Sr_UpdHolFil  BEGSR
 
      ** Update Holiday File with data from Acceptance File
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
 
     C     key_HolDay    CHAIN(e)  @HOLPHG
     C                   IF        %Error
     C                   ITER
     C                   ENDIF
 
     C                   IF        %Found(SDHOLL0)
     C                   EXSR      Sr_FillArr
     C                   EVAL      DGTYLC = c_Amend
     C                   EVAL      DGEACC = BJRDNB
     C                   EVAL      DGLCD  = BJRDNB
     C                   EVAL      DGAACC = w_AccZone
     C                   UPDATE(e) @HOLPHG
     C                   IF        %Error
     C                   ITER
     C                   ENDIF
     C                   EVAL      w_Action = c_Amend
 
     C                   ELSE
 
     C                   EVAL      Ds_AcceptFile = PData
     C                   EVAL      DGEACC = BJRDNB
     C                   EVAL      DGLCD  = BJRDNB
     C                   EVAL      DGTYLC = c_Insert
     C                   WRITE(e)  @HOLPHG
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
     C                   EVAL      DBFILE =  'SDHOLL0'
     C                   EVAL      DBKEY  =  k_CurCode + k_LocCode + k_YearNbr
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   EVAL      DBASE  =  001
     C                   EVAL      DBMOD  =  PSProcMod
     C                   EVAL      DBPROC =  'SR/Sr_UpdHolFil'
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
      *  Calls: SrQcmd / *PSSR                                        *
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
      *  SrAccp - Acceptane File Update Routine                        *
      *                                                               *
      *  Called by: Main Routine                                       *
      *                                                               *
      *  Calls: SrQcmd / *PSSR
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
 
     C     key_HolDay    CHAIN(e)  SDHOLD0
     C                   IF        %Error
     C                   ITER
     C                   ENDIF
 
     C                   EVAL      Ds_AcceptFile = PData
     C                   IF        %Found(SDAHDYL0)
     C                   UPDATE(e) SDHOLD0
     C                   IF        %Error
     C                   ITER
     C                   ENDIF
 
     C                   ELSE
 
     C                   WRITE(e)  SDHOLD0
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
     C                   EVAL      DBFILE =  'SDAHDYL0'
     C                   EVAL      DBKEY  =  k_CurCode + k_LocCode + k_YearNbr
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
      *  Sr_FillArr -  Holidays Array Population Routine              *
      *                This routine basically updates the Holiday     *
      *                Zonal or Acceptance Files on a per field       *
      *                basis (from Jan01 to Dec31)                    *
      *                                                               *
      *  Called by: Sr_UpdHolFil / SrAccp                             *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
 
     C     Sr_FillArr    BEGSR
 
     C                   MOVEA     Ds_AcceptFile Arr_Zonal
 
     ** Jan01 is at position 17
     ** Dec31 is at position 382
 
     C                   EVAL      v_Idx = 17
 
     C                   DOW       v_Idx < 383
     C                   IF        Arr_Global(v_Idx) = c_Holiday
     C                   EVAL      Arr_Zonal(v_Idx) = c_Holiday
     C                   ENDIF
 
     C                   EVAL      v_Idx = v_Idx + 1
 
     C                   ENDDO
 
     C                   MOVEA     Arr_Zonal     Ds_AcceptFile
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrQcmd - Job Command Execution routine                       *
      *                                                               *
      *  Called by: Sr_UpdHolFil / Sr_UpdTrailr / SrAccp              *
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
 
     C     key_HolDay    KLIST
     C                   KFLD                    k_CurCode
     C                   KFLD                    k_LocCode
     C                   KFLD                    k_YearNbr
 
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
      *  Called by: Sr_UpdHolFil / Sr_UpdTrailr / SrAccp              *
      *                                                               *
      *  Calls: DBERRCTL                                              *
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
 
