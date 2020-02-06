     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas RE Cash Management Hierarchy Errors Browse')
      *****************************************************************
      *                                                               *
      *  Midas - Retail Module                                        *
      *                                                               *
      *  RE100470 - Cash Management Hierarchy Errors Browse           *
      *                                                               *
      *  Function: This module allows browsing of Cash Management     *
      *            Hierarchy Validation Errors                        *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. BG8539             Date 15Sep05               *
      *                 CRE008  *CREATE    Date 19Feb02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  BG8539 - Screen not dispaly properly in WebFacing            *
      *           Change the write/read order so that the last        *
      *           written format of the screen is next one to be READ *
      *  CRE008 - Cash Management                                     *
      *                                                               *
      *****************************************************************
 
     FRE100470DFCF   E             WORKSTN INFSR(*PSSR)
     F                                     SFILE(SUBFLREC:RRN)
     FRECMVEL0  IF   E           K DISK    INFSR(*PSSR)
 
      *****************************************************************
      * Standard D Specifications
     D/COPY ZACPYSRC,RECMSTDD
      * Program Status Data Structure
     D/COPY ZACPYSRC,PSDS
      *****************************************************************
 
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for BANK details
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for access programs
 
 
      * Time
     D                 DS
     D VETIME                  1      6S 0
     D VETIMEH                 1      2
     D VETIMEM                 3      4
     D VETIMES                 5      6
 
 
      /SPACE 5
 
 
      * Fill the subfile with messages
 
     C                   EXSR      FILL_SUB
 
      * Display screen until F3, or F12 taken
 
     C     *INKC         DOWEQ     '0'
     C     *INKL         ANDEQ     '0'
     C                   EXSR      DSPLAY_SCN
     C                   END
 
      * End of program
 
     C                   SETON                                        LR
 
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
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      *****************************************************************
      * Fill the subfile with the outgoing messages
      *****************************************************************
     C     FILL_SUB      BEGSR
 
      * Clear subfile
     C                   MOVEA     '0000'        *IN(11)
     C                   Z-ADD     *ZERO         RRN
     C                   WRITE     SUBFLCTL                                     *
 
      * Read all hierarchy validation errors
 
     C     *LOVAL        SETLL     RECMVEL0
     C                   READ      RECMVEL0                               99    *
     C  N99              Z-SUB     1             P_VEHIER          9 0
 
      * Do while hierarchy validation errors found
 
     C     *IN99         DOWEQ     '0'
 
     C     VEHIER        IFNE      P_VEHIER
 
     C     P_VEHIER      IFNE      -1
     C                   EVAL      DDERR = '----------------------------' +
     C                                     '----------------------------' +
     C                                     '----------------------------'
     C                   ADD       1             RRN               4 0          *
     C                   WRITE     SUBFLREC
     C                   ENDIF
 
     C                   EVAL      DDERR = VEHISN + ' ' + VEHTYP
     C                                     + ' ' + VEDATE + '  ' + VETIMEH
     C                                     + ':' + VETIMEM + ':' + VETIMES
     C                   ADD       1             RRN                            *
     C                   WRITE     SUBFLREC
 
     C                   MOVEL     VEHIER        P_VEHIER
     C                   ENDIF
 
     C                   EVAL      DDERR = VEHISN + ' ' + VEMSGA
     C                   ADD       1             RRN                            *
     C                   WRITE     SUBFLREC
 
     C                   READ      RECMVEL0                               99    *
     C                   ENDDO
 
     C     RRN           IFGT      *ZERO
     C                   EVAL      DDERR = '----------------------------' +
     C                                     '----------------------------' +
     C                                     '----------------------------'
     C                   ADD       1             RRN                            *
     C                   WRITE     SUBFLREC
     C                   ELSE
     C                   EVAL      DDERR = '                         '
     C                                     + '* NO ERRORS TO REPORT *'
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
 
     C                   MOVEL     'RE100470'    DDPGM
 
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
