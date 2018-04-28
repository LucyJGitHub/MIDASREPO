     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SC 24x7 Processing Day Msg Mnt Retrieve')
      *****************************************************************
      *                                                               *
      *  Midas - System Control Module                                *
      *                                                               *
      *  SCWMSGRTV - Processing Day Message Maintenance - Retrieve    *
      *                                                               *
      *  Function:  This module retrieves the message details for the *
      *             record being enquired, amended, or deleted.       *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4.01 -------------------------------------------*
      *  Last Amend No. CSC011  *CREATE    Date 18Sep01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSC011 - 24x7 Midas Availability                             *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    11         End of file/No record found                     *
      *                                                               *
      *    90-99      Used by Standard Subroutines                    *
      *                                                               *
      *    U7+U8      Database Error                                  *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRINIT - Initialise                                          *
      *                                                               *
      *  *PSSR  - Error processing                                    *
      *  *INZSR - Initialise                                          *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FSCSYSTL2  IF   E           K DISK    INFSR(*PSSR)
 
      *****************************************************************
      /EJECT
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
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D OKMTIM          S              1
     D OKLANG          S              1
 
     D PAction         S              1
     D PMType          S              1
     D PMTime          S              5  0
     D PLang           S              2
     D PMText          S            500
 
     D WLang           S              2
     D Idx             S              3P 0
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ Initial processing is performed automatically: *INZSR is   ¦
      ** ¦ executed at program activation.                            ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
 
      ** Initialise fields and arrays.
 
     C                   EXSR      SRInit
 
     C                   IF        PAction = 'I'
     C                   EXSR      SRValKey
 
     C                   ELSE
     C                   EVAL      WLang = PLang
     C     KSYST         CHAIN     SCSYSTD0                           11
     C                   EVAL      PMText = T1MTXT
     C                   ENDIF
 
     C                   IF        OKMTIM = 'N'
     C                   EVAL      RetCodeIn = '*ERROR'
     C                   ENDIF
 
     C                   EVAL      *INLR = '1'
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValKey - Validate record to be inserted                    *
      *                                                               *
      *  Called by: Main                                              *
      *                                                               *
      *  Calls    : None                                              *
      *                                                               *
      *****************************************************************
 
     C     SRValKey      BEGSR
 
      ** There should be an existing record with the same Message
      ** Type/Message Time combination with blank Language Code.
 
     C                   IF        PLang <> *BLANKS
     C                   EVAL      WLang = *BLANKS
     C     KSYST         CHAIN     SCSYSTD0                           11
     C                   IF        *IN11 = *ON
     C                   EVAL      OKMTIM = 'N'
     C                   EVAL      OKLANG = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = '#2MTIM'
     C                   EVAL      MsgIdArr(Idx) = 'SCC0021'
     C                   ENDIF
     C                   ENDIF
 
      ** Record must not exist in file.
 
     C                   IF        *IN11 = *OFF
     C                   EVAL      WLang = PLang
     C     KSYST         CHAIN     SCSYSTD0                           11
     C                   IF        *IN11 = *OFF
     C                   EVAL      OKMTIM = 'N'
     C                   EVAL      OKLANG = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = '#2MTIM'
     C                   EVAL      MsgIdArr(Idx) = 'SCC0022'
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRInit - Initialisation                                      *
      *                                                               *
      *  Called by: Main                                              *
      *                                                               *
      *  Calls    : None                                              *
      *                                                               *
      *****************************************************************
 
     C     SRInit        BEGSR
 
     C                   EVAL      OKMTIM = 'Y'
     C                   EVAL      OKLANG = 'Y'
     C                   EVAL      RetCodeIn = *BLANKS
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation routine                      *
      *                                                               *
      *  Called by: Implicitly on program activation                  *
      *                                                               *
      *  Calls    : None                                              *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
 
      ** INPUTS
      ** Return Code
 
     C                   PARM                    RetCodeIn
 
      ** Action Mode
 
     C                   PARM                    PAction
 
      ** Message Type
 
     C                   PARM                    PMType
 
      ** Message Time
 
     C                   PARM                    PMTime
 
      ** Language Code
 
     C                   PARM                    PLang
 
      ** OUTPUTS
      ** Message Text
 
     C                   PARM                    PMText
 
      ** OK - Message Time
 
     C                   PARM                    OKMTIM
 
      ** OK - Language Code
 
     C                   PARM                    OKLANG
 
      ** Errors
 
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
 
      ** Array index
 
     C                   PARM                    Idx
 
      ** Key list for LF/SCSYSTL2
 
     C     KSYST         KLIST
     C                   KFLD                    PMType
     C                   KFLD                    PMTime
     C                   KFLD                    WLang
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
** CPY@
(c) Misys International Banking Systems Ltd. 2001
