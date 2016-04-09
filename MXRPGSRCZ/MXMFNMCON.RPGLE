     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MX Meridian Field Name Construction')
      *****************************************************************
      *                                                               *
      *  Midas - Meridian Export Module                               *
      *                                                               *
      *  MXMFNMCON - Merdian Field Name Construction                  *
      *                                                               *
      *  Function:  This module constructs the Merdian field name     *
      *             from an AS/400 field text                         *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *  Last Amend No. CMX001  *CREATE    Data 01Jan00               *
      *  Prev Amend No.                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CMX001 - Meridian Export                                     *
      *                                                               *
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
 
 
     D VALCL           S              1    DIM(26) CTDATA PERRCD(26)
     D VALCU           S              1    DIM(26) CTDATA PERRCD(26)
     D VALNM           S              1    DIM(10) CTDATA PERRCD(10)
 
     D                 DS
     D INPD                    1     50    DIM(50)
     D                 DS
     D OUTD                    1     29    DIM(29)
 
 
      *
     C     *ENTRY        PLIST
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           30
      * INPUTS
      * C=convert, V=validate
     C                   PARM                    I#CV              1
      * Field Text
     C                   PARM                    I#FTXT           50
      * Merdian Field Name
     C                   PARM                    I#MFNM           29
      * OUTPUTS
      * Merdian Field Name
     C                   PARM                    O#MFNM           29
 
      * Set input data array
 
     C                   MOVE      *BLANK        INPD
     C     I#CV          IFEQ      'C'
     C                   MOVEA     I#FTXT        INPD
     C                   ELSE
     C                   MOVEA     I#MFNM        INPD
     C                   ENDIF
 
      * Clear output data array
 
     C                   MOVE      *BLANK        OUTD
 
      * Construct Meridian Field Name
 
     C                   EXSR      CON_MFNM
 
      * Set output Merdian Field Name
 
     C                   MOVEA     OUTD          O#MFNM
     C     O#MFNM        IFEQ      *BLANK
     C                   MOVEL     'NoName'      O#MFNM
     C                   ENDIF
 
 
      * Return
 
     C                   RETURN
      *
     C/SPACE 5
      ********************************************************************
      * Construct Meridian Field Name
      ********************************************************************
     C     CON_MFNM      BEGSR
 
      * Remove invalid characters
     C                   Z-ADD     1             @X
     C     @X            DOUGT     50
     C     INPD(@X)      LOOKUP    VALCL                                  99    *
     C  N99INPD(@X)      LOOKUP    VALCU                                  99    *
     C  N99INPD(@X)      LOOKUP    VALNM                                  99    *
     C     *IN99         IFEQ      '0'
     C                   MOVE      ' '           INPD(@X)
     C                   ENDIF
 
      * First character can't be a number
     C     @X            IFEQ      1
     C     INPD(@X)      LOOKUP    VALNM                                  99    *
     C   99              MOVE      ' '           INPD(@X)
     C                   ENDIF
 
     C                   ADD       1             @X
     C                   ENDDO
 
      * Remove blanks
     C                   Z-ADD     1             @X                3 0
     C                   Z-ADD     1             @Y                3 0
 
     C     @X            DOUGT     50
 
      * If previous character is blank, or first character
      * convert to capitals (if not already)
 
     C     @X            SUB       1             @Z                3 0
     C     @Z            IFGT      *ZERO
     C     INPD(@Z)      ANDEQ     *BLANK
     C     INPD(@X)      ANDNE     *BLANK
     C     @Z            OREQ      *ZERO
     C     INPD(@X)      ANDNE     *BLANK
     C                   Z-ADD     1             @I                3 0
     C     INPD(@X)      LOOKUP    VALCL(@I)                              99    *
     C   99              MOVE      VALCU(@I)     INPD(@X)
     C                   ELSE
      * else, convert to lowercase
     C                   Z-ADD     1             @I
     C     I#CV          IFEQ      'C'
     C     INPD(@X)      LOOKUP    VALCU(@I)                              99    *
     C   99              MOVE      VALCL(@I)     INPD(@X)
     C                   ENDIF
     C                   ENDIF
 
     C     INPD(@X)      IFNE      *BLANK
     C     @Y            ANDLE     29
     C                   MOVE      INPD(@X)      OUTD(@Y)
     C                   ADD       1             @Y
     C                   ENDIF
 
     C                   ADD       1             @X
     C                   ENDDO
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY MXCPYSRC,MXPSSR
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
** VALCL
abcdefghijklmnopqrstuvwxyz
** VALCU
ABCDEFGHIJKLMNOPQRSTUVWXYZ
** VALNM
1234567890
