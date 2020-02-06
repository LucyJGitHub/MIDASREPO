     H DEBUG
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas RP Private Banking Customer Selection input.')
      *****************************************************************
      *                                                               *
      *  Midas - Windows                                              *
      *                                                               *
      *  RP1430 - Private Banking Customer selection.                 *
      *                                                               *
      *  Function:    This module allows to select either a range of  *
      *            Private Banking Customers or all Private Banking   *
      *            Customers for an Account Officer, plus the main    *
      *            Customer Branch.                                   *
      *               Range and Account Officer selections are        *
      *            mutually exclusive                                 *
      *                                                               *
      *  (phase(s) Input Cycle)                                       *
      *                                                               *
      *  Component of: RP1430 - Private Banking Customer selection    *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CPB002  *CREATE    Date 01Jun99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CPB002 - Meridian DBA Middleware Replication Customization.  *
      *                                                               *
      *****************************************************************
 
      **  PB Private Banking customers selection display file.
     FRP1430DF  CF   E             Workstn Infsr(*Pssr)
 
      **  SD Optional window reference file.
     FSDOREFL1  IF   E           K Disk
     F                                     Infsr(*Pssr)
 
      /EJECT
      *****************************************************************
      *                                                               *
      *          F U N C T I O N   O F   I N D I C A T O R S          *
      *          -------------------------------------------          *
      *                                                               *
      *  03  -  Key <CA03> response indicator.                        *
      *  05  -  Key <CA05> response indicator.                        *
      *  12  -  Key <CA12> response indicator.                        *
      *                                                               *
      *  25  -  SFLEND (Message subfile)                              *
      *                                                               *
      *  37  -  Multibranching Indicator is ob.                       *
      *                                                               *
      *  51  -  Error on From Customer Number.                        *
      *  52  -  Error on To Customer Number.                          *
      *  53  -  Error on Account Officer Code.                        *
      *  54  -  Error on Main Customer Branch.                        *
      *                                                               *
      *  72  -  Key <CA12> is available.                              *
      *  75  -  General error indicator.                              *
      *  77  -  SCAN resulting indicator.                             *
      *                                                               *
      *  81  -  Access to SDOREFL1 fails.                             *
      *                                                               *
      *  U7                                                           *
      *  U8  -  Database error.                                       *
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
      *       * 21   22   23   24   xx   26   27   28   29   30 *     *
      *       * 31   32   33   34   35   36   37   38   39   40 *     *
      *       * 41   42   43   44   45   46   47   48   49   50 *     *
      *       * xx   xx   xx   xx   55   56   57   58   59   60 *     *
      *       * 61   62   63   64   65   66   67   68   69   70 *     *
      *       * 71   xx   73   74   xx   76   xx   78   79   80 *     *
      *       * xx   82   83   84   85   86   87   88   89   90 *     *
      *       * 91   92   93   94   95   96   97   98   99      *     *
      *       ***************************************************     *
      *                                                               *
      *****************************************************************
      /Space 3
      *****************************************************************
      *                                                               *
      *                S U B R O U T I N E   I N D E X                *
      *                -------------------------------                *
      *                                                               *
      *  #Valid - Subroutine to validate customer range selection.    *
      *  #SndMs - Subroutine to send message to Program Message Queue.*
      *  #Clear - Subroutine to clear Program Message Queue.          *
      *  *Pssr  - Program exception error routine.                    *
      *  *Inzsr - Program initialization routine.                     *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
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
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
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
     D  Cancel                12     12
      ** ¦                                                                ¦
      ** ¦                                                                ¦
      ** ¦                                                                ¦
      ** ¦ Set the indicator array pointer                                ¦
     D pIndicator      S               *   INZ(%Addr(*In))
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      **  Array containing Copyright statement
     D Cpy@            S             80    Dim(1) Ctdata Perrcd(1)
 
      **  Midas Local Data Area for database error reporting; based on
      **  external file
     D Lda           E DS           256    Extname(LDA) DTAARA(LDA)
      **  The following fields are defined in the external file:
      **                                    134 141 DBFile
      **                                    142 170 DBKey
      **                                    171 180 DBPgm
      **                                    181 1830DBase
      **                                    184 193 DBMod
      **                                    194 203 DBProc
 
      **  External Data structure for Run Date Informations.
     D Rundat        E DS                  Extname(RUNDAT) DTAARA(RUNDAT)
 
      **  Customer Selection Data Area.
     D RPCust        E DS                  Extname(RPCUST) DTAARA(RPCUST)
 
      **  External data structure for access to SD Customer Details.
     D Sdcust        E DS                  Extname(SDCUSTPD)
 
      **  External data structure for access to SD Account Officer Details.
     D Sdacof        E DS                  Extname(SDACOFPD)
 
      **  External data structure for access to SD Branch Details.
     D Sdbrch        E DS                  Extname(SDBRCHPD)
     D  #DFAC1       E                     EXTFLD(QQDFAC)                                     CGL029
      *
      **  First Data Structure for Access Programs, short Data Structure.
     D Dsfdy         E DS                  Extname(DSFDY)
 
      **  Second Data Structure for Access Programs, long Data Structure.
     D Dssdy         E DS                  Extname(DSSDY)
 
      **  Third Data Structure for Access Programs, very long Data Structure.
     D Dsldy         E DS                  Extname(DSLDY)
 
      **  Data Structure used to get Account Officer code.
     D SACOC           DS             2
     D  SACOC1                 1      2
     D  SACOC2                 1      2
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** --------- Start of fields used by access programs ----------**
      **  Return code.
     D P_RtCd          S              7A
      **  Option.
     D P_Optn          S              7A
      **  Calling program + sequence number to access to SDOREFL1.
     D P_Keys          S             12A
      **  Customer Shortname or Number.
     D P_Cnum          S             10A
      **  Customer Key Status.
     D P_Cnst          S              7A
      **  Account Officer Code.
     D P_Acoc          S              2A
      **  Branch Code.
     D P_Brca          S              3A
      ** ---------- End of fields used by access programs -----------**
 
      **---- Start of fields used by programs SNDERMSG/CLRERMSG -----**
      **  Program queue.
     D P_Pgmq          S             10A
      **  Rel queue.
     D P_Pgrl          S              5A
      **  Message Id.
     D P_Msid          S              7A
      **  Message file.
     D P_Msgf          S             10A
      **  Message data.
     D P_Amsa          S            132A
      **  Message type.
     D P_Mstp          S            132A
      **----- End of fields used by programs SNDERMSG/CLRERMSG ------**
 
      **  Work fields used to save screen "From" and "To" customer numbers.
     D K_Nmcp          S             10A
     D K_Fnky          S              2A
 
      **  Work fields used to save screen "From"/"To" customer numbers
      **  and Account Officer.
     D W_SCUSTB        S             10A
     D W_SCUSTA        S             10A
     D W_SACOC         S              2A
 
      **  Work Field used to enable or not <CA12> function key.
     D W_Key           S              1S 0
 
      **  Work fields used to return key that was pressed.
     D W_Exit          S             10A   INZ('Exit')
     D W_Cancel        S             10A   INZ('Cancel')
 
      ** True and False can be used for indicators being on or off.
     D True            C                   *On
     D False           C                   *Off
 
      **  Work Field used to produce only one dump.
     D W_RunBefore     S              1A
 
      **  Work field used to set up window title when not found
      **  in SDOREFPD.
     D W_Title         S             50A   INZ('                Customer +
     D                                     Selection')
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /Eject
      *****************************************************************
 
     C     Start         TAG
      ** Note: the above tag is only there to force the first comments in
      ** the C-specs to appear after the D- or I-specs in compiled listings.
 
      *****************************************************************
      *                                                               *
      *                 M A I N   P R O C E S S I N G                 *
      *                                                               *
      *****************************************************************
 
      **  Perform initialization subroutine as program remains in memory.
     C                   Exsr      #Init
 
     C     Exit          Doweq     False                                        Begin Do_While
 
      **  Display message subfile, only if any error occured.
     C     *in75         Ifeq      True                                         Begin *in75
     C                   Write     #MSGCTL
 
     C                   Endif                                                  End *in75
 
      **  Display window.
     C                   Exfmt     RP1430F1
 
      **  1lear Program Message Queue.
     C                   Exsr      #Clear
 
     C                   Select                                                 Begin Select
 
      **  If exit or cancellation(return to previos screen) was required.
     C     Exit          Wheneq    True                                         Exit
     C     Cancel        Oreq      True                                         Cancel
     C                   Leave
 
      **  If refresh required.
     C     Refresh       Wheneq    True                                         Refresh
     C                   Eval      SCUSTB = CSFromCust
     C                   Eval      SCUSTA = CSToCust
     C                   Eval      SACOC  = CSAcofCode
     C                   Eval      SBRCH  = CSMainBrch
     C                   Movea     '0000'        *In(51)
     C                   Eval      *In75 = True
     C                   Iter
 
     C                   Other                                                  Enter
 
      **  Validate Input.
     C                   Exsr      #Valid
 
      **  If no error.
     C     *In75         Ifeq      False                                        Begin *In75
     C                   Leave
 
     C                   Endif                                                  End *In75
 
     C                   Endsl                                                  End Select
 
     C                   Enddo                                                  End Do_While
 
      **  Update Customer Selection Data Area with screen field values,
      **  depending on key pressed.
     C     *Lock         In        RPCUST
 
     C                   Select                                                 Begin Select
 
      **  If exit was required.
     C     Exit          Wheneq    True                                         Exit
     C                   Eval      CSRetnCode   = W_Exit
 
      **  If cancellation (return to previous screen) was required.
     C     Cancel        Wheneq    True                                         Cancel
     C                   Eval      CSRetnCode   = W_Cancel
 
      **  If input was validated.
     C                   Other                                                  Enter
     C                   Eval      CSFromCust    = SCUSTB
     C                   Eval      CSToCust      = SCUSTA
     C                   Eval      CSAcofCode    = SACOC
     C                   Eval      CSMainBrch    = SBRCH
 
     C                   Endsl                                                  End Select
 
     C                   Out       RPCUST
 
      **  Termination processing.
     C                   Close     RP1430DF
     C                   Return
 
      /Eject
      *****************************************************************
      *                                                               *
      *  #Valid - Validation subroutine.                              *
      *                                                               *
      *  Called By: Main processing                                   *
      *                                                               *
      *  Calls:     #Sndms                                            *
      *                                                               *
      *****************************************************************
     C     #Valid        Begsr                                                  ** #Valid SR **
 
      **  Set off error indicators.
     C                   Movea     '0000'        *in(51)
     C                   Eval      *in75 = False
 
      **  If both Customer Range and Account Officer have been left blank.
     C     SCUSTB        Ifeq      *blanks                                      Begin SCUSTB
     C     SCUSTA        Andeq     *blanks
     C     SACOC         Andeq     *blanks
     C                   Eval      P_Msid = 'RP00008'
     C                   Movea     '111'         *in(51)
     C                   Eval      *IN75 = True
     C                   Exsr      #SndMs
     C                   Goto      @ValBranch
 
     C                   Endif                                                  End SCUSTB
 
      **  If both Range and Account Officer selections have been required.
     C     SCUSTB        Ifne      *blanks                                      Begin SCUSTB
     C     SACOC         Andne     *blanks
     C     SCUSTA        Orne      *blanks
     C     SACOC         Andne     *blanks
     C                   Eval      P_Msid = 'RP00009'
     C                   Movea     '111'         *in(51)
     C                   Eval      *IN75 = True
     C                   Exsr      #SndMs
     C                   Goto      @ValBranch
 
     C                   Endif                                                  End SCUSTB
 
      **  If Account Officer selection was choosed.
     C     SACOC         Ifne      *blanks                                      Begin SACOC
     C                   Goto      @ValAccOff
 
     C                   Endif                                                  End SACOC
 
      **  If all Private Banking Customers were selected.
     C     SCUSTB        Ifeq      'ALL       '                                 Begin SCUSTB
     C     SCUSTA        Andeq     *Blanks
     C                   Goto      @ValBranch
 
     C                   Endif                                                  End SCUSTB
 
      **  If "From" customer Number was not input.
     C     SCUSTB        Ifeq      *Blanks                                      Begin SCUSTB
     C                   Eval      P_Msid = 'RP00010'
     C                   Eval      *in51 = True
     C                   Eval      *in75 = True
     C                   Exsr      #SndMs
 
      **  If "From" Customer Number was input.
     C                   Else                                                   Else SCUSTB
 
      **  Check if selection was requested for "From" Customer Number.
     C                   Eval      W_SCUSTB = SCUSTB
     C     '?'           Scan      SCUSTB                                 77
 
      **  If selection was requested.
     C     *in77         Ifeq      True                                         Begin *in77
     C                   Eval      SCUSTB = '?'
 
     C                   Endif                                                  End *in77
 
      **  Check if valid "From" Customer number/shortname.
     C                   Callb     'AOCUSTR1'
     C                   Parm      *blanks       P_Rtcd
     C                   Parm      '*KEY   '     P_Optn
     C                   Parm      SCUSTB        P_Cnum
     C                   Parm                    P_Cnst
     C     Sdcust        Parm      Sdcust        Dsldy
 
      **  If no record found, send message.
     C     P_Rtcd        Ifne      *Blanks                                      Begin P_Rtcd
     C                   Eval      P_Msid = 'RP00011'
     C                   Eval      *in51 = True
     C                   Eval      *in75 = True
     C                   Exsr      #SndMs
 
      **  If selection was requested.
     C     *In77         Ifeq      True                                         Begin *In77
     C                   Eval      SCUSTB = W_SCUSTB
 
     C                   Endif                                                  End *In77
 
      **  If record was found.
     C                   Else                                                   Else P_Rtcd
 
      **  If selection was requested.
     C     *In77         Ifeq      True                                         Begin *In77
     C                   Eval      SCUSTB = BBCUST
 
     C                   Endif                                                  End *In77
 
     C                   Endif                                                  End P_Rtcd
 
     C                   Endif                                                  End SCUSTB
 
      **  If "To" customer Number was not input.
     C     SCUSTA        Ifeq      *Blanks                                      Begin SCUSTA
     C                   Eval      P_Msid = 'RP00013'
     C                   Eval      *in52 = True
     C                   Eval      *in75 = True
     C                   Exsr      #SndMs
 
      **  If "To" Customer Number was input.
     C                   Else                                                   Else SCUSTA
 
      **  Check if selection was requested for "To" Customer Number.
     C                   Eval      W_SCUSTA = SCUSTA
     C     '?'           Scan      SCUSTA                                 77
 
      **  If selection was requested.
     C     *in77         Ifeq      True                                         Begin *in77
     C                   Eval      SCUSTA = '?'
 
     C                   Endif                                                  End *in77
 
      **  Check if valid "To" Customer number/shortname.
     C                   Callb     'AOCUSTR1'
     C                   Parm      *blanks       P_Rtcd
     C                   Parm      '*KEY   '     P_Optn
     C                   Parm      SCUSTA        P_Cnum
     C                   Parm                    P_Cnst
     C     Sdcust        Parm      Sdcust        Dsldy
 
      **  If no record found, send message.
     C     P_Rtcd        Ifne      *Blanks                                      Begin P_Rtcd
     C                   Eval      P_Msid = 'RP00014'
     C                   Eval      *in52 = True
     C                   Eval      *in75 = True
     C                   Exsr      #SndMs
 
      **  If selection was requested.
     C     *in77         Ifeq      True                                         Begin *in77
     C                   Eval      SCUSTA = W_SCUSTA
 
     C                   Endif                                                  End *in77
 
      **  If record was found.
     C                   Else                                                   Else P_Rtcd
 
      **  If selection was requested.
     C     *in77         Ifeq      True                                         Begin *In77
     C                   Eval      SCUSTA = BBCUST
 
     C                   Endif                                                  End *In77
 
     C                   Endif                                                  End P_Rtcd
 
     C                   Endif                                                  End SCUSTA
 
      ** "To" Customer Number must be greater or equal than "From".
     C     SCUSTB        Ifne      *Blanks                                      Begin SCUSTB
     C     SCUSTA        Andne     *Blanks
     C     SCUSTA        Andlt     SCUSTB
     C                   Eval      P_Msid = 'RP00016'
     C                   Eval      *in52 = True
     C                   Eval      *in75 = True
     C                   Exsr      #SndMs
 
     C                   Endif                                                  End FromCustNum
 
     C     @ValAccOff    Tag
 
      **  If Account Officer was input.
     C     SACOC         Ifne      *blanks                                      Begin SACOC
 
      **  Check if selection was requested for Account Officer.
     C                   Eval      W_SACOC = SACOC
     C     '?'           Scan      SACOC                                  77
 
      **  If selection was requested.
     C     *in77         Ifeq      True                                         Begin *in77
     C                   Eval      SACOC = '?'
 
     C                   Endif                                                  End *in77
 
      **  Check existence of Account Officer, by using Access Object.
     C                   Call      'AOACOFR0'
     C                   Parm      *blanks       P_Rtcd
     C                   Parm      '*KEY   '     P_Optn
     C                   Parm      SACOC         P_Acoc
     C     Sdacof        Parm      Sdacof        Dssdy
 
      **  If no record found, send message.
     C     P_Rtcd        Ifne      *Blanks                                      Begin P_Rtcd
     C                   Eval      P_Msid = 'RP00017'
     C                   Eval      *in53 = True
     C                   Eval      *in75 = True
     C                   Exsr      #SndMs
 
      **  If selection was requested.
     C     *in77         Ifeq      True                                         Begin *in77
     C                   Eval      SACOC = W_SACOC
 
     C                   Endif                                                  End *in77
 
      **  If record was found.
     C                   Else                                                   Else P_Rtcd
 
      **  If selection was requested.
     C     *in77         Ifeq      True                                         Begin *In77
     C                   Eval      SACOC = AZACOC
 
     C                   Endif                                                  End *In77
 
     C                   Endif                                                  End P_Rtcd
 
     C                   Endif                                                  End SACOC
 
     C     @ValBranch    Tag
 
      **  If Main Customer Branch was not input, use default value "ALL".
     C     SBRCH         Ifeq      *blanks                                      Begin SBRCH
     C                   Eval      SBRCH = 'ALL'
     C                   Goto      @EndValid
 
     C                   End                                                    End SBRCH
 
      **  If all branches are selected, bypass branch existence check.
     C     SBRCH         Ifeq      'ALL'                                        Begin SBRCH
     C                   Goto      @EndValid
 
     C                   End                                                    End SBRCH
 
      **  Check existence of Branch, by using Access Object.
     C**********         CALLB     'AOBRCHR0'                                                 CGL029
     C                   CALL      'AOBRCHR1'                                                 CGL029
     C                   Parm      *blanks       P_Rtcd
     C                   Parm      '*KEY   '     P_Optn
     C                   Parm      SBRCH         P_Brca
     C     Sdbrch        Parm      Sdbrch        Dssdy
 
      **  If no record found, send message.
     C     P_Rtcd        Ifne      *Blanks                                      Begin P_Rtcd
     C                   Eval      P_Msid = 'RP00018'
     C                   Eval      *in54 = True
     C                   Eval      *in75 = True
     C                   Exsr      #SndMs
 
     C                   Endif                                                  End P_Rtcd
 
     C     @EndValid     Tag
 
     C                   Endsr
      /Eject
      *****************************************************************
      *  #Sndms - Subroutine to send message to Program's Message     *
      *           Queue.                                              *
      *                                                               *
      *  Called by: #Valid                                            *
      *                                                               *
      *  Calls:     None                                              *
      *****************************************************************
 
     C     #Sndms        Begsr                                                  ** #SndMs SR **
 
     C                   Call      'SNDERMSG'
     C                   Parm      PSProcName    P_Pgmq                         Program queue
     C                   Parm                    P_Pgrl                         Rel queue
     C                   Parm                    P_Msid                         Message Id.
     C                   Parm      'PBUSRMSG'    P_Msgf                         Message file.
     C                   Parm                    P_Amsa                         Message data.
     C                   Parm                    P_Mstp                         Message type.
 
     C                   Endsr
      /Eject
      *****************************************************************
      *  #Clear - Subroutine to clear program message queue.          *
      *                                                               *
      *  Called by: Main Processing                                   *
      *                                                               *
      *  Calls:     None                                              *
      *****************************************************************
 
     C     #Clear        Begsr                                                  ** #Clear SR **
 
     C                   Call      'CLRERMSG'
     C                   Parm      PSProcName    P_Pgmq
     C                   Parm      '*SAME'       P_Pgrl
 
     C                   Endsr
      /Eject
      *****************************************************************
      *                                                               *
      *  *PSSR - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      *  Called by: (**calling routines**)                            *
      *                                                               *
      *  Calls:     None                                              *
      *                                                               *
      *****************************************************************
 
     C     *Pssr         Begsr                                                  ** *Pssr SR **
 
     C     W_RunBefore   Ifne      'Y'                                          Begin W_RunBefore
     C                   Eval      W_RunBefore = 'Y'
     C                   Dump
 
     C                   Callb     'DBERRCTL'
 
     C                   Endif                                                  End W_RunBefore
 
     C                   Eval      *inu7 = True
     C                   Eval      *inu8 = True
     C                   Eval      *inlr = True
 
     C                   Return
 
     C                   Endsr
      /Eject
      *****************************************************************
      *                                                               *
      *  #Init - Subroutine to initialize Work and display fields.    *
      *                                                               *
      *  Called By: Main processing                                   *
      *                                                               *
      *  Calls:     None                                              *
      *                                                               *
      *****************************************************************
      *
     C     #Init         Begsr                                                  ** #Init SR **
     C                   Open      RP1430DF                             99
 
      **  Get Customer Selection input defaults from data area.
     C                   In        RPCust
     C                   Eval      SCUSTB = CSFromCust
     C                   Eval      SCUSTA = CSToCust
     C                   Eval      SACOC  = CSAcofCode
     C                   Eval      SBRCH  = CSMainBrch
 
      **  Clear Program Message Queue.
     C                   Exsr      #Clear
     C                   Eval      *in75 = True
 
      **  Initialize work fields and indicators.
     C                   Eval      Exit  = False
     C                   Movea     '0000'        *in(51)
 
     C                   Endsr
      /Eject
      *****************************************************************
      *                                                               *
      *  *Inzsr - Program Initialisation routine.                     *
      *                                                               *
      *  Called By: Implicitly on program activation                  *
      *                                                               *
      *  Calls:     None                                              *
      *                                                               *
      *****************************************************************
      *
     C     *Inzsr        Begsr                                                  ** *Inzsr SR **
 
      **  Get Multi-branching indicator from RUNDAT data area.
     C                   In        RUNDAT
 
      **  If Multi-branching environment, allow Main Customer
      **  Branch selection.
     C     AGMBIN        Ifeq      'Y'                                          Begin AGMBIN
     C                   Eval      *in37  = True
 
     C                   Endif                                                  End AGMBIN
 
      **  Set up Subfile Program Message Queue Name.
     C                   Eval      ##PGM  = PSProcName
 
      **  Define Key list to access to Optional Window Reference File.
     C     K_Sdoref      Klist
     C                   Kfld                    K_Nmcp
     C                   Kfld                    K_Fnky
 
     ²**  Set up key list.
     C                   In        RPCust
     C                   Eval      K_Nmcp = CSCallPgm
     C                   Eval      K_Fnky = '99'
 
      **  Get position of window on screen.
     C     K_Sdoref      Chain     SDOREFL1                           81
 
      **  If record does not exist, display window at fixed positions.
     C     *In81         Ifeq      True                                         Begin *In81
     C                   Eval      Swrow = 6
     C                   Eval      Swcol = 2
     C                   Eval      STITL = W_Title
 
     C                   Else                                                   Else *In81
     C                   Eval      Swrow = DMSRWD
     C                   Eval      Swcol = DMSCWD
     C                   Eval      STITL =  DMPGMT
 
     C                   Endif                                                  End *In81
 
      **  Make key <CA12> available if required by calling program.
     C     DMWINT        Ifne      'F'                                          Begin DMWINT
     C                   Eval      *in72 = True
 
     C                   Endif                                                  End DMWINT
 
     C                   Endsr
      /Eject
      ********************************************************************
**CTDATA CPY@
(c) Finastra International Limited 2001
