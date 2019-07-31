     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Statmts Prod. Requests - Display')
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  RPGLE/SESTPRDSP - Statement Production Requests - Display    *
      *                                                               *
      *  Function:  This module displays the Statement Prod. Request  *
      *             Details maintenance screen                        *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. CSD102             Date 08Jan19               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSE040  *CREATE    Date 14Mar03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD102 - Password Length Extension (Recompile)               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSE040 - Securities Statement Processing                     *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

     FSESTPRDDF CF   E             WORKSTN

      ** Table of field numbers and names
     FZAFLDNPD  IT   F   15        DISK    INFSR(*PSSR)

      *****************************************************************
      *                                                               *
      * ID F  C  H  L    FUNCTION OF INDICATORS                       *
      *                                                               *
      *       01  Insert Mode                                         *
      *       02  Amend Mode                                          *
      *       03  Delete Mode                                         *
      *       04  Enquire Mode                                        *
      *       05  Authorise Mode                                      *
      *     10-31 Field Error - highlight screen fields               *
      *       68  Protect Key Fields                                  *
      *       70  Protect Other Detail Fields                         *
      *       71  Enable Function Key - F5                            *
      *       72  Enable Function Key - F10                           *
      *       73  Enable Function Key - F24                           *
      *       80  *On if Multi-Branching                              *
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

     D @EI             S              1    DIM(22)
     D @Z0             S              1    DIM(22) CTDATA PERRCD(22)

     D StPRScnIFld   E DS                  EXTNAME(SESTPR1PD)
      ** SESTPR Transaction Details in screen format

     D StPRScnOFld   E DS                  EXTNAME(SESTPR2PD)
      ** SESTPR Output only Screen Fields

     D StPROkFlags   E DS                  EXTNAME(SEESTPRPD)
      ** SESTPR Transaction Details OK indicators

     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for Bank Details

     D DSFDY         E DS                  EXTNAME(DSFDY)
      **  Short DS for access programs

     D DSSDY         E DS                  EXTNAME(DSSDY)
      **  Long DS for access programs

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

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
      ** Sets the default cursor location
      *
     C                   SELECT
     C                   WHEN      @EdtKeyFld = 'Y'
     C                   EVAL      F0CROW = 7
     C                   EVAL      F0CCOL = 26
      *
     C                   WHEN      @EdtOthFld = 'Y'
     C                   EVAL      F0CROW = 8
     C                   EVAL      F0CCOL = 26
      *
     C                   OTHER
     C                   EVAL      F0CROW = 0
     C                   EVAL      F0CCOL = 0
     C                   ENDSL
      *
      ** Move 'OK' flags into array (for checking)
      *
     C                   MOVEA     StPROkFlags   @EI
      *
      ** Set screen error indicators according to status of 'OK' flags
      ** If any error exist, the cursor location fields are set to 0,
      ** to allow the first active DSPATR(PC) to work
      *
     C                   Z-ADD     1             C                 2 0
     C                   Z-ADD     10            E                 2 0
      *
     C                   DOU       C > 22
      *
     C                   IF        @EI(C) = 'N' or
     C                             @EI(C) = 'W'
     C                   MOVEL     '1'           *IN(E)
     C                   EVAL      F0CROW = 0
     C                   EVAL      F0CCOL = 0
     C                   ENDIF
      *
     C                   ADD       1             C
     C                   ADD       1             E
     C                   ENDDO
      *
      ** The following /COPY line includes processing for the error and
      ** warning messages.
     D/COPY ZACPYSRC,MSGHNDDSP1
      *
      ** SCREEN SETUP
      ** Processing mode
      *                                                               >><<==
     C     DDACTN        COMP      'I'                                    01
     C     DDACTN        COMP      'A'                                    02
     C     DDACTN        COMP      'D'                                    03
     C     DDACTN        COMP      'E'                                    04
     C     DDACTN        COMP      'X'                                    05
      *
      ** Key fields protection
      *                                                               >><<==
     C     @EdtKeyFld    COMP      'Y'                                6868
      *
      ** Detail fields protection
      *                                                               >><<==
     C     @EdtOthFld    COMP      'Y'                                7070
      *
      ** Enable/Disable Function Keys
      *                                                               >><<==
     C     @EINKE        COMP      'Y'                                    71    F5
     C     @EINKJ        COMP      'Y'                                    72    F10
     C     @EINKY        COMP      'Y'                                    73    F24
      *
      ** SCREEN WRITE/READ: Message subfile control and keys+details formats
      *
     C                   WRITE     SESTPRDCM
     C                   WRITE     SESTPRDF0
      *
      ** Read keys+details screen if write only not requested
      *
     C                   IF        WriteOnly <> 'Y'
     C                   READ      SESTPRDF0                              99
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
     C                   EVAL      @INKY = *INKY
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** The following /COPY line includes the ProcMsgs subroutine
      ** to process error and warning messages.
      *****************************************************************
     D/COPY ZACPYSRC,MSGHNDDSP2
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
      ** SESTPR Input/Output Fields in Screen Format
     C                   PARM                    StPRScnIFld
      ** SESTPR Output Only Fields in Screen Format
     C                   PARM                    StPRScnOFld
      ** SESTPR Error Indicator Flags
     C                   PARM                    StPROkFlags
      ** Editing of Key Fields (Y/N)
     C                   PARM                    @EdtKeyFld        1
      ** Editing of Other Fields (Y/N)
     C                   PARM                    @EdtOthFld        1
      ** Write Only Indicator (Y/N)
     C                   PARM                    WriteOnly         1
      ** Errors
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      ** Warnings
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
      ** Enables Function Keys (Y/N)
     C                   PARM                    @EINKE            1            F5
     C                   PARM                    @EINKJ            1            F10
     C                   PARM                    @EINKY            1            F24
      *
      ** OUTPUT PARAMETERS:
      ** Used Function Keys (1/0)
     C                   PARM                    @INKC             1            F3
     C                   PARM                    @INKE             1            F5
     C                   PARM                    @INKJ             1            F10
     C                   PARM                    @INKL             1            F12
     C                   PARM                    @INKY             1            F24
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
      *
      ** Multi-Branching Indicator
      *                                                               >><<==
     C     BJSBRC        COMP      *Blanks                                80
      *
      ** Initialise the fixed parameters for ZAMSGHNDLE.
      *
     C                   EVAL      ModuleID     = 'SE'
     C                   EVAL      APRPRLOCN    = 'S'
     C                   EVAL      APCNFVALFO   = 'N'
     C                   EVAL      APRespMode   = 'S'
      *
      ** Set up the production request reference and action code
      ** to be used by the message handler
      ** Doesn't matter, as messages are sent to the screen
      *
     C                   EVAL      TranRef = 'Not used'
     C                   EVAL      ActionCode = '?'
      *
      ** Set up the prime and secondary message files for
      ** finding message IDs.
      *
     C                   EVAL      #MsgFile     = 'SEUSRMSG'
     C                   EVAL      MsgFArray(1) = 'DRSMM'
     C                   EVAL      MsgFArray(2) = 'MEMSG'
      *
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
(c) Finastra International Limited 2003
**CTDATA @Z0
0000000000000000000000
