     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2013')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas DL Reporting Information Retrieve a record')     *
      *****************************************************************
      *                                                               *
      *  Midas - Dealing Module                                       *
      *                                                               *
      *  DLRPIFR - Midas DL Reporting Information Conversion to scrn  *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2013            *
      *                                                               *
      *  Last Amend No. CSW214             Date 25Nov14               *
      *  Prev Amend No. CSW213  *CREATE    Date 03Jun13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSW214 - SWIFT Changes 2014                                  *
      *  CSW213 - SWIFT Changes 2013                                  *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
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
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
 
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
     D DLRPIFFileFmt E DS                  EXTNAME(DLRPIFPD)
     D DLRPIFScn1Fmt E DS                  EXTNAME(DLRIS1PD)
     D DLRPIFScn2Fmt E DS                  EXTNAME(DLRIS2PD)
     D DLRPIFScn3Fmt E DS                  EXTNAME(DLRIS3PD)
     D DLRPIFScn4Fmt E DS                  EXTNAME(DLRIS4PD)                                  CSW214
     D PDlRILkpd     E DS                  EXTNAME(DLRILKPD)
 
     D PRetCode        S             10A
     D PModeOp         S              6A
     D PTranRefOK      S              1A
     D DFOfcrIDOK      S              1A
     D WNoRepFlag      S              1A
     D EIdx            S              3  0
     D WIdx            S              3  0
 
      **************************************************************
      /EJECT
      **************************************************************
 
      ** Initialization
 
     C                   EXSR      SRInit
     C                   EXSR      SRGetRecord
 
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRGetRecord - Get Record                                      *
      *****************************************************************
     C     SRGetRecord   BEGSR
 
     C                   CALLB     'DLRPIFRTV'
 
      ** Inputs
      ** Return code
     C                   PARM      *BLANKS       PRetCode
 
      ** Mode of operation
     C                   PARM                    PModeOp
 
      ** RPIF Set up fields
     C                   PARM                    PDlRILkpd
 
      ** OUTPUTS
      ** No Reporting information
     C                   PARM                    WNoRepFlag
 
      ** (Current) deal in file format
     C                   PARM                    DLRPIFFileFmt
 
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
 
      ** Error Array index (3P0) from/to caller
     C                   PARM      *ZERO         EIdx
 
      ** Warning error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM      *BLANKS       WFldNamArr
     C                   PARM      *BLANKS       WMsgIdArr
     C                   PARM      *BLANKS       WMsgDtaArr
 
      ** Warning array index (3P0) from/to caller
 
     C                   PARM      *ZEROS        WIdx
 
     C                   IF        EIdx <> 0
     C                   EVAL      PRetCode = 'Error'
 
     C                   ELSE
     C                   IF        WNoRepFlag = 'N'
 
     C                   CALLB     'DLRPIFCVT'
 
      ** Return Code
     C                   PARM                    PRetCode
 
      ** Deal in file format
     C                   PARM                    DLRPIFFileFmt
 
      ** Output parameters
      ** Transaction Reporting screen 1
     C                   PARM                    DLRPIFScn1Fmt
 
      ** Transaction Reporting screen 2
     C                   PARM                    DLRPIFScn2Fmt
 
      ** Transaction Reporting screen 3
     C                   PARM                    DLRPIFScn3Fmt
                                                                                              CSW214
      ** Transaction Reporting screen 4                                                       CSW214
                                                                                              CSW214
     C                   PARM                    DLRPIFScn4Fmt                                CSW214
 
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRInit - Initialization
      *****************************************************************
     C     SRInit        BEGSR
 
     C                   CLEAR                   DLRPIFFileFmt
     C                   CLEAR                   DLRPIFScn1Fmt
     C                   CLEAR                   DLRPIFScn2Fmt
     C                   CLEAR                   DLRPIFScn3Fmt
     C                   CLEAR                   DLRPIFScn4Fmt                                CSW214
 
     C                   ENDSR
     C********************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Initial Processing
      *****************************************************************
     C     *INZSR        BEGSR
 
      ** Parameters
     C     *ENTRY        PLIST
 
      ** Inputs
      ** Return code
     C                   PARM                    PRetCode
 
      ** Mode of operation
     C                   PARM                    PModeOp
 
      ** RPFI Set up fields
     C                   PARM                    PDlRILkpd
 
      ** OUTPUTS
      ** Transaction Reference OK Flag
     C                   PARM                    PTranRefOK
 
      ** Front Office ID OK Flag
     C                   PARM                    DFOfcrIDOK
 
      ** No Report Information flag
     C                   PARM                    WNoRepFlag
 
      ** DLRPIF in File Format
     C                   PARM                    DLRPIFFileFmt
 
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
 
      ** Array index (3P0) from/to caller
     C                   PARM                    EIdx
 
      ** Warning error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
 
      ** Warning array index (3P0) from/to caller
     C                   PARM                    WIdx
 
      ** Report Information File - Screen Format
     C                   PARM                    DLRPIFScn1Fmt
     C                   PARM                    DLRPIFScn2Fmt
     C                   PARM                    DLRPIFScn3Fmt
     C                   PARM                    DLRPIFScn4Fmt                                CSW214
 
      ** Initialize program name
 
     C                   EVAL      DBPGM = 'DLRPIFR'
 
     C                   ENDSR
      ********************************************************************
