     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GO BSPL Request Validate and Update')
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GOBSRQVU  - BSPL Request validate and update                 *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2005            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CAS014             Date 10Aug05               *
      *  Prev Amend No. CGP010  *CREATE    Date 17Jan05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CAS014 - IAS21 (The Effects of Changes in Foreign Exchange   *
      *           Rates). Recompile.                                  *
      *  CGP010 - Global BSPL                                         *
      *                                                               *
      *****************************************************************
 
     FZAFLDNPD  IT   F   15        DISK    INFSR(*PSSR)
 
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
      **    True       logical = *on (for indicator processing)
      **    False      logical = *off (for indicator processing)
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
      ** The following /COPY line includes the definitions for arrays
      ** specific to API *CTL modules.
     D/COPY ZACPYSRC,APICTLARR
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
 
      * Incoming Header
     D HeadIn        E DS                  EXTNAME(APHEADPD)
 
     D ScreenIn      E DS                  EXTNAME(GOBSRQPD)
      * Incoming Transaction
 
     D ValidGPBSRQ   E DS                  EXTNAME(GPBSRQPD) PREFIX(V_)
      * BSPL Request - File Format
 
     D CurrentGPBSRQ E DS                  EXTNAME(GPBSRQPD)
      * BSPL Request - File Format
 
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Error message field(s)
     D     Msg1        S                   LIKE(#MsgID)
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
 
      ** Field (500A) to receive the incoming transaction
     D Trans500        S            500A
 
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
 
      /EJECT
 
     C                   MOVEL     Trans500      ScreenIn
 
      * Reset variables gradually updated
 
     C                   EXSR      RESETCYCLE
 
      *  Validate Action Code
 
     C                   EXSR      ValidateAc
 
      *  If error in validation of action code, fail this input
      *
     C     Idx           IFNE      0
     C                   GOTO      INVALID
     C                   END
 
      *  Validate Main Screen
 
     C                   IF        DDACTN = 'I' OR  DDACTN = 'A'
     C                   EXSR      ValidateScn
     C                   ENDIF
      *
     C     INVALID       TAG
 
      *  Write to database
      *  Immediate Request
 
     C     UpdateYN      IFEQ      'Y'
     C     Idx           ANDEQ     0
     C                   EXSR      WriteToDB
     C     DDRQTYP       IFEQ      'I'
     C                   EXSR      ImmedRequest
     C                   ENDIF
     C                   ENDIF
 
 
     C                   EVAL                    Buffer = ScreenIn
 
     C                   SETON                                        LR
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      * ValidateAc - Validate action code                             *
      *****************************************************************
     C     ValidateAc    BEGSR
 
     C                   CALLB     'GOBSRQRTV'
     C                   PARM      *BLANK        @RTCD             7
     C                   PARM      *BLANK        @ERMS            50
 
      * Action
     C                   PARM                    DDACTN            1
      * Request Type
      * Request ID
     C                   PARM                    DDRQTYP           1
     C                   PARM                    DDRQID           15
 
      * OUTPUTS
 
      * BSPL Request - File Format
     C                   PARM                    CurrentGPBSRQ
 
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM      *BLANK        FldNameArr
     C                   PARM      *BLANK        MsgIDArr
     C                   PARM      *BLANK        MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM      *ZERO         Idx               3 0
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  Validate Main Screen
      *****************************************************************
     C     ValidateScn   BEGSR
 
     C                   CALLB     'GOBSRQVAL'
     C                   PARM                    @RTCD             7
     C                   PARM                    @ERMS            50
 
      * INPUTS
 
      * BSPL Request - Screen Format
     C                   PARM                    ScreenIn
 
      * OUTPUTS
 
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM      *BLANK        FldNameArr
     C                   PARM      *BLANK        MsgIDArr
     C                   PARM      *BLANK        MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM      *ZERO         Idx               3 0
 
      * BSPL Request - File Format
     C                   PARM                    ValidGPBSRQ
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * Write to the Database
      *****************************************************************
     C     WriteToDB     BEGSR
 
     C                   IF        DDACTN = 'I'
     C                   EXSR      SETUP_REQID
     C                   ENDIF
 
     C     Idx           IFEQ      0
     C                   EXSR      SETUPVALID
     C                   EXSR      UpdateDB
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * Immediate Request
      *****************************************************************
     C     ImmedRequest  BEGSR
 
     C                   CALL      'GOC0720'
     C                   PARM                    DDRQID
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * RESETCYCLE- Reset error information that is gradually         *
      *    updated during each run of this program                    *
      *****************************************************************
     C     RESETCYCLE    BEGSR
 
     C                   RESET                   FldNameArr
     C                   RESET                   MsgIDArr
     C                   RESET                   MsgDtaArr
     C                   RESET                   Idx
 
     C                   CLEAR                   ValidGPBSRQ
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SETUP_REQID - Set up Request ID for Inserts                   *
      *****************************************************************
     C     SETUP_REQID   BEGSR
 
     C                   IF           DDRQID = *blanks
     C                             OR DDRQID = *zeros
 
     C                   CALL      'GPBSRIGEN'
     C                   PARM                    @RTCD
     C                   PARM                    @ERMS
     C                   PARM                    DDRQTYP
     C                   PARM      *BLANK        DDRQID
 
     C     @RTCD         IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDRQID'
     C                   EVAL      MsgIDArr(Idx) = @ERMS
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SETUPVALID - Set up additional fields that are needed on the  *
      *    Valid record.                                              *
      *****************************************************************
     C     SETUPVALID    BEGSR
 
     C                   IF           DDACTN = 'D'
     C                   MOVEL     CurrentGPBSRQ ValidGPBSRQ
     C                   ENDIF
 
     C                   MOVEL     DDRQTYP       V_SCRQTYP
     C                   MOVEL     DDRQID        V_SCRQID
     C                   MOVEL     DDACTN        V_SCCHTP
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * UPDATEDB - Update Database                                    *
      *****************************************************************
     C     UPDATEDB      BEGSR
      *
      * DATABASE UPDATE
      *
     C                   CALLB     'GOBSRQUPD'
     C                   PARM      *BLANK        @RTCD             7
     C                   PARM      *BLANK        @ERMS            50
     C                   PARM                    ValidGPBSRQ
      *
      * IF THERE WERE ANY ERRORS IN THE UPDATE FUNCTIONS, ROLLBACK ANY
      * UPDATES AND END THIS PROGRAM. OTHERWISE, COMMIT THE UPDATES
      *
     C     @RTCD         IFNE      *BLANK
     C     @RTCD         ANDNE     '*RECUPD'
     C                   MOVEL     '0'           APIRetc
     C                   ROLBK
     C                   EXSR      *PSSR
     C                   ELSE
     C                   COMMIT
     C                   END
      *
      ** If update not done due to record being updated by another
      *  workstation send message to screen.
     C
     C     @RTCD         IFEQ      '*RECUPD'
     C
     C                   MOVEL     '*ANY'        FldNameArr(1)
     C                   MOVEL     'GO09999'     MsgIdArr(1)
     C
     C                   END
 
     C                   ENDSR
      *****************************************************************
      /EJECT
     C/COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
      * Common header information (DS) from source system
     C                   PARM                    HeadIn
      * Transaction information in a single large field from source system
     C                   PARM                    Trans500
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    MsgFArray
     C                   PARM                    UpdateYN          1
     C                   PARM                    Buffer         6000
     C                   PARM                    APIRetc           1
 
      * Set up the names of the message files from which the message handler
      * will get the messages
     C                   EVAL      MsgFArray(1) = 'MIDAS'
 
     C                   ENDSR
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2005
