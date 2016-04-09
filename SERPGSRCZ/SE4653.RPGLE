     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Holding - Sub-Balance extract')               *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SE4653 - Midas SE Holding - Sub-Balance Extract              *
      *                                                               *
      *  Function:  This module extracts the Sub-Balance Details.     *
      *                                                               *
      *  Called By   : SEC4651 - SE Statement Processing              *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      *  Last Amend No. CRE073             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD027             Date 09Dec05               *
      *                 CSE075             Date 17Nov05               *
      *                 CSE071             Date 19Jul05               *
      *                 CSW205             Date 30Nov04               *
      *                 218078             Date 23May03               *
      *                 CSE040   *CREATE   Date 10Mar03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSE075 - US Enhanced Treasury Upgrade to MidasPlus           *
      *           (Recompile)                                         *
      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
      *  CSW205 - Swift 2005 Standards                                *
      *  218078 - Remove translation table                            *
      *  CSE040 - Securities Statement Processing                     *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    XX         Function of indicator                           *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FSEBKALL6  IF   E           K DISK    INFSR(*PSSR) IGNORE(SECOALD0)
      ** Midas SE All Blocked Positions (Secty/Cust) - Index
 
     FSEHSBLPD  O    E             DISK    COMMIT       INFSR(*PSSR)
      ** Midas SE Holding - Sub-balance
 
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
      *
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
 
     D DSSDRV        E DS                  EXTNAME(SESDRVPD)
      ** Midas SE Statement - Driver file
 
     D DSBANK        E DS                  EXTNAME(SDBANKPD)
      ** Bank Details
 
     D DSSECTY       E DS                  EXTNAME(SECTY) PREFIX(Se_)
      ** Midas Security Details
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** DS (short) used as output parameter for Access Objects
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** DS (long) used as output parameter for Access Objects
 
     D DSLDY         E DS                  EXTNAME(DSLDY)
      ** DS (longest) used as output parameter for Access Objects
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D @RUN            S              1
     D WkAvailable     S             15  0                                      Available Nominal
     D WkCtlDat        S              5  0                                      Control Date
 
      *****************************************************************
      /EJECT
      *****************************************************************
     ISEERALD0      01
     I              VCRECI                      XXRECI
     I              VCCNUM                      XXCNUM
     I              VCERTP                      XXBLTY
     I              VCSESN                      XXSESN
     I              VCBEDT                      XXBEDT
     I              VCNOMA                      XXNOMB
      *
     ISEBLKPD0      02
     I              VDRECI                      XXRECI
     I              VDCNUM                      XXCNUM
     I              VDBLTY                      XXBLTY
     I              VDSESN                      XXSESN
     I              VDBEDT                      XXBEDT
     I              VDNOMB                      XXNOMB
     I              VDBSTT                      XXBSTT
      *
     ISECOBKD0      03
     I              MURECI                      XXRECI
     I              MUCNUM                      XXCNUM
     I              MUBLTY                      XXBLTY
     I              MUSESN                      XXSESN
     I              MUBEDT                      XXBEDT
     I              MUNOMB                      XXNOMB
     I              MUBSTT                      XXBSTT
 
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
 
      ** Read Block Positions Files
 
     C     KBlock        SETLL     SEBKALL6
     C     KBlock        READE     SEBKALL6
 
      ** Till the end of file
 
     C                   DOW       NOT %EOF(SEBKALL6)
 
      ** Extract blocked position accroding the Control Date
 
     C                   IF        *IN01                                        Early Redemption
     C                             AND XXBEDT >= WkCtlDat
     C                             OR  *IN02                                    Manual Blocked Pos.
     C                             AND XXBEDT >= WkCtlDat
     C                             AND XXBSTT <= WkCtlDat
     C                             OR  *IN03                                    Corporate Block Pos.
     C                             AND XXBEDT >= WkCtlDat
     C                             AND XXBSTT <= WkCtlDat
 
     C                   CLEAR                   SEHSBLD0
 
      ** Load Balance
 
     C                   EXSR      $LdBalance
 
      ** Update Available Nominal
 
     C                   EXSR      $UpAvail
 
      ** Load Place
 
     C                   EXSR      $LdPlace
 
      ** Load Narratives
 
     C                   EXSR      $LdNarr
 
      ** Add Sub-balance records
 
     C                   EVAL      HSEXTR = *ZEROS                              Extract Reference
     C                   EVAL      HSDATE = SPDATE                              Request Date
     C                   EVAL      HSRSEQ = SPRSEQ                              Request Sequence
     C                   EVAL      HSSESN = Se_SESN                             Security shortname
 
     C                   WRITE     SEHSBLD0
 
     C                   ENDIF
 
      ** Read Block Positions Files
 
     C     KBlock        READE     SEBKALL6
 
     C                   ENDDO
 
      ** Load Available Nominal
 
     C                   CLEAR                   SEHSBLD0
 
      * If Swift 2005 Changes are in effect                                                   CSW205
     C     CSW205        IFEQ      'N'                                                        CSW205
     C                   EXSR      $LdAvail
     C                   END                                                                  CSW205
 
      ** Add Sub-balance records
 
     C                   EVAL      HSEXTR = *ZEROS                              Extract Reference
     C                   EVAL      HSDATE = SPDATE                              Request Date
     C                   EVAL      HSRSEQ = SPRSEQ                              Request Sequence
     C                   EVAL      HSSESN = Se_SESN                             Security shortname
 
     C                   WRITE     SEHSBLD0
 
     C                   EXSR      $ExitMod
 
      **********************************************************************
      /EJECT
      **********************************************************************
      ** $LdBalance - Load Balance                                         *
      **********************************************************************
     C     $LdBalance    BEGSR
      *    ----------    -----
 
      ** Balance Qualifier
      *  -----------------
 
     C                   EVAL      HSBQUA = 'BLOK'                              Balance Qualifier
 
      ** Balance Quantity Type Code
      *  --------------------------
 
     C                   IF        Se_SPBS = 'P'                                Percentage
     C                   EVAL      HSBQTC = 'FAMT'                              Face Value
     C                   ELSE
     C                   EVAL      HSBQTC = 'UNIT'                              Unit
     C                   ENDIF
 
      ** Balance Type Code
      *  -----------------
 
     C                   EVAL      HSBTYP = 'NAVL'                              Balance Type Code
 
      ** Balance
      *  -------
 
     C                   IF           XXNOMB = *HIVAL
     C                             OR XXNOMB = *ZEROS
     C                   EVAL      HSBALA = *HIVAL                              Balance
     C                   ELSE
     C                   EVAL      HSBALA = XXNOMB
     C                   ENDIF
 
      ** Number of Decimal Position
      *  --------------------------
 
     C                   EVAL      HSBDPS = Se_NMDP                             Decimal Pos.
 
      ** Evaluate the SWIFT message length
      *  ---------------------------------
 
     C                   EVAL      HSSIZE = HSSIZE + 52                         Static Fields
     C                                             + %LEN(%TRIM(HSBQUA))        Balance Qualifier
     C                                             + %LEN(%TRIM(HSBQTC))        Balance Quantity
     C                                             + %LEN(%TRIM(HSBTYP))        Balance Type
     C                                             + %LEN(%CHAR(HSBALA)) + 2    Balance + Comma + Si
 
      *                  -----
     C                   ENDSR
      **********************************************************************
      * $UpAvail  - Update Available Nominal                               *
      **********************************************************************
 
     C     $UpAvail      BEGSR
      *    ---------     -----
 
     C                   IF        HSBQUA = 'BLOK'                              Balance Qualifier
     C                             AND HSBTYP = 'NAVL'                          Balance Type Code
     C                   EVAL      WkAvailable = WkAvailable - HSBALA
     C                   ENDIF
 
      *                  -----
     C                   ENDSR
      **********************************************************************
      * $LdPlace  - Load Place: Source of Price                            *
      **********************************************************************
 
     C     $LdPlace      BEGSR
      *    ---------     -----
 
 
      *                  -----
     C                   ENDSR
      **********************************************************************
      * $LdNarr   - Sub-Balance Detail Narrative                           *
      **********************************************************************
 
     C     $LdNarr       BEGSR
      *    -------       -----
 
     C                   SELECT
     C                   WHEN      *IN01
     C                   EVAL      HSNAR1 = 'Early Redemptions Allocation'
     C                   WHEN      *IN02
     C                   EVAL      HSNAR1 = 'Manual Blocked Position'
     C                   WHEN      *IN03
     C                   EVAL      HSNAR1 = 'Corporate Action Blocked Position'
     C                   ENDSL
 
      ** Evaluate the SWIFT message length
      *  ---------------------------------
 
     C                   IF        HSNAR1 <> *BLANKS
     C                   EVAL      HSSIZE = HSSIZE + 20                         Static Fields
     C                                             + %LEN(%TRIM(HSNAR1))        Narrative 1
     C                                             + %LEN(%TRIM(HSNAR2))        Narrative 2
     C                                             + %LEN(%TRIM(HSNAR3))        Narrative 3
     C                                             + %LEN(%TRIM(HSNAR4))        Narrative 4
     C                   ENDIF
 
      *                  -----
     C                   ENDSR
      **********************************************************************
      ** $LdAvail - Load Available Nominal                                 *
      **********************************************************************
     C     $LdAvail      BEGSR
      *    --------      -----
 
      ** Balance Qualifier
      *  -----------------
 
     C                   EVAL      HSBQUA = 'TAVI'                              Balance Qualifier
 
      ** Balance Quantity Type Code
      *  --------------------------
 
     C                   IF        Se_SPBS = 'P'                                Percentage
     C                   EVAL      HSBQTC = 'FAMT'                              Face Value
     C                   ELSE
     C                   EVAL      HSBQTC = 'UNIT'                              Unit
     C                   ENDIF
 
      ** Balance Type Code
      *  -----------------
 
     C                   EVAL      HSBTYP = 'AVAI'                              Balance Type Code
 
      ** Balance
      *  -------
 
     C                   IF        WkAvailable > *ZEROS
     C                   EVAL      HSBALA = WkAvailable                         Available Nominal
     C                   ENDIF
 
      ** Number of Decimal Position
      *  --------------------------
 
     C                   EVAL      HSBDPS = Se_NMDP                             Decimal Pos.
 
      ** Evaluate the SWIFT message length
      *  ---------------------------------
 
     C                   EVAL      HSSIZE = HSSIZE + 52                         Static Fields
     C                                             + %LEN(%TRIM(HSBQUA))        Balance Qualifier
     C                                             + %LEN(%TRIM(HSBQTC))        Balance Quantity
     C                                             + %LEN(%TRIM(HSBTYP))        Balance Type
     C                                             + %LEN(%CHAR(HSBALA)) + 2    Balance + Comma + Si
 
      *                  -----
     C                   ENDSR
      **********************************************************************
      * $ExitMod  - Exit from the module                                   *
      **********************************************************************
 
     C     $ExitMod      BEGSR
      *    ---------     -----
 
     C                   MOVE      *On           *INLR
     C                   RETURN
 
      *                  -----
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
      *    ------        -----
 
     C     *entry        PLIST
     C                   PARM                    ReturnCode                     Return Code
     C                   PARM                    DSSDRV                         Statement Request
     C                   PARM                    DSSECTY                        Security Details
     C                   PARM                    WkAvailable                    Nominal
 
      ** Check if switchable feature CSW205 is switched on                                    CSW205
     C                   CALL      'SWIF2005'                                                 CSW205
     C                   PARM                    @RTCD                                        CSW205
      *                                                                                       CSW205
     C     @RTCD         IFEQ      'CSW2005'                                                  CSW205
     C                   MOVE      'Y'           CSW205            1                          CSW205
     C                   ELSE                                                                 CSW205
     C                   MOVE      'N'           CSW205                                       CSW205
     C                   ENDIF                                                                CSW205
 
      ** Access Bank details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     DSBANK        PARM      DSBANK        DSFDY
 
      ** Initialize LDA
 
     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   EVAL      DBMOD  =  PSProcMod
     C                   EVAL      DBPROC =  PSProcName
     C                   OUT       LDA
 
      ** Retrieve the Control Date
 
     C                   IF           SPTYPE = 'TC'                             Trade Date Change
     C                             OR SPTYPE = 'VC'                             Value Date Change
     C                             OR SPTYPE = 'SC'                             Settle Date Change
     C                   EVAL      WkCtlDat = SPMSTD                            Request Start Date
     C                   ELSE
     C                   EVAL      WkCtlDat = BJRDNB                            Run Date
     C                   ENDIF
 
      ** Key list to access Blocked Position
 
     C                   EVAL      KeySecn = Se_SESN
     C                   MOVE      SPCUST        KeyCust
 
     C     KBlock        KLIST
     C                   KFLD                    KeySecn          10            Security
     C**********         KFLD                    KeyCust           6 0          Customer      CSD027
     C                   KFLD                    KeyCust           6            Customer      CSD027
 
      *                  -----
     C                   ENDSR
 
      *********************************************************************
      /EJECT
      *********************************************************************
      *                                                                   *
      * *PSSR  - Program exception error routine                          *
      *          Called automatically if a program error occurs,          *
      *          or directly by the program code using EXSR.              *
      *          This subroutine DUMPs the program just once.             *
      *                                                                   *
      * Called by: (**calling routines**)                                 *
      *                                                                   *
      * Calls: None                                                       *
      *                                                                   *
      *********************************************************************
 
     C     *PSSR         BEGSR
      *    -----         -----
 
     C                   EVAL      ReturnCode = '*ERROR*'                       Return Code
 
     C                   DUMP
 
     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'
 
     C                   CALLB     'DBERRCTL'
 
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
      *                  -----
     C                   ENDSR
 
      ********************************************************************
**CTDATA CPY@
(c) Misys International Banking Systems Ltd. 2003
