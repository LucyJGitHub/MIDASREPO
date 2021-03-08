     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2005')
      *****************************************************************
/**** *  RPGBASEBND                                                   *                     MD055681
/*STD *  RPGSQLBND                                                    *                     MD055681
/*EXI *  TEXT('Midas SC Open Month End System Setup')                 *
/*XBI *****************************************************************
/*XBI *                                                               *
      *  Midas - System Control Module                                *
      *                                                               *
      *  SC000103 - Open Month End System Setup                       *
      *                                                               *
      *  (c) Finastra International Limited 2005                      *
      *                                                               *
      *  Last Amend No. MD055681           Date 31Jul20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 AR690003           Date 07Jan11               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG8604            Date 19Sep05               *
/*    *                 BUG8501            Date 14Sep05               *
      *                 BUG8417            Date 09Sep05               *
      *                 BUG8384            Date 05Sep05               *
      *                 BUG8387            Date 03Sep05               *
      *                 BUG8328            Date 30Aug05               *
      *                 CSC024  *CREATE    Date 07Feb05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD055681 - Deliverable Data Split for SAR                    *
      *  MD046248 - Finastra Rebranding                               *
      *  AR690003 - SC000103 continued even if there is no Source     *
      *             system prefix (Child: AR690007)                   *
      *  BUG8604 - Change system title in TABTE10.                    *
      *  BUG8501 - Maintain OME SFACAUPD, do not replicate it from    *
      *            LIVE system.                                       *
      *  BUG8417- Auto setting up of CSC024 switachable feature       *
      *  BUG8384- Authorization limits at OME system should be off    *
      *  BUG8387- OME System Set-up Error                             *
      *  BUG8328- OME Global Data Replication from Live to OME        *
      *  CSC024 - Open Month End                                      *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of Indicators.                                           *
      *                                                               *
      *  03 - F3 is pressed                                           *
      *  05 - F5 is pressed                                           *
      *  25 - SFL END                                                 *
      *  26 - Error in Resttore from tape                             *
      *  27 - Display Device                                          *
      *  28 - not OME system                                          *
      *  29 - confirmation page                                       *
      *  30 - Error in Device field                                   *
      *  31 - Error page                                              *
      *  32 - Error in DBIC seq no                                    *                      BUG8328
      *  33 - Error in DBICDTA seq no                                 *                      BUG8328
      *  34 - Error in DBICG seq no                                   *                      BUG8328
      *  35 - Error in DBICGta seq no                                 *                      BUG8328
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SrReset - Clears Input Screen                                *
      *  SrClearMsg - Clear Program Message File                      *
      *  SrSndMsg - Send Error Message                                *
      *  SrOMESetUp - Start OME set-up                                *
      *  SrSDBank - Access and update Bank ICD details                *
      *  SrTABTB10 - Update system title                              *                      BUG8604
      *  SrUpdReplay - Update OME subscriber status file              *
      *  SrResetFile - Reset files that allocates transaction numbers *
      *  SrAuthLimit - Disable authorization limits                   *                      BUG8384
      *  SrOMESwitch - Setting up of OME switchable feature           *                      BUG8417
      *  SrAcntAuth - Maintain Account code authorities               *                      BUG8501
      *  SrGlobal - Synchronize global file with zonal file           *
      *  SrValidate - Validation process                              *
      *  SRZAlign   - Validate numeric fields                         *
      *  SrInit - Initialise fields                                   *
      *  *INZSR - Initialisation                                      *
      *  *PSSR  - Program exception error routine                     *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

      ** Next Available Deal Number
     FCANDLNLL  UF   E             DISK    INFSR(*PSSR)
     F                                     USROPN

      ** FD Deal number records
     FFDDLNMLL  UF   E             DISK    INFSR(*PSSR)
     F                                     USROPN

      ** Transaction Ranges
     FZATNRGL0  UF   E           K DISK    INFSR(*PSSR)
     F                                     USROPN

      ** Global Files
     FGPGLOBFL1 IF   E           K DISK    INFSR(*PSSR)
     F                                     USROPN                                            BUG8387
                                                                                             BUG8417
      ** Midas SC Enabled/disabled switchable features file                                  BUG8417
     F*SCSAREL0*UF A E           K DISK    INFSR(*PSSR)                             BUG8417 MD055681
     F**********                           USROPN                                   BUG8417 MD055681
                                                                                             BUG8501
      ** Midas SF Account code/authorities file by a/c code                                  BUG8501
     FSFACAUL0  UF A E           K DISK    INFSR(*PSSR)                                      BUG8501
     F                                     USROPN                                            BUG8501
                                                                                             BUG8501
      ** Midas SD Account codes - retrieval index                                            BUG8501
     FSDACODL1  IF   E           K DISK    INFSR(*PSSR)                                      BUG8501
     F                                     USROPN                                            BUG8501
                                                                                             BUG8604
      ** Midas SD Installation Control Record one                                            BUG8604
     FTABTB10   UF   E           K DISK    INFSR(*PSSR)                                      BUG8604
     F                                     USROPN                                            BUG8604

      ** Midas SC OME system Setup display
     FSC000103DFCF   E             WORKSTN INFSR(*PSSR)

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------

      *****************************************************************
      /EJECT
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

      ** System Values Array
     D*SysValArr       S             20    DIM(5) CTDATA PERRCD(1)                           BUG8328
     D SysValArr       S             20    DIM(7) CTDATA PERRCD(1)                           BUG8328

      ** Layout for the RUNDAT data area
     D RUNDAT        E DS                  EXTNAME(RUNDAT) DTAARA(RUNDAT)

      ** First DS for access programs, short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)

      ** External DS for bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

     D PRetCode        S              7A
     D POption         S              7A
     D P@OP01          S             20A
     D P@VL01          S            200A
     D P@OP02          S             20A
     D P@VL02          S            200A
     D P@OP03          S             20A
     D P@VL03          S            200A
     D P@OP04          S             20A
     D P@VL04          S            200A
     D P@OP05          S             20A
     D P@VL05          S            200A
     D P@OP06          S             20A
     D P@VL06          S            200A
     D P@OP07          S             20A
     D P@VL07          S            200A
     D P@OP08          S             20A
     D P@VL08          S            200A
     D P@OP09          S             20A
     D P@VL09          S            200A
     D P@OP10          S             20A
     D P@VL10          S            200A

     D*PMsgFile*       S             10A   INZ('SDUSRMSG')                                   BUG8328
     D PMsgFile        S             10A   INZ('GBSDUSRMSG')                                 BUG8328
     D PMsgId          S             10A
     D PZoneName       S             10A

      ** Parameters for ZALIGN                                                               BUG8328
     D PZRetCode       S              7A                                                     BUG8328
     D PZField         S             16A                                                     BUG8328
     D PZADEC          S              1P 0                                                   BUG8328
     D PZADIG          S              2P 0                                                   BUG8328
     D PZOutField      S             16A                                                     BUG8328
                                                                                             BUG8328
     D WrkNum10        S             10  0                                                   BUG8328
     D WErrFlag        S              1A   INZ('N')
     D WRun            S              1A
     D WConfirm        S              1A
     D WSetupOk        S              1A

     D WDRstp          S                   LIKE(DRSTP)
     D WDDev           S                   LIKE(DDEV)
     D WDbicSq         S                   LIKE(DBICSQ)                                      BUG8328
     D WDbicDtSq       S                   LIKE(DBICDTSQ)                                    BUG8328
     D WDbicGSq        S                   LIKE(DBICGSQ)                                     BUG8328
     D WDbicGtSq       S                   LIKE(DBICGTSQ)                                    BUG8328
                                                                                             BUG8501
     D WKeyACOD        S                   LIKE(A5ACCD)                                      BUG8501
     D SCSARD        E DS                  EXTNAME(SCSRDJW0)                                MD055681
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+

      *****************************************************************
      /EJECT
      *****************************************************************

     C                   EXSR      SrInit

      ** If not an OME system,exit the program

     C                   IF        P@VL03 = 'N'
     C                   EVAL      *IN28 = *ON
     C                   TIME                    #0TIME
     C                   WRITE     SC000103C0
     C                   WRITE     SC000103F4
     C                   WRITE     SC000103F0
     C                   EXFMT     SC000103F2
     C                   ENDIF

      ** Procees for OME system

     C                   DOW       *IN03 <> *ON AND
     C                             P@VL03 = 'Y' AND
     C                             WSetupOk = 'N'

      ** F5 for Refresh

     C                   IF        *IN05 = *ON
     C                   EXSR      SrReset
     C                   ENDIF

      ** Write Message Control, Header and Footer

     C                   TIME                    #0TIME
     C                   WRITE     SC000103C0
     C                   WRITE     SC000103F4
     C                   WRITE     SC000103F0

      ** Execute format Detail Screen

     C                   EXFMT     SC000103F1

      ** Clear Program Message File

     C                   EXSR      SrClearMsg

      ** Not refresh or exit command, process input

     C                   IF        *IN03 <> *ON AND
     C                             *IN05 <> *ON

      ** Validate input fields

     C                   EVAL      WErrFlag = 'N'
     C                   EXSR      SrValidate

      ** If no error, continue processing


     C                   SELECT
     C                   WHEN      WErrFlag = 'Y'
     C                   EVAL      WConfirm = 'N'
     C                   EVAL      *IN29 = *OFF

     C                   WHEN      DRSTP = 'Y' AND
     C                             WDRsTp <> DRSTP
     C                   EVAL      *IN27 = *ON
     C                   EVAL      *IN29 = *OFF
     C                   EVAL      WDRsTp = DRSTP
     C                   EVAL      DDEV  = *BLANKS
     C                   EVAL      DBICSQ = *BLANKS                                          BUG8328
     C                   EVAL      DBICDTSQ = *BLANKS                                        BUG8328
     C                   EVAL      DBICGSQ = *BLANKS                                         BUG8328
     C                   EVAL      DBICGTSQ = *BLANKS                                        BUG8328
     C                   EVAL      WConfirm = 'N'

     C                   WHEN      DRSTP <> 'Y' AND
     C                             *IN27 = *ON
     C                   EVAL      *IN27 = *OFF
     C                   EVAL      *IN29 = *OFF
     C                   EVAL      WDRsTp = DRSTP
     C                   EVAL      DDEV  = *BLANKS
     C                   EVAL      DBICSQ = *BLANKS                                          BUG8328
     C                   EVAL      DBICDTSQ = *BLANKS                                        BUG8328
     C                   EVAL      DBICGSQ = *BLANKS                                         BUG8328
     C                   EVAL      DBICGTSQ = *BLANKS                                        BUG8328
     C                   EVAL      WConfirm = 'N'

     C                   WHEN      WDRsTp <> DRSTP
     C                   EVAL      *IN29 = *OFF
     C                   EVAL      WDRsTp = DRSTP
     C                   EVAL      DDEV  = *BLANKS
     C                   EVAL      DBICSQ = *BLANKS                                          BUG8328
     C                   EVAL      DBICDTSQ = *BLANKS                                        BUG8328
     C                   EVAL      DBICGSQ = *BLANKS                                         BUG8328
     C                   EVAL      DBICGTSQ = *BLANKS                                        BUG8328
     C                   EVAL      WDDev = DDEV
     C                   EVAL      WDbicSq = DBICSQ                                          BUG8328
     C                   EVAL      WDbicDtSq = DBICDTSQ                                      BUG8328
     C                   EVAL      WDbicGSq = DBICGSQ                                        BUG8328
     C                   EVAL      WDbicGtSq = DBICGTSQ                                      BUG8328
     C                   EVAL      WConfirm = 'N'


      ** If confirmed, no amendments of fields, start OME system set-up

     C                   WHEN      WDRsTp = DRSTP AND
     C                             WDDev  = DDEV AND
     C                             WDbicSq = DBICSQ AND                                      BUG8328
     C                             WDbicDtSq = DBICDTSQ AND                                  BUG8328
     C                             WDbicGSq = DBICGSQ AND                                    BUG8328
     C                             WDbicGtSq = DBICGTSQ AND                                  BUG8328
     C                             WConfirm = 'Y'
     C                   EXSR      SrOMESetUp

      ** Display comfirmation page

     C                   WHEN      WDRsTp = DRSTP
     C                   EVAL      WDDev = DDEV
     C                   EVAL      WDbicSq = DBICSQ                                          BUG8328
     C                   EVAL      WDbicDtSq = DBICDTSQ                                      BUG8328
     C                   EVAL      WDbicGSq = DBICGSQ                                        BUG8328
     C                   EVAL      WDbicGtSq = DBICGTSQ                                      BUG8328
     C                   EVAL      WConfirm = 'Y'
     C                   EVAL      *IN29 = *ON

     C                   ENDSL
     C                   ENDIF
     C                   ENDDO

      ** If OME set-up is successful

     C                   IF        WSetupok = 'Y'
     C                   EVAL      *IN28 = *ON
     C                   EVAL      *IN29 = *OFF
     C                   TIME                    #0TIME
     C                   WRITE     SC000103C0
     C                   WRITE     SC000103F4
     C                   WRITE     SC000103F0
     C                   EXFMT     SC000103F3
     C                   ENDIF

      ** End of Program

     C                   EVAL      *INLR = *ON
     C                   RETURN

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrReset - Clears Input Screen                                *
      *                                                               *
      *****************************************************************
     C     SrReset       BEGSR

      ** Clear Error Indicators

     C                   EVAL      *IN03 = *OFF
     C                   EVAL      *IN05 = *OFF
     C                   EVAL      *IN25 = *OFF
     C                   EVAL      *IN26 = *OFF
     C                   EVAL      *IN27 = *OFF
     C                   EVAL      *IN28 = *OFF
     C                   EVAL      *IN29 = *OFF
     C                   EVAL      *IN30 = *OFF
     C                   EVAL      *IN31 = *OFF
     C                   EVAL      *IN32 = *OFF                                              BUG8328
     C                   EVAL      *IN33 = *OFF                                              BUG8328
     C                   EVAL      *IN34 = *OFF                                              BUG8328
     C                   EVAL      *IN35 = *OFF                                              BUG8328

      ** Reset Input Fields

     C                   EVAL      DRSTP = 'N'
     C                   EVAL      DDEV = *BLANKS
     C                   EVAL      DBICSQ = *BLANKS                                          BUG8328
     C                   EVAL      DBICDTSQ = *BLANKS                                        BUG8328
     C                   EVAL      DBICGSQ = *BLANKS                                         BUG8328
     C                   EVAL      DBICGTSQ = *BLANKS                                        BUG8328
     C                   EVAL      WDRsTp = DRSTP
     C                   EVAL      WDDev = DDEV
     C                   EVAL      WDbicSq = DBICSQ                                          BUG8328
     C                   EVAL      WDbicDtSq = DBICDTSQ                                      BUG8328
     C                   EVAL      WDbicGSq = DBICGSQ                                        BUG8328
     C                   EVAL      WDbicGtSq = DBICGTSQ                                      BUG8328
     C                   EVAL      WConfirm = 'N'
     C                   EVAL      WSetupOk = 'N'

      ** Clear Program Messages

     C                   EXSR      SrClearMsg

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrClearMsg - Clear Program Message File                      *
      *                                                               *
      *****************************************************************
     C     SrClearMsg    BEGSR

     C                   CALL      'ZA0250'

     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  SrSndMsg - Send Error Message                                *
      *                                                               *
      *****************************************************************
     C     SrSndMsg      BEGSR

     C                   CALL      'ZA0340'
     C                   PARM                    PMsgFile
     C                   PARM                    PMsgId

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrOMESetUp - Start OME set-up                                *
      *                                                               *
      *****************************************************************
     C     SrOMESetUp    BEGSR

     C                   CALL      'GPC000103'                                               BUG8328
     C                   PARM      *BLANKS       PRetCode                                    BUG8328
     C                   PARM                    PPrGlobLive                                 BUG8328
     C                   PARM                    PPrGlobOME                                  BUG8328
     C                   PARM                    DDEV                                        BUG8328
     C                   PARM                    DBICGSQ                                     BUG8328
     C                   PARM                    DBICGTSQ                                    BUG8328
                                                                                             BUG8328
     C                   IF        PRetCode = *BLANKS                                        BUG8328
                                                                                             BUG8328
     C                   CALL      'SCC000103'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM                    DPRFL
     C                   PARM                    DPRFO
     C                   PARM                    DDEV
     C                   PARM                    DBICSQ                                      BUG8328
     C                   PARM                    DBICDTSQ                                    BUG8328
     C                   PARM                    PZoneName

     C                   IF        PRetCode = *BLANKS

      ** Update OME system bank detail

     C                   EXSR      SrSDBank
                                                                                             BUG8604
      ** Update OME system ICD detail                                                        BUG8604
                                                                                             BUG8604
     C                   EXSR      SrTABTB10                                                 BUG8604

      ** Reset files containing last transaction number

     C                   EXSR      SrResetFile

      ** Disable authorization limits                                                        BUG8384
                                                                                             BUG8384
     C                   EXSR      SrAuthLimit                                               BUG8384
                                                                                             BUG8384
      ** Set-up OME Switchable Feature                                                       BUG8417
                                                                                             BUG8417
     C                   EXSR      SrOMESwitch                                               BUG8417
                                                                                             BUG8417
      ** Maintain Account Code Authorities File                                              BUG8501
                                                                                             BUG8501
     C                   EXSR      SrAcntAuth                                                BUG8501
                                                                                             BUG8501
      ** House keeping for global file

     C                   EXSR      SrGlobal

      ** Set-up ok flag

     C                   EVAL      WSetupOk = 'Y'

     C                   ENDIF                                                               BUG8328
     C                   ENDIF                                                               BUG8328
                                                                                             BUG8328
     C                   IF        PRetCode <> *BLANKS                                       BUG8328
     C**********         ELSE                                                                BUG8328

      ** Redisplay menu

     C                   EVAL      WConfirm = 'N'
     C                   EVAL      *IN29 = *OFF
     C                   EVAL      *IN31 = *ON

     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  SrSDBank - Access and update Bank ICD details                *
      *                                                               *
      *****************************************************************
     C     SrSDBank      BEGSR

      ** Read Bank ICD file

     C                   CALL      'AOBANKR0'
     C                   PARM      '*MSG   '     PRetCode
     C                   PARM      '*FIRST '     POption
     C     SDBANK        PARM      SDBANK        DSFDY

     C                   IF        PRetCode <> *BLANKS
     C                   EVAL      DBFile = 'SDBANKPD'
     C                   EVAL      DBKey = POption
     C                   EVAL      DBase = 2
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Update Bank ICD file

     C                   EVAL      BJURPT = P@VL04
     C                   CALL      'AOBANKU0'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      '*UPDATE'     POption
     C     SDBANK        PARM      SDBANK        DSFDY

     C                   IF        PRetCode <> *BLANKS
     C                   EVAL      DBFile = 'SDBANKPD'
     C                   EVAL      DBKey = POption
     C                   EVAL      DBase = 3
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Close Bank ICD file

     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      '*FREE  '     POption
     C     SDBANK        PARM      SDBANK        DSFDY

     C                   IF        PRetCode <> *BLANKS
     C                   EVAL      DBFile = 'SDBANKPD'
     C                   EVAL      DBKey = POption
     C                   EVAL      DBase = 4
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   ENDSR
      *****************************************************************                      BUG8604
      *                                                               *                      BUG8604
      *  SrTABTB10 - Update system title                              *                      BUG8604
      *                                                               *                      BUG8604
      *****************************************************************                      BUG8604
     C     SrTABTB10     BEGSR                                                               BUG8604
                                                                                             BUG8604
     C                   OPEN      TABTB10                                                   BUG8604
     C                   READ      TABTB10                                                   BUG8604
     C                   EVAL      TITL = P@VL04                                             BUG8604
     C                   UPDATE    TABTB10F                                                  BUG8604
     C                   CLOSE     TABTB10                                                   BUG8604
                                                                                             BUG8604
     C                   ENDSR                                                               BUG8604
      *****************************************************************
      *                                                               *
      *  SrResetFile - Reset files that allocates transaction numbers *
      *                                                               *
      *****************************************************************
     C     SrResetFile   BEGSR

     C                   OPEN      CANDLNLL
     C                   OPEN      ZATNRGL0
     C                   OPEN      FDDLNMLL

     C                   READ      CANDLNLL
     C                   DOW       NOT %EOF(CANDLNLL)
     C                   EVAL      FTNDLS = 1
     C                   UPDATE    CANDLNP0
     C                   READ      CANDLNLL
     C                   ENDDO

     C     *LOVAL        SETLL     ZATNRGL0
     C                   READ      ZATNRGL0
     C                   DOW       NOT %EOF(ZATNRGL0)
     C                   EVAL      FNOR = 1
     C                   UPDATE    ZATNRGD0
     C                   READ      ZATNRGL0
     C                   ENDDO

     C                   READ      FDDLNMLL
     C                   DOW       NOT %EOF(FDDLNMLL)
     C                   EVAL      NORDLN = 1
     C                   UPDATE    FDDLNMP0
     C                   READ      FDDLNMLL
     C                   ENDDO

     C                   CLOSE     CANDLNLL
     C                   CLOSE     ZATNRGL0
     C                   CLOSE     FDDLNMLL

     C                   ENDSR
      *****************************************************************                      BUG8384
      *                                                               *                      BUG8384
      *  SrAuthLimit - Disable authorization limits                   *                      BUG8384
      *                                                               *                      BUG8384
      *****************************************************************                      BUG8384
     C     SrAuthLimit   BEGSR                                                               BUG8384
                                                                                             BUG8384
     C                   CALL      'SC000107'                                                BUG8384
     C                   PARM      *BLANKS       PRetCode                                    BUG8384
                                                                                             BUG8384
     C                   IF        PRetCode <> *BLANKS                                       BUG8384
     C                   EVAL      DBFile = 'SC000107'                                       BUG8384
     C                   EVAL      DBKey = PRetCode                                          BUG8384
     C                   EVAL      DBase = 5                                                 BUG8384
     C                   EXSR      *PSSR                                                     BUG8384
     C                   ENDIF                                                               BUG8384
                                                                                             BUG8384
     C                   ENDSR                                                               BUG8384
      *****************************************************************                      BUG8417
      *                                                               *                      BUG8417
      *  SrOMESwitch - Setting up of OME switchable features          *                      BUG8417
      *                                                               *                      BUG8417
      *****************************************************************                      BUG8417
     C     SrOMESwitch   BEGSR                                                               BUG8417
                                                                                             BUG8417
     C**********         OPEN      SCSAREL0                                         BUG8417 MD055681
                                                                                             BUG8417
     C                   EVAL      #1SARN  =  'CSC024'                                       BUG8417
     C*****#1SARN        CHAIN     SCSARED0                                         BUG8417 MD055681
     C**********         IF        %Found                                           BUG8417 MD055681
     C/EXEC SQL                                                                             MD055681
     C+ SELECT *                                                                            MD055681
     C+ into :SCSARD                                                                        MD055681
     C+ from SCSRDJW2                                                                       MD055681
     C+ where SARN = 'CSC024'                                                               MD055681
     C/END-EXEC                                                                             MD055681
     C                   IF        SQLCODE = 0                                              MD055681
                                                                                             BUG8417
     C                   CALL      'SC3010X'                                                 BUG8417
     C                   PARM                    RtnCode           7                         BUG8417
     C                   PARM      '+'           ActCode           1                         BUG8417
     C                   PARM                    #1SARN            6                         BUG8417
     C                   PARM                    Allow             1                         BUG8417
                                                                                             BUG8417
     C                   IF        Allow  <>  'Y'                                            BUG8417
     C                   EVAL      DBFile = 'SCSARDPD'                                       BUG8417
     C                   EVAL      DBKey  = #1SARN + ' not allowed.'                         BUG8417
     C                   EXSR      *PSSR                                                     BUG8417
     C                   ENDIF                                                               BUG8417
                                                                                             BUG8417
     C**********         WRITE     @SARDL0                                          BUG8417 MD055681
     C/EXEC SQL                                                                             MD055681
     C+ update SCSRDXTD                                                                     MD055681
     C+ set ENABLD = 'E'                                                                    MD055681
     C+ where SARN = 'CSC024'                                                               MD055681
     C/END-EXEC                                                                             MD055681
     C**********         DELETE    SCSARED0                                         BUG8417 MD055681
                                                                                             BUG8417
     C                   ENDIF                                                               BUG8417
                                                                                             BUG8417
     C**********         CLOSE     SCSAREL0                                         BUG8417 MD055681
                                                                                             BUG8417
     C                   ENDSR                                                               BUG8417
      *****************************************************************                      BUG8501
      *                                                               *                      BUG8501
      *  SrAcntAuth - Maintain Account code authorities               *                      BUG8501
      *                                                               *                      BUG8501
      *****************************************************************                      BUG8501
     C     SrAcntAuth    BEGSR                                                               BUG8501
                                                                                             BUG8501
     C                   OPEN      SFACAUL0                                                  BUG8501
     C                   OPEN      SDACODL1                                                  BUG8501
                                                                                             BUG8501
      ** Retain SFACAUPD of OME system but delete all records that doesn't                   BUG8501
      ** exist in SDACODPD.                                                                  BUG8501
                                                                                             BUG8501
     C                   READ      SFACAUL0                                                  BUG8501
     C                   DOW       NOT %EOF(SFACAUL0)                                        BUG8501
     C                   MOVE      SFACOD        WKeyACOD                                    BUG8501
     C     WKeyACOD      CHAIN     SDACODL1                                                  BUG8501
     C                   IF        NOT %FOUND(SDACODL1)                                      BUG8501
     C                   DELETE    SFACAUL0                                                  BUG8501
     C                   ENDIF                                                               BUG8501
     C                   READ      SFACAUL0                                                  BUG8501
     C                   ENDDO                                                               BUG8501
                                                                                             BUG8501
     C                   CLOSE     SFACAUL0                                                  BUG8501
     C                   CLOSE     SDACODL1                                                  BUG8501
                                                                                             BUG8501
     C                   ENDSR                                                               BUG8501
      *****************************************************************
      *                                                               *
      *  SrGlobal - Synchronize global file with zonal file           *
      *                                                               *
      *****************************************************************
     C     SrGlobal      BEGSR

      ** Synchrinize all global file

     C                   OPEN      GPGLOBFL1                                                 BUG8387
     C     *LOVAL        SETLL     GPGLOBFL1
     C                   READ      GPGLOBFL1
     C                   DOW       NOT %EOF(GPGLOBFL1)
     C                   IF        GFGPF <> 'GZSDBRCHPD' AND
     C                             GFGPF <> 'GZRSACMTPD'
     C                   CALL      'GOC0100'
     C                   PARM                    GFGPF
     C                   ENDIF
     C                   READ      GPGLOBFL1
     C                   ENDDO
     C                   CLOSE     GPGLOBFL1                                                 BUG8387

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrValidate - Validation process                              *
      *                                                               *
      *****************************************************************
     C     SrValidate    BEGSR

      ** Process restore from tape indicator

     C                   IF        DRSTP <> 'Y' AND
     C                             DRSTP <> 'N' AND
     C                             DRSTP <> *BLANK
     C                   EVAL      *IN26 = *ON
     C                   EVAL      WErrFlag = 'Y'
     C                   EVAL      PMsgId = 'DRM0015'
     C                   EXSR      SrSndMsg

     C                   ELSE
     C                   EVAL      *IN26 = *OFF
     C                   IF        DRSTP = *BLANK
     C                   EVAL      DRSTP = 'N'
     C                   EVAL      WDRsTp = *BLANK
     C                   ENDIF
     C                   ENDIF

      ** Validate device

     C                   IF        DDEV = *BLANKS AND
     C                             DRSTP = 'Y'AND
     C                             *IN27 = *ON
     C                   EVAL      *IN30 = *ON
     C                   EVAL      WErrFlag = 'Y'
     C**********         EVAL      PMsgId = 'ASM0001'                                        BUG8328
     C                   EVAL      PMsgId = 'SCC0043'                                        BUG8328
     C                   EXSR      SrSndMsg
     C                   ELSE
     C                   EVAL      *IN30 = *OFF
     C                   ENDIF
                                                                                             BUG8328
      ** Validate Sequence No.                                                               BUG8328
                                                                                             BUG8328
     C                   EVAL      *IN32 = *OFF                                              BUG8328
     C                   EVAL      *IN33 = *OFF                                              BUG8328
     C                   EVAL      *IN34 = *OFF                                              BUG8328
     C                   EVAL      *IN35 = *OFF                                              BUG8328
     C                   EVAL      PZADEC = 0                                                BUG8328
     C                   EVAL      PZADIG = 10                                               BUG8328
                                                                                             BUG8328
     C                   IF        DRSTP = 'Y'AND                                            BUG8328
     C                             *IN27 = *ON                                               BUG8328
                                                                                             BUG8328
      ** Validate DBIC Seq No.                                                               BUG8328
                                                                                             BUG8328
     C                   IF        DBICSQ <> *BLANKS                                         BUG8328
     C                   MOVE      *Blanks       PZField                                     BUG8328
     C                   MOVE      DBICSQ        PZField                                     BUG8328
     C                   EXSR      SRZAlign                                                  BUG8328
                                                                                             BUG8328
     C                   IF        PZRetCode <> *BLANKS                                      BUG8328
     C                   EVAL      *IN32 = *ON                                               BUG8328
     C                   EVAL      WErrFlag = 'Y'                                            BUG8328
     C                   EVAL      PMsgId = 'SCC0045'                                        BUG8328
     C                   EXSR      SrSndMsg                                                  BUG8328
     C                   ELSE                                                                BUG8328
     C                   EVAL      WrkNum10 = *ZERO                                          BUG8328
     C                   MOVE      PZOutField    WrkNum10                                    BUG8328
     C                   IF        WrkNum10 < 1 OR                                           BUG8328
     C                             WrkNum10 > 16777215                                       BUG8328
     C                   EVAL      *IN32 = *ON                                               BUG8328
     C                   EVAL      WErrFlag = 'Y'                                            BUG8328
     C                   EVAL      PMsgId = 'SCC0045'                                        BUG8328
     C                   EXSR      SrSndMsg                                                  BUG8328
     C                   ENDIF                                                               BUG8328
     C                   ENDIF                                                               BUG8328
                                                                                             BUG8328
     C                   IF        *IN32 = *OFF                                              BUG8328
     C                   MOVE      PZOutField    DBICSQ                                      BUG8328
     C                   ENDIF                                                               BUG8328
     C                   ENDIF                                                               BUG8328
                                                                                             BUG8328
      ** Validate DBICDTA Seq No.                                                            BUG8328
                                                                                             BUG8328
     C                   IF        DBICDTSQ <> *BLANKS                                       BUG8328
     C                   MOVE      *Blanks       PZField                                     BUG8328
     C                   MOVE      DBICDTSQ      PZField                                     BUG8328
     C                   EXSR      SRZAlign                                                  BUG8328
                                                                                             BUG8328
     C                   IF        PZRetCode <> *BLANKS                                      BUG8328
     C                   EVAL      *IN33 = *ON                                               BUG8328
     C                   EVAL      WErrFlag = 'Y'                                            BUG8328
     C                   EVAL      PMsgId = 'SCC0046'                                        BUG8328
     C                   EXSR      SrSndMsg                                                  BUG8328
     C                   ELSE                                                                BUG8328
     C                   EVAL      WrkNum10 = *ZERO                                          BUG8328
     C                   MOVE      PZOutField    WrkNum10                                    BUG8328
     C                   IF        WrkNum10 < 1 OR                                           BUG8328
     C                             WrkNum10 > 16777215                                       BUG8328
     C                   EVAL      *IN33 = *ON                                               BUG8328
     C                   EVAL      WErrFlag = 'Y'                                            BUG8328
     C                   EVAL      PMsgId = 'SCC0046'                                        BUG8328
     C                   EXSR      SrSndMsg                                                  BUG8328
     C                   ENDIF                                                               BUG8328
     C                   ENDIF                                                               BUG8328
                                                                                             BUG8328
     C                   IF        *IN33 = *OFF                                              BUG8328
     C                   MOVE      PZOutField    DBICDTSQ                                    BUG8328
     C                   ENDIF                                                               BUG8328
     C                   ENDIF                                                               BUG8328
                                                                                             BUG8328
      ** Validate DBICG Seq No.                                                              BUG8328
                                                                                             BUG8328
     C                   IF        DBICGSQ <> *BLANKS                                        BUG8328
     C                   MOVE      *Blanks       PZField                                     BUG8328
     C                   MOVE      DBICGSQ       PZField                                     BUG8328
     C                   EXSR      SRZAlign                                                  BUG8328
                                                                                             BUG8328
     C                   IF        PZRetCode <> *BLANKS                                      BUG8328
     C                   EVAL      *IN34 = *ON                                               BUG8328
     C                   EVAL      WErrFlag = 'Y'                                            BUG8328
     C                   EVAL      PMsgId = 'SCC0047'                                        BUG8328
     C                   EXSR      SrSndMsg                                                  BUG8328
     C                   ELSE                                                                BUG8328
     C                   EVAL      WrkNum10 = *ZERO                                          BUG8328
     C                   MOVE      PZOutField    WrkNum10                                    BUG8328
     C                   IF        WrkNum10 < 1 OR                                           BUG8328
     C                             WrkNum10 > 16777215                                       BUG8328
     C                   EVAL      *IN34 = *ON                                               BUG8328
     C                   EVAL      WErrFlag = 'Y'                                            BUG8328
     C                   EVAL      PMsgId = 'SCC0047'                                        BUG8328
     C                   EXSR      SrSndMsg                                                  BUG8328
     C                   ENDIF                                                               BUG8328
     C                   ENDIF                                                               BUG8328
                                                                                             BUG8328
     C                   IF        *IN34 = *OFF                                              BUG8328
     C                   MOVE      PZOutField    DBICGSQ                                     BUG8328
     C                   ENDIF                                                               BUG8328
     C                   ENDIF                                                               BUG8328
                                                                                             BUG8328
      ** Validate DBICGTA Seq No.                                                            BUG8328
                                                                                             BUG8328
     C                   IF        DBICGTSQ <> *BLANKS                                       BUG8328
     C                   MOVE      *Blanks       PZField                                     BUG8328
     C                   MOVE      DBICGTSQ      PZField                                     BUG8328
     C                   EXSR      SRZAlign                                                  BUG8328
                                                                                             BUG8328
     C                   IF        PZRetCode <> *BLANKS                                      BUG8328
     C                   EVAL      *IN35 = *ON                                               BUG8328
     C                   EVAL      WErrFlag = 'Y'                                            BUG8328
     C                   EVAL      PMsgId = 'SCC0048'                                        BUG8328
     C                   EXSR      SrSndMsg                                                  BUG8328
     C                   ELSE                                                                BUG8328
     C                   EVAL      WrkNum10 = *ZERO                                          BUG8328
     C                   MOVE      PZOutField    WrkNum10                                    BUG8328
     C                   IF        WrkNum10 < 1 OR                                           BUG8328
     C                             WrkNum10 > 16777215                                       BUG8328
     C                   EVAL      *IN35 = *ON                                               BUG8328
     C                   EVAL      WErrFlag = 'Y'                                            BUG8328
     C                   EVAL      PMsgId = 'SCC0048'                                        BUG8328
     C                   EXSR      SrSndMsg                                                  BUG8328
     C                   ENDIF                                                               BUG8328
     C                   ENDIF                                                               BUG8328
                                                                                             BUG8328
     C                   IF        *IN35 = *OFF                                              BUG8328
     C                   MOVE      PZOutField    DBICGTSQ                                    BUG8328
     C                   ENDIF                                                               BUG8328
     C                   ENDIF                                                               BUG8328
                                                                                             BUG8328
     C                   ENDIF                                                               BUG8328
                                                                                            AR690003
      ** Validate Source System Prefix                                                      AR690003
                                                                                            AR690003
     C                   IF        DPRFL = *BLANKS                                          AR690003
     C                   EVAL      WErrFlag = 'Y'                                           AR690003
     C                   EVAL      PMsgId = 'SCC0049'                                       AR690003
     C                   EXSR      SrSndMsg                                                 AR690003
     C                   ENDIF                                                              AR690003
                                                                                            AR690003
      ** Validate Target System Prefix                                                      AR690003
                                                                                            AR690003
     C                   IF        DPRFO = *BLANKS                                          AR690003
     C                   EVAL      WErrFlag = 'Y'                                           AR690003
     C                   EVAL      PMsgId = 'SCC0050'                                       AR690003
     C                   EXSR      SrSndMsg                                                 AR690003
     C                   ENDIF                                                              AR690003

      ** Same system prefix cannot be on the same partition

     C                   IF        DPRFL = DPRFO AND
     C                             DRSTP <> 'Y' AND
     C                             WErrFlag <> 'Y'
     C                   EVAL      WErrFlag = 'Y'
     C**********         EVAL      PMsgId = 'ASM0002'                                        BUG8328
     C                   EVAL      PMsgId = 'SCC0044'                                        BUG8328
     C                   EXSR      SrSndMsg
     C                   ENDIF
     C
     C                   ENDSR
      *****************************************************************                      BUG8328
      /EJECT                                                                                 BUG8328
      *****************************************************************                      BUG8328
      *                                                               *                      BUG8328
      *  SRZAlign - Validate numeric fields                           *                      BUG8328
      *                                                               *                      BUG8328
      *****************************************************************                      BUG8328
     C     SRZAlign      BEGSR                                                               BUG8328
                                                                                             BUG8328
     C                   CALL      'ZALIGN'                                                  BUG8328
     C                   PARM      *BLANKS       PZRetCode                                   BUG8328
     C                   PARM                    PZField                                     BUG8328
     C                   PARM                    PZADEC                                      BUG8328
     C                   PARM                    PZADIG                                      BUG8328
     C                   PARM                    PZOutField                                  BUG8328
                                                                                             BUG8328
     C                   ENDSR                                                               BUG8328
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrInit - Initialise fields                                   *
      *                                                               *
      *****************************************************************
     C     SrInit        BEGSR

      ** Get system prefix for 'live' and OME system

     C                   IF        P@VL03 = 'Y'
     C                   MOVEL     P@VL01        DPRFO
     C                   MOVEL     P@VL02        DPRFL
     C                   MOVEL     P@VL06        PPrGlobOME                                  BUG8328
     C                   MOVEL     P@VL07        PPrGlobLive                                 BUG8328
     C                   ENDIF
     C                   MOVEL     P@VL05        PZoneName

      ** Initialise constant field, clear program message file,
      ** and reset display fields.

     C                   EVAL      DDEVTX = 'Device:'
     C                   EVAL      DBICTX = 'DBIC Seq No....:'                               BUG8328
     C                   EVAL      DBICDTTX = 'DBICDTA Seq No.:'                             BUG8328
     C                   EVAL      DBICGTX = 'DBICG Seq No...:'                              BUG8328
     C                   EVAL      DBICGTTX = 'DBICGTA Seq No.:'                             BUG8328
     C                   EXSR      SrClearMsg
     C                   EXSR      SrReset

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Initialisation                                      *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR

      ** Set up Local Data Area

     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = *BLANKS
     C                   EVAL      DBKey = *BLANKS
     C                   EVAL      DBPgm = *BLANKS
     C                   EVAL      DBPgm = 'SC000103'
     C                   EVAL      DBase = *ZERO
     C                   OUT       LDA

     C                   IN        RUNDAT

     C                   EVAL      #0RUND = AGMRDT
     C                   EVAL      #0USER = PSUSER
     C                   EVAL      #0WSID = PSJOBNAME
     C                   EVAL      #0PGM = PSPROCMOD

      ** Define variables                                                                    BUG8328
                                                                                             BUG8328
     C     *LIKE         DEFINE    DPRFL         PPrGlobOME                                  BUG8328
     C     *LIKE         DEFINE    DPRFL         PPrGlobLive                                 BUG8328
                                                                                             BUG8328
      ** Access System values

     C                   CALL      'AOSVALR0'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      SysValArr(1)  P@OP01
     C                   PARM      *BLANKS       P@VL01
     C                   PARM      SysValArr(2)  P@OP02
     C                   PARM      *BLANKS       P@VL02
     C                   PARM      SysValArr(3)  P@OP03
     C                   PARM      *BLANKS       P@VL03
     C                   PARM      SysValArr(4)  P@OP04
     C                   PARM      *BLANKS       P@VL04
     C                   PARM      SysValArr(5)  P@OP05
     C                   PARM      *BLANKS       P@VL05
     C**********         PARM      *BLANKS       P@OP06                                      BUG8328
     C                   PARM      SysValArr(6)  P@OP06                                      BUG8328
     C                   PARM      *BLANKS       P@VL06
     C**********         PARM      *BLANKS       P@OP07                                      BUG8328
     C                   PARM      SysValArr(7)  P@OP07                                      BUG8328
     C                   PARM      *BLANKS       P@VL07
     C                   PARM      *BLANKS       P@OP08
     C                   PARM      *BLANKS       P@VL08
     C                   PARM      *BLANKS       P@OP09
     C                   PARM      *BLANKS       P@VL09
     C                   PARM      *BLANKS       P@OP10
     C                   PARM      *BLANKS       P@VL10

     C                   IF        PRetCode  <> *BLANKS
     C                   EVAL      DBFile = 'SDSVALPD'
     C                   EVAL      DBKey = '*KEY   '
     C                   EVAL      DBase = 1
     C                   EXSR      *PSSR
     C                   ENDIF

     C/COPY ZACPYSRC,DBFIELDS

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR  - Program exception error routine                     *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR

     C                   IF        WRun = *BLANK
     C                   EVAL      WRun = 'Y'
     C                   DUMP
     C                   ENDIF

     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
** CPY@
(c) Finastra International Limited 2005
** System Values Array
BrgMidasSystemPrefix
OMELiveSystemPrefix
OMEIndicator
OMESystemTitle
ZoneSystemName
BrgMidasGlobalPrefix                                                                         BUG8328
OMELiveGlobalPrefix                                                                          BUG8328
