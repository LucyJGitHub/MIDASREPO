     H DEBUG
     H COPYRIGHT('(c) Finastra International Systems Ltd. 2020')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Customer Extended Details Validation')        *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  SDCUS11VL - Midas SD Customer Extended Details Validation    *
      *                                                               *
      *  (c) Finastra International Systems Ltd. 2020                 *
      *                                                               *
      *  Last Amend No. MD058097           Date 23Apr21               *
      *  Prev Amend No. LUC139             Date 23Dec20               *
      *                 BUG18898A          Date 12Feb09               *
      *                 CER008  *CREATE    Date 16Aug06               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD058097 - CUSD Insert check                                 *
      *  LUC139 - UCI Italian Returns Upgrade to FM2.1                *
      *  BUG18898A - Changes in APDUMP and APHEADPD (Recompile)       *
      *  CER008 - Base Italian Features Upgrade to MidasPlus          *
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
      **---------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
      /COPY ZACPYSRC,STD_D_SPEC
      **---------------------------------------------------------------

      **---------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
      /COPY ZACPYSRC,STDDECLARE
      **---------------------------------------------------------------

      **---------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
      /COPY ZACPYSRC,PSDS
      **---------------------------------------------------------------

      **---------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
      /COPY ZACPYSRC,ERR_ARRAYS
      **---------------------------------------------------------------

      **---------------------------------------------------------------
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the size
      ** of the arrays.
      /COPY ZACPYSRC,ERR_XARRYS
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

     D ValidCUSD     E DS                  Extname(SDVCUSDPD)
      ** Used to pass input Parms needed by validation modules

     D NwScnDtaIt1   E DS                  Extname(SDCUS1PD)
      ** Used to pass screen data to be validated

     D ValidCUSDItl  E DS                  Extname(SDCUT1PD)
     D                                     PREFIX(V)                                          CER008
      ** Used to contain successfully validated screen data

     D OkCUSDItl     E DS                  Extname(SDECUIT1PD)
      ** Transaction Details OK indicators

                                                                                            MD058097
     D PDATA           DS          1024                                                     MD058097
     D #1CUST                  1      6                                                     MD058097
     D #1PAIN                  7      7                                                     MD058097
     D #1PCNB                  8     13                                                     MD058097
     D #1COLC                 15     16                                                     MD058097
     D #1LINC                 17     18                                                     MD058097
     D #1BRCD                 19     21                                                     MD058097
     D #1BNBI                 22     22                                                     MD058097
     D #2CNCZ                 23     24                                                     MD058097
     D #1FOTR                 45     64                                                     MD058097
     D #1TMST                 65     90Z                                                    MD058097
     D #1CRNM                 91    110                                                     MD058097
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

     D MSG1            S                   Like(#MSGID)
     D WMSG            S                   Like(#MSGID)
     D MSGDATA         S                   Like(#MSGDATA)
     D*PCntyLoc****    S                   Like(CUCOLC)                                    MD058097
     D PCntyLoc        S                   Like(#1COLC)                                    MD058097

     D Idx             S              3P 0
      ** Index for arrays of of error message ids etc

     D WIdx            S              3P 0
      ** Index for arrays of of warning message ids etc

     D I               S              3P 0

      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+

      *****************************************************************
      /EJECT
      *****************************************************************

      ** Initial processing

     C                   Exsr      SrInitialize

      ** Validate Residenza field

     C                   Exsr      SrValRes

      ** If no error

     C                   If        Idx = 0
     C                   Exsr      SrSetVal
     C                   Endif

      ** Return

     C                   Return

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrInitialize - Initialize                                    *
      *                                                               *
      *****************************************************************

     C     SrInitialize  Begsr

     C                   Clear                   ValidCUSDItl

     C                   Endsr

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrValRes - Validate Residenza field                          *
      *                                                               *
      *****************************************************************
      *
     C     SrValRes      Begsr

      ** Reset variables updated by validation

     C                   Exsr      RESETERRS
     C**********         Eval      PCntyLoc = CUCOLC
     C                   Eval      PCntyLoc = #1COLC

      ** Validation module

     C                   Callb     'SDVTRESI'

     C                   Parm                    ReturnCode

     C                   Parm                    PCntyLoc
     C                   Parm                    DDTA004

     C                   Parm                    FldNamXAr
     C                   Parm                    MsgIDXAr
     C                   Parm                    MsgDtaXAr
     C                   Parm                    WFldNmXAr
     C                   Parm                    WMsgIDXAr
     C                   Parm                    WMsgDtXAr
     C                   Parm                    DDTA004Ok                                   LUC139

      ** Update error info with that returned from the validation module

     C                   Exsr      UPDATERRS

     C**********         Callb     'ZASETOKFLG'
     C**********         Parm                    DDTA004OK
     C**********         Parm                    ReturnCode
     C**********         Parm                    WarnGlobal

     C                   Endsr

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  RESETERRS - Reset error information that is received back    *
      *              from each validation module                      *
      *                                                               *
      *****************************************************************

     C     RESETERRS     Begsr

     C                   Eval      ReturnCode = *Blanks

      ** Reset error & warning fields/message IDs/message data (arrays)

     C                   Eval      FldNamXAr = *BLANK
     C                   Eval      MsgIDXAr  = *BLANK
     C                   Eval      MsgDtaXAr = *BLANK
     C                   Eval      WFldNmXAr = *BLANK
     C                   Eval      WMsgIDXAr = *BLANK
     C                   Eval      WMsgDtXAr = *BLANK

     C                   Eval      MSG1 = *Blanks
     C                   Eval      WMSG = *Blanks
     C                   Eval      MSGDATA = *Blanks

     C                   Endsr

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  UPDATERRS - Update error information with that received back *
      *              from each validation module                      *
      *                                                               *
      *****************************************************************

     C     UPDATERRS     Begsr

      ** Update error fields/message IDs/message data (arrays)

     C                   Z-ADD     1             I
     C     *BLANK        LOOKUP    FldNameArr(I)                          99
     C                   IF        *IN99 = *ON
     C                   MOVEA     FldNamXAr     FlDNameArr(I)
     C                   MOVEA     MsgIDXAr      MsgIdArr(I)
     C                   MOVEA     MsgDtaXAr     MsgDtaArr(I)
     C                   Endif

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
     C                   Endif

      ** Set Warning Index

     C                   Z-ADD     1             I
     C     *BLANK        LOOKUP    WFldNamArr(I)                          99
     C     I             SUB       1             WIdx

     C                   Endsr

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrSetVal - Setup Valids                                      *
      *                                                               *
      *****************************************************************

     C     SrSetVal      Begsr

     C**********         Eval      VBBCUST = CUCUST                                     HF240321
     C                   Eval      VBBCUST = #1CUST                                     HF240321
     C                   Eval      VBBA004 = DDTA004

     C                   Endsr

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation Routine                      *
      *                                                               *
      *****************************************************************

     C     *INZSR        Begsr

     C     *Entry        Plist

     C**********         Parm                    ValidCUSD                               MD058097
     C                   Parm                    PData                                   MD058097
     C                   Parm                    NwScnDtaIt1
     C                   Parm                    OkCUSDItl

     C                   Parm                    FldNameArr
     C                   Parm                    MsgIDArr
     C                   Parm                    MsgDtaArr
     C                   Parm                    Idx

     C                   Parm                    WFldNamArr
     C                   Parm                    WMsgIDArr
     C                   Parm                    WMsgDtaArr
     C                   Parm                    WIdx

     C                   Parm                    ValidCUSDItl

      **---------------------------------------------------------------
      ** The following /COPY sets the values of program, module and
      ** procedure names for database error processing.
      /COPY ZACPYSRC,DBFIELDS
      **---------------------------------------------------------------

     C                   Endsr

      *****************************************************************
      /EJECT
      *****************************************************************
      **---------------------------------------------------------------
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
      /COPY ZACPYSRC,PSSR_ILE
      **---------------------------------------------------------------
      *****************************************************************
**  CPY@
(c) Finastra International Systems Ltd. 2020
