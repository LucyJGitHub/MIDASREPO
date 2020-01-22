     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2019')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Manual Diary Details List Report')            *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LE000352P - Midas LE Manual Diary Events Report              *
      *                                                               *
      *  Function:  This is a new program to print Manual Diary       *
      *             Events for Lending                                *
      *                                                               *
      *  (c) Finastra International Limited 2019                      *
      *                                                               *
      *  Last Amend No. CLE070   *CREATE   Date 19Jun19               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CLE070 - Manual Diary                                        *
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
      *  SrOpenP1  - Open printer file LE000352P1                     *
      *  SrCloseP1 - Close printer file LE000352P1                    *
      *  SrDate2   - Convert Midas Date to Report Date                *
      *  *Pssr     - Error Handling Subroutine                        *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+                     *
      ** ¦ F-specs                              ¦                     *
      ** ¦ =======                              ¦                     *
      ** +--------------------------------------+                     *

      ** RTV:
     FLEDIAML1  IF   E           K DISK

      ** RPT:
     FLE000352P1O    E             PRINTER INFDS(Spool1)
     F                                     INFSR(*Pssr)
     F                                     USROPN

      ** RPT:
     FLE000352AUO    E             PRINTER INFDS(SpoolU)
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

      ** Second DS for Aacces Programs, Long Data Structure
     D DSSDY         E DS                  EXTNAME(DSSDY)

      ** Bank Details Accessed via Access Program
     D SDBANK        E DS                  EXTNAME(SDBANKPD)

      ** Customer Details Accessed via Access Program
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)

      ** File Information Data Structure for printer file LE000352P1
     D Spool1          DS
     D  Sfile1                83     92
     D  Sfnum1               123    124B 0
     D  Oflln1               188    189B 0
     D  Prtln1               367    368B 0

      ** File Information Data Structure for printer file LE000352AU
     D SpoolU          DS
     D  Sfileu                83     92
     D  Sfnumu               123    124B 0

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

     D WrSydt          S              5  0
     D WrInsert        S              5  0
     D WrDelete        S              5  0
     D WrAmend         S              5  0
     D WrTotal         S              5  0
     D WRund           S              5  0
     D WRun            S              1
     D POptn           S              7
     D PRtcd           S              7
     D PKey2           S             10A
     D PKySt           S              7A

      ** ZSFILE Parameters
     D PMode           S              1
     D PSeq            S              5
     D Penty           S              3
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
      *          Controls Set-up of LE000352P1 Details                *
      *          Outputs LE000352P1 Details                           *
      *                                                               *
      * Called by: Main Routine                                       *
      *                                                               *
      * Calls    : SrPrint                                            *
      *                                                               *
      *****************************************************************
     C     SrMain        BEGSR

     C                   EVAL      WrSydt = 0
     C     *LOVAL        SETLL     LEDIAML1
     C                   READ      LEDIAML1

      ** Do until end of Loan Diary
     C                   DOW       NOT %EOF(LEDIAML1)

      ** Read through Loan Diary records Audit Report
     C                   IF        (PMode = 'A' AND LCD = WRUND)
     C                             OR PMode = 'L'
     C                             OR PMode = ' '

      ** If DB error has occured no more processing in this routine
     C                   IF        *IN80 = *ON
     C                   LEAVE
     C                   ENDIF

      ** If record read print header and details
     C                   EXSR      SrPrint

      ** Increment count of records output

     C                   SELECT
     C                   WHEN      CHTP = 'I'
     C                   ADD       1             WrInsert
     C                   WHEN      CHTP = 'D'
     C                   ADD       1             WrDelete
     C                   WHEN      CHTP = 'A'
     C                   ADD       1             WrAmend
     C                   ENDSL

     C                   ADD       1             WrTotal
     C                   ENDIF

     C                   READ      LEDIAML1
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

      ** Write detail record to LE000352P1
     C                   WRITE     LE000352R1

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
     C                   WRITE     LE000352R0

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrCloseP1 - Close printer file LE000352P1                     *
      *                                                               *
      * Called by: SrInit                                             *
      *                                                               *
      * Calls    : None                                               *
      *                                                               *
      *****************************************************************
     C     SrCloseP1     BEGSR

     C                   IF        %OPEN (LE000352P1)
     C                   CLOSE     LE000352P1
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrOpenP1 - Open printer file LE000352P1                       *
      *                                                               *
      * Called by: SrInit                                             *
      *                                                               *
      * Calls    : ZSFILE                                             *
      *                                                               *
      *****************************************************************
     C     SrOpenP1      BEGSR

      ** Open printer file and indicate that there is atleast one
      ** detail to report; ensure report spool file recorded by RCF

     C                   IF        NOT %OPEN (LE000352P1)
     C                   OPEN      LE000352P1

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

     C                   EVAL      PKey2 = CNUM
     C                   CALL      'AOCUSTR0'
     C                   PARM      *Blanks       PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM                    PKey2
     C                   PARM                    PKySt
     C     SDCUST        PARM      SDCUST        DSSDY

     C                   EVAL      RRCUSN = BBCUST
     C                   EVAL      RRCUST = BBCRNM
      *
      *    CONVERT DATES TO ALPHA FORMAT.
     C                   EVAL      ZDAYNO = STTD
     C                   EXSR      SrDate2
     C                   MOVE      ZADATE        RRSTRT
      *
     C                   EVAL      ZDAYNO = ACYD
     C                   EXSR      SrDate2
     C                   MOVE      ZADATE        RRACTD
      *
     C                   EVAL      ZDAYNO = ENDD
     C                   EXSR      SrDate2
     C                   MOVE      ZADATE        RRENDT
      *
     C                   MOVE      DYRF          RRDIAR
     C                   EVAL      RRFREQ = ACYF
     C                   MOVE      ACDY          RRDAYN
     C                   MOVE      NTCD          RRNTCD
     C                   MOVE      DRYT          RRDTYP
     C                   MOVE      DOCC          RRDOCC
     C                   EVAL      RRLNRF = LNRF
     C                   EVAL      RRNAR1 = NLN01
     C                   EVAL      RRNAR2 = NLN02
     C                   EVAL      RRACTN = CHTP
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
     C                   PARM                    PMode
     C                   PARM                    PSeq
     C                   PARM                    PEnty

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
     C                   EVAL      WRUND  = BJRDNB

      ** set number of records read to Zero

     C                   Z-ADD     0             WrTotal
     C                   Z-ADD     0             WrInsert
     C                   Z-ADD     0             WrDelete
     C                   Z-ADD     0             WrAmend

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

     C                   WRITE     LE000352R3
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
     C                   Z-ADD     WrTotal       RRTOTR
     C                   Z-ADD     WrInsert      RRINSR
     C                   Z-ADD     WrDelete      RRDELR
     C                   Z-ADD     WrAmend       RRAMNR

      ** Print standard totals report
     C                   EVAL      *IN54 = *ON
     C                   IF        WrInsert = 0
     C                             AND WrDelete = 0
     C                             AND WrAmend = 0
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
     C                   EVAL      DBPGM = 'LE000352'

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
(c) Finastra International Limited 2019
