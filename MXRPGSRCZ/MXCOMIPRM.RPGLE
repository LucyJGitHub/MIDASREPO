     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MX Composite ID Prompt')
      *****************************************************************
      *                                                               *
      *  Midas - Meridian Export Module                               *
      *                                                               *
      *  MXCOMIPRM - Composite ID Prompt                              *
      *                                                               *
      *  Function:  This module prompts for a composite ID            *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Last Amend No. 256564             Date 17Sep08               *
      *  Prev Amend No. BUG17937           Date 24Apr08               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CAAA03             Date 12Mar04               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CMX003  *CREATE    Date 05Nov00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  BUG17937 - SEC3300 is Failing with an error.  Applied fix    *
      *             245268 (Recompile)                                *
      *  CAAA03 - Webfacing Changes                                   *
      *  CMX003 - Meridian Export Enhancements - Phase 2              *
      *                                                               *
      *****************************************************************
 
     FMXCOMIPDD CF   E             WORKSTN        INFSR(*PSSR)
     FMXCOMDPD  IF   E           K DISK           INFSR(*PSSR)
 
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
     C                   PARM                    I#COMI            8
     C                   PARM                    @INKC             1
 
      **  Main processing
      **  Loop until CK/3 taken or no validation errors
 
     C     *INKC         DOUEQ     '1'
     C     *IN50         OREQ      '0'
     C                   EXSR      MAIN
     C                   END
 
      * Return variables
 
     C                   MOVE      DDCOMI        I#COMI
     C                   MOVE      *INKC         @INKC
 
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
     C                   WRITE     MXCOMIS0
     C**********         WRITE     MXCOMIP1                                                   CAAA03
     C                   WRITE     MXCOMIF1
     C                   WRITE     MXCOMIP1                                                   CAAA03
     C                   READ      MXCOMIP1                               99
 
      ** Validate screen input as long as F3 is not taken
 
     C     *INKC         IFEQ      '0'
     C                   EXSR      VALSIN
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
 
      * Composite ID
 
     C     DDCOMI        IFNE      *BLANK
 
     C     DDCOMI        CHAIN     MXCOMDP0                           99
     C     *in99         IFEQ      '1'
     C                   MOVEL     'MX00750'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN10
     C                   MOVE      '1'           *IN50
     C                   ENDIF
     C                   ENDIF
                                                                                CDE002
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
      /SPACE 5                                                                  CDE002
      *****************************************************************
      * *INZSR - INITIAL PROCESSING
      *****************************************************************
     C     *INZSR        BEGSR
      *
      ** Initialize program name
      *
     C                   MOVEL     'MXCOMIPRM'   DDPGM
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
(c) Misys International Banking Systems Ltd. 2001
