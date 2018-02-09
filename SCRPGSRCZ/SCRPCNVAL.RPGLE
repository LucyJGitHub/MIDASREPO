     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SC Data Replication Configurator Validation')
      *****************************************************************
      *                                                               *
      *  Midas - System Control Module                                *
      *                                                               *
      *  SCRPCNVAL - Data Replication Validation Module               *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4.01 -------------------------------------------*
      *  Prev Amend No. CSC011  *CREATE    Date 18Sep01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSC011 - 24x7 Midas Availability                             *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Hook to enable non-core files to be included
      /COPY WNCPYSRC,SCRPCNV001
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
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
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** New Data Replication Details in Screen format
     D NwRepScnFmt   E DS                  EXTNAME(SCRPCNPD)
 
      ** Current Data Replication Details in Screen Format
     D CrRepScnFmt   E DS                  EXTNAME(SCRPCNPD)
     D                                     PREFIX(CR:2)
 
      ** Replication file definition in Screen format
     D NwRepFilFmt   E DS                  EXTNAME(SCFDTLPD)
 
      ** Replication file definition OK indicators
     D OKFlags       E DS                  EXTNAME(SCERPCNPD)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Entry parameters
     D Idx             S              3P 0
     D WIdx            S              3P 0
     D PReDsp          S              1A
 
     D I               S              3  0
 
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      /COPY WNCPYSRC,SCRPCNV002
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
      /COPY WNCPYSRC,SCRPCNV003
 
      ** Replication Select
 
      /COPY WNCPYSRC,SCRPCNV006
     C                   EXSR      SR_RepSelect
      /COPY WNCPYSRC,SCRPCNV007
 
      ** Physical File Name
 
      /COPY WNCPYSRC,SCRPCNV008
     C                   EXSR      SR_PFile
      /COPY WNCPYSRC,SCRPCNV009
 
      ** Batch Number
 
      /COPY WNCPYSRC,SCRPCNV014
     C                   EXSR      SR_BatchNum
      /COPY WNCPYSRC,SCRPCNV015
 
      ** Frequency of Update
 
      /COPY WNCPYSRC,SCRPCNV016
     C                   EXSR      SR_FreqUpd
      /COPY WNCPYSRC,SCRPCNV017
 
     C                   RETURN
 
      ** Hook to enable non-core subroutines to be included
      /COPY WNCPYSRC,SCRPCNV020
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SR_RepSelect - Validate Replication Select Routine           *
      *                                                               *
      *  Called by: Main Processing                                   *
      *                                                               *
      *  Calls:     SRResetErrs, SRUpdErrs                            *
      *                                                               *
      *****************************************************************
     C     SR_RepSelect  BEGSR
 
      ** Reset variables updated by validation
 
     C                   EXSR      SRReSetErrs
 
      ** Validate Replication Flag
 
     C                   CALLB     'SCVRPLF'
 
      ** Inputs
      ** Return Code
 
     C                   PARM                    RetCodeIn
 
      ** Field requiring validation: Replication Select
 
     C                   PARM                    #1RPLF
 
      ** Outputs
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Warning fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr
 
      ** Data Replication Error Indicators
 
     C                   PARM                    OKFlags
 
      ** Data Replication Details File Format
 
     C                   PARM                    NwRepFilFmt
 
      ** Update error info with that returned from the validation module
 
     C                   EXSR      SRUpdErrs
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SR_PFile - Validate Replication Select Flag                  *
      *                                                               *
      *  Called by: Main Processing                                   *
      *                                                               *
      *  Calls:     SRResetErrs, SRUpdErrs                            *
      *                                                               *
      *****************************************************************
     C     SR_PFile      BEGSR
 
      ** Reset variables updated by validation
 
     C                   EXSR      SRResetErrs
 
      ** Validate Physical File Name
 
     C                   CALLB     'SCVPHYF'
 
      ** INPUTS
      ** Return Code
 
     C                   PARM                    RetCodeIn
 
      ** Field requiring validation: Physical File to be Replicated
 
     C                   PARM                    #1PHYF
 
      ** Action Code
 
     C                   PARM                    #1ACTN
 
      ** OUTPUTS
      ** -------
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Warning fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr
 
      ** Data Replication Error Indicators
 
     C                   PARM                    OKFlags
 
      ** Data Replication Details File Format
 
     C                   PARM                    NwRepFilFmt
 
      ** Update error info with that returned from the validation module
 
     C                   EXSR      SRUpdErrs
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SR_BatchNum - Validate Batch Number                          *
      *                                                               *
      *  Called by: Main Processing                                   *
      *                                                               *
      *  Calls:     SRResetErrs, SRUpdErrs                            *
      *                                                               *
      *****************************************************************
     C     SR_BatchNum   BEGSR
 
      ** Reset variables updated by validation
 
     C                   EXSR      SRResetErrs
 
      ** Validate Batch Number
 
     C                   CALLB     'SCVBATN'
 
      ** Inputs
      ** Return Code
 
     C                   PARM                    RetCodeIn
 
      ** Field requiring validation: Batch Number
 
     C                   PARM                    #1BATN
 
      ** Outputs
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Warning fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr
 
      ** Data Replication Error Indicators
 
     C                   PARM                    OKFlags
 
      ** Data Replicaiton Details File Format
 
     C                   PARM                    NwRepFilFmt
 
      ** Update error info with that returned from the validation module
 
     C                   EXSR      SRUpdErrs
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SR_FreqUpd - Validate Frequency of Update                    *
      *                                                               *
      *  Called by: Main Processing                                   *
      *                                                               *
      *  Calls:     SRResetErrs, SRUpdErrs                            *
      *                                                               *
      *****************************************************************
     C     SR_FreqUpd    BEGSR
 
      ** Reset variables updated by validation
 
     C                   EXSR      SRResetErrs
 
      ** Validate Frequency of Update
 
     C                   CALLB     'SCVFREQ'
 
      ** Inputs
      ** Return Code
 
     C                   PARM                    RetCodeIn
 
      ** Field requiring validation: Frequency of Update
 
     C                   PARM                    #1FREQ
 
      ** Outputs
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Warning fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr
 
      ** Data Replication Error Indicators
 
     C                   PARM                    OKFlags
 
      ** Data Replicaiton Details File Format
 
     C                   PARM                    NwRepFilFmt
 
      ** Update error info with that returned from the validation module
 
     C                   EXSR      SRUpdErrs
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRResetErrs - Reset error information that is received back  *
      *    from each validation module.                               *
      *                                                               *
      *  Called by: SR_RepSelect, SR_PFile, SR_BatchNum, SR_FreqUpd   *
      *                                                               *
      *  Calls:     None                                              *
      *                                                               *
      *****************************************************************
     C     SRResetErrs   BEGSR
 
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
      *  SRUpdErrs - Update error information with that received back *
      *    from each validation module.                               *
      *                                                               *
      *  Called by: SR_RepSelect, SR_PFile, SR_BatchNum, SR_FreqUpd   *
      *                                                               *
      *  Calls:     None                                              *
      *                                                               *
      *****************************************************************
     C     SRUpdErrs     BEGSR
 
      ** Update error fields/message IDs/message data (arrays)
 
     C                   Z-ADD     1             I
     C     *BLANK        LOOKUP    FldNameArr(I)                          01
     C                   IF        *IN01 = *ON
     C                   MOVEA     FldNamXAr     FlDNameArr(I)
     C                   MOVEA     MsgIDXAr      MsgIdArr(I)
     C                   MOVEA     MsgDtaXAr     MsgDtaArr(I)
     C                   ENDIF
 
      ** Set Error Index
 
     C                   Z-ADD     1             I
     C     *BLANK        LOOKUP    FldNameArr(I)                          01
     C     I             SUB       1             Idx
 
      ** Update warning fields/message IDs/message data (arrays)
 
     C                   Z-ADD     1             I
     C     *BLANK        LOOKUP    WFldNamArr(I)                          01
     C                   IF        *IN01 = *ON
     C                   MOVEA     WFldNmXAr     WFldNamArr(I)
     C                   MOVEA     WMsgIDXAr     WMsgIDArr(I)
     C                   MOVEA     WMsgDtXAr     WMsgDtaArr(I)
     C                   ENDIF
 
      ** Set Warning Index
 
     C                   Z-ADD     1             I
     C     *BLANK        LOOKUP    WFldNamArr(I)                          01
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
 
      ** INPUTS
      ** Return Code
 
     C                   PARM                    RetCodeIn
 
      ** Data Replication screen format
 
     C                   PARM                    NwRepScnFmt
 
      ** Current Screen Format
 
     C                   PARM                    CrRepScnFmt
 
      ** OUTPUTS
      ** -------
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
 
      ** Array index (3P0) from/to caller
 
     C                   PARM                    Idx
 
      ** Warning fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
 
      ** Array index (3P0) from/to caller
 
     C                   PARM                    WIdx
 
      ** Error definition file / OK Flags
 
     C                   PARM                    OKFlags
 
      ** Data replication definition file (File format)
 
     C                   PARM                    NwRepFilFmt
 
      ** Redisplay flag
 
     C                   PARM                    PReDsp
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY sets the values of program, module and
      ** procedure names for database error processing.
     C/COPY ZACPYSRC,DBFIELDS
      **--------------------------------------------------------------------------------------------
 
      **  Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,SCRPCNV021
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2001
