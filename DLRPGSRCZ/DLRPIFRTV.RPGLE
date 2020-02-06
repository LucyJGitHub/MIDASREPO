     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2013')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas DL Reporting Information Retrieve')              *
      *****************************************************************
      *                                                               *
      *  Midas - Dealing Module                                       *
      *                                                               *
      *  DLRPIFRTV - Midas DL Reporting Information Retrieve          *
      *                                                               *
      *  (c) Finastra International Limited 2013                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CSW216             Date 14Mar16               *
      *                 CSW214             Date 25Nov14               *
      *                 CSW213  *CREATE    Date 03Jun13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSW216 - SWIFT Changes 2016 (Recompile)                      *
      *  CSW214 - SWIFT Changes 2014 (Recompile)                      *
      *  CSW213 - SWIFT Changes 2013                                  *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Midas DL Dealing Reporting Info
     FDLRPIFL0  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(DLRPIFD0:DLRPIF00)
      ** Midas DL Dealing Reporting Info
     FDLRPIFL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(DLRPIFD0:DLRPIFD2)
 
      ** Midas DL Dealing Reporting Info
     FDLRPIFL3  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(DLRPIFD0:DLRPIFD3)
 
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
 
     D ZMUSER          DS            17
     D  BRC                   11     13
     D  DEPT                  14     16
 
     D DLRPIFPDDtl   E DS                  EXTNAME(DLRPIFPD)
      *
     D DLRPIFL0Dtl   E DS                  EXTNAME(DLRPIFL0)
     D                                     PREFIX(L0)
      *
     D DLRPIFL1Dtl   E DS                  EXTNAME(DLRPIFL1)
     D                                     PREFIX(L2)
      *
     D DLRPIFL3Dtl   E DS                  EXTNAME(DLRPIFL3)
     D                                     PREFIX(L3)
 
     D WDlRILkpd     E DS                  EXTNAME(DLRILKPD)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      *
      ** Index for arrays of of error message ids etc
     D Ix              S              3  0
      *
      ** Variables introduced by CAS004
     D WI              S              3  0
      *
     D WFound          S              1
     D WRetCode        S             10
     D WModeOp         S              6
     D*WAPID           S              4
     D*WDTyp           S              2
     D*WActn           S              1
     D*WTRRF           S             16
     D*WFOID           S             20
     D WNRI            S              1
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      **************************************************************
      /EJECT
      **************************************************************
 
      ** Initialization
 
     C                   EXSR      SRInit
 
      ** Main process
 
     C                   EXSR      SRMain
 
      ** Return
 
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRMain - Main process
      *****************************************************************
     C     SRMain        BEGSR
 
     C                   EVAL      WNRI = 'Y'
     C                   EVAL      WFound = 'N'
 
     C                   IF        WModeOp = '*FRONT'
     C     DLRPIFKey3    CHAIN     DLRPIFL3
     C                   IF        %FOUND(DLRPIFL3)
     C                   EVAL      WFound = 'Y'
     C                   ENDIF
 
     C                   ELSE
     C                   IF        RLAPID <> *BLANKS
     C     DLRPIFKey0    CHAIN     DLRPIFL0
     C                   IF        %FOUND(DLRPIFL0)
     C                   EVAL      WFound = 'Y'
     C                   ENDIF
 
     C                   ELSE
     C     DLRPIFKey1    CHAIN     DLRPIFL1
     C                   IF        %FOUND(DLRPIFL1)
     C                   EVAL      WFound = 'Y'
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF
 
     C     WFound        IFEQ      'Y'
     C                   EVAL      WNRI = 'N'
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRInit - Initialization
      *****************************************************************
     C     SRInit        BEGSR
 
     C                   CLEAR                   DLRPIFPDDtl
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Initial processing
      *****************************************************************
     C     *INZSR        BEGSR
      *
      ** Parameters
      *
     C     *ENTRY        PLIST
 
      ** Inputs
      ** Return code
     C                   PARM                    WRetCode
 
      ** Mode of operation
     C                   PARM                    WModeOp
 
      ** RPIF Set up fields
     C                   PARM                    WDlRILkpd
 
      ** OUTPUTS
      ** No Report Information flag
     C                   PARM                    WNRI
 
      ** (Current) deal in file format
     C                   PARM                    DLRPIFPDDtl
 
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
 
      ** Array index (3P0) from/to caller
     C                   PARM                    Ix
 
      ** Warning error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
 
      ** Warning array index (3P0) from/to caller
     C                   PARM                    WI
 
      ** Initialize program name
 
     C                   EVAL      DBPGM = 'DLRPIFRTV'
 
      ** Key Lists
 
     C     DLRPIFKey0    KLIST
     C                   KFLD                    RLAPID
     C                   KFLD                    RLTRRF
 
     C     DLRPIFKey1    KLIST
     C                   KFLD                    RLDTYP
     C                   KFLD                    RLLTRF
 
     C     DLRPIFKey3    KLIST
     C                   KFLD                    RLFOID
 
      ** Get ZMUSER to access default branch.
 
     C     *DTAARA       DEFINE                  ZMUSER
     C                   IN        ZMUSER
     C                   UNLOCK    ZMUSER
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      ********************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
