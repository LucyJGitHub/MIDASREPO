     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2006')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Validate Settlement Type')                             *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module - Validate Settlement Type      *
      *                                                               *
      *  SDVSTTY -  validate Settlement Type                          *
      *                                                               *
      *  (c) Finastra International Limited 2006                      *
      *                                                               *
      *   /COPY, Customer Future and Options Details amendments must  *
      *        not be applied to this source.                         *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. MD025484           Date 19Aug14               *
      *                 MD000091           Date 15May13               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 CSD079  *CREATE    Date 05Feb07               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD025484 - Duplicate DDSMAC Settlement Account field in CUSD *
      *  MD000091 - Event Codes Substitution                          *
      *  CSD079 - Enhanced Customer Maintenance API                   *
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
      ** ¦ =====================================¦
      ** +-------------------------------------- +
      ** External DS for Access programs
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** External DS for Trading Details
     D SDTRAD        E DS                  EXTNAME(SDTRADPD)
      ** External DS for Retail Banking Details
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      **
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      ** Define work field Transaction Type
     D WUTRTY          S              2
      ** Define work field Special Instructions
     D WUSPI           S             35
      ** Define work field US Dollars Currency Code
     D WUUSCY          S              3
      ** Define work field Retail Banking
     D WURTBN          S              1
      ** Define work field Retail A/C Nos. Required?
     D WURANR          S              1
      ** Define work field Account Code
     D WUACCD          S             10
      ** Define work field Store customer number
     D WUSCNB          S              6
      ** Define Work field for Return Code
     D W0RTN           S              7
      **
     D WUCPNO          S             10
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
     D WIdx            S              3P 0
 
      ** Parameters
     D DDSTTY          S              2A
     D DDFACO          S             10A
     D DDCPNO          S              8A
     D DDSMAC          S             18A
     D DDCYCD          S              3A
     D DDCUST          S              6A
     D DDSTTYOK        S              1A
     D DDFACOOK        S              1A
     D DDCPNOOK        S              1A
     D DDSMACOK        S              1A
     D FOCPNO          S              8A
                                                                                            MD000091
      **                                                                                    MD000091
     D BChar           DS                                                                   MD000091
     D   BLen                  1      2B 0                                                  MD000091
     D   LenStr                1      2                                                     MD000091
     D   MsgDtaTmp                   99                                                     MD000091
 
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
 
     C                   MOVE      *BLANK        FldNamXAr
     C                   MOVE      *BLANK        MsgIDXAr
     C                   MOVE      *BLANK        MsgDtaXAr
     C                   Z-ADD     0             Idx
     C                   Z-ADD     0             WIdx
 
      ** Validation
      ** Validate Settlement Type,
      ** Check if Settlement Type is Blank
     C                   IF        DDSTTY = *BLANK
      ** Send message 'Settlement Type Required'
     C                   EVAL      DDSTTYOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDSTTY    '
     C                   EVAL      MsgIdXAr(Idx)  = 'USR1214'
      *
     C                   ELSE
      ** Validate Settlement types - Futures & Options Clients  *
     C                   CALL      'SD0332U'                            90
     C     W0RTN         PARM                    W0RTN
     C     DDCYCD        PARM                    DDCYCD
     C     DDCUST        PARM                    DDCUST
     C     WUTRTY        PARM                    WUTRTY
     C     DDSTTY        PARM                    DDSTTY
     C     DDSMAC        PARM                    DDSMAC
     C     DDCPNO        PARM      DDCPNO        WUCPNO
     C     DDFACO        PARM                    DDFACO
     C     WUSPI         PARM                    WUSPI
     C                   PARM                    WUUSCY
     C                   PARM                    WURTBN
     C                   PARM      *BLANKS       WURANR
     C                   PARM      *BLANKS       WUACCD
     C     WUSCNB        PARM      *BLANKS       WUSCNB
 
     C                   IF        *IN90 = *ON
      ** Send message '*Error occurred on CALL...'
     C                   EVAL      DDSTTYOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDSTTY    '
     C                   EVAL      MsgIdXAr(Idx)  = 'Y2U0032'
     C**********         EVAL      MsgDtaXAr(Idx) = 'SD0332U '
     C                   EVAL      MsgDTATmp = 'SD0332U '                                   MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaXAr(Idx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   ENDIF
 
      ** Settlement types Return Codes,
      ** Error Messages based on the Return Codes,
      ** Return code is Invalid Format
     C                   IF        W0RTN = 'INVALFT'
      ** Send message 'Invalid Format'
     C                   EVAL      DDSTTYOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDSTTY    '
     C                   EVAL      MsgIdXAr(Idx)  = 'USR0285'
 
     C                   ENDIF
 
      ** Return code is Invalid Settlement Method
     C                   IF        W0RTN = 'TPINVAL'
      ** Send message 'invalid set type'
     C                   EVAL      DDSTTYOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDSTTY    '
     C                   EVAL      MsgIdXAr(Idx)  = 'USR0515'
 
     C                   ENDIF
      ** For Account of Return Codes,
      ** Return code is For Acct Of must be blank
     C                   IF        W0RTN = 'FORNEBL'
      ** Setup message data for message
      ** Send message 'For Account Of NE Blank'
     C                   EVAL      DDFACOOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDFACO    '
     C                   EVAL      MsgIdXAr(Idx)  = 'USR0290'
     C                   ENDIF
 
      ** CounterParty Nostro Return Codes,
      ** Return code is No Selection
     C                   IF        W0RTN = 'NOSEL'
      ** Send message 'No Code Selected.'
     C                   EVAL      DDCPNOOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDCPNO    '
     C                   EVAL      MsgIdXAr(Idx)  = 'USR0530'
     C                   ENDIF
 
      ** Return code is Need a Nostro
     C                   IF        W0RTN = 'NEEDNOS'
      ** Send message 'Nostro Rqd for 01,07,08'
     C                   EVAL      DDCPNOOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDCPNO    '
     C                   EVAL      MsgIdXAr(Idx)  = 'USR0529'
     C                   ENDIF
 
      ** Return code is *Normal
     C                   IF        W0RTN = *BLANK
      ** Store customer number is Not Blank
     C     WUSCNB        IFNE      *BLANK
     C                   MOVEL     *BLANK        FOCPNO
     C                   MOVEL     WUSCNB        FOCPNO
     C                   MOVEL     *BLANK        DDCPNO
     C                   MOVEL     WUSCNB        DDCPNO
     C                   ELSE
      *
     C                   MOVEL     DDCPNO        FOCPNO
     C                   ENDIF
     C                   ENDIF
 
      ** Return code is Nostro Not Found
     C                   IF        W0RTN = 'NONOST'
      ** Send message 'A/C not found on Nostro'
     C                   EVAL      DDCPNOOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDCPNO    '
     C                   EVAL      MsgIdXAr(Idx)  = 'USR0277'
     C                   ENDIF
 
      ** Return code is Nostro should be blank
     C                   IF        W0RTN= 'NOSNEBL'
      ** Send message 'Their CCY Nostro'
     C                   EVAL      DDCPNOOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDCPNO    '
     C                   EVAL      MsgIdXAr(Idx)  = 'USR0287'
     C                   ENDIF
 
      ** Return code is No Cust/Counterparty found
     C                   IF        W0RTN = 'NOCUSCP'
      ** Send message 'Invalid Cust/Cparty No.'
     C                   EVAL      DDCPNOOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDCPNO    '
     C                   EVAL      MsgIdXAr(Idx)  = 'USR0288'
     C                   ENDIF
 
      ** Return code is Counterparty Invalid
     C                   IF        W0RTN = 'CPINVAL'
      ** Send message 'C/party Nostro invalid'
     C                   EVAL      DDCPNOOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDCPNO    '
     C                   EVAL      MsgIdXAr(Idx)  = 'USR0289'
     C                   ENDIF
 
      ** Return code is Cust/Cparty not found
     C                   IF        W0RTN = 'CUSCPNO'
      ** Send message 'Cust/Cparty not on file'
     C                   EVAL      DDCPNOOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDCPNO    '
     C                   EVAL      MsgIdXAr(Idx)  = 'USR0291'
     C                   ENDIF
 
      ** Return code is Invalid Counterparty
     C                   IF        W0RTN = 'INVALCP'
      ** Send message 'Invalid Counterparty'
     C                   EVAL      DDCPNOOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDCPNO    '
     C                   EVAL      MsgIdXAr(Idx)  = 'USR0292'
     C                   ENDIF
 
      ** Return code is nost must be blank
     C                   IF        W0RTN = 'NOSNOVA'
      ** Send message 'cp nost must be blank'
     C                   EVAL      DDCPNOOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDCPNO    '
     C                   EVAL      MsgIdXAr(Idx)  = 'USR0523'
     C                   ENDIF
 
      ** Settlement Account Return Codes,
      ** Return code is Account should be blank
     C                   IF        W0RTN = 'ACNEBLK'
      ** Send message 'Account Blank - 04 06 15'
     C                   EVAL      DDCPNOOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C**********         EVAL      FldNamXAr(Idx) = 'DDSMAC    '                            MD025484
     C                   EVAL      FldNamXAr(Idx) = 'DDSMAC2   '                            MD025484
     C                   EVAL      MsgIdXAr(Idx)  = 'USR1213'
      *
     C                   ENDIF
 
      ** Return code is Acct not on Master file
     C                   IF        W0RTN = 'NOACMAS'
      ** Send message 'settlement account not valid'
     C                   EVAL      DDCPNOOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C**********         EVAL      FldNamXAr(Idx) = 'DDSMAC    '                            MD025484
     C                   EVAL      FldNamXAr(Idx) = 'DDSMAC2   '                            MD025484
     C                   EVAL      MsgIdXAr(Idx)  = 'USR0514'
      *
     C                   ENDIF
 
      ** Return code is settlement account required
     C                   IF        W0RTN = 'NEEDSTA'
      ** Send message 'settlement account required'
     C                   EVAL      DDSMACOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C**********         EVAL      FldNamXAr(Idx) = 'DDSMAC    '                            MD025484
     C                   EVAL      FldNamXAr(Idx) = 'DDSMAC2   '                            MD025484
     C                   EVAL      MsgIdXAr(Idx)  = 'USR0516'
      *
     C                   ENDIF
 
      ** Return code is Non numeric data not valid,
     C                   IF        W0RTN = 'ALPADAT'
      ** Send message 'no numeric data not valid'
     C                   EVAL      DDSMACOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C**********         EVAL      FldNamXAr(Idx) = 'DDSMAC    '                            MD025484
     C                   EVAL      FldNamXAr(Idx) = 'DDSMAC2   '                            MD025484
     C                   EVAL      MsgIdXAr(Idx)  = 'USR0517'
      *
     C                   ENDIF
 
      ** EndIf for DDSTTY IFEQ Blanks,
     C                   ENDIF
 
      ** Return
     C     EMAIN         TAG
     C                   RETURN
      *****************************************************************
     C/EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
      ** Inputs
      ** Return Code
     C                   PARM                    RetCodeIn
      ** Other parms
      ** Field(s) requiring validation
      ** Settlement type
     C                   PARM                    DDSTTY
      ** For Account of
     C                   PARM                    DDFACO
      ** Counterparty Nostro
     C                   PARM                    DDCPNO
      ** Settlement Account
     C                   PARM                    DDSMAC
      ** Currency Code
     C                   PARM                    DDCYCD
      ** Customer Number
     C                   PARM                    DDCUST
      ** Outputs
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      ** Settlement Type - OK
     C                   PARM                    DDSTTYOK
      ** For Account of - OK
     C                   PARM                    DDFACOOK
      ** Counterparty Nostro -OK
     C                   PARM                    DDCPNOOK
      ** Settlement Account - OK
     C                   PARM                    DDSMACOK
      ** Counterparty Nostro
     C                   PARM                    FOCPNO
 
      ** Retrieval of US Dollars Currency code, from Trading Data file
     C                   CALLB     'AOTRADR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDTRAD        PARM      SDTRAD        DSFDY
      ** Database Error if the record not found,
     C                   IF        @RTCD <> *BLANKS AND
     C                             @RTCD <> '*NRF   '
     C                   EVAL      DBKEY  = '@OPTN  '
     C                   EVAL      DBFILE = 'SDTRADPD'
     C                   EVAL      DBASE  = 900
     C                   EXSR      *PSSR
     C                   ENDIF
      ** US Dollars Currency Code
     C                   EVAL      WUUSCY = BLUSCY
 
      ** Retrieval of Retail Banking field,Midas Module Flag Retrieval,
     C                   CALL      'AOMMODR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDMMOD        PARM      SDMMOD        DSFDY
      ** Database Error if the record not found,
     C                   IF        @RTCD <> *BLANKS AND
     C                               @RTCD <> '*NRF   '
     C                   EVAL      DBKEY  = '@OPTN  '
     C                   EVAL      DBFILE = 'SDMMODPD'
     C                   EVAL      DBASE  = 901
     C                   EXSR      *PSSR
     C                   ENDIF
      ** Retail Banking Module,
     C                   EVAL      WURTBN = BGRTBN
 
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
(c) Finastra International Limited 2006
