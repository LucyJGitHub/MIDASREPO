     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2009')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MX Access customer lending facility FCLTYFM')    *
      *****************************************************************
      *                                                               *
      *  Midas - Meridian Export Module                               *
      *                                                               *
      *  MXACSFCLT3 - Access customer lending facilities              *
      *                                                               *
      *  Function:  This module accesses facilities from FCLTYFM.     *
      *                                                               *
      *  (c) Finastra International Limited 2009                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CLE064             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER045  *CREATE    Date 20Jul09               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE064 - Enhancement of Lending Frequencies (Recompile)      *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER045 - German Features - Reporting Bundesbank              *
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
 
      ** Facility details
 
     D FCLT1         E DS                  EXTNAME(FCLTYFM)
 
     C     *ENTRY        PLIST
 
     C/COPY MXCPYSRC,MXACSPRMI
 
      ** Use input link-to fields
 
     C                   MOVEL     I#LFD1        A_CNUM            6
     C                   MOVEL     I#LFD2        A_FACT            3
     C                   MOVEL     I#LFD3        A_FCNO            2
 
      ** Get the facility from FCLTYFM
 
     C                   MOVEL     A_CNUM        CNUM
     C                   MOVEL     A_FACT        FACT
     C                   MOVEL     A_FCNO        FCNO
     C     FACLKY        CHAIN     FCLTYFMF                           99        *
 
      ** If the facility isn't found
      ** and facility number is not zero,
      ** it is an error
 
     C                   IF        *IN99  ='1' AND
     C**********                   (CNUM  <> 0 OR                                             CER059
     C                             (CNUM  <> *Blanks OR                                       CER059
     C                              FACT  <> 0 OR
     C                              FCNO  <> 0)
     C                   EVAL      I#ERMS = 'BAD FACILITY:'
     C                             + A_CNUM + A_FACT + A_FCNO
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** If the facility isn't on FCLTYFM
 
     C                   IF        *IN99  = '1'
     C                   CLEAR                   FCLT1
     C                   ENDIF
 
      ** If the facility isn't available
      ** and this is a driver format
      **  Indicate that the facility is not to be extracted
 
     C                   IF        *IN99  = '1' AND
     C                             CFLFMT = '*DRIVER'
     C                   MOVEL     '*NOEXT '     I#RTCD
     C                   ENDIF
 
      * Set up output data
 
     C                   EVAL      InData = FCLT1
 
      ** Return
 
     C                   RETURN
 
      *
     C/SPACE 5
      ********************************************************************
      * *INZSR --- INITIAL PROCESSING
      ********************************************************************
     C     *INZSR        BEGSR
 
      ** Key list
 
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
(c) Finastra International Limited 2009
