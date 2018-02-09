     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SC Invalid features look-up window')
      *****************************************************************
      *                                                               *
      *  Midas - System control module                                *
      *                                                               *
      *  SC0431W0 - Midas SC Invalid features Look-up Window          *
      *                                                               *
      *  Function:  This window program is selected from a UTMENU     *
      *             option which displays all the switchable features *
      *             currently held on file. This window displays      *
      *             those features held on file which are however     *
      *             inactive.                                         *
      *             The user may enquire on these features (why they  *
      *             are inactive); enter passwords for them and       *
      *             define them on SCSARSPD (core) and SCSARZPD       *
      *             (non-core switchable features file).              *
      *                                                               *
      *  Called By: SC3010M - Switchable features maintenance         *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CGP002             Date 03Sep03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CSC010  *CREATE    Date 24May99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CGP002 - Global Processing.                                  *
      *           - Rename SCCSECPD to GP file.                       *
      *  CSC010 - Inactive switchable features look up window         *
      *                                                               *
      *****************************************************************
     FScsardl0  IF   E           K DISK
      * switchable features on file                                   *
     FSc0431#0  CF   E             WorkStn INFDS(Infds)
      * subfile display of inactive features                          *
     F                                     SFILE(Csfl:Crrn)
     FScsarjl1  IF   E           K DISK
     FScpasspd  IF   E           K DISK    INFSR(*PSSR)                         CSC010
     F                                     USROPN
     F*Sccsecl1*IF***E           K DISK    INFSR(*PSSR)                                CSC010 CGP002
     FGpcsecl1  IF   E           K DISK    INFSR(*PSSR)                                       CGP002
     F                                     USROPN
      * All core and non-core switchable features                     *
      /EJECT
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      *
      ** Array containing Copyright statement
      *
      /SPACE 3
     D Dsfdy         E DS                  EXTNAME(Dsfdy)                       CSC010
     D Scsard        E DS                  EXTNAME(Scsardpd)                    CSC010
     D INFDS           DS
     D Key                   369    369
     D PagRrn                378    379B 0
      *
      ** Data Area giving Installation Control Details
      *
     D PSDS           SDS
      *
      ** Program Status Data Structure - gives Job/Workstation name and
      ** User ID
      *
     D  ##PGM            *PROC
     D  JOB                  244    253
     D  WSID                 244    246
     D  USER                 254    263
     D  PARMS            *PARMS
      *
      * Named hexadecimal constants for function keys
      *
     D F03             C                   CONST(X'33')
     D F05             C                   CONST(X'35')
     D F12             C                   CONST(X'3C')
     D PageDn          C                   CONST(X'F5')
     D Crrn            S              5  0
     D Wcrrn           S                   Like(Crrn)
     D O#Sarn          S                   Like(SFNUM)
     D WNsfnum         S                   Like(Nsfnum)
 
      * Count of inactive features
     D Inactives       S              3  0
 
      * Total number of inactive features
     D TotInact        S              3  0
 
      * Active/Inactive flag
     D ActFlag         S              8
 
      * Password on?
     D PassOn          S              1
 
      * Return code
     D @Return         S              7
      *
      ** Output parameter O#Sarn is selected Feature Number
      *
     C     *Entry        Plist
     C                   Parm                    @Return
     C                   Parm                    O#Sarn
     C                   Parm                    PassOn
      *
      ** Set up copyright parameter
      *
     C                   MoveA     Cpy@          Cpy2@            80
      *
      ** Count inactive features if called from SC3010M
      *
     C     pparm         plist                                                                 CSC01
     C                   Parm      *BLANKS       @Rtcd             7                           CSC01
     C                   Parm      '*VERIFY'     @Optn             7                           CSC01
     C                   Parm                    @Sard             6                           CSC01
     C     scsard        Parm      scsard        dsfdy                                         CSC01
 
     C                   Exsr      @Main
 
     C*
     C* Main Subroutine
     C* ---------------
     C*
     C     @Main         Begsr
     C                   Eval      Inactives = 0
      *
      ** Position file at beginning for initial read
      ** in case of SHARE(*YES) on open, or in case previous call
      ** to program returned without LR on.
     C     *Loval        Setll     SCSardl0                           54
     C                   If        *In54
     C                   Exsr      @NoData
     C                   Eval      *In50 = *on
     C                   Endif
      *
      ** Reset Crrn (key to subfile CSFL) in case previous call to
      ** program returned with LR set to *ON.
      *
     C                   Reset                   Crrn
     C                   Write     CsflCmd
     C                   Dou       Key=F03 or
     C                             Key=F12
      *
      ** Fill subfile.
      *
     C                   Exsr      @Load
      *
      ** Check for existing subfile records to condition SFLDSP
      *
     C                   If        Crrn > 0
     C                   Eval      *IN81 = *on
     C                   Else
     C                   Eval      *In81 = *off
     C                   Endif
      *
      ** Display selection window.
      *  ------------------------
     C                   Dou       Key=F03 or
     C                             Key=F12
     C                   If        *In50=*on
     C                   Write     #msgctl
     C                   Write     CsflCmd
     C                   EndIf
     C                   Exfmt     CsflCtl
     C                   Eval      Sfnum = *blanks
     C                   Eval      Sfsard= *blanks
     C                   Eval      Selio = *blanks
     C                   Exsr      @ClearMess
      *
      ** Initialize SFLRCDNBR value with PagRrn value from I/O feedback
      ** area -- the lowest subfile RRN on the current subfile display.
      ** This ensures that the proper page is re-displayed.
      *
     C                   Eval      RcdNbr = PagRrn
      *
      ** Exit or Cancel request.
      *
     C                   If        Key = F03 or
     C                             Key = F12
     C                   Leave
     C                   Endif
 
      *
      ** F5 - Refresh screen
      *  -------------------
 
     C                   If        Key = F05
     C                   Exsr      @Rebuild
     C                   Endif
      *
      ** User requests change of position.
      *  --------------------------------
     C                   If        NSfnum <> *BLANKS
     C                   If        WNSfnum = Nsfnum
      * Don't leave loop ...!
     C                   Else
     C                   Eval      WNSfnum = Nsfnum
     C                   Exsr      @Repos
     C                   Leave
     C                   Endif
     C                   Endif
      *
      ** Page down
      *  ---------
     C                   If        Key = PageDn
     C                   Leave
     C                   Endif
      *
      ** user has blanked out positioner field - rebuild
      ** -----------------------------------------------
 
     C                   If        NSfnum = *blanks and
     C                             WNSfnum <> *blanks
     C                   Exsr      @Rebuild
     C                   Endif
      *
      ** Check if the user made a selection.
      *
     C                   ReadC     Csfl                                   98
     C                   Dow       *In98 = *off
      *
      ** If the user made a selection a variable was passed initialize
      ** the output variable with the user selection
 
      *
      * Enquire
      * -------
     C                   If        Selio = 'E'
     C                   If        Parms>*Zero
     C                   Eval      O#Sarn=Sfnum
     C                   Eval      Selio = *blanks
     C                   Update    CSfl
     C                   Endif
     C                   Exsr      @WhyInact
     C                   Endif
     C
      * Password
      * --------
     C                   If        Selio = 'P'
     C                   If        Parms>*Zero
     C                   Exsr      @PassEnt
     C                   EndIf
     C                   Endif
     C
      * Define non-core feature
      * -----------------------
     C                   If        Selio = '1'
     C                   If        Parms>*Zero
     C                   Exsr      @Defnoncor
     C                   EndIf
     C                   Endif
     C
     C                   ReadC     Csfl                                   98
     C                   Enddo
     C                   Enddo
     C                   Enddo
     C
      *
      ** If there all features are active, return a message.
      *
     C                   If        TotInact = 0
     C                   Eval      @Return='ALLACT'
     C                   EndIf
     C
     C                   Exsr      @Exit
     C                   EndSr
     C
     C*
     C* Exit program
     C* ------------
     C
     C     @Exit         Begsr
     C                   CLOSE     SCSardl0
     C                   Eval      *INLR =*On
     C                   Return
     C                   EndSr
     C*
     C*
     C* Reposition subfile for 'Position To' entry
     C* ------------------------------------------
     C*
     C     @Repos        BegSr
      *
      ** Reset subfile relative record number
      *
     C                   Reset                   Crrn
      *
      ** Clear subfile
      *
     C                   Eval      *IN80 = '1'
     C                   Write     CsflCtl
     C                   Eval      *IN80 = '0'
      *
      ** Position file by partial entry NSfnum in display file
      *
     C                   Eval      Absarn=NSfnum
     C     Absarn        Setll     SCSardl0                           54
     C                   Endsr
     C*
     C* Load subfile records
     C* --------------------
 
     C     @Load         Begsr
     C                   Read      SCSardl0                               82
     C                   Dow       *in82=*off
     C                   Call      'AOSARDR0'
     C                   Parm      *Blanks       @Rtrncde          7
     C                   Parm      '*VERIFY'     @Optn             7
     C                   Parm                    Absarn            6
     C                   Eval      ActFlag= *blanks
     C*
     C** Set up a flag to distinguish active from inactive features
     C*
     C                   If        @Rtrncde = *Blanks
     C                   Eval      ActFlag= 'Active'
     C                   Else
     C                   Eval      ActFlag= 'Inactive'
     C                   Eval      TotInact=TotInact + 1
     C                   EndIf
     C*
     C* If the PASSWD feature has not been switched on, all non-core
     C* switchable features on SCSARDPD will appear inactive.
     C* This code prevents this:
     C*
     C                   If        PassOn  = 'N' and
     C                             ActFlag = 'Inactive'
     C     AbSarn        Chain     SCSARJL1                           75
     C                   If        AxMntb <> 'C'
     C                   Eval      ActFlag = 'Active  '
     C                   Eval      TotInact=TotInact - 1
     C                   EndIf
     C                   EndIf
     C*
     C** If the feature is inactive, display it
     C*
     C                   If        ActFlag= 'Inactive'
     C                   Eval      Inactives = Inactives + 1
     C                   Eval      Crrn = Crrn+1
     C                   Clear                   Selio
     C                   Eval      Selio = *blanks
     C                   Eval      SfNum = Absarn
     C                   Eval      SfSard = Absard
     C                   Write     Csfl
 
     C                   EndIf
 
     C                   If        *in82=*on
     C                   Leave
     C                   Endif
 
     C                   Read      SCSardl0                               82
 
     C                   If        Inactives = 5
     C                   Leave
     C                   EndIf
     C                   EndDo
     C*
     C** To ensure a new subfile is displayed RCDNBR=SFRCDNBR
     C*
     C                   Eval      RcdNbr = Crrn
     C                   If        Inactives=0
     C                             and Key <> '5'
     C                   Exsr      @NoData
     C                   Eval      *In50 = *on
     C                   EndIf
     C                   Reset                   Inactives
     C                   EndSr
 
 
     C* Initialisation subroutine
     C* -------------------------
 
     C     *Inzsr        Begsr
     C                   Eval      Crrn=0
     C                   Endsr
 
     C*
     C* Clear Messages
     C* --------------
 
     C     @ClearMess    Begsr
     C                   Call      'Y2CLMSC'
     C                   Parm      'SC0431W0'    Zapgmq           10
     C                   Parm      '*SAME'       Zapgrl            5
     C                   Endsr
 
     C*
     C* No Data message
     C* ---------------
 
     C     @NoData       Begsr
     C*
     C* If there is no entry on the file - error
     C*
     C                   Eval      Zamsid = 'Y2U0008'
     C                   Eval      Zamsgf = 'Y2USRMSG'
     C                   Exsr      @Zasnms
     C                   Endsr
 
     C*
     C* Send message
     C* ------------
 
     C     @Zasnms       Begsr
     C                   If        Zapgmq = *blanks
     C                   Eval      zapgmq = 'SC0431W0'
     C                   end
     C                   Call      'Y2SNMGC'
     C                   Parm                    zapgmq           10
     C                   parm                    zapgrl            5
     C                   parm                    zamsid            7
     C                   parm                    zamsgf           10
     C                   parm                    zamsda          132
     C                   parm                    zamstp            7
     C                   Endsr
 
     C*
     C* 'E' option (Enquire) - why inactive
     C* -----------------------------------
 
     C     @WhyInact     Begsr
     C*
     C* If  sfnum does not equal blanks, a switchable feature
     C* has been selected. Attempt to diagnose why feature is
     C* currently inactive.
     C*
     C**********         Open      SCCSECL1                                                   CGP002
     C*****sfnum         Chain     SCCSECD0                           73                      CGP002
     C**********         Close     SCCSECL1                                                   CGP002
     C                   Open      GPCSECL1                                                   CGP002
     C     sfnum         Chain     GPCSECD0                           73                      CGP002
     C                   Close     GPCSECL1                                                   CGP002
     C*
     C* If there is no entry on delivered passwords file - error
     C*
     C                   If        *In73
     C                   Eval      Zamsid = 'CBM0240'
     C                   Eval      Zamsgf = 'CBUSRMSG'
     C                   Eval      Zamsda = sfnum
     C                   Exsr      @Zasnms
     C                   End
     C                   Open      SCPASSPD
     C     sfnum         Chain     SCPASSPD                           74
     C                   Close     SCPASSPD
     C                   If        *In74
     C*
     C* If there is no entry on passwords file - error
     C*
     C                   Eval      Zamsid = 'CBM0241'
     C                   Eval      Zamsgf = 'CBUSRMSG'
     C                   Eval      Zamsda = sfnum
     C                   Exsr      @Zasnms
     C                   End
     C                   If        *In73 = *off and
     C                             *In74 = *off
     C                   Eval      @SARD = sfnum
     C                   Call      'AOSARDR0'    pparm
     C                   If        @Rtcd = '*NRF'
     C                   Eval       Zamsid = 'CBM0242'
     C                   Eval       Zamsda = sfnum
     C                   Eval      Zamsgf = 'CBUSRMSG'
     C                   Exsr      @Zasnms
     C                   Endif
     C                   Endif
     C                   Eval      *In50 = *on
     C                   Endsr
     C
 
     C*
     C* F5 - Rebuild subfile
     C* --------------------
 
     C     @Rebuild      Begsr
     C                   Eval      *In80 = *on
     C                   Write     CsflCtl
     C                   Eval      *In80 = *off
     C                   Eval      WNsfnum= *blanks
     C                   Exsr      @Main
     C                   Endsr
     C
 
     C*
     C* 'P' - Password option
     C* ---------------------
 
     C*
     C** User wants to enter password for feature
     C*
     C     @PassEnt      Begsr
     C*
     C** Call dependency checking program
     C*
     C                   Call      'SC3010X'
     C                   Parm                    PasRtn            7
     C                   Parm      'I'           ActCde            1
     C                   Parm                    Sfnum
     C                   Parm                    Allow             1
     C*
     C** If dependency checking program disallows switching on of feature...
     C*
     C                   If        Allow <> 'Y'
     C                   Eval      *In50 = *on
     C                   Eval      Zamsid = 'CBM0229'
     C                   Eval      Zamsgf = 'CBUSRMSG'
     C                   Eval      Zamsda = sfnum
     C                   Exsr      @Zasnms
     C*
     C** dependency checking OK so call the window program
     C** and prompt for the password.
     C*
     C                   Else
     C                   Call      'SC0430W0'
     C                   Parm                    PasRtn
     C                   Parm                    Keyp              6
     C                   Parm                    Sfnum
     C                   If        PasRtn = *blanks
     C                   Exsr      @ClearMess
     C*
     C** display message that switchable feature inserted successfully
     C*
     C                   Eval      *In50 = *on
     C                   Eval      Zamsid = 'CBM0230'
     C                   Eval      Zamsgf = 'CBUSRMSG'
     C                   Eval      Zamsda = sfnum
     C                   Exsr      @Zasnms
     C                   Endif
     C                   Endif
     C                   Update    Csfl
     C                   Write     #msgctl
     C                   Write     CsflCmd
     C                   Endsr
 
     C*
     C* '1' - Define non-core feature
     C* -----------------------------
 
     C     @Defnoncor    Begsr
     C     Sfnum         Chain     SCSARJL1                           75
     C                   If        Axmntb <> 'C'
     C                   Call      'SCC4200'
     C                   Parm                    Sfnum
     C                   Parm                    Sfsard
     C                   Parm                    Pass
     C                   Parm                    RtnCde            7
     C                   If        RtnCde = *Blanks
     C                   Eval      *In50 = *on
     C                   Eval      Zamsid = 'CBM0248'
     C                   Eval      Zamsgf = 'CBUSRMSG'
     C                   Eval      Zamsda = sfnum
     C                   Exsr      @Zasnms
     C                   Endif
     C                   Else
     C                   Eval      *In50 = *on
     C                   Eval      Zamsid = 'CBM0247'
     C                   Eval      Zamsgf = 'CBUSRMSG'
     C                   Eval      Zamsda = sfnum
     C                   Exsr      @Zasnms
     C                   Endif
     C                   Update    Csfl
     C                   Write     #msgctl
     C                   Write     CsflCmd
     C                   Endsr
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C     @RUN          IFEQ      *BLANK
     C                   MOVE      'Y'           @RUN              1
     C                   DUMP
     C                   END
     C                   SETON                                        U7U8LR
     C                   RETURN
     C                   ENDSR
**  CPY@
(c) Finastra International Limited 2001
