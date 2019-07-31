     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas DL Dealing Fees display')
      *****************************************************************
      *                                                               *
      *  Midas - Dealing Module                                       *
      *                                                               *
      *  DLDLFEDSP - Dealing Fees Details Display                     *
      *                                                               *
      *  Function:  This module displays the dealing Fess Transaction *
      *             Details maintenance screen                        *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *  Last Amend No. CSD102             Date 08Jan19               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CAS009  *CREATE    Date 04May04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD102 - Password Length Extension (Recompile)               *
      *  MD046248 - Finastra Rebranding                               *
      *  CAS009 - Effective Interest Rate/Amortised Cost Accounting   *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FDLDLFEDDDFCF   E             WORKSTN
 
      ** Table of field numbers and names
     FZAFLDNPD  IT   F   15        DISK    INFSR(*PSSR)
 
      *****************************************************************
      *                                                               *
      * ID F  C  H  L    FUNCTION OF INDICATORS                       *
      *                                                               *
      *     10-69 Field Error - highlight screen fields               *
      *       70  Display only                                        *
      *       71  Enable Function Key - F10                           *
      *       72  Toggle F3 footer text                               *
      *       73  Position cursor on first field if no error          *
      *       99  Read error                                          *
      ********************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
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
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the definitions of the error
      ** arrays, including the named constant giving the size of
      ** the arrays.  Note that it uses #MsgID and *MsgData, and so requires
      ** STD_D_SPEC.
     D/COPY ZACPYSRC,FVAL_ARRAY
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,APICTLARR
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for fields
      ** required by the message handler.
     D/COPY ZACPYSRC,MSGHNDDCL
      **--------------------------------------------------------------------------------------------
 
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
 
     D @EI             S              1    DIM(60)
     D @Z0             S              1    DIM(50) CTDATA PERRCD(50)
     D @NAR            S             49    DIM(3) CTDATA PERRCD(1)
 
      ** Dealing Fees Transaction Details in screen format
     D NwDlScnFmt    E DS                  EXTNAME(DLDLFEPD)
 
      ** Dealing Fees Transaction Details OK indicators
     D OKNwDlScnFmt  E DS                  EXTNAME(DLEDLFEPD)
 
      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      **  Short DS for access programs
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** condition availability of F7 (previous)
     D @EINKG          S              1A
      ** condition availability of F8 (next)
     D @EINKH          S              1A
      ** condition availability of F10 (delete)
     D @EINKJ          S              1A
      ** condition availability of F11 (authorise)
     D @EINKK          S              1A
      ** condition availability of F12 (cancel)
     D @EINKL          S              1A
      ** condition availability of F14 (settlements)
     D @EINKN          S              1A
      ** condition availability of F15 (browse)
     D @EINKP          S              1A
 
     D DDSTAT          S             16A
     D DDFOTX          S             49A
     D C               S              2  0
     D E               S              2  0
     D @INKC           S              1
     D @INKG           S              1
     D @INKH           S              1
     D @INKJ           S              1
     D @INKK           S              1
     D @INKL           S              1
     D @INKN           S              1
     D @INKP           S              1
     D @EKYFD          S              1
     D @EDTFD          S              1
     D PRTCD           S              7
     D POPTN           S              7
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the             ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
     C                   EXSR      MAIN
 
      ** Return
 
     C                   IF        @INKC = '1'
     C                   SETON                                        LR
     C                   ENDIF
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      * MAIN - MAIN processing
      *****************************************************************
     C     MAIN          BEGSR
 
      ** Move 'OK' flags into array (for checking)
 
     C                   MOVEA     OKNwDlScnFmt  @EI
     C                   EVAL      *IN10 = *OFF
 
      ** Set screen error indicators according to status of 'OK' flags
 
     C                   Z-ADD     1             C
     C                   Z-ADD     12            E
      *
     C                   DOU       C > 60
     C                   IF        @EI(C) = 'N' or
     C                             @EI(C) = 'W'
     C                   MOVEL     '1'           *IN(E)
     C                   ENDIF
     C                   ADD       1             C
     C                   ADD       1             E
     C                   ENDDO
 
      ** Set up the customer reference to be used by the message handler
     C                   EVAL      TranRef = DDDLNO
     C                   EVAL      ActionCode = DDACTN
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes processing for the error and
      ** warning messages.
     C/COPY ZACPYSRC,MSGHNDDSP1
      **--------------------------------------------------------------------------------------------
 
      ** Enable all fields
 
     C     @EDTFD        COMP      'Y'                                7070
 
      ** Enable Function Keys
     C     @EINKG        COMP      'Y'                                    71
     C     @EINKH        COMP      'Y'                                    72
     C     @EINKJ        COMP      'Y'                                    73
     C     @EINKK        COMP      'Y'                                    74
     C     @EINKN        COMP      'Y'                                    75
     C     @EINKP        COMP      'Y'                                    76
 
      ** Hide the Status field when action code is blank
     C     DDACTN        IFNE      *BLANK
     C     DDSTAT        ANDNE     *BLANKS
     C                   EVAL      *IN10 = *ON
     C                   ENDIF
 
      ** Position cursor on first field if no errors
 
     C     'N'           LOOKUP    @EI                                    69
     C     @EINKJ        IFEQ      'Y'
     C                   EVAL      DDFOTX = @NAR(2)
     C                   ELSE
     C     @EINKK        IFEQ      'Y'
     C                   EVAL      DDFOTX = @NAR(3)
     C                   ELSE
     C                   EVAL      DDFOTX = *BLANK
     C                   ENDIF
     C                   ENDIF
 
      * Write message subfile, Securities Clients Details and footer screen
     C                   TIME                    DDTIME
     C                   WRITE     DLDLFES0
     C                   WRITE     DLDLFEF1
 
     C                   EXFMT     DLDLFED1
 
      ** Set screen error indicators off
     C                   MOVEA     @Z0           *IN(10)
 
      ** Set return keys
     C                   EVAL      @INKC = *INKC
     C                   EVAL      @INKG = *INKG
     C                   EVAL      @INKH = *INKH
     C                   EVAL      @INKJ = *INKJ
     C                   EVAL      @INKK = *INKK
     C                   EVAL      @INKL = *INKL
     C                   EVAL      @INKN = *INKN
     C                   EVAL      @INKP = *INKP
 
     C                   ENDSR
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the ProcMsgs subroutine
      ** to process error and warning messages.
     C/COPY ZACPYSRC,MSGHNDDSP2
      **--------------------------------------------------------------------------------------------
      ********************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - INITIAL PROCESSING
      *****************************************************************
     C     *INZSR        BEGSR
 
      ** Parameters
 
     C     *ENTRY        PLIST
 
      ** INPUT PARAMETERS :
 
      ** Return code
     C                   PARM                    RetCodeIn
 
      ** Transaction Details in screen format
     C                   PARM                    NwDlScnFmt
 
      ** Transaction Details OK indicators
     C                   PARM                    OKNwDlScnFmt
 
      ** Errors
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
 
      ** Warning
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
 
      ** Enabled Key & Detail Fields
 
     C                   PARM                    @EKYFD
     C                   PARM                    @EDTFD
 
      ** Enabled Function Keys
      ** F7 - Read Previous
      ** F8 - Read Next
      ** F10 - Delete
      ** F11 - Authorise
      ** F14 - Settlement Details
      ** F15 - Browse
     C                   PARM                    @EINKG
     C                   PARM                    @EINKH
     C                   PARM                    @EINKJ
     C                   PARM                    @EINKK
     C                   PARM                    @EINKN
     C                   PARM                    @EINKP
      ** Status
     C                   PARM                    DDSTAT
 
      ** OUTPUT PARAMETERS :
 
      ** Function Keys
     C                   PARM                    @INKC
     C                   PARM                    @INKG
     C                   PARM                    @INKH
     C                   PARM                    @INKJ
     C                   PARM                    @INKK
     C                   PARM                    @INKL
     C                   PARM                    @INKN
     C                   PARM                    @INKP
      *
      ** Initialize program name
      *
     C                   EVAL      DBPGM = 'DLDLFEDSP'
      *
      ** Move user and workstation ID to screen fields.
      *
     C                   EVAL      DDUSER = PsUser
     C                   EVAL      DDWID  = PsJobName
 
     C                   EVAL      *IN97 = *ON
     C                   EVAL      DDPGMQ = '*'
 
      ** Access Bank Details
 
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR '     PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDBANK        PARM      SDBANK        DSFDY
 
      * Database error
 
     C                   IF        PRTCD <> *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     '901'         DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line sets up the fixed data for SD *DSP
      ** functions for the message handler, ZAMSGHNDLE.
     C/COPY SDCPYSRC,MSGHNDDATA
      **--------------------------------------------------------------------------------------------
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRERR - EXCEPTION ERRORS                                      *
      *                                                               *
      *****************************************************************
     C     SRERR         BEGSR
      *
     C                   EVAL      DBPGM = 'DLDLFEDSP'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   DUMP
      *
      **  Terminte the program
      *
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2004
** @Z0
00000000000000000000000000000000000000000000000000
** @NAR
Fee Sequence number    successfully inserted.
F10 = CONFIRM DELETE
F11 = CONFIRM AUTHORISATION
