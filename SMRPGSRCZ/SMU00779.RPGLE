     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2016')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Utility to update DRCD and OLDR in ACCNTAB')           *
      *****************************************************************
      *                                                               *
      *  Midas - Implementation module                                *
      *                                                               *
      *  SMU00245 - Utility to update DRCD and OLDR in ACCNTAB        *
      *                                                               *
      *  Function:  This program will update DRCD and OLDR of ACCNTAB *
      *                                                               *
      *  Called By: SMUC00779                                         *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2016            *
      *                                                               *
      *  Last Amend No. MD038563 *CREATE   Date 29Jun16               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD038563 - Update DRCD and OLDR in ACCNTAB                   *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *       10  Read REHISDL                                        *
      *       80  Update mode                                         *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * *PSSR - Error processing                                      *
      *                                                               *
      *****************************************************************

     FACCNTL0   UF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(C_)
     FREHISDL   IF   E           K DISK    INFSR(*PSSR)
     FSMU00779P1O    E             PRINTER OFLIND(*IN70)

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
      ** The following /COPY includes the LE standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **--------------------------------------------------------------------------------------------

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **--------------------------------------------------------------------------------------------

      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+

      *****************************************************************
      /SPACE 5
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
      *
      ** Data Area giving Installation Control Details

     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** Bank Details
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.

     D DSFDY         E DS                  EXTNAME(DSFDY)

      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

     D @RUN            S              1

      *****************************************************************
      /EJECT
      *****************************************************************

      *
      ** Write header records.
      *
     C                   WRITE     HEADPY
     C                   Z-ADD     0             ERRSUM            5 0
      *
     C     *LOVAL        SETLL     ACCNTL0
     C                   READ      ACCNTL0

     C                   DOW       NOT %EOF(ACCNTL0)

     C                   MOVEL     C_BRCA        KBRCA
     C                   MOVEL     C_CNUM        KCNUM
     C                   MOVEL     C_CCY         KCCY
     C                   Z-ADD     C_ACOD        KACOD
     C                   Z-ADD     C_ACSQ        KACSQ
     C                   Z-ADD     99999         KHISD
     C                   MOVE      'N'           ERRFLG            1
      *
      ** Check the DRCD or OLDR if correct.
      *
     C     KEY001        SETGT     REHISDL
     C     KEY002        READPE    REHISDL                                10
      *
     C     *IN10         IFEQ      '0'
     C     C_DRCD        IFNE      DRCD
     C     C_OLDR        ORNE      DRCD
     C                   MOVE      'Y'           ERRFLG
     C                   ADD       1             ERRSUM
     C                   ENDIF
     C                   ENDIF
      *
      ** Process the record with error.
      *
     C     ERRFLG        IFEQ      'Y'
     C                   MOVE      C_BRCA        RBRCA
     C                   MOVE      C_CNUM        RCNUM
     C                   MOVE      C_CCY         RCCY
     C                   MOVE      C_ACOD        RACOD
     C                   MOVE      C_ACSQ        RACSQ
     C                   MOVE      C_DRCD        ODRCD
     C                   MOVE      DRCD          NDRCD
     C                   MOVE      C_OLDR        OOLDR
     C                   MOVE      DRCD          NOLDR
      *
     C                   IF        *IN70 = '1'
     C                   WRITE     HEADPY
     C                   EVAL      *IN70 = '0'
     C                   ENDIF
     C                   WRITE     DETAIL1
      *
     C     *IN80         IFEQ      *ON
     C                   Z-ADD     DRCD          C_DRCD
     C                   Z-ADD     DRCD          C_OLDR
     C                   UPDATE    ACCNTABF
     C                   ENDIF
     C                   ENDIF
     C                   READ      ACCNTL0
      *
     C                   ENDDO
      *
     C                   Z-ADD     ERRSUM        RTOTAL
     C                   WRITE     TRAILPY
     C                   EVAL      *INLR = *ON
     C                   Return

      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Initialisation Subroutine                           *
      *                                                               *
      *  Called From:  Main program                                   *
      *                                                               *
      *  Calls: *PSSR                                                 *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
      *
      ** Parameter entry.
      *
     C     *ENTRY        PLIST
     C                   PARM                    MODE              1
      *
      ** Define RUNDAT.
      *
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
      *
      ** Check mode if 'AUDIT' or 'UPDATE'.
      *
     C                   IF        MODE = 'U'
     C                             or MODE = 'u'
     C                   MOVE      '1'           *IN80
     C                   ELSE
     C                   MOVE      '0'           *IN80
     C                   ENDIF
      *
      ** Access bank details.
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      '*MSG   '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
     C                   IF        @RTCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = @OPTN
     C                   EVAL      DBPGM = 'SMU00779'
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE = 1
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Key Lists.
      *
     C     KEY001        KLIST
     C                   KFLD                    KBRCA             3
     C                   KFLD                    KCNUM             6
     C                   KFLD                    KCCY              3
     C                   KFLD                    KACOD            10 0
     C                   KFLD                    KACSQ             2 0
     C                   KFLD                    KHISD             5 0
     C     KEY002        KLIST
     C                   KFLD                    KBRCA
     C                   KFLD                    KCNUM
     C                   KFLD                    KCCY
     C                   KFLD                    KACOD
     C                   KFLD                    KACSQ
      *
      ** Initialise variables.
      *
     C                   MOVEL     BJMRDT        RMRDT
     C                   MOVE      *BLANK        KBRCA
     C                   MOVE      *BLANK        KCNUM
     C                   MOVE      *BLANK        KCCY
     C                   Z-ADD     0             KACOD
     C                   Z-ADD     0             KACSQ
      *
     C                   ENDSR
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
     C                   EVAL      *INLR = *ON
     C                   RETURN

     C                   ENDSR

      ********************************************************************
**  CPY@
(c) Misys Banking Systems 2016
