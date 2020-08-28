     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM Validate Base Rate                (Deams)')
      *****************************************************************
      *                                                               *
      *  Midas - Money Market Dealing Module                          *
      *                                                               *
      *  MMVBASERAT - Validate Base Rate                              *
      *                                                               *
      *  Function:  This module receives a parameter containing the   *
      *             Base Rate and confirms whether it has a valid     *
      *             value.                                            *
      *             If it is valid the 10A return code will be blank, *
      *             if it is not it will contain  'Error'             *
      *                                                               *
      *  Component of: MMVALIDTE - MM validation service program      *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CDL022             Date 03Feb04               *
      *                 CDL017  *CREATE    Date 03Feb04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *  MD046248 - Finastra Rebranding                               *
      *  CDL022 - Deal Amendment Changes                              *
      *  CDL017 - Penalty Fee & Early Maturity of Fixed Term Loan/Dep *
      *                                                               *
      *****************************************************************
 
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
 
      ** Include the MM standard declares
     D/COPY ZACPYSRC,STDDECLARE
 
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
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** External DS for Bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** External DS for Base Rate details
     D SDBSRT        E DS                  EXTNAME(SDBSRTPD)
 
      ** External DS (Short)
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** External DS (Long)
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Error message field received as a parameter
     D Msgid1          S                   LIKE(#MsgID)
 
      ** Warning message field received as a parameter
     D WMsgid1         S                   LIKE(#MsgID)
 
      ** Base Rate received as a parameter
     D DDBSRT          S              2A
 
      ** Type received as a parameter
     D DDMTYP          S              2A
 
      ** Numeric base rate
     D PRATE           S                   LIKE(BACBSR)
 
      ** Value date of Base Rate change received as a parameter
     D PVDYNO          S                   LIKE(BAVDNR)
 
      ** Value Date of Deal received as a parameter
     D DDVDAT          S              6A
 
      ** Base Rate received as a parameter
     D IGBSRT          S              2A
 
      ** Currency received as a parameter
     D DDCCY           S              3A
 
      ** Amount/Penalty Fee received as a parameter
     D DDAMNP          S             15A
 
      ** Parameters used in call to ZDATE1
     D DateIn          S              6A
     D DaynoOut        S              5P 0
     D ErrorFlag       S              1A
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
 
     C
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      ** Reset error flags & msgs to prevent problems on subsequent calls
     C                   RESET                   ErrorFound
     C                   RESET                   Msgid1
     C                   RESET                   WMsgid1
 
      ** Base Rate cannot be entered for any Type other than 'EM'
      ** and BC.                                                                              CDL022
     C     DDMTYP        IFNE      'EM'
     C     DDMTYP        ANDNE     'BC'                                                       CDL022
     C     DDBSRT        ANDNE     *BLANKS
     C                   EVAL      ErrorFound = 'Y'
     C                   MOVEL     'MMM0348'     Msgid1
     C                   GOTO      ERROR
     C                   ENDIF
                                                                                              CDL022
      ** For Type BC, Base Rate Code must be entered                                          CDL022
     C     DDMTYP        IFEQ      'BC'                                                       CDL022
     C     DDBSRT        ANDEQ     *BLANKS                                                    CDL022
     C                   EVAL      ErrorFound = 'Y'                                           CDL022
     C                   MOVEL     'MMM0354'     Msgid1                                       CDL022
     C                   GOTO      ERROR                                                      CDL022
     C                   ENDIF                                                                CDL022
 
      ** For Type EM, Base Rate must be blank if Penalty Fee entered
     C     DDMTYP        IFEQ      'EM'
     C     DDAMNP        ANDNE     *BLANKS
     C     DDBSRT        ANDNE     *BLANKS
     C                   EVAL      ErrorFound = 'Y'
     C                   MOVEL     'MMM0341'     Msgid1
     C                   GOTO      ERROR
     C                   ENDIF
 
      **  Access the base rates file to ascertain whether the base rate
      **  code is valid.
     C     DDBSRT        IFNE      *BLANKS
 
     C                   CALLB     'AOBSRTR0'
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM      '*KEY   '     POPTN             7
     C                   PARM      DDCCY         PAJCD             3
     C                   PARM      DDBSRT        PDWND             2
     C     SDBSRT        PARM      SDBSRT        DSSDY
 
      **  If no valid record is found, it is an error.
     C     PRTCD         IFNE      *BLANK
     C                   EVAL      ErrorFound = 'Y'
     C                   MOVEL     'MMM0417'     MsgID1
 
      **  If a valid record has been found, find the base rate to use.
     C                   ELSE
     C                   MOVEL     BABSRC        DDBSRT
 
      **  If the deal value date is less than value date of new rate
      **  change, use the previous base rate.
     C     PVDYNO        IFLT      BAVDNR
     C                   Z-ADD     BACBSR        PRATE
 
      ** Display a warning message if the user is in Insert mode
     C                   EVAL      WarnFound = 'Y'
     C                   MOVEL     'MMM1045'     WMsgID1
 
      **  If the deal value date is greater than value date of new rate
      **  change, use the next base rate.
     C                   ELSE
     C                   Z-ADD     BANBRT        PRATE
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
      ** If an error was found, set the return code appropriately
     C     ERROR         TAG
     C                   IF        ErrorFound = 'Y'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ELSE
     C                   MOVE      DDBSRT        IGBSRT
     C                   ENDIF
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *entry        PLIST
     C                   PARM                    RetCodeIn
     C                   PARM                    Msgid1
     C                   PARM                    WMsgid1
     C                   PARM                    DDVDAT
     C                   PARM                    DDAMNP
     C                   PARM                    DDCCY
     C                   PARM                    DDBSRT
     C                   PARM                    DDMTYP
     C                   PARM                    IGBSRT
 
      **  Access Bank Details via Access Object
      **  (database error handling done in access program)
 
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR'      PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Key List for Loan Type/Subtype and Deal Type/Subtype
 
     C     KLBsRate      KLIST
     C                   KFLD                    DDCCY
     C                   KFLD                    DDBSRT
 
      ** Find Value Date of Deal in Midas Day Number format:
 
     C                   CALLB     'ZDATE1'
     C                   PARM      DDVDAT        DateIn
     C                   PARM      *Zero         DaynoOut
     C                   PARM                    BJDFIN
     C                   PARM                    ErrorFlag
 
     C                   MOVE      DaynoOut      PVDYNO
 
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR                                                  *** InzEnd ***
 
      *****************************************************************
      /EJECT
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2004
