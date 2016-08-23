     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2013')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Document Management - Validation')            *
      *****************************************************************
      *                                                               *
      *  Midas - Standing data Module                                 *
      *                                                               *
      *  SDDCMTVAL - SD Document Management Validation                *
      *                                                               *
      *  Function: This Program Validates Document Codes Input into   *
      *            the Midas database.                                *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2013            *
      *                                                               *
      *  Last Amend No. CSD093 *CREATE     Date 01Apr13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD093 - Document Management                                 *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *****************************************************************
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
      ** The following /COPY line includes definitions for the above fields
      ** as #ProcPgm, #ProcMod and #ProcName.  They are based on the
      ** corresponding fields in the PSDS /COPY member, so that member
      ** must be included where this one is used.
 
     D/COPY ZACPYSRC,PROCPARMS
 
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
 
      * Incoming Doc mgt in screen format
     D DocMgtScIn    E DS                  EXTNAME(SDDCMSPD)
 
      * Valid Doc Mgt Layout
     D ValdDocMgt    E DS                  EXTNAME(SDVDCMTPD)
 
      ** EXTERNAL DS FOR Document Management DETAILS
     D SDDCMT        E DS                  EXTNAME(SDDCMTPD)
 
      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** External DS for MIdas Modules Details
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
 
      ** First DS for Access Programs, Short Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Second DS for Access Programs, Long Data Structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** 24X7 status data area
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)
 
      ** SD data area
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)
 
     D ZMUSER          DS            17
     D  BRC                   11     13
     D  DEPT                  14     16
 
      ** External DS for Market Data Feeds ICD
     D SDMDFC        E DS                  EXTNAME(SDMDFCPD)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
 
      ** Index for arrays of of error message ids etc
     D Idx             S              3P 0
     D Ix              S              3P 0
 
      ** Index for arrays of of warning message ids etc
     D WIdx            S              3P 0
 
      ** Flags to indicate whether Doc Mgt fields are valid
     D OKFlagsDS     E DS                  EXTNAME(SDEDCMTPD)
 
      ** A code to indicate the calling function to the lower level modules
     D DCMT            S              4A   INZ('DCMT')
 
      ** Response Mode, received as a parameter from the common header
     D RespMode        S              1A
 
      * Switchable features
     D CSD006F         S              1A
     D CSW005          S              1A
     D CSW011          S              1A
     D CSW200          S              1A
 
      ** Time stamp field in file format, defaulted if necessary
     D JDFTS           S             14  0
 
     D CSC011          S              1A
     D PRtCd           S              7A
     D POptn           S              7A
     D WRunDay         S                   LIKE(BJRDNB)
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
 
      *****************************************************************
      /EJECT
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      ** Call Validation Modules in Sequence
 
      ** Validate Doc Mgt Status
     C                   EXSR      VDocStat
      *
      ** Validate Issuing Country
     C                   EXSR      VIsCtry
      *
      ** Validate Issuing Date
     C                   EXSR      VIssDat
 
      ** Validate Expiry Date
     C                   EXSR      VExpDat
 
      ** Validate Requested Date
     C                   EXSR      VReqDat
      *
      ** Validate Received Date
     C                   EXSR      VRcvDat
      *
      ** Validate Rejected Date
     C                   EXSR      VRejcDt
      *
      ** Validate Required by Date
     C                   EXSR      VRqByDt
      *
 
      *  *-------------------------------------------------------*
      *  * If no errors set up outstanding fields for valid file *
      *  *-------------------------------------------------------*
 
     C                   IF        Idx = 0
     C                   EXSR      SetupValid
     C                   ENDIF
 
      * RETURN
      *
     C                   RETURN
      *****************************************************************
     C/EJECT
 
      * Hook to enable non-core subroutines to be included
 
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VDocStat - Validate base rate name
      *****************************************************************
     C     VDocStat      BEGSR
 
      * Reset variables updated by each module
 
     C                   EXSR      RESETERRS
      *
     C                   IF        DDSTCD <> 'A'
     C                             AND DDSTCD <> 'C'
     C                             AND DDSTCD <> 'O'
     C                             AND DDSTCD <> 'R'
     C                             AND DDSTCD <> 'Z'
     C                   ADD       1             Ix
     C                   EVAL      FldNamXAr(Ix) = 'DDSTCD'
     C                   EVAL      MsgIDXAr(Ix) = 'USS0404'
     C                   EVAL      DDSTCDOK  = 'N'
     C                   ELSE
     C                   EVAL      DVSTCD = DDSTCD
     C                   ENDIF
 
      ** Update error info with that returned from the validation module
 
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  VIsCtry  - Validate Issuing Country                          *
      *                                                               *
      *****************************************************************
     C     VIsCtry       BEGSR
 
      ** Reset variables updated by each subroutine
 
     C                   EXSR      RESETERRS
 
      ** Validate Issuing Country
 
     C                   CALLB     'SDVISCT'
 
      ** INPUTS
      ** Return Code
     C                   PARM                    RetCodeOut
 
      ** Issueing Date
     C                   PARM                    DDISCT
 
      ** OUTPUTS
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Issuing Date - OK
     C                   PARM                    DDISCTOK          1
     C                   PARM                    DVISCT
 
      * Update error info with that returned from the validation module
 
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  VIssDat  - Validate Issuing Date                             *
      *                                                               *
      *****************************************************************
     C     VIssDat       BEGSR
 
      * Reset variables updated by each subroutine
 
     C                   EXSR      RESETERRS
 
      ** Validate Issuing Date
 
     C                   CALLB     'SDVISDT'
 
      ** INPUTS
      ** Return Code
     C                   PARM                    RetCodeOut
 
      ** Issueing Date
     C                   PARM                    DDISDT
     C                   PARM                    BJRDNB
     C                   PARM                    BJDFIN
 
      ** OUTPUTS
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Issuing Date - OK
     C                   PARM                    DDISDTOK          1
     C                   PARM                    DVISDT
 
      * Update error info with that returned from the validation module
 
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  VReqDat  - Validate Requested Date                           *
      *                                                               *
      *****************************************************************
     C     VReqDat       BEGSR
 
      ** Reset variables updated by each subroutine
 
     C                   EXSR      RESETERRS
 
      ** Validate Requested Date
 
     C                   CALLB     'SDVRQDT'
 
      ** INPUTS
      ** Return Code
     C                   PARM                    RetCodeOut
 
      ** Requested Date
     C                   PARM                    DDRQDT
      ** Document Status Code
     C                   PARM                    DVSTCD
     C                   PARM                    BJRDNB
     C                   PARM                    BJDFIN
 
      ** OUTPUTS
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Requested Date - OK
     C                   PARM                    DDRQDTOK          1
     C                   PARM                    DVRQDT
 
      * Update error info with that returned from the validation module
 
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  VRcvDat  - Validate Received Date                            *
      *                                                               *
      *****************************************************************
     C     VRcvDat       BEGSR
 
      ** Reset variables updated by each subroutine
 
     C                   EXSR      RESETERRS
 
      ** Validate Received Date
 
     C                   CALLB     'SDVRCDT'
 
      ** INPUTS
      ** Return Code
     C                   PARM                    RetCodeOut
 
      ** Requested Date
     C                   PARM                    DDRCDT
 
      ** Document Status Code
     C                   PARM                    DVSTCD
     C                   PARM                    BJRDNB
     C                   PARM                    BJDFIN
 
      ** OUTPUTS
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Received Date - OK
     C                   PARM                    DDRCDTOK          1
     C                   PARM                    DVRCDT
 
      * Update error info with that returned from the validation module
 
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  VRejcDt  - Validate Rejected Date
      *                                                               *
      *****************************************************************
     C     VRejcDt       BEGSR
 
      ** Reset variables updated by each subroutine
 
     C                   EXSR      RESETERRS
 
      ** Validate Rejected Date
 
     C                   CALLB     'SDVREJC'
 
      ** INPUTS
      ** Return Code
     C                   PARM                    RetCodeOut
 
      ** Rejected Date
     C                   PARM                    DDREJC
     C                   PARM                    DVSTCD
     C                   PARM                    BJRDNB
     C                   PARM                    BJDFIN
 
      ** OUTPUTS
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Rejected Date - OK
     C                   PARM                    DDREJCOK          1
     C                   PARM                    DVREJC
 
      ** Update error info with that returned from the validation module
 
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  VRqByDt  - Validate Required by Date                         *
      *                                                               *
      *****************************************************************
     C     VRqByDt       BEGSR
 
      ** Reset variables updated by each subroutine
 
     C                   EXSR      RESETERRS
 
      ** Validate Required bu Date
 
     C                   CALLB     'SDVREQB'
 
      ** INPUTS
      ** Return Code
     C                   PARM                    RetCodeOut
 
      ** Required by Date
     C                   PARM                    DDREQB
     C                   PARM                    BJRDNB
     C                   PARM                    BJDFIN
 
      ** OUTPUTS
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Required by Date - OK
     C                   PARM                    DDREQBOK          1
     C                   PARM                    DVREQB
 
      * Update error info with that returned from the validation module
 
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  VExpDat  - Validate Expiry Date                              *
      *                                                               *
      *****************************************************************
     C     VExpDat       BEGSR
 
      ** Reset variables updated by each subroutine
 
     C                   EXSR      RESETERRS
 
      ** Validate Requested Date
 
     C                   CALLB     'SDDVEXDT'
 
      ** INPUTS
      ** Return Code
     C                   PARM                    RetCodeOut
 
      ** Expiry Date
     C                   PARM                    DDEXDT
     C                   PARM                    DVISDT
     C                   PARM                    BJRDNB
     C                   PARM                    BJDFIN
 
      ** OUTPUTS
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Expiry Date - OK
     C                   PARM                    DDEXDTOK          1
     C                   PARM                    DVEXDT
 
      * Update error info with that returned from the validation module
 
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SETUPVALID - Set up additional fields that are needed on the *
      *   Valid file record.                                          *
      *                                                               *
      *****************************************************************
 
     C     SETUPVALID    BEGSR
 
      ** Other DVxxxx fields are set up during the individual data
      **  validation, such as the ones where the input & database formats
      **  are different, e.g. dates, amounts.
      ** This SR sets up the fields with the same (or compatible) attributes
 
      ** Document Code
     C                   EVAL      DVREFN = DDREFN
     C                   EVAL      DVRTYP = DDRTYP
     C                   EVAL      DVCODE = DDCODE
     C                   EVAL      DVDREF = DDDREF
      *
      ** Document Management Comments
     C                   EVAL      DVCOMM = DDCOM1 + DDCOM2
     C                                    + DDCOM3 + DDCOM4
 
     C                   EVAL      DVIMGE = DDIMGE
      *
      ** Last Change Date
     C                   Z-ADD     BJRDNB        DVLCDT
      ** Last Change type
     C                   EVAL      DVLTYP = DDACTN
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation routine                      *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
      * Response mode (1A), from source system common header
     C                   PARM                    RespMode
      * Transaction information (DS) from source system
     C                   PARM                    DocMgtScIn
      * Field OK flags (DS) from/to caller
     C                   PARM                    OKFlagsDS
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      ** Array index (3P0) from/to caller
     C                   PARM                    Idx
      ** Valid Doc Mgt (DS) from/to caller
     C                   PARM                    ValdDocMgt
      ** Array index (3P0) from/to caller
     C                   PARM                    WIdx
      ** Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
      *
      **  GET ZMUSER to access default branch.
      *
     C     *DTAARA       DEFINE                  ZMUSER
     C                   IN        ZMUSER
     C                   UNLOCK    ZMUSER
      *
      **  Move program name into *LDA field.
      *
     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM = 'SDDCMTVAL'
     C                   OUT       LDA
      *
      ** Access Bank details via access program
      *  (database error handling done in access program)
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR '     PRTCD             7
     C                   PARM      '*FIRST '     POPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Set up the name of the MSGF from which the message handler will
      ** get the messages
     C                   EVAL      #MsgFile = 'SDUSRMSG'
      *
      ** ACCESS MIDAS MODULE DETAILS
      *
     C                   CALL      'AOMMODR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDMMOD        PARM      SDMMOD        DSFDY
      *
      ** DATABASE ERROR
      *
     C     PRTCD         IFNE      *BLANK
     C                   EVAL      DBKEY  = POPTN
     C                   EVAL      DBFILE = 'SDMMODPD'
     C                   EVAL      DBASE  = 001
     C                   EXSR      *PSSR
     C                   END
      *
 
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  RESETERRS - Reset error information that is received back    *
      *    from each validation module.                               *
      *                                                               *
      *****************************************************************
 
     C     RESETERRS     BEGSR
 
     C                   EVAL      RetCodeOut = *Blanks
     C                   EVAL      Ix = *ZERO
      *
      * Reset error & warning fields/message IDs/message data (arrays)
     C                   EVAL      FldNamXAr = *BLANK
     C                   EVAL      MsgIDXAr  = *BLANK
     C                   EVAL      MsgDtaXAr = *BLANK
     C                   EVAL      WFldNmXAr = *BLANK
     C                   EVAL      WMsgIDXAr = *BLANK
     C                   EVAL      WMsgDtXAr = *BLANK
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  UPDATERRS - Update error information with that received back *
      *    from each validation module.                               *
      *                                                               *
      *****************************************************************
 
     C     UPDATERRS     BEGSR
      *
      ** Update error fields/message IDs/message data (arrays)
      *
     C                   Z-ADD     1             I                 3 0
     C     *BLANK        LOOKUP    FldNameArr(I)                          99
     C     *IN99         IFEQ      '1'
     C                   MOVEA     FldNamXAr     FlDNameArr(I)
     C                   MOVEA     MsgIDXAr      MsgIdArr(I)
     C                   MOVEA     MsgDtaXAr     MsgDtaArr(I)
     C                   END
      *
      ** Set Error Index
     C                   Z-ADD     1             I
     C     *BLANK        LOOKUP    FldNameArr(I)                          99
     C     I             SUB       1             Idx
      *
      ** Update warning fields/message IDs/message data (arrays)
      *
     C                   Z-ADD     1             I
     C     *BLANK        LOOKUP    WFldNamArr(I)                          99
     C     *IN99         IFEQ      '1'
     C                   MOVEA     WFldNmXAr     WFldNamArr(I)
     C                   MOVEA     WMsgIDXAr     WMsgIDArr(I)
     C                   MOVEA     WMsgDtXAr     WMsgDtaArr(I)
     C                   END
      *
      ** Set Warning Index
     C                   Z-ADD     1             I
     C     *BLANK        LOOKUP    WFldNamArr(I)                          99
     C     I             SUB       1             WIdx
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * #TERM - Termination processing.
      *****************************************************************
     C     #TERM         BEGSR
      *
      **  Terminate program
      *
     C                   EVAL      *INLR = '1'
      *
     C                   IF        *INU7 = '1'
     C                   DUMP
     C                   END
      *
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
      /EJECT
