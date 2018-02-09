     H DEBUG
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas PB Replication operator menu')
      *****************************************************************
      *                                                               *
      *  Midas - Private Banking Module.                              *
      *                                                               *
      *  RP1300 - Replication Operator Menu.                          *
      *                                                               *
      *  Function: This Module allows to use most of functions        *
      *            needed when Replication software is installed.     *
      *                                                               *
      *  Component of: RP1300 - Replication Operator Menu.            *
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
 
      **  Replication Operator Menu Display File.
     FRP1300DF  CF   E             WORKSTN INFDS(Dspfds)
     F                                     SFILE(RP1300S1:Rrn1)
     F                                     INFSR(*Pssr)
 
      **  Replication Operator Menu Items file.
     FRPMENUL1  IF   E           K DISK
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
      *  70  -  Conditionning indicator to store first available item.*
      *                                                               *
      *  81  -  End of file RPMENUL1.                                 *
      *  82  -  Resulting indicator on READC operation.               *
      *                                                               *
      *  98  -  Date Format indicator (*OFF = DDMMYY).                *
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
      *       * xx   62   63   64   65   66   67   68   69   xx *     *
      *       * 71   72   73   74   75   76   77   78   79   80 *     *
      *       * xx   xx   83   84   85   86   87   88   89   90 *     *
      *       * 91   92   93   94   95   96   97   xx   99      *     *
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
 
      **  Display File Information Data Stucture.
     D DSPFDS          DS
     D  RWCL                 370    371B 0
     D  CURS                 378    379B 0
 
      **  Data Structure for command string for QCMDEXC
     D CMDTXT          DS           240
     D  SYSID1                21     22
     D  SYSID2                22     23
 
      **  External Data structure for Run Date Informations.
     D RUNDAT        E DS
 
      **  External Data structure for System Informations.
     D SDSTAT        E DS
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      **  Work field used to calculate relative record number.
     D W_Rrn1          S              4  0
 
      **  Work field used to indicate there is at least one subfile
      **  selection field in error.
     D W_Error         S              1
 
      **  Work field used to condition execution of take on.
     D W_TakeOn        S              1
 
      **  Number of blanks lines that have to be inserted in subfile.
     D W_NbrBlkLines   S              1  0
 
      **  Work field used to know whether take on has completed
      **  abnormally.
     D W_TakonError    S              1
 
      **---------------- Start of QCMDEXC Parameters ----------------**
      **  Return Code
     D P_ReturnCode    S              2
      **  Command string.
     D P_Command       S             90
      **  Command length.
     D P_Length        S             15
      **  Message Id.
     D P_MsgId         S              7
      **  Message Data.
     D P_Msgdta        S            256
      **  Message file.
     D P_Msgf          S             10
      **  Message file library.
     D P_Msgflib       S             10
      **----------------- End of QCMDEXC Parameters -----------------**
 
      **  Work field used to determine exact length of command string.
     D W_Length        S             15  0
 
      **  Work field used to avoid dump to be done more than once.
     D W_RunBefore     S              1A
 
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
 
      **  If no item to display, send information message.
     C                   Eval      *in42 = True
     C     Rrn1          Ifeq      0                                            Begin Rrn1
     C                   Eval      *in42 = False
     C                   Eval      P@MsgId  = 'RP00001'
     C                   Exsr      #Sndms
 
     C                   Endif                                                  End Rrn1
 
     C                   Write     #MSGCTL                                      Error Message
     C                   Write     RP1300F0                                     Command Key
 
     C                   Exfmt     RP1300C1                                     Subfile
 
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
 
      **  If no available item, skip processing.
     C     Rrn1          Ifeq      0                                            Begin Rrn1
     C                   Iter
 
     C                   Endif                                                  End Rrn1
 
      **  Only process relative record number different from 0.
      **  Relative record number equal to 0 means cursor was
      **  located outside the subfile.
     C     SCRRN1        Ifeq      0                                            Begin SCRRN1
     C                   Iter
 
     C                   Endif                                                  End SCRRN1
 
     C                   Eval      SPRN1 = SCRRN1
 
      **  Access to subfile record to get program or command to run.
     C     SCRRN1        Chain     RP1300S1                           82
 
      **  If subfile record was not found.
     C     *in82         Ifeq      True                                         Begin *in82
     C                   Iter
 
     C                   Endif                                                  End *in82
 
      **  Only process menu items ...
     C                   If        STYPE <> 'F'                                 Begin STYPE
     C                   Iter
 
     C                   Endif                                                  End STYPE
 
      **  ... menu command of which is available.
     C                   If        SPCMD = *blanks                              Begin SPCMD
     C                             Or %subst(SPCMD:1:1) = '*'
     C                   Eval      P@MsgId   = 'RP00027'
     C                   Eval      P@MsgDta  = %Triml(SINAR)
     C                   Exsr      #Sndms
     C                   Iter
 
     C                   Endif                                                  End SPCMD
 
      **  Run program or command.
     C                   Movel     SPCMD         P_Command
     C                   Move      SPARA         P_Command
     C     ' '           Checkr    P_Command     W_Length
     C                   Move      W_Length      P_Length
     C                   Call      'RPC1312'
     C                   Parm      *blanks       P_ReturnCode
     C                   Parm                    P_Command
     C                   Parm                    P_Length
     C                   Parm      *blanks       P_Msgid
     C                   Parm      *blanks       P_Msgdta
     C                   Parm      *blanks       P_Msgf
     C                   Parm      *blanks       P_Msgflib
 
      **  If Run Command program ended abnormally.
     C     P_ReturnCode  Ifne      *blanks                                      Begin P_ReturnCode
     C                   Eval      P@MsgId   = 'RP00004'
     C                   Eval      P@MsgDta  = %Triml(SINAR)
     C                   Exsr      #Sndms
     C                   Iter
 
     C                   Endif                                                  End P_ReturnCode
 
      **  If any message was sent while running command.                        Begin P_Msgid
     C     P_Msgid       Ifne      *blanks
     C                   Eval      P@MsgFile = P_Msgf
     C                   Eval      P@MsgId   = P_Msgid
     C                   Eval      P@MsgDta  = P_MsgDta
     C                   Exsr      #Sndms
     C                   Eval      P@MsgFile = 'PBUSRMSG'
 
     C                   Endif                                                  End P_Msgid
 
     C                   Endsl                                                  End Select
 
     C                   Enddo                                                  End DO_W_KC
      *
      *** Setup library list with the library list of the job description MIDASIC
     C                   Call      'RPC1319'
     C                   Parm      *Blanks       P_Return          7
     C                   Parm      'RESTORE'     P_Action          7
      *
     C                   If        P_Return = '*ERROR*'
     C     *lock         In        Lda                                          ****************
     C                   Z-add     1             Dbase                          ** DBError 01 **
     C                   Move      'RPC1319'     Dbfile                         ****************
     C                   Eval      Dbkey = 'RESTORE'
     C                   Eval      DBPGM  = PSProcMod
     C                   Exsr      *PSSR
     C                   Out       Lda
     C                   EndIf
 
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
     C                   Write     RP1300C1
     C                   Eval      *in41 = True
     C                   Eval      *in70 = False
 
      **  Initialize Subfile Relative Record Number.
     C                   Eval      W_Rrn1 = 0
 
      **  Read all Replication Operator Menu items.
     C     *Loval        Setll     RPMENUL1
     C                   Read      RPMENUL1                               81
 
      **  Do while menu items to be processed.
     C     *In81         Doweq     False                                        Begin DO_W_81
 
      **  Only display available menu items.
     C                   If        MNACTI = 'Y'                                 Begin MNACTI
 
     C                   Clear     *All          RP1300S1
     C                   Movea     '000'         *In(50)
 
     C                   Move      MNICDE        W_NbrBlkLines
 
      **  If blank lines have to be inserted in subfile.
     C                   If        W_NbrBlkLines <> 0                           Begin W_NbrBlkLines
 
     C                   Do        W_NbrBlkLines                                Begin Do
     C                   Eval      W_Rrn1 = W_Rrn1 + 1
     C                   Eval      Rrn1 = W_Rrn1
     C                   Eval      STYPE = 'B'
     C                   Write     RP1300S1
 
     C                   Enddo                                                  End Do
 
     C                   Endif                                                  End W_NbrBlkLines
 
      **  Set up subfile relative record number.
     C                   Eval      W_Rrn1 = W_Rrn1 + 1
     C                   Eval      Rrn1 = W_Rrn1
 
      **  Initialize Subfile Record Fields from Replication
      **  Functions Control File fields.
     C                   Exsr      #Infld
 
      **  Write a record in subfile.
     C                   Write     RP1300S1
 
     C                   Endif                                                  Endif MNACTI
 
      **  Read next Replication Function record to be processed.
     C                   Read      RPMENUL1                               81
 
     C                   Enddo                                                  End DO_W_81
 
      **  Set up Relative Record Number for Page to be displayed.
     C                   Select                                                 Begin Select
 
     C     SPRN1         Wheneq    0                                            First page
     C                   Eval      SPRN1 = W_FirstRrn1
 
     C     SPRN1         Whengt    W_LastRrn1                                   Last page
     C                   Eval      SPRN1 = W_LastRrn1
 
     C                   Endsl                                                  End Select
 
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
 
      **  Set up Item Narrative.
     C                   Movel     MNINAR        SINAR
 
     C                   Select                                                 Begin Select
 
      **  If Menu Group Code, seton indicators so that Group Title
      **  would be underlined and highlighted.
     C                   When      %subst(MNINAR:1:1) <> *blank                 Group line
     C                   Eval      STYPE = 'H'
     C                   Eval      *in52 = True
 
      **  If take on program is not available, set on indicator so
      **  so that item could not be selected.
     C                   When      %subst(MNPCMD:1:1) = '*'                     Not available
     C                   Eval      STYPE = 'F'
 
      **  If selection line, set up hidden fields.
     C                   Other                                                  Selection line
     C                   Eval      STYPE = 'F'
     C     *in70         Ifeq      False                                        Begin *in70
 
      **  Store First Subfile Relative Record Number, relative to
      **  a Function.
     C     *Like         Define    Rrn1          W_FirstRrn1
     C                   Eval      W_FirstRrn1 = Rrn1
     C                   Eval      *in70 = True
 
     C                   Endif                                                  End *in70
 
      **  Store Last Subfile Relative Record Number, relative to
      **  a Function.
     C     *Like         Define    Rrn1          W_LastRrn1
     C                   Eval      W_LastRrn1 = Rrn1
 
     C                   Eval      SPCMD = MNPCMD                               Program name
     C                   Eval      SPARA = MNPARA                               Program parameters
     C                   Eval      P_Scan = MNPARA
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
 
     C                   Eval      SPARA = %Subst(MNPARA:1:P_Begin-1)
     C                                     + Libr
     C                                     + %Subst(MNPARA:P_End:P_Total)
     C                   Endif
 
     C                   Endsl                                                  End Select
 
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
      *                                                               *
      *  Calls:     None                                              *
      *****************************************************************
     C     #Sndms        Begsr                                                  ** #Sndms SR **
 
     C                   Call      'SNDERMSG'
     C                   Parm      PSProcName    P@PgmQueue       10            Program queue
     C                   Parm                    P@CallMsgQueue    5            Rel queue
     C                   Parm                    P@MsgId           7            Message Id.
     C                   Parm                    P@MsgFile        10            Message file.
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
 
      **  If program error subroutine is given control for any
      **  file exception.
     C     *lock         In        Lda
     C     DBFILE        Ifeq      *Blanks                                      Begin DBFILE
     C                   Eval      DBPGM  = PSProcMod
     C                   Eval      DBFILE = PSLastFile
     C                   Eval      DBKEY  = PSFileInfo
 
     C                   Endif                                                  End DBFILE
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
      *  Called ²y: Implicitly on program activation.                 *
      *                                                               *
      *  Calls:     None                                              *
      *                                                               *
      *****************************************************************
     C     *Inzsr        Begsr                                                  ** *Inzsr SR **
 
      **  Set up copyright parameter:
     C                   Movea     CPY@          CPY2@            80
 
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
     C                   MOVE      PSUser        SUSER                          User
     C                   MOVE      AGMRDT        SRUNA                          Run Date
     C                   MOVE      PSJobName     SWSID                          Workstation
     C                   Eval      P@MsgFile = 'PBUSRMSG'
      *
      *** Setup library list with the library list of the job description
      *** Jobd is retrieved from DTAARA/RPTRG
     C                   Call      'RPC1319'
     C                   Parm      *Blanks       P_Return          7
     C                   Parm      'SETUP'       P_Action          7
      *
     C                   If        P_Return = '*ERROR*'
     C     *lock         In        Lda                                          ****************
     C                   Z-add     2             Dbase                          ** DBError 02 **
     C                   Move      'RPC1319'     Dbfile                         ****************
     C                   Move      'SETUP'       Dbkey
     C                   Eval      DBPGM  = PSProcMod
     C                   Exsr      *PSSR
     C                   Out       Lda
     C                   EndIf
      *
     C                   EXSR      #Clear
      *
     C                   Endsr
      /Eject
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2001
