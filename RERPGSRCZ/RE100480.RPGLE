     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas RE Cash Management I/C Sweeping Monitor')
      *****************************************************************
      *                                                               *
      *  Midas - Retail Module                                        *
      *                                                               *
      *  RE100480 - Cash Management Input Cycle Sweeping Monitor      *
      *                                                               *
      *  Function: This module allows browsing of the Cash Management *
      *            Input Cycle Sweeping Log file.                     *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. BG8539             Date 15Sep05               *
      *  Prev Amend No. CRE008  *CREATE    Date 19Feb02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  BG8539 - Screen not dispaly properly in WebFacing            *
      *           Change the write/read order so that the last        *
      *           written format of the screen is next one to be READ *
      *  CRE008 - Cash Management                                     *
      *                                                               *
      *****************************************************************
 
     FRE100480DFCF   E             WORKSTN INFSR(*PSSR)
     F                                     SFILE(SUBFLREC:RRN)
     FREICSLL2  IF   E           K DISK    INFSR(*PSSR)
 
      *****************************************************************
      * Standard D Specifications
     D/COPY ZACPYSRC,RECMSTDD
      * Program Status Data Structure
     D/COPY ZACPYSRC,PSDS
      *****************************************************************
 
 
     D #_WRKJOB1       S             18    DIM(1)  CTDATA PERRCD(1)
     D #_WRKJOB2       S             15    DIM(1)  CTDATA PERRCD(1)
     D #_TXT           S              1    DIM(60)
 
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for BANK details
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for access programs
 
 
      /SPACE 5
 
 
      * Fill the subfile with messages
 
     C                   EXSR      FILL_SUB
 
      * Display screen until F3, or F5 or F12 taken
 
     C     *INKC         DOWEQ     '0'
     C     *INKE         ANDEQ     '0'
     C     *INKL         ANDEQ     '0'
     C                   EXSR      DSPLAY_SCN
     C                   END
 
      * End of program
 
     C  NKE              SETON                                        LR
     C   KE              SETOFF                                       KE
 
      /SPACE 5
      *****************************************************************
      * Display screen
      *****************************************************************
     C     DSPLAY_SCN    BEGSR
 
      * Write and read screen
 
     C                   TIME                    DDTIME
     C**********         WRITE     SUBFLCTL                                                   BG8539
     C                   WRITE     FOOTER
     C                   WRITE     SUBFLCTL                                                   BG8539
 
      * Read subfile control
 
     C                   READ      SUBFLCTL                               99    *
 
      * Check for a record selected from the subfile
 
     C                   EXSR      CHK_SUBF
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      *****************************************************************
      * Check for a record selected from the subfile
      *****************************************************************
     C     CHK_SUBF      BEGSR
 
     C                   READC     SUBFLREC                               99    *RECORD CHANGED
 
      * Do until all records processed
 
     C     *IN99         DOWEQ     '0'
 
      * If an action code is specified
      *   Enquire on the record in the subfile
 
     C     DDACTN        IFNE      *BLANK
     C                   MOVE      *BLANK        #_TXT
     C                   MOVEA     #_WRKJOB1     #_TXT
     C                   MOVEA     DDJBNO        #_TXT(12)
     C                   MOVEA     '/'           #_TXT(18)
     C                   MOVEA     ILJBUS        #_TXT(19)
     C                   Z-ADD     1             I                 2 0
     C     *BLANK        LOOKUP    #_TXT(I)                               99
     C                   MOVEA     '/'           #_TXT(I)
     C                   ADD       1             I
     C                   MOVEA     ILJBNM        #_TXT(I)
     C     *BLANK        LOOKUP    #_TXT(I)                               99
     C                   MOVEA     #_WRKJOB2     #_TXT(I)
     C                   MOVE      *BLANK        #_TXT(7)
     C                   CALL      'QCMDEXC'                            9999    *
     C                   PARM                    #_TXT
     C                   PARM      60            LEN              15 5
     C                   ENDIF
 
      * Read next
 
     C                   READC     SUBFLREC                               99    *RECORD CHANGED
     C                   ENDDO
 
     C                   MOVE      *ON           *INKE
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      *****************************************************************
      * Fill the subfile with the outgoing messages
      *****************************************************************
     C     FILL_SUB      BEGSR
 
      * Clear subfile
     C                   MOVEA     '0000'        *IN(11)
     C                   Z-ADD     *ZERO         RRN               4 0
     C                   WRITE     SUBFLCTL                                     *
 
      * Read all input cycle sweeping log records
 
     C     *LOVAL        SETLL     REICSLL2
     C                   READ      REICSLL2                               99    *
 
      * Do while input cycle sweeping log records found
 
     C     *IN99         DOWEQ     '0'
 
     C                   MOVE      *BLANK        DDACTN
     C                   EVAL      DDNARR = %SUBST(ILNARR:40:60)
     C     ILJBNM        COMP      *BLANK                             5050
     C                   MOVE      ILJBNO        DDJBNO
 
     C                   ADD       1             RRN                            *
     C                   WRITE     SUBFLREC
 
     C                   READ      REICSLL2                               99    *
     C                   ENDDO
 
     C     RRN           IFEQ      *ZERO
     C                   SETOFF                                       50
     C                   EVAL      DDNARR = '     * NO DETAILS TO DISPLAY *'
     C                   ADD       1             RRN                            *
     C                   WRITE     SUBFLREC
     C                   ENDIF
 
 
      * Reset subfile
 
     C                   MOVEA     '111'         *IN(11)
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * *INZSR - Initial subroutine called automatically at program start
      *****************************************************************
     C     *INZSR        BEGSR
 
      * Initialize program name
 
     C                   MOVEL     'RE100480'    DDPGM
 
      * Set up standard screen fields.
 
     C                   MOVEL     PsJobName     DDJOB
     C                   MOVEL     PsUser        DDUSR
 
      *  Access Bank Details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR  '    @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY ZACPYSRC,RECMPSSR
      *****************************************************************
** #_WRKJOB1
WRKJOB_JOB(999999/
** #_WRKJOB2
) OPTION(*SPLF)
