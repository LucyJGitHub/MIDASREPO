     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2007')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Customer Risk Weighted Assets Details Validation')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  SDRWANVAL - Customer Risk Weighted Assets Details Validation *
      *                                                               *
      *  (c) Finastra International Limited 2007                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Prev Amend No. CSD079  *CREATE    Date 05Feb07               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD079 - Enhanced Customer Maintenance API
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      * Hook to enable non-core files to be included
      /COPY WNCPYSRC,SDRWANV001
 
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
     D TrnDets       E DS                  EXTNAME(SDRWANPD)
 
      ** Transaction Details OK indicators
     D OKTrnDets     E DS                  EXTNAME(SDERWANPD)
 
      ** Valid Transaction Details layout
     D ValidRwan     E DS                  EXTNAME(SDVRWANPD)
 
      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** Short DS for access programs
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Long DS for access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
     D ZMUSER          DS            17
     D  USRBCH                11     13
 
      ** array to store RWA Code
     D Cod_Arr         S              2    DIM(36)
 
      ** array to store RWA Set number
     D Set_Arr         S              1    DIM(36)
 
      ** array to store Combination of Code & Set Id
     D Com_Arr         S              3    DIM(36)
 
      ** Array to store Combination of Validated Code & Set Id
     D VCom_Arr        S              3    DIM(36)
 
      ** array for Code OK
     D DDCODOK_A       S              1    DIM(36)
 
      ** array for Set Id OK
     D DDSETOK_A       S              1    DIM(36)
 
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
     D Ctr             S              3P 0
     D Idx1            S              3P 0
     D I               S              3P 0
 
      ** Entry parameters
     D RespMode        S              1A
 
     D S01496          S              1A
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      /COPY WNCPYSRC,SDRWANV002
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *inzsr is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      ** Clear array for code & Set id
 
     C                   EXSR      Clear_Arr
 
      ** Populate code & Set id array
 
     C                   EXSR      Pop_CodSet
 
      ** Populate combination array of code & set id
 
     C                   Eval      Com_Arr = Cod_Arr + Set_arr
 
 
      /COPY WNCPYSRC,SDRWANV003
 
      ** Validate RWA Code & Set Number
 
      /COPY WNCPYSRC,SDRWANV004
     C                   Eval      Ctr = 1
     C                   Eval      Idx1 = 1
     C                   DOW       Com_Arr(Ctr)<>*BLANKS AND Ctr < 37
     C                   EXSR      VCODSR
     C                   Eval      Ctr = Ctr + 1
     C                   If        Ctr = 37
     C                   Leave
     C                   EndIf
     C                   ENDDO
      /COPY WNCPYSRC,SDRWANV005
 
      ** Populate Code & Set Id OK fields from Code & Set id array
 
     C                   EXSR      Pop_CodSetOK
      *
 
     C                   RETURN
 
      ** Hook to enable non-core subroutines to be included
 
      /COPY WNCPYSRC,SDRWANV006
 
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  VCODSR - Validate RWA Code & Set Number                      *
      *                                                               *
      *****************************************************************
     C     VCODSR        BEGSR
 
      ** Reset variables updated by validation
 
     C                   EXSR      RESETERRS
 
      ** Validate RWA Code & Set Number
 
     C                   CALLB     'SDVCOD'
 
      ** Inputs
      ** Return Code
 
     C                   PARM                    RetCodeIn
 
      ** Other parms
      ** RWA Code
 
     C                   PARM                    Cod_Arr(Ctr)
 
      ** RWA Set Id
 
     C                   PARM                    Set_Arr(Ctr)
 
      ** Validated Code/Set Combination
 
     C                   PARM                    VCom_arr
 
      ** Next available position for writing code/set combination array
 
     C                   PARM                    Idx1
      *
     C                   PARM                    Ctr
 
      ** Outputs
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** RWA Code       - OK
 
     C                   PARM                    DDCODOK_A(Ctr)
 
      ** RWA Set id      - OK
 
     C                   PARM                    DDSETOK_A(Ctr)
 
      ** Update error info with that returned from the validation
      ** module
 
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
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
      *  Clear_Arr - Subroutine for clearing code & set id arrays     *
      *                                                               *
      *****************************************************************
     C     Clear_Arr     BEGSR
     C                   Clear                   Cod_Arr
     C                   Clear                   Set_Arr
     C                   Clear                   Com_Arr
     C                   Clear                   VCom_Arr
     C                   MOVE      *ALL'Y'       DDCODOK_A
     C                   MOVE      *ALL'Y'       DDSETOK_A
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  Pop_CodSet - Subroutine for code & set id array population   *
      *                                                               *
      *****************************************************************
      *
     C     Pop_CodSet    BEGSR
 
     C                   Eval      Cod_Arr(1) = DDCOD1
     C                   Eval      Set_Arr(1) = DDSET1
     C                   Eval      Cod_Arr(2) = DDCOD2
     C                   Eval      Set_Arr(2) = DDSET2
     C                   Eval      Cod_Arr(3) = DDCOD3
     C                   Eval      Set_Arr(3) = DDSET3
     C                   Eval      Cod_Arr(4) = DDCOD4
     C                   Eval      Set_Arr(4) = DDSET4
     C                   Eval      Cod_Arr(5) = DDCOD5
     C                   Eval      Set_Arr(5) = DDSET5
     C                   Eval      Cod_Arr(6) = DDCOD6
     C                   Eval      Set_Arr(6) = DDSET6
     C                   Eval      Cod_Arr(7) = DDCOD7
     C                   Eval      Set_Arr(7) = DDSET7
     C                   Eval      Cod_Arr(8) = DDCOD8
     C                   Eval      Set_Arr(8) = DDSET8
     C                   Eval      Cod_Arr(9) = DDCOD9
     C                   Eval      Set_Arr(9) = DDSET9
     C                   Eval      Cod_Arr(10) = DDCOD10
     C                   Eval      Set_Arr(10) = DDSET10
     C                   Eval      Cod_Arr(11) = DDCOD11
     C                   Eval      Set_Arr(11) = DDSET11
     C                   Eval      Cod_Arr(12) = DDCOD12
     C                   Eval      Set_Arr(12) = DDSET12
     C                   Eval      Cod_Arr(13) = DDCOD13
     C                   Eval      Set_Arr(13) = DDSET13
     C                   Eval      Cod_Arr(14) = DDCOD14
     C                   Eval      Set_Arr(14) = DDSET14
     C                   Eval      Cod_Arr(15) = DDCOD15
     C                   Eval      Set_Arr(15) = DDSET15
     C                   Eval      Cod_Arr(16) = DDCOD16
     C                   Eval      Set_Arr(16) = DDSET16
     C                   Eval      Cod_Arr(17) = DDCOD17
     C                   Eval      Set_Arr(17) = DDSET17
     C                   Eval      Cod_Arr(18) = DDCOD18
     C                   Eval      Set_Arr(18) = DDSET18
     C                   Eval      Cod_Arr(19) = DDCOD19
     C                   Eval      Set_Arr(19) = DDSET19
     C                   Eval      Cod_Arr(20) = DDCOD20
     C                   Eval      Set_Arr(20) = DDSET20
     C                   Eval      Cod_Arr(21) = DDCOD21
     C                   Eval      Set_Arr(21) = DDSET21
     C                   Eval      Cod_Arr(22) = DDCOD22
     C                   Eval      Set_Arr(22) = DDSET22
     C                   Eval      Cod_Arr(23) = DDCOD23
     C                   Eval      Set_Arr(23) = DDSET23
     C                   Eval      Cod_Arr(24) = DDCOD24
     C                   Eval      Set_Arr(24) = DDSET24
     C                   Eval      Cod_Arr(25) = DDCOD25
     C                   Eval      Set_Arr(25) = DDSET25
     C                   Eval      Cod_Arr(26) = DDCOD26
     C                   Eval      Set_Arr(26) = DDSET26
     C                   Eval      Cod_Arr(27) = DDCOD27
     C                   Eval      Set_Arr(27) = DDSET27
     C                   Eval      Cod_Arr(28) = DDCOD28
     C                   Eval      Set_Arr(28) = DDSET28
     C                   Eval      Cod_Arr(29) = DDCOD29
     C                   Eval      Set_Arr(29) = DDSET29
     C                   Eval      Cod_Arr(30) = DDCOD30
     C                   Eval      Set_Arr(30) = DDSET30
     C                   Eval      Cod_Arr(31) = DDCOD31
     C                   Eval      Set_Arr(31) = DDSET31
     C                   Eval      Cod_Arr(32) = DDCOD32
     C                   Eval      Set_Arr(32) = DDSET32
     C                   Eval      Cod_Arr(33) = DDCOD33
     C                   Eval      Set_Arr(33) = DDSET33
     C                   Eval      Cod_Arr(34) = DDCOD34
     C                   Eval      Set_Arr(34) = DDSET34
     C                   Eval      Cod_Arr(35) = DDCOD35
     C                   Eval      Set_Arr(35) = DDSET35
     C                   Eval      Cod_Arr(36) = DDCOD36
     C                   Eval      Set_Arr(36) = DDSET36
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  Pop_CodSetOK - Subroutine for Code & Set id OK fields        *
      *                 population                                    *
      *                                                               *
      *****************************************************************
     C     Pop_CodSetOK  BEGSR
 
     C                   Eval      DDCOD1OK = DDCODOK_A(1)
     C                   Eval      DDSET1OK = DDSETOK_A(1)
     C                   Eval      DDCOD2OK = DDCODOK_A(2)
     C                   Eval      DDSET2OK = DDSETOK_A(2)
     C                   Eval      DDCOD3OK = DDCODOK_A(3)
     C                   Eval      DDSET3OK = DDSETOK_A(3)
     C                   Eval      DDCOD4OK = DDCODOK_A(4)
     C                   Eval      DDSET4OK = DDSETOK_A(4)
     C                   Eval      DDCOD5OK = DDCODOK_A(5)
     C                   Eval      DDSET5OK = DDSETOK_A(5)
     C                   Eval      DDCOD6OK = DDCODOK_A(6)
     C                   Eval      DDSET6OK = DDSETOK_A(6)
     C                   Eval      DDCOD7OK = DDCODOK_A(7)
     C                   Eval      DDSET7OK = DDSETOK_A(7)
     C                   Eval      DDCOD8OK = DDCODOK_A(8)
     C                   Eval      DDSET8OK = DDSETOK_A(8)
     C                   Eval      DDCOD9OK = DDCODOK_A(9)
     C                   Eval      DDSET9OK = DDSETOK_A(9)
     C                   Eval      DDCOD10OK = DDCODOK_A(10)
     C                   Eval      DDSET10OK = DDSETOK_A(10)
     C                   Eval      DDCOD11OK = DDCODOK_A(11)
     C                   Eval      DDSET11OK = DDSETOK_A(11)
     C                   Eval      DDCOD12OK = DDCODOK_A(12)
     C                   Eval      DDSET12OK = DDSETOK_A(12)
     C                   Eval      DDCOD13OK = DDCODOK_A(13)
     C                   Eval      DDSET13OK = DDSETOK_A(13)
     C                   Eval      DDCOD14OK = DDCODOK_A(14)
     C                   Eval      DDSET14OK = DDSETOK_A(14)
     C                   Eval      DDCOD15OK = DDCODOK_A(15)
     C                   Eval      DDSET15OK = DDSETOK_A(15)
     C                   Eval      DDCOD16OK = DDCODOK_A(16)
     C                   Eval      DDSET16OK = DDSETOK_A(16)
     C                   Eval      DDCOD17OK = DDCODOK_A(17)
     C                   Eval      DDSET17OK = DDSETOK_A(17)
     C                   Eval      DDCOD18OK = DDCODOK_A(18)
     C                   Eval      DDSET18OK = DDSETOK_A(18)
     C                   Eval      DDCOD19OK = DDCODOK_A(19)
     C                   Eval      DDSET19OK = DDSETOK_A(19)
     C                   Eval      DDCOD20OK = DDCODOK_A(20)
     C                   Eval      DDSET20OK = DDSETOK_A(20)
     C                   Eval      DDCOD21OK = DDCODOK_A(21)
     C                   Eval      DDSET21OK = DDSETOK_A(21)
     C                   Eval      DDCOD22OK = DDCODOK_A(22)
     C                   Eval      DDSET22OK = DDSETOK_A(22)
     C                   Eval      DDCOD23OK = DDCODOK_A(23)
     C                   Eval      DDSET23OK = DDSETOK_A(23)
     C                   Eval      DDCOD24OK = DDCODOK_A(24)
     C                   Eval      DDSET24OK = DDSETOK_A(24)
     C                   Eval      DDCOD25OK = DDCODOK_A(25)
     C                   Eval      DDSET25OK = DDSETOK_A(25)
     C                   Eval      DDCOD26OK = DDCODOK_A(26)
     C                   Eval      DDSET26OK = DDSETOK_A(26)
     C                   Eval      DDCOD27OK = DDCODOK_A(27)
     C                   Eval      DDSET27OK = DDSETOK_A(27)
     C                   Eval      DDCOD28OK = DDCODOK_A(28)
     C                   Eval      DDSET28OK = DDSETOK_A(28)
     C                   Eval      DDCOD29OK = DDCODOK_A(29)
     C                   Eval      DDSET29OK = DDSETOK_A(29)
     C                   Eval      DDCOD30OK = DDCODOK_A(30)
     C                   Eval      DDSET30OK = DDSETOK_A(30)
     C                   Eval      DDCOD31OK = DDCODOK_A(31)
     C                   Eval      DDSET31OK = DDSETOK_A(31)
     C                   Eval      DDCOD32OK = DDCODOK_A(32)
     C                   Eval      DDSET32OK = DDSETOK_A(32)
     C                   Eval      DDCOD33OK = DDCODOK_A(33)
     C                   Eval      DDSET33OK = DDSETOK_A(33)
     C                   Eval      DDCOD34OK = DDCODOK_A(34)
     C                   Eval      DDSET34OK = DDSETOK_A(34)
     C                   Eval      DDCOD35OK = DDCODOK_A(35)
     C                   Eval      DDSET35OK = DDSETOK_A(35)
     C                   Eval      DDCOD36OK = DDCODOK_A(36)
     C                   Eval      DDSET36OK = DDSETOK_A(36)
 
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
 
      ** Customer Risk Weighted Assets Details
 
     C                   PARM                    TrnDets
 
      ** Outputs
      ** Customer Risk Weighted Assets OK inds
 
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
 
      ** Valid Customer Risk Weighted Assets layout (DS) from/to caller
 
     C                   PARM                    ValidRWAN
 
      ** Access Bank Details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database Error
 
     C                   IF        @RTCD <> *BLANKS
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE  =  900
     C                   EVAL      DBKEY  = @OPTN
     C                   EXSR      *PSSR
     C                   ELSE
     C                   EVAL      WKDFIN = BJDFIN
     C                   EVAL      WKRDNB = BJRDNB
     C                   EVAL      WKCYCD = BJCYCD
     C                   ENDIF
 
      ** Check if switchable feature S01496 is switched on.
      ** Private Banking Securities Trading Enhancement
 
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'S01496'      @SARD
 
      ** Database Error
 
     C                   IF        @RTCD <> *BLANKS AND
     C                             @RTCD <> '*NRF   '
     C                   EVAL      DBKEY  = 'S01496'
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE  =  902
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   IF        @RTCD = *BLANK
     C                   MOVE      'Y'           S01496
     C                   ELSE
     C                   MOVE      'N'           S01496
     C                   ENDIF
      *
      **------------------------------------------------------------------
      ** The following /COPY sets the values of program, module and
      ** procedure names for database error processing.
     C/COPY ZACPYSRC,DBFIELDS
      **------------------------------------------------------------------
 
      ** Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,SDRWANV007
 
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
