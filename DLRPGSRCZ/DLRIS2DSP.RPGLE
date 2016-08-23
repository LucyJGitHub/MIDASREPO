     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2013')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas DL Reporting Information Screen 2 Display')      *
      *****************************************************************
      *                                                               *
      *  Midas - Dealing Module                                       *
      *                                                               *
      *  DLRIS2DSP - Midas DL Reporting Information Screen 2 Display  *
      *                                                               *
      *  Function:  This module displays the screen 2 of the Dealing  *
      *             Reporting Information screen                      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2013            *
      *                                                               *
      *  Last Amend No. CSW214             Date 25Nov14               *
      *  Prev Amend No. CSW213  *CREATE    Date 03Jun13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSW214 - SWIFT Changes 2014 (Recompile)                      *
      *  CSW213 - SWIFT Changes 2013                                  *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     FDLRPIFDF2 CF   E             WORKSTN
 
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
      ** Bank Details File
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for Access programs - short data structure
      *
     D DLRIS2Detail  E DS                  EXTNAME(DLRIS2PD)
      ** DLRIS2PD screen layout
      *
     D DLError2      E DS                  EXTNAME(DLERI2PD)
      ** Screen 2 error flags
      *
 
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
     D WZAmsId         S             10A
     D WZAmDta         S             45A
     D WC              S              2S 0
     D WE              S              2S 0
 
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
     C                   EXSR      Main
      *
      ** Return
      *
     C     WINKC         IFEQ      '1'
     C                   EVAL      *INLR = '1'
     C                   ENDIF
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
     C* Main - Main processing
      *****************************************************************
     C     Main          BEGSR
      *
      ** Move 'OK' flags into array (for checking)
      *
     C                   MOVEA     DLError2      @EI
      *
      ** Set screen error indicators according to status of 'OK' flags
      *
     C                   Z-ADD     1             WC
     C                   Z-ADD     11            WE
      *
     C                   DOU       WC > 70
 
     C                   IF        @EI(WC) = 'N'
     C                             OR @EI(WC) = 'W'
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
      *
     C                   DOW       WC <= ArrayMax
     C                             AND FldNameArr(WC) <> *BLANKS
     C                   EVAL      WMsgId = MsgIdArr(WC)
     C                   EVAL      WMsgDt = MsgDtaArr(WC)
 
     C                   IF        WMsgDt = *BLANKS
     C                   EXSR      ErrWoD
     C                   ELSE
     C                   EXSR      ErrWiD
     C                   ENDIF
 
     C                   EVAL      WC = WC + 1
     C                   ENDDO
      *
      ** Do while warning messages found
      ** Write warning messages (with or without data) to subfile
      *
     C                   Z-ADD     1             WC
      *
     C     WC            DOWLE     ArrayMax
     C     WFldNamArr(WC)ANDNE     *BLANKS
     C                   MOVEL     WMsgIdArr(WC) WMsgId
     C                   MOVEL     WMsgDtaArr(WC)WMsgDt
 
     C     WMsgDt        IFEQ      *BLANKS
     C                   EXSR      ErrWoD
     C                   ELSE
     C                   EXSR      ErrWiD
     C                   ENDIF
 
     C                   ADD       1             WC
     C                   ENDDO
      *
      ** Write msg ID MMM1030 (If There is) to subfile
      *
     C     MsgIdArr(1)   IFEQ      'MMM1030'
     C                   MOVEL     MsgIdArr(1)   WMsgId
     C                   MOVEL     MsgDtaArr(1)  WMsgDt
 
     C     WMsgDt        IFEQ      *BLANKS
     C                   EXSR      ErrWoD
     C                   ELSE
     C                   EXSR      ErrWiD
     C                   ENDIF
     C                   ENDIF
      *
      ** Enable detail fields
      *
     C                   EVAL      *IN70 = '0'
     C                   IF        WActn <> 'I'
     C                             AND WActn <> 'A'
     C                   EVAL      *IN70 = '1'
     C                   ENDIF
      *
      ** Write message subfile, details and footer screen
      *
     C                   WRITE     DLRPIF2C0
     C                   WRITE     DLRPIF2F0
     C                   WRITE     DLRPIF2F1
     C                   WRITE     DLRPIF2F2
      *
      ** Read details screen,
      *
      ** If not write only
      *
     C                   IF        WriteOnly <> 'Y'
     C                   READ      DLRPIF2F1                              99
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
     C*****************************************************************
     C*                                                               *
     C* ErrWoD  - Output Error Messages Without Data                  *
     C*                                                               *
     C*****************************************************************
     C     ErrWoD        BEGSR
      *
      ** Display error message
      *
     C                   MOVEL     *BLANK        WZAmsId
     C                   MOVEL     WMsgId        WZAmsId
     C                   CALL      'ZA0240'
     C                   PARM                    WZAmsId
      *
     C                   ENDSR
     C*****************************************************************
      /EJECT
     C*****************************************************************
     C*                                                               *
     C* ErrWiD  - Output Error Messages With Data                     *
     C*                                                               *
     C*****************************************************************
     C     ErrWiD        BEGSR
      *
      ** Display error message
      *
     C                   MOVEL     *BLANK        WZAmsId
     C                   MOVEL     WMsgId        WZAmsId
     C                   CALL      'ZA0440'
     C                   PARM                    WZAmsId
     C                   PARM      WMsgDt        WZAmDta
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
     C                   PARM                    DLRIS2Detail
      *
      ** Fields in error - screen 2
     C                   PARM                    DLError2
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
     C                   MOVEL     'DLRIS2DSP'   DBPGM
      *
      ** Message subfile control
      *
     C                   MOVE      '1'           *IN97
     C                   MOVEL     '*'           DDPGMQ
      *
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*MSG   '     PRtCd             7
     C                   PARM      '*FIRST '     POptn             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
     C                   IF        PRtCd = *BLANKS
     C                   EVAL      R2RUND = BJMRDT
     C                   ELSE
     C                   EVAL      R2RUND = *BLANKS
     C                   ENDIF
      *
     C                   EVAL      R2USID = PSUser
     C                   EVAL      R2PGMN = 'DLRIS2DSP'
     C                   EVAL      R2WSID = PSJobName
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
