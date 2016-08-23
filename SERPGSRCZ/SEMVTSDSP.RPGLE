     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Movements Status - Display')                  *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  RPGLE/SEMVTSDSP - Movements Status - Display                 *
      *                                                               *
      *  Function:  This module displays the Movements Status         *
      *             Transaction Details maintenance screen            *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      *  Last Amend No. AR325346           Date 21May10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSE039   *CREATE   Date 10Feb03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR325346 - DVP/RVP should not appear                         *
      *  CSE039 - Automatic Settlement of Trades                      *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FSEMVTSDDF CF   E             WORKSTN
 
      ** Table of field numbers and names
     FZAFLDNPD  IT   F   15        DISK    INFSR(*pssr)
 
      *****************************************************************
      *                                                               *
      * ID F  C  H  L    FUNCTION OF INDICATORS                       *
      *                                                               *
      *       01  Insert Mode                                         *
      *       02  Amend Mode                                          *
      *       03  Delete Mode                                         *
      *       04  Enquire Mode                                        *
      *     10-21 Field Error - highlight screen fields               *
      *       68  Protect Key Fields                                  *
      *       69  Protect Detail Fields When Origin <> 'Manual'       *
      *       70  Protect Other Detail Fields                         *
      *       71  Enable Function Key - F5                            *
      *       72  Enable Function Key - F10                           *
      *       73  Enable Function Key - F22                           *
      *       97  *On or *Off = SFLEND on Message Subfile             *
      *       99  Multi Purpose                                       *
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **---------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **---------------------------------------------------------------
 
      **---------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **---------------------------------------------------------------
 
      **---------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
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
 
     D @EI             S              1    DIM(12)
     D @Z0             S              1    DIM(12) CTDATA PERRCD(12)
 
      ** SEMVTS Transaction Details in screen format
     D APITrnDets    E DS                  EXTNAME(SEMVTS1PD)
 
      ** SEMVTS Output only Screen Fields
     D OScrnFlds     E DS                  EXTNAME(SEMVTS2PD)
 
      ** SEMVTS Transaction Details OK indicators
     D OKTrnDets     E DS                  EXTNAME(SEEMVTSPD)
 
      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      **  Short DS for access programs
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      **  Long DS for access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** External DS for switchable features                                                AR325346
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                AR325346
                                                                                            AR325346
      ** Split up the narrative field into screen fields
     D SplitNarr       DS                  BASED(Pointer1)
     D   DDNR01                      63A
     D   DDNR02                      63A
     D   DDNR03                      63A
     D   DDNR04                      63A
     D   DDNR05                      63A
     D   DDNR06                      63A
     D   DDNR07                      63A
     D   DDNR08                      63A
     D   DDNR09                      63A
     D   DDNR10                      63A
     D   DDNR11                      63A
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Pointer to the adress of the complete narrative
     D Pointer1        S               *   INZ(%Addr(DDNARR))
 
      ** Dummy definition of APITrnDets as input parameter, in order to
      ** have APITrnDets being part of the data storage of this module,
      ** to give a valid address for Pointer1
     D DummyTrnDet     S                   LIKE(APITrnDets)
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--- Start of Main processing -------------------------------+
      ** ¦ Initial processing is performed automatically: the *INZSR  ¦
      ** ¦ subroutine is executed at program activation.              ¦
      ** +------------------------------------------------------------+
      *
      ** Main processing
      *
     C                   EXSR      MAIN
      *
      ** Return
      *
     C                   IF        @INKC = '1'
     C                   SETON                                        LR
     C                   ENDIF
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      * MAIN - MAIN processing
      *****************************************************************
     C     MAIN          BEGSR
      *
      ** Move 'OK' flags into array (for checking)
      *
     C                   MOVEA     OKTrnDets     @EI
      *
      ** Set screen error indicators according to status of 'OK' flags
      *
     C                   Z-ADD     1             C                 2 0
     C                   Z-ADD     10            E                 2 0
      *
     C                   DOU       C > 12
      *
     C                   IF        @EI(C) = 'N' or
     C                             @EI(C) = 'W'
     C                   MOVEL     '1'           *IN(E)
     C                   ENDIF
      *
     C                   ADD       1             C
     C                   ADD       1             E
     C                   ENDDO
 
      **---------------------------------------------------------------
      ** The following /COPY line includes processing for the error and
      ** warning messages.
     D/COPY ZACPYSRC,MSGHNDDSP1
      **---------------------------------------------------------------
 
      ** SCREEN SETUP
      ** Processing mode
      *                                                               >><<==
     C     DDACTN        COMP      'I'                                    01
     C     DDACTN        COMP      'A'                                    02
     C     DDACTN        COMP      'D'                                    03
     C     DDACTN        COMP      'E'                                    04
      *
      ** Key fields protection
      *                                                               >><<==
     C     DDACTN        COMP      'I'                                6868
      *
     C                   IF        CallerCode = '*RPR'
     C                   SETON                                        68
     C                   ENDIF
      *
      ** Detail fields protection if movement origine isn't 'Manual'
      *                                                               >><<==
     C     DDINOR        COMP      'MANUAL'                           6969
      *
      ** All detail fields protection if Enquire or Delete
      *
     C                   IF        DDACTN = 'E' OR DDACTN = 'D'
     C                   SETON                                        6970
     C                   ELSE
     C                   SETOFF                                       70
     C                   ENDIF
      *
      ** Enable/Disable Function Keys
      *                                                               >><<==
     C     @EINKE        COMP      'Y'                                    71    F5
     C     @EINKJ        COMP      'Y'                                    72    F10
     C     @EINKW        COMP      'Y'                                    73    F22
      *
      ** SCREEN WRITE/READ: Message subfile control and keys+details formats
      *
     C                   WRITE     SEMVTSDCM
     C                   WRITE     SEMVTSDF0
      *
      ** Read keys+details screen if write only not requested
      *
     C                   IF        WriteOnly <> 'Y'
     C                   READ      SEMVTSDF0                              99
     C                   ENDIF
      *
      ** Set screen error indicators off
      *
     C                   MOVEA     @Z0           *IN(10)
      *
      ** Set return keys
      *
     C                   EVAL      @INKC = *INKC
     C                   EVAL      @INKE = *INKE
     C                   EVAL      @INKJ = *INKJ
     C                   EVAL      @INKL = *INKL
     C                   EVAL      @INKW = *INKW
      *
     C                   ENDSR
 
      **---------------------------------------------------------------
      ** The following /COPY line includes the ProcMsgs subroutine
      ** to process error and warning messages.
     D/COPY ZACPYSRC,MSGHNDDSP2
      **---------------------------------------------------------------
 
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - INITIAL PROCESSING
      *****************************************************************
     C     *INZSR        BEGSR
      *
      ** Parameters
      *
     C     *ENTRY        PLIST
      *
      ** INPUT PARAMETERS:
      ** Return code
     C                   PARM                    RetCodeIn
      ** Calling Module Code (*SIN or *RPR)
     C                   PARM                    CallerCode        4
      ** Transaction Details in screen format
     C     APITrnDets    PARM      APITrnDets    DummyTrnDet
      ** Output only Screen Fields
     C                   PARM                    OScrnFlds
      ** Transaction Details OK indicators
     C                   PARM                    OKTrnDets
      ** Write only indicator
     C                   PARM                    WriteOnly         1
      ** Errors
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      ** Warnings
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
      ** Enabled Function Keys
     C                   PARM                    @EINKE            1            F5
     C                   PARM                    @EINKJ            1            F10
     C                   PARM                    @EINKW            1            F22
      *
      ** OUTPUT PARAMETERS:
      ** Function Keys
     C                   PARM                    @INKC             1            F3
     C                   PARM                    @INKE             1            F5
     C                   PARM                    @INKJ             1            F10
     C                   PARM                    @INKL             1            F12
     C                   PARM                    @INKW             1            F22
      *
      ** Program, module and procedure names for database error processing.
      *
     C                   EVAL      DBPgm  = PSProcPgm
     C                   EVAL      DBMod  = PSProcMod
     C                   EVAL      DBProc = PSProcName
      *
      ** Program message queue name
      *
     C                   EVAL      MSPGMQ = '*'
      *
      ** Access Bank Details
      *
     C                   CALLB     'AOBANKR0'
     C                   PARM      *Blanks       @RtCD
     C                   PARM      '*FIRST '     @Optn
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Database error
      *
     C                   IF        @RtCd <> *Blanks
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   Z-ADD     901           DBASE
     C                   MOVEL     @Optn         DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
      *                                                                                     AR325346
      ** Access switchable features file - CSE041                                           AR325346
      *                                                                                     AR325346
     C                   CALLB     'AOSARDR0'                                               AR325346
     C                   PARM      *BLANKS       @RTCD                                      AR325346
     C                   PARM      '*VERIFY'     @OPTN                                      AR325346
     C                   PARM      'CSE041'      @SARD                                      AR325346
     C     SCSARD        PARM      SCSARD        DSFDY                                      AR325346
      *                                                                                     AR325346
      ** Set screen conditioning indicator                                                  AR325346
      *                                                                                     AR325346
     C     @RTCD         IFEQ      *BLANKS                                                  AR325346
     C                   EVAL      *IN90 = '0'                                              AR325346
     C                   ELSE                                                               AR325346
     C                   EVAL      *IN90 = '1'                                              AR325346
     C                   ENDIF                                                              AR325346
      *
      ** Initialise the fixed parameters for ZAMSGHNDLE.
      *
     C                   EVAL      ModuleID     = 'SE'
     C                   EVAL      APRPRLOCN    = 'S'
     C                   EVAL      APCNFVALFO   = 'N'
     C                   EVAL      APRespMode   = 'S'
      *
      ** Set up the movement reference and action code
      ** to be used by the message handler
      ** Doesn't matter, as messages are sent to screen
      *
     C                   EVAL      TranRef = 'Nice weather, isn''t it?'
     C                   EVAL      ActionCode = '?'
      *
      ** Set up the prime and secondary message files for
      ** finding message IDs.
      *
     C                   EVAL      #MsgFile     = 'SEUSRMSG'
     C                   EVAL      MsgFArray(1) = 'DRSMM'
     C                   EVAL      MsgFArray(2) = 'MEMSG'
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
**CTDATA CPY@
(c) Misys International Banking Systems Ltd. 2003
**CTDATA @Z0
000000000000
