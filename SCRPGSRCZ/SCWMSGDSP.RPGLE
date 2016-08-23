     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SC 24x7 Processing Day Msg Mnt Display')
      *****************************************************************
      *                                                               *
      *  Midas - System Control Module                                *
      *                                                               *
      *  SCWMSGDSP - 24x7 Processing Day Message Maintenance Details  *
      *              Display                                          *
      *                                                               *
      *  Function:  This module displays the 24x7 Processing Day      *
      *             Details maintenance screen.                       *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4.01 -------------------------------------------*
      *  Last Amend No. CSC011  *CREATE    Date 18Sep01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSC011 - 24x7 Midas Availability                             *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Processing Day Msg Mnt Display File
     FSCWMSGDPDFCF   E             WORKSTN INFSR(*PSSR)
 
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
      *       77  Display Condition - Autocharge Option, Tax Code fld *
      *       78  Display Condition - Safe Custody fields             *
      *       79  Display Condition - Charges Groups (S01496)         *
      *     80-89 Reference and Part./Non-Part. fields display        *
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
 
     D WErrInd         S              1    DIM(60)
     D WInzErr         S              1    DIM(60) CTDATA PERRCD(60)
 
      ** Record Details in screen format
     D RecDets         DS
     D   WMsgType              1      1
     D   WMsgTime              2      6
     D   WLangCode             7      8
     D   WMsgText              9    508
 
      ** OK Indicators
     D OKFlags         DS
     D   OKSELE                1      1
     D   OKMTIM                2      2
     D   OKLANG                3      3
     D   OKMTXT                4      4
 
      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      **  Short DS for access programs
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D PINKC           S              1
     D PINKJ           S              1
     D PINKL           S              1
     D PEINKJ          S              1
     D PEKYFD          S              1
     D PEDTFD          S              1
     D PRetCode        S              7
     D POption         S              7
     D PSelect         S              1
     D PMTypTxt        S             78
 
     D WMType          S              1
     D WCtr1           S              2  0
     D WCtr2           S              2  0
 
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
 
      ** Initialisation
 
     C                   EXSR      SRInit
 
      ** Main processing
 
     C                   EXSR      SRMain
 
      ** Return
 
     C                   IF        PINKC = '1'
     C                   EVAL      *INLR = *ON
     C                   ENDIF
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRMain - MAIN processing                                     *
      *                                                               *
      *  Called by: Main                                              *
      *                                                               *
      *  Calls    : SCC0250                                           *
      *                                                               *
      *****************************************************************
 
     C     SRMain        BEGSR
 
      ** Move 'OK' Flags into array (for checking)
 
     C                   MOVEA     OKFlags       WErrInd
 
      ** Set screen error indicators according to status of 'OK' Flags
 
     C                   Z-ADD     1             WCtr1
     C                   Z-ADD     10            WCtr2
 
     C                   DOU       WCtr1 > 60
     C                   IF        WErrInd(WCtr1) = 'N' or
     C                             WErrInd(WCtr1) = 'W'
     C                   MOVEL     '1'           *IN(WCtr2)
     C                   ENDIF
     C                   ADD       1             WCtr1
     C                   ADD       1             WCtr2
     C                   ENDDO
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes processing for the error and
      ** warning messages.
     C/COPY ZACPYSRC,MSGHNDDSP1
      **--------------------------------------------------------------------------------------------
 
      ** Protect all fields
 
     C                   EVAL      *IN70 = *OFF
 
      ** Enable Detail Fields (All fields except Message Time & Language Code)
 
     C                   IF        PEDTFD = 'Y'
     C                   EVAL      *IN70 = '1'
     C                   ENDIF
 
      ** Enable Function Key - F10 Confirm Delete
 
     C                   IF        PEINKJ = 'Y'
     C                   EVAL      *IN71 = '1'
     C                   ENDIF
 
      ** Display Main Screen.
 
     C                   IF        PEKYFD = 'N' AND PEDTFD = 'N'
     C                   EVAL      *IN81 = '1'
     C                   EVAL      #1SELE = PSelect
 
     C                   ELSE
     C                   EVAL      #2MTYP = PMTypTxt
     C                   EVAL      #2MINS = %SUBST(WMsgTime:1:3)
     C                   EVAL      #2SECS = %SUBST(WMsgTime:4:2)
     C                   EVAL      #2LANG = WLangCode
     C                   EVAL      #2MTXT = WMsgText
 
      ** Display Amendment Screen.
 
     C                   SELECT
     C                   WHEN      PEKYFD = 'N' AND PEDTFD = 'Y'
     C                   EVAL      *IN82 = '1'
 
      ** Display Deletion Screen.
 
     C                   WHEN      PEKYFD = 'Y' AND PEDTFD = 'Y' AND
     C                             PEINKJ = 'Y'
     C                   EVAL      *IN72 = '1'
     C                   EVAL      *IN83 = '1'
     C                   EVAL      *IN84 = '1'
 
      ** Display Enquiry Screen.
 
     C                   WHEN      PEKYFD = 'Y' AND PEDTFD = 'Y'
     C                   EVAL      *IN84 = '1'
 
      ** Display Insertion Screen.
 
     C                   WHEN      PEKYFD = 'Y' AND PEDTFD = 'N'
     C                   EVAL      *IN85 = '1'
     C                   ENDSL
 
     C                   EVAL      WMType = WMsgType
 
      ** Don't display Message Time if Message Type is O, F, or X.
 
     C                   IF        WMType = 'O' OR WMType = 'F' OR WMType = 'X'
     C                   EVAL      *IN86 = '1'
     C                   EVAL      #2MINS = *BLANKS
     C                   EVAL      #2SECS = *BLANKS
     C                   ENDIF
     C                   ENDIF
 
      ** Write message subfile, record details and footer screen.
 
     C                   WRITE     SCWMSGDPF0
     C                   WRITE     SCWMSGDPF3
     C                   WRITE     SCWMSGDPC0
 
     C                   IF        PEKYFD = 'N' AND PEDTFD = 'N'
     C                   EXFMT     SCWMSGDPF1
     C                   EVAL      PSelect = #1SELE
 
     C                   ELSE
     C                   EXFMT     SCWMSGDPF2
     C                   EVAL      WMsgTime = #2MINS + #2SECS
     C                   EVAL      WLangCode = #2LANG
     C                   EVAL      WMsgText = #2MTXT
     C                   ENDIF
 
      ** Clear message subfile.
 
     C                   CALL      'SCC0250'
 
      ** Set screen error indicators off
 
     C                   MOVEA     WInzErr       *IN(10)
 
      ** Set return keys
 
     C                   EVAL      PINKC = *INKC
     C                   EVAL      PINKJ = *INKJ
     C                   EVAL      PINKL = *INKL
 
     C                   ENDSR
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the ProcMsgs subroutine
      ** to process error and warning messages.
     C/COPY ZACPYSRC,MSGHNDDSP2
      **--------------------------------------------------------------------------------------------
 
      ********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRINIT - Initialisation                                      *
      *                                                               *
      *  Called by: Main                                              *
      *                                                               *
      *  Calls    : SCC0250                                           *
      *                                                               *
      *****************************************************************
 
     C     SRINIT        BEGSR
 
     C                   CALL      'SCC0250'
     C                   EVAL      PINKC = '0'
     C                   EVAL      PINKJ = '0'
     C                   EVAL      PINKL = '0'
     C                   MOVEA     '000'         *IN(70)
     C                   MOVEA     '000000'      *IN(81)
     C                   MOVEA     WInzErr       *IN(10)
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - INITIAL PROCESSING
      *****************************************************************
 
     C     *INZSR        BEGSR
 
      ** Parameters
 
     C     *ENTRY        PLIST
 
      ** Input Parameters
      ** Return code
 
     C                   PARM                    RetCodeIn
 
      ** Message Type Text
 
     C                   PARM                    PMTypTxt
 
      ** Record Details in screen format
 
     C                   PARM                    RecDets
 
      ** Record Details OK indicators
 
     C                   PARM                    OKFlags
 
      ** Errors
 
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
 
      ** Warning
 
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
 
      * Enabled Key & Detail Fields
 
     C                   PARM                    PEKYFD
     C                   PARM                    PEDTFD
 
      ** Enabled Function Keys
      ** F10 - Confirm Delete
 
     C                   PARM                    PEINKJ
 
      ** Output Parameters
      ** Selection option in initial screen
 
     C                   PARM                    PSelect
 
      ** Function Keys
 
     C                   PARM                    PINKC
     C                   PARM                    PINKJ
     C                   PARM                    PINKL
 
      ** Access Bank Details
 
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR '     PRetCode
     C                   PARM      '*FIRST '     POption
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database error
 
     C                   IF        PRetCode <> *BLANKS
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE = 901
     C                   EVAL      DBKEY = POption
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Initialize program name
 
     C                   EVAL      DBPGM = 'SCWMSGDSP'
 
      ** Move user and workstation ID to screen fields.
 
     C                   EVAL      #0USER = PsUser
     C                   EVAL      #0WSID = PsJobName
     C                   EVAL      #0RUNA = BJMRDT
     C                   EVAL      #0PGMQ = PSProcName
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line sets up the fixed data for SD *DSP
      ** functions for the message handler, ZAMSGHNDLE.
     C/COPY SDCPYSRC,MSGHNDDATA
      **--------------------------------------------------------------------------------------------
 
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
** CPY@
(c) Misys International Banking Systems Ltd. 2001
** WInzErr
000000000000000000000000000000000000000000000000000000000000
