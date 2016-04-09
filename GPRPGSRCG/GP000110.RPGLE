     H DEBUG ALWNULL(*USRCTL)
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2011')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas GP Work in Progress Housekeeping')               *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GP000110 - Midas GP Work In Progress Housekeeping            *
      *                                                               *
      *  Function:  This new program will delete all the records from *
      *             the Global Work In Progress file (T_MSWIP) and    *
      *             History file (T_MSWIP_H) reaching retention       *
      *             period with WIP status of 'AUTHORISED',           *
      *             'REJECTED' or 'NOT APPROVED'.                     *
      *                                                               *
      *  Called By: GOC000110 - Midas GO Work In Progress             *
      *                         Housekeeping Control                  *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2011            *
      *                                                               *
      *  Last Amend No. AR1005609          Date 25Nov12               *
      *  Prev Amend No. CSF011  *CREATE    Date 12Sep11               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR1005609- GOC000110 failed in EOM June run                  *
      *             (Child: AR1005610)                                *
      *  CSF011 - Customer Name on Inputs                             *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  *PSSR       - Error processing                               *
      *  *INZSR      - Initialise                                     *
      *  SrPrint     - Print Details                                  *
      *  SRAudit     - Generate Audit Report                          *
      *  SrOpenP1    - Open and Enroll report file                    *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
 
     FMSWIPTL0  UF   E           K DISK    INFSR(*PSSR) COMMIT USROPN
      ** Midas GP Work In Progress File
 
     FMSWIPHL0  UF   E           K DISK    INFSR(*PSSR) COMMIT USROPN
      ** Midas GP Work In Progress History File
 
     FGP000110P1O    E             PRINTER INFSR(*PSSR) INFDS(SPOOL1) USROPN
      ** GP Work In Progress Housekeeping Report
 
     FGP000110AUO    E             PRINTER INFSR(*PSSR) INFDS(SPOOLU) USROPN
      ** GP Work In Progress Housekeeping Audit
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
     D LDA           E DS           256    EXTNAME(LDA)
      ** Local data area for database error details
 
     D GZSDBANK      E DS                  EXTNAME(GZSDBANKPD)
      ** External DS for Bank Details
 
     D SPOOL1          DS
      ** P1 printer file information data structure
 
     D  SFILE                 83     92
     D  SFNUM                123    124B 0
     D  SFPLE                152    153B 0
     D  SFOVR                188    189B 0
     D  SFCUR                367    368B 0
 
     D SPOOLU          DS
      ** AU printer file information data structure
 
     D  SFILEU                83     92
     D  SFNUMU               123    124B 0
     D  SFPLEU               152    153B 0
     D  SFOVRU               188    189B 0
     D  SFCURU               367    368B 0
 
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY GPCPYSRCG,PSDS
      ** Program Status Data Structure
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D T_DATE          DS            10
     D W@YYYY                  1      4
     D W@MM                    6      7
     D W@DD                    9     10
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D @RUN            S              1A
     D PZone           S             10A
     D PRtCd           S              7A
     D PErms           S             50A
     D PCache          S              1A
     D PRecImage       S          32000A
 
     D MaxRptLine      S              3  0
     D CurRptLine      S              3  0
     D FirstPage       S              1A
     D RecordCount     S              5  0
 
     D ReptSeq         S              5A
     D Entity          S              3A
     D ZSNUMU          S              6  0
     D ZSERRU          S              1
     D ZSNUM           S              6  0
     D ZSERR           S              1
     D RetPeriod       S              3S 0
     D T_TMST          S             26A
     D W@DateIn        S              8A
     D W@DayNo         S              5P 0
     D W@DFmnt         S              1A
     D W@EFlag         S              1A
     D W@HWID          S                   LIKE(WHWID)
     D DltFlg          S              1A   INZ('N')
                                                                                           AR1005609
     D NULLDT          C                   CONST('0001-01-01-00.00.00.000000')             AR1005609
 
 
      *********************************************************************
      /EJECT
      *********************************************************************
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
      *********************************************************************
 
     C                   EXSR      SRINIT
 
     C     *LOVAL        SETLL     MSWIPTL0
     C                   READ      MSWIPTL0
 
     C                   DOW       NOT %EOF( MSWIPTL0 )
 
      ** Use Authoriser Timestamp to compute for the days from Rundate
 
     C                   IF        MSWZONE = BJZONE AND
     C                             (MSWSTAT = 'AUTHORISED')
     C                   EVAL      T_TMST = %CHAR(MSWAUTHTS)
     C                   EVAL      DltFlg = 'Y'
      *                                                                                    AR1005609
     C                   IF        T_TMST = NULLDT                                         AR1005609
     C                   EVAL      DltFlg = 'N'                                            AR1005609
     C                   ENDIF                                                             AR1005609
      *                                                                                    AR1005609
     C                   ENDIF
 
      ** Use Input Timestamp to compute for the days from the Rundate
 
     C                   IF        MSWZONE = BJZONE AND
     C                             (MSWSTAT = 'REJECTED' OR
     C                             MSWSTAT = 'NOT_APPROVED')
     C                   EVAL      T_TMST = %CHAR(MSWINPTS)
     C                   EVAL      DltFlg = 'Y'
      *                                                                                    AR1005609
     C                   IF        T_TMST = NULLDT                                         AR1005609
     C                   EVAL      DltFlg = 'N'                                            AR1005609
     C                   ENDIF                                                             AR1005609
      *                                                                                    AR1005609
     C                   ENDIF
 
     C                   IF        DltFlg = 'Y'
     C                   EXSR      SRDate11
 
      ** Delete record in WIP file if days calculated is greater than
      ** the retention period days in system values
 
     C                   IF        (BJRDNB - W@DayNo) > RetPeriod
     C                   DELETE    R_MSWIP                              99
     C                   EVAL      RecordCount = RecordCount + 1
     C                   EXSR      SRPrint
 
      ** Delete corresponding record in WIP history file
 
     C                   EVAL      W@HWID  = MSWID
 
     C     MS_KEYH       SETLL     MSWIPHL0
     C     MS_KEYH       READE     MSWIPHL0
 
     C                   DOW       NOT %EOF(MSWIPHL0)
     C                   DELETE    R_MSWIPH                             99
     C     MS_KEYH       READE     MSWIPHL0
     C                   ENDDO
 
     C                   ENDIF
     C                   ENDIF
 
     C                   READ      MSWIPTL0
     C                   EVAL      DltFlg = 'N'
     C                   ENDDO
 
      ** Output report trailer
 
     C                   IF        RecordCount <> 0
 
      ** Check for overflow line, output heading if required
 
     C                   Z-ADD     SFOVR         MaxRptLine
     C                   Z-ADD     SFCUR         CurRptLine
     C                   IF        ((MaxRptLine-CurRptLine) < 4) OR
     C                             FirstPage = 'Y'
     C                   WRITE     HEADP1
     C                   EVAL      FirstPage = 'N'
     C                   ENDIF
 
     C                   WRITE     TRAILP1
 
      ** Commit changes
 
     C                   COMMIT
 
     C                   ENDIF
 
      ** Generate Audit Report
 
     C                   EXSR      SRAudit
 
     C                   EVAL      *INLR = *ON
     C                   CLOSE     MSWIPTL0
     C                   CLOSE     MSWIPHL0
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRDate11 - Convert Date/Timestamp to Day Number               *
      *                                                               *
      *****************************************************************
 
     C     SRDate11      BEGSR
 
     C                   EVAL      T_DATE = T_TMST
     C                   EVAL      W@DateIn = W@DD + W@MM + W@YYYY
 
     C                   CALL      'ZDATE11'
     C                   PARM                    W@DateIn
     C                   PARM      *ZERO         W@DayNo
     C                   PARM      'D'           W@DFmnt
     C                   PARM      *BLANKS       W@EFlag
 
     C                   IF        W@EFlag = 'Y'
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'ZDATE11'
     C                   EVAL      DBASE = 04
     C                   EVAL      DBKEY = W@DateIn
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRInit - Initialisation                                       *
      *                                                               *
      *****************************************************************
 
     C     SRInit        BEGSR
     C
     C                   EVAL      PSysVal01 = 'WIPHousekeepDays'
     C                   CALL      'GPAOSVALR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM                    PSysVal01        20
     C                   PARM                    PCurSet01       200
     C                   PARM                    PSysVal02        20
     C                   PARM                    PCurSet02       200
     C                   PARM                    PSysVal03        20
     C                   PARM                    PCurSet03       200
     C                   PARM                    PSysVal04        20
     C                   PARM                    PCurSet04       200
     C                   PARM                    PSysVal05        20
     C                   PARM                    PCurSet05       200
     C                   PARM                    PSysVal06        20
     C                   PARM                    PCurSet06       200
     C                   PARM                    PSysVal07        20
     C                   PARM                    PCurSet07       200
     C                   PARM                    PSysVal08        20
     C                   PARM                    PCurSet08       200
     C                   PARM                    PSysVal09        20
     C                   PARM                    PCurSet09       200
     C                   PARM                    PSysVal10        20
     C                   PARM                    PCurSet10       200
 
     C                   IF        PRtCd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'GPSVALPD'
     C                   EVAL      DBASE = 01
     C                   EVAL      DBKEY = PSysVal01
     C                   OUT       LDA
     C                   EXSR      *PSSR
 
     C                   ELSE
 
     C                   EVAL      RetPeriod = %INT(PCurSet01)
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRPrint - Print Details                                       *
      *                                                               *
      *****************************************************************
 
     C     SrPrint       BEGSR
 
      ** Open & enroll report file
 
     C                   EXSR      SrOpenP1
 
      ** Set up report fields
 
     C                   EVAL      RSWID      = MSWID
     C                   EVAL      RSWACT     = MSWACT
     C                   EVAL      RSWAPI     = MSWAPI
     C                   EVAL      RSWSTAT    = MSWSTAT
     C                   EVAL      RSWTREF    = MSWTREF
     C                   EVAL      RSWINPUSER = MSWINPUSER
     C                   EVAL      RSWINPTS   = MSWINPTS
     C                   EVAL      RSWAUTHS   = MSWAUTH
     C                   EVAL      RSWAUTHTS  = MSWAUTHTS
 
      ** Check for overflow line, output heading if required
 
     C                   Z-ADD     SFOVR         MaxRptLine
     C                   Z-ADD     SFCUR         CurRptLine
     C                   IF        ((MaxRptLine-CurRptLine) < 3) OR
     C                             FirstPage = 'Y'
     C                   WRITE     HEADP1
     C                   EVAL      FirstPage = 'N'
     C                   ENDIF
 
      ** Output detail line
 
     C                   WRITE     DETAIL
 
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
     C                   PARM                    PZone
 
     C     *DTAARA       DEFINE                  LDA
 
     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM  = 'GP000110'
     C                   EVAL      DBFILE = *BLANKS
     C                   EVAL      DBKEY  = *BLANKS
     C                   EVAL      DBASE  = 00
     C                   OUT       LDA
 
     C                   CALL      'GPACSZBNK'
 
      ** Input
 
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      *BLANKS       PErms
     C                   PARM                    PZone
     C                   PARM      'N'           PCache
 
      ** Output
 
     C     GZSDBANK      PARM                    PRecImage
 
     C                   IF        PRtCd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM = 'GPACSZBNK'
     C                   EVAL      DBFILE = 'GZSDBANKPD'
     C                   EVAL      DBKEY = PRtcd
     C                   EVAL      DBASE = 01
     C                   OUT       LDA
     C                   EXSR      *PSSR
 
     C                   ENDIF
 
      ** Initialise report workfields and counter
 
     C                   EVAL      RecordCount = 0
     C                   EVAL      FirstPage   = 'Y'
 
     C     MS_KEYH       KLIST
     C                   KFLD                    W@HWID
     C                   KFLD                    MSWAPI
     C                   KFLD                    MSWZONE
 
     C                   OPEN      MSWIPTL0
     C                   OPEN      MSWIPHL0
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRAudit - Generate Audit Report                               *
      *                                                               *
      *****************************************************************
 
     C     SRAudit       BEGSR
 
      ** Open & enroll report file
 
     C                   IF        NOT %OPEN(GP000110AU)
     C                   OPEN      GP000110AU
     C                   Z-ADD     SFNUMU        ZSNUMU
     C                   CALL      'ZSFILE'
     C                   PARM      *BLANKS       ReptSeq
     C                   PARM      *BLANKS       Entity
     C                   PARM                    SFILEU
     C                   PARM                    ZSNUMU
     C                   PARM                    ZSERRU
 
     C                   IF        ZSERRU = 'Y'
     C                   EVAL      DBFILE =  'ZSFILE'
     C                   EVAL      DBKEY  =  'GP000109AU'
     C                   EVAL      DBPGM  =  'GP000109'
     C                   EVAL      DBASE  =  02
     C                   OUT       LDA
     C                   SETON                                        U7U8
     C                   DUMP
     C                   ENDIF
 
     C                   ENDIF
 
      ** Output audit heading
 
     C                   WRITE     HEADAU
 
      ** Output audit detail
 
     C                   IF        *INU7 = *OFF AND
     C                             *INU8 = *OFF
     C                   IF        RecordCount <> 0
     C                   Z-ADD     RecordCount   RCOUNT
     C                   WRITE     CONTROL
     C                   ELSE
     C                   WRITE     NODTLS
     C                   ENDIF
 
     C                   ELSE
     C                   WRITE     DBERROR
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrOpenP1 - Open and Enroll report file                        *
      *                                                               *
      *****************************************************************
 
     C     SrOpenP1      BEGSR
 
      ** Open & enroll report file
 
     C                   IF        NOT %OPEN(GP000110P1)
     C                   OPEN      GP000110P1
     C                   Z-ADD     SFNUM         ZSNUM
     C                   CALL      'ZSFILE'
     C                   PARM      *BLANKS       ReptSeq
     C                   PARM      *BLANKS       Entity
     C                   PARM                    SFILE
     C                   PARM                    ZSNUM
     C                   PARM                    ZSERR
 
     C                   IF        ZSERR = 'Y'
     C                   EVAL      DBFILE =  'ZSFILE'
     C                   EVAL      DBKEY  =  'GP000110P1'
     C                   EVAL      DBPGM  =  'GP000110'
     C                   EVAL      DBASE  =  03
     C                   OUT       LDA
     C                   SETON                                        U7U8
     C                   EXSR      *PSSR
     C                   ENDIF
 
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
 
     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'
     C                   DUMP
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
 
     C                   EXSR      SRAudit
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
 
