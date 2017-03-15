     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2014')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL Customer Balance Collection')                 *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GL000621 - Midas GL Customer Balance Collection              *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2014            *
      *                                                               *
      *  Last Amend No. MD044377           Date 28Feb17               *
      *  Prev Amend No. MD043973           Date 03Feb17               *
      *                 MD042828           Date 15Dec16               *
      *                 MD042683           Date 22Nov16               *
      *                 CGL154  *CREATE    Date 13Oct14               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD044377 - Traded FRA is captured in FATCA EOY customer      *
      *             balance collection file                           *
      *  MD043973 - FATCA Account closed file entries are not         *
      *             transferred to FATCA EOY archive file             *
      *  MD042828 - Daily Accounts Closed/Transferred File cannot     *
      *             capture other FATCA Accounts                      *
      *  MD042683 - Daily Accounts Closed/Transferred File cant store *
      *             reported closed/transferred Accounts under        *
      *             Joint Account Members                             *
      *  CGL154 - FATCA Reporting                                     *
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

      ** Midas DL DEALSDC/DEALSDD by Deal-type/Sub-Type
     FDEALSL54  IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(DC_)

      ** Midas LE Participations sold by loan
     FPSOLD     IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(CL_)

      ** Midas DL FRA live deals
     FDLDLDGLC  IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(FR_)

      ** Midas DL IRS live deals
     FDLDLDGLD  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(DEALSDGF:DEALSDG0)
     F                                     PREFIX(IR_)

      ** Midas DRS/FX Take on Master File
     FFXTODLLL  IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(DB_)

      ** Midas SE Securities r File
     FSECTY     IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(SE_)

      ** Midas SE Investment Types Detail
     FINVTPC    IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(IV_)

      ** Midas Customer Positions
     FSESEPSLL  IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(CP_)

      ** Midas GL FATCA FF Transaction detail

     FTRANSD    IF   E           k DISK    INFSR(*PSSR)
     F                                     PREFIX(TR_)
     F                                     INFDS(FSDS)

     FTRANS     IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(TRANSDF:TRANS0)
     F                                     PREFIX(TS_)
     F                                     EXTMBR('*ALL')

      ** Midas FF Selected Instrument Type Details
     FINTYP     IF   E           K DISK    INFSR(*PSSR)

      ** Midas SD Currency codes retrieval
     FPRICS1    IF   E           K DISK    INFSR(*PSSR)

      ** Midas GL FATCA Customer Balance Collection File
     FGLFCABPD  IF   E             DISK    INFSR(*PSSR)
     F                                     PREFIX(CA)

      ** Midas RE History header records
     FRELIVE    IF   E             DISK    INFSR(*PSSR)
     F                                     PREFIX(RE_)

      ** Midas GL Closed Accounts
     F***ACCNTL16  IF   E             DISK    INFSR(*PSSR)                                  MD042683
     FACCNTL18  IF   E             DISK    INFSR(*PSSR)                                     MD042683
     F                                     PREFIX(GC_)
     F                                     RENAME(ACCNTABF:ACCNTABG)

      ** Midas RE Retail History Posting
     FREHISDL   IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(RH_)

     FSDJACCL0  IF   E           K DISK    INFSR(*PSSR)

      ** Midas GL FATCA Customer Balance Collection File
     FGLCSBAPD  O    E             DISK    INFSR(*PSSR)

      ** Midas SD Nostro Details
     FSDNOSTLB  IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(NO_)

      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs: Arrays and Data Structures  ¦
      ** ¦ =======  ==========================  ¦
      ** +--------------------------------------+

      ** External DS Based On SDCURRPD
     D SDCURR        E DS                  EXTNAME(SDCURRPD)

      ** External DS Based On SDCUSDPD
     D SDCUSD        E DS                  EXTNAME(SDCUSTPD)

      ** Local data area for database error details
     D LDA           E DS           256    EXTNAME(LDA) DTAARA(LDA)

      ** Long Data Structure
     D DSSDY         E DS                  EXTNAME(DSSDY)

      ** ** Short Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)

      ** Data Structures used by Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)

      ** Data Structure used by GLCSBADPD
     D GLCSBA        E DS                  EXTNAME(GLCSBAPD)
                                                                                            MD044377
      ** Midas Book Codes File                                                              MD044377
     D SDBOOK        E DS                  EXTNAME(SDBOOKPD)                                MD044377

     ** File Status Data Structure
     D FSDS            DS
     D  FMBR                 129    138

      ** Override Database Table
     D QCMD1           S             50A   INZ(*BLANKS)

      ** +--------------------------------------+
      ** ¦ D-specs: Declared variables          ¦
      ** ¦ =======  ==================          ¦
      ** +--------------------------------------+

      ** Declared Variables
     D WWTRNO          S              6
     D WMktVal         S             15  0
     D WWAMT           S             19  3
     D WWQOTC          S              1  0
     D PCurr           S              3A
     D POptn           S              7A
     D PRtcd           S              7A
     D PCust           S             10A
     D PKySt           S              7A
     D WBrch           S              3A
     D PInit           S              1A
     D WMatD           S              5P 0
     D WWRITE          S              1A
     D WWTNBR          S                   LIKE(TR_TNBR)
     D WWMBR           S             10A   INZ(' ')
     D WMsgLen         S             15P 5 INZ(50)
     D PPFTC           S              2                                                     MD044377

      ** Declare Keys
     D KInvTp          S              3A
     D KInvCy          S              3A
     D KISTT           S              5A
     D KMTHN           S              2  0
     D KPCAL           S              1A
     D KSTRP           S             15  8
     D KYRNO           S              2  0
     D KNCUST          S              6A
     D KBRCA           S              3A
     D KCNUM           S              6A
     D KCCY            S              3A
     D KACOD           S             10S 0
     D KACSQ           S              2S 0
     D KHISD           S              5P 0

      ** Parameters for ZDATE9
     D DayOut8         S              8S 0
     D WNacrDt         S              8
     D DateIn5         S              5P 0
     D WDateYYYY       S              4A
     D WYearEnd        S              4A
     D WYearNum        S              4S 0

      ** Parameters for SrFFTVCL
     D FFNOC           S              5  0
     D FFTKDM          S              3  0
     D FFMNPF          S             15  8
     D FFNOT1          S             16  3
     D FFTNVL          S             13  0
     D FFNOTK          S             13  0

     D FFFP            DS            15
     D  FFPRIC                 1     15  8
     D  FFINTG                 1      7  0
     D  FFIN                   1      7
     D  FFDCN1                 8      8  0
     D  FFDCN2                 8      9  0
     D  FFDCN3                 8     10  0
     D  FFDECN                 8     10  0
     D  FFDECD                 8     15  0
     D  FFDECA                 8     15
     D  FFDCN4                 9     11  3
     D  FFDCN5                10     12  3
     D  FFDCN6                11     13  3

      ** Declared Constants

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
      * MAIN PROCEDURE                                                *
      *****************************************************************

      ** Money market and Fiduciary deposits processing

     C                   EXSR      SrDlsDC

      ** Lending participation sold processing

     C                   EXSR      SrCLoan

      ** Foreign exchange deals processing

     C                   EXSR      SrDlsDB

      ** Midas DL FRA live deals processing

     C                   EXSR      SrDlFRA

      ** Midas DL IRS live deals processing

     C                   EXSR      SrDlIRS

      ** Midas Securities records processing

     C                   EXSR      SrSecPr

      ** Futures and Options Transaction details Processing

     C                   EXSR      SrTrans

     C                   IF        PInit = ' '
      ** Accounts Closed / Transferred Collection Processing
     C                   EXSR      SrGLATC

      ** Retail Accounts file Processing
     C                   EXSR      SrRetAc
     C                   ELSE
     C                   EXSR      SrCloRetAc
     C                   ENDIF

     C                   EVAL      *INLR = *ON

      *****************************************************************
      *  P R O G R A M   E N D                                        *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation routine                      *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR

     C     *ENTRY        PLIST
     C
     C                   PARM                    PInit

     C                   IF        PInit = ' '
     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM  =  'GL000621'
     C                   OUT       LDA
     C                   ENDIF

      ** Key list for Investment Type

     C     KInvTyp       KLIST
     C                   KFLD                    KInvTp
     C                   KFLD                    KInvCy

     C     KPRIC         KLIST
     C                   KFLD                    KISTT
     C                   KFLD                    KYRNO
     C                   KFLD                    KMTHN
     C                   KFLD                    KPCAL
     C                   KFLD                    KSTRP

     C     KRHIS         KLIST
     C                   KFLD                    KBRCA
     C                   KFLD                    KCNUM
     C                   KFLD                    KCCY
     C                   KFLD                    KACOD
     C                   KFLD                    KACSQ
     C                   KFLD                    KHISD

      ** Get Midas run day number

     C                   CALLB     'AOBANKR0'
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

     C                   EVAL      DateIn5 = BJRDNB

      ** Get the current year

     C                   EXSR      SrGetYr

     C                   EVAL      WYearEnd = WDateYYYY
     C                   IF        PInit = 'Y'
     C                   MOVE      WYearEnd      WYearNum
     C                   EVAL      WYearNum = WYearNum -1
     C                   MOVE      WYearNum      WYearEnd
     C                   ENDIF
     C                   EVAL      WMatD = 15706


     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrDlsDC - DEALSDC Money market and Fiduciary deposits        *
      *                                                               *
      *****************************************************************
     C     SrDlsDC       BEGSR

     C     *LOVAL        SETLL     DEALSL54
     C                   READ      DEALSL54

      ** Populate GLCSBAPD file while DEALSL54 end of file not reached.

     C                   DOW       NOT %EOF(DEALSL54)

     C                   CLEAR                   GLCSBA

     C                   EVAL      CBYEAR = WYearEnd
     C                   EVAL      CBBALN = DC_PCPL
     C                   EVAL      CBCURR = DC_CCY
     C                   EVAL      CBTTYP = DC_DTYP + DC_DLST
     C                   MOVEL     DC_DLNO       WWTRNO
     C                   EVAL      CBTRNN = 'DL' + WWTRNO
     C                   IF        DC_DTYP = 'CI'
     C                   MOVEL     DC_CHNA       CBCUST
     C                   ELSE
     C                   MOVEL     DC_CNUM       CBCUST
     C                   ENDIF
     C                   EXSR      SrCust

     C                   EVAL      CBBRCH = DC_BRCA

     C                   IF        PInit = *Blanks OR
     C                             (PInit = 'Y'
     C                             AND WMatD >= DC_DDAT
     C                             AND WMatD <= DC_MDAT
     C                             AND DC_MDAT <> 0)
     C                             OR (PInit = 'Y'
     C                             AND WMatD >= DC_DDAT
     C                             AND DC_MDAT = 0)
     C                   EXSR      SRWriteCSBA
     C                   ENDIF

     C                   READ      DEALSL54

     C                   ENDDO

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrCLoan - CLOANCL Lending participation sold processing      *
      *                                                               *
      *****************************************************************
     C     SrCLoan       BEGSR

     C     *LOVAL        SETLL     PSOLD
     C                   READ      PSOLD

      ** Populate GLCSBAPD file while PSOLD end of file not reached.

     C                   DOW       NOT %EOF(PSOLD)

     C                   CLEAR                   GLCSBA

     C                   EVAL      CBYEAR = WYearEnd
     C                   EVAL      CBBALN = CL_CPAM
     C                   EVAL      CBCURR = CL_CCY
     C                   EVAL      CBTTYP = CL_LTYP + CL_SUTP
     C                   MOVEL     CL_LNRF       WWTRNO
     C                   EVAL      CBTRNN = 'LE' + WWTRNO
     C                   MOVEL     CL_CNUM       CBCUST
     C                   EXSR      SrCust

     C                   EVAL      CBBRCH = CL_BRCA

     C                   IF        PInit = *Blanks OR
     C                             (PInit = 'Y'
     C                             AND WMatD >= CL_DDAT
     C                             AND WMatD <= CL_MDAT
     C                             AND CL_MDAT <> 0)
     C                             OR (PInit = 'Y'
     C                             AND WMatD >= FR_DDAT
     C                             AND CL_MDAT = 0)
     C                   EXSR      SRWriteCSBA
     C                   ENDIF

     C                   READ      PSOLD
     C                   ENDDO

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrDlsDB - DEALSDB Midas DL Foreign exchange deals processing *
      *                                                               *
      *****************************************************************
     C     SrDlsDB       BEGSR

     C     *LOVAL        SETLL     FXTODLLL
     C                   READ      FXTODLLL

      ** Populate GLCSBAPD file while FXTODLLL end of file not reached.

     C                   DOW       NOT %EOF(FXTODLLL)

      ** Write live records only

     C                   IF        DB_RECI = 'D'

     C                   CLEAR                   GLCSBA

     C                   EVAL      CBYEAR = WYearEnd
     C                   EVAL      CBBALN = DB_SLAM
     C                   EVAL      CBCURR = DB_SLCY
     C                   EVAL      CBTTYP = DB_DTYP + DB_DLST
     C                   MOVEL     DB_CNUM       CBCUST
     C                   EXSR      SrCust

     C                   EVAL      CBBRCH = DB_BRCA
     C                   MOVEL     DB_DLNO       WWTRNO
     C                   EVAL      CBTRNN = 'DL' + WWTRNO

     C                   IF        PInit = *Blanks
     C                             OR (PInit = 'Y'
     C                             AND WMatD >= DB_DDAT
     C                             AND DB_OTDT <> 0
     C                             AND WMatD <= DB_OTDT)
     C                             OR (PInit = 'Y'
     C                             AND WMatD >= DB_DDAT
     C                             AND DB_OTDT = 0
     C                             AND WMatD <= DB_VDAT)
     C                   EXSR      SRWriteCSBA
     C                   ENDIF

     C                   ENDIF

     C                   READ      FXTODLLL
     C                   ENDDO

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrDlFRA - DEALSDG Midas DL FRA live deals processing         *
      *                                                               *
      *****************************************************************
     C     SrDlFRA       BEGSR

     C     *LOVAL        SETLL     DLDLDGLC
     C                   READ      DLDLDGLC

      ** Populate GLCSBAPD file while end of file not reached.

     C                   DOW       NOT %EOF(DLDLDGLC)

     C                   CLEAR                   GLCSBA

     C                   EVAL      CBYEAR = WYearEnd
     C                   EVAL      CBBALN = FR_UPAMT
     C                   EVAL      CBCURR = FR_UCUCY
     C                   EVAL      CBTTYP = FR_DTYP + FR_DLST
     C                   MOVEL     FR_CNUM       CBCUST
     C                   EXSR      SrCust

     C                   EVAL      CBBRCH = FR_BRCA
     C                   MOVEL     FR_DLNO       WWTRNO
     C                   EVAL      CBTRNN = 'DL' + WWTRNO

     C                   CALL      'AOBOOKR0'                                               MD044377
     C                   PARM      *BLANKS       PRTCD                                      MD044377
     C                   PARM      '*KEY    '    POPTN                                      MD044377
     C                   PARM      FR_BOKC       PPFTC                                      MD044377
     C     SDBOOK        PARM      SDBOOK        DSFDY                                      MD044377
     C                                                                                      MD044377
     C                   IF        BDHGIN <> 'N'                                            MD044377
     C                   IF        PInit = *Blanks
     C                             OR (PInit = 'Y'
     C                             AND WMatD >= FR_DDAT
     C                             AND WMatD <= FR_MDAT
     C                             AND FR_MDAT <> 0)
     C                             OR (PInit = 'Y'
     C                             AND WMatD >= FR_DDAT
     C                             AND FR_MDAT = 0)
     C                   EXSR      SRWriteCSBA
     C                   ENDIF
     C                   ENDIF                                                              MD044377

     C                   READ      DLDLDGLC
     C                   ENDDO

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrDlIRS - Midas DL IRS live deals processing                 *
      *                                                               *
      *****************************************************************
     C     SrDlIRS       BEGSR

     C     *LOVAL        SETLL     DLDLDGLD
     C                   READ      DLDLDGLD

      ** Populate GLCSBAPD file while end of file not reached.

     C                   DOW       NOT %EOF(DLDLDGLD)

     C                   IF        (IR_DTYP = 'RR' AND IR_BYSL = 'B')
     C                             OR (IR_DTYP = 'RP' AND IR_BYSL = 'B')
     C                             OR (IR_DTYP = 'RF' AND IR_BYSL = 'S')
     C                             OR (IR_DTYP = 'RS')
     C                             OR (IR_DTYP = 'RX')

     C                   CLEAR                   GLCSBA

     C                   IF        IR_DTYP = 'RX'
     C                   EVAL      CBBALN = IR_TPAMT
     C                   EVAL      CBCURR = IR_TCUCY
     C                   ELSE
     C                   EVAL      CBBALN = IR_UPAMT
     C                   EVAL      CBCURR = IR_UCUCY
     C                   ENDIF

     C                   EVAL      CBYEAR = WYearEnd
     C                   EVAL      CBTTYP = IR_DTYP + IR_DLST
     C                   MOVEL     IR_CNUM       CBCUST
     C                   EXSR      SrCust

     C                   EVAL      CBBRCH = IR_BRCA
     C                   MOVEL     IR_DLNO       WWTRNO
     C                   EVAL      CBTRNN = 'DL' + WWTRNO

     C                   IF        PInit = *Blanks OR
     C                             (PInit = 'Y'
     C                             AND WMatD >= IR_DDAT
     C                             AND WMatD <= IR_MDAT)
     C                   EXSR      SRWriteCSBA
     C                   ENDIF
     C                   ENDIF

     C                   READ      DLDLDGLD
     C                   ENDDO

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrSecPr - Securities file processing                         *
      *                                                               *
      *****************************************************************
     C     SrSecPr       BEGSR

     C     *LOVAL        SETLL     SESEPSLL
     C                   READ      SESEPSLL

     C                   DOW       NOT %EOF(SESEPSLL)

      ** Only process records with 'long positions'

     C                   IF        CP_CSNV > 0

      ** Check if the record exist in Securities table and get the
      ** Nominal Currency, Security Market Price , Security
      ** Investment Type and Current Factor

     C     CP_CSSC       CHAIN     SECTY

     C                   IF        NOT %FOUND(SECTY)
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SECTYD'
     C                   EVAL      DBASE  = 004
     C                   EVAL      DBKEY  = CP_CSSC
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   CLEAR                   GLCSBA

      ** If record is found, get the Investment Processing Type
      ** from Investment Type Table

     C                   EVAL      KInvTp = SE_SITP
     C                   EVAL      KInvCy = SE_NMCY

     C     KInvTyp       CHAIN     INVTPC

     C                   IF        %FOUND(INVTPC)

      ** Calculate market value of securities nominal
      ** base on Investment Processing Type

     C                   SELECT
     C                   WHEN      IV_PROT = '1'
     C                             OR IV_PROT = '3'
     C                             OR IV_PROT = '5'
     C                             OR IV_PROT = '6'
     C                             OR IV_PROT = '9'

     C                   EVAL(H)   WMktVal = (CP_CSNV * SE_MKPR)/100

     C                   WHEN      IV_PROT = '8'

     C                   EVAL      WMktVal = (CP_CSNV * SE_MKPR * SE_CFCT)
     C                   EVAL(H)   WMktVal = WMktVal/100

     C                   WHEN      IV_PROT = '2'
     C                             OR IV_PROT = '4'
     C                             OR IV_PROT = '7'

     C                   EVAL(H)   WMktVal = (CP_CSNV * SE_MKPR)

     C                   ENDSL

      ** Populate GLCSBAPD file

     C                   EVAL      CBYEAR = WYearEnd
     C                   EVAL      CBCURR = SE_NMCY
     C                   EVAL      CBBALN = WMktVal
     C                   MOVEL     CP_CSCN       CBCUST
     C                   EXSR      SrCust

     C                   EVAL      CBBRCH = CP_CSBA
     C                   EVAL      CBTRNN = CBCUST + SE_SESN

     C                   IF        PInit = *Blanks OR
     C                             (PInit = 'Y' AND
     C                             WMatD >= CP_CSDA)
     C                   EXSR      SRWriteCSBA
     C                   ENDIF

     C                   ENDIF
     C                   ENDIF

     C                   READ      SESEPSLL

     C                   ENDDO

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrTrans - TRANSD FF Transaction details processing           *
      *                                                               *
      *****************************************************************
     C     SrTrans       BEGSR

     C                   READ      TRANSDF

      ** Populate GLCSBAPD file while end of file not reached.

     C                   DOW       NOT %EOF(TRANSD)

     C                   IF        TR_RECI = 'D'
     C                             AND TR_TRTY = 'S'
     C                             AND TR_TNBR > 0

      ** Check if FF transaction has negative counterpart
     C                   IF        WWMBR <> FMBR
     C                   EVAL      QCMD1 = 'OVRDBF FILE(TRANS) TOFILE(TRANS)' +
     C                                     ' MBR(' + FMBR + ')'
     C                   EVAL      WWMBR = FMBR

     C                   CALL      'QCMDEXC'
     C                   PARM                    QCMD1
     C                   PARM                    WMsgLen
     C                   ENDIF

     C                   EVAL      WWTNBR = TR_TNBR *(-1)
     C     WWTNBR        SETLL     TRANS
     C     WWTNBR        READE     TRANS                                7080
     C                   IF        NOT %EOF(TRANS)

     C                   READ      TRANSDF
     C                   ITER
     C                   ENDIF

     C     TR_ISTT       CHAIN     INTYP

     C                   IF        NOT %FOUND(INTYP)
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'INTYPD'
     C                   EVAL      DBASE  = 002
     C                   EVAL      DBKEY  = TR_ISTT
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Calculate Trade Value Amount
      ** Futures with the Instrument Processing Type equal to 7
      ** (Australian) and Options with the Instrument Processing Type
      ** equal to 8 (Australian) must be ignored

     C                   IF        ISPT <> 7 AND ISPT <> 8

     C                   CLEAR                   GLCSBA
     C                   EVAL      WWAMT = 0
      *
     C                   IF        ISPT = 5
     C                   MOVE      OTHC          PCurr
     C                   ELSE
     C                   MOVE      ISCY          PCurr
     C                   ENDIF
      *
      ** Get FF Market Prices record
     C                   IF        ISPT <> 5
     C                   EVAL      KISTT = TR_ISTT
     C                   EVAL      KYRNO = TR_YRNO
     C                   EVAL      KMTHN = TR_MTHN
     C                   EVAL      KPCAL = TR_PCAL
     C                   EVAL      KSTRP = TR_STRP
     C     KPRIC         CHAIN     PRICS1
     C                   IF        %FOUND(PRICS1)
      *
     C                   IF        ISPT = 1 OR ISPT = 4
     C                   EVAL      NEWP = 100 - NEWP
     C                   ENDIF
      *
     C                   EVAL      FFNOC = TR_NOCO
     C                   EVAL      FFPRIC = NEWP
     C                   EVAL      FFTKDM = TKDM
     C                   EVAL      FFMNPF = MNPF
     C                   EXSR      SrFFTVCL
     C                   EVAL      WWAMT = FFTNVL * TKVL
     C                   EVAL      WWAMT = WWAMT * 1000
      *
     C                   ENDIF
      *
      ** Instrument processing type = 5
     C                   ELSE
     C                   EVAL      WWAMT = TR_NOCO * CCAM
     C                   EVAL      WWAMT = WWAMT * 1000
     C                   ENDIF
      *
     C                   IF        WWAMT > 0
      *
     C                   IF        QOTC < 0
     C                   Z-SUB     QOTC          WWQOTC
     C                   DO        WWQOTC
     C                   EVAL      WWAMT = WWAMT / 10
     C                   ENDDO
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Populate GLCSBAPD

     C                   EVAL      CBYEAR = WYearEnd
     C                   EVAL      CBTTYP = '_' + TR_TRTY + '_' + %CHAR(ISPT)
     C                   EVAL      CBCURR = PCurr
     C                   EVAL      CBBALN = WWAMT
     C                   MOVEL     TR_CUSC       CBCUST
     C                   EXSR      SrCust

     C                   EVAL      CBBRCH = TR_BRCA
     C                   MOVEL     TR_TNBR       WWTRNO
     C                   EVAL      CBTRNN = 'FF' + WWTRNO

      ** Write record only if customer is existing

     C                   IF        CBCUST <> '000000'

     C                   IF        PInit = *Blanks OR
     C                             (PInit = 'Y'
     C                             AND WMatD >= TR_TRSD)
     C                   EXSR      SRWriteCSBA
     C                   ENDIF
     C                   ENDIF

     C                   ENDIF

     C                   ENDIF

     C                   READ      TRANSDF

     C                   ENDDO

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrGLATC - GLFCABPD Accounts Closed / Transferred Collection  *
      *            file processing                                    *
      *                                                               *
      *****************************************************************
     C     SrGLATC       BEGSR

     C                   READ      GLFCABPD

      ** Populate GLCSBAPD file while end of file not reached.

     C                   DOW       NOT %EOF(GLFCABPD)

     C                   EVAL      DateIn5 = CACBDACC

      ** Check the records year

     C                   EXSR      SrGetYr
     C                   EVAL      Wwrite = ' '                                             MD043973
     C                   IF        CACBDACC = 0                                             MD043973
     C                   EVAL      Wwrite = 'Y'                                             MD043973
     C                   ENDIF                                                              MD043973

     C                   IF        WDateYYYY = WYearEnd
     C                             OR Wwrite = 'Y'                                          MD043973

     C                   CLEAR                   GLCSBA

     C                   EVAL      CBYEAR = WYearEnd
     C                   EVAL      CBBRCH = CACBBRCH
     C                   EVAL      CBACSQ = CACBSEQ
     C                   EVAL      CBBALN = CACBAMNT
     C                   EVAL      CBCURR = CACBCURR
     C                   EVAL      CBACOD = CACBACOD
     C**********         EVAL      CBTTYP = 'ACCD'                                          MD042828
     C                   EVAL      CBTTYP = CACCTYPE                                        MD042828
     C                   MOVEL     CACBCNUM      CBCUST
     C                   EVAL      CBTRNN = *Blanks                                         MD043973
     C                   IF        Wwrite = 'Y'                                             MD043973
     C                   EVAL      CBTRNN = CACCTRNN                                        MD043973
     C                   ENDIF                                                              MD043973

     C**********         EXSR      SRWriteCSBA                                              MD042683
     C                   EVAL      CBJANO = CACCJANO                                        MD042683
     C                   EVAL      CBACHL = CACCACHL                                        MD042683
     C                   EVAL      CBACTY = CACCACTY                                        MD042683
     C                   EVAL      CBJATP = CACCJATP                                        MD042683
                                                                                            MD042683
     C                   WRITE     GLCSBAD0                                                 MD042683

     C                   ENDIF

     C                   READ      GLFCABPD
     C                   ENDDO

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrFFTVCL - Calculates transaction value for a given number of*
      *           contracts at a given price in units of the          *
      *           appropriate ticks denominator or minimum price      *
      *           fluctuation (depending on whether the ticks         *
      *           denominator is 100)                                 *
      *                                                               *
      *****************************************************************
     C     SrFFTVCL      BEGSR
      *
      ** If the Ticks Denominator is equal to 100
     C                   IF        FFTKDM = 100
      *
      ** Divide Price by Min Price Fluctuation
     C                   EVAL      FFNOTK = FFPRIC / FFMNPF
     C                   ELSE
      ** Multiply integer of Price by the Ticks Denominator
     C                   EVAL      FFNOTK = FFINTG * FFTKDM
      ** The remaining fraction of the Price should be added to the
      ** result of Price integer X Ticks Denominator
      *
      ** If Ticks Denominator is between 1 & 10 use 1st dec place
     C                   IF        FFTKDM <= 10
     C                   ADD       FFDCN1        FFNOTK
      *
     C                   IF        FFMNPF <> 0
     C                   EVAL      FFNOT1 = FFNOTK + FFDCN4
     C                   EVAL      FFNOTK = FFNOT1 / FFMNPF
     C                   ENDIF
      *
     C                   ELSE
      *
      ** If Ticks Denominator is between 11 & 99 use 1-2nd dec places
     C                   IF        FFTKDM <= 99
     C                   ADD       FFDCN2        FFNOTK
      *
     C                   IF        FFMNPF <> 0
     C                   EVAL      FFNOT1 = FFNOTK + FFDCN5
     C                   EVAL      FFNOTK = FFNOT1 / FFMNPF
     C                   ENDIF
      *
     C                   ELSE
      ** If Ticks Denominator is between 101 & 999 use 1-3rd dec places
     C                   ADD       FFDCN3        FFNOTK
      *
     C                   IF        FFMNPF <> 0
     C                   EVAL      FFNOT1 = FFNOTK + FFDCN6
     C                   EVAL      FFNOTK = FFNOT1 / FFMNPF
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      ** Multiply the number of ticks by the number of contracts
     C                   EVAL      FFTNVL = FFNOTK * FFNOC
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrGetYr -  Convert Day Number to YYYYMMDD format and get the *
      *             year in YYYY format                               *
      *                                                               *
      *****************************************************************
     C     SrGetYr       BEGSR

      ** Convert Day Number to YYYYMMDD format

     C                   CALLB     'ZDATE9'
     C                   PARM                    DateIn5
     C                   PARM      *ZERO         DayOut8
     C                   PARM                    PRtcd

     C                   MOVE      DayOut8       WNacrDt
     C                   EVAL      WDateYYYY = %SubSt(WNacrDt:1:4)

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrRetAc - Retail Accounts file processing                    *
      *                                                               *
      *****************************************************************
     C     SrRetAc       BEGSR

     C                   READ      RELIVE

      ** Populate GLCSBAPD file while end of file not reached.

     C                   DOW       NOT %EOF(RELIVE)

      ** Save only those account that are not yet close

     C                   IF        RE_RECI <> 'C'
     C                             AND RE_CLBL <=0

     C                   MOVEL     RE_CNUM       KNCUST
     C                   EVAL      NO_A7CUST = *Blanks
     C     KNCUST        SETLL     SDNOSTLB
     C     KNCUST        READE     SDNOSTLB
     C                   IF        KNCUST <> NO_A7CUST
     C                   CLEAR                   GLCSBA

     C                   EVAL      CBYEAR = WYearEnd
     C                   EVAL      CBBRCH = RE_BRCA
     C                   EVAL      CBACSQ = RE_ACSQ
     C                   EVAL      CBBALN = RE_CLBL
     C                   EVAL      CBCURR = RE_CCY
     C                   EVAL      CBACOD = RE_ACOD
     C                   MOVEL     RE_CNUM       CBCUST

     C                   EXSR      SRWriteCSBA
     C                   ENDIF

     C                   ENDIF

     C                   READ      RELIVE
     C                   ENDDO

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrCust - Extract details of customer                         *
      *                                                               *
      *****************************************************************
     C     SrCust        BEGSR

     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      CBCUST        PCust
     C                   PARM                    PKySt
     C     SDCUSD        PARM      SDCUSD        DSSDY

     C                   EVAL      WBrch = *BLANKS
     C                   IF        Prtcd = *BLANKS
     C                   EVAL      WBrch = BBBRCD
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRWriteCSBA - Generate Customer Balance FIle                 *
      *                                                               *
      *****************************************************************
     C     SRWriteCSBA   BEGSR

     C                   EVAL      CBJANO = *BLANKS
     C                   EVAL      CBACHL = CBCUST
     C                   EVAL      CBACTY = 'CUST'
     C                   EVAL      CBJATP = ' '
     C
     C                   WRITE     GLCSBAD0

     C                   IF        CBTTYP = 'ACCD'
     C                   EVAL      CBACOD = 0
     C                   EVAL      CBACSQ = 0
     C                   ENDIF
     C                   EVAL      JCJANO = CBCUST
     C     JCJANO        SETLL     SDJACCL0
     C     JCJANO        READE     SDJACCL0

     C                   DOW       NOT %EOF(SDJACCL0)
     C                   EVAL      CBJANO = JCJANO
     C                   EVAL      CBCUST = JCCUST
     C                   IF        JCCUST <> *BLANKS
     C                   EVAL      CBACHL = JCCUST
     C                   EVAL      CBACTY = 'CUST'
     C                   ELSE
     C                   EVAL      CBACHL = JCNAHO
     C                   EVAL      CBACTY = 'NAHO'
     C                   ENDIF
     C                   EVAL      CBJATP = 'M'
     C                   WRITE     GLCSBAD0


     C     JCJANO        READE     SDJACCL0
     C                   ENDDO

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrCloRetAc - Process closed customer account                 *
      *                                                               *
      *****************************************************************
     C     SrCloRetAc    BEGSR

     C**********         READ      ACCNTL16                                                 MD042683
     C**********         DOW       NOT %EOF(ACCNTL16)                                       MD042683
     C                   READ      ACCNTL18                                                 MD042683
     C                   DOW       NOT %EOF(ACCNTL18)                                       MD042683
     C                   IF        GC_DACC <= WMatD
     C                   EVAL      KBRCA = GC_BRCA
     C                   EVAL      KCNUM = GC_CNUM
     C                   EVAL      KCCY  = GC_CCY
     C                   EVAL      KACOD = GC_ACOD
     C                   EVAL      KACSQ = GC_ACSQ
     C                   EVAL      KHISD = 99999
     C                   EVAL      WWRITE = ' '
     C     KRHIS         SETGT     REHISDL
     C                   READP     REHISDL
     C                   DOW       KBRCA = RH_BRCA
     C                             AND KCNUM = RH_CNUM
     C                             AND KCCY  = RH_CCY
     C                             AND KACOD = RH_ACOD
     C                             AND KACSQ = RH_ACSQ
     C                             AND WWRITE = ' '
     C                   IF        RH_HISB <> 0
     C                   CLEAR                   GLCSBA
     C                   EVAL      CBYEAR = WYearEnd
     C                   EVAL      CBBRCH = RH_BRCA
     C                   EVAL      CBACSQ = RH_ACSQ
     C                   EVAL      CBBALN = RH_HISB
     C                   EVAL      CBCURR = RH_CCY
     C                   EVAL      CBACOD = RH_ACOD
     C                   MOVEL     RH_CNUM       CBCUST
     C                   IF        RH_HISB <= 0
     C                   EXSR      SRWriteCSBA
     C                   ENDIF
     C                   EVAL      WWRITE = 'Y'
     C                   ENDIF
     C                   READP     REHISDL
     C                   ENDDO
     C                   ENDIF
     C**********         READ      ACCNTL16                                                 MD042683
     C                   READ      ACCNTL18                                                 MD042683
     C                   ENDDO

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR  - Program exception error routine                     *
      *           Called automatically if a program error occurs,     *
      *           or directly by the program code using EXSR.         *
      *           This subroutine DUMPs the program just once.        *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR

     C                   DUMP

     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON

     C                   RETURN

     C                   ENDSR
      *****************************************************************
