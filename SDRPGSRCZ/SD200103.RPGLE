     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Network Description - Report P.E.P.')         *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  RPGLE/SD200103 - Network Details Report - Program Entry Point*
      *                                                               *
      *  Function:  This module will be called if MT94x Messages      *
      *             Generation (CGL013) is installed.  This report    *
      *             includes the fields added to the Network          *
      *             Details Maintenance Function.                     *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. EML104             Date 05Feb20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CGL146             Date 10Jul13               *
      *                 CER059             Date 19Jul10               *
      *                 CER030             Date 09Jul08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CGL013  *CREATE    Date 29Mar02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  EML104 - Upgrade EML010 to FB Midas 2.1 SP21                 *
      *           Structured field :86:                               *
      *           Add EML104_015, EML104_016                          *
      *  MD046248 - Finastra Rebranding                               *
      *  CGL146 - MT940/MT950 Production in Input Cycle               *
      *           Added hooks: CGL146_033, CGL146_034, CGL146_035,    *
      *                        CGL146_048, CGL146_049, CGL146_050     *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER030 - Multicash German Feature                            *
      *  CGL013 - MT94x Messages Generation                           *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    XX         Function of indicator                           *
      *    01         A database error occurred                       *
      *    30         Overflow indicator to avoid error when printing *
      *               all the possible formats for a record           *
      *    79         Difference found during audit control           *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

     FSDNWRKL1  IF   E           K DISK    INFSR(*PSSR)
      ** Message Network Details Retrieval Index

     FSDFCTLL0  UF   E           K DISK    INFSR(*PSSR)
      ** Standing Data Control Update Index

     F/COPY OFCPYSRCZ,CGL146_033                                                              CGL146
     FSD200103P1O    E             PRINTER INFSR(*PSSR)
     F                                     INFDS(SPOOL1)
     F                                     OFLIND(*IN30)
      ** Network Details Printer File

     FSD200103AUO    E             PRINTER INFSR(*PSSR)
     F                                     INFDS(SPOOLU)
      ** Printer file for Network List (Audit)

      ****************************************************************
      /EJECT
      ****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

     D LDA           E DS           256    EXTNAME(LDA) DTAARA(LDA)
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
      **                                    184 193 DBMOD
      **                                    194 203 DBPROC

      ** The following /COPY line includes all the defined fields in
      ** the PSDS.  They have meaningful names, prefixed by 'PS'.

     D/COPY ZACPYSRC,PSDS
      *
      ** Program Status Data Structure

      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

      ** External Data Structures for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)

      ** DS for access programs: Long Data Structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *                                                                                       CER030
      ** External DS for SAR Details                                                          CER030
      *                                                                                       CER030
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CER030
      *                                                                                       CER030
      ** Short data structure                                                                 CER030
      *                                                                                       CER030
     D DSFDY         E DS                  EXTNAME(DSFDY)                                     CER030

      ** File Information Data Structure for SD200103P1
     D SPOOL1          DS
     D  SFILE1                83     92
     D  SFNUM1               123    124B 0
      * OFLLN1               188    189B 0                                      Unused
      * PRTLN1               367    368B 0                                      Unused
     D  OFLLN1               188    189B 0                                                    CER030
     D  PRTLN1               367    368B 0                                                    CER030

      ** File Information Data Structure for SD200103AU
     D SPOOLU          DS
     D  SFILEU                83     92
     D  SFNUMU               123    124B 0

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

     D WRun            S              1A
     D WFirst          S              1A
     D PRetCode        S              7A
     D POption         S              7A
     D PRtCd           S              7A

      ** ZSFILE Parameters
     D PSeq            S              5A
     D PSenty          S              3A
     D PPrFile         S             10A
     D PSnum           S              6P 0
     D PSErr           S              1A

      ** ZDATE2 Parameters
     D PDateIn         S              5P 0
     D PDateNum        S              6P 0
     D PDateAlpha      S              7A

      ** Parameter declarations.
     D PAudReqS        S              1A
     D PSequence       S              5A
     D PLevel          S              1A
     D PEntity         S              3A
      *                                                                                       CER030
      ** Variables for CER030                                                                 CER030
      *                                                                                       CER030
     D PSard           S              6A                                                      CER030
     D CER030          S              1A                                                      CER030
     D WRem            S              2  0                                                    CER030
     D/COPY OFCPYSRCZ,CGL146_048                                                              CGL146

      ****************************************************************

      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+

      ** Establish Starting Position in SDNWRKL1 and first record reading

     C     *LOVAL        SETLL     @EDREJZ
     C                   READ      @EDREJZ

      ** Print Details while not end of file. A record will be printed if:
      **    . the list mode is "audit" and it was inserted/amended/deleted today
      **    . the list mode is "full" and it is not deleted

     C                   DOW       NOT %EOF(SDNWRKL1)
      *
     C                   IF        (PAudReqS = 'A' AND EDLCD = BJRDNB) OR
     C                             (PAudReqS <> 'A' AND EDTYLC <> 'D')
     C                   EXSR      SRProcess
     C                   ENDIF
      *
     C                   IF        EDTYLC <> 'D'
     C                   EVAL      RCOUNT = RCOUNT + 1
     C                   ENDIF
      *
     C                   READ      @EDREJZ
     C                   ENDDO

     C                   IF        RCOUNT <> 0
     C                   WRITE     TRAILER
     C                   ENDIF

     C                   EXSR      SRCFAU
     C                   EXSR      SRAudit

     C                   EVAL      *INLR = *ON

      *****************************************************************
      * SRProcess - Print Details                                     *
      *****************************************************************
     C     SRProcess     BEGSR

      ** If it is the first output to the printer file, record the report into RCF

     C                   IF        WFirst <> 'N'
     C                   EXSR      SRCFP1
     C                   EVAL      WFirst = 'N'
     C                   ENDIF

      ** Last Change Date

     C                   CALLB     'ZDATE2'
     C                   PARM      EDLCD         PDateIn
     C                   PARM                    BJDFIN
     C                   PARM      *ZEROS        PDateNum
     C                   PARM      *BLANKS       PDateAlpha
     C                   EVAL      EALCHD = PDateAlpha

      ** Write Report (always set off the overflow indicator)

     C                   EVAL      *IN30 = *Off
     C                   WRITE     HEADER

     C                   WRITE     NETWORK

      ** FTP Protocol Details

     C                   IF        EDPROT = '*FTP'
     C                   WRITE     FTPDTL
     C                   ENDIF
     C/COPY OFCPYSRCZ,CGL146_034                                                              CGL146

      ** MT950 Details

     C                   IF        EDM950 = 'Y'
     C                   WRITE     MT950DTL
     C                   ENDIF

      ** MT940 Details

     C                   IF        EDM940 = 'Y'
     C                   WRITE     MT940DTL
     C                   ENDIF

      ** MT941 Details

     C                   IF        EDM941 = 'Y'
     C                   WRITE     MT941DTL
     C                   ENDIF

      ** MT942 Details

     C                   IF        EDM942 = 'Y'
     C/COPY OFCPYSRCZ,CGL146_049                                                              CGL146
     C                   WRITE     MT942DTL
     C/COPY OFCPYSRCZ,CGL146_050                                                              CGL146
     C                   ENDIF

     C                   IF        EDENRA = 'Y'                                               CER030
     C                   EVAL      WRem = OFLLN1 - PRTLN1                                     CER030
     C                   IF        WRem < 7                                                   CER030
     C                   WRITE     HEADER                                                     CER030
     C                   WRITE     EXTNARDT                                                   CER030
     C                   ELSE                                                                 CER030
     C                   WRITE     EXTNARDT                                                   CER030
     C                   ENDIF                                                                CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C                   IF        CER030 = 'Y' AND EDMCNW = 'Y'                              CER030
     F/COPY WNCPYSRC,EML104_015                                                               EML104
     C                   EVAL      WRem = OFLLN1 - PRTLN1                                     CER030
     C                   IF        WRem < 3                                                   CER030
     C                   WRITE     HEADER                                                     CER030
     C                   WRITE     MTCASHDT                                                   CER030
     C                   ELSE                                                                 CER030
     C                   WRITE     MTCASHDT                                                   CER030
     C                   ENDIF                                                                CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C                   ENDSR

      *****************************************************************
      * SRAudit - Print Audit Report                                  *
      *****************************************************************
     C     SRAudit       BEGSR

      ** Header

     C                   WRITE     HEADAU

      ** DB Error, no details ou counters

     C                   SELECT
      ** -- DB Error
     C                   WHEN      *IN01
     C                   WRITE     DBERROR
      *
      ** -- No details
     C                   WHEN      RCOUNT = 0
     C                   WRITE     NODTLS
      *
      ** -- Counters and SDFCTLL0 Update
     C                   OTHER
     C                   EXSR      SRSDCntl
     C                   WRITE     CONTROL
     C                   EXSR      SRChange
     C                   ENDSL

     C                   ENDSR

      *****************************************************************
      * SRSDCntl - Audit/On-Req Retrieve on SDFCTLL0                  *
      *****************************************************************
     C     SRSDCntl      BEGSR

      ** Move key fields to @AHREAU

     C                   EVAL      AHFLNM = 'SDNWRKPD'
     C     AHFLNM        CHAIN     @AHREAU

     C                   IF        NOT %FOUND(SDFCTLL0)
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = 'SDNWRKPD'
     C                   EVAL      DBFILE = 'SDFCTLL0'
     C                   EVAL      DBASE = 2
     C                   EVAL      DBPGM = PSProcPgm
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE
     C                   Z-ADD     AHNOIN        RINSER
     C                   Z-ADD     AHNOAM        RAMEND
     C                   Z-ADD     AHNODL        RDELET
     C                   ENDIF

      ** If RCOUNT is not equal to number of Records on file

     C                   IF        RCOUNT <> AHNORC
     C                   EVAL      *IN79 = *On
     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      * SRChange - Change Standing Data Controls                      *
      *****************************************************************
     C     SRChange      BEGSR

     C                   IF        PAudReqS = 'A'
     C                   Z-ADD     *ZERO         AHNOIN
     C                   Z-ADD     *ZERO         AHNOAM
     C                   Z-ADD     *ZERO         AHNODL
     C                   Z-ADD     RCOUNT        AHNORC
     C                   UPDATE    @AHREAU
     C                   ELSE
     C                   UNLOCK    SDFCTLL0
     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      * SRCFP1 - Record the SD200103P1 printer file into RCF          *
      *****************************************************************
     C     SRCFP1        BEGSR

     C                   CALL      'ZSFILE'
     C                   PARM                    PSeq
     C                   PARM                    PSenty
     C                   PARM      SFILE1        PPrFile
     C                   PARM      SFNUM1        PSnum
     C                   PARM                    PSErr

     C                   IF        PSErr = 'Y'
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = SFILE1
     C                   EVAL      DBFILE = 'ZSFILE'
     C                   EVAL      DBASE = 3
     C                   EVAL      DBPGM = PSProcPgm
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      * SRCFAU - Record the SD200103AU printer file into RCF          *
      *****************************************************************
     C     SRCFAU        BEGSR

     C                   CALL      'ZSFILE'
     C                   PARM                    PSeq
     C                   PARM                    PSenty
     C                   PARM      SFILEU        PPrFile
     C                   PARM      SFNUMU        PSnum
     C                   PARM                    PSErr

     C                   IF        PSErr = 'Y'
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = SFILEU
     C                   EVAL      DBFILE = 'ZSFILE'
     C                   EVAL      DBASE = 4
     C                   OUT       LDA
     C                   EVAL      DBPGM = PSProcPgm
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR

     C     *ENTRY        PLIST
     C                   PARM                    PRetCode
     C                   PARM                    PAudReqS
     C                   PARM                    PSequence
     C                   PARM                    PLevel
     C                   PARM                    PEntity

      ** The following /COPY sets the program, module and procedure
      ** names for database error processing.

     C/COPY ZACPYSRC,DBFIELDS

      ** Access Bank Details

     C                   CALLB     'AOBANKR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*FIRST '     POption
     C     SDBANK        PARM      SDBANK        DSSDY

      ** Database Error

     C                   IF        PRtCd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE = 1
     C                   EVAL      DBKEY = '*FIRST'
     C                   EVAL      DBPGM = PSProcPgm
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *                                                                                       CER030
     C                   EVAL      CER030 = 'N'                                               CER030
     C                   EVAL      *IN31 = *OFF                                               CER030
      *                                                                                       CER030
      ** Check the switchable feature CER030 with the corresponding                           CER030
      ** parameters.                                                                          CER030
      *                                                                                       CER030
     C                   CALL      'AOSARDR0'                                                 CER030
     C                   PARM      *BLANKS       PRtCd                                        CER030
     C                   PARM      '*VERIFY'     POption                                      CER030
     C                   PARM      'CER030'      PSard                                        CER030
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER030
      *                                                                                       CER030
     C                   IF        PRtcd = *BLANKS                                            CER030
     C                   EVAL      CER030 = 'Y'                                               CER030
     C                   EVAL      *IN31 = *ON                                                CER030
      *                                                                                       CER030
      ** Database error (return code other than *NRF and blanks)                              CER030
      *                                                                                       CER030
     C                   ELSE                                                                 CER030
     C                   IF        PRtcd <> '*NRF' AND                                        CER030
     C                             PRtcd <> *BLANKS                                           CER030
     C     *LOCK         IN        LDA                                                        CER030
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER030
     C                   EVAL      DBASE = 5                                                  CER030
     C                   EVAL      DBKEY = PSard                                              CER030
     C                   EVAL      DBPGM = PSProcPgm                                          CER030
     C                   OUT       LDA                                                        CER030
     C                   EXSR      *PSSR                                                      CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C                   ENDIF                                                                CER030
     C/COPY OFCPYSRCZ,CGL146_035                                                              CGL146
     C/COPY WNCPYSRC,EML104_016                                                               EML104

     C                   ENDSR

      *********************************************************************
      * *PSSR  - Program exception error routine                          *
      *********************************************************************
     C     *PSSR         BEGSR

     C                   DUMP

     C                   EVAL      *IN01 = *ON

     C                   IF        WRUN <> 'Y'
     C                   EVAL      WRUN = 'Y'
     C                   EXSR      SRAudit
     C                   CALLB     'DBERRCTL'
     C                   ENDIF

     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN

     C                   ENDSR
      ********************************************************************
