     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Joint A/c Member Details Display')            *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDJACMDSP - Midas SD Joint Account Member Details Display    *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2004            *
      *                                                               *
      *  Last Amend No. CER059             Date 19Jul10               *
      *  Prev Amend No. BUG24029           Date 20May09               *
      *                 BUG22580           Date 02Feb09               *
      *                 CER047             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      *                 244537             Date 17Aug05               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 232543             Date 01Apr05               *
      *                 CGL031  *CREATE    Date 05Jul04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG24029 - COB Error RE3662 Database Error                   *
      *  BUG22580 - Fields incorrectly labeled and lengths (Recompile)*
      *  CER047 - German Features LF037-00 Reporting §24c KWG         *
      *           (Recompile)                                         *
      *  244537 - To avoid overriding front office identifier         *
      *           (Recompile)                                         *
      *  232543 - Fix to CGL031 (Recompile)                           *
      *  CGL031 - Taxation of Savings Income                          *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FSDJACMDF  CF   E             WORKSTN
      ** Midas SD Joint A/c Member Details Display File
 
     FZAFLDNPD  IT   F   15        DISK    INFSR(*PSSR)
      ** Midas ZA Sequence Numbers for Input Fields
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      **---------------------------------------------------------------
      ** Program Status Data Structure
     D/COPY ZACPYSRC,PSDS
      **---------------------------------------------------------------
 
      **---------------------------------------------------------------
      ** Standard D-specs
     D/COPY ZACPYSRC,STD_D_SPEC
      **---------------------------------------------------------------
 
      **---------------------------------------------------------------
      ** API Validation Error Array Declarations
     D/COPY ZACPYSRC,ERR_ARRAYS
      **---------------------------------------------------------------
 
      **---------------------------------------------------------------
      ** Array Declares for *CTL Modules
     D/COPY ZACPYSRC,APICTLARR
      **---------------------------------------------------------------
 
      **---------------------------------------------------------------
      ** Message Handler Definitions
     D/COPY ZACPYSRC,MSGHNDDCL
      **---------------------------------------------------------------
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Named Constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Error Indicators Array
     D EINA            S              1A   DIM(%LEN(OKJAcMDets))
 
      ** Indicator Array Overlay Data Structure
     D INPTR           S               *   INZ(%ADDR(*IN))
     D                 DS                  BASED(INPTR)
 
      ** Function Key Indicators
     D  F03                   03     03
     D  F05                   05     05
     D  F12                   12     12
 
      ** Subfile Management Indicators
     D  SFLMSGEND             96     96
 
      ** Joint A/c Member Details - Screen Format
     D JAcMScrFmt    E DS                  EXTNAME(SDJACMPD)
 
      ** Joint A/c Member Error Indicators
     D OKJAcMDets    E DS                  EXTNAME(SDEJACMPD)
 
      ** Bank Details Data Structure
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** Customer Details Data Structure
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
 
      ** Non-a/c Holder Details Data Structure
     D SDNAHO        E DS                  EXTNAME(SDNAHOPD)
 
      ** Short Access Object Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Long Access Object Data Structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
                                                                                            BUG24029
      ** Long Access Object Data Structure                                                  BUG24029
     D DSLDY         E DS                  EXTNAME(DSLDY)                                   BUG24029
 
      ** +--------------------------------------+
      ** ¦ Declared Variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Entry Parameters
     D PRetCode        S             10A
     D PDJANO          S              6A
     D OKACTN          S              1A
     D PINKC           S              1A
     D PINKE           S              1A
     D PINKL           S              1A
     D Ix              S              3P 0
 
      ** Access Object Parameters
     D PRtCd           S              7A
     D POptn           S              7A
     D PCust           S             10A
     D PKyst           S              7A
     D PNAHo           S             10A
 
      ** Working Variables
     D WIn             S              3P 0
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +---------------- Start of Main Processing ------------------+
      ** ¦                                                            ¦
      ** ¦  *INZSR is automatically executed at program activation.   ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
 
      ** Set the header details.
 
     C                   EVAL      PCust = PDJANO
     C                   EXSR      SRGetCust
     C                   EVAL      DDJANO = PDJANO
     C                   EVAL      DDJARN = BBCRNM
 
      ** Set screen error indicators.
 
     C                   MOVEA     OKJAcMDets    EINA
 
     C                   FOR       WIn = 2 TO %ELEM(EINA)
 
     C                   EVAL      *IN(WIn + 20) = *OFF
 
     C                   IF        EINA(WIn) = 'N'
     C                   EVAL      *IN(WIn + 20) = *ON
     C                   ENDIF
 
     C                   ENDFOR
 
      ** Highlight key fields if an Action Code error occurred.
 
     C                   IF        OKACTN = 'N'
 
     C                   SELECT
     C                   WHEN      DDCUST <> *BLANKS
     C                   EVAL      *IN22 = *ON
     C                   WHEN      DDNAHO <> *BLANKS
     C                   EVAL      *IN23 = *ON
     C                   ENDSL
 
     C                   ENDIF
 
      ** Get the report name first.
 
     C                   EXSR      SRGetRptN
 
     C                   IF        DDACTN = *BLANK
     C                   EVAL      DDACTN = 'I'
     C                   ENDIF
 
     C                   EVAL      *IN62 = *OFF
 
      ** Unprotect fields if necessary.
 
     C                   IF        DDACTN = 'I'
     C                   EVAL      *IN62 = *ON
     C                   ENDIF
 
     C                   EVAL      DDJANO = PDJANO
 
      ** Set up the Joint A/c Reference to be used by the message handler.
 
     C                   EVAL      ActionCode = DDACTN
 
     C                   IF        DDCUST <> *BLANKS
     C                   EVAL      TranRef = DDJANO + DDCUST
     C                   ELSE
     C                   EVAL      TranRef = DDJANO + DDNAHO
     C                   ENDIF
 
      **---------------------------------------------------------------
      ** Error & Warning Messages Processing
     C/COPY ZACPYSRC,MSGHNDDSP1
      **---------------------------------------------------------------
 
     C                   WRITE     SDJACMC1
     C                   WRITE     SDJACMF2
 
     C                   WRITE     SDJACMF1
     C                   READ      SDJACMF1
 
     C                   EVAL      PINKC = F03
     C                   EVAL      PINKE = F05
     C                   EVAL      PINKL = F12
 
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRGetCust - Gets customer details.                           *
      *                                                               *
      *****************************************************************
     C     SRGetCust     BEGSR
 
     C                   CLEAR                   SDCUST
 
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY   '     POptn
     C                   PARM                    PCust
     C                   PARM      *BLANKS       PKyst
     C     SDCUST        PARM      SDCUST        DSSDY
 
     C                   IF        PRtCd <> *BLANKS AND
     C                             PRtCd <> '*NRF   '
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'SDCUSTPD'
     C                   EVAL      DBKey = PCust
     C                   EVAL      DBase = 102
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRGetNAHo - Gets Non-a/c Holder details.                     *
      *                                                               *
      *****************************************************************
     C     SRGetNAHo     BEGSR
 
     C                   CLEAR                   SDNAHO
 
     C                   CALL      'AONAHOR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY   '     POptn
     C                   PARM                    PNAHo
     C*****SDNAHO        PARM      SDNAHO        DSSDY                                      BUG24029
     C     SDNAHO        PARM      SDNAHO        DSLDY                                      BUG24029
 
     C                   IF        PRtCd <> *BLANKS AND
     C                             PRtCd <> '*NRF   '
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'SDNAHOPD'
     C                   EVAL      DBKey = PNAHo
     C                   EVAL      DBase = 103
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRGetRptN - Gets the report name.                            *
      *                                                               *
      *****************************************************************
     C     SRGetRptN     BEGSR
 
     C                   EVAL      DDCRNM = *BLANKS
 
     C                   IF        *IN22 = *OFF AND
     C                             *IN23 = *OFF
 
     C                   IF        DDCUST <> *BLANKS AND
     C                             %SCAN('?':DDCUST) = *ZERO
     C                   EVAL      PCust = DDCUST
     C                   EXSR      SRGetCust
     C                   EVAL      DDCRNM = BBCRNM
     C                   ENDIF
 
     C                   IF        DDNAHO <> *BLANKS
     C                   EVAL      PNAHo = DDNAHO
     C                   EXSR      SRGetNAHo
     C                   EVAL      DDCRNM = NHNARN
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program initialisation subroutine.                  *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
 
      **********************
      ** Input Parameters **
      **********************
 
      ** Return Code
     C                   PARM                    PRetCode
 
      ** Joint A/c Number
     C                   PARM                    PDJANO
 
      ** Joint A/c Member Details - Screen Format
     C                   PARM                    JAcMScrFmt
 
      ** OK - Action Code
     C                   PARM                    OKACTN
 
      ** OK - Joint A/c Member
     C                   PARM                    OKJAcMDets
 
      ** Error Fields/Message IDs/Message Data (arrays) From/To Caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
 
      ** Array Index (3P0) From/To Caller
     C                   PARM                    Ix
 
      ***********************
      ** Output Parameters **
      ***********************
 
      ** Command Keys
     C                   PARM                    PINKC
     C                   PARM                    PINKE
     C                   PARM                    PINKL
 
      ** Get bank details.
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY
 
     C                   IF        PRtCd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'SDBANKPD'
     C                   EVAL      DBKey = POptn
     C                   EVAL      DBase = 101
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Set the system information display fields.
 
     C                   EVAL      DDRUND = BJMRDT
     C                   EVAL      DDUSER = PSUser
     C                   EVAL      DDWSID = PSJobName
     C                   EVAL      DDPGMQ = PSProcMod
 
     C                   EVAL      SFLMSGEND = *ON
 
      **---------------------------------------------------------------
      ** Message Handler Fixed Data
     C/COPY SDCPYSRC,MSGHNDDATA
      **---------------------------------------------------------------
 
      **---------------------------------------------------------------
      ** Program, Module, & Procedure Names for DB Error Processing
     C/COPY ZACPYSRC,DBFIELDS
      **---------------------------------------------------------------
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      **---------------------------------------------------------------
      ** ProcMsgs Subroutine
     D/COPY ZACPYSRC,MSGHNDDSP2
      **---------------------------------------------------------------
      *****************************************************************
      /EJECT
      *****************************************************************
      **---------------------------------------------------------------
      ** ILE RPG Program Status Subroutine
     C/COPY ZACPYSRC,PSSR_ILE
      **---------------------------------------------------------------
      *****************************************************************
      /EJECT
      *****************************************************************
** CPY@
(c) Misys International Banking Systems Ltd. 2004
