     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MX Access Daily Events - Securities Bk Pos')
      *****************************************************************
      *                                                               *
      *  Midas - Meridian Export Module                               *
      *                                                               *
      *  MXACSDESEB - Access Daily Events - SECURITIES Book Positions *
      *                                                               *
      *  Function:  This module accesses daily events from MXDESEBPD  *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *  Last Amend No. CMX003  *CREATE    Date 05Nov00               *
      *  Prev Amend No.                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CMX003 - Meridian Export Enhancements - Phase 2              *
      *                                                               *
      *****************************************************************
 
     FMXDESEBL1 IF   E           K DISK    INFSR(*PSSR)
      * Daily Events - SECURITIES Book Positions
 
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
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
 
      * Daily Events - SECURITIES Book Positions
     D DESEB         E DS                  EXTNAME(MXDESEBPD)
 
 
     C     *ENTRY        PLIST
     C/COPY MXCPYSRC,MXACSPRMI
 
 
      * Use input link-to fields
 
     C                   MOVEL     I#LFD1        A_BHBA            3
     C                   MOVEL     I#LFD2        A_BHBK            2
     C                   MOVEL     I#LFD3        A_BHSC           10
     C                   MOVEL     I#LFD4        A_BHMK            1
     C                   MOVEL     I#LFD5        A_BHTV            1
 
      * Error if no branch is supplied
 
     C     A_BHBA        IFEQ      *BLANK
     C                   EVAL      I#ERMS = 'BLANK BRANCH'
     C                   EXSR      *PSSR
     C                   ENDIF
 
      * Error if no book is supplied
 
     C     A_BHBK        IFEQ      *BLANK
     C                   EVAL      I#ERMS = 'BLANK BOOK'
     C                   EXSR      *PSSR
     C                   ENDIF
 
      * Error if no security is supplied
 
     C     A_BHSC        IFEQ      *BLANK
     C                   EVAL      I#ERMS = 'BLANK SECURITY'
     C                   EXSR      *PSSR
     C                   ENDIF
 
      * Error if no market is supplied
 
     C     A_BHMK        IFEQ      *BLANK
     C                   EVAL      I#ERMS = 'BLANK MARKET'
     C                   EXSR      *PSSR
     C                   ENDIF
 
      * Error if no Trade/Value date basis is supplied
 
     C     A_BHTV        IFEQ      *BLANK
     C                   EVAL      I#ERMS = 'BLANK T/V DATE BASIS'
     C                   EXSR      *PSSR
     C                   ENDIF
 
      * If a new book position, re-position the file pointer
 
     C                   MOVEL     A_BHBA        BHBA
     C                   MOVEL     A_BHBK        BHBK
     C                   MOVEL     A_BHSC        BHSC
     C                   MOVEL     A_BHMK        BHMK
     C                   MOVEL     A_BHTV        BHTV
 
     C     BHBA          IFNE      P_BHBA
     C     BHBK          ORNE      P_BHBK
     C     BHSC          ORNE      P_BHSC
     C     BHMK          ORNE      P_BHMK
     C     BHTV          ORNE      P_BHTV
 
     C                   MOVEL     BHBA          P_BHBA
     C                   MOVEL     BHBK          P_BHBK
     C                   MOVEL     BHSC          P_BHSC
     C                   MOVEL     BHMK          P_BHMK
     C                   MOVEL     BHTV          P_BHTV
     C                   CLEAR                   DESEB
     C                   Z-ADD     *ZERO         Num_Events        5 0
     C     MXDESEBK      SETLL     MXDESEBP0
     C                   ENDIF
 
      * Get a daily event for the book position
 
     C     MXDESEBK      READE     MXDESEBP0                              99     *
 
      * No more events
 
     C     *IN99         IFEQ      '1'
     C     Num_Events    ANDNE     *zero
     C                   MOVEL     '*EODATA'     I#RTCD
     C                   ELSE
     C                   ADD       1             Num_Events
     C                   Z-ADD     Num_Events    EAEVTC
     C                   ENDIF
 
 
      * Set up output data
 
     C                   EVAL      InData = DESEB
 
 
      * Return
 
     C                   RETURN
      *
     C/SPACE 5
      ********************************************************************
      * *INZSR --- INITIAL PROCESSING
      ********************************************************************
     C     *INZSR        BEGSR
 
     C                   MOVEL     *BLANK        P_BHBA
     C                   MOVEL     *BLANK        P_BHBK
     C                   MOVEL     *BLANK        P_BHSC
     C                   MOVEL     *BLANK        P_BHMK
     C                   MOVEL     *BLANK        P_BHTV
 
      * Key lists
 
     C     MXDESEBK      KLIST
     C                   KFLD                    P_BHBA            3
     C                   KFLD                    P_BHBK            2
     C                   KFLD                    P_BHSC           10
     C                   KFLD                    P_BHMK            1
     C                   KFLD                    P_BHTV            1
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY MXCPYSRC,MXPSSR
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
