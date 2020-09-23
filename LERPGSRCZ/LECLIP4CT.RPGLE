     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Customer Loans cnv: file to screen DSP 4')    *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending ILE Module                          *
      *                                                               *
      *  LECLIP4CT - Customer Loans cnv: file to screen DSPF 4        *
      *                                                               *
      *  Function:  This module converts the fields of a customer     *
      *             loan from their format as on file to a screen     *
      *             format (record format 4)                          *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. CER050             Date 16Jun19               *
      *                 MD046248           Date 27Oct17               *
      *                 CLE141             Date 08Feb16               *
      *                 CLE134             Date 01Aug12               *
      *                 CLE148             Date 23Jul12               *
      *                 CRE073             Date 06Dec10               *
      *                 CLE143             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER020             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 BUG10574           Date 02Mar06               *
      *                 CLE042             Date 06Sep05               *
      *                 CLE106             Date 01Aug04               *
      *                 CLE036             Date 22Sep03               *
      *                 CLE034             Date 05May03               *
      *                 CLE031             Date 03Feb03               *
      *                 CAP086             Date 08Jun05               *
      *                 TDA023             Date 22Mar04               *
      *                 CLE030             Date 29Aug02               *
      *                 CAP074  *CREATE    Date 05Apr02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *             (Recompile)                                       *
      *  CER050 - Annualised Percentage Rate (Recompile)              *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE141 - Currency and Location Business Day Convention for   *
      *           Lending Transactions                                *
      *  CLE134 - Past Due Call Loan Processing                       *
      *  CLE148 - Alpha Loan Reference (Recompile)                    *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CLE143 - Original Loan Contract Date & Effective Interest    *
      *           Rate (Recompile)                                    *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus (Recompile)                              *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG10574 - Recompiled due to changes in LECLI4PD.            *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  CLE106 - Syndications Manager. (Recompiled)                  *
      *  CLE036 - Lending Enhancements for Nordea Phase 1 Priority 2  *
      *           Allow specific base rates  (Recompile)              *
      *  CLE034 - Lending Enhancements Phase 1 Priority 1A            *
      *           (Recompile)                                         *
      *  CLE031 - Lending Enhancements (Recompile)                    *
      *  CAP086 - Introduce Auto Authorisation to the API's           *
      *           without it. (Recompile)                             *
      *  TDA023 - Increase Maturity Date Account to 18 Digits         *
      *           (Recompile)                                         *
      *  CLE030 - Release Authorisation processing                    *
      *  CAP074 - Lending API enhancements - Loans input.             *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
      *
     D/COPY ZACPYSRC,STD_D_SPEC
      *
      ** Include the MM standard declares
     D/COPY ZACPYSRC,STDDECLARE
      *
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
      *
     D/COPY ZACPYSRC,PSDS
      *
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
     D LoanFilFmtCL  E DS                  EXTNAME(CLOANCL)
     D  BsDayFilFmt         1906   2025                                                       CLE141
      ***  Loan in file Format CL
      *
     D LoanFilFmtCK  E DS                  EXTNAME(CLOANCK)
      ***  Loan in file Format CK
     D                                     PREFIX(K_)
      *
     D LoanScnFmt4   E DS                  EXTNAME(LECLI4PD)
     D LoanScnFmt6   E DS                  EXTNAME(LECLI6PD)                                  CLE134
     D LoanScnFmt7   E DS                  EXTNAME(LECLI7PD)                                  CLE141
      ***  Loan in Screen Format
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ***  External DS for bank details
      *
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CLE134
     D SCA_LCD       E                     EXTFLD(LCD)                                        CLE134
      *                                                                                       CLE134
      ** EXTERNAL DS FOR SAR DETAILS                                                          CLE134
      *                                                                                       CLE134
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ***  First DS for access programs, short data structure
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
                                                                                              CLE134
     D CLE134          S              1                                                       CLE134
     D PRTCD           S              7A                                                      CLE134
     D POPTN           S              7A                                                      CLE134
     D PSARD           S              6A                                                      CLE134
     D CLE141          S              1                                                       CLE141
      *
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ***  Initialization
      *
     C                   EXSR      INIT
      *
      ***  Set output screen fields
      *
     C                   EXSR      SETFLD
      *
      ***  Return
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      ** SETFLD - Set output screen fields                            *
      *****************************************************************
     C     SETFLD        BEGSR
      *
      ***  Loan status
      *
     C                   SELECT
     C     RECI          WHENEQ    'M'
     C                   MOVEL     'LEL0496'     ZAMSID
     C     RECI          WHENEQ    'R'
     C                   MOVEL     'LEL0088'     ZAMSID
     C     LSTS          WHENEQ    'C'
     C                   MOVEL     'LEL0098'     ZAMSID
     C     LSTS          WHENEQ    'R'
     C                   MOVEL     'LEL0086'     ZAMSID
     C     LSTS          WHENEQ    'A'
     C                   MOVEL     'LEL0087'     ZAMSID
     C     LSTS          WHENEQ    'D'
     C                   MOVEL     'LEL0088'     ZAMSID
     C     LSTS          WHENEQ    'Q'                                                        CLE030
     C                   MOVEL     'LEL0124'     ZAMSID                                       CLE030
     C                   ENDSL
     C                   EXSR      SRTEXT
     C                   MOVEL     ZAMSTP        DDLST4
     C                   MOVE      *BLANKS       ZAMSID
      *
      ***  Loan number
      *
     C                   MOVE      LNRF          DDLNR4
      *
      ***  Special instructions - 1
      *
     C                   MOVEL     K_SPI1        DDSPI1
      *
      ***  Special instructions - 2
      *
     C                   MOVEL     K_SPI2        DDSPI2
      *
      ***  Special instructions - 3
      *
     C                   MOVEL     K_SPI3        DDSPI3
      *
      ** If Past Due Call Loan Processing Present;                                            CLE134
      ** - Set Facility Amount Utilisation.                                                   CLE134
      *                                                                                       CLE134
     C                   IF        CLE134      = 'Y'                                          CLE134
     C                   EVAL      DDFAMU      = FAMU                                         CLE134
      *                                                                                       CLE134
      ** - Set Reporting Past Due Initial Date.                                               CLE134
      *                                                                                       CLE134
     C                   MOVE      RIDT          ZDateNum                                     CLE134
     C                   MOVE      BJDFIN        ZDateFmtInd                                  CLE134
     C                   CALL      'ZDATE2'                                                   CLE134
     C                   PARM                    ZDateNum          5 0                        CLE134
     C                   PARM                    ZDateFmtInd       1                          CLE134
     C                   PARM                    ZDateFmt6         6 0                        CLE134
     C                   PARM                    ZDateFmt7         7                          CLE134
      *                                                                                       CLE134
     C                   MOVE      ZDateFmt6     DDRIDT                                       CLE134
      *                                                                                       CLE134
      ** - Set Reporting Past Due Classification.                                             CLE134
      *                                                                                       CLE134
     C                   MOVEL     RCAT          DDRCAT                                       CLE134
      *                                                                                       CLE134
     C                   IF        DDRCAT      = *BLANKS                                      CLE134
     C                   EVAL      DDRCAT      = '0'                                          CLE134
     C                   ENDIF                                                                CLE134
      *                                                                                       CLE134
      ** - Set Basel II Past Due Initial Date.                                                CLE134
      *                                                                                       CLE134
     C                   MOVE      BIDT          ZDateNum                                     CLE134
     C                   MOVE      BJDFIN        ZDateFmtInd                                  CLE134
     C                   CALL      'ZDATE2'                                                   CLE134
     C                   PARM                    ZDateNum          5 0                        CLE134
     C                   PARM                    ZDateFmtInd       1                          CLE134
     C                   PARM                    ZDateFmt6         6 0                        CLE134
     C                   PARM                    ZDateFmt7         7                          CLE134
      *                                                                                       CLE134
     C                   MOVE      ZDateFmt6     DDBIDT                                       CLE134
      *                                                                                       CLE134
      ** - Set Basel II Past Due Classification.                                              CLE134
      *                                                                                       CLE134
     C                   MOVEL     BCAT          DDBCAT                                       CLE134
      *                                                                                       CLE134
     C                   IF        DDBCAT      = *BLANKS                                      CLE134
     C                   EVAL      DDBCAT      = '0'                                          CLE134
     C                   ENDIF                                                                CLE134
      *                                                                                       CLE134
     C                   ENDIF                                                                CLE134
      *                                                                                       CLE134
     C                   IF        CLE141 = 'N'                                               CLE141
     C                   EVAL      LoanScnFmt7 = BsDayFilFmt                                  CLE141
     C                   ENDIF                                                                CLE141
                                                                                              CLE141
     C                   IF        CLE141 = 'Y'                                               CLE141
     C                   EVAL      DDC1PR = C1PR                                              CLE141
     C                   EVAL      DDC2PR = C2PR                                              CLE141
     C                   EVAL      DDC3PR = C3PR                                              CLE141
     C                   EVAL      DDC4PR = C4PR                                              CLE141
     C                   EVAL      DDC5PR = C5PR                                              CLE141
     C                   EVAL      DDC6PR = C6PR                                              CLE141
     C                   EVAL      DDC7PR = C7PR                                              CLE141
     C                   EVAL      DDC8PR = C8PR                                              CLE141
     C                   EVAL      DDC9PR = C9PR                                              CLE141
     C                   EVAL      DDC0PR = C0PR                                              CLE141
     C                   EVAL      DDL1PR = L1PR                                              CLE141
     C                   EVAL      DDL2PR = L2PR                                              CLE141
     C                   EVAL      DDL3PR = L3PR                                              CLE141
     C                   EVAL      DDL4PR = L4PR                                              CLE141
     C                   EVAL      DDL5PR = L5PR                                              CLE141
     C                   EVAL      DDL6PR = L6PR                                              CLE141
     C                   EVAL      DDL7PR = L7PR                                              CLE141
     C                   EVAL      DDL8PR = L8PR                                              CLE141
     C                   EVAL      DDL9PR = L9PR                                              CLE141
     C                   EVAL      DDL0PR = L0PR                                              CLE141
     C                   EVAL      DDC1PI = C1PI                                              CLE141
     C                   EVAL      DDC2PI = C2PI                                              CLE141
     C                   EVAL      DDC3PI = C3PI                                              CLE141
     C                   EVAL      DDC4PI = C4PI                                              CLE141
     C                   EVAL      DDC5PI = C5PI                                              CLE141
     C                   EVAL      DDC6PI = C6PI                                              CLE141
     C                   EVAL      DDC7PI = C7PI                                              CLE141
     C                   EVAL      DDC8PI = C8PI                                              CLE141
     C                   EVAL      DDC9PI = C9PI                                              CLE141
     C                   EVAL      DDC0PI = C0PI                                              CLE141
     C                   EVAL      DDL1PI = L1PI                                              CLE141
     C                   EVAL      DDL2PI = L2PI                                              CLE141
     C                   EVAL      DDL3PI = L3PI                                              CLE141
     C                   EVAL      DDL4PI = L4PI                                              CLE141
     C                   EVAL      DDL5PI = L5PI                                              CLE141
     C                   EVAL      DDL6PI = L6PI                                              CLE141
     C                   EVAL      DDL7PI = L7PI                                              CLE141
     C                   EVAL      DDL8PI = L8PI                                              CLE141
     C                   EVAL      DDL9PI = L9PI                                              CLE141
     C                   EVAL      DDL0PI = L0PI                                              CLE141
     C                   ENDIF                                                                CLE141
                                                                                              CLE141
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRTEXT  -  Set up text from message file.                     *
      *****************************************************************
     C     SRTEXT        BEGSR
      *
     C                   CALL      'Y2RVMGC'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM                    ZAMSID            7            Message Id.
     C                   PARM      'LERMSGF '    ZAMSGF           10            Message file.
     C                   PARM                    ZAMSDA          132            Message data.
     C                   PARM                    ZAMSTP          132            Messge text
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * INIT - Initialization                                         *
      *****************************************************************
     C     INIT          BEGSR
      *
      ***  Blank outputs (except for action code within loan format)
      *
     C                   MOVEL     DDACT4        ##ACTN            1
     C                   MOVEL     *BLANK        LoanScnFmt4
     C                   MOVEL     *BLANK        LoanScnFmt6                                  CLE134
     C                   MOVEL     ##ACTN        DDACT4
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Initial processing                                   *
      *****************************************************************
     C     *INZSR        BEGSR
      *
      ***  Program parameters
      *
     C     *ENTRY        PLIST
      *
      ***  INPUTS parameters
      *
      ***  Return Code
      *
     C                   PARM                    RetCodeIn
      *
      ***  Loan in file format CL
      *
     C                   PARM                    LoanFilFmtCL
      *
      ***  Loan in file format CK
      *
     C                   PARM                    LoanFilFmtCK
      *
      ***  OUTPUT parameters
      *
      ***  Loan in screen format
      *
     C                   PARM                    LoanScnFmt4
     C                   PARM                    LoanScnFmt6                                  CLE134
     C                   PARM                    LoanScnFmt7                                  CLE141
      *
      ***  Initialize program name
      *
     C                   MOVEL     'LECLIP4CT'   DBPGM
      *
      ***  Access bank details
      *
     C                   CALLB     'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ***  Database error
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     @OPTN         DBKEY
     C                   MOVEL     'SDBANKPD'    DBFILE                         *************
     C                   MOVEL     '001'         DBASE                          * DBERR 001 *
     C                   EXSR      *PSSR                                        *************
     C                   END
      *
     C                   CALLB     'AOSARDR0'                                                 CLE134
     C                   PARM      *BLANKS       PRTCD                                        CLE134
     C                   PARM      '*VERIFY'     POPTN                                        CLE134
     C                   PARM      'CLE134'      PSARD                                        CLE134
     C     SCSARD        PARM      SCSARD        DSFDY                                        CLE134
      *                                                                                       CLE134
     C                   IF        PRTCD      <> *BLANKS       AND                            CLE134
     C                             PRTCD      <> '*NRF   '                                    CLE134
     C                   EVAL      DBFILE      = 'SCSARDPD'                                   CLE134
     C                   EVAL      DBKEY       = 'CLE134'                                     CLE134
     C                   EVAL      DBASE       = 002                                          CLE134
     C                   EXSR      *PSSR                                                      CLE134
     C                   ENDIF                                                                CLE134
      *                                                                                       CLE134
     C                   IF        PRTCD       = *BLANKS                                      CLE134
     C                   EVAL      CLE134      = 'Y'                                          CLE134
      *                                                                                       CLE134
     C                   ELSE                                                                 CLE134
     C                   EVAL      CLE134      = 'N'                                          CLE134
     C                   ENDIF                                                                CLE134
                                                                                              CLE141
      ** Determine if CLE141 is switched on                                                   CLE141
                                                                                              CLE141
     C                   CALLB     'AOSARDR0'                                                 CLE141
     C                   PARM      *BLANKS       PRTCD                                        CLE141
     C                   PARM      '*VERIFY'     POPTN                                        CLE141
     C                   PARM      'CLE141'      PSARD                                        CLE141
     C     SCSARD        PARM      SCSARD        DSFDY                                        CLE141
      *                                                                                       CLE141
     C                   IF        PRTCD      <> *BLANKS       AND                            CLE141
     C                             PRTCD      <> '*NRF   '                                    CLE141
     C                   EVAL      DBFILE      = 'SCSARDPD'                                   CLE141
     C                   EVAL      DBKEY       = 'CLE141'                                     CLE141
     C                   EVAL      DBASE       = 003                                          CLE141
     C                   EXSR      *PSSR                                                      CLE141
     C                   ENDIF                                                                CLE141
      *                                                                                       CLE141
     C                   IF        PRTCD       = *BLANKS                                      CLE141
     C                   EVAL      CLE141      = 'Y'                                          CLE141
     C                   ELSE                                                                 CLE141
     C                   EVAL      CLE141      = 'N'                                          CLE141
     C                   ENDIF                                                                CLE141
      *                                                                                       CLE141
     C                   ENDSR
      *****************************************************************
      /EJECT
      ********************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2002
