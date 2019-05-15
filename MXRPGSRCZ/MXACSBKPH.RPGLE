     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MX Access (SE) Book Position Headers')
      *****************************************************************
      *                                                               *
      *  Midas - Meridian Export Module                               *
      *                                                               *
      *  MXACSBKPH - Access (Securities) Book Position Headers        *
      *                                                               *
      *  Function:  This module accesses book position headers        *
      *             from BKPHDD.                                      *
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
      *  Prev Amend No. CMX003  *CREATE    Date 05Nov00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CMX003 - Meridian Export Enhancements - Phase 2              *
      *                                                               *
      *****************************************************************
 
     FBKPHD     IF   E           K DISK    INFSR(*PSSR)
      * Book Position Headers
 
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
 
 
      * Book Position Headers
     D BKPHED        E DS                  EXTNAME(BKPHDD)
 
 
      ** External DS for BANK details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
 
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
 
      * Get the book position header from BKPHDD
 
     C                   MOVEL     A_BHBA        BHBA
     C                   MOVEL     A_BHBK        BHBK
     C                   MOVEL     A_BHSC        BHSC
     C                   MOVEL     A_BHMK        BHMK
     C                   MOVEL     A_BHTV        BHTV
     C     BKPHDK        CHAIN     BKPHDDF                            99        *
 
      * If the book position header isn't found
      * and this is a current extract
      * it is an error
 
     C     *IN99         IFEQ      '1'
     C     I#EXTT        ANDEQ     'C'
     C                   EVAL      I#ERMS = 'BAD POSITION:'
     C                             + A_BHBA + A_BHBK + A_BHSC + A_BHMK
     C                             + A_BHTV
     C                   EXSR      *PSSR
     C                   ENDIF
 
      * If the book position header isn't on BKPHDD
 
     C     *IN99         IFEQ      '1'
     C                   CLEAR                   BKPHED
     C                   MOVEL     A_BHBA        BHBA
     C                   MOVEL     A_BHBK        BHBK
     C                   MOVEL     A_BHSC        BHSC
     C                   MOVEL     A_BHMK        BHMK
     C                   MOVEL     A_BHTV        BHTV
     C                   ENDIF
 
      * If the book position header isn't available
      * and this is a driver format
      *  Indicate that the book position header is not to be extracted
 
     C     *IN99         IFEQ      '1'
     C     CFLFMT        ANDEQ     '*DRIVER   '
     C                   MOVEL     '*NOEXT '     I#RTCD
     C                   ELSE
 
      * If this is a driver format
 
     C     CFLFMT        IFEQ      '*DRIVER   '
 
      * Determine if branch is to be included in the export
 
     C                   MOVE      'D'           I#LD
     C                   MOVEL     BHBA          I#BRCA
     C                   EXSR      BRCA_FLT
 
      * If the branch is NOT for export
      *  Indicate that book position is not to be extracted
 
     C     Exp_BRCA      IFNE      'Y'
     C                   MOVEL     '*NOEXT '     I#RTCD
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
      * Set up output data
 
     C                   EVAL      InData = BKPHED
 
 
      * Return
 
     C                   RETURN
      *
      /SPACE 5
      *********************************************************************
      * B R A N C H   F I L T E R
      /COPY MXCPYSRC,MXFLTBRCA
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * *INZSR --- INITIAL PROCESSING
      ********************************************************************
     C     *INZSR        BEGSR
      *
      **  Access Bank Details
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR  '    @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
 
      * Load branches for export
 
     C                   MOVE      'L'           I#LD
     C                   EXSR      BRCA_FLT
 
      * Key list
 
     C     BKPHDK        KLIST
     C                   KFLD                    BHSC
     C                   KFLD                    BHBA
     C                   KFLD                    BHBK
     C                   KFLD                    BHMK
     C                   KFLD                    BHTV
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY MXCPYSRC,MXPSSR
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2001
