     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2013')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas DL Reporting Information Screen 3 Display')      *
      *****************************************************************
      *                                                               *
      *  Midas - Money Market Dealing Module                          *
      *                                                               *
      *  DLRIS3DSP - Midas DL Reporting Information Screen 3 Display  *
      *                                                               *
      *  Function:  This module displays the main details screen of   *
      *             the dealing reporting  information screen         *
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
     FDLRPIFDF3 CF   E             WORKSTN
      *****************************************************************
      /EJECT
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
 
      **---------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **---------------------------------------------------------------
 
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
      *
     D @Z0             S              1    DIM(70) CTDATA PERRCD(70)
     D @EI             S              1    DIM(70)
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
     D DSFDY         E DS                  EXTNAME(DSFDY)
     D DLRIS3Detail  E DS                  EXTNAME(DLRIS3PD)
     D DLError3      E DS                  EXTNAME(DLERI3PD)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D WRetCode        S             10A
     D WActn           S              1A
     D WINKC           S              1A
     D WINKL           S              1A
     D WMsgId          S              7A
     D WMsgDt          S             45A
     D WZAMsId         S             10A
     D WZAMDta         S             45A
     D WC              S              2S 0
     D WE              S              2S 0
     D PRtCd           S              7A
     D POptn           S              7A
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
      *
      * Main processing
      *
     C                   EXSR      SRMain
      *
      ** Return
      *
     C                   IF        WINKC = '1'
     C                   EVAL      *INLR = *ON
     C                   ENDIF
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRMain - Main Processing
      *****************************************************************
     C     SRMain        BEGSR
      *
      ** Move 'OK' flags into array (for checking)
      *
     C                   MOVEA     DLError3      @EI
      *
      ** Set screen error indicators according to status of 'OK' flags
      *
     C                   Z-ADD     1             WC
     C                   Z-ADD     11            WE
      *
     C                   DOU       WC > 70
 
     C                   IF        @EI(WC) = 'N' OR
     C                             @EI(WC) = 'W'
     C                   EVAL      *IN(WE) = '1'
     C                   ENDIF
 
     C                   EVAL      WC = WC + 1
     C                   EVAL      WE = WE + 1
     C                   ENDDO
      *
      ** Do while error messages found
      ** Write error messages (with or without data) to subfile
      *
     C                   Z-ADD     1             WC
     C                   DOW       WC <= ArrayMax AND
     C                             FldNameArr(WC) <> *BLANKS
     C                   EVAL      WMsgId = MsgIdArr(WC)
     C                   EVAL      WMsgDt = MsgDtaArr(WC)
 
     C                   IF        WMsgDt = *BLANKS
     C                   EXSR      SRErrWoD
     C                   ELSE
     C                   EXSR      SRErrWiD
     C                   ENDIF
 
     C                   EVAL      WC = WC + 1
     C                   ENDDO
      *
      ** Do while warning messages found
      ** Write warning messages (with or without data) to subfile
      *
     C                   Z-ADD     1             WC
     C                   DOW       WC <= ArrayMax AND
     C                             WFldNamArr(WC) <> *BLANKS
     C                   EVAL      WMsgId = WMsgIdArr(WC)
     C                   EVAL      WMsgDt = WMsgDtaArr(WC)
 
     C                   IF        WMsgDt = *BLANKS
     C                   EXSR      SRErrWoD
     C                   ELSE
     C                   EXSR      SRErrWoD
     C                   ENDIF
 
     C                   EVAL      WC = WC + 1
     C                   ENDDO
      *
      ** Write msg ID MMM1030 (If There is) to subfile
      *
     C                   IF        MsgIdArr(1) = 'MMM1030'
     C                   EVAL      WMsgId = MsgIdArr(1)
     C                   EVAL      WMsgDt = MsgDtaArr(1)
 
     C                   IF        WMsgDt = *BLANKS
     C                   EXSR      SRErrWoD
     C                   ELSE
     C                   EXSR      SRErrWiD
     C                   ENDIF
     C                   ENDIF
      *
      ** Enable detail fields
      *
     C                   EVAL      *IN70 = *OFF
     C                   IF        WActn <> 'I' AND
     C                             WActn <> 'A'
     C                   EVAL      *IN70 = *ON
     C                   ENDIF
      *
      ** Write message subfile, details and footer screen
      *
     C                   WRITE     DLRPIF3C0
     C                   WRITE     DLRPIF3F0
     C                   WRITE     DLRPIF3F1
      *
      ** Read details screen,
      *
      ** If not write only
      *
     C                   IF        WriteOnly <> 'Y'
     C                   READ      DLRPIF3F0                              99
     C                   ENDIF
      *
      ** Clear message subfile
      *
     C                   CALL      'ZA0250'
      *
      ** Set screen error indicators off
      *
     C                   MOVEA     @Z0           *IN(10)
      *
      ** Set return keys
      *
     C                   EVAL      WINKC = *INKC
     C                   EVAL      WINKL = *INKL
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRErrWoD  - Output error messages without data                *
      *                                                               *
      *****************************************************************
     C     SRErrWoD      BEGSR
      *
      ** Display error message
      *
     C                   EVAL      WZAMsId = *BLANK
     C                   EVAL      WZAMsId = WMsgId
 
     C                   CALL      'ZA0240'
     C                   PARM                    WZAMsId
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRErrWiD - Output error messages with data                    *
      *                                                               *
      *****************************************************************
     C     SRErrWiD      BEGSR
      *
      ** Display error message
      *
     C                   EVAL      WZAMsId = *BLANK
     C                   EVAL      WZAMsId = WMsgId
 
     C                   CALL      'ZA0440'
     C                   PARM                    WZAMsId
     C                   PARM      WMsgDt        WZAMDta
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Initial Processing
      *****************************************************************
     C     *INZSR        BEGSR
      *
      ** Parameters
      *
     C     *ENTRY        PLIST
      *
      ** Input parameters
      *
      ** Return code
     C                   PARM                    WRetCode
      *
      ** Action code
     C                   PARM                    WActn
      *
      ** Transaction Reporting screen 2
     C                   PARM                    DLRIS3Detail
      *
      ** Fields in error - screen 2
     C                   PARM                    DLError3
      *
      ** Errors
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ** Warnings
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      ** Function Keys
     C                   PARM                    WINKC
     C                   PARM                    WINKL
      *
      ** Initialize program name
      *
     C                   EVAL      DBPGM = 'DLRIS3DSP'
      *
      ** Message subfile control
      *
     C                   EVAL      *IN97 = *ON
     C                   EVAL      DDPGMQ = '*'
      *
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*MSG   '     PRtCd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY
      *
     C                   IF        PRtCd = *BLANKS
     C                   EVAL      R3RUND = BJMRDT
     C                   ELSE
     C                   EVAL      R3RUND = *BLANKS
     C                   ENDIF
                                                                                              CSW214
      ** Check if Swift 2014 Changes is installed.                                            CSW214
                                                                                              CSW214
     C                   CALL      'SWIF2014'                                                 CSW214
     C                   PARM      *BLANKS       PRTCD                                        CSW214
                                                                                              CSW214
     C     PRTCD         IFEQ      'CSW2014'                                                  CSW214
     C                   EVAL      *IN82 = '1'                                                CSW214
     C                   ELSE                                                                 CSW214
     C                   EVAL      *IN82 = '0'                                                CSW214
     C                   ENDIF                                                                CSW214
      *
     C                   EVAL      R3USID = PSUser
     C                   EVAL      R3PGMN = 'DLRIS3DSP'
     C                   EVAL      R3WSID = PSJobName
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** Program, module and procedure names for database error processing.
      ** ==============================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
