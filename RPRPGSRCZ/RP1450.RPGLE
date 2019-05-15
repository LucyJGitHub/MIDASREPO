     H DEBUG
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas RP PB Transactions/Positions       - take on')
      *****************************************************************
      *                                                               *
      *  Midas - Private Banking Module.                              *
      *                                                               *
      *  RP1450 - Transactions/Positions take on.                     *
      *                                                               *
      *  Function:    This module allows to download Transactions     *
      *            and Positions from Midas to PC site by using       *
      *            Meridian Replication functions.                    *
      *                                                               *
      *  Component of: RP1450 - Transactions/Positions take on.       *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *  Prev Amend No. CPB002  *CREATE    Date 01Jun99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CPB002 - Meridian DBA Middleware Replication Customization.  *
      *                                                               *
      *****************************************************************
 
      **  TransactionS/Positions Take-on display File.
     FRP1450DF  CF   E             WORKSTN INFDS(Dspfds)
     F                                     SFILE(RP1450S1:Rrn1)
     F                                     INFSR(*Pssr)
 
      **  Transactions/Positions Take-on control file, sorted by Group Code
      **  and Short Code.
     FRPTPTOL1  IF   E           K DISK
     F                                     INFSR(*Pssr)
 
      /Eject
      *****************************************************************
      *                                                               *
      *          F U N C T I O N   O F   I N D I C A T O R S          *
      *          -------------------------------------------          *
      *                                                               *
      *  35  -  SFLEND (Message subfile window)                       *
      *                                                               *
      *  41  -  SFLDSPCTL/SFLCLR.                                     *
      *  42  -  SFLDSP.                                               *
      *  43  -  SFLEND(*MORE).                                        *
      *                                                               *
      *  50  -  SFLNXTCHG.                                            *
      *  51  -  Error on subfile selection field.                     *
      *  52  -  Narrative is highlighted for sub titles.              *
      *                                                               *
      *  61  -  Selection field non-displayed and in protect mode.    *
      *                                                               *
      *  77  -  Resulting indicator on CHECKR operation.              *
      *                                                               *
      *  81  -  End of file RPTPTOL1.                                 *
      *  82  -  Resulting indicator on READC operation.               *
      *                                                               *
      *  98  -  Date Format indicator (*OFF = DDMMYY).                *
      *  99  -  General Error Indicator.                              *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *                  *************************                    *
      *                  ** INDICATORS NOT USED **                    *
      *                  *************************                    *
      *                                                               *
      *       ***************************************************     *
      *       * 01   02   03   04   05   06   07   08   09   10 *     *
      *       * 11   12   13   14   15   16   17   18   19   20 *     *
      *       * 21   22   23   24   25   26   27   28   29   30 *     *
      *       * 31   32   33   34   xx   36   37   38   39   40 *     *
      *       * xx   xx   xx   44   45   46   47   48   49   xx *     *
      *       * xx   xx   53   54   55   56   57   58   59   60 *     *
      *       * xx   62   63   64   65   66   67   68   69   70 *     *
      *       * 71   72   73   74   75   76   xx   78   79   80 *     *
      *       * xx   xx   83   84   85   86   87   88   89   90 *     *
      *       * 91   92   93   94   95   96   97   xx   xx      *     *
      *       ***************************************************     *
      *                                                               *
      *****************************************************************
      /SPACE 3
      *****************************************************************
      *                                                               *
      *                S U B R O U T I N E   I N D E X                *
      *                -------------------------------                *
      *                                                               *
      *  #Insfl - Subroutine to initialise Subfile.                   *
      *  #Infld - Subroutine to initialise Subfile Record Fields.     *
      *  #Vlsfl - Subroutine to validate Subfile selection.           *
      *  #Takon - Subroutine to process Take-on.                      *
      *  #Sndms - Subroutine to send message to Program Message Queue.*
      *  #Clear - Subroutine to clear Program Message Queue.          *
      *  *Pssr  - Program exception error routine.                    *
      *  *Inzsr - Program Initialization routine.                     *
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
 
      **  Array containing Copyright statement
     D Cpy@            S             80    Dim(1) Ctdata Perrcd(1)
 
      **  Alternate tables containing messages Id. and data to be passed.
     D TabMsgId        S              7    Dim(2) Ctdata Perrcd(1)
     D TabMsgData      S             80    Dim(2) Alt(TabMsgId)
 
      ** Midas Local Data Area for database error reporting; based on
      ** external file
     D Lda           E DS           256    Extname(LDA) DTAARA(LDA)
      ** The following fields are defined in the external file:
      **                                    134 141 DBFile
      **                                    142 170 DBKey
      **                                    171 180 DBPgm
      **                                    181 1830DBase
      **                                    184 193 DBMod
      **                                    194 203 DBProc
 
      **  Display File Information Data Stucture.
     D DSPFDS          DS
     D  RWCL                 370    371B 0
     D  CURS                 378    379B 0
 
      **  External Data structure for Run Date Informations.
     D RUNDAT        E DS
 
      **  External Data structure for System Informations.
     D SDSTAT        E DS
 
      **  Customer Selection Data Area.
     D RPCust        E DS                  Extname(RPCUST) DTAARA(RPCUST)
 
      ** +--- Named indicators -------------------------------------------+
      ** ¦                                                                ¦
      ** ¦ NOTE: this whole section can be deleted if no named indicators ¦
      ** ¦       are being used.  The names given are examples.           ¦
      ** ¦                                                                ¦
      ** ¦ Map variable names to indicators to allow use of names instead ¦
      ** ¦ of numbers; base the following data structure on a pointer to  ¦
      ** ¦ the indicator array.                                           ¦
     D Indicators      DS                  BASED(pIndicator)
      ** ¦                                                                ¦
     D  Exit                   3      3
      ** ¦                                                                ¦
     D  Refresh                5      5
      ** ¦                                                                ¦
      ** ¦                                                                ¦
      ** ¦ Set the indicator array pointer                                ¦
     D pIndicator      S               *   INZ(%Addr(*In))
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** ------------- Start of parameters for QCMDEXC --------------**
      **  Command string.
     D P_Command       S            128A
      **  Length of command string.
     D P_Length        S             15  5
      ** -------------- End of parameters for QCMDEXC ---------------**
 
      **  Length of command string.
     D W_Length        S             15  0
 
      **  Work field used to calculate relative record number.
     D W_Rrn1          S              4  0
 
      **  Work field used to indicate there is already an error
      **  relating to subfile selection field.
     D W_Error         S              1
 
      **  Work field used to indicate there is already an error
      **  relating to selection of exclusive option.
     D W_ExclError     S              1
 
      **  Work field used to check exclusive condition.
     D W_Exclus        S              1
 
      **  Work field used to condition execution of take on.
     D W_TakeOn        S              1
 
      **  Work field used to condition display of Private Banking
      **  selection window.
     D W_Select        S              1
 
      **  Number of blanks lines that have to be inserted in subfile.
     D W_NbrBlkLines   S              1  0
 
      **  Work field used to know whether take on has completed
      **  abnormally.
     D W_TakonError    S              1
 
      **  Work fields used to determine what key was pressed on Private
      **  Banking Customers selection window.
     D W_Exit          S             10A   INZ('Exit')
     D W_Cancel        S             10A   INZ('Cancel')
 
      **  Work field used to avoid dump to be done more than once.
     D W_RunBefore     S              1A
 
      ** True and False can be used for indicators being on or off.
     D True            C                   *On
     D False           C                   *Off
 
      **  Work field used to set up RP00004 message data.
     D W_EndRP00004    S              8A   INZ(' take on')
 
      ** +--------------------------------------+
      ** ¦ Declared procedures                  ¦
      ** ¦ ===================                  ¦
      ** +--------------------------------------+
 
     D RCLRSC          PR                  EXTPROC('CEETREC')
     D   Cel_rc_mod    S             10A   INZ('Cancel')
     D   User_rc       S             10A   INZ('Cancel')
 
      /Eject
      *****************************************************************
      *                                                               *
      *                 M A I N  P R O C E S S I N G                  *
      *                                                               *
      *****************************************************************
 
      **  Initialize subfile.
     C                   Exsr      #Insfl
 
     C     *Inkc         Doweq     False                                        Begin DO_W_KC
 
      **  Set up current time.
     C                   Time                    W_Time            6 0
     C                   Move      W_Time        STIME
 
      **  If no Transactions/Positions to download, send information message.
     C                   Eval      *in42 = True
     C     Rrn1          Ifeq      0                                            Begin Rrn1
     C                   Eval      *in42 = False
     C                   Eval      P@MsgId  = 'RP00001'
     C                   Eval      P@MsgDta = *blanks
     C     P@MsgId       Lookup    TabMsgId      TabMsgData               77
 
      **  If message data was found in table.
     C     *in77         Ifeq      True                                         Begin *in77
     C                   Eval      P@MsgDta = TabMsgData
 
     C                   Endif                                                  End *in77
     C                   Exsr      #Sndms
 
     C                   Endif                                                  End Rrn1
 
     C                   Write     #MSGCTL                                      Error Message
     C                   Write     RP1450F0                                     Command Key
 
     C                   Exfmt     RP1450C1                                     Subfile
 
      **  Save subfile relative record number of page to be displayed.
     C                   Eval      SPRN1 = CURS
 
      **  Clear Program Message Queue.
     C                   Exsr      #Clear
 
     C                   Select                                                 Begin Select
 
      **  F3 pressed, exit program.
     C     Exit          Wheneq    True                                         <CA03>
     C                   Leave
 
      **  F5 pressed, refresh screen, by remaining on last page displayed.
     C     Refresh       Wheneq    True                                         <CA05>
 
      **  Initialize subfile.
     C                   Exsr      #Insfl
 
      **  Validate subfile selection.
     C                   Other                                                  <ENTER>
 
      **  If no Transactions/Positions to download, skip processing.
     C     Rrn1          Ifeq      0                                            Begin Rrn1
     C                   Iter
 
     C                   Endif                                                  End Rrn1
 
      **  Validate Subfile selection.
     C                   Exsr      #Vlsfl
 
      **  If no subfile selection error, process Take-on.
     C     W_TakeOn      Ifeq      'Y'                                          Begin W_TakeOn
     C     W_Error       Andeq     *blank
 
      **  Clear Program Message Queue.
     C                   Exsr      #Clear
     C                   Write     #Msgctl
 
      **  Update Customer Selection Data Area with default values.
     C     *lock         In        RPCust
     C                   Eval      CSRetnCode = *blanks
     C                   Eval      CSFromCust = 'ALL'
     C                   Eval      CSMainBrch = 'ALL'
     C                   Out       RPCust
 
      **  Do while return code remains blank.
     C     CSRetnCode    Doweq     *Blanks                                      Begin Do_W_RPC1430
 
      **  If Private Banking Customers selection screen is required.
     C     W_Select      Ifeq      'Y'                                          Begin W_Select
 
      **  Update Customer Selection Data Area with default values.
     C     *lock         In        RPCust
     C                   Eval      CSToCust   = *blanks
     C                   Eval      CSAcofCode = *blanks
     C                   Out       RPCust
 
      **  Call Customer Selection Input program.
     C                   Callb     'RPC1430'                            99
 
      **  Get Customer Selection Data Area return values.
     C                   In        RPCust
 
     C                   Endif                                                  End W_Select
 
      **  If Return Code is blank, process Take-on.
     C     *in99         Ifeq      True                                         Begin CSRetnCode
     C                   Eval      CSRetnCode = 'ErrRPC1430'
 
     C                   Endif
 
      **  If Return Code is blank, process Take-on.
     C     CSRetnCode    Ifeq      *Blanks                                      Begin CSRetnCode
     C                   Exsr      #Takon
     C     CSRetnCode    Ifne      *blanks
     C                   Iter
     C                   Endif
     C     *lock         In        RPCust
     C                   Eval      CSFromCust  = *blanks
     C                   Out       RPCust
 
      **  If Take on was processed without any selection required, set up
      **  Return code so that to leave Do Group.
     C     W_Select      Ifne      'Y'                                          Begin W_Select
     C     *inu7         Andeq     False
     C                   Eval      CSRetnCode = 'Noselect  '
 
     C                   Endif                                                  End W_Select
 
     C                   Endif                                                  End CSRetnCode
 
     C                   Enddo                                                  End Do_W_RPC1430
 
     C                   Select                                                 Begin Select
 
      **  If <F3> pressed on window, exit from program.
     C     CSRetnCode    Wheneq    W_Exit                                       Exit
     C                   Eval      Exit = True
     C                   Leave
 
      **  If <F12> pressed on window, just return to selection
      **  screen after clearing program message queue.
     C     CSRetnCode    Wheneq    W_Cancel                                    Cancel
     C                   Exsr      #Clear
 
      **  Initialize subfile.
     C                   Exsr      #Insfl
 
     C                   Iter
 
      **  If no selection was required.
     C     CSRetnCode    Wheneq    'NoSelect  '                                 No selection
     C                   Exsr      #Insfl
 
     C                   Other                                                  Error
 
     C                   Endsl                                                  End Select
 
     C                   Endif                                                  End W_TakeOn
 
     C                   Endsl                                                  End Select
 
     C                   Enddo                                                  End DO_W_KC
 
      **  Program end.
     C                   Eval      *Inlr = True
 
      /Eject
      *****************************************************************
      /Title SR/#Insfl
      *****************************************************************
      *                                                               *
      *  #Insfl  - Subroutine to initialise subfile.                  *
      *                                                               *
      *  Called By: Main Processing                                   *
      *                                                               *
      *  Calls:     #Infld                                            *
      *                                                               *
      *****************************************************************
     C     #Insfl        Begsr                                                  **#Insfl SR **
 
      **  Clear subfiles.
     C                   Eval      *in41 = False
     C                   Write     RP1450C1
     C                   Eval      *in41 = True
 
      **  Initialize Subfile Relative Record Number.
     C                   Eval      W_Rrn1 = 0
 
      **  Read all Transactions/Positions to be processed by take-on.
     C     *Loval        Setll     RPTPTOL1
     C                   Read      RPTPTOL1                               81
 
      **  Do while Transactions/Positions to be processed.
     C     *In81         Doweq     False                                        Begin DO_W_81
 
      **  If no program exists for the item, do not display it.
     C     TPPCMD        Ifne      *blanks                                      Begin TPPCMD
     C     TPACTI        Oreq      *blanks
 
     C                   Clear     *All          RP1450S1
     C                   Movea     '000'         *In(50)
     C                   Movea     '0'           *In(42)
     C                   Movea     '0'           *In(61)
 
     C                   Move      TPICDE        W_NbrBlkLines
 
      **  If blank lines have to be inserted in subfile.
     C                   If        W_NbrBlkLines <> 0                           Begin W_NbrBlkLines
 
     C                   Do        W_NbrBlkLines                                Begin Do
     C                   Eval      W_Rrn1 = W_Rrn1 + 1
     C                   Eval      Rrn1 = W_Rrn1
     C                   Eval      *in61 = True
     C                   Write     RP1450S1
 
     C                   Enddo                                                  End Do
 
     C                   Endif                                                  End W_NbrBlkLines
 
      **  Initialize Subfile Record Fields from Transactions/Positions
      **  take on file fields.
     C                   Exsr      #Infld
 
      **  Write a record in subfile.
     C                   Eval      W_Rrn1 = W_Rrn1 + 1
     C                   Eval      Rrn1 = W_Rrn1
     C                   Write     RP1450S1
 
     C                   Endif                                                  Endif TPPCMD
 
      **  Read next Transactions/Positions record to be processed.
     C                   Read      RPTPTOL1                               81
 
     C                   Enddo                                                  End DO_W_81
 
      **  Store Last Subfile Relative Record Number.
     C     *Like         Define    Rrn1          W_LastRrn1
     C                   Eval      W_LastRrn1 = Rrn1
 
      **  Set up Relative Record Number for Page to be displayed.
     C                   Select                                                 Begin Select
 
     C     SPRN1         Wheneq    0                                            First page
     C                   Eval      SPRN1 = 1
 
     C     SPRN1         Whengt    W_LastRrn1                                   Last page
     C                   Eval      SPRN1 = W_LastRrn1
 
     C                   Endsl                                                  End Select
 
      **  Set off exclusive item indicator.
     C                   Movea     '0'           *In(42)
 
      **  Clear Program Message Queue.
     C                   Exsr      #Clear
 
     C                   Endsr
      /Eject
      *****************************************************************
      /Title SR/#Infld
      *****************************************************************
      *                                                               *
      *  #Infld  - Subroutine to initialise Subfile record Fields.    *
      *                                                               *
      *  Called By: #Insfl                                            *
      *                                                               *
      *  Calls:     None                                              *
      *                                                               *
      *****************************************************************
     C     #Infld        Begsr                                                  ** #Infld SR **
 
     C                   Eval      *In61 = False
 
      **  Set up Item Narrative.
     C                   Movel     TPINAR        SINAR
 
     C                   Select                                                 Begin Select
 
      **  If Menu Group Code, seton indicators so that Group Title
      **  would be underlined and highlighted.
     C                   When      %subst(SINAR:1:1) <> *blank                  Group line
     C                   Eval      *in52 = True
     C                   Eval      *in61 = True
 
      **  If take on item not allowed, set on indicator so that item
      **  could not be selected.
     C                   When      TPACTI = 'N'                                 Not allowed
     C                   Eval      *in61 = True
 
      **  If selection line, set up hidden fields.
     C                   Other                                                  Selection line
     C                   Movel     TPPCMD        SPCMD                          Program name
     C                   Movel     TPPBCS        SPBCS                          PB cust sel required
     C                   Movel     TPEXCI        SEXCI                          Exclusive item
     C                   Eval      SPARA = TPPARA                               Program parameters
     C                   Eval      P_Scan = TPPARA
      *
      ** Scan Parameter to replace Midas system prefix
      *
     C                   Call      'QCLSCAN'
     C                   Parm                    P_Scan           70
     C                   Parm      70            P_ScanL           3 0          Length
     C                   Parm      1             P_Start           3 0          Start
     C                   Parm      'XX'          P_Mask           30            Mask
     C                   Parm      2             P_MaskL           3 0          Length
     C                   Parm      '1'           P_Translate       1            Translate
     C                   Parm      '1'           P_Trim            1            Trim
     C                   Parm      '?'           P_Wild            1            Wild
     C                   Parm                    P_Result          3 0          Result
      *
      ** Replace "XX" by Midas system Prefix
      *
     C                   If        P_Result > 1
     C                   Z-add     P_Result      P_Begin           3 0
     C                   Z-add     P_Result      P_End             3 0
     C                   Add       2             P_End
     C                   Z-add     70            P_Total           3 0
     C                   Sub       P_end         P_Total
 
     C                   Eval      SPARA = %Subst(TPPARA:1:P_Begin-1)
     C                                     + Libr
     C                                     + %Subst(TPPARA:P_End:P_Total)
     C                   Endif
 
      **  If exclusive item, display in red colour.
     C     SEXCI         Ifeq      'Y'                                          Begin SEXCI
     C                   Eval      *in42 = True
 
     C                   Endif                                                  End SEXCI
 
     C                   Endsl                                                  End Select
 
     C                   Eval      SSEL = *blank
 
     C                   Endsr
      /Eject
      *****************************************************************
      /Title SR/#Vlsfl
      *****************************************************************
      *                                                               *
      *  #Vlsfl - Subroutine to validate subfile selection.           *
      *                                                               *
      *  Called By: Main Processing                                   *
      *                                                               *
      *  Calls:     #Sndms                                            *
      *                                                               *
      ********************************************************************
     C     #Vlsfl        Begsr                                                  ** #Vlsfl SR **
 
      **  Initialize error, selection screen display and take-on process flags.
     C                   Eval      W_Error     = *blank
     C                   Eval      W_ExclError = *blank
     C                   Eval      W_TakeOn    = *blank
     C                   Eval      W_Exclus    = *blank
     C                   Eval      W_Select    = *blank
 
     C                   Eval      *in61 = False
 
      **  Read changed records.
     C                   Readc     RP1450S1                               82
 
      **  Do while changed records to be processed.
     C     *in82         Doweq     False                                        Begin Do_w_82
     C                   Movea     '000'         *in(50)
 
      **  If selection field does not contain "X", send an error message,
      **  but only on.
     C     SSEL          Ifne      *blank                                       Begin SSEL_1
 
      **  If correct value.
     C     SSEL          Ifeq      'X'                                          Begin SSEL_2
 
     C                   Select                                                 Begin Select
 
      **  If exclusive item was selected when exclusive or
      **  non-exclusive item was already selected.
     C     SEXCI         Wheneq    'Y'
     C     W_Takeon      Andeq     'Y'
     C                   Eval      *in51 = True
 
     C     W_Error       Ifeq      *blank                                       Begin W_Error
     C                   Eval      W_Error = 'Y'
     C                   Eval      SPRN1 = RRN1
 
     C                   Endif                                                  End W_Error
 
     C                   Eval      W_ExclError = 'Y'
     C                   Eval      P@MsgId = 'RP00003'
     C     '. '          Checkr    SINAR         P                 2 0    77
     C                   Eval      P@MsgDta = %Triml(%Subst(SINAR:1:P))
     C                   Exsr      #SNDMS
 
      **  If non-exclusive Item was selected when an
      **  exclusive item was already selected.
     C     SEXCI         Wheneq    ' '
     C     W_Exclus      Andeq     'Y'
     C                   Eval      *in51 = True
 
     C     W_Error       Ifeq      *blank                                       Begin W_Error
     C                   Eval      W_Error = 'Y'
     C                   Eval      SPRN1 = RRN1
 
     C                   Endif                                                  End W_Error
 
     C     W_ExclError   Ifne      'Y'                                          Begin W_ExclError
     C                   Eval      W_ExclError = 'Y'
     C                   Eval      P@MsgId = 'RP00003'
     C                   Exsr      #SNDMS
 
     C                   Endif                                                  End W_ExclError
     C
     C     SEXCI         Wheneq    'Y'
     C                   Eval      W_Exclus   = 'Y'
     C     '. '          Checkr    SINAR         P                 2 0    77
     C                   Eval      P@MsgDta = %Triml(%Subst(SINAR:1:P))
     C
     C                   Endsl                                                  End Select
 
     C                   Eval      *in50 = True
     C                   Eval      W_TakeOn = 'Y'
 
      **  If at least one option that requires Private Banking Customers
      **  selection screen to be displayed.
     C     SPBCS         Ifeq      'Y'                                          Begin TPPBCS
     C                   Eval      W_Select = 'Y'
 
     C                   Endif                                                  End TPPBCS
 
      **  If wrong value.
     C                   Else                                                   Else SSEL
     C                   Eval      *in51 = True
     C                   Eval      *in50 = True
 
     C     W_Error       Ifeq      *blank                                       Begin W_Error
     C                   Eval      W_Error = 'Y'
     C                   Eval      SPRN1 = RRN1
     C                   Eval      P@MsgId = 'RP00002'
     C                   Exsr      #SNDMS
 
     C                   Endif                                                  End W_Error
 
     C                   Endif                                                  End SSEL_2
 
     C                   Endif                                                  End SSEL_1
 
      **  If exclusive item, display in red colour.
     C                   Eval      *in42 = False
     C     SEXCI         Ifeq      'Y'                                          Begin SEXCI
     C                   Eval      *in42 = True
 
     C                   Endif                                                  End SEXCI
 
      **  Update Subfile record.
     C                   Update    RP1450S1
 
      **  Read next changed record.
     C                   Readc     RP1450S1                               82
 
     C                   Enddo                                                  End Do_w_82
 
     C                   Endsr
      /Eject
      *****************************************************************
      /Title SR/#Takon
      *****************************************************************
      *                                                               *
      *  #Takon - Subroutine to process take on.                      *
      *                                                               *
      *  Called By: Main Processing                                   *
      *                                                               *
      *  Calls:     Program RPC1435 (OPNQRYF)                         *
      *             Transactions/positions take on programs           *
      *             #Clear                                            *
      *             #SndMs                                            *
      *                                                               *
      *****************************************************************
     C     #Takon        Begsr                                                  ** #Takon SR **
 
      **  Display "Take on in progress..." information message.
     C                   Write     RP1450W1
 
      **  Clear Program Message Queue.
     C                   Exsr      #Clear
 
      **  Initialize work field used to know whether take on
      **  has completed successfully or not.
     C                   Eval      W_TakonError = 'N'
 
      **  Call Private Banking Customers selection program (OPNQRYF)
      **  for take on if required.
     C     W_Select      Ifeq      'Y'                                          Begin W_Select
     C                   Callb     'RPC1435'
 
      **  Get ReturnCode from Customer Selection Data Area.
     C                   In        RPCust
 
      **  If Private Banking Customers selection for take on program
      **  ended abnormally.
     C     CSRetnCode    Ifne      *blanks                                      Begin CSRetnCode
     C                   Eval      CSRetnCode   = *blanks
     C                   Eval      W_TakonError = 'Y'
     C                   Eval      P@MsgId      = 'RP00004'
     C                   Eval      P@MsgDta = *blanks
     C     P@MsgId       Lookup    TabMsgId      TabMsgData               77
 
      **  If message data was found in table.
     C     *in77         Ifeq      True                                         Begin *in77
     C                   Eval      P@MsgDta = TabMsgData + W_EndRP00004
 
     C                   Endif                                                  End *in77
     C                   Exsr      #Sndms
     C                   Goto      @Error
      *
     C                   End                                                    End CSRetnCode
 
     C                   Endif                                                  End W_Select
 
      **  Read changed records.
     C                   Readc     RP1450S1                               82
 
      **  Do while changed records to be processed.
     C     *in82         Doweq     False                                        Begin Do_w_82
 
      **  Concatenate command and parameters.
     C                   Eval      P_Command = *blanks
     C     SPCMD         Cat       SPARA         P_Command
     C     ' '           Checkr    P_Command     W_Length                 77
 
      **  Call take on program by using QCMDEXC.
     C                   Call      'QCMDEXC'                            99
     C                   Parm                    P_Command
     C                   Parm      W_Length      P_Length
 
      **  Get Return Code from Customer Selection Data Area.
     C     *lock         In        RPCust
 
      **  If take on program ended abnormally.
     C     *in99         Ifeq      True
     C     CSRetnCode    Orne      *blanks
     C                   Eval      CSRetnCode   = *Blanks
     C                   Eval      *in99        = False
     C                   Eval      W_TakonError = 'Y'
     C                   Eval      P@MsgId      = 'RP00004'
     C     '. '          Checkr    SINAR         P                 2 0    77
     C                   Eval      P@MsgDta = %Triml(%Subst(SINAR:1:P)) +
     C                                        W_EndRP00004
     C                   Exsr      #Sndms
      *
     C                   Endif                                                  End *in99
 
      **  Update Customer Selection Data Area.
     C                   Out       RPCust
 
      **  If exclusive item, display in red colour.
     C                   Eval      *in42 = False
     C     SEXCI         Ifeq      'Y'                                          Begin SEXCI
     C                   Eval      *in42 = True
 
     C                   Endif                                                  End SEXCI
 
      **  Update Subfile record.
     C                   Eval      *in50 = True
     C                   Update    RP1450S1
 
      **  Read next changed record.
     C                   Readc     RP1450S1                               82
 
     C                   Enddo                                                  End Do_w_82
 
      **  Send completion message.
     C                   Select                                                 Begin Select
 
     C     W_Select      Whenne    'Y'                                          No customer select.
     C                   Eval      P@MsgId  = 'RP00005'
 
     C     CSAcofCode    Whenne    *blanks                                      Account Officer
     C                   Eval      P@MsgDta = CSAcofCode
     C                   Eval      P@MsgId  = 'RP00012'
 
     C     CSFromCust    Wheneq    'ALL'                                        All customers
     C                   Eval      P@MsgId  = 'RP00007'
 
     C                   Other                                                  Customers range
     C                   Eval      P@MsgDta = CSFromCust + CSToCust
     C                   Eval      P@MsgId  = 'RP00006'
 
     C                   Endsl                                                  End Select
     C                   Exsr      #Sndms
     C                   Write     #MSGCTL                                      Error Message
 
     C     @Error        Tag
 
      **  If take on did not complete successfully, set up error indicator
      **  so that program returns to subfile selection and user could
      **  identify cause of problem.
     C     W_TakonError  Ifeq      'Y'                                          Begin W_TakenError
     C                   Eval      CSRetnCode = 'Error'
 
     C                   Endif                                                  End W_TakenError
 
     C                   Endsr
      /Eject
      *****************************************************************
      /Title SR/#Sndms
      *****************************************************************
      *  #Sndms - Subroutine to send message to Program's Message     *
      *              Queue.                                           *
      *                                                               *
      *  Called by: Main processing                                   *
      *             #Vlsfl                                            *
      *             #Takon                                            *
      *                                                               *
      *  Calls:     None                                              *
      *****************************************************************
     C     #Sndms        Begsr                                                  ** #Sndms SR **
 
     C                   Call      'SNDERMSG'
     C                   Parm      PSProcName    P@PgmQueue       10            Program queue
     C                   Parm                    P@CallMsgQueue    5            Rel queue
     C                   Parm                    P@MsgId           7            Message Id.
     C                   Parm      'PBUSRMSG'    P@MsgFile        10            Message file.
     C                   Parm                    P@MsgDta        132            Message data.
     C                   Parm                    P@MsgType         7            Message type.
 
     C                   Endsr
      /Eject
      *****************************************************************
      /Title SR/#Clear
      *****************************************************************
      *  #Clear    - Subroutine to clear program message queue.       *
      *                                                               *
      *  Called by: Main Processing                                   *
      *             #Takon                                            *
      *                                                               *
      *  Calls:     Program CLRERMSG                                  *
      *****************************************************************
     C     #Clear        Begsr                                                  ** #Clear SR **
 
     C                   Call      'CLRERMSG'
     C                   Parm      PSProcName    P@PgmQueue       10
     C                   Parm      '*SAME'       P@CallMsgQueue    5
 
     C                   Endsr
      /Eject
      *****************************************************************
      /Title SR/*Pssr
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      *  Called by: (**calling routines**)                            *
      *                                                               *
      *  Calls:     program DBERRCTL                                  *
      *                                                               *
      *****************************************************************
 
     C     *Pssr         Begsr                                                  ** *Pssr SR **
 
     C     W_RunBefore   Ifeq      *Blank                                       Begin W_RunBefore
     C                   Eval      W_RunBefore = 'Y'
 
     C                   Dump
 
     C     *lock         In        Lda
     C                   Eval      Dbpgm = PSProcName
 
      **  If not a Database Error.
     C     Dbkey         Ifeq      *blanks                                      Begin Dbfile
     C                   Eval      Dbmod = PSProcName
     C                   Eval      ZZ053 = PSExcpData
 
     C                   Endif                                                  End Dbfile
 
     C                   Out       Lda
 
     C                   Endif                                                  End W_Runbefore
 
     C                   Eval      *inu7 = True
     C                   Eval      *inu8 = True
     C                   Eval      *inlr = True
 
     C                   Return
 
     c                   Endsr
      /Eject
      *****************************************************************
      /Title SR/*Inzsr
      *****************************************************************
      *                                                               *
      *  *Inzsr  - Program Initialization routine.                    *
      *                                                               *
      *  Called By: Implicitly on program activation.                 *
      *                                                               *
      *  Calls:     None                                              *
      *                                                               *
      *****************************************************************
     C     *Inzsr        Begsr                                                  ** *Inzsr SR **
 
      ** Retrieve Run Date.
     C     *Dtaara       Define                  RUNDAT
     C                   In        RUNDAT
 
      **  Check System Date Format, DDMMYY or MMDDYY.
     C     AGDFF         Ifeq      'M'                                          Begin AGDFF
     C                   Eval      *in98 = True
 
     C                   Endif                                                  End AGDFF
 
      ** Retrieve Midas system prefix.
     C     *Dtaara       Define                  SDSTAT
     C                   In        SDSTAT
 
      **  Set up Subfile Program Message Queue Name.
     C                   Eval      ##PGM = PSProcName
 
      **  Set up Subfile Control Fields.
     C                   Eval      SUSER = PSUser                               User
     C                   Eval      SRUNA = AGMRDT                               Run Date
     C                   Eval      SWSID = PSJobName                            Workstation
 
      **  UPdate Customer Selection Data Area with name of calling program.
     C     *lock         In        RPCust
     C                   Eval      CSCallPgm = PSProcName
     C                   Out       RPCust
 
     C                   Endsr
      /Eject
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2001
**  TabMsgId
RP00001Transactions/Positions take on
RP00004PB Customers selection for take on
