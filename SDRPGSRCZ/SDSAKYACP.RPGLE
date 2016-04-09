     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2006')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD SE Account Keys Acceptance')                  *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  SDSAKYACP - SD SE Account Keys Acceptance                    *
      *                                                               *
      *  Function:  This program updates the zonal file and the       *
      *             acceptance file based on the data sent by the     *
      *             background job SDC000060 or SD000061              *
      *                                                               *
      *  Called By: SDC000060 - SD Central Data Acceptance BG Job     *
      *             SD000061 -  SD Central Data Acceptance on         *
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
      *  CSD031 - Enhanced Centralised Static Data.                   *
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
      * SRZONE    - Zonal file update routine                         *
      * SRSACCTKEY - Account key update routine                       *
      * SRTRAILER - Standing data control update file                 *
      * SRACCP    - Acceptance file update routine                    *
      * SRDELAY   - Delay job for 1 second                            *
      * *PSSR     - Error processing                                  *
      * *INZSR    - Initialise                                        *
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
      *
      ** Midas SE Account Keys
     FSEACKD    UF A E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
      *
      ** Midas SE Account Keys (Audit)
     FSEACKA    UF   E             DISK    INFSR(*PSSR)
     F                                     COMMIT
      *
      ** Midas SE Account Keys Acceptance File
     FSDASAKL0  UF A E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SEACKDF:SDASKDF)
     F                                     COMMIT
     F
 
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
      *
      ** Midas SD Account Code Acceptance file
     D Ds_AcceptFile E DS                  ExtName(SDASAKPD)
      *
 
      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** First DS for access programs, short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D @RUN            S              1
     D DFound          S              1A
     D DSuccess        S              1A
      *
      ** Entry Parameters
      *
     D PDATA           S           4000A
     D PPROGRAM        S             10A
     D RetCodeOut      S              7A
      *
      ** Parameter List
      *
     D PCmd            S             13A   Inz('DLYJOB DLY(1)')
     D PCmd_Len        S             15  5
      *
      ** Key Fields
      *
     D KSAcctKey       S                   Like(ACKE)
      *
     D c_Yes           C                   Const('Y')
 
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
      *
      ** Read in Installation Data
      *
     C     *DTAARA       DEFINE                  LDA
      *
     C                   EVAL      Ds_AcceptFile = PDATA
      *
     C                   IF        AACC     = c_Yes or
     C                             PPROGRAM = 'SDC000061'
     C                   EXSR      SrZone
     C                   ELSE
     C                   EXSR      SrAccp
     C                   ENDIF
      *
      ** Commit changes if there are no errors, otherwise rollback
      *
     C                   IF        RetCodeOut = *Blanks
     C                   COMMIT
     C                   ELSE
     C                   ROLBK
     C                   ENDIF
 
     C                   EVAL      *INLR = *On
     C                   RETURN
 
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
     C                   PARM                    PDATA
     C                   PARM                    RetCodeOut
     C                   PARM                    PPROGRAM
 
     C     KSACCT        KLIST
     C                   KFLD                    KSAcctKey
 
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
      *  SrZone - Zonal File update routine                           *
      *                                                               *
      *  Called by: Main Routine                                      *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     SrZone        BEGSR
      *
      ** Add/Update SEACKD - SE Account Key Physical File
      *
     C                   EXSR      SrSAcctKey
      *
      ** Add/Update SEACKA - SE Account Key Trailer file
      *
     C                   EXSR      SrTrailer
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrSAcctKey - SE Account Key Update routine                   *
      *               Write/Update to Zonal Account Key File          *
      *                                                               *
      *  Called by: SrZone                                            *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     SrSAcctKey    BEGSR
      *
     C                   EVAL      KSAcctKey = ACKE
     C                   EVAL      DFound    = 'Y'
     C                   EVAL      DSuccess  = 'N'
      *
     C                   DO        100
     C     KSACCT        CHAIN(e)  SEACKD
     C                   IF        %Error()
     C                   EXSR      SrDelay
     C                   ITER
     C                   ELSE
     C                   IF        %Found()
     C                   EVAL      Ds_AcceptFile = PDATA
     C                   Eval      CHTP = 'A'
     C                   Eval      EACC = BJRDNB
     C                   Eval      LCD  = BJRDNB
     C                   UPDATE(e) SEACKDF
     C                   IF        %Error()
     C                   EXSR      SrDelay
     C                   ITER
     C                   ENDIF
     C                   ELSE
     C                   Eval      CHTP = 'I'
     C                   Eval      EACC = BJRDNB
     C                   Eval      LCD  = BJRDNB
     C                   WRITE(e)  SEACKDF
     C                   IF        %Error()
     C                   EXSR      SrDelay
     C                   ITER
     C                   ENDIF
     C                   EVAL      DFound = 'N'
     C                   ENDIF
     C                   EVAL      DSuccess  = 'Y'
     C                   LEAVE
     C                   ENDIF
     C                   ENDDO
      *
     C                   IF        DSuccess = 'N'
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'SEACKD'
     C                   EVAL      DBKEY  =  KSAcctKey
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   EVAL      DBASE  =  001
     C                   EVAL      DBMOD  =  PSProcMod
     C                   EVAL      DBPROC =  'SR/SrSAcctKey'
     C                   OUT       LDA
     C                   EVAL      RetCodeOut = '*ERROR'
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrTrailer - Standing Data control update file                *
      *                                                               *
      *  Called by: SrZone                                            *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     SrTrailer     BEGSR
      *
     C                   EVAL      DSuccess  = 'N'
      *
     C                   DO        100
     C     1             CHAIN(e)  SEACKA
     C                   IF        %Error()
     C                   EXSR      SrDelay
     C                   ITER
     C                   ENDIF
     C                   IF        %Found()
     C                   IF        DFound = 'Y'
     C                   EVAL      SAMD   = SAMD + 1
     C                   ELSE
     C                   EVAL      NORE   = NORE + 1
     C                   EVAL      SINS   = SINS + 1
     C                   ENDIF
     C                   UPDATE(e) SEACKAF
     C                   IF        not %Error()
     C                   EVAL      DSuccess  = 'Y'
     C                   ENDIF
     C                   ENDIF
     C                   LEAVE
     C                   ENDDO
      *
     C                   IF        DSuccess = 'N'
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'SEACKA'
     C                   EVAL      DBKEY  =  ' '
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   EVAL      DBASE  =  002
     C                   EVAL      DBMOD  =  PSProcMod
     C                   EVAL      DBPROC =  'SR/SrTrailer'
     C                   OUT       LDA
     C                   EVAL      RetCodeOut = '*ERROR'
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrAccp - Acceptance file update routine                      *
      *                                                               *
      *  Called by: Main Routine                                      *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     SrAccp        BEGSR
      *
     C                   EVAL      KSAcctKey  = ACKE
      *
     C                   DO        100
     C     KSACCT        CHAIN(e)  SDASAKL0
     C                   IF        %Error()
     C                   EXSR      SrDelay
     C                   ITER
     C                   ELSE
     C                   IF        %Found()
     C                   EVAL      Ds_AcceptFile = PDATA
     C                   UPDATE(e) SDASKDF
     C                   ELSE
     C                   WRITE(e)  SDASKDF
     C                   ENDIF
     C                   IF        %Error()
     C                   ITER
     C                   ELSE
     C                   LEAVE
     C                   ENDIF
     C                   ENDIF
     C                   ENDDO
      *
     C                   IF        DSuccess = 'N'
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'SDASAKL0'
     C                   EVAL      DBKEY  =  KSAcctKey
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   EVAL      DBASE  =  003
     C                   EVAL      DBMOD  =  PSProcMod
     C                   EVAL      DBPROC =  'SR/SrAccp'
     C                   OUT       LDA
     C                   EVAL      RetCodeOut = '*ERROR'
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrDelay - Delay Job for 1 second                             *
      *                                                               *
      *  Called by: SrZone                                            *
      *             SrAccp                                            *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     SrDelay       BEGSR
      *
     C                   EVAL      PCmd_Len = %Len(PCmd)
     C                   CALL      'QCMDEXC'
     C                   PARM                    PCmd
     C                   PARM                    PCmd_Len
      *
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
