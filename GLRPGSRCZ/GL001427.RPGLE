     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL MT94x Postings Drop')                         *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GL001427 - Midas GL MT94x Postings Drop.                     *
      *                                                               *
      *  Function:  This module deletes the postings.                 *
      *                                                               *
      *             For real posting (RECI = 'P'), the process        *
      *             deletes it when the posting has been processed    *
      *             (MGPORC = 'Y'), and, the value date is less than  *
      *             the next working day.                             *
      *                                                               *
      *             For shadow postings, as the processing extracts   *
      *             the events who will be posted today, and, it      *
      *             could send the shadow and the real posting to     *
      *             destination (the shadow is considered as          *
      *             'expected' and the real as 'real'), all shadow    *
      *             postings could be deleted.                        *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. 223783             Date 28May12               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 AR549926           Date 19Aug14               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 216937             Date 28Apr03               *
      *                 CRE008             Date 31May02               *
      *                 CGL013  *CREATE    Date 31Apr02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  223783 - Applied for AR973615.(Child: AR973617) (Recompile)  *
      *  MD046248 - Finastra Rebranding                               *
      *  AR549926 - GLPOSTPD and MGX950PD tables have a total size    *
      *             of about 1.4GB. These tables hold  records printed*
      *             on the MT9xx SWIFT messages. Amended program to   *
      *             delete postings in GLPOSTPD file that belong to a *
      *             Closed or Non-existing Retail Account.            *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  216937 - If GA account, include source account (recompile)   *
      *  CRE008 - Cash Management  (Recompile Only)                   *
      *  CGL013 - MT94x Messages Generation                           *
      *                                                               *
      *****************************************************************

     FGLPOSTL0  UF   E           K DISK                   INFSR(*PSSR)
      ** Midas GL Postings for MT94x Messages.
     FACCNTL0   IF   E           K DISK                   INFSR(*PSSR)                      AR549926
     F                                     PREFIX(X_)                                       AR549926
      *                                                                                     AR549926
      ** Account Maintenance File                                                           AR549926
      *                                                                                     AR549926

      *****************************************************************
      *                                                               *
      * Use of Indicators                                             *
      *                                                               *
      * Database Access Indicators                                    *
      *                                                               *
      * 27 - Access GL Postings for MT94x Messages.                   *
      *                                                               *
      * Database Error Indicators                                     *
      *                                                               *
      * U7 - Abnormal Completion                                      *
      * U8 - File Out of Balance                                      *
      * U7 + U8 - Database Error                                      *
      *                                                               *
      * Other Indicators                                              *
      *                                                               *
      * 99 - Multi-purpose                                            *
      *                                                               *
      *****************************************************************

      ** Automatically included D-specs
      ** ==============================

      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)

     D/COPY ZACPYSRC,STD_D_SPEC

      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.

     D/COPY ZACPYSRC,PSDS

      ** Manually included D-specs
      ** =========================

      ** Named constants
      ** ---------------

      ** Arrays and Data Structures
      ** --------------------------

     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      **  Data Structure for Bank Details.

     D DSSDY         E DS                  EXTNAME(DSSDY)
      **  First DS for access programs, long data structure.

     D DSFDY         E DS                  EXTNAME(DSFDY)
      **  Second DS for access programs, short data structure.

      ** Declared variables
      ** ------------------

     D P@RTCD          S              7A                                        Return Code
     D P@OPTN          S              7A                                        Option

      ** Input Specs
      ** -----------

      *------------------------------------------------------------------------*
      ** C Spec. Declaratives
      ** ====================

      *========================================================================*
      *              M  A  I  N     P  R  O  C  E  S  S  I  N  G               *
      *========================================================================*

      ** Init processing uses the standard *INZSR subroutine

      ** Read each record of the file.

     C     *LOVAL        SETLL     GLPOSTL0
     C                   READ      GLPOSTL0                               27

     C                   DOW       NOT *IN27

     C                   SELECT

      ** For real posting (RECI = 'P'), the process deletes it when the posting has been
      ** processed (MGPORC = 'Y'), And, the value date is less than the next working day.

     C                   WHEN      RECI = 'P'
     C                             AND MGPROC = 'Y'
     C                             AND VALD < BJDNWD
     C                   DELETE    GLPOSTD0

      *                                                                                     AR549926
      ** Also delete real posting (RECI = 'P'), unprocessed, Value date                     AR549926
      ** is less than the Next Working day and belong to a Closed or                        AR549926
      ** non-existing Retail Account                                                        AR549926
      *                                                                                     AR549926
     C                   WHEN      RECI = 'P'                                               AR549926
     C                             AND MGPROC <> 'Y'                                        AR549926
     C                             AND VALD < BJDNWD                                        AR549926
     C                             AND ATYP = 'R'                                           AR549926
     C                   EXSR      CHKACCT                                                  AR549926
      *                                                                                     AR549926
      ** For shadow postings, as the processing extracts the events to post today,
      ** and, it could send the shadow and the real posting to destination
      ** (the shadow is considered as 'expected' and the real as 'real'),
      ** all shadow postings could be deleted.

     C                   WHEN      RECI = 'S'
     C                   DELETE    GLPOSTD0

      ** Remove invalid postings.

     C                   WHEN      RECI <> 'P'
     C                             AND RECI <> 'S'
     C                   DELETE    GLPOSTD0

     C                   ENDSL

      ** Read next GL Posting.

     C                   READ      GLPOSTL0                               27

     C                   ENDDO

     C                   EVAL      *INLR = *On
     C                   RETURN

      *****************************************************************                     AR549926
      *  CHKACCT S/R - This S/R deletes postings from GLPOSTPD file   *                     AR549926
      *                for non-existing or closed Retail Account      *                     AR549926
      *****************************************************************                     AR549926
      *                                                                                     AR549926
     C     CHKACCT       BEGSR                                                              AR549926
      *                                                                                     AR549926
     C**********         Z-ADD     CNUM          KCNUM                                      AR549926
     C                   MOVE      CNUM          KCNUM                                      AR549926
     C                   MOVEL     CCY           KCCY                                       AR549926
     C                   Z-ADD     ACOD          KACOD                                      AR549926
     C                   Z-ADD     ACSQ          KACSQ                                      AR549926
     C                   MOVEL     BRCA          KBRCA                                      AR549926
      *                                                                                     AR549926
     C     KEYACCT       CHAIN     ACCNTL0                            98                    AR549926
      *                                                                                     AR549926
     C     *IN98         IFEQ      '1'                                                      AR549926
     C                   DELETE    GLPOSTD0                                                 AR549926
     C                   ELSE                                                               AR549926
     C     X_RECI        IFEQ      'C'                                                      AR549926
     C                   DELETE    GLPOSTD0                                                 AR549926
     C                   ENDIF                                                              AR549926
     C                   ENDIF                                                              AR549926
      *                                                                                     AR549926
     C                   ENDSR                                                              AR549926
      *****************************************************************                     AR549926
      *========================================================================*
      * *INZSR    : Init Processing                                            *
      *------------------------------------------------------------------------*

     C     *INZSR        BEGSR
      *    ------        -----

      ** Initialise Copyright Array

     C                   MOVEA     CPY@          CPY@@            80

      ** Initialise LDA

     C     *LOCK         IN        LDA
     C                   MOVEL     PSProcPgm     DBpgm
     C                   OUT       LDA

      ** Retrieve Bank details.

     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR '     P@RTCD                         Return Code
     C                   PARM      '*FIRST '     P@OPTN                         Option
     C     SDBANK        PARM      SDBANK        DSFDY

     C     KEYACCT       KLIST                                                              AR549926
     C**********         KFLD                    KCNUM             6 0                      AR549926
     C                   KFLD                    KCNUM             6                        AR549926
     C                   KFLD                    KCCY              3                        AR549926
     C                   KFLD                    KACOD            10 0                      AR549926
     C                   KFLD                    KACSQ             2 0                      AR549926
     C                   KFLD                    KBRCA             3                        AR549926
      *                                                                                     AR549926
      *    ------        -----
     C     @INZSR        ENDSR

      *========================================================================*
      * *PSSR     : Program exception error subroutine                         *
      *------------------------------------------------------------------------*

     C     *PSSR         BEGSR
      *    ----------    ------

     C                   DUMP

     C                   EVAL      *INU7 = *On
     C                   EVAL      *INU8 = *On
     C                   EVAL      *INLR = *On

     C                   RETURN

      *    ----------    ------
     C     @PSSR         ENDSR

      *========================================================================*
**  CPY@
(c) Finastra International Limited 2002
