     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Joint A/c Member Details Browse 2')           *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDJACM2BW - Midas SD Joint Account Member Details Browse 2   *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CER059             Date 19Jul10               *
      *                 BUG23732           Date 23Apr09               *
      *                 BUG24029           Date 20May09               *
      *                 BUG22580           Date 02Feb09               *
      *                 CER047             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 CSW207             Date 08Jun07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      *                 244537             Date 17Aug05               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 243024             Date 04Nov06               *
      *                 CGL035             Date 01Mar05               *
      *                 233965             Date 06Jun05               *
      *                 233207             Date 25Apr05               *
      *                 232543             Date 30Mar05               *
      *                 CGL031  *CREATE    Date 05Jul04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG23732 - Joint Account Threshold                           *
      *  BUG24029 - COB Error RE3662 Database Error                   *
      *  BUG22580 - Fields incorrectly labeled and lengths (Recompile)*
      *  CER047 - German Features LF037-00 Reporting §24c KWG         *
      *           (Recompile)                                         *
      *  CSW207 - SWIFT 2007 Changes                                  *
      *  244537 - To avoid overriding front office identifier         *
      *           (Recompile)                                         *
      *  243024 - Handle empty subfile/end of subfile                 *
      *  CGL035 - EUSD Upgrade to MidasPlus                           *
      *  233965 - Unable to exit Joint A/c Member Details             *
      *           Maintenance.                                        *
      *  233207 - Non-account Holders Selection Processing            *
      *  232543 - Fix to CGL031                                       *
      *  CGL031 - Taxation of Savings Income                          *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FSDJACM2BDFCF   E             WORKSTN SFILE(SDJACM2S1:WSFRN1)
     F                                     SFILE(SDJACM2S2:WSFRN2)
      ** Midas SD Joint A/c Member Details Browse 2 Display
 
     FSDJACCL8  IF   E           K DISK    INFSR(*PSSR)
      ** Midas SD Joint A/c Member Details by Joint A/c No./Customer No./Non-a/c Holder
 
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
     D  F09                   09     09
     D  F12                   12     12
 
      ** Subfile Management Indicators
     D  SFLCLR                91     91
     D  SFLDSP                92     92
     D  SFLEND                93     93
     D  ROLLUP                94     94
     D  SFLNXTCHG             95     95
     D  SFLMSGEND             96     96
 
      ** Run Date Data Area Layout
     D RUNDAT        E DS                  EXTNAME(RUNDAT) DTAARA(RUNDAT)
 
      ** Joint A/c Member Details - Screen Format
     D JAcMScrFmt    E DS                  EXTNAME(SDJACMPD)
 
      ** Joint A/c Member Details Error Indicators
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
                                                                                              CSW207
      ** External DS for Midas modules details                                                CSW207
     D SDMMOD        E DS                  Extname(SDMMODPD)                                  CSW207
      *                                                                                     BUG23732
      ** Switchable Feature Details Data Structure                                          BUG23732
      *                                                                                     BUG23732
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                BUG23732
 
      ** +--------------------------------------+
      ** ¦ Declared Variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Entry Parameters
     D PRetCode        S             10A
     D PDACTN          S              1A
     D PDJANO          S              6A
     D PSFACT          S              8A
     D OKACTN          S              1A
     D POPSEL          S              1A
     D PJASEL          S              6A
     D PCUSEL          S              6A
     D PNASEL          S             10A
     D PDFRNT          S             20A
     D PDREPA          S              1A
     D PDTMST          S               Z
     D PDACTD          S              1A
     D PDMSGID         S              7A
     D PINKC           S              1A
     D PINKE           S              1A
     D PINKI           S              1A
     D PINKL           S              1A
     D Ix              S              3P 0
     D WIx             S              3P 0
 
      ** Access Object Parameters
     D PRtCd           S              7A
     D POptn           S              7A
     D PCust           S             10A
     D PKyst           S              7A
     D PNAHo           S             10A
     D PSARD           S              6A                                                      CSW207
 
      ** Standard Utility Parameters
     D PZActn          S              1A
     D PZBrch          S              3A
     D PZErr           S              1P 0
     D PMsgFile        S             10A
     D PMsgID          S             10A
 
      ** Key Fields
     D KJANo           S                   LIKE(JCJANO)
     D KCust           S                   LIKE(JCCUST)
     D KNAHo           S                   LIKE(JCNAHO)
 
      ** Working Variables
     D WSFRN1          S              5P 0
     D WSFRN2          S              5P 0
     D WRecCnt         S              3P 0
     D WEoF            S              1A
     D WIn             S              3P 0
     D WRptName        S                   LIKE(DDCRNM)
     D CGL031          S              1    INZ(' ')                                           CSW207
     D CGL032          S              1    INZ(' ')                                           CSW207
     D PrivBank        S              1    INZ(' ')                                           CSW207
     D CER048          S              1A                                                    BUG23732
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +---------------- Start of Main Processing ------------------+
      ** ¦                                                            ¦
      ** ¦  *INZSR is automatically executed at program activation.   ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
 
     C                   EXSR      SRInit
 
     C                   SELECT
 
      ** Build the subfile.
 
     C                   WHEN      PSFACT = '*BUILD  '
 
     C                   IF        PDACTN <> 'I'
     C                   EXSR      SRBldSf1
     C                   ELSE
     C                   EXSR      SRBldSf2
     C                   ENDIF
 
     C                   RETURN
 
      ** Refresh the subfile.
 
     C                   WHEN      PSFACT = '*REFRESH'
     C                   EXSR      SRRefSfl
     C                   RETURN
 
      ** Read the subfile.
 
     C                   WHEN      PSFACT = '*READ   '
     C                   If        SFLDSP = *ON                                               243024
     C                   EXSR      SRRedSfl
     C                   EndIf                                                                243024
     C                   RETURN
 
      ** Update the subfile.
 
     C                   WHEN      PSFACT = '*UPDATE '
     C                   EXSR      SRUpdSfl
     C                   RETURN
 
      ** Display the subfile.
 
     C                   WHEN      PSFACT = '*DISPLAY'
     C                   EXSR      SRDspSfl
 
     C                   ENDSL
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRBldSf1 - Builds the Joint A/c Member details subfile.      *
      *                                                               *
      *****************************************************************
     C     SRBldSf1      BEGSR
 
      ** Initialise relevant variables.
 
     C                   EVAL      DDSFRN = *ZERO
     C                   EVAL      WSFRN1 = *ZERO
     C                   EVAL      SFLDSP = *ON
     C                   EVAL      SFLEND = *OFF
     C                   EVAL      *IN10 = *OFF
     C                   EVAL      *IN61 = *OFF
     C                   EVAL      *IN62 = *OFF
 
      ** Clear the subfile.
 
     C                   EXSR      SRClrSfl
 
      ** Send error message if necessary.
 
     C                   IF        PDMSGID <> *BLANKS
     C                   EVAL      PMsgID = PDMSGID
     C                   EXSR      SRSndErr
     C                   EVAL      PDMSGID = *BLANKS
     C                   ENDIF
 
      ** Set the header details.
 
     C                   EVAL      PCust = PDJANO
     C                   EXSR      SRGetCust
     C                   EVAL      DDJANO = PDJANO
     C                   EVAL      DDJARN = BBCRNM
 
      ** Protect amendable fields if necessary.
 
     C                   IF        PDACTN = 'E'
     C                   EVAL      *IN61 = *ON
     C                   ENDIF
 
     C                   IF        AGSUC = 'Y'
     C                   EVAL      *IN62 = *ON
     C                   ENDIF
 
      ** Set the file pointer.
 
     C                   EVAL      KJANo = DDJANO
 
     C                   IF        *IN61 = *OFF                                               233965
     C     KJANo         CHAIN     SDJACCL8                                                   233965
     C                   IF        NOT %FOUND                                                 233965
     C                   EVAL      *IN62 = *ON                                                233965
     C                   ENDIF                                                                233965
     C                   ENDIF                                                                233965
                                                                                              233965
     C                   IF        DDKCUS <> *BLANKS OR
     C                             DDKNAH <> *BLANKS
     C                   EVAL      KCust = DDKCUS
     C                   EVAL      KNAHo = DDKNAH
     C     KJACC         SETLL     SDJACCL8
     C                   ELSE
     C     KJANo         SETLL     SDJACCL8
     C                   ENDIF
 
      ** Build the subfile pages.
 
     C                   EXSR      SRBSfPg1
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRBSfPg1 - Builds Joint A/c Member details subfile pages.    *
      *                                                               *
      *****************************************************************
     C     SRBSfPg1      BEGSR
 
     C                   EVAL      ROLLUP = *ON
 
     C                   DOW       ROLLUP = *ON
 
      ** Read a Joint A/c Member detail.
 
     C                   EXSR      SRRdJAcMDet
 
     C                   EVAL      WRecCnt = *ZERO
 
     C                   DOW       WEoF <> 'Y'
 
     C                   EVAL      WSFRN1 = DDSFRN
     C                   EVAL      WSFRN1 = WSFRN1 + 1
     C                   EVAL      WRecCnt = WRecCnt + 1
 
     C                   EVAL      *IN21 = *OFF
     C                   EVAL      *IN24 = *OFF
     C                   EVAL      *IN25 = *OFF
     C                   EVAL      *IN26 = *OFF
 
     C                   EVAL      DDACTN = *BLANK
     C                   EVAL      DDCUST = JCCUST
     C                   EVAL      DDNAHO = JCNAHO
 
     C                   IF        JCCUST <> *BLANKS
     C                   EVAL      DDCRNM = BBCRNM
     C                   ELSE
     C                   EVAL      DDCRNM = NHNARN
     C                   ENDIF
 
     C                   EVAL      DDINVP = JCINVP
     C                   EVAL      DDPAHT = JCPAHT
     C                   EVAL      DDPAHO = JCPAHO
 
     C                   EVAL      DDFRNT = JCFRNT
     C                   EVAL      DDREPA = JCREPA
     C                   EVAL      DDTMST = JCTMST
 
     C                   EVAL      DDSFRN = WSFRN1
 
     C                   IF        *IN61 = *ON
     C                   WRITE     SDJACM2S1
     C                   ELSE
     C                   EVAL      SFLNXTCHG = *ON
     C                   WRITE     SDJACM2S1
     C                   EVAL      SFLNXTCHG = *OFF
     C                   ENDIF
 
      ** Leave if one subfile page has been filled.
 
     C                   IF        WRecCnt = 12
 
      ** Check first if there are more records available.
 
     C                   EXSR      SRRdJAcMDet
 
     C                   IF        WEoF <> 'Y'
     C                   READP     SDJACCL8
     C                   ENDIF
 
     C                   LEAVE
     C                   ENDIF
 
     C                   EXSR      SRRdJAcMDet
     C                   ENDDO
 
     C                   IF        WEoF = 'Y' AND
     C                             WRecCnt = *ZERO
 
      ** No records found.
 
     C**********         EVAL      PMsgID = 'SDM0100'                                         CGL035
     C                   EVAL      PMsgID = 'SDM0135'                                         CGL035
     C                   EXSR      SRSndErr
     C                   EVAL      SFLDSP = *OFF
     C                   ENDIF
 
     C                   EXSR      SRDSfPag
 
     C                   SELECT
 
     C                   WHEN      F03 = *ON
     C                   EVAL      PINKC = *ON
     C                   RETURN
 
     C                   WHEN      F05 = *ON
     C                   EVAL      PINKE = *ON
     C                   RETURN
 
     C                   WHEN      F09 = *ON
     C                   EVAL      PINKI = *ON
     C                   RETURN
 
     C                   WHEN      F12 = *ON
     C                   EVAL      PINKL = *ON
     C                   RETURN
     C                   ENDSL
 
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRBldSf2 - Builds the insert subfile.                        *
      *                                                               *
      *****************************************************************
     C     SRBldSf2      BEGSR
 
      ** Initialise relevant variables.
 
     C                   EVAL      DDSFRN = *ZERO
     C                   EVAL      WSFRN2 = *ZERO
     C                   EVAL      SFLDSP = *ON
     C                   EVAL      SFLEND = *OFF
     C                   EVAL      *IN10 = *ON
     C                   EVAL      *IN61 = *ON
     C                   EVAL      *IN62 = *OFF
 
      ** Clear the subfile.
 
     C                   EXSR      SRClrSfl
 
      ** Send error message if necessary.
 
     C                   IF        PDMSGID <> *BLANKS
     C                   EVAL      PMsgID = PDMSGID
     C                   EXSR      SRSndErr
     C                   EVAL      PDMSGID = *BLANKS
     C                   ENDIF
 
      ** Set the header details.
 
     C                   EVAL      PCust = PDJANO
     C                   EXSR      SRGetCust
     C                   EVAL      DDJANO = PDJANO
     C                   EVAL      DDJARN = BBCRNM
 
      ** Build the subfile pages.
 
     C                   EXSR      SRBSfPg2
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRBSfPg2 - Builds insert subfile pages.                      *
      *                                                               *
      *****************************************************************
     C     SRBSfPg2      BEGSR
 
     C                   EVAL      ROLLUP = *ON
 
     C                   DOW       ROLLUP = *ON
 
     C                   EVAL      WRecCnt = *ZERO
 
     C                   DOW       WRecCnt < 13
 
     C                   EVAL      WSFRN2 = DDSFRN
     C                   EVAL      WSFRN2 = WSFRN2 + 1
     C                   EVAL      WRecCnt = WRecCnt + 1
 
     C                   EVAL      *IN22 = *OFF
     C                   EVAL      *IN23 = *OFF
     C                   EVAL      *IN24 = *OFF
     C                   EVAL      *IN25 = *OFF
     C                   EVAL      *IN26 = *OFF
 
     C                   EVAL      DDACTN = *BLANK
     C                   EVAL      DDCUST = *BLANKS
     C                   EVAL      DDNAHO = *BLANKS
     C                   EVAL      DDCRNM = *BLANKS
     C                   EVAL      DDINVP = *BLANKS
     C                   EVAL      DDPAHT = *BLANK
     C                   EVAL      DDPAHO = *BLANK
     C                   EVAL      DDSFRN = WSFRN2
     C                   WRITE     SDJACM2S2
 
     C                   ENDDO
 
     C                   EXSR      SRDSfPag
 
     C                   SELECT
 
     C                   WHEN      F03 = *ON
     C                   EVAL      PINKC = *ON
     C                   RETURN
 
     C                   WHEN      F05 = *ON
     C                   EVAL      PINKE = *ON
     C                   RETURN
 
     C                   WHEN      F12 = *ON
     C                   EVAL      PINKL = *ON
     C                   RETURN
 
     C                   ENDSL
 
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDSfPag - Displays the subfile page.                        *
      *                                                               *
      *****************************************************************
     C     SRDSfPag      BEGSR
 
     C                   WRITE     SDJACM2F1
     C                   WRITE     SDJACM2C3
     C                   WRITE     SDJACM2F2
 
     C                   IF        PDACTN <> 'I'
     C                   WRITE     SDJACM2C1
     C                   READ      SDJACM2C1
     C                   ELSE
     C                   WRITE     SDJACM2C2
     C                   READ      SDJACM2C2
     C                   ENDIF
 
      ** Clear messages from the program message queue.
 
     C                   CALL      'ZA0250'
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRClrSfl - Clears the subfile.                               *
      *                                                               *
      *****************************************************************
     C     SRClrSfl      BEGSR
 
     C                   EVAL      SFLCLR = *ON
 
     C                   IF        PDACTN <> 'I'
     C                   WRITE     SDJACM2C1
     C                   ELSE
     C                   WRITE     SDJACM2C2
     C                   ENDIF
 
     C                   EVAL      SFLCLR = *OFF
 
      ** Clear messages from the program message queue.
 
     C                   CALL      'ZA0250'
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRefSfl - Refreshes the subfile.                            *
      *                                                               *
      *****************************************************************
     C     SRRefSfl      BEGSR
 
     C                   IF        PDACTN <> 'I'
     C                   EVAL      DDKCUS = *BLANKS
     C                   EVAL      DDKNAH = *BLANKS
     C                   EVAL      WSFRN1 = *ZERO
     C                   ELSE
     C                   EVAL      WSFRN2 = *ZERO
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRedSfl - Reads the subfile.                                *
      *                                                               *
      *****************************************************************
     C     SRRedSfl      BEGSR
 
     C                   EVAL      POPSEL = *BLANK
     C                   EVAL      PJASEL = *BLANKS
     C                   EVAL      PCUSEL = *BLANKS
     C                   EVAL      PNASEL = *BLANKS
     C                   EVAL      PDFRNT = *BLANKS
     C                   EVAL      PDREPA = *BLANKS
     C                   CLEAR                   PDTMST
     C                   EVAL      PDACTD = *BLANK
 
     C                   IF        PDACTN <> 'I'
     C**********         READC     SDJACM2S1                                                  243024
     C                   READC     SDJACM2S1                              99                  243024
     C                   ELSE
     C**********         READC     SDJACM2S2                                                  243024
     C                   READC     SDJACM2S2                              99                  243024
 
      ** Initialise hidden fields for insert.
 
     C                   EVAL      DDACTN = 'I'
     C                   EVAL      DDFRNT = *BLANKS
     C                   EVAL      DDREPA = *BLANK
     C                   CLEAR                   DDTMST
     C                   EVAL      PDACTD = 'Y'
     C                   ENDIF
 
     C                   IF        NOT %EOF
 
      ** Default Action Code to 'A' if necessary.
 
     C                   IF        DDACTN = *BLANK
     C                   EVAL      POPSEL = 'A'
     C                   EVAL      PDACTD = 'Y'
     C                   ELSE
     C                   EVAL      POPSEL = DDACTN
     C                   ENDIF
 
      ** Return the Action Code, Joint A/c Number, Customer Number, &
      ** Non-a/c Holder.
 
     C                   EVAL      PJASEL = DDJANO
     C                   EVAL      PCUSEL = DDCUST
     C                   EVAL      PNASEL = DDNAHO
     C                   EVAL      PDFRNT = DDFRNT
     C                   EVAL      PDREPA = DDREPA
     C                   EVAL      PDTMST = DDTMST
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRUpdSfl - Updates the subfile.                              *
      *                                                               *
      *****************************************************************
     C     SRUpdSfl      BEGSR
 
      ** Set the screen error indicators.
 
     C                   EVAL      *IN21 = *OFF
     C                   IF        CER048 = 'Y'                                             BUG23732
     C                   EVAL      *IN66 = *OFF                                             BUG23732
     C                   ENDIF                                                              BUG23732
 
     C                   IF        OKACTN = 'N'
     C                   EVAL      *IN21 = *ON
     C                   ENDIF
      *                                                                                     BUG23732
     C                   IF        CER048 = 'Y' AND                                         BUG23732
     C                             OKCUST = 'N'                                             BUG23732
     C                   EVAL      *IN66 = *ON                                              BUG23732
     C                   ENDIF                                                              BUG23732
 
     C                   MOVEA     OKJAcMDets    EINA
 
     C                   FOR       WIn = 2 TO %ELEM(EINA)
 
     C                   EVAL      *IN(WIn + 20) = *OFF
 
     C                   IF        EINA(WIn) = 'N'
     C                   EVAL      *IN(WIn + 20) = *ON
     C                   ENDIF
 
     C                   ENDFOR
 
     C                   EVAL      SFLNXTCHG = *ON
 
     C                   IF        PDACTN <> 'I'
     C                   UPDATE    SDJACM2S1
     C                   ELSE
 
      ** Get the report name first.
 
     C                   EXSR      SRGetRptN
     C                   EVAL      DDCRNM = WRptName
 
     C                   UPDATE    SDJACM2S2
     C                   ENDIF
 
     C                   EVAL      SFLNXTCHG = *OFF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDsfSfl - Displays the subfile.                             *
      *                                                               *
      *****************************************************************
     C     SRDspSfl      BEGSR
 
      **---------------------------------------------------------------
      ** Error & Warning Messages Processing
     C/COPY ZACPYSRC,MSGHNDDSP1
      **---------------------------------------------------------------
 
     C                   EXSR      SRDSfPag
 
     C                   IF        ROLLUP = *ON
 
     C                   IF        PDACTN <> 'I'
     C                   EXSR      SRBSfPg1
     C                   ELSE
     C                   EXSR      SRBSfPg2
     C                   ENDIF
 
     C                   ENDIF
 
     C                   SELECT
 
     C                   WHEN      F03 = *ON
     C                   EVAL      PINKC = *ON
 
     C                   WHEN      F05 = *ON
     C                   EVAL      PINKE = *ON
 
     C                   WHEN      F09 = *ON
     C                   EVAL      PINKI = *ON
 
     C                   WHEN      F12 = *ON
     C                   EVAL      PINKL = *ON
 
     C                   ENDSL
 
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRdJAcMDet - Reads a Joint Account Member detail.           *
      *                                                               *
      *****************************************************************
     C     SRRdJAcMDet   BEGSR
 
     C                   EVAL      WEoF = 'N'
     C                   EVAL      SFLEND = *OFF
 
     C     KJANo         READE     SDJACCL8
 
     C                   IF        NOT %EOF
 
     C                   IF        JCCUST <> *BLANKS
     C                   EVAL      PCust = JCCUST
     C                   EXSR      SRGetCust
     C                   ELSE
     C                   EVAL      PNAHo = JCNAHO
     C                   EXSR      SRGetNAHo
     C                   ENDIF
 
     C                   LEAVESR
     C                   ENDIF
 
     C                   EVAL      WEoF = 'Y'
     C                   EVAL      SFLEND = *ON
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSndErr - Sends error messages to the program message       *
      *             queue.                                            *
      *                                                               *
      *****************************************************************
     C     SRSndErr      BEGSR
 
     C                   CALL      'ZA0340'
     C                   PARM      'SDUSRMSG  '  PMsgFile
     C                   PARM                    PMsgID
 
     C                   ENDSR
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
     C                             And PRtCd <> '*KEY   '                                     232543
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
 
     C                   EVAL      WRptName = *BLANKS
 
     C                   IF        *IN22 = *OFF AND
     C                             *IN23 = *OFF
 
     C                   IF        DDCUST <> *BLANKS AND
     C                             %SCAN('?':DDCUST) = *ZERO
     C                   EVAL      PCust = DDCUST
     C                   EXSR      SRGetCust
     C                   EVAL      WRptName = BBCRNM
     C                   ENDIF
 
     C                   IF        DDNAHO <> *BLANKS
     C                             AND %SCAN('?':DDNAHO) = *ZERO                              233207
     C                   EVAL      PNAHo = DDNAHO
     C                   EXSR      SRGetNAHo
     C                   EVAL      WRptName = NHNARN
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRInit - Handles initial processing.                         *
      *                                                               *
      *****************************************************************
     C     SRInit        BEGSR
 
     C                   IF        (CGL031 = 'Y' AND CGL032 = 'Y') OR                         CSW207
     C                             PrivBank = 'Y'                                             CSW207
     C                   EVAL      *IN65 = *OFF                                               CSW207
     C                   ELSE                                                                 CSW207
     C                   EVAL      *IN65 = *ON                                                CSW207
     C                   ENDIF                                                                CSW207
                                                                                              CSW207
     C                   EVAL      F03 = *OFF
     C                   EVAL      F05 = *OFF
     C                   EVAL      F09 = *OFF
     C                   EVAL      F12 = *OFF
 
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
 
      ** Action Code
     C                   PARM                    PDACTN
 
      ** Joint A/c Number Pointer
     C                   PARM                    PDJANO
 
      ** Subfile Action
     C                   PARM                    PSFACT
 
      ** OK - Action Code
     C                   PARM                    OKACTN
 
      ** OK - Joint A/c Member Details
     C                   PARM                    OKJAcMDets
 
      ** Error Fields/Message IDs/Message Data (arrays) From/To Caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
 
      ** Array Index (3P0) From/To Caller
     C                   PARM                    Ix
 
      ** Warning Fields/Message IDs/Message Data (arrays) From/To Caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
 
      ** Array Index (3P0) From/To Caller
     C                   PARM                    WIx
 
      ** Message ID
     C                   PARM                    PDMSGID
 
      ***********************
      ** Output Parameters **
      ***********************
 
      ** Option Selected
     C                   PARM                    POPSEL
 
      ** Joint A/c Number Selected
     C                   PARM                    PJASEL
 
      ** Customer Number Selected
     C                   PARM                    PCUSEL
 
      ** Non-a/c Holder Selected
     C                   PARM                    PNASEL
 
      ** Joint A/c Member Details - Screen Format
     C                   PARM                    JAcMScrFmt
 
      ** Joint A/c Member Front Office Transaction ID
     C                   PARM                    PDFRNT
 
      ** Joint A/c Member Repair Location
     C                   PARM                    PDREPA
 
      ** Joint A/c Member Timestamp
     C                   PARM                    PDTMST
 
      ** Action Code Default
     C                   PARM                    PDACTD
 
      ** Command Keys
     C                   PARM                    PINKC
     C                   PARM                    PINKE
     C                   PARM                    PINKI
     C                   PARM                    PINKL
 
      ** Key Lists
 
     C     KJACC         KLIST
     C                   KFLD                    KJANo
     C                   KFLD                    KCust
     C                   KFLD                    KNAHo
 
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
      ** Check CGL031 feature                                                                 CSW207
     C                   Call      'AOSARDR0'                                                 CSW207
     C                   Parm      *Blanks       PRtCd                                        CSW207
     C                   Parm      '*VERIFY'     POptn                                        CSW207
     C                   Parm      'CGL031'      PSARD                                        CSW207
     C                   Parm                    DSFDY                                        CSW207
                                                                                              CSW207
     C                   IF        PRtCd <> *BLANKS AND                                       CSW207
     C                             PRtCd <> '*NRF   '                                         CSW207
     C     *LOCK         IN        LDA                                                        CSW207
     C                   EVAL      DBFile = 'CGL031'                                          CSW207
     C                   EVAL      DBKey = POptn                                              CSW207
     C                   EVAL      DBase = 104                                                CSW207
     C                   OUT       LDA                                                        CSW207
     C                   EXSR      *PSSR                                                      CSW207
     C                   ELSE                                                                 CSW207
     C                   IF        PRtCd = '*NRF   '                                          CSW207
     C                   EVAL      CGL031 = 'N'                                               CSW207
     C                   ELSE                                                                 CSW207
     C                   EVAL      CGL031 = 'Y'                                               CSW207
     C                   ENDIF                                                                CSW207
     C                   ENDIF                                                                CSW207
      ** Check CGL032 feature                                                                 CSW207
     C                   Call      'AOSARDR0'                                                 CSW207
     C                   Parm      *Blanks       PRtCd                                        CSW207
     C                   Parm      '*VERIFY'     POptn                                        CSW207
     C                   Parm      'CGL032'      PSARD                                        CSW207
     C                   Parm                    DSFDY                                        CSW207
                                                                                              CSW207
     C                   IF        PRtCd <> *BLANKS AND                                       CSW207
     C                             PRtCd <> '*NRF   '                                         CSW207
     C     *LOCK         IN        LDA                                                        CSW207
     C                   EVAL      DBFile = 'CGL032'                                          CSW207
     C                   EVAL      DBKey = POptn                                              CSW207
     C                   EVAL      DBase = 105                                                CSW207
     C                   OUT       LDA                                                        CSW207
     C                   EXSR      *PSSR                                                      CSW207
     C                   ELSE                                                                 CSW207
     C                   IF        PRtCd = '*NRF   '                                          CSW207
     C                   EVAL      CGL032 = 'N'                                               CSW207
     C                   ELSE                                                                 CSW207
     C                   EVAL      CGL032 = 'Y'                                               CSW207
     C                   ENDIF                                                                CSW207
     C                   ENDIF                                                                CSW207
                                                                                              CSW207
      ** Check if Private Banking Module is available                                         CSW207
     C                   Call      'AOMMODR0'                                                 CSW207
     C                   Parm      *Blanks       PRtCd                                        CSW207
     C                   Parm      '*FIRST'      POptn                                        CSW207
     C     SDMMOD        PARM      SDMMOD        DSFDY                                        CSW207
     C                   IF        PRtCd <> *BLANKS                                           CSW207
     C     *LOCK         IN        LDA                                                        CSW207
     C                   EVAL      DBFile = 'SDMMODPD'                                        CSW207
     C                   EVAL      DBKey = POptn                                              CSW207
     C                   EVAL      DBase = 106                                                CSW207
     C                   OUT       LDA                                                        CSW207
     C                   EXSR      *PSSR                                                      CSW207
     C                   ENDIF                                                                CSW207
     C                   IF        BGN4ST = 'Y'                                               CSW207
     C                   EVAL      PrivBank = 'Y'                                             CSW207
     C                   ENDIF                                                                CSW207
                                                                                              CSW207
      *                                                                                     BUG23732
      ** Check if CER048 is enabled.                                                        BUG23732
      *                                                                                     BUG23732
     C                   CALL      'AOSARDR0'                                               BUG23732
     C                   PARM      *BLANKS       PRtcd                                      BUG23732
     C                   PARM      '*VERIFY'     POptn                                      BUG23732
     C                   PARM      'CER048'      PSard                                      BUG23732
     C     SCSARD        PARM      SCSARD        DSFDY                                      BUG23732
      *                                                                                     BUG23732
     C                   EVAL      CER048 = 'N'                                             BUG23732
      *                                                                                     BUG23732
     C                   IF        PRtcd = *BLANKS                                          BUG23732
      *                                                                                     BUG23732
     C                   EVAL      CER048 = 'Y'                                             BUG23732
      *                                                                                     BUG23732
     C                   ELSE                                                               BUG23732
      *                                                                                     BUG23732
     C                   IF        (PRtcd <> *BLANKS) AND                                   BUG23732
     C                             (PRtcd <> '*NRF   ')                                     BUG23732
      *                                                                                     BUG23732
     C     *LOCK         IN        LDA                                                      BUG23732
     C                   EVAL      DBFILE = 'SCSARDPD'                                      BUG23732
     C                   EVAL      DBKEY = 'CER048'                                         BUG23732
     C                   EVAL      DBASE = 111                                              BUG23732
     C                   OUT       LDA                                                      BUG23732
     C                   EXSR      *PSSR                                                    BUG23732
      *                                                                                     BUG23732
     C                   ENDIF                                                              BUG23732
      *                                                                                     BUG23732
     C                   ENDIF                                                              BUG23732
 
      ** Set the system information display fields.
 
     C                   EVAL      DDRUND = BJMRDT
     C                   EVAL      DDUSER = PSUser
     C                   EVAL      DDWSID = PSJobName
     C                   EVAL      DDPGMQ = PSProcMod
 
     C                   EVAL      SFLDSP = *ON
     C                   EVAL      SFLMSGEND = *ON
 
      **---------------------------------------------------------------
      ** Message Handler Fixed Data
     C/COPY SDCPYSRC,MSGHNDDATA
      **---------------------------------------------------------------
 
     C                   IN        RUNDAT
 
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
(c) Finastra International Limited 2004
