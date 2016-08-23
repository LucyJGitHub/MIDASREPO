     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD KYC Audit and List report')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      ***SD000040*-*Midas*SD*KYC*Audit*and*List*report*****************                      CSD028A
      *  SD000055 - Midas SD KYC Audit and List report                *                      CSD028A
      *                                                               *
      *  Function:  This report program will list all of the          *
      *             customers that are currently held for the         *
      *             completion of the KYC investigation.              *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2005            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSD027A            Date 05May06               *
      *  Prev Amend No. BUG10603           Date 14Feb06               *
      *                 CSD028A            Date 21Dec05               *
      *                 CSD028  *CREATE    Date 22Aug05               *
      *                                                               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD027A - Conversion Of Customer Number to Alpha             *
/*    *  BUG10603 - Change Control for KYC                            *
      *  CSD028A- Change in program name                              *
      *  CSD028 - KYC (Standing Data Authorisations)                  *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    30,31,32   Print Function fields                           *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * SRINIT - Initialisation                                       *
      * SRPROC - Detail Processing                                    *
      * SRPRNT - Detail Printing                                      *
      * SRRCFP1 - Detail Spool File recorded by RCF                   *
      * SRDATE - Convert Midas day number to date                     *
      * SRAudit - Write audit report                                  *
      *                                                               *
      * *PSSR - Error processing                                      *
      * *INZSR - Initialise                                           *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FSDCDSHJ0  IF   E           K DISK    INFSR(*PSSR)
      ** Midas SD Customer detail shadow and Authorization Log Join file
 
     FSDKYCIL0  IF   E           K DISK    INFSR(*PSSR)
      ** KYC Investigation Items
 
     F***SD000040P1O    E             PRINTER INFSR(*PSSR)                                   CSD028A
     FSD000055P1O    E             PRINTER INFSR(*PSSR)                                      CSD028A
     F                                     INFDS(SPOOL1)
      ** Midas SD KYC Audit and List Printer File
 
     F***SD000040AUO    E             PRINTER INFDS(SPOOLU)                                  CSD028A
     FSD000055AUO    E             PRINTER INFDS(SPOOLU)                                     CSD028A
     F                                     USROPN
     F                                     INFSR(*PSSR)
      ** Midas SD KYC Audit and List Printer File - Audit
 
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
 
      ** Externally described DS for bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** External DS for Branch Code Details
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
 
      ** DS for access programs - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Long Data Structure for Access Programs
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ***File*Information*Data*Structure*for*SD000040P1****************                      CSD028A
      ** File Information Data Structure for SD000055P1                                      CSD028A
      * for RCF use
     D SPOOL1          DS
     D  PSFile1               83     92
     D  PSFNum1              123    124B 0
     D  OflLn1               188    189B 0
     D  PrtLn1               367    368B 0
 
      ***File*Information*Data*Structure*for*SD000040AU****************                      CSD028A
      ** File Information Data Structure for SD000055AU                                      CSD028A
      * for RCF use
     D SPOOLU          DS
     D  PSFile2               83     92
     D  PSFNum2              123    124B 0
     D  OflLn2               188    189B 0
     D  PrtLn2               367    368B 0
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Parameters for ZSFILE
     D PSeq            S              5
     D PEnty           S              3
     D PZSnum          S              6  0
     D PZSerr          S              1
 
      ** Parameters for ZDATE2
     D PZDateIN        S                   LIKE(KYORED)
     D PDfinIN         S                   LIKE(BJDFIN)
     D PZDateOUT       S              6  0
     D PZADateOUT      S              7
 
      ** Parameter for SD000053                                                             BUG10603
     D PRtCd           S              7A                                                    BUG10603
     D POptn           S              7A                                                    BUG10603
     D PItem           S           5000A                                                    BUG10603
     D PStaFlg         S              1A                                                    BUG10603
     D PLength         S              4P 0                                                  BUG10603
     D PToken          S             80A                                                    BUG10603
     D PTknTyp         S              7A                                                    BUG10603
     D PCurIdx         S              4P 0                                                  BUG10603
     D PStatus         S             10A                                                    BUG10603
                                                                                            BUG10603
     D RqdLn1          S              3P 0
     D DifLn1          S              4P 0
 
     D*WrkCSSN**       S              6  0                                                   CSD027A
     D WrkCSSN         S              6A                                                     CSD027A
     D*WOutI****       S             50    DIM(10)                                          BUG10603
     D WIndex          S              2  0
     D WRunDate        S              7A
     D WFirst          S              1A
     D WkBrcdSV        S              3A
     D WDtlPrintFlg    S              1A   INZ('N')
     D WItemFlagH      S              1A                                                    BUG10603
     D WKycFound       S              1A                                                    BUG10603
     D WPass1          S              1A                                                    BUG10603
 
     D WError          S              1
     D PRetCode        S              7A
     D POption         S              7A
     D PBRCA           S              3A
     D NewPage         S              1
 
     D                 DS
     D*PKYOUTI**               1    500                                                     BUG10603
     D*#1OTI1***               1     50                                                     BUG10603
     D*#1OTI2***              51    100                                                     BUG10603
     D*#1OTI3***             101    150                                                     BUG10603
     D*#1OTI4***             151    200                                                     BUG10603
     D*#1OTI5***             201    250                                                     BUG10603
     D*#1OTI6***             251    300                                                     BUG10603
     D*#1OTI7***             301    350                                                     BUG10603
     D*#1OTI8***             351    400                                                     BUG10603
     D*#1OTI9***             401    450                                                     BUG10603
     D*#1OTI10**             451    500                                                     BUG10603
 
      ** Entry Parameters
     D PMode           S              1
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************
 
     C                   EXSR      SRINIT
 
     C                   EXSR      SRPROC
 
      ** End of program
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRINIT - Initialisation                                       *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SRINIT        BEGSR
 
      ** RCF Processing for rinter File.
 
     C                   EXSR      SRRCFP1
 
      ** Report Work fields.
 
     C                   EVAL      RqdLn1   = 0
     C                   EVAL      DifLn1   = 0
     C                   EVAL      PrtLn1   = 0
     C                   EVAL      WError   = 'N'
     C                   EVAL      NewPage  = 'N'
     C                   EVAL      WFirst   = 'Y'
     C                   EVAL      WkBrcdSV = *BLANK
 
     C                   EVAL      RJURPT   = BJURPT
     C                   EVAL      RJMRDT   = BJMRDT
     C                   EVAL      WRunDate = RJMRDT
     C                   Eval      WDtlPrintFlg   = 'N'
     C                   EVAL      *IN30    = *OFF
     C                   EVAL      *IN31    = *OFF
 
     C                   SELECT
     C                   WHEN      PMode    = 'L'
     C                   EVAL      *IN30    = *ON
     C                   WHEN      Pmode    = 'A'
     C                   EVAL      *IN31    = *ON
     C                   ENDSL
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRPROC - Detail Processing                                    *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: SRPRNT, SRCHKLIN, SRRTVBRCH, SRDATE                    *
      *                                                               *
      *****************************************************************
 
     C     SRPROC        BEGSR
 
     C     *LOVAL        SETLL     SDCDSHJ0
     C                   READ      SDCDSHJ0
 
     C                   DOW       NOT %EOF(SDCDSHJ0)
 
     C                   IF        WKBrcdSV <> BBBRCD
 
     C                   EVAL      WkBrcdSV = BBBRCD
     C                   EVAL      NewPage  = 'Y'
     C                   EVAL      PBRCA    = BBBRCD
     C                   EXSR      SRRTVBRCH
     C                   EVAL      R8BRCD   = A8BRCD
     C                   EVAL      R8BRNM   = A8BRNM
 
     C                   ENDIF
 
     C                   EVAL      RRCUST  = BBCUST
     C                   EVAL      RRCSSN  = BBCSSN
     C**********         EVAL      WrkCSSN = %INT(BBCUST)                                    CSD027A
     C                   EVAL      WrkCSSN = BBCUST                                          CSD027A
     C                   EVAL      RROEDT  = *BLANK
     C                   EVAL      RRSTAT  = *BLANK
     C**********         EVAL      RRINVI  = *BLANK                                         BUG10603
     C**********         EVAL      PKYOUTI = *BLANK                                         BUG10603
 
     C                   EVAL      WKycFound = ' '                                          BUG10603
     C     WrkCSSN       CHAIN     SDKYCIL0
 
     C                   IF        %FOUND(SDKYCIL0)
 
     C                   EVAL      PZDateIN = KYORED
     C                   EXSR      SRDATE
     C                   EVAL      RROEDT = PZADateOUT
     C                   SELECT
     C                   WHEN      KYSTAT = 'P'
     C                   EVAL      RRSTAT = 'Pending      '
     C                   WHEN      KYSTAT = 'S'
     C                   EVAL      RRSTAT = 'Start        '
     C                   WHEN      KYSTAT = 'I'
     C                   EVAL      RRSTAT = 'Investigation'
     C                   WHEN      KYSTAT = 'U'
     C                   EVAL      RRSTAT = 'Update       '
     C                   WHEN      KYSTAT = 'A'
     C                   EVAL      RRSTAT = 'Accepted     '
     C                   WHEN      KYSTAT = 'R'
     C                   EVAL      RRSTAT = 'Rejected     '
     C                   ENDSL
 
     C**********         EVAL      PKYOUTI = KYOUTI                                         BUG10603
     C                   EVAL      WKycFound = 'Y'                                          BUG10603
     C                   ENDIF
 
     C                   IF        (PMode = 'L' AND RROEDT = WRunDate)
     C                             OR PMode = 'A'
     C                   EXSR      SRPRNT
                                                                                            BUG10603
     C                   IF        WKycFound = 'Y'                                          BUG10603
     C                   EXSR      SRKycAll                                                 BUG10603
     C                   EXSR      SRKycOut                                                 BUG10603
     C                   ELSE                                                               BUG10603
     C                   EXSR      SRKycNotFound                                            BUG10603
     C                   ENDIF                                                              BUG10603
                                                                                            BUG10603
     C                   ENDIF
 
     C                   READ      SDCDSHJ0
 
     C                   ENDDO
 
     C                   IF        WDtlPrintFlg = 'N'
     C                   EXSR      SRAUDIT
     C                   ELSE
      ** When EOF, write trailer
 
     C                   IF        %EOF(SDCDSHJ0)
     C                   EVAL      RqdLn1 = 8
     C                   EXSR      SRCHKLIN
     C                   WRITE     TRAILP1
     C                   ENDIF
     C                   ENDIF
 
     C     ENDPROC       ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRPRNT - Detail Printing                                      *
      *                                                               *
      * Called by: SRPROC                                             *
      *                                                               *
      * Calls: SRCHKLIN                                               *
      *                                                               *
      *****************************************************************
 
     C     SRPRNT        BEGSR
 
      ** Check for overflow
     C**********         EVAL      RqdLn1 = 4                                               BUG10603
     C                   EVAL      RqdLn1 = 6                                               BUG10603
     C                   EXSR      SRCHKLIN
 
      ** Write Detail
     C                   WRITE     DETAIL1
     C                   IF        WDtlPrintFlg   = 'N'
     C                   EVAL      WDtlPrintFlg   = 'Y'
     C                   ENDIF
     C**********         CLEAR                   WOutI                                      BUG10603
     C**********         EVAL      WOutI(1)  = #1OTI1                                       BUG10603
     C**********         EVAL      WOutI(2)  = #1OTI2                                       BUG10603
     C**********         EVAL      WOutI(3)  = #1OTI3                                       BUG10603
     C**********         EVAL      WOutI(4)  = #1OTI4                                       BUG10603
     C**********         EVAL      WOutI(5)  = #1OTI5                                       BUG10603
     C**********         EVAL      WOutI(6)  = #1OTI6                                       BUG10603
     C**********         EVAL      WOutI(7)  = #1OTI7                                       BUG10603
     C**********         EVAL      WOutI(8)  = #1OTI8                                       BUG10603
     C**********         EVAL      WOutI(9)  = #1OTI9                                       BUG10603
     C**********         EVAL      WOutI(10) = #1OTI10                                      BUG10603
     C**********         EVAL      *IN32 = *ON                                              BUG10603
     C**********         EVAL      WIndex   = 1                                             BUG10603
     C**********         DOW       Windex <= 10                                             BUG10603
     C**********         EVAL      RRINVI = WOutI(WIndex)                                   BUG10603
     C**********         IF        WOutI(WIndex) <> *BLANK                                  BUG10603
     C**********                   OR WIndex = 1                                            BUG10603
     C**********         EVAL      RqdLn1 = 2                                               BUG10603
     C**********         EXSR      SRCHKLIN                                                 BUG10603
     C**********         WRITE     DETAIL2                                                  BUG10603
     C**********         EVAL      *IN32 = *OFF                                             BUG10603
     C**********         ENDIF                                                              BUG10603
     C**********         EVAL      WIndex   = WIndex + 1                                    BUG10603
     C**********         ENDDO                                                              BUG10603
 
     C                   ENDSR
      *****************************************************************                     BUG10603
      /EJECT                                                                                BUG10603
      *****************************************************************                     BUG10603
      *                                                               *                     BUG10603
      * SRKycAll - Details for All KYC Items                          *                     BUG10603
      *                                                               *                     BUG10603
      *****************************************************************                     BUG10603
                                                                                            BUG10603
     C     SRKycAll      BEGSR                                                              BUG10603
                                                                                            BUG10603
     C                   EVAL      WItemFlagH ='A'                                          BUG10603
     C                   EVAL      WPass1 = ' '                                             BUG10603
                                                                                            BUG10603
      ** Check for overflow                                                                 BUG10603
                                                                                            BUG10603
     C                   EVAL      RqdLn1 = 5                                               BUG10603
     C                   EXSR      SRChkLinA                                                BUG10603
                                                                                            BUG10603
      ** Call the program that parses the All KYC Items                                     BUG10603
                                                                                            BUG10603
     C                   CALL      'SD000053'                                               BUG10603
     C                   PARM      *BLANKS       PRtCd                                      BUG10603
     C                   PARM      '*FIRST'      POptn                                      BUG10603
     C                   PARM      KYALLI        PItem                                      BUG10603
     C                   PARM      ' '           PStaFlg                                    BUG10603
     C                   PARM                    PLength                                    BUG10603
     C                   PARM                    PToken                                     BUG10603
     C                   PARM                    PTknTyp                                    BUG10603
     C                   PARM                    PCurIdx                                    BUG10603
     C                   PARM                    PStatus                                    BUG10603
                                                                                            BUG10603
     C                   SELECT                                                             BUG10603
                                                                                            BUG10603
      ** No details found on All KYC Items                                                  BUG10603
                                                                                            BUG10603
     C                   WHEN      PRtCd = '*EOL'                                           BUG10603
     C                   WRITE     NoDetail                                                 BUG10603
                                                                                            BUG10603
      ** Details found on All KYC Items                                                     BUG10603
                                                                                            BUG10603
     C                   WHEN      PRtCd = *BLANKS                                          BUG10603
                                                                                            BUG10603
      ** Determine Column Header                                                            BUG10603
                                                                                            BUG10603
     C                   IF        PTknTyp = '*COL'                                         BUG10603
     C                   EVAL      RINVH22 = %TRIM(PToken)                                  BUG10603
     C                   WRITE     HeadP22                                                  BUG10603
     C                   ENDIF                                                              BUG10603
                                                                                            BUG10603
     C                   DOW       PRtCd <> '*EOL'                                          BUG10603
                                                                                            BUG10603
      ** Call the program that parses the All KYC Items                                     BUG10603
                                                                                            BUG10603
     C                   CALL      'SD000053'                                               BUG10603
     C                   PARM      *BLANKS       PRtCd                                      BUG10603
     C                   PARM      '*NEXT'       POptn                                      BUG10603
     C                   PARM      KYALLI        PItem                                      BUG10603
     C                   PARM      ' '           PStaFlg                                    BUG10603
     C                   PARM                    PLength                                    BUG10603
     C                   PARM                    PToken                                     BUG10603
     C                   PARM                    PTknTyp                                    BUG10603
     C                   PARM                    PCurIdx                                    BUG10603
     C                   PARM                    PStatus                                    BUG10603
                                                                                            BUG10603
     C                   SELECT                                                             BUG10603
                                                                                            BUG10603
      ** Determine Column Header                                                            BUG10603
                                                                                            BUG10603
     C                   WHEN      PTknTyp = '*COL'                                         BUG10603
     C                   EVAL      RINVH22 = %TRIM(PToken)                                  BUG10603
                                                                                            BUG10603
      ** Check for overflow                                                                 BUG10603
                                                                                            BUG10603
     C                   EVAL      RqdLn1 = 2                                               BUG10603
     C                   EXSR      SRChkLinA                                                BUG10603
     C                   WRITE     HeadP22                                                  BUG10603
                                                                                            BUG10603
      ** Determine Column Detail                                                            BUG10603
                                                                                            BUG10603
     C                   WHEN      PTknTyp = '*DOC'                                         BUG10603
     C                   EVAL      RINVD22 = %TRIM(Ptoken)                                  BUG10603
                                                                                            BUG10603
      ** Check for overflow                                                                 BUG10603
                                                                                            BUG10603
     C                   EVAL      RqdLn1 = 1                                               BUG10603
     C                   EXSR      SRChkLinA                                                BUG10603
     C                   WRITE     Detail22                                                 BUG10603
                                                                                            BUG10603
     C                   ENDSL                                                              BUG10603
                                                                                            BUG10603
     C                   ENDDO                                                              BUG10603
                                                                                            BUG10603
     C                   ENDSL                                                              BUG10603
                                                                                            BUG10603
     C                   ENDSR                                                              BUG10603
      *****************************************************************                     BUG10603
      /EJECT                                                                                BUG10603
      *****************************************************************                     BUG10603
      *                                                               *                     BUG10603
      * SRKycOut - Details for Outstanding KYC Item                   *                     BUG10603
      *                                                               *                     BUG10603
      *****************************************************************                     BUG10603
                                                                                            BUG10603
     C     SRKycOut      BEGSR                                                              BUG10603
                                                                                            BUG10603
     c                   EVAL      WItemFlagH = 'B'                                         BUG10603
     C                   EVAL      WPass1 = ' '                                             BUG10603
                                                                                            BUG10603
      ** Check for overflow                                                                 BUG10603
                                                                                            BUG10603
     C                   EVAL      RqdLn1 = 5                                               BUG10603
     C                   EXSR      SRChkLinA                                                BUG10603
                                                                                            BUG10603
      ** Call the program that parses the All KYC Items                                     BUG10603
                                                                                            BUG10603
     C                   CALL      'SD000053'                                               BUG10603
     C                   PARM      *BLANKS       PRtCd                                      BUG10603
     C                   PARM      '*FIRST'      POptn                                      BUG10603
     C                   PARM      KYOUTI        PItem                                      BUG10603
     C                   PARM      'Y'           PStaFlg                                    BUG10603
     C                   PARM                    PLength                                    BUG10603
     C                   PARM                    PToken                                     BUG10603
     C                   PARM                    PTknTyp                                    BUG10603
     C                   PARM                    PCurIdx                                    BUG10603
     C                   PARM                    PStatus                                    BUG10603
                                                                                            BUG10603
     C                   SELECT                                                             BUG10603
                                                                                            BUG10603
      ** No details found on All KYC Items                                                  BUG10603
                                                                                            BUG10603
     C                   WHEN      PRtCd = '*EOL'                                           BUG10603
     C                   WRITE     NoDetail                                                 BUG10603
                                                                                            BUG10603
      ** Details found on All KYC Items                                                     BUG10603
                                                                                            BUG10603
     C                   WHEN      PRtCd = *BLANKS                                          BUG10603
                                                                                            BUG10603
      ** Determine Column Header                                                            BUG10603
                                                                                            BUG10603
     C                   IF        PTknTyp = '*COL'                                         BUG10603
     C                   EVAL      ROUTH32 = %TRIM(PToken)                                  BUG10603
     C                   WRITE     HeadP32                                                  BUG10603
     C                   ENDIF                                                              BUG10603
                                                                                            BUG10603
     C                   DOW       PRtCd <> '*EOL'                                          BUG10603
                                                                                            BUG10603
      ** Call the program that parses the All KYC Items                                     BUG10603
                                                                                            BUG10603
     C                   CALL      'SD000053'                                               BUG10603
     C                   PARM      *BLANKS       PRtCd                                      BUG10603
     C                   PARM      '*NEXT'       POptn                                      BUG10603
     C                   PARM      KYOUTI        PItem                                      BUG10603
     C                   PARM      'Y'           PStaFlg                                    BUG10603
     C                   PARM                    PLength                                    BUG10603
     C                   PARM                    PToken                                     BUG10603
     C                   PARM                    PTknTyp                                    BUG10603
     C                   PARM                    PCurIdx                                    BUG10603
     C                   PARM                    PStatus                                    BUG10603
                                                                                            BUG10603
     C                   SELECT                                                             BUG10603
                                                                                            BUG10603
      ** Determine Column Header                                                            BUG10603
                                                                                            BUG10603
     C                   WHEN      PTknTyp = '*COL'                                         BUG10603
     C                   EVAL      ROUTH32 = %TRIM(PToken)                                  BUG10603
                                                                                            BUG10603
      ** Check for overflow                                                                 BUG10603
                                                                                            BUG10603
     C                   EVAL      RqdLn1 = 2                                               BUG10603
     C                   EVAL      WItemFlagH ='B'                                          BUG10603
     C                   EXSR      SRCHKLIN                                                 BUG10603
     C                   WRITE     HeadP32                                                  BUG10603
                                                                                            BUG10603
      ** Determine Column Detail                                                            BUG10603
                                                                                            BUG10603
     C                   WHEN      PTknTyp = '*DOC'                                         BUG10603
     C                   EVAL      ROUTD32 = %TRIM(Ptoken)                                  BUG10603
                                                                                            BUG10603
      ** Check for overflow                                                                 BUG10603
                                                                                            BUG10603
     C                   EVAL      RqdLn1 = 1                                               BUG10603
     C                   EXSR      SRChkLinA                                                BUG10603
     C                   WRITE     Detail32                                                 BUG10603
                                                                                            BUG10603
     C                   ENDSL                                                              BUG10603
                                                                                            BUG10603
     C                   ENDDO                                                              BUG10603
                                                                                            BUG10603
     C                   ENDSL                                                              BUG10603
                                                                                            BUG10603
     C                   ENDSR                                                              BUG10603
 
      *****************************************************************                     BUG10603
      /EJECT                                                                                BUG10603
      *****************************************************************                     BUG10603
      *                                                               *                     BUG10603
      * SRKycNotFound - No record found in SDKYCIPD                   *                     BUG10603
      *                                                               *                     BUG10603
      * Called by: SRPROC                                             *                     BUG10603
      *                                                               *                     BUG10603
      * Calls:                                                        *                     BUG10603
      *                                                               *                     BUG10603
      *****************************************************************                     BUG10603
                                                                                            BUG10603
     C     SRKycNotFound BEGSR                                                              BUG10603
                                                                                            BUG10603
     C                   EVAL      RqdLn1 = 10                                              BUG10603
     C                   EVAL      DifLn1 = OFLLN1 - PRTLN1                                 BUG10603
     C                                                                                      BUG10603
     C                   IF        DifLn1 <= RqdLn1                                         BUG10603
     C                   WRITE     HEADP1                                                   BUG10603
     C                   WRITE     HEADP21                                                  BUG10603
     C                   WRITE     NoDetail                                                 BUG10603
     C                   WRITE     HEADP31                                                  BUG10603
     C                   WRITE     NoDetail                                                 BUG10603
     C                   ELSE                                                               BUG10603
     C                   WRITE     HEADP21                                                  BUG10603
     C                   WRITE     NoDetail                                                 BUG10603
     C                   WRITE     HEADP31                                                  BUG10603
     C                   WRITE     NoDetail                                                 BUG10603
     C                   ENDIF                                                              BUG10603
                                                                                            BUG10603
     C                   ENDSR                                                              BUG10603
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRRCFP1 - Detail Spool File recorded by RCF                   *
      *                                                               *
      * Called by: SRINIT                                             *
      *                                                               *
      * Calls: ZSFILE                                                 *
      *                                                               *
      *****************************************************************
 
     C     SRRCFP1       BEGSR
 
      ** Ensure Detail Spool File recorded by RCF.
 
     C                   EVAL      PZSnum = PSFNum1
 
     C                   CALL      'ZSFILE'
     C                   PARM                    PSeq
     C                   PARM      *Blanks       PEnty
     C                   PARM                    PSFile1
     C                   PARM                    PZSnum
     C                   PARM      *Blank        PZSerr
 
      ** If Error occurs during ZSFILE processing, then return to the
      ** Calling Program.
 
     C                   IF        PZSerr = 'Y'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAudit - Write audit report                                 *
      *                                                               *
      *****************************************************************
     C     SRAudit       BEGSR
 
     C**********         OPEN      SD000040AU                                                CSD028A
     C                   OPEN      SD000055AU                                                CSD028A
 
      ** Ensure Audit Spool File recorded by RCF.
 
     C                   EVAL      PZSnum = PSFNum2
 
     C                   CALL      'ZSFILE'
     C                   PARM                    PSeq
     C                   PARM      *Blanks       PEnty
     C                   PARM                    PSFile2
     C                   PARM                    PZSnum
     C                   PARM      *Blank        PZSerr
 
      ** If Error occurs during ZSFILE processing, then return to the
      ** Calling Program.
 
     C                   IF        PZSERR = 'Y'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
 
     C                   WRITE     HEADAU
 
      ** If there is a DB Error, Output the DB Error Information.
 
     C                   IF        WError = 'Y'
     C                   WRITE     DBERROR
     C                   ELSE
     C                   WRITE     NODTLS
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRRTVBRCH - Access Branch Details                             *
      *                                                               *
      * Called by: SRPROC                                             *
      *                                                               *
      * Calls: AOBRCHR1, SRAUDIT                                      *
      *                                                               *
      *****************************************************************
 
     C     SRRTVBRCH     BEGSR
     C                   CALL      'AOBRCHR1'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      '*KEY   '     POption
     C                   PARM                    PBRCA
     C     SDBRCH        PARM      SDBRCH        DSSDY
 
     C                   IF        PRetCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDBRCHPD'
     C                   EVAL      DBKEY = PBRCA
     C**********         EVAL      DBPGM = 'SD000040'                                        CSD028A
     C                   EVAL      DBPGM = 'SD000055'                                        CSD028A
     C                   EVAL      DBASE = 002
     C                   OUT       LDA
     C                   EVAL      WError = 'Y'
     C                   EXSR      SRAUDIT
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRDATE - Convert Date to DDMMYY                               *
      *                                                               *
      * Called by: SRPRNT                                             *
      *                                                               *
      * Calls: ZDATE2                                                 *
      *                                                               *
      *****************************************************************
 
     C     SRDATE        BEGSR
 
     C                   CALL      'ZDATE2'
     C                   PARM                    PZDateIN
     C                   PARM                    PDfinIN
     C                   PARM      *ZEROS        PZDateOUT
     C                   PARM      *BLANKS       PZADateOUT
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRCHKLIN - Checks for printer file overflow condition         *
      *                                                               *
      * Called by: SRPROC, SRPRNT                                     *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SRCHKLIN      BEGSR
 
     C                   EVAL      DifLn1 = OFLLN1 - PRTLN1
 
     C                   IF        DifLn1 <= RqdLn1
     C                             OR WFirst  = 'Y'
     C                             OR NewPage = 'Y'
     C                   WRITE     HEADP1
     C                   EVAL      WFirst  = 'N'
     C                   EVAL      NewPage = 'N'
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT                                                                                BUG10603
      *****************************************************************                     BUG10603
      *                                                               *                     BUG10603
      * SRChkLinA - Checks for printer file overflow condition        *                     BUG10603
      *                                                               *                     BUG10603
      *****************************************************************                     BUG10603
                                                                                            BUG10603
     C     SRChkLinA     BEGSR                                                              BUG10603
                                                                                            BUG10603
     C                   EVAL      DifLn1 = OFLLN1 - PRTLN1                                 BUG10603
                                                                                            BUG10603
     C                   SELECT                                                             BUG10603
                                                                                            BUG10603
     C                   WHEN      DifLn1 <= RqdLn1                                         BUG10603
     C                   WRITE     HEADP1                                                   BUG10603
                                                                                            BUG10603
     C                   IF        WItemFlagH = 'A'                                         BUG10603
     C                   WRITE     HEADP21                                                  BUG10603
     C                   ELSE                                                               BUG10603
     C                   WRITE     HEADP31                                                  BUG10603
     C                   ENDIF                                                              BUG10603
     C                   EVAL      WPass1 = 'N'                                             BUG10603
                                                                                            BUG10603
     C                   WHEN      DifLn1 > RqdLn1 and WPass1 = ' '                         BUG10603
                                                                                            BUG10603
     C                   EVAL      WPass1 = 'N'                                             BUG10603
     C                   IF        WItemFlagH = 'A'                                         BUG10603
     C                   WRITE     HEADP21                                                  BUG10603
     C                   ELSE                                                               BUG10603
     C                   WRITE     HEADP31                                                  BUG10603
     C                   ENDIF                                                              BUG10603
                                                                                            BUG10603
     C                   ENDSL                                                              BUG10603
                                                                                            BUG10603
     C                   ENDSR                                                              BUG10603
      *****************************************************************                     BUG10603
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    PMode
     C                   PARM                    PSeq
     C                   PARM                    PEnty
 
     C/COPY ZACPYSRC,DBFIELDS
 
      ** Access Bank Details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      '*FIRST '     POption
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database Error
 
     C                   IF        PRetCode <> *BLANKS
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE = 1
     C                   EVAL      DBKEY = '*FIRST'
     C**********         EVAL      DBPGM = 'SD000040'                                        CSD028A
     C                   EVAL      DBPGM = 'SD000055'                                        CSD028A
     C                   EVAL      WError = 'Y'
     C                   EXSR      SRAUDIT
     C                   EXSR      *PSSR
     C                   ELSE
     C                   EVAL      PDfinIN = BJDFIN
     C                   ENDIF
 
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
      * Called by: (**calling routines**)                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *PSSR         BEGSR
 
     C                   DUMP
 
     C                   IF        RunBefore = *BLANK
     C                   EVAL      RunBefore = 'Y'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      PRetCode = '*ERROR'
 
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
 
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2005
