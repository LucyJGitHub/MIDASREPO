     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2013')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas UT Recreate T_DLAAQD Records Based on STRANF')   *
      *****************************************************************
      *                                                               *
      *  Midas - Dealing Module                                       *
      *                                                               *
      *  UT019950 - Utility to Recreate T_DLAAQD Records Based on     *
      *             STRANF file                                       *
      *                                                               *
      *  Function:  This program writes records to T_DLAAQD table     *
      *  (I/C)      with Transaction Number and Front of Office ID    *
      *             based on STRANF file records                      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2013            *
      *                                                               *
      *  Called By : UTC019950                                        *
      *                                                               *
      *  Last Amend No. MD019950 *CREATE   Date 10Apr13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD019950 - Transaction Number already exists encountered     *
      *             in SOAP                                           *
      *                                                               *
      *****************************************************************
      *
     FSTRANFL0  IF   E           K DISK    INFSR(*PSSR)
      ** Midas DL STRANF Transactions
      *
     FT_DLAAQD  O    E           K DISK    INFSR(*PSSR)
     F                                     RENAME(T_DLAAQD:DLAAQD0)
      ** Midas DL Deal Adjustment to Accrued Interest
      *
     FUT019950P1O    E             PRINTER OFLIND(*IN05)
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
      ** First DS for access programs, Short Data Structure
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** Work variables.
      *
     D PRTCD           S              7A
     D POPTN           S              7A
     D @RUN            S              1A
      *
     D R0CNTR          S              7S 0
 
      *****************************************************************
      /TITLE Main Processing
      *****************************************************************
      *  P R O G R A M   S T A R T                                    *
      *****************************************************************
      *
      ** Perform detail processing
      *
     C                   EXSR      SRMain
      *
      ** Output report file and end program
      *
     C                   EXSR      SREnd
      *
      *****************************************************************
      *  P R O G R A M   E N D                                        *
      *****************************************************************
      /SPACE 5
      *****************************************************************
      *                                                               *
      * SRMain - Main Processing                                      *
      *                                                               *
      *****************************************************************
     C     SRMain        BEGSR
      *
      ** Read first record from File
      *
     C                   READ      STRANFL0                               11
      *
     C                   DOW       *IN11 = '0' AND FLTRNN <> *BLANKS
      *
      ** Write Transaction ID and Front Office ID to T_DLAAQD
      *
     C                   EVAL      TRNN  = FLTRNN
     C                   EVAL      FRNT  = FLFRNT
     C                   EVAL      R0CNTR =  R0CNTR + 1
     C                   WRITE     DLAAQD0
      *
     C                   EXSR      SRPrint
      *
      ** Read next record
      *
     C                   READ      STRANFL0                               11
     C                   ENDDO
      *
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      *                                                               *
      * SRPrint - Process Report Lines                                *
      *                                                               *
      *****************************************************************
     C     SRPrint       BEGSR
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
      ** Write out detail record
      *
     C                   EVAL      R0TRNN = FLTRNN
     C                   EVAL      R0FRNT = FLFRNT
     C                   WRITE     DET2
      *
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      *                                                               *
      * SREnd - Subroutine to Write End of Report                     *
      *                                                               *
      *****************************************************************
     C     SREnd         BEGSR
      *
      ** Check that sufficient lines remain for the Format. If not,
      ** write out the Main Headings on a new page.
      *
     C                   IF        *IN05 = '1'
     C                   WRITE     PAGHDG
     C                   WRITE     TOTAL
     C                   ENDIF
      *
     C                   IF        R0CNTR = 0
     C                   EVAL      *IN04 = '1'
     C                   ENDIF
      *
      ** End program and return
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
      ** Report work fields
      *
     C                   EVAL      R0CNTR = 0
     C                   EVAL      *IN05 = '0'
      *
      ** Access bank details
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
      ** Print header
      *
     C                   WRITE     PAGHDG
     C                   WRITE     DETAIL
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
(c) Misys International Banking Systems Ltd. 2013
