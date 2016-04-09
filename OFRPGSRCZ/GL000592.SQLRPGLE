     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2013')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas OF Forecast Housekeeping')
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GL000592 - Midas OF Forecast Housekeeping                    *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2013            *
      *                                                               *
      *  Last Amend No. MD025451           Date 07Mar14               *
      *  Prev Amend No. CGL145   *CREATE   Date 10Jul13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD025451 - Forecasts was not deleted based on System value   *
      *             ForecastRetention after CoB                       *
      *  CGL145 - Subsidiaries Daily Sweeping Forecast                *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Midas GL Accounting Rules List report - Audit list
     FGL000592AUO    E             PRINTER INFDS(SPOOLU)
     F                                     INFSR(*PSSR)
 
      ** +--------------------------------------+
      ** ¦ D-specs: Arrays and Data Structures  ¦
      ** ¦ =======  ==========================  ¦
      ** +--------------------------------------+
      ** Local data area for database error details
     D LDA           E DS           256    EXTNAME(LDA)
      ** The following fields are defined in the external file:
      **                                    134 141 DBFile
      **                                    142 170 DBKey
      **                                    171 180 DBPgm
      **                                    181 1830DBase
      **                                    184 193 DBMod
      **                                    194 203 DBProc
 
      ** Program Status Data Structure
     D/COPY ZACPYSRC,PSDS
 
      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      **  Short DS for access programs
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      **  Long DS for access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
     ** File DS
     **   Midas OF Total Forecast
     D FORTT         E DS                  EXTNAME(GLFORTTD)
 
      ** File Information Data Structure for GL000592AU.
     D SPOOLU          DS
     D   SFILEU               83     92
     D   SFNUMU              123    124B 0
 
      ** Parameter data
     D PData           DS
     D  Data                   1    100A
 
      ** Data structure for AOSVALR0 string
     D @SVAL1          DS           200
     D  SVAL1                  1    200
     D  SVAL1_1                1      1
 
      ** +--------------------------------------+
      ** ¦ D-specs: Declared variables          ¦
      ** ¦ =======  ==================          ¦
      ** +--------------------------------------+
 
      ** Parameters for access object programs
     D PRtCd           S              7
     D POptn           S              7
     D PSARD           S              6
 
      ** Parameters for ZSFILE
     D PSeq            S              5
     D SEnty           S              3
     D ZSnum           S              6  0
     D ZSnumU          S              6  0
     D ZSerr           S              1
 
      ** Parameter list fields
     D PMode           S              1
     D PLevl           S              1
     D PEnty           S              3
 
      ** Other fields used
     D WRun            S              1A   INZ
     D WRecNo          S              7S 0 INZ
     D WTFDCNT         S              7S 0 INZ(0)
     D WIFDCNT         S              7S 0 INZ(0)
     D WTFRCNT         S              7S 0 INZ(0)
     D WIFRCNT         S              7S 0 INZ(0)
     D RecordRead      S              1A   INZ('N')
 
      ** Processing mode
     D ProcMode        S            190
 
     D ForecastRet     S             17    INZ('ForecastRetention')
     D WDIFF           S              6  0 INZ(0)
     D WMNTH           S              6  0 INZ(0)
 
      ** Forecast Retention Period work field
     D WFRPD           S              6  0
 
     **  Forecast work fields
     D WFCUST          S              6
     D WFCSAC          S             34
     D WFCCY           S              3
     D WFNOSC          S              2
     D WFDATE          S              5  0 INZ(0)
 
 
      ** Parameter variables for AOSVALR0 string
     DRTNCDE           S              7
     DSVALK2           S             20
     DSVAL2            S            200
     DSVALK3           S             20
     DSVAL3            S            200
     DSVALK4           S             20
     DSVAL4            S            200
     DSVALK5           S             20
     DSVAL5            S            200
     DSVALK6           S             20
     DSVAL6            S            200
     DSVALK7           S             20
     DSVAL7            S            200
     DSVALK8           S             20
     DSVAL8            S            200
     DSVALK9           S             20
     DSVAL9            S            200
     DSVALK0           S             20
     DSVAL10           S            200
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ *InzSR is executed at program activation.                  ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
 
      * Audit Spool File recorded by RCF
 
     C                   EXSR      AuditRCF
 
      * Drop all logically deleted records
 
     C                   EXSR      DropDelRec
 
      * Drop all records that exceeds retention period
 
     C                   EXSR      DropRetRec
 
      * Write Audit Report
 
     C                   EXSR      SRAudit
 
     C                   EVAL      *INLR = *ON
 
     C                   RETURN
      *****************************************************************
      *  P R O G R A M   E N D                                        *
      *****************************************************************
      *                                                               *
      *  DropDelRec - Drop all logically deleted records              *
      *                                                               *
      *****************************************************************
     C     DropDelRec    BEGSR
      * Count all Logically deleted records:
 
      * from GLFORTTD (Total Forecast)
     C/exec SQL
     C+ SELECT COUNT(*) into: WTFDCNT from GLFORTTD
     C+ where TFRECI <> 'D'
     C/end-exec
 
      * from GLFORITD (Individual Forecast)
     C/exec SQL
     C+ Select COUNT(*) into: WIFDCNT from GLFORITD
     C+ where IFRECI <> 'D'
     C/end-exec
 
      * Move record count to report fields
 
     C                   EVAL      TFDCOUNT = WTFDCNT
     C                   EVAL      IFDCOUNT = WIFDCNT
 
      * Drop all logically deleted records
      * if record count <> 0
 
     C                   IF        TFDCOUNT <> 0
      *
      * from GLFORTTD (Total Forecast)
     C/exec SQL
     C+ Delete from GLFORTTD
     C+ where TFRECI <> 'D'
     C/end-exec
 
     C                   EVAL      RecordRead = 'Y'
 
     C                   ENDIF
 
     C                   IF        IFDCOUNT <> 0
      *
      * from GLFORITD (Individual Forecast)
     C/exec SQL
     C+ Delete from GLFORITD
     C+ where IFRECI <> 'D'
     C/end-exec
 
     C                   EVAL      RecordRead = 'Y'
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  DropRetRec - Drop all that exceeds retention period          *
      *                                                               *
      *****************************************************************
     C     DropRetRec    BEGSR
 
      ** Set file pointer to first record of Forecast Total and do initial read.
 
     C/exec SQL
     C+ declare LIST cursor for
     C+ select * from GLFORTTD
     C+ where TFRECI = 'D'
     C+ order by
     C+       TFCUST, TFCSAC,
     C+       TFCCY, TFNOSC,
     C+       TFDATE
     C/end-exec
 
     C/exec SQL
     C+ open LIST
     C/end-exec
 
      ** Handle SQL Error (if not %EOF)
 
     C                   If        SQLCOD < 0
 
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 3
     C                   EVAL      DBFILE = 'SQL STM'
     C                   EVAL      DBKEY = 'SQLSTT : ' + SQLSTT
     C                                   + ';  SQLCOD : ' + %char(SQLCOD)
     C                   OUT       LDA
     C                   EXSR      *PSSR
 
     C                   EndIf
 
 
     C/exec SQL
     C+ fetch next
     C+ from LIST
     C+ into: FORTT
     C/end-exec
 
      ** Read Total Forecast Table until end of file
 
     C                   DOW       SQLCode <> 100
 
      * Get the difference of Rundate Forecast Creation Date
 
     C                   EVAL      WDIFF = BJRDNB - TFDATE
 
      * Divide the difference with 30 (Monthly)
 
     C**********         EVAL      WMNTH = WDIFF / 30                                       MD025451
     C                   EVAL      WMNTH = WFRPD * 30                                       MD025451
 
      * Add 1 to total count if greater than the retention period
 
     C**********         IF        WMNTH > WFRPD                                            MD025451
     C                   IF        WDIFF > WMNTH                                            MD025451
 
     C                   EVAL      RecordRead = 'Y'
 
     C                   EVAL      WTFRCNT = WTFRCNT + 1
 
      * Move Primary Keys to a temporary field
 
     C                   Eval      WFCUST = TFCUST
     C                   Eval      WFCSAC = TFCSAC
     C                   Eval      WFCCY = TFCCY
     C                   Eval      WFNOSC = TFNOSC
     C                   Eval      WFDATE = TFDATE
 
      * Count records from the individual forecast related to the total forecast
 
      * from GLFORITD (Individual Forecast)
     C/exec SQL
     C+ Select COUNT(*) into: WIFRCNT from GLFORITD
     C+ where IFCUST = :WFCUST and
     C+ IFCSAC = :WFCSAC and
     C+ IFCCY = :WFCCY and
     C+ IFNOSC = :WFNOSC and
     C+ IFDATE = :WFDATE
     C/end-exec
 
      * Move record count to report fields
 
     C                   EVAL      TFRCOUNT = WTFRCNT
     C                   EVAL      IFRCOUNT = IFRCOUNT + WIFRCNT
 
      * Delete Records
 
      * from GLFORTTD (Total Forecast)
     C/exec SQL
     C+ Delete from GLFORTTD
     C+ where TFCUST = :WFCUST and
     C+ TFCSAC = :WFCSAC and
     C+ TFCCY = :WFCCY and
     C+ TFNOSC = :WFNOSC and
     C+ TFDATE = :WFDATE
     C/end-exec
 
      * from GLFORITD (Indivual Forecast)
     C/exec SQL
     C+ Delete from GLFORITD
     C+ where IFCUST = :WFCUST and
     C+ IFCSAC = :WFCSAC and
     C+ IFCCY = :WFCCY and
     C+ IFNOSC = :WFNOSC and
     C+ IFDATE = :WFDATE
     C/end-exec
 
     C                   ENDIF
 
     C/exec SQL
     C+ fetch next from LIST
     C+ into :FORTT
     C/end-exec
 
     C                   ENDDO
 
      ** Handle SQL Error (if not %EOF)
 
     C                   If        SQLCode < 100
 
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 4
     C                   EVAL      DBFILE = 'SQL STM'
     C                   EVAL      DBKEY = 'SQLSTT : ' + SQLSTT
     C                                   + ';  SQLCOD : ' + %char(SQLCOD)
     C                   OUT       LDA
     C                   EXSR      *PSSR
 
     C                   EndIf
 
     C/exec SQL
     C+ close LIST
     C/end-exec
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAudit - Write audit report                                 *
      *                                                               *
      *****************************************************************
     C     SRAudit       BEGSR
 
      ** If there is a DB Error, Output the DB Error Information.
 
     C                   IF        *INU7 = *ON
     C                   WRITE     DBERROR
     C                   ELSE
 
      ** If there is a record read, write audit control report.
 
     C                   IF        RecordRead = 'Y'
     C                   WRITE     CONTROL
     C                   ELSE
 
      ** Or, if no records read, Output "No Details" message.
 
     C                   WRITE     NODTLS
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  AuditRCF - Audit Spool File recorded by RCF                  *
      *                                                               *
      *****************************************************************
     C     AuditRCF      BEGSR
 
      ** Ensure Audit Spool File recorded by RCF.
 
     C                   EVAL      ZSnumU = SFNUMU
 
     C                   CALL      'ZSFILE'
     C                   PARM                    PSeq
     C                   PARM      *Blanks       SEnty
     C                   PARM                    SFILEU
     C                   PARM                    ZSnumU
     C                   PARM      *Blank        ZSerr
 
      ** If Error occurs during ZSFILE processing, then return to the
      ** Calling Program.
 
     C                   IF        ZSERR = 'Y'
     C                   EVAL      *InU7 = *On
     C                   EVAL      *InU8 = *On
     C                   EVAL      *InLR = *On
     C                   RETURN
     C                   ENDIF
 
      * Write Header
     C                   WRITE     HEADAU
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *InzSr - Program Initialisation routine                      *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    PSeq
     C                   PARM                    PData
 
      ** Set off program indicators
 
     C                   EVAL      *INU7 = *OFF
     C                   EVAL      *INU8 = *OFF
 
     C     *DTAARA       DEFINE                  LDA
 
     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   OUT       LDA
 
      ** Access Bank details
      **   Retrieve Run day number
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *Blanks       PRtCd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY
 
     C                   IF        PRtCd <> *Blanks
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = POptn
     C                   EVAL      DBFile = 'SDBANKPD'
     C                   EVAL      DBase = 001
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      * Retrieve the system value
 
     C                   EVAL      ProcMode = ForecastRet
     C                   CALL      'AOSVALR0'
     C                   PARM                    RTNCDE
     C                   PARM                    ProcMode
     C                   PARM                    SVAL1
     C                   PARM                    SVALK2
     C                   PARM                    SVAL2
     C                   PARM                    SVALK3
     C                   PARM                    SVAL3
     C                   PARM                    SVALK4
     C                   PARM                    SVAL4
     C                   PARM                    SVALK5
     C                   PARM                    SVAL5
     C                   PARM                    SVALK6
     C                   PARM                    SVAL6
     C                   PARM                    SVALK7
     C                   PARM                    SVAL7
     C                   PARM                    SVALK8
     C                   PARM                    SVAL8
     C                   PARM                    SVALK9
     C                   PARM                    SVAL9
     C                   PARM                    SVALK0
     C                   PARM                    SVAL10
 
      * If the system value is not found then issue a database error
 
     C     RTNCDE        IFNE      '       '
     C                   EXSR      *PSSR
     C                   ENDIF
 
      * Get the Forecast Retention Period
 
     C                   EVAL      WFRPD = %Dec(SVAL1:2:0)
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
      *  Called by:                                                   *
      *                                                               *
      *  Calls:          None                                         *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
 
     C                   IF        WRun = *Blanks
     C                   EVAL      WRun = 'Y'
     C                   DUMP
     C                   ENDIF
 
     C                   EVAL      *INU7 = *On
     C                   EVAL      *INU8 = *On
     C                   EVAL      *INLR = *On
 
     C                   EXSR      SRAudit
 
     C                   RETURN
 
     C                   ENDSR
