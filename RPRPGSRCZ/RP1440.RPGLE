     H DEBUG
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas RP PB Standing Data Take on.')
      *****************************************************************
      *                                                               *
      *  Midas - Private Banking Module.                              *
      *                                                               *
      *  RP1440 - Standing Data take on.                              *
      *                                                               *
      *  Function:    This program allows to download Standing Data   *
      *            from Midas to PC site by using Meridian            *
      *            Replication functions.                             *
      *                                                               *
      *  Component of: RP1440 - Standing Data take on.                *
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
 
      **  Standing Data Take-on display File.
     FRP1440DF  CF   E             WORKSTN INFDS(Dspfds)
     F                                     SFILE(RP1440S1:Rrn1)
     F                                     INFSR(*Pssr)
 
      **  Standing Data Take-on control file, sorted by Group Code
      **  and Short Code.
     FRPSDTOL1  IF   E           K DISK
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
      *  81  -  End of file RPSDTOL1.                                 *
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
 
      **  External Data structure for Run Date Informations.
     D RUNDAT        E DS
 
      **  External Data structure for System Informations.
     D SDSTAT        E DS
 
      **  External data structure for Bank Details.
     D Sdbank        E DS                  Extname(SDBANKPD)
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
      **  Command string.
     D P_Command       S             80A
      **  Command length.
     D P_Length        S             15  5
      **----------------- End of QCMDEXC Parameters -----------------**
 
      **  Work field used to determine exact length of command string.
     D W_Length        S              3  0
 
      **  Work field used to setup PB00115 message data.
     D W_Title         S             25A   INZ('Standing Data')
 
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
 
      **  If no Standing Data to download, send information message.
     C                   Eval      *in42 = True
     C     Rrn1          Ifeq      0                                            Begin Rrn1
     C                   Eval      *in42 = False
     C                   Eval      P@MsgId  = 'RP00001'
     C                   Eval      P@MsgDta = W_Title
     C                   Exsr      #Sndms
 
     C                   Endif                                                  End Rrn1
 
     C                   Write     #MSGCTL                                      Error Message
     C                   Write     RP1440F0                                     Command Key
 
     C                   Exfmt     RP1440C1                                     Subfile
 
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
 
      **  If no Standing Data to download, skip processing.
     C     Rrn1          Ifeq      0                                            Begin Rrn1
     C                   Iter
 
     C                   Endif                                                  End Rrn1
 
      **  Validate Subfile selection.
     C                   Exsr      #Vlsfl
 
      **  If no subfile selection error, process Take-on.
     C     W_TakeOn      Ifeq      'Y'                                          Begin W_TakeOn
     C     W_Error       Andeq     *blank
     C                   Exsr      #Takon
 
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
     C                   Write     RP1440C1
     C                   Eval      *in41 = True
 
      **  Initialize Subfile Relative Record Number.
     C                   Eval      W_Rrn1 = 0
 
      **  Read all Standing Data to be processed by take-on.
     C     *Loval        Setll     RPSDTOL1
     C                   Read      RPSDTOL1                               81
 
      **  Do while Standing Data to be processed.
     C     *In81         Doweq     False                                        Begin DO_W_81
 
      **  If program is not available for the item, do not display it.
     C                   If        %Subst(SDPCMD:1:1) <> '*'                    Begin TSPCMD
     C                             or SDACTI = *blanks
 
     C                   Clear     *All          RP1440S1
     C                   Movea     '000'         *In(50)
     C                   Movea     '0'           *In(61)
 
     C                   Move      SDICDE        W_NbrBlkLines
 
      **  If blank lines have to be inserted in subfile.
     C                   If        W_NbrBlkLines <> 0                           Begin W_NbrBlkLines
 
     C                   Do        W_NbrBlkLines                                Begin Do
     C                   Eval      W_Rrn1 = W_Rrn1 + 1
     C                   Eval      Rrn1 = W_Rrn1
     C                   Eval      *in61 = True
     C                   Write     RP1440S1
 
     C                   Enddo                                                  End Do
 
     C                   Endif                                                  End W_NbrBlkLines
 
      **  Initialize Subfile Record Fields from Standing Data
      **  take on file fields.
     C                   Exsr      #Infld
 
      **  Write a record in subfile.
     C                   Eval      W_Rrn1 = W_Rrn1 + 1
     C                   Eval      Rrn1 = W_Rrn1
     C                   Write     RP1440S1
 
     C                   Endif                                                  Endif TPPCMD
 
      **  Read next Standing Data record to be processed.
     C                   Read      RPSDTOL1                               81
 
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
     C                   Movel     SDINAR        SINAR
 
     C                   Select                                                 Begin Select
 
      **  If Menu Group Code, seton indicators so that Group Title
      **  would be underlined and highlighted.
     C                   When      %subst(SINAR:1:1) <> *blank                  Group line
     C                   Eval      *in52 = True
     C                   Eval      *in61 = True
 
      **  If take on item not allowed, set on indicator so that item
      **  could not be selected.
     C                   When      SDACTI = 'N'                                 Not allowed
     C                   Eval      *in61 = True
 
      **  If selection line, set up hidden fields.
     C                   Other                                                  Selection line
     C                   Eval      SPCMD = SDPCMD                               Program name
     C                   Eval      SPARA = SDPARA                               Program parameters
     C                   Eval      P_Scan = SDPARA
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
 
     C                   Eval      SPARA = %Subst(SDPARA:1:P_Begin-1)
     C                                     + Libr
     C                                     + %Subst(SDPARA:P_End:P_Total)
     C                   Endif
 
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
     C                   Eval      W_Error  = *blank
     C                   Eval      W_TakeOn = *blank
 
     C                   Eval      *in61 = False
 
      **  Read changed records.
     C                   Readc     RP1440S1                               82
 
      **  Do while changed records to be processed.
     C     *in82         Doweq     False                                        Begin Do_w_82
     C                   Movea     '000'         *in(50)
 
      **  If selection field does not contain "X", send an error message,
      **  but only on.
     C     SSEL          Ifne      *blank                                       Begin SSEL_1
 
      **  If correct value.
     C     SSEL          Ifeq      'X'                                          Begin SSEL_2
     C                   Eval      *in50 = True
     C                   Eval      W_TakeOn = 'Y'
 
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
 
      **  Update Subfile record.
     C                   Update    RP1440S1
 
      **  Read next changed record.
     C                   Readc     RP1440S1                               82
 
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
      *  Calls:     #Clear                                            *
      *             #SndMs                                            *
      *                                                               *
      *****************************************************************
     C     #Takon        Begsr                                                  ** #Takon SR **
 
      **  Clear Program Message Queue.
     C                   Exsr      #Clear
     C                   Write     #MSGCTL
 
      **  Display "Take on in progress..." information message.
     C                   Write     RP1440W1
 
      **  Initialize work field used to know whether take on
      **  has completed successfully or not.
     C                   Eval      W_TakonError = 'N'
      *
      **  Read changed records.
     C                   Readc     RP1440S1                               82
 
      **  Do while changed records to be processed.
     C     *in82         Doweq     False                                        Begin Do_w_82
 
      **  Call take on program.
     C                   Movel     SPCMD         P_Command
     C                   Move      SPARA         P_Command
     C     ' '           Checkr    P_Command     W_Length
     C                   Call      'QCMDEXC'
     C                   Parm                    P_Command
     C                   Parm      W_Length      P_Length
 
      **  Update Subfile record.
     C                   Eval      SSEL = *blanks
     C                   Update    RP1440S1
 
      **  Read next changed record.
     C                   Readc     RP1440S1                               82
 
     C                   Enddo                                                  End Do_w_82
 
      **  Send completion message.
     C                   Eval      P@MsgId  = 'RP00005'
     C                   Exsr      #Sndms
 
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
      *
     C                   Endsr
      /Eject
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2001
