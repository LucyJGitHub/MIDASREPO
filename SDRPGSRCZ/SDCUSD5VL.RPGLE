     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Customer Details Private Banking Valid')      *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Details Module.                             *
      *                                                               *
      *  SDCUSD5VL - Private Banking Customer Details Validation     *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. HUT113             Date 01Apr20               *
      *  Prev Amend No. MD040876           Date 13Sep16               *
      *                 MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CGL031             Date 05Jul04               *
      * Midas Release 4.01 -------------------------------------------*
      *                 197191             Date 22Aug01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CPB002             Date 13Dec99               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                   CAP034  *CREATE  Date 01Sep99               *
      *                                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *  HUT113 - Full PB Functionality in FM                         *
      *           (Upgrade HUT026 to FM2.1 SP22)                      *
      *           Addition of hook HUT113_113                         *
      *  MD040876 - CRS MQ (Recompile)                                *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGL031 - Taxation on Savings Income                          *
      *  197191 - Review behaviour of fields Valid Counterparty and   *
      *           Requested PB Customer                               *
      *  CPB002 - New Private Banking Customer Processing.            *
      *  CAP034 - Conversion of SD inputs into modular structure      *
      *           for use as APIs.                                    *
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

      * Hook to enable non-core files to be included
      /COPY WNCPYSRC,SDCUDRV001

      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------

      **--------------------------------------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **--------------------------------------------------------------------------------------------

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **--------------------------------------------------------------------------------------------

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the size
      ** of the arrays.
     D/COPY ZACPYSRC,ERR_XARRYS
      **--------------------------------------------------------------------------------------------

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

     D CuPriv        E DS                  EXTNAME(SDCUPBPD)
      ** Private Banking Customer Details in screen format

     D OKCuPriv      E DS                  EXTNAME(SDECUPBPD)
      ** Private Banking Customer Details OK Indicators

     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for Bank Details

     D DSFDY         E DS                  EXTNAME(DSFDY)
      **  Short DS for access programs

     D DSSDY         E DS                  EXTNAME(DSSDY)
      **  Long DS for access programs

     D ValidPriv     E DS                  EXTNAME(SDVCUPBPD)
      ** Valid Private Banking Customer Details Layout

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      ** Index for arrays of of error message ids etc
     D Idx             S              3P 0
      *                                                                                       CGL031
      ** Input Parameter                                                                      CGL031
     D DDCUSN          S              6A                                                      CGL031

      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+

      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      /COPY WNCPYSRC,SDCUDRV002

      *****************************************************************
      /EJECT
      *****************************************************************

      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *inzsr is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+


      /COPY WNCPYSRC,SDCUDRV003

      * Call Validation Modules in Sequence
      *
      ** Validate Hold Mail Indicator
      *
      /COPY WNCPYSRC,SDCUDRV004
     C                   EXSR      VCHOLD
      /COPY WNCPYSRC,SDCUDRV005
      *
      *
      ** Validate Numbered Account Indicator
      *
      /COPY WNCPYSRC,SDCUDRV006
     C                   EXSR      VCNUAC
      /COPY WNCPYSRC,SDCUDRV007
      *
      ** Validate Agent
      *
      /COPY WNCPYSRC,SDCUDRV008
     C                   EXSR      VCAGEN
      /COPY WNCPYSRC,SDCUDRV009
      *
      *
      ** Validate Valid Counterparty
      *
      /COPY WNCPYSRC,SDCUDRV010
     C                   EXSR      VCCOUN
      /COPY WNCPYSRC,SDCUDRV011
      *
      *
      ** Validate Requested PB Customer
      *
      /COPY WNCPYSRC,SDCUDRV012
     C                   EXSR      VCREPB
      /COPY WNCPYSRC,SDCUDRV013
      *
      *
      ** Validate Private Banking Start Date
      *
      /COPY WNCPYSRC,SDCUDRV014
     C                   EXSR      VCPBST
      /COPY WNCPYSRC,SDCUDRV015

     C                   RETURN

      * Hook to enable non-core subroutines to be included
      /COPY WNCPYSRC,SDCUDRV016

      *****************************************************************
     C/EJECT
      *****************************************************************
      ** Validate Hold Mail Indicator
      *****************************************************************
     C     VCHOLD        BEGSR

      * Reset variables updated by each module

     C                   EXSR      RESETERRS
      *
      ** Call Validation Module
      *
     C                   CALLB     'SDVCSMC02'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeIn
      *
      ** Other parms
      *
      ** Private Banking Hold Mail Indicator
     C     PBHOLD        PARM                    DDHOLD
      *
      ** Private Banking Customer
     C                   PARM                    BBPRBA
      *
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Valid Hold Mail Indicator - OK
     C                   PARM                    DDHOLDOK


      * Update error info with that returned from the validation module

     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** Validate Numbered Account Indicator
      *****************************************************************
     C     VCNUAC        BEGSR

      * Reset variables updated by each module

     C                   EXSR      RESETERRS
      *
      ** Call Validation Module
      *
     C                   CALLB     'SDVACIN'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeIn
      *
      ** Other parms
      *
      ** Numbered Account Indicator
     C     PBNUAC        PARM                    DDNUAC
      *
      ** Private Banking Customer
     C                   PARM                    BBPRBA
      *
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Numbered Account Indicator - OK
     C                   PARM                    DDNUACOK
      *

      * Update error info with that returned from the validation module

     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** Validate Agent
      *****************************************************************
     C     VCAGEN        BEGSR

      * Reset variables updated by each module

     C                   EXSR      RESETERRS
      *
      ** Call Validation Module
      *
     C                   CALLB     'SDVCSMC01'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeIn
      *
      ** Other parms
      *
      ** Private Banking Agent - alpha
     C                   PARM                    DDAGEN
      *
      ** Private Banking Customer
     C                   PARM                    BBPRBA
      *
      *
      * OUTPUTS
      *
      ** Private Banking Agent - numeric
     C                   PARM                    PBAGEN
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Private Banking Aent - OK
     C                   PARM                    DDAGENOK
      *

      * Update error info with that returned from the validation module

     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** Validate Valid Counterparty
      *****************************************************************
     C     VCCOUN        BEGSR

      * Reset variables updated by each module

     C                   EXSR      RESETERRS
      *
      ** Call Validation Module
      *
     C                   CALLB     'SDVPBCP'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeIn
      *
      ** Other parms
      *
      ** Private Banking Valid Counterparty
     C     PBCOUN        PARM                    DDCOUN
      *
      ** Private Banking Customer
     C                   PARM                    BBPRBA
      *
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Valid Counterparty Indicator - OK
     C                   PARM                    DDCOUNOK
      *

      * Update error info with that returned from the validation module

     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** Validate Requested Private Banking Customer
      *****************************************************************
     C     VCREPB        BEGSR

      * Reset variables updated by validation

     C                   EXSR      RESETERRS
      *
      ** Call Validation Module
      *
     C                   CALLB     'SDVPBCS'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeIn
      *
      ** Other parms
      *
      ** Private Banking Requested Customer
     C     PBREPB        PARM                    DDREPB
      *
      ** Private Banking Customer
     C                   PARM                    BBPRBA
      *                                                                         CPB002
      ** Portfolio Management Customer Indicator                                CPB002
     C                   PARM                    PtfrCust                       CPB002
      *                                                                         CPB002
      ** Account Officer                                                        CPB002
     C                   PARM                    DDACOC                         CPB002
      *                                                                         197191
      ** Valid Counterparty                                                     197191
     C                   PARM                    DDCOUN                         197191
                                                                                              CGL031
      ** Customer Number                                                                      CGL031
     C                   PARM                    DDCUSN                                       CGL031
      *
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Private Banking Requested Customer - OK
     C                   PARM                    DDREPBOK
      *
      *
      * Update error info with that returned from validation

     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** Validate Private Banking Start Date
      *****************************************************************
     C     VCPBST        BEGSR

      * Reset variables updated by each module

     C                   EXSR      RESETERRS
      *
      ** Call Validation Module
      *
     C                   CALLB     'SDVCSDT'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeIn
      *
      ** Other parms
      *
      ** Private Banking Start Date - alpha
     C                   PARM                    DDPBST
      *
      /COPY WNCPYSRC,HUT113_113                                                          HUT113
      *
      ** MIDAS date format indicator
     C                   PARM                    BJDFIN
      *
      * OUTPUTS
      *
      ** Private Banking Start Date - numeric
     C                   PARM                    PBPBST
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Valid Counterparty Indicator - OK
     C                   PARM                    DDPBSTOK
      *

      * Update error info with that returned from the validation module

     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      * RESETERRS - Reset error information that is received back     *
      *    from each validation module.                               *
      *****************************************************************
     C     RESETERRS     BEGSR

     C                   EVAL      RetCodeOut = *Blanks
      *
      * Reset error & warning fields/message IDs/message data (arrays)
     C                   MOVEL     *BLANK        FldNamXAr
     C                   MOVEL     *BLANK        MsgIDXAr
     C                   MOVEL     *BLANK        MsgDtaXAr

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * UPDATERRS - Update error information with that received back  *
      *    from each validation module.                               *
      *****************************************************************
     C     UPDATERRS     BEGSR
      *
      * Update error fields/message IDs/message data (arrays)
      *
     C                   Z-ADD     1             I                 3 0
     C     *BLANK        LOOKUP    FldNameArr(I)                          99
     C     *IN99         IFEQ      '1'
     C                   MOVEA     FldNamXAr     FldNameArr(I)
     C                   MOVEA     MsgIDXAr      MsgIdArr(I)
     C                   MOVEA     MsgDtaXAr     MsgDtaArr(I)
     C                   END
      *
      * Set Error Index
     C                   Z-ADD     1             I
     C     *BLANK        LOOKUP    FldNameArr(I)                          99
     C     I             SUB       1             Idx
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *inzsr - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
     C     *inzsr        BEGSR

     C     *entry        PLIST

      * INPUTS

      * Response mode
     C                   PARM                    RespMode          1
      *
      ** Private Banking Customer Indicator
     C                   PARM                    BBPRBA            1
      *
      ** Customer Private Banking Details
     C                   PARM                    CuPriv
      *                                                                         CPB002
      ** Portfolio Management Customer Indicator                                CPB002
     C                   PARM                    PtfrCust          1            CPB002
      *                                                                         CPB002
      ** Account Officer                                                        CPB002
     C                   PARM                    DDACOC            2            CPB002
                                                                                              CGL031
      ** Customer Number                                                                      CGL031
     C                   PARM                    DDCUSN                                       CGL031
      *
      * OUTPUTS
      *
      ** Customer Private Banking Details OK inds
     C                   PARM                    OKCuPriv

      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    Idx

      * Valid Private Banking layout (DS) from/to caller
     C                   PARM                    ValidPriv

      *
      ** ACCESS BANK DETAILS
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     '901'         DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   END
      *
      *
      **--------------------------------------------------------------------------------------------
      ** The following /COPY sets the values of program, module and
      ** procedure names for database error processing.
     C/COPY ZACPYSRC,DBFIELDS
      **--------------------------------------------------------------------------------------------

      *  Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,SDCUDRV017

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRERR - EXCEPTION ERRORS                                      *
      *                                                               *
      *****************************************************************
     C     SRERR         BEGSR
      *
     C                   MOVEL     'SETRADSVAL'  DBPGM
     C                   MOVE      '1'           *INU7
     C                   MOVE      '1'           *INU8
     C                   MOVE      '1'           *INLR
     C                   DUMP
      *
      **  Terminate the program
      *
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      **--------------------------------------------------------------------------------------------
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILE
      **--------------------------------------------------------------------------------------------
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
