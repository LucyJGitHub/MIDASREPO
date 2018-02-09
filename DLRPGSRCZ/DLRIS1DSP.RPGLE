     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2013')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas DL Reporting Information Screen 1 Display')      *
      *****************************************************************
      *                                                               *
      *  Midas - Money Market Dealing Module                          *
      *                                                               *
      *  DLRIS1DSP - Midas DL Reporting Information Screen 1 Display  *
      *                                                               *
      *  Function:  This module displays the screen 1 of the Dealing  *
      *             Reporting Information screen                      *
      *                                                               *
      *  (c) Finastra International Limited 2013                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CSW214             Date 25Nov14               *
      *                 MD023264           Date 05Nov13               *
      *                 MD023197           Date 03Nov13               *
      *                 CSW213  *CREATE    Date 03Jun13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSW214 - SWIFT Changes 2014                                  *
      *  MD023264 - CCP House details should only be shown for FXDL   *
      *             with non-precious metal currencies. (Recompile)   *
      *  MD023197 - Link Swap ID shown for other APIs other than FXDL *
      *             with both currencies tagged as non-precious       *
      *             metals.                                           *
      *  CSW213 - SWIFT Changes 2013                                  *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     FDLRPIFDF1 CF   E             WORKSTN
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
      *
     D/COPY ZACPYSRC,STD_D_SPEC
      *
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
      *
     D/COPY ZACPYSRC,PSDS
      *
      **---------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **---------------------------------------------------------------
      *
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
      *
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
     D DLRIS1Detail  E DS                  EXTNAME(DLRIS1PD)
      ** DLRIS1PD screen layout
      *
     D DLError1      E DS                  EXTNAME(DLERI1PD)
      ** Screen 1 error flags
                                                                                            MD023197
     D DLRILKDetail  E DS                  EXTNAME(DLRILKPD)                                MD023197
      ** RPIF Link File                                                                     MD023197
                                                                                            MD023197
     D SDCURR        E DS                  EXTNAME(SDCURRPD)                                MD023197
      ** External DS for Currency Details                                                   MD023197
                                                                                            MD023197
     D DSSDY         E DS                  EXTNAME(DSSDY)                                   MD023197
      ** External DS for long Dummy Data Structure                                          MD023197
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
     D WRetCode        S             10A
     D WActn           S              1A
     D WINKC           S              1A
     D WINKL           S              1A
     D WMsgId          S              7A
     D WMsgDt          S             45A
     D WZAmSId         S             10A
     D WZAmDta         S             45A
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
     C                   MOVEA     DLError1      @EI
      *
      ** Set screen error indicators according to status of 'OK' flags
      *
     C                   Z-ADD     1             WC
     C                   Z-ADD     11            WE
      *
     C                   DOU       WC > 70
     C                   IF        @EI(WC) = 'N' OR
     C                             @EI(WC) = 'W'
     C                   MOVEL     '1'           *IN(WE)
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
     C                   DOW       WC <= ArrayMax AND
     C                             FldNameArr(WC) <> *BLANKS
     C                   MOVEL     MsgIdArr(WC)  WMsgId
     C                   MOVEL     MsgDtaArr(WC) WMsgDt
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
     C                   DOW       WC <= ArrayMax AND
     C                             WFldNamArr(WC) <> *BLANKS
     C                   MOVEL     WMsgIdArr(WC) WMsgId
     C                   MOVEL     WMsgDtaArr(WC)WMsgDt
     C                   IF        WMsgDt = *BLANKS
     C                   EXSR      ErrWoD
     C                   ELSE
     C                   EXSR      ErrWiD
     C                   ENDIF
     C                   EVAL      WC = WC + 1
     C                   ENDDO
      *
      ** Write msg ID MMM1030 (If There is) to subfile
      *
     C                   IF        MsgIdArr(1) = 'MMM1030'
     C                   MOVEL     MsgIdArr(1)   WMsgId
     C                   MOVEL     MsgDtaArr(1)  WMsgDt
     C                   IF        WMsgDt = *BLANKS
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
      *                                                                                     MD023197
      ** Show Link Swap ID field only for FX Deals                                          MD023197
      *                                                                                     MD023197
     C**********         EVAL      *IN22 = '0'                                       MD023197 CSW214
     C                   EVAL      *IN83 = '0'                                                CSW214
     C                   IF        RLAPID = 'FXDL'                                          MD023197
                                                                                            MD023197
     C                   CALLB     'AOCURRR0'                                               MD023197
     C                   PARM      *BLANKS       @RTCD                                      MD023197
     C                   PARM      '*KEY    '    @OPTN                                      MD023197
     C                   PARM      RLSCCY        @CURR             3                        MD023197
     C     SDCURR        PARM      SDCURR        DSSDY                                      MD023197
     C     @RTCD         IFEQ      *BLANKS                                                  MD023197
     C                   MOVE      A6PMRT        SPMRT             1                        MD023197
     C                   ENDIF                                                              MD023197
                                                                                            MD023197
     C                   CALLB     'AOCURRR0'                                               MD023197
     C                   PARM      *BLANKS       @RTCD                                      MD023197
     C                   PARM      '*KEY    '    @OPTN                                      MD023197
     C                   PARM      RLBCCY        @CURR                                      MD023197
     C     SDCURR        PARM      SDCURR        DSSDY                                      MD023197
     C     @RTCD         IFEQ      *BLANKS                                                  MD023197
     C                   MOVE      A6PMRT        BPMRT             1                        MD023197
     C                   ENDIF                                                              MD023197
                                                                                            MD023197
     C     SPMRT         IFNE      'Y'                                                      MD023197
     C     BPMRT         ANDNE     'Y'                                                      MD023197
     C**********         EVAL      *IN22 = '1'                                       MD023197 CSW214
     C                   EVAL      *IN83 = '1'                                                CSW214
     C                   ENDIF                                                              MD023197
                                                                                            MD023197
     C                   ENDIF                                                              MD023197
      *
      ** Write message subfile, details and footer screen
      *
     C                   WRITE     DLRPIF1C0
     C                   WRITE     DLRPIF1F0
     C                   WRITE     DLRPIF1F1
     C                   WRITE     DLRPIF1F2
      *
      ** Read details screen,
      *
      ** If not write only
      *
     C                   IF        WriteOnly <> 'Y'
     C                   READ      DLRPIF1F1                              99
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
     C                   EVAL      WZAmSId = *BLANK
     C                   EVAL      WZAmSId = WMsgId
      *
     C                   CALL      'ZA0240'
     C                   PARM                    WZAmSId
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
     C                   EVAL      WZAmSId = *BLANK
     C                   EVAL      WZAmSId = WMsgId
      *
     C                   CALL      'ZA0440'
     C                   PARM                    WZAmSId
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
      ** Transaction Reporting screen 1
     C                   PARM                    DLRIS1Detail
      *
      ** Fields in error - screen 1
     C                   PARM                    DLError1
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
      *                                                                                     MD023197
     C                   PARM                    DLRILKDetail                               MD023197
      *
      ** Initialize program name
      *
     C                   MOVEL     'DLRIS1DSP'   DBPGM
      *
      ** Message subfile control
      *
     C                   MOVE      '1'           *IN97
     C                   MOVEL     '*'           DDPGMQ
      *
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*MSG   '     PRtCd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY
      *
     C                   IF        PRtCd = *BLANKS
     C                   EVAL      R1RUND = BJMRDT
     C                   ELSE
     C                   EVAL      R1RUND = *BLANKS
     C                   ENDIF
      *                                                                                       CSW214
      ** Check if Swift 2014 Changes is installed.                                            CSW214
      *                                                                                       CSW214
     C                   CALL      'SWIF2014'                                                 CSW214
     C                   PARM      *BLANKS       PRTCD                                        CSW214
      *                                                                                       CSW214
     C     PRTCD         IFEQ      'CSW2014'                                                  CSW214
     C                   EVAL      *IN82 = '1'                                                CSW214
     C                   ELSE                                                                 CSW214
     C                   EVAL      *IN82 = '0'                                                CSW214
     C                   ENDIF                                                                CSW214
      *
     C                   EVAL      R1USID = PSUser
     C                   EVAL      R1PGMN = 'DLRIS1DSP'
     C                   EVAL      R1WSID = PSJobName
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
