      *****************************************************************
     H DEBUG
     H DFTACTGRP (*NO)
     H COPYRIGHT('(c) Finastra International Limited 2010')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas UT Validation List Maintenance')                 *
      *****************************************************************
      *                                                               *
      *  Midas - Utilities Module                                     *
      *                                                               *
      *  UT000034 - Validation List maintenance                       *
      *                                                               *
      *  Function:  This program handles the entries contained        *
      *             within a given validation list.                   *
      *             It uses DSM API's which displays the input        *
      *             fields dynamically based on length passed.        *
      *                                                               *
      *  (c) Finastra International Limited 2010                      *
      *                                                               *
      *  Last Amend No. MD056350           Date 31Jul20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CUT007  *CREATE    Date 22Nov10               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD056350 - Error with buffer when emulation is 24*80.        *
      *  MD046248 - Finastra Rebranding                               *
      *  CUT007 - Make utility file-driven.                           *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  PutGet    - Write/read from/to screen                        *
      *  InzScr    - Initialise screen                                *
      *  SetDsp    - Display screen header                            *
      *  InsDsp    - Insert screen                                    *
      *  AmdDsp    - Amend screen                                     *
      *  ValInp    - Validate user's input                            *
      *  MovInp    - Move user input to variables                     *
      *  ExtPgm    - Exit program                                     *
      *  *INZSR    - Initialise                                       *
      *                                                               *
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

     D ClrBuf          PR                  extproc( 'QsnClrBuf' )               clear buffer
     D   Buffer                      10I 0
     D   ErrorCode                   10I 0 const

     D ClrScr          PR                  extproc( 'QsnClrScr' )               clear screen
     D   Mode                         1A   const
     D   CmdBuf                      10I 0
     D   LowLevel                    10I 0 const
     D   ErrorCode                   10I 0 const

     D CrtCmdBuf       PR                  extproc( 'QsnCrtCmdBuf' )            create command buff
     D   InitSize                    10I 0 const
     D   Increment                   10I 0 const
     D   Maximum                     10I 0 const
     D   CmdBuf                      10I 0
     D   ErrorCode                   10I 0 const

     D CrtInpBuf       PR                  extproc( 'QsnCrtInpBuf' )            create input buffer
     D   InitSize                    10I 0 const
     D   Increment                   10I 0 const
     D   Maximum                     10I 0 const
     D   CmdBuf                      10I 0
     D   ErrorCode                   10I 0 const

     D DltBuf          PR                  extproc( 'QsnDltBuf' )               delete buffer
     D   Buffer                      10I 0
     D   ErrorCode                   10I 0 const

     D ReadInp         PR                  extproc( 'QsnReadInp' )              read input fields
     D   ControlChar1                 1A   const
     D   ControlChar2                 1A   const
     D   NoFldDtaRd                  10I 0
     D   InpBuf                      10I 0
     D   CmdBuf                      10I 0
     D   LowLevel                    10I 0 const
     D   ErrorCode                   10I 0 const

     D RtvDta          PR              *   extproc( 'QsnRtvDta' )               retrieve data
     D   InpBuf                      10I 0
     D   Data                          *
     D   ErrorCode                   10I 0 const

     D RtvDtaLen       PR            10I 0 extproc( 'QsnRtvDtaLen' )            retrieve data length
     D   InpBuf                      10I 0
     D   DataLen                     10I 0
     D   ErrorCode                   10I 0 const

     D SetCsrAdr       PR                  extproc( 'QsnSetCsrAdr' )            set cursor address
     D   FieldId                     10I 0 const
     D   Row                         10I 0 const
     D   Column                      10I 0 const
     D   CmdBuf                      10I 0
     D   LowLevel                    10I 0 const
     D   ErrorCode                   10I 0 const

     D SetFld          PR                  extproc( 'QsnSetFld' )               set field
     D   FieldId                     10I 0 const
     D   FieldLength                 10I 0 const
     D   Row                         10I 0 const
     D   Column                      10I 0 const
     D   FldFmtWord                   2A   const
     D   FldCtlWord                  10A   const
     D   FldCtlCount                 10I 0 const
     D   MonoAttr                     1A   const
     D   ColorAttr                    1A   const
     D   CmdBuf                      10I 0
     D   LowLevel                    10I 0 const
     D   ErrorCode                   10I 0 const

     D WrtDta          PR                  extproc( 'QsnWrtDta' )               write data
     D   Data                     32767A   const
     D   DataLength                  10I 0 const
     D   FieldId                     10I 0 const
     D   Row                         10I 0 const
     D   Column                      10I 0 const
     D   StartMono                    1A   const
     D   EndMono                      1A   const
     D   StartColor                   1A   const
     D   EndColor                     1A   const
     D   CmdBuf                      10I 0
     D   LowLevel                    10I 0 const
     D   ErrorCode                   10I 0 const

     D WTD             PR                  extproc( 'QsnWTD' )                  write to display
     D   ControlChar1                 1A   const
     D   ControlChar2                 1A   const
     D   CmdBuf                      10I 0
     D   LowerLevel                  10I 0 const
     D   ErrorCode                   10I 0 const

     D RtvReadAID      PR             1A   EXTPROC('QsnRtvReadAID')
     D  InpBfrHnd                    10I 0 const
     D  AIDCod                        1A   options(*omit)
     D  ErrorCode                    10I 0 const

      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+

      * AID keys (function keys).
     D Qsn_F12         C                   X'3C'

      * Control characters ( CC1 & CC2 ).
     D QSN_CC1_NULL    C                   X'00'
     D QSN_CC2_NULL    C                   X'00'
     D QSN_CC2_SET_CSR_BL...
     D                 C                   X'18'

      * Screen Attributes.
     D QSN_SA_NORM     C                   X'20'
     D QSN_SA_RI       C                   X'21'
     D QSN_SA_HI       C                   X'22'
     D QSN_SA_UL       C                   X'24'
     D QSN_SA_ND       C                   X'27'

     D QSN_SA_GRN      C                   X'20'
     D QSN_SA_WHT      C                   X'22'
     D QSN_SA_GRN_UL   C                   X'24'
     D QSN_SA_GRN_UL_RI...
     D                 C                   X'25'
     D QSN_SA_ND_37    C                   X'37'
     D QSN_SA_BLU      C                   X'3A'

      * Field format words.
     D QSN_FFW_ALPHA_SHIFT...
     D                 C                   X'4000'

      ** +--------------------------------------+
      ** ¦ Data Structures                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+

     D                 DS
     D Force_Align                     *
     D Var                           32A   dim( Max )
     D   VarPtr                        *   overlay( Var :  1 )
     D   Var_Id                      10I 0 overlay( Var : 17 )
     D   VarLen                      10I 0 overlay( Var : 21 )
     D   VarRow                       3U 0 overlay( Var : 25 )
     D   VarCol                       3U 0 overlay( Var : 26 )
     D   VarRowCol                    2A   overlay( Var : 25 )

     D                 DS                  based( Data@ )
     D DataByte                       1A
     D DataRowCol                     2A
     D Data                       32767A

     D                SDS
     D PgmName               001    010
     D Job_Name              244    253
     D UserPrf               254    263

     D InputData       ds                  qualified
     D                                     based(p_InputData)
     D   Row                          3U 0
     D   Col                          3U 0
     D   AID                          1A
     D   Field                      807A

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

     D CmdBuf          S             10I 0
     D FldCnt          S             10I 0
     D InpBuf          S             10I 0
     D DataLen         S             10I 0
     D Work            S          32767A   based( Work@ )
     D Max             C                   const( 4 )

      * Entry parameters.
     D Action          S              1A
     D ValidList       S             10A
     D Library         S             10A
     D IDLen           S             10I 0
     D PwdLen          S             10I 0
     D DscLen          S             10I 0
     D IDTx            S             30A
     D ID              S            100A
     D Pwd1            S            600A
     D Desc            S           1000A

      * Parameters.
     D PReturnCode     S              7A
     D PAction         S              1A
     D PValidList      S             10A
     D PLibrary        S             10A
     D PIDName         S            100A
     D PPass1          S            600A
     D PPass2          S            600A
     D PDescr          S           1000A

      * Variables.
     D Aid             S              1A
     D InpFlds         S           1074A
     D ExtFlg          S              1N   inz(*off)
     D ErrFlg          S              1N   inz(*off)
     D IntFlg          S              1N   inz(*off)
     D ProcFlg         S              1N
     D len             s             10I 0
     D Pwd2            S            600A
     D Pwd3            S            600A
     D Pwd4            S            600A
     D IDTxTmp         S             30A
     D IDTxDot         S             30A   inz('. . . . . . . . . . . . . . .:')
     D a               S             30A
     D b               S             30A
      *
      /EJECT
      *****************************************************************
      * MAIN - Processing
      *****************************************************************
      *
     C                   EXSR      InzScr
     C                   EXSR      SetDsp
      *
     C                   DOW       (Aid <> Qsn_F12) and (ExtFlg = *Off)
     C                   SELECT
      *
      * Insert
     C                   WHEN      Action = 'I'
     C                   EXSR      InsDsp
      *
      * Amend
     C                   WHEN      Action = 'A'
     C                   EXSR      AmdDsp
     C                   ENDSL
      *
     C                   ENDDO
      *
     C                   EXSR      ExtPgm
     C                   RETURN
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Initialisation                                      *
      *                                                               *
      *  Called by: Main Processing                                   *
      *                                                               *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
     C                   PARM                    Action
     C                   PARM                    ValidList
     C                   PARM                    Library
     C                   PARM                    IDLen
     C                   PARM                    PwdLen
     C                   PARM                    DscLen
     C                   PARM                    IDTx
     C                   PARM                    ID
     C                   PARM                    Pwd1
     C                   PARM                    Desc
     C                   PARM                    ProcFlg
      *
     C                   Eval      IDTxTmp = %Subst(IDTx:1:%Len(%Trim(IDTx))) +
     C                                       %Subst(IDTxDot:%Len(%Trim(IDTx))
     C                                       + 1 :(30 - %Len(%Trim(IDTx))))
      *
     C     INZSRE        ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  PutGet - Put/Get Data                                        *
      *                                                               *
      *  Called by: Main Processing                                   *
      *                                                               *
      *  Calls: DSM API                                               *
      *                                                               *
      *****************************************************************
     C     PutGet        BEGSR
      *
      * Clear input buffer.
     C                   CALLP     ClrBuf( InpBuf : 0 )
      *
      * Read input fields.
     C                   CALLP     ReadInp( QSN_CC1_NULL : QSN_CC2_NULL :
     C                                  FldCnt : InpBuf : CmdBuf : 0 : 0 )
      *
      * Read function key.
     C                   CALLP     RtvReadAid( InpBuf : Aid : 0 )
      *
      * Retrieve data.
     C                   EVAL      p_InputData = RtvDta( InpBuf : Data@ : 0 )
      *
      * Retrieve data length.
     C                   EVAL      len = RtvDtaLen( InpBuf : DataLen : 0 )
     C                                   - %size(InputData.ROW)
     C                                   - %size(InputData.COL)
     C                                   - %size(InputData.AID)

     C                   IF        len > 0
     C                   EVAL      InpFlds = %subst(InputData.field
     C                                       :1:len)
     C                   EXSR      MovInp
     C                   ENDIF
      *
     C     PutGetE       ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  InzScr - Initialize screen                                   *
      *                                                               *
      *  Called by: Main Processing                                   *
      *                                                               *
      *  Calls: DSM API                                               *
      *                                                               *
      *****************************************************************
     C     InzScr        BEGSR
      *
     C                   IF        Action = 'I'
      *
      * Dynamically define "ID" input field.
     C                   Z-ADD     IDLen         VarLen( 1 )
     C                   Z-ADD     7             VarRow( 1 )
     C                   Z-ADD     34            VarCol( 1 )
      *
      * Dynamically define "Password/Current Password" input field.
     C                   Z-ADD     PwdLen        VarLen( 2 )
     C                   Z-ADD     10            VarRow( 2 )
     C                   Z-ADD     34            VarCol( 2 )
      *
      * Dynamically define "Confirm Password/New Password" input field.
     C                   Z-ADD     PwdLen        VarLen( 3 )
     C                   Z-ADD     14            VarRow( 3 )
     C                   Z-ADD     34            VarCol( 3 )
      *
      * Define "Description" input field.
     C                   Z-ADD     DscLen        VarLen( 4 )
     C                   Z-ADD     18            VarRow( 4 )
     C                   Z-ADD     34            VarCol( 4 )
      *
     C                   ENDIF
      *
     C                   IF        Action = 'A'
      *
      * Dynamically define "Current Password" input field.
     C                   Z-ADD     PwdLen        VarLen( 1 )
     C                   Z-ADD     09            VarRow( 1 )
     C                   Z-ADD     34            VarCol( 1 )
      *
      * Dynamically define "New Password" input field.
     C                   Z-ADD     PwdLen        VarLen( 2 )
     C                   Z-ADD     13            VarRow( 2 )
     C                   Z-ADD     34            VarCol( 2 )
      *
      * Dynamically define "Confirm New Password" input field.
     C                   Z-ADD     PwdLen        VarLen( 3 )
     C                   Z-ADD     17            VarRow( 3 )
     C                   Z-ADD     34            VarCol( 3 )
      *
      * Define "Description" input field.
     C                   Z-ADD     DscLen        VarLen( 4 )
     C                   Z-ADD     21            VarRow( 4 )
     C                   Z-ADD     34            VarCol( 4 )
      *
     C                   ENDIF
      *
      * Allocate storage for input fields.
     C     1             DO        Max           X                10 0
     C                   If        VarLen( X ) <> *Zero
     C                   Z-ADD     X             Var_Id( X )
     C                   ALLOC     VarLen( X )   VarPtr( X )
     C                   MOVE      VarPtr( X )   Work@
     C                   EVAL      %subst( Work : 1 : VarLen( X )) = *blanks
     C                   Endif
     C                   ENDDO
      *
      * Create command buffer.
     C**********         CALLP     CrtCmdBuf( 6300 : 6300 : 0 : CmdBuf : 0 )                MD056350
     C                   CALLP(E)  CrtCmdBuf( 6300 : 6300 : 0 : CmdBuf : 0 )                MD056350
      *
     C                   if        %error                                                   MD056350
     C                   CALLP     CrtCmdBuf( 4500 : 4500 : 0 : CmdBuf : 0 )                MD056350
     C                   CALLP     CrtInpBuf( 4500 : 4500 : 0 : InpBuf : 0 )                MD056350
     C                   else                                                               MD056350
      * Create input buffer.
     C                   CALLP     CrtInpBuf( 6300 : 6300 : 0 : InpBuf : 0 )
     C                   endif                                                              MD056350
      *
      * Clear screen.
     C                   CALLP     ClrScr( '3' : CmdBuf : 0 : 0 )
      *
      * Write to display.
     C                   CALLP     WTD( QSN_CC1_NULL : QSN_CC2_SET_CSR_BL :
     C                             CmdBuf : 0 : 0 )
      *
     C     InzScrE       ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  SetDsp - This will set the screen display header.            *
      *                                                               *
      *  Called by: Main Processing                                   *
      *                                                               *
      *  Calls: DSM API                                               *
      *                                                               *
      *****************************************************************
     C     SetDsp        BEGSR
      *
     C                   CALLP     WrtDta( UserPrf
     C                                  : 10 : 0 : 1 : 2 : QSN_SA_NORM :
     C                                  QSN_SA_NORM: QSN_SA_GRN : QSN_SA_GRN :
     C                                  CmdBuf : 0 : 0 )
     C                   CALLP     WrtDta( PgmName
     C                                  : 10 : 0 : 1 : 13 : QSN_SA_NORM :
     C                                  QSN_SA_NORM: QSN_SA_GRN : QSN_SA_GRN :
     C                                  CmdBuf : 0 : 0 )
     C                   CALLP     WrtDta( 'Validation List Manager'
     C                                  : 23 : 0 : 1 : 29 : QSN_SA_HI :
     C                                  QSN_SA_NORM : QSN_SA_WHT : QSN_SA_GRN :
     C                                  CmdBuf : 0 : 0 )
     C                   CALLP     WrtDta( %Char(%Date():*USA)
     C                                  : 10 : 0 : 1 : 71 : QSN_SA_NORM :
     C                                  QSN_SA_NORM: QSN_SA_GRN : QSN_SA_GRN :
     C                                  CmdBuf : 0 : 0 )
     C                   CALLP     WrtDta( Job_Name
     C                                  : 22 : 0 : 2 : 2 : QSN_SA_NORM :
     C                                  QSN_SA_NORM: QSN_SA_GRN : QSN_SA_GRN :
     C                                  CmdBuf : 0 : 0 )
     C                   CALLP     WrtDta( 'Work with List Entries'
     C                                  : 22 : 0 : 2 : 30 : QSN_SA_HI :
     C                                  QSN_SA_NORM : QSN_SA_WHT : QSN_SA_GRN :
     C                                  CmdBuf : 0 : 0 )
     C                   CALLP     WrtDta( %Char(%Time():*HMS)
     C                                  : 22 : 0 : 2 : 72 : QSN_SA_NORM :
     C                                  QSN_SA_NORM: QSN_SA_GRN : QSN_SA_GRN :
     C                                  CmdBuf : 0 : 0 )
     C                   CALLP     WrtDta( 'Type the following and press ENTER'
     C                                  : 34 : 0 : 5 : 2 : QSN_SA_NORM :
     C                                  QSN_SA_NORM : QSN_SA_BLU : QSN_SA_GRN :
     C                                  CmdBuf : 0 : 0 )
      *
     C     SetDspE       ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  InsDsp - Insert display                                      *
      *                                                               *
      *  Called by: Main Processing                                   *
      *                                                               *
      *  Calls: DSM API                                               *
      *                                                               *
      *****************************************************************
     C     InsDsp        BEGSR
      *
     C                   IF        Not IntFlg
      * Write constant.
     C                   CALLP     WrtDta( 'INSERT'
     C                                  : 26 : 0 : 3 : 74 : QSN_SA_HI :
     C                                  QSN_SA_NORM : QSN_SA_WHT : QSN_SA_GRN :
     C                                  CmdBuf : 0 : 0 )
      *
      * Write constant.
     C                   CALLP     WrtDta( IDTxTmp
     C                                  : 30 : 0 : 7 : 3 : QSN_SA_NORM :
     C                                  QSN_SA_NORM: QSN_SA_GRN : QSN_SA_GRN :
     C                                  CmdBuf : 0 : 0 )
      *
      * Write "ID" input field.
     C                   CALLP     SetFld( Var_Id( 1 ) :
     C                                     VarLen( 1 ) :
     C                                     VarRow( 1 ) :
     C                                     VarCol( 1 ) : QSN_FFW_ALPHA_SHIFT :
     C                                     ' ' : 0 : QSN_SA_UL : QSN_SA_GRN_UL :
     C                                     CmdBuf : 0 : 0 )
      *
      * Write constant.
     C                   CALLP     WrtDta( 'Password. . . . . . . . . . .:'
     C                                  : 30 : 0 : 10 : 3 : QSN_SA_NORM :
     C                                  QSN_SA_NORM: QSN_SA_GRN : QSN_SA_GRN :
     C                                  CmdBuf : 0 : 0 )
      *
      * Write "Password" input field.
     C                   CALLP     SetFld( Var_Id( 2 ) :
     C                                     VarLen( 2 ) :
     C                                     VarRow( 2 ) :
     C                                     VarCol( 2 ) : QSN_FFW_ALPHA_SHIFT :
     C                                     ' ' : 0 : QSN_SA_ND : QSN_SA_ND_37 :
     C                                     CmdBuf : 0 : 0 )
      *
      * Write constant.
     C                   CALLP     WrtDta( 'Confirm Password. . . . . . .:'
     C                                  : 30 : 0 : 14 : 3 : QSN_SA_NORM :
     C                                  QSN_SA_NORM: QSN_SA_GRN : QSN_SA_GRN :
     C                                  CmdBuf : 0 : 0 )
      *
      * Write "Confirm Password" input field.
     C                   CALLP     SetFld( Var_Id( 3 ) :
     C                                     VarLen( 3 ) :
     C                                     VarRow( 3 ) :
     C                                     VarCol( 3 ) : QSN_FFW_ALPHA_SHIFT :
     C                                     ' ' : 0 : QSN_SA_ND : QSN_SA_ND_37 :
     C                                     CmdBuf : 0 : 0 )
      *
      * Write constant.
     C                   CALLP     WrtDta( 'Description . . . . . . . . .:'
     C                                  : 30 : 0 : 18 : 3 : QSN_SA_NORM :
     C                                  QSN_SA_NORM: QSN_SA_GRN : QSN_SA_GRN :
     C                                  CmdBuf : 0 : 0 )
      *
      * Write "Description' input field.
     C                   CALLP     SetFld( Var_Id( 4 ) :
     C                                     VarLen( 4 ) :
     C                                     VarRow( 4 ) :
     C                                     VarCol( 4 ) : QSN_FFW_ALPHA_SHIFT :
     C                                     ' ' : 0 : QSN_SA_UL : QSN_SA_GRN_UL :
     C                                     CmdBuf : 0 : 0 )
      *
      * Write constant
     C                   CALLP     WrtDta( 'F12=Previous'
     C                                  : 12 : 0 : 23 : 2 : QSN_SA_NORM :
     C                                  QSN_SA_NORM : QSN_SA_BLU : QSN_SA_GRN :
     C                                  CmdBuf : 0 : 0 )
      *
      * Put / get the screen.
     C                   EXSR      PutGet
      *
     C                   EVAL      IntFlg = *On
     C                   ENDIF
      *
     C                   EXSR      ValInp
      *
      * Put / get the screen.
     C                   IF        ErrFlg
     C                   EXSR      PutGet
     C                   ELSE
     C                   EVAL      ProcFlg = *On
     C                   EVAL      ExtFlg = *On
     C                   ENDIF
      *
     C     InsDspE       ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  AmdDsp - Amend display                                       *
      *                                                               *
      *  Called by: Main Processing                                   *
      *                                                               *
      *  Calls: DSM API                                               *
      *                                                               *
      *****************************************************************
     C     AmdDsp        BEGSR
      *
     C                   IF        Not IntFlg
      * Write constant.
     C                   CALLP     WrtDta( 'AMEND'
     C                                  : 26 : 0 : 3 : 74 : QSN_SA_HI :
     C                                  QSN_SA_HI : QSN_SA_WHT : QSN_SA_WHT :
     C                                  CmdBuf : 0 : 0 )
      *
      * Write constant.
     C                   CALLP     WrtDta( IDTxTmp
     C                                  : 30 : 0 : 6 : 3 : QSN_SA_NORM :
     C                                  QSN_SA_NORM: QSN_SA_GRN : QSN_SA_GRN :
     C                                  CmdBuf : 0 : 0 )
      *
     C                   CALLP     WrtDta( ID
     C                                  : IDLen : 0 : 6 : 34 : QSN_SA_HI :
     C                                  QSN_SA_HI : QSN_SA_WHT : QSN_SA_WHT :
     C                                  CmdBuf : 0 : 0 )
      *
      * Write constant.
     C                   CALLP     WrtDta( 'Current Password. . . . . . .:'
     C                                  : 30 : 0 : 09 : 3 : QSN_SA_NORM :
     C                                  QSN_SA_NORM: QSN_SA_GRN : QSN_SA_GRN :
     C                                  CmdBuf : 0 : 0 )
      *
      * Write "Current Password" input field.
     C                   CALLP     SetFld( Var_Id( 1 ) :
     C                                     VarLen( 1 ) :
     C                                     VarRow( 1 ) :
     C                                     VarCol( 1 ) : QSN_FFW_ALPHA_SHIFT :
     C                                     ' ' : 0 : QSN_SA_ND : QSN_SA_ND_37 :
     C                                     CmdBuf : 0 : 0 )
      *
      * Write constant.
     C                   CALLP     WrtDta( 'New Password. . . . . . . . .:'
     C                                  : 30 : 0 : 13 : 3 : QSN_SA_NORM :
     C                                  QSN_SA_NORM: QSN_SA_GRN : QSN_SA_GRN :
     C                                  CmdBuf : 0 : 0 )
      *
      * Write "New Password" input field.
     C                   CALLP     SetFld( Var_Id( 2 ) :
     C                                     VarLen( 2 ) :
     C                                     VarRow( 2 ) :
     C                                     VarCol( 2 ) : QSN_FFW_ALPHA_SHIFT :
     C                                     ' ' : 0 : QSN_SA_ND : QSN_SA_ND_37 :
     C                                     CmdBuf : 0 : 0 )
      *
      * Write constant.
     C                   CALLP     WrtDta( 'Confirm New Password. . . . .:'
     C                                  : 30 : 0 : 17 : 3 : QSN_SA_NORM :
     C                                  QSN_SA_NORM: QSN_SA_GRN : QSN_SA_GRN :
     C                                  CmdBuf : 0 : 0 )

      * Write "Confirm New Password" input field.
     C                   CALLP     SetFld( Var_Id( 3 ) :
     C                                     VarLen( 3 ) :
     C                                     VarRow( 3 ) :
     C                                     VarCol( 3 ) :  QSN_FFW_ALPHA_SHIFT :
     C                                     ' ' : 0 : QSN_SA_ND : QSN_SA_ND_37 :
     C                                     CmdBuf : 0 : 0 )
      *
      * Write constant.
     C                   CALLP     WrtDta( 'Description . . . . . . . . .:'
     C                                  : 30 : 0 : 21 : 3 : QSN_SA_NORM :
     C                                  QSN_SA_NORM: QSN_SA_GRN : QSN_SA_GRN :
     C                                  CmdBuf : 0 : 0 )
      *
      * Write "Description' input field.
     C                   CALLP     SetFld( Var_Id( 4 ) :
     C                                     VarLen( 4 ) :
     C                                     VarRow( 4 ) :
     C                                     VarCol( 4 ) : QSN_FFW_ALPHA_SHIFT :
     C                                     ' ' : 0 : QSN_SA_UL : QSN_SA_GRN_UL :
     C                                     CmdBuf : 0 : 0 )
      *
     C                   If        DscLen <> *Zero
     C                   CALLP     WrtDta( Desc :
     C                                     VarLen( 4 ) :
     C                                     Var_Id( 4 ) : 0 : 0 : QSN_SA_UL :
     C                                     QSN_SA_NORM : QSN_SA_GRN_UL :
     C                                     QSN_SA_GRN : CmdBuf : 0 : 0 )
     C                   EndIf
      *
      * Write constant.
     C                   CALLP     WrtDta( 'F12=Previous'
     C                                  : 12 : 0 : 23 : 2 : QSN_SA_NORM :
     C                                  QSN_SA_NORM : QSN_SA_BLU : QSN_SA_GRN :
     C                                  CmdBuf : 0 : 0 )
      *
      * Save old password.
     C                   EVAL      Pwd4 = Pwd1
     C                   EVAL      Pwd1 = *Blanks
      *
      * Put / get the screen.
     C                   EXSR      PutGet
      *
     C                   EVAL      IntFlg = *On
     C                   ENDIF
      *
     C                   EXSR      ValInp
      *
      * Put / get the screen.
     C                   IF        ErrFlg
     C                   EXSR      PutGet
     C                   ELSE
     C                   EVAL      ProcFlg = *On
     C                   EVAL      ExtFlg = *On
     C                   EVAL      Pwd1 = Pwd2
     C                   ENDIF

     C     AmdDspE       ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  ExtPgm - Exit Program                                        *
      *                                                               *
      *  Called by: Main Processing                                   *
      *                                                               *
      *  Calls: DSM API                                               *
      *                                                               *
      *****************************************************************
     C     ExtPgm        BEGSR
      *
      * Delete command buffer.
     C                   CALLP     DltBuf( CmdBuf : 0 )
      *
      * Delete input buffer.
     C                   CALLP     DltBuf( InpBuf : 0 )
      *
      * Clean up.
     C     1             DO        Max           X
     C                   DEALLOC                 VarPtr( X )
     C                   ENDDO
     C                   MOVE      *on           *INLR
      *
     C     ExtPgmE       ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  ValInp - Validate inputs                                     *
      *                                                               *
      *  Called by: Main Processing                                   *
      *                                                               *
      *  Calls: DSM API                                               *
      *                                                               *
      *****************************************************************
     C     ValInp        BEGSR
      *
     C                   EVAL      ErrFlg = *Off
      *
     C                   IF        Action = 'I'
      *
      * Check if ID exists.
     C                   CALL      'UT000033'
     C                   PARM      '*BLANKS'     PReturnCode
     C                   PARM      'F'           PAction
     C                   PARM      ValidList     PValidList
     C                   PARM      Library       PLibrary
     C                   PARM      ID            PIDName
     C                   PARM      *Blanks       PPass1
     C                   PARM      *Blanks       PPass2
     C                   PARM      *Blanks       PDescr
      *
     C                   IF        PReturnCode = *Blanks
     C                   EVAL      ErrFlg = *On
     C                   CALLP     WrtDta( %Trimr(IDTx) +  ' already exist.'
     C                                  : 70 : 0 : 24 : 02 : QSN_SA_HI :
     C                                  QSN_SA_NORM : QSN_SA_WHT : QSN_SA_GRN :
     C                                  CmdBuf : 0 : 0 )
      *
      * Now show "ID" field as error; use field ID instead of row / column.
     C                   CALLP     WrtDta( ID :
     C                                     VarLen( 1 ) :
     C                                     Var_Id( 1 ) : 0 : 0 :
     C                                     QSN_SA_RI :
     C                                     QSN_SA_NORM :
     C                                     QSN_SA_GRN_UL_RI :
     C                                     QSN_SA_GRN :
     C                                     CmdBuf : 0 : 0 )
      *
      * Set cursor address at "ID" field; use field ID instead of row / column.
     C                   CALLP     SetCsrAdr( Var_Id( 1 ) :
     C                                  0 : 0 : CmdBuf : 0: 0 )
      *
      * Check if ID input is blank.
     C                   ELSEIF    ID = *Blanks

     C                   EVAL      ErrFlg = *On
     C                   CALLP     WrtDta( %Trim(IdTx) + ' must be entered.'
     C                                  : 70 : 0 : 24 : 02 : QSN_SA_HI :
     C                                  QSN_SA_NORM : QSN_SA_WHT : QSN_SA_GRN :
     C                                  CmdBuf : 0 : 0 )
      *
      * Now show "ID" field as error; use field ID instead of row / column.
     C                   CALLP     WrtDta( ID :
     C                                     VarLen( 1 ) :
     C                                     Var_Id( 1 ) : 0 : 0 :
     C                                     QSN_SA_UL :
     C                                     QSN_SA_NORM :
     C                                     QSN_SA_GRN_UL_RI :
     C                                     QSN_SA_GRN :
     C                                     CmdBuf : 0 : 0 )
      *
      * Set cursor address at "ID" field; use field ID instead of row / column.
     C                   CALLP     SetCsrAdr( Var_Id( 1 ) :
     C                                  0 : 0 : CmdBuf : 0: 0 )
      *
      * Check if password input is blank.
     C                   ELSEIF    Pwd1 = *Blanks and PwdLen <> *Zero
      *
     C                   EVAL      ErrFlg = *On
     C                   CALLP     WrtDta( 'Current password must be entered.'
     C                                  : 70 : 0 : 24 : 02 : QSN_SA_HI :
     C                                  QSN_SA_NORM : QSN_SA_WHT : QSN_SA_GRN :
     C                                  CmdBuf : 0 : 0 )
      *
      * Set cursor address at "Password" field; use field ID instead of row / column.
     C                   CALLP     SetCsrAdr( Var_Id( 2 ) :
     C                                  0 : 0 : CmdBuf : 0: 0 )
      *
      * Check if new password and confirm new password is a match.
     C                   ELSEIF    Pwd1 <> Pwd2 and PwdLen <> *Zero
      *
     C                   EVAL      ErrFlg = *On
     C                   CALLP     WrtDta( 'New password and confirm new passw+
     C                                     ord does not match'
     C                                  : 70 : 0 : 24 : 02 : QSN_SA_HI :
     C                                  QSN_SA_NORM : QSN_SA_WHT : QSN_SA_GRN :
     C                                  CmdBuf : 0 : 0 )
      *
      * Set cursor address at "Password" field; use field ID instead of row / column.
     C                   CALLP     SetCsrAdr( Var_Id( 2 ) :
     C                                  0 : 0 : CmdBuf : 0: 0 )
     C                   ENDIF
     C                   ENDIF
      *
     C                   IF        Action = 'A'
      *
      * Check if current password input is blank.
     C                   IF        Pwd1 = *Blanks and PwdLen <> *Zero
      *
     C                   EVAL      ErrFlg = *On
     C                   CALLP     WrtDta( 'Current password must be entered.'
     C                                  : 70 : 0 : 24 : 02 : QSN_SA_HI :
     C                                  QSN_SA_HI : QSN_SA_WHT : QSN_SA_WHT :
     C                                  CmdBuf : 0 : 0 )
      *
      * Set cursor address at "Current Password" field; use field ID instead of row / column.
     C                   CALLP     SetCsrAdr( Var_Id( 1 ) :
     C                                  0 : 0 : CmdBuf : 0: 0 )
      *
      * Check if current password is equal to saved password.
     C                   ELSEIF    Pwd1 <> Pwd4 and PwdLen <> *Zero
      *
     C                   EVAL      ErrFlg = *On
     C                   CALLP     WrtDta( 'Current password is not valid'
     C                                  : 70 : 0 : 24 : 02 : QSN_SA_HI :
     C                                  QSN_SA_HI : QSN_SA_WHT : QSN_SA_WHT :
     C                                  CmdBuf : 0 : 0 )
      *
      * Set cursor address at "Current Password" field; use field ID instead of row / column.
     C                   CALLP     SetCsrAdr( Var_Id( 1 ) :
     C                                  0 : 0 : CmdBuf : 0: 0 )
      *
      * Check if new password input is blank.
     C                   ELSEIF    Pwd2 = *Blanks and PwdLen <> *Zero
      *
     C                   EVAL      ErrFlg = *On
     C                   CALLP     WrtDta( 'New password must be entered.'
     C                                  : 70 : 0 : 24 : 02 : QSN_SA_HI :
     C                                  QSN_SA_HI : QSN_SA_WHT : QSN_SA_WHT :
     C                                  CmdBuf : 0 : 0 )
      *
      * Set cursor address at "New Password" field; use field ID instead of row / column.
     C                   CALLP     SetCsrAdr( Var_Id( 2 ) :
     C                                  0 : 0 : CmdBuf : 0: 0 )
      *
      * Check if new password is equal to confirm new password.
     C                   ELSEIF    Pwd2 <> Pwd3 and PwdLen <> *Zero
      *
     C                   EVAL      ErrFlg = *On
     C                   CALLP     WrtDta( 'New password and confirm new passwo+
     C                                  rd does not match'
     C                                  : 70 : 0 : 24 : 02 : QSN_SA_HI :
     C                                  QSN_SA_HI : QSN_SA_WHT : QSN_SA_WHT :
     C                                  CmdBuf : 0 : 0 )
      *
      * Set cursor address at "New Password" field; use field ID instead of row / column.
     C                   CALLP     SetCsrAdr( Var_Id( 2 ) :
     C                                  0 : 0 : CmdBuf : 0: 0 )
     C                   ENDIF

     C                   ENDIF

     C     ValInpE       ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  MovInp - Move input values                                   *
      *                                                               *
      *  Called by: Main Processing                                   *
      *                                                               *
      *  Calls: DSM API                                               *
      *                                                               *
      *****************************************************************
     C     MovInp        BEGSR
      *
     C                   IF        Action = 'I'
      *
      * "ID".
     C                   EVAL      ID = %subst( InpFlds : 1 : IDLen )
     C                   CALLP     WrtDta( ID :
     C                                     VarLen( 1 ) :
     C                                     Var_Id( 1 ) : 0 : 0 : QSN_SA_UL :
     C                                     QSN_SA_NORM : QSN_SA_GRN_UL :
     C                                     QSN_SA_GRN : CmdBuf : 0 : 0 )
      *
      * "Password".
     C                   EVAL      Pwd1 = %subst( InpFlds : IDLen + 1 : PwdLen)
     C                   If        PwdLen <> *Zero
     C                   CALLP     WrtDta( Pwd1 :
     C                                     VarLen( 2 ) :
     C                                     Var_Id( 2 ) : 0 : 0 : QSN_SA_ND :
     C                                     QSN_SA_NORM : QSN_SA_ND_37 :
     C                                     QSN_SA_GRN : CmdBuf : 0 : 0 )
     C                   EndIf
      *
      * "Confirm Password".
     C                   EVAL      Pwd2 = %subst( InpFlds : (IDLen + PwdLen) +
     C                                    1 : PwdLen )
     C                   If        PwdLen <> *Zero
     C                   CALLP     WrtDta( Pwd2 :
     C                                     VarLen( 3 ) :
     C                                     Var_Id( 3 ) : 0 : 0 : QSN_SA_ND :
     C                                     QSN_SA_NORM : QSN_SA_ND_37 :
     C                                     QSN_SA_GRN : CmdBuf : 0 : 0 )
     C                   EndIf
      *
      * "Description".
     C                   EVAL      Desc = %subst( InpFlds : (IDLen + PwdLen
     C                                    + PwdLen) + 1 : DscLen )
     C                   If        DscLen <> *Zero
     C                   CALLP     WrtDta( Desc :
     C                                     VarLen( 4 ) :
     C                                     Var_Id( 4 ) : 0 : 0 : QSN_SA_UL :
     C                                     QSN_SA_NORM : QSN_SA_GRN_UL :
     C                                     QSN_SA_GRN : CmdBuf : 0 : 0 )
     C                   EndIf
      *
     C                   ENDIF
      *
     C                   IF        Action = 'A'
      *
      * "Current Password".
     C                   EVAL      Pwd1 = %subst( InpFlds : 1 : PwdLen)
     C                   If        PwdLen <> *Zero
     C                   CALLP     WrtDta( Pwd1 :
     C                                     VarLen( 1 ) :
     C                                     Var_Id( 1 ) : 0 : 0 : QSN_SA_ND :
     C                                     QSN_SA_NORM : QSN_SA_ND_37 :
     C                                     QSN_SA_GRN : CmdBuf : 0 : 0 )
     C                   EndIf
      *
      * "New Password".
     C                   EVAL      Pwd2 = %subst( InpFlds : PwdLen
     C                                     + 1 : PwdLen )
     C                   If        PwdLen <> *Zero
     C                   CALLP     WrtDta( Pwd2 :
     C                                     VarLen( 2 ) :
     C                                     Var_Id( 2 ) : 0 : 0 : QSN_SA_ND :
     C                                     QSN_SA_NORM : QSN_SA_ND_37 :
     C                                     QSN_SA_GRN : CmdBuf : 0 : 0 )
     C                   EndIf
      *
      * "Confirm New Password".
     C                   EVAL      Pwd3 = %subst( InpFlds : (PwdLen + PwdLen)
     C                                     + 1 : PwdLen )
     C                   If        PwdLen <> *Zero
     C                   CALLP     WrtDta( Pwd3 :
     C                                     VarLen( 3 ) :
     C                                     Var_Id( 3 ) : 0 : 0 : QSN_SA_ND :
     C                                     QSN_SA_NORM : QSN_SA_ND_37 :
     C                                     QSN_SA_GRN : CmdBuf : 0 : 0 )
     C                   EndIf
      *
      * "Description".
     C                   EVAL      Desc = %subst( InpFlds : (PwdLen + PwdLen
     C                                    + PwdLen) + 1 : DscLen )
     C                   If        DscLen <> *Zero
     C                   CALLP     WrtDta( Desc :
     C                                     VarLen( 4 ) :
     C                                     Var_Id( 4 ) : 0 : 0 : QSN_SA_UL :
     C                                     QSN_SA_NORM : QSN_SA_GRN_UL :
     C                                     QSN_SA_GRN : CmdBuf : 0 : 0 )
     C                   EndIf
      *
     C                   ENDIF
      *
     C     MovInpE       ENDSR
