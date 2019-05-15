     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Convert dtls of BYLOANX0 to Screen Format')   *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LECLIPCVT1 -  LE Facility Conversion: File to Screen Format  *
      *                                                               *
      *  Function:  This module converts the details of the extension *
      *             file BYLOANX0 to screen format                    *
      *                                                               *
      *  (c) Finastra International Limited 2005                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Midas Plus 1.4 Base ------------------------------------------*
      *  Prev Amend No. LLN022  *CREATE    Date 24Jan05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  LLN022 - BOE Upgrade to MidasPlus                            *
      *                                                               *
      *****************************************************************
      *                                                               *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
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
      ** the copyright array definition:
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      * Transaction Details in File Format
     D ClipExFilFmt  E DS                  EXTNAME(BYLOANX0)
 
      * Facility in Screen Format
     D ClipExScnFmt  E DS                  EXTNAME(LECLEXPD)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      ** parameter fields
 
     D PRetCodeIn      S             10
     D PLonNum         S              3P 0
     D ZDateNum        S              5P 0
     D ZDateFmtInd     S              1
     D ZDateFmt6       S              6P 0
     D ZDateFmt7       S              7
      *
      ** variable fields
      *
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      * Initialization
      *
     C                   EXSR      SRINIT
      *
      * Set output screen fields for first screen
      *
     C                   EXSR      SRSETFLD
      * Return
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRSETFLD - Set Screen Fields                                  *
      *****************************************************************
     C     SRSETFLD      BEGSR
      *
      * Move retrieve value to Screen Format
      *
     C                   EVAL      LLNTPX = LLNTP
     C                   EVAL      LFMATX = LFMAT
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRINIT - INITIALIZATION                                       *
      *****************************************************************
     C     SRINIT        BEGSR
      *
      * Initialialize Data Structure of Screen Format
      *
     C                   CLEAR                   ClipExScnFmt
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - INITIAL PROCESSING                                   *
      *****************************************************************
     C     *INZSR        BEGSR
      *
      * Program Parameters
      *
     C     *ENTRY        PLIST
      *
      * Inputs Parameter
      *
      * Return Code
     C                   PARM                    PRetCodeIn
      * Loan Number
     C                   PARM                    PLonNum
      *
      * Extension File Format
     C                   PARM                    ClipExFilFmt
      *
      * Output Parameter
      *
      * Screen File Format
     C                   PARM                    ClipExScnFmt
      * BJDFIN Value pass to ZDateFmtInd as Parameter
     C                   PARM                    ZDateFmtInd
      *
      * Initialize program name
      *
     C                   MOVEL     'LECLIPCVT1'  DBPGM
      *
     C                   ENDSR
      ********************************************************************
      /EJECT
      ********************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2005
