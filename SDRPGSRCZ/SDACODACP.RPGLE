     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2006')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Account Code Acceptance')                     *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  SDACODACP - SD Account Code Acceptance                       *
      *                                                               *
      *  Function:  This program updates the zonal file and the       *
      *             acceptance file based on the data sent by the     *
      *             background job SDC000060.                         *
      *                                                               *
      *  Called By: SDC000060 - SD Central Data Acceptance BG Job     *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2006            *
      *                                                               *
      *  Last Amend No. CLE134             Date 01Aug12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. BUG12645           Date 16Nov06               *
      *                 BUG12523           Date 11Nov06               *
      *                 BUG12416           Date 08Nov06               *
      *                 BUG11881           Date 14Aug06               *
      *                 CSD031  *CREATE    Date 10Apr06               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  BUG12645 - COB component SDC0602 failed because of unmatched *
      *             trailer file                                      *
      *  BUG12523 - Fields amendable at the zonal layer should be     *
      *             set for writes.                                   *
      *  BUG12416 - Restrict movement of details from global file     *
      *             to zonal file. The following information should   *
      *             not be moved :                                    *
      *             A5SRLC - Stat Returns BS L/C                      *
      *             A5SRFC - Stat Returns BS F/C                      *
      *             A5RPCD - Reporting code                           *
      *             A5MISU - Min Int subj to Tax                      *
      *             A5INNR - PM Instrument code                       *
      *  BUG11881 - Job error upon amendment in zonal listview        *
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
      *
      ** SD Account Code Update Logical File
     FSDACODL0  UF A E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
      *
      ** SD Account Code Acceptance Update Logical File
     FSDAACDL0  UF A E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
      *
      ** SD Standing Data Controls Logical File
     FSDFCTLL0  UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
      *
      ** Accounts by Report Logical File
     FSDACRCL0  UF A E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
      *
     FSDACX2L0  UF A E           K DISK    INFSR(*PSSR)                                     BUG11881
     F                                     COMMIT                                           BUG11881
      ** Extended Accout Code Details                                                       BUG11881
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     D LDA           E DS           256    EXTNAME(LDA)
      *
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
      *
      ** Midas SD Account Code Acceptance file
     D Ds_AcceptFile E DS                  ExtName(SDAACDPD)
      *
      ** Customer Details File - Zoned Numeric Definition
     D Input_Acct    E DS                  ExtName(SDZACODPD)
      *
      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** First DS for access programs, short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
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
     D PZreturn        S              1
     D PZfield         S             16
     D PZdecimals      S              1P 0
     D PZdigits        S              2P 0
      *
      ** Key Fields
      *
     D KAcctCode       S             10A
     D KFile           S             10A
     D KRSNO           S              1A
     D KRSCD           S             10A
     D KACCD           S             10A
     D KDRCR           S              1A
      *
     D c_Yes           C                   Const('Y')
      *                                                                                     BUG11881
     D W_Attempt       S              3  0                                                  BUG11881
     D K_AcodNum       S             10  0                                                  BUG11881
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
      *
      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************
 
     C     *DTAARA       DEFINE                  LDA
      *
     C                   EVAL      Input_Acct    = PDATA
      *
     C                   IF        ACAACC = c_Yes or
     C                             PPROGRAM = 'SDC000061'
     C                   EXSR      SrZone
     C                   ELSE
     C                   EXSR      SrAccp
     C                   ENDIF
                                                                                            BUG11881
     C                   EXSR      SrExtn                                                   BUG11881
                                                                                            BUG11881
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
      *  *INZSR - Program Initialisation routine                      *
      *                                                               *
      *  Called by: Implicitly on program activation                  *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *entry        PLIST
     C                   PARM                    PDATA
     C                   PARM                    RetCodeOut
     C                   PARM                    PPROGRAM
 
     C     KACCDK        KLIST
     C                   KFLD                    KAcctCode
 
     C     KACRC         KLIST
     C                   KFLD                    KRSNO
     C                   KFLD                    KRSCD
     C                   KFLD                    KACCD
     C                   KFLD                    KDRCR
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
     C                   EVAL      DBASE  =  006
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
      *           Called automatically if a program error occurs,     *
      *           or directly by the program code using EXSR.         *
      *           This subroutine DUMPs the program just once.        *
      *                                                               *
      *  Called by: (**calling routines**)                            *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     SrZone        BEGSR
      *
      ** Add/Update SDACODPD - Account Code file
      *
     C                   EXSR      SrAcctCode
      *
      ** Add/Update SDFCTLPA - Standing Data Controls file
      *
     C                   EXSR      SrTrailer
      *
      ** Add SDACRCPD - Accounts by Report file
      *
     C                   IF        DFound = 'N'
     C                   EXSR      SrAcctRpt
     C                   IF        DSuccess = 'Y'                                           BUG12645
     C                   EXSR      SrTrailer                                                BUG12645
     C                   ENDIF                                                              BUG12645
     C                   ENDIF
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrAcctCode - Account Code Update routine                     *
      *               Write/Update to Zonal Account Code File         *
      *                                                               *
      *  Called by: SrZone                                            *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     SrAcctCode    BEGSR
      *
     C                   EVAL      KAcctCode = ACGACD
     C                   EVAL      DFound    = 'Y'
     C                   EVAL      DSuccess  = 'N'
      *
     C                   DO        100
     C     KACCDK        CHAIN(e)  SDACODL0
     C                   IF        %Error()
     C                   EXSR      SrDelay
     C                   ITER
     C                   ELSE
     C                   IF        %Found()
     C                   EVAL      Input_Acct = PDATA
     C                   EXSR      SrConv
      *
     C                   EVAL      A5EACC = BJRDNB
     C                   EVAL      A5LCD  = BJRDNB
     C                   EVAL      A5TYLC = 'A'
     C                   UPDATE(e) @A5UPA7
     C                   IF        %Error()
     C                   LEAVE
     C                   ENDIF
     C                   ELSE
     C                   EXSR      SrConv
     C                   EXSR      SrUpdLoc                                                 BUG12523
     C                   EVAL      A5LCD  = BJRDNB
     C                   EVAL      A5EACC = BJRDNB
     C                   EVAL      A5TYLC = 'I'
     C                   WRITE(e)  @A5UPA7
     C                   IF        %Error()
     C                   EXSR      SrDelay
     C                   ITER
     C                   ENDIF
     C                   EVAL      DFound = 'N'
     C                   ENDIF
     C                   EVAL      DSuccess  = 'Y'
     C                   EVAL      KFile  = 'SDACODPD'                                      BUG12645
     C                   LEAVE
     C                   ENDIF
     C                   ENDDO
      *
     C                   IF        DSuccess = 'N'
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'SDACODL0'
     C                   EVAL      DBKEY  =  KAcctCode
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   EVAL      DBASE  =  001
     C                   EVAL      DBMOD  =  PSProcMod
     C                   EVAL      DBPROC =  'SR/SrAcctCode'
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
     C**********         EVAL      KFile  = 'SDACODPD'                                      BUG12645
     C                   EVAL      DSuccess  = 'N'
      *
     C                   DO        100
     C     KFile         CHAIN(e)  SDFCTLL0
     C                   IF        %Error()
     C                   EXSR      SrDelay
     C                   ITER
     C                   ELSE
     C                   IF        %Found()
     C                   IF        DFound = 'Y'
     C                   EVAL      AHNOAM = AHNOAM + 1
     C                   ELSE
     C                   EVAL      AHNORC = AHNORC + 1
     C                   EVAL      AHNOIN = AHNOIN + 1
     C                   ENDIF
     C                   UPDATE(e) @AHREAU
     C                   IF        not %Error()
     C                   EVAL      DSuccess  = 'Y'
     C                   ENDIF
     C                   ENDIF
     C                   LEAVE
     C                   ENDIF
     C                   ENDDO
      *
     C                   IF        DSuccess = 'N'
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'SDFCTLL0'
     C                   EVAL      DBKEY  =  KFile
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
      *  SrAcctRpt - Account by Report update file                    *
      *                                                               *
      *  Called by: SrZone                                            *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     SrAcctRpt     BEGSR
      *
     C                   EVAL      KRSNO    = '*'
     C                   EVAL      KRSCD    = '****'
     C                   EVAL      KACCD    = KAcctCode
     C                   EVAL      KDRCR    = *blanks
     C                   EVAL      DSuccess = 'N'
      *
     C                   DO        100
     C     KACRC         CHAIN(e)  SDACRCL0
     C                   IF        %Error()
     C                   EXSR      SrDelay
     C                   ITER
     C                   ENDIF
     C                   IF        %Found()
     C                   LEAVE
     C                   ELSE
     C                   EVAL      G6RSNO = '*'
     C                   EVAL      G6RSCD = '****'
     C                   EVAL      G6ACCD = KAcctCode
     C                   EVAL      G6DRCR = *blanks
     C                   EVAL      G6LCD  = A5LCD
     C                   EVAL      G6TYLC = A5TYLC
     C                   WRITE(e)  @AGREAQ
     C                   IF        %Error()
     C                   ITER
     C                   ENDIF
     C                   EVAL      DSuccess  = 'Y'
     C                   EVAL      KFile  = 'SDACRCPD'                                      BUG12645
     C                   LEAVE
     C                   ENDIF
     C                   ENDDO
      *
     C                   IF        DSuccess = 'N'
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'SDACRCL0'
     C                   EVAL      DBKEY  =  KAcctCode
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   EVAL      DBASE  =  003
     C                   EVAL      DBMOD  =  PSProcMod
     C                   EVAL      DBPROC =  'SR/SrAcctRpt'
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
      *           Called automatically if a program error occurs,     *
      *           or directly by the program code using EXSR.         *
      *           This subroutine DUMPs the program just once.        *
      *                                                               *
      *  Called by: (**calling routines**)                            *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     SrAccp        BEGSR
      *
     C                   EVAL      KAcctCode = ACGACD
      *
     C                   DO        100
     C     KACCDK        CHAIN(e)  SDAACDL0
     C                   IF        %Error()
     C                   EXSR      SrDelay
     C                   ITER
     C                   ELSE
     C                   IF        %Found()
     C**********         EVAL      Ds_AcceptFile = PDATA                                    BUG12523
     C                   EXSR      SrConv
     C                   EXSR      SrUpdLoc                                                 BUG12523
     C                   UPDATE(e) SDACODD0
     C                   ELSE
     C                   EXSR      SrConv
     C                   EXSR      SrUpdLoc                                                 BUG12523
     C                   WRITE(e)  SDACODD0
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
     C                   EVAL      DBFILE =  'SDAACDL0'
     C                   EVAL      DBKEY  =  KAcctCode
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   EVAL      DBASE  =  001
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
      *  SrConv - Convert Input data to Correct Format                *
      *           Called automatically if a program error occurs,     *
      *           or directly by the program code using EXSR.         *
      *                                                               *
      *  Called by: (**calling routines**)                            *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     SrConv        BEGSR
     C                   EVAL      A5TYLC   =   ACCHTP
     C                   EVAL      A5ACTY   =   ACACTY
     C                   EVAL      A5TOIN   =   ACTOIN
     C                   EVAL      A5ACSC   =   ACACSC
     C                   EVAL      A5ACST   =   ACACST
     C                   EVAL      A5TRFD   =   ACTRFD
     C                   EVAL      A5ACGC   =   ACACGC
     C                   EVAL      A5MAPC   =   ACMAPC
     C                   EVAL      A5MABK   =   ACMABK
     C                   EVAL      A5MAAC   =   ACMAAC
     C                   EVAL      A5MATR   =   ACMATR
     C                   EVAL      A5MAPR   =   ACMAPR
     C                   EVAL      A5FNAC   =   ACFNAC
     C                   EVAL      A5FNBR   =   ACFNBR
     C                   EVAL      A5CAAC   =   ACCAAC
     C                   EVAL      A5TIAT   =   ACTIAT
     C                   EVAL      A5TFCT   =   ACTFCT
     C                   EVAL      A5VOST   =   ACVOST
     C                   EVAL      A5LORO   =   ACLORO
     C                   EVAL      A5NARR   =  ACDESC
     C                   EVAL      A5ZONE   =  ACZONE
     C                   EVAL      A5ACCD   =  ACGACD
     C                   EVAL      A5CIAD   =  ACCIAD
     C                   EVAL      A5CIAC   =  ACCIAC
     C                   EVAL      A5DIAC   =  ACDIAC
     C                   EVAL      A5DIAD   =  ACDIAD
     C                   EVAL      A5ICIC   =  ACICIC
     C                   EVAL      A5ICID   =  ACICID
     C                   EVAL      A5DIPD   =  ACDIPD
     C                   EVAL      A5DIPC   =  ACDIPC
     C                   EVAL      A5CIPC   =  ACCIPC
     C                   EVAL      A5CISU   =  ACCISU
     C                   EVAL      A5CINS   =  ACCINS
     C                   EVAL      A5WTAC   =  ACWTAC
     C                   EVAL      A5FNIC   =  ACFNIC
     C                   EVAL      A5FNAA   =  ACFNAA
     C                   EVAL      A5TRAN   =  ACTRAN
     C                   EVAL      A5IUSR   =  ACIUSR
     C                   EVAL      A5AUSR   =  ACCUSR
     C                   EVAL      A5XUSR   =  ACXUSR
     C                   EVAL      A5AACC   =  ACAACC
     C                   EVAL      A5ACCN   =  ACACCN
     C**********         MOVE      ACSRLC1       A5SRLC                                     BUG12416
     C**********         MOVE      ACSRFC1       A5SRFC                                     BUG12416
     C**********         MOVE      ACRPCD1       A5RPCD                                     BUG12416
     C**********         MOVE      ACMISU1       A5MISU                                     BUG12416
     C**********         MOVE      ACINNR        A5INNR                                     BUG12416
     C                   MOVE      ACLCD1        A5LCD
     C                   MOVE      ACACPR1       A5ACPR
     C                   MOVE      ACTRDA1       A5TRDA
     C                   MOVE      ACTRCA1       A5TRCA
     C                   MOVE      ACEACC1       A5EACC
     C                   MOVE      ACGPDT        A5GPDT
 
     C                   ENDSR
      *                                                                                     BUG12523
      /EJECT                                                                                BUG12523
      *****************************************************************                     BUG12523
      *                                                               *                     BUG12523
      *  SrUpdLoc - Updates Local Fields                              *                     BUG12523
      *                                                               *                     BUG12523
      *****************************************************************                     BUG12523
                                                                                            BUG12523
     C     SrUpdLoc      BEGSR                                                              BUG12523
                                                                                            BUG12523
     C                   MOVE      ACSRLC1       A5SRLC                                     BUG12523
     C                   MOVE      ACSRFC1       A5SRFC                                     BUG12523
     C                   MOVE      ACRPCD1       A5RPCD                                     BUG12523
     C                   MOVE      ACMISU1       A5MISU                                     BUG12523
     C                   MOVE      ACINNR        A5INNR                                     BUG12523
                                                                                            BUG12523
     C                   ENDSR                                                              BUG12523
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrAlign - Align Numeric Data                                 *
      *                                                               *
      *****************************************************************
 
     C     SrAlign       BEGSR
 
     C                   CALLB     'ZALIGN'
     C                   PARM                    PZreturn
     C                   PARM                    PZfield
     C                   PARM                    PZdecimals
     C                   PARM                    PZdigits
 
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
      *****************************************************************                     BUG11881
      /EJECT                                                                                BUG11881
      *****************************************************************                     BUG11881
      *                                                               *                     BUG11881
      * SeExtn - Extension File Update Routine                        *                     BUG11881
      *                                                               *                     BUG11881
      *****************************************************************                     BUG11881
                                                                                            BUG11881
     C     SrExtn        BEGSR                                                              BUG11881
                                                                                            BUG11881
      ** Check if record exists                                                             BUG11881
                                                                                            BUG11881
     C                   EVAL      W_Attempt = 0                                            BUG11881
     C                   MOVE      KAcctCode     K_AcodNum                                  BUG11881
                                                                                            BUG11881
     C                   DOW       W_Attempt < 100                                          BUG11881
     C     K_AcodNum     CHAIN(E)  SDACX2L0                                                 BUG11881
                                                                                            BUG11881
      ** If record is locked to another job, wait 1 second and try again                    BUG11881
                                                                                            BUG11881
     C                   IF        %ERROR                                                   BUG11881
     C                   EXSR      SrDelay                                                  BUG11881
     C                   EVAL      W_Attempt = W_Attempt + 1                                BUG11881
     C                   ELSE                                                               BUG11881
     C                   LEAVE                                                              BUG11881
     C                   ENDIF                                                              BUG11881
                                                                                            BUG11881
     C                   ENDDO                                                              BUG11881
                                                                                            BUG11881
     C                   IF        %ERROR                                                   BUG11881
                                                                                            BUG11881
      ** Database update error                                                              BUG11881
                                                                                            BUG11881
     C     *LOCK         IN        LDA                                                      BUG11881
     C                   EVAL      DBFILE =  'SDACX2L0'                                     BUG11881
     C                   EVAL      DBKEY  =  KAcctCode                                      BUG11881
     C                   EVAL      DBPGM  =  PSProcPgm                                      BUG11881
     C                   EVAL      DBASE  =  004                                            BUG11881
     C                   EVAL      DBMOD  =  PSProcMod                                      BUG11881
     C                   EVAL      DBPROC =  'SR/SREXTN '                                   BUG11881
     C                   OUT       LDA                                                      BUG11881
     C                   EXSR      *PSSR                                                    BUG11881
     C                   ENDIF                                                              BUG11881
                                                                                            BUG11881
     C                   IF        %FOUND(SDACX2L0)                                         BUG11881
                                                                                            BUG11881
     C                   EVAL      QQACOD = 0                                               BUG11881
     C                   EVAL      SDIM93 = 0                                               BUG11881
     C                   EVAL      SDSHAT = 0                                               BUG11881
                                                                                            BUG11881
     C                   UPDATE    SDACODF6                                                 BUG11881
                                                                                            BUG11881
     C                   ELSE                                                               BUG11881
                                                                                            BUG11881
     C                   EVAL      QQACOD = 0                                               BUG11881
     C                   EVAL      SDIM93 = 0                                               BUG11881
     C                   EVAL      SDSHAT = 0                                               BUG11881
     C                   EVAL      SDACOD = K_AcodNum                                       BUG11881
                                                                                            BUG11881
     C                   WRITE     SDACODF6                                                 BUG11881
                                                                                            BUG11881
     C                   ENDIF                                                              BUG11881
                                                                                            BUG11881
     C                   ENDSR                                                              BUG11881
      *
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
