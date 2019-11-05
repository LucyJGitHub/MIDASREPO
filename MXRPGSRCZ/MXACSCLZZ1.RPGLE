     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MX Access customer lending loans & parts')       *
      *****************************************************************
      *                                                               *
      *  Midas - Meridian Export Module                               *
      *                                                               *
      *  MXACSCLZZ1 - Access customer lending loans and participations*
      *                                                               *
      *  Function:  This module accesses loans & parts from CLOANCL.  *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CLE134             Date 01Aug12               *
      *                 CLE148             Date 23Jul12               *
      *                 CER059             Date 19Jul10               *
      *                 CER020             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CLE042             Date 06Sep05               *
      *                 CAP074             Date 08Aug02               *
      *                 CLE028             Date 27Jun02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 189208  *CREATE    Date 25Jan01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CLE148 - Alpha Loan Reference                                *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus (Recompile)                              *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  CAP074 - Lending API enhancements - Loans input.             *
      *           (Recompile)                                         *
      *  CLE028 - Flat Rate Personal Loans (Rule of 78s)              *
      *  189208 - Consolidation of Loans & participations into 1 fmt  *
      *                                                               *
      *****************************************************************
 
     FCLOAN     IF   E           K DISK    INFSR(*PSSR)
     F                                     IGNORE(CLOANZ1F : CLOANHHF)
      * All Loans
 
     FMXSLECLPD IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(CLOANCLF: MXSLECLP0)
      * Saved Loans
 
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
 
 
     D***LoanProcTypes***C                   '61 62 63 64 65 66 67 68 69'                     CLE028
     D LoanProcTypes   C                   '61 62 63 64 65 66 67 68 69 80'                    CLE028
 
      * Loans and Participations
     D CLZZ1         E DS                  EXTNAME(CLOANCL)
 
 
      ** External DS for BANK details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
 
     C     *ENTRY        PLIST
     C/COPY MXCPYSRC,MXACSPRMI
 
 
      * Use input link-to field
 
     C                   MOVEL     I#LFD1        A_LNRF            6
 
      * Error if no loan number is supplied
 
     C     A_LNRF        IFEQ      *BLANK
     C*****A_LNRF        OREQ      '000000'                                                   CLE148
     C                   EVAL      I#ERMS = 'INVALID LOAN NUMBER: '
     C                             + A_LNRF
     C                   EXSR      *PSSR
     C                   ENDIF
 
      * Get the loan from CLOANCL
 
     C                   MOVEL     A_LNRF        LNRF
     C     LNRF          CHAIN     CLOANCLF                           99        *
 
      * If the loan isn't found
      * and this is a current extract
      * it is an error
 
     C     *IN99         IFEQ      '1'
     C     I#EXTT        ANDEQ     'C'
     C                   EVAL      I#ERMS = 'LOAN NOT ON CLOANCL:'
     C                             + A_LNRF
     C                   EXSR      *PSSR
     C                   ENDIF
 
      * If the loan isn't on CLOANCL
      * Get the loan from MXSLECLPD
 
     C     *IN99         IFEQ      '1'
     C                   CLEAR                   CLZZ1
     C                   MOVEL     A_LNRF        LNRF
     C     LNRF          CHAIN     MXSLECLP0                          99        *
     C                   ENDIF
 
      * If the loan isn't available
      * and this is a driver format
      *  Indicate that loan is not to be extracted
 
     C     *IN99         IFEQ      '1'
     C     CFLFMT        ANDEQ     '*DRIVER   '
     C                   MOVEL     '*NOEXT '     I#RTCD
     C                   ELSE
 
      * If this is a driver format
 
     C     CFLFMT        IFEQ      '*DRIVER   '
 
      * If the loan has not the required processing type
      * (The %editc BIF is used to convert PTYP to character)
      *  Indicate that loan is not to be extracted
 
     C                   IF        %scan(%editc(PTYP : 'X') :
     C                                   LoanProcTypes) = 0
     C                   MOVEL     '*NOEXT '     I#RTCD
     C                   ELSE
 
      * Determine if branch is to be included in the export
 
     C                   MOVE      'D'           I#LD
     C                   MOVEL     BRCA          I#BRCA
     C                   EXSR      BRCA_FLT
 
      * Determine if loan type/sub type is to be included in the export
 
     C                   MOVE      'D'           I#LD
     C                   MOVEL     LTYP          I#LTYP
     C                   MOVEL     SUTP          I#SUTP
     C                   MOVEL     PTYP          Proc_Type
     C                   EXSR      LTST_FLT
 
      * If the branch or loan type/sub type are NOT for export
      *  Indicate that loan is not to be extracted
 
     C     Exp_BRCA      IFNE      'Y'
     C     Exp_LTST      ORNE      'Y'
     C                   MOVEL     '*NOEXT '     I#RTCD
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
      * Set up output data
 
     C                   EVAL      InData = CLZZ1
 
 
      * Return
 
     C                   RETURN
      *
      /SPACE 5
      *********************************************************************
      * B R A N C H   F I L T E R
      /COPY MXCPYSRC,MXFLTBRCA
      ********************************************************************
      /SPACE 5
      *********************************************************************
      * L O A N  T Y P E  / S U B   T Y P E   F I L T E R
      /COPY MXCPYSRC,MXFLTLTST
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
 
      * Load loan type/sub types for export
 
     C                   MOVE      'L'           I#LD
     C                   EXSR      LTST_FLT
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY MXCPYSRC,MXPSSR
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2001
