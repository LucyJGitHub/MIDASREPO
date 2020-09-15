     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2016')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL CRS Reports Management Header/FI')            *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GL000762 - Midas GL CRS Reports Management Header/FI         *
      *                                                               *
      *  (c) Finastra International Limited 2016                      *
      *                                                               *
      *  Last Amend No. MD054905           Date 04Dec19               *
      *  Prev Amend No. MD040841           Date 26Aug16               *
      *                 CGL177  *CREATE    Date 11Jan16               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD054905 - Change Message Ref Id format                      *
      *  MD040841 - CRS Reports Screenflow for Actions Exclude, Cor-  *
      *             rect and Include should be adjusted               *
      *  CGL177 - CRS Reporting Phase 2                               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  *INZSR       - Initialise                                    *
      *  *PSSR        - Error processing                              *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

      ** CRS Message Header and Reporting FI
     FGL000762DFCF   E             WORKSTN

      ** Midas GL Reports Management
     FGLCRMDL2  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(GLCRMDD0:GLCRMD02)
     FGLCRMDL0  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(GLCRMDD0:GLCRMD00)

      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+

     D/COPY ZACPYSRC,STD_D_SPEC

     D/COPY ZACPYSRC,PSDS

      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs: Arrays and Data Structures  ¦
      ** ¦ =======  ==========================  ¦
      ** +--------------------------------------+

      ** Data Structures used by Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)

      ** ** Short Data Structure

     D DSFDY         E DS                  EXTNAME(DSFDY)

      ** Customer/Non-Account Holder Inclusion Array
     D ArIncCsNhO      S            278A   DIM(50)
     D ArIncCsNhI      S            278A   DIM(50)

      ** Output Array for Excluded/Amended/Corrected Records
     D ArAcctDetExOut  S            341A   DIM(50)
     D ArAcctDetAmOut  S             83A   DIM(50)

      ** +--------------------------------------+
      ** ¦ D-specs: Declared variables          ¦
      ** ¦ =======  ==================          ¦
      ** +--------------------------------------+

     D***KMsgRID         S             21A                                                  MD054905
     D KMsgRID         S             29A                                                    MD054905
     D KTopElm         S             40A

      ** Parameter  entry
     D PActMode        S              1A
     D***PMsgRId         S             21A                                                  MD054905
     D PMsgRId         S             29A                                                    MD054905
     D PDDocTp         S              7A
     D PDDocRf         S             30A
     D PDCorRf         S             30A
     D PDRtyp          S             18A
     D PDRyer          S              4A
     D PFuncKey        S              3A
     D PExitInd        S              1A
     D PCancel         S              1A
     D PRCancel        S              1A

      ** Parameter out for Reporting FI selection
     D POutDOCRF       S             35A

     D InitScreen      S              1A   INZ(*OFF)
     D Leave           S              1A   INZ('N')
     D LeaveFI         S              1A   INZ('N')

      ** Parameters GL000663
     D***PMsgRIdOut      S             21A                                                  MD054905
     D PMsgRIdOut      S             29A                                                    MD054905

      ** Parameters AOBANKR0
     D POptn           S              7A
     D PRtcd           S              7A

      ** Parameter For ZA0350
     D PMsgFile        S             10A   INZ('GBSDUSRMSG')
     D PMsgId          S             10A
     D PMsgData        S             45A

     D WIdx            S              3P 0
     D FinalAddress    S            200A
     D WSlash          S              5U 0
     D WTrim           S              5U 0


      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+

      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ *INZSR is executed at program activation.                  ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+

      *****************************************************************
      *                                                               *
      * MAIN PROCEDURE                                                *
      *                                                               *
      *****************************************************************

     C                   EVAL      PExitInd = 'N'
     C                   EVAL      InitScreen = *ON
     C                   EVAL      Leave = 'N'
     C                   EVAL      LeaveFI = 'N'
     C                   CALL      'ZA0250'
     C                   EVAL      WIdx = 0

      ** Display the Screen Until F3 Is Pressed

     C                   DOW       (*IN03 = *OFF)

     C                   SELECT

     C                   WHEN      PFuncKey = 'F12'
     C                             OR InitScreen = *ON
     C                   EVAL      PFuncKey = ' '
     C                   EXSR      SrMHRFI

     C                   IF        *IN03 = *ON OR *IN12 = *ON
     C                   IF        *IN03 = *ON
     C                   EVAL      PExitInd = 'Y'
     C                   IF        PActMode = 'O'                                           MD040841
     C                             OR PActMode = 'C'                                        MD040841
     C                             OR PActMode = 'I'                                        MD040841
     C                   EVAL      PExitInd = 'N'                                           MD040841
     C                   ENDIF                                                              MD040841
     C                   ENDIF
     C                   IF        *IN12 = *ON
     C                   EVAL      PCancel = 'Y'
     C                   ENDIF

     C                   EVAL      PRCancel = ' '
     C                   IF        *IN12 = *ON
     C                             AND PActMode = 'R'
     C                   EVAL      PRCancel = 'Y'
     C                   ENDIF
     C                   LEAVE
     C                   ENDIF
     C                   IF        PFuncKey = ' ' AND *IN03 = *OFF
     C                   LEAVE
     C                   ENDIF

     C                   EVAL      *IN03 = *OFF
     C                   EVAL      *IN12 = *OFF

     C                   IF        PFuncKey = *BLANKS
     C                   EVAL      InitScreen = *ON
     C                   ELSE
     C                   EVAL      InitScreen = *OFF
     C                   ENDIF

     C                   WHEN      PFuncKey = 'F20'
     C                   CALL      'GL000763'
     C                   PARM                    PActMode
     C                   PARM                    PMsgRId
     C                   PARM                    PDRtyp
     C                   PARM                    PDRyer
     C                   PARM                    DDOCTP
     C                   PARM                    DDOCRF
     C                   PARM                    DCORRF
     C                   PARM                    PFuncKey
     C                   PARM                    ArAcctDetExOut
     C                   PARM                    ArAcctDetAmOut

     C                   WHEN      PFuncKey = 'F22'
     C                   CALL      'GL000765'
     C                   PARM                    PActMode
     C                   PARM                    PMsgRId
     C                   PARM                    DDOCTP
     C                   PARM                    PDRtyp
     C                   PARM                    PDRyer
     C                   PARM                    PFuncKey
     C                   PARM                    ArIncCsNhO

     C                   EVAL      ArIncCsNhI = ArIncCsNhO
     C                   ENDSL

     C                   IF        PFuncKey = 'F3 '
     C                   EVAL      PExitInd = 'Y'
     C                   IF        PActMode = 'O'                                           MD040841
     C                             OR PActMode = 'C'                                        MD040841
     C                             OR PActMode = 'I'                                        MD040841
     C                   EVAL      PExitInd = 'N'                                           MD040841
     C                   EVAL      PCancel = 'N'                                            MD040841
     C                   ENDIF                                                              MD040841
     C                   EVAL      *IN03 = *ON
     C                   ENDIF

     C                   ENDDO

     C                   EVAL      *INLR = *ON
     C                   RETURN

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrMHRFI - Message Header and Reporting FI processing          *
      *                                                               *
      *****************************************************************

     C     SrMHRFI       BEGSR

      ** Retrieve 'CRS Schema Version'

     C                   EVAL      KMsgRID = PMsgRId
     C                   EVAL      KTopElm = 'Root'

     C     KeyOECD       SETLL     GLCRMDL0
     C     KeyOECD       READE     GLCRMDL0
     C
     C                   IF        MGELMT = 'CRS_OECD'
     C                   EVAL      DFOECD = MGDATA
     C                   ENDIF

      ** Report Message Header

     C     PMsgRId       SETLL     GLCRMDL2
     C     PMsgRId       READE     GLCRMDL2
     C                   DOW       NOT %EOF(GLCRMDL2) AND
     C                             Leave = 'N'

     C                   SELECT

     C                   WHEN      MGELMT = 'SendingCompanyIN'
     C                   EVAL      DSNDCI = MGDATA

     C                   WHEN      MGELMT = 'TransmittingCountry'
     C                   EVAL      DTRANC = MGDATA

     C                   WHEN      MGELMT = 'ReceivingCountry'
     C                   EVAL      DRECVC = MGDATA

     C                   WHEN      MGELMT = 'MessageType'
     C                   EVAL      DMSGTP = MGDATA

     C                   WHEN      MGELMT = 'Warning'
     C                   EVAL      DWARNM = MGDATA

     C                   WHEN      MGELMT = 'MessageRefId'
     C                   EVAL      DMRFID = MGDATA

     C                   WHEN      MGELMT = 'CorrMessageRefID'
     C                   EVAL      DCMRID = MGDATA

     C                   WHEN      MGELMT = 'ReportingPeriod'
     C                   EVAL      DRPTPD = MGDATA

     C                   WHEN      MGELMT = 'Timestamp'
     C                   EVAL      DTSTMP = MGDATA
     C                   EVAL      Leave  = 'Y'

     C                   ENDSL

     C     PMsgRId       READE     GLCRMDL2

     C                   ENDDO

      ** Reporting Financial Institution

     C     PMsgRId       SETLL     GLCRMDL2
     C     PMsgRId       READE     GLCRMDL2
     C                   DOW       NOT %EOF(GLCRMDL2) AND
     C                             LeaveFI = 'N'

     C                   SELECT

     C                   WHEN      MGELMT = 'IN'
     C                             AND MGTPMT = 'ReportingFI'
     C                   EVAL      DTINNO = MGDATA
     C                   EVAL      DTINIB = MGDAT2

     C                   WHEN      MGELMT = 'ResCountryCode'
     C                             AND MGTPMT = 'ReportingFI'
     C                   EVAL      DRESCD = MGDATA

     C                   WHEN      MGELMT = 'Name'
     C                             AND MGTPMT = 'ReportingFI'
     C                   EVAL      DCNAME = MGDATA

     C                   WHEN      MGELMT = 'AddressFree'
     C                             AND MGTPMT = 'ReportingFI'
     C                   EVAL      FinalAddress = %TRIM(MGDATA)
     C                   EVAL      WSlash = %SCAN('/':FinalAddress)
     C                   EVAL      WSlash = WSlash + 1
     C                   EVAL      WTrim = %SCAN('/':FinalAddress:WSlash)
     C                   EVAL      DADDR1 = %SUBST(FinalAddress:1:WTrim)
     C                   EVAL      DADDR1 = %TRIM(DADDR1)
     C                   EVAL      WTrim = WTrim + 1
     C                   EVAL      DADDR2 = %SUBST(FinalAddress:WTrim:60)
     C                   EVAL      DADDR2 = %TRIM(DADDR2)

     C                   WHEN      MGELMT = 'DocTypeIndic'
     C                             AND MGTPMT = 'ReportingFI'
     C                   EVAL      DDOCTP = MGDATA
     C                   EVAL      DDACTC = PActMode
     C                   EVAL      DDRTYP = PDRtyp
     C                   EVAL      DDRYER = PDRyer

     C                   WHEN      MGELMT = 'DocRefId'
     C                             AND MGTPMT = 'ReportingFI'
     C                   EVAL      DDOCRF = MGDATA

     C                   WHEN      MGELMT = 'CorrDocRefId'
     C                             AND MGTPMT = 'ReportingFI'
     C                   EVAL      DCORRF = MGDATA
     C                   EVAL      LeaveFI  = 'Y'

     C                   ENDSL

     C     PMsgRId       READE     GLCRMDL2

     C                   ENDDO

     C                   EVAL      *IN90 = *OFF

     C                   IF        PActMode = 'C'
     C                   EVAL      *IN90 = *ON
     C                   ENDIF

     C     ReDisplay     TAG

     C                   EVAL      *IN41 = *ON
     C                   WRITE     GL000762C0
     C                   EVAL      *IN41 = *OFF

     C                   CALL      'ZA0250'

     C                   WRITE     GL000762F1
     C                   EXFMT     GL000762F0

     C                   IF        PActMode = 'C'
     C                   EXSR      SrReptFIChk
     C                   ENDIF

      ** If Reporting FI was selected for update

     C                   IF        DCRFIS = '1'
     C                   IF        *IN03 = *OFF
     C                             AND *IN12 = *OFF
     C                             AND *IN20 = *OFF
     C                             AND *IN22 = *OFF
     C                   EXSR      SrReptFIUpd
     C                   IF        *IN12 = *ON
     C                   GOTO      ReDisplay
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF

      ** If Reports Management is for Re-Create, Delete or Approve

     C                   IF        PActMode = 'R'
     C                             OR PActMode = 'D'
     C                             OR PActMode = 'X'
     C                             OR PActMode = 'I'
     C                             AND PDRtyp = 'DRAFT NEW'
     C                   EVAL      PCancel = 'Y'
     C                   IF        *IN03 = *OFF
     C                             AND *IN12 = *OFF
     C                             AND *IN20 = *OFF
     C                             AND *IN22 = *OFF
     C                   EVAL      PCancel = 'Y'
     C                   EXSR      SrRCDLAP
     C                   IF        *IN12 = *ON
     C                   GOTO      ReDisplay
     C                   ENDIF
     C                   ENDIF

     C                   ENDIF

     C                   IF        *INKC = *ON
     C                   EVAL      *INLR = *ON
     C                   ENDIF

     C                   IF        *IN20 = *ON
     C                   EVAL      PFuncKey = 'F20'
     C                   ENDIF

     C                   IF        *IN22 = *ON
     C                   EVAL      PFuncKey = 'F22'
     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrReptFIChk - Checking of Report FI selection                *
      *                                                               *
      *****************************************************************

     C     SrReptFIChk   BEGSR

     C     RFIS          TAG
     C                   EVAL      WIdx = 0
     C                   IF        DCRFIS <> '1'
     C                             AND DCRFIS <> ' '
     C                   EVAL      PMsgId = 'USR9358'
     C                   EVAL      WIdx = WIdx + 1
     C                   EXSR      SRErrDta

     C                   IF        WIdx > *ZEROS
     C                   EVAL      *IN40 = *ON
     C                   WRITE     GL000762C0
     C                   EXFMT     GL000762F0
     C                   CALL      'ZA0250'

     C                   IF        *IN03 = *OFF
     C                             AND *IN12 = *OFF
     C                   GOTO      RFIS
     C                   ENDIF

     C                   ENDIF

     C                   ELSE

     C                   CALL      'ZA0250'
     C                   EVAL      *IN41 = *ON
     C                   WRITE     GL000762C0
     C                   EVAL      *IN41 = *OFF

     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrReptFIUpd - Report FI section for update                   *
      *                                                               *
      *****************************************************************

     C     SrReptFIUpd   BEGSR

     C                   EVAL      WIdx = 0
     C                   EVAL      PMsgId = 'USS0519'
     C                   EVAL      WIdx = WIdx + 1
     C                   EXSR      SRErrDta

     C                   IF        WIdx > *ZEROS
     C                   EVAL      *IN40 = *ON
     C                   WRITE     GL000762C0
     C                   EXFMT     GL000762F0
     C                   CALL      'ZA0250'

     C                   ELSE

     C                   CALL      'ZA0250'
     C                   EVAL      *IN41 = *ON
     C                   WRITE     GL000762C0
     C                   EVAL      *IN41 = *OFF
     C                   ENDIF

     C                   IF        *IN03 = *OFF
     C                             AND *IN12 = *OFF
     C                   EVAL      POutDOCRF = DDOCRF
     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrRCDLAP - Reports Management for Recreate, Delete or Approve*
      *                                                               *
      *****************************************************************

     C     SrRCDLAP      BEGSR

     C                   EVAL      WIdx = 0

     C                   SELECT
     C                   WHEN      PActMode = 'I'
     C                             AND PDRtyp = 'DRAFT NEW'
     C                   EVAL      PMsgId = 'USS0519'
     C                   WHEN      PActMode = 'R'
     C                   EVAL      PMsgId = 'USS0519'
     C                   WHEN      PActMode = 'D'
     C                   EVAL      PMsgId = 'USS0529'
     C                   WHEN      PActMode = 'X'
     C                   EVAL      PMsgId = 'USS0530'
     C                   ENDSL

     C                   EVAL      WIdx = WIdx + 1
     C                   EXSR      SRErrDta

     C                   EVAL      *IN40 = *ON
     C                   WRITE     GL000762C0
     C                   EXFMT     GL000762F0
     C                   CALL      'ZA0250'

     C                   IF        *IN03 = *OFF
     C                             AND *IN12 = *OFF
     C                             AND *IN20 = *OFF
     C                             AND *IN22 = *OFF
     C                   EVAL      PCancel = 'N'
     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRErrDta - Output Error Message with data                    *
      *                                                               *
      *****************************************************************
     C     SRErrDta      BEGSR

     C                   CALL      'ZA0350'
     C                   PARM                    PMsgFile
     C                   PARM                    PMsgId
     C                   PARM                    PMsgData

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Access Bank file to set system date, time, job       *
      *          and user in the screen header                        *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR

     C     *ENTRY        PLIST
     C                   PARM                    PActMode
     C                   PARM                    PMsgRId
     C                   PARM                    PDRtyp
     C                   PARM                    PDRyer
     C                   PARM                    ArAcctDetExOut
     C                   PARM                    ArAcctDetAmOut
     C                   PARM                    ArIncCsNhI
     C                   PARM                    PExitInd
     C                   PARM                    PCancel
     C                   PARM                    POutDOCRF
     C                   PARM                    PRCancel

     C                   EVAL      DDPGMQ = '*'
     C                   EVAL      DDUSER = PSUser
     C                   EVAL      DDWID = PSJobName

     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY

     C                   IF        PRtcd <> *Blanks
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBKEY = POPTN
     C                   EVAL      DBASE = 001
     C                   EXSR      *PSSR
     C                   OUT       LDA
     C                   ENDIF

     C     KeyOECD       KLIST
     C                   KFLD                    KMsgRID
     C                   KFLD                    KTopElm

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************

     C/COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
