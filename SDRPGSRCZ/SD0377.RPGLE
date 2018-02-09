     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Withholding Tax Treaty Maintenance')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD0377 - Withholding Tax Treaty Maintenance                  *
      *                                                               *
      *  Function:  This program maintains the Withholding Tax Treaty *
      *             Details                                           *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Prev Amend No. CRE026             Date 24May06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 BUG3644            Date 12Jul04               *
      *                 CGP001             Date 18Dec03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CSE023  *CREATE    Date 12Jul00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CRE026 - Consumer Banking (Recompile)                        *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG3644 - Serious Error in Collateralised Lending (Recompile)*
      *  CGP001 - Global Processing (Recompile)                       *
      *  CSE023 - Treaty Withholding Tax                              *
      *                                                               *
      *****************************************************************
      /EJECT
     FSDWHTTL0  UF A E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
     FSDFCTLL0  UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
     FSDWHTTL4  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SDWHTTD0:SDWHTTD4)
     FSDTXBSL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SDTXBSD0:SDTXBSD1)
     FSDEXEML1  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SDEXEMD0:SDEXEMD1)
     FINVTPL0   IF   E           K DISK    INFSR(*PSSR)
     FSD0377DF  CF   E             WORKSTN INFSR(*PSSR)
     F                                     INFDS(DSP1DS)
     F                                     SFILE(SD0377S0:RRN)
      *
      *****************************************************************
      *                                                               *
      *  F U N C T I O N   O F   I N D I C A T O R S                  *
      *                                                               *
      *  40 - Chain no find on PF/SDWHTTPD                            *
      *  41 - End of File for READC                                   *
      *  42 - Chain no find                                           *
      *                                                               *
      *  50 - Global Error indicator                                  *
      *  51 - Error in Action Code                                    *
      *  52 - Error in Country of Tax Treaty                          *
      *  53 - Error in Investment Type                                *
      *  54 - Error in Default basket for no documentation            *
      *  55 - Error in Default basket for backup withholding          *
      *  56 - Error in Deduct tax                                     *
      *  57 - Error in Allocation Days                                *
      *  58 - Error in Default exemption Code for Portfolio Interest  *
      *  59 - Error in Action Code for Subfile                        *
      *                                                               *
      *  60 - Error in Country of Residence                           *
      *  61 - Error in Tax basket                                     *
      *  62 - Error in Exemption Code                                 *
      *  63 - Protect Fields for Initial Screen                       *
      *  64 - Protect fields for Subheader                            *
      *  65 - Enquiry Mode for Subfile                                *
      *  66 - No Display for S1SEL                                    *
      *  67 - Protect Country of Residence                            *
      *  68 - Error in Default Basket for Portfolio Exemption         *
      *                                                               *
      *  70 - Subfile Display                                         *
      *  71 - Subfile Display Control                                 *
      *  72 - Subfile End                                             *
      *  73 - Subfile next Change                                     *
      *                                                               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E   I N D E X                              *
      *                                                               *
      *  SRAmend      - Process for Amend Mode                        *
      *  SRBuildE     - Build Empty Subfile                           *
      *  SRBuildSubF  - ReBuild Subfile Details                       *
      *  SRDelete     - Process for Delete Mode                       *
      *  SRDelRec     - Process to Delete all records                 *
      *  SREnquire    - Process for Enquire Mode                      *
      *  SRInsAdd     - Process to Add Records                        *
      *  SRInsert     - Process for Insert Mode                       *
      *  SRInsNew     - Process to Insert New Record                  *
      *  SRLoadSubH   - Load Subheader and Subfile                    *
      *  SRProDel     - Process to Delete chosen recod                *
      *  SRTrailer    - Update File Controls                          *
      *  SRUpdate     - Update Records for Amend                      *
      *  SRUpdSHdr    - Update Details for Sub-header only            *
      *  SRValActCode - Validate Action Code                          *
      *  SRValCtryTax - Validate Country of Tax Treaty                *
      *  SRValInvType - Validate Investment Type                      *
      *  SRValFlds    - Validate Subfile Details                      *
      *  SRValSubF    - Process to validate Subfile Details           *
      *  SRValSubHdr  - Validate Subheader Details                    *
      *  SRWrite      - Write Details to file                         *
      *                                                               *
      *  *PSSR  - Program exception error routine                     *
      *  SRErrMsg - Display error messages                            *
      *                                                               *
      *****************************************************************
      /EJECT
      /COPY ZACPYSRC,STD_D_SPEC
      /COPY ZACPYSRC,PSDS
      *
     D DSP1DS          DS
      ** File Information Data Structure for SD0377DF
      *
     D  RRN1                 378    379B 0
      *
     D PrvDtls         DS
     D  PrvDBDC                       2
     D  PrvDRBW                       2
     D  PrvDTSU                       1
     D  PrvALDY                       2
     D  PrvEXPI                       2
     D  PrvPFEX                       2
      *
     D CurDtls         DS
     D  CurDBDC                       2
     D  CurDRBW                       2
     D  CurDTSU                       1
     D  CurALDY                       2
     D  CurEXPI                       2
     D  CurPFEX                       2
      *
     D ValFlds         DS             6
     D  SCRRS
     D  STXBS
     D  SEXCD
      *
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
      ** Data Area giving Installation Control Details
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** Bank Details
      *
     D SDCTRY        E DS                  EXTNAME(SDCTRYPD)
      ** Country Codes
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** DS for access programs, Long data structure
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** DS for access programs, Short data structure
      *
     D ZAlignOk        S              1
     D ZField          S             16
     D ZADEC           S              1P 0
     D ZADIG           S              2P 0
 
      /EJECT
      *****************************************************************
      *                                                               *
      *  Main Processing                                              *
      *                                                               *
      *  Called by: None                                              *
      *                                                               *
      *  Calls:     SRValActCode, SRValCtryTax, SRValInvType,         *
      *             SRInsert, SRAmend, SRDelete, SREnquire            *
      *                                                               *
      *****************************************************************
     C                   MOVEA     CPY@          BIS@             80
 
     C                   MOVE      BJMRDT        SRUNA
     C                   Z-ADD     1             RRN
 
     C                   DOW       *INKC = *Off
 
     C                   EVAL      *IN05 = *On
     C                   EVAL      *IN10 = *Off
     C                   EVAL      *IN12 = *Off
 
     C                   WRITE     SD0377F0
     C                   WRITE     #MSGCTL
     C                   WRITE     SD0377F3
     C                   EXFMT     SD0377F1
     C                   CALL      'ZA0250'
 
      ** If F5 is pressed
 
     C                   IF        *INKC = *Off
     C                   IF        *INKE = *On
     C                   MOVEA     '00000'       *IN(50)
     C                   CLEAR                   SD0377F1
     C                   ELSE
 
      ** Validate Input
 
     C                   MOVEA     '0000'        *IN(50)
     C                   EXSR      SRValActCode
     C                   EXSR      SRValCtryTax
     C                   EXSR      SRValInvType
 
      ** Process Action Code
 
     C                   IF        *IN50 = *Off
 
     C                   SELECT
     C                   WHEN      SACTN = 'I'
     C                   EXSR      SRInsert
     C                   WHEN      SACTN = 'A'
     C                   EXSR      SRAmend
     C                   WHEN      SACTN = 'D'
     C                   EXSR      SRDelete
     C                   WHEN      SACTN = 'E'
     C                   EXSR      SREnquire
     C                   ENDSL
 
     C                   MOVEA     '0000'        *IN(50)
     C                   EVAL      *IN63 = *Off
     C                   EVAL      *IN66 = *Off
     C                   CLEAR                   SD0377F1
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDDO
 
     C                   MOVE      *ON           *INLR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRInsert - Process for Insert Mode                           *
      *                                                               *
      *  Called by: Main Processing                                   *
      *                                                               *
      *  Calls:     SRInsNew, SRInsAdd                                *
      *                                                               *
      *****************************************************************
     C     SRInsert      BEGSR
 
 
     C                   EVAL      *IN05 = *On
     C                   EVAL      *IN10 = *Off
     C                   EVAL      *IN12 = *On
 
     C                   EVAL      KCRTT = SCRTT
     C                   EVAL      KINVT = SINVT
     C     Key1          CHAIN     SDWHTTD4                           40
 
      ** If record does not exist, display subheader first
 
     C                   DOW       *INKC = *Off
     C                   IF        *IN40 = *On or *INKL = *On
     C                   EXSR      SRInsNew
     C                   IF        *INKL = *On
     C                   LEAVE
     C                   ENDIF
     C                   ENDIF
 
      ** Display subheader with fields protected and Add record
 
     C                   IF        *IN50 = *Off
     C                   EXSR      SRInsAdd
     C                   ENDIF
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRInsNew - Process to Insert New Record                      *
      *                                                               *
      *  Called by: SRInsert                                          *
      *                                                               *
      *  Calls:     SRLoadSubH, SRValSubHdr                           *
      *                                                               *
      *****************************************************************
     C     SRInsNew      BEGSR
 
     C                   MOVEA     '10010'       *IN(63)
     C                   MOVE      '0'           *IN69
     C                   EXSR      SRLoadSubH
 
     C                   DOW       *INKC = *Off and *INKL = *Off
 
     C                   WRITE     SD0377F0
     C                   WRITE     #MSGCTL
     C                   WRITE     SD0377F1
     C                   WRITE     SD0377F3
     C                   EXFMT     SD0377C0
     C                   CALL      'ZA0250'
 
      ** If F5 is pressed
 
     C                   EVAL      *IN50 = *Off
     C                   IF        *INKE = *On
     C                   MOVEA     '000000000'   *IN(50)
     C                   EXSR      SRLoadSubH
     C                   ELSE
 
      ** Validate Fields
 
     C                   IF        *INKL = *Off
     C                   EXSR      SRValSubHdr
     C                   IF        *IN50 = *Off
     C                   MOVEA     '11'          *IN(63)
     C                   EVAL      *IN69 = *On
     C                   LEAVE
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRInsAdd - Process to Add Records                            *
      *                                                               *
      *  Called by: SRInsert                                          *
      *                                                               *
      *  Calls:     SRBuildE, SRValSubF                               *
      *                                                               *
      *****************************************************************
     C     SRInsAdd      BEGSR
 
     C                   EVAL      *IN50 = *Off
     C                   MOVEA     '11010'       *IN(63)
     C                   EVAL      *IN69 = *On
     C                   EXSR      SRBuildE
     C                   Z-ADD     1             RRN
 
     C                   IF        *IN40 = *Off
     C                   EVAL      SDBDC = WTDBDC
     C                   EVAL      SDRBW = WTDRBW
     C                   EVAL      SDTSU = WTDTSU
     C                   MOVE      WTALDY        SALDY
     C                   EVAL      SEXPI = WTEXPI
     C                   EVAL      SPFEX = WTPFEX
     C                   ENDIF
 
     C                   DOW       *INKC = *Off and *INKL = *Off
 
     C                   WRITE     SD0377F0
     C                   WRITE     #MSGCTL
     C                   WRITE     SD0377F1
     C                   WRITE     SD0377F3
     C                   EXFMT     SD0377C0
     C                   CALL      'ZA0250'
 
      ** If F5 is pressed, rebuild empty subfile
 
     C                   IF        *INKC = *Off
     C                   EVAL      *IN50 = *Off
     C                   IF        *INKE = *Off and *INKL = *Off
     C                   IF        RRN1 = 0
     C                   Z-ADD     1             RRN
     C                   ELSE
     C                   Z-ADD     RRN1          RRN
     C                   ENDIF
     C                   MOVEA     '0000000000'  *IN(50)
     C                   EXSR      SRValSubF
     C                   ENDIF
 
     C                   IF        *IN50 = *Off
     C                   COMMIT
     C                   EXSR      SRBuildE
     C                   Z-ADD     1             RRN
     C                   ELSE
     C                   ROLBK
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAmend - Process for Amend Mode                             *
      *                                                               *
      *  Called by: Main Processing                                   *
      *                                                               *
      *  Calls:     SRLoadSubH, SRValSubHdr, SRValSubF                *
      *                                                               *
      *****************************************************************
     C     SRAmend       BEGSR
 
     C                   EVAL      *IN05 = *On
     C                   EVAL      *IN10 = *Off
     C                   EVAL      *IN12 = *On
 
     C                   MOVEA     '00010011'    *IN(60)
     C                   MOVE      '1'           *IN69
     C                   EXSR      SRLoadSubH
     C                   Z-ADD     1             RRN
 
     C                   DOW       *INKC = *Off and *INKL = *Off
 
     C                   WRITE     SD0377F0
     C                   WRITE     #MSGCTL
     C                   WRITE     SD0377F1
     C                   WRITE     SD0377F3
     C                   EXFMT     SD0377C0
     C                   CALL      'ZA0250'
 
      ** If F5 is pressed
 
     C                   IF        *INKE = *On
     C                   MOVEA     '000000000'   *IN(50)
     C                   MOVEA     '000'         *IN(60)
     C                   EXSR      SRLoadSubH
     C                   Z-ADD     1             RRN
     C                   ELSE
 
      ** Validate Subfile
 
     C                   IF        *INKC = *Off and *INKL = *Off
     C                   IF        RRN1 = 0
     C                   Z-ADD     1             RRN
     C                   ELSE
     C                   Z-ADD     RRN1          RRN
     C                   ENDIF
 
     C                   EXSR      SRValSubHdr
     C                   EXSR      SRValSubF
 
      ** If no errors, rebuild subfile
 
     C                   IF        *IN50 = *Off
     C                   COMMIT
     C                   EXSR      SRLoadSubH
     C                   Z-ADD     1             RRN
     C                   ELSE
     C                   ROLBK
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRDelete - Process for Delete Mode                            *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls:     SRLoadSubH, SRDelRec, SRProDel                     *
      *                                                               *
      *****************************************************************
     C     SRDelete      BEGSR
 
     C                   EVAL      *IN05 = *Off
     C                   EVAL      *IN10 = *On
     C                   EVAL      *IN12 = *On
 
     C                   MOVEA     '111'         *IN(63)
     C                   EVAL      *IN69 = *Off
     C                   EXSR      SRLoadSubH
 
     C                   DOW       *INKC = *Off and *INKL = *Off
     C                   WRITE     SD0377F0
     C                   WRITE     #MSGCTL
     C                   WRITE     SD0377F1
     C                   WRITE     SD0377F3
     C                   EXFMT     SD0377C0
     C                   CALL      'ZA0250'
 
      ** If F10 is not pressed
 
     C                   IF        *INKC = *Off and *INKL = *Off
     C                   IF        *INKJ = *On
     C                   EXSR      SRDelRec
     C                   EVAL      *INKL = *On
     C                   ELSE
     C                   EXSR      SRProDel
     C                   ENDIF
     C                   ENDIF
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRLoadSubh - Process to Load subheader and subfile           *
      *                                                               *
      *  Called by: SRInsert, SRInsNew, SRAmend, SRDelete, SREnquire  *
      *                                                               *
      *                                                               *
      *  Calls:     None                                              *
      *                                                               *
      *****************************************************************
     C     SRLoadSubH    BEGSR
 
     C                   Z-ADD     1             RRN
     C                   MOVEA     '00'          *IN(70)
     C                   EVAL      *IN73 = *Off
     C                   WRITE     SD0377C0
     C                   MOVEA     '00000'       *IN(54)
     C                   MOVE      '0'           *IN68
 
     C                   EVAL      SDBDC = *Blanks
     C                   EVAL      SDRBW = *Blanks
     C                   EVAL      SDTSU = *Blanks
     C                   EVAL      SALDY = *Blanks
     C                   EVAL      SEXPI = *Blanks
     C                   EVAL      SPFEX = *Blanks
 
      ** Load Subheader details
 
     C                   EVAL      *IN50 = *Off
     C                   EVAL      *IN63 = *On
 
     C                   EVAL      KCRTT = SCRTT
     C                   EVAL      KINVT = SINVT
     C     Key1          SETLL     SDWHTTD4
     C     Key1          READE     SDWHTTD4                               72
 
     C                   IF        *IN72 = *Off
     C                   EVAL      SDBDC = WTDBDC
     C                   EVAL      SDRBW = WTDRBW
     C                   EVAL      SDTSU = WTDTSU
     C                   MOVE      WTALDY        SALDY
     C                   EVAL      SEXPI = WTEXPI
     C                   EVAL      SPFEX = WTPFEX
     C                   ENDIF
 
      ** Load Subfile
 
     C                   IF        SACTN <> 'D'
     C                   DOW       *IN72 = *Off
 
     C                   EVAL      SCRRS = WTCRRS
     C                   EVAL      STXBS = WTTXBS
     C                   EVAL      SEXCD = WTEXCD
     C                   WRITE     SD0377S0
     C                   Add       1             RRN
     C     Key1          READE     SDWHTTD4                               72
 
     C                   ENDDO
     C                   ENDIF
 
     C                   IF        RRN = 1
     C                   MOVEA     '01'          *IN(70)
     C                   ELSE
     C                   MOVEA     '11'          *IN(70)
     C                   ENDIF
 
     C                   EVAL      PrvDBDC = SDBDC
     C                   EVAL      PrvDRBW = SDRBW
     C                   EVAL      PrvDTSU = SDTSU
     C                   EVAL      PrvALDY = SALDY
     C                   EVAL      PrvEXPI = SEXPI
     C                   EVAL      PrvPFEX = SPFEX
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SREnquire - Process for Enquire Mode                         *
      *                                                               *
      *  Called by: Main Processing                                   *
      *                                                               *
      *  Calls:     SRLoadSubH                                        *
      *                                                               *
      *****************************************************************
     C     SREnquire     BEGSR
 
     C                   EVAL      *IN05 = *Off
     C                   EVAL      *IN10 = *Off
     C                   EVAL      *IN12 = *On
 
     C                   MOVEA     '11111'       *IN(63)
     c                   MOVE      '1'           *IN69
     C                   EXSR      SRLoadSubH
     C                   Z-ADD     1             RRN
 
     C                   DOW       *INKC = *Off and *INKL = *Off
     C                   WRITE     SD0377F0
     C                   WRITE     #MSGCTL
     C                   WRITE     SD0377F1
     C                   WRITE     SD0377F3
     C                   EXFMT     SD0377C0
     C                   CALL      'ZA0250'
 
     C                   IF        *INKC = *Off
     C                   IF        *INKL = *On
     C                   CLEAR                   SD0377F1
     C                   ENDIF
     C                   ENDIF
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValActCode - Validate Action Code                          *
      *                                                               *
      *  Called by: Main Processing                                   *
      *                                                               *
      *  Calls:     SRErrMsg                                          *
      *                                                               *
      *****************************************************************
     C     SRValActCode  BEGSR
 
     C                   IF        SACTN <> 'I' and SACTN <> 'A' and
     C                             SACTN <> 'D' and SACTN <> 'E'
     C                   MOVE      *ON           *IN50
     C                   MOVE      *ON           *IN51
     C                   MOVEL     'USR7665'     WZMsgID
     C                   EXSR      SRErrMsg
     C                   ENDIF
 
     C                   IF        PMODE = 'E' and SACTN <> 'E'
     C                   MOVE      *ON           *IN50
     C                   MOVE      *ON           *IN51
     C                   MOVEL     'USR7665'     WZMsgID
     C                   EXSR      SRErrMsg
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValCtryTax - Validate Country of Tax Treaty                *
      *                                                               *
      *  Called by: Main Processing                                   *
      *                                                               *
      *  Calls:     SRErrMsg                                          *
      *                                                               *
      *****************************************************************
     C     SRValCtryTax  BEGSR
 
      ** Country of Tax Treaty must be entered if Action Code is Entered
 
     C                   IF        *IN51 = *Off
     C                   IF        SCRTT = *Blanks
     C                   MOVE      *ON           *IN50
     C                   MOVE      *ON           *IN52
     C                   MOVEL     'USR7650'     WZMsgID
     C                   EXSR      SRErrMsg
 
     C                   ELSE
 
      ** Country of Tax Treaty must be valid
 
     C                   CALL      'AOCTRYR0'
     C                   PARM      *BLANKS       PRetCode          7
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      SCRTT         PCTRY             2
     C     SDCTRY        PARM      SDCTRY        DSSDY
 
     C                   IF        PRetCode <> *Blanks
     C                   MOVE      *ON           *IN50
     C                   MOVE      *ON           *IN52
     C                   MOVEL     'USR7651'     WZMsgID
     C                   EXSR      SRErrMsg
     C                   ELSE
     C                   MOVE      A4CNCD        SCRTT
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *   SRValInvType - Validate Investment Type                     *
      *                                                               *
      *   Called by: Main Processing                                  *
      *                                                               *
      *   Calls:     SRErrMsg                                         *
      *                                                               *
      *****************************************************************
     C     SRValInvType  BEGSR
 
     C                   IF        SINVT <> *Blanks
     C     SINVT         CHAIN     INVTPDF                            53
     C                   IF        *IN53 = *On
     C                   MOVE      *ON           *IN50
     C                   MOVEL     'USR7652'     WZMsgID
     C                   EXSR      SRErrMsg
     C                   ENDIF
     C                   ENDIF
 
      ** Check if record exist in file
 
     C                   IF        *IN51 = *Off and *IN52 = *Off
     C                   IF        SACTN='A' or SACTN='E' or SACTN='D'
     C                   EVAL      KCRTT = SCRTT
     C                   EVAL      KINVT = SINVT
     C     Key1          CHAIN     SDWHTTD4                           40
 
     C                   IF        *IN40 = *On
     C                   MOVEA     '1111'        *IN(50)
     C                   MOVEL     'USR7668'     WZMsgID
     C                   EXSR      SRErrMsg
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *   SRValSubHdr - Validate Subheader details                    *
      *                                                               *
      *   Called by: SRInsNew, SRAmend                                *
      *                                                               *
      *   Calls:     SRErrMsg                                         *
      *                                                               *
      *****************************************************************
     C     SRValSubHdr   BEGSR
 
     C                   MOVEA     '000000000'   *IN(50)
     C                   MOVE      '0'           *IN68
 
      ** Validate Default Basket for No documentation
 
     C                   IF        SDBDC = *Blanks
     C                   MOVE      *ON           *IN50
     C                   MOVE      *ON           *IN54
     C                   MOVEL     'USR7666'     WZMsgID
     C                   EXSR      SRErrMsg
     C                   ELSE
     C                   EVAL      KCRTT = SCRTT
     C                   EVAL      KTXBS = SDBDC
     C     Key2          CHAIN     SDTXBSD1                           42
 
     C                   IF        *IN42 = *On
     C                   MOVE      *ON           *IN50
     C                   MOVE      *ON           *IN54
     C                   MOVEL     'USR7656'     WZMsgID
     C                   EXSR      SRErrMsg
     C                   ENDIF
     C                   ENDIF
 
      ** Validate Default Basket for Backup Withholding
 
     C                   IF        SDRBW = *Blanks
     C                   MOVE      *ON           *IN50
     C                   MOVE      *ON           *IN55
     C                   MOVEL     'USR7667'     WZMsgID
     C                   EXSR      SRErrMsg
     C                   ELSE
     C                   EVAL      KCRTT = SCRTT
     C                   EVAL      KTXBS = SDRBW
     C     Key2          CHAIN     SDTXBSD1                           42
 
     C                   IF        *IN42 = *On
     C                   MOVE      *ON           *IN50
     C                   MOVE      *ON           *IN55
     C                   MOVEL     'USR7657'     WZMsgID
     C                   EXSR      SRErrMsg
     C                   ENDIF
     C                   ENDIF
 
      ** Validate Deduct Tax
 
     C                   IF        SDTSU = *Blanks
     C                   MOVE      *ON           *IN50
     C                   MOVE      *ON           *IN56
     C                   MOVEL     'USR7658'     WZMsgID
     C                   EXSR      SRErrMsg
     C                   ELSE
     C                   IF        SDTSU <> 'S' and SDTSU <> 'U'
     C                   MOVE      *ON           *IN50
     C                   MOVE      *ON           *IN56
     C                   MOVEL     'USR7659'     WZMsgID
     C                   EXSR      SRErrMsg
     C                   ENDIF
     C                   ENDIF
 
      ** Validate Allocation Days
 
     C                   IF        SALDY <> *Blanks
     C                   MOVE      *Blanks       ZField
     C                   MOVE      SALDY         ZField
     C                   Z-ADD     0             ZADEC
     C                   Z-ADD     2             ZADIG
 
     C                   CALLB     'ZALIGN'
     C                   PARM                    ZAlignOk
     C                   PARM                    ZField
     C                   PARM                    ZADEC
     C                   PARM                    ZADIG
 
     C                   IF        ZAlignOk = 'N'
     C                   MOVE      *ON           *IN50
     C                   MOVE      *ON           *IN57
     C                   MOVEL     'USR7663'     WZMsgID
     C                   EXSR      SRErrMsg
     C                   ENDIF
 
     C                   ELSE
 
     C                   EVAL      SALDY = '01'
     C                   ENDIF
 
      ** Validate Default Exemption Code for Portfolio Interest
 
     C                   IF        SEXPI <> *Blanks
     C                   EVAL      KCRTT = SCRTT
     C                   EVAL      KEXCD = SEXPI
     C     Key4          CHAIN     SDEXEMD1                           42
     C                   IF        *IN42 = *On
     C                   MOVE      *ON           *IN50
     C                   MOVE      *ON           *IN58
     C                   MOVEL     'USR7664'     WZMsgID
     C                   EXSR      SRErrMsg
     C                   ENDIF
     C                   ENDIF
 
      ** Validate Default Basket for Portfolio Exemption
 
     C                   IF        SPFEX = *Blanks
     C                   MOVE      *ON           *IN50
     C                   MOVE      *ON           *IN68
     C                   MOVEL     'USR7669'     WZMsgID
     C                   EXSR      SRErrMsg
     C                   ELSE
     C                   EVAL      KCRTT = SCRTT
     C                   EVAL      KTXBS = SPFEX
     C     Key2          CHAIN     SDTXBSD1                           42
 
     C                   IF        *IN42 = *On
     C                   MOVE      *ON           *IN50
     C                   MOVE      *ON           *IN68
     C                   MOVEL     'USR7670'     WZMsgID
     C                   EXSR      SRErrMsg
     C                   ENDIF
     C                   ENDIF
 
      ** Save Current Screen Value
 
     C                   IF        *IN50 = *Off
     C                   EVAL      CurDBDC = SDBDC
     C                   EVAL      CurDRBW = SDRBW
     C                   EVAL      CurDTSU = SDTSU
     C                   EVAL      CurALDY = SALDY
     C                   EVAL      CurEXPI = SEXPI
     C                   EVAL      CurPFEX = SPFEX
     C                   EXSR      SRUpdSHdr
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRBuildE - Build Empty subfile                               *
      *                                                               *
      *  Called by: SRInsAdd                                          *
      *                                                               *
      *  Calls:     None                                              *
      *                                                               *
      *****************************************************************
     C     SRBuildE      BEGSR
 
     C                   EVAL      *IN50 = *Off
     C                   MOVEA     '00'          *IN(70)
     C                   WRITE     SD0377C0
     C                   Z-ADD     1             RRN
 
     C     1             DO        300           A                 3 0
     C                   EVAL      *IN73 = *Off
     C                   EVAL      *IN74 = *Off
     C                   MOVEA     '000'         *IN(60)
     C                   EVAL      *IN66 = *On
     C                   EVAL      SCRRS = *Blanks
     C                   EVAL      STXBS = *Blanks
     C                   EVAL      SEXCD = *Blanks
     C                   WRITE     SD0377S0
     C                   ADD       1             RRN
     C                   ENDDO
     C                   MOVEA     '111'         *IN(70)
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValSubF - Process to Validate Subfile                      *
      *                                                               *
      *  Called by: SRInsAdd, SRAmed                                  *
      *                                                               *
      *  Calls:     SRValFlds, SRWrite, SRUpdate                      *
      *                                                               *
      *****************************************************************
     C     SRValSubF     BEGSR
 
     C                   READC     SD0377S0                               41
 
     C                   DOW       *IN41 = *Off
 
     C                   IF        ValFlds <> *Blanks
     C                   MOVEA     '000'         *IN(60)
     C                   EXSR      SRValFlds
 
     C                   IF        *IN50 = *On
     C                   EVAL      *IN73 = *On
     C                   UPDATE    SD0377S0
     C                   ELSE
 
     C                   MOVEA     '000'         *IN(60)
     C                   UPDATE    SD0377S0
     C                   SELECT
     C                   WHEN      SACTN = 'I'
     C                   EXSR      SRWrite
     C                   WHEN      SACTN = 'A'
     C                   EXSR      SRUpdate
     C                   ENDSL
 
     C                   ENDIF
     C                   ENDIF
 
     C                   READC     SD0377S0                               41
 
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValFlds - Validate Subfile Details                         *
      *                                                               *
      *  Called by: SRValSubF                                         *
      *                                                               *
      *  Calls:     SRErrMsg                                          *
      *                                                               *
      *****************************************************************
     C     SRValFlds     BEGSR
 
      ** Validate Country of Residence
 
     C                   IF        SACTN = 'I'
     C                   IF        SCRRS = *Blanks
     C                   EVAL      *IN50 = *On
     C                   EVAL      *IN60 = *On
     C                   MOVEL     'USR7653'     WZMsgId
     C                   EXSR      SRErrMsg
 
     C                   ELSE
 
     C                   CALL      'AOCTRYR0'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      SCRRS         PCTRY
     C     SDCTRY        PARM      SDCTRY        DSSDY
 
     C                   IF        PRetCode <> *Blanks
     C                   MOVE      *ON           *IN50
     C                   MOVE      *ON           *IN60
     C                   MOVEL     'USR7654'     WZMsgID
     C                   EXSR      SRErrMsg
     C                   ELSE
     C                   MOVE      A4CNCD        SCRRS
     C                   ENDIF
 
      ** Record must not exist
 
     C                   EVAL      KCRTT = SCRTT
     C                   EVAL      KINVT = SINVT
     C                   EVAL      KCRRS = SCRRS
     C     Key5          CHAIN     SDWHTTD4                           42
 
     C                   IF        *IN42 = *Off
     C                   MOVE      *ON           *IN50
     C                   MOVE      *ON           *IN60
     C                   MOVEL     'USR7655'     WZMsgID
     C                   EXSR      SRErrMsg
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
      ** Validate Tax Basket
 
     C                   IF        STXBS = *Blanks
     C                   MOVE      *ON           *IN50
     C                   MOVE      *ON           *IN61
     C                   MOVEL     'USR7660'     WZMsgID
     C                   EXSR      SRErrMsg
 
     C                   ELSE
 
     C                   IF        *IN60 = *Off
     C                   EVAL      KCRTT = SCRTT
     C                   EVAL      KTXBS = STXBS
     C     Key2          Chain     SDTXBSD1                           42
     C                   IF        *IN42 = *On
     C                   MOVE      *ON           *IN50
     C                   MOVE      *ON           *IN61
     C                   MOVEL     'USR7661'     WZMsgID
     C                   EXSR      SRErrMsg
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
      ** Validate Exemption Code
 
     C                   IF        SEXCD <> *Blanks
     C                   EVAL      KCRTT = SCRTT
     C                   EVAL      KEXCD = SEXCD
     C     Key4          CHAIN     SDEXEMD1                           42
     C                   IF        *IN42 = *On
     C                   MOVE      *ON           *IN50
     C                   MOVE      *ON           *IN62
     C                   MOVEL     'USR7662'     WZMsgID
     C                   EXSR      SRErrMsg
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRBuildSubF - Build Subfile Details                          *
      *                                                               *
      *  Called by: SRProDel                                          *
      *                                                               *
      *  Calls:     None                                              *
      *                                                               *
      *****************************************************************
     C     SRBuildSubF   BEGSR
 
     C                   Z-ADD     1             RRN
     C                   MOVEA     '00'          *IN(70)
     C                   EVAL      *IN69 = *On
     C                   EVAL      *IN73 = *Off
     C                   WRITE     SD0377C0
     C     Key1          SETLL     SDWHTTD4
     C     Key1          READE     SDWHTTD4                               72
 
      ** Load Subfile
 
     C                   DOW       *IN72 = *Off
     C                   EVAL      S1SEL = *Blanks
     C                   EVAL      SCRRS = WTCRRS
     C                   EVAL      STXBS = WTTXBS
     C                   EVAL      SEXCD = WTEXCD
     C                   WRITE     SD0377S0
     C                   Add       1             RRN
     C     Key1          READE     SDWHTTD4                               72
     C                   ENDDO
 
     C                   IF        RRN = 1
     C                   MOVEA     '01'          *IN(70)
     C                   ELSE
     C                   MOVEA     '11'          *IN(70)
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDelRec - Process to Delete all records                     *
      *                                                               *
      *  Called by: SRDelete                                          *
      *                                                               *
      *  Calls:     SRTrailer                                         *
      *                                                               *
      *****************************************************************
     C     SRDelRec      BEGSR
 
     C     Key1          SETLL     SDWHTTD0
     C     Key1          READE     SDWHTTD0                               40
 
     C                   DOW       *IN40 = *Off
     C                   DELETE    SDWHTTD0
     C                   EXSR      SRTrailer
     C     Key1          READE     SDWHTTD0                               40
     C                   ENDDO
 
     C                   COMMIT
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRProDel - Process to Delete chosen recod                    *
      *                                                               *
      *  Called by: SRDelete                                          *
      *                                                               *
      *  Calls:     SRBuildSubF, SRErrMsg, SRTrailer                  *
      *                                                               *
      *****************************************************************
     C     SRProDel      BEGSR
 
     C                   EVAL      *IN05 = *On
     C                   EVAL      *IN10 = *Off
     C                   EVAL      *IN12 = *On
 
     C                   EVAL      *IN59 = *Off
     C                   MOVEA     '11100'       *IN(63)
     C                   MOVE      '0'           *IN69
     C                   EXSR      SRBuildSubF
     C                   Z-ADD     1             RRN
 
      ** Process subfile action
 
     C                   DOW       *INKC = *Off and *INKL = *Off
 
     C                   WRITE     SD0377F0
     C                   WRITE     #MSGCTL
     C                   WRITE     SD0377F1
     C                   WRITE     SD0377F3
     C                   EXFMT     SD0377C0
     C                   CALL      'ZA0250'
 
     C                   IF        *INKE = *On
     C                   EVAL      *IN50 = *Off
     C                   EVAL      *IN59 = *Off
     C                   EVAL      S1SEL = *Blanks
     C                   EXSR      SRBuildSubF
     C                   Z-ADD     1             RRN
     C                   ELSE
 
      ** Process Deleted Records
 
     C                   READC     SD0377S0                               41
     C                   DOW       *IN41 = *Off
 
      ** Validate Action Code
 
     C                   IF        S1SEL <> 'D'
     C                   EVAL      *IN50 = *On
     C                   EVAL      *IN59 = *On
     C                   MOVEL     'USR7665'     WZMsgID
     C                   EXSR      SRErrMsg
     C                   ENDIF
 
     C                   IF        *IN50 = *On
     C                   EVAL      *IN73 = *On
     C                   UPDATE    SD0377S0
     C                   ELSE
     C                   EVAL      *IN73 = *Off
     C                   EVAL      KCRRS = SCRRS
     C     Key5          CHAIN     SDWHTTD0                           40
     C                   IF        *IN40 = *Off
     C                   DELETE    SDWHTTD0
     C                   EXSR      SRTrailer
     C                   ENDIF
     C                   ENDIF
 
     C                   READC     SD0377S0                               41
     C                   ENDDO
 
      ** Rebuild subfile after delete
 
     C                   IF        *IN50 = *Off
     C                   COMMIT
     C                   EXSR      SRBuildSubF
     C                   IF        *IN(70) = '01'
     C                   LEAVE
     C                   ENDIF
     C                   Z-ADD     1             RRN
     C                   ELSE
     C                   ROLBK
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRWrite     - Write Details to file                          *
      *                                                               *
      *  Called by: SRValSubF                                         *
      *                                                               *
      *  Calls:     SRTrailer                                         *
      *                                                               *
      *****************************************************************
     C     SRWrite       BEGSR
 
     C                   EVAL      WTRECI = 'D'
     C                   EVAL      WTCRTT = SCRTT
     C                   EVAL      WTINVT = SINVT
     C                   EVAL      WTCRRS = SCRRS
     C                   EVAL      WTDBDC = SDBDC
     C                   EVAL      WTDRBW = SDRBW
     C                   EVAL      WTDTSU = SDTSU
     C                   EVAL      WTTXBS = STXBS
     C                   EVAL      WTEXCD = SEXCD
     C                   MOVE      SALDY         WTALDY
     C                   EVAL      WTEXPI = SEXPI
     C                   EVAL      WTPFEX = SPFEX
     C                   EVAL      WTTYLC = 'I'
     C                   EVAL      WTLCD = BJRDNB
     C                   WRITE     SDWHTTD0
     C                   EXSR      SRTrailer
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRUpdSHdr   - Update Details for Sub-header only             *
      *                                                               *
      *  Called by: SRValSubHdr                                       *
      *                                                               *
      *  Calls:     SRTrailer                                         *
      *                                                               *
      *****************************************************************
     C     SRUpdSHdr     BEGSR
 
      ** If Subheader details are changed
 
     C                   IF        PrvDtls <> CurDtls
     C     Key1          SETLL     SDWHTTD0
     C     Key1          READE     SDWHTTD0                               40
     C                   DOW       *IN40 = *Off
     C                   EVAL      WTDBDC = SDBDC
     C                   EVAL      WTDRBW = SDRBW
     C                   EVAL      WTDTSU = SDTSU
     C                   MOVE      SALDY         WTALDY
     C                   EVAL      WTEXPI = SEXPI
     C                   EVAL      WTPFEX = SPFEX
     C                   EVAL      WTTYLC = 'A'
     C                   EVAL      WTLCD = BJRDNB
     C                   UPDATE    SDWHTTD0
     C                   EXSR      SRTrailer
     C     Key1          READE     SDWHTTD0                               40
     C                   ENDDO
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRUpdate    - Update Records for Amend                       *
      *                                                               *
      *  Called by: SRValSubF                                         *
      *                                                               *
      *  Calls:     SRTrailer                                         *
      *                                                               *
      *****************************************************************
     C     SRUpdate      BEGSR
 
      ** If Subfile Details is amended
 
     C                   EVAL      KCRRS = SCRRS
     C     Key5          CHAIN     SDWHTTD0                           40
     C                   EVAL      WTTXBS = STXBS
     C                   EVAL      WTEXCD = SEXCD
     C                   EVAL      WTTYLC = 'A'
     C                   EVAL      WTLCD = BJRDNB
     C                   UPDATE    SDWHTTD0
 
     C                   IF        PrvDtls = CurDtls
     C                   EXSR      SRTrailer
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRTrailer - Update File Controls                             *
      *                                                               *
      *  Called by: SRAmd                                             *
      *                                                               *
      *  Calls:     None                                              *
      *                                                               *
      *****************************************************************
     C     SRTrailer     BEGSR
 
     C     Key3          CHAIN     @AHREAU                            81
 
     C                   SELECT
     C                   WHEN      SACTN = 'A'
     C                   ADD       1             AHNOAM
 
     C                   WHEN      SACTN = 'D'
     C                   ADD       1             AHNODL
     C                   SUB       1             AHNORC
 
     C                   WHEN      SACTN = 'I'
     C                   ADD       1             AHNOIN
     C                   ADD       1             AHNORC
     C                   ENDSL
 
     C                   UPDATE    @AHREAU
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation                              *
      *                                                               *
      *  Called by:                                                   *
      *                                                               *
      *  Calls:     AOBANKR0                                          *
      *             SRBuild                                           *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
 
     C     *ENTRY        Plist
     C                   PARM                    PMODE             1
 
      ** Read in Installation Data
 
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
     C     *LOCK         IN        LDA
     C                   MOVEL     'SD0377'      DBPGM
     C                   OUT       LDA
 
     C                   Eval      SPGM = PsProcName
     C                   Eval      SWSID = PSJobName
     C                   Eval      SUSER = PSUser
 
      ** Get Bank Details
 
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR '     PRTCD             7
     C                   PARM      '*FIRST '     POPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
 
     C     Key1          KLIST
     C                   KFLD                    KCRTT             2
     C                   KFLD                    KINVT             3
 
 
     C     Key2          KLIST
     C                   KFLD                    KCRTT
     C                   KFLD                    KTXBS             2
 
     C     Key3          KLIST
     C                   KFLD                    KAHFLNM          10
 
     C     Key4          KLIST
     C                   KFLD                    KCRTT
     C                   KFLD                    KEXCD             2
 
     C     Key5          KLIST
     C                   KFLD                    KCRTT
     C                   KFLD                    KINVT
     C                   KFLD                    KCRRS             2
 
     C                   MOVEL     'SDWHTTPD'    KAHFLNM
 
      ** Initialise Fields
 
     C                   EVAL      KCRTT = *Blanks
     C                   EVAL      KINVT = *Blanks
     C                   EVAL      KCRRS = *Blanks
     C                   EVAL      KTXBS = *Blanks
     C                   EVAL      KEXCD = *Blanks
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *   SRErrMsg - Subroutine which handles the display of error    *
      *              messages                                         *
      *                                                               *
      *   Called by: SRBuild                                          *
      *              SRValAction                                      *
      *              SRVal1                                           *
      *              SRVal2                                           *
      *                                                               *
      *   Calls:     ZA0340                                           *
      *                                                               *
      *****************************************************************
     C     SRErrMsg      BEGSR
 
     C                   CALL      'ZA0340'
     C                   PARM      'SDUSRMSG'    WZMsgFile        10
     C                   PARM                    WZMsgID          10
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: None                                               *
      *                                                               *
      * Calls    : None                                               *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
 
     C     WRUN          IFEQ      *BLANK
     C                   MOVE      'Y'           WRUN              1
     C                   DUMP
     C                   ROLBK
     C                   MOVE      *ON           *INU7
     C                   MOVE      *ON           *INU8
     C                   ENDIF
 
      ** If *PSSR already run, then just end the program here
 
     C                   MOVE      *ON           *INLR
     C                   RETURN
 
     C                   ENDSR
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
