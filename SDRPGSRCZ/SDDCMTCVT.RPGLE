     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2013')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Document Management - File to Scrn Format')   *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDDCMTCVT - SD Document Management: File to Screen Format    *
      *                                                               *
      *  Function:  This module converts the fields of a Document Mgt *
      *             Code from their format as on file to a screen     *
      *             format                                            *
      *                                                               *
      *  (c) Finastra International Limited 2013                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CSD093  *CREATE    Date 01Apr13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD093 - Document Management                                 *
      *                                                               *
      *****************************************************************
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
 
      * Document Management in File Format
     D DocRFilFmt    E DS                  EXTNAME(SDDCMTPD)
 
      * Documen Management in Screen Format
     D DocRScnFmt    E DS                  EXTNAME(SDDCMSPD)
 
      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** EXTERNAL DS FOR BANK DETAILS
 
      ** External DS for Document Code Details
     D SDDOCM        E DS                  EXTNAME(SDDOCMPD)
 
      ** First DS for Access Programs, Long Data Structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** First DS for Access Programs, Short Data STructure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
     D DateIn          S              8S 0
 
     D WCOMM           DS
     D  WCOM1                  1     64
     D  WCOM2                 65    128
     D  WCOM3                129    192
     D  WCOM4                193    256
      ** Time Format
     D WWCTIM          DS
     D  WWHH                   1      2
     D  WWC1                   3      3    INZ(':')
     D  WWMM                   4      5
     D  WWC2                   6      6    INZ(':')
     D  WWSS                   7      8
 
     ** Parameter for Access Object
     D PRTCD           S              7
     D POPTN           S              7
     D PDCCD           S              2
     D WWACTN          S              1
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** Initialization
      *
     C                   EXSR      INIT
      *
      ** Set Output screen fields
      *
     C                   EXSR      SETFLD
      *
      ** Return
      *
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** SETFLD - SET OUTPUT SCREEN FIELDS
      *****************************************************************
     C     SETFLD        BEGSR
      *
      ** Customer Name
      *
     C                   MOVEL     DMREFN        DDREFN
     C                   EVAL      DDRTYP = DMRTYP
      *
      ** Document Code Details
      *
     C                   MOVE      DMCODE        DDCODE
     C                   EXSR      SRDOCM
     C                   MOVE      DMSEQN        DDSEQN
     C                   MOVE      DMDREF        DDDREF
     C                   MOVE      DMSTCD        DDSTCD
 
     C                   SELECT
     C                   WHEN      DMSTCD = 'A'
     C                   EVAL      *IN61  = *ON
     C                   WHEN      DMSTCD = 'C'
     C                   EVAL      *IN62  = *ON
     C                   WHEN      DMSTCD = 'O'
     C                   EVAL      *IN63  = *ON
     C                   WHEN      DMSTCD = 'R'
     C                   EVAL      *IN64  = *ON
     C                   WHEN      DMSTCD = 'Z'
     C                   EVAL      *IN65  = *ON
     C                   ENDSL
 
     C                   EVAL      DDISCT = DMISCT
 
     C                   EVAL      DDISDT = *BLANKS
     C                   IF        DMISDT <> *ZERO
     C                   Z-ADD     DMISDT        ZDAYNO
     C                   EXSR      SRDATE2
     C                   MOVEL     ZDATE         DDISDT
     C                   ENDIF
 
     C                   EVAL      DDRQDT = *BLANKS
     C                   IF        DMRQDT <> *ZERO
     C                   Z-ADD     DMRQDT        ZDAYNO
     C                   EXSR      SRDATE2
     C                   MOVEL     ZDATE         DDRQDT
     C                   ENDIF
 
     C                   EVAL      DDRCDT = *BLANKS
     C                   IF        DMRCDT <> *ZERO
     C                   Z-ADD     DMRCDT        ZDAYNO
     C                   EXSR      SRDATE2
     C                   MOVEL     ZDATE         DDRCDT
     C                   ENDIF
 
     C                   EVAL      DDREJC = *BLANKS
     C                   IF        DMREJC <> *ZERO
     C                   Z-ADD     DMREJC        ZDAYNO
     C                   EXSR      SRDATE2
     C                   MOVEL     ZDATE         DDREJC
     C                   ENDIF
 
     C                   EVAL      DDREQB = *BLANKS
     C                   IF        DMREQB <> *ZERO
     C                   Z-ADD     DMREQB        ZDAYNO
     C                   EXSR      SRDATE2
     C                   MOVEL     ZDATE         DDREQB
     C                   ENDIF
 
     C                   EVAL      DDEXDT = *BLANKS
     C                   IF        DMEXDT <> *ZERO
     C                   Z-ADD     DMEXDT        ZDAYNO
     C                   EXSR      SRDATE2
     C                   MOVEL     ZDATE         DDEXDT
     C                   ENDIF
 
     C                   EVAL      DDCUSR = DMCUSR
     C                   EVAL      DDCDAT = *BLANKS
     C                   IF        DMCDAT <> *ZERO
     C                   Z-ADD     DMCDAT        ZDAYNO
     C                   EXSR      SRDATE2
     C                   MOVEL     ZDATE         DDCDAT
     C                   ENDIF
     C                   IF        DMCTIM = *BLANKS
     C                   EVAL      DDCTIM = *BLANKS
     C                   ELSE
     C                   EVAL      WWHH = %SUBST(DMCTIM:1:2)
     C                   EVAL      WWMM = %SUBST(DMCTIM:3:2)
     C                   EVAL      WWSS = %SUBST(DMCTIM:5:2)
     C                   MOVEL     WWCTIM        DDCTIM
     C                   ENDIF
 
     C                   MOVEL     DMCOMM        WCOMM
     C                   EVAL      DDCOM1 = WCOM1
     C                   EVAL      DDCOM2 = WCOM2
     C                   EVAL      DDCOM3 = WCOM3
     C                   EVAL      DDCOM4 = WCOM4
 
     C                   MOVEL     DMIMGE        DDIMGE
 
     C                   EXSR      SRSYST
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSYST - Chack Dates and output System Status                *
      *                                                               *
      *  Called by: Main                                              *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SRSYST        BEGSR
 
     C                   EVAL      DDSYST = *BLANKS
     C                   IF        DMREQB <> *ZERO
     C                             AND DMSTCD <> 'A'
     C                             AND DMSTCD <> 'C'                                        MD024677
     C                   IF        BJRDNB > DMREQB
     C                   EVAL      DDSYST = 'OVERDUE'
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        DMEXDT <> *ZERO
     C                             AND DMSTCD <> 'C'                                        MD024677
     C                   IF        BJRDNB > DMEXDT
     C                   EVAL      DDSYST = 'EXPIRED'
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDOCM - Access Document Code File for Details               *
      *                                                               *
      *  Called by: Main                                              *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SRDOCM        BEGSR
 
      ** Access Document Codes Details
 
     C                   CALL      'AODOCMR2'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      DDCODE        PDCCD
     C     SDDOCM        PARM      SDDOCM        DSSDY
 
     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      DBASE =  902
     C                   EVAL      DBKEY = POPTN
     C                   EXSR      *PSSR
     C                   ELSE
     C                   EVAL      DDNARR = ATDCNA
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDATE2 - Convert Midas Day to DDMMYY                        *
      *                                                               *
      *  Called by: Main                                              *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SRDATE2       BEGSR
 
     C                   CALLB     'ZDATE2'
     C                   PARM                    ZDAYNO            5 0
     C                   PARM                    BJDFIN
     C                   PARM                    ZDATE             6 0
     C                   PARM                    ZADATE            7
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  INIT - Initialization                                        *
      *                                                               *
      *  Called by: Main                                              *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     INIT          BEGSR
 
      ** Blank Outputs (Except for Action Code with Doc Mgt Format)
 
     C                   EVAL      WWACTN     = DDACTN
     C                   EVAL      DocRScnFmt = *BLANK
     C                   EVAL      DDACTN     = WWACTN
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Initial Processing                                  *
      *                                                               *
      *  Called by: Main                                              *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
      **  Program parameters
 
     C     *ENTRY        PLIST
 
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeIn
      *
      ** Document Management in File Format
     C                   PARM                    DocRFilFmt
      *
      ** Output parameters
      *
      ** Document Management in screen format
     C                   PARM                    DocRScnFmt
 
      ** Initialize program name
 
     C                   EVAL      DBPGM = 'SDDCMTCVT'
 
      ** Access Back Details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST  '    POPTN
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** DATABASE ERROR
 
     C                   IF        PRTCD <> *BLANK
     C                   EVAL      DBKEY  = POPTN
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE  = 901
     C                   EXSR      *PSSR
     C                   END
 
     C                   ENDSR
      *****************************************************************
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
(c) Finastra International Limited 2013
