     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2006')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Account Keys Acceptance')                     *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  SDAKEYACP - SD Account Keys Acceptance                       *
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
      *  Prev Amend No. CER049             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG12492           Date 08Nov06               *
      *                 CSD031  *CREATE    Date 10Apr06               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CER049 - Stamp Tax (Recompile)                               *
      *  BUG12492 - SCC0411 00001 Failed                              *
      *  CSD031 - Enhanced Centralised Static Data.                   *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    XX         Function of Indicator                           *
      *    90         Check Account and Narrative Codes if existing   *                     BUG12492
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * SRZONE    - Zonal file update routine                         *
      * SRACCTKEY - Account key update routine                        *
      * SRTRAILER - Standing data control update file                 *
      * SRACCP    - Acceptance file update routine                    *
      * SRDELAY   - Delay job for 1 second                            *
      * *PSSR     - Error processing                                  *
      * *INZSR    - Initialise                                        *
      *  SrChkAcNr - Routine to check all accnt and narr code fields  *                     BUG12492
      *  SrValAcod - Validate Account Code fields                     *                     BUG12492
      *  SrValNarr - Validate Marrative Code fields                   *                     BUG12492
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
      ** Account Keys Logical File
     FACKEY     UF A E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
      *
      ** Account Keys Acceptance File
     FSDAAKYL0  UF A E           K DISK    INFSR(*PSSR)
     F                                     RENAME(ACKEYALF:ACKEYACF)
 
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
      *
      ** Midas SD Account Code Acceptance file
     D Ds_AcceptFile E DS                  ExtName(SDAAKYPD)
 
      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** External DS for Account Code Details                                               BUG12492
     D SDACOD        E DS                  EXTNAME(SDACODPD)                                BUG12492
                                                                                            BUG12492
      ** External DS for Narrative Code Details                                             BUG12492
     D SDNARR        E DS                  EXTNAME(SDNARRPD)                                BUG12492
                                                                                            BUG12492
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
     D KAcctKey        S             14A
     D KAcctKey1       S             14A
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
 
      ** Set Date Format Indicator *IN98  on if date format is MMDDYY
 
     C                   IF        BJDFIN = 'M'
     C                   EVAL      *IN98 = *ON
     C                   ENDIF
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
 
     C     KACCTK        KLIST
     C                   KFLD                    KAcctKey
      *
      ** Access Bank Details
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Datebase error
      *
     C     @RTCD         IFNE      *BLANKS
 
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'SDBANKPD'
     C                   EVAL      DBKEY  =  @OPTN
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   EVAL      DBASE  =  004
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
      *  Called by: (Main)                                            *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     SrZone        BEGSR
      *
      ** Check all account and narrative code fields                                        BUG12492
     C                   EXSR      SrChkAcNr                                                BUG12492
     C                   IF        *IN90 = *ON                                              BUG12492
     C                   EVAL      AACC = 'N'                                               BUG12492
     C                   EXSR      SrAccp                                                   BUG12492
     C                   LEAVESR                                                            BUG12492
     C                   ENDIF                                                              BUG12492
                                                                                            BUG12492
      ** Add/Update ACKEYAL - Account Key Physical File
      *
     C                   EXSR      SrAcctKey
      *
      ** Add/Update ACKEYAK - Account Key Header file
      *
     C                   EXSR      SrTrailer
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************                     BUG12492
      *                                                               *                     BUG12492
      *  SrChkAcNr - Check all Account and Narrative Code fields      *                     BUG12492
      *                                                               *                     BUG12492
      *  Called by: SrZone                                            *                     BUG12492
      *                                                               *                     BUG12492
      *  Calls: SrValAcod and SrValNarr                               *                     BUG12492
      *                                                               *                     BUG12492
      *****************************************************************                     BUG12492
                                                                                            BUG12492
     C     SrChkAcNr     BEGSR                                                              BUG12492
                                                                                            BUG12492
     C                   EVAL      *IN90 = *OFF                                             BUG12492
                                                                                            BUG12492
     C                   IF        ACD1 <> *ZERO                                            BUG12492
     C                   EVAL      AACOD = ACD1                                             BUG12492
     C                   EXSR      SrValAcod                                                BUG12492
     C   90              LEAVESR                                                            BUG12492
     C                   ENDIF                                                              BUG12492
                                                                                            BUG12492
     C                   IF        ACD2 <> *ZERO                                            BUG12492
     C                   EVAL      AACOD = ACD2                                             BUG12492
     C                   EXSR      SrValAcod                                                BUG12492
     C   90              LEAVESR                                                            BUG12492
     C                   ENDIF                                                              BUG12492
                                                                                            BUG12492
     C                   IF        ACD3 <> *ZERO                                            BUG12492
     C                   EVAL      AACOD = ACD3                                             BUG12492
     C                   EXSR      SrValAcod                                                BUG12492
     C   90              LEAVESR                                                            BUG12492
     C                   ENDIF                                                              BUG12492
                                                                                            BUG12492
     C                   IF        ACD4 <> *ZERO                                            BUG12492
     C                   EVAL      AACOD = ACD4                                             BUG12492
     C                   EXSR      SrValAcod                                                BUG12492
     C   90              LEAVESR                                                            BUG12492
     C                   ENDIF                                                              BUG12492
                                                                                            BUG12492
     C                   IF        ACD5 <> *ZERO                                            BUG12492
     C                   EVAL      AACOD = ACD5                                             BUG12492
     C                   EXSR      SrValAcod                                                BUG12492
     C   90              LEAVESR                                                            BUG12492
     C                   ENDIF                                                              BUG12492
                                                                                            BUG12492
     C                   IF        ACD6 <> *ZERO                                            BUG12492
     C                   EVAL      AACOD = ACD6                                             BUG12492
     C                   EXSR      SrValAcod                                                BUG12492
     C   90              LEAVESR                                                            BUG12492
     C                   ENDIF                                                              BUG12492
                                                                                            BUG12492
     C                   IF        NCD1 <> *BLANKS                                          BUG12492
     C                   EVAL      @NARR = NCD1                                             BUG12492
     C                   EXSR      SrValNarr                                                BUG12492
     C   90              LEAVESR                                                            BUG12492
     C                   ENDIF                                                              BUG12492
                                                                                            BUG12492
     C                   IF        NCD2 <> *BLANKS                                          BUG12492
     C                   EVAL      @NARR = NCD2                                             BUG12492
     C                   EXSR      SrValNarr                                                BUG12492
     C   90              LEAVESR                                                            BUG12492
     C                   ENDIF                                                              BUG12492
                                                                                            BUG12492
     C                   IF        NCD3 <> *BLANKS                                          BUG12492
     C                   EVAL      @NARR = NCD3                                             BUG12492
     C                   EXSR      SrValNarr                                                BUG12492
     C   90              LEAVESR                                                            BUG12492
     C                   ENDIF                                                              BUG12492
                                                                                            BUG12492
     C                   IF        NCD4 <> *BLANKS                                          BUG12492
     C                   EVAL      @NARR = NCD4                                             BUG12492
     C                   EXSR      SrValNarr                                                BUG12492
     C   90              LEAVESR                                                            BUG12492
     C                   ENDIF                                                              BUG12492
                                                                                            BUG12492
     C                   IF        NCD5 <> *BLANKS                                          BUG12492
     C                   EVAL      @NARR = NCD5                                             BUG12492
     C                   EXSR      SrValNarr                                                BUG12492
     C   90              LEAVESR                                                            BUG12492
     C                   ENDIF                                                              BUG12492
                                                                                            BUG12492
     C                   IF        NCD6 <> *BLANKS                                          BUG12492
     C                   EVAL      @NARR = NCD6                                             BUG12492
     C                   EXSR      SrValNarr                                                BUG12492
     C   90              LEAVESR                                                            BUG12492
     C                   ENDIF                                                              BUG12492
                                                                                            BUG12492
     C                   ENDSR                                                              BUG12492
      *****************************************************************                     BUG12492
      /EJECT                                                                                BUG12492
      *****************************************************************                     BUG12492
      *                                                               *                     BUG12492
      *  SrValAcod - Validate Account Code fields                     *                     BUG12492
      *                                                               *                     BUG12492
      *  Called by: SrChkAcNr                                         *                     BUG12492
      *                                                               *                     BUG12492
      *  Calls: None                                                  *                     BUG12492
      *                                                               *                     BUG12492
      *****************************************************************                     BUG12492
                                                                                            BUG12492
     C     SrValAcod     BEGSR                                                              BUG12492
                                                                                            BUG12492
     C                   CALL      'AOACODR0'                                               BUG12492
     C                   PARM      *BLANKS       @RTCD                                      BUG12492
     C                   PARM      '*KEY   '     @OPTN                                      BUG12492
     C                   PARM                    @ACOD            10                        BUG12492
     C     SDACOD        PARM      SDACOD        DSFDY                                      BUG12492
                                                                                            BUG12492
     C                   MOVE      @ACOD         AACOD            10 0                      BUG12492
                                                                                            BUG12492
     C                   IF        @RTCD <> *BLANKS                                         BUG12492
     C                   EVAL      *IN90 = *ON                                              BUG12492
     C                   ENDIF                                                              BUG12492
                                                                                            BUG12492
     C                   ENDSR                                                              BUG12492
      *****************************************************************                     BUG12492
      /EJECT                                                                                BUG12492
      *****************************************************************                     BUG12492
      *                                                               *                     BUG12492
      *  SrValNarr - Validate Narrative Code fields                   *                     BUG12492
      *                                                               *                     BUG12492
      *  Called by: SrChkAcNr                                         *                     BUG12492
      *                                                               *                     BUG12492
      *  Calls: None                                                  *                     BUG12492
      *                                                               *                     BUG12492
      *****************************************************************                     BUG12492
                                                                                            BUG12492
     C     SrValNarr     BEGSR                                                              BUG12492
                                                                                            BUG12492
     C                   CALL      'AONARRR0'                                               BUG12492
     C                   PARM      *BLANKS       @RTCD                                      BUG12492
     C                   PARM      '*KEY   '     @OPTN                                      BUG12492
     C                   PARM                    @NARR            10                        BUG12492
     C     SDNARR        PARM      SDNARR        DSFDY                                      BUG12492
                                                                                            BUG12492
     C                   IF        @RTCD <> *BLANKS                                         BUG12492
     C                   EVAL      *IN90 = *ON                                              BUG12492
     C                   ENDIF                                                              BUG12492
                                                                                            BUG12492
     C                   ENDSR                                                              BUG12492
      *****************************************************************                     BUG12492
      /EJECT                                                                                BUG12492
      *****************************************************************
      *                                                               *
      *  SrAcctKey - Account Key Update routine                       *
      *               Write/Update to Zonal Account Key File          *
      *                                                               *
      *  Called by: SrZone                                            *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     SrAcctKey     BEGSR
      *
     C                   EVAL      KAcctKey  = AKEY
     C                   EVAL      DFound    = 'Y'
     C                   EVAL      DSuccess  = 'N'
      *
     C                   DO        100
     C     KACCTK        CHAIN(e)  ACKEYALF
     C                   IF        %Error()
     C                   EXSR      SrDelay
     C                   ITER
     C                   ELSE
     C                   IF        %Found()
     C                   EVAL      Ds_AcceptFile = PDATA
     C                   EVAL      EACC = BJRDNB
     C                   EVAL      LCD  = BJRDNB
     C                   EVAL      CHTP = 'A'
     C                   UPDATE(e) ACKEYALF
     C                   IF        %Error()
     C                   EXSR      SrDelay
     C                   ITER
     C                   ENDIF
     C                   ELSE
     C                   EVAL      EACC = BJRDNB
     C                   EVAL      LCD  = BJRDNB
     C                   EVAL      CHTP = 'I'
     C                   WRITE(e)  ACKEYALF
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
     C                   EVAL      DBFILE =  'ACKEYAL'
     C                   EVAL      DBKEY  =  KAcctKey
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   EVAL      DBASE  =  001
     C                   EVAL      DBMOD  =  PSProcMod
     C                   EVAL      DBPROC =  'SR/SrAcctKey'
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
     C                   EVAL      KAcctKey1 = *blanks
     C                   EVAL      DSuccess  = 'N'
      *
     C                   DO        100
     C     *LOVAL        SETLL     ACKEYAKF
     C                   READ(e)   ACKEYAKF
     C                   IF        %Error()
     C                   EXSR      SrDelay
     C                   ITER
     C                   ENDIF
     C                   IF        %Found()
     C                   IF        DFound = 'Y'
     C                   EVAL      NAMD   = NAMD + 1
     C                   ELSE
     C                   EVAL      NINS   = NINS + 1
     C                   EVAL      NREC1  = NREC1 + 1
     C                   ENDIF
     C                   UPDATE(e) ACKEYAKF
     C                   IF        not %Error()
     C                   EVAL      DSuccess  = 'Y'
     C                   ENDIF
     C                   ENDIF
     C                   LEAVE
     C                   ENDDO
      *
     C                   IF        DSuccess = 'N'
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'ACKEYAK'
     C                   EVAL      DBKEY  =  KAcctKey1
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
      *  Called by: (Main)                                            *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     SrAccp        BEGSR
      *
     C                   EVAL      KAcctKey  = AKEY
      *
     C                   DO        100
     C     KACCTK        CHAIN(e)  SDAAKYL0
     C                   IF        %Error()
     C                   EXSR      SrDelay
     C                   ITER
     C                   ELSE
     C                   IF        %Found()
     C                   EVAL      Ds_AcceptFile = PDATA
     C                   UPDATE(e) ACKEYACF
     C                   ELSE
     C                   WRITE(e)  ACKEYACF
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
     C                   EVAL      DBFILE =  'SDAAKYL0'
     C                   EVAL      DBKEY  =  KAcctKey
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
