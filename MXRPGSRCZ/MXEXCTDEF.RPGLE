     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MX Export Control Information Definition')
      *****************************************************************
      *                                                               *
      *  Midas - Meridian Export Module                               *
      *                                                               *
      *  MXEXCTDEF - Export Control Information Definition            *
      *                                                               *
      *  Function:  This module allows definition of export           *
      *             control information.                              *
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
 
     FMXEXCTDDD CF   E             WORKSTN        INFSR(*PSSR)
     FMXOLEJPD  IF A E             DISK    COMMIT INFSR(*PSSR)
     FMXOLTJPD  IF A E             DISK    COMMIT INFSR(*PSSR)
 
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
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** EXTERNAL DS FOR BANK DETAILS
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
 
     D MXEXPCTL      E DS                  EXTNAME(MXEXPCTL)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
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
 
     C     *ENTRY        PLIST
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           30
 
      **  Main processing
      **  Loop until CK/3 taken
 
     C     *INKC         DOWEQ     '0'
     C                   EXSR      MAIN
     C                   END
 
      * Terminate program
 
     C                   MOVE      '1'           *INLR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      * MAIN - MAIN PROCESSING
      *****************************************************************
     C     MAIN          BEGSR
 
      ** Selection screen
 
     C                   TIME                    DDTIME
     C                   WRITE     MXEXCTS0
     C                   WRITE     MXEXCTD1
     C                   WRITE     MXEXCTF1
     C                   READ      MXEXCTD1                               99
 
      ** Validate screen input as long as F3 is not taken
 
     C     *INKC         IFEQ      '0'
     C                   EXSR      VALSIN
      *
      * If no errors, update export control details on data-area
      *
     C     *IN50         IFEQ      '0'
     C     *LOCK         IN        MXEXPCTL
     C                   MOVEL     DDTSOM        TRGSOM
     C                   MOVEL     DDTRDX        TRACDX
     C                   MOVEL     DDTRDT        TRACDT
     C                   MOVEL     DDTRBX        TRACBX
     C                   MOVEL     DDTRBT        TRACBT
     C                   MOVEL     DDDIAG        DIAGEV
     C                   MOVEL     DDMRAC        MNTRAC
     C                   MOVEL     DDSFDL        SDFQDL
     C                   MOVEL     DDSFGL        SDFQGL
     C                   MOVEL     DDSFLE        SDFQLE
     C                   MOVEL     DDSFRE        SDFQRE
     C                   MOVEL     DDSFSE        SDFQSE
     C                   OUT       MXEXPCTL
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VALSIN   - VALIDATE SCREEN INPUT
      *****************************************************************
     C     VALSIN        BEGSR
      *
      ** Clear the message queue & init error indicators
      *
     C                   CALL      'Y2CLMSC'
     C                   PARM      DDPGM         ZAPGMQ           10
     C                   PARM      '*SAME'       ZAPGRL            5
     C                   MOVE      '0'           *IN50
     C                   MOVEA     '0000000000'  *IN(10)
     C                   MOVEA     '0000000000'  *IN(20)
 
      * Trigger Start of Month Processing
 
     C     DDTSOM        IFNE      'Y'
     C     DDTSOM        ANDNE     'N'
     C                   MOVEL     'MX00048'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN10
     C                   END
 
      * Trace flags
 
     C     DDTRDX        IFNE      'Y'
     C     DDTRDX        ANDNE     'N'
     C                   MOVEL     'MX00043'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN11
     C                   END
     C     DDTRDT        IFNE      'Y'
     C     DDTRDT        ANDNE     'N'
     C                   MOVEL     'MX00044'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN12
     C                   END
     C     DDTRBX        IFNE      'Y'
     C     DDTRBX        ANDNE     'N'
     C                   MOVEL     'MX00045'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN13
     C                   END
     C     DDTRBT        IFNE      'Y'
     C     DDTRBT        ANDNE     'N'
     C                   MOVEL     'MX00046'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN14
     C                   END
 
      * Diagnose events flag
 
     C     DDDIAG        IFNE      'Y'
     C     DDDIAG        ANDNE     'N'
     C                   MOVEL     'MX00047'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN15
     C                   END
 
      * Diagnose events flag
 
     C     DDDIAG        IFNE      'Y'
     C     DDDIAG        ANDNE     'N'
     C                   MOVEL     'MX00047'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN15
     C                   END
 
      * Maintain Retail Accruals
 
     C     DDMRAC        IFNE      'Y'
     C     DDMRAC        ANDNE     'N'
     C                   MOVEL     'MX00049'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN16
     C                   END
 
      * Save Data Frequency: By Module
 
     C     DDSFDL        IFNE      'D'
     C     DDSFDL        ANDNE     'M'
     C     DDSFDL        ANDNE     'N'
     C                   MOVEL     'MX00050'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN17
     C                   END
     C     DDSFGL        IFNE      'D'
     C     DDSFGL        ANDNE     'M'
     C     DDSFGL        ANDNE     'N'
     C                   MOVEL     'MX00050'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN18
     C                   END
     C     DDSFLE        IFNE      'D'
     C     DDSFLE        ANDNE     'M'
     C     DDSFLE        ANDNE     'N'
     C                   MOVEL     'MX00050'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN19
     C                   END
     C     DDSFRE        IFNE      'D'
     C     DDSFRE        ANDNE     'M'
     C     DDSFRE        ANDNE     'N'
     C                   MOVEL     'MX00050'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN20
     C                   END
     C     DDSFSE        IFNE      'D'
     C     DDSFSE        ANDNE     'M'
     C     DDSFSE        ANDNE     'N'
     C                   MOVEL     'MX00050'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN21
     C                   END
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * ZASNMS - SEND A MESSAGE
      *****************************************************************
     C     ZASNMS        BEGSR
 
     C                   CALL      'Y2SNMGC'                            9999    *
     C                   PARM      DDPGM         ZAPGMQ           10
     C                   PARM                    ZAPGRL            5
     C                   PARM                    ZAMSID            7
     C                   PARM      'MIDAS'       ZAMSGF           10
     C                   PARM                    ZAMSDA          132
     C                   PARM                    ZAMSTP            7
 
      * Error encountered
 
     C                   MOVE      '1'           *IN50
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Convert a day number to a date
      *****************************************************************
     C     ZDATE2        BEGSR
     C                   CALLB     'ZDATE2'
     C                   PARM                    ZDAYNO            5 0
     C                   PARM                    BJDFIN
     C                   PARM      *ZERO         ZDATEN            6 0
     C                   PARM                    ZADATE            7
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * *INZSR - INITIAL PROCESSING
      *****************************************************************
     C     *INZSR        BEGSR
      *
      ** Initialize program name
      *
     C                   MOVEL     'MXEXCTDEF'   DDPGM
      *
      ** Set up subfile message queue information
      *
     C                   MOVEL     '*'           DDPGMQ
     C                   MOVE      '1'           *IN40
      *
      ** Set up standard screen fields.
      *
     C                   MOVEL     PsJobName     DDJOB
     C                   MOVEL     PsUser        DDUSR
      *
      ** ACCESS BANK DETAILS
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE                         ************
     C                   MOVEL     '900'         DBASE                          * DBERR 901*
     C                   MOVEL     @OPTN         DBKEY                          ************
     C                   EXSR      *PSSR
     C                   END
 
      * Update Export Control Information
 
     C                   CALL      'MXEXCTUPD'
     C                   PARM      *BLANK        W#RTCD            7
     C                   PARM      *BLANK        W#ERMS           30
     C                   PARM      *BLANK        W#COB             1
     C                   PARM      'N'           S_O_Month         1
 
      * Error
     C     W#RTCD        IFEQ      '*ERROR'
     C                   EVAL      I#ERMS = 'ERROR IN CALL TO MXEXCTUPD'
     C                   EXSR      *PSSR
     C                   ENDIF
 
      * Get extract control data
 
     C     *DTAARA       DEFINE                  MXEXPCTL
     C     *LOCK         IN        MXEXPCTL
     C                   OUT       MXEXPCTL
 
      * Set screen fields
 
     C                   Z-ADD     CUREOM        ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVEL     ZADATE        DDCEOM
 
     C                   Z-ADD     CURSOM        ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVEL     ZADATE        DDCSOM
 
     C                   Z-ADD     PRVSOM        ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVEL     ZADATE        DDPSOM
 
     C                   Z-ADD     CURRUN        ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVEL     ZADATE        DDCRUN
 
     C                   Z-ADD     CURNWD        ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVEL     ZADATE        DDCNWD
 
     C                   Z-ADD     PRVRUN        ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVEL     ZADATE        DDPRUN
 
     C                   MOVEL     TRGSOM        DDTSOM
     C                   MOVEL     TRACDX        DDTRDX
     C                   MOVEL     TRACDT        DDTRDT
     C                   MOVEL     TRACBX        DDTRBX
     C                   MOVEL     TRACBT        DDTRBT
     C                   MOVEL     DIAGEV        DDDIAG
     C                   MOVEL     MNTRAC        DDMRAC
     C                   MOVEL     SDFQDL        DDSFDL
     C                   MOVEL     SDFQGL        DDSFGL
     C                   MOVEL     SDFQLE        DDSFLE
     C                   MOVEL     SDFQRE        DDSFRE
     C                   MOVEL     SDFQSE        DDSFSE
 
      * Write a record to the on-line extract journal seq. no. file
      * if one does not currently exist.
 
     C     1             CHAIN     MXOLEJPD                           99
     C     *IN99         IFEQ      '1'
     C                   EVAL      I#LASTSEQ = '0000000001'
     C                   WRITE     MXOLEJP0
     C                   ENDIF
 
      * Write a record to the on-line transmission journal seq. no. file
      * if one does not currently exist.
 
     C     1             CHAIN     MXOLTJPD                           99
     C     *IN99         IFEQ      '1'
     C                   EVAL      I#LASTSEQ = '0000000001'
     C                   WRITE     MXOLTJP0
     C                   ENDIF
 
      * Commit the update
 
     C                   COMMIT
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
