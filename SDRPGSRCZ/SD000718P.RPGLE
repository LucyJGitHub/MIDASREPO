     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2014')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD FATCA Due Diligence Action Report')           *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD000718P - Midas SD FATCA Due Diligence Action Report       *
      *                                                               *
      *  Function:  This is a new program to print Due Dillence Action*
      *             Report for both Customer and Non-Account Holder   *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2014            *
      *                                                               *
      *  Last Amend No. MD042946           Date 01Dec16               *
      *  Prev Amend No. CGL154  *CREATE    Date 13Oct14               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD042946 - Input Cycle Due Diligence Action Report is not    *
      *             generated (Recompile)                             *
      *  CGL154 - FATCA Reporting                                     *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    80  - Data Base Error Indicator                            *
      *  U7+U8 - Data Base Error (job switch)                         *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E   I N D E X                              *
      *                                                               *
      *  SrMain    - Main Processing                                  *
      *  SrInit    - Initial Processing                               *
      *  SrTerm    - Termination Processing                           *
      *  SrFcp     - Produces Standard Totals Report                  *
      *  SrPrint   - Prints header and details of report              *
      *  SrHeader  - Prints header details                            *
      *  SrDetail  - Prints detail                                    *
      *  SrOpenP1  - Open printer file SD000718P1                     *
      *  SrCloseP1 - Close printer file SD000718P1                    *
      *  SrDate2   - Convert Midas Date to Report Date                *
      *  *Pssr     - Error Handling Subroutine                        *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+                     *
      ** ¦ F-specs                              ¦                     *
      ** ¦ =======                              ¦                     *
      ** +--------------------------------------+                     *
 
      ** RTV: Midas SD Due Diligence Action Driving file
     FSDDDACL1  IF   E           K DISK
 
      ** RPT: FATCA Due Diligence Report Control
     FSD000718P1O    E             PRINTER INFDS(Spool1)
     F                                     INFSR(*Pssr)
     F                                     USROPN
 
      ** RPT: FATCA Due Diligence Report Audit
     FSD000718AUO    E             PRINTER INFDS(SpoolU)
     F                                     INFSR(*Pssr)
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      *
      **------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      ** Data Area giving Installation Control Details
 
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      ** Program Status Data Structure
 
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
 
      ** First DS for Access Programs, Short Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Bank Details Accessed via Access Program
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** File Information Data Structure for printer file SD000718P1
     D Spool1          DS
     D  Sfile1                83     92
     D  Sfnum1               123    124B 0
     D  Oflln1               188    189B 0
     D  Prtln1               367    368B 0
 
      ** File Information Data Structure for printer file SD000718AU
     D SpoolU          DS
     D  Sfileu                83     92
     D  Sfnumu               123    124B 0
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D WrSydt          S              5  0
     D WrTcus          S              5  0
     D WrTnah          S              5  0
     D WRun            S              1
     D POptn           S              7
     D PRtcd           S              7
 
      ** ZSFILE Parameters
     D PSeq            S              5
     D ZEnty           S              3
     D ZsErr           S              1
     D ZsNum           S              6  0
 
      ** ZDATE2 Parameters
     D ZDayNo          S              5  0
     D ZDate           S              6  0
     D ZaDate          S              7
 
      ** Fields used to check that sufficient lines remain for the
      ** printer file record format
     D Difln1          S              2  0
     D Rqdln1          S              2  0
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      *********************************************************************
      *                  M A I N  P R O C E S S I N G                     *
      *********************************************************************
 
      ** Initial Processing
     C                   EXSR      SrInit
 
      ** Main Processing
     C                   EXSR      SrMain
 
      ** Termination Processing
     C                   EXSR      SrTerm
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrMain - Main Processing                                      *
      *          Controls Set-up of SD000718P1 Details                *
      *          Outputs SD000718P1 Details                           *
      *                                                               *
      * Called by: Main Routine                                       *
      *                                                               *
      * Calls    : SrPrint                                            *
      *                                                               *
      *****************************************************************
     C     SrMain        BEGSR
 
     C                   EVAL      WrSydt = 0
     C     *LOVAL        SETLL     SDDDACL1
 
      ** Do until end of Due Diligence Action Driving File
     C                   DOW       NOT %EOF(SDDDACL1)
 
      ** Read through soon to Expire Customers or Non-account Holders
     C                   READ      SDDDACL1
     C                   IF        NOT %EOF(SDDDACL1)
 
      ** If change of Due Diligence Date, write logical break space
     C                   IF        FDSYDT <> WrSydt
     C                             AND WrSydt <> 0
 
      **  Check that sufficient lines remain for the Format
     C                   Eval      Rqdln1 = 1
     C                   Eval      Difln1 = Oflln1 - Prtln1
 
     C                   IF        DifLn1 > Rqdln1
     C                   WRITE     SD000718R2
     C                   ENDIF
 
     C                   ENDIF
 
      ** If DB error has occured no more processing in this routine
     C                   IF        *IN80 = *ON
     C                   LEAVE
     C                   ENDIF
 
      ** If record read print header and details
     C                   EXSR      SrPrint
 
      ** Increment count of records output
     C                   IF        FDFILE = 'CUST'
     C                   ADD       1             WrTcus
     C                   ELSE
     C                   ADD       1             WrTnah
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrPrint  - Prints header and details of report                *
      *                                                               *
      * Called by: SrMain                                             *
      *                                                               *
      * Calls    : SrHeader, SrDetail                                 *
      *                                                               *
      *****************************************************************
     C     SrPrint       BEGSR
 
      ** Prepare detail data for printing
     C                   EXSR      SrDetail
 
      **  Check that sufficient lines remain for the Format. If not,
      **  write out the Main Headings on a new page.
     C                   Eval      Rqdln1 = 1
     C                   Eval      Difln1 = Oflln1 - Prtln1
 
     C                   IF        DifLn1 <= Rqdln1
     C                   EXSR      SrHeader
     C                   ENDIF
 
      ** Write detail record to SD000718P1
     C                   WRITE     SD000718R1
 
      ** Save Due Diligence Date for comaprison to next read
     C                   EVAL      WrSydt = FDSYDT
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrHeader - Writes header details                              *
      *                                                               *
      * Called by: SrPrint                                            *
      *                                                               *
      * Calls    : None                                               *
      *                                                               *
      *****************************************************************
     C     SrHeader      BEGSR
 
      ** Write header
     C                   WRITE     SD000718R0
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrCloseP1 - Close printer file SD000718P1                     *
      *                                                               *
      * Called by: SrInit                                             *
      *                                                               *
      * Calls    : None                                               *
      *                                                               *
      *****************************************************************
     C     SrCloseP1     BEGSR
 
     C                   IF        %OPEN (SD000718P1)
     C                   CLOSE     SD000718P1
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrOpenP1 - Open printer file SD000718P1                       *
      *                                                               *
      * Called by: SrInit                                             *
      *                                                               *
      * Calls    : ZSFILE                                             *
      *                                                               *
      *****************************************************************
     C     SrOpenP1      BEGSR
 
      ** Open printer file and indicate that there is atleast one
      ** detail to report; ensure report spool file recorded by RCF
 
     C                   IF        NOT %OPEN (SD000718P1)
     C                   OPEN      SD000718P1
 
      **  Force header format printing
     C                   Eval      Prtln1 =  Oflln1
 
     C                   Z-ADD     Sfnum1        ZsNum
     C                   CALL      'ZSFILE'
     C                   PARM                    PSeq
     C                   PARM      *BLANKS       ZEnty
     C                   PARM                    SFile1
     C                   PARM                    ZsNum
     C                   PARM                    ZsErr
 
      ** Error during ZSFILE processing, return to calling program
 
     C                   IF        ZsErr = 'Y'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrDetail - Prepare Details for Printing                       *
      *                                                               *
      * Called by: SrMain - Main Processing                           *
      *                                                               *
      * Calls    : SrDate2                                            *
      *                                                               *
      *****************************************************************
     C     SrDetail      BEGSR
 
      * Set Report Details
 
     C                   EVAL      ZDayNo = FDSYDT
     C                   EXSR      SrDate2
     C                   EVAL      RRSYDT = ZADATE
 
     C                   EVAL      RRCUST = FDCUST
     C                   EVAL      RRCRNM = FDCRNM
     C                   EVAL      RRHVAC = FDHVAC
     C                   EVAL      RRCSTY = FDCSTY
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrDate2  - Convert Midas Date to Report Date                  *
      *                                                               *
      * Called by: SrDetail                                           *
      *                                                               *
      * Calls    : ZDATE2                                             *
      *                                                               *
      *****************************************************************
     C     SrDate2       BEGSR
 
     C                   CALLB     'ZDATE2'
     C                   PARM                    ZDayNo
     C                   PARM                    BJDFIN
     C                   PARM                    ZDate
     C                   PARM                    ZaDate
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrInit   - Initial processing                                 *
      *                                                               *
      * Called by: Main Routine                                       *
      *                                                               *
      * Calls    : *Pssr, SrHeader, SrOpenP1, SrCloseP1               *
      *                                                               *
      *****************************************************************
     C     SrInit        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    PSeq
 
      ** Access bank details
 
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*MSG   '     PRtcd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** If access program fails call SR. *Pssr
 
     C                   IF        PRtcd <> *BLANK
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBKEY  = '*FIRST'
     C                   EVAL      DBASE  = 001
     C                   OUT       LDA
     C                   EXSR      *Pssr
     C                   ENDIF
 
      ** if fails goto END
 
     C                   IF        *IN80 = *ON
     C                   GOTO      Iend
     C                   ENDIF
 
      ** load printer file fields with date and title
 
     C                   EVAL      RRTITL = BJURPT
     C                   EVAL      RRRUNA = BJMRDT
 
      ** set number of records read to Zero
 
     C                   Z-ADD     0             WrTcus
     C                   Z-ADD     0             WrTnah
 
     C                   EXSR      SrCloseP1
     C                   EXSR      SrOpenP1
     C                   EXSR      SrHeader
 
     C     Iend          ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrTerm   - Termination processing                             *
      *                                                               *
      * Called by: Main Routine                                       *
      *                                                               *
      * Calls    : SrFcp                                              *
      *                                                               *
      *****************************************************************
     C     SrTerm        BEGSR
 
      ** If database error has occured, output total report headings;
      ** print error message and exit program.
 
     C                   IF        *IN80 = *ON
     C                   WRITE     CONTROL
     C                   WRITE     DBERROR
     C                   GOTO      Tend
     C                   ENDIF
 
      ** Produce standard totals report
 
     C                   EXSR      SrFcp
 
      ** if a database error has occured, bypass further processing
 
     C     *INU7         CABEQ     *ON           TEND
 
      ** prints 'END OF REPORT' if *IN54 ON
     C                   IF        *IN54 = *ON
 
      **  Check that sufficient lines remain for the Format. If not,
      **  write out the Main Headings on a new page.
     C                   Eval      Rqdln1 = 3
     C                   Eval      Difln1 = Oflln1 - Prtln1
 
     C                   IF        DifLn1 <= Rqdln1
     C                   EXSR      SrHeader
     C                   ENDIF
 
     C                   WRITE     SD000718R3
     C                   ENDIF
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C     Tend          ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrFcp - Produces Standard Totals Report                       *
      *                                                               *
      * Called by: SrTerm                                             *
      *                                                               *
      * Calls    : None                                               *
      *                                                               *
      *****************************************************************
     C     SrFcp         BEGSR
 
      ** Set-up calculated number of records fields
     C                   Z-ADD     WrTcus        RRTCUS
     C                   Z-ADD     WrTnah        RRTNAH
 
      ** Print standard totals report
     C                   EVAL      *IN54 = *ON
     C                   IF        WrTcus = 0
     C                             AND WrTnah = 0
     C                   EVAL      *IN54 = *OFF
     C                   ENDIF
     C                   WRITE     CONTROL
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *Pssr    - Error handling subroutine                          *
      *            Executes whenever field or program exception       *
      *            error occurs                                       *
      *                                                               *
      * Called by: SrInit                                             *
      *                                                               *
      * Calls    : None                                               *
      *                                                               *
      *****************************************************************
     C     *Pssr         BEGSR
 
     C                   IF        WRun  = *BLANK
     C                   EVAL      WRun = 'Y'
     C                   EVAL      DBPGM = 'SD000718'
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
 
      ** set on database error indicator and dump
 
     C                   EVAL      *IN80 = *ON
     C                   DUMP
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
** CPY@
(c) Misys International Banking Systems Ltd. 2014
