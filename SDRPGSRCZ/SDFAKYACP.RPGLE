     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2006')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD FO Account Keys Acceptance')                  *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  SDFAKYACP - SD FO Account Keys Acceptance                    *
      *                                                               *
      *  Function:  This program updates the zonal file and the       *
      *             acceptance file based on the data sent by the     *
      *             background job SDC000060 or SD000061              *
      *                                                               *
      *  Called By: SDC000060 - SD Central Data Acceptance BG Job     *
      *             SD000061 -  SD Central Data Acceptance on         *
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
      *                 CSD031  *CREATE    Date 10Apr06               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CSD031 - Enhanced Centralised Static data                    *
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
 
      ** Midas FF FO Account Keys
     FFACKY     UF A E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
 
      ** Midas FF FO Account Keys (Audit)
     FFACKYA    UF   E             DISK    INFSR(*PSSR)
     F                                     COMMIT
 
      ** Midas FF FO Account Keys Acceptance File
     FSDAFAKL0  UF A E           K DISK    INFSR(*PSSR)
     F                                     RENAME(FACKYDF:SDAFKDF)
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
 
      ** Midas SD Account Code Acceptance file
     D Ds_AcceptFile E DS                  ExtName(SDAFAKPD)
     D Ds_AcceptFileAE DS                  ExtName(SDAFAKPD)
     D                                     Prefix(A_)
 
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
 
      ** Entry Parameters
 
     D PDATA           S           4000A
     D PPROGRAM        S             10A
     D RetCodeOut      S              7A
 
      ** Parameter List
 
     D PCmd            S             13A   Inz('DLYJOB DLY(1)')
     D PCmd_Len        S             15  5
 
      ** Key Fields
 
     D KFAcctKey       S             14A
 
     D c_Yes           C                   Const('Y')
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
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
 
     C     *DTAARA       DEFINE                  RUNDAT
     C     *DTAARA       DEFINE                  LDA
     C                   IN        RUNDAT
 
      ** Set Date Format Indicator *IN98  on if date format is MMDDYY
 
     C                   IF        AGDFF = 'M'
     C                   EVAL      *IN98 = *ON
     C                   ENDIF
 
     C                   EVAL      Ds_AcceptFile = PDATA
 
     C                   IF        AACC     = c_Yes or
     C                             PPROGRAM = 'SDC000061'
     C                   EXSR      SrZone
     C                   ELSE
     C                   EXSR      SrAccp
     C                   ENDIF
 
      ** Commit changes if there are no errors, otherwise rollback
 
     C                   IF        RetCodeOut = *Blanks
     C                   COMMIT
     C                   ELSE
     C                   ROLBK
     C                   ENDIF
 
     C                   EVAL      *INLR = *ON
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
 
     C     KFACCT        KLIST
     C                   KFLD                    KFAcctKey
 
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
      *  SrZone - Zonal File update routine                           *
      *           Called automatically if a program error occurs,     *
      *           or directly by the program code using EXSR.         *
      *           This subroutine DUMPs the program just once.        *
      *                                                               *
      *  Called by: Main Routine                                      *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
 
     C     SrZone        BEGSR
 
      ** Add/Update FACKY - FF FO Account Key Physical File
 
     C                   EXSR      SrFAcctKey
 
      ** Add/Update FACKYA - FF FO Account Key Trailer file
 
     C                   IF        DFound <> *BLANK
     C                   EXSR      SrTrailer
     C                   ENDIF
 
     C                   ENDSR
 
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrFAcctKey - FF FO Account Key Update routine                *
      *               Write/Update to Zonal Account Key File          *
      *                                                               *
      *  Called by: SrZone                                            *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
 
     C     SrFAcctKey    BEGSR
 
     C                   EVAL      KFAcctKey = FFKY
     C                   EVAL      DFound    = 'Y'
     C                   EVAL      DSuccess  = 'N'
 
     C                   DO        100
     C     KFACCT        CHAIN(E)  FACKY
     C                   IF        %ERROR()
     C                   EXSR      SrDelay
     C                   ITER
     C                   ELSE
     C                   IF        %FOUND()
     C                   IF        CHTP = 'D'
     C                   EVAL      Ds_AcceptFile = PDATA
     C                   EVAL      DFound = 'N'
     C                   IF        CHTP = 'D'
     C                   EVAL      DFound = *BLANK
     C                   ENDIF
     C                   ELSE
     C                   EXSR      SrMovCntrlFlds
     C                   EVAL      CHTP = 'A'
     C                   ENDIF
     C                   UPDATE(E) FACKYDF
     C                   IF        %ERROR()
     C                   LEAVE
     C                   ENDIF
     C                   ELSE
     C                   EVAL      CHTP = 'I'
     C                   EVAL      LCD  = BJRDNB
     C                   EVAL      EACC = BJRDNB
     C                   WRITE(E)  FACKYDF
     C                   IF        %ERROR()
     C                   EXSR      SrDelay
     C                   ITER
     C                   ENDIF
     C                   EVAL      DFound = 'N'
     C                   ENDIF
     C                   EVAL      DSuccess  = 'Y'
     C                   LEAVE
     C                   ENDIF
     C                   ENDDO
 
     C                   IF        DSuccess = 'N'
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'FACKY'
     C                   EVAL      DBKEY  =  KFAcctKey
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   EVAL      DBASE  =  001
     C                   EVAL      DBMOD  =  PSProcMod
     C                   EVAL      DBPROC =  'SR/SrFAcctKey'
     C                   OUT       LDA
     C                   EVAL      RetCodeOut = '*ERROR'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
 
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrMovCntrlFlds - For Amendments, select only the central     *
      *                   fields for updates                          *
      *                                                               *
      *  Called by: SrFAcctKey                                        *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
 
     C     SrMovCntrlFldsBEGSR
 
     C                   EVAL      Ds_AcceptFileA = PDATA
 
      ** Narrative code
     C                   EVAL      NRC1   = A_NRC1
     C                   EVAL      NRC2   = A_NRC2
     C                   EVAL      NRC3   = A_NRC3
     C                   EVAL      NRC4   = A_NRC4
     C                   EVAL      NRC5   = A_NRC5
     C                   EVAL      NRC6   = A_NRC6
 
      ** Account code
     C                   EVAL      ACD1   = A_ACD1
     C                   EVAL      ACD2   = A_ACD2
     C                   EVAL      ACD3   = A_ACD3
     C                   EVAL      ACD4   = A_ACD4
     C                   EVAL      ACD5   = A_ACD5
     C                   EVAL      ACD6   = A_ACD6
 
      ** Effective date
     C                   EVAL      EACC   = BJRDNB
     C                   EVAL      LCD  = BJRDNB
 
     C                   ENDSR
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
 
     C     SrTrailer     BEGSR
 
     C                   EVAL      DSuccess  = 'N'
 
     C                   DO        100
     C     1             CHAIN(E)  FACKYA
     C                   IF        %ERROR()
     C                   EXSR      SrDelay
     C                   ITER
     C                   ENDIF
     C                   IF        %FOUND()
     C                   IF        DFound = 'Y'
     C                   EVAL      NAMD   = NAMD + 1
     C                   ELSE
     C                   EVAL      NORE   = NORE + 1
     C                   EVAL      NINS   = NINS + 1
     C                   ENDIF
     C                   UPDATE(E) FACKYAF
     C                   IF        not %ERROR()
     C                   EVAL      DSuccess  = 'Y'
     C                   ENDIF
     C                   ENDIF
     C                   LEAVE
     C                   ENDDO
 
     C                   IF        DSuccess = 'N'
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'FACYA'
     C                   EVAL      DBKEY  =  ' '
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   EVAL      DBASE  =  002
     C                   EVAL      DBMOD  =  PSProcMod
     C                   EVAL      DBPROC =  'SR/SrTrailer'
     C                   OUT       LDA
     C                   EVAL      RetCodeOut = '*ERROR'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
 
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrAccp - Acceptance file update routine                      *
      *           Called automatically if a program error occurs,     *
      *           or directly by the program code using EXSR.         *
      *           This subroutine DUMPs the program just once.        *
      *                                                               *
      *  Called by: Main Routine                                      *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
 
     C     SrAccp        BEGSR
 
     C                   EVAL      KFAcctKey  = FFKY
 
     C                   DO        100
     C     KFACCT        CHAIN(E)  SDAFAKL0
     C                   IF        %ERROR()
     C                   EXSR      SrDelay
     C                   ITER
     C                   ELSE
     C                   IF        %FOUND()
     C                   EVAL      Ds_AcceptFile = PDATA
rgc  C                   IF        RECI = '*'
rgc  C                   EVAL      RECI = *BLANKS
rgc  C                   ENDIF
     C                   UPDATE(E) SDAFKDF
     C                   ELSE
rgc  C                   IF        RECI = '*'
rgc  C                   EVAL      RECI = *BLANKS
rgc  C                   ENDIF
     C                   WRITE(E)  SDAFKDF
     C                   ENDIF
     C                   IF        %ERROR()
     C                   ITER
     C                   ELSE
     C                   LEAVE
     C                   ENDIF
     C                   ENDIF
     C                   ENDDO
 
     C                   IF        DSuccess = 'N'
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'SDAFAKL0'
     C                   EVAL      DBKEY  =  KFAcctKey
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   EVAL      DBASE  =  003
     C                   EVAL      DBMOD  =  PSProcMod
     C                   EVAL      DBPROC =  'SR/SrAccp'
     C                   OUT       LDA
     C                   EVAL      RetCodeOut = '*ERROR'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
 
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
 
     C     SrDelay       BEGSR
 
     C                   EVAL      PCmd_Len = %LEN(PCmd)
     C                   CALL      'QCMDEXC'
     C                   PARM                    PCmd
     C                   PARM                    PCmd_Len
 
     C                   ENDSR
 
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
 
     C     *PSSR         BEGSR
 
     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'
     C                   DUMP
 
     C                   CALL      'DBERRCTL'
 
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
 
