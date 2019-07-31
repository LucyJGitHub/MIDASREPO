     H DEBUG
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas PB Filter Refused of Invalid Transactions')      *
      *****************************************************************
      *                                                               *
      *  Midas - Private Banking Module                               *
      *                                                               *
      *  RP1593 - Filter Refused of Invalid Transactions              *
      *                                                               *
      *  Function:    This module is called each time replication send*
      *               refused transaction back from Midas(Delete of   *
      *               transaction in Midas Repair). It's function     *
      *               is to avoid the send when it's is originated on *
      *               specific system i.e. CityDealer. All to forbiden*
      *               system for send back of delete are listed  in   *
      *               file RPSYRFPD.                                  *
      *                                                               *
      *  Component of: RP1592 - Filter Refused of Invalid Transactions*
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CSD092             Date 01May13               *
      *                 CSD093             Date 01Apr13               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CGL031             Date 05Jul04               *
      *                 229699             Date 21Sep04               *
      *                 215336  *CREATE    Date 21Mar03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD092 - Account Review                                      *
      *  CSD093 - Document Management                                 *
      *  CGL031 - Taxation of Savings Income                          *
      *  229699 - Replace DDFOTRANID with DDFRNT from PMIPFDMPD.      *
      *  215336 - Avoid send back of transaction in repair(action code*
      *           is 'Q')when not originated by TOF(i.e. CityDealer)  *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      * System name to not receive Refused Invalid
     FRPSYRFPD  IF   E             DISK    Usropn
     F                                     Infsr(*Pssr)
      /Eject
      *****************************************************************
      /Space 3
      *****************************************************************
      *                                                               *
      *                S U B R O U T I N E   I N D E X                *
      *                -------------------------------                *
      *                                                               *
      *  RtvPos   - retrieve position in Meridian message.            *
      *  Repair   - Repair process                                    *
      *  WrtTrace - Trace process                                     *
      *  *Pssr    - Program exception error routine                   *
      *  *Inzsr   - Program Initialization routine.                   *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
 
      ** The following /COPY contains various standard declares
     C***/COPY*RPCPYSRC,Std_Dcl                                                               CSD092
     C/COPY RPCPYSRC,STD_DCL                                                                  CSD092
 
      ** The following /COPY contains the layout of the Meridian header as
      ** a data structure
     C***/COPY*RPCPYSRC,Mdn_Hd_DS                                                             CSD092
     C/COPY RPCPYSRC,MDN_HD_DS                                                                CSD092
 
      ** Following /COPY is the declares for fields passed to the formatting
      **  routines
     C/COPY RPCPYSRC,RPFMTDCL
 
      ** Following /COPY is the procedure prototype for the Packed routine
     C/COPY RPCPYSRC,RPFMTPPP
 
      ** Following /COPY is the procedure prototype for the Signed routine
     C/COPY RPCPYSRC,RPFMTPPS
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      *****************************************************************
      /Eject
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      **  Array containing Copyright statement.
     D Cpy@            S             80    Dim(1) Ctdata Perrcd(1)
 
      ** Midas Local Data Area for database error reporting; based on
      ** external file
     D Lda           E DS           256    Extname(LDA) Dtaara
      ** The following fields are defined in the external file:
      **                                    134 141 DBFile
      **                                    142 170 DBKey
      **                                    171 180 DBPgm
      **                                    181 1830DBase
      **                                    184 193 DBMod
      **                                    194 203 DBProc
 
      **  Arrays used to store Position and Length of each fields
     D ArrFld          S             10    Dim(100)
     D ArrPos          S              7  0 Dim(100)
     D ArrLen          S              4  0 Dim(100)
      **
     D ArrPfx          S             10    Dim(100)
     D Pref_N          S              3  0
 
      ** Replication Defaults Data Area; based on external file.
     D RPDftsDa      E DS           256    Extname(RPDFTSDA) DTAARA(RPDFTSDA)
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      **-------------------- Start of parameters --------------------**
 
      **  Output queue name.
     D OutQueue        S                   Like(MQSQueue)
 
      **--------------------- End of parameters ---------------------**
 
      **-------------- Start of parameters for RPC1305 --------------**
 
      **  Script Name.
     D ScriptName      S             10A
      **  Image Name.
     D ImageName       S             32A
      **  Field Name.
     D FieldName       S             10A
      **  Field Type.
     D FieldType       S              1A
      **  Field Value.
     D FieldValue      S           9999A
      **  Field Position.
     D FieldPosition   S              7S 0
      **  Field Length
     D FieldLength     S              4S 0
 
      **--------------- End of parameters for RPC1305 ---------------**
     D MessageInd      S              1A
 
     D RAMSGOLD        S                   LIKE(RAMSGTYPE)
 
      **   Database Error Messsage Text
     D DBErrText       S            256A
 
      **   Transaction Data of associated transaction
     D AssocData       S                   LIKE(TransData)
 
      **   Meridian header Layout of associated transaction
     D MdHdAssoc       S                   LIKE(MdnHeadDs)
     D RAMSGSTOR       S                   LIKE(RAMSGTYPE)
     D FrontOfID       S             20A
     D FrOFldName      S             10A
 
      ** --------- Start of fields used by access programs ----------**
      ** ---------- End of fields used by access programs -----------**
 
      **  Work Field used as position for each numeric fields
     D W_PosDebut      S              2S 0
     D fmDpLen         S              1A
 
      **  End Position.
     D EndPosition     S              7S 0
 
      **  Work Field used to condition Meridian message sending.
     D W_SendMsg       S              1A
 
      **  Work Field used to produce only one dump.
     D W_RunBefore     S              1A
 
      **  Composite Data.
     D CompData        S                   LIKE(TransData)
 
      ** True and False can be used for indicators being on or off.
     D True            C                   *On
     D False           C                   *Off
 
      **  Work field used to set up return code when no record found.
     D W_NoRcdFnd      C                   CONST('*NoRcdFnd')
 
      **  Work field used for change message type
     D W_PosFin        S              3S 0
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
     C     Start         Tag
 
      ** Note: the above tag is only there to force the first comments in
      ** the C-specs to appear after the D- or I-specs in compiled listings.
 
      *****************************************************************
      *                                                               *
      *                  M A I N  P R O C E S S I N G                 *
      **   +------------------------------------------------------+   *
      **   ¦                                                      ¦   *
      **   ¦ Initial processing is performed automatically: the   ¦   *
      **   ¦ *inzsr is executed at program activation.            ¦   *
      **   ¦                                                      ¦   *
      **   +------------------------------------------------------+   *
      *                                                               *
      *****************************************************************
 
     C                   If        RAMSGSTOR <> RAMSGTYPE
     C                   Clear                   ArrFld
     C                   Clear                   ArrPos
     C                   Clear                   ArrLen
     C                   EXSR      *INZSR
     C                   EndIf
 
     C                   Eval      MessageInd = 'Y'
     C                   Eval      RAMSGOLD = RAMSGTYPE
     C                   Eval      AssocData = *Blanks
     C                   Eval      MdHdAssoc = *Blanks
 
      **  Enter the processing to read the additional files and produce a
      **  composite message here.
 
      **  Extract Front Office ID from message data.
     C
     C                   Z-add     1             X
     C     FrOFldName    Lookup    Arrfld(X)                              89
     C                   Eval      FrontOfID = %Subst(TransData:+
     C                             ArrPos(X):ArrLen(X))
 
      **----------------- Start of Additionnal fields ---------------**
 
     C                   Eval      W_SendMsg = 'Y'
     C
     C                   If        Pref_N>0
 
     C     1             Do        Pref_N        Idx               3 0
      ** For each System prefix check if this prefix is containing in the FrontOffice ID
 
     C                   Movea     ArrPfx(Idx)   W_Temp10         10
     C     ' '           Scan      W_Temp10:1    Pos               2 0
     C                   Eval      Pos=Pos-1
     C                   If        Pos > 0
     C     W_Temp10:Pos  Scan      FrontOfID:1   Pos
     C                   If        Pos=1
     C                   Eval      W_SendMsg = 'N'
     C                   EndIf
     C                   EndIf
 
     C                   EndDo
 
     C                   EndIf
     C
     C                   If        W_SendMsg='Y'
      **
      **  Place the result in field CompData.
 
     C                   Eval      CompData = %subst(TransData:1:EndPosition)
 
      **  Call a standard routine to actually send the message.
     C                   Callb     'RPSNDMSG'
     C                   Parm                    OutQueue
     C                   Parm                    MdnHeadDS
     C                   Parm                    CompData
     C                   Parm                    CommitCtl
     C                   Parm                    ReturnCode
 
      ** If error then perform any special processing and exit
     C                   If        ReturnCode <> *blank                         Begin ReturnCode
     C     *Lock         In        Lda
     C                   Move      'RPSNDMSG  '  DBpgm
     C                   Out       Lda
     C                   Exsr      Repair
 
      **  If no error, commit the unit of work so that messages that have
      **  been got from a queue would be permanently deleted and put
      **  operations would be made permanent.
     C                   Else                                                   Else ReturnCode
 
     C                   Exsr      WrtTrace
     C                   Commit
 
     C                   Endif                                                  End ReturnCode
 
     C                   Endif                                                  End W_SendMsg
 
     C                   Return
 
      /Eject
      *****************************************************************
      *                                                               *
      *  RtvPos   - retrieve position in Meridian message.            *
      *                                                               *
      *  Called by : Main processing.                                 *
      *                                                               *
      *  Calls     : None.                                            *
      *                                                               *
      *****************************************************************
 
     C     RtvPos        Begsr
 
     C                   Callb     'RPC1305'
     C                   Parm                    ScriptName
     C                   Parm      RAMSGTYPE     ImageName
     C                   Parm                    FieldName
     C                   Parm                    FieldType
     C                   Parm                    TransData
     C                   Parm      0             FieldPosition
     C                   Parm      0             FieldLength
     C                   Parm      *blank        FieldValue
     C                   Parm      *blank        ReturnCode
 
      **  If any error occurred while retrieving position, handle it.
     C     ReturnCode    Ifne      *blanks                                      Begin ReturnCode
     C     *lock         In        Lda
     C                   Eval      DBpgm  = PSProcName
     C                   Eval      DBfile = 'Call    '                          ***************
     C                   Eval      DBase  = 06                                  * Db Error 06 *
     C                   Eval      DBkey  = 'RPC1305'                           ***************
     C                   Out       LDA
     C****               Exsr      *Pssr
 
     C                   Eval      MessageInd = 'N'
     C                   Exsr      Repair
     C                   Eval      MessageInd = 'Y'
     C                   Endif                                                  End ReturnCode
 
     C                   Eval      X = X + 1
      **  If any error occurred while retrieving position, handle it.
     C                   If        X > 100
     C     *lock         In        Lda
     C                   Eval      DBpgm  = PSProcName
     C                   Eval      DBfile = 'Array   '                          ***************
     C                   Eval      DBase  = 07                                  * Db Error 07 *
     C                   Eval      DBkey  = 'Index  '                           ***************
     C                   Out       LDA
     C****               Exsr      *Pssr
     C                   Exsr      Repair
     C                   Endif                                                  End ReturnCode
 
     C                   Eval      ArrFld(X) = FieldName
     C                   Eval      ArrPos(X) = FieldPosition
     C                   Eval      ArrLen(X) = FieldLength
 
     C                   Endsr
      /Eject
      *****************************************************************
      *                                                               *
      *  WrtTrace - Write a Trace of outgoing messages.               *
      *                                                               *
      *  Called by : Main processing.                                 *
      *                                                               *
      *  Calls     : None.                                            *
      *                                                               *
      *****************************************************************
 
     C     WrtTrace      Begsr
 
     C                   Callb     'RP1590'
     C                   Parm                    OutQueue
     C                   Parm                    MdnHeadDS
     C                   Parm                    CompData
     C                   Parm                    CommitCtl
     C                   Parm                    ReturnCode
 
      **  If any error occurred while retrieving position, handle it.
     C     ReturnCode    Ifne      *blanks                                      Begin ReturnCode
     C     *Lock         In        Lda
     C                   Eval      DBpgm  = PSProcName
     C                   Eval      DBfile = 'Call    '                          ***************
     C                   Eval      DBase  = 08                                  * Db Error 08 *
     C                   Eval      DBkey  = 'RP1590'                            ***************
     C                   Out       Lda
 
     C                   Endif                                                  End ReturnCode
     C                   Endsr
 
      /Eject
      *****************************************************************
      *                                                               *
      *  Repair   - Write a Trace of outgoing messages to repair      *
      *                                                               *
      *  Called by : Main processing.                                 *
      *                                                               *
      *  Calls     : None.                                            *
      *                                                               *
      *****************************************************************
 
     C     Repair        Begsr
 
     C                   Move      Dbase         dbasea            3
 
     C                   Eval      DBErrText = 'DBError' +
     C                             ' in : ' + DBpgm +
     C                             ' at: ' + DBasea +
     C                             ' file : ' + DBfile +
     C                             ' Key : ' + DBKey +
     C                             ' Return :' + ReturnCode
 
     C                   Eval      RAMSGTYPE = RAMSGOLD
 
     C                   Callb     'RP1592'
     C                   Parm                    OutQueue
     C                   Parm                    MdnHeadDS
     C                   Parm                    TransData
     C                   Parm                    MdHdAssoc
     C                   Parm                    AssocData
     C                   Parm                    CommitCtl
     C                   Parm                    DBErrText
     C                   Parm                    MessageInd
     C                   Parm      *Blanks       ReturnCode
 
      **  If any error occurred while retrieving position, handle it.
     C     ReturnCode    Ifne      *blanks                                      Begin ReturnCode
     C     *Lock         In        Lda
     C                   Eval      DBpgm  = PSProcName
     C                   Eval      DBfile = 'Call    '                          ***************
     C                   Eval      DBase  = 50                                  * Db Error 50 *
     C                   Eval      DBkey  = 'RP1592'                            ***************
     C                   Out       Lda
 
     C                   exsr      *pssr
     C                   Else
     C                   Return
     C                   Endif                                                  End ReturnCode
 
     C                   Endsr
 
 
      /Eject
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: (**calling routines**)                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *                                                               *
      *****************************************************************
 
     C     *Pssr         Begsr
 
     C     W_RunBefore   Ifeq      *blank                                       Begin W_RunBefore
 
      **  If commitment control required, back out the unit of work so
      **  that current message could be available again.
     C                   If        CommitCtl = 'Y'                              Begin CommiCtl
     C                   Rolbk
 
     C                   Endif                                                  End CommitCtl
 
     C     *Lock         In        Lda
     C     DBpgm         Ifeq      *blanks                                      Begin DBpgm
     C                   Move      PSProcName    DBpgm
     C                   Out       Lda
 
     C                   Endif                                                  End DBpgm
 
     C                   Move      'Y'           W_RunBefore
     C                   Dump
 
     C                   Endif                                                  End W_RunBefore
 
     C     ReturnCode    Ifeq      *blank                                       Begin ReturnCode
     C                   Eval      ReturnCode = '*PSSR'
     C                   Endif                                                  End ReturnCode
 
     C                   Seton                                        U7U8LR
     C                   Return
 
     C                   Endsr
      /Eject
      *****************************************************************
      *                                                               *
      * *Inzsr - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
 
     C     *Inzsr        Begsr
 
     C     *Entry        Plist
      ** MQSeries queue to write to - this parameter IS used in this module
     C                   Parm                    OutQueue
      ** Merdian header
     C                   Parm                    MdnHeadDS
      ** Transaction Data
     C                   Parm                    TransData
      ** Commitment control flag
     C                   Parm                    CommitCtl
      ** Return Code
     C                   Parm                    ReturnCode
 
     C                   Eval      MessageInd = 'Y'
 
      **  Set up work fields for formatting that will not change if
      **  Replication formatting is required.
      **     - signs are not shown for Positive numbers.
      **     - get decimal separator from Replication data area RPDFTSDA.
     C                   In        RPDftsDa
     C                   Eval      fmDecSep   = RCDECSEP
     C                   Eval      fmDpLen  = %Subst(RCZEROFLD:2:1)
     C                   Move      fmDpLen       W_PosDebut
     C                   Eval      fmShwPsSgn = 'N'
 
      **  Set up work fields that will not change if retrieve
      **  function is to be used.
     C                   Eval      ScriptName = 'RP' + RATGTSYS
 
     C                   Z-add     0             X                 3 0
 
     C                   Select
 
      **  Fund Transfer invalid
     C                   When      RAMSGTYPE='FTIOPAYPD_A'
     C                   Eval      FrOFldName='SFOTRANID'
 
      **  FX deal invalid
     C                   When      RAMSGTYPE='FXIFXDLPD_A'
     C                   Eval      FrOFldName='DDFOTRANID'
 
      **  Account detail invalid
     C                   When      RAMSGTYPE='GLIAMADPD_A'
     C                   Eval      FrOFldName='DDFOTRANID'
 
      **  Deal amendment invalid
     C                   When      RAMSGTYPE='MMIDEAMPD_A'
     C                   Eval      FrOFldName='DDFOTRANID'
 
      **  MM Deal invalid
     C                   When      RAMSGTYPE='MMILDNIPD_A'
     C                   Eval      FrOFldName='DDFOTRANID'
 
      **  Portf. Def. invalid
     C                   When      RAMSGTYPE='PMIPFDMPD_A'
     C**********         Eval      FrOFldName='DDFOTRANID'                                    229699
     C                   Eval      FrOFldName='DDFRNT'                                        229699
 
      **  PB Cust. Details invalid
     C                   When      RAMSGTYPE='SDICUPBPD_A'
     C                   Eval      FrOFldName='DDFOTRANID'
 
      **  Depot Mvt. invalid
     C                   When      RAMSGTYPE='SEIDPMVPD_A'
     C                   Eval      FrOFldName='FOFFID'
 
      **  Security Trade invalid
     C                   When      RAMSGTYPE='SEITRADPD_A'
     C                   Eval      FrOFldName='DDFOTRANID'
 
     ** Invalid  AB API int contracts
     C                   When      RAMSGTYPE='ABIINTCPD_A'
     C                   Eval      FrOFldName='DDFOTRANID'
 
     ** Invalid  FF exchange-traded
     C                   When      RAMSGTYPE='FFIEXTRPD_A'
     C                   Eval      FrOFldName='SEFOTRANID'
 
     ** Invalid  FF broker settlement instructions
     C                   When      RAMSGTYPE='FFIBSETPD_A'
     C                   Eval      FrOFldName='SBFOTRANID'
 
     ** Invalid  FF customer settlement instructions
     C                   When      RAMSGTYPE='FFICSETPD_A'
     C                   Eval      FrOFldName='SCFOTRANID'
 
     ** Invalid  FF OTC currency options
     C                   When      RAMSGTYPE='FFIOTCCPD_A'
     C                   Eval      FrOFldName='SOFOTRANID'
 
     ** Invalid  FF OTC
     C                   When      RAMSGTYPE='FFIOTCPPD_A'
     C                   Eval      FrOFldName='SPFOTRANID'
 
     ** Invalid IR cross currency
     C                   When      RAMSGTYPE='IRICIRSPD_A'
     C                   Eval      FrOFldName='SFOTRANID'
 
     ** Invalid IR Valid interest rate calendars
     C                   When      RAMSGTYPE='IRIDTSCPD_A'
     C                   Eval      FrOFldName='SFOTRANID'
 
     ** Invalid  IR Invalid forward aggreement
     C                   When      RAMSGTYPE='IRIFRAPD_A'
     C                   Eval      FrOFldName='SFOTRANID'
 
     ** Invalid  IR single currency interest rate swap
     C                   When      RAMSGTYPE='IRISIRSPD_A'
     C                   Eval      FrOFldName='SFOTRANID'
 
     ** Invalid  MM NA's Purchased
     C                   When      RAMSGTYPE='MMINASPPD_A'
     C                   Eval      FrOFldName='FRONTOFFID'
 
     ** Invalid  MM NA's Sold
     C                   When      RAMSGTYPE='MMINASSPD_A'
     C                   Eval      FrOFldName='FRONTOFFID'
 
     ** Invalid  SD Customer
     C                   When      RAMSGTYPE='SDICUSDPD_A'
     C                   Eval      FrOFldName='DDFOTRANID'
 
     ** Invalid  SD Customer BRT details
     C                   When      RAMSGTYPE='SDICUBRPD_A'
     C                   Eval      FrOFldName='DDFOTRANID'
 
     ** Invalid  SD Customer
     C                   When      RAMSGTYPE='SDICEXPD_A'
     C                   Eval      FrOFldName='PBFRNT'
 
     ** Invalid  SD customer security detail
     C                   When      RAMSGTYPE='SDISECDPD_A'
     C                   Eval      FrOFldName='DDFOTRANID'
 
     ** Invalid  SE Securities
     C                   When      RAMSGTYPE='SEISECSPD_A'
     C                   Eval      FrOFldName='DDFRNT'
 
     ** Invalid  SD Additional Customer Details                                               CGL031
     C                   When      RAMSGTYPE='SDIACUDPD_A'                                    CGL031
     C                   Eval      FrOFldName='DDFRNT'                                        CGL031
                                                                                              CGL031
     ** Invalid  SD Customer Details by Country of Tax                                        CGL031
     C                   When      RAMSGTYPE='SDICCTXPD_A'                                    CGL031
     C                   Eval      FrOFldName='DDFRNT'                                        CGL031
                                                                                              CGL031
     ** Invalid  SD Joint Account Members                                                     CGL031
     C                   When      RAMSGTYPE='SDIJACMPD_A'                                    CGL031
     C                   Eval      FrOFldName='DDFRNT'                                        CGL031
                                                                                              CGL031
     ** Invalid  SD Non-account Holders                                                       CGL031
     C                   When      RAMSGTYPE='SDINAHLPD_A'                                    CGL031
     C                   Eval      FrOFldName='DDFRNT'                                        CGL031
                                                                                              CGL031
     ** Invalid  SD Non-a/c Holders by Country of Tax                                         CGL031
     C                   When      RAMSGTYPE='SDINATXPD_A'                                    CGL031
     C                   Eval      FrOFldName='DDFRNT'                                        CGL031
                                                                                              CGL031
      ** Invalid  SD Account Review                                                           CSD092
     C                   WHEN      RAMSGTYPE='SDIACRVPD_A'                                    CSD092
     C                   EVAL      FrOFldName='DDFOTRANID'                                    CSD092
                                                                                              CSD092
     ** Invalid  SD Document Management                                                       CSD093
     C                   WHEN      RAMSGTYPE='SDIDCMTPD_A'                                    CSD093
     C                   EVAL      FrOFldName='DDFOTRANID'                                    CSD093
                                                                                              CSD093
     C                   EndSl
 
      **  Retrieve position and length of Charge Account from DPTMVD message data.
     C                   Eval      FieldName   = FrOFldName
     C                   Eval      FieldType   = 'A'
     C                   Exsr      RtvPos
 
      **  Retrieve begin position of additionnal fields in Meridian message.
     C                   Eval      FieldName   = '*END_IMAGE'
     C                   Eval      FieldType   = *blank
     C                   Exsr      RtvPos
     C                   Eval      EndPosition = FieldPosition - 1
 
     ** Store Message type
     C                   EVAL      RAMSGSTOR = RAMSGTYPE
     C                   OPEN(E)   RPSYRFPD
     C                   If        %ERROR
 
     **  If error on open, consider list empty.
     C                   EVAL      Pref_N=0
     C
     C                   Else
     ** Store all prefix system
     C                   EVAL      Pref_N=1
     C     1             SETLL     RPSYRFPD
     **
     C                   READ      RPSYRFPD                               01
     C                   Dow       *IN01='0' and  Pref_N<100
     C                   If        RSPREF<>*BLANKS
     C                   Eval      ArrPfx(Pref_N)=RSPREF
     C                   Eval      Pref_N=Pref_N+1
     C                   EndIf
     C                   READ      RPSYRFPD                               01
     C                   EndDo
     C                   EVAL      Pref_N=Pref_N-1
     C                   CLOSE     RPSYRFPD
     C                   EndIf
 
     C                   Endsr
      /Eject
      *****************************************************************
 
**  CPY@
(c) Finastra International Limited 2003
