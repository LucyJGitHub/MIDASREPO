     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2013')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Validate Clearing system code')               *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module - Customer Details Validation   *
      *                                                               *
      *  SDVCLCY - Validate Clearing system code                      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2013            *
      *                                                               *
      *  Last Amend No. MD022862           Date 17Oct13               *
      *  Prev Amend No. MD022557           Date 02Oct13               *
      *                 CFT050  *CREATE    Date 03Jun13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD022862 - LEI Code not accepted eventhough consists of first*
      *             18 uppercase character and last 2 numbers.        *
      *  MD022557 - Incorrect validation in MT3xx receiver party      *
      *             information and LEI                               *
      *  CFT050 - SWIFTRef Directories upload                         *
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
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
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
 
     D SDCCSY        E DS                  EXTNAME(SDCCSYPD)
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Valid Clearing system code
     D ClearingSys     S              2    DIM(16) CTDATA PERRCD(16)
      ** Valid Clearing system code
     D ClearingLen     S              2S 0 DIM(16) CTDATA PERRCD(16)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Work Variables
     D DDCYCD          S              3A
     D DDCLSY          S              2A
     D DDCLID          S             15A
     D DDLEN           S              2S 0
     D OKDDCLSY        S              1A
     D OKDDCLID        S              1A
     D WCLSYFLAG       S              1A
     D WCURRFLAG       S              1A
     D WWRTCD          S              7A
     D WWOPTN          S              7A
     D WLEN            S              2S 0
     D WWKY3           S              3A
     D WWKY2           S              2A
     D WIDX            S              2S 0
 
      ** Index for arrays of error message ids etc
     D Idx             S              3S 0
      ** Index for arrays of warning message ids etc
     D WIx             S              3S 0
 
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
 
      ** Initialization
 
     C                   MOVE      *BLANK        RetCodeIn
 
     C                   MOVE      *BLANK        FldNamXAr
     C                   MOVE      *BLANK        MsgIDXAr
     C                   MOVE      *BLANK        MsgDtaXAr
     C                   Z-ADD     0             Idx
 
     C                   EVAL      OKDDCLSY = 'Y'
      *
      ** Validation
      *
     C                   EXSR      SRCLSY
      *
      ** If an error was found, set the return code appropriately
      *
     C     OKDDCLSY      IFEQ      'N'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
      *
      *  RETURN
      *
     C                   RETURN
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** SRCLSY - Validate Clearing system code
      *****************************************************************
     C     SRCLSY        BEGSR
 
     C                   IF        DDCLSY <> *BLANKS
      ** Check Clearing code from ClearingSys arrayblanks
     C                   EVAL      WCLSYFLAG = *BLANKS
     C                   EVAL      WCURRFLAG = *BLANKS
     C                   IF        %LOOKUP(DDCLSY:ClearingSys) = 0
     C**********         EVAL      OKDDCLSY = 'N'                                           MD022557
     C**********         EVAL      Idx = Idx + 1                                            MD022557
     C**********         MOVEL     'DDCLSY'      FldNamXAr(Idx)                             MD022557
     C**********         MOVEL     '5046095'     MsgIDXAr(Idx)                              MD022557
     C                   EVAL      WCLSYFLAG = 'N'                                          MD022557
     C                   ELSE
     C                   EVAL      WIDX  = %LOOKUP(DDCLSY:ClearingSys)
     C                   EVAL      DDLEN = ClearingLen(WIDX)
     C                   ENDIF                                                              MD022557
      *
      ** Check if existing in Currency Clearing system table
      *
     C                   CALL      'AOCCSYR0'
     C                   PARM      *BLANKS       WWRTCD
     C                   PARM      '*KEY'        WWOPTN
     C                   PARM      DDCYCD        WWKY3
     C                   PARM      DDCLSY        WWKY2
     C     SDCCSY        PARM      SDCCSY        DSFDY
     C                   IF        WWRTCD <> *BLANKS
 
     C**********         EVAL      WIx = WIx + 1                                            MD022557
     C**********         MOVEL     'DDCLSY'      WFldNmXAr(WIx)                             MD022557
     C**********         MOVEL     '5046091'     WMsgIdXAr(WIx)                             MD022557
     C                   EVAL      WCURRFLAG = 'N'                                          MD022557
     C                   ENDIF
 
     C**********         ENDIF                                                              MD022557
                                                                                            MD022557
     C                   SELECT                                                             MD022557
     C                   WHEN      WCLSYFLAG = 'N'                                          MD022557
     C                             AND WCURRFLAG = 'N'                                      MD022557
     C                   EVAL      OKDDCLSY = 'N'                                           MD022557
     C                   EVAL      Idx = Idx + 1                                            MD022557
     C                   MOVEL     'DDCLSY'      FldNamXAr(Idx)                             MD022557
     C                   MOVEL     '5046095'     MsgIDXAr(Idx)                              MD022557
                                                                                            MD022557
     C                   WHEN      WCLSYFLAG = 'N'                                          MD022557
     C                             AND WCURRFLAG = ' '                                      MD022557
     C                   EVAL      WIx = WIx + 1                                            MD022557
     C                   MOVEL     'DDCLSY'      WFldNmXAr(WIx)                             MD022557
     C                   MOVEL     '5046091'     WMsgIdXAr(WIx)                             MD022557
     C                   ENDSL                                                              MD022557
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
     C/EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeIn
      *
      ** Other parms
      *
      ** Currency code
     C                   PARM                    DDCYCD
      ** Clearing system code
     C                   PARM                    DDCLSY
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Warning fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr
      *
      ** Other parms
      *
      ** Clearing system code - OK
     C                   PARM                    OKDDCLSY
      ** Clearing system code length
     C                   PARM                    DDLEN
      *
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      ********************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
      ** Copyright must be defined for compile time array definition                      MD022862
**  CPY@
(c) Misys International Banking Systems Ltd. 2013
**  Clearing system code
ATAUCCESGRHKIEINITNZPLPTRUSWZA
**  Clearing system code length
050609080703061110060808090306
