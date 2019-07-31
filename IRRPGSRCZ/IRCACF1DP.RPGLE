     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas IR Caps/Collars/Floors Details')
      *****************************************************************
      *                                                               *
      *  Midas - FRA/IRS Module                                       *
      *                                                               *
      *  IRCACF1DP - Caps/Collars/Floors Details Display              *
      *                                                               *
      *  Function:  This module displays the Caps/Collars/Floors      *
      *             Transaction Details maintenance screen            *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. CSD102             Date 08Jan19               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CDL038             Date 10May05               *
      *                 BUG6472            Date 23Apr05               *
      *                 CDL028             Date 07Feb05               *
      *                 CGL029             Date 01Sep03               *
      *                 CAS005             Date 16Dec02               *
      *                 CAS004             Date 26Jun02               *
      *                 217684             Date 12May03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAP055  *CREATE    Date 13Mar02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD102 - Password Length Extension (Recompile)               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CDL038 - Extended Deal Sub Type                              *
      *  BUG6472- Added a sign field for short term rate (Recompile)  *
      *  CDL028 - Automatic Rate Interpolations (Recompile)           *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CAS005 - Enhancements to CAS001, CAS002 and CAS004           *
      *           (Recompile)                                         *
      *  CAS004 - Hedge Accounting Phase A (Recompile)                *
      *  217684 - Authorisation User Malfunction (Recompile).         *
      *  CAP055 - APIs for FRA/IRS Caps/Collars/Floors                *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Caps/Collars/Floors Details Screen
     FIRCACF1DF CF   E             WORKSTN INFSR(*PSSR)
 
      ** Confirmation Matching - Feedback Title from TRAM
     FCFFEEDL0  IF   E           K DISK    INFSR(*PSSR)
 
      ** Table of field numbers and names
     FZAFLDNPD  IT   F   15        DISK    INFSR(*PSSR)
 
      *****************************************************************
      *                                                               *
      *  Use of Indicators                                            *
      *                                                               *
      *       01  Work indicator                                      *
      *       08  Extended Deal Sub Type not installed                *                       CDL038
      *       09  Error in Class                                      *                       CDL038
      *     10-59 Field Error - highlight screen fields               *
      *       60  Deal Type is RP                                     *
      *       61  Deal Type is RR                                     *
      *       62  Deal Type is RF                                     *
      *       67  Display Confirmation Matching status                *
      *       70  Display only                                        *
      *       71  Enable Function Key - F7                            *
      *       72  Enable Funciton Key - F8                            *
      *       73  Enable Function Key - F10                           *
      *       74  Enable Function Key - F14                           *
      *       75  Enable Function Key - F15                           *
      *       76  Protect Ref Short Term Rate                         *
      *       77  Protect Rate Fix Days                               *
      *       78  Protect Tax Indicator                               *
      *       79  Protect Base Rate Code                              *
      *       80  Not multibranching                                  *
      *       81  Originating branch not used                         *
      *       82  Profit centres not used                             *
      *       83  CSW005 installed                                    *
      *       84  Protect Spread Field                                *
      *       85  Test Bit Indicator                                  *
      *       96  Subfile control                                     *
      *       97  Subfile end                                         *
      *       99  Read error                                          *
      *                                                               *
      ********************************************************************
      /EJECT
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
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
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
 
     D WZ0             S              1    DIM(60) CTDATA PERRCD(60)
     D WEI             S              1    DIM(60)
 
      ** Array for counterparty and broker fields narratives
     D CPBKTxt         S             17    DIM(2) PERRCD(1) CTDATA
 
      ** Array for counterparty and broker status codes/narratives
     D TAB1            S              2  0 DIM(16) PERRCD(1) CTDATA
     D TAB2            S             15    DIM(16) ALT(TAB1)
 
      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** External DS for General Ledger Details
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
 
      ** Exteranl DS for Switchable Feature Details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
 
      ** External DS for Midas Modules Details
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
 
      ** First DS for Access Programs, Short Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Caps/Collars/Floors Transaction Details in screen format
     D IRCACF        E DS                  EXTNAME(IRCACFPD)
 
      ** Current Deal in File Format
     D CrIRFilFmt    E DS                  EXTNAME(DEALSDG)
     D                                     PREFIX(RP)
 
      ** Caps/Collars/Floors Transaction Details OK indicators
     D IRECACF       E DS                  EXTNAME(IRECACFPD)
                                                                                              CGL029
     D DSSDY         E DS                  EXTNAME(DSSDY)                                     CGL029
 
      ** CFFEEDL0 key
     D  WCFKY          DS            16
     D  WTST1                  1      8
     D  WKEY1                  1      2
     D  WKEY2                  3      8
     D  WKEY3                  9     11
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Work variables
     D WTST2           S              8
     D CCF003          S              1
     D CIR006          S              1
     D CEU003          S              1
     D Cx              S              2P 0
     D Ex              S              2P 0
     D PRtcD           S              7
     D POption         S              7
     D PSard           S              6
 
      ** Function keys to activate
     D PEINKG          S              1A
     D PEINKH          S              1A
     D PEINKJ          S              1A
     D PEINKN          S              1A
     D PEINKP          S              1A
 
      ** Function keys activated
     D PINKC           S              1A
     D PINKG           S              1A
     D PINKH           S              1A
     D PINKJ           S              1A
     D PINKL           S              1A
     D PINKN           S              1A
     D PINKP           S              1A
 
      ** Work parameters
     D PEKyFld         S              1A
     D PEDtFld         S              1A
 
      ** work varibles to for retrieving text
     D WMsgDNb         S              7
     D WMsgNme         S             10
     D WMsgTxt         S             80
 
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
 
      **  Initial processing
 
     C                   EXSR      SRInitial
 
      **  Main processing
 
     C                   EXSR      SRProcess
 
      ** Return
 
     C                   IF        PINKC = *ON
     C                   EVAL      *INLR = *ON
     C                   ENDIF
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRInitial - Initial Processing                               *
      *                                                               *
      *****************************************************************
 
     C     SRInitial     BEGSR
 
      ** Condition Screen Title
 
     C                   MOVEA     '000'         *IN(60)
 
     C                   SELECT
 
     C                   WHEN      #0DTYP = 'RP'
     C                   MOVEA     '100'         *IN(60)
     C                   EVAL      WMsgDNb = 'MMM3006'
     C                   EXSR      SrRtvTxt
     C                   EVAL      #0TITL = WMsgTxt
 
     C                   WHEN      #0DTYP = 'RR'
     C                   MOVEA     '010'         *IN(60)
     C                   EVAL      WMsgDNb = 'MMM3007'
     C                   EXSR      SrRtvTxt
     C                   EVAL      #0TITL = WMsgTxt
 
     C                   WHEN      #0DTYP = 'RF'
     C                   MOVEA     '001'         *IN(60)
     C                   EVAL      WMsgDNb = 'MMM3008'
     C                   EXSR      SrRtvTxt
     C                   EVAL      #0TITL = WMsgTxt
 
     C                   ENDSL
 
      ** Initialize indicators
 
     C                   MOVEA     '0000'        *IN(76)
     C                   MOVEA     '00'          *IN(84)
 
      ** Protect fields during Amend
 
     C                   IF        #0ACCD = 'A'
 
      ** Spread Field
 
     C                   EVAL      *IN84 = *OFF
     C                   IF        RPUINFD = 0 and RPTINFD = 0
     C                   EVAL      *IN84 = *ON
     C                   ENDIF
 
     ** Rate Fix Days, Ref Short Term Rate Taxable Indicator
 
     C                   MOVEA     '1111'        *IN(76)
     C                   TESTB     '3'           RPTDSTI                  85
     C                   IF        *IN85 = *ON and RPVDAT < BJRDNB
     C                             or *IN85 = *OFF
     C                   EVAL      *IN76 = *OFF
     C                   ENDIF
 
     C                   IF        *IN85 = *OFF
     C                   EVAL      *IN77 = *OFF
     C                   ENDIF
 
     C                   IF        RPVDAT >= BJRDNB
     C                   EVAL      *IN78 = *OFF
     C                   IF        RPTBRTT > 0 and RPTINFD > 0
     C                             and RPTINFD <= RPVDAT
     C                             or RPUBRTT > 0 and RPUINFD > 0
     C                             and RPUINFD <= RPVDAT
     C                   EVAL      *IN79 = *OFF
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
 
     C                   IF        #0ACCD <> 'I' AND #0AVRM = 'Y'
     C                   EVAL      WMsgDNb = 'MMM9037'
     C                   EXSR      SrRtvTxt
     C                   EVAL      #0NARR = WMsgTxt
     C                   ELSE
     C                   EVAL      WMsgDNb = 'MMM9036'
     C                   EXSR      SrRtvTxt
     C                   EVAL      #0NARR = WMsgTxt
     C                   ENDIF
 
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrRtvTxt - Retrieve text                                     *
      *                                                               *
      *****************************************************************
 
     C     SrRtvTxt      BEGSR
 
     C                   CALL      'SDRTVTXT'
     C                   PARM                    WMsgDNb
     C                   PARM      'GBDRSMM'     WMsgNme
     C                   PARM      *BLANK        WMsgTxt
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRProcess - Process Details                                  *
      *                                                               *
      *****************************************************************
 
     C     SRProcess     BEGSR
 
      ** Move 'OK' Flags into Array for Checking
 
     C                   MOVEA     IRECACF       WEI
 
      ** Set Screen Error Indicators According to Status of 'OK' flags
 
     C                   Z-ADD     1             Cx
     C                   Z-ADD     10            Ex
 
     C                   DOU       Cx > 60
     C                   IF        WEI(Cx) = 'N' or WEI(Cx) = 'W'
     C                   EVAL      *IN(Ex) = *ON
     C                   ENDIF
 
     C                   EVAL      Cx = Cx + 1
     C                   EVAL      Ex = Ex + 1
     C                   ENDDO
                                                                                              CDL038
     C     OKCLAS        comp      'N'                                    09                  CDL038
                                                                                              CDL038
 
      ** The following /COPY line includes processing for the error and
      ** warning messages.
     D/COPY ZACPYSRC,MSGHNDDSP1
 
      ** Enable detail fields
 
     C                   IF        PEDtFld = 'Y'
     C                   EVAL      *IN70 = *OFF
     C                   ELSE
     C                   EVAL      *IN70 = *ON
     C                   ENDIF
 
      ** Enable CF07 (Previous)
 
     C                   IF        PEINKG = 'Y'
     C                   EVAL      *IN71 = *ON
     C                   ELSE
     C                   EVAL      *IN71 = *OFF
     C                   ENDIF
 
      ** Enable CF08 (Next)
 
     C                   IF        PEINKH = 'Y'
     C                   EVAL      *IN72 = *ON
     C                   ELSE
     C                   EVAL      *IN72 = *OFF
     C                   ENDIF
 
      ** Enable CF10 (Confirm deletion)
 
     C                   IF        PEINKJ = 'Y'
     C                   EVAL      *IN73 = *ON
     C                   ELSE
     C                   EVAL      *IN73 = *OFF
     C                   ENDIF
 
      ** Enable CF14 (Settlements)
 
     C                   IF        PEINKN = 'Y'
     C                   EVAL      *IN74 = *ON
     C                   ELSE
     C                   EVAL      *IN74 = *OFF
     C                   ENDIF
 
      ** Enable CF15 (Select)
 
     C                   IF        PEINKP = 'Y'
     C                   EVAL      *IN75 = *ON
     C                   ELSE
     C                   EVAL      *IN75 = *OFF
     C                   ENDIF
 
      ** Confirmation matching feedback information
 
     C                   IF        BGCFMT = 'Y' AND *IN83 = *ON
     C                             AND CCF003 = 'Y'
     C                             AND #0DLNO <> *BLANKS
     C                             AND OKDLNO = 'Y'
     C                             AND #0ACCD <> *BLANKS
     C                             AND OKACCD = 'Y'
     C                             AND #0ACCD <> 'I'
     C                   EVAL      *IN67 = *ON
     C                   EXSR      SRFEED
     C                   ELSE
     C                   EVAL      *IN67 = *OFF
     C                   ENDIF
 
     C                   IF        #1STAT = *BLANKS
     C                   EVAL      *IN87 = *OFF
     C                   ELSE
     C                   EVAL      *IN87 = *ON
     C                   ENDIF
 
      ** Write message subfile, Caps/Collars/Floors Details and
      ** Footer Screen
 
     C                   TIME                    #0TIME
     C                   WRITE     IRCACF1C0
     C                   WRITE     IRCACF1F0
     C                   WRITE     IRCACF1F1
 
      ** If not Write Only, read details screen.
 
     C                   IF        WriteOnly <> 'Y'
     C                   READ      IRCACF1F0                              99
     C                   ENDIF
 
      ** Clear message subfile.
 
     C                   CALL      'ZA0250'
 
      ** Set screen error indicators off.
 
     C                   MOVEA     WZ0           *IN(10)
                                                                                              CDL038
     C                   SETOFF                                       09                      CDL038
                                                                                              CDL038
 
      ** Set return keys
 
     C                   EVAL      PINKC = *INKC
     C                   EVAL      PINKG = *INKG
     C                   EVAL      PINKH = *INKH
     C                   EVAL      PINKJ = *INKJ
     C                   EVAL      PINKL = *INKL
     C                   EVAL      PINKN = *INKN
     C                   EVAL      PINKP = *INKP
 
     C                   ENDSR
 
      ** The following /COPY line includes the ProcMsgs subroutine
      ** to process error and warning messages.
     D/COPY ZACPYSRC,MSGHNDDSP2
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRFEED - Extract feedback information (Confirmation          *
      *           Matching)                                           *
      *                                                               *
      *****************************************************************
 
     C     SRFEED        BEGSR
 
      ** If Confirmation Matching present, get C/P and Broker Status
 
     C                   EVAL      #0CPTX = *BLANKS
     C                   EVAL      #0CPST = *BLANKS
     C                   EVAL      #0BKTX = *BLANKS
     C                   EVAL      #0BKST = *BLANKS
     C                   EVAL      WKEY1 = 'FI'
     C                   EVAL      WKEY2 = #0DLNO
     C                   EVAL      WKEY3 = '999'
 
     C     WCFKY         SETGT     CFFEEDL0
     C                   READP     CFFEEDL0                               01
     C                   EVAL      WTST2 = IMRF
     C                   MOVEL     IMRF          WTST2
 
      ** If no record found or feedback is for different deal, use
      ** default "NO FEEDBACK YET"
 
     C                   IF        *IN01 = *ON
     C                             OR WTST1 <> WTST2
     C                   EVAL      CPSX = *ZERO
     C                   EVAL      BKSX = *ZERO
     C                   ENDIF
 
      ** Counterparty Status
 
     C                   EVAL      #0CPTX = CPBKTxt(1)
     C     CPSX          LOOKUP    TAB1          TAB2                     01
     C                   EVAL      #0CPST = TAB2
 
      ** Broker involved?
 
     C                   IF        #0BRKC <> 'PHON' AND
     C                             #0BRKC <> 'TELX' AND
     C                             #0BRKC <> 'MAIL' AND
     C                             #0BRKC <> 'SWAP'
     C                   EVAL      #0BKTX = CPBKTxt(2)
     C     BKSX          LOOKUP    TAB1          TAB2                     01
     C                   EVAL      #0BKST = TAB2
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation routine                      *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
      ** Parameters
 
     C     *ENTRY        PLIST
 
      ** Input Parameters :
 
      ** Return code
 
     C                   PARM                    RetCodeIn
 
      ** Transaction Details in screen format
 
     C                   PARM                    IRCACF
 
      ** Current Deal in file format
 
     C                   PARM                    CrIRFilFmt
 
      ** Deal status
 
     C                   PARM                    #1STAT
 
      ** Transaction Details OK indicators
 
     C                   PARM                    IRECACF
 
      ** Error
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
 
      ** Warning
 
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
 
      ** Enable detail fields indicator
 
     C                   PARM                    PEKyFld
     C                   PARM                    PEDtFld
 
      ** Enable function keys
      ** KG = Command key 07 = Read Previous
      ** KH = Command key 08 = Read Next
      ** KJ = Command key 10 = Delete
      ** KN = Command key 14 = Settlements
      ** KP = Command key 15 = Browse
 
     C                   PARM                    PEINKG
     C                   PARM                    PEINKH
     C                   PARM                    PEINKJ
     C                   PARM                    PEINKN
     C                   PARM                    PEINKP
 
      ** Amortisation of Caps/Collars/Floors
 
     C                   PARM                    CIR006
 
      ** EMU Dealing Settlement Ccy COnversion
 
     C                   PARM                    CEU003
 
      ** Output Parameters :
 
      ** Function Keys
 
     C                   PARM                    PINKC
     C                   PARM                    PINKG
     C                   PARM                    PINKH
     C                   PARM                    PINKJ
     C                   PARM                    PINKL
     C                   PARM                    PINKN
     C                   PARM                    PINKP
 
      ** Write screen with no read indicator
 
     C                   PARM                    WriteOnly
 
 
      ** Initialize program name
 
     C                   EVAL      DBPGM = 'IRCACF1DP'
 
      ** Move user and workstation ID to screen fields.
 
     C                   EVAL      #0USER = PsUser
     C                   EVAL      #0WSID = PsJobName
 
     C                   EVAL      *IN97 = *ON
     C                   EVAL      #0PGMQ = '*'
 
      ** Access Bank Details
 
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR '     PRtCd
     C                   PARM      '*FIRST '     POption
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database Error
 
     C                   IF        PRtCd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE = 901
     C                   EVAL      DBKEY = POption
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Access General Ledger Details
 
     C**********         CALLB     'AOGELRR0'                                                 CGL029
     C                   CALLB     'AOGELRR1'                                                 CGL029
     C                   PARM      '*DBERR '     PRtCd
     C                   PARM      '*FIRST '     POption
     C*****SDGELR        PARM      SDGELR        DSFDY                                        CGL029
     C     SDGELR        PARM      SDGELR        DSSDY                                        CGL029
 
      ** Database Error
 
     C                   IF        PRtCd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDGELRPD'
     C                   EVAL      DBASE = 902
     C                   EVAL      DBKEY = POption
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Access Module Details.
 
     C                   CALL      'AOMMODR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*FIRST '     POption
     C     SDMMOD        PARM      SDMMOD        DSFDY
 
      ** Database Error
 
     C                   IF        PRtCd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDMMODPD'
     C                   EVAL      DBASE = 903
     C                   EVAL      DBKEY = POption
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Access SAR details file to determine if IRS Msg Gen Feature is on
 
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*VERIFY'     POption
     C                   PARM      'CSW005'      PSard
     C     SCSARD        PARM      SCSARD        DSFDY
 
      ** Database Error
 
     C                   IF        PRtCd <> *BLANKS AND PRtCd <> '*NRF '
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE = 904
     C                   EVAL      DBKEY = 'CSW005'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        PRtCd = *BLANKS
     C                   EVAL      *IN83 = *ON
     C                   ENDIF
 
      ** Access SAR details file to determine if CCF003 is on.
 
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*VERIFY'     POption
     C                   PARM      'CCF003'      PSard
     C     SCSARD        PARM      SCSARD        DSFDY
 
      ** Database Error
 
     C                   IF        PRtCd <> *BLANKS AND PRtCd <> '*NRF '
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE = 905
     C                   EVAL      DBKEY = 'CCF003'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        PRtCd = *BLANKS
     C                   EVAL      CCF003 = 'Y'
     C                   ELSE
     C                   EVAL      CCF003 = 'N'
     C                   ENDIF
                                                                                              CDL038
      ** Access SAR details file to determine if CDL038 is switched on                        CDL038
      ** (Extended Deal Sub Type)                                                             CDL038
                                                                                              CDL038
     C                   Call      'AOSARDR0'                                                 CDL038
     C                   Parm      *Blanks       PRtCd                                        CDL038
     C                   Parm      '*VERIFY'     POption                                      CDL038
     C                   Parm      'CDL038'      PSard                                        CDL038
     C     SCSARD        Parm      SCSARD        DSFDY                                        CDL038
      *                                                                                       CDL038
     C                   IF        PRtCd = *BLANKS                                            CDL038
     C                   EVAL      *IN08 = *OFF                                               CDL038
     C                   ELSE                                                                 CDL038
     C                   EVAL      *IN08 = *ON                                                CDL038
     C                   ENDIF                                                                CDL038
 
      ** Set Screen Protect/Non-Display Indicators
 
      ** Single-branching (protect booking branch)
 
     C                   IF        BJSBRC <> *BLANKS
     C                   EVAL      *IN80 = *ON
     C                   ENDIF
 
      ** Originating Branches not used
 
     C                   IF        BKOBRU <> 'Y' OR BJSBRC <> *BLANK
     C                   EVAL      *IN81 = *ON
     C                   ENDIF
 
      ** Profit Centres not used (protect profit centre)
 
     C                   IF        BKPRCU <> 'Y'
     C                   EVAL      *IN82 = *ON
     C                   ENDIF
 
     C                   IF        CIR006 = 'Y'
     C                   EVAL      *IN86 = *ON
     C                   ELSE
     C                   EVAL      *IN86 = *OFF
     C                   ENDIF
 
      ** The following /COPY line sets up the fixed data for SD *DSP
      ** functions for the message handler, ZAMSGHNDLE.
     D/COPY SDCPYSRC,MSGHNDDATA
 
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
(c) Finastra International Limited 2001
** WZ0
000000000000000000000000000000000000000000000000000000000000
** CPBKTxt - COUNTERPARTY AND BROKER FIELD NARRATIVE
Counterparty Conf
Broker Conf
** (TAB1/TAB2) - COUNTERPARTY AND BROKER STATUS CODES/NARRATIVES
00NO FEEDBACK YET
01WAITING
02TIMED OUT
03SPLIT FM PAIR
50PROPOSED PAIR
51PAIRED ERROR-O
52PAIRED ERROR-T
53PAIRED ERROR-B
54PROPOSED INVEST
55DUPLICATE ERROR
56INVESTIGATION
91CORRECT
92COMPLETE
93CANCEL
97NONE EXPECTED
99PAIRED NO ERROR
