     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Additional Customer Details Display')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  SDACUD2DP - Additional Customer Details Enquiry              *
      *                                                               *
      *  Function:  This module displays the SDACUSPD Transaction     *
      *             Details second screen.                            *
      *                                                               *
      *  (c) Finastra International Limited 2005                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD029  *CREATE    Date 22Aug05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD029 - Customer Details Additional Fields                  *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Midas SD Additional Customer Details Display File
     FSDACUD2DDFCF   E             WORKSTN
 
      ** Table of field numbers and names
     FZAFLDNPD  IT   F   15        DISK    INFSR(*pssr)
 
      *****************************************************************
      *                                                               *
      * ID F  C  H  L    FUNCTION OF INDICATORS                       *
      *                                                               *
      *     10-69 Field Error - highlight screen fields               *
      *       70  Display condition                                   *
      *       71  Display condition                                   *
      *       72  Display condition                                   *
      *       73  Position cursor on first field if no error          *
      *       79  Display Condition                                   *
      *       83  Enable/disable function for F7 F8                   *
      *       99  Read error                                          *
      *****************************************************************
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
      /COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
      /COPY ZACPYSRC,STDDECLARE
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
      /COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
      /COPY ZACPYSRC,ERR_ARRAYS
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the definitions of the error
      ** arrays, including the named constant giving the size of
      ** the arrays.  Note that it uses #MsgID and *MsgData, and so requires
      ** STD_D_SPEC.
      /COPY ZACPYSRC,FVAL_ARRAY
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
      /COPY ZACPYSRC,APICTLARR
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for fields
      ** required by the message handler.
      /COPY ZACPYSRC,MSGHNDDCL
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
     D @Z0             S              1    DIM(60) CTDATA PERRCD(60)
 
      ** SDACUSPD Transaction Details in screen format
     D TrnDets       E DS                  EXTNAME(SDACUDPD)
 
      ** SDACUDPD Transaction Details OK indicators
     D OKTrnDets     E DS                  EXTNAME(SDEACUDPD)
 
      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      **  Short DS for access programs
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      **  Long DS for access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Parameter for Access Object
     D PRtcd           S              7A
     D POptn           S              7A
 
      ** Parameter of *Entry
     D SDCUSDcall      S              1A
     D PEKYFD          S              1A
     D PEDTFD          S              1A
     D PEINKG          S              1A
     D PINKC           S              1A
     D PINKG           S              1A
     D PINKH           S              1A
     D PINKL           S              1A
 
      ** Value is 'Y' if its called from SDACUDENQ
      ** Value is ' ' if its called from SDACUDSIN
      ** Value is 'R' if its called from SDACUDRPR
     D PSDACUDENQ      S              1A
 
      ** Switchable feature CGL032
     D PCGL032         S              1A
     D PEPRTD          S              1A
 
      ** Index for error indicators
     D C               S              2P 0
     D E               S              2P 0
 
      ** Other Variables
     D WDate           S              4A
 
     D SVALSCRN        DS           250
     D DDDS01                  1     25
     D DDDS02                 26     50
     D DDDS03                 51     75
     D DDDS04                 76    100
     D DDDS05                101    125
     D DDDS06                126    150
     D DDDS07                151    175
     D DDDS08                176    200
     D DDDS09                201    225
     D DDDS10                226    250
     I*DACUDD0
     I*                                         DDF001                  50
     I*                                         DDF002                  51
     I*                                         DDF003                  52
     I*                                         DDF004                  53
     I*                                         DDF005                  54
     I*                                         DDF006                  55
     I*                                         DDF007                  56
     I*                                         DDF008                  57
     I*                                         DDF009                  58
     I*                                         DDF010                  59
 
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
 
      ** Main processing
 
     C                   EXSR      SRMain
 
      ** Return
 
     C                   EVAL      *INLR = *ON
 
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRMain - Main Processing
      *****************************************************************
     C     SRMain        BEGSR
 
      ** Move 'OK' Flags into array (For Checking)
 
     C                   MOVEA     OKTrnDets     @EI
 
      ** Set Screen Error Indicators according to Status of 'OK' Flags
 
     C                   Z-ADD     1             C
     C                   Z-ADD     10            E
 
     C                   DOU       C > 60
     C                   IF        @EI(C) = 'N' or
     C                             @EI(C) = 'W'
     C                   MOVEL     '1'           *IN(E)
     C                   END
     C                   ADD       1             C
     C                   ADD       1             E
     C                   ENDDO
 
 
      ** Set up the customer reference to be used by the message handler
 
     C                   EVAL      TranRef = DDCUST
     C                   EVAL      ActionCode = DDACTN
 
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes processing for the error and
      ** warning messages.
      /COPY ZACPYSRC,MSGHNDDSP1
      **--------------------------------------------------------------------------------------------
 
      ** Protect all fields
 
     C                   EVAL      *IN70 = *ON
 
      ** Enable Detail Fields (All Fields except Action Code & Deal Number)
 
     C                   IF        PEDTFD = 'Y'
     C                   EVAL      *IN70 = *OFF
     C                   ENDIF
 
 
      ** Position cursor on first field if no errors
 
     C     'N'           LOOKUP    @EI                                    73
 
      ** Write message subfile, Securities Clients Details and footer screen
 
     C                   TIME                    DDTIME
     C                   WRITE     SDACUD2S0
     C                   WRITE     SDACUD2D1
     C                   WRITE     SDACUD2F1
 
     C                   READ      SDACUD2D1                              99
 
      ** Set screen error indicators off
 
     C                   MOVEA     @Z0           *IN(10)
 
      ** Set return keys
 
     C                   EVAL      PINKC = *INKC
     C                   EVAL      PINKL = *INKL
 
     C                   ENDSR
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the ProcMsgs subroutine
      ** to process error and warning messages.
      /COPY ZACPYSRC,MSGHNDDSP2
      **--------------------------------------------------------------------------------------------
 
      ********************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Initial Processing
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
 
      ** INPUT PARAMETERS :
      ** Return code
     C                   PARM                    RetCodeIn
 
      ** Transaction Details in screen format
     C                   PARM                    TrnDets
 
      ** Screen details retrieved from AOSVALPD
     C                   PARM                    SVALSCRN
 
      ** Transaction Details OK indicators
     C                   PARM                    OKTrnDets
 
 
      ** ERRORS
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
 
      ** WARNING
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
 
      ** Enabled Key & Detail Fields
     C                   PARM                    PEKYFD
     C                   PARM                    PEDTFD
     C                   PARM                    PEINKG
 
      ** OUTPUT PARAMETERS :
      ** Function Keys
     C                   PARM                    PINKC
     C                   PARM                    PINKL
 
      ** Initialize program name
 
     C                   EVAL      DBPGM = 'SDACUD2DP'
 
      ** Move user and workstation ID to screen fields.
 
     C                   EVAL      DDUSER = PsUser
     C                   EVAL      DDWID  = PsJobName
 
     C                   EVAL      *IN94 = *ON
     C                   EVAL      DDPGMQ = '*'
 
      ** Access Bank Details
 
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR '     PRtcd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database error
 
     C                   IF        PRtcd <> *BLANKS
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE  = 901
     C                   EVAL      DBKEY  = POptn
     C                   EXSR      *PSSR
     C                   ENDIF
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line sets up the fixed data for SD *DSP
      ** functions for the message handler, ZAMSGHNDLE.
      /COPY SDCPYSRC,MSGHNDDATA
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
 
     C                   EVAL      DBPGM = 'SDACUD2DP'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   DUMP
 
      **  Terminte the program
 
     C                   RETURN
 
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
** CTDATA @CPY
Finastra International Limited 2005
** CTDATA @Z0
000000000000000000000000000000000000000000000000000000000000
