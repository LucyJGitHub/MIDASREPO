     H DEBUG
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Outgoing Payments Margins Info display')      *
      *****************************************************************
      *                                                               *
      *  Midas - API Funds Transfer Module                            *
      *                                                               *
      *  FTOPAY3DP - Outgoing Payments Margins Info Display           *
      *                                                               *
      *  Function:  This API module will serve as the screen display/ *
      *             input module of Margins Informations. This fields *
      *             were previously being displayed in FTOPAY3DP and  *
      *             validated by FTOPAY3VL but were moved here to act *
      *             as an additional information screen for outgoing  *
      *             maintenance when function 19 is pressed.          *
      *                                                               *
      *  Called By: FTOPAY1SN                                         *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. MD035776           Date 10Sep15               *
      *                 MD027047           Date 19Aug14               *
      *                 CFT120             Date 28Sep12               *
      *                 CSF011A            Date 28Nov11               *
      *                 CRE067             Date 05Oct10               *
      *                 CER059             Date 19Jul10               *
      *                 CER030             Date 09Jul08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 255711             Date 31Jul08               *
      *                 250600             Date 07Oct07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CFT032             Date 11Sep06               *
      *  Prev Amend No. CDL049             Date 06Jul06               *
      *                 CGL014             Date 20Oct03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CFT009             Date 15Nov00               *
      *                 CFT014  *CREATE    Date 25May00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD035776 - User need to press twice on input screen          *
      *           - Remove unsupported keywords of HATS from dspf     *
      *             (Recompile)                                       *
      *  MD027047 - Avoid HATS issue with redisplaying previous screen*
      *             on the stack. End program with SETON LR with no   *
      *             RETURN.                                           *
      *  CFT120 - FT IN/OP - Charges to DR of Account Currency        *
      *           (Recompile)                                         *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CRE067 - Midas Plus/Teller Interface via Bankfusion          *
      *           (Recompile)                                         *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER030 - Multicash German Feature                            *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  255711 - Field Ref rate does not record rate. (Recompiled)   *
      *  250600 - Recompiled for change in FTV@OPAYPD                 *
      *           to fix CFT032/CSW207 errors                         *
      *  CFT032 - Account Line in Field 50X in MT103 (Recompile)      *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CGL014 - Collaterals Processing (Recompile)                  *
      *  CFT009 - Funds Transfer Fees and Charges - recompile         *
      *  CFT014 - Straight-through Processing Phase 2 MT103           *
      *           Messages Generation for FT.                         *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     FFTOPAY5DF CF   E             WORKSTN INFDS(INFDS#)
 
      ** Table of field numbers and names
     FZAFLDNPD  IT   F   15        DISK    INFSR(*PSSR)
 
      *****************************************************************
      *                                                               *
      * ID F  C  H  L    FUNCTION OF INDICATORS                       *
      *                                                               *
      *     10-59 Field Error - highlight screen fields               *
      *                                                               *
      *       68  Position cursor on action code (if it is blank)     *
      *       77  Enable CF04, BIC DB+ Prompt                         *
      *       78  Enable CF16, BIC DB+ Search                         *
      *                                                               *
      *       96  Subfile control                                     *
      *       97  Subfile end                                         *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** Include the standard declares
     D/COPY ZACPYSRC,STDDECLARE
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
      **---------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
 
      **---------------------------------------------------------------
      ** The following /COPY line includes all the definitions of the error
      ** arrays, including the named constant giving the size of
      ** the arrays.  Note that it uses #MsgID and *MsgData, and so requires
      ** STD_D_SPEC.
     D/COPY ZACPYSRC,FVAL_ARRAY
      **---------------------------------------------------------------
 
      **---------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,APICTLARR
      **---------------------------------------------------------------
 
      **---------------------------------------------------------------
      ** The following /COPY line includes the definitions for fields
      ** required by the message handler.
     D/COPY ZACPYSRC,MSGHNDDCL
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
 
     D @Z0             S              1    DIM(60) CTDATA PERRCD(60)
 
     D @EI             S              1    DIM(60)
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for Bank details
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for Access Programs, short data structure
 
     D FTOPAY1       E DS                  EXTNAME(FTOPY1PD)
      ** Screen fields (Screen 1)
 
     D FTOPAY7       E DS                  EXTNAME(FTOPY7PD)
      ** Screen fields (Margin Info Screen)
 
     D FTOPAY7A      E DS                  EXTNAME(FTOPY7APD)                                 CER030
      *                                                                                       CER030
     D FTOPAY7B      E DS                  EXTNAME(FTOPY7BPD)                                 CER030
      *                                                                                       CER030
      ** DS for extended narrative files                                                      CER030
      *                                                                                       CER030
     D FTEOPY5       E DS                  EXTNAME(FTEOPY5PD)
      ** Error Indicators (Margin Info Screen)
 
     D Val@Fields    E DS                  EXTNAME(FTV@OPAYPD)
      ** Validation Work Fields
 
     D INFDS#        E DS                  EXTNAME(Y2I#DSP)
      ** Display file information data structure
 
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CER030
      *                                                                                       CER030
      ** External DS for SAR Details                                                          CER030
      *                                                                                       CER030
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)                                  CER030
      *                                                                                       CER030
      ** Externally described DS for Midas Modules details                                    CER030
      *                                                                                       CER030
     D  FuncText       DS            33
     D  F3text                 1      9
     D  F5text                10     21
     D  F12text               22     33
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D #MSDTA          S            132
     D #MSTX1          S            132
     D #MSTX2          S            512
      *                                                                                       CER030
     D PRtcd           S              7A                                                      CER030
     D POptn           S              7A                                                      CER030
     D PSard           S              6A                                                      CER030
     D CER031          S              1A                                                      CER030
     D CER030          S              1A                                                      CER030
     D CFT003          S              1A                                                      CER030
     D CGL013          S              1A                                                      CER030
 
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
 
      ** Main processing
 
     C                   ExSr      SrMain
 
      ** Command F3 pressed, exit
 
     C**********         If        @INKC = *On                                              MD027047
     C                   Eval      *INLR = *On
     C**********         EndIf                                                              MD027047
 
     C**********         Return                                                             MD027047
 
      *****************************************************************
      /Title Sr/SrMain
      *****************************************************************
      *                                                               *
      * SR/SrMain    - Main processing                                *
      *                                                               *
      * Called By: Main Routine                                       *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SrMain        BegSr
 
      ** Move 'OK' flags into array for checking
 
     C                   MoveA     FTEOPY5       @EI
 
      ** Set screen error indicators according to status of 'OK' flags
 
     C                   Z-Add     1             C                 2 0
     C                   Z-Add     10            E                 2 0
 
     C                   DoU       C > 60
     C                   If        (@EI(C) = 'N') Or (@EI(C) = 'W')
     C                   Eval      *IN(E) = *On
     C                   EndIf
     C                   Eval      C = C + 1
     C                   Eval      E = E + 1
     C                   Enddo
 
      ** Set up the payment reference to be used by the message handler
 
     C                   Eval      TranRef = SPREF
     C                   Eval      ActionCode = SACTION
 
      **---------------------------------------------------------------
      ** The following /COPY line includes processing for the error and
      ** warning messages.
     C/COPY ZACPYSRC,MSGHNDDSP1
      **---------------------------------------------------------------
 
      ** Position cursor on action code if it is blank
 
     C     SAction       Comp      *BLANK                                 68
 
      ** Enable detail fields (all fields except action code & payment
      ** Reference
 
     C     @EDTFD        Comp      'Y'                                7070
 
      ** Set up function key footer text
 
     C                   Eval      SCCMDTXT = *Blanks
     C                   Eval      %SUBST(SCCMDTXT:1:9) = F3text
     C                   Eval      %SUBST(SCCMDTXT:22:12) = F12text
 
      ** Disable F5 key if detail fields not amendable,
 
     C                   If        *IN70 = True
     C                   Eval      *IN71 = False
     C                   Eval      %SUBST(SCCMDTXT:10:12) = *Blank
     C                   Else
     C                   Eval      *IN71 = True
     C                   Eval      %SUBST(SCCMDTXT:10:12) = F5text
     C                   EndIf
 
      *                                                                                       CER030
      ** Conditioning display of margin info fields                                           CER030
      *                                                                                       CER030
     C                   EVAL      *IN75 = *OFF                                               CER030
      *                                                                                       CER030
     C                   IF        BGN0ST = 'Y'                                               CER030
     C                   IF        (SPCCY = SSMCY)                                            CER030
     C                             AND (SMBSI = *BLANKS)                                      CER030
     C                             AND (SMSIG = *BLANKS)                                      CER030
     C                   EVAL      *IN75 = *OFF                                               CER030
     C                   ELSE                                                                 CER030
     C                   EVAL      *IN75 = *ON                                                CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C                   ENDIF                                                                CER030
      ** Write message subfile, details and footer screen
 
     C                   Time                    DDTime
     C                   Write     FTOPAY5S0
     C                   Write     FTOPAY5D1
     C                   Write     FTOPAY5F1
 
      ** Read details screen
 
     C                   If        WriteOnly <> 'Y'
     C                   Read      FTOPAY5D1                              01
     C                   EndIf
 
      ** Clear message subfile
 
     C                   Call      'ZA0250'
 
      ** Set screen error indicators off
 
     C                   MoveA     @Z0           *IN(10)
 
      ** Set return keys
 
     C                   Move      *INKC         @INKC
     C                   Move      *INKL         @INKL
     C                   Move      *INKE         @INKE
 
     C                   EndSr
 
      *****************************************************************
      /Title Sr/*InzSr
      *****************************************************************
      *                                                               *
      * SR/*InzSr     - Initial Processing                            *
      *                                                               *
      * Called By: Automatically executed when program starts         *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
 
     C     *InzSr        BegSr
 
      ** Receive input parameters
 
     C     *Entry        Plist
     C                   Parm                    RetCodeIn
     C                   PARM                    FTOPAY1
     C                   PARM                    FTOPAY7
      ** Parameters for extended narrative                                                    CER030
     C                   PARM                    FTOPAY7A                                     CER030
     C                   PARM                    FTOPAY7B                                     CER030
      *                                                                                       CER030
     C                   PARM                    DDSTS            24
     C                   PARM                    FTEOPY5
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    @EKYFD            1
     C                   PARM                    @EDTFD            1
     C                   PARM                    @INKC             1
     C                   PARM                    @INKL             1
     C                   PARM                    @INKE             1
     C                   PARM                    WriteOnly         1
     C                   PARM      @#RWCL        CursorLoc         5 0
     C                   PARM                    Val@Fields
 
      ** Initialise program name
 
     C                   Eval      DBPGM = 'FTOPAY5DP'
 
      ** Workstation ID
 
     C                   Eval      DDWID = PsJobName
 
      ** Access Bank Details via Access Object AOBANKR0
 
     C                   Call      'AOBANKR0'
     C                   Parm      *Blanks       @RTCD
     C                   Parm      '*FIRST '     @OPTN
     C     SDBANK        Parm      SDBANK        DSFDY
 
     C     @RTCD         IfNe      *BLANKS
     C                   MoveL     'SDBANKPD'    DBFILE
     C                   Z-Add     1             DBASE
     C                   MoveL     @Optn         DBKEY
     C                   Exsr      *PSSR
     C                   EndIf
 
      ** Retrieve the text for footer function keys using MEC1150
 
     C                   Call      'MEC1150'                            9090
     C                   Parm      'FTM2627'     #MSGID
     C                   Parm      'FTUSRMSG'    #MsgFile
     C                   Parm                    #MSDTA
     C                   Parm      *BLANKS       #MSTX1
     C                   Parm      *BLANKS       #MSTX2
 
     C                   Movel     #MSTX1        FuncText
 
      ** Message subfile control
 
     C                   Move      True          *IN97
     C                   Movel     '*'           DDPGMQ
 
      *                                                                                       CER030
      ** Check if CER031 is enabled                                                           CER030
      *                                                                                       CER030
     C                   EVAL      CER031 = 'N'                                               CER030
      *                                                                                       CER030
     C                   CALL      'AOSARDR0'                                                 CER030
     C                   PARM      *BLANKS       PRtcd                                        CER030
     C                   PARM      '*VERIFY'     POptn                                        CER030
     C                   PARM      'CER031'      PSard                                        CER030
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER030
      *                                                                                       CER030
     C                   IF        PRtcd = *BLANKS                                            CER030
     C                   EVAL      CER031 = 'Y'                                               CER030
     C                   EVAL      *IN73 = *ON                                                CER030
     C                   ELSE                                                                 CER030
      *                                                                                       CER030
     C                   IF        PRtcd <> '*NRF'                                            CER030
      *                                                                                       CER030
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER030
     C                   EVAL      DBASE = 002                                                CER030
     C                   EVAL      DBKEY = PSard                                              CER030
     C                   EXSR      *PSSR                                                      CER030
      *                                                                                       CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
      ** Check if CER030 is enabled                                                           CER030
      *                                                                                       CER030
     C                   EVAL      CER030 = 'N'                                               CER030
      *                                                                                       CER030
     C                   CALL      'AOSARDR0'                                                 CER030
     C                   PARM      *BLANKS       PRtcd                                        CER030
     C                   PARM      '*VERIFY'     POptn                                        CER030
     C                   PARM      'CER030'      PSard                                        CER030
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER030
      *                                                                                       CER030
     C                   IF        PRtcd = *BLANKS                                            CER030
     C                   EVAL      CER030 = 'Y'                                               CER030
     C                   ELSE                                                                 CER030
      *                                                                                       CER030
     C                   IF        PRtcd <> '*NRF'                                            CER030
      *                                                                                       CER030
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER030
     C                   EVAL      DBASE = 003                                                CER030
     C                   EVAL      DBKEY = PSard                                              CER030
     C                   EXSR      *PSSR                                                      CER030
      *                                                                                       CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
      ** Check if CFT003 is enabled                                                           CER030
      *                                                                                       CER030
     C                   EVAL      CFT003 = 'N'                                               CER030
      *                                                                                       CER030
     C                   CALL      'AOSARDR0'                                                 CER030
     C                   PARM      *BLANKS       PRtcd                                        CER030
     C                   PARM      '*VERIFY'     POptn                                        CER030
     C                   PARM      'CFT003'      PSard                                        CER030
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER030
      *                                                                                       CER030
     C                   IF        PRtcd = *BLANKS                                            CER030
     C                   EVAL      CFT003 = 'Y'                                               CER030
     C                   ELSE                                                                 CER030
      *                                                                                       CER030
     C                   IF        PRtcd <> '*NRF'                                            CER030
      *                                                                                       CER030
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER030
     C                   EVAL      DBASE = 004                                                CER030
     C                   EVAL      DBKEY = PSard                                              CER030
     C                   EXSR      *PSSR                                                      CER030
      *                                                                                       CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
      ** Check if CGL013 is enabled                                                           CER030
      *                                                                                       CER030
     C                   EVAL      CGL013 = 'N'                                               CER030
      *                                                                                       CER030
     C                   CALL      'AOSARDR0'                                                 CER030
     C                   PARM      *BLANKS       PRtcd                                        CER030
     C                   PARM      '*VERIFY'     POptn                                        CER030
     C                   PARM      'CGL013'      PSard                                        CER030
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER030
      *                                                                                       CER030
     C                   IF        PRtcd = *BLANKS                                            CER030
     C                   EVAL      CGL013 = 'Y'                                               CER030
     C                   ELSE                                                                 CER030
      *                                                                                       CER030
     C                   IF        PRtcd <> '*NRF'                                            CER030
      *                                                                                       CER030
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER030
     C                   EVAL      DBASE = 005                                                CER030
     C                   EVAL      DBKEY = PSard                                              CER030
     C                   EXSR      *PSSR                                                      CER030
      *                                                                                       CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C                   IF        CER030 = 'Y' OR CGL013 = 'Y'                               CER030
     C                   EVAL      *IN72  = *ON                                               CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C                   IF        CER031 = 'Y' AND CFT003 = 'Y'                              CER030
     C                   EVAL      *IN74  = *ON                                               CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
      ** Access Midas Modules details.                                                        CER030
      *                                                                                       CER030
     C                   CALLB     'AOMMODR0'                                                 CER030
     C                   PARM      *BLANKS       PRtcd                                        CER030
     C                   PARM      '*FIRST '     POptn                                        CER030
     C     SDMMOD        PARM      SDMMOD        DSFDY                                        CER030
      *                                                                                       CER030
      ** Database error.                                                                      CER030
      *                                                                                       CER030
     C                   IF        PRtcd <> *BLANKS                                           CER030
     C                   EVAL      DBFILE = 'SDMMODPD'                                        CER030
     C                   EVAL      DBASE = 006                                                CER030
     C                   EVAL      DBKEY = POptn                                              CER030
     C                   EXSR      *PSSR                                                      CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
      **---------------------------------------------------------------
      ** The following /COPY line sets up the fixed data for FT *DSP
      ** functions for the message handler, ZAMSGHNDLE.
     C/COPY FTCPYSRC,MSGHNDDATA
      **---------------------------------------------------------------
 
     C                   EndSr
 
      *****************************************************************
      /EJECT
      **---------------------------------------------------------------
      ** The following /COPY line includes the ProcMsgs subroutine
      ** to process error and warning messages.
     C/COPY ZACPYSRC,MSGHNDDSP2
      **---------------------------------------------------------------
      *****************************************************************
      /EJECT
      *****************************************************************
      ** Program, module and procedure names for database error processing.
      ** ==============================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2001
**  @Z0
000000000000000000000000000000000000000000000000000000000000
