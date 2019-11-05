     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas DL Dealing Fees Input Today')                    *
      *****************************************************************
      *                                                               *
      *  Midas - Dealing Module                                       *
      *                                                               *
      *  DL000140 - Midas DL Dealing Fees Input today                 *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CLE134             Date 01Aug12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 BUG13049           Date 17Jan07               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CAS011             Date 16May05               *
      *                 CAS009  *CREATE    Date 04May04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  BUG13049 - Incorrect "Payment On" value                      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CAS011 - EIR/AC Accounting Upgrade to MP1                    *
      *  CAS009 - Effective Interest Rate/Amortised Cost Accounting   *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Midas DL Fees File
     FDLFEEDLA  IF   E           K DISK    INFSR(*PSSR)
 
      ** Midas DL Fees File
     FDLFEEZ    UF   E             DISK    INFSR(*PSSR)
 
      ** Midas DL Dealing Fees Input Today Report
     FDL000140P1O    E             PRINTER USROPN
     F                                     INFSR(*PSSR)
     F                                     INFDS(SPOOL1)
 
      ** Midas DL Dealing Fees Input Today Audit Report
     FDL000140AUO    E             PRINTER INFSR(*PSSR)
     F                                     INFDS(SPOOLU)
 
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
 
      ** External data structure for General Ledger ICD Details
     D SDFEE         E DS                  EXTNAME(SDFEEPD)
 
      ** Externally described DS for branch details
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
 
      ** Externally described DS for Customer details
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
     D  QQDFA1       E                     EXTFLD(QQDFAC)                                     CAS011
 
      ** Externally described DS for currency details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      ** DS for access programs - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** DS for access programs - long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** File Information Data Structure for DL000140P1
     D SPOOL1          DS
     D  PSFile1               83     92
     D  PSFNum1              123    124B 0
     D  OflLn1               188    189B 0
     D  PrtLn1               367    368B 0
 
      ** File Information Data Structure for DL000140AU
 
     D SPOOLU          DS
     D  PSFileU               83     92
     D  PSFNumU              123    124B 0
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** ZSEDIT fields
     D PZFLD15         S             15  0
     D PZDECS          S              1  0
     D PZECODE         S              1    INZ('J')
     D PZOUT21         S             21
 
      ** Parameters for ZSFILE
     D PSeq            S              5
     D PLevel          S              1
     D PEnty           S              3
     D ZSnum           S              6  0
     D ZSnum1          S              6  0
     D ZSnumU          S              6  0
     D ZSerr           S              1
 
      ** Parameters for access object programs
     D PRTCD           S              7
     D POPTN           S              7
     D PCYCD           S              3
     D PFECD           S              2
     D PKYST           S              7
     D PCNUM           S             10
 
     D ZDAYNO          S              5  0
     D ZDATE           S              6  0
     D ZADATE          S              7
     D ZDATEB          S              7
 
      ** Other work fields
 
     D WNBDP           S              1  0
     D RQDLN1          S              3  0
     D RQDLN2          S              3  0
     D DIFLN1          S              3  0
     D WFirst          S              1    INZ('Y')
     D WDFBRCA         S              3
 
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
 
     C                   EXSR      SRAUDT
 
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
 
      ** Initialize report work fields
 
     C                   EVAL      RQDLN1 = 0
     C                   EVAL      DIFLN1 = 0
     C                   EVAL      RQDLN2 = 0
 
     C                   EVAL      PZECODE = 'J'
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRPROC - Detail Processing                                    *
      *                                                               *
      *****************************************************************
 
     C     SRPROC        BEGSR
 
     C     *LOVAL        SETLL     DLFEEDLA
 
      ** Read Midas DL Fees File
 
     C                   READ      DLFEEDLA                               01
 
     C                   IF        *IN01 = *ON
     C                   EXSR      SRAUDT
     C                   ENDIF
 
     C                   DOW       *IN01 = *OFF
 
     C                   EVAL      RREC = RREC + 1
 
     C                   IF        DFLCHD = BJRDNB
 
     C                   EVAL      RNORE = RNORE + 1
 
      ** Print Header if new branch
 
     C                   IF        WDFBRCA <> DFBRCA AND
     C                             WFirst = 'N'
     C                   WRITE     ENDBRC1
     C                   EXSR      SRBRCH
     C                   WRITE     HEADP1
     C                   ENDIF
 
      ** If first record with satisfied condition, do RCF processing
 
     C                   IF        WFirst = 'Y'
     C                   EXSR      SRRCFP1
     C                   EXSR      SRBRCH
     C                   WRITE     HEADP1
     C                   EVAL      WFirst = 'N'
     C                   ENDIF
 
      ** Compute number of inserted record
 
     C                   IF        DFORED = BJRDNB
     C                   EVAL      RINS = RINS + 1
     C                   ENDIF
 
      ** Compute number of Ammended and Deleted record
 
     C                   IF        DFLCDT = 'A'
     C                   EVAL      RAMD = RAMD + 1
     C                   ENDIF
 
     C                   IF        DFLCDT = 'D'
     C                   EVAL      RDEL = RDEL + 1
     C                   ENDIF
 
      ** Save previous branch
 
     C                   EVAL      WDFBRCA = DFBRCA
 
      ** Print detail and read next record
 
     C                   EXSR      SRPRNTDET
 
     C                   ENDIF
     C                   READ      DLFEEDLA                               01
     C                   IF        *IN01 = *ON
     C                   IF        WFirst = 'Y'                                               CAS011
     C                   EXSR      SRRCFP1                                                    CAS011
     C                   EXSR      SRBRCH                                                     CAS011
     C                   WRITE     HEADP1                                                     CAS011
     C                   WRITE     NODETP1                                                    CAS011
     C                   EVAL      WFirst = 'N'                                               CAS011
     C                   ELSE                                                                 CAS011
     C                   WRITE     ENDBRC1
     C                   WRITE     ENDREP1
     C                   ENDIF                                                                CAS011
     C                   ENDIF
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRPRNTDET - Detail Printing                                   *
      *                                                               *
      *****************************************************************
     C     SRPRNTDET     BEGSR
 
      ** Put details to printer fields.
 
     C                   MOVE      DFCUST        RCNUM
     C                   EXSR      SRCUST
     C                   EVAL      RCRNM = BBCRNM
     C                   MOVE      BBCRTN        RCRTN
 
     C                   MOVE      DFDLNO        RDLNO
     C                   MOVE      DFFSEQ        RFSEQ
     C                   MOVE      DFFCOD        RFCOD
     C                   MOVE      DFFCOD        PFECD
     C                   EXSR      SRFEE
     C                   EVAL      RCCY = DFFCCY
 
     C                   EVAL      PCYCD = DFFCCY
     C                   EXSR      SRCURR
     C                   EVAL      PZFLD15 = DFFAMT
     C                   EXSR      SRZSEDIT
     C                   EVAL      RAMT = PZOUT21
 
     C                   EVAL      ZDAYNO = DFPSTD
     C                   EXSR      SRZDATE
     C                   EVAL      RSDAT = ZDATEB
 
     C                   EVAL      ZDAYNO = DFPEND
     C                   EXSR      SRZDATE
     C                   EVAL      REDAT = ZDATEB
 
      ** Reset RPAYON value to blanks first                                                 BUG13049
                                                                                            BUG13049
     C                   EVAL      RPAYON = ' '                                             BUG13049
                                                                                            BUG13049
     C                   SELECT
     C                   WHEN      DFPYON = 'S'
     C                   EVAL      RPAYON = 'START'
     C                   WHEN      DFPYON = 'E'
     C                   EVAL      RPAYON = 'END'
     C                   WHEN      DFPYON = 'N'
     C                   EVAL      RPAYON = 'NEXT'
     C                   ENDSL
 
     C                   EVAL      ZDAYNO = DFNPYD
     C                   EXSR      SRZDATE
     C                   EVAL      RNPYD = ZDATEB
 
     C                   EVAL      RFREQ = DFFREQ
     C                   MOVE      DFDYIM        RDYIM
 
      ** Print Settlement Instructions
 
     C                   IF        DFDTYP = 'IT' OR DFDTYP = 'TD' OR
     C                             DFDTYP = 'CI' OR DFDTYP = 'CD'
     C                   MOVE      DFPSTM        RPSTM
     C                   MOVE      DFPONS        RPONS
     C                   EVAL      RCVMR = DFCVMR
     C                   EVAL      RRVNO = DFRVNO
     C                   MOVE      DFPOCN        RPOCN
     C                   MOVE      DFPOBN        RPOBN
     C                   EVAL      *IN02 = *ON
     C                   ELSE
     C                   MOVE      DFRSTM        RRSTM
     C                   EVAL      RRONS = DFRONS
     C                   MOVE      DFROCN        RROCN
     C                   MOVE      DFROBN        RROBN
     C                   EVAL      RRIBN = DFRIBN
     C                   EVAL      RRIBA = DFRIBA
     C                   EVAL      *IN02 = *OFF
     C                   ENDIF
 
      ** If overflow, write header
 
     C                   EVAL      RQDLN1 = 19
     C                   EVAL      DIFLN1 = OFLLN1 - PRTLN1
     C                   IF        DIFLN1 <= RQDLN1
     C                   WRITE     HEADP1
     C                   ENDIF
 
      ** Write Detail
 
     C                   WRITE     DETAILP1
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRAUDT - Audit Processing                                     *
      *                                                               *
      *****************************************************************
 
     C     SRAUDT        BEGSR
 
     C                   WRITE     HEADAU
 
      ** If there is a DB error, output the DB error information
 
     C                   IF        *INU7 = *ON
     C                   WRITE     DBERROR
     C                   ELSE
 
      ** If file is not empty, write number of records, else no
      ** detail write to display
 
     C                   IF        RREC <> 0
 
     C                   READ      DLFEEZ
     C                   IF        %EOF(DLFEEZ)
     C                   EVAL      DBFILE = 'DLFEEZ'
     C                   EVAL      DBASE = 1
     C                   EVAL      DBKEY = '1'
     C                   EVAL      DBPGM = 'DL000140'
     C                   EXSR      *PSSR
     C                   ELSE
 
     C                   IF        RINS <> DFNINT OR
     C                             RAMD <> DFNAMD OR
     C                             RDEL <> DFNDEL
     C                   EVAL      *IN03 = *ON
     C                   ELSE
     C                   EVAL      DFNORE = RREC
     C                   EVAL      DFNINT = 0
     C                   EVAL      DFNAMD = 0
     C                   EVAL      DFNDEL = 0
     C                   UPDATE    DLFEEZF
     C                   ENDIF
 
     C                   ENDIF
 
     C                   WRITE     CONTROL
     C                   ELSE
     C                   WRITE     NODTLS
     C                   ENDIF
     C                   ENDIF
 
      ** End of Program
 
     C                   EVAL      *INLR = '1'
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRRCFP1 - Detail Spool File recorded by RCF                   *
      *                                                               *
      *****************************************************************
     C     SRRCFP1       BEGSR
 
     C                   OPEN      DL000140P1
 
      ** Ensure Detail Spool File recorded by RCF.
 
     C                   EVAL      ZSnum = PSFNum1
 
     C                   CALL      'ZSFILE'
     C                   PARM                    PSeq
     C                   PARM                    PEnty
     C                   PARM                    PSFile1
     C                   PARM                    ZSnum
     C                   PARM      *Blank        ZSerr
 
      ** If Error occurs during ZSFILE processing, then return to the
      ** Calling Program.
 
     C     ZSERR         IFEQ      'Y'
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
      * SRRCFAU - Detail Spool File recorded by RCF                   *
      *                                                               *
      *****************************************************************
     C     SRRCFAU       BEGSR
 
      ** Ensure Detail Spool File recorded by RCF.
 
     C                   EVAL      ZSnumU = PSFNumU
 
     C                   CALL      'ZSFILE'
     C                   PARM                    PSeq
     C                   PARM                    PEnty
     C                   PARM                    PSFileU
     C                   PARM                    ZSnumU
     C                   PARM      *Blank        ZSerr
 
      ** If Error occurs during ZSFILE processing, then return to the
      ** Calling Program.
 
     C     ZSERR         IFEQ      'Y'
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
      * SRBRCH - Get Branch Name                                      *
      *                                                               *
      *****************************************************************
     C     SRBRCH        BEGSR
 
     C                   CALLB     'AOBRCHR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM                    DFBRCA
     C     SDBRCH        PARM      SDBRCH        DSSDY
 
      ** Database Error
 
     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      DBFILE = 'SDBRCHPD'
     C                   EVAL      DBASE = 2
     C                   EVAL      DBKEY = DFBRCA
     C                   EVAL      DBPGM = 'DL000140'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      RBRNM = A8BRNM
     C                   EVAL      RBRCA = DFBRCA
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRCUST - Get Customer Name                                    *
      *                                                               *
      *****************************************************************
     C     SRCUST        BEGSR
 
     C                   CALLB     'AOCUSTR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      RCNUM         PCNUM
     C                   PARM      *BLANKS       PKYST
     C     SDCUST        PARM      SDCUST        DSSDY
 
      ** Database Error
 
     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      DBFILE = 'SDCUSTPD'
     C                   EVAL      DBASE = 3
     C                   EVAL      DBKEY = RCNUM
     C                   EVAL      DBPGM = 'DL000140'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRFEE  - Access Fee code file                                 *
      *                                                               *
      *****************************************************************
     C     SRFEE         BEGSR
 
     C                   CALL      'AOFEER0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY'        POPTN
     C                   PARM                    PFECD
     C     SDFEE         PARM      SDFEE         DSFDY
 
      ** Database Error
 
     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      DBFILE = 'SDFEEPD'
     C                   EVAL      DBASE = 4
     C                   EVAL      DBKEY = PFECD
     C                   EVAL      DBPGM = 'DL000140'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRCURR - Access Currency code file                            *
      *                                                               *
      *****************************************************************
 
     C     SRCURR        BEGSR
 
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM                    PCYCD
     C     SDCURR        PARM      SDCURR        DSSDY
 
      ** Database Error
 
     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      DBFILE = 'SDCURRPD'
     C                   EVAL      DBASE = 5
     C                   EVAL      DBKEY = PCYCD
     C                   EVAL      DBPGM = 'DL000140'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      WNBDP = A6NBDP
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRZSEDIT - Convert amount from file format to screen format   *
      *                                                               *
      *****************************************************************
 
     C     SRZSEDIT      BEGSR
 
     C                   CALLB     'ZSEDIT'
     C                   PARM                    PZFLD15
     C                   PARM      WNBDP         PZDECS
     C                   PARM                    PZECODE
     C                   PARM                    PZOUT21
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRZDATE - Convert date to format DDMMMYY                      *
      *                                                               *
      *****************************************************************
     C     SRZDATE       BEGSR
 
     C                   CALL      'ZDATE2'
     C                   PARM                    ZDAYNO
     C                   PARM                    BJDFIN
     C                   PARM                    ZDATE
     C                   PARM                    ZDATEB
 
     C                   ENDSR
      *****************************************************************
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
 
      ** Access Bank Details
 
     C                   CALLB     'AOBANKR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database Error
 
     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE = 6
     C                   EVAL      DBKEY = '*FIRST'
     C                   EVAL      DBPGM = 'DL000140'
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** RCF Processing for Audit Printer File
 
     C                   EXSR      SRRCFAU
 
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
     C                   EXSR      SRAUDT
 
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
 
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2004
