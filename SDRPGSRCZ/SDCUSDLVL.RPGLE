     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2007')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Customer Marketing Information Validation')            *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  SDCUSDLVL - Customer Marketing Information Validation        *
      *                                                               *
      *  (c) Finastra International Limited 2007                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CSD090             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 CSD079  *CREATE    Date 05Feb07               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD090 - Customer Segmentation                               *
      *  CSD079 - Enhanced Customer Maintenance API                   *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      * Hook to enable non-core files to be included
      /COPY WNCPYSRC,SDCUMIV001
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **------------------------------------------------------------------
 
      **------------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **------------------------------------------------------------------
 
      **------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **------------------------------------------------------------------
 
      **------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **------------------------------------------------------------------
 
      **------------------------------------------------------------------
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the size
      ** of the arrays.
     D/COPY ZACPYSRC,ERR_XARRYS
      **------------------------------------------------------------------
 
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
 
      ** Transaction Details in screen format
     D TrnDets       E DS                  EXTNAME(SDCUMIPD)
 
      ** Transaction Details OK indicators
     D OKTrnDets     E DS                  EXTNAME(SDECUMIPD)
 
      ** Valid Transaction Details layout
     D ValidCumi     E DS                  EXTNAME(SDVCUMIPD)
 
      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** External DS for SAR details                                                          CSD090
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CSD090
                                                                                              CSD090
      ** Short DS for access programs
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Long DS for access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
     D ZMUSER          DS            17
     D  USRBCH                11     13
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Work fields for bank data
     D WKDFIN          S                   LIKE(BJDFIN)
     D WKRDNB          S                   LIKE(BJRDNB)
     D WKCYCD          S                   LIKE(BJCYCD)
 
      ** Index for arrays of of error message ids etc
     D Idx             S              3P 0
 
      ** Index for arrays of of warning message ids etc
     D WIdx            S              3P 0
 
      ** Work variables
     D I               S              3P 0
     D RespMode        S              1
     D PRTCD           S              7
     D POPTN           S              7
     D PSARD           S              6A                                                      CSD090
     D CSD090          S              1A                                                      CSD090
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      /COPY WNCPYSRC,SDCUMIV002
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *inzsr is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
 
      /COPY WNCPYSRC,SDCUMIV003
 
      ** Validate Group 1
 
      /COPY WNCPYSRC,SDCUMIV004
     C                   EXSR      VGPC1SR
      /COPY WNCPYSRC,SDCUMIV005
 
      ** Validate Group 2
 
      /COPY WNCPYSRC,SDCUMIV006
     C                   EXSR      VGPC2SR
      /COPY WNCPYSRC,SDCUMIV007
 
      ** Validate Group 3
 
      /COPY WNCPYSRC,SDCUMIV008
     C                   EXSR      VGPC3SR
      /COPY WNCPYSRC,SDCUMIV009
 
      ** Validate Group 4
 
      /COPY WNCPYSRC,SDCUMIV010
     C                   EXSR      VGPC4SR
      /COPY WNCPYSRC,SDCUMIV011
 
      ** Validate Group 5
 
      /COPY WNCPYSRC,SDCUMIV012
     C                   EXSR      VGPC5SR
      /COPY WNCPYSRC,SDCUMIV013
 
      ** Validate Customer Segmentation Code                                                  CSD090
                                                                                              CSD090
     C                   IF        CSD090 = 'Y'                                               CSD090
     C                   EXSR      VCSEG01SR                                                  CSD090
     C                   ENDIF                                                                CSD090
                                                                                              CSD090
     C                   RETURN
 
      ** Hook to enable non-core subroutines to be included
      /COPY WNCPYSRC,SDCUMIV014
 
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  VGPC1SR - Validate Group 1                                   *
      *                                                               *
      *****************************************************************
 
     C     VGPC1SR       BEGSR
 
      ** Reset variables updated by validation
 
     C                   EXSR      RESETERRS
 
      ** Validate Group 1
 
     C                   CALLB     'SDVGPC1'
 
      ** Inputs
      ** Return Code
 
     C                   PARM                    RetCodeIn
 
      ** Other parms
      ** Group 1
 
     C                   PARM                    DDGPC1
 
      ** Outputs
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Group 1       - OK
 
     C                   PARM                    DDGPC1OK
 
      ** Update error info with that returned from the validation
      ** module
 
     C                   EXSR      UPDATERRS
 
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  VGPC2SR - Validate Group 2                                   *
      *                                                               *
      *****************************************************************
 
     C     VGPC2SR       BEGSR
 
      ** Reset variables updated by validation
 
     C                   EXSR      RESETERRS
 
      ** Validate Group 2
 
     C                   CALLB     'SDVGPC2'
 
      ** Inputs
      ** Return Code
 
     C                   PARM                    RetCodeIn
 
      ** Other parms
      ** Group 2
 
     C                   PARM                    DDGPC2
 
      ** Outputs
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Group 2       - OK
 
     C                   PARM                    DDGPC2OK
 
      ** Update error info with that returned from the validation
      ** module
 
     C                   EXSR      UPDATERRS
 
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  VGPC3SR - Validate Group 3                                   *
      *                                                               *
      *****************************************************************
 
     C     VGPC3SR       BEGSR
 
      ** Reset variables updated by validation
 
     C                   EXSR      RESETERRS
 
      ** Validate Group 3
 
     C                   CALLB     'SDVGPC3'
 
      ** Inputs
      ** Return Code
 
     C                   PARM                    RetCodeIn
 
      ** Other parms
      ** Group 3
 
     C                   PARM                    DDGPC3
 
      ** Outputs
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Group 3       - OK
 
     C                   PARM                    DDGPC3OK
 
      ** Update error info with that returned from the validation
      ** module
 
     C                   EXSR      UPDATERRS
 
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  VGPC4SR - Validate Group 4                                   *
      *                                                               *
      *****************************************************************
 
     C     VGPC4SR       BEGSR
 
      ** Reset variables updated by validation
 
     C                   EXSR      RESETERRS
 
      ** Validate Group 4
 
     C                   CALLB     'SDVGPC4'
 
      ** Inputs
      ** Return Code
 
     C                   PARM                    RetCodeIn
 
      ** Other parms
      ** Group 4
 
     C                   PARM                    DDGPC4
 
      ** Outputs
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Group 4       - OK
 
     C                   PARM                    DDGPC4OK
 
      ** Update error info with that returned from the validation
      ** module
 
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  VGPC5SR - Validate Group 5                                   *
      *                                                               *
      *****************************************************************
 
     C     VGPC5SR       BEGSR
 
      ** Reset variables updated by validation
 
     C                   EXSR      RESETERRS
 
      ** Validate Group 5
 
     C                   CALLB     'SDVGPC5'
 
      ** Inputs
      ** Return Code
 
     C                   PARM                    RetCodeIn
 
      ** Other parms
      ** Group 5
 
     C                   PARM                    DDGPC5
 
      ** Outputs
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Group 5       - OK
 
     C                   PARM                    DDGPC5OK
 
      ** Update error info with that returned from the validation
      ** module
 
     C                   EXSR      UPDATERRS
 
     C                   ENDSR
 
      *****************************************************************                       CSD090
      /EJECT                                                                                  CSD090
      *****************************************************************                       CSD090
      *                                                               *                       CSD090
      *  VCSEG01SR - Validate Customer Segmentation Code              *                       CSD090
      *                                                               *                       CSD090
      *****************************************************************                       CSD090
                                                                                              CSD090
     C     VCSEG01SR     BEGSR                                                                CSD090
                                                                                              CSD090
      ** Reset variables updated by validation                                                CSD090
                                                                                              CSD090
     C                   EXSR      RESETERRS                                                  CSD090
                                                                                              CSD090
      ** Validate Customer Segmentation Code                                                  CSD090
                                                                                              CSD090
     C                   CALLB     'SDVCSEG01'                                                CSD090
                                                                                              CSD090
      ** Inputs                                                                               CSD090
      ** Return Code                                                                          CSD090
                                                                                              CSD090
     C                   PARM                    RetCodeIn                                    CSD090
                                                                                              CSD090
      ** Customer Segmentation Code                                                           CSD090
                                                                                              CSD090
     C                   PARM                    DDCSDE                                       CSD090
                                                                                              CSD090
      ** OUTPUTS                                                                              CSD090
                                                                                              CSD090
      ** Warning fields/message IDs/message data (arrays) from/to caller                      CSD090
                                                                                              CSD090
     C                   PARM                    FldNamXAr                                    CSD090
     C                   PARM                    MsgIDXAr                                     CSD090
     C                   PARM                    MsgDtaXAr                                    CSD090
     C                   PARM                    WFldNmXAr                                    CSD090
     C                   PARM                    WMsgIDXAr                                    CSD090
     C                   PARM                    WMsgDtXAr                                    CSD090
                                                                                              CSD090
      ** Customer Segmentation Code - Ok Flag                                                 CSD090
                                                                                              CSD090
     C                   PARM                    DDCSDEOK                                     CSD090
                                                                                              CSD090
      ** Update error info with that returned from the validation                             CSD090
      ** module                                                                               CSD090
                                                                                              CSD090
     C                   EXSR      UPDATERRS                                                  CSD090
                                                                                              CSD090
     C                   ENDSR                                                                CSD090
                                                                                              CSD090
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      * RESETERRS - Reset error information that is received back     *
      *    from each validation module.                               *
      *                                                               *
      *****************************************************************
     C     RESETERRS     BEGSR
 
     C                   EVAL      RetCodeOut = *Blanks
 
      ** Reset error & warning fields/message IDs/message data (arrays)
 
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
      * UPDATERRS - Update error information with that received back  *
      *    from each validation module.                               *
      *                                                               *
      *****************************************************************
     C     UPDATERRS     BEGSR
 
      ** Update error fields/message IDs/message data (arrays)
 
     C                   Z-ADD     1             I
     C     *BLANK        LOOKUP    FldNameArr(I)                          99
     C                   IF        *IN99 = *ON
     C                   MOVEA     FldNamXAr     FlDNameArr(I)
     C                   MOVEA     MsgIDXAr      MsgIdArr(I)
     C                   MOVEA     MsgDtaXAr     MsgDtaArr(I)
     C                   ENDIF
 
      ** Set Error Index
 
     C                   Z-ADD     1             I
     C     *BLANK        LOOKUP    FldNameArr(I)                          99
     C     I             SUB       1             Idx
 
      ** Update warning fields/message IDs/message data (arrays)
 
     C                   Z-ADD     1             I
     C     *BLANK        LOOKUP    WFldNamArr(I)                          99
     C                   IF        *IN99 = *ON
     C                   MOVEA     WFldNmXAr     WFldNamArr(I)
     C                   MOVEA     WMsgIDXAr     WMsgIDArr(I)
     C                   MOVEA     WMsgDtXAr     WMsgDtaArr(I)
     C                   ENDIF
 
      ** Set Warning Index
 
     C                   Z-ADD     1             I
     C     *BLANK        LOOKUP    WFldNamArr(I)                          99
     C     I             SUB       1             WIdx
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
 
      ** Inputs
      ** Response mode
 
     C                   PARM                    RespMode
 
      ** Marketing Information Details
 
     C                   PARM                    TrnDets
 
      ** Outputs
      ** Marketing Information OK inds
 
     C                   PARM                    OKTrnDets
 
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
 
      ** Array index (3P0) from/to caller
 
     C                   PARM                    Idx
 
      ** Warning fields/message IDs/message data (arrays) from/to
      ** caller
 
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
 
      ** Array index (3P0) from/to caller
 
     C                   PARM                    WIdx
 
      ** Valid Marketing Information layout (DS) from/to caller
 
     C                   PARM                    ValidCUMI
 
      ** Access Bank Details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database Error
 
     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE  = 900
     C                   EVAL      DBKEY  = POPTN
     C                   EXSR      *PSSR
     C                   ELSE
     C                   EVAL      WKDFIN = BJDFIN
     C                   EVAL      WKRDNB = BJRDNB
     C                   EVAL      WKCYCD = BJCYCD
     C                   ENDIF
                                                                                              CSD090
     C                   EVAL      CSD090 = 'N'                                               CSD090
     C                   CALL      'AOSARDR0'                                                 CSD090
     C                   PARM      *BLANKS       PRTCD                                        CSD090
     C                   PARM      '*VERIFY'     POPTN                                        CSD090
     C                   PARM      'CSD090'      PSARD                                        CSD090
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD090
                                                                                              CSD090
      ** Database Error                                                                       CSD090
                                                                                              CSD090
     C                   IF        PRTCD <> *BLANKS AND                                       CSD090
     C                             PRTCD <> '*NRF   '                                         CSD090
     C                   EVAL      DBKEY  = 'CSD090'                                          CSD090
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSD090
     C                   EVAL      DBASE  = 911                                               CSD090
     C                   EXSR      *PSSR                                                      CSD090
     C                   ENDIF                                                                CSD090
                                                                                              CSD090
     C                   IF        PRTCD = *BLANKS                                            CSD090
     C                   EVAL      CSD090 = 'Y'                                               CSD090
     C                   ENDIF                                                                CSD090
                                                                                              CSD090
      *
      *
      **------------------------------------------------------------------
      ** The following /COPY sets the values of program, module and
      ** procedure names for database error processing.
     C/COPY ZACPYSRC,DBFIELDS
      **------------------------------------------------------------------
 
      *  Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,SDCUMIV015
 
     C                   ENDSR
      ********************************************************************
      /EJECT
      ********************************************************************
      **------------------------------------------------------------------
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILE
      **------------------------------------------------------------------
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2007
