     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2013')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas RE ABC Exception File Purge')                    *
      *****************************************************************
      *                                                               *
      *  Midas - Retail Module                                        *
      *                                                               *
      *  RE001512 - Account Balance Check Exception File Purge        *
      *                                                               *
      *  Function:  This program will drop records from REABCXPD that *
      *             are outside the defined retention period.         *
      *                                                               *
      *  Called By: REC001512 - Account Balance Exception File Purge  *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2013            *
      *                                                               *
      *  Last Amend No. AR1089591 *CREATE  Date 05Apr13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR1089591 - ABC Data Queue Recovery Process                  *
      *              (Child:AR1089593)                                *
      *            - Applied for MD019899                             *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    60         End-of-File Indicator                           *
      *    99         Error Indicator                                 *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E   I N D E X                              *
      *                                                               *
      *  Main routine                                                 *
      *  SRInit    - Initialise                                       *
      *  *PSSR     - Error handling subroutine                        *
      *  SRProcess - Drop records from REABCXPD that                  *
      *              are outside the defined retention period         *
      *  SRPrint   - Process Report Lines                             *
      *  SRWP1REC  - Write a Detail record to the Report              *
      *  SRRCFP1   - Register the P1 Printer File via RCF             *
      *  SRAudit   - Output Audit report and End Program              *
      *  SRRCFAU   - Register the AU Printer File via RCF             *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Midas RE ABC Message Details for Exception Errors (Logical)
     FREABCXL1  UF   E           K DISK    COMMIT
     F                                     INFSR(*PSSR)
 
      ** RE ABC Exception File Purge Report - Detail
     FRE001512P1O    E             PRINTER INFSR(*PSSR) USROPN
     F                                     INFDS(SPOOL1)
 
      ** RE ABC Exception File Purge Report - Audit
     FRE001512AUO    E             PRINTER INFSR(*PSSR) USROPN
     F                                     INFDS(SPOOLU)
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** Short data structure for access objects
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** DS for access programs, long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** The Following /COPY Line Includes All The Defined Fields In
      ** The PSDS.  They Have Meaningful Names, Prefixed By 'PS'.
     D/COPY ZACPYSRC,PSDS
 
      ** +--------------------------------------+
      ** ¦ Arrays AND Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Local data area for database error details
     D LDA             DS           256
 
     D  DBFILE               134    141
     D  DBKEY                142    170
     D  DBPGM                171    180
     D  DBASE                181    183  0
     D  DBTXT                184    256
 
      ** File Information Data Structure for RE001512P1
     D SPOOL1          DS
 
     D  SFILE1                83     92
     D  SFNUM1               123    124B 0
     D  OFLLN1               188    189B 0
     D  PRTLN1               367    368B 0
 
      ** File Information Data Structure for RE001512AU
     D SPOOLU          DS
 
     D  SFILEU                83     92
     D  SFNUMU               123    124B 0
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D P@OP01          S             20
     D P@VL01          S            200
     D P@OP02          S             20
     D P@VL02          S            200
     D P@OP03          S             20
     D P@VL03          S            200
     D P@OP04          S             20
     D P@VL04          S            200
     D P@OP05          S             20
     D P@VL05          S            200
     D P@OP06          S             20
     D P@VL06          S            200
     D P@OP07          S             20
     D P@VL07          S            200
     D P@OP08          S             20
     D P@VL08          S            200
     D P@OP09          S             20
     D P@VL09          S            200
     D P@OP10          S             20
     D P@VL10          S            200
 
     D WRun            S              1A
     D PRtCd           S              7A
     D POptn           S              7A
     D PSeq            S              5
     D PEnty           S              3
     D PZSErr          S              1
     D PZSNum          S              6  0
     D PSFile          S             10
     D WRqdln          S              3  0
     D WDifln          S              3  0
     D WRetPrd         S              5
     D WRetPrdN        S              5  0
     D WTranRetPrd     S              5  0
     D ZDAYNO          S              5  0
     D ZDATE           S              6  0
     D ZADATE          S              7
     D WCount          S              4  0
     D WLine           S              4  0
     D WLength         S              4  0
     D WRem            S              4  0
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *  MAIN - Processing                                            *
      *****************************************************************
 
      ** Perform Initialisation
 
     C                   EXSR      SRInit
 
      ** Perform Detail Processing
 
     C                   EXSR      SRProcess
 
      ** Output Audit Report and End Program
 
     C                   EXSR      SRAudit
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRProcess - Subroutine to drop records from REABCXPD that     *
      *             are outside the defined retention period          *
      *                                                               *
      * Called by: Main routine                                       *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SRProcess     BEGSR
 
     C     *LOVAL        SETLL     REABCXL1
     C                   READ      REABCXL1
 
     C                   DOW       NOT %EOF(REABCXL1)
 
     C                   IF        MXLDAT < WTranRetPrd
 
     C                   EVAL      RCOUNT = RCOUNT + 1
     C                   EXSR      SRPrint
     C                   DELETE    REABCXD0
 
     C                   ENDIF
 
     C                   READ      REABCXL1
     C                   ENDDO
 
     C                   EXSR      SRAudit
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPrint  - Process Report Lines                              *
      *                                                               *
      *  Called by: SRProcess                                         *
      *                                                               *
      *  Calls: SRWP1REC, SRRCFP1                                     *
      *                                                               *
      *****************************************************************
 
     C     SRPrint       BEGSR
 
      ** If first pass or branch is not the same as previous branch
 
     C                   IF        NOT %OPEN(RE001512P1)
     C                   OPEN      RE001512P1
     C                   WRITE     HEADPY
     C                   ENDIF
 
      ** Do RCF processing
 
     C                   EXSR      SRRCFP1
 
     C                   EVAL      ZDAYNO = MXLDAT
     C                   CALL      'ZDATE2'
     C                   PARM                    ZDAYNO
     C                   PARM                    BJDFIN
     C                   PARM      *ZEROS        ZDATE
     C                   PARM      *BLANKS       ZADATE
 
      ** Write Details
      ** Date received, Status flag, Message details
 
     C                   EVAL      RALDAT = ZADATE
     C                   EVAL      RAFLAG = MXFLAG
     C                   EVAL      RAMSG  = MXMSG
 
     C                   EXSR      SRWP1REC
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRWP1REC - Subroutine to Write a Detail record to the Report *
      *                                                               *
      *  Called by: SRPrint                                           *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
 
     C     SRWP1REC      BEGSR
 
      ** Determine number of lines of the ABC message
 
     C                   EVAL      WCount = 108
     C                   EVAL      WLine = 1
     C                   EVAL      RAMSG2 = RAMSG
     C                   EVAL      WLength = %LEN(%TRIM(MXMSG))
     C                   EVAL      WRem = %REM(WLength:107)
     C                   IF        WRem > 0
     C                   EVAL      WLength = (WLength - WRem) + 107
     C                   ENDIF
 
     C                   DOW       WCount < Wlength
     C                   IF        (Wlength - WCount) >= 107
     C                   EVAL      RAMSG2 = %SUBST(MXMSG:WCount:107)
     C                   ELSE
     C                   EVAL      RAMSG2 = %SUBST(MXMSG:WCount:WRem)
     C                   ENDIF
     C                   EVAL      WLine = WLine + 1
     C                   EVAL      WCount = WCount + 107
     C                   ENDDO
 
      ** Check that sufficient lines remain for the Format. If not,
      ** write out the Main Headings on a new page
 
     C                   EVAL      WRqdln = WLine
     C                   EVAL      WDifln = OFLLN1 - PRTLN1
     C                   IF        WDifln <= WRqdln
     C                   WRITE     HEADPY
     C                   ENDIF
 
      ** Write out Detail Record
 
     C                   WRITE     DETAIL
 
     C                   EVAL      WCount = 108
     C                   EVAL      RAMSG2 = RAMSG
 
     C                   DOW       WCount < Wlength
     C                   IF        (Wlength - WCount) >= 107
     C                   EVAL      RAMSG2 = %SUBST(MXMSG:WCount:107)
     C                   ELSE
     C                   EVAL      RAMSG2 = %SUBST(MXMSG:WCount:WRem)
     C                   ENDIF
     C                   WRITE     DETAIL2
     C                   EVAL      WCount = WCount + 107
     C                   EVAL      RAMSG2 = ''
     C                   ENDDO
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRCFP1 - Subroutine to register the P1 Printer File via RCF *
      *                                                               *
      *  Called by: SRPrint                                           *
      *                                                               *
      *  Calls: ZSFILE                                                *
      *                                                               *
      *****************************************************************
 
     C     SRRCFP1       BEGSR
 
      ** Ensure Report Spool File recorded by RCF
 
     C                   EVAL      PSFile = SFILE1
     C                   Z-ADD     SFNUM1        PZSNum
 
     C                   CALL      'ZSFILE'
     C                   PARM                    PSeq
     C                   PARM      *BLANKS       PEnty
     C                   PARM                    PSFile
     C                   PARM                    PZSNum
     C                   PARM      *BLANK        PZSErr
 
      ** If Error occurs during ZSFILE processing, then return to the
      ** Calling Program
 
     C                   IF        PZSErr = 'Y'
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
      *  SRAudit - Subroutine to Output Audit report and End Program  *
      *                                                               *
      *  Called by: Main Processing, *PSSR                            *
      *                                                               *
      *  Calls: SRRCFAU                                               *
      *                                                               *
      *****************************************************************
 
     C     SRAudit       BEGSR
 
      ** Open Audit Report, Do RCF processing & Print Header
 
     C                   OPEN      RE001512AU
     C                   EXSR      SRRCFAU
     C                   WRITE     HEADAU
 
      ** If there is a DB Error, Output the DB Error Information
 
     C                   IF        *INU7 = *ON AND *INU8 = *ON
     C                   WRITE     DBERROR
     C                   ELSE
 
      ** If no records read, Output "No Details" message
      ** else, write file control format
 
     C                   IF        RCOUNT = *ZEROS
     C                   WRITE     NODTLS
     C                   ELSE
     C                   WRITE     CONTROL
     C                   ENDIF
     C                   ENDIF
 
      ** End Program and Return
 
     C                   IF        %OPEN(RE001512P1)
     C                   WRITE     TRAILPY
     C                   CLOSE     RE001512P1
     C                   ENDIF
 
     C                   IF        %OPEN(RE001512AU)
     C                   WRITE     TRAILAU
     C                   CLOSE     RE001512AU
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRCFAU - Subroutine to register the AU Printer File via RCF *
      *                                                               *
      *  Called by: SRAudit                                           *
      *                                                               *
      *  Calls: ZSFILE                                                *
      *                                                               *
      *****************************************************************
 
     C     SRRCFAU       BEGSR
 
      ** Ensure Audit Spool File recorded by RCF
 
     C                   EVAL      PSFile = SFILEU
     C                   EVAL      PZSNum = SFNUMU
 
     C                   CALL      'ZSFILE'
     C                   PARM                    PSeq
     C                   PARM      *BLANKS       PEnty
     C                   PARM                    PSFile
     C                   PARM                    PZSNum
     C                   PARM      *BLANK        PZSErr
 
      ** If Error occurs during ZSFILE processing, then return to the
      ** Calling Program
 
     C                   IF        PZSErr = 'Y'
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
      * SRInit - Subroutine to do Program Initialisation              *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: AOBANKR0, AOSVALR0                                     *
      *                                                               *
      *****************************************************************
 
     C     SRInit        BEGSR
 
      ** Read in data area
 
     C     *DTAARA       DEFINE                  LDA
 
     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM  = 'RE001512'
     C                   EVAL      DBFILE = *BLANKS
     C                   EVAL      DBKEY  = *BLANKS
     C                   EVAL      DBTXT  = *BLANKS
     C                   EVAL      DBASE  = 0
     C                   OUT       LDA
 
      ** Access Bank details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*FIRST  '    POptn
     C     SDBANK        PARM      SDBANK        DSFDY
 
     C     PRtcd         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'SDBANKPD'
     C                   EVAL      DBKEY  =  '*FIRST'
     C                   EVAL      DBPGM  =  'AOBANKR0'
     C                   EVAL      DBASE  =  1
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Call Access Program for System Value - ABCPoisonMsgRetention
 
     C                   EVAL      P@OP01 = 'ABCPoisonMsgRetDays'
     C                   CALL      'AOSVALR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM                    P@OP01
     C                   PARM      *BLANKS       P@VL01
     C                   PARM                    P@OP02
     C                   PARM      *BLANKS       P@VL02
     C                   PARM                    P@OP03
     C                   PARM      *BLANKS       P@VL03
     C                   PARM                    P@OP04
     C                   PARM      *BLANKS       P@VL04
     C                   PARM                    P@OP05
     C                   PARM      *BLANKS       P@VL05
     C                   PARM                    P@OP06
     C                   PARM      *BLANKS       P@VL06
     C                   PARM                    P@OP07
     C                   PARM      *BLANKS       P@VL07
     C                   PARM                    P@OP08
     C                   PARM      *BLANKS       P@VL08
     C                   PARM                    P@OP09
     C                   PARM      *BLANKS       P@VL09
     C                   PARM                    P@OP10
     C                   PARM      *BLANKS       P@VL10
 
      ** Handle Database Error
 
     C                   IF        PRtCd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 2
     C                   EVAL      DBFILE = 'SDSVALPD'
     C                   EVAL      DBKEY = P@OP01
     C                   EVAL      DBPGM = 'AOSVALR0'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE
     C                   IF        P@VL01 <> *BLANKS
     C                   EVALR     WRetPrd = %TRIM(P@VL01)
     C                   ENDIF
     C                   MOVE      WRetPrd       WRetPrdN
     C     BJRDNB        SUB       WRetPrdN      WTranRetPrd
     C                   ENDIF
 
      ** Report Work fields
 
     C                   EVAL      OFLLN1 = *ZEROS
     C                   EVAL      WDifln = *ZEROS
     C                   EVAL      RCOUNT = *ZEROS
 
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
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
 
     C                   IF        WRun = *BLANKS
     C                   EVAL      WRun = 'Y'
     C                   DUMP
     C                   EXSR      SRAudit
     C                   ENDIF
 
     C                   EVAL      *INLR = *ON
 
     C                   ROLBK
     C                   RETURN
 
     C                   ENDSR
 
      *****************************************************************
