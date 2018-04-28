     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SC Data Replication Configurator Display')
      *****************************************************************
      *                                                               *
      *  Midas - System Control Module                                *
      *                                                               *
      *  SCRPCNDSP - Data Replication Configurator Display            *
      *                                                               *
      *  Function:  This module displays the Data Replication         *
      *             Details maintenance screen                        *
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
 
      ** Data Replication Configurator Display File
     FSCRPCNDSDFCF   E             WORKSTN
 
      ** Table of field numbers and names
     FZAFLDNPD  IT   F   15        DISK    INFSR(*pssr)
 
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
      *                                                               *
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
 
      ** Data Replicaiton Details in screen format
     D NwRepScnFmt   E DS                  EXTNAME(SCRPCNPD)
 
      ** Data Replication Details OK indicators
     D OKFlags       E DS                  EXTNAME(SCERPCNPD)
 
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
 
     D WCtr1           S              2  0
     D WCtr2           S              2  0
     D PEKYFD          S              1
     D PEDTFD          S              1
     D PWriteOnly      S              1
     D PEINKG          S              1
     D PEINKH          S              1
     D PEINKJ          S              1
     D PEINKP          S              1
 
     D PINKC           S              1
     D PINKG           S              1
     D PINKH           S              1
     D PINKJ           S              1
     D PINKL           S              1
     D PINKP           S              1
     D PConfig         S              1
 
     D PRetCode        S              7
     D POption         S              7
 
     D I               S              2  0
     D PMsgID          S             10
 
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
      *
      ** Main processing
      *
     C                   EXSR      SRMain
 
      ** Return
 
     C                   IF        PINKC = '1'
     C                   EVAL      *INLR = *ON
     C                   ENDIF
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRMAIN - MAIN processing                                     *
      *                                                               *
      *  Called by: Main Processing                                   *
      *                                                               *
      *  Calls:                                                       *
      *                                                               *
      *****************************************************************
     C     SRMain        BEGSR
 
      ** Move 'OK' flags into array (for checking)
 
     C                   MOVEA     OKFlags       WErrInd
 
      ** Set screen error indicators according to status of 'OK' Flags
 
     C                   Z-ADD     1             WCtr1
     C                   Z-ADD     10            WCtr2
 
     C                   DOU       WCtr1 > 60
     C                   IF        WErrInd(WCtr1) = 'N' or
     C                             WErrInd(WCtr1) = 'W'
     C                   EVAL      *IN(WCtr2) = *On
     C                   ENDIF
     C                   EVAL      WCtr1 = WCtr1 + 1
     C                   EVAL      WCtr2 = WCtr2 + 1
     C                   ENDDO
 
     C                   EVAL      I = 1
     C                   DOW       I < 76 and MsgIdArr(I) <> *Blanks
     C                   EVAL      PMsgId = MsgIdArr(I)
     C                   CALL      'ZA0340'
     C                   PARM                    #MsgFile
     C                   PARM                    PMsgId           10
     C                   EVAL      I = I + 1
     C                   ENDDO
 
     C                   EVAL      I = 1
     C                   DOW       I < 76 and WMsgIdArr(I) <> *Blanks
     C                   EVAL      PMsgId = WMsgIdArr(I)
     C                   CALL      'ZA0340'
     C                   PARM                    #MsgFile
     C                   PARM                    PMsgId
     C                   EVAL      I = I + 1
     C                   ENDDO
 
      ** Protect all fields
 
     C                   EVAL      *IN80 = *Off
     C                   MOVEA     '0000'        *IN(01)
 
      ** Enable detail fields (All fields except action code and physical file)
 
     C                   IF        PEDTFD <> 'Y'
     C                   EVAL      *IN80 = *On
     C                   ENDIF
 
      ** Enable Function Key - F10 Confirm
 
     C                   IF        PEINKJ = 'Y'
     C                   EVAL      *IN04 = *On
     C                   ENDIF
 
      ** Enable Function Key = F7 and F8
 
     C                   IF        PEINKG = 'Y'
     C                   EVAL      *IN02 = *On
     C                   ENDIF
 
     C                   IF        PEINKP = 'Y'
     C                   EVAL      *IN03 = *On
     C                   ENDIF
 
      ** Write message subfile, Details and footer screen
 
     C                   TIME                    #0TIME
     C                   WRITE     SCRPCNDSF0
     C                   WRITE     SCRPCNDSF2
     C                   WRITE     SCRPCNDSC0
     C                   WRITE     SCRPCNDSF1
 
     C                   IF        PWriteOnly = 'N'
     C                   READ      SCRPCNDSF1                             89
     C                   ENDIF
 
      ** Clear message subfile
 
     C                   CALL      'ZA0250'
 
      ** Set screen error indicators off
 
     C                   MOVEA     WInzErr       *IN(10)
 
      ** Set return keys
 
     C                   EVAL      PINKC = *INKC
     C                   EVAL      PINKG = *INKG
     C                   EVAL      PINKH = *INKH
     C                   EVAL      PINKJ = *INKJ
     C                   EVAL      PINKL = *INKL
     C                   EVAL      PINKP = *INKP
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *  *INZSR - INITIAL PROCESSING                                  *
      *****************************************************************
     C     *INZSR        BEGSR
 
      ** Parameters
 
     C     *ENTRY        PLIST
 
      ** INPUT PARAMETERS :
      ** Return code
 
     C                   PARM                    RetCodeIn
 
      ** Data Replication detials in screen format
 
     C                   PARM                    NwRepScnFmt
 
      ** Data Replication details OK indicators
 
     C                   PARM                    OKFlags
 
      ** Errors
 
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
 
      ** Warning
 
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
 
      ** Enabled key & Detail fields
 
     C                   PARM                    PEKYFD
     C                   PARM                    PEDTFD
 
      ** Enabled Function Keys
      ** F7  - Previous
      ** F8  - Next
      ** F10 - Delete
      ** F15 - Select
 
     C                   PARM                    PEINKG
     C                   PARM                    PEINKH
     C                   PARM                    PEINKJ
     C                   PARM                    PEINKP
 
      ** Write Only
 
     C                   PARM                    PWriteOnly
 
      ** Called by Data Replication Configurator
 
     C                   PARM                    PConfig
 
      ** OUTPUT PARAMETERS :
      ** Function Keys
 
     C                   PARM                    PINKC
     C                   PARM                    PINKG
     C                   PARM                    PINKH
     C                   PARM                    PINKJ
     C                   PARM                    PINKL
     C                   PARM                    PINKP
 
      ** Access Bank Details
 
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR '     PRetCode
     C                   PARM      '*FIRST '     POption
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database error
 
     C                   IF        PRetCode <> *Blanks
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE  = 901
     C                   EVAL      DBKEY  = POption
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Initialize program name
 
     C                   EVAL      DBPGM = 'SCRPCNDSP'
 
      ** Move user and workstation ID to screen fields.
 
     C                   EVAL      #0USER = PsUser
     C                   EVAL      #0WID  = PsJobName
 
     C                   EVAL      *IN97 = *ON
     C                   EVAL      #0PGMQ = '*'
     C                   EVAL      #0DATE = BJMRDT
 
     C                   EVAL      #MsgFile = 'UTMSGF'
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRERR - EXCEPTION ERRORS                                      *
      *                                                               *
      *****************************************************************
     C     SRERR         BEGSR
 
     C                   EVAL      DBPGM = 'SCRPCNDSP'
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
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
** WInzErr
000000000000000000000000000000000000000000000000000000000000
