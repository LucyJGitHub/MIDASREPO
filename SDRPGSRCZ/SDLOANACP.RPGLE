     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2006')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Loan Type/Sub-Type Acceptance')               *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  SDLOANACP - SD Loan Type/Sub-Type Acceptance                 *
      *                                                               *
      *  Function:  This program updates the SD Loan Type/SubType     *
      *             Zonal or Acceptance files based on the data       *
      *             sent by the background jobs                       *
      *                                                               *
      *  Called By: SDC000060 - SD Central Data Acceptance Job        *
      *                                                               *
      *  (c) Finastra International Limited 2006                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CLE164             Date 18Aug14               *
      *                 CLE134             Date 01Aug12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG11799           Date 30Jul06               *
      *                 CSD031  *CREATE    Date 10Apr06               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *             (Recompile)                                       *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE164 - CLE134 Enhancement F (Repayment Methodology)        *
      *           (Recompile)                                         *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  BUG11799 - DB error on amend and delete mode                 *
      *  CSD031 - Enhanced Centralised Static Data                    *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  *PSSR - Error processing                                     *
      *  *INZSR - Initialise                                          *
      *  SrZone - Entry routine for updating Zonal Files              *
      *  Sr_UpdCurCod - Routine for updating Currency Code file       *
      *  Sr_UpdTrailr - Routine for updating Trailer file             *
      *  Sr_UpdICFile - Routine for updating Installation Control file*
      *  Sr_UpdICEFil - Routine for updating Installation Control     *
      *                 Extension file                                *
      *  Sr_UpdICTFil - Routine for updating Installation Control     *
      *                 Trailer file                                  *
      *  Sr_Accp - Routine to update Acceptance file                  *
      *  Sr_Qcmd - Routine to execute Job Command                     *
      *  Sr_FillRECCY - Routine to update RECCY record                *
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
 
      ** Midas SD Loan Type/Sub-Type file
     FSDLOANL0  UF A E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
 
      ** Midas SD Loan Type/Sub-Type Acceptance file
     FSDALTSL0  UF A E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
      ** Midas SD Loan type/sub-typ - LU Ext. File                                          BUG11799
     FSDLNX1L0  UF A E           K DISK    INFSR(*PSSR)                                     BUG11799
     F                                     COMMIT                                           BUG11799
 
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
      ** Midas SD Loan Types/Sub-Types Acceptance File
     D Ds_AcceptFile E DS                  ExtName(SDALTSPD)
 
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
 
     D PReturn         S              7A
     D PLoanType       S              2A
     D PLoanSubType    S              2A
     D PLTDescription  S             30A
     D PLoanProc       S              2P 0
     D PTLChange       S              1A
     D PMidasNo        S              5P 0
 
     D k_LoanTyp       S                   Like(AYLNTY)
     D k_LoanSTp       S                   Like(AYLNST)
     D k_LoanCls       S                   Like(AYLNCL)                                     BUG11799
 
     D w_Action        S              1A
     D w_AYRANG        S                   Like(AYRANG)
     D w_AYILTY        S                   Like(AYILTY)
     D w_AYILST        S                   Like(AYILST)
     D w_AYAACC        S                   Like(AYAACC)
 
     D v_Count         S              3  0
     D v_AYLNPT        S                   Like(AYLNPT)
     D v_AYLNTD        S                   Like(AYLNTD)
 
     D i_Success       S               N
 
     D c_Yes           C                   Const('Y')
     D c_Insert        C                   Const('I')
     D c_Amend         C                   Const('A')
     D c_AcceptEffDte  C                   Const('SDC000061')
     D c_File          C                   Const('SDLOANPD  ')
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
 
     C     *DTAARA       DEFINE                  LDA
 
     C                   EVAL      Ds_AcceptFile = PData
 
      ** Save key fields as well as the amendable fields
 
     C                   EVAL      k_LoanTyp = AYLNTY
     C                   EVAL      k_LoanSTp = AYLNST
     C                   EVAL      k_LoanCls = AYLNCL                                       BUG11799
     C                   EVAL      w_AYRANG = AYRANG
     C                   EVAL      w_AYILTY = AYILTY
     C                   EVAL      w_AYILST = AYILST
     C                   EVAL      v_AYLNPT = AYLNPT
     C                   EVAL      v_AYLNTD = AYLNTD
     C                   EVAL      w_AYAACC = AYAACC
 
     C                   IF        AYAACC = c_Yes or
     C                             PProgram = c_AcceptEffDte
     C                   EXSR      SrZone
     C                   ELSE
     C                   EXSR      SrAccp
     C                   ENDIF
 
      ** Commit changes if there are no errors, otherwise rollback
 
     C                   IF        PRetCode = *BLANKS
     C                   COMMIT
     C                   ENDIF
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrZone - Zonal File Update Routine                           *
      *                                                               *
      *  Called by: Main Routine                                      *
      *                                                               *
      *  Calls: Sr_UpdLoanF / Sr_UpdTrailr                            *
      *                                                               *
      *****************************************************************
 
     C     SrZone        BEGSR
 
      ** Update Loan Type/SubType Codes File
 
     C                   EXSR      Sr_UpdLoanF
 
      ** Update Trailer File
 
     C                   EXSR      Sr_UpdTrailr
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  Sr_UpdLoanF - Loan Type/Sub-type Update Routine              *
      *                                                               *
      *  Called by: SrZone                                            *
      *                                                               *
      *  Calls: SrQcmd                                                *
      *                                                               *
      *****************************************************************
 
     C     Sr_UpdLoanF   BEGSR
 
      ** Update Loan Type/Sub-type with data from Acceptance File
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
 
     C     key_LoanF     CHAIN(e)  @AYRECK
     C                   IF        %Error
     C                   ITER
     C                   ENDIF
     C                   IF        %Found(SDLOANL0)
 
      ** ...only override fields that are globally maintained
 
     C                   EVAL      AYRANG = w_AYRANG
     C                   EVAL      AYILTY = w_AYILTY
     C                   EVAL      AYILST = w_AYILST
     C                   EVAL      AYLNPT = v_AYLNPT
     C                   EVAL      AYLNTD = v_AYLNTD
     C                   EVAL      AYLCD  = BJRDNB
     C                   EVAL      AYEACC = BJRDNB
     C                   EVAL      AYAACC = w_AYAACC
     C                   EVAL      AYTYLC = c_Amend
     C                   UPDATE(e) @AYRECK
     C                   IF        %Error
     C                   ITER
     C                   ENDIF
 
     C                   EXSR      SRTablet6
     C                   EVAL      w_Action = c_Amend
     C                   ELSE
 
     C                   EVAL      Ds_AcceptFile = PData
     C                   EVAL      AYTYLC = c_Insert
     C                   EVAL      AYLCD  = BJRDNB
     C                   EVAL      AYEACC = BJRDNB
     C                   WRITE(e)  @AYRECK
      *                                                                                     BUG11799
     C                   Eval      VILNTY = AYLNTY                                          BUG11799
     C                   Eval      VILNST = AYLNST                                          BUG11799
     C                   Eval      VIMOBC = 0                                               BUG11799
     C                   Eval      VIPMOB = 0                                               BUG11799
     C                   Eval      VIDIST = 0                                               BUG11799
     C                   Eval      VILNCL = AYLNCL                                          BUG11799
     C                   Write(e)  SDLOANF6                                                 BUG11799
     C                   IF        %Error
     C                   ITER
     C                   ENDIF
 
     C                   EXSR      SRTablet6
     C                   EVAL      w_Action = c_Insert
     C                   ENDIF
 
      ** ...if the program reaches this point, no errors
      **    were encountered
 
     C                   EVAL      i_Success = *On
     C                   LEAVE
 
     C                   ENDDO
 
     C                   IF        i_Success = *Off
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'SDLOANL0'
     C**********         EVAL      DBKEY  =  k_LoanTyp + k_LoanSTp                          BUG11799
     C                   EVAL      DBKEY  =  k_LoanTyp + k_LoanSTp + k_LoanCls              BUG11799
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   EVAL      DBASE  =  001
     C                   EVAL      DBMOD  =  PSProcMod
     C                   EVAL      DBPROC =  'SR/Sr_UpdLoanF '
     C                   OUT       LDA
     C                   EVAL      PRetCode = '*ERROR'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRTablet6  - Call Tablet6                                    *
      *                                                               *
      *****************************************************************
 
     C     SRTablet6     BEGSR
 
     C                   CALL(e)   'TABLET6'
     C                   PARM      *BLANKS       PReturn
     C                   PARM      AYLNTY        PLoanType
     C                   PARM      AYLNST        PLoanSubType
     C                   PARM      AYLNTD        PLTDescription
     C                   PARM      AYLNPT        PLoanProc
     C                   PARM      AYTYLC        PTLChange
     C                   PARM      BJRDNB        PMidasNo
 
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
      *  SrAccp - Acceptance File Update Routine                      *
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
 
     C     key_LoanF     CHAIN(e)  SDLOAND0
     C                   IF        %Error
     C                   ITER
     C                   ENDIF
 
     C                   EVAL      Ds_AcceptFile = PData
 
     C                   IF        %Found(SDALTSL0)
     C                   UPDATE(e) SDLOAND0
     C                   IF        %Error
     C                   ITER
     C                   ENDIF
 
     C                   ELSE
 
     C                   WRITE(e)  SDLOAND0
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
     C                   EVAL      DBFILE =  'SDALTSPD'
     C**********         EVAL      DBKEY  =  k_LoanTyp + k_LoanSTp                          BUG11799
     C                   EVAL      DBKEY  =  k_LoanTyp + k_LoanSTp + k_LoanCls              BUG11799
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
      *  Called by: Sr_UpdLoanF / Sr_UpdTrailr / SrAccp               *
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
 
     C     key_LoanF     KLIST
     C                   KFLD                    k_LoanTyp
     C                   KFLD                    k_LoanSTp
     C                   KFLD                    k_LoanCls                                  BUG11799
 
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
      *  Called by: Sr_UpdCurCod / Sr_UpdTrailr / Sr_FillRECCY /      *
      *             Sr_UpdICFile / Sr_UpdICEFil / Sr_UpdICTFil /      *
      *             SrAccp                                            *
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
 
