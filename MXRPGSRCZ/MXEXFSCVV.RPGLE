     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MX Export Format Selection CompVl Validation')
      *****************************************************************
      *                                                               *
      *  Midas - Meridian Export Module                               *
      *                                                               *
      *  MXEXFSCVV - Export Format Selection CompVl Validation        *
      *                                                               *
      *  Function:  This module validates a comparision value         *
      *             within the export format selection criteria       *
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
 
 
     D ZSN             S              1    DIM(10) ASCEND
     D INVC            S              1    DIM(2) CTDATA PERRCD(2)
 
 
 
     C     *ENTRY        PLIST
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           30
      * INPUTS
     C                   PARM                    WHFLDT            1
     C                   PARM                    WHFLDD            2 0
     C                   PARM                    WHFLDB            5 0
     C                   PARM                    DDSCPV           10
 
 
     C                   MOVEA     DDSCPV        ZSN
 
      * Validate a NUMERIC field
 
     C     WHFLDT        IFEQ      'S'
     C     WHFLDT        OREQ      'P'
     C                   EXSR      VAL_NUM
     C                   ELSE
 
      * Validate an ALPHAMERIC field
 
     C                   EXSR      VAL_ALP
     C                   END
 
      * Return
 
     C                   RETURN
      *
      *****************************************************************
      * Validate a NUMERIC field
      *****************************************************************
     C     VAL_NUM       BEGSR
 
      * If date check code-words are used
      * the field must have the attributes of a date
 
     C     DDSCPV        IFEQ      '*CUREOM   '
     C     DDSCPV        OREQ      '*CURSOM   '
     C     DDSCPV        OREQ      '*PRVSOM   '
     C     DDSCPV        OREQ      '*CURRUN   '
     C     DDSCPV        OREQ      '*CURNWD   '
     C     DDSCPV        OREQ      '*PRVRUN   '
 
     C     WHFLDD        IFNE      5
     C                   MOVEL     'INVDAT '     I#RTCD
     C                   ENDIF
 
     C                   ELSE
      *
      * Check that there are as many characters input as there are digits,
      * no more
      *
     C                   Z-ADD     1             @X                2 0
     C     @X            DOUGT     10
     C     ZSN(@X)       IFNE      *BLANK                                       *
     C     @X            ANDGT     WHFLDD
     C     ZSN(@X)       OREQ      *BLANK                                       *
     C     @X            ANDLE     WHFLDD
     C                   MOVEL     'INVSIZ '     I#RTCD
     C                   ENDIF
     C                   ADD       1             @X
     C                   ENDDO
      *
      * Validate that a number is present
      *
     C                   MOVEL     *BLANK        ZFIELD
     C                   MOVEA     ZSN           ZFIELD
     C                   CALLB     'ZALIGN'
     C                   PARM                    ZALIGNok          1
     C                   PARM                    ZFIELD           16
     C                   PARM      0             ZADEC             1 0
     C                   PARM      WHFLDD        ZADIG             2 0
      *
      * Invalid number
      *
     C     ZALIGNok      IFNE      'Y'
     C                   MOVEL     'INVNUM '     I#RTCD
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Validate an ALPHAMERIC field
      *****************************************************************
     C     VAL_ALP       BEGSR
      *
      * Check that there are no more characters input as there are bytes
      * in the field
      *
     C                   Z-ADD     1             @X
     C     @X            DOUGT     10
     C     ZSN(@X)       IFNE      *BLANK                                       *
     C     @X            ANDGT     WHFLDB
     C                   MOVEL     'INVSIZ '     I#RTCD
     C                   ENDIF
     C                   ADD       1             @X
     C                   ENDDO
 
      * Check FOR INVALID CHARACTERS
 
     C                   Z-ADD     1             @X
     C     INVC(1)       LOOKUP    ZSN(@X)                                99    *
     C  N99INVC(2)       LOOKUP    ZSN(@X)                                99    *
     C     *IN99         IFEQ      '1'
     C                   MOVEL     'INVCHR '     I#RTCD
     C                   ENDIF
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY MXCPYSRC,MXPSSR
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
** INVC
'"
