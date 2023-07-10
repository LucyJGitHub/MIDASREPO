     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2023')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas LE Summary of Generated Entries from REEODPF')   *
      *****************************************************************
      *                                                               *
      *  Midas - Lending Module                                       *
      *                                                               *
      *  LE000038 - Summary of Generated Entries from REEODPF         *
      *                                                               *
      *  (c) Finastra International Limited 2023                      *
      *                                                               *
      *  Last Amend No. MD021383A *CREATE  Date 16Jun23               *
      *  Prev Amend No. xxxxxxxx           Date ddMmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD021383A - Credit Lines (CLE025) Shadow Posting Correction. *
      *            - MD061267 - Credit Lines (CLE025) fixes           *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    U7 - Database error                                        *
      *    U8 - Database error                                        *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Subroutine index                                             *
      *                                                               *
      * *INZSR  - Initialise                                          *
      * SRWrite - Output the record to RESEODPD                       *
      * SRSave  - Save the details of the current amount and reset    *
      *           totals                                              *
      * *PSSR   - Error processing                                    *
      *                                                               *
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

      ** Midas RE Gen. Entries for RE Keyed on Acct & Clr Bal Date
     FRESEODPL0 IF   E           K DISK    INFSR(*PSSR)

      ** Midas RE Summary of Generated Entries from REEODPF
     FRESEODPD  O    E             DISK    INFSR(*PSSR)

      *****************************************************************
      /EJECT
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+

      **---------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA
      ** layout and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      ** Data Area giving Installation Control Details
      **---------------------------------------------------------------

      **---------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in
      ** the Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      ** Program Status Data Structure
      **---------------------------------------------------------------

      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+

      *****************************************************************
      /EJECT
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

      ** Short data structures for Access Objects
     D DSFDY         E DS                  EXTNAME(DSFDY)

      ** Previous General Entries Details
     D WPrevEOD      E DS                  EXTNAME(REEODPF)
     D                                     PREFIX(Pr)

     ** +--------------------------------------+
     ** ¦ Declared variables                   ¦
     ** ¦ ==================                   ¦
     ** +--------------------------------------+

     D WTotAmtDR       S             13  0
     D WTotAmtCR       S             13  0
     D WTotAmt         S             13  0

      *****************************************************************
      /EJECT
      *****************************************************************

      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ Initial processing is performed automatically: the *INZSR  ¦
      ** ¦ is executed at program activation.                         ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+

      *****************************************************************
      ** MAIN PROCEDURE                                               *
      *****************************************************************
      *
      ** Read through the File
      *
     C     *LOVAL        SETLL     RESEODPL0
     C                   READ      RESEODPL0
      *
      ** Save Details for output later
      *
     C                   EVAL      PrCnum = CNUM
     C                   EVAL      PrCCY  = CCY
     C                   EVAL      PrACOD = ACOD
     C                   EVAL      PrACSQ = ACSQ
     C                   EVAL      PrBRCA = BRCA
     C                   EVAL      PrACNO = ACNO
     C                   EVAL      PrPSTD = PSTD
      *
     C                   DOW       NOT %EOF(RESEODPL0)
      *
      ** Accumulate the posting amount depending on the DRCR Indicator
      *
     C                   IF        PrCNUM = CNUM and
     C                             PrCCY  = CCY  and
     C                             PrACOD = ACOD and
     C                             PrACSQ = ACSQ and
     C                             PrBRCA = BRCA and
     C                             PrPSTD = PSTD
      *
     C                   IF        DRCR = 0
     C                   EVAL      WTotAmtDR = WTotAmtDR + PSTA
     C                   ELSE
     C                   EVAL      WTotAmtCR = WTotAmtCR + PSTA
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** If Account or posting date has changed, output the record
      *
     C                   IF        PrCNUM <> CNUM or
     C                             PrCCY  <> CCY  or
     C                             PrACOD <> ACOD or
     C                             PrACSQ <> ACSQ or
     C                             PrBRCA <> BRCA or
     C                             PrPSTD <> PSTD
      *
     C                   EXSR      SRWrite
     C                   EXSR      SRSave
      *
     C                   ENDIF
      *
      ** Read next record
      *
     C                   READ      RESEODPL0
     C                   ENDDO
      *
      ** Output the last record
      *
     C                   IF        PrPSTD <> *ZEROS
      *
     C                   EXSR      SRWrite
      *
     C                   ENDIF
      *
      ** End of Program
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program initialisation routine                       *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
      *
      ** Initialise Work Fields
      *
     C                   EVAL      WTotAmtDR = *ZEROS
     C                   EVAL      WTotAmtCR = *ZEROS
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRWrite - Output the record to RESEODPD                       *
      *                                                               *
      *****************************************************************
     C     SRWrite       BEGSR
      *
     C                   EVAL      R1CNUM = PrCNUM
     C                   EVAL      R1CCY  = PrCCY
     C                   EVAL      R1ACOD = PrACOD
     C                   EVAL      R1ACSQ = PrACSQ
     C                   EVAL      R1BRCA = PrBRCA
     C                   EVAL      R1ACNO = PrACNO
     C                   EVAL      R1VDAT = PrPSTD
      *
     C                   EVAL      WTotAmt = WTotAmtDr - WTotAmtCR
      *
     C                   IF        WTotAmt >= 0
     C                   EVAL      R1DRCR = 0
     C                   ELSE
     C                   EVAL      WTotAmt = 0 - WTotAmt
     C                   EVAL      R1DRCR = 1
     C                   ENDIF
      *
     C                   EVAL      R1PSTA = WTotAmt
      *
     C                   WRITE     RESEODD0
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRSave - Save the details of the current amount and reset     *
      *          totals                                               *
      *                                                               *
      *****************************************************************
     C     SRSave        BEGSR
      *
     C                   EVAL      PrCnum = CNUM
     C                   EVAL      PrCCY  = CCY
     C                   EVAL      PrACOD = ACOD
     C                   EVAL      PrACSQ = ACSQ
     C                   EVAL      PrBRCA = BRCA
     C                   EVAL      PrACNO = ACNO
     C                   EVAL      PrPSTD = PSTD
      *
     C                   IF        DRCR = 0
     C                   EVAL      WTotAmtDR = PSTA
     C                   EVAL      WTotAmtCR = *ZEROS
     C                   ELSE
     C                   EVAL      WTotAmtDR = *ZEROS
     C                   EVAL      WTotAmtCR = PSTA
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *                                                               *
      * Called by: (**calling routines**)                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
      *
     C                   IF        RunBefore <> 'Y'
     C                   EVAL      RunBefore = 'Y'
     C                   DUMP
     C                   ENDIF
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
      *
     C                   RETURN
      *
     C                   ENDSR
