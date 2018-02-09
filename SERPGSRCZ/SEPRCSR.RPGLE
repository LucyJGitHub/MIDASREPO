     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Prices Input - Retrieve a record')
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SEPRCSR   - SE Prices Input - Retrieve a record              *
      *                                                               *
      *  Function:  This module retrieves a record from the file      *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD027             Date 09Dec05               *
      *                 BUG9475            Date 10Jan06               *
      *                 CGL031             Date 05Jul04               *
      *                 CSE071             Date 19Jul05               *
      *                 BUG4258            Date 13Sep04               *
      *                 CAP084  *CREATE    Date 06Jan04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG9475 - Incorrect Net Treasury Price display format        *
      *  CGL031 - Taxation of Savings Income                          *
      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
      *  BUG4258- Stopping changes being overwritten by other user    *
      *           when try to amend the record at the same time.      *
      *  CAP084 - Synchronous calling of APIs                         *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Securities file
     FSECTY     IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(M)
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **-----------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **-----------------------------------------------------------------------
 
      **-----------------------------------------------------------------------
      ** The following /COPY includes the standard API declares:
     D/COPY ZACPYSRC,STDDECLARE
      **-----------------------------------------------------------------------
 
      **-----------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **-----------------------------------------------------------------------
 
      **-----------------------------------------------------------------------
     D/COPY ZACPYSRC,ERR_ARRAYS
      **-----------------------------------------------------------------------
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** SE Prices in screen format
     D NwPrcsScnFmt  E DS                  EXTNAME(SEPRCSPD)
 
      ** SE Prices in file format
     D NwPrcsFilFmt  E DS                  EXTNAME(SEVPRCSPD)
     D                                     PREFIX(V)
     D CrPrcsFilFmt  E DS                  EXTNAME(PRICED)
 
      ** Flags to indicate whether Price fields are valid
     D OKFlagsDS     E DS                  EXTNAME(SEEPRCSPD)
 
      ** Externally described DS for Midas modules details
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
 
      ** Externally described DS for SAR details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
     D SLCD          E                     EXTFLD(LCD)
 
      ** DS for access programs - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Security Trading Detail
     D SDSTRD        E DS                  EXTNAME(SDSTRDPD)
 
      **  Long DS for access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** Parameters for access objects
     D PRtcd           S              7A
     D PSARd           S              6A
     D POptn           S              7A
 
      ** Index for arrays of of error message ids etc
     D Idx             S              3P 0 INZ(0)
     D WIdx            S              3P 0 INZ(0)
 
      ** Collateralised Lending Switchable Feature
     D CSD010          S              1A
                                                                                              CGL031
      ** Taxation of Savings Income Switchable Feature                                        CGL031
     D CGL031          S              1A                                                      CGL031
     D HPPRC           S             15P 8
     D HOFPR           S             15P 8
     D HCLPR           S             15P 8
     D HBDPR           S             15P 8
                                                                                             BUG9475
     D  ZFIELD         S             16A                                                     BUG9475
     D  ZADEC          S              1  0                                                   BUG9475
 
     D                 DS
     D  WDDFTS                 1     14A
     D  DDTSDT                 3      8A
     D  DDTSTM                 9     14A
     D  WDMKPN                       16A
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--- Start of main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
     C     DDACTN        IFEQ      *BLANK
     C     AuthComp      IFEQ      'X'
     C                   MOVEL     'X'           DDACTN
     C                   ELSE
     C                   MOVEL     'E'           DDACTN
     C                   ENDIF
     C                   ENDIF
 
     C     FwdBck        IFEQ      'F'
     C                   MOVEL     'Y'           @RDFWD
     C                   MOVEL     'N'           @RDBCK
     C                   ELSE
     C     FwdBck        IFEQ      'B'
     C                   MOVEL     'N'           @RDFWD
     C                   MOVEL     'Y'           @RDBCK
     C                   ELSE
     C                   MOVEL     'N'           @RDFWD
     C                   MOVEL     'N'           @RDBCK
     C                   ENDIF
     C                   ENDIF
 
     C     @RDFWD        IFEQ      'Y'
     C     @RDBCK        OREQ      'Y'
     C                   EXSR      SEPRCSRED
     C                   ELSE
     C                   MOVEL     DDPSSN_In     DDPSSN
     C                   MOVEL     DDPCNM_In     DDPCNM
     C                   MOVEL     DDPMKT_In     DDPMKT
     C                   MOVEL     DDPBRA_In     DDPBRA
     C                   MOVEL     DDPBOK_In     DDPBOK
     C                   MOVEL     DDPPRT_In     DDPPRT
     C                   MOVEL     DDPTFR_In     DDPTFR
     C                   ENDIF
 
      ** If security shortname read and no error message returned
     C     @ERRMS        IFEQ      *BLANK
     C     DDPSSN        ANDNE     *BLANK
 
      ** Retrieve security price
     C                   EXSR      SEPRCSRTV
 
      ** Default Extel details
 
     C                   IF        Idx = 0  AND
     C                             DDLPRI  = *BLANKS AND
     C                             DDUPRI  = *BLANKS AND
     C                             DDPCEN  = *BLANKS AND
     C                             DDAPND  = *BLANKS AND
     C                             DDPSRC  = *BLANKS
     C                   EXSR      SRDFT
     C                   ENDIF
 
      ** Convert to screeen format
 
     C                   IF        Idx = 0
     C                   EXSR      SEPRCSCVT
     C                   ENDIF
 
     C                   ENDIF
 
      ** Also pass output fields
     C                   MOVEL     *BLANKS       WDMKPN
     C                   IF        Idx = 0
     C     DDPSSN        CHAIN     SECTY                              01
     C                   IF        *IN01 = *Off
     C**********         MOVEL     MMKPN         WDMKPN                                      BUG9475
                                                                                             BUG9475
     C                   MOVE      *BLANKS       ZFIELD                                      BUG9475
     C                   MOVE      MMKPN         ZFIELD                                      BUG9475
     C                   Z-ADD     8             ZADEC                                       BUG9475
     C                   CALLB     'ZEDIT'                                                   BUG9475
     C                   PARM                    ZFIELD                                      BUG9475
     C                   PARM                    ZADEC                                       BUG9475
     C                   MOVE      ZFIELD        WDMKPN                                      BUG9475
                                                                                             BUG9475
     C                   ENDIF
 
     C                   MOVEL     DDDFTS        WDDFTS
     C                   ENDIF
 
     C                   IF        ReturnCode <> *BLANK
     C                   MOVEL     '0'           APIRetc
     C                   MOVEL     'DDPSSN'      FldNameArr(1)
     C                   MOVEL     @ERRMS        MsgIDArr(1)
     C                   ENDIF
 
      ** Build buffer with required output
 
     C                   MOVE      PRTMST        @TimeStamp       26                         BUG4258
     C*************      EVAL      Buffer = NwPrcsScnFmt + WDMKPN + DDTSDT                   BUG4258
     C                   EVAL      Buffer = NwPrcsScnFmt                                     BUG4258
     C                                      + @TimeStamp                                     BUG4258
     C                                      + WDMKPN + DDTSDT                                BUG4258
     C                                 + DDTSTM
 
     C                   MOVE      *ON           *INLR
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SEPRCSRED - ROLL BACKWARDS & FORWARDS THROUGH DEALS FILE
      *****************************************************************
     C     SEPRCSRED     BEGSR
 
     C                   RESET                   RetCodeOut
 
     C                   CALLB     'SEPRCSRED'
 
      ** Input
      ** Return Code
     C                   PARM      *BLANK        RetCodeOut
     C                   PARM                    DDPSSN           10
     C                   PARM                    DDPCNM           10
     C                   PARM                    DDPMKT            1
     C                   PARM                    DDPBRA            3
     C                   PARM                    DDPBOK            2
     C                   PARM                    DDPRFC            4
     C                   PARM                    DDPPRT            2
     C                   PARM                    DDPTFR            4
 
      ** Read fwd
     C                   PARM                    @RDFWD            1
 
      ** Read backwards
     C                   PARM                    @RDBCK            1
 
      ** ICD
     C                   PARM                    CAC005            1
     C                   PARM                    BGN4ST            1
     C                   PARM                    FCR997            4
 
      ** Output parameters
      ** Error message
     C                   PARM      *BLANK        @ERRMS            7
 
      ** Security Read - Key fields
     C                   PARM                    @PSSN            10
     C                   PARM                    @PCNM            10
     C                   PARM                    @PMKT             1
     C                   PARM                    @PBRA             3
     C                   PARM                    @PBOK             2
     C                   PARM                    @PRFC             4
     C                   PARM                    @PPRT             2
     C                   PARM                    @PTFR             4
 
      ** Setup details
     C     @PSSN         IFNE      *BLANK
     C     @ERRMS        ANDEQ     *BLANK
     C                   MOVEL     @PSSN         DDPSSN
     C                   MOVEL     @PCNM         DDPCNM
     C                   MOVEL     @PMKT         DDPMKT
     C                   MOVEL     @PBRA         DDPBRA
     C                   MOVEL     @PBOK         DDPBOK
     C                   MOVEL     @PRFC         DDPRFC
     C                   MOVEL     @PPRT         DDPPRT
     C                   MOVEL     @PTFR         DDPTFR
     C                   ENDIF
 
     C                   ENDSR
      **********************************************************************
      *  SEPRCSRTV  - RETRIEVE SECURITY
      *****************************************************************
     C     SEPRCSRTV     BEGSR
 
     C                   RESET                   RetCodeOut
 
     C                   CALLB     'SEPRCSRTV'
 
      ** Inputs
      ** Return code
     C                   PARM      *BLANK        ReturnCode
 
     C                   PARM      *BLANKS       ModeofOp          6
 
      ** Response mode
     C                   PARM      'S'           RespMode          1
 
      ** Front Office Id
     C                   PARM                    FOTRID           20
 
      ** Action Code
     C                   PARM                    DDACTN            1
     C                   PARM                    DDPSSN           10
     C                   PARM                    DDPCNM           10
     C                   PARM                    DDPMKT            1
     C                   PARM                    DDPBRA            3
     C                   PARM                    DDPBOK            2
     C                   PARM                    DDPRFC            4
     C                   PARM                    DDPPRT            2
     C                   PARM                    DDPTFR            4
      ** ICD
      ** Extel Indicator
     C                   PARM                    BVEXOP            1
 
      ** Outputs
      ** (Current) securities prices in file format
 
     C                   PARM                    CrPRCSFilFmt
 
      ** If CAC005 is on, this is the book code the user entered on the screen
     C                   PARM                    PBCD              2
 
      ** If CAC005 is on, this is the pseudo book
      ** If CAC005 is off, this is the book the user entered on the screen
     C                   PARM                    PBOK              2
 
      ** Profit Centre, in file format
     C                   PARM                    PRFC              4
 
      ** Customer number in file format
     C                   PARM                    PCNM
 
      ** Current Price retrieved, depending on price type
     C                   PARM                    DDCURP           16
 
      ** OK fields
     C                   PARM                    DDACTNOK
     C                   PARM                    DDSSNOK
     C                   PARM                    DDPCNMOK
     C                   PARM                    DDPMKTOK
     C                   PARM                    DDPBRAOK
     C                   PARM                    DDPBOKOK
     C                   PARM                    DDPRFCOK
     C                   PARM                    DDPRTOK
     C                   PARM                    DDPTFROK
 
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
 
      ** Warnings
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
 
      ** Array index (3P0) from/to caller
     C                   PARM      *ZERO         Idx
     C                   PARM      *ZERO         WIdx
     C                   PARM      FCR997        @CR997            4
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRDFT   - DEFAULTING FOR EXTEL DETAILS
      *****************************************************************
     C     SRDFT         BEGSR
 
     C                   CALLB     'SEPRCSDFT'
      *
      * INPUTS
      *
      * Return Code
     C                   PARM                    RetCodeIn
      ** Action Code
     C                   PARM                    DDACTN            1
      ** Security Shortname
     C                   PARM                    DDPSSN           10
      ** Price Type
     C                   PARM                    DDPPRT            2
 
      * Account in file format
     C                   PARM                    CrPrcsFilFmt
      * ICD
     C                   PARM                    BVEXOP
 
      * OUTPUTS
      * Screen Output
      *
      ** Price Source
     C                   PARM      *BLANKS       DDPSRC            1
      ** Auto-Price Indicator
     C                   PARM      *BLANKS       DDAPND            1
      ** Lower Price Boundary
     C                   PARM      *BLANKS       DDLPRI           16
      ** Upper Price Boundary
     C                   PARM      *BLANKS       DDUPRI           16
      ** Percentage
     C                   PARM      *BLANKS       DDPCEN           10
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
      ** Security shortname OK flag
     C                   PARM                    DDSSNOK
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SEPRCSCVT  - PUT A DEAL ON THE MAIN DETAILS SCREEN
      *****************************************************************
     C     SEPRCSCVT     BEGSR
 
     C                   CALLB     'SEPRCSCVT'
 
      ** Inputs
      ** Return Code
     C                   PARM                    DDSTS             8
     C                   PARM      *BLANK        ReturnCode
 
      ** Securities Prices Transaction Details file format
     C                   PARM                    CrPrcsFilFmt
 
      ** If CAC005 is on, this is the pseudo book ( the book stored on file on PRICED )
      ** If CAC005 is off, this is the book the user entered on the screen
 
     C                   PARM                    PBOK
                                                                                              CGL031
      ** Taxation on Savings Income                                                           CGL031
                                                                                              CGL031
     C                   PARM                    CGL031                                       CGL031
 
      ** Outputs
      ** Securities Prices Transaction Details screen format
     C                   PARM                    NwPrcsScnFmt
 
      ** Current Price in file format
     C                   PARM                    HPPRC
 
      ** Switchable feature CSD010 parameters
     C                   PARM                    HBDPR
     C                   PARM                    HOFPR
     C                   PARM                    HCLPR
     C                   PARM                    CSD010
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * RESETCYCLE- Reset error information that is gradually         *
      *    updated during each run of this program                    *
      *                                                               *
      *****************************************************************
     C     RESETCYCLE    BEGSR
 
     C                   MOVE      *ALL'Y'       OKFlagsDS
 
     C                   CLEAR                   NwPrcsFilFmt
     C                   CLEAR                   NwPrcsScnFmt
     C                   CLEAR                   CrPrcsFilFmt
 
      * Output only fields
     C                   EVAL      DDCURP = *BLANKS
     C                   EVAL      DDPSRC = *BLANKS
     C                   ENDSR
      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program initialisation                              *
      *         - This subroutine runs automatically for program      *
      *           initialisation.                                     *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
      ** Entry parameters.
 
     C     *ENTRY        PLIST
     C                   PARM                    AuthComp          1
     C                   PARM                    FwdBck            1
 
      ** Key fields
     C                   PARM                    DDPSSN_In        10
     C                   PARM                    DDPCNM_In        10
     C                   PARM                    DDPMKT_In         1
     C                   PARM                    DDPBRA_In         3
     C                   PARM                    DDPBOK_In         2
     C                   PARM                    DDPPRT_In         2
     C                   PARM                    DDPTFR_In         4
 
     C                   PARM                    Buffer         6000
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    MsgFArray
     C                   PARM                    APIRetc           1
 
      ** Set up the name of the primary and secondary message files from
      ** which the message handler will get the messages
 
     C                   EVAL      MsgFArray(1) = 'SEUSRMSG'
     C                   EVAL      MsgFArray(2) = 'DRSMM'
     C                   EVAL      MsgFArray(3) = 'MEMSG'
 
      ** Access midas modules.
 
     C                   CALLB     'AOMMODR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*FIRST '     POptn
     C     SDMMOD        PARM      SDMMOD        DSFDY
 
      ** Database error
 
     C                   IF        PRtcd <> *BLANKS
     C                   EVAL      DBKey = POptn
     C                   EVAL      DBFile = 'SDMMODPD'
     C                   Z-ADD     1             DBase
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Access SAR file to determine if CAC005 is installed
 
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'CAC005'      PSARd
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C                   IF        PRtcd = *BLANK
     C                   EVAL      CAC005 = 'Y'
     C                   ELSE
     C                   EVAL      CAC005 = 'N'
     C                   ENDIF
 
      ** Access SAR file to determine if CSD010 is installed
 
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'CSD010'      PSARd
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C                   IF        PRtcd = *BLANK
     C                   EVAL      CSD010 = 'Y'
     C                   ELSE
     C                   EVAL      CSD010 = 'N'
     C                   ENDIF
                                                                                              CGL031
      ** Check if CGL031 is enabled.                                                          CGL031
                                                                                              CGL031
     C                   CALLB     'AOSARDR0'                                                 CGL031
     C                   PARM      *BLANKS       PRtCd                                        CGL031
     C                   PARM      '*VERIFY'     POptn                                        CGL031
     C                   PARM      'CGL031'      PSARD                                        CGL031
     C     SCSARD        PARM      SCSARD        DSFDY                                        CGL031
                                                                                              CGL031
     C                   EVAL      CGL031 = 'N'                                               CGL031
                                                                                              CGL031
     C                   IF        PRtCd = *BLANKS                                            CGL031
     C                   EVAL      CGL031 = 'Y'                                               CGL031
     C                   ELSE                                                                 CGL031
                                                                                              CGL031
     C                   IF        PRtCd <> '*NRF   '                                         CGL031
     C     *LOCK         IN        LDA                                                        CGL031
     C                   EVAL      DBFile = 'SCSARDPD'                                        CGL031
     C                   EVAL      DBKey = PSARD                                              CGL031
     C                   EVAL      DBase = 101                                                CGL031
     C                   OUT       LDA                                                        CGL031
     C                   EXSR      *PSSR                                                      CGL031
     C                   ENDIF                                                                CGL031
                                                                                              CGL031
     C                   ENDIF                                                                CGL031
 
      ** Check if EXTEL indicator is on, BVEXOP
 
     C                   CALL      'AOSTRDR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDSTRD        PARM      SDSTRD        DSSDY
 
     C                   EXSR      RESETCYCLE
 
     C                   ENDSR
 
      *********************************************************************
      /EJECT
      *********************************************************************
      ** The following /COPY contains the standard program status
      ** subroutine, excluding a bound call to the DBERRCTL module.
      *********************************************************************
     C/COPY ZACPYSRC,PSSR_ILENE
     C                   EVAL      APIRETC = '0'
     C                   RETURN
      *
     C                   ENDSR
      *********************************************************************
      /EJECT
      *********************************************************************
**  CPY@
(c) Finastra International Limited 2004
