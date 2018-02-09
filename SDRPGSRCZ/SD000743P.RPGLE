     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Hedge Strategy Tables Report')                *
      *****************************************************************
      *                                                               *
      *  Midas - Accounting Standard Module                           *
      *                                                               *
      *  SD000743P - Hedge Strategy Tables Report                     *
      *                                                               *
      *  Function:  This module lists the Hedge Strategy Tables in    *
      *             the system. Runs on I/C upon request and in COB   *
      *             if there is an action done in maintenance.        *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CLE134             Date 01Aug12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 228125             Date 30Jun04               *
      *                 CGL029             Date 01Sep03               *
      *                 CAS006             Date 21Jan03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAS002  *CREATE    Date 14Jan02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  228125 - File controls out of balance SD000743AU.            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CAS006 - Hedge Accounting Phase B                            *
      *  CAS002 - Hedge Strategy/Linkage                              *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    01         End of File for SDHGSTL1                        *
      *    10         Derivatie Types exceeds 5 items                 *
      *    11         No Details to Report                            *
      *    12         Chain fail to files                             *
      *    13         Program Failure                                 *
      *    14         Record Locked                                   *
      *    15         Update Error                                    *
      *    16         Display Indicator for FSMEFF                    *                       CAS006
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * SRINIT - Initialisation                                       *
      * SRPROC - Detail Processing                                    *
      * SRAUDT - Audit Printing                                       *
      * SRPRNT - Detail Printing                                      *
      * SRRCFP1 - Detail Spool File recorded by RCF                   *
      * SRBRCH - Get Branch Name                                      *
      * SRCHTP - Determine Last action done to record                 *
      * SRDATE - Convert Midas day number to date                     *
      * SRFLDS - Place remaining fields to printer file               *
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
 
      ** SD Hedge Strategy Table File
     FSDHGSTL1  IF   E           K DISK    INFSR(*PSSR)
 
      ** RTV: Standing Data Controls Retrieval index
     FSDFCTLL1  IF   E           K DISK    INFSR(*PSSR)
 
      ** UPD: Standing Data Controls Update index
     FSDFCTLL0  UF   E           K DISK    INFSR(*PSSR)
 
      ** SD Hedge Strategy Table detail report
     FSD000743P1O    E             PRINTER USROPN
     F                                     INFSR(*PSSR)
     F                                     INFDS(SPOOL1)
 
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
 
      ** Externally described DS for branch details
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
 
      ** External data structure for Switchable Features Details                              CAS006
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CAS006
                                                                                              CAS006
      ** DS for access programs - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** File Information Data Structure for SD000743P1
     D SPOOL1          DS
     D  PSFile1               83     92
     D  PSFNum1              123    124B 0
     D  OflLn1               188    189B 0
     D  PrtLn1               367    368B 0
      *
      ** File Information Data Structure for SD000743AU
     D SPOOLU          DS
     D  PSFileU               83     92
     D  PSFNumU              123    124B 0
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Parameters for ZSFILE
     D PSeq            S              5
     D PLevel          S              1
     D PEnty           S              3
     D ZSnum           S              6  0
     D ZSnumU          S              6  0
     D ZSerr           S              1
 
      ** Parameters for access object programs
     D PRTCD           S              7
     D POPTN           S              7
     D PSard           S              6                                                       CAS006
 
     D PMode           S              1
     D PFlag           S              1
 
     D RqdLn1          S              3P 0
     D DifLn1          S              4P 0
     D WorkNum         S              5P 0
     D PReptNam        S             10
 
     D WHead1          S             16
     D WLine1          S             16
     D WHead2          S             18
     D WLine2          S             18
 
     D ZDATE           S              6  0
     D ZADATE          S              7
 
     D KFilNam         S             10
     D WNORC           S                   LIKE(AHNORC)
     D WNORC2          S                   LIKE(AHNORC)
     D WNOIN           S                   LIKE(AHNOIN)
     D WNOAM           S                   LIKE(AHNOAM)
     D WNODL           S                   LIKE(AHNODL)
 
     D WError          S              1
     D CAS006          S              1                                                       CAS006
      *                                                                                       CGL029
     D DSSDY         E DS                  EXTNAME(DSSDY)                                     CGL029
      *                                                                                       CGL029
 
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
 
      ** RCF Processing for rinter File.
 
     C                   EXSR      SRRCFP1
 
      ** Report Work fields.
 
     C                   EVAL      RqdLn1  = 0
     C                   EVAL      DifLn1  = 0
     C                   EVAL      RTOTAL  = 0
     C                   EVAL      PrtLn1  = 0
     C                   EVAL      WorkNum = 0
     C                   EVAL      *IN11 = '0'
     C                   EVAL      PFlag = *BLANKS
     C                   EVAL      WError = 'N'
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRPROC - Detail Processing                                    *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: SRPRNT                                                 *
      *                                                               *
      *****************************************************************
 
     C     SRPROC        BEGSR
 
      ** Print Header
     C                   WRITE     HEADP1
 
     C     *LOVAL        SETLL     SDHGSTL1
 
      ** SD Hedge Strategy
     C                   READ      SDHGSTL1                               01
 
     C                   DOW       *IN01 = *OFF
 
     C                   EVAL      WorkNum = WorkNum + 1
 
      ** If AUDIT mode, process only records whose LCD = Rundate
      ** If report is requested, process only live records
     C                   IF        ((PMode = 'A') AND (FSLCD = BJRDNB))
     C                             OR ((PMode <> 'A') AND
     C                             (FSCHTP <> 'D'))
     C                   EXSR      SRPRNT
     C                   ENDIF
 
     C                   READ      SDHGSTL1                               01
 
     C                   ENDDO
 
      ** When EOF, write trailer
     C                   IF        *IN01 = *ON
     C                   EVAL      RqdLn1 = 8
     C                   EXSR      SRCHKLIN
 
     C                   IF        RTOTAL = 0
     C                   EVAL      *IN11 = '1'
     C                   ENDIF
 
     C                   WRITE     TRAILP1
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRPRNT - Detail Printing                                      *
      *                                                               *
      * Called by: SRPROC                                             *
      *                                                               *
      * Calls: SRBRCH                                                 *
      *                                                               *
      *****************************************************************
 
     C     SRPRNT        BEGSR
 
      ** Check for overflow
     C                   EVAL      RqdLn1 = 14
     C                   EXSR      SRCHKLIN
 
      ** Put details to printer fields.
 
     C                   EVAL      RHESN = FSHESN
     C                   EVAL      RHELD = FSHELD
     C                   EVAL      RBRCD = FSBRCA
 
      ** Obtain Branch Name
     C                   EXSR      SRBRCH
 
      ** Get Last Change type
     C                   EXSR      SRCHTP
 
     C                   EVAL      RPRTP = FSPRTP
     C                   EVAL      RPRST = FSPRST
                                                                                              CAS006
      ** Hide "For information purpose only" field                                            CAS006
                                                                                              CAS006
     C**********         EVAL      RHRSK = FSHRSK                                             CAS006
     C**********         EVAL      REFFM = FSEFFM                                             CAS006
     C                   EVAL      REFUP = FSEFUP
     C                   EVAL      REFLO = FSEFLO
     C                   EVAL      REFFQ = FSEFFQ
 
      ** Convert midas rundate to appropriate date format
     C                   EXSR      SRDATE
 
      ** Put remaining fields in printer file
     C                   EXSR      SRFLDS
 
     C                   EVAL      RTOTAL = RTOTAL + 1
 
      ** Write Detail
      *
     C                   WRITE     DETAIL
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRAUDT - Audit Processing                                     *
      *                                                               *
      * Called by: Main Processing, SRPROC                            *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SRAUDT        BEGSR
 
      ** Process SDFCTLPA only in audit mode
     C                   IF        PMode = 'A'
 
     C                   EVAL      KFilNam = 'SDHGSTPD  '
     C     KFILE         CHAIN     SDFCTLL1                           12
 
      ** DBerror if record not found
     C                   IF        *IN12 = '1'
     C                   EVAL      DBFILE = 'SDFCTLPA'
     C                   EVAL      DBASE = 3
     C                   EVAL      DBKEY = KFilNam
     C                   EXSR      *PSSR
 
     C                   ELSE
 
     C                   EVAL      WNORC = AHNORC
     C                   EVAL      WNOIN = AHNOIN
     C                   EVAL      WNOAM = AHNOAM
     C                   EVAL      WNODL = AHNODL
     C                   ENDIF
 
      ** Compare # of records read to the # of records in file
                                                                                              228125
     C                   EVAL      WorkNum = WorkNum - WNODL                                  228125
     C                   IF        WorkNum <> WNORC
     C                   EVAL      PFlag = 'N'
     C                   ENDIF
 
      ** Call Audit Printfile override program, SD Data Controls
     C                   CALL      'SDC540P'                            13
     C                   PARM      'SD000743AU'  PReptNam
     C                   PARM                    PFlag
     C                   PARM                    WNOIN
     C                   PARM                    WNOAM
     C                   PARM                    WNODL
     C                   PARM                    WorkNum
     C                   PARM                    WNORC
     C                   PARM                    RTITLE
     C                   PARM                    RUNDLN
 
      ** Call to program ended in error
     C                   IF        *IN13 = '1'
     C                   EVAL      WError = 'Y'
     C                   ENDIF
 
      ** If work flag is incorrect
     C                   IF        PFlag = 'N'
     C                   EVAL      *INU8 = '1'
     C                   ENDIF
 
      ** If audit program ended normally
     C                   IF        WError = 'N'
     C                   EXSR      SRUPDAT
     C                   ENDIF
 
     C                   ENDIF
 
      ** END OF PROGRAM
     C                   EVAL      *INLR = '1'
     C                   RETURN
 
     C                   ENDSR
 
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
 
     C                   OPEN      SD000743P1
      *
      ** Ensure Detail Spool File recorded by RCF.
      *
     C                   EVAL      ZSnum = PSFNum1
      *
     C                   CALL      'ZSFILE'
     C                   PARM                    PSeq
     C                   PARM                    PEnty
     C                   PARM                    PSFile1
     C                   PARM                    ZSnum
     C                   PARM      *Blank        ZSerr
      *
      ** If Error occurs during ZSFILE processing, then return to the
      ** Calling Program.
      *
     C     ZSERR         IFEQ      'Y'
     C                   SETON                                        U7U8LR
     C                   RETURN
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRBRCH - Get Branch Name                                      *
      *                                                               *
      * Called by: SRPRNT                                             *
      *                                                               *
      * Calls: AOBRCHR0                                               *
      *                                                               *
      *****************************************************************
 
     C     SRBRCH        BEGSR
 
     C**********         CALLB     'AOBRCHR0'                                                 CGL029
     C                   CALL      'AOBRCHR1'                                                 CGL029
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM                    FSBRCA
     C*****SDBRCH        PARM      SDBRCH        DSFDY                                        CGL029
     C     SDBRCH        PARM      SDBRCH        DSSDY                                        CGL029
 
      ** Database Error
     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      DBFILE = 'SDBRCHPD'
     C                   EVAL      DBASE = 2
     C                   EVAL      DBKEY = FSBRCA
     C                   EVAL      DBPGM = 'SD000743P'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      RBRNM = A8BRNM
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRCHTP - Determine Last Action done to record                 *
      *                                                               *
      * Called by: SRPRNT                                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SRCHTP        BEGSR
 
      ** Populate action fields only in AUDIT mode
 
     C                   IF        PMode = 'A'
 
     C                   EVAL      RACT  = 'ACTION:'
     C                   SELECT
     C                   WHEN      FSCHTP = 'I'
     C                   EVAL      RACTION = 'INSERT'
     C                   WHEN      FSCHTP = 'A'
     C                   EVAL      RACTION = 'AMEND'
     C                   WHEN      FSCHTP = 'D'
     C                   EVAL      RACTION = 'DELETE'
     C                   ENDSL
 
     C                   ELSE
     C                   EVAL      RACT = *BLANKS
     C                   EVAL      RACTION = *BLANKS
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRDATE - Convert Date to DDMMMYY                              *
      *                                                               *
      * Called by: SRPRNT                                             *
      *                                                               *
      * Calls: ZDATE2                                                 *
      *                                                               *
      *****************************************************************
 
     C     SRDATE        BEGSR
 
     C                   CALLB     'ZDATE2'
     C                   PARM                    FSFSDT
     C                   PARM                    BJDFIN
     C                   PARM      *ZEROS        ZDATE
     C                   PARM      *BLANKS       ZADATE
 
     C                   MOVE      ZADATE        RFSDT
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRFLDS - Place remaining fields in printer file               *
      *                                                               *
      * Called by: SRPRNT                                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SRFLDS        BEGSR
 
     C                   EVAL      *IN10 = '0'
 
      ** Effectiveness Assessment Method                                                      CAS006
                                                                                              CAS006
     C                   IF        CAS006 = 'Y'                                               CAS006
     C                   EVAL      *IN16 = '1'                                                CAS006
     C                   EVAL      RMEFF = FSMEFF                                             CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
      ** Derivative Types
     C                   EVAL      R1DVT1 = FSDVT1
     C                   EVAL      R1DVT2 = FSDVT2
     C                   EVAL      R1DVT3 = FSDVT3
     C                   EVAL      R1DVT4 = FSDVT4
     C                   EVAL      R1DVT5 = FSDVT5
 
     C                   IF        (FSDVT6 <> *BLANKS) OR
     C                             (FSDVT7 <> *BLANKS) OR
     C                             (FSDVT8 <> *BLANKS) OR
     C                             (FSDVT9 <> *BLANKS) OR
     C                             (FSDVT10 <> *BLANKS)
     C                   EVAL      *IN10 = '1'
     C                   EVAL      R1DVT6 = FSDVT6
     C                   EVAL      R1DVT7 = FSDVT7
     C                   EVAL      R1DVT8 = FSDVT8
     C                   EVAL      R1DVT9 = FSDVT9
     C                   EVAL      R1DVT10 = FSDVT10
     C                   ENDIF
 
      ** Derivative Sub Types
     C                   EVAL      R1DST1 = FSDST1
     C                   EVAL      R1DST2 = FSDST2
     C                   EVAL      R1DST3 = FSDST3
     C                   EVAL      R1DST4 = FSDST4
     C                   EVAL      R1DST5 = FSDST5
     C                   EVAL      R1DST6 = FSDST6
     C                   EVAL      R1DST7 = FSDST7
     C                   EVAL      R1DST8 = FSDST8
     C                   EVAL      R1DST9 = FSDST9
     C                   EVAL      R1DST10 = FSDST10
 
      ** Derivative Book Codes
     C                   EVAL      R1DBK1 = FSDBK1
     C                   EVAL      R1DBK2 = FSDBK2
     C                   EVAL      R1DBK3 = FSDBK3
     C                   EVAL      R1DBK4 = FSDBK4
     C                   EVAL      R1DBK5 = FSDBK5
     C                   EVAL      R1DBK6 = FSDBK6
     C                   EVAL      R1DBK7 = FSDBK7
     C                   EVAL      R1DBK8 = FSDBK8
     C                   EVAL      R1DBK9 = FSDBK9
     C                   EVAL      R1DBK10 = FSDBK10
 
      ** Hedged Deal/Investment Types
     C                   EVAL      R1HDT1 = FSHDT1
     C                   EVAL      R1HDT2 = FSHDT2
     C                   EVAL      R1HDT3 = FSHDT3
     C                   EVAL      R1HDT4 = FSHDT4
     C                   EVAL      R1HDT5 = FSHDT5
     C                   EVAL      R1HDT6 = FSHDT6
     C                   EVAL      R1HDT7 = FSHDT7
     C                   EVAL      R1HDT8 = FSHDT8
     C                   EVAL      R1HDT9 = FSHDT9
     C                   EVAL      R1HDT10 = FSHDT10
 
      ** Hedged Deal Sub Types
     C                   EVAL      R1HST1 = FSHST1
     C                   EVAL      R1HST2 = FSHST2
     C                   EVAL      R1HST3 = FSHST3
     C                   EVAL      R1HST4 = FSHST4
     C                   EVAL      R1HST5 = FSHST5
     C                   EVAL      R1HST6 = FSHST6
     C                   EVAL      R1HST7 = FSHST7
     C                   EVAL      R1HST8 = FSHST8
     C                   EVAL      R1HST9 = FSHST9
     C                   EVAL      R1HST10 = FSHST10
 
      ** Hedged Deal Book Codes
     C                   EVAL      R1HBK1 = FSHBK1
     C                   EVAL      R1HBK2 = FSHBK2
     C                   EVAL      R1HBK3 = FSHBK3
     C                   EVAL      R1HBK4 = FSHBK4
     C                   EVAL      R1HBK5 = FSHBK5
     C                   EVAL      R1HBK6 = FSHBK6
     C                   EVAL      R1HBK7 = FSHBK7
     C                   EVAL      R1HBK8 = FSHBK8
     C                   EVAL      R1HBK9 = FSHBK9
     C                   EVAL      R1HBK10 = FSHBK10
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRUPDAT - Update Audit Controls                               *
      *                                                               *
      * Called by: SRAUDT                                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SRUPDAT       BEGSR
 
     C                   EVAL      KFilNam = 'SDHGSTPD  '
     C     KFILE         CHAIN     SDFCTLL0                           1214
 
      ** DBerror if record not found
     C                   IF        *IN12 = '1'
     C                   EVAL      DBFILE = 'SDFCTLPA'
     C                   EVAL      DBASE = 4
     C                   EVAL      DBKEY = KFilNam
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Record Locked dont continue update
     C                   IF        *IN14 = '1'
     C                   EVAL      *IN14 = '1'
     C                   ELSE
 
      ** Save values in work fields
     C                   EVAL      WNORC2 = AHNORC
     C                   EVAL      WNOIN  = AHNOIN
     C                   EVAL      WNOAM  = AHNOAM
     C                   EVAL      WNODL  = AHNODL
 
      ** Update File fields
     C                   EVAL      AHNORC = WNORC2
     C                   EVAL      AHNOIN = 0
     C                   EVAL      AHNOAM = 0
     C                   EVAL      AHNODL = 0
 
     C                   UPDATE    @AHREAU                              15
     C                   IF        *IN15 = '1'
     C                   EVAL      DBASE = 5
     C                   EVAL      DBKEY = '*UPDATE'
     C                   EVAL      DBFILE = 'SDFCTLPA'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDIF
 
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
     C                   WRITE     HEADP1
     C                   ENDIF
 
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
 
     C     *ENTRY        PLIST
     C                   PARM                    ReturnCode
     C                   PARM                    PMode
     C                   PARM                    PSeq
     C                   PARM                    PLevel
     C                   PARM                    PEnty
 
     C/COPY ZACPYSRC,DBFIELDS
 
      ** Access Bank Details
     C                   CALLB     'AOBANKR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database Error
     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE = 1
     C                   EVAL      DBKEY = '*FIRST'
     C                   EVAL      DBPGM = 'SD000743P'
     C                   EXSR      *PSSR
     C                   ENDIF
                                                                                              CAS006
      ** Check if CAS006 is installed                                                         CAS006
                                                                                              CAS006
     C                   EVAL      CAS006 = 'N'                                               CAS006
     C                   CALL      'AOSARDR0'                                                 CAS006
     C                   PARM      *BLANKS       PRTCD                                        CAS006
     C                   PARM      '*VERIFY'     POPTN                                        CAS006
     C                   PARM      'CAS006'      PSard                                        CAS006
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAS006
                                                                                              CAS006
     C                   IF        PRTCD = *BLANKS                                            CAS006
     C                   EVAL      CAS006 = 'Y'                                               CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
      ** Database error                                                                       CAS006
                                                                                              CAS006
     C                   IF        PRTCD <> *BLANKS AND                                       CAS006
     C                             PRTCD <> '*NRF   '                                         CAS006
     C                   EVAL      DBKEY = PSard                                              CAS006
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CAS006
     C                   EVAL      DBASE  =  2                                                CAS006
     C                   EXSR      *PSSR                                                      CAS006
     C                   ENDIF                                                                CAS006
 
      ** Prepare the Header Title to be used (must be centered)
     C                   EVAL      WHead1 = 'HEDGE STRATEGIES'
     C                   EVAL      WLine1 = '----------------'
 
     C                   IF        PMode = 'A'
     C                   EVAL      WHead2 = ' MAINTENANCE TODAY'
     C                   EVAL      WLine2 = '------------------'
     C                   EVAL      RTITLE = '          ' +
     C                                      WHead1 + WHead2
     C                   EVAL      RUNDLN = '          ' +
     C                                      WLine1 + WLine2
     C                   ELSE
 
     C                   EVAL      WHead2 = ' LISTING'
     C                   EVAL      WLine2 = '--------'
     C                   EVAL      RTITLE = '               ' +
     C                                      WHead1 + WHead2
     C                   EVAL      RUNDLN = '               ' +
     C                                      WLine1 + WLine2
     C                   ENDIF
 
      ** Define Key List Foe SDFCTLPA
     C     KFILE         KLIST
     C                   KFLD                    KFilNam
 
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
     C                   EVAL      ReturnCode = '*ERROR'
 
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
 
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2002
