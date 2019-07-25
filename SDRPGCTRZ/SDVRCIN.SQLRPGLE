     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2014')
      *****************************************************************
/*STD *  RPGSQLMOD                                                    *
/*EXI *  TEXT('Midas SD Validate Receive Instructions Details')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDVRCIN - Validate Receive Instructions Details              *
      *                                                               *
      *  (c) Finastra International Limited 2014                      *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. CDL094C01          Date 29Jul14               *
      *  Prev Amend No. CDL094  *CREATE    Date 30May14               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CDL094C01 - Prevent SWIFT BIC and allow Counterparty Nostro  *
      *              entry (MD-29082)                                 *
      *  CDL094 - Enhance Receive Settlement Instructions             *
      *                                                               *
      *****************************************************************


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

     D DSSDY         E DS                  EXTNAME(DSSDY)
      **  Long data structure for access programs

     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      **  External Data structure for customer details.

      ** Transaction Details OK indicators
     D OKTrnDets     E DS                  EXTNAME(SDENOSRPD)
      **  Validation flags for Intermediary banks fields
     D   DBOKFlags            20     25
     D   OkFlagsAry                   2    Dim(3)
     D                                     Overlay(DBOKFlags)

      ** Valid Transaction Details layout
     D ValidNosr     E DS                  EXTNAME(SDNOSRPD)
      ** Intermediary bank fields
     D   DBIntermeds         133    270
     D   IntBanks                    46    Dim(3)
     D                                     Overlay(DBIntermeds)

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      ** Index for arrays of error message ids etc
     D Idx             S              3P 0 Inz(0)
     D WIdx            S              3P 0 Inz(0)

     D IdIn            S             18    Inz
     D wOk             S               N
     D   P#Intermeds   S            138
     D   P#OKFLAGS     S              6
     D x               S              3U 0
     D RcdCnt          S              3U 0
     D CustInpType     S                   Like(@RtCd)
     D Key10           S             10
     D Key8            S              8                                                    CDL094C01

      ** Intermediary Customers/Banks
     D BankFldDs       DS
     D   Bank1                       10    Inz('DDRF56')
     D   Bank2                       10    Inz('DDRF57')
     D   Bank3                       10    Inz('DDRF58')
     D  BankFld                      10    Overlay(BankFldDs)
     D                                     Dim(3)

      ** Intermediary Customers/Banks Account Line
     D BankAcLineDS    DS
     D   BAL1                        10    Inz('DDRA56')
     D   BAL2                        10    Inz('DDRA57')
     D   BAL3                        10    Inz('DDRA58')
     D  BankAcLine                   10    Overlay(BankAcLineDS)
     D                                     Dim(3)

     D MsgStruct       DS                  Dim(3)
     D                                     Qualified
     D   MsgDta                      25    Inz
     D                                     VARYING
     D   Data                  1     27

      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
     C
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+

      ** Initialization

     C                   MOVE      *BLANK        RetCodeIn

     C                   Eval      DBIntermeds = P#Intermeds
     C                   Eval      DBOKFlags = P#OKFlags

     C                   MOVE      *BLANK        FldNamXAr
     C                   MOVE      *BLANK        MsgIDXAr
     C                   MOVE      *BLANK        MsgDtaXAr
     C                   Z-ADD     0             Idx
     C                   Z-ADD     0             WIdx

     C                   Exsr      ValCust
     C                   Exsr      ValAcctLine
      *
      * RETURN
      *
     C     EMAIN         TAG

     C                   Eval      P#Intermeds = DBIntermeds
     C                   Eval      P#OKFlags = DBOKFlags

     C                   Eval      *INLR = *Off
     C                   RETURN
      *****************************************************************
     C/EJECT
      *****************************************************************
      * ValCust - validate Receive Intermediary Banks/Customer        *
      *****************************************************************
     C     ValCust       BEGSR

      ** Intermediary banks

     C                   CLEAR                   X
     C                   For       x = 1 to 3
     C
     C**********         EVAL      IdIn = %Subst(IntBanks(x):1:11)                         CDL094C01
     C                   EVAL      IdIn = %Subst(IntBanks(x):1:10)                         CDL094C01
     C                   IF        IdIn = *BLANKS
     C                   ITER
     C                   ENDIF

     C                   EXSR      ChkCust

     C                   IF        not wOK
     C                   Eval      %Subst(OkFlagsAry(x):1:1) = 'N'

     C                   Eval      Idx = Idx + 1
     C                   Eval      MsgIDXAr(Idx) = '5046473'
     C                   Eval      MsgDtaXAr(Idx) = MsgStruct(x).Data
     C                   Eval      FldNamXAr(Idx) = BankFld(x)
     C                   Eval      RetCodeIn = 'Error'
     C
     C                   ENDIF

     C                   EndFor

     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      * ValAcctLine - Validate Intermediary Account Lines             *
      *****************************************************************
     C     ValAcctLine   BEGSR

      ** Intermediary Account Lines

     C                   Clear                   x
     C                   For       x = 1 to 3

      ** If Receive Bank Line is blank and
      **   Receive account line is not blank, issue Account Line error

     C**********         If        %Subst(IntBanks(x):1:11) = *Blanks                      CDL094C01
     C                   If        %Subst(IntBanks(x):1:10) = *Blanks                      CDL094C01
     C                             and %Subst(IntBanks(x):12:35)
     C                                 <> *Blanks

     C                   Eval      %Subst(OkFlagsAry(x):2:1) = 'N'

     C                   Eval      Idx = Idx + 1
     C                   Eval      MsgIDXAr(Idx) = '5046474'
     C                   Eval      MsgDtaXAr(Idx) = MsgStruct(x).Data
     C                   Eval      FldNamXAr(Idx) = BankAcLine(x)
     C                   Eval      RetCodeIn = 'Error'
     C
     C                   EndIf

      ** If first character of Account Line is not '/'
      ** then return an error

     C                   If        %Subst(IntBanks(x):1:11) <> *Blanks
     C                             and %Subst(IntBanks(x):12:35) <> *Blanks
     C                             and %Subst(IntBanks(x):12:1) <> '/'

     C                   Eval      %Subst(OkFlagsAry(x):2:1) = 'N'

     C                   Eval      Idx = Idx + 1
     C                   Eval      MsgIDXAr(Idx) = '5046475'
     C                   Eval      MsgDtaXAr(Idx) = MsgStruct(x).Data
     C                   Eval      FldNamXAr(Idx) = BankAcLine(x)
     C                   Eval      RetCodeIn = 'Error'

     C                   ENDIF

     C                   EndFor

     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      * ChkCust - Check for valid Customer number, Shortname,         *
      *           or BIC address                                      *
      *****************************************************************
     C     ChkCust       BEGSR

     C                   Eval      wOK = *On

     C**********         CallB     'AOBICDV01'                                             CDL094C01
     C**********         Parm      *Blanks       RetCodeIn                                 CDL094C01
     C**********         Parm                    IdIn                                      CDL094C01
     C**********         Parm                    CustInpType                               CDL094C01
     C**********         Parm                    DSSDY                                     CDL094C01
      **********                                                                           CDL094C01
     C**********         If        CustInpType <> '*BIC'                                   CDL094C01
      **********                                                                           CDL094C01
      ***Not*valid*BIC.*Check*further*if*valid*Customer*Number*********                    CDL094C01
      **********                                                                           CDL094C01
     C                   EVAL      Key8 = %Subst(IntBanks(x):1:8)                          CDL094C01
     C                   CallB     'AOCNSTR0'                                              CDL094C01
     C                   Parm      *Blanks       RetCodeIn                                 CDL094C01
     C                   Parm      '*KEY   '     @Optn                                     CDL094C01
     C                   Parm                    Key8                                      CDL094C01
     C                   Parm                    DSSDY                                     CDL094C01
                                                                                           CDL094C01
     C                   If        RetCodeIn <> *BLANKS                                    CDL094C01
     C                             OR %Subst(IntBanks(x):9:2) <> *BLANKS                   CDL094C01
                                                                                           CDL094C01
      ** Not valid Counterpart Nostro. Check further if valid Customer Number              CDL094C01
      ** or valid Customer Shortname

     C                   Eval      Key10  = IdIn

     C                   CallB     'AOCUSTR0'
     C                   Parm      *Blanks       @Rtcd
     C                   Parm      '*KEY   '     @Optn
     C                   Parm                    Key10
     C                   Parm      *Blanks       CustInpType
     C     SDCUST        PARM      *BLANKS       DSSDY

     C**********         IF        @Rtcd =  '*NRF   '                                     CDL094C01
     C                   IF        @Rtcd <> *BLANKS                                       CDL094C01
     C                             OR %Subst(IntBanks(x):11:1) <> *BLANKS                 CDL094C01

      ** Not valid Customer either.
      ***Check*if*found*as*BIC*in*SDCUSTPD*file************************                   CDL094C01
     C**/exec SQL                                                                         CDL094C01
     C**+ select count(*) into :RcdCnt                                                    CDL094C01
     C**+ from SDCUSTL7 where BBCSID = :IdIn                                              CDL094C01
     C**/end-exec                                                                         CDL094C01
      **                                                                                  CDL094C01
      ***If*record*not*found*or*file*access*error,*********************                   CDL094C01
      ***report*not*Ok*to*caller***************************************                   CDL094C01
     C**********         IF        RcdCnt = 0                                             CDL094C01
     C**********                   or SQLCOD < *zero                                      CDL094C01
     C**********         Eval      wOK = *OFF                                             CDL094C01
     C**********         EndIf                                                            CDL094C01

      ** Other AOCUST access errors
     C**********         ElseIf    @Rtcd <> *BLANKS                                       CDL094C01
     C                   Eval      wOK = *OFF
     C                   EndIf

     C                   EndIf

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
      ** Intermediary banks fields for validation
     C                   PARM                    P#Intermeds
      * OUTPUTS
     C                   PARM                    P#OKFLAGS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr

     C                   Eval      MsgStruct(1).MsgDta
     C                              = 'Receive Intermediary'
     C                   Eval      MsgStruct(2).MsgDta
     C                              = 'Receive Delivery Agent'
     C                   Eval      MsgStruct(3).MsgDta
     C                              = 'Receive Beneficiary'
      *
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
**  CPY@
(c) Finastra International Limited 2014
