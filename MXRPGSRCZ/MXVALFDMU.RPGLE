     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MX Validate Field MakeUp')
      *****************************************************************
      *                                                               *
      *  Midas - Meridian Export Module                               *
      *                                                               *
      *  MXVALFDMU - Validate Field Makeup                            *
      *                                                               *
      *  Function:  This module checks the makeup of a field.         *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *  Prev Amend No. CMX001  *CREATE    Data 01Jan00               *
      *                                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
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
 
 
     D                 DS
     D FD2BV                   1    100    DIM(100)
 
 
     D VALLC           S              1    DIM(26) CTDATA PERRCD(26)
     D VALUC           S              1    DIM(26) CTDATA PERRCD(26)
     D VALNM           S              1    DIM(10) CTDATA PERRCD(10)
 
     D                 DS
     D VALOC                   1     10    DIM(10)
 
 
      *
     C     *ENTRY        PLIST
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           30
      * INPUTS
      * Field
     C                   PARM                    ZFD2BV          100
      * Lowercase allowed
     C                   PARM                    ZFDLC             1
      * Uppercase allowed
     C                   PARM                    ZFDUC             1
      * Numbers allowed
     C                   PARM                    ZFDNM             1
      * Other characters allowed
     C                   PARM                    ZFDOTHC          10
      * OUTPUTS
      * Field in Error
     C                   PARM                    ZFDError          1
 
      * Set field to be validated array
 
     C                   MOVEA     ZFD2BV        FD2BV
 
      * Set valid other characters array
 
     C                   MOVEA     ZFDOTHC       VALOC
 
      * Reset output error indicator
 
     C                   MOVE      'N'           ZFDError
 
      * Validate Field MakeUp
 
     C                   EXSR      VAL_FDMU
 
 
      * Return
 
     C                   RETURN
      *
     C/SPACE 5
      ********************************************************************
      * Validate Field MakeUp
      ********************************************************************
     C     VAL_FDMU      BEGSR
 
      * Look at each byte in the field to be validated
 
     C                   Z-ADD     1             @X                3 0
 
     C     @X            DOUGT     100
 
     C     FD2BV(@X)     IFNE      *BLANK
 
     C                   MOVE      '0'           *IN99
 
      * Check lowercase, uppercase, numbers and other characters
 
     C     ZFDLC         IFEQ      'Y'
     C  N99FD2BV(@X)     LOOKUP    VALLC                                  99    *
     C                   ENDIF
     C     ZFDUC         IFEQ      'Y'
     C  N99FD2BV(@X)     LOOKUP    VALUC                                  99    *
     C                   ENDIF
     C     ZFDNM         IFEQ      'Y'
     C  N99FD2BV(@X)     LOOKUP    VALNM                                  99    *
     C                   ENDIF
     C  N99FD2BV(@X)     LOOKUP    VALOC                                  99    *
 
      * If not found -> error
 
     C     *IN99         IFEQ      '0'
     C                   MOVE      'Y'           ZFDError
     C                   ENDIF
 
     C                   ENDIF
 
      * First character can't be a number
     C     @X            IFEQ      1
     C     FD2BV(@X)     LOOKUP    VALNM                                  99    *
     C   99              MOVE      'Y'           ZFDError
     C                   ENDIF
      * First character can't be an 'other character'
     C     @X            IFEQ      1
     C     FD2BV(@X)     LOOKUP    VALOC                                  99    *
     C   99              MOVE      'Y'           ZFDError
     C                   ENDIF
 
     C                   ADD       1             @X
     C                   ENDDO
 
      * Look for embedded blanks in the field to be validated
 
     C                   Z-ADD     1             @X
 
     C     @X            DOUGT     100
 
      * If previous character is blank -> error
 
     C     @X            SUB       1             @Z                3 0
     C     @Z            IFGT      *ZERO
     C     FD2BV(@Z)     ANDEQ     *BLANK
     C     FD2BV(@X)     ANDNE     *BLANK
     C                   MOVE      'Y'           ZFDError
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
(c) Finastra International Limited 2001
** VALLC
abcdefghijklmnopqrstuvwxyz
** VALUC
ABCDEFGHIJKLMNOPQRSTUVWXYZ
** VALNM
1234567890
