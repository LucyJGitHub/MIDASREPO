     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Joint A/c Member Details Browse 1')           *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDJACM1BW - Midas SD Joint Account Member Details Browse 1   *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2004            *
      *                                                               *
      *  Last Amend No. CER071             Date 01Aug16               *
      *  Prev Amend No. CER070             Date 19Aug14               *
      *                 MD026708           Date 12May14               *
      *                 MD026477           Date 29Apr14               *
      *                 CGL132             Date 01May13               *
      *                 CLE134             Date 01Aug12               *
      *                 CER059             Date 19Jul10               *
      *                 CER045             Date 20Jul09               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 243024             Date 04Nov06               *
      *                 CGL035             Date 01Mar05               *
      *                 232543             Date 31Mar05               *
      *                 CGL031  *CREATE    Date 05Jul04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER071 - BAIS - Legal Form field (Recompile)                 *
      *  CER070 - BuBa Reporting / BAIS V.1.16.0 (Recompile)          *
      *  MD026708 - Joint Account Member Maintenance shows records    *
      *             that should not be included                       *
      *  MD026477 - Database Error on JACM when CGL132 is OFF         *
      *  CGL132 - FATCA Phase 1 - Customers' Identification and       *
      *           Classification - Master                             *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER045 - German Features - Reporting Bundesbank (Recompile)  *
      *  243024 - Handle empty subfile/end of subfile                 *
      *  CGL035 - EUSD Upgrade to MidasPlus                           *
      *  232543 - Fix to CGL031 (Recompile)                           *
      *  CGL031 - Taxation of Savings Income                          *
      *                                                               *
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

     FSDJACM1BDFCF   E             WORKSTN SFILE(SDJACM1S1:WSFRN1)
     F                                     SFILE(SDJACM1S2:WSFRN2)
      ** Midas SD Joint A/c Member Details Browse 1 Display

     FSDACUSL1  IF   E           K DISK    INFSR(*PSSR)
      ** Midas SD Additional Customer Details by Customer Number

     FSDACUSL2  IF   E           K DISK    INFSR(*PSSR)
      ** Midas SD Additional Customer Details by Front Office Transaction ID

     FSDCUSTL1  IF   E           K DISK    INFSR(*PSSR)
      ** Midas SD Customer Details by Customer Number

     FSDJACCL1  IF   E           K DISK    INFSR(*PSSR)
      ** Midas SD Joint A/c Member Details by Joint A/c No./Customer No.

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

      ** Indicator Array Overlay Data Structure
     D INPTR           S               *   INZ(%ADDR(*IN))
     D                 DS                  BASED(INPTR)

      ** Function Key Indicators
     D  F03                   03     03
     D  F05                   05     05
     D  F11                   11     11

      ** Subfile Management Indicators
     D  ENQMODE               90     90
     D  SFLCLR                91     91
     D  SFLDSP                92     92
     D  SFLEND                93     93
     D  ROLLUP                94     94
     D  SFLNXTCHG             95     95
     D  SFLMSGEND             96     96

      ** Bank Details Data Structure
     D SDBANK        E DS                  EXTNAME(SDBANKPD)

      ** External DS for SAR details                                                          CGL132
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CGL132
                                                                                              CGL132
      ** Short Access Object Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)

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
     D PDACTD          S              1A
     D PINKC           S              1A
     D PINKE           S              1A
     D Ix              S              3P 0

      ** Access Object Parameters
     D PRtCd           S              7A
     D POptn           S              7A
     D PSARD           S              6A                                                      CGL132
     D*CGL132***       S              1A                                             CGL132 MD026708
     D CGL132          S              1A   INZ('N')                                         MD026708

      ** Standard Utility Parameters
     D PZActn          S              1A
     D PZErr           S              1P 0
     D PMsgFile        S             10A
     D PMsgID          S             10A

      ** Key Fields
     D KCust           S                   LIKE(E5CUST)
     D KFrnt           S                   LIKE(E5FRNT)
     D KJANo           S                   LIKE(JCJANO)

      ** Working Variables
     D WSFRN1          S              5P 0
     D WSFRN2          S              5P 0
     D WRecCnt         S              3P 0
     D WEoF            S              1A
     D WTrnKey         S              1A

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
     C                             OR PSFACT = '*ENQUIRY'

     C                   IF        WTrnKey = 'B'

     C                   DOU       F11 = *OFF

     C                   EXSR      SRBldSf1

      ** Switch to the Front Office ID subfile on F11.

     C                   IF        F11 = *ON
     C                   EXSR      SRBldSf2
     C                   ENDIF

     C                   ENDDO

     C                   ELSE

     C                   DOU       F11 = *OFF

     C                   EXSR      SRBldSf2

      ** Switch to the Joint A/c Member subfile on F11.

     C                   IF        F11 = *ON
     C                   EXSR      SRBldSf1
     C                   ENDIF

     C                   ENDDO

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
      *  SRBldSf1 - Builds the Joint A/c Number subfile.              *
      *                                                               *
      *****************************************************************
     C     SRBldSf1      BEGSR

      ** Initialise relevant variables.

     C                   EVAL      WTrnKey = 'B'
     C                   EVAL      DDSFRN = *ZERO
     C                   EVAL      WSFRN1 = *ZERO
     C                   EVAL      SFLDSP = *ON
     C                   EVAL      SFLEND = *OFF
     C                   EVAL      *IN10 = *OFF

      ** Clear the subfile.

     C                   EXSR      SRClrSfl

      ** Set the file pointer.

     C                   IF        DDKJAN <> *BLANKS
     C                   EVAL      KCust = DDKJAN
     C     KCust         SETLL     SDACUSL1
     C                   ELSE
     C     *LOVAL        SETLL     SDACUSL1
     C                   ENDIF

      ** Build the subfile pages.

     C                   EXSR      SRBSfPg1

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRBSfPg1 - Builds Joint A/c Number subfile pages.            *
      *                                                               *
      *****************************************************************
     C     SRBSfPg1      BEGSR

     C                   EVAL      ROLLUP = *ON

     C                   DOW       ROLLUP = *ON

      ** Read a Joint A/c Member.

     C                   EXSR      SRRdJAcM

     C                   EVAL      WRecCnt = *ZERO

     C                   DOW       WEoF <> 'Y'

     C                   EVAL      WSFRN1 = DDSFRN
     C                   EVAL      WSFRN1 = WSFRN1 + 1
     C                   EVAL      WRecCnt = WRecCnt + 1

     C                   EVAL      *IN21 = *OFF
     C                   EVAL      DDACTN = *BLANK
     C                   EVAL      DDJANO = E5CUST
     C                   EVAL      DDCSSN = BBCSSN
     C                   EVAL      DDCRNM = BBCRNM
     C                   EVAL      DDCRTN = BBCRTN
     C                   EVAL      DDSFRN = WSFRN1
     C                   WRITE     SDJACM1S1

      ** Leave if one subfile page has been filled.

     C                   IF        WRecCnt = 14

      ** Check first if there are more records available.

     C                   EXSR      SRRdJAcM

     C                   IF        WEoF <> 'Y'
     C                   READP     SDACUSL1
     C                   ENDIF

     C                   LEAVE
     C                   ENDIF

     C                   EXSR      SRRdJAcM
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

     C                   ENDSL

     C                   ENDDO

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRBldSf2 - Builds the subfile by Front Office ID.            *
      *                                                               *
      *****************************************************************
     C     SRBldSf2      BEGSR

      ** Initialise relevant variables.

     C                   EVAL      WTrnKey = 'F'
     C                   EVAL      DDSFRN = *ZERO
     C                   EVAL      WSFRN2 = *ZERO
     C                   EVAL      SFLDSP = *ON
     C                   EVAL      SFLEND = *OFF
     C                   EVAL      *IN10 = *ON

      ** Clear the subfile.

     C                   EXSR      SRClrSfl

      ** Set the file pointer.

     C                   IF        DDKFRN <> *BLANKS
     C                   EVAL      KFrnt = DDKFRN
     C     KFrnt         SETLL     SDACUSL2
     C                   ELSE
     C     *LOVAL        SETLL     SDACUSL2
     C                   ENDIF

      ** Build the subfile pages.

     C                   EXSR      SRBSfPg2

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRBSfPg2 - Builds Front Office ID subfile pages.             *
      *                                                               *
      *****************************************************************
     C     SRBSfPg2      BEGSR

     C                   EVAL      ROLLUP = *ON

     C                   DOW       ROLLUP = *ON

      ** Read a Joint A/c Member.

     C                   EXSR      SRRdJAcM

     C                   EVAL      WRecCnt = *ZERO

     C                   DOW       WEoF <> 'Y'

     C                   EVAL      WSFRN2 = DDSFRN
     C                   EVAL      WSFRN2 = WSFRN2 + 1
     C                   EVAL      WRecCnt = WRecCnt + 1

     C                   EVAL      *IN21 = *OFF
     C                   EVAL      DDACTN = *BLANK
     C                   EVAL      DDJANO = E5CUST
     C                   EVAL      DDFRNT = E5FRNT
     C                   EVAL      DDCSSN = BBCSSN
     C                   EVAL      DDCRNM = BBCRNM
     C                   EVAL      DDCRTN = BBCRTN
     C                   EVAL      DDSFRN = WSFRN2
     C                   WRITE     SDJACM1S2

      ** Leave if one subfile page has been filled.

     C                   IF        WRecCnt = 14

      ** Check first if there are more records available.

     C                   EXSR      SRRdJAcM

     C                   IF        WEoF <> 'Y'
     C                   READP     SDACUSL2
     C                   ENDIF

     C                   LEAVE
     C                   ENDIF

     C                   EXSR      SRRdJAcM
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

     C                   WRITE     SDJACM1F1
     C                   WRITE     SDJACM1C3
     C                   WRITE     SDJACM1F2

     C                   IF        WTrnKey = 'B'
     C                   WRITE     SDJACM1C1
     C                   READ      SDJACM1C1
     C                   ELSE
     C                   WRITE     SDJACM1C2
     C                   READ      SDJACM1C2
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

     C                   IF        WTrnKey = 'B'
     C                   WRITE     SDJACM1C1
     C                   ELSE
     C                   WRITE     SDJACM1C2
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

     C                   IF        WTrnKey = 'B'
     C                   EVAL      DDKJAN = *BLANKS
     C                   EVAL      WSFRN1 = *ZERO
     C                   ELSE
     C                   EVAL      DDKFRN = *BLANKS
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
     C                   EVAL      PDACTD = *BLANK

     C                   IF        WTrnKey = 'B'
     C**********         READC     SDJACM1S1                                                  243024
     C                   READC     SDJACM1S1                              99                  243024
     C                   ELSE
     C**********         READC     SDJACM1S2                                                  243024
     C                   READC     SDJACM1S2                              99                  243024
     C                   ENDIF

     C                   IF        NOT %EOF

      ** Return the Action Code & Joint A/c Number.

     C                   IF        DDACTN = 'A'

     C                   EVAL      KJANo = DDJANO
     C     KJANo         CHAIN     SDJACCL1

      ** Change Action Code to 'I' if necessary.

     C                   IF        NOT %FOUND
     C                   EVAL      POPSEL = 'I'
     C                   EVAL      PDACTD = 'Y'
     C                   ELSE
     C                   EVAL      POPSEL = 'A'
     C                   ENDIF

     C                   ELSE
     C                   EVAL      POPSEL = DDACTN
     C                   ENDIF

     C                   EVAL      PJASEL = DDJANO
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

     C                   EVAL      *IN21 = *OFF

     C                   IF        OKACTN = 'N'
     C                   EVAL      *IN21 = *ON
     C                   ENDIF

     C                   EVAL      SFLNXTCHG = *ON

     C                   IF        WTrnKey = 'B'
     C                   UPDATE    SDJACM1S1
     C                   ELSE
     C                   UPDATE    SDJACM1S2
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

     C                   IF        WTrnKey = 'B'
     C                   EXSR      SRBSfPg1
     C                   ELSE
     C                   EXSR      SRBSfPg2
     C                   ENDIF

     C                   ENDIF

     C                   SELECT

     C                   WHEN      F03 = *ON
     C                   EVAL      PINKC = *ON
     C                   RETURN

     C                   WHEN      F05 = *ON
     C                   EVAL      PINKE = *ON
     C                   RETURN

      ** Force the subfile to build itself on F11.

     C                   WHEN      F11 = *ON

     C                   EVAL      PSFACT = '*BUILD  '

     C                   IF        WTrnKey = 'B'
     C                   EVAL      WTrnKey = 'F'
     C                   ELSE
     C                   EVAL      WTrnKey = 'B'
     C                   ENDIF

     C                   OTHER
     C                   RETURN

     C                   ENDSL

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRdJAcM - Reads a Joint Account Member.                     *
      *                                                               *
      *****************************************************************
     C     SRRdJAcM      BEGSR

     C                   EVAL      WEoF = 'N'
     C                   EVAL      SFLEND = *OFF

     C                   IF        WTrnKey = 'B'
     C                   READ      SDACUSL1
     C                   ELSE
     C                   READ      SDACUSL2
     C                   ENDIF

     C                   DOW       NOT %EOF

     C                   EVAL      PZErr = *ZERO

     C                   IF        BJSBRC <> *BLANKS
     C                   CALL      'ZVACTU'
     C                   PARM      'E'           PZActn
     C                   PARM                    PZErr
     C                   ENDIF

     C                   IF        E5JATP = 'Y' AND
     C                             PZErr = *ZERO
     C                             AND CGL132 = 'N'                                           CGL132
     C                             OR PZErr = *ZERO                                           CGL132
     C                             AND CGL132 = 'Y'                                           CGL132
     C                   EVAL      KCust = E5CUST
     C     KCust         CHAIN     SDCUSTL1
     C                   LEAVESR
     C                   ENDIF

     C                   IF        WTrnKey = 'B'
     C                   READ      SDACUSL1
     C                   ELSE
     C                   READ      SDACUSL2
     C                   ENDIF

     C                   ENDDO

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
      *  SRInit - Handles initial processing.                         *
      *                                                               *
      *****************************************************************
     C     SRInit        BEGSR

     C                   EVAL      F03 = *OFF
     C                   EVAL      F05 = *OFF
     C                   EVAL      F11 = *OFF

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

      ** Error Fields/Message IDs/Message Data (arrays) From/To Caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr

      ** Array Index (3P0) From/To Caller
     C                   PARM                    Ix

      ***********************
      ** Output Parameters **
      ***********************

      ** Option Selected
     C                   PARM                    POPSEL

      ** Joint A/c Number Selected
     C                   PARM                    PJASEL

      ** Action Code Default
     C                   PARM                    PDACTD

      ** Command Keys
     C                   PARM                    PINKC
     C                   PARM                    PINKE

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

     C                   EVAL      SFLDSP = *ON
     C                   EVAL      SFLMSGEND = *ON

      ** Start with the Joint A/c subfile.

     C                   EVAL      WTrnKey = 'B'

      ** Cater Enquiry Mode Processing.

     C                   IF        PSFACT = '*ENQUIRY'
     C                   EVAL      ENQMODE = *ON
     C                   EVAL      PSFACT = '*BUILD'
     C                   ENDIF
                                                                                              CGL132
      ** Check if CGL132 is ON                                                                CGL132
                                                                                              CGL132
     C                   CALL      'AOSARDR0'                                                 CGL132
     C                   PARM      *BLANKS       PRTCD                                        CGL132
     C                   PARM      '*VERIFY'     POPTN                                        CGL132
     C                   PARM      'CGL132'      PSARD                                        CGL132
     C     SCSARD        PARM      SCSARD        DSFDY                                        CGL132
                                                                                              CGL132
     C                   IF        PRTCD <> *BLANKS                                           CGL132
     C                             AND PRTCD <> '*NRF   '                                   MD026477
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CGL132
     C                   MOVEL     '901'         DBASE                                        CGL132
     C                   MOVEL     PSARD         DBKEY                                        CGL132
     C                   EXSR      *PSSR                                                      CGL132
     C                   ELSE                                                                 CGL132
     C                   IF        PRTCD = '*NRF   '                                        MD026708
     C                   EVAL      CGL132 = 'N'                                             MD026708
     C                   ELSE                                                               MD026708
     C                   EVAL      CGL132 = 'Y'                                               CGL132
     C                   ENDIF                                                              MD026708
     C                   ENDIF                                                                CGL132

      **---------------------------------------------------------------
      ** Message Handler Fixed Data
     D/COPY SDCPYSRC,MSGHNDDATA
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
