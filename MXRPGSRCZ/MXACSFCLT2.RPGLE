     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MX Access customer lending facilitiesFCLTYFN')
      *****************************************************************
      *                                                               *
      *  Midas - Meridian Export Module                               *
      *                                                               *
      *  MXACSFCLT2 - Access customer lending facilities              *
      *                                                               *
      *  Function:  This module accesses facilities from FCLTYFN.     *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CLE042             Date 06Sep05               *
      *                 CSD027             Date 09Dec05               *
      *                 CAP074             Date 08Aug02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAP068             Date 25JUN02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CMX001  *CREATE    Data 01Jan00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data.    *
      *           (Recompile)                                         *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CAP074 - Lending API enhancements - Loans input.             *
      *           (Recompile)                                         *
      *  CAP068 - Recompiled for changes to FCLTYFM and FCLTYFN.      *
      *  CMX001 - Meridian Export                                     *
      *                                                               *
      *****************************************************************

     FFCLTY     IF   E           K DISK    INFSR(*PSSR)
     F                                     IGNORE(FCLTYHHF : FCLTYZZF)

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


      * Facility details
     D FCLT2         E DS                  EXTNAME(FCLTYFN)


     C     *ENTRY        PLIST
     C/COPY MXCPYSRC,MXACSPRMI


      * Use input link-to fields

     C                   MOVEL     I#LFD1        A_CNUM            6
     C                   MOVEL     I#LFD2        A_FACT            3
     C                   MOVEL     I#LFD3        A_FCNO            2

      * Error if no customer number is supplied

     C     A_CNUM        IFEQ      *BLANK
     C     A_CNUM        OREQ      '000000'
     C                   EVAL      I#ERMS = 'BLANK CUSTOMER'
     C                   EXSR      *PSSR
     C                   ENDIF

      * Error if no facility type is supplied

     C     A_FACT        IFEQ      *BLANK
     C     A_FACT        OREQ      '000'
     C                   EVAL      I#ERMS = 'BLANK FACILITY TYPE'
     C                   EXSR      *PSSR
     C                   ENDIF

      * Error if no facility number is supplied

     C     A_FCNO        IFEQ      *BLANK
     C     A_FCNO        OREQ      '00'
     C                   EVAL      I#ERMS = 'BLANK FACILITY NUMBER'
     C                   EXSR      *PSSR
     C                   ENDIF

      * Get the facility from FCLTYFN

     C                   MOVEL     A_CNUM        CNUM
     C                   MOVEL     A_FACT        FACT
     C                   MOVEL     A_FCNO        FCNO
     C     FACLKY        CHAIN     FCLTYFNF                           99        *

      * If the facility isn't found
      * and this is a current extract
      * it is an error

     C     *IN99         IFEQ      '1'
     C     I#EXTT        ANDEQ     'C'
     C                   EVAL      I#ERMS = 'BAD FACILITY:'
     C                             + A_CNUM + A_FACT + A_FCNO
     C                   EXSR      *PSSR
     C                   ENDIF

      * If the facility isn't on FCLTYFN

     C     *IN99         IFEQ      '1'
     C                   CLEAR                   FCLT2
     C                   MOVEL     A_CNUM        CNUM
     C                   MOVEL     A_FACT        FACT
     C                   MOVEL     A_FCNO        FCNO
     C                   ENDIF

      * If the facility isn't available
      * and this is a driver format
      *  Indicate that the facility is not to be extracted

     C     *IN99         IFEQ      '1'
     C     CFLFMT        ANDEQ     '*DRIVER   '
     C                   MOVEL     '*NOEXT '     I#RTCD
     C                   ENDIF

      * Set up output data

     C                   EVAL      InData = FCLT2


      * Return
     C                   RETURN

      *
     C/SPACE 5
      ********************************************************************
      * *INZSR --- INITIAL PROCESSING
      ********************************************************************
     C     *INZSR        BEGSR

      * Key list

     C     FACLKY        KLIST
     C                   KFLD                    CNUM
     C                   KFLD                    FACT
     C                   KFLD                    FCNO

     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY MXCPYSRC,MXPSSR
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2001
