     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Outgoing payment SSI report')                 *
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer module                                *
      *                                                               *
      *  FT000510 - Midas FT Outgoing Payments SSI Report             *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      *  Last Amend No. CER059             Date 19Jul10               *
      *  Prev Amend No. CER030             Date 09Jul08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 BUG14716           Date 24Aug07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027B            Date 10Jul06               *
      *                 CSD031             Date 10Apr06               *
      *                 CFT018   *CREATE   Date 29Nov02               *
      *                                    Date DDMmmYY               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER030 - Multicash German Feature                            *
      *  BUG14716 - CFT032 pre-req missing CFT018 OPSI Outgoing       *
      *             Payments Template (Recompile)                     *
      *  CSD027B - Recompiled due to change in FT000510P1.            *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CFT018 - Standard Settlement Instructions for                *
      *           Outgoing Payments                                   *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
     FFTOPSAL0  UF   E           K DISK    INFSR(*PSSR)
      *
     FFTOSSIL0  UF   E           K DISK    INFSR(*PSSR)
      *
     FFTOSIXL0  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(FTOSSID0:FTOSIXD0)
      *
     FFT000510P1O    E             PRINTER INFDS(SPOOL1) OFLIND(*IN01)
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     D LDA           E DS           256    EXTNAME(LDA) DTAARA(LDA)
      ** Local data area for database error details
      *
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
      ** Data Area giving Installation Control Details
      *
     D/COPY ZACPYSRC,PSDS
      ** Program Status Data Structure
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
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      ** EXTERNAL DS FOR SAR DETAILS
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for bank details
      *
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ** External data structure for currency codes
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** External DS for access programs, short DS
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      * Second DS for access programs, long data structure
      *
     D SPOOL1          DS
     D   Sfile1               83     92
     D   Sfnum1              123    124B 0
     D   Oflln1              188    189B 0
     D   Prtln1              367    368B 0
     ** Data for ZSFILE
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Entry Parameter
     D RMODE           S              7A
     D RSEQ            S              5A
     D RLEV            S              1A
     D RENT            S              3A
      *
      ** Access Object parameter fields
     D PRTCD           S              7A
     D POPTN           S              7A
     D PSARD           S              6A
     D PCCY            S                   Like(BJCYCD)
      *
     D @RUN            S              1
     D Sfilp           S             10
     D Splno           S              6  0
     D Zerr            S              1
      *
      ** Parameters for ZDATE2
     D PDAYNO          S              5P 0
     D PDATE           S              6P 0
     D PADATE          S              7A
      *
     ** Parameters for ZSFILE
     D  RptDtl         S              1
      *
     ** Format Fields
     D #Pgm            S             10
      *                                                                                       CER030
      ** Fields defined for CER030                                                            CER030
      *                                                                                       CER030
     D CER030          S              1A                                                      CER030
     D CER031          S              1A                                                      CER030
     D CFT003          S              1A                                                      CER030
     D CGL013          S              1A                                                      CER030
      *
      *
      /EJECT
      *****************************************************************
      *
      ** +--- Start of MaIn processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
      *
      *
      **  Initialisation
     C                   Exsr      Sr_Init
      *
      *
      **  Process according to run mode
     C                   Select
      *
      **  Program called in 'INTERIM' mode
     C     RMODE         Wheneq    'INTERIM'
     C                   Exsr      Sr_Interim
      *
      *
      **  Program called in 'AUDIT' mode
     C     RMODE         Wheneq    'AUDIT'
     C                   Exsr      Sr_Audit
      *
      *
      **  Program called in 'AUDIT' mode
     C     RMODE         Wheneq    'LIST'
     C                   Exsr      Sr_List
      *
     C                   Endsl
      *
      *
      **  Termination processing
     C                   Exsr      Sr_Term
      *
      *
      /EJECT
      *****************************************************************
      * INIT - Initialisation Processing each time module is invoked
      *****************************************************************
     C     Sr_Init       Begsr
      *
      ** Reposition files
     C     *Loval        Setll     FTOPSAL0
     C     *Loval        Setll     FTOSSIL0
     C     *Loval        Setll     FTOSIXL0
      *
     C                   Endsr
      /EJECT
      *****************************************************************
      * Sr_Interim - Processing when called in Interim Mode
      *****************************************************************
     C     Sr_Interim    Begsr
      *
      **  Read through SSI request print file
     C                   Read      FTOPSAL0                               89
     C     *In89         Doweq     *Off
      *
      **  Only process if not previously printed
     C     OSPRTI        Ifeq      'Y'
      *
      **  Set flag to indicate details reported
     C                   Eval      RptDtl = 'Y'
      *
      **  Get SSI details from LF/FTOSSIL0
     C     K@OSSI        Chain(n)  FTOSSIL0                           90
      *
      **  If details not authorised then get details from LF/FOSIXL0
     C     OSSTAT        Ifeq      'C'
     C     OSSTAT        oreq      'R'
     C     K@OSSI        Chain     FTOSIXL0                           90
     C                   End
      *
      **  Report SSI details
     C                   Exsr      RptSSI
      *
      **  Update print item indicator
     C                   Movel     'P'           OSPRTI
      *
     C                   End
      *
      **  Update record just read
     C                   Update    FTOPSAD0
      *
     C                   Read      FTOPSAL0                               89
     C                   EndDo
      *
      *
     C                   Endsr
      /EJECT
      *****************************************************************
      * Sr_Audit - Processing when called in Audit Mode
      *****************************************************************
     C     Sr_Audit      Begsr
      *
      **  Read through SSI details
     C                   Read      FTOSSIL0                               89
     C     *In89         Doweq     *Off
      *
      **  Only process if amended today
     C     OSLCD         Ifeq      BJRDNB
      *
      **  Set flag to indicate details reported
     C                   Eval      RptDtl = 'Y'
      *
      **  If details not authorised then get details from LF/FOSIXL0
     C     OSSTAT        Ifeq      'C'
     C     OSSTAT        oreq      'R'
     C     K@OSSI        Chain     FTOSIXL0                           90
     C                   End
      *
      **  Report SSI details
     C                   Exsr      RptSSI
      *
     C                   EndIf
      *
      **  Delete record if SSI has been deleted
     C     OSSTAT        Ifeq      'D'
     C                   Delete    FTOSSID0
     C                   EndIf
      *
     C                   Read      FTOSSIL0                               89
     C                   EndDo
      *
     C                   Endsr
      /EJECT
      *****************************************************************
      * Sr_List - Processing when called in List Mode
      *****************************************************************
     C     Sr_List       Begsr
      *
      **  Read through all SSI details
     C                   Read(n)   FTOSSIL0                               89
     C     *In89         Doweq     *Off
      *
      **  Set flag to indicate details are being reported
     C                   Eval      RptDtl = 'Y'
      *
      **  If details not authorised then get details from LF/FOSIXL0
     C     OSSTAT        Ifeq      'C'
     C     OSSTAT        oreq      'R'
     C     K@OSSI        Chain     FTOSIXL0                           90
     C                   End
      *
      **  Report SSI details
     C                   Exsr      RptSSI
      *
     C                   Read(n)   FTOSSIL0                               89
     C                   EndDo
      *
     C                   Endsr
      /EJECT
      *****************************************************************
      * RtvSSI - Retrieve SSI Details
      *****************************************************************
     C     RtvSSI        Begsr
      *
     C                   Endsr
      /EJECT
      *****************************************************************
      * RptSSI - Report SSI Details
      *****************************************************************
     C     RptSSI        Begsr
      *
      **  Start new page for each SSI printed
     C                   Write     HEADER
      *
      **  Report SSI details
     C                   Write     DETAIL
      *
     C                   Endsr
      /EJECT
      *****************************************************************
      * Sr_Term - Termination Processing
      *****************************************************************
     C     Sr_Term       Begsr
      *
      ** If no details have been reported then report this
     C     RptDtl        Ifne      'Y'
     C                   Write     HEADER
     C                   Write     NODETL
     C                   EndIf
      *
      ** Write trailer - 'End of report'
     C                   Write     TRAILER
      *
      **  Set on LR and return to calling program
     C                   Move      *On           *InLR
     C                   Return
      *
     C                   Endsr
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
     C     *INZSR        Begsr
      *
     C     *Entry        Plist
     C                   Parm                    RMODE
     C                   Parm                    RSEQ
     C                   Parm                    RLEV
     C                   Parm                    RENT
      *
      ** RCF Printer File
     C                   Eval      Splno = Sfnum1
     C                   Eval      Sfilp = Sfile1
      *
     C                   Call      'ZSFILE'
     C                   Parm                    RSEQ
     C                   Parm                    RENT
     C                   Parm                    Sfilp
     C                   Parm                    Splno
     C                   Parm      *Blank        Zerr
      *
      ** Database error
     C                   If        Zerr = 'Y'
     C     *LOCK         In        LDA
     C                   Eval      DBFILE =  'ZSFILE'
     C                   Eval      DBKEY  =  SFILE1
     C                   Eval      DBPGM  =  PSProcPgm
     C                   Eval      DBASE  =  001
     C                   Eval      DBMOD  =  PSProcMod
     C                   Eval      DBPROC =  '*INZSR'
     C                   OUT       LDA
     C                   Write     DBERROR
     C                   EXSR      *PSSR
     C                   EndIf
      *
      ** Retrieve bank details
     C                   CallB     'AOBANKR0'
     C                   Parm      *Blanks       PRTCD
     C                   Parm      '*FIRST   '   POPTN
     C     SDBANK        Parm      SDBANK        DSFDY
      *
      ** Database error
     C                   If        PRTCD  <> *Blanks
     C     *Lock         In        LDA
     C                   Eval      DBFILE =  'SDBANKPD'
     C                   Eval      DBKEY  =  '*FIRST'
     C                   Eval      DBPGM  =  PSProcPgm
     C                   Eval      DBASE  =  002
     C                   Eval      DBMOD  =  PSProcMod
     C                   Eval      DBPROC =  '*INZSR'
     C                   Out       LDA
     C                   Write     DBERROR
     C                   Exsr      *PSSR
     C                   EndIf
      *
      ** Access SAR details file to see if CFT009 is installed.
     C                   Callb     'AOSARDR0'
     C                   Parm      *BLANKS       PRTCD
     C                   Parm      '*VERIFY'     POPTN
     C                   Parm      'CFT009'      PSARD
     C     SCSARD        Parm      SCSARD        DSFDY
     C                   If        PRTCD = *Blanks
     C                   Movel     'Y'           CFT009            1
     C                   Movel     *ON           *IN09
     C                   Else
     C                   Movel     'N'           CFT009
     C                   Movel     *OFF          *IN09
     C                   End
      *
      ** Access SAR details file to see if CFT014 is installed.
     C                   Callb     'AOSARDR0'
     C                   Parm      *BLANKS       PRTCD
     C                   Parm      '*VERIFY'     POPTN
     C                   Parm      'CFT014'      PSARD
     C     SCSARD        Parm      SCSARD        DSFDY
     C                   If        PRTCD = *Blanks
     C                   Movel     'Y'           CFT014            1
     C                   Movel     *ON           *IN14
     C                   Else
     C                   Movel     'N'           CFT014
     C                   Movel     *OFF          *IN14
     C                   EndIf
      *                                                                                       CER030
      ** Check the switchable feature CER030                                                  CER030
      *                                                                                       CER030
     C                   EVAL      *IN15 = *OFF                                               CER030
     C                   CALLB     'AOSARDR0'                                                 CER030
     C                   PARM      *BLANKS       PRtCd                                        CER030
     C                   PARM      '*VERIFY'     POptn                                        CER030
     C                   PARM      'CER030'      PSard                                        CER030
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER030
      *                                                                                       CER030
     C                   IF        PRtCd = *BLANKS                                            CER030
     C                   EVAL      CER030 = 'Y'                                               CER030
     C                   EVAL      *IN15 = *ON                                                CER030
     C                   ELSE                                                                 CER030
      *                                                                                       CER030
      ** Database error (return code other than *NRF)                                         CER030
      *                                                                                       CER030
     C                   IF        PRtCd  <> '*NRF   '                                        CER030
     C     *LOCK         IN        LDA                                                        CER030
     C                   EVAL      DBFILE =  'SCSARDPD'                                       CER030
     C                   EVAL      DBKEY  =  POptn                                            CER030
     C                   EVAL      DBPGM  =  PSProcPgm                                        CER030
     C                   EVAL      DBASE  =  003                                              CER030
     C                   EVAL      DBMOD  =  PSProcMod                                        CER030
     C                   EVAL      DBPROC =  '*INZSR'                                         CER030
     C                   OUT       LDA                                                        CER030
     C                   WRITE     DBERROR                                                    CER030
     C                   EXSR      *PSSR                                                      CER030
     C                   ELSE                                                                 CER030
     C                   EVAL      CER030 = 'N'                                               CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
      ** Check the switchable feature CER031                                                  CER030
      *                                                                                       CER030
     C                   CALLB     'AOSARDR0'                                                 CER030
     C                   PARM      *BLANKS       PRtCd                                        CER030
     C                   PARM      '*VERIFY'     POptn                                        CER030
     C                   PARM      'CER031'      PSard                                        CER030
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER030
      *                                                                                       CER030
     C                   IF        PRtCd = *BLANKS                                            CER030
     C                   EVAL      CER031 = 'Y'                                               CER030
     C                   EVAL      *IN16 = *ON                                                CER030
     C                   ELSE                                                                 CER030
      *                                                                                       CER030
      ** Database error (return code other than *NRF)                                         CER030
      *                                                                                       CER030
     C                   IF        PRtCd  <> '*NRF   '                                        CER030
     C     *LOCK         IN        LDA                                                        CER030
     C                   EVAL      DBFILE =  'SCSARDPD'                                       CER030
     C                   EVAL      DBKEY  =  POptn                                            CER030
     C                   EVAL      DBPGM  =  PSProcPgm                                        CER030
     C                   EVAL      DBASE  =  004                                              CER030
     C                   EVAL      DBMOD  =  PSProcMod                                        CER030
     C                   EVAL      DBPROC =  '*INZSR'                                         CER030
     C                   OUT       LDA                                                        CER030
     C                   WRITE     DBERROR                                                    CER030
     C                   EXSR      *PSSR                                                      CER030
     C                   ELSE                                                                 CER030
     C                   EVAL      CER031 = 'N'                                               CER030
     C                   EVAL      *IN16 = *OFF                                               CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
      ** Check the switchable feature CFT003                                                  CER030
      *                                                                                       CER030
     C                   CALLB     'AOSARDR0'                                                 CER030
     C                   PARM      *BLANKS       PRtCd                                        CER030
     C                   PARM      '*VERIFY'     POptn                                        CER030
     C                   PARM      'CFT003'      PSard                                        CER030
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER030
      *                                                                                       CER030
     C                   IF        PRtCd = *BLANKS                                            CER030
     C                   EVAL      CFT003 = 'Y'                                               CER030
     C                   ELSE                                                                 CER030
      *                                                                                       CER030
      ** Database error (return code other than *NRF)                                         CER030
      *                                                                                       CER030
     C                   IF        PRtCd  <> '*NRF   '                                        CER030
     C     *LOCK         IN        LDA                                                        CER030
     C                   EVAL      DBFILE =  'SCSARDPD'                                       CER030
     C                   EVAL      DBKEY  =  POptn                                            CER030
     C                   EVAL      DBPGM  =  PSProcPgm                                        CER030
     C                   EVAL      DBASE  =  005                                              CER030
     C                   EVAL      DBMOD  =  PSProcMod                                        CER030
     C                   EVAL      DBPROC =  '*INZSR'                                         CER030
     C                   OUT       LDA                                                        CER030
     C                   WRITE     DBERROR                                                    CER030
     C                   EXSR      *PSSR                                                      CER030
     C                   ELSE                                                                 CER030
     C                   EVAL      CFT003 = 'N'                                               CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C                   IF        (CER031 = 'Y') AND (CFT003 = 'Y')                          CER030
     C                   EVAL      *IN17 = *ON                                                CER030
     C                   ELSE                                                                 CER030
     C                   EVAL      *IN17 = *OFF                                               CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
      ** Check the switchable feature CGL013                                                  CER030
      *                                                                                       CER030
     C                   CALLB     'AOSARDR0'                                                 CER030
     C                   PARM      *BLANKS       PRtCd                                        CER030
     C                   PARM      '*VERIFY'     POptn                                        CER030
     C                   PARM      'CGL013'      PSard                                        CER030
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER030
      *                                                                                       CER030
     C                   IF        PRtCd = *BLANKS                                            CER030
     C                   EVAL      CGL013 = 'Y'                                               CER030
     C                   EVAL      *IN15 = *ON                                                CER030
     C                   ELSE                                                                 CER030
      *                                                                                       CER030
      ** Database error (return code other than *NRF)                                         CER030
      *                                                                                       CER030
     C                   IF        PRtCd  <> '*NRF   '                                        CER030
     C     *LOCK         IN        LDA                                                        CER030
     C                   EVAL      DBFILE =  'SCSARDPD'                                       CER030
     C                   EVAL      DBKEY  =  POptn                                            CER030
     C                   EVAL      DBPGM  =  PSProcPgm                                        CER030
     C                   EVAL      DBASE  =  006                                              CER030
     C                   EVAL      DBMOD  =  PSProcMod                                        CER030
     C                   EVAL      DBPROC =  '*INZSR'                                         CER030
     C                   OUT       LDA                                                        CER030
     C                   WRITE     DBERROR                                                    CER030
     C                   EXSR      *PSSR                                                      CER030
     C                   ELSE                                                                 CER030
     C                   EVAL      CGL013 = 'N'                                               CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C                   ENDIF                                                                CER030
      *
      *
      ** Define key list to access LF/FTOSSIL0
     C     K@OSSI        Klist
     C                   Kfld                    OSDRCY
     C                   Kfld                    OSDRAC
     C                   Kfld                    OSREF1
     C                   Kfld                    OSREF2
     C                   Kfld                    OSCRCY
      *
     C                   Eval      #Pgm = 'FT000510'
      *
     C                   EndSR
      *********************************************************************
      /EJECT
      *********************************************************************
      *                                                                   *
      * *PSSR  - Program exception error routine                          *
      *          Called automatically if a program error occurs,          *
      *          or directly by the program code using EXSR.              *
      *          This subroutine DUMPs the program just once.             *
      *                                                                   *
      * Called by: (**callIng routines**)                                 *
      *                                                                   *
      * Calls: None                                                       *
      *                                                                   *
      *********************************************************************
     C     *PSSR         Begsr
      *
     C                   If        @RUN = *Blank
     C                   Eval      @RUN = 'Y'
     C                   Callb     'DBERRCTL'
     C                   Dump
     C                   EndIf
      *
     C                   Eval      *InU7 = *On
     C                   Eval      *InU8 = *On
     C                   Eval      *InLR = *On
     C                   Return
      *
     C                   EndSr
      *
      ********************************************************************
