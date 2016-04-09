     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2012')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Check/update invalid PRTO and NDEC')                   *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  UT09008 - Check/update invalid PRTO and NDEC.                *
      *                                                               *
      *  Function:  This program checks if there is an uninitialised  *
      *  (I/C)      values for PRTO and NDEC of INVTPD. NDEC with     *
      *             zero values will be re-initialised as program     *
      *             cannot distinguish between '0' and *blanks        *
      *             among zoned decimal data. This happens even when  *
      *             FIXNBR was not specified in the creation          *
      *             parameters.                                       *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2012            *
      *                                                               *
      *  Called By : UTC9008                                          *
      *                                                               *
      *  Last Amend No. AR1076145          Date 22Jan13               *
      *  Prev Amend No. AR317764 *CREATE   Date 22Aug12               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR1076145 - Convert to PGMA - audit and update as one.       *
      *              Will convert bad data to 0 value                 *
      *  AR317764 - Unable to extract data from some fields of RUDWH  *
      *             library tables - Securities. Initialize PRTO and  *
      *             NDEC fields to zero. (Child: AR317765)            *
      *                                                               *
      *****************************************************************
      *
     FINVTPD    UF   E           K DISK    INFSR(*PSSR)
      ** Midas SE Investment types
      *
     FUT9008P1  O    E             PRINTER OFLIND(*IN05)
      ** Audit report of INVTPD records with error.
      *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database
      **                             error handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
      *
     D/COPY ZACPYSRC,STD_D_SPEC
      *
     D/COPY ZACPYSRC,STDDECLARE
      *
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in
      ** the PSDS. They have meaningful names, prefixed by 'PS'.
      *
     D/COPY ZACPYSRC,PSDS
      *
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** Data Structure for Bank details.
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
     D   RUNA                         7A   OVERLAY(BJMRDT)
      *
      ** First DS for access programs, Short Data Structure.
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** Data Structure to check for uninitialised fields.
      *
     D INVTDS        E DS                  EXTNAME(INVTPD)
     D   #PRTO                        3A   OVERLAY(PRTO)
     D   #NDEC                        1A   OVERLAY(NDEC)
      *
      ** Work variables.
      *
     D PRTCD           S              7A
     D POPTN           S              7A
     D @RUN            S              1A
      *
     D CTR             S              7S 0
     D CHNGE           S              7S 0
 
      *****************************************************************
      /TITLE Main Processing
      *****************************************************************
      *  P R O G R A M   S T A R T                                    *
      *****************************************************************
      *
      ** Perform Initialisation.
      *
     C                   EXSR      INIT
      *
      ** Perform Detail Processing.
      *
     C                   EXSR      MAIN
      *
      ** Output Audit Report and End Program.
      *
     C                   EXSR      WENDSR
      *
      *****************************************************************
      *  P R O G R A M   E N D                                        *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * INIT - Subroutine to do Program Initialisation.               *
      *                                                               *
      *****************************************************************
     C     INIT          BEGSR
      *
      ** Report Work fields.
      *
     C                   EVAL      CTR = 0
     C                   EVAL      CHNGE = 0
     C                   EVAL      *IN05 = '0'
     C                   EVAL      *IN71 = '0'
     C                   EVAL      *IN72 = '0'
     C                   EVAL      *IN98 = '0'
     C                   EVAL      #PRTO = *BLANKS
     C                   EVAL      #NDEC = *BLANKS
      *
      ** Print header.
      *
     C                   WRITE     PAGHDG
     C                   WRITE     DETAIL
      *
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      *                                                               *
      * MAIN - Main body.                                             *
      *                                                               *
      *****************************************************************
     C     MAIN          BEGSR
      *
      ** Read first record from File.
      *
     C                   READ      INVTPDF                                11
      *
      ** Check if PRTO and NDEC are numeric.
      *
     C                   IF        *IN11 = *OFF
     C                   EXSR      NUMCHK
     C                   ENDIF
      *
      ** Do Until End of File.
      *
     C                   DOW       *IN11 = '0'
      *
     C                   IF        *IN71 = '1'
     C                             or *IN72 = '1'
      *
      ** Print this record.
      *
     C                   EVAL      *IN33 = '1'
     C                   EVAL      SINAM = INAM
     C                   EVAL      SINVT = INVT
     C                   EVAL      SCCYI = CCYI
     C                   EVAL      SPROT = PROT
      *
     C                   IF        *IN71 = '1'
     C                   EVAL      SPRTO = '+++++++'
     C                   IF        *IN01 = '1'
     C                   EVAL      PRTO = 0
     C                   EVAL      SPRTO = '00.000'                                        AR1076145
     C                   ENDIF
     C                   ELSE
     C                   EVAL      SPRTO = %CHAR(PRTO)
     C                   ENDIF
      *
     C                   IF        *IN72 = '1'
     C                   EVAL      SNDEC = '+'
     C                   IF        *IN01 = '1'
     C                   EVAL      NDEC = 0
     C                   ENDIF
     C                   ELSE
     C                   EVAL      SNDEC = %CHAR(NDEC)
     C                   ENDIF
      *
     C                   EXSR      REPORT
      *
      ** Print current record.
      *
     C                   EVAL      *IN33 = '0'
     C                   EVAL      CTR = CTR + 1
      *
     C                   IF        *IN01 = '1'
     C                   EVAL      CHNGE = CHNGE + 1
     C                   ENDIF
      *
     C                   IF        *IN01 = '1'
     C                   UPDATE    INVTPDF
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   EVAL      #PRTO = *BLANKS
     C                   EVAL      #NDEC = *BLANKS
      *
      ** Read next record.
      *
     C                   READ      INVTPDF                                11
      *
      ** Check if PRTO and NDEC are numeric.
      *
     C                   IF        *IN11 = *OFF
     C                   EXSR      NUMCHK
     C                   ENDIF
      *
      ** End of Do Until End of Valid Records.
      *
     C                   ENDDO
      *
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      *                                                               *
      * NUMCHK - Checks if Entry is Numeric.                          *
      *                                                               *
      *****************************************************************
     C     NUMCHK        BEGSR
      *
     C                   TESTN                   #PRTO                    71
     C                   TESTN                   #NDEC                    72
      *
     C                   IF        PRTO = 0
     C                   EVAL      *IN71 = *ON
     C                   ENDIF
      *
     C                   IF        NDEC = 0
     C                   EVAL      *IN72 = *ON
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      *                                                               *
      * REPORT - Process Report Lines.                                *
      *                                                               *
      *****************************************************************
     C     REPORT        BEGSR
      *
      ** Check that sufficient lines remain for the Format. If not,
      ** write out the Main Headings on a new page.
      *
     C                   IF        *IN05 = '1'
     C                   WRITE     PAGHDG
     C                   WRITE     DETAIL
     C                   EVAL      *IN05 = '0'
     C                   ENDIF
      *
      ** Write out Detail Record.
      *
     C                   WRITE     DET2
      *
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      *                                                               *
      * WENDSR - Subroutine to Write End of Report.                   *
      *                                                               *
      *****************************************************************
     C     WENDSR        BEGSR
      *
      ** Check that sufficient lines remain for the Format. If not,
      ** write out the Main Headings on a new page.
      *
     C                   IF        *IN05 = '1'
     C                   WRITE     PAGHDG
     C                   WRITE     TOTAL
     C                   ENDIF
      *
     C                   IF        CTR = 0
     C                   EVAL      *IN04 = '1'
     C                   ENDIF
      *
      ** End Program and Return.
      *
     C                   WRITE     TOTAL
     C                   WRITE     END
      *
     C                   EVAL      *INLR = '1'
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine.                      *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
      *
     C******ENTRY        PLIST                                                             AR1076145
     C**********         PARM                    PMODE             1                       AR1076145
      *
      ** Set up copyright parameter.
      *
     C                   MOVEA     CPY@          CPY2@            80
      *
      ** Move program name into *LDA field.
      *
     C******LOCK         IN        LDA                                                     AR1076145
     C**********         MOVEL     'UT09007'     DBPGM                                     AR1076145
     C**********         OUT       LDA                                                     AR1076145
      *
     C**********         IF        PMODE = 'U'                                             AR1076145
     C**********                   or PMODE = 'u'                                          AR1076145
     C                   EVAL      *IN01 = '1'
     C**********         ELSE                                                              AR1076145
     C**********         EVAL      *IN01 = '0'                                             AR1076145
     C**********         ENDIF                                                             AR1076145
      *
      ** Access Bank Details.
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST  '    POPTN
     C     SDBANK        PARM      SDBANK        DSFDY
      *
     C                   IF        PRTCD <> *BLANK
     C                   MOVEL     POPTN         DBKEY
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   Z-ADD     1             DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine.                     *
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
      *
     C                   DUMP
      *
     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'
     C                   CALL      'DBERRCTL'
     C                   ENDIF
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
      *
     C                   IF        *IN05 = '1'
     C                   WRITE     PAGHDG
     C                   WRITE     DETAIL
     C                   EVAL      *IN05 = '0'
     C                   ENDIF
      *
     C                   WRITE     ERRORAU
      *
     C                   RETURN
      *
     C                   ENDSR
      *
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2012
